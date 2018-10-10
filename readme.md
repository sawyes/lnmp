

thanks [laradock/php-fpm](https://github.com/laradock/php-fpm)

## Todo list

- [x] nginx
- [x] php-fpm(5.4)
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