# Dockerfile.alpine
FROM golang:1.25-alpine AS builder

RUN apk update
RUN apk add git

WORKDIR /app
COPY  build.sh go.mod go.sum main.go vanity_server.go vanity_template.go functions.go conf.go ./
COPY .git/ ./.git

RUN CGO_ENABLED=0 GOOS=linux ./build.sh

FROM alpine:3.22

WORKDIR /root/
COPY --from=builder /app/goovus  .

CMD ["./goovus", "-s"]