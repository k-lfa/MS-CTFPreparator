# MS-CTFPreparator

**Script for prepare your windows OS before CTF (Hardening Only)**

## What he's doing ?

1. Update OS
2. Update Defender signatures
3. Disable Netdiscover and Share/printer
4. Disable LLMNR
5. Disable Netbios on all interfaces
5. Disable SMBv1

## What execute it ?

Open a powershell terminal **In administrator**

```
Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File .\Install.ps1"
```

"-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit

###### TODO

Disable NTLMv1 & LM
Force SMB signature Check

