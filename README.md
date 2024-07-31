# NeoakaDarkman/snappymail

![](https://snappymail.eu/static/img/logo-256x256.png)

### What is this ?

Simple, modern, lightweight & fast web-based email client. More details on the [official website](https://snappymail.eu/).

### Features

- Lightweight & secure image (no root process)
- Based on Alpine
- Latest Snappymail
- Contacts (DB) : sqlite, mysql or pgsql (server not built-in)
- With Nginx and PHP8.3
- Postfixadmin-change-password plugin

### Build-time variables

- **GPG_FINGERPRINT** : fingerprint of signing key

### Ports

- **8888**

### Environment variables

| Variable | Description | Type | Default value |
| -------- | ----------- | ---- | ------------- |
| **UID** | snappymail user id | *optional* | 991
| **GID** | snappymail group id | *optional* | 991
| **UPLOAD_MAX_SIZE** | Attachment size limit | *optional* | 25M
| **LOG_TO_STDOUT** | Enable nginx and php error logs to stdout | *optional* | false
| **MEMORY_LIMIT** | PHP memory limit | *optional* | 128M

### Docker-compose.yml

```yml
# Full example :
# https://github.com/neoakadarkman/mailserver/blob/master/docker-compose.sample.yml

snappymail:
  image: neoakadarkman/snappymail
  container_name: snappymail
  volumes:
    - /mnt/docker/snappymail:/snappymail/data
  depends_on:
    - mailserver
```

