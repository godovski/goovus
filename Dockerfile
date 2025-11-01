# Dockerfile.alpine
FROM golang:1.25-alpine AS builder

ARG DATE
ARG VERSION

RUN apk update
RUN apk add git

WORKDIR /app
COPY  go.mod go.sum main.go vanity_server.go vanity_template.go functions.go conf.go ./
COPY .git/ ./.git

ENV CGO_ENABLED=0
ENV GOOS=linux
RUN go build -o goovus

FROM alpine:3.22

WORKDIR /root/
COPY --from=builder /app/goovus  .

CMD ["./goovus", "-s"]