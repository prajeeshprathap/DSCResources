enum Ensure 
{ 
    Absent 
    Present 
}

[DscResource()]
class xPackageManagement
{
    [DsCProperty(Key)]
    [System.String] $Name

    [DsCProperty(Mandatory)]
    [Ensure] $Ensure

    [DsCProperty()]
    [System.String] $Version

    [DsCProperty()]
    [System.String] $Source

    [DsCProperty(NotConfigurable)]
    [Boolean] $IsValid

    [xPackageManagement] Get()
    {        
        $this.IsValid = $false
        if(-not ([string]::IsNullOrWhiteSpace($this.Version)))
        {
            $package = Get-Package |? {($_.Name -eq $this.Name) -and ($_.Version -eq $this.Version)}
        }
        else
        {
            $package = Get-Package |? {$_.Name -eq $this.Name}
        }

        if($this.Ensure -eq [Ensure]::Present)
        {
            if($package -ne $null)
            {
                $this.IsValid = $true
            }
        }
        else
        {
            if($package -eq $null)
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
            if(-not ([String]::IsNullOrWhiteSpace($this.Source)))
            {
                if(-not ([string]::IsNullOrWhiteSpace($this.Version)))
                {
                    Install-Package -Name $this.Name -RequiredVersion $this.Version -Source $this.Source
                }
                else
                {
                    Install-Package -Name $this.Name -Source $this.Source
                }
            }
            else
            {
                if(-not ([string]::IsNullOrWhiteSpace($this.Version)))
                {
                    Install-Package -Name $this.Name -RequiredVersion $this.Version
                }
                else
                {
                    Install-Package -Name $this.Name
                }
            }
        }
        else
        {
            if(-not ([string]::IsNullOrWhiteSpace($this.Version)))
            {
                Get-Package |? {($_.Name -eq $this.Name) -and ($_.Version -eq $this.Version)} | Uninstall-Package -Force
            }
            else
            {
                Get-Package |? {$_.Name -eq $this.Name} | Uninstall-Package -Force
            }            
        }
    }

    [bool] Test()
    {
        $result = $this.Get()

        if($this.Ensure -eq [Ensure]::Present)
        {       
            if($result.IsValid)
            {
                if(-not ([String]::IsNullOrWhiteSpace($this.Version)))
                {
                    Write-Verbose "The pacakge $($this.Name) with version $($this.Version) already exists"     
                    return $true
                }
                else
                {
                    Write-Verbose "The pacakge $($this.Name) already exists"     
                    return $true
                }
            }
            else
            {
                if(-not ([String]::IsNullOrWhiteSpace($this.Version)))
                {
                    Write-Verbose "The pacakge $($this.Name) with version $($this.Version) does not exists. This will be installed"     
                    return $false
                }
                else
                {
                    Write-Verbose "The pacakge $($this.Name) does not exists. This will be installed"     
                    return $false
                }                     
            }
        }
        else
        {
            if($result.IsValid)
            {
                Write-Verbose "The pacakge $($this.Name) does not exists"     
                return $true
            }
            else
            {
                if(-not ([String]::IsNullOrWhiteSpace($this.Version)))
                {
                    Write-Verbose "The pacakge $($this.Name) with version $($this.Version) exists. This will be uninstalled"     
                    return $false
                }
                else
                {
                    Write-Verbose "The pacakge $($this.Name) exists. This will be uninstalled"     
                    return $false
                }                  
            }
        }
    } 
}