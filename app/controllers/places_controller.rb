class PlacesController < ApplicationController
    before_action :set_place_id, only: %i[ show edit update destroy ]
    require 'rest-client'
    require 'json'
    
    DEV_URL = 'http://localhost:3000'
    PROD_URL = 'https://schengine.herokuapp.com'

    URL = ENV["RAILS_ENV"] == 'development' ? DEV_URL : PROD_URL

    def index
        @json_places = get_places 
        @places = ActiveSupport::JSON.decode(@json_places)
    end

    def show
        @json_place = get_place
        @place = ActiveSupport::JSON.decode(@json_place)
    end

    private

    def set_place_id
        @place_id = params[:id]
    end

    def get_place
        url = URL + '/api/v1/places/' + @place_id
        puts 'requesting data from api on ' + url
        response = RestClient.get(url)
        # render json: response
    end

    def get_places
        url = URL + '/api/v1/places'
        puts 'requesting data from api on ' + url
        response = RestClient.get(url)
        # render json: response
    end
end
