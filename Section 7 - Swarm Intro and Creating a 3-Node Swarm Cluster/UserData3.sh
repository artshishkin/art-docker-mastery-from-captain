#!/bin/bash
yum update -y
amazon-linux-extras install -y docker
service docker start
usermod -a -G docker ec2-user
chkconfig docker on
docker swarm join --token SWMTKN-1-0ir23d5rvatr1v12f5kvc57aoq03unc8je5g6eicibc9kqvqed-ac9aye0d251rirhgb3yec0kvs 172.31.39.69:2377
