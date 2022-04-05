
echo 'Por favor ingrese el nombre del directorio del proyecto'
read nombreProyecto

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
