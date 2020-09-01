FROM alpine:3.12

WORKDIR /snapshot

ENV S3_BUCKET=
ENV PATH_PREFIX=

ENV CONSUL_HTTP_ENDPOINT=
ENV CONSUL_SCHEME=
ENV CONSUL_HOST=
ENV CONSUL_PORT=

RUN apk --no-cache update && \
    apk --no-cache add python3 py3-pip unzip curl

RUN pip3 --no-cache-dir install awscli

RUN curl -o consul.zip https://releases.hashicorp.com/consul/1.8.3/consul_1.8.3_linux_amd64.zip && \
    unzip consul.zip && \
    mv consul /usr/local/bin/consul && \
    rm consul.zip

COPY utils.sh backup.sh restore.sh ./

ENTRYPOINT [ "/bin/sh", "-c", "./backup.sh" ]