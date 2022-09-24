#!/bin/sh
openssl ocsp -index index.txt -rsigner OCSP.crt -rkey OCSP.pem -rmd sha256 -CA ca.crt -port 8888 -text
