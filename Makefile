# flex-spa-stack makefile

# vars
OK_COLOR=\033[32;01m
NO_COLOR=\033[0m

# commands
volume_dirs :
	sudo mkdir -p \
		data/grafana \
		data/mysql \
		data/postgres \
		data/sentry \
		data/whisper \
		log/graphite/webapp \
		log/nginx \
		log/cron \
		log/supervisor

repos :
	@if [ ! -d backend-app ]; then git clone https://github.com/devpride/flex-spa-backend.git backend-app && cp ./backend-app/.env.dist ./backend-app/.env; fi;
	@if [ ! -d frontend-app ]; then git clone https://github.com/devpride/react-universally.git frontend-app; fi;

envs :
	@if [ ! -f .env ]; then cp .env.dist .env; fi;

hosts_up :
	# services
	./bin/add_host.sh 127.0.0.1 flex-spa.dev
	./bin/add_host.sh 127.0.0.1 m.flex-spa.dev
	./bin/add_host.sh 127.0.0.1 api.flex-spa.dev
	./bin/add_host.sh 127.0.0.1 admin.flex-spa.dev
	./bin/add_host.sh 127.0.0.1 phpmemadmin.flex-spa.dev
	./bin/add_host.sh 127.0.0.1 phpredisadmin.flex-spa.dev
	./bin/add_host.sh 127.0.0.1 elastichq.flex-spa.dev
	./bin/add_host.sh 127.0.0.1 rabbitmqadmin.flex-spa.dev
	./bin/add_host.sh 127.0.0.1 grafana.flex-spa.dev
	./bin/add_host.sh 127.0.0.1 sentry.flex-spa.dev
	# internal tools
	./bin/add_host.sh 127.0.0.1 mysql.flex-spa.dev
	./bin/add_host.sh 127.0.0.1 redis.flex-spa.dev
	./bin/add_host.sh 127.0.0.1 memcached.flex-spa.dev
	./bin/add_host.sh 127.0.0.1 statsd.flex-spa.dev
	./bin/add_host.sh 127.0.0.1 graphite.flex-spa.dev
	./bin/add_host.sh 127.0.0.1 elasticsearch.flex-spa.dev
	./bin/add_host.sh 127.0.0.1 rabbitmq.flex-spa.dev
	./bin/add_host.sh 127.0.0.1 memcached.sentry.flex-spa.dev
	./bin/add_host.sh 127.0.0.1 redis.sentry.flex-spa.dev
	./bin/add_host.sh 127.0.0.1 postgres.sentry.flex-spa.dev
	./bin/add_host.sh 127.0.0.1 smtp.sentry.flex-spa.dev

hosts_down :
	# remove all flex-spa hosts
	./bin/remove_host.sh flex-spa.dev

up : volume_dirs envs hosts_up repos permissions
	sudo docker-compose up --build -d

dependencies :
	# install dependencies for backend app
	sudo docker-compose exec -T backend composer install
	# post-install for phpmemadmin
	sudo docker-compose exec -T phpmemadmin composer install
	sudo docker-compose exec phpmemadmin sh -c 'sed -i "s/127.0.0.1/$$MEMCACHED_HOST/g" app/.config.dist && sed -i "s/11211/$$MEMCACHED_PORT/g" app/.config.dist'
	sudo docker-compose stop phpmemadmin
	sudo docker-compose up --build -d phpmemadmin

nuclear : down
	sudo rm -rf ./data ./log ./backend-app/src/Migrations/*.php
	sudo docker volume prune

data :
	# generate db schema migration and migrate it
	sudo docker-compose exec -T backend_web php bin/console doctrine:migrations:diff
	sudo docker-compose exec -T backend_web php bin/console doctrine:migrations:migrate
	# load demo fixtures to database
	sudo docker-compose exec -T backend_web php bin/console doctrine:fixtures:load
	# populate mysql data to elastic indexes according to app mappings
	sudo docker-compose exec -T backend_web php bin/console fos:elastica:populate
	# init sentry db
	sudo docker-compose run --rm sentry_web upgrade

tests :
	sudo docker-compose exec -T backend_web php bin/phpunit

jwt :
	sudo docker-compose exec -T backend openssl genrsa -out config/jwt/private.pem -aes256 4096
	sudo docker-compose exec -T backend openssl rsa -pubout -in config/jwt/private.pem -out config/jwt/public.pem

down : hosts_down
	sudo docker-compose down

permissions :
	sudo chmod -R 777 ./backend-app/

re :
	sudo docker-compose stop $(C)
	sudo docker-compose up --build -d $(C)

shell :
	sudo docker-compose exec $(C) /bin/bash

tail :
	sudo docker-compose logs -f $(C)

install : up dependencies jwt data permissions tests

.PHONY: volume_dirs repos envs hosts_up hosts_down up dependencies nuclear data tests jwt down permissions re shell tail install
