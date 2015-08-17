Configuration xGithubModuleConfig
{
    Import-Dscresource -ModuleName xGithubModule    
   
    xGithubModule AzureChocoModule1
    {
        Url = "https://raw.githubusercontent.com/prajeeshprathap/DSCResources/master/xChocolateySource/xChocolateySource.psd1"
        Module = "xChocolateySource"
        Ensure = "Present"      
    }        
   
    xGithubModule AzureChocoModule2
    {
        Url = "https://raw.githubusercontent.com/prajeeshprathap/DSCResources/master/xChocolateySource/xChocolateySource.psm1"
        Module = "xChocolateySource"
        Ensure = "Present"      
    }  
}

xGithubModuleConfig  