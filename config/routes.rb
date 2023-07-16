Rails.application.routes.draw do
  
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  resources :my_pages, only:[:show, :edit]
  resources :favorites, only:[:create, :destroy, :show]
  resources :posts do
    collection do
      get 'map'
    end
  end
  
  root 'posts#map'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
