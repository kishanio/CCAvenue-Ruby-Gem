#
# CCAvenue Gem V0.0.1
# CCAvenuePayment gateway implementaion
# MIT License
# by Kishan Thobhani (@kishanio)
#

require "ccavenue/version"

module Ccavenue

  class Payment

  	@merchant_Id = ""
  	@redirect_Url = ""
  	@working_Key = ""

  	# constructer to one time initialze genric keys
  	def initialize(merchant_Id,working_Key,redirect_Url)
  		@merchant_Id = merchant_Id
  		@redirect_Url = redirect_Url
  		@working_Key = working_Key
  	end

  	# request CCAvenue encrypted data

  	def request(order_Id,amount,billing_cust_name,billing_cust_address,billing_cust_city,billing_zip_code,billing_cust_state,billing_cust_country,billing_cust_email,billing_cust_tel,billing_cust_notes="",delivery_cust_name="",delivery_cust_address="",delivery_cust_city="",delivery_zip_code="",delivery_cust_state="",delivery_cust_country="",delivery_cust_email="",delivery_cust_tel="",delivery_cust_notes="")
  		checksum = getChecksum(order_Id,amount)
  		raw_request = "Merchant_Id=#{@merchant_Id}&Amount=#{amount}&Order_Id=#{order_Id}&Redirect_Url=#{@redirect_Url}&billing_cust_name=#{billing_cust_name}&billing_cust_address=#{billing_cust_address}&billing_cust_country=#{billing_cust_country}&billing_cust_state=#{billing_cust_state}&billing_cust_city=#{billing_cust_city}&billing_zip_code=#{billing_zip_code}&billing_cust_tel=#{billing_cust_tel}&billing_cust_email=#{billing_cust_email}&billing_cust_notes=#{billing_cust_notes}&delivery_cust_name=#{delivery_cust_name}&delivery_cust_address=#{delivery_cust_address}&delivery_cust_country=#{delivery_cust_country}&delivery_cust_state=#{delivery_cust_state}&delivery_cust_city=#{delivery_cust_city}&delivery_zip_code=#{delivery_zip_code}&delivery_cust_tel=#{delivery_cust_tel}&billing_cust_notes=#{delivery_cust_notes}&Checksum=#{checksum.to_s}"
  		return encrypt_data(raw_request,@working_Key,"AES-128-CBC")[0]
  	end

  	# calling response method to check if everything went well

  	def response(response)
  		raw_response = CGI::parse(decrypt_data(response,@working_Key,"AES-128-CBC"))

  		auth_desc = raw_response["AuthDesc"][0]
  		order_id = raw_response["Order_Id"][0]
  		amount = raw_response["Amount"][0]
  		checksum = raw_response["Checksum"][0]

  		verification = verifyChecksum(order_id,amount,auth_desc,checksum)
  		return auth_desc,verification,raw_response
  	end

  	private


	  	# @merchant_Id, @working_Key is provided by CCAvenues upon registration
	  	# order_Id has to be unique for each request.

	  	def getChecksum(order_Id,amount)
	  		str = "#{@merchant_Id}|#{order_Id}|#{amount}|#{@redirect_Url}|#{@working_Key}"
		    return Zlib::adler32(str,1)
	  	end

	  	# verify checksum response

		def verifyChecksum(  order_Id,  amount,  authDesc,  checksum) 
			String str = @merchant_Id+"|"+order_Id+"|"+amount+"|"+authDesc+"|"+@working_Key
			String newChecksum = Zlib::adler32(str).to_s
			return (newChecksum.eql?(checksum)) ? true : false
		end

	  	# encryption 

		def encrypt_data(data, key, cipher_type)
			vect = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f]
			iv = vect.pack("C*")
			key = hextobin(Digest::MD5.hexdigest(key))
			aes = OpenSSL::Cipher::Cipher.new(cipher_type)
			aes.encrypt
			aes.key = key
			aes.iv = iv if iv != nil
			en = aes.update(data) + aes.final      
			return en.unpack('H*')
		end

		# decryption

		def decrypt_data(encrypted_data, key, cipher_type)
			vect = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f]
			iv = vect.pack("C*")
			key = hextobin(Digest::MD5.hexdigest(key))
			encrypted_data = hextobin(encrypted_data)
			aes = OpenSSL::Cipher::Cipher.new(cipher_type)
			aes.decrypt
			aes.key = key
			aes.iv = iv if iv != nil
			dy = aes.update(encrypted_data) + aes.final  
			return dy
		end

		# hex-to-bin

		def hextobin(hexstring)

			length = hexstring.length
			binString = ""
			count = 0

			while count < length do
				substring = hexstring[count,2]
				substring = [substring]
				packedString = substring.pack('H*')
				
				if count == 0
					binString = packedString
				else
					binString +=packedString
				end

				count+=2
			end

			return binString
		end

  end

end
