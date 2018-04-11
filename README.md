# cassandra-on-docker

[![Build Status](https://travis-ci.org/OlegGorj/cassandra-on-docker.svg?branch=master)](https://travis-ci.org/OlegGorj/cassandra-on-docker)
[![GitHub last commit](https://img.shields.io/github/last-commit/google/skia.svg?branch=master)](https://travis-ci.org/OlegGorj/cassandra-on-docker)
[![Docker Automated build](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg)](https://dockerbuildbadges.quelltext.eu/status.svg?organization=oleggorj&repository=cassandra-on-docker)
[![codecov](https://codecov.io/gh/OlegGorj/cassandra-on-docker/branch/master/graph/badge.svg)](https://codecov.io/gh/OlegGorj/cassandra-on-docker)
[![GitHub release](https://img.shields.io/github/release/OlegGorj/cassandra-on-docker.svg)](https://github.com/OlegGorj/cassandra-on-docker/releases)
[![GitHub issues](https://img.shields.io/github/issues/OlegGorj/cassandra-on-docker.svg)](https://github.com/OlegGorj/cassandra-on-docker/issues)


Latest Apache Cassandra (`3.11.2`) docker image based on alpine os


## Quick setup

#### Create network

```bash
docker network create vnet
```

#### Startup Cassandra in container (simple start)

```bash
docker run --net vnet --name cassandra -d oleggorj/cassandra:3.11.0-alpine
```

#### Start Cassandra container AND map ports to the node (or local machine). It is done this way so external services and clients could see Cassandra DB.

```bash
docker run --net vnet --name cassandra -p 9042:9042 -p 9160:9160 -p 7199:7199 -d oleggorj/cassandra:3.11.0-alpine
```

#### Tail Cassandra logs

```bash
docker logs -f cassandra
```

#### Access Cassandra using cqlsh

```bash
docker run -it --rm --net vnet oleggorj/cassandra:3.11.0-alpine cqlsh cassandra.vnet

Connected to Test Cluster at cassandra.vnet:9042.
[cqlsh 5.0.1 | Cassandra 3.11 | CQL spec 3.4.4 | Native protocol v4]
Use HELP for help.
cqlsh>
cqlsh> SELECT release_version, cluster_name FROM system.local;

 release_version | cluster_name
-----------------+--------------
            3.11 | Test Cluster

(1 rows)
cqlsh> exit
```

## Cluster containers setup on single host

```
# startup cassandra
docker-compose up -d

# tail logs for a while
docker-compose logs -f

# check ps
docker-compose ps

   Name                Command             State                        Ports                       
---------------------------------------------------------------------------------------------------
cassandra-1   entrypoint.sh cassandra -f   Up      7000/tcp, 7001/tcp, 7199/tcp, 9042/tcp, 9160/tcp
cassandra-2   entrypoint.sh cassandra -f   Up      7000/tcp, 7001/tcp, 7199/tcp, 9042/tcp, 9160/tcp
cassandra-3   entrypoint.sh cassandra -f   Up      7000/tcp, 7001/tcp, 7199/tcp, 9042/tcp, 9160/tcp

# check node status
docker-compose exec cassandra-1 nodetool status

Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address     Load       Tokens    Owns (effective)  Host ID                               Rack
UN  172.18.0.2  103.66 KiB  256      66.3%             30e50198-03ef-46dc-a521-9b77c11b185b  rack1
UN  172.18.0.3  100.4 KiB   256      62.5%             aa610862-ac91-4be7-9495-de54773752b3  rack1
UN  172.18.0.4  80.23 KiB   256      71.2%             d624fec9-1a5d-48ce-a229-20ad5a691757  rack1

# stop cassandra  
docker-compose stop

# cleanup container
docker-compose rm -v

```


---
