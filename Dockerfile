FROM alpine:3.20

LABEL description="Snappymail is a simple, modern & fast web-based client" \
      maintainer="NeoakaDarkman <developer@fantasia-wmc.com>" \
      former_maintainer="Hardware <contact@meshup.net>"

ENV UID=991 GID=991 UPLOAD_MAX_SIZE=25M LOG_TO_STDOUT=false MEMORY_LIMIT=128M

ARG SNAPPY_VERSION=2.37.3
ARG PHP_VERSION=83

RUN echo "@community https://nl.alpinelinux.org/alpine/v3.20/community" >> /etc/apk/repositories \
 && apk -U upgrade \
 && apk add -t build-dependencies \
    gnupg \
    libsodium \
    wget \
 && apk add \
    ca-certificates \
    nginx \
    s6 \
    su-exec \
    php${PHP_VERSION}-fpm@community \
    php${PHP_VERSION}-curl@community \
    php${PHP_VERSION}-iconv@community \
    php${PHP_VERSION}-xml@community \
    php${PHP_VERSION}-dom@community \
    php${PHP_VERSION}-sodium@community \
    php${PHP_VERSION}-json@community \
    php${PHP_VERSION}-common@community \
    php${PHP_VERSION}-pdo_pgsql@community \
    php${PHP_VERSION}-pdo_mysql@community \
    php${PHP_VERSION}-pdo_sqlite@community \
    php${PHP_VERSION}-sqlite3@community \
    php${PHP_VERSION}-ldap@community \
    php${PHP_VERSION}-simplexml@community \
	php${PHP_VERSION}-mbstring@community \
	php${PHP_VERSION}-fileinfo@community \
 && cd /tmp \
 && wget -q https://github.com/the-djmaze/snappymail/releases/download/v${SNAPPY_VERSION}/snappymail-${SNAPPY_VERSION}.zip \
 && wget -q https://github.com/the-djmaze/snappymail/releases/download/v${SNAPPY_VERSION}/snappymail-${SNAPPY_VERSION}.zip.asc \
 && FINGERPRINT="$(LANG=C gpg --verify snappymail-${SNAPPY_VERSION}.zip.asc snappymail-${SNAPPY_VERSION}.zip 2>&1 \
  | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
 && mkdir /snappymail && unzip -q /tmp/snappymail-${SNAPPY_VERSION}.zip -d /snappymail \
 && find /snappymail -type d -exec chmod 755 {} \; \
 && find /snappymail -type f -exec chmod 644 {} \; \
 && apk del build-dependencies \
 && rm -rf /tmp/* /var/cache/apk/* /root/.gnupg

COPY rootfs /
RUN chmod +x /usr/local/bin/run.sh /services/*/run /services/.s6-svscan/*
VOLUME /snappymail/data
EXPOSE 8888
CMD ["run.sh"]
