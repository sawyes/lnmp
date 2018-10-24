

thanks [laradock/php-fpm](https://github.com/laradock/php-fpm)

## Todo list

- [x] nginx
- [x] php-fpm
- [ ] mysql


## usage

#### Installation and Configuration

set env

```
cp .env.example .env
```

set app path, by default: `../`
```
APP_CODE_PATH_HOST
```

set nginx conf

```
cp laravel.template laravel.conf
```

start docker

```
docker-compose up -d nginx

docker-compose exec php-fpm bash
docker-compose exec nginx bash
```

#### rebuild

```
docker-compose down
docker-compose build --no-cache
```


#### php-fpm

ext save in docker(docker-php-ext-install)

```
/usr/src/php/ext
```

## mutiple php version

#### add anther php version

copy base php-fpm folder if not exists

> set php-version to hard set, and expose port 90{version} in dockerfile 

```
cp -a php-fpm php-fpm{version}
```

copy php-fpm context to anther php-fpm version on `docker-compose.yml`

> modify context place, expose port (90{version})

```
...
php-version7.2
 - ...
...
```

set UPSTREAM_ENABLE_PHP{version} to true in `.env` if exists

or add below on nginx/Dockerfile and check `docker-compose.yml` add `UPSTREAM_ENABLE_PHP{version}` varriable in nginx context
```
ARG ENABLE_PHP73=false
RUN if [ ${ENABLE_PHP73} = true ]; then \
    echo "upstream php-upstream73 { server php-fpm73:9073; }" > /etc/nginx/conf.d/upstream73.conf \
;fi
```

> !important, that send http request to which upstream

##### up mutiple php version

```
docker-compose up nginx php-fpm php-fpmfpm54
```

##### set nginx conf to diff php version

```
server {
...
    location ~ \.php$ {
    ...
        fastcgi_pass php-upstream54;
        ...
    
```