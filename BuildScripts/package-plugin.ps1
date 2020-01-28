Param(
  [string]$project_name = "default"
)

$base_project_directory = (Get-Item -Path .).FullName
write-output $base_project_directory
#clean up the folder structure
Write-Output "Cleaning up temporary package folder structure..."
Write-Output "==> Removing package folder"
Remove-Item -Path "package" -Recurse -Force 2>&1 | Out-Null
Write-Output "==> Removing deploy folder"
Remove-Item -Path "deploy" -Recurse -Force 2>&1 # | Out-Null

#create temp directories to store items for zipping
Write-output "Creating the temporary directories for creating the zipped deployment package..."
write-output "==> Creating directory package\inetpub\wwwroot\Director\DisplayConfig\$project_name"
New-Item "package\inetpub\wwwroot\Director\DisplayConfig\$project_name" -ItemType Directory  | Out-Null
write-output "==> Creating directory package\inetpub\wwwroot\Director\DisplayConfig\$project_name"
New-Item "package\inetpub\wwwroot\Director\plugin" -ItemType Directory  | Out-Null
write-output "==> Creating directory package\inetpub\wwwroot\Director\plugin"
New-Item "package\inetpub\wwwroot\Director\plugins\$project_name" -ItemType Directory  | Out-Null
write-output "==> Creating directory package\inetpub\wwwroot\Director\plugins\$project_name"

#get the root directory
$root_output_directory = Get-Item "package\inetpub\wwwroot\Director\"
write-output $root_output_directory.FullName

#copy the plugin configuration file to the temp output directory in prep for compressing
Write-Output "Copying the plugin configuration file to the package directory..."
Copy-Item "$base_project_directory\PluginConfiguration\*.*"  -Destination "$root_output_directory\DisplayConfig\$project_name\"  | Out-Null

#copy the dll
$dll_name = (Get-Item -Path .).BaseName + ".dll"
Write-Output "Copying $dll_name to the package directory..."
Copy-Item "$base_project_directory\bin\debug\$dll_name" -Destination "$root_output_directory\plugin\" | Out-Null

#copy the UI
Write-Output "Copying the user interface files to the package directory..."
Copy-Item -Path "$base_project_directory\UI\" -Destination "$root_output_directory\plugins\$project_name" -Recurse -Force -Filter "*" | Out-Null

#copy the templates to the temp directory
Copy-Item -Path "$base_project_directory\BuildScripts\Templates\" -Destination "$root_output_directory\DisplayConfig\$project_name\TemplatesToMerge" -Recurse -Force -Filter "*" | Out-Null

#zip
Write-Output ("Compressing the deployment package into $project_name" + "_plugin_deploy.zip")
Add-Type -AssemblyName "system.io.compression.filesystem"
New-Item -Path "$base_project_directory\deploy\" -ItemType Directory | Out-Null

[io.compression.zipfile]::CreateFromDirectory("package","$base_project_directory\deploy\$project_name" + "_plugin_deploy.zip")

Write-Output "Removing the temporary folder structure"
Remove-Item -Path "package" -Recurse -Force | Out-Null

#writing the install PS1
Write-Output "Creating the installer powershell script for easy installation"
"Add-Type -assembly `"system.io.compression.filesystem`"" | Out-File "$base_project_directory\deploy\installPlugin.ps1"

"`$Destination = `"C:\`"" |  Out-File "$base_project_directory\deploy\installPlugin.ps1" -Append
#"`$DeployZipFilePath = `"$project_name" + "_plugin_deploy.zip`"" | Out-File "$base_project_directory\deploy\installPlugin.ps1" -Append

"`$DeployZipFilePath = `$PSCommandPath.Replace(`$MyInvocation.MyCommand.Name,`"`") + `"$project_name" + "_plugin_deploy.zip`"" | Out-File "$base_project_directory\deploy\installPlugin.ps1" -Append

"[io.compression.zipfile]::ExtractToDirectory(`$DeployZipFilePath, `$Destination)"  | Out-File "$base_project_directory\deploy\installPlugin.ps1" -Append

"Write-Host `"Director plugin has been deployed. You will have to update your display configuration files in order to complete your installation.`"  -ForegroundColor DarkGreen" | Out-File "$base_project_directory\deploy\installPlugin.ps1" -Append

Write-Host "Created plugin deployment and zip file" -ForegroundColor yellow
Write-Host "Plugin package located at '$base_project_directory\deploy\' please copy this directory to your Director server and execute the installPlugin.ps1 file" -ForegroundColor green