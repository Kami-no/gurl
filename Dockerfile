# build stage
FROM golang:1.21-bookworm AS build

WORKDIR /opt/build

COPY ["go.mod", "go.sum", "./"]
RUN go mod download

COPY . .
RUN go test ./... \
    && CGO_ENABLED=0 go build -a -tags 'netgo' -ldflags '-s -w' -o bat

# artefact stage
# hadolint ignore=DL3007
FROM gcr.io/distroless/static-debian12:latest

COPY --from=build /opt/build/bat /usr/local/bin/bat
USER 1000
CMD ["bat"]
