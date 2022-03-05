FROM alpine as builder

WORKDIR /home/law

ARG SNELL_VERSION
ARG SERVER_PORT

ENV SNELL_VERSION ${SNELL_VERSION:-2.0.3}
ENV SERVER_HOST 0.0.0.0
ENV SERVER_PORT ${SERVER_PORT:-32900} 
ENV IPV6 false
ENV OBFS http

# config
RUN echo "[snell-server]" >> snell-server.conf && \
    echo "listen = ${SERVER_HOST}:${SERVER_PORT}" >> snell-server.conf && \
    echo "psk = $(date | sha256sum | base64 | head -c 15; echo)" >> snell-server.conf && \
    echo "ipv6 = ${IPV6}" >> snell-server.conf && \
    echo "obfs = ${OBFS}" >> snell-server.conf

RUN apk --no-cache add bash unzip && \
    wget -O snell-server.zip https://github.com/surge-networks/snell/releases/download/v${SNELL_VERSION}/snell-server-v${SNELL_VERSION}-linux-amd64.zip && \
    unzip snell-server.zip


FROM alpine

WORKDIR /home/law

ARG SERVER_PORT
ARG GLIBC_VERSION
ENV GLIBC_VERSION ${GLIBC_VERSION:-2.34-r0}
ENV SERVER_PORT ${SERVER_PORT:-32910}

EXPOSE ${SERVER_PORT}/tcp
EXPOSE ${SERVER_PORT}/udp

COPY --from=builder /home/law/snell-server .
COPY --from=builder /home/law/snell-server.conf .

RUN mv snell-server /usr/local/bin/

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk && \
    apk add glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk && \
    apk add --no-cache libstdc++ && \
    rm -rf glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk /etc/apk/keys/sgerrand.rsa.pub /var/cache/apk/*

ENTRYPOINT ["snell-server"]
CMD ["-c","snell-server.conf"]


# docker构建 
# docker build \
# -f snell.dockerfile \
# --build-arg SNELL_VERSION=2.0.6 \
# --build-arg GLIBC_VERSION=2.34-r0 \
# --build-arg SERVER_PORT=32910 \
# -t snelltest:2.0.6 \
# .

# 测试
# docker run -d --name test --entrypoint /bin/sh snelltest:2.0.6 -c "sleep infinity"

# 运行
# 注意映射container中暴露的端口
# docker run \
# -d \
# --name snell-server \
# --restart=always \
# -P \
# snelltest:2.0.6 