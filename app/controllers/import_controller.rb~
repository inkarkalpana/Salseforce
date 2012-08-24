class ImportController < ApplicationController
include Databasedotcom::Rails::Controller
  def index
     
  end

  def start_migration

    @ooor = Ooor.new(:url => 'http://localhost:8069/xmlrpc', :database => 'salseforcedb', :username => 'admin', :password   => 'admin')

     # All Lead salseforce data
     lead = Lead.all
     call_lead_save(lead)

     # All Account salseforce data
     account = Account.all 
     call_account_save(account)
  
     # All Contact salseforce data
     contact = Contact.all
     call_contact_save(contact)

  end

  
  #for Lead saving data
  def call_lead_save(led)
    led .each do |lead1|
      crmlead = CrmLead.new   #oor
      rescountry = ResCountry.new
      crmlead.contact_name = lead1.Name
      crmlead.name = lead1.Name
      crmlead.active = 'TRUE' if lead1.IsDeleted == 'false'
      crmlead.function = lead1.Title
      crmlead.street = lead1.Street  
      crmlead.city = lead1.City      
      crmlead.zip = lead1.PostalCode   
      if lead1.Country == nil
      #  crmlead.country_id = nil
      else
        crmlead.country_id =  ResCountry.search([["name","=",lead1.Country]])[0] 
      end
      state_id = ""
      if lead1.State == nil
      #  crmlead.state_id = nil
      else
        crmlead.state_id =  ResCountryState.search([["code","=",lead1.State]])[0]  
      end
      #crmlead.partner_id =  ResPartner.search([["name","=",lead1.Name ]])[0] 
      crmlead.phone = lead1.Phone  
      crmlead.mobile = lead1.MobilePhone  
      crmlead.fax  = lead1.Fax  
      crmlead.email_from = lead1.Email   
      crmlead.description = lead1.Description 
      if lead1.IsConverted == 'true'
        crmlead.type = 'opportunity'
      else
        crmlead.type = 'lead'
      end  
      if CrmCaseResourceType.name != lead1.LeadSource
         CrmCaseResourceType.create(name: lead1.LeadSource)
         crmlead.type_id = CrmCaseResourceType.search([["name","=",lead1.LeadSource]])[0]    
      end           
         crmlead.type_id = CrmCaseResourceType.search([["name","=",lead1.LeadSource]])[0]
         crmlead.partner_lead = lead1.Company                                                  
         crmlead.save   
    end
  end
  
  # for account saving data
  def call_account_save(acc)
       acc .each do |acnt|
            respart = ResPartner.new   #oor
            respart.name = acnt.Name
            respart.active = true
            respart.customer = true
            respart.website = acnt.Website if acnt.Website
            respart.date = acnt.CreatedDate 
            if acnt.Parent == nil
            #  respart.parent_id = nil
            else
              respart.parent_id = ResPartner.search([["name","=",acnt.Parent]])[0]   
            end
            respart.save   

             puts "================"
              p acnt.Name
              p acnt.Parent
             puts"===================="           
            respartadd = ResPartnerAddress.new
            respartadd.partner_id = respart.id 
            respartadd.type = 'default' 
           
            billingaddress = [acnt.BillingStreet , acnt.BillingCity, acnt.BillingPostalCode, acnt.BillingCountry,acnt.BillingState]
            shippingaddress = [acnt.ShippingStreet , acnt.ShippingCity, acnt.ShippingPostalCode, acnt.ShippingCountry,acnt.ShippingState]
            puts "================="
             p billingaddress
            puts"======================"
            puts "================="
             p shippingaddress
            puts"======================"

            if billingaddress
                respartadd = ResPartnerAddress.new
                respartadd.partner_id = respart.id 
                respartadd.type = 'invoice'
              	respartadd.street = acnt.BillingStreet
              	respartadd.city = acnt.BillingCity
                respartadd.zip = acnt.BillingPostalCode
                respartadd.phone = acnt.Phone
                respartadd.fax = acnt.Fax 
                if acnt.BillingCountry == nil
                  respartadd.country_id = nil
                else
        	  respartadd.country_id = ResCountry.search([["name","=",acnt.BillingCountry]])[0] 
                end
                if acnt.BillingState == nil
                #  respartadd.state_id = nil
                else
                #  respartadd.state_id = ResCountryState.search([["code","=",acnt.BillingState]])[0] 
                end
                respartadd.save 
              end

            if shippingaddress  
                respartadd = ResPartnerAddress.new
                respartadd.partner_id = respart.id 
                respartadd.type = 'delivery'
                respartadd.street = acnt.ShippingStreet
                respartadd.city = acnt.ShippingCity    
                respartadd.zip = acnt.ShippingPostalCode
                respartadd.phone = acnt.Phone
                respartadd.fax = acnt.Fax 
                
                if acnt.ShippingCountry == nil
               #   respartadd.country_id = nil
                else
        	  respartadd.country_id = ResCountry.search([["name","=",acnt.ShippingCountry]])[0] 
                end
                if acnt.ShippingState == nil
               #   respartadd.state_id = nil
                else
                  respartadd.state_id = ResCountryState.search([["code","=",acnt.ShippingState]])[0] 
                end               
                respartadd.save
            end 
        end
    end


    # for contact saving data
    def call_contact_save(con)
      con .each do |cont|
        respartadd = ResPartnerAddress.new
        respart = ResPartner.new
       #  if cont.Name == nil
       #  respart.name = "name not found"
       #  end
         respart.name = cont.Name
         respart.active = true
         respart.customer = true
        respart.save
        respartadd.partner_id =  ResPartner.search([["name","=",cont.Name ]])[0] 
        puts "============"
        p cont.AccountId
        puts "=============="
        # respartadd.Account = cont.AccountId]
        respartadd.name = cont.Name 
        respartadd.street = cont.MailingStreet
        respartadd.city = cont.MailingCity         
        if cont.MailingCountry == nil
       #   respartadd.country_id = nil
        else
          respartadd.country_id = ResCountry.search([["code","=",cont.MailingCountry]])[0]
        end
        if cont.MailingState == nil
      #   respartadd.country_id = nil
        else
          respartadd.state_id = ResCountryState.search([["code","=",cont.MailingState]])[0] 
        end  
        respartadd.zip = cont.MailingPostalCode
        respartadd.phone = cont.Phone
        respartadd.email = cont.Email if cont.Email
        respartadd.mobile = cont.MobilePhone
        respartadd.fax = cont.Fax
       # respart.save
        respartadd.save
      end
    end
end
