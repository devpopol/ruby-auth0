module Auth0
  module Api
    module V2
      module UserBlocks
        attr_reader :user_blocks_path

        def user_blocks(options = {})
          if present?(options.fetch(:user_id, nil)) ^ present?(options.fetch(:identifier, nil))
            get_user_blocks(options)
          else
            fail Auth0::MissingParameter, 'Must supply user_id or identifier but not both'
          end
        end

        def unblock(user_id)
          fail Auth0::MissingUserId, 'Must supply a valid user_id' if user_id.to_s.empty?
          path = format("%s/%s", user_blocks_path, user_id)
          delete(path)
        end

        def unblock_identifier(identifier)
          fail Auth0::MissingParameter, 'Must supply a string identifier' if identifier.to_s.empty?
          request_params = {
            identifier: identifier
          }
          result = self.class.send(:delete, user_blocks_path, query: request_params)
          result.code == 204
        end

        private
        def present?(param)
          !param.to_s.empty?
        end

        def get_user_blocks(options = {})
          request_params = {}
          path = user_blocks_path
          if present? options[:user_id]
            path = "#{path}/#{options[:user_id]}"
          else
            request_params[:identifier] = options.fetch(:identifier, nil)
          end

          get(user_blocks_path, request_params)
        end

        # Users API path
        def user_blocks_path
          @user_blocks_path ||= '/api/v2/user-blocks'
        end
      end
    end
  end
end
