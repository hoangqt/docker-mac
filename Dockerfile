FROM ubuntu:24.04 AS base

LABEL maintainer="Hoang Tran"
LABEL description="Base OS with essential tools"
LABEL stage="base"

# Restore man pages that are removed in minimal Ubuntu image
RUN yes | unminimize

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
    valgrind \
    logrotate \
    network-manager \
    lvm2 \
    nfs-common \
    iputils-ping \
    traceroute \
    dnsutils \
    mtr \
    firewalld \
    tcpdump \
    htop \
    iotop \
    iftop \
    nethogs \
    sysstat \
    dmidecode \
    lsof \
    psmisc \
    ldnsutils \
    acl \
    man \
    man-db \
    manpages \
    manpages-dev \
    manpages-posix \
    && mandb


FROM base AS development

LABEL description="Development environment"
LABEL stage="dev"

# Terraform
RUN wget -q https://releases.hashicorp.com/terraform/1.13.1/terraform_1.13.1_linux_amd64.zip && \
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

# Nodejs repo
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash -

RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    golang-go \
    ruby \
    lua5.4 \
    bazel-bootstrap \
    nodejs

# Astral uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Rust
# hadolint ignore=SC1091
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal && \
    . "$HOME/.cargo/env" && \
    rustup default stable && \
    ln -s "$HOME/.cargo/bin/rustup" /usr/local/bin/rustup && \
    ln -s "$HOME/.cargo/bin/rustc" /usr/local/bin/rustc && \
    ln -s "$HOME/.cargo/bin/cargo" /usr/local/bin/cargo

# Install SDKMAN and Groovy
RUN curl -s "https://get.sdkman.io" | bash \
    && bash -c "source ~/.sdkman/bin/sdkman-init.sh && sdk install groovy"

# hadolint global ignore=SC2016
RUN echo 'export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"' >> ~/.bashrc \
    && echo 'source ~/.sdkman/bin/sdkman-init.sh' >> ~/.bashrc

FROM development AS databases

RUN curl https://clickhouse.com/ | sh
