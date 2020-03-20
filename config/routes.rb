Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/api/v1/snowflake/*dsn', to: 'snowflakes#fetch_data'
  get '/api/v1/snowflake', to: 'snowflakes#fetch_data_with_driver'
end
