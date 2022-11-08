# Docker Scripts for Training
This repository is about implementing fundamental docker environment for training DL model shortly

## 1. Download jetbrain IDE kits and rename them as clion.tar.gz and pycharm.tar.gz respectively

## 2. Build docker image
```bash
make build
```

## 3. Create network interface for docker(optional)
```bash
make eth_setup
```

## 4. Start docker machine
```bash
# if it needs, add ip and network options when running the docker machine
make start
```
