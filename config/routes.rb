Rails.application.routes.draw do
  root to: 'top#index'
  post 'top/index'

  get 'api' => 'top#api'

end
