openssl s_server -cert localhost.crt -key localhost.pem -www -Verify 1 -port 443 -CAfile ca.crt -msg
