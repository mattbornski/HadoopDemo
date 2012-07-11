#!/bin/bash

# Parameters for the cluster we want to use
CLUSTER_NAME="hadoop-demo"

# Data should already exist in this bucket.  Bucket must be readable by you, but need not be writable.
DATA_BUCKET="hadoop-demo.bornski"
DATA_FILE="userAgents.log"

# Log bucket is optional.  If set, bucket must be writable by you.
LOG_BUCKET=""

# Results bucket is mandatory.  Bucket must be writable by you.
RESULTS_BUCKET="hadoop-demo.bornski"
RESULTS_FILE="countedUserAgents.csv"

# Check that we've got the right credentials configured for the AWS / S3 / EC2 / EMR scripts.
./ensureCredentials.sh

if [ -n "$LOG_BUCKET" ] ; then {
  ./ensureBucket.sh $LOG_BUCKET
}; fi

./ensureBucket.sh $RESULTS_BUCKET

./ensureCluster.sh $CLUSTER_NAME

./pigJob.sh $CLUSTER_NAME s3n://$DATA_BUCKET/countUserAgents.pig s3n://$DATA_BUCKET/$DATA_FILE s3n://$RESULTS_BUCKET/$RESULTS_FILE

#./deleteCluster.sh $CLUSTER_NAME