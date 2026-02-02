# ============================================
# Minimal Ubuntu Desktop with xfce4 + Chrome
# For Remote Debugging
# ============================================
# Base: Ubuntu 24.04 Server (minimal)
# Components: xfce4, SSH, KasmVNC, Chrome
# No extra plugins or unnecessary services
# ============================================

ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

LABEL maintainer "temple <temple@iobond.com>"
LABEL description="Minimal Ubuntu Desktop for Remote Debugging"

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai
ENV USER=ubuntu
ENV PASSWORD=ubuntu
ENV UID=1000
ENV GID=1000
ENV DISPLAY=:1
ENV KASMVNC_PORT=6901

# ============================================
# Step 1: System update and minimal dependencies
# ============================================
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        gnupg \
        software-properties-common \
        apt-transport-https \
        sudo \
        locales \
        tzdata && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

# ============================================
# Step 2: Install SSH server
# ============================================
RUN apt-get update && \
    apt-get install -y --no-install-recommends openssh-server && \
    mkdir -p /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    rm -rf /var/lib/apt/lists/*

# ============================================
# Step 3: Install xfce4 desktop (minimal)
# ============================================
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        xfce4 \
        xfce4-goodies \
        xserver-xorg-core \
        xserver-xorg-input-all \
        x11-xserver-utils \
        xterm \
        xfonts-base \
        xfonts-100dpi \
        xfonts-75dpi \
        xfonts-scalable \
        fonts-liberation \
        fonts-dejavu-core \
        fonts-freefont-ttf \
        dbus-x11 && \
    rm -rf /var/lib/apt/lists/*

# ============================================
# Step 4: Install KasmVNC
# ============================================
# Add KasmVNC repository
RUN wget -qO - https://github.com/kasmtech/KasmVNC/releases/download/v1.3.1/kasmvnc.asc | gpg --dearmor -o /usr/share/keyrings/kasmvnc-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/kasmvnc-archive-keyring.gpg] https://github.com/kasmtech/KasmVNC/releases/download/v1.3.1/deb stable main" > /etc/apt/sources.list.d/kasmvnc.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends kasmvncserver && \
    rm -rf /var/lib/apt/lists/*

# ============================================
# Step 5: Install Google Chrome
# ============================================
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        fonts-liberation \
        libu2f-udev \
        libvulkan1 \
        xdg-utils \
        ./google-chrome-stable_current_amd64.deb && \
    rm -f google-chrome-stable_current_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

# ============================================
# Step 6: Create user
# ============================================
RUN useradd -m -s /bin/bash -u ${UID} ${USER} && \
    echo "${USER}:${PASSWORD}" | chpasswd && \
    usermod -aG sudo ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# ============================================
# Step 7: Setup KasmVNC startup script
# ============================================
COPY --chown=${USER}:${USER} config/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# ============================================
# Expose ports
# ============================================
EXPOSE 22 ${KASMVNC_PORT}

# ============================================
# Health check
# ============================================
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD pgrep xfce4-session || exit 1

# ============================================
# Set working directory and entrypoint
# ============================================
WORKDIR /home/${USER}
ENTRYPOINT ["/entrypoint.sh"]

# Start services
CMD ["start"]
