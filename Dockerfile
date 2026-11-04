FROM golang:1.22 AS build

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY main.go parcel.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -o /runtime/app/parcel-tracker .

# SQLite needs the supplied database, including its schema.
COPY tracker.db /runtime/app/tracker.db

FROM scratch

COPY --from=build --chown=65532:65532 /runtime/ /
WORKDIR /app
USER 65532:65532

CMD ["/app/parcel-tracker"]
