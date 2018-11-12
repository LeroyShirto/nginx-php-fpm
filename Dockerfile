FROM php:7.0-fpm-alpine
LABEL maintainer="leroy.shirto@blackhousestudios.co.uk"

RUN addgroup -S nginx \
    && adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \ 
    && apk add --no-cache \
    bash \
    supervisor \
    nginx \
    # forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir -p /run/nginx

ADD config/supervisord.conf /etc/supervisord.conf

# Copy our nginx config
RUN rm -Rf /etc/nginx/nginx.conf
ADD config/nginx.conf /etc/nginx/nginx.conf

# nginx site conf
RUN mkdir -p /etc/nginx/sites-available/ && \
    mkdir -p /etc/nginx/sites-enabled/ && \
    mkdir -p /etc/nginx/ssl/ && \
    rm -Rf /var/www/* && \
    mkdir -p /app/public
ADD config/nginx-site.conf /etc/nginx/sites-enabled/default.conf

# Add Scripts
ADD scripts/start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 8080

WORKDIR "/app"

# ENTRYPOINT [ "bash", '-c', '/start.sh' ]
ENTRYPOINT []
CMD ["/start.sh"]
