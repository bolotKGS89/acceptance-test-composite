#!/bin/bash

#set -x

export REGIONS="us-east-1
us-east-2
us-west-1
us-west-2
ap-south-1
ap-northeast-2
ap-southeast-1
ap-southeast-2
ap-northeast-1
eu-central-1
eu-west-1
sa-east-1"

./ac_test_clean.sh

#for r in $REGIONS
for r in us-east-1
do
  echo "processing region: $r"
  export AWS_DEFAULT_REGION=$r
  ./vpc_clean.sh acceptance-test-vpc
done


