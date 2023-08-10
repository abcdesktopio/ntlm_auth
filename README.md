# ntlm_auth

## Description


`ntlm_auth.abcdesktop.path` is a patch to add sso using file credentials to ntlm_auth binary.

`ntlm_auth` is used by firefox to get credentials

This patch uses a ramdom key NTLM_KEY and a hard coded key
You must change the hard coded key value then you build ntlm_auth.c
The password is encrypted with RC4 128 bits key (GNUTLS_CIPHER_ARCFOUR_128)
Each ntlm_auth call create a different key value NTLM_KEY
The NTLM_KEY is encrypted with the hard coded key
Make the ntlm_auth chmod to 111.

> Remember that this is only a patch to make it works

## apply the patch to samba utils ntlm_auth.c source code

First get the samba source code

``` bash
apt-get source samba
```

To apply the patch run the `patch ntlm_auth.c ntlm_auth.abcdesktop.patch` command

``` bash
cp ntlm_auth.abcdesktop.patch samba-4.15.13+dfsg/source3/utils
cd samba-4.15.13+dfsg/source3/utils && patch ntlm_auth.c ntlm_auth.abcdesktop.patch
```

## Files credentials 

The default secrets directory is `/var/secrets/abcdesktop/ntlm`

- `abcdesktop` is the namespace of abcdesktop.io projet
- `ntlm` is the name of the ntlm secrets direcotry. ntlm secrets are created by this patched ntlm_auth command line 

### to create files credentials

### create NTLM_DOMAIN and NTLM_USER files

Create NTLM_DOMAIN and NTLM_USER files

``` bash
echo YOUR_DOMAIN > /var/secrets/abcdesktop/ntlm/NTLM_DOMAIN
echo YOUR_SAMACCOUNTNAME > /var/secrets/abcdesktop/ntlm/NTLM_USER
```

### run ntlm_auth 

``` bash
NTLM_PASSWORD=YOUR_PASSWORD ./ntlm_auth
```

returns `NTLM_KEY` and `NTLM_PASSWORD`

```
NTLM_KEY=YGV/t5d09/NRrxdcag8UjweeGvRgnFgGlDhemgPrTWM=
NTLM_PASSWORD=smch/ZWp0s2z8ZmuGwkGAh8R8S2L
```

### create NTLM_PASSWORD and NTLM_KEY files

Create `NTLM_PASSWORD` and `NTLM_KEY` files

``` bash
echo "YGV/t5d09/NRrxdcag8UjweeGvRgnFgGlDhemgPrTWM=" > /var/secrets/abcdesktop/ntlm/NTLM_KEY
echo "smch/ZWp0s2z8ZmuGwkGAh8R8S2L" > /var/secrets/abcdesktop/ntlm/NTLM_PASSWORD
```

### to decode files

run `ntlm_auth` with `NTLM_DEBUG=1` to dumps previous credential strings to stderr

``` bash
NTLM_DEBUG=1 ./bin/ntlm_auth --helper-protocol=ntlmssp-client-1
```

```
desktop_read_credentials read NTLM_KEY [YGV/t5d09/NRrxdcag8UjweeGvRgnFgGlDhemgPrTWM=]
desktop_read_credentials read NTLM_USER [YOUR_SAMACCOUNTNAME]
desktop_read_credentials read NTLM_DOMAIN [YOUR_DOMAIN]
desktop_read_credentials read NTLM_PASSWORD [smch/ZWp0s2z8ZmuGwkGAh8R8S2L]
NTLM_USER YOUR_SAMACCOUNTNAME
NTLM_DOMAIN YOUR_DOMAIN
NTLM_KEY YGV/t5d09/NRrxdcag8UjweeGvRgnFgGlDhemgPrTWM=
NTLM_PASSWORD YOUR_PASSWORD
```










