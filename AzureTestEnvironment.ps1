﻿# Parameter Section - Change here to change Default values
param(
    [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$AzureRegion1 = 'North Europe',

    [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$AzureRegion2 = 'West Europe',
    
    [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$AzureAdminUserName = 'AzureAdmin',

    [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$AzureAdminUserPassword = 'P@ss1234WordP@ss5678',

    [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$AutoShutdownStatus = 'Enabled',

	[Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$AutoShutdownTime = '16:00',

	[Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$AutoShutdownTimeZone = 'Romance Standard Time',

	[Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$AutoShutdownNotificationStatus = 'Enabled',

	[Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$AutoShutdownNotificationLocale = 'en',

	[Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$AutoShutdownNotificationEmail = 'test@test.com',

	[Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$temp = 'temp'		
			
)


# Main Menu
function Show-Menu-Main {
    param (
        [string]$Title = 'Main Menu'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' for Creating Test Environment"
    Write-Host "2: Press '2' for Add-On to Test Environment"
    Write-Host "3: Press '3' for Delete all or Parts of Test Environment"
    Write-Host "4: Press '4' to ??"
    Write-Host "========================================"
}

# Create Menu
function Show-Menu-Create {
    param (
        [string]$Title = 'Test Environment Creation Menu'
    )
    Write-Host " "
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' for Creating Single Test Environment i Region 1"
    Write-Host "2: Press '2' for Creating Single Test Environment i Region 2"
    Write-Host "3: Press '3' for ??"
    Write-Host "4: Press '4' to ??"
    Write-Host "========================================"
}

# Remove Menu
function Show-Menu-Remove {
    param (
        [string]$Title = 'Test Environment Remove Menu'
    )
    Write-Host " "
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' for Remove Single Test Environment i Region 1"
    Write-Host "2: Press '2' for Remove Single Test Environment i Region 2"
    Write-Host "3: Press '3' for ??"
    Write-Host "4: Press '4' to ??"
    Write-Host "========================================"
}




try {


    ## Download the Azure PowerShell module if you don't have it
    if (-not (Get-Module -Name Azure -ListAvailable -ErrorAction Ignore)) {
        Install-Module -Name Azure -Force
    }

    if (-not (Get-Module -Name AzureRM -ListAvailable -ErrorAction Ignore)) {
        Install-Module -Name AzureRM -Force
    }

    ## If You isn't already authenticated to Azure, ask you to
    if (-not (Get-AzureRmContext -ErrorAction Continue)) {
        Connect-AzureRmAccount
    }

    ## Hide the prog bar generated by Invoke-WebRequest
    $progPrefBefore = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
    

       

# Running Main menu to get what to do
do
 {
    Show-Menu-Main
    $selectionMain = Read-Host "Please make a selection"
    switch ($selectionMain)
    {
      '1' {
      'You chose option #1 - Creating Test Environment'
    } '2' {
      'You chose option #2 - Add-On to Test Environment'
    } '3' {
      'You chose option #3 - Delete all or Parts of Test Environment'
    } '4' {
      'You chose option #4 - ??'
    }
    }
 }
 until ($selectionMain -le 5 )

# Based on Choice action execute

if ($selectionMain -eq 1)
    # Section Creating Test Environment 
     {Write-Host "*"
      Write-Host "*"

     # Running Create menu to get what to do
     do
        {
         Show-Menu-Create
            $selectionCreate = Read-Host "Please make a selection"
            switch ($selectionCreate)
            {
            '1' {
                'You chose option #1'
            } '2' {
                'You chose option #2'
            } '3' {
                'You chose option #3'
            } '4' {
                'You chose option #4 - ??'
            }
            }
        }
            until ($selectionCreate -le 5 )


        if ($selectionCreate -eq 1)
        # Section Creating Test Environment in Region 1
            {Write-Host "*"
             Write-Host "========================================"
             Write-Host "Creating Test environment in Azure Location :" $AzureRegion1
             
             
             ## Download the ARM template
                ##$templatePath = "$env:TEMP\TestLab.json"
				## $url = 'https://raw.githubusercontent.com/PerJohansen/LabsScripts/master/TestLab.json'
				## Invoke-WebRequest -Uri $url -OutFile $templatePath
				
## Husk !!!				
				$templatePath = "C:\OneDrive\OneDrive - EG A S\TestLab.json"
                
            $ResourceGName = 'TestLAB1'
            $DeploymentName = "$ResourceGName-Deployment"

            ## Create the lab's resource group
            if (-not (Get-AzureRmResourceGroup -Name $ResourceGName -Location $AzureRegion1 -ErrorAction Ignore)) {
                        $null = New-AzureRmResourceGroup -Name $ResourceGName -Location $AzureRegion1
                }


            $paramObject = @{
                        'location' = $AzureRegion1
                        'ResourceGName' = $ResourceGName
                        'AzureAdminUserName' = $AzureAdminUserName
                        'AzureAdminUserPassword'  = $AzureAdminUserPassword
                        'virtualNetworkName' = "$ResourceGName-vNet"
                        'subnetName' = "$ResourceGName-subnet"
                        'addressPrefix' = '10.1.0.0/16'
                        'subnetPrefix' = '10.1.2.0/24'
						'AutoShutdownStatus' = $AutoShutdownStatus
						'AutoShutdownTime' = $AutoShutdownTime
						'AutoShutdownTimeZone' = $AutoShutdownTimeZone
						'AutoShutdownNotificationStatus' = $AutoShutdownNotificationStatus
						'AutoShutdownNotificationLocale' = $AutoShutdownNotificationLocale
						'AutoShutdownNotificationEmail' = $AutoShutdownNotificationEmail
                        }
            $parameters = @{
                        'Name'                  = $DeploymentName
                        'ResourceGroupName'     = $ResourceGName
                        'TemplateFile'          = $templatePath
                        'TemplateParameterObject'    = $paramObject
                        'Verbose'               = $true
                        }

            $null = New-AzureRmResourceGroupDeployment @parameters

            $DeploymentResult = (Get-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGName -Name $DeploymentName).Outputs

            <#
             Write-Host "Your lab VM IPs to RDP to are:"
                $vmIps = @()
                foreach ($val in $DeploymentResult.Values.Value) {
                $pubIp = Get-AzureRmResource -ResourceId $val
                $vmName = $pubIp.Id.split('/')[-1].Replace('-PubIP', '')
                $ip = (Get-AzurePublicIP -Name $pubip.Name).IpAddress
                $vmIps += [pscustomobject]@{
                   Name = $vmName
                   IP   = $ip
                   }
                   Write-Host "VM: $vmName IP: $ip"
                }#>
         }  
        elseif ($selectionCreate -eq 2)
        # Section Creating Single Test Environment in Region 2
            {Write-Host "*"
             Write-Host "========================================"
             Write-Host "Creating Test environment in Azure Location :" $AzureRegion2
             
             
             ## Download the ARM template
                $templatePath = "$env:TEMP\TestLab.json"
                $url = 'https://raw.githubusercontent.com/PerJohansen/LabsScripts/master/TestLab.json'
                Invoke-WebRequest -Uri $url -OutFile $templatePath


            $ResourceGName = 'TestLAB2'
            $DeploymentName = "$ResourceGName-Deployment"


            ## Create the lab's resource group
            if (-not (Get-AzureRmResourceGroup -Name $ResourceGName -Location $AzureRegion2 -ErrorAction Ignore)) {
                        $null = New-AzureRmResourceGroup -Name $ResourceGName -Location $AzureRegion2
                }


            $paramObject = @{
                        'location' = $AzureRegion2
                        'ResourceGName' = $ResourceGName
                        'AzureAdminUserName' = $AzureAdminUserName
                        'AzureAdminUserPassword'  = $AzureAdminUserPassword
                        'virtualNetworkName' = "$ResourceGName-vNet"
                        'subnetName' = "$ResourceGName-subnet"
                        'addressPrefix' = '10.2.0.0/16'
                        'subnetPrefix' = '10.2.2.0/24'
						'AutoShutdownStatus' = $AutoShutdownStatus
						'AutoShutdownTime' = $AutoShutdownTime
						'AutoShutdownTimeZone' = $AutoShutdownTimeZone
						'AutoShutdownNotificationStatus' = $AutoShutdownNotificationStatus
						'AutoShutdownNotificationLocale' = $AutoShutdownNotificationLocale
						'AutoShutdownNotificationEmail' = $AutoShutdownNotificationEmail
                        }
            $parameters = @{
                        'Name'                  = $DeploymentName
                        'ResourceGroupName'     = $ResourceGName
                        'TemplateFile'          = $templatePath
                        'TemplateParameterObject'    = $paramObject
                        'Verbose'               = $true
                        }

            $null = New-AzureRmResourceGroupDeployment @parameters

            $DeploymentResult = (Get-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGName -Name $DeploymentName).Outputs

            <#
             Write-Host "Your lab VM IPs to RDP to are:"
                $vmIps = @()
                foreach ($val in $DeploymentResult.Values.Value) {
                $pubIp = Get-AzureRmResource -ResourceId $val
                $vmName = $pubIp.Id.split('/')[-1].Replace('-PubIP', '')
                $ip = (Get-AzurePublicIP -Name $pubip.Name).IpAddress
                $vmIps += [pscustomobject]@{
                   Name = $vmName
                   IP   = $ip
                   }
                   Write-Host "VM: $vmName IP: $ip"
                } #>
            }

        elseif ($selectionCreate -eq 3)
        # ??
            {Write-Host " Run 3"
            }

        else
        {Write-Host " Run 4"}

        


      # End Main Menu Creation of Test Environment
      }
elseif ($selectionMain -eq 2)
    # Section Add-On to  Test Environment
     {Write-Host " Run 2"
     }
elseif ($selectionMain -eq 3)
    # Section Delete all or Parts of Test Environment
     {Write-Host "*"
      Write-Host "*"

     # Running Create menu to get what to do
     do
        {
         Show-Menu-Remove
            $selectionCreate = Read-Host "Please make a selection"
            switch ($selectionCreate)
            {
            '1' {
                'You chose option #1'
            } '2' {
                'You chose option #2'
            } '3' {
                'You chose option #3'
            } '4' {
                'You chose option #4 - ??'
            }
            }
        }
            until ($selectionCreate -le 5 )
 
       if ($selectionCreate -eq 1)
        # Section Remove Test Environment in Region 1
            {Write-Host "*"
             Write-Host "========================================"
             Write-Host "Remove TestLAB1 environment in Azure Location :" $AzureRegion1
            
            $ResourceGName = Get-AzureRmResourceGroup 'TestLAB1' 

            Foreach($name in $ResourceGName)
                {
                Write-Host "Deleting all Resources in Resource Group incl. it self: " $name.ResourceGroupName
                Remove-AzureRmResourceGroup -Name $name.ResourceGroupName -Verbose -Force
                }
           
             
         }  
        elseif ($selectionCreate -eq 2)
        # Selecion Remove Single Test Environment in Region 2
            {Write-Host "*"
             Write-Host "========================================"
             Write-Host "Remove TestLAB2 environment in Azure Location :" $AzureRegion2
            
            $ResourceGName = Get-AzureRmResourceGroup 'TestLAB2' 

            Foreach($name in $ResourceGName)
                {
                Write-Host "Deleting all Resources in Resource Group incl. it self: " $name.ResourceGroupName
                Remove-AzureRmResourceGroup -Name $name.ResourceGroupName -Verbose -Force
                }
           
            }
        elseif ($selectionCreate -eq 3)
        # ??
            {Write-Host " Run 3"
            }

        else
        {Write-Host " Run 4"}

     }

else
 {Write-Host " Run 4"}

}catch {
    throw $_.Exception.Message
} finally {
    $ProgressPreference = $progPrefBefore
}

