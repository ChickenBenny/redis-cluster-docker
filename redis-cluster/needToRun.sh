ip=172.31.103.55
for port in {7001..7006}; 
do 
mkdir -p ./${port}/conf && PORT=${port} IP=${ip} envsubst < ./redis-cluster.tmpl > ./${port}/conf/redis.conf; 
done