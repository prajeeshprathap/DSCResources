Configuration xPackageManagementConfig
{
    Import-Dscresource -ModuleName xPackageManagement    
   
    xPackageManagement Foxe
    {
        Name = "Foxe"
        Source = "http://prajeeshchoco.azurewebsites.net/nuget/"
        Ensure = "Present"      
    }       
}

xPackageManagementConfig  