Set-Location $env:windir\\system32\\inetsrv\\

        # Add server farm 1
        .\appcmd.exe set config  -section:webFarms /+"[name='1']" /commit:apphost

		# Add server to farm 1
		.\appcmd.exe set config  -section:webFarms /+"[name='1'].[address='1.iis.dmz']" /commit:apphost
		
		
		# Add URL Rewrite to farm 1
		.\appcmd.exe set config  -section:system.webServer/rewrite/globalRules /+"[name='ARR_1_lb', patternSyntax='Wildcard',stopProcessing='True']" /commit:apphost
		.\appcmd.exe set config  -section:system.webServer/rewrite/globalRules /"[name='ARR_1_lb',patternSyntax='Wildcard',stopProcessing='True']".match.url:"*1/*"  /commit:apphost
        .\appcmd.exe set config  -section:system.webServer/rewrite/globalRules /"[name='ARR_1_lb',patternSyntax='Wildcard',stopProcessing='True']".action.type:Rewrite  /"[name='ARR_1_lb',patternSyntax='Wildcard',stopProcessing='True']".action.url:"http://1/{R:2}" /commit:apphost
        
        
        # Add server farm 2
        .\appcmd.exe set config  -section:webFarms /+"[name='2']" /commit:apphost

		# Add server to farm 2
		.\appcmd.exe set config  -section:webFarms /+"[name='2'].[address='2.iis.dmz']" /commit:apphost
		
		
		# Add URL Rewrite to farm 2
		.\appcmd.exe set config  -section:system.webServer/rewrite/globalRules /+"[name='ARR_2_lb', patternSyntax='Wildcard',stopProcessing='True']" /commit:apphost
		.\appcmd.exe set config  -section:system.webServer/rewrite/globalRules /"[name='ARR_2_lb',patternSyntax='Wildcard',stopProcessing='True']".match.url:"*2/*"  /commit:apphost
        .\appcmd.exe set config  -section:system.webServer/rewrite/globalRules /"[name='ARR_2_lb',patternSyntax='Wildcard',stopProcessing='True']".action.type:Rewrite  /"[name='ARR_2_lb',patternSyntax='Wildcard',stopProcessing='True']".action.url:"http://2/{R:2}" /commit:apphost