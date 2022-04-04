#!/bin/bash
cd html
echo 'Bienvenido al script de descarga de wordpress'
echo 'Por favor ingrese el nombre del directorio del proyecto'
read nombreProyecto
wget -c https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
mv wordpress $nombreProyecto
# rm latest.tar.gz
{ \
	echo '# BEGIN WordPress'; \
	echo ''; \
	echo 'RewriteEngine On'; \
	echo 'RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]'; \
	echo 'RewriteBase /'; \
	echo 'RewriteRule ^index\.php$ - [L]'; \
	echo 'RewriteCond %{REQUEST_FILENAME} !-f'; \
	echo 'RewriteCond %{REQUEST_FILENAME} !-d'; \
	echo 'RewriteRule . /index.php [L]'; \
	echo ''; \
	echo '# END WordPress'; \
} > ./$nombreProyecto/.htaccess;

# docker-compose restart

docker exec php-openjuy chown -R www-data:www-data /var/www/html/$nombreProyecto

echo 'Ingrese el nombre del dominio del proyecto, sin www'
read dominio

echo 'docker exec -t cerbot certonly --webroot --webroot-path=/var/www/html/argenyx --email openjuy@gmail.com --agree-tos --no-eff-email --staging -d $dominio -d www.$dominio'

echo 'Ingrese el password de root mysql'
read dbPass
echo "Ingrese el password de ${nombreProyecto}dba en mysql"
read dbPassUser

{ \
	echo "CREATE DATABASE ${nombreProyecto}db;"; \
	echo "CREATE USER '${nombreProyecto}dba'@'%' identified by '${dbPassUser}';"; \
	echo "GRANT ALL ON ${nombreProyecto}db.* TO '${nombreProyecto}dba'@'%';"; \
	echo "SHOW DATABASES;"; \
} > usersdatabases.sql

docker exec -it db-openjuy mysql -u root -p$dbPass -e "$(cat ./usersdatabases.sql)"
cat usersdatabases.sql
rm usersdatabases.sql

# Configuracion de dominio
cd ..
cat .docker/dominios.conf >> nginx-conf/nginx.conf
serverName="server_name ${dominio} www.${dominio};"
varRoot="root \/var\/www\/html\/${nombreProyecto};"
sed -i "s/reemplazarDominios/$serverName/g" ./nginx-conf/nginx.conf
sed -i "s/reemplazarProyecto/$varRoot/g" ./nginx-conf/nginx.conf

docker restart nginx-openjuy
docker-compose ps
echo 'Se finalizo con exito'
