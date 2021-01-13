#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page


if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "httpd" ]]; then
    

    . /apache-init.sh
    . /wordpress-init.sh

    nami_initialize apache mysql-client wordpress
    info "######################################"
    info "          Availale  Plugins"
    info "######################################"
    su daemon -s /bin/bash -c '/opt/bitnami/wp-cli/bin/wp plugin list'

    info "######################################"
    info "          Availale Themes"
    info "######################################"
    su daemon -s /bin/bash -c '/opt/bitnami/wp-cli/bin/wp theme list'


    info "######################################"
    info "          Activating Extras"
    info "######################################"
    
    
    # composer update  => just assign this in docker-compose files for each project
    # Configure this in the project .env file or environment option
    info "Loading composer.json ${COMPOSER_FILE}"
    if [[ -z "${COMPOSER_FILE}" ]] 
    then
        info "Extra Plugins Not Assigned"
    fi

    # THEME
    su daemon -s /bin/bash -c '/opt/bitnami/wp-cli/bin/wp theme activate ${WP_THEME}'
 
    # PLUGINS
    su daemon -s /bin/bash -c '/opt/bitnami/wp-cli/bin/wp plugin activate wp-migrate-db-pro'
    su daemon -s /bin/bash -c '/opt/bitnami/wp-cli/bin/wp plugin activate wp-migrate-db-pro-cli'
    su daemon -s /bin/bash -c '/opt/bitnami/wp-cli/bin/wp plugin activate wp-migrate-db-pro-media-files'
    su daemon -s /bin/bash -c '/opt/bitnami/wp-cli/bin/wp plugin activate wp-migrate-db-pro-theme-plugin-files'
    
    # su daemon -s /bin/bash -c '/opt/bitnami/wp-cli/bin/wp plugin activate bbpress'
    # LICENSE
    su daemon -s /bin/bash -c '/opt/bitnami/wp-cli/bin/wp migratedb setting update license ${MARIADB_LICENSE}'
    info "########################################################################"

    info "Starting wordpress gosu... "
    . /post-init.sh

fi

exec tini -- "$@"


