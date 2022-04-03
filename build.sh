echo 'Ingrese el password del root MYSQL'
read passMYSQL
echo "MYSQL_ROOT_PASSWORD=${passMYSQL}" > .env
FILE=./html
FILE2=./nginx-conf
if [ -f "$FILE" ]; then
    echo "El directorio html ya existe"
else 
    echo "El directorio html no existe"
    mkdir html
fi

if [ -f "$FILE2" ]; then
    echo "El directorio nginx-conf ya existe"
else 
    echo "El directorio nginx-conf no existe"
    mkdir nginx-conf
fi
cd .docker/php
docker build -t php-openjuy .
cd ../nginx
docker build -t nginx-openjuy .
cd ../..
docker-compose up -d
