
FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive
ENV APP=''

RUN set -xe \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    xvfb x11vnc xterm \
    sudo \
    supervisor \
    ttf-wqy-microhei \
    && curl -o mysql-workbench.deb https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community_8.0.12-1ubuntu18.04_amd64.deb \
    && dpkg -i mysql-workbench.deb \
    && apt-get update \
    && apt --fix-broken install \
    && rm -rf /var/lib/apt/lists/*

RUN set -xe \
    && useradd -u 1000 -g 100 -G sudo --shell /bin/bash --no-create-home --home-dir /tmp user \
    && echo 'ALL ALL = (ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

COPY supervisord.conf /etc/
COPY entry.sh /

User user
WORKDIR /tmp

CMD ["/entry.sh"]
