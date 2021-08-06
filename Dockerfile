# build stage
FROM golang:1.13 as builder
#FROM golang:rc-stretch@sha256:c4be0000340e6a3bfbad5a42a7bf01cd453c8abfa1109d63b70f8f62d64ef4d9 as builder

ENV GO111MODULE=on

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN #CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build
RUN env CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build

# final stage
FROM scratch

COPY --from=builder /app/imagepullsecret-patcher /app/

ENTRYPOINT ["/app/imagepullsecret-patcher"]