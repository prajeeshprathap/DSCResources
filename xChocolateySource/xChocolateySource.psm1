enum Ensure
{
    Absent
    Present
}

[DscResource()]
class xChocolateySource
{
    [DsCProperty(Key)]
    [System.String] $Name

    [DsCProperty(Mandatory)]
    [System.String] $Location

    [DsCProperty(Mandatory)]
    [Ensure] $Ensure

    [DsCProperty(NotConfigurable)]
    [Boolean] $IsValid

    [xChocolateySource] Get()
    {       
        $this.IsValid = $false
        $packagesource = Get-PackageSource -ProviderName chocolatey -Name $this.Name        

        if($this.Ensure -eq [Ensure]::Present)
        {
            if($packagesource -ne $null)
            {
                $this.IsValid = $true
            }
        }
        else
        {
            if($packagesource -eq $null)
            {
                $this.IsValid = $true
            }
        }
        return $this  
    }

    [void] Set()
    {                  
      
        if($this.Ensure -eq [Ensure]::Present)
        {     
            Register-PackageSource -ProviderName Chocolatey -Name $this.Name -Location $this.Location -Force -Confirm:$true            
        }
        else
        {
            Unregister-PackageSource -Source $this.Name -ProviderName Chocolatey -Force          
        }
    }

    [bool] Test()
    {
        $result = $this.Get()

        if($this.Ensure -eq [Ensure]::Present)
        {      
            if($result.IsValid)
            {
                Write-Verbose "The pacakge source $($this.Name) already exists"    
                return $true                
            }
            else
            {
                Write-Verbose "The pacakge source $($this.Name) does not exist. This will be created"    
                return $false                   
            }
        }
        else
        {
            if($result.IsValid)
            {
                Write-Verbose "The pacakge source $($this.Name) does not exists"    
                return $true
            }
            else
            {
                Write-Verbose "The pacakge source $($this.Name) exists. This will be be removed"    
                return $false                 
            }
        }
    }
}