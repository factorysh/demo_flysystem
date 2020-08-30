images: front app

front:
	docker build \
		-t demo_flysystem_front \
		-f Dockerfile.front \
		.

app: vendor
	docker build \
		--build-arg UID=`id -u`\
		-t demo_flysystem_app \
		-f Dockerfile.app \
		.

data:
	mkdir -p data

vendor:
	docker run -t --rm \
		-u `id -u`\
		-v `pwd`:/src \
		-v ${HOME}/.composer:/.composer \
		-w /src \
		bearstech/php-composer:7.3 \
		composer install

up: data
	docker-compose up -d --remove-orphans
	docker-compose ps

dev: data
	docker-compose -f docker-compose.yml -f dev.yml up -d --remove-orphans
	docker-compose -f docker-compose.yml -f dev.yml ps
	docker-compose -f docker-compose.yml -f dev.yml logs -f

.mc:
	mkdir -p .mc


mc=docker-compose -f docker-compose.yml -f dev.yml run --rm fixture
fixture: .mc
	${mc} alias set flysystem http://minio:9000 AKIAIOSFODNN7EXAMPLE wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY --api S3v4
	${mc} alias ls
	${mc} mb --ignore-existing flysystem/demo-flysystem
	${mc} ls flysystem
	${mc} policy set download flysystem/demo-flysystem
	${mc} policy get flysystem/demo-flysystem

clean:
	rm -rf vendor