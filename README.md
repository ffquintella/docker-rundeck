# docker-rundeck
Job Scheduler Manager

# Table of Contents

This container contains the Rundeck Job Scheduler server installation based on Linux Centos 7 & puppet.

## Supported tags

Current branch: latest

*  `2.7.1.1`

For previous versions or newest releases see other branches.

## Introduction

Rundeck is a jobseduler with interdependeces and a nice GUI (http://rundeck.org)

### Version
* Version: `2.7.1.1` - Latest: First version


## Installation

Pull the image from docker hub.

```bash
docker pull ffquintella/docker-rundeck:latest
```

Alternately you can build the image locally.

```bash
git clone https://github.com/ffquintella/docker-rundeck.git
cd docker-rundeck
./build.sh
```

## Quick Start

Not written yet.

## Configuration

### Data Store

Not written yet.

### User

No special users

### Ports

Next ports are exposed

* `8080/tcp` - default port


### Entrypoint

We use puppet as the default entry point to manage the environment

*Service is launched in background. Which means that is possible to restart without restarting the container.*

### Hostname

It is recommended to specify `hostname` for this image.

### SSL certs
The image is configured to use /etc/pki/tls/certs as the base ssl cert configuration. Java will use /etc/pki/tls/certs/java/cacerts as it's keychain.

If you want to add more certs to it ou can mount this file.

### Basic configuration using Environment Variables

> Some basic configurations are allowed to configure the system and make it easier to change at docker command line


## Upgrade from previous version

Basically stop your running container;

Docker pull latest version

Start a new instance with the new image (backup your data dir)

## Credits

My thanks to the following

- The Rundeck guys for providing this application
- Every one who worked building docker
- Github for the dvcs support
- Puppet guys for the great tool