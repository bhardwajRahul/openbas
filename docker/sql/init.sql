\c openex
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE TABLE injects_statuses (status_id VARCHAR(255) NOT NULL, status_inject VARCHAR(255) DEFAULT NULL, status_name VARCHAR(255) DEFAULT NULL, status_message TEXT DEFAULT NULL, status_date TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT NULL, status_execution INT DEFAULT NULL, PRIMARY KEY(status_id));
CREATE UNIQUE INDEX UNIQ_658A47A864E0DBD ON injects_statuses (status_inject);
CREATE TABLE dryinjects_statuses (status_id VARCHAR(255) NOT NULL, status_dryinject VARCHAR(255) DEFAULT NULL, status_name VARCHAR(255) DEFAULT NULL, status_message TEXT DEFAULT NULL, status_date TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT NULL, status_execution INT DEFAULT NULL, PRIMARY KEY(status_id));
CREATE UNIQUE INDEX UNIQ_1863E729F2504301 ON dryinjects_statuses (status_dryinject);
CREATE TABLE objectives (objective_id VARCHAR(255) NOT NULL, objective_exercise VARCHAR(255) DEFAULT NULL, objective_title VARCHAR(255) NOT NULL, objective_description TEXT NOT NULL, objective_priority SMALLINT NOT NULL, PRIMARY KEY(objective_id));
CREATE INDEX IDX_6CB0696C157D9150 ON objectives (objective_exercise);
CREATE TABLE subaudiences (subaudience_id VARCHAR(255) NOT NULL, subaudience_audience VARCHAR(255) DEFAULT NULL, subaudience_name VARCHAR(255) NOT NULL, subaudience_enabled BOOLEAN NOT NULL, PRIMARY KEY(subaudience_id));
CREATE INDEX IDX_9CF031F069138C0B ON subaudiences (subaudience_audience);
CREATE TABLE users_subaudiences (subaudience_id VARCHAR(255) NOT NULL, user_id VARCHAR(255) NOT NULL, PRIMARY KEY(subaudience_id, user_id));
CREATE INDEX IDX_CFB417FCCB0CA5A3 ON users_subaudiences (subaudience_id);
CREATE INDEX IDX_CFB417FCA76ED395 ON users_subaudiences (user_id);
CREATE TABLE logs (log_id VARCHAR(255) NOT NULL, log_exercise VARCHAR(255) DEFAULT NULL, log_user VARCHAR(255) DEFAULT NULL, log_title VARCHAR(255) NOT NULL, log_content TEXT NOT NULL, log_date TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, PRIMARY KEY(log_id));
CREATE INDEX IDX_F08FC65CC0891EC3 ON logs (log_exercise);
CREATE INDEX IDX_F08FC65C9CFD383C ON logs (log_user);
CREATE TABLE outcomes (outcome_id VARCHAR(255) NOT NULL, outcome_incident VARCHAR(255) DEFAULT NULL, outcome_comment TEXT DEFAULT NULL, outcome_result INT NOT NULL, PRIMARY KEY(outcome_id));
CREATE UNIQUE INDEX UNIQ_6E54D0FA2DB358A7 ON outcomes (outcome_incident);
CREATE TABLE grants (grant_id VARCHAR(255) NOT NULL, grant_group VARCHAR(255) DEFAULT NULL, grant_exercise VARCHAR(255) DEFAULT NULL, grant_name VARCHAR(255) NOT NULL, PRIMARY KEY(grant_id));
CREATE INDEX IDX_64ADC7D620B0BD5E ON grants (grant_group);
CREATE INDEX IDX_64ADC7D6CAE7A988 ON grants (grant_exercise);
CREATE UNIQUE INDEX "grant" ON grants (grant_group, grant_exercise, grant_name);
CREATE TABLE tokens (token_id VARCHAR(255) NOT NULL, token_user VARCHAR(255) DEFAULT NULL, token_value VARCHAR(255) NOT NULL, token_created_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, PRIMARY KEY(token_id));
CREATE INDEX IDX_AA5A118EEF97E32B ON tokens (token_user);
CREATE UNIQUE INDEX tokens_value_unique ON tokens (token_value);
CREATE TABLE comchecks (comcheck_id VARCHAR(255) NOT NULL, comcheck_exercise VARCHAR(255) DEFAULT NULL, comcheck_audience VARCHAR(255) DEFAULT NULL, comcheck_start_date TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, comcheck_end_date TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, PRIMARY KEY(comcheck_id));
CREATE INDEX IDX_4E039727729413D0 ON comchecks (comcheck_exercise);
CREATE INDEX IDX_4E039727218352D4 ON comchecks (comcheck_audience);
CREATE TABLE organizations (organization_id VARCHAR(255) NOT NULL, organization_name VARCHAR(255) NOT NULL, organization_description TEXT DEFAULT NULL, PRIMARY KEY(organization_id));
CREATE TABLE parameters (parameter_id VARCHAR(255) NOT NULL, parameter_key VARCHAR(255) NOT NULL, parameter_value VARCHAR(255) NOT NULL, PRIMARY KEY(parameter_id));
CREATE TABLE files (file_id VARCHAR(255) NOT NULL, file_name VARCHAR(255) NOT NULL, file_path VARCHAR(255) NOT NULL, file_type VARCHAR(255) NOT NULL, PRIMARY KEY(file_id));
CREATE TABLE exercises (exercise_id VARCHAR(255) NOT NULL, exercise_owner VARCHAR(255) DEFAULT NULL, exercise_image VARCHAR(255) DEFAULT NULL, exercise_animation_group VARCHAR(255) DEFAULT NULL, exercise_name VARCHAR(255) NOT NULL, exercise_subtitle TEXT NOT NULL, exercise_description TEXT NOT NULL, exercise_start_date TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, exercise_end_date TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, exercise_message_header VARCHAR(255) DEFAULT NULL, exercise_message_footer VARCHAR(255) DEFAULT NULL, exercise_canceled BOOLEAN NOT NULL, PRIMARY KEY(exercise_id));
CREATE INDEX IDX_FA14991EA5611BE ON exercises (exercise_owner);
CREATE INDEX IDX_FA14991E00BF39D ON exercises (exercise_image);
CREATE INDEX IDX_FA149911E7111AB ON exercises (exercise_animation_group);
CREATE TABLE dryruns (dryrun_id VARCHAR(255) NOT NULL, dryrun_exercise VARCHAR(255) DEFAULT NULL, dryrun_date TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, dryrun_speed INT NOT NULL, dryrun_status BOOLEAN NOT NULL, PRIMARY KEY(dryrun_id));
CREATE INDEX IDX_F1C33DFFC7C87328 ON dryruns (dryrun_exercise);
CREATE TABLE events (event_id VARCHAR(255) NOT NULL, event_exercise VARCHAR(255) DEFAULT NULL, event_image VARCHAR(255) DEFAULT NULL, event_title VARCHAR(255) NOT NULL, event_description VARCHAR(255) NOT NULL, event_order SMALLINT NOT NULL, PRIMARY KEY(event_id));
CREATE INDEX IDX_5387574AE8363CCC ON events (event_exercise);
CREATE INDEX IDX_5387574A8426B573 ON events (event_image);
CREATE TABLE dryinjects (dryinject_id VARCHAR(255) NOT NULL, dryinject_dryrun VARCHAR(255) DEFAULT NULL, dryinject_title VARCHAR(255) NOT NULL, dryinject_content TEXT DEFAULT NULL, dryinject_date TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, dryinject_type VARCHAR(255) NOT NULL, PRIMARY KEY(dryinject_id));
CREATE INDEX IDX_6DA84B5817861437 ON dryinjects (dryinject_dryrun);
CREATE TABLE audiences (audience_id VARCHAR(255) NOT NULL, audience_exercise VARCHAR(255) DEFAULT NULL, audience_name VARCHAR(255) NOT NULL, audience_enabled BOOLEAN NOT NULL, PRIMARY KEY(audience_id));
CREATE INDEX IDX_89F9AC9380E3E92 ON audiences (audience_exercise);
CREATE TABLE subobjectives (subobjective_id VARCHAR(255) NOT NULL, subobjective_objective VARCHAR(255) DEFAULT NULL, subobjective_title VARCHAR(255) NOT NULL, subobjective_description TEXT NOT NULL, subobjective_priority SMALLINT NOT NULL, PRIMARY KEY(subobjective_id));
CREATE INDEX IDX_33218ECF261C0E05 ON subobjectives (subobjective_objective);
CREATE TABLE injects (inject_id VARCHAR(255) NOT NULL, inject_incident VARCHAR(255) DEFAULT NULL, inject_user VARCHAR(255) DEFAULT NULL, inject_title VARCHAR(255) NOT NULL, inject_description TEXT NOT NULL, inject_content TEXT DEFAULT NULL, inject_date TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, inject_type VARCHAR(255) NOT NULL, inject_all_audiences BOOLEAN NOT NULL, inject_enabled BOOLEAN NOT NULL, PRIMARY KEY(inject_id));
CREATE INDEX IDX_A60839B2E3DA09AD ON injects (inject_incident);
CREATE INDEX IDX_A60839B2E20FC097 ON injects (inject_user);
CREATE TABLE injects_audiences (inject_id VARCHAR(255) NOT NULL, audience_id VARCHAR(255) NOT NULL, PRIMARY KEY(inject_id, audience_id));
CREATE INDEX IDX_BA0CEBB87983AEE ON injects_audiences (inject_id);
CREATE INDEX IDX_BA0CEBB8848CC616 ON injects_audiences (audience_id);
CREATE TABLE injects_subaudiences (inject_id VARCHAR(255) NOT NULL, subaudience_id VARCHAR(255) NOT NULL, PRIMARY KEY(inject_id, subaudience_id));
CREATE INDEX IDX_96E1B96C7983AEE ON injects_subaudiences (inject_id);
CREATE INDEX IDX_96E1B96CCB0CA5A3 ON injects_subaudiences (subaudience_id);
CREATE TABLE groups (group_id VARCHAR(255) NOT NULL, group_name VARCHAR(255) NOT NULL, PRIMARY KEY(group_id));
CREATE TABLE users_groups (group_id VARCHAR(255) NOT NULL, user_id VARCHAR(255) NOT NULL, PRIMARY KEY(group_id, user_id));
CREATE INDEX IDX_FF8AB7E0FE54D947 ON users_groups (group_id);
CREATE INDEX IDX_FF8AB7E0A76ED395 ON users_groups (user_id);
CREATE TABLE incidents (incident_id VARCHAR(255) NOT NULL, incident_type VARCHAR(255) DEFAULT NULL, incident_event VARCHAR(255) DEFAULT NULL, incident_title VARCHAR(255) NOT NULL, incident_story TEXT NOT NULL, incident_weight INT NOT NULL, incident_order SMALLINT NOT NULL, PRIMARY KEY(incident_id));
CREATE INDEX IDX_E65135D066D22096 ON incidents (incident_type);
CREATE INDEX IDX_E65135D0609AA8CD ON incidents (incident_event);
CREATE TABLE incidents_subobjectives (incident_id VARCHAR(255) NOT NULL, subobjective_id VARCHAR(255) NOT NULL, PRIMARY KEY(incident_id, subobjective_id));
CREATE INDEX IDX_4A01CB2559E53FB9 ON incidents_subobjectives (incident_id);
CREATE INDEX IDX_4A01CB25C80C8E53 ON incidents_subobjectives (subobjective_id);
CREATE TABLE file_tags (tag_id VARCHAR(255) NOT NULL, tag_file VARCHAR(255) DEFAULT NULL, tag_name VARCHAR(255) NOT NULL, PRIMARY KEY(tag_id));
CREATE INDEX IDX_E640FC48629089A6 ON file_tags (tag_file);
CREATE UNIQUE INDEX file_tag ON file_tags (tag_name, tag_file);
CREATE TABLE comchecks_statuses (status_id VARCHAR(255) NOT NULL, status_user VARCHAR(255) DEFAULT NULL, status_comcheck VARCHAR(255) DEFAULT NULL, status_last_update TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, status_state BOOLEAN NOT NULL, PRIMARY KEY(status_id));
CREATE INDEX IDX_A25F7872B5957BDD ON comchecks_statuses (status_user);
CREATE INDEX IDX_A25F787295A4A46F ON comchecks_statuses (status_comcheck);
CREATE TABLE users (user_id VARCHAR(255) NOT NULL, user_organization VARCHAR(255) DEFAULT NULL, user_login VARCHAR(255) NOT NULL, user_firstname VARCHAR(255) NOT NULL, user_lastname VARCHAR(255) NOT NULL, user_email VARCHAR(255) NOT NULL, user_email2 VARCHAR(255) DEFAULT NULL, user_phone VARCHAR(255) DEFAULT NULL, user_phone2 VARCHAR(255) DEFAULT NULL, user_phone3 VARCHAR(255) DEFAULT NULL, user_pgp_key TEXT DEFAULT NULL, user_password VARCHAR(255) DEFAULT NULL, user_admin BOOLEAN NOT NULL, user_status SMALLINT NOT NULL, user_lang VARCHAR(255) DEFAULT NULL, PRIMARY KEY(user_id));
CREATE UNIQUE INDEX UNIQ_1483A5E948CA3048 ON users (user_login);
CREATE INDEX IDX_1483A5E941221F7E ON users (user_organization);
CREATE UNIQUE INDEX users_email_unique ON users (user_email);
CREATE TABLE incident_types (type_id VARCHAR(255) NOT NULL, type_name VARCHAR(255) NOT NULL, PRIMARY KEY(type_id));
ALTER TABLE injects_statuses ADD CONSTRAINT FK_658A47A864E0DBD FOREIGN KEY (status_inject) REFERENCES injects (inject_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE dryinjects_statuses ADD CONSTRAINT FK_1863E729F2504301 FOREIGN KEY (status_dryinject) REFERENCES dryinjects (dryinject_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE objectives ADD CONSTRAINT FK_6CB0696C157D9150 FOREIGN KEY (objective_exercise) REFERENCES exercises (exercise_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE subaudiences ADD CONSTRAINT FK_9CF031F069138C0B FOREIGN KEY (subaudience_audience) REFERENCES audiences (audience_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE users_subaudiences ADD CONSTRAINT FK_CFB417FCCB0CA5A3 FOREIGN KEY (subaudience_id) REFERENCES subaudiences (subaudience_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE users_subaudiences ADD CONSTRAINT FK_CFB417FCA76ED395 FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE logs ADD CONSTRAINT FK_F08FC65CC0891EC3 FOREIGN KEY (log_exercise) REFERENCES exercises (exercise_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE logs ADD CONSTRAINT FK_F08FC65C9CFD383C FOREIGN KEY (log_user) REFERENCES users (user_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE outcomes ADD CONSTRAINT FK_6E54D0FA2DB358A7 FOREIGN KEY (outcome_incident) REFERENCES incidents (incident_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE grants ADD CONSTRAINT FK_64ADC7D620B0BD5E FOREIGN KEY (grant_group) REFERENCES groups (group_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE grants ADD CONSTRAINT FK_64ADC7D6CAE7A988 FOREIGN KEY (grant_exercise) REFERENCES exercises (exercise_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE tokens ADD CONSTRAINT FK_AA5A118EEF97E32B FOREIGN KEY (token_user) REFERENCES users (user_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE comchecks ADD CONSTRAINT FK_4E039727729413D0 FOREIGN KEY (comcheck_exercise) REFERENCES exercises (exercise_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE comchecks ADD CONSTRAINT FK_4E039727218352D4 FOREIGN KEY (comcheck_audience) REFERENCES audiences (audience_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE exercises ADD CONSTRAINT FK_FA14991EA5611BE FOREIGN KEY (exercise_owner) REFERENCES users (user_id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE exercises ADD CONSTRAINT FK_FA14991E00BF39D FOREIGN KEY (exercise_image) REFERENCES files (file_id) ON DELETE SET NULL NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE exercises ADD CONSTRAINT FK_FA149911E7111AB FOREIGN KEY (exercise_animation_group) REFERENCES groups (group_id) ON DELETE SET NULL NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE dryruns ADD CONSTRAINT FK_F1C33DFFC7C87328 FOREIGN KEY (dryrun_exercise) REFERENCES exercises (exercise_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE events ADD CONSTRAINT FK_5387574AE8363CCC FOREIGN KEY (event_exercise) REFERENCES exercises (exercise_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE events ADD CONSTRAINT FK_5387574A8426B573 FOREIGN KEY (event_image) REFERENCES files (file_id) ON DELETE SET NULL NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE dryinjects ADD CONSTRAINT FK_6DA84B5817861437 FOREIGN KEY (dryinject_dryrun) REFERENCES dryruns (dryrun_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE audiences ADD CONSTRAINT FK_89F9AC9380E3E92 FOREIGN KEY (audience_exercise) REFERENCES exercises (exercise_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE subobjectives ADD CONSTRAINT FK_33218ECF261C0E05 FOREIGN KEY (subobjective_objective) REFERENCES objectives (objective_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE injects ADD CONSTRAINT FK_A60839B2E3DA09AD FOREIGN KEY (inject_incident) REFERENCES incidents (incident_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE injects ADD CONSTRAINT FK_A60839B2E20FC097 FOREIGN KEY (inject_user) REFERENCES users (user_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE injects_audiences ADD CONSTRAINT FK_BA0CEBB87983AEE FOREIGN KEY (inject_id) REFERENCES injects (inject_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE injects_audiences ADD CONSTRAINT FK_BA0CEBB8848CC616 FOREIGN KEY (audience_id) REFERENCES audiences (audience_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE injects_subaudiences ADD CONSTRAINT FK_96E1B96C7983AEE FOREIGN KEY (inject_id) REFERENCES injects (inject_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE injects_subaudiences ADD CONSTRAINT FK_96E1B96CCB0CA5A3 FOREIGN KEY (subaudience_id) REFERENCES subaudiences (subaudience_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE users_groups ADD CONSTRAINT FK_FF8AB7E0FE54D947 FOREIGN KEY (group_id) REFERENCES groups (group_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE users_groups ADD CONSTRAINT FK_FF8AB7E0A76ED395 FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE incidents ADD CONSTRAINT FK_E65135D066D22096 FOREIGN KEY (incident_type) REFERENCES incident_types (type_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE incidents ADD CONSTRAINT FK_E65135D0609AA8CD FOREIGN KEY (incident_event) REFERENCES events (event_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE incidents_subobjectives ADD CONSTRAINT FK_4A01CB2559E53FB9 FOREIGN KEY (incident_id) REFERENCES incidents (incident_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE incidents_subobjectives ADD CONSTRAINT FK_4A01CB25C80C8E53 FOREIGN KEY (subobjective_id) REFERENCES subobjectives (subobjective_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE file_tags ADD CONSTRAINT FK_E640FC48629089A6 FOREIGN KEY (tag_file) REFERENCES files (file_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE comchecks_statuses ADD CONSTRAINT FK_A25F7872B5957BDD FOREIGN KEY (status_user) REFERENCES users (user_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE comchecks_statuses ADD CONSTRAINT FK_A25F787295A4A46F FOREIGN KEY (status_comcheck) REFERENCES comchecks (comcheck_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE users ADD CONSTRAINT FK_1483A5E941221F7E FOREIGN KEY (user_organization) REFERENCES organizations (organization_id) ON DELETE RESTRICT NOT DEFERRABLE INITIALLY IMMEDIATE;
INSERT INTO users (user_id, user_login, user_firstname, user_lastname, user_email, user_password, user_admin, user_status, user_lang) VALUES ('3cc8da56-db62-4a52-8ac3-00224b755d9e', 'admin@openex.io', 'John', 'Doe', 'admin@openex.io', '$2y$12$ifjMJqEIzOE9M9AO7HMVtu2wyJX6/NVCL4r4rbl.bUPfUauNiZLo6', TRUE, 1, 'auto');
INSERT INTO tokens (token_id, token_user, token_value, token_created_at) VALUES ('a0c1e118-72ce-45ba-9574-79a3434d2136', '3cc8da56-db62-4a52-8ac3-00224b755d9e', 'TOKEN_TO_REPLACE', '2018-01-01 00:00:00');
