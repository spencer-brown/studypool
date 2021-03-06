Studypool::Application.routes.draw do
  
  authenticated :user do
    root :to => "pages#dashboard", :as => "authenticated_root"
  end

  root :to => redirect("/home")

  get 'home' => 'pages#home'
  get 'dashboard' => 'pages#dashboard'
  get 'howto' => 'pages#howto'
  get 'getting_started' => 'pages#getting_started'
  get 'help' => 'pages#help'
  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :etherpads, path: 'studypads', only: ['show', 'new', 'create']
  resources :subjects, only: ['index', 'show']
  resources :groups, path: 'courses', only: 'show' do
    # allows 'apply' button to add current user to a class
    get 'apply', on: :member
    get 'remove', on: :member
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
