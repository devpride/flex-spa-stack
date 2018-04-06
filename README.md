# FlexSPA - dockerized single page application stack

## Table of Contents

- [Getting started](#getting-started)
- [Lifecycle](#lifecycle)
- [Service list](#service-list)
    - [Main services](#main-services)
    - [Internal service endpoints](#internal-service-enpoints)
- [Roadmap](#roadmap)
- [Docs](#docs)
- [Contributing](#contributing)

## Getting started

Just make few simple steps below:

```bash
git clone https://github.com/devpride/flex-spa-stack project_name
cd project_name
make install
```

Installation step will trigger some interactive prompt questions on which you must to answer for installation complete.

Some of them:

```bash
> Clickalicious\PhpMemAdmin\Installer::postInstall
Installer

Flags
  --verbose, -v  Turn on verbose output
  --version, -V  Display the version
  --quiet, -q    Disable all output
  --help, -h     Show this help screen

+----------------------------------------------------------------------+
| Installer                                                            |
| Version: $Id: 1479a0ed10f3f7489a0e9308c3046d7b397e5ab7 $             |
+----------------------------------------------------------------------+
  1. Install phpMemAdmin
  2. Quit 

Your choice: [Install phpMemAdmin]:
>> [PUSH ENTER] <<

Install to /var/www/phpmemadmin ? [Y/n]
>> [PUSH ENTER] <<

Installing ... -  (0:00, 0/s)                              

Installation of phpMemAdmin was successful.

...

sudo docker-compose exec -T backend openssl genrsa -out config/jwt/private.pem -aes256 4096
Generating RSA private key, 4096 bit long modulus
...........++
.....++
e is 65537 (0x10001)
Enter pass phrase for config/jwt/private.pem:
>> [PASTE 'API_JWT_PASSPHRASE' VALUE FROM .env FILE] <<

Verifying - Enter pass phrase for config/jwt/private.pem:
>> [PASTE 'API_JWT_PASSPHRASE' VALUE FROM .env FILE] <<

sudo docker-compose exec -T backend openssl rsa -pubout -in config/jwt/private.pem -out config/jwt/public.pem
Enter pass phrase for config/jwt/private.pem:
>> [PASTE 'API_JWT_PASSPHRASE' VALUE FROM .env FILE] <<

...
Created internal Sentry project (slug=internal, id=1)

Would you like to create a user account now? [Y/n]: y
Email: example@mail.com
Password: *****
Repeat for confirmation: ***** 
Should this user be a superuser? [y/N]: y
```

Open http://sentry.flex-spa.dev:1940/.

In Welcome screen put **http://sentry.flex-spa.dev:1940** as **Root URL**. Other fields and checkboxes are up to you.

Go to http://sentry.flex-spa.dev:1940/sentry/internal/settings/keys/, copy **DSN** and put it to your .env as **SENTRY_DSN** value.

Now update backend with:

```bash
make re C=backend && make re C=backend_web && make re C=backend_worker && make re C=backend_cron
```

That's all! Now you are able to use all stack features for developing and support needs of your SPA.

## Lifecycle

You should remember that FlexSPA run all containers in **detach mode** by default so you must shut it down manually by running:

```bash
make down
```

If you want make it up again, just run:

```bash
make up
```

## Service list
Services available out of the box:

#### Main services

- http://flex-spa.dev:1934/ - [frontend application](https://github.com/devpride/react-universally) web version
- http://m.flex-spa.dev:1934/ - [frontend application](https://github.com/devpride/react-universally) mobile version
- http://api.flex-spa.dev:1934/ - backend [REST API](https://github.com/devpride/flex-spa-backend)
- http://admin.flex-spa.dev:1934/ - application [admin panel](https://github.com/devpride/flex-spa-backend)
- http://phpmemadmin.flex-spa.dev:1935/ - [PhpMemAdmin](https://github.com/clickalicious/phpmemadmin)
(login: **admin**; password: **pass**)
- http://phpredisadmin.flex-spa.dev:1936/ - [PhpRedisAdmin](https://github.com/erikdubbelboer/phpRedisAdmin)
(login: **admin** (.env:REDIS_ADMIN_USER); password: **pass** (.env:REDIS_ADMIN_PASSWORD))
- http://elastichq.flex-spa.dev:1937/ - [ElasticHQ](https://github.com/ElasticHQ/elasticsearch-HQ)
(First time put **http://elasticsearch.flex-spa.dev:9200/** into input and press **Connect**)
- http://grafana.flex-spa.dev:1938/ - [Grafana](https://github.com/kamon-io/docker-grafana-graphite)
(login: **admin**; password: **admin**)
- http://graphite.flex-spa.dev:1939/ - [Graphite web GUI](https://github.com/kamon-io/docker-grafana-graphite)
- http://sentry.flex-spa.dev:1940/ - [Sentry](https://github.com/getsentry/docker-sentry)
- http://rabbitmqadmin.flex-spa.dev:15672/ - [RabbitMQ Management](https://www.rabbitmq.com/management.html)
(login: **user** (.env:RABBITMQ_USER); password: **password** (.env:RABBITMQ_PASSWORD))

#### Internal service endpoints

- mysql.flex-spa.dev:3306 - MySQL
- redis.flex-spa.dev:6379 - Redis (port from .env:REDIS_PORT)
- memcached.flex-spa.dev:11211 - Memcached (port from .env:MEMCACHED_PORT)
- statsd.flex-spa.dev:8125 - StatsD (port from .env:STATSD_PORT, on udp://)
- elasticsearch.flex-spa.dev:9200 - ElasticSearch (port from .env:ELASTICSEARCH_PORT)
- rabbitmq.flex-spa.dev:5672 - RabbitMQ (port from .env:RABBITMQ_PORT)
- memcached.sentry.flex-spa.dev:11211 - Memcached for Sentry
- redis.sentry.flex-spa.dev:6379 - Redis for Sentry
- postgres.sentry.flex-spa.dev:5432 - PostgreSQL for Sentry
- smtp.sentry.flex-spa.dev:25 - SMTP server for Sentry

## Roadmap

- Make demo SPA that use every service and feature for making all stack capabilities clear to understand.
- Update project documentation for all tools and services and make it more detail.
- General stability of builds
- Cover all services with functional tests
- Add healthcheck tools for stack features
- Add code coverage and auto-build check features

## Docs

- [Backend Application](https://github.com/devpride/flex-spa-backend/blob/master/README.md)
- [Frontend Application](https://github.com/devpride/react-universally/blob/master/README.md)
- [Commands](/docs/COMMANDS.md)

## Contributing

Yes, please ;) A lot of different work here. Together we could do it better. Feel free to make pull requests.
