FROM alpine:latest

LABEL maintainer="Drew Gauderman <drew@dpg.host>" \
    Description="PHP Dev Server."

ENV TZ="America/Los_Angeles"

ENV PHP_DEPS \
    php7-fpm \
    php7-simplexml \
    php7-json \
    php7-sockets \
    php7-mysqli \
    php7-mbstring \
    php7-curl \
    php7-yaml \
    php7-openssl

# Install nginx and php
RUN apk --no-cache --update add \
    $PHP_DEPS \
    curl \
    bash \
    nginx \
    supervisor \
    && mkdir /run/nginx \
    && mkdir /var/log/supervisor \
    && rm -rf /tmp/*.tar.gz /var/cache/apk/*

# add user www-data
RUN adduser -u 82 -D -S -G www-data www-data

# Nginx configuration
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf

# PHP configuration
RUN rm /etc/php7/php-fpm.d/www.conf
COPY ./docker/php-fpm.d/ /etc/php7/php-fpm.d/
COPY ./docker/conf.d/ /etc/php7/conf.d/

# Configure supervisord
COPY ./docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# init script
COPY ./docker/init_script.sh /init_script.sh
RUN chmod +x /init_script.sh

WORKDIR /var/www/

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]