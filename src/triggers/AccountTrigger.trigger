trigger AccountTrigger on Account (after insert,before insert, after update, before update, after delete, before delete, after undelete) {
    for(Account a : Trigger.new){
        system.debug(a.Id);
    }
}