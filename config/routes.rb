Rails.application.routes.draw do
  # resources :users,only: [:show,:index]
  root to: 'homes#top'
  devise_for :users
  get 'home/about' => 'homes#about'
  resources :books do
    resource :favorites,only:[:create,:destroy]
    resources :post_comments,only:[:create,:destroy]
  end
  resources :users,only: [:show,:index,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get "followings" => "relationships#followings",as:"followings"
    get "followers" => "relationships#followers",as:"followers"
  end
  get "search" => "searches#search"


end