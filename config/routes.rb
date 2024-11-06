Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :articles

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA files
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Customer routes
  root "customers#index"

  get "customers/alphabetized" => "customers#alphabetized", as: :customers_alphabetized
  get "customers/missing_email" => "customers#missing_email", as: :customers_missing_email

  # Add routes for all actions (new, create, edit, update, destroy)
  resources :customers, only: [:index, :new, :create, :edit, :update, :destroy]
end
