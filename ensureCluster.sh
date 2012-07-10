#!/bin/bash

./ensureCredentials.sh

CLUSTER_NAME=$1
OUT=`./thirdparty/elastic-mapreduce-ruby/elastic-mapreduce -c ~/.aws.json --list`
JOB_FLOW_ID=`echo $OUT | awk -v cluster_name="$CLUSTER_NAME" '{ for( i = 0; i <= NF; i++ ) if ( $i == cluster_name && ( $(i - 2) == "WAITING" || $(i - 2) == "STARTING" ) ) print $(i - 3) }'`

if [ -z "$JOB_FLOW_ID" ] ; then {
  echo "No running $CLUSTER_NAME cluster found"
  OUT=`./thirdparty/elastic-mapreduce-ruby/elastic-mapreduce -c ~/.aws.json --create --name $CLUSTER_NAME --pig-interactive --alive`
  JOB_FLOW_ID=`echo $OUT | grep "Created job flow" | awk '{print $NF}'`
}; fi

echo "Cluster running as Job Flow ID = $JOB_FLOW_ID"
