using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
//add citrix DLL
using Citrix.Dmc.Common.Plugin;
using Citrix.Dmc.WebService;

namespace {plugin-name}
{

    public class {plugin-name}DirectorPlugin : I{plugin-name}DirectorPlugin
    {
        //simple method that returns a string to the calling program
        public string ExampleTestMethod()
        {
            return "You have sucessfully called API Method from a director plugin";
        }
        //simple method that returns a list of string. This could be the
        //groups a user is a member of for example.s   
        public List<string> ExampleGetUserGroups(string User)
        {
            List<string> _userGroups = new List<string> { "group1", "group2", "group3", "group4" };

            return _userGroups;
        }
    }
}
