#!/bin/bash
fecha=$(date +%Y%m%d)
if [ -d $fecha ]
then
    echo "ya existe la carpeta"
else
    mkdir $fecha
    mongoexport -d buda -c contratacionesabiertas --out $fecha/contratacionesabiertas_bulk.json --jsonArray
    mongoexport -d buda -c Records --out $fecha/contratacionesabiertas_bulk.csv --type=csv --fieldFile fieldFile.txt
    mongoexport -d buda -c contratacionesabiertas --out $fecha/contratacionesabiertas.json
    mongoexport -d buda -c Records --out $fecha/Records.json
    mongoexport -d edca -c Releases_SFP --out $fecha/Releases_SFP.json
    mongoexport -d buda -c parties --out $fecha/parties.json
    python export_mongo_data_chunks.py
    zip $fecha/contratacionesabiertas_bulk_paquetes.json.zip contratacionesabiertas_bulk_paquete*.json
    zip $fecha/contratacionesabiertas_bulk_paquetes.csv.zip contratacionesabiertas_bulk_paquete*.csv
    zip $fecha/edcas$fecha.zip $fecha/contratacionesabiertas.json $fecha/parties.json $fecha/Releases_SFP.json $fecha/Records.json
    zip $fecha/contratacionesabiertas_bulk.json.zip $fecha/contratacionesabiertas_bulk.json
    zip $fecha/contratacionesabiertas_bulk.csv.zip $fecha/contratacionesabiertas_bulk.csv
    rm *.json
    rm *.csv
    echo "listo!"
fi
