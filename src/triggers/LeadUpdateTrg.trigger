Trigger LeadUpdateTrg on Lead (after insert) {
    set<Lead> updateLead = new set<Lead>();
    set<Id> sIDs = new set<Id>();
    for(Lead oLead:Trigger.new){
        sIDs.add(oLead.Id);
    }   
    List<Lead> oLeadlst = [SELECT id, NAme, Email, FirstName, Lastname, Phone, Website, Company, Calendly__c, EIN__c FROM Lead WHERE ID IN: sIDs];   
    if(oLeadlst != null && oLeadlst.size()>0){
        for(Lead oLead:oLeadlst){
            if(oLead.Calendly__c==true){
                UpdateLeadCtr.updateLead(oLead.Id,oLead.Name,oLead.Email,oLead.Phone,oLead.Website,oLead.Company,oLead.Calendly__c,oLead.EIN__c, oLead.FirstName, oLead.Lastname);
            }
        }
    }
}