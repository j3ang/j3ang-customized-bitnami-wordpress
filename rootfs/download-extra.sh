#!/bin/bash -e



curl -o /tmp/bbpress.2.6.4.zip https://downloads.wordpress.org/plugin/bbpress.2.6.4.zip
curl -o /tmp/gambit.1.6.5.zip https://downloads.wordpress.org/theme/gambit.1.6.5.zip
unzip /tmp/bbpress.2.6.4.zip -d /opt/bitnami/wordpress/wp-content/plugins
unzip /tmp/gambit.1.6.5.zip -d /opt/bitnami/wordpress/wp-content/themes

apt-get update -y
apt-get install nano git zsh rpl bash-completion -y

# Install migrate-db pro in composer.json 
# composer install

# =================================================================
#   Set up oh my zsh
# =================================================================

# install oh-my-zsh
curl -o /tmp/install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh && sh /tmp/install.sh

#switch theme
rpl "robbyrussell" "fino" ~/.zshrc  # root
touch /bitnami/.zshrc
rpl "robbyrussell" "bira" /bitnami/.zshrc  # user: bitnami 
