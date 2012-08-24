class LeadsController < ApplicationController

include Databasedotcom::Rails::Controller
	 
	def show
	    @lead = Lead.find(params[:id]) #salseforce
            crmlead = CrmLead.new   #oor
            rescountry = ResCountry.new
            crmlead.contact_name = @lead.Name
            crmlead.name = @lead.Name
            crmlead.active = 'TRUE' if @lead.IsDeleted == 'false'
            crmlead.function = @lead.Title
            crmlead.street = @lead.Street  
            crmlead.city = @lead.City      
            crmlead.zip = @lead.PostalCode   
            crmlead.country_id =  ResCountry.search([["name","=",@lead.Country]])[0] 
            state_id = ""
            crmlead.state_id =  ResCountryState.search([["code","=",@lead.State]])[0]  
            crmlead.phone = @lead.Phone  
            crmlead.mobile = @lead.MobilePhone  
            crmlead.fax  = @lead.Fax  
            crmlead.email_from = @lead.Email   
            crmlead.description = @lead.Description 
            if @lead.IsConverted == 'true'
               crmlead.type = 'opportunity'
            else
               crmlead.type = 'lead'
            end  
  
            if CrmCaseResourceType.name != @lead.LeadSource
              CrmCaseResourceType.create(name: @lead.LeadSource)
              crmlead.type_id = CrmCaseResourceType.search([["name","=",@lead.LeadSource]])[0]    
            end           
            crmlead.type_id = CrmCaseResourceType.search([["name","=",@lead.LeadSource]])[0]
            crmlead.partner_lead = @lead.Company                                                  
            crmlead.save   
	end
end
