FROM redis:latest

LABEL maintainer="peter <7061384@126.com>"

## For security settings uncomment, make the dir, copy conf, and also start with the conf, to use it
RUN mkdir -p /usr/local/etc/redis/
COPY redis.conf /usr/local/etc/redis/redis.conf

RUN echo "net.core.somaxconn = 551" > /etc/sysctl.conf && \
    echo "vm.overcommit_memory=1" >> /etc/sysctl.conf

VOLUME /data

EXPOSE 6379

CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]
#CMD ["redis-server"]
