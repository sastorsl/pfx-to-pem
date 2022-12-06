# pfx-to-pem

So you've received your shiny certificate, and it's in a PFX, with a password.

This won't do in a lot of software, such as apache, nginx or haproxy.

This script will take your certificate as input, ask for you password, and then output the certificate and it's keyfile - without passwords.

# Usage

```bash
usage: pfx-to-pem.sh <pfxfile>
```
