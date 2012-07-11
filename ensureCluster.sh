#!/bin/bash

./ensureCredentials.sh

CLUSTER_NAME=$1
OUT=`./thirdparty/elastic-mapreduce-ruby/elastic-mapreduce -c ~/.aws.json --list`
JOB_FLOW_ID=`echo $OUT | awk -v cluster_name="$CLUSTER_NAME" '{ for( i = 0; i <= NF; i++ ) if ( $i == cluster_name && ( $(i - 2) == "WAITING" || $(i - 2) == "STARTING" ) ) print $(i - 3) }'`

if [ -z "$JOB_FLOW_ID" ] ; then {
  echo "ensureCluster No running $CLUSTER_NAME cluster found"
  OUT=`./thirdparty/elastic-mapreduce-ruby/elastic-mapreduce -c ~/.aws.json --create --name $CLUSTER_NAME --pig-interactive --alive`
  JOB_FLOW_ID=`echo $OUT | grep "Created job flow" | awk '{print $NF}'`
  echo "ensureCluster Starting $CLUSTER_NAME as job flow $JOB_FLOW_ID"
}; fi

# Wait until state is WAITING
# Valid states along the way: STARTING, ...

while : ; do {
  OUT=`./thirdparty/elastic-mapreduce-ruby/elastic-mapreduce -c ~/.aws.json  --describe $JOB_FLOW_ID`
  ERROR=`echo $OUT | python -c "import json, sys; out = json.loads(sys.stdin.read()); print out['JobFlows'][0]['ExecutionStatusDetail']['LastStateChangeReason'] if out['JobFlows'][0]['ExecutionStatusDetail']['State'] == 'FAILED' else ''; sys.exit(out['JobFlows'][0]['ExecutionStatusDetail']['State'] != 'WAITING')"`
  if [ "$?" == "0" ] ; then {
    # Success, the cluster is up and waiting.
    break
  } else {
    if [ -n "$ERROR" ] ; then {
      # Failure
      echo "ensureCluster Error in cluster startup"
      echo "ensureCluster $ERROR"
      exit 1
    } else {
      # Still waiting I think.
      sleep 5
    }; fi
  }; fi
}; done

echo "ensureCluster Cluster running as job flow $JOB_FLOW_ID"