require 'rubygems'
require 'sinatra/base'

module Sinatra
  module Index
    def use_static_indices(*args)
      @_static_indices = args.flatten
      
      before do
        if settings.static? && (request.get? || request.head?)
          orig_path = request.path_info
          path = unescape orig_path
          path = path << '/' unless path.end_with? '/'
          
          @_static_indices.each do |idx|
            request.path_info = path + idx
            static!
          end
          
          request.path_info = orig_path
        end
      end
      
    end
    
    alias_method :use_static_index, :use_static_indices
  end
  
  register Index
end
