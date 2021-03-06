# gitlab on docker

https://docs.gitlab.com/omnibus/docker/README.html#gitlab-docker-images

```
sudo docker run --detach \
    --hostname gitlab.example.com \
    --publish 443:443 --publish 80:80 --publish 22:22 \
    --name gitlab \
    --restart always \
    --volume /srv/gitlab/config:/etc/gitlab \
    --volume /srv/gitlab/logs:/var/log/gitlab \
    --volume /srv/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
```

### docker-compose

```
docker-compose up -d gitlab
```

# proxy pass to gitlab

```
cp nginx_proxy_pass.conf /path/to/nginx
```

# gitlab

 Open your browser and visit the localhost on port 8989: http://localhost:8989 
Note: You may change GITLAB_DOMAIN_NAME to your own domain name like http://gitlab.example.com default is http://localhost
