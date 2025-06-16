ARG BASE_IMAGE
FROM $BASE_IMAGE
LABEL maintainer="contact@saunafs.com"
RUN apt update && apt install -y gnupg wget dirmngr

# Ensure gnupg home exists before importing key
RUN mkdir -p /root/.gnupg

# Import SaunaFS public key
RUN gpg --no-default-keyring \
    --keyring /usr/share/keyrings/saunafs-archive-keyring.gpg \
    --keyserver hkps://keyserver.ubuntu.com \
    --receive-keys 0xA80B96E2C79457D4

# Use BuildKit secret for apt authentication and install package in one layer
RUN --mount=type=secret,id=apt_auth,mode=0444 \
    cp /run/secrets/apt_auth /etc/apt/auth.conf.d/saunafs.conf && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/saunafs-archive-keyring.gpg] https://repo.saunafs.com/repository/saunafs-ubuntu-24.04/ noble main" > /etc/apt/sources.list.d/saunafs.list && \
    apt update && \
    apt install -y saunafs-cgiserv

# Add SaunaFS repository
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/saunafs-archive-keyring.gpg] https://repo.saunafs.com/repository/saunafs-ubuntu-24.04/ noble main" > /etc/apt/sources.list.d/saunafs.list
RUN apt update
RUN apt install -y saunafs-cgiserv
CMD ["/usr/bin/python3", "/usr/sbin/saunafs-cgiserver", "-v", "-P", "9425"]
