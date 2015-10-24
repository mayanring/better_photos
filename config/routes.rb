Rails.application.routes.draw do
  resources :recommendations, :only => [:index]

  root to: 'recommendations#index'
end
