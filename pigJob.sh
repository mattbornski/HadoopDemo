#!/bin/bash

./ensureCredentials.sh

CLUSTER_NAME=$1
SCRIPT_URL=$2
INPUT_URL=$3
OUTPUT_URL=$4
OUT=`./thirdparty/elastic-mapreduce-ruby/elastic-mapreduce -c ~/.aws.json --list`
JOB_FLOW_ID=`echo $OUT | awk -v cluster_name="$CLUSTER_NAME" '{ for( i = 0; i <= NF; i++ ) if ( $i == cluster_name && $(i - 2) == "WAITING" ) print $(i - 3) }'`

if [ -z "$JOB_FLOW_ID" ] ; then {
  echo "pigJob No running $CLUSTER_NAME cluster found"
  exit 1
}; fi

./thirdparty/elastic-mapreduce-ruby/elastic-mapreduce -c ~/.aws.json --jobflow $JOB_FLOW_ID --ssh "pig -p INPUT=$INPUT_URL -p OUTPUT=$OUTPUT_URL $SCRIPT_URL"

echo "pigJob Completed Pig job on $JOB_FLOW_ID, results in $OUTPUT_URL"