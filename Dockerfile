# First Docker build stage (for local development). Install tools. Download Golang modules.
FROM golang:1.19-alpine AS builder
RUN go install github.com/cespare/reflex@latest
WORKDIR /go/src/app
# When there are go modules, uncomment these two lines.
# COPY go.mod go.sum ./
# RUN go mod download -x

# Second Docker build stage. Use the Golang image to build the Golang binary.
FROM builder AS binary
COPY . .
RUN go build -a -installsuffix -o main .

# Third Docker build stage. Copy the binary into a much smaller image - alpine. For faster and more secure distribution.
FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=binary /go/src/app/main .
CMD ["./main"]
