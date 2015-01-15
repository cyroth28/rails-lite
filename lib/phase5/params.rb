require 'uri'
require 'byebug'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below

    def initialize(req, route_params = {})
      @params = route_params
      if req.query_string
        @params.merge!(parse_www_encoded_form(req.query_string))
      elsif req.body
        @params.merge!(parse_www_encoded_form(req.body))
      end
      @params
    end

    def [](key)
      @params[key]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      params = {}
      parsed_form = URI.decode_www_form(www_encoded_form)
      parsed_form.each do |key_blob, val|
        node = params
        key_array = parse_key(key_blob)
        key_array.each_with_index do |key, idx|
          if idx == key_array.length - 1
            node[key] ||= val
          else
            node[key] = {}
            node = node[key]
          end
        end
      end
      params
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\[|\]\[|\]/)
    end
  end
end