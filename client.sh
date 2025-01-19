#!/bin/bash
IP_SERVER=$1
IP=`ip a | grep "scope global" | xargs | cut -d " " -f 2 | cut -d "/" -f 1`
PORT="2022"
echo "Cliente de Dragon Magia Abuelita Miedo 2022"
echo "1.ENVIO DE CABECERA"
echo "DMAM $IP" | nc $IP_SERVER $PORT
DATA=`nc -l $PORT`
echo "3.COMPROBANDO"
if [ "$DATA" != "OK_HEADER" ]
then
	echo "ERROR"
	exit 1
fi
echo "4. COMPROBANDO HEADER"
read FILE_NAME
HASH=$(echo -n "$FILE_NAME" | md5sum | cut -d " " -f 1)
echo "FILE_NAME $FILE_NAME $HASH" | nc $IP_SERVER $PORT

echo "7. RECIBIENDO"
DATA=`nc -l $PORT`

if [ "$DATA" != "OK_FILE_NAME" ]
then
	echo "ERROR 2: el nombre es incorrecto"
	exit 2
fi

echo "8. ENVIANDO CONTENIDO"

cat client/$FILE_NAME | nc $IP_SERVER $PORT

echo "9. RECIBIENDO OK_DATA"
DATA=`nc -l $PORT´
if [ "$DATA" != "OK_DATA" ]
then
echo "ERROR 3: No se ha recibido OK_DATA"
exit 3
fi

echo "10. CALCULANDO MD5 DEL CONTENIDO DEL ARCHIVO"
FILE_MD5=$(md5sum client/$FILE_NAME | cut -d " " -f 1)
echo "FILE_MD5 $FILE_MD5" | nc $IP_SERVER $PORT
