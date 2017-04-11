# x86-64 dockerfile
#
# docker build -t x86-demo -f Dockerfile .
#
# docker run --rm -it -p 8080:8080 x86-demo

FROM ubuntu

RUN apt-get update && apt-get install -y curl

# install go
ENV GO_VERSION 1.8.1
RUN curl -fsSL "https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz" \
	| tar -xzC /usr/local

ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go

EXPOSE 8080

COPY christy.png /tmp/gopher.png
COPY server.go /tmp/server.go

RUN set -x \
	&& go build -o /usr/local/demo-server /tmp/server.go

ENTRYPOINT ["/usr/local/demo-server"]

