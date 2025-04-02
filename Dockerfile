FROM nvidia/cuda:11.3.1-devel-ubuntu20.04

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

RUN apt-get update && apt-get install wget -yq
RUN apt-get install build-essential g++ gcc -y
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install libgl1-mesa-glx libglib2.0-0 -y
RUN apt-get install openmpi-bin openmpi-common libopenmpi-dev libgtk2.0-dev git -y

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda
# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH
RUN conda install python=3.9
RUN conda install pytorch==1.10.1 torchvision==0.11.2 torchaudio==0.10.1 cudatoolkit=11.3 -c pytorch
RUN pip install Pillow==8.4.0
RUN pip install tqdm
RUN pip install torchpack
RUN pip install mmcv==1.4.0 mmcv-full==1.4.0 mmdet==2.20.0
RUN pip install nuscenes-devkit
RUN pip install mpi4py==3.0.3
RUN pip install numba==0.48.0


# Set up a locale for the python 3 version of bitbake
RUN echo 'LANG="en_US.UTF-8"'>/etc/default/locale \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

