require 'sinatra/base'

module Sinatra
  module Index

    def self.registered(app)
      app.set :static_indices, []

      app.before do
        if app.static? && (request.get? || request.head?)
          orig_path = request.path_info
          path      = unescape(orig_path)
          query     = !request.query_string.empty? ? request.query_string : nil
          host      = request.host
          redirect_code = 301

          if !path.end_with?('/') && !path.to_s.include?('.')
            path = path << '/'
            url_options = { host: host, path: path, query: query }

            if ENV['RACK_ENV'] == 'development'
              url_options[:port] = 9292
              redirect_code = 302
            end

            # build the new URL based on the requested scheme
            if request.scheme == 'https'
              new_url = URI::HTTPS.build(url_options)
            else
              new_url = URI::HTTP.build(url_options)
            end

            redirect new_url, redirect_code
          end

          app.static_indices.each do |idx|
            request.path_info = path + idx
            static!
          end

          request.path_info = orig_path
        end 
      end
    end

    def use_static_indices(*args)
      static_indices.concat(args.flatten)
    end

    alias_method :use_static_index, :use_static_indices
  end

  register Index
end
