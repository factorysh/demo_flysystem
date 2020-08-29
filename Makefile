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

clean:
	rm -rf vendor