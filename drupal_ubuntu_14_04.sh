#!/bin/bash

echo 'started...'

echo 'Enter site name. (For example example.dev)'
read SITENAME

echo 'Downloading latest Drupal version...'

drush -y dl drupal --drupal-project-rename=$SITENAME
cd $SITENAME
drush site-install standard --db-url=mysql://root:root@localhost/$SITENAME --site-name=$SITENAME

echo 'Enable necessary standart modules...'
drush -y en php, contact, node, image, field_ui, profile, update, field_sql_storage, number, dashboard

drush -y dis toolbar
drush -y dis overlay

drush -y dl admin_menu
drush -y en admin_menu, admin_devel, admin_menu_toolbar

drush -y en views, views_ui

drush -y en views_php

drush -y en jquery_update

drush -y en field_group

drush -y en module_filter

drush -y en field_collection

drush -y en entityreference

drush -y en date

drush -y en date_popup

drush -y en date_views

drush -y en devel

drush -y en wysiwyg

echo 'Creating host...'
echo 'Copy yhis text to editor (CTRL/ins in terminal)'
echo '<VirtualHost *:80>'
echo '     	ServerAdmin webmaster@'$SITENAME
echo '		ServerName ' $SITENAME
echo '		DocumentRoot /home/alex/www/'$SITENAME
echo '		<Directory /home/alex/www/'$SITENAME'/>'
echo '			Options Indexes FollowSymLinks MultiViews
				AllowOverride All
				Require all granted
	        </Directory>

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>'
	
sudo gedit '/etc/apache2/sites-available/'$SITENAME'.conf'
sudo gedit /etc/hosts

sudo a2ensite $SITENAME'.conf'

echo 'Restarting Apache'

sudo service apache2 reload

echo 'Enter theme name:'
read SUBTHEME

echo 'Enter machine name (for ex machine_name)'
read MACHINE

echo 'Enter description'
read DESC

drush -y dl zen
drush -y en zen

drush -y cc all

drush -y zen $SUBTHEME $MACHINE --description=$DESC --without-rtl

sudo service apache2 reload

echo 'Drupal 7 base instalation completed! Visit your local site here:'
echo $SITENAME
echo ' Enjoy!'

exit
