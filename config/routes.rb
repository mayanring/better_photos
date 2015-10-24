Rails.application.routes.draw do
  resources :recommendations, :only => [:index]
end
