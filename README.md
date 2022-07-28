# Redis-cluster-sentinel-docker
This repo is try to build the different structure of redis, and will contain master-slave, sentinel and redis cluster. 

All the database system will be deploy by docker.

The detail tutorial we can find in my medium article:
https://medium.com/@ChickenBenny/redis-cluster-and-sentinel-with-docker-from-zero-to-hero-part-iv-63ba9d196cc3

### Quickstart
1. Clone the repository.
```
$ git clone https://github.com/ChickenBenny/redis-cluster-sentinel-docker
```
2. Choose which mode you want to build, and use docker compose to build the container.
```
$ cd ${the folder name}
$ docker-compose up
```
* Notice: If you want to use the reids cluster mode, you need to run more command:
  1. After using docker compose, you need to go into one container
  ```
  $ docker ps      // choose one container which you like
  $ docker exec -it ${container ID} sh
  $ redis-cli --cluster create 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 --cluster-replicas 1
  ```
  2. check if the cluster is successfully built.
  ```
  $ redis-cli -p 7000 cluster info      // check if the status is OK
  $ redis-cli -p 7000 cluster nodes     // check the cluster node
  $ redis-cli -p 7000 -c                // enter the cluster mode
  ```

## Structure you can play with
### 1. Master-slave
![](https://i.imgur.com/PggxwJH.png)

### 2. Master-slave with sentinel
![](https://i.imgur.com/WKLCLgN.png)


### 3. Redis-cluster
![](https://i.imgur.com/dejCci3.png)


##### Slot and CRC16
![](https://i.imgur.com/yKmGRtY.png)


