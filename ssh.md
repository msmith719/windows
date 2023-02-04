# SSH
This is only meant to be a guide for a starting point. Always implement security best practices, and routinely audit what is still setup in prod and even test enviroments. Also check the stuff you have forgotten about as well. :grinning:

## Generate New Key Pair
``` ps1
ssh-keygen.exe -t rsa -b 4096
```
The default output location is `c:\users\<username>\`, and the default file name is `id_rsa`

## Start the OpenSSH Authentication Agent (ssh-agent)
``` ps1
Set-Service   ssh-agent -StartupType Automatic
Start-Service ssh-agent
```

## Add private key
``` ps1
ssh-add.exe c:\users\<username>\.ssh\id_rsa
```

## HP Procurve 3500-48G-PoE yl J8693A
In the directory `c:\users\<username>\.ssh`, make file named `config` (no file extension) if it does not exist.

Add the following to that config file:
```
Host <switch IP>
KexAlgorithms +diffie-hellman-group14-sha1
HostkeyAlgorithms +ssh-rsa
User manager
Hostname <switch IP>
```

## HP Procurve 2810-48G J9022A
In the directory `c:\users\<username>\.ssh`, make file named `config` (no file extension) if it does not exist.

Add the following to that config file:
```
Host <switch IP>
KexAlgorithms +diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1
HostkeyAlgorithms +ssh-rsa
Ciphers +3des-cbc
User manager
Hostname <switch IP>
```