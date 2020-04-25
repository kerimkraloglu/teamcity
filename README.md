# Test Automation with Teamcity

The aim is to create a task ticket automatically on "FogBugz Issue Tracking system" if the TeamCity build configuration become fail.

## Getting Started

Tracking and maintenance on test automation are so important. To make easier this process I am using the FogBugz issue tracking system. Thus, I can analyze every build configuration that fails and log the maintenance time. 

### Prerequisites

* A build configuration on TeamCity. 
* FogBugz API Token for powershell script. 


### Installing

* Create an additional build step on your build configuration. Select the Runner type as PowerShell.
* Select "Even if some of the previous steps failed" as Execute step.
* Select the source code on Script dropdown list.
* Copy the PowerShell script (AutoFogBugz.ps1) and paste on Script source place.
* Define the variables on Script arguments.
![](/powershell-variables.png)

## Authors

* **Kerim Kraloglu** - *Initial work* - [KerimKraloglu](https://github.com/kerimkraloglu)
