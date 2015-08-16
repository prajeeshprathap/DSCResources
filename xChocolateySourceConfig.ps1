Configuration xChocolateySourceConfig
{
    Import-Dscresource -ModuleName xChocolateySource    
   
    xChocolateySource Foxe
    {
        Name = "Azurechoco"
        Location = "http://prajeeshchoco.azurewebsites.net/nuget/"
        Ensure = "Present"      
    }       
}

xChocolateySourceConfig  