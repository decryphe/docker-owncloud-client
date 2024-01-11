FROM debian:bookworm-slim

# Create the directory in which the scripts will be stored
RUN mkdir -p /opt/ownCloud/log

# Update, upgrade and install some packages
RUN apt update \
    && apt -y upgrade \
    && apt -y install \
    apt-transport-https \
    moreutils \
    wget \
    dialog \
    apt-utils \
    gnupg2 \
    && apt-get clean \
    && apt -y autoremove \
    && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /usr/share/doc \
    /usr/share/man \
    /usr/share/locale \
    /usr/share/info \
    /usr/share/lintian

# Add the ownCloud repository and install it
RUN echo 'deb https://download.owncloud.com/desktop/ownCloud/stable/latest/linux/Debian_12/ /' > /etc/apt/sources.list.d/owncloud-client.list \
    && wget -nv 'https://download.owncloud.com/desktop/ownCloud/stable/latest/linux/Debian_12/Release.key' -O - | gpg --dearmor | tee /etc/apt/trusted.gpg.d/owncloud-client.gpg > /dev/null \
    && apt-key add - < /tmp/Release.key \
    && apt update \
    && apt install -yq --no-install-recommends \
    owncloud-client \
    && apt upgrade -y \
    && apt-get clean \
    && apt -y autoremove \
    && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /usr/share/doc \
    /usr/share/man \
    /usr/share/locale \
    /usr/share/info \
    /usr/share/lintian

COPY *.sh /opt/ownCloud/
WORKDIR /ocdata

ENTRYPOINT ["/bin/bash","/opt/ownCloud/docker-entrypoint.sh"]
CMD ["/bin/bash", "/opt/ownCloud/run.sh"]

ENV OC_USER=oc_username \
    OC_PASS=oc_passwordORtoken \
    OC_SERVER=yourserver.com \
    OC_PROTO=https \
    OC_URLPATH=/ \
    OC_WEBDAV=remote.php/webdav \
    OC_FILEPATH=/ \
    TRUST_SELFSIGN=0 \
    SYNC_HIDDEN=0 \
    SILENCE_OUTPUT=1 \
    RUN_INTERVAL=30 \
    RUN_UID=99 \
    RUN_GID=100
