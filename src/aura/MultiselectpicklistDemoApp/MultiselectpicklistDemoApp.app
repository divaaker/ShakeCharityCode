<aura:application access="global" extends="force:slds" >
    <c:MultiselectpicklistDemo />
  <!--  <aura:attribute name="options" type="Object[]" default="[
  {
    'label': 'All',
    'value': 'All'
  },
  {
    'label': 'Watching Rates',
    'value': 'Watching Rates'
  },
  {
    'label': 'Initial Contact',
    'value': 'Initial Contact'
  },
  {
    'label': 'Application',
    'value': 'Application'
  },
  {
    'label': 'Waiting for Qualifying Documentation',
    'value': 'Waiting for Qualifying Documentation'
  },
  {
    'label': 'Qualifying Documentation Review',
    'value': 'Qualifying Documentation Review'
   }]"/>
    <aura:attribute name="mySelectedItems" type="Object[]" />
    <div class="slds-form-element">
    <label class="slds-form-element__label" for="my-multi-select">Multi Select!!</label>
    <div class="slds-form-element__control">
        <c:MultiselectpicklistDemo aura:id="my-multi-select" options="{!v.options}" selectChnage="{!c.handleSelectChangeEvent}" selectedItems="{!v.mySelectedItems}" />
    </div>
</div>
-->
</aura:application>