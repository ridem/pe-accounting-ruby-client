require 'pe_accounting/client/version'

require 'rest-client'
require 'multi_json'

module PeAccounting
  class PeAccouningError < StandardError; end

  class Client
    def initialize(token, endpoint = 'https://my.accounting.pe/api/v1/')
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

      request(:put, url(kwargs[:company_id], kwargs[:request]), kwargs[:payload]))
    end

    def post(kwargs = {})
      unless kwargs[:company_id] && kwargs[:request] && kwargs[:payload]
        raise PeAccouningError, 'You must specify a company_id, a request, and a payload'
      end

      request(:post, url(kwargs[:company_id], kwargs[:request]), kwargs[:payload]))

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

    def request(method, url, payload = nil)
      res = RestClient::Request.execute(method: method, url: url,
                                        payload: MultiJson.dump(payload),
                                        headers: { content_type: :json,
                                          x_token: @token })
      hash = MultiJson.load(res.body)
      hash.length == 1 ? hash.values.first : hash
    end

    def file_to_json(file)
      file.read.each_byte.map { |b| b.to_s(16) }.to_json
    end
  end
end
