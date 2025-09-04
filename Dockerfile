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
    gnupg2 \
    wget \
    unzip \
    apt-transport-https \
    ca-certificates \
    curl \
    valgrind

# Terraform
RUN wget https://releases.hashicorp.com/terraform/1.13.1/terraform_1.13.1_linux_amd64.zip && \
    unzip terraform_1.13.1_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_1.13.1_linux_amd64.zip

# Kubectl
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key \
    | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
    https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | \
    tee /etc/apt/sources.list.d/kubernetes.list && \
    chmod 644 /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && apt-get install -y kubectl
