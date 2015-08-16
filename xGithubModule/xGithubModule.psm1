enum Ensure
{
    Absent
    Present
}

[DscResource()]
class xGithubModule
{
    [DsCProperty(Key)]
    [System.String] $Url

    [DsCProperty(Mandatory)]
    [System.String] $ModuleName

    [DsCProperty(Mandatory)]
    [Ensure] $Ensure

    [DsCProperty(NotConfigurable)]
    [Boolean] $IsValid

    [xGithubModule] Get()
    {       
        $this.IsValid = $false
        $fileName = $this.Url.Substring($this.Url.LastIndexOf('/'), $this.Url.Length - ($this.Url.LastIndexOf('/')))
        $moduleFolder = Join-Path 'C:\Program Files\WindowsPowerShell\Modules' $this.ModuleName
                
        $fileExists = Test-Path (Join-Path $moduleFolder $fileName)

        if($this.Ensure -eq [Ensure]::Present)
        {
            if($fileExists)
            {
                $this.IsValid = $true
            }
        }
        else
        {
            if(-not $fileExists)
            {
                $this.IsValid = $true
            }
        }
        return $this 
    }

    [void] Set()
    {  
        $modulePath = 'C:\Program Files\WindowsPowerShell\Modules'
        $fileName = $this.Url.Substring($this.Url.LastIndexOf('/'), $this.Url.Length - ($this.Url.LastIndexOf('/')))

        $moduleFolder = Join-Path 'C:\Program Files\WindowsPowerShell\Modules' $this.ModuleName
        $filePath = Join-Path $moduleFolder $fileName                
      
        if($this.Ensure -eq [Ensure]::Present)
        {  
            Write-Verbose "Starting download file at location $($this.Url) to $filePath"

            $webClient = New-Object System.Net.WebClient
            $uri = New-Object System.Uri $this.Url
            $webClient.DownloadFile($uri, $filePath)           
        }
        else
        {           
            Remove-Item $filePath      
        }
    }

    [bool] Test()
    {
        $result = $this.Get()

        if($this.Ensure -eq [Ensure]::Present)
        {      
            if($result.IsValid)
            {
                Write-Verbose "The file from the Url $($this.Url) already exists in the modules folder"    
                return $true                
            }
            else
            {
                Write-Verbose "The file from the Url $($this.Url) does not exists in the modules folder. This will be downloaded"    
                return $false                   
            }
        }
        else
        {
            if($result.IsValid)
            {
                Write-Verbose "The file from the Url $($this.Url) does not exists in the modules folder"    
                return $true
            }
            else
            {
                Write-Verbose "The file from the Url $($this.Url) exists in the modules folder. This will be be removed"    
                return $false                 
            }
        }
    }
}