api-salesforce
==============

Sample code for integrating Work Market with Salesforce.  Work Market API documentation can be found [here](https://www.workmarket.com/apidocs).

This sample demonstrates creating an assignment in Work Market from a corresponding object in Salesforce, including pricing, location, scheduling, and custom field information.


##Setup

Setting this demo up in your salesforce environment requires a few customizations in the following areas:
* Custom Labels for environment-specific constants
* Custom object to represent a Work Market Assignment in SF
* The Apex classes and trigger included in this repo

Follow the instructions below to get started.


### Custom Labels
This relies on Custom Labels for storing certain constants related to the integration. You will need to create the following Custom Labels in your SF instance:

| Label Name           | Description                                                             | Example                                |
|----------------------|-------------------------------------------------------------------------|----------------------------------------|
| WM_API_Error_Email   | Email to receive error messages                                         | you@yourdomain.com                     |
| WM_API_Secret        | WM API secret                                                           | VeC315dwF9ablGXikVx                    |
| WM_API_Token         | WM API token (not access token)                                         | SdnpUD319F9fda98uFaZpi92fxXxaYhmqcJ2aL |
| WM_URL               | The base URL of the WM environment you are using                        | https://api.dev.workmarket.com         |
| WM_CF_Default_Grp_ID | ID of your default custom fields group in WM                            | 539                                    |
| WM_CF_Object_SF_ID   | ID of the Salesforce Object ID field in your default custom field group | 8943


### Custom Assignment Object

For this sample code, we have created a custom Assignment object that represents a WM assignment.  You could pull these fields from a
customized Case, Opportunity, or whatever you prefer to use.  You'll want to create a layout for this object as well
to make it usable.

| Field Name | API Name | Data Type |
|------------|----------|-----------|
|Address 1|Address_1__c|Text(120)|
|Address 2|Address_2__c|Text(120)|
|Assign By Email|Assign_By_Email__c|Text(100)|
|Assigned Resource|Assigned_Resource__c|Lookup(Contact)|
|Assignment ID|Assignment_ID__c|Text(12) (External ID) (Unique Case Insensitive)|
|City|City__c|Text(120)|
|Country|Country__c|Text(3)|
|Custom Field 1|Custom_Field_1__c|Text(8)|
|Description|Description__c|Long Text Area(32768)|
|End Time (Site Local)|End_Time_Site_Local__c|Date/Time|
|Group|Group__c|Picklist|
|Max Hours/Units|Max_Hours_Units__c|Number(5, 0)|
|Max Hours @ Secondary Rate|Max_Hours_Secondary_Rate__c|Number(4, 0)|
|Postal Code|Postal_Code__c|Text(12)|
|Pricing Type|Pricing_Type__c|Picklist ("Flat Rate", "Hourly", "Dual Rate Hourly", "Per Unit")|
|Rate|Rate__c|Currency(5, 2)|
|Resource Email|Resource__c|Text(100)|
|Resource Name|Resource_Name__c|Text(128)|
|Resource Phone|Resource_Phone__c|Phone|
|Secondary Rate|Secondary_Rate__c|Currency(5, 2)|
|Skills & Specialties|Skills_Specialties__c|Text Area(255)|
|Special Instructions|Special_Instructions__c|Long Text Area(32768)|
|Start Time (Site Local)|Start_Time_Site_Local__c|Date/Time|
|State / Province / Region|State_Province_Region__c|Text(4)|
|Status|Status__c|Picklist ("Draft", "Published to Work Market")|
|Template|Template__c|Picklist|
|Title|Title__c|Text(255)|
|View in Work Market|View_in_Work_Market__c|Formula (Text) "$Label.WM_URL & '/assignments/details/' & Assignment_ID__c"|

Feel free to contribute with pull requests!
