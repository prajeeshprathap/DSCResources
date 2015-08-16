Configuration xGithubModuleConfig
{
    Import-Dscresource -ModuleName xGithubModule    
   
    xGithubModule AzureChocoModule1
    {
        Url = "https://raw.githubusercontent.com/prajeeshprathap/DSCResources/master/xChocolateySource/xChocolateySource.psd1"
        ModuleName = "xChocolateySource"
        Ensure = "Present"      
    }        
   
    xGithubModule AzureChocoModule2
    {
        Url = "https://raw.githubusercontent.com/prajeeshprathap/DSCResources/master/xChocolateySource/xChocolateySource.psm1"
        ModuleName = "xChocolateySource"
        Ensure = "Present"      
    }  
}

xChocolateySourceConfig  