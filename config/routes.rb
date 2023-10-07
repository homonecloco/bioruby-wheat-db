require 'sequenceserver'
require "#{Rails.root}/lib/links.rb"  
Rails.application.routes.draw do
  
  root 'wellcome#default'
  get 'wellcome/search_gene'
  
  post 'deletions/query_for_lines'
  get 'deletions/query_for_lines'
  
  resources :search  do
    collection do
      get 'list'
      post 'list'
      post 'redirect'
      get 'autocomplete'
      get 'sequence'
    end
  end

#Lines to make sequenceserver run.
  begin
    SequenceServer.init
   mount SequenceServer, :at => "sequenceserver"  
  rescue => exception
    Rails.logger.info "Unable to start sequence server: #{exception}"
  end  
  
end
