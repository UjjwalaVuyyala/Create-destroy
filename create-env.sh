#!/bin/bash


aws elb create-load-balancer --load-balancer-name itmo-544-ujv --listeners Protocol=Http,LoadBalancerPort=80,InstanceProtocol=Http,InstancePort=80 --subnet subnet-e27c5486

aws autoscaling create-launch-configuration --launch-configuration-name ujvwebserver --image-id "$1" --key-name uvuyyala --instance-type t2.micro --user-data file://installapp.sh

aws autoscaling create-auto-scaling-group --auto-scaling-group-name ujvwebserverdemo --launch-configuration ujvwebserver --availability-zone us-west-2b --load-balancer-names itmo-544-ujv --max-size 5 --min-size 2 --desired-capacity 3

sleep 30

IID=`aws autoscaling describe-auto-scaling-instances --query AutoScalingInstances[].InstanceId`

aws ec2 wait instance-running --instance-ids $IID

aws elb register-instances-with-load-balancer --load-balancer-name itmo-544-ujv --instances $IID




