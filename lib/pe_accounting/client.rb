require 'rest-client'
require 'multi_json'
require 'gyoku'
require 'nori'

module PeAccounting
  class PeAccouningError < StandardError; end

  class Client


    # Initializes the API Client
    #
    # @param [String] token - API token
    # @param [Symbol] format - :xml or :json - :xml by default
    # @param [Type] endpoint = 'https://my.accounting.pe/api/v1/'. This shouldn't change
    # @return [PeAccounting::Client] A PeAccounting::Client object
    def initialize(token, format = :xml, endpoint = 'https://my.accounting.pe/api/v1/')
      unless [:xml,:json].include?(format)
        raise PeAccouningError, 'You must specify a Company ID and a request'
      end
      @format = format
      @token = token
      @endpoint = endpoint
    end


    def get(kwargs = {})
      unless kwargs[:company_id] && kwargs[:request]
        raise PeAccouningError, 'You must specify a Company ID and a request'
      end

      request(:get, url(kwargs[:company_id], kwargs[:request]))
    end

    def put(kwargs = {})
      unless kwargs[:company_id] && kwargs[:request] && kwargs[:payload]
        raise PeAccouningError, 'You must specify a company_id, a request, and a payload'
      end
      request(:put, url(kwargs[:company_id], kwargs[:request]),
              kwargs[:payload])
    end

    def post(kwargs = {})
      unless kwargs[:company_id] && kwargs[:request] && kwargs[:payload]
        raise PeAccouningError, 'You must specify a company_id, a request, and a payload'
      end

      request(:post, url(kwargs[:company_id], kwargs[:request]),
              kwargs[:payload])
    end

    def delete(kwargs = {})
      unless kwargs[:company_id] && kwargs[:request]
        raise PeAccouningError, 'You must specify a Company ID and a request'
      end
      request(:delete, url(kwargs[:company_id], kwargs[:request]))
    end

    private

    def url(company_id, path)
      "#{@endpoint}company/#{company_id}/#{path}"
    end

    def generate_payload(payload)
      if payload
        if @format == xml
          Gyoku.xml(payload)
        else
          MultiJson.dump(payload)
        end
      end
    end

    def handle_body(body)
      if @format == :xml
        parser = Nori.new
        parser.parse(body)
      else
        hash = MultiJson.load(body)
        hash.length == 1 ? hash.values.first : hash
      end
    end

    def request(method, url, payload = nil)
      res = RestClient::Request.execute(method: method, url: url,
                                        payload: generate_payload(payload),
                                        headers: { content_type: @format,
                                                   x_token: @token })
      handle_body(res.body)
    end

    def file_to_json(file)
      file.read.each_byte.map { |b| b.to_s(16) }.to_json
    end
  end
end
