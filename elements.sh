#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
echo -e "Please provide an element as an argument."
exit 0
else
  if [[ $1 =~ ^[0-9]+$ ]]; then
  IS_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1;")
    if [[ -z $IS_ATOMIC_NUMBER ]]
    then
    echo -e "\nI could not find that element in the database."
    exit 0
    else
    COLUMN="atomic_number"
    DATA_QUERY=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE $COLUMN=$1;")
    fi
  else
  IS_SYMBOL=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1';")
  IS_NAME=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1';")
    if [[ -z $IS_SYMBOL ]]
    then
      if [[ -z $IS_NAME ]]
      then
        echo "I could not find that element in the database."
        exit 0
      else
      COLUMN="name"
      fi
    else
    COLUMN="symbol"
    fi
  DATA_QUERY=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE $COLUMN='$1';")
  fi
  echo $DATA_QUERY | while IFS="|" read TYPE_ID AT_NBR SYM NAM AT_MASS MELT BOIL TYPE
  do
    if [[ $TYPE_ID!="type_id" ]]
    then
    echo "The element with atomic number $AT_NBR is $NAM ($SYM). It's a $TYPE, with a mass of $AT_MASS amu. $NAM has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    fi
  done
fi