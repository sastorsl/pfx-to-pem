# pfx-to-pem

So you've received your shiny certificate, and it's in a PFX, with a password.

This won't do in a lot of software, such as apache, nginx or haproxy.

This script will take your certificate as input, ask for you password, and then output the certificate and it's keyfile - without passwords.

# Usage

```bash
usage: pfx-to-pem.sh <pfxfile>
```

# Example

```bash
$ pfx-to-pem.sh myhostname.com.pfx.pfx 
Extracting certificate from myhostname.com.pfx.pfx to myhostname.com.pfx.crt
Enter Import Password:

Extracting key from myhostname.com.pfx.pfx to myhostname.com.pfx.key.crt (with password)
Enter Import Password:
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:

Converting key from PKCS12 in myhostname.com.pfx.key.crt to PEM in myhostname.com.pfx.key (removing password)
Enter pass phrase for myhostname.com.pfx.key.crt:
writing RSA key

Input PFX-File: myhostname.com.pfx.pfx
Extracted PKCS12 KEY-File: myhostname.com.pfx.key.crt

Copy the following files to your destination:
CRT-File: myhostname.com.pfx.crt
KEY-File: myhostname.com.pfx.key

Certificate details:
Issuer: <issuer>
Not Before: Nov 17 09:29:40 2022 GMT
Not After : Dec 11 22:59:00 2023 GMT
Subject: <subject>

```
