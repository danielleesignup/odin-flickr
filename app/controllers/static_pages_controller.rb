# app/controllers/static_pages_controller.rb
class StaticPagesController < ApplicationController
  require 'rest-client'
  require 'json'

  def home
  end

  def photos
    user_id = params[:user_id]
    if user_id.present?
      json_response = RestClient.get("https://api.flickr.com/services/feeds/photos_public.gne?id=#{user_id}&format=json")
      @photos = JSON.parse(json_response.gsub('jsonFlickrFeed(', '').chomp(')'))['items']
    else
      flash.now[:alert] = 'Please enter a valid Flickr user ID.'
      render :home
    end
  rescue RestClient::NotFound
    flash.now[:alert] = 'Flickr user not found.'
    render :home
  end
end
