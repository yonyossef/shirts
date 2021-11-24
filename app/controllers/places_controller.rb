class PlacesController < ApplicationController
    before_action :get_place, only: %i[ show edit destroy ]
    require 'rest-client'
    require 'json'
    
    DEV_URL = 'http://localhost:3000'
    PROD_URL = 'https://schengine.herokuapp.com'

    URL = ENV["RAILS_ENV"] == 'development' ? DEV_URL : PROD_URL

    def index
        @json_places = get_places 
        @places = ActiveSupport::JSON.decode(@json_places)
    end

    # GET /places/1
    def show
    end

    # GET /places/new
    def new
        @tmplace = Place.new
    end

    # GET /places/1/edit
    def edit
        # Faking Place.find(params[:id]) by using api GET data (get_place)
        @tmplace = Place.new
        @tmplace.name = @place['name']
        @tmplace.sid = @place['id']
        if @tmplace.save
            puts 'edit place: tmplace was saved for persisted? test'
        else
            puts 'edit: local place could not be saved before edit, result maybe create instead of update'
        end
    end
    
    # PUT /place/1 or /places/1.json
    def update
        @tmplace = Place.find(params[:id])

        if @tmplace.update(place_params)
            # puts "MAILING EDIT PLACE START"
            # PlaceMailer.edit_place(@tmplace).deliver!
            # puts "MAILING EDIT PLACE END"

            puts 'putting from tmplace to remote server using api'
            if update_place(@tmplace)
                puts 'put successful, delete local tmp place'
                @tmplace.destroy
            else
                puts 'Remote place could not be updated'
            end

            redirect_to places_path, notice: "Place was successfully updated."

        else
            puts 'local place could not be saved by update'
            render :edit, status: :unprocessable_entity
        end
    end

    # POST /places or /places.json
    def create
        @tmplace = Place.new(place_params)

        if @tmplace.save
            # puts "MAILING NEW PLACE START"
            # PlaceMailer.new_place(@tmplace).deliver!
            # puts "MAILING NEW PLACE END"

            puts 'posting from tmplace to remote server using api'
            if post_place(@tmplace)
                # post successful, delete local tmp place
                @tmplace.destroy
            else
                puts 'Remote place could not be created'
            end

            redirect_to places_path, notice: "Place was successfully created."

        else
            puts 'local place could not be saved'
            render :new, status: :unprocessable_entity
        end
    end

    # DELETE /places/1
    def destroy
        delete_place
        redirect_to places_path, notice: "Place was successfully deleted."
    end
    
    private

    def get_place
        @place_id = params[:id]
        url = URL + '/api/v1/places/' + @place_id
        puts 'requesting data from api on ' + url
        response = RestClient.get(url)
        @place = ActiveSupport::JSON.decode(response)
        # render json: response
    end

    def post_place(place_hash)
        url = URL + '/api/v1/places/'
        puts 'posting data to server api on ' + url
        response = RestClient.post url, :name => place_hash['name']
        @place = ActiveSupport::JSON.decode(response)
    end

    def update_place(place)
        place_id = place[:sid].to_s
        url = URL + '/api/v1/places/' + place_id
        puts 'putting data: ' + place[:name] + ' - to server api on ' + url
        response = RestClient.put url, :name => place[:name]
        @place = ActiveSupport::JSON.decode(response)
    end

    # Started PATCH "/places/31" for 127.0.0.1 at 2021-11-24 10:11:20 +0200
    # Processing by PlacesController#update as HTML
    #   Parameters: {"authenticity_token"=>"[FILTERED]", "place"=>{"name"=>"Kio2000"}, "commit"=>"Update Place", "id"=>"31"}
    #   Place Load (0.9ms)  SELECT "places".* FROM "places" WHERE "places"."id" = $1 LIMIT $2  [["id", 31], ["LIMIT", 1]]
    #   ↳ app/controllers/places_controller.rb:40:in `update'
    #   TRANSACTION (0.7ms)  BEGIN
    #   ↳ app/controllers/places_controller.rb:42:in `update'
    #   Place Update (0.8ms)  UPDATE "places" SET "name" = $1, "updated_at" = $2 WHERE "places"."id" = $3  [["name", "Kio2000"], ["updated_at", "2021-11-24 08:11:20.487637"], ["id", 31]]
    #   ↳ app/controllers/places_controller.rb:42:in `update'
    #   TRANSACTION (0.8ms)  COMMIT
    #   ↳ app/controllers/places_controller.rb:42:in `update'
    # putting from tmplace to remote server using api
    # putting data: #<Place id: 31, name: "Kio2000", sid: 5, created_at: "2021-11-24 08:11:15.444814000 +0000", updated_at: "2021-11-24 08:11:20.487637000 +0000"> - to server api on http://localhost:3000/api/v1/places/5
    # Completed 500 Internal Server Error in 24ms (ActiveRecord: 3.2ms | Allocations: 5795)
    
    
      
    # RestClient::BadRequest (400 Bad Request):
    

    def delete_place
        @place_id = params[:id]
        url = URL + '/api/v1/places/' + @place_id
        puts 'delete place from server ' + url
        response = RestClient.delete url
    end

    def get_places
        url = URL + '/api/v1/places'
        puts 'requesting data from api on ' + url
        response = RestClient.get(url)
        # render json: response
    end

    # Only allow a list of trusted parameters through.
    def place_params
        params.require(:place).permit(:name)
    end
end
