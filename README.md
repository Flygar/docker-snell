# docker-snell
github actions taste

## Usage
docker pull
```sh
# GHCR
docker pull ghcr.io/flygar/docker-snell:latest 

# Docker Hub
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
snell:latest 

# Docker Hub
docker run \
-d \
--name snell \
--restart=always \
-p 28888:32910/tcp \
-p 28888:32910/udp \
snell:latest 

# replace「ENTRYPOINT」and「CMD」
# Docker Hub
docker run \
-d \
--name test \
--entrypoint /bin/sh \
snell:latest \
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