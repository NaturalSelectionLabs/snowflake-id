FROM golang:1.22.4-alpine as base

WORKDIR /app

RUN --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=bind,source=go.sum,target=go.sum \
    --mount=type=bind,source=go.mod,target=go.mod \
    go mod download -x

COPY . .

FROM base as builder
ENV CGO_ENABLED=0
RUN --mount=type=cache,target=/go/pkg/mod/ \
    go build -o snowflake-id

FROM alpine:3.19 as runtime

COPY --from=builder /app/snowflake-id /usr/local/bin/snowflake-id

ENTRYPOINT ["/usr/local/bin/snowflake-id"]