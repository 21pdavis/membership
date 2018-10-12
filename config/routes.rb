class SignupDomain
  def self.matches?(request)
    request.subdomain.empty?
  end
end
class OrganisationDomain
  def self.matches?(request)
    !SignupDomain.matches?(request)
  end
end

Rails.application.routes.draw do
  constraints SignupDomain do
    resources :organisations
    root "organisations#new"
  end

  constraints OrganisationDomain do
    resource :organisation, only: %w{edit update}, controller: 'organisation' do
      member do
        get :first_user
        post :create_admin
        get :setup
      end
    end
    devise_for :users, controllers: {
      registrations: 'users/registrations',
      confirmations: 'users/confirmations',
    }
    resources :members
    resources :groups do
      resources :group_users
      resources :group_memberships
      resources :mailouts do
        member do
          patch :send_email
        end
      end
    end
    get '/confirmation_needed', to: 'pages#confirmation_needed'
    root 'groups#index'
  end
end
