FROM mcr.microsoft.com/windows/servercore/iis

MAINTAINER Vegar Berget

WORKDIR /
# Add the webserver features
RUN powershell -Command Add-WindowsFeature Web-Server

RUN @powershell Install-WindowsFeature Web-Mgmt-Service
RUN @powershell Install-WindowsFeature WAS-Config-APIs
RUN @powershell Install-WindowsFeature NET-Framework-45-ASPNET

# Add registry key to be able to install the MSI
RUN reg add HKLM\SOFTWARE\Microsoft\InetStp /v MajorVersion /t REG_DWORD /d 0x9 /f

# Download and install the modules.
RUN @powershell wget http://download.microsoft.com/download/5/7/0/57065640-4665-4980-a2f1-4d5940b577b0/webfarm_v1.1_amd64_en_us.msi -OutFile webfarm_v1.1_amd64_en_us.msi 
RUN msiexec /i "webfarm_v1.1_amd64_en_us.msi" /q /log inst.log
RUN @powershell wget http://download.microsoft.com/download/3/4/1/3415F3F9-5698-44FE-A072-D4AF09728390/ExternalDiskCache_amd64_en-US.msi -OutFile ExternalDiskCache_amd64_en-US.msi
RUN msiexec /i "ExternalDiskCache_amd64_en-US.msi" /q /log inst.log
RUN @powershell wget http://download.microsoft.com/download/6/7/D/67D80164-7DD0-48AF-86E3-DE7A182D6815/rewrite_amd64_en-US.msi -OutFile rewrite_amd64_en-US.msi
RUN msiexec /i "rewrite_amd64_en-US.msi" /q /log inst.log
RUN @powershell wget http://download.microsoft.com/download/6/3/D/63D67918-483E-4507-939D-7F8C077F889E/requestRouter_x64.msi -OutFile requestRouter_x64.msi
RUN msiexec /i "requestRouter_x64.msi" /q /log inst.log


RUN reg add HKLM\SOFTWARE\Microsoft\InetStp /v MajorVersion /t REG_DWORD /d 0xa /f

ADD /start.ps1 /
RUN @powershell ./start.ps1 
# Routine to add two serverfarm servers and set them to connect at different ports, this has to be done on cmd as I coud not figure out how to do it in PS.
RUN c:\windows\system32\inetsrv\appcmd.exe set config  -section:webFarms /[name='1'].[address='1.iis.dmz'].applicationRequestRouting.httpPort:"81" /commit:apphost
RUN c:\windows\system32\inetsrv\appcmd.exe set config  -section:webFarms /[name='2'].[address='2.iis.dmz'].applicationRequestRouting.httpPort:"82" /commit:apphost