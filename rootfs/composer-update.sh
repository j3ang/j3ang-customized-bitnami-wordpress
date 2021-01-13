#!/bin/bash 

sudo apt-get install jq -y
req=$(jq '.require | keys[] as $k | "\($k)" ' composer.json)

echo 'Updating composer ...'
for k in $req; do
    # Plugin Name
    plugin=$(echo "$k" | cut -d '/' -f 2 | cut -d '"' -f 1)
    
    # Vendor / Plugin Name
    venderPlugin=$(echo "$k" | sed -e 's/^"//' -e 's/"$//')
    
    # active=$(su daemon -s /bin/bash -c "/opt/bitnami/wp-cli/bin/wp plugin is-active $plugin")
    
    echo "Checking if $plugin is installed ..."
    if [ ! -d "/opt/bitnami/wordpress/wp-content/plugins/$plugin" ]; then
        echo "$venderPlugin is not installed. Composer requiring ..."
        composer require "$venderPlugin" 
        su daemon -s /bin/bash -c "/opt/bitnami/wp-cli/bin/wp plugin activate $plugin"
    fi
       
    su daemon -s /bin/bash -c "/opt/bitnami/wp-cli/bin/wp plugin activate $plugin"

done