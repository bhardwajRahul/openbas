import { useParams } from 'react-router-dom';
import React, { useEffect, useState } from 'react';
import { Chip, Grid, List, Paper, Tooltip, Typography } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useAppDispatch } from '../../../../utils/hooks';
import { useHelper } from '../../../../store';
import useDataLoader from '../../../../utils/ServerSideEvent';
import type { AtomicTestingOutput, AttackPattern, InjectTargetWithResult, KillChainPhase } from '../../../../utils/api-types';
import type { AtomicTestingHelper } from '../../../../actions/atomic_testings/atomic-testing-helper';
import { fetchAtomicTesting } from '../../../../actions/atomic_testings/atomic-testing-actions';
import ResponsePie from './ResponsePie';
import Empty from '../../../../components/Empty';
import { useFormatter } from '../../../../components/i18n';
import TargetResultsDetail from './TargetResultsDetail';
import useSearchAnFilter from '../../../../utils/SortingFiltering';
import TargetListItem from './TargetListItem';
import ExpandableMarkdown from '../../../../components/ExpandableMarkdown';
import ItemStatus from '../../../../components/ItemStatus';
import SearchFilter from '../../../../components/SearchFilter';
import InjectIcon from '../../common/injects/InjectIcon';
import PlatformIcon from '../../../../components/PlatformIcon';

const useStyles = makeStyles(() => ({
  chip: {
    fontSize: 12,
    height: 25,
    margin: '0 7px 7px 0',
    textTransform: 'uppercase',
    borderRadius: 4,
    width: 180,
  },
  gridContainer: {
    marginBottom: 20,
  },
  paper: {
    height: '100%',
    minHeight: '100%',
    margin: '10px 0 0 0',
    padding: 15,
    borderRadius: 4,
  },
}));

