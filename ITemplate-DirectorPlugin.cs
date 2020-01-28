using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
//add citrix DLL
using Citrix.Dmc.Common.Plugin;
using Citrix.Dmc.WebService;
//for plugin
using System.ServiceModel;
using System.ServiceModel.Web;

namespace {plugin-name}
{

    [PluginAttribute]
    interface I{plugin-name}DirectorPlugin
    {
        //simple method that returns a string to the calling program
        [OperationContract]
        [FaultContract(typeof(DmcServiceFault))]
        [WebInvoke(
            ResponseFormat = WebMessageFormat.Json, 
            BodyStyle = WebMessageBodyStyle.Wrapped)
        ]
        string ExampleTestMethod();

        //simple method that returns a list of string. This could be the
        //groups a user is a member of for example.
        [OperationContract]
        [FaultContract(typeof(DmcServiceFault))]
        [WebInvoke(
            ResponseFormat = WebMessageFormat.Json, 
            BodyStyle = WebMessageBodyStyle.Wrapped)
        ]        
        List<string> ExampleGetUserGroups(string User);
    }
}
