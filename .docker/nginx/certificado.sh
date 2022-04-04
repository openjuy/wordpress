correo=$1
dominio=$2
certbot --nginx --non-interactive --agree-tos -m $correo -d $dominio -d www.$dominio
