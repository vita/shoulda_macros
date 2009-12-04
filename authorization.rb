# Shoulda macros
module Authorization
  module Shoulda
    # options:
    #       :index
    # or    :edit, :id => 5
    # or    'show category', :action => :index, :id => 5
    # or    :update, :method => :put, :id => 5
    def should_not_be_authorized_for(name, options={})
      should "not be authorized for #{name}" do
        call_route(name, options)
        assert_redirected_to unauthorized_page_path
      end
    end

    # options:
    #         :index,
    #         [:update, {:method => :put, :id => 1}],
    #         ['destroy category', {:action => :destroy, :method => :put, :id => 1}]
    def should_not_be_authorized_for_actions(*actions)
      actions.each {|a|
        if a.kind_of?(Array)
          name = a[0]
          options = a[1]
        else
          name = a
        end
        should_not_be_authorized_for(name, options)
      }
    end

    # options:
    #       :index
    # or    :edit, :id => 5
    # or    'show category', :action => :index, :id => 5
    # or    :update, :method => :put, :id => 5
    def should_be_authorized_for(name, options={})
      should "be authorized for #{name}" do
        call_route(name, options)
        assert_response :success
      end
    end

    # options:
    #         :index,
    #         [:update, {:method => :put, :id => 1}],
    #         ['destroy category', {:action => :destroy, :method => :put, :id => 1}]
    def should_be_authorized_for_actions(*actions)
      actions.each {|a|
        if a.kind_of?(Array)
          name = a[0]
          options = a[1]
        else
          name = a
        end
        should_be_authorized_for(name, options)
      }
    end
  end
end

module Authorization
  module Shoulda
    module Helpers
      def call_route(name, options={})
        unless options.blank?
          method = options[:method] || :get
          action = options[:action] || name
          make_request method, action, options
        else
          make_request method, name
        end
      end

      def make_request(method, action, options={})
        case method
        when :post
          post action, options
        when :put
          put action, options
        when :delete
          delete action, options
        else
          get action, options
        end
      end
      
      def unauthorized_page_path
        'session/new'
      end
    end
  end
end

class Test::Unit::TestCase
  include Authorization::Shoulda::Helpers
end
Test::Unit::TestCase.extend(Authorization::Shoulda)
