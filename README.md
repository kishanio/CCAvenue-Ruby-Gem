CCAvenue Payment Gateway Ruby Gem
===================================

[CCAvenue Payment Gateway](https://www.ccavenue.com)

####Demo & Other resources: ####


####Dependency: ####

None

Encryption & Decryption are implemented in core Ruby itself.

####Usage:####

**_Rails:_**

**GEMFILE**

    gem 'ccavenue'

    # application_controller.rb
    
    # Create an instace with merchantid, workingkey and redirect url as parameter
    def ccavenue
        return @ccavenue = Ccavenue::Payment.new(<TODO: MERCHANT ID>,<TODO: MERCHANT WORKING KEY>,<TODO: REDIRECT URL>)
    end


**orders page to redirect to payment gateway**
    
    def send_to_ccavenue
        
        # process order
        
        # Merchant id needed in view
        @CCAVENUE_MERCHANT_ID = APP_CONFIG[:ave_merchant_id]
        
        # CCAvenue requires a new order id for each request so if transaction fails we can use #same ones again accross our website.
        
        order_id =  Time.now.strftime('%d%m%H%L') + <TODO: Order Id>
        
        # Parameters:
        # 
        #   order_id
        #   price
        #   billing_name
        #   billing_address
        #   billing_city
        #   billing_zip
        #   billing_state
        #   billing_country
        #   billing_email
        #   billing_phone
        #   billing_notes
        #   delivery_name
        #   delivery_address
        #   delivery_city
        #   delivery_zip
        #   delivery_state
        #   delivery_country
        #   delivery_email
        #   delivery_phone
        #   delivery_notes
        #
        #   Mandatory - order_id,price,billing_name,billing_address,billing_city,billing_zip,billing_state,billing_country,billing_email,billing_phone
        #   Optional - billing_notes,delivery_name,delivery_address,delivery_city,delivery_zip,delivery_state,delivery_country,delivery_email,delivery_phone,delivery_notes
        
        @encRequest = ccavenue.request(order_id,<TODO: Price>,@order.full_name,"#{@order.address1} ,#{@order.address2}",@order.city,@order.zip,@order.state,@order.country,@order.email,@order.phone)

        render "<TODO: Redirect Page>"
    end


**Redirect view**
    
    <form id="redirect" method="post" name="redirect" action="http://www.ccavenue.com/shopzone/cc_details.jsp">
        <input type="hidden" name="encRequest" value="<%= @encRequest %>">
        <input type="hidden" name="Merchant_Id" value="<%=@CCAVENUE_MERCHANT_ID%>">
    </form>

    <script>
    document.getElementById("redirect").submit();   
    </script>
    
**payment confirmation page post payment**
    
    def payment_confirm   # Method post 
    
        # parameter to response is encrypted reponse we get from CCavenue
        # return parameters are Auth Description: <String: Payment Failed/Success>, Checksum Verification <Bool: True/False>, Data: <HASH/Array: Order_id, amount etc>
        
        authDesc,verify,data = ccavenue.response(params['encResponse'])
        
        order_Id = data["Order_Id"][0]
        
        # post proccessing can be done here like sending email etc.
    end
    
    

The MIT License
===============

Copyright 2014 Kishan Thobhani

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.