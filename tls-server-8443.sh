#!/bin/sh
openssl s_server -cert localhost.crt -key localhost.pem -www -port 8443 -msg
