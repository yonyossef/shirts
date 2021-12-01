class ApplicationController < ActionController::Base
    require 'rest-client'
    require 'json'
    
    DEV_URL = 'http://localhost:3000'
    PROD_URL = 'https://schengine.herokuapp.com'

    URL = ENV["RAILS_ENV"] == 'development' ? DEV_URL : PROD_URL
end
