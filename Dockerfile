# hadolint global ignore=DL3008,DL3009,DL3015
FROM ubuntu:25.04

RUN apt-get update && apt-get install -y \
    gdb \
    docker.io \
    ansible-core \
    make \
    cmake \
    build-essential \
    gcc \
    g++ \
    ninja-build \
    net-tools \
    neovim \
    policycoreutils \
    gnupg2
