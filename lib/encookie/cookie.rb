module Rack
  module Session
    class Encookie
      def initialize(app, options={})
        @app = app
        @name = options[:name] || 'rack.session'
        @key = options[:key]
        @default_options = { domain: nil, path: '/'}.merge(options)
        fail 'A secret is required' unless @key
      end

      def call(env)
        load_session env
        status, headers, body = @app.call env
        commit_session env, status, headers, body
      end

      def load_session(env)
        request = Rack::Request.new env
        env['rack.session.options'] = @default_options.dup

        cookieval = request.cookies[@name]
        enc = cookieval_to_encrypted cookieval
        json = ::Encookie::Cryptor.decrypt ciphertext: enc.ciphertext, key: @key, iv: enc.iv, auth_tag: enc.auth_tag
        session_data = MultiJson.load json, symbolize_keys: true

        env['rack.session'] = session_data
      rescue
        env['rack.session'] = Hash.new
      end

      def commit_session(env, status, headers, body)
        options = env['rack.session.options']

        session_data = env['rack.session']
        json = MultiJson.dump session_data
        enc = ::Encookie::Cryptor.encrypt plaintext: json, key: @key
        cookieval = encrypted_to_cookieval enc

        if session_data.size > (4096 - @name.size)
          env['rack.errors'].puts 'Warning! Rack::Session::Cookie data size exceeds 4K. Content dropped.'
        else
          cookie = Hash.new
          cookie[:value] = cookieval
          cookie[:expires] = Time.now + options[:expire_after] unless options[:expire_after].nil?
          Utils.set_cookie_header! headers, @name, cookie.merge(options)
        end

        [status, headers, body]
      end

      def encrypted_to_cookieval(encrypted)
        combined = encrypted.iv + encrypted.auth_tag + encrypted.ciphertext
        Base64.urlsafe_encode64 combined
      end

      def cookieval_to_encrypted(cookieval)
        combined = Base64.urlsafe_decode64 cookieval
        iv = combined[0..11]
        auth_tag = combined[12..27]
        ciphertext = combined[28..-1]
        ::Encookie::Cryptor::Encrypted.new ciphertext, iv, auth_tag
      end
    end
  end
end
