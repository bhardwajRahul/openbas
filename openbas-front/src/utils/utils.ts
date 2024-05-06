import * as R from 'ramda';
import { MESSAGING$ } from './Environment';

export const export_max_size = 50000;

export const isNotEmptyField = <T>(field: T | null | undefined): field is T => !R.isEmpty(field) && !R.isNil(field);
export const isEmptyField = <T>(
  field: T | null | undefined,
): field is null | undefined => !isNotEmptyField(field);

export const copyToClipboard = (t: (text: string) => string, text: string) => {
  if ('clipboard' in navigator) {
    navigator.clipboard.writeText(text);
  } else {
    document.execCommand('copy', true, text);
  }
  MESSAGING$.notifySuccess(t('Copied to clipboard'));
};

export const download = (content: string, filename: string, contentType: string | undefined) => {
  let finalContentType = contentType;
  if (!contentType) {
    finalContentType = 'application/octet-stream';
  }
  const a = document.createElement('a');
  const blob = new Blob([content], { type: finalContentType });
  a.href = URL.createObjectURL(blob);
  a.download = filename;
  a.click();
};

export const removeEmptyFields = (
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  obj: Record<string, any | undefined>,
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
): Record<string, any> => {
  const clone = { ...obj };
  Object.keys(clone).forEach((key) => {
    if (typeof clone[key] !== 'string' && isEmptyField(clone[key])) {
      delete clone[key];
    }
  });
  return clone;
};

export const deleteElementByValue = (obj: Record<string, string>, val: string) => {
  for (const key in obj) {
    if (obj[key] === val) {
      // eslint-disable-next-line no-param-reassign
      delete obj[key];
    }
  }
  return obj;
};

export const readFileContent = (file: File): Promise<unknown> => {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();

    reader.onload = (event) => {
      try {
        const jsonContent = JSON.parse(event.target?.result as string);
        resolve(jsonContent);
      } catch (error) {
        reject(error);
      }
    };

    reader.onerror = (error) => reject(error);
    reader.readAsText(file);
  });
};

export const randomElements = (elements: never[], number: number) => {
  const shuffled = elements.sort(() => 0.5 - Math.random());
  return shuffled.slice(0, number);
};
