#!/bin/bash
# 21.12.2021, Stein Arne Storslett
# Convert from PFX to PEM
# NB! Usually requires password

# openssl pkcs12 -in my.hostname.com.pfx -out my.hostname.com.crt -nokeys
# cat my.hostname.com.crt  | openssl x509 -noout -text | less
# openssl pkcs12 -in my.hostname.com.pfx -out my.hostname.com.key.crt
# openssl rsa -in my.hostname.com.key.crt -out my.hostname.com.key

PFXFILE=$1

usage () {
    echo "usage: pfx-to-pem.sh <pfxfile>"
    exit 1
}

if [ $# -ne 1 ]
then
    usage
fi

if [ ! -f ${PFXFILE} ]
then
    echo "File \"${PFXFILE}\" does not exist or is not a file." >&2
    exit 1
fi

if [ ${PFXFILE##*.} != "pfx" ]
then
    echo "File \"${PFXFILE}\" does not have a pfx suffix." >&2
    exit 1
fi

CRTFILE=${PFXFILE%.pfx}.crt
KEYCRTFILE=${PFXFILE%.pfx}.key.crt
KEYFILE=${PFXFILE%.pfx}.key

/bin/rm -f ${CRTFILE} ${KEYCRTFILE} ${KEYFILE}

#
# Extract the certificate, convert from pkcs12 to PEM
#
echo -e "Extracting certificate from ${PFXFILE} to ${CRTFILE}.\nEnter the PFX-file password."
openssl pkcs12 -in ${PFXFILE} -out ${CRTFILE} -nokeys || exit $?

#
# Extract the certifcate key
# Password is removed to make the key work with webservers
# such as nginx and apache
#
echo -e "\nExtracting key from ${PFXFILE} to ${KEYCRTFILE} (with password).\nEnter the PFX-file password."
openssl pkcs12 -in ${PFXFILE} -out ${KEYCRTFILE} || exit $?
echo -e "\nConverting key from PKCS12 in ${KEYCRTFILE} to PEM in ${KEYFILE} (removing password)\nEnter the PFX-file password."
openssl rsa -in ${KEYCRTFILE} -out ${KEYFILE} || exit $?


chmod 600 ${CRTFILE} ${KEYCRTFILE} ${KEYFILE}

echo "
Input PFX-File: ${PFXFILE}
Extracted PKCS12 KEY-File: ${KEYCRTFILE}

Copy the following files to your destination:
CRT-File: ${CRTFILE}
KEY-File: ${KEYFILE}

#
# Certificate details for ${CRTFILE}:
#
$(cat ${CRTFILE} |
    openssl x509 -noout -text |
    awk '/ (Subject|Issuer|Not (Before|After)) *:/ { sub(/^\W+/,"") ; print }')

#
# Verifying keyfile ${KEYFILE}
#
$(cat ${KEYFILE} |
    openssl rsa -check 2>&1 |
    sed '/^-----BEGIN/,$d')
"
