
# Executables (local)
DOCKER_COMP = docker compose

# Docker containers
PHP_CONT = $(DOCKER_COMP) exec app

# Executables
PHP      = $(PHP_CONT) php
COMPOSER = $(PHP_CONT) composer
SYMFONY  = $(PHP) bin/console

# ----------------------------------------------------------------------------------------------------------------------

install:
	cp .env.example .env
	@$(DOCKER_COMP) up -d

up:
	@$(DOCKER_COMP) up -d

down:
	@$(DOCKER_COMP) down --remove-orphans

rebuild:
	@$(DOCKER_COMP) up -d --build --remove-orphans

migration:
	@$(DOCKER_COMP) exec app php bin/console doctrine:migrations:migrate --no-interaction

cs:
	@$(DOCKER_COMP) exec -e PHP_CS_FIXER_IGNORE_ENV=1 app vendor/bin/php-cs-fixer fix src

stan:
	@$(DOCKER_COMP) exec app php vendor/bin/phpstan analyse src

rector:
	@$(DOCKER_COMP) exec app php vendor/bin/rector

phpunit:
	@$(DOCKER_COMP) exec -e APP_ENV=test app vendor/bin/phpunit

# See result coverage in var/phpunit/coverage directory
phpunit-coverage:
	@$(PHP) vendor/bin/phpunit --coverage-html var/phpunit/coverage

codeception:
	@$(DOCKER_COMP) exec -e APP_ENV=test codeception vendor/bin/codecept run

# See result coverage in tests/_output/coverage directory
coverage:
	@$(DOCKER_COMP) exec -e APP_ENV=test codeception vendor/bin/codecept run Api --coverage --coverage-html

cc:
	@$(DOCKER_COMP) exec app php bin/console c:c

test: cs stan rector codeception
