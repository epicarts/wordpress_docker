#!/bin/bash
openssl genrsa 2048 > /openssl/server_pkey.pem # carete rsa key
openssl req -new -key /openssl/server_pkey.pem -out /openssl/csr.pem -config /openssl/csr.conf # create CSR from csr.conf
openssl x509 -req -days 365 -in /openssl/csr.pem -signkey /openssl/server_pkey.pem -out /openssl/server.crt # create self-signed CRT

echo "========= created self-signed CRT ========="

chmod 600 /openssl/server.crt /openssl/server_pkey.pem
mv /openssl/server.crt /etc/ssl/certs/server.crt
mv /openssl/server_pkey.pem /etc/ssl/private/server_pkey.pem

echo "========= moveed self-signed CRT ========="