Flysystem Demo with object storage
==================================

[Flysystem](https://flysystem.thephpleague.com) is a PHP library for abstracting storage.

[S3](https://en.wikipedia.org/wiki/Amazon_S3), for Simple Storage Service, is a *de facto* standard for storing thing over HTTP.

[Minio](https://min.io/) is an open source object storage service, using S3 API. Other implementations exist, but *minio* is the simplest one for using with *docker-compose*.

Demo
----

Build all images

    make images

Launch all services

    make up

Open http://localhost:8000/ for the main website.

Minio private web UI url is http://localhost:9000/ account information are in the `.env` file.