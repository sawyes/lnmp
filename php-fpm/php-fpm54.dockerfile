FROM php:5.4-fpm

LABEL maintainer="peter <7061384@126.com>"

ARG CHANGE_SOURCE=false
COPY ./alibaba-source/ /etc/apt/
RUN if [ ${CHANGE_SOURCE} = true ]; then \
    # Change application source from dl-cdn.alpinelinux.org to aliyun source
    cp /etc/apt/sources.list /etc/apt/sources.list.bak && \
    rm -fr /etc/apt/sources.list && \
    cp /etc/apt/debian/8.x.jessie.source.list /etc/apt/sources.list \
;fi

###########################################################################
# HTTP_PROXY
###########################################################################

ARG HTTP_PROXY=${HTTP_PROXY}

RUN if [ ${HTTP_PROXY} ]; then \
    # pear set HTTP_PROXY
    pear config-set http_proxy ${HTTP_PROXY} \
;fi

###########################################################################
# lib
###########################################################################
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        libmemcached-dev \
        wget \
        git \
        zip \
        libfreetype6-dev \
        libz-dev \
        libssl-dev \
        libnghttp2-dev \
        libjpeg-dev \
        libmcrypt-dev \
        libpcre3-dev

###########################################################################
# WKHTMLTOPDF, A application that output pdf document
###########################################################################

ARG INSTALL_WKHTMLTOPDF=false

RUN if [ ${INSTALL_WKHTMLTOPDF} = true ]; then \
    apt-get update && apt-get install -y wkhtmltopdf xvfb\
;fi

###########################################################################
# composer
###########################################################################

ARG INSTALL_COMPOSER=false
ARG COMPOSER_REPO_PACKAGIST

RUN if [ ${INSTALL_COMPOSER} = true ]; then \
    curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer self-update --clean-backups \
    && (if [ ${COMPOSER_REPO_PACKAGIST} ]; then \
       composer config -g repo.packagist composer ${COMPOSER_REPO_PACKAGIST} \
    ;fi) \
;fi

###########################################################################
# PHP REDIS EXTENSION
# 注意版本约束问题
# 这是强烈建议用户使用其明确的版本号pecl install的调用，以确保适当的PHP版本兼容性（选择一个版本的扩展程序安装时PECL不检查PHP版本的兼容性，但要安装它时一样）。es: pecl install redis-4.0.1
# https://docs.docker.com/samples/library/php/#pecl-extensions
###########################################################################

ARG INSTALL_PHPREDIS=false

RUN if [ ${INSTALL_PHPREDIS} = true ]; then \
    # Install Php Redis Extension
    pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis \
;fi

###########################################################################
# Mysqli Modifications:
###########################################################################

ARG INSTALL_MYSQLI=false

RUN if [ ${INSTALL_MYSQLI} = true ]; then \
    docker-php-ext-install mysqli \
;fi

###########################################################################
# PDO_Mysql Modifications:
###########################################################################

ARG INSTALL_PDO=false

RUN if [ ${INSTALL_PDO} = true ]; then \
    docker-php-ext-install pdo && \
    docker-php-ext-install pdo_mysql \
;fi

###########################################################################
# pgsql
###########################################################################

ARG INSTALL_PGSQL=false

RUN if [ ${INSTALL_PGSQL} = true ]; then \
    # Install the pgsql extension
    # on RHEL systems: yum install postgresql-devel
    apt-get install -y libpq-dev && \
    docker-php-ext-install pgsql \
;fi

###########################################################################
# pgsql client
###########################################################################

ARG INSTALL_PG_CLIENT=false

RUN if [ ${INSTALL_PG_CLIENT} = true ]; then \
    # Create folders if not exists (https://github.com/tianon/docker-brew-debian/issues/65)
    mkdir -p /usr/share/man/man1 && \
    mkdir -p /usr/share/man/man7 && \
    # Install the pgsql client
    apt-get install -y postgresql-client \
;fi

###########################################################################
# ZipArchive extension:
###########################################################################

ARG INSTALL_ZIP=false

RUN if [ ${INSTALL_ZIP} = true ]; then \
    # Install the zip extension
    docker-php-ext-install zip \
;fi


###########################################################################
# mb_string extension:
###########################################################################

ARG INSTALL_MBSTRING=false

RUN if [ ${INSTALL_MBSTRING} = true ]; then \
    # Install the zip extension
    docker-php-ext-install mbstring \
;fi

###########################################################################
# bcmath:
###########################################################################

ARG INSTALL_BCMATH=false

RUN if [ ${INSTALL_BCMATH} = true ]; then \
    # Install the bcmath extension
    docker-php-ext-install bcmath \
;fi

###########################################################################
# Install the PHP gd library
###########################################################################

ARG INSTALL_GD=false

RUN if [ ${INSTALL_GD} = true ]; then \
    docker-php-ext-install gd && \
    docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd \
;fi

###########################################################################
# Opcache:   PHP_VERSION >= 5.5
# other version(<=5.4) see @http://php.net/manual/zh/intro.opcache.php
###########################################################################

ARG INSTALL_OPCACHE=false

RUN if [ ${INSTALL_OPCACHE} = true ]; then \
    docker-php-ext-install opcache \
;fi

# # Override with custom opcache settings
COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY ./laravel.ini /usr/local/etc/php/conf.d/laravel.ini

###########################################################################
# PHP Memcached:
###########################################################################

ARG INSTALL_MEMCACHED=false

RUN if [ ${INSTALL_MEMCACHED} = true ]; then \
    # Install the php memcached extension
    curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz" \
    && mkdir -p memcached \
    && tar -C memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
    && ( \
        cd memcached \
        && phpize \
        && ./configure \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r memcached \
    && rm /tmp/memcached.tar.gz \
    && docker-php-ext-enable memcached \
;fi

###########################################################################
# bcmath:
# PHP_VERSION < 5.6
###########################################################################

ARG INSTALL_MCRYPT=false

RUN if [ ${INSTALL_MCRYPT} = true ]; then \
    # Install the mcrypt extension
    docker-php-ext-install mcrypt \
;fi

USER root


COPY ./error.ini /usr/local/etc/php/conf.d/error.ini

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog && \
    pear config-set http_proxy "" && \
    apt-get autoremove

ARG APP_USER=www
ARG APP_UID=1001
ARG APP_GROUP=www
ARG APP_GID=1001
RUN groupadd -r ${APP_GROUP} -g ${APP_GID} && \
    useradd --no-log-init -u ${APP_UID} -r -g ${APP_GROUP} ${APP_USER}

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9054
