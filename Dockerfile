FROM debian:bookworm-slim

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-rustdesk-server-aio"

# Base configuration identical to ich777/debian-baseimage with English locale
RUN echo "deb http://deb.debian.org/debian bookworm contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    apt-get update && apt-get -y upgrade && \
    apt-get -y install --no-install-recommends wget locales procps && \
    touch /etc/locale.gen && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && \
    apt-get -y install --reinstall ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# English language environment variables
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install RustDesk packages for ARM64 (latest version)
RUN apt-get update && \
    LATEST_VERSION=$(wget -qO- https://api.github.com/repos/rustdesk/rustdesk-server/releases/latest | grep -Po '"tag_name": "\K.*?(?=")') && \
    wget -O /tmp/hbbs.deb https://github.com/rustdesk/rustdesk-server/releases/download/${LATEST_VERSION}/rustdesk-server-hbbs_${LATEST_VERSION}_arm64.deb && \
    wget -O /tmp/hbbr.deb https://github.com/rustdesk/rustdesk-server/releases/download/${LATEST_VERSION}/rustdesk-server-hbbr_${LATEST_VERSION}_arm64.deb && \
    apt-get -y install /tmp/hbbs.deb /tmp/hbbr.deb && \
    rm -rf /tmp/hbbs.deb /tmp/hbbr.deb /var/lib/apt/lists/*

ENV DATA_DIR="/rustdesk-server"
ENV HBBS_ENABLED="true"
ENV HBBR_ENABLED="true"
ENV RELAY_SERVER=""
ENV KEY=""
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV USER="rustdesk"
ENV DATA_PERM=770

RUN mkdir $DATA_DIR && \
    useradd -d $DATA_DIR -s /bin/bash $USER && \
    chown -R $USER $DATA_DIR && \
    ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

# Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]