Rails.application.routes.draw do
  root to: 'top#index'
  post 'top/index'
  get 'top/generate_tweet' => 'top#generate_tweet'

  get 'api' => 'top#api'
end
