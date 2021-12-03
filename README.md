# docker-snell
github actions taste

## Usage
docker pull
```sh
# GHCR
docker pull ghcr.io/flygar/docker-snell:latest 

# Docker Hub
# https://hub.docker.com/r/flygar/snell/tags
docker pull flygar/snell:latest 
```

docker run
```
# Docker Hub
docker run \
-d \
--name snell \
--restart=always \
-P \
flygar/snell:latest 

# Docker Hub
docker run \
-d \
--name snell \
--restart=always \
-p 28888:32910/tcp \
-p 28888:32910/udp \
flygar/snell:latest 

# replace「ENTRYPOINT」and「CMD」
# Docker Hub
docker run \
-d \
--name test \
--entrypoint /bin/sh \
flygar/snell:latest \
-c "sleep infinity"
```

logs and config
```
# log
docker logs snell

# conf
docker exec -w /home/law snell /bin/sh -c "cat snell-server.conf"
```

## Update
update publish-docker-images.yml