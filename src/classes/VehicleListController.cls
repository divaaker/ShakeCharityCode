public with sharing class VehicleListController {
 

    @AuraEnabled//Annotation to use method in lightning component
    public static List<Account> getVehicleList() {//Fetch data
        return [SELECT Id,Name,AccountNumber, Phone,Type, CreatedDate FROM Account];
    }    
}