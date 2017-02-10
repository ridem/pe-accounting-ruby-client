require 'multi_json'
require 'gyoku'
require 'nori'
require 'uri'
require 'net/http'

module PeAccounting
  class PeAccouningError < StandardError; end

  class Client

    # Initializes an API Client
    #
    # @param token [String] The API token
    # @param company_id [Integer] The company ID
    # @param format [Symbol] The format by which the wrapper will interact with the API.
    #   `:xml` or `:json - leave empty for :json by default
    # @param endpoint [String] 'https://my.accounting.pe/api/v1/' by default. This shouldn't change.
    # @return [PeAccounting::Client] A PeAccounting::Client object
    #
    # @example
    #   api = PeAccounting::Client.new("your-api-token", 123)
    def initialize(token, company_id, format = :json, endpoint = 'https://my.accounting.pe/api/v1/')
      @company_id = company_id
      @format = format
      @token = token
      @endpoint = endpoint
    end


    # Performs a GET request
    #
    # @param request [String] The endpoint to perform the request to, e.g. `client`
    # @return [Hash, Array] A hash or an array, depending on the specs
    #
    # @example
    #   api.get('client')
    def get(request)
      unless request
        raise PeAccouningError, 'You must specify a request'
      end

      request(:get, uri(request))
    end

    # Performs a PUT request
    #
    # @param request [String] The options to pass to the method
    # @param payload [Hash] A native Ruby hash describing the data to send
    # @param root [String] The enclosing root of the object (useful for xml)
    # @return [Hash] A hash containing the result of the request
    #
    # @example
    #   api.put('client', {name: "John Doe"})
    def put(request, payload = {}, root = nil)
      unless request
        raise PeAccouningError, 'You must specify a request'
      end
      payload = (root ? {root => payload} : payload)
      request(:put, uri(request), payload)
    end

    # Performs a POST request
    #
    # (see #put)
    #
    # @example
    #   api.post('client/123', {name: "John Doe"})
    def post(request, payload = {}, root = nil)
      unless request
        raise PeAccouningError, 'You must specify a request'
      end
      payload = (root ? {root => payload} : payload)
      request(:post, uri(request), payload)
    end

    # Performs a DELETE request
    #
    # (see #get)
    #
    # @example
    #   api.delete('client/123')
    def delete(request)
      unless request
        raise PeAccouningError, 'You must specify a request'
      end
      request(:delete, uri(request))
    end

    # Public for debugging purposes
    def generate_payload(payload)
      if @format == :xml
        Gyoku.xml(payload)
      else
        MultiJson.dump(payload)
      end
    end

    private

    def uri(path)
      URI.parse("#{@endpoint}company/#{@company_id}/#{path}")
    end

    # Unused for now, but can be useful for object editing if we go more high-level
    def denilize(h)
      h.each_with_object({}) { |(k,v),g|
        g[k] = (Hash === v) ?  denilize(v) : v ? v : '' }
    end

    def handle_body(body)
      if @format == :xml
        parser = Nori.new(convert_dashes_to_underscores: false,
        empty_tag_value: "")
        hash = parser.parse(body)
      else
        hash = MultiJson.load(body)
      end

      # Try to get a more proper ruby object when doing JSON 
      if @format == :json
        while hash.is_a?(Hash) && hash.length == 1
          hash = hash.values.first
        end
      end
      hash
    end

    def request(method, uri, payload = nil)
      req = Net::HTTP.const_get(method.capitalize, false).new(uri)
      req.content_type = "application/#{@format.downcase}"
      req['X-Token'] = @token
      req.body = generate_payload(payload) if payload

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      case res
      when Net::HTTPSuccess
        return handle_body(res.body)
      else
        raise PeAccouningError, (res.read_body ? handle_body(res.body) : res)
      end
    end
  end
end
