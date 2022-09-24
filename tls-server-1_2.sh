#!/bin/sh
openssl s_server -cert localhost.crt -key localhost.pem -www -port 443 -tls1_2 -msg
