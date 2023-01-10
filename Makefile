.PHONY: run test clean
default: run

HTTP_PORT = 8080

# Rebuild the Golang service inside the long running container.
# The -it flags are needed here to properly send the ctr+C signal to the process inside the container.
# The "reflex -s" will watch all changes, and rerun the command "go run ..." when a file is saved.
# This will greatly save development time. So you only need to run "make run" once. No need to "ctr+C" or "make clean" in between.
run: run-base
	@docker exec -it helloworld-service reflex -s go run /go/src/app/main.go

# Run all the tests
test: run-base
	@docker exec helloworld-service go test -cover ./...

# Remove the container.
clean:
	@docker stop helloworld-service && docker rm helloworld-service || exit 0

# run-base: Create a long running container in the background.
run-base:
	@if [ "$(shell docker ps --filter=name=helloworld-service -q)" = "" ]; then \
		docker build --target builder -t helloworld-service-base . && \
		docker run \
			-p 0.0.0.0:$(HTTP_PORT):$(HTTP_PORT)/tcp \
			-v $(shell pwd):/go/src/app \
			--name helloworld-service \
			-td helloworld-service-base; \
	fi;
