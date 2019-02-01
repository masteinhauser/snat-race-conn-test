FROM golang:1.8 as build-env

# Download and install the latest release of dep
ADD https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64 /usr/bin/dep
RUN chmod +x /usr/bin/dep

WORKDIR /go/src/app
ADD ./app /go/src/app

RUN dep ensure --vendor-only

RUN go-wrapper download   # "go get -d -v ./..."
RUN go-wrapper install

FROM gcr.io/distroless/base:debug
COPY --from=build-env /go/bin/app /
EXPOSE 8080
ENTRYPOINT ["/app"]
