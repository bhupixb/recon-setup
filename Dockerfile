FROM debian:bookworm

# Set non-interactive mode and update, install dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    zsh \
    curl \
    git \
    jq \
    yq \
    ripgrep \
    fd-find \
    dnsutils \
    netcat-openbsd \
    iputils-ping \
    fzf \
    locales \
    sudo \
    python3 \
    python3-pip \
    wget \
    ca-certificates \
    build-essential \
    && ln -s $(which fdfind) /usr/local/bin/fd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8


# Install latest Go
ENV GO_VERSION=1.24.0
RUN wget -q https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
rm -rf /usr/local/go && \
tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
rm go${GO_VERSION}.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Install pipx (user mode)
# RUN python3 -m pip install --no-cache-dir --upgrade pip && \
#     python3 -m pip install --no-cache-dir pipx && \
#     pipx ensurepath

# Set up zsh config for root
# RUN mkdir -p /root && \
#     echo 'export HISTFILE=~/.zsh_history' > /root/.zshrc && \
#     echo 'export HISTSIZE=30000' >> /root/.zshrc && \
#     echo 'export SAVEHIST=30000' >> /root/.zshrc && \
#     echo 'setopt append_history' >> /root/.zshrc && \
#     echo 'setopt inc_append_history' >> /root/.zshrc && \
#     echo 'setopt share_history' >> /root/.zshrc && \
#     echo 'autoload -Uz compinit && compinit' >> /root/.zshrc && \
#     echo 'source /usr/share/doc/fzf/examples/key-bindings.zsh' >> /root/.zshrc && \
#     echo 'source /usr/share/doc/fzf/examples/completion.zsh' >> /root/.zshrc

# Set working directory
WORKDIR /root

# Default shell
SHELL ["/bin/bash", "-c"]

# # Entrypoint
CMD ["bash"] 