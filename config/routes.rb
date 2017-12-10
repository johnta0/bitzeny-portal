Rails.application.routes.draw do
  root to: 'top#index'
  post 'top/index'
  post '/generate_tweet' => 'top#generate_tweet'

  get 'api' => 'top#api'
end
