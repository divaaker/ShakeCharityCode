global class GuidestarCTR {
    global string sOrgId;
    webservice static void getGuideStartData(string EIN){
        system.debug(EIN);
        List<Account> UpdateAcc = new List<Account>();
        HttpRequest req = new HttpRequest();
        string endpoint = 'https://apidata.guidestar.org/essentials/v1';

         req.setEndpoint(endpoint);
         req.setHeader('Subscription-Key','54868ff4f13443b1a245b918781c1d4e');
         
         
         req.setHeader('Content-Type','application/json');
         req.setBody('{"search_terms": "'+EIN+'","from": 0,"size": 0,"sort": {"sort_by": "string","ascending": true}}');
         req.setTimeout(60000);
         req.setMethod('POST');               
         Http h = new Http();
         HttpResponse response;
         String body;
         response = h.send(req);
         body = response.getBody();
         system.debug(body);
         
          ///// Map Object to JSON Data ////
         JSON2Apex root = (JSON2Apex) JSON.deserializeStrict(body , JSON2Apex.class);
         List<JSON2Apex.Hits> lstJSON= root.Data.hits;
         system.debug(lstJSON);
         string sOrgId = lstJSON[0].organization_id;
         system.debug(sOrgId );
         List<Account> lstAccount = [SELECT Id, Name, Report_URL__c, Bridge_Number__c, AccountNumber, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, Total_Assets__c, Company_Mission__c, Website, YearStarted, NumberOfEmployees, Total_Expense__c, Total_Revenue__c, Contact_Email__c, Contact_Person__c, Contact_Phone__c, Contact_Title__c, EIN__c, Form_Type__c, Foundation_Code__c, Independent__c, lat_long__c, NTEE_Code__c,  Organaization_Id__c  FROM Account WHERE EIN__c=:EIN LIMIT 1];
         if(lstAccount != null && lstAccount.size()>0){
             for(Account oAcc : lstAccount){
                oAcc.Name = lstJSON[0].organization_name;
                oAcc.Organaization_Id__c  = lstJSON[0].organization_id;
                sOrgId   = lstJSON[0].organization_id;
                oAcc.Report_URL__c = lstJSON[0].public_report; 
                oAcc.BillingStreet = lstJSON[0].address_line_1; 
                oAcc.BillingCity = lstJSON[0].city; 
                oAcc.BillingState = lstJSON[0].state; 
                oAcc.BillingPostalCode = lstJSON[0].zip; 
                oAcc.BillingCountry = lstJSON[0].county;
                oAcc.Total_Assets__c = lstJSON[0].form990_total_assets; 
                oAcc.Company_Mission__c = lstJSON[0].mission; 
                oAcc.Website = lstJSON[0].website_url; 
                //oAcc.NumberOfEmployees = Integer.valueof(lstJSON[0].number_of_employees); 
                oAcc.Total_Expense__c = lstJSON[0].form990_total_expenses; 
                oAcc.Total_Revenue__c = lstJSON[0].form990_total_revenue; 
                oAcc.Contact_Email__c = lstJSON[0].contact_email; 
                oAcc.Contact_Person__c = lstJSON[0].contact_name; 
                oAcc.Contact_Title__c = lstJSON[0].contact_title; 
                oAcc.EIN__c = lstJSON[0].ein; 
                oAcc.Form_Type__c = lstJSON[0].form_type; 
                oAcc.Foundation_Code__c = lstJSON[0].foundation_code;
                //oAcc.lat_long__c = lstJSON[0].lat_long; 
                oAcc.NTEE_Code__c = lstJSON[0].ntee_code;
                oAcc.Bridge_Number__c = lstJSON[0].bridge_id;
                oAcc.county__c= lstJSON[0].county;
                UpdateAcc.add(oAcc);                
             }
         }
        if(UpdateAcc.size()>0){
            Update UpdateAcc;   
        }       
            GuidestarCTR.getGuideStartDataPremius(sOrgId);
    }
    @future (callout=true)
    webservice static void getGuideStartDataPremius(string sOrgId){
        List<Account> UpdateAcc = new List<Account>();  
        system.debug(sOrgId);
        if(sOrgId != null){
            HttpRequest reqPrem = new HttpRequest();
            string endpointPre = 'https://apidata.guidestar.org/premier/v1/'+sOrgId;
            system.debug(endpointPre);
            reqPrem.setEndpoint(endpointPre);
            reqPrem.setHeader('Subscription-Key','c0baddb29740404c8f2f4528e18ea3ca');
            system.debug(reqPrem);
            reqPrem.setHeader('Content-Type','application/json');
            reqPrem.setTimeout(60000);
            reqPrem.setMethod('GET');               
            Http hPrem = new Http();
            HttpResponse responsePrem;
            String bodyPrem;
            responsePrem = hPrem.send(reqPrem);
            bodyPrem = responsePrem.getBody();
            system.debug(bodyPrem);
            
            JSON2ApexPremier root = (JSON2ApexPremier) JSON.deserializeStrict(bodyPrem , JSON2ApexPremier.class);
            JSON2ApexPremier.Charitycheck Check = root.Data.Charitycheck ;
            system.debug(Check);
            List<JSON2ApexPremier.Organization_types> lstOrgType =  root.Data.Charitycheck.Organization_types ;
            List<Account> lstAccount = [SELECT Id, Name, Deductablity_Status_Desacription__c, Most_Recent_BMF__c, Most_Recent_IRB__c, Most_Recent_Pub_78__c, Ruling_Month__c, Ruling_Year__c, Subsection_Description__c, Foundation_Status__c FROM Account WHERE Organaization_Id__c=:sOrgId LIMIT 1];
            if(lstAccount != null && lstAccount.size()>0){
                for(Account oAcc : lstAccount){
                    oAcc.Deductablity_Status_Desacription__c = lstOrgType[0].deductibility_status_description;
                    oAcc.Most_Recent_BMF__c  = Check.most_recent_bmf.remove('5:00:00 AM');
                    oAcc.Most_Recent_IRB__c  = Check.most_recent_irb.remove('5:00:00 AM');
                    oAcc.Most_Recent_Pub_78__c  = Check.most_recent_pub78.remove('5:00:00 AM');
                    oAcc.Ruling_Year__c  = Check.ruling_year;
                    oAcc.Ruling_Month__c  = Check.ruling_month;
                    oAcc.Subsection_Description__c  = Check.subsection_description;
                    oAcc.Foundation_Status__c  = Check.foundation_509a_status;
                    UpdateAcc.add(oAcc);
                    system.debug(UpdateAcc);
                }
            }
            system.debug(Check.foundation_509a_status);
            if(UpdateAcc.size()>0){
                Update UpdateAcc;   
            }  
        }
    }       
}