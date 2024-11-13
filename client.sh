#!/bin/bash
PORT="2022"
echo "Cliente de Dragon Magia Abuelita Miedo 2022"
echo "1.ENVIO DE CABECERA"
echo "DMAM" | nc 127.0.0.1 $PORT
DATA=`nc -l $PORT`
if [ "$DATA" != "OK_HEADER" ]
then
	echo "ERROR"
	exit 1
fi
echo "Dime nombre del archivo"
read FILE_NAME
echo "FILE_NAME $FILE_NAME" | nc 127.0.0.1 $PORT
