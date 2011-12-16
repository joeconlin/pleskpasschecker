#!/bin/bash

# this will output the local mail users and passwords from the plesk db
output=$(/usr/local/psa/admin/bin/mail_auth_view " " 2>/dev/null)

# the following will fix the line escaping for the command output
OIFS="${IFS}"
NIFS=$'\n'
IFS="${NIFS}"

#iterate through the results and pass through cracklib
for LINE in ${output} ;
do
 if [[ ${LINE} == \|* ]]
 then
#     echo $LINE
    IFS="${OIFS}"
    usermail=$(echo ${LINE} | cut -f2 -d"|")
    userpass=$(echo ${LINE} | cut -f4 -d"|")
    crackresult=$( echo $userpass | cracklib-check )
    if [[ $crackresult != *OK ]]
    then
       echo $usermail - $crackresult
    fi
    IFS="${NIFS}"
 fi
done

