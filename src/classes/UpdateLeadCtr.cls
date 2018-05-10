public class UpdateLeadCtr{
    @Future
    public static void updateLead(Id Id, string sName, string sEmial, String sPhone, String sWebsite, String sCompany, Boolean bCalendly, String sEIN, String sFname, String sLname){
        boolean bPhone = false;
        boolean bPhoneNumber = false;
        boolean bOrg = false;
        boolean bWeb = false;
        set<Lead> updateLead = new set<Lead>();
        List<Event> UpdateEv = new List<Event>();
        List<Event> lstEvt = [SELECT Id,WhatId FROM EVENT WHERE WhoId=:Id];
        if(bCalendly==true){
            
            List<Lead> lstLeadEml = [SELECT id, NAme, Email, Phone, Website, Company FROM Lead WHERE Id !=:Id AND Email=:sEmial LIMIT 1];
            if(lstLeadEml != null && lstLeadEml .size()>0){
                for(Lead oLead1:lstLeadEml ){
                    oLead1.Phone = sPhone;
                    oLead1.Website = sWebsite;
                    oLead1.Company = sCompany;
                    oLead1.status = 'Open Needs Review';
                    updateLead.add(oLead1);
                    bPhone = true;
                    if(lstEvt != null && lstEvt.size()>0){
                        for(Event Oevt : lstEvt){
                            Oevt.WhoId = oLead1.Id;UpdateEv.add(Oevt);
                        }
                    }
                }

                system.debug(updateLead);
                
            }
            else{
                List<Lead> lstLead = [SELECT id, NAme, Email, FirstName, LastName, Phone, Website, Company FROM Lead WHERE Id !=:Id AND (Phone=:sPhone OR Company=:sCompany OR Website=:sWebsite)  LIMIT 1];
                if(lstLead != null && lstLead.size()>0){
                    for(Lead oLead1:lstLead){
                        if(oLead1.Company==sCompany){
                            bOrg = true;
                        }
                        else if(oLead1.Phone==sPhone){
                            bPhoneNumber = true;
                        }                       
                        else if(oLead1.Website==sWebsite){
                            bWeb = true;
                        }
                        if(bOrg==true || bPhoneNumber==true || bWeb==true){
                            if(oLead1.FirstName==sFname && oLead1.LastName==sLname){
                                oLead1.Phone = sPhone;
                                oLead1.Website = sWebsite;
                                oLead1.Company = sCompany;
                                oLead1.status = 'Open Needs Review';
                                updateLead.add(oLead1);
                                bPhone = true;
                                if(lstEvt != null && lstEvt.size()>0){
                                    for(Event Oevt : lstEvt){
                                        Oevt.WhoId = oLead1.Id;UpdateEv.add(Oevt);
                                    }
                                }
                            }
                        }
                    }

                    system.debug(updateLead);
                }   
            }
            
            if(updateLead.size()>0)
                Update new List<Lead>(updateLead);
            if(UpdateEv.size()>0)Update UpdateEv;
            if(!Test.isRunningTest()){
                if(bPhone == true)delete ([SELECT Id FROM Lead WHERE Id=:Id FOR UPDATE]);
            }
        }  
    }
}