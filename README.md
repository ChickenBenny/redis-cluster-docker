# Redis-cluster-docker-cheatsheet
This project will help your learn how to establish redis-cluster by shell and docker compose.

### Architecture
```
redis-cluster-docker-cheatsheat
├── README.md
├── master-slave       
│   └── docker-compose.yml
├── master-slave-sentinel
│   ├── docker-compose.yml
│   └── sentinel
│       └── sentinel.conf
└── redis-cluster
    ├── docker-compose.yml
    ├── needToRun.sh
    └── redis-cluster.tmpl
```

### Quickstart
1. Clone the repository.
```
$ mkdir redis-cluster && cd redis-cluster
$ git clone https://github.com/ChickenBenny/redis-cluster-sentinel-docker
```
2. Choose the structure you want to build, and use docker compose in the folder to build the database.
> **Master-slave** => It contain one master and two slave example. If you want to build the sturcture with more slave, take a look at the master-slave chapter.

> **Master-slave-sentinel** => It contain one master and two slave structure with three sentinels example. If you want to build the sturcture with more slaves or sentinels, take a look at the master-slave-sentinel chapter.

> **Redis-cluster** => It contain three master slave sturcture example. If you want to build the cluster with more master slave structure, take a look at the redis cluster chapter.


## Setting cheatsheet
### 1. Master-slave
![](https://i.imgur.com/PggxwJH.png)
The stucture need one master and N slaves, remember the slave container youe need to add --slaveof ```${name of master container}``` ```${master expose port}```.

**Check the structure**
1. Check whether all the container is built.
```
$ docker ps
```
![](https://i.imgur.com/Anmk1r4.png)

2. Enter redis-master container and check the replications status. The role should be 'master' and the connect slave should be '2'.
```
$ docker exec -it redis-master sh      // Enter the container
$ redis-cli                            // Connect the redis server
127.0.0.1:6379> info replication       
```
![](https://i.imgur.com/kgXoorg.png)

3. Enter redis-slave container and check the replications status. The role should be 'slave' and the master host should be ```${redis-master container name}```.

![](https://i.imgur.com/0KHbYd8.png)


### 2. Master-slave with sentinel
![](https://i.imgur.com/WKLCLgN.png)
If you want to add sentinel in your master slave structure, you need to add sentinel folder and setting the config first.
* sentinel config
```
port 5000
sentinel monitor mymaster redis-master 6379 2
sentinel down-after-milliseconds mymaster 5000
sentinel failover-timeout mymaster 60000
sentinel parallel-syncs mymaster 1
```
1. ```port```The sentinel runs on which port in the container.
2. ```sentinel monitor <master-group-name> <ip> <port> <quorum>```
   The **quorum** is the number of Sentinels that need to agree about the fact the master is not reachable, and eventually start a failover procedure. The quorum is only used to detect the failure!!
3. ```sentinel <option_name> <master_name> <option_value>```
  **down-after-milliseconds** is the time in milliseconds an instance should not be reachable.
  **parallel-syncs** sets the number of replicas that can be reconfigured to use the new master after a failover at the same time.

**Check the structure**
1. Check whether sentinels is built and check the monitoring information.
```
$ docker exec -it redis-sentinel1 sh
$ redis-cli -p 5000
127.0.0.1:5000 > info sentinel
```
![](https://i.imgur.com/FLQOaxK.png)

2. Try to stop the master container and check whether sentinel switch the new master.
```
$ docker stop redis-master
```
![](https://i.imgur.com/peYwuhY.png)

3. Go to the slave container and check the role and replication information. One of the slave should be change to master, and the connect slave should be 1.

![](https://i.imgur.com/lgohWXF.png)


### 3. Redis-cluster
![](https://i.imgur.com/9eciYe7.png)


* Shell
**Important : you should find your ip first and type in the shell script.**
If you want to build more db, you can change {7001..```${7001 + N you wanted}```}.
```
#!/bin/bash
ip=${your ip}
for port in {7001..7006}; 
do 
mkdir -p ./${port}/conf && PORT=${port} IP=${ip} envsubst < ./redis-cluster.tmpl > ./${port}/conf/redis.conf; 
done
```


* Redis-cluster.tmpl
```
port ${PORT} 
protected-mode no 
cluster-enabled yes 
cluster-config-file nodes.conf 
cluster-node-timeout 5000 
cluster-announce-ip ${IP}
cluster-announce-port ${PORT} 
cluster-announce-bus-port 1${PORT} 
appendonly yes
```

* docker compose
The cluster creat command I wrote in redis-1 and you can use docker-compose up to build the cluster.
```
$ export IP=${your ip}
$ docker-compose up
```

**Check the structure**
1. Check the docker compose log information, whether the cluster is connect successfully.
![](https://i.imgur.com/H4ac6X3.png)

2. Go to redis-1 container and check the cluster info, the cluster status should be 'OK' and the cluster size should be 3.
```
$ docker exec -it redis-1 sh
$ redis-cli -p 7001 -c            
127.0.0.1:7001> cluster info
```

![](https://i.imgur.com/5d22JhN.png)

3. You can also go to other container to connect the cluster.
> redis-cli -p ${container ip} -c

### Learn more
If you want to learn more about redis, check out my medium article.
* Redis introduction : https://blog.devops.dev/redis-introduction-from-zero-to-hero-part-i-7c13e63170f5
* Redis persistence and cap theorem : https://blog.devops.dev/redis-persistence-and-cap-theorem-from-zero-to-hero-part-ii-91eaedf58d79
* Redis structure with docker : https://blog.devops.dev/redis-cluster-and-sentinel-with-docker-from-zero-to-hero-part-iv-63ba9d196cc3