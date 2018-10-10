


## start

```
docker-compose up -d nginx

docker-compose exec php-fpm bash
docker-compose exec nginx bash
```

## rebuild

```
docker-compose down
docker-compose build --no-cache
```


## php-fpm

ext save in docker(docker-php-ext-install)

```
/usr/src/php/ext
```