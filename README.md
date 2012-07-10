# HadoopDemo

Test drive Hadoop on AWS Elastic Map Reduce

## Prerequisites

You should have an AWS account.

## Installation

## Example Usage

I'll test drive running a map reduce job on user agent strings.  To extract the user agent strings from a web server log, I used this command:

```bash
awk -v FS='"' '{ if( $(NF - 1) !~ "-" ) print $(NF - 1) }' webServer.log > userAgents.log
```

Then, I uploaded the file to an AWS S3 bucket, since S3 buckets are the preferred way to provide input to and retrieve output from AWS Elastic Map Reduce nodes.

```bash

```

```bash
./hadoopDemo.sh

```
