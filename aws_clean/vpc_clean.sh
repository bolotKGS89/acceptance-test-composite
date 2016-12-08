#!/bin/bash

set -x

vpcname="$1"
vpcids=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$vpcname" | grep VpcId | awk -F'"' '{print $4}' | sort | uniq)

for vpcid in $vpcids; do
    echo "######################################################################"
    echo " vpc: $vpcid"
    echo "######################################################################"

   subnets=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpcid" | grep SubnetId | awk -F'"' '{print $4}' | sort | uniq)
   subnetIds=$(echo $subnets | perl -pe 's{\s}{,}g; s{,$}{}g')
   routetables=$(aws ec2 describe-route-tables --filters "Name=association.subnet-id,Values=[$subnetIds]" | grep RouteTableId | awk -F'"' '{print $4}' | sort | uniq)
   igw=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$vpcid" | grep InternetGatewayId  | awk -F'"' '{print $4}' | sort | uniq)

   for rtb in $routetables; do
	associations=$(aws ec2 describe-route-tables --route-table-id $rtb | grep RouteTableAssociationId | awk -F'"' '{print $4}' | sort | uniq)
	for asid in $associations; do
	    echo aws ec2 disassociate-route-table --association-id $asid
	    aws ec2 disassociate-route-table --association-id $asid
	done
	echo aws ec2 delete-route-table --route-table-id $rtb
	aws ec2 delete-route-table --route-table-id $rtb
   done
   echo "subnets: $subnets"
   for sid in $subnets; do
	echo aws ec2 delete-subnet --subnet-id $sid
	aws ec2 delete-subnet --subnet-id $sid
   done
   echo "igw:     $igw"
   echo aws ec2 detach-internet-gateway --internet-gateway-id $igw --vpc-id $vpcid
   aws ec2 detach-internet-gateway --internet-gateway-id $igw --vpc-id $vpcid
   echo aws ec2 delete-internet-gateway --internet-gateway-id $igw
   aws ec2 delete-internet-gateway --internet-gateway-id $igw
   echo aws ec2 delete-vpc --vpc-id $vpcid
   aws ec2 delete-vpc --vpc-id $vpcid
   echo "######################################################################"
done
exit 0

# aws ec2 describe-vpcs | grep VpcId | awk -F'"' '{print $4}' | sort | uniq
# vpc-3dd93f5b
# vpc-6c6c7a0b
# vpc-41303b26
# vpc-78b4521e
# vpc-b4af4ad2
# vpc-6dbc5a0b
# vpc-6fda3c09
# vpc-79e1071f
# vpc-9da046fb
# vpc-5d2acd3b
# vpc-3cce285a
# vpc-6baf490d
# vpc-925cbbf4
# vpc-ddd234bb
# vpc-406d8a26
# vpc-07de3861
# vpc-6bfb1d0d
# vpc-01fd1a67
# vpc-05f2b262
# vpc-ef9d8488
# vpc-91f513f7

# vpcid=vpc-6baf490d; aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpcid" | grep SubnetId | awk -F'"' '{print $4}' | sort | uniq
# subnet-1d8a2630
# subnet-7a8a2657
# subnet-defa6597
# subnet-27fa656e
# subnet-5ba10100
# subnet-72a10129

# subnetId=subnet-72a10129; aws ec2 describe-route-tables --filters "Name=association.subnet-id,Values=$subnetId" | grep RouteTableId | awk -F'"' '{print $4}' | sort | uniq
# rtb-290f444f

# vpcid=vpc-6baf490d; aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$vpcid" | grep InternetGatewayId  | awk -F'"' '{print $4}' | sort | uniq
# igw-ae862fc9
