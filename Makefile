.PHONY: all
all: runtime

.PHONY: clean
clean:
	docker rmi -f oleggorj/cassandra:latest || :

.PHONY: runtime
runtime:
	docker images
	docker build \
		--build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
		--build-arg VCS_REF=${VCS_REF} \
		--build-arg VERSION=${VERSION} \
		--no-cache --tag oleggorj/cassandra:latest https://github.com/OlegGorj/cassandra-on-docker.git
	docker images | grep cassandra

.PHONY: test
test:
	(docker network ls | grep vnet ) || docker network create vnet
	docker run --net vnet --name cassandra --hostname cassandra.vnet -e MAX_HEAP_SIZE=2048M -e HEAP_NEWSIZE=800M -d  oleggorj/cassandra:latest
	docker run --net vnet oleggorj/cassandra:latest  bash -c 'for i in $$(seq 200); do nc -z cassandra.vnet 9042 && echo "test starting" && break; echo -n .; sleep 1; [ $$i -ge 300 ] && echo timeout && exit 124; done'

#	bats test/test_*.bats
