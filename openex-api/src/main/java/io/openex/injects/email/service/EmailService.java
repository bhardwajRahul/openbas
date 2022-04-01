package io.openex.injects.email.service;

import io.openex.database.model.Document;
import io.openex.database.repository.DocumentRepository;
import io.openex.execution.Execution;
import io.openex.execution.ExecutionContext;
import io.openex.execution.ExecutionTrace;
import io.openex.injects.email.model.EmailAttachment;
import io.openex.service.DocumentService;
import org.apache.commons.io.IOUtils;
import org.bouncycastle.openpgp.PGPPublicKey;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;

import javax.activation.DataHandler;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.internet.*;
import javax.mail.util.ByteArrayDataSource;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static io.openex.helper.TemplateHelper.buildContextualContent;

@Component
public class EmailService {

    private DocumentRepository documentRepository;
    private JavaMailSender emailSender;
    private EmailPgp emailPgp;
    private DocumentService fileService;

    @Autowired
    public void setDocumentRepository(DocumentRepository documentRepository) {
        this.documentRepository = documentRepository;
    }

    @Autowired
    public void setFileService(DocumentService fileService) {
        this.fileService = fileService;
    }

    @Autowired
    public void setEmailSender(JavaMailSender emailSender) {
        this.emailSender = emailSender;
    }

    @Autowired
    public void setEmailPgp(EmailPgp emailPgp) {
        this.emailPgp = emailPgp;
    }

    public List<EmailAttachment> resolveAttachments(Execution execution, List<Document> attachments) {
        List<EmailAttachment> resolved = new ArrayList<>();
        for (Document attachment : attachments) {
            String documentId = attachment.getId();
            Optional<Document> askedDocument = documentRepository.findById(documentId);
            try {
                Document doc = askedDocument.orElseThrow();
                InputStream fileInputStream = fileService.getFile(doc).orElseThrow();
                byte[] content = IOUtils.toByteArray(fileInputStream);
                resolved.add(new EmailAttachment(doc.getName(), content, doc.getType()));
            } catch (Exception e) {
                // Can't fetch the attachments, ignore
                String docInfo = askedDocument.map(Document::getName).orElse(documentId);
                String message = "Error getting document " + docInfo;
                execution.addTrace(ExecutionTrace.traceError(getClass().getSimpleName(), message, e));
            }
        }
        return resolved;
    }

    private MimeMessage buildMimeMessage(String from, String subject, String body, List<EmailAttachment> attachments) throws Exception {
        MimeMessage mimeMessage = emailSender.createMimeMessage();
        mimeMessage.setFrom(from);
        mimeMessage.setSubject(subject, "utf-8");
        Multipart mailMultipart = new MimeMultipart("mixed");
        // Add mail content
        MimeBodyPart bodyPart = new MimeBodyPart();
        bodyPart.setContent(body, "text/html;charset=utf-8");
        mailMultipart.addBodyPart(bodyPart);
        // Add Attachments
        for (EmailAttachment attachment : attachments) {
            MimeBodyPart aBodyPart = new MimeBodyPart();
            aBodyPart.setFileName(attachment.name());
            aBodyPart.setHeader("Content-Type", attachment.contentType());
            ByteArrayDataSource bds = new ByteArrayDataSource(attachment.data(), attachment.contentType());
            aBodyPart.setDataHandler(new DataHandler(bds));
            mailMultipart.addBodyPart(aBodyPart);
        }
        mimeMessage.setContent(mailMultipart);
        return mimeMessage;
    }

    public MimeMessage sendGlobalEmail(List<ExecutionContext> usersContext, String from, String subject, String message,
                                       List<EmailAttachment> attachments) throws Exception {
        MimeMessage mimeMessage = buildMimeMessage(from, subject, message, attachments);
        List<InternetAddress> recipients = new ArrayList<>();
        for (ExecutionContext userContext : usersContext) {
            recipients.add(new InternetAddress(userContext.getUser().getEmail()));
        }
        mimeMessage.setRecipients(Message.RecipientType.TO, recipients.toArray(InternetAddress[]::new));
        emailSender.send(mimeMessage);
        return mimeMessage;
    }

    public MimeMessage sendEmail(ExecutionContext userContext, String from, boolean mustBeEncrypted, String subject,
                                 String message, List<EmailAttachment> attachments) throws Exception {
        String email = userContext.getUser().getEmail();
        String contextualSubject = buildContextualContent(subject, userContext);
        String contextualBody = buildContextualContent(message, userContext);
        MimeMessage mimeMessage = buildMimeMessage(from, contextualSubject, contextualBody, attachments);
        mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(email));
        // Crypt if needed
        if (mustBeEncrypted) {
            PGPPublicKey userPgpKey = emailPgp.getUserPgpKey(userContext.getUser());
            // Need to create another email that will wrap everything.
            MimeMessage encMessage = emailSender.createMimeMessage();
            encMessage.setFrom(from);
            encMessage.setSubject(subject, "utf-8");
            encMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(email));
            Multipart encMultipart = new MimeMultipart("encrypted; protocol=\"application/pgp-encrypted\"");
            // This is an OpenPGP/MIME encrypted message (RFC 4880 and 3156)
            InternetHeaders headers = new InternetHeaders();
            headers.addHeader("Content-Type", "application/pgp-encrypted");
            MimeBodyPart mimeExPart = new MimeBodyPart(headers, "Version: 1".getBytes());
            mimeExPart.setDescription("PGP/MIME version identification");
            encMultipart.addBodyPart(mimeExPart);
            // Export and crypt to basic email
            ByteArrayOutputStream multiEncStream = new ByteArrayOutputStream();
            mimeMessage.writeTo(multiEncStream);
            String encryptedEmail = emailPgp.encrypt(userPgpKey, multiEncStream.toString());
            MimeBodyPart encBodyPart = new MimeBodyPart();
            encBodyPart.setDisposition("inline");
            encBodyPart.setFileName("openpgp-encrypted-message.asc");
            encBodyPart.setContent(encryptedEmail, "application/octet-stream");
            encMultipart.addBodyPart(encBodyPart);
            // Fill the message with the multipart content
            encMessage.setContent(encMultipart);
            emailSender.send(encMessage);
            return encMessage;
        } else {
            emailSender.send(mimeMessage);
            return mimeMessage;
        }
    }
}
