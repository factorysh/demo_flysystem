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

fixture: .mc
	docker-compose -f docker-compose.yml -f dev.yml run --rm fixture alias set flysystem http://minio:9000 AKIAIOSFODNN7EXAMPLE wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY --api S3v4
	docker-compose -f docker-compose.yml -f dev.yml run --rm fixture alias ls
	docker-compose -f docker-compose.yml -f dev.yml run --rm fixture mb --ignore-existing flysystem/demo-flysystem
	docker-compose -f docker-compose.yml -f dev.yml run --rm fixture ls flysystem

clean:
	rm -rf vendor