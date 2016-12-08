#!/bin/bash

set +x

ELB=`aws elb describe-load-balancers | grep LoadBalancerName | grep '\-ac\-cat\-elb' | sed 's/            "LoadBalancerName": "//' | sed 's/\"\,//'`

IAM_ROLES=`aws iam list-roles | grep RoleName | grep ac\-cat | sed 's/            "RoleName": "//' | sed 's/\"\,//'`

ASG=`aws autoscaling describe-auto-scaling-groups | grep AutoScalingGroupName | grep ac\-cat | sed 's/            "AutoScalingGroupName": "//' | sed 's/\"\,//'`

LC=`aws autoscaling describe-launch-configurations | grep LaunchConfigurationName  | grep ac\-cat | sed 's/            "LaunchConfigurationName": "//' | sed 's/\"\,//'`

SG=`perl sg.pl`

echo "ELB: $ELB"
echo "IAM_ROLES: $IAM_ROLES"
echo "ASG: $ASG"
echo "LC: $LC"
echo "SG: $SG"

set -x

if [ "$ELB" != "" ]
then
aws elb delete-load-balancer --load-balancer-name $ELB
fi

while [ "$ASG" != "" ]
do
  ASG=`aws autoscaling describe-auto-scaling-groups | grep AutoScalingGroupName | grep ac\-cat | sed 's/            "AutoScalingGroupName": "//' | sed 's/\"\,//'`
  if [ "$ASG" != "" ]
  then
    aws autoscaling delete-auto-scaling-group --force-delete --auto-scaling-group-name $ASG
    sleep 10
  fi
done

if [ "$LC" != "" ]
then 
aws autoscaling delete-launch-configuration --launch-configuration-name $LC
fi

if [ "$SG" != "" ]
then
for sg in $SG; do
  aws ec2 delete-security-group --group-id $sg
done
fi

#if [ "$IAM_ROLES" != "" ]
#then
#for role in $IAM_ROLES; do
#  aws iam delete-role --role-name $role
#done
#fi




