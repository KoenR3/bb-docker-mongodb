#!/bin/bash

USER=${MONGODB_USER:-"$MONGO_USER"}
DATABASE=${MONGODB_DATABASE:-"admin"}
PASS=${MONGODB_PASS:-"$MONGO_PASS"}

mongod&

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup"
    sleep 5
    mongo admin --eval "help" >/dev/null 2>&1
    RET=$?
done

echo "=> Creating an ${USER} user with a password in MongoDB"
mongo admin --eval "db.createUser({user: '$USER', pwd: '$PASS', roles:[{role:'root',db:'admin'}]});"

if [ "$DATABASE" != "admin" ]; then
    echo "=> Creating an ${USER} user with a ${_word} password in MongoDB"
    mongo admin -u $USER -p $PASS << EOF
use $DATABASE
db.createUser({user: '$USER', pwd: '$PASS', roles:[{role:'dbOwner',db:'$DATABASE'}]})
EOF
fi

echo "=> Done!"
