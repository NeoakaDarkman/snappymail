FROM alpine:3.20

LABEL description "Snappymail is a simple, modern & fast web-based client" \
      maintainer="NeoakaDarkman <developer@fantasia-wmc.com>" \
      former_maintainer="Hardware <contact@meshup.net>"

ENV UID=991 GID=991 UPLOAD_MAX_SIZE=25M LOG_TO_STDOUT=false MEMORY_LIMIT=128M

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
    php83-fpm@community \
    php83-curl@community \
    php83-iconv@community \
    php83-xml@community \
    php83-dom@community \
    php83-sodium@community \
    php83-json@community \
    php83-common@community \
    php83-pdo_pgsql@community \
    php83-pdo_mysql@community \
    php83-pdo_sqlite@community \
    php83-sqlite3@community \
    php83-ldap@community \
    php83-simplexml@community \
 && cd /tmp \
 && wget -q https://github.com/the-djmaze/snappymail/releases/download/v2.36.4/snappymail-2.36.4.zip \
 && wget -q https://github.com/the-djmaze/snappymail/releases/download/v2.36.4/snappymail-2.36.4.zip.asc \
 && FINGERPRINT="$(LANG=C gpg --verify snappymail-2.36.4.zip.asc snappymail-2.36.4.zip 2>&1 \
  | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
 && mkdir /snappymail && unzip -q /tmp/snappymail-2.36.4.zip -d /snappymail \
 && find /snappymail -type d -exec chmod 755 {} \; \
 && find /snappymail -type f -exec chmod 644 {} \; \
 && apk del build-dependencies \
 && rm -rf /tmp/* /var/cache/apk/* /root/.gnupg

COPY rootfs /
RUN chmod +x /usr/local/bin/run.sh /services/*/run /services/.s6-svscan/*
VOLUME /snappymail/data
EXPOSE 8888
CMD ["run.sh"]
