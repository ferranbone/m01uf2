#!/bin/bash
PORT="2022"
echo "Cliente de Dragon Magia Abuelita Miedo 2022"
echo "1.ENVIO DE CABECERA"
echo "DMAM" | nc 127.0.0.1 $PORT
DATA=`nc -l $PORT`
echo "3.COMPROBANDO"
if [ "$DATA" != "OK_HEADER" ]
then
	echo "ERROR"
	exit 1
fi
echo "4. COMPROBANDO HEADER"
FILE_NAME="dragon.txt"
echo "FILE_NAME $FILE_NAME" | nc 127.0.0.1 $PORT
echo "7. RECIBIENDO"
DATA=`nc -l $PORT`
