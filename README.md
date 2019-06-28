# MS-CTFPreparator

**Script for prepare your windows OS before CTF (Hardening Only)**

## What he's doing ?

1- Update OS
2- Update Defender signatures
3- Disable Netdiscover and Share/printer
4- Disable LLMNR
5- Disable Netbios on all interfaces
6- Disable SMBv1

## What execute it ?

Open a powershell terminal **In administrator**

```
Start-Process powershell.exe -ExecutionPolicy Bypass '\Install.ps1'
``

###### TODO

Disable NTLMv1 & LM
Force SMB signature Check

