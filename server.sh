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
FILE_NAME=$(echo $FILE_DATA | cut -d " " -f 2)
HASH_CLIENTE=$(echo $FILE_DATA | cut -d " " -f 3)

echo "5. COMPROBANDO"
if [ "$PREFIJO" != "FILE_NAME" ]
then
	echo "ERROR 2: Prefijo incorrecto"
	echo "KO_FILE_NAME" | nc $IP $PORT
	exit 2
fi 

HASH_SERVIDOR=$(echo -n "$FILE_NAME" | md5sum | cut -d " " -f 1)
if [ "$HASH_CLIENTE" != "$HASH_SERVIDOR" ]; then
    echo "ERROR 3: Hash incorrecto"
    echo "KO_FILE_NAME" | nc $IP $PORT
    exit 3
fi

echo "6. ENVIANDO OK_FILE_NAME"
echo "OK_FILE_NAME" | nc $IP $PORT

DATA=$(nc -l $PORT)

echo "7. RECIBIENDO CONTENIDO"
cat > server/$FILE_NAME
echo "OK_DATA" | nc $IP $PORT

echo "8. CALCULANDO MD5 DEL CONTENIDO DEL ARCHIVO"
FILE MD5=$(md5sum server/$FILE_NAME | cut -d " " -f 1)
DATA=`nc -l $PORT`
PREFIJO_MD5=$(echo $DATA | cut -d " " -f 1)
MD5_RECIBIDO=$(echo $DATA | cut -d " " -f 2)

if [ "$PREFIJO_MD5" != "FILE_MD5" ]
then
echo "ERROR 4: Prefijo FILE_MD5 incorrecto"
echo "KO_FILE_MD5" | nc $IP $PORT
exit 4
fi

if [ "MD5_RECIBIDO" != "$FILE_MD5" ]
then
echo "ERROR 5: El MD5 del contenido no coincide"
echo "KO_FILE_MD5" | nc $IP $PORT
exit 5
fi

echo "OK_FILE_MD5" | nc $IP $PORT
