class TermsController < ApplicationController
  
  def index
    
    #these are the supported vocabularies and the associated class names
    authorities_classes = {"lcsh"=>"Authorities::Lcsh", "loc"=>"Authorities::Loc"}
    
    #make sure vocab param is present
    if !params[:vocab].present?
      raise Exception, 'The vocabulary was not specified'
    end
    
    #make sure q param is present
    if !params[:q].present?
      raise Exception, 'The query was not specified'
    end
    
    #make sure vocab param is valid
    if !authorities_classes.has_key? params[:vocab]
      raise Exception, 'Vocabulary not supported'
    end
    
    #get the authority class
    authority_class = authorities_classes[params[:vocab]]
    
    #convert wildcard to be URI encoded
    params[:q].gsub!("*", "%2A")
   
   #initialize the authority and run the search. if there's a sub-authority and it's valid, include that param
    if params[:sub_authority].present? and authority_class.constantize.authority_valid?(params[:sub_authority])
      @authority = authority_class.constantize.new(params[:q], params[:sub_authority])
    else
      @authority = authority_class.constantize.new(params[:q])
    end
    
    #parse the results
    @authority.parse_authority_response
    
    respond_to do |format|
      format.html { render :layout => false, :text => @authority.results }
      format.json { render :layout => false, :text => @authority.results }
      format.js   { render :layout => false, :text => @authority.results }
    end
  end


end
