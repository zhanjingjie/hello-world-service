# Stage 1 of the multi-stage build. 
# Build the Golang binary.
FROM golang:1.15 AS builder
WORKDIR /go/src/app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Stage 2 of the multi-stage build.
# Copy the binary into a much small image - alpine. For faster and more secure distribution.
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/app/ .
CMD ["./main"]
