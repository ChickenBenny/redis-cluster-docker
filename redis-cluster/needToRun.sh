#!/bin/bash
for port in {7001..7006}; 
do 
mkdir -p ./${port}/conf && PORT=${port} IP=`hostname -I` envsubst < ./redis-cluster.tmpl > ./${port}/conf/redis.conf; 
done
