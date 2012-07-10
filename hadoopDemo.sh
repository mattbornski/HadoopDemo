#!/bin/bash

# Parameters for the cluster we want to use
CLUSTER_NAME="HadoopDemo"

# Data should already exist in this bucket.  Bucket must be readable by you, but need not be writable.
DATA_BUCKET="HadoopDemo"
DATA_FILE="userAgents.log"

# Log bucket is optional.  If set, bucket must be writable by you.
LOG_BUCKET=""

# Results bucket is mandatory.  Bucket must be writable by you.
RESULTS_BUCKET="HadoopDemo"

# Check that we've got the right credentials configured for the AWS / S3 / EC2 / EMR scripts.
./ensureCredentials.sh

if [ -n "$LOG_BUCKET" ] ; then {
  ./ensureBucket.sh $LOG_BUCKET
}; fi

./ensureBucket.sh $RESULTS_BUCKET

./ensureCluster.sh $CLUSTER_NAME