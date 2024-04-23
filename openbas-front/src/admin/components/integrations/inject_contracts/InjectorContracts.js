import React, { useState } from 'react';
import { List, ListItem, ListItemIcon, ListItemSecondaryAction, ListItemText } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { LockPattern } from 'mdi-material-ui';
import CreateAttackPattern from './CreateInjectorContract';
import InjectorContractPopover from './InjectorContractPopover';
import PaginationComponent from '../../../../components/common/pagination/PaginationComponent';
import SortHeadersComponent from '../../../../components/common/pagination/SortHeadersComponent';
import { initSorting } from '../../../../components/common/pagination/Page';
import { useFormatter } from '../../../../components/i18n';
import Breadcrumbs from '../../../../components/Breadcrumbs';
import { searchInjectorContracts } from '../../../../actions/InjectorContracts';

const useStyles = makeStyles(() => ({
  container: {
    margin: 0,
    padding: '0 200px 50px 0',
  },
  list: {
    marginTop: 10,
  },
  itemHead: {
    paddingLeft: 10,
    textTransform: 'uppercase',
    cursor: 'pointer',
  },
  item: {
    paddingLeft: 10,
    height: 50,
  },
  bodyItem: {
    height: '100%',
    fontSize: 13,
  },
}));

const headerStyles = {
  injector_contract_labels: {
    width: '35%',
  },
  attack_patterns: {
    width: '50%',
  },
  injector_contract_updated_at: {
    width: '12%',
  },
};

const inlineStyles = {
  injector_contract_labels: {
    float: 'left',
    width: '35%',
    height: 20,
    whiteSpace: 'nowrap',
    overflow: 'hidden',
    textOverflow: 'ellipsis',
  },
  attack_patterns: {
    float: 'left',
    width: '50%',
    height: 20,
    whiteSpace: 'nowrap',
    overflow: 'hidden',
    textOverflow: 'ellipsis',
  },
  injector_contract_updated_at: {
    float: 'left',
    width: '15%',
    height: 20,
    whiteSpace: 'nowrap',
    overflow: 'hidden',
    textOverflow: 'ellipsis',
  },
};

const InjectorContracts = () => {
  // Standard hooks
  const classes = useStyles();
  const { t, nsdt } = useFormatter();

  // Headers
  const headers = [
    { field: 'kill_chain_phase', label: 'Kill chain phase', isSortable: false },
    { field: 'attack_pattern_external_id', label: 'External ID', isSortable: true },
    { field: 'attack_pattern_name', label: 'Name', isSortable: true },
    { field: 'attack_pattern_created_at', label: 'Created', isSortable: true },
    { field: 'attack_pattern_updated_at', label: 'Updated', isSortable: true },
  ];

  const [attackPatterns, setAttackPatterns] = useState([]);
  const [searchPaginationInput, setSearchPaginationInput] = useState({
    sorts: initSorting('attack_pattern_external_id'),
  });

  // Export
  const exportProps = {
    exportType: 'attack_patterns',
    exportKeys: [
      'attack_pattern_external_id',
      'attack_pattern_name',
      'attack_pattern_created_at',
      'attack_pattern_updated_at',
    ],
    exportData: attackPatterns,
    exportFileName: `${t('AttackPatterns')}.csv`,
  };

  return (
    <div className={classes.container}>
      <Breadcrumbs variant="list" elements={[{ label: t('Settings') }, { label: t('Taxonomies') }, { label: t('Attack patterns'), current: true }]} />
      <PaginationComponent
        fetch={searchInjectorContracts}
        searchPaginationInput={searchPaginationInput}
        setContent={setAttackPatterns}
        exportProps={exportProps}
      />
      <div className="clearfix" />
      <List classes={{ root: classes.list }}>
        <ListItem
          classes={{ root: classes.itemHead }}
          divider={false}
          style={{ paddingTop: 0 }}
        >
          <ListItemIcon>
            <span
              style={{
                padding: '0 8px 0 8px',
                fontWeight: 700,
                fontSize: 12,
              }}
            >
              &nbsp;
            </span>
          </ListItemIcon>
          <ListItemText
            primary={
              <SortHeadersComponent
                headers={headers}
                inlineStylesHeaders={headerStyles}
                searchPaginationInput={searchPaginationInput}
                setSearchPaginationInput={setSearchPaginationInput}
              />
            }
          />
          <ListItemSecondaryAction> &nbsp; </ListItemSecondaryAction>
        </ListItem>
        {attackPatterns.map((attackPattern) => (
          <ListItem
            key={attackPattern.attack_pattern_id}
            classes={{ root: classes.item }}
            divider={true}
          >
            <ListItemIcon>
              <LockPattern color="primary" />
            </ListItemIcon>
            <ListItemText
              primary={
                <div>
                  <div
                    className={classes.bodyItem}
                    style={inlineStyles.kill_chain_phase}
                  >
                    &nbsp;
                  </div>
                  <div
                    className={classes.bodyItem}
                    style={inlineStyles.attack_pattern_external_id}
                  >
                    {attackPattern.attack_pattern_external_id}
                  </div>
                  <div
                    className={classes.bodyItem}
                    style={inlineStyles.attack_pattern_name}
                  >
                    {attackPattern.attack_pattern_name}
                  </div>
                  <div
                    className={classes.bodyItem}
                    style={inlineStyles.attack_pattern_created_at}
                  >
                    {nsdt(attackPattern.attack_pattern_created_at)}
                  </div>
                  <div
                    className={classes.bodyItem}
                    style={inlineStyles.attack_pattern_updated_at}
                  >
                    {nsdt(attackPattern.attack_pattern_updated_at)}
                  </div>
                </div>
              }
            />
            <ListItemSecondaryAction>
              <InjectorContractPopover
                attackPattern={attackPattern}
              />
            </ListItemSecondaryAction>
          </ListItem>
        ))}
      </List>
      <CreateAttackPattern />
    </div>
  );
};

export default InjectorContracts;
