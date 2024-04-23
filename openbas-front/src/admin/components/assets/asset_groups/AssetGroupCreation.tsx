import React, { FunctionComponent, useState } from 'react';
import { ListItemButton, ListItemIcon, ListItemText, Theme } from '@mui/material';
import { ControlPointOutlined } from '@mui/icons-material';
import { makeStyles } from '@mui/styles';

import { useFormatter } from '../../../../components/i18n';
import { useAppDispatch } from '../../../../utils/hooks';
import type { AssetGroupInput } from '../../../../utils/api-types';
import Drawer from '../../../../components/common/Drawer';
import { addAssetGroup } from '../../../../actions/asset_groups/assetgroup-action';
import AssetGroupForm from './AssetGroupForm';
import ButtonCreate from '../../../../components/common/ButtonCreate';
import Dialog from '../../../../components/common/Dialog';

const useStyles = makeStyles((theme: Theme) => ({
  text: {
    fontSize: theme.typography.h2.fontSize,
    color: theme.palette.primary.main,
    fontWeight: theme.typography.h2.fontWeight,
  },
}));

interface Props {
  inline?: boolean;
  onCreate?: (result: string) => void;
}

const AssetGroupCreation: FunctionComponent<Props> = ({
  inline,
  onCreate,
}) => {
  // Standard hooks
  const classes = useStyles();
  const [open, setOpen] = useState(false);
  const { t } = useFormatter();

  const dispatch = useAppDispatch();
  const onSubmit = (data: AssetGroupInput) => {
    dispatch(addAssetGroup(data)).then(
      (result: { result: string }) => {
        if (result.result) {
          if (onCreate) {
            onCreate(result.result);
          }
          setOpen(false);
        }
        return result;
      },
    );
  };

  return (
    <div>
      {inline ? (
        <ListItemButton
          divider
          onClick={() => setOpen(true)}
          color="primary"
        >
          <ListItemIcon color="primary">
            <ControlPointOutlined color="primary" />
          </ListItemIcon>
          <ListItemText
            primary={t('Create a new asset group')}
            classes={{ primary: classes.text }}
          />
        </ListItemButton>
      ) : (
        <ButtonCreate onClick={() => setOpen(true)} />
      )}

      {inline ? (
        <Dialog
          open={open}
          handleClose={() => setOpen(false)}
          title={t('Create a new asset group')}
        >
          <AssetGroupForm
            onSubmit={onSubmit}
            handleClose={() => setOpen(false)}
          />
        </Dialog>
      ) : (
        <Drawer
          open={open}
          handleClose={() => setOpen(false)}
          title={t('Create a new asset group')}
        >
          <AssetGroupForm
            onSubmit={onSubmit}
            handleClose={() => setOpen(false)}
          />
        </Drawer>
      )}
    </div>
  );
};

export default AssetGroupCreation;
