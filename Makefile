LOCALUSER_NAME := $(shell id -un)
LOCALUSER_ID := $(shell id -u)
LOCALUSER_GID := $(shell id -g)
IMAGE_NAME := planning_train
CONTAINER_NAME := planning_train_$(LOCALUSER_NAME)
BASE_IMAGE_NAME := planning_train_base:latest
NETWORK_NAME := network_ipvlan
#GATEWAY := 192.168.20.1
#SUBNET := 192.168.20.0/24


help:
	@echo 'Simple Makefile to help with creating a useful, local, docker container'
	@echo 'which mimics the build environment used on Jenkins but includes your'
	@echo 'own user.'
	@echo ''
	@echo 'Your user name, UID, and GID are used to create a matching user inside the'
	@echo 'container. The container, when created, has your home directory mounted where'
	@echo 'you would expect it. This avoids permissions problems and means you own any files'
	@echo 'created while you are inside the container.'
	@echo ''
	@echo 'Your user is also added to the sudo group for passwordless sudo commands inside'
	@echo 'the container. This lets you do add things to the container if needed: but be'
	@echo 'aware the container is run with the "-rm" switch so changes will disappear when'
	@echo 'you exit. If you want it to survive, use the "run_persistent" target. That will let'
	@echo 'you restart the container with "make restart"'
	@echo ''
	@echo 'Targets are:'
	@echo '	checkargs:      See which user information will be used'
	@echo '	eth_setup:      Docker Network Setup'
	@echo '	build:          Build the image for your container (called apdlocal)'
	@echo '	start:          docker run in back ground.'
	@echo '	into:           in to docker.'
	@echo ' 	restart:        Restart a stopped container that was launched with run_persistent'
	@echo '	stop:           Stops the container'
	@echo '	clean:          Clean up your personal container and image'
	@echo '	clean_all:      Clean up the base and personal images'
	@echo ''

checkargs:
	echo NAME: "$(LOCALUSER_NAME)"
	echo UID : "$(LOCALUSER_ID)"
	echo GID : "$(LOCALUSER_GID)"

eth_setup:

	$(shell docker network ls | grep $(NETWORK_NAME) > /dev/null 2>&1)

	docker network create -d ipvlan --subnet=$(shell ./findsn.sh) --gateway=$(shell ./findgw.sh) -o parent=$(shell ifconfig | grep -e RUNNING | grep -v "LOOPBACK" | awk '{print $1}' | cut -d ':' -f1 | grep -v veth | grep -v docker | head -n 1) $(NETWORK_NAME)

build: Dockerfile.local build_base
	docker build \
		--build-arg base_image_name=$(BASE_IMAGE_NAME) \
		--build-arg localuser_name=$(LOCALUSER_NAME) \
		--build-arg localuser_id=$(LOCALUSER_ID) \
		--build-arg localuser_gid=$(LOCALUSER_GID) \
		--tag $(IMAGE_NAME) \
		--file Dockerfile.local .

build_base: Dockerfile
	docker build \
		--tag $(BASE_IMAGE_NAME) \
		--file Dockerfile .

start:
	docker run \
		--privileged \
		--volume $(HOME):$(HOME) \
		--gpus all \
		--user $(LOCALUSER_NAME) \
		--name $(CONTAINER_NAME) \
		--workdir $(HOME) \
		-p 8000:8000 \
		-p 8001:8001 \
		-e DISPLAY -e TERM \
		-e QT_X11_NO_MITSHM=1 \
		-e XAUTHORITY=/tmp/.docker0lhyjlnb.xauth \
		-v /tmp/.docker0lhyjlnb.xauth:/tmp/.docker0lhyjlnb.xauth \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v /etc/localtime:/etc/localtime:ro \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-tid \
		$(IMAGE_NAME)


into:
	docker exec \
		-u $(LOCALUSER_NAME) \
		-e DISPLAY=$(DISPLAY) \
		-it $(CONTAINER_NAME) \
		/bin/bash 

restart:
	docker restart ${CONTAINER_NAME}
	docker exec -ti --user $(LOCALUSER_NAME) --workdir $(HOME) $(CONTAINER_NAME) bash

clean:
	docker stop $(CONTAINER_NAME) || true
	docker container rm $(CONTAINER_NAME) || true
	docker image rm $(IMAGE_NAME) || true


clean_all: clean clean_base


stop:
	docker stop $(CONTAINER_NAME) || true

