# app/controllers/static_pages_controller.rb
class StaticPagesController < ApplicationController
  require 'rest-client'
  require 'json'

  def home
  end

  # def photos
  #   user_id = params[:user_id]
  #   if user_id.present?
  #     json_response = RestClient.get("https://api.flickr.com/services/feeds/photos_public.gne?id=#{user_id}&format=json")
  #     @photos = JSON.parse(json_response.gsub('jsonFlickrFeed(', '').chomp(')'))['items']
  #   else
  #     flash.now[:alert] = 'Please enter a valid Flickr user ID.'
  #     render :home
  #   end
  # rescue RestClient::NotFound
  #   flash.now[:alert] = 'Flickr user not found.'
  #   render :home
  # end



  def photos
    user_id = params[:user_id]
    if user_id.present?
      flickr = Flickr.new "efef6cf594a7edd60a5e6d4135222033", "f9c0da0e7db09068"

      # Make sure to specify the extras parameter to fetch additional information
      photos = flickr.photos.search(user_id: user_id, extras: 'url_m, date_upload, tags')

      @photos = photos.map do |photo|
        {
          title: photo.title,
          link: photo.url_m, # Access the URL for the medium-sized photo
          media: {
            m: photo.url_m # Access the URL for the medium-sized photo
          },
          tags: photo.tags,
          published: Time.at(photo.dateupload.to_i).utc,
          author: flickr.people.getInfo(user_id: photo.owner).username,
          author_id: photo.owner,
        }
      end
      puts @photos
    else
      flash.now[:alert] = 'Please enter a valid Flickr user ID.'
      render :home
    end
  rescue Flickr::FailedResponse
    flash.now[:alert] = 'Flickr user not found.'
    render :home
  end
end
