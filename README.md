# Docker Scripts for Training
This repository is about implementing fundamental docker environment for training DL model shortly

## 1. Download jetbrain [IDE kits](https://www.jetbrains.com/ko-kr/) and rename them as clion.tar.gz and pycharm.tar.gz respectively

## 2. Build docker image
```bash
make build
```

## 3. Create network interface for docker(optional)
```bash
make eth_setup
```

## 4. Add Xwindow authority for docker
```bash
sudo xhost +local:docker
```

## 5. Start docker machine
```bash
# if it needs, add ip and network options when running the docker machine
make start
```
## 6. Install gedit and libxrender1 inside docker container
```bash
docker exec -it planning_train_kunwoo /bin/bash
sudo apt-get install libxrender1
sudo apt-get install gedit
```

## 7. Install compatible tensorflow
```bash
pip install tensorflow==2.10
```
