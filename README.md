Turns JIRA CRs in IM text into clickable links. For example if you configure your URL base as "https://jira.secondlife.com/browse" and then type:
```
SUN-114
```
Everyone with a Pidgin client will see it as a link:
```
[SUN-114](https://jira.secondlife.com/browse/SUN-114)
```
Other users do not need the plugin for this to work.

Requires: 
* pidgin 2.7.x (2.6.x has a bug in the perl plugins)
     

Install:
* Copy it to ~/.purple/plugins/
* Restart pidgin, enable in the plugin setup, hit configure and enter the Jira base url (i.e, 'http://jira.myhost.com/browse')
* For help on Windows see [Why doesn't my Perl plugin show up in the Plugins dialog? (pidgin.im)](https://developer.pidgin.im/wiki/Scripting%20and%20Plugins#WhydoesntmyPerlpluginshowupinthePluginsdialog), i.e:
    * Install correct version of Strawberry Perl, make sure it's on PATH
	* Check Perl is enabled from Pidgin's Help menu -> Build Information

To do:
* Support for multiple base-URLs (depending on project name?)
