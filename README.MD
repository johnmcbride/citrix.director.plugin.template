# Building plugins for Citrix Director

### Overview
---
Would you like to provide additional features to your Citrix Director install? Perhaps you would like
to provide an additional level of information to your users of director. If that is what you are trying
to accomplish, then this sample is you starting point!


This sample is intended to provide a quickstart for building a plugin for Citrix Director. It is intended
to be the boiler plate you can use to build your plugin and continue to extend it.
  
For more information on the Citrix Director plugin model, please check out our blog post on [citrix.com](https://www.citrix.com/blogs/2016/01/07/citrix-director-plugin-model/)

### Getting Started
---
Since you are reading this, you have already created the sample, entered your plugin name and description. You're
almost ready to go. There is just a few thing you will need to do before you can deploy your plugin.

1. Because we cannot distribute the reference assemblies needed in this sample, you will need to add the following
dll's to the project. You can get these dll's from server where your Citrix Director is installed. They will be
located in "C:\inetpub\wwwroot\Director\Bin" folder. Please add the following dll's
**Depending on your version of Director you will need to include different DLLs. This is due
to the fact that some DLLS were renamed in the 7.8 release.**

    Director 7.8
    * DmcCommon.dll
    * WebService.dll

    Prior to 7.8
    * common.dll
    * WebService.dll

 
### Building and deploying the sample
---
We have tried to make building and deploying the sample plugin as easy as possible. Now that you have
added the correct references to the project, you should be able to successfully build the project.

To help with deployment we are using a custom Task to help package up your plugin and make a zip
package that you can take and extract/deploy to your Citrix Director. You can see this new Task by opening the Visual Studio Task Runner Explorer 
(View->Other Windows->Task Runner Explorer or by using the key combination Ctrl+Alt+Bkspce)

#### How it works
After you build the sample, you will see a new folder in the solution explorer called "deploy" with a
a few files included in it. 

* **[your plugin name]_plugin_deploy.zip** (All plugin files need to deploy plugin)
* installPlugin.ps1 (Installation script to help deploy your plugin)

To deploy your sample, move the zip file and installPlugin.ps1 file to your director server
and perform the following steps to get the plugin installed.
    
1. Copy the zip file and installPlugin.ps1 to the director server in a temporary folder.
2. Open up powershell on the director server where you copied the files.
3. Navigate to the location of the zip file.
4. execute the installPlugin.ps1 file.

The last step for enabling your plugin in director is to modify the director configuration
files to have your plugin show up. We ship with the plugin a few templates that you can use to
make it easier to get up and running. There are two options

* Copy one of the template files listed in the C:\inetpub\wwwroot\Director\DisplayConfig\ **[plugin name]** \TemplatesToMerge
to C:\inetpub\wwwroot\Director\DisplayConfig\ and overwrite the existing file.
* Modify one of the files in the C:\inetpub\wwwroot\Director\DisplayConfig\ and add
an additional panel entry in the format of &lt;panel pluginId="[you plugin name]" /&gt;
 
The zipped package should be called **[your plugin name]_plugin_deploy.zip**

**NOTE: If you do not see this file, you may to "show all files" for the solution by clicking the show all files toolbar button
located in the solution explorer**

This is the package you can take and extract on your server that is running Citrix Director. Once you
have extracted the files onto the server, you should issue the command "iisreset" from the command prompt.

Congratulations, you should now see your new plugin in the Director UI.
