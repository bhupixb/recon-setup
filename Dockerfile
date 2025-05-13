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
    locales \
    sudo \
    python3 \
    python3-pip \
    wget \
    ca-certificates \
    build-essential \
    tini \
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

# Install zsh, oh-my-zsh, powerlevel10k, completions, etc. using deluan/zsh-in-docker
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh)"
# Uses "Spaceship" theme with some customization. Uses some bundled plugins and installs some more from github
# RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh)" -- \
    # -t https://github.com/denysdovhan/spaceship-prompt \
    # -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
    # -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
    # -p git \
    # -p ssh-agent \
    # -p https://github.com/zsh-users/zsh-autosuggestions \
    # -p https://github.com/zsh-users/zsh-completions

# Set working directory
WORKDIR /root

ENV HOME=/root

RUN touch $HOME/ok && touch /root/ok
# # Install Atuin
RUN curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh 

RUN ln -s $HOME/.atuin/bin/atuin /usr/local/bin/atuin && \
    echo "Atuin installed at $(ls $HOME/.atuin/bin/atuin || echo "no")" && \
    echo "Atuin installed at $(ls /root/.atuin/bin/atuin || echo "no 1")" && \
    echo "Atuin installed at $(ls /usr/local/bin/atuin || echo "no 2")" && \
    echo 'eval "$(atuin init zsh)"' >> ~/.zshrc

# ENV PATH="/usr/local/go/bin:${PATH}"

# Default shell
SHELL ["/bin/zsh", "-c"]

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Use tini for graceful shutdown
ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
# No CMD needed as entrypoint.sh handles launching zsh 