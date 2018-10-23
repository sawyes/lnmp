FROM nginx:alpine

LABEL maintainer="peter <7061384@126.com>"

COPY nginx.conf /etc/nginx/

# If you're in China, or you need to change sources, will be set CHANGE_SOURCE to true in .env.

ARG CHANGE_SOURCE=false
RUN if [ ${CHANGE_SOURCE} = true ]; then \
    # Change application source from dl-cdn.alpinelinux.org to aliyun source
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
;fi

RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash \
    && adduser -D -H -u 1000 www-data

ARG PHP_UPSTREAM_CONTAINER=php-fpm
ARG PHP_UPSTREAM_PORT=9000

# Set upstream conf and remove the default conf
RUN echo "upstream php-upstream { server ${PHP_UPSTREAM_CONTAINER}:${PHP_UPSTREAM_PORT}; }" > /etc/nginx/conf.d/upstream.conf \
    && echo "upstream php-upstream54 { server php-fpm54:9054; }" > /etc/nginx/conf.d/upstream54.conf \
    && echo "upstream php-upstream55 { server php-fpm55:9055; }" > /etc/nginx/conf.d/upstream55.conf \
    && echo "upstream php-upstream56 { server php-fpm56:9056; }" > /etc/nginx/conf.d/upstream56.conf \
    && echo "upstream php-upstream70 { server php-fpm70:9070; }" > /etc/nginx/conf.d/upstream70.conf \
    && echo "upstream php-upstream71 { server php-fpm71:9071; }" > /etc/nginx/conf.d/upstream71.conf \
    && echo "upstream php-upstream72 { server php-fpm72:9072; }" > /etc/nginx/conf.d/upstream72.conf \
    && echo "upstream php-upstream73 { server php-fpm73:9073; }" > /etc/nginx/conf.d/upstream73.conf \
    && rm /etc/nginx/conf.d/default.conf

CMD ["nginx"]

EXPOSE 80 443
