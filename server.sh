#!/bin/bash
PORT="2022"
echo "Servidor de Dragon Magia Abuelita Miedo 2022"
echo "0. ESCUCHAMOS"
DATA=`nc -l $PORT`
HEADER=`echo $DATA | cut -d " " -f 1`
IP=`echo $DATA | cut -d " " -f 2`
if [ "$HEADER" != "DMAM" ]
then
    echo "ERROR 1: Cabecera incorrecta"
    echo "KO_HEADER" | nc $IP 2022
    exit 1
fi
echo "2. CHECK OK - Enviando OK_HEADER"
echo "OK_HEADER" | nc $IP 2022
FILE_DATA=$(nc -l $PORT)
PREFIJO=$(echo $FILE_DATA | cut -d " " -f 1)
echo "5. COMPROBANDO"
if [ "$PREFIJO" != "FILE_NAME" ]
then
	echo "ERROR 2: Prefijo incorrecto"
	echo "KO_FILE_NAME" | nc $IP $PORT
	exit 2
fi 

echo "6. ENVIANDO OK_FILE_NAME"
echo "OK_FILE_NAME" | nc $IP $PORT

DATA=`nc -l $PORT`

FILE_NAME=$(cat nombre.txt)
echo "$DATA" > server/$FILE_NAME
cat server/$FILE_NAME
