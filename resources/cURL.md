```
curl --request GET \
  --url http://localhost:1000/mock \
  --header 'Content-Type: application/xml' \
  --header 'User-Agent: insomnia/9.3.2' \
  --header 'apikey: jN8lJH1cTA9MRddpRSaC5m5nDMfJgUjk' \
  --data '<?xml version="1.0" encoding="utf-8" ?>
<Request>
  <orders>
    <items>
      <itemname>ST. CLAIRE</itemname>
      <quantity>1</quantity>
      <amount>73800.00</amount>
    </items>
  </orders>
  <mid>xxxxx</mid>
  <request_id>123456789652376</request_id>
  <ip_address>202.126.44.100</ip_address>
  <notification_urb>https://webhook.site/32423</notification_urb>
  <response_urb>http://www.paynamics.com/response</response_urb>
  <cancel_urb>http://www.paynamics.com/cancel</cancel_urb>
  <mtac_urb>http://www.paynamics.com/mtac</mtac_urb>
  <descriptor_note />
  <name>Juan</name>
  <lname>Delacruz</lname>
  <mname />
  <address1>First Street</address1>
  <address2>H.V. dela Costa Street</address2>
  <city>Makati</city>
  <state>Metro Manila</state>
  <country>PH</country>
  <zip>1227</zip>
  <secure3d>try3d</secure3d>
  <trxType>sale</trxType>
  <email>juandelacruz@paynamics.net</email>
  <phone>330-8227</phone>
  <mobile>09171632407</mobile>
  <client_ip>202.126.44.100</client_ip>
  <amount>73800.00</amount>
  <currency>PHP</currency>
  <logo_url>https://testpi.payserv.net/webpayment/resources/images/paynamics_logo.png</logo_url>
  <method />
  <signature>xxxxx</signature>
</Request>
'
```
