ARG BASE_IMAGE
FROM $BASE_IMAGE
LABEL maintainer="contact@saunafs.org"
RUN apt update && apt install -y gnupg wget dirmngr

# Ensure gnupg home exists before importing key
RUN mkdir -p /root/.gnupg

# Import SaunaFS public key
RUN gpg --no-default-keyring \
    --keyring /usr/share/keyrings/saunafs-archive-keyring.gpg \
    --keyserver hkps://keyserver.ubuntu.com \
    --receive-keys 0xA80B96E2C79457D4

# Define a non-volume-mapped path for templates
ENV SAUNAFS_TEMPLATE_DIR /opt/saunafs/templates

# Use BuildKit secret for apt authentication and install package in one layer
RUN --mount=type=secret,id=apt_auth,mode=0444 \
    cp /run/secrets/apt_auth /etc/apt/auth.conf.d/saunafs.conf && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/saunafs-archive-keyring.gpg] https://repo.saunafs.com/repository/saunafs-ubuntu-24.04/ noble main" > /etc/apt/sources.list.d/saunafs.list

RUN apt-get update && \
    apt-get install -y dialog && \
    yes | unminimize

RUN apt-get update && \
    apt-get install -y saunafs-master && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${SAUNAFS_TEMPLATE_DIR} && \
    cp /var/lib/saunafs/metadata.sfs.empty ${SAUNAFS_TEMPLATE_DIR}/metadata.sfs.empty

COPY saunafs-master.start.sh /saunafs-master.start.sh
RUN chmod +x /saunafs-master.start.sh
CMD ["/saunafs-master.start.sh"]
