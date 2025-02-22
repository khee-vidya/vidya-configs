#!/bin/bash

# Check if correct number of arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <text_to_encrypt> <key>"
    echo "Example: $0 \"Hello World\" \"mysecretkey\""
    exit 1
fi

# Assign input parameters to variables
TEXT="$1"
KEY=$(echo -n "$2" | md5sum | awk '{print $1}')

# Function to base64 encode (similar to Kotlin's encode)
base64_encode() {
    echo -n "$1" | base64
}


# Perform AES-ECB encryption with PKCS5 padding
# OpenSSL uses PKCS5/PKCS7 padding by default
ENCRYPTED=$(echo -n "$TEXT" | openssl enc -aes-128-ecb -K "$KEY" -nopad 2>/dev/null | openssl enc -base64 -A)

# Check if encryption was successful
if [ $? -ne 0 ]; then
    echo "Error: Encryption failed"
    exit 1
fi

# Output results
echo "Original text: $TEXT"
echo "Original key: $KEY"
echo "Encrypted (base64): $ENCRYPTED"
echo
echo "To decrypt, use:"
echo "echo \"$ENCRYPTED\" | openssl enc -aes-128-ecb -d -base64 -A -K \"$KEY_HEX\""