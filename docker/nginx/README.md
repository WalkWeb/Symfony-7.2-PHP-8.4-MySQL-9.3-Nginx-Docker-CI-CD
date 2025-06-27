
# Generate and setting https

On server:

`apt-get update`

`apt-get install letsencrypt`

Change you email and domain:

`certbot certonly --manual --preferred-challenges=dns --email your_mail@gmail.com --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d domain.com -d *.domain.com`

Then you need to set the DNS TXT record with specified string:

```
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name:

_acme-challenge.domain.com.

with the following value:

NxwzQlSUr3TwHFqiwe_BZzeOGodaR11QOtG8KqRu-0
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue

```

Create TXT record, wait 10-20 min and press Enter.

After this, you will need to create a DNS TXT record again:

```
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name:

_acme-challenge.domain.com.

with the following value:

NxwzQlSUr3TwHFqiwe_BZzeOGodaR11QOtG8KqRu-0
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name:

_acme-challenge.domain.com.

with the following value:

3hFdE_6e6Y943Hb3wkcIp67MGTnQGr3DWaECVFeingE

(This must be set up in addition to the previous challenges; do not remove,
replace, or undo the previous challenge tasks yet. Note that you might be
asked to create multiple distinct TXT records with the same name. This is
permitted by DNS standards.)

Before continuing, verify the TXT record has been deployed. Depending on the DNS
provider, this may take some time, from a few seconds to multiple minutes. You can
check if it has finished deploying with aid of online tools, such as the Google
Admin Toolbox: https://toolbox.googleapps.com/apps/dig/#TXT/_acme-challenge.domain.com.
Look for one or more bolded line(s) below the line ';ANSWER'. It should show the
value(s) you've just added.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue
```

Create TXT record again, and wait 10-20 min and press Enter.

You must see:

```
Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/domain.com./fullchain.pem
Key is saved at:         /etc/letsencrypt/live/domain.com./privkey.pem
This certificate expires on 2025-09-17.
These files will be updated when the certificate renews.

```

Copy ssl file to app directory:

`cp /etc/letsencrypt/archive/domain.com/fullchain1.pem /var/www/domain.com/docker/nginx/ssl/fullchain.pem`
`cp /etc/letsencrypt/archive/domain.com/privkey1.pem /var/www/domain.com/docker/nginx/ssl/privkey.pem`

Change nginx config (`/docker/nginx/conf.d/domain.conf`):

```
    # Remove this line after create ssl sertificate
    listen       80;

    # Uncommit after create ssl sertificate (look README.md)
    #listen 443 ssl;
    #ssl_certificate "/etc/nginx/ssl/fullchain.pem";
    #ssl_certificate_key "/etc/nginx/ssl/privkey.pem";
```

To:

```
    listen 443 ssl;
    ssl_certificate "/etc/nginx/ssl/fullchain.pem";
    ssl_certificate_key "/etc/nginx/ssl/privkey.pem";
```

And set your domain name:

```
    server_name domain.com;
```

And restart app:

`docker compose restart`

## Notice #1

You can also add a redirect from http to https. Change file `/docker/nginx/conf.d/http_domain.conf]`:

```
server {
    listen       80;
    server_name  domain.com;
    return       301 https://domain.com$request_uri;
}
```

And set your domain name and restart app.

## Notice #2

Remember that in order to be able to access the domain, it must be registered in `/etc/hosts`, example:

For developer PC:

```
127.0.0.1 app.loc
```

For public server:

```
127.0.0.1 domain.com
```
