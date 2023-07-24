
# config/routes.rb
Rails.application.routes.draw do
  root 'static_pages#home'
  get 'flickr_photos', to: 'static_pages#photos'
end
