# set initial nvidia docker image
FROM nvidia/cuda:11.2.0-cudnn8-devel-ubuntu20.04

RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64/7fa2af80.pub

# set initial arguments
ARG DEBIAN_FRONTEND=noninteractive 
ENV TZ=Asia/Seoul

# install initial packages 
RUN apt-get update -y
RUN apt-get upgrade -y

RUN apt-get install -y \
        sudo \
        vim \
        apt-utils \
        language-pack-en-base \
        build-essential \
        gcc-multilib \
        git \
        unzip \
        wget \
        iputils-ping \
        net-tools \
        ssh \
        iproute2 \
        locales \
        rename \
        zip \
        clang \
        cmake \
        debianutils \
        net-tools \
        libjansson-dev \
        tzdata \
        python3-git \
        python3-jinja2 \
        python3-venv \
        python3 \
        python3-crypto \
        python3-pip \
        python3-pexpect \
        libgl1-mesa-glx \
	libpython3.8-dev \
	python3-dev

RUN wget -O /usr/bin/repo https://storage.googleapis.com/git-repo-downloads/repo \
    && chmod a+x /usr/bin/repo

# Set up a locale for the python 3 version of bitbake
RUN echo 'LANG="en_US.UTF-8"'>/etc/default/locale \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

# install ide
RUN echo "install ide..."
RUN mkdir -p /ides
COPY pycharm.tar.gz /ides/
COPY clion.tar.gz /ides/
RUN cd /ides/ && tar -xvzf pycharm.tar.gz && tar -xvzf clion.tar.gz
ENV PATH="${PATH}:/ides/pycharm-2022.2.3/bin"
ENV PATH="${PATH}:/ides/clion-2022.2.4/bin"


RUN echo "base image build complete...."