const AtomicTesting = () => {
  // Standard hooks
  const classes = useStyles();
  const { t, tPick } = useFormatter();
  const dispatch = useAppDispatch();
  const { atomicId } = useParams() as { atomicId: AtomicTestingOutput['atomic_id'] };
  const [selectedTarget, setSelectedTarget] = useState<InjectTargetWithResult>();
  const filtering = useSearchAnFilter('', 'name', ['name']);

  // Fetching data
  const { atomic }: { atomic: AtomicTestingOutput } = useHelper((helper: AtomicTestingHelper) => ({
    atomic: helper.getAtomicTesting(atomicId),
  }));
  useDataLoader(() => {
    dispatch(fetchAtomicTesting(atomicId));
  });

  // Effects
  useEffect(() => {
    if (atomic && atomic.atomic_targets) {
      setSelectedTarget(atomic.atomic_targets[0]);
    }
  }, [atomic]);

  const sortedTargets: InjectTargetWithResult[] = filtering.filterAndSort(atomic.atomic_targets);

  // Handles
  const handleTargetClick = (target: InjectTargetWithResult) => {
    setSelectedTarget(target);
  };

  return (
    <>
      <Grid
        container={true}
        spacing={3}
        classes={{ container: classes.gridContainer }}
      >
        <Grid item={true} xs={6} style={{ paddingTop: 10 }}>
          <Typography variant="h4" gutterBottom={true}>
            {t('Information')}
          </Typography>
          <Paper classes={{ root: classes.paper }} variant="outlined">
            <Grid container={true} spacing={3}>
              <Grid item={true} xs={12} style={{ paddingTop: 10 }}>
                <Typography
                  variant="h3"
                  gutterBottom={true}
                  style={{ marginTop: 20 }}
                >
                  {t('Description')}
                </Typography>
                <ExpandableMarkdown
                  source={atomic.atomic_description}
                  limit={300}
                />
              </Grid>
              <Grid item={true} xs={4} style={{ paddingTop: 10 }}>
                <Typography
                  variant="h3"
                  gutterBottom={true}
                  style={{ marginTop: 20 }}
                >
                  {t('Type')}
                </Typography>
                <Tooltip title={tPick(atomic.atomic_injector_contract.injector_contract_labels)}>
                  <div style={{ display: 'flex' }}>
                    <InjectIcon
                      variant="inline"
                      tooltip={t(atomic.atomic_type)}
                      type={atomic.atomic_type}
                    />
                    <div style={{
                      marginLeft: 10,
                      whiteSpace: 'nowrap',
                      overflow: 'hidden',
                      textOverflow: 'ellipsis',
                    }}
                    >
                      {tPick(atomic.atomic_injector_contract.injector_contract_labels)}
                    </div>
                  </div>
                </Tooltip>
              </Grid>
              <Grid item={true} xs={4} style={{ paddingTop: 10 }}>
                <Typography
                  variant="h3"
                  gutterBottom={true}
                  style={{ marginTop: 20 }}
                >
                  {t('Platforms')}
                </Typography>
                <div style={{ display: 'flex' }}>
                  {atomic.atomic_injector_contract.injector_contract_platforms?.map((platform: string) => (
                    <div key="platform" style={{ display: 'flex', marginRight: 15 }}>
                      <PlatformIcon width={20} platform={platform} marginRight={5} />
                      {platform}
                    </div>
                  ))}
                </div>
              </Grid>
              <Grid item={true} xs={4} style={{ paddingTop: 10 }}>
                <Typography
                  variant="h3"
                  gutterBottom={true}
                  style={{ marginTop: 20 }}
                >
                  {t('Status')}
                </Typography>
                <ItemStatus status={atomic.atomic_status} label={t(atomic.atomic_status ?? 'Unknown')} />
              </Grid>
              <Grid item={true} xs={4} style={{ paddingTop: 10 }}>
                <Typography
                  variant="h3"
                  gutterBottom={true}
                  style={{ marginTop: 20 }}
                >
                  {t('Kill Chain Phases')}
                </Typography>
                {(atomic.atomic_kill_chain_phases ?? []).length === 0 && '-'}
                {atomic.atomic_kill_chain_phases?.map((killChainPhase: KillChainPhase) => (
                  <Chip
                    key={killChainPhase.phase_id}
                    variant="outlined"
                    classes={{ root: classes.chip }}
                    color="error"
                    label={killChainPhase.phase_name}
                  />
                ))}
              </Grid>
              <Grid item={true} xs={4} style={{ paddingTop: 10 }}>
                <Typography
                  variant="h3"
                  gutterBottom={true}
                  style={{ marginTop: 20 }}
                >
                  {t('Attack Patterns')}
                </Typography>
                {(atomic.atomic_attack_patterns ?? []).length === 0 && '-'}
                {atomic.atomic_attack_patterns?.map((attackPattern: AttackPattern) => (
                  <Tooltip key={attackPattern.attack_pattern_id} title={`[${attackPattern.attack_pattern_external_id}] ${attackPattern.attack_pattern_name}`}>
                    <Chip
                      variant="outlined"
                      classes={{ root: classes.chip }}
                      color="primary"
                      label={`[${attackPattern.attack_pattern_external_id}] ${attackPattern.attack_pattern_name}`}
                    />
                  </Tooltip>
                ))}
              </Grid>
            </Grid>
          </Paper>
        </Grid>
        <Grid item={true} xs={6} style={{ paddingTop: 10 }}>
          <Typography variant="h4" gutterBottom={true}>
            {t('Results')}
          </Typography>
          <Paper classes={{ root: classes.paper }} variant="outlined" style={{ display: 'flex', alignItems: 'center' }}>
            <ResponsePie expectationResultsByTypes={atomic.atomic_expectation_results} />
          </Paper>
        </Grid>
        <Grid item={true} xs={6} style={{ marginTop: 25 }}>
          <Typography variant="h4" gutterBottom={true} style={{ float: 'left' }}>
            {t('Targets')}
          </Typography>
          <div style={{ float: 'right', marginTop: -15 }}>
            <SearchFilter
              small={true}
              onChange={filtering.handleSearch}
              keyword={filtering.keyword}
              placeholder={t('Search by target name')}
            />
          </div>
          <div className="clearfix" />
          <Paper classes={{ root: classes.paper }} variant="outlined">
            {sortedTargets.length > 0 ? (
              <List>
                {sortedTargets.map((target) => (
                  <div key={target?.id} style={{ marginBottom: 15 }}>
                    <TargetListItem onClick={handleTargetClick} target={target} selected={selectedTarget?.id === target.id} />
                    <List component="div" disablePadding>
                      {target?.children?.map((child) => (
                        <TargetListItem key={child?.id} isChild onClick={handleTargetClick} target={child} selected={selectedTarget?.id === target.id} />
                      ))}
                    </List>
                  </div>
                ))}
              </List>
            ) : (
              <Empty message={t('No target configured for this atomic test.')} />
            )}
          </Paper>
        </Grid>
        <Grid item={true} xs={6} style={{ marginTop: 25 }}>
          <Typography variant="h4" gutterBottom={true}>
            {t('Results by target')}
          </Typography>
          <Paper classes={{ root: classes.paper }} variant="outlined" style={{ marginTop: 18 }}>
            {selectedTarget && (
              <TargetResultsDetail
                target={selectedTarget}
                injectId={atomicId}
                injectType={atomic.atomic_type}
                lastExecutionStartDate={atomic.atomic_last_execution_start_date || ''}
                lastExecutionEndDate={atomic.atomic_last_execution_end_date || ''}
              />
            )}
            {!selectedTarget && (
            <Empty message={t('No target data available.')} />
            )}
          </Paper>
        </Grid>
      </Grid>
    </>
  );
};

export default AtomicTesting;
