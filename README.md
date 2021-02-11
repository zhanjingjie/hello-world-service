# Hello world service

This is a repo to demonstrate how to create a production-grade local development environment, built on top of Docker. 
The service is a simple Golang Hello World service. The same local environment setup can be easily applied to other languages as well. 

## How to get started

Build and run the service. Go to http://localhost:8080/ it should return "Hello world" as response.
```
make run
```

Run all the tests.
```
make test
```

Stop and remove the containers.
```
make clean
```
