#!/bin/bash

DB_NAME="jobfitscore"
JSON_DIR="."

mongoimport --db $DB_NAME --collection usuarios --file $JSON_DIR/usuarios.json --jsonArray
mongoimport --db $DB_NAME --collection empresas --file $JSON_DIR/empresas.json --jsonArray
mongoimport --db $DB_NAME --collection habilidades --file $JSON_DIR/habilidades.json --jsonArray

mongoimport --db $DB_NAME --collection vagas --file $JSON_DIR/vagas.json --jsonArray
mongoimport --db $DB_NAME --collection cursos --file $JSON_DIR/cursos.json --jsonArray

mongoimport --db $DB_NAME --collection usuario_habilidade --file $JSON_DIR/usuario_habilidade.json --jsonArray
mongoimport --db $DB_NAME --collection candidaturas --file $JSON_DIR/candidaturas.json --jsonArray
mongoimport --db $DB_NAME --collection vaga_habilidade --file $JSON_DIR/vaga_habilidade.json --jsonArray

echo "Importação concluída!"
