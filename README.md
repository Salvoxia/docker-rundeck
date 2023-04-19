# Extended Rundeck Docker Image

This image extends the [Rundeck Docker Image](https://hub.docker.com/r/rundeck/rundeck) with some useful convenience functions. Since it does __not__ implement a complete separate way of running Rundeck inside a docker image, it is fully compatible with the official image.

The following functionality has been added to this image:
* [Installing custom plugins](#installing-custom-plugins)
* [Passing JVM arguments to rundeck process](#jvm-arguments-for-rundeck-process)
* [Running pre-start hook shell scripts](#pre-start-hook-scripts)

## Disclaimer
* Official Docker Image: [rundeck/rundeck](https://hub.docker.com/r/rundeck/rundeck) @ Docker Hub
* Official Github Repository: [rundeck/rundeck](https://github.com/rundeck/rundeck) @ GitHub


#### Upstream Links

* Docker Registry @ [salvoxia/rundeck](https://hub.docker.com/r/salvoxia/rundeck)
* GitHub @ [salvoxia/docker-rundeck](https://github.com/salvoxia/docker-rundeck)

### Cheat Sheet
__Build__ 
```bash
docker build -t salvoxia/rundeck:latest .
```
__Build Multi-Arch (buildx)__ 
 ```bash
 docker buildx create --name multi-platform-builder --platform linux/arm/v7,linux/arm64/v8,linux/amd64
 docker buildx build --builder multi-platform-builder -t salvoxia/rundeck:latest .
```

## Extended Functionality

### Installing custom plugins

To install custom plugins into the container on startup, you need to mount a volume containing the plugin `.jar` files into the container as the directory `/opt/rundeck-plugins`. The files in this folder will be copied over to `/home/rundeck/libext` inside the container.  
Example `docker-compose` file:
```docker-compose
version: "3"
services:
 rundeck:
   container_name: rundeck_oss
   image: salvoxia/rundeck:1.4.11.0
   ports:
     - 4440:4440
   environment:
     RUNDECK_GRAILS_URL: "http://localhost:4440"
   volumes:
     - rundeck/plugins:/opt/rundeck-plugins
```


### JVM arguments for Rundeck process

This docker image allows setting an environment variable `CUSTOM_RUNDECK_JVM_ARGS` containing a space separated list of JVM arguments to be passed to the Rundeck process on startup.  
The following example specifies the two JVM arguments `server.session.timeout` and `server.port`:
```docker-compose
version: "3"
services:
 rundeck:
   container_name: rundeck_oss
   image: salvoxia/rundeck:1.4.11.0
   ports:
     - 4440:4440
   environment:
     RUNDECK_GRAILS_URL: "http://localhost:4440"
     CUSTOM_RUNDECK_JVM_ARGS: "-Dserver.session.timeout=3600 -Dserver.port=8080"
   volumes:
     - rundeck/plugins:/opt/rundeck-plugins
```

### Pre-Start Hook Scripts

To perform any modifications to the configuration before starting the rundeck process, it is possible to mount a folder containing shell scripts into the container to `/opt/rundeck-prestart-hooks`. These scripts are sorted numerically (using `sort -n`) and executed one by one before the base image's entrypoint is launched.  
The pre-start hook scripts are executed __before__ custom plugins are installed. If this execution order is not right for your usecase, implement a pre-start hook scripts that performs plugin installation and name it so it is executed at the appropriate time for your use case.  
Example `docker-compose` file:
```docker-compose
version: "3"
services:
 rundeck:
   container_name: rundeck_oss
   image: salvoxia/rundeck:1.4.11.0
   ports:
     - 4440:4440
   environment:
     RUNDECK_GRAILS_URL: "http://localhost:4440"
   volumes:
     - rundeck/pre-start-hooks:/opt/rundeck-prestart-hooks
```

## Image Tag Versioning Scheme

This docker image extends on Rundeck's official docker image. It does not use their `SNAPSHOT` image, but a specified version.
The versioning scheme of this image consists of two versioning parts:
* Version of this image
* Version of the used Rundeck base image

Example: `1.4.11.0`
* Part 1: __1__.4.11.0 means version 1 of this extended image
* Part 2: 1.__4.11.0__ means this image extends on Rundeck's image version 4.11.0

