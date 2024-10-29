# Kong plugins: SOAP/XML Handling for Request and Response
This repository concerns Kong plugins developed in Lua and uses the GNOME C libraries [libxml2](https://gitlab.gnome.org/GNOME/libxml2#libxml2) and [libxslt](https://gitlab.gnome.org/GNOME/libxslt#libxslt) (for XSLT 1.0). Part of the functions are bound in the [XMLua/libxml2](https://clear-code.github.io/xmlua/) library.
Both GNOME C and XMLua/libxml2 libraries are already included in [kong/kong-gateway](https://hub.docker.com/r/kong/kong-gateway) Enterprise Edition Docker image, so you don't need to rebuild a Kong image.

The XSLT Transformation can also be managed with the [saxon](https://www.saxonica.com/html/welcome/welcome.html) library, which supports XSLT 2.0 and 3.0. With XSLT 2.0+ there is a way for applying JSON <-> XML transformation with [fn:json-to-xml](https://www.w3.org/TR/xslt-30/#func-json-to-xml) and [fn:xml-to-json](https://www.w3.org/TR/xslt-30/#func-xml-to-json). The `saxon` library is not included in the Kong Docker image, see [SAXON.md](SAXON.md) for how to integrate saxon with Kong. It's optional, don't install `saxon` library if you don't need it.

These plugins don't apply to Kong OSS. They work for Kong EE and Konnect.

The plugins handle the SOAP/XML **Request** and/or the SOAP/XML **Response** in this order:

**soap-xml-request-handling** plugin to handle Request:

1) `XSLT TRANSFORMATION - BEFORE XSD`: Transform the XML request with XSLT (XSLTransformation) before step #2
2) `WSDL/XSD VALIDATION`: Validate XML request with its WSDL/XSD schema
3) `XSLT TRANSFORMATION - AFTER XSD`: Transform the XML request with XSLT (XSLTransformation) after step #2
4) `ROUTING BY XPATH`: change the Route of the request to a different hostname and path depending of XPath condition

**soap-xml-response-handling** plugin to handle Reponse:

5) `XSLT TRANSFORMATION - BEFORE XSD`: Transform the XML response before step #6
6) `WSDL/XSD VALIDATION`: Validate the XML response with its WSDL/XSD schema
7) `XSLT TRANSFORMATION - AFTER XSD`:  Transform the XML response after step #6

Each handling is optional. In case of misconfiguration the Plugin sends to the consumer an HTTP 500 Internal Server Error `<soap:Fault>` (with the error detailed message).

![Alt text](/images/Pipeline-Kong-soap-xml-handling.png?raw=true "Kong - SOAP/XML execution pipeline")

![Alt text](/images/Kong-Manager.png?raw=true "Kong - Manager")


## `soap-xml-request-handling` and `soap-xml-response-handling` configuration reference
|FORM PARAMETER                 |DEFAULT          |DESCRIPTION                                                 |
|:------------------------------|:----------------|:-----------------------------------------------------------|
|config.ExternalEntityLoader_Async|false|Download asynchronously the XSD schema from an external entity (i.e.: http(s)://)|
|config.ExternalEntityLoader_CacheTTL|3600|Keep the XSD schema in Kong memory cache during the time specified (in second). It applies for synchronous and asynchronous XSD download|
|config.ExternalEntityLoader_Timeout|1|Tiemout in second for XSD schema downloading. It applies for synchronous and asynchronous XSD download|
|config.RouteToPath|N/A|URI Path to change the route dynamically to the Web Service. Syntax is: `scheme://kong_upstream/path`|
|config.RouteXPath|N/A|XPath request to extract a value from the request body and to compare it with `RouteXPathCondition`|
|config.RouteXPathCondition|N/A|XPath value to compare with the value extracted by `RouteXPath`. If the condition is satisfied the route is changed to `RouteToPath`|
|config.RouteXPathRegisterNs|Pre-defined|Register Namespace to enable XPath request. The syntax is `name,namespace`. Mulitple entries are allowed (example: `name1,namespace1,name2,namespace2`)|
|config.VerboseRequest|false|`soap-xml-request-handling` only: enable a detailed error message sent to the consumer. The syntax is `<detail>...</detail>` in the `<soap:Fault>` message|
|config.VerboseResponse|false|`soap-xml-response-handling` only: see above|
|config.xsdApiSchema|false|WSDL/XSD schema used by `WSDL/XSD VALIDATION` for the Web Service tags|
|config.xsdApiSchemaInclude|false|XSD content included in the plugin configuration. It's related to `xsdApiSchema`. It avoids downloading content from external entity (i.e.: http(s)://). The include has priority over the download from external entity|
|config.xsdSoapSchema|Pre-defined|WSDL/XSD schema used by `WSDL/XSD VALIDATION` for the `<soap>` tags: `<soap:Envelope>`, `<soap:Header>`, `<soap:Body>`|
|config.xsltLibrary|libxslt|Library name for `XSLT TRANSFORMATION`. Select `saxon` for supporting XSLT 2.0 or 3.0
|config.xsltTransformAfter|N/A|`XSLT` definition used by `XSLT TRANSFORMATION - AFTER XSD`|
|config.xsltTransformBefore|N/A|`XSLT` definition used by `XSLT TRANSFORMATION - BEFORE XSD`|

## How to deploy SOAP/XML Handling plugins in Kong Gateway (standalone) | Docker
1) Do a Git Clone of this repo
```sh
git clone https://github.com/jeromeguillaume/kong-plugin-soap-xml-handling.git
```
2) Create and prepare a PostgreDB called `kong-database-soap-xml-handling`.
[See documentation](https://docs.konghq.com/gateway/latest/install/docker/#prepare-the-database)
3) Provision a license of Kong Enterprise Edition and put the content in `KONG_LICENSE_DATA` environment variable. The following license is only an example. You must use the following format, but provide your own content
```sh
 export KONG_LICENSE_DATA='{"license":{"payload":{"admin_seats":"1","customer":"Example Company, Inc","dataplanes":"1","license_creation_date":"2023-04-07","license_expiration_date":"2023-04-07","license_key":"00141000017ODj3AAG_a1V41000004wT0OEAU","product_subscription":"Konnect Enterprise","support_plan":"None"},"signature":"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b","version":"1"}}'
```
4) Start the standalone Kong Gateway
```sh
./start-kong.sh
```

## How to deploy SOAP/XML Handling plugins **schema** in Konnect (Control Plane) for Kong Gateway
1) Do a Git Clone of this repo (if it’s not done yet):
```sh
git clone https://github.com/jeromeguillaume/kong-plugin-soap-xml-handling.git
```
2) Login to Konnect
3) Select the `Kong Gateway` in the Gateway Manager
4) Click on `Plugins`
5) Click on `+ New Plugin`
6) Click on `Custom Plugins`
7) Click on `Create` Custom Plugin
8) Click on `Select file` and open the [schema.lua](kong/plugins/soap-xml-request-handling/schema.lua) of `soap-xml-request-handling`
9) Click on `Save`

Repeat from step #6 and open the [schema.lua](kong/plugins/soap-xml-response-handling/schema.lua) of `soap-xml-response-handling`

## How to deploy SOAP/XML Handling plugins **schema** in Konnect (Control Plane) for Kong Ingress Controller (KIC)
1) Do a Git Clone of this repo (if it’s not done yet):
```sh
git clone https://github.com/jeromeguillaume/kong-plugin-soap-xml-handling.git
```
2) Login to Konnect
3) Create a Personal Access Token (starting by `kpat_`) or System Account Access Token (starting by `spat_`). [See documentation](https://docs.konghq.com/konnect/gateway-manager/declarative-config/#generate-a-personal-access-token)
4) From the `Overview` page of KIC-Gateway manager page, get the KIC `id`
5) Upload the custom plugin schema of `soap-xml-request-handling` by using the Konnect API:
```sh
cd ./kong-plugin-soap-xml-handling/kong/plugins/soap-xml-request-handling
https -A bearer -a <**REPLACE_BY_ACCESS_TOKEN_VALUE**> eu.api.konghq.com/v2/control-planes/<**REPLACE_BY_KIC_ID**>/core-entities/plugin-schemas lua_schema=@schema.lua
```
The expected response is:
```
HTTP/1.1 201 Created
```
Repeat step #5 with the schema.lua of `soap-xml-response-handling` by changing the directory:
```sh
cd -
cd ./kong-plugin-soap-xml-handling/kong/plugins/soap-xml-response-handling
```

## How to deploy SOAP/XML Handling plugins in Kong Gateway (Data Plane) | Kubernetes
1) Do a Git Clone of this repo (if it’s not done yet):
```sh
git clone https://github.com/jeromeguillaume/kong-plugin-soap-xml-handling.git
```
2) Create `configMaps`
- `configMaps` for the custom plugins (Request and Response)
```sh
cd ./kong-plugin-soap-xml-handling/kong/plugins
kubectl -n kong create configmap soap-xml-request-handling --from-file=./soap-xml-request-handling
kubectl -n kong create configmap soap-xml-response-handling --from-file=./soap-xml-response-handling
```
- Create a `configMap` for the shared library
```sh
kubectl -n kong create configmap soap-xml-handling-lib --from-file=./soap-xml-handling-lib
```
- Include `subdirectories` of the library
```sh
cd soap-xml-handling-lib

kubectl -n kong create configmap libxml2ex --from-file=./libxml2ex
kubectl -n kong create configmap libxslt --from-file=./libxslt
```
3) [See Kong Gateway on Kubernetes documentation](https://docs.konghq.com/gateway/latest/install/kubernetes/proxy/) and add the following properties to the helm `values.yaml`:
```yaml
image:
  repository: kong/kong-gateway
  ...
env:
  plugins: bundled,soap-xml-request-handling,soap-xml-response-handling
...
plugins:
  configMaps:
  - pluginName: soap-xml-request-handling
    name: soap-xml-request-handling
  - pluginName: soap-xml-response-handling
    name: soap-xml-response-handling
  - pluginName: soap-xml-handling-lib
    name: soap-xml-handling-lib
    subdirectories:
    - name: libxml2ex
      path: libxml2ex
    - name: libxslt
      path: libxslt
```
4) Execute the `helm` command:
```sh
helm install kong kong/kong -n kong --values ./values.yaml
```

# Execution

1) Create a service with configuration something like this:

  ```
  connect_timeout: 60000
  read_timeout: 60000
  host: httpbin.org
  path: /anything
  enabled: true
  name: test
  retries: 5
  protocol: https
  port: 443
  write_timeout: 60000
  id: 30eff71a-0180-4886-9a6c-3c1e28bd5251
  ```

2) Create a route with similar config:

  ```
  paths:
    - /mock
  preserve_host: false
  service:
    id: 30eff71a-0180-4886-9a6c-3c1e28bd5251
  path_handling: v0
  name: test
  regex_priority: 0
  request_buffering: true
  response_buffering: true
  https_redirect_status_code: 426
  protocols:
    - http
    - https
  strip_path: true
  id: 359ede19-a2e3-4e20-9ef4-16e1eaadb47a
  ```

3) Enable the `soap-xml-request-handling-plugin` on the created route with the following config:

  - Ensure the following values are configured on the plugin:
    a. `XsltLibrary`: `saxon`
    b. `VerboseRequest`: true
    c. `xsdSoapSchema`: see [file](./resources/xsdSoapSchema.xml)
    d. `XsltTransformAfter`: see [file](./resources/xsltTransformAfter.xml)

  - config resembles something like this
    ```
    enabled: true
    name: soap-xml-request-handling
    config:
      RouteToPath: null
      xsdApiSchema: null
      xsdApiSchemaInclude: {}
      ExternalEntityLoader_Async: false
      xsltLibrary: saxon
      ExternalEntityLoader_Timeout: 1
      xsltTransformBefore: null
      ExternalEntityLoader_CacheTTL: 3600
      VerboseRequest: true
      RouteXPathRegisterNs:
        - soap,http://schemas.xmlsoap.org/soap/envelope/
      xsltTransformAfter: >-
        <xsl:stylesheet      version="3.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fn="http://www.w3.org/2005/xpath-functions"
        exclude-result-prefixes="fn">      <xsl:mode
        on-no-match="shallow-skip"/>     <xsl:output method="text" />
        <xsl:template match="/Request">         <xsl:variable
        name="json-result">             <map
        xmlns="http://www.w3.org/2005/xpath-functions">                 <map
        key="transaction">                     <string
        key="request_id"><xsl:value-of
        select="request_id"/></string>                     <string
        key="notification_url"><xsl:value-of
        select="notification_urb"/></string>                     <string
        key="response_url"><xsl:value-of
        select="response_urb"/></string>                     <string
        key="cancel_url"><xsl:value-of
        select="cancel_urb"/></string>                     <string
        key="pchannel"/>                     <string
        key="payment_notification_status">1</string>                     <string
        key="payment_notification_channel"/>                     <string
        key="amount"><xsl:value-of select="amount"/></string>
        <string key="currency"><xsl:value-of
        select="currency"/></string>                     <string
        key="trx_type"><xsl:value-of select="trxType"/></string>
        <string key="signature"><xsl:value-of
        select="signature"/></string>                 </map>                  <map
        key="billing_info">                     <string
        key="billing_address1"><xsl:value-of
        select="address1"/></string>                     <string
        key="billing_address2"><xsl:value-of
        select="address2"/></string>                     <string
        key="billing_city"><xsl:value-of
        select="city"/></string>                     <string
        key="billing_state"><xsl:value-of
        select="state"/></string>                     <string
        key="billing_country"><xsl:value-of
        select="country"/></string>                     <string
        key="billing_zip"><xsl:value-of select="zip"/></string>
        </map>                  <map key="shipping_info">
        <string key="shipping_address1"><xsl:value-of
        select="address1"/></string>                     <string
        key="shipping_city">Quezon City</string>                     <string
        key="shipping_state">Metro Manila Area</string>                     <string
        key="shipping_country"><xsl:value-of
        select="country"/></string>                     <string
        key="shipping_zip">1229</string>                 </map>
        <map key="customer_info">                     <string
        key="fname"><xsl:value-of select="name"/></string>
        <string key="lname"><xsl:value-of
        select="lname"/></string>                     <string
        key="mname"><xsl:value-of select="mname"/></string>
        <string key="email"><xsl:value-of
        select="email"/></string>                     <string
        key="phone"><xsl:value-of select="phone"/></string>
        <string key="mobile"><xsl:value-of
        select="mobile"/></string>                     <string
        key="dob"/>                     <string key="signature"><xsl:value-of
        select="signature"/></string>                 </map>                  <map
        key="order_details">                     <array
        key="orders">                         <xsl:for-each
        select="orders/items">
        <map>                                 <string key="itemname"><xsl:value-of
        select="itemname"/></string>                                 <number
        key="quantity"><xsl:value-of
        select="quantity"/></number>                                 <string
        key="unitprice"><xsl:value-of
        select="amount"/></string>                                 <string
        key="totalprice"><xsl:value-of
        select="amount"/></string>
        </map>                         </xsl:for-each>
        </array>                     <string key="subtotalprice"><xsl:value-of
        select="amount"/></string>                     <string
        key="shippingprice">0.00</string>                     <string
        key="discountamount">0.00</string>                     <string
        key="totalorderamount"><xsl:value-of
        select="amount"/></string>                 </map>             </map>
        </xsl:variable>          <xsl:value-of select="fn:xml-to-json($json-result)"
        />     </xsl:template> </xsl:stylesheet>
      xsdSoapSchema: >-
        <?xml version="1.0" encoding="UTF-8"?> <xs:schema
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        attributeFormDefault="unqualified"
        elementFormDefault="qualified">      <!-- Root element -->     <xs:element
        name="Request" type="RequestType"/>      <!-- Complex type for items within
        orders -->     <xs:complexType name="ItemType">
        <xs:sequence>             <xs:element name="itemname"
        type="xs:string"/>             <xs:element name="quantity"
        type="xs:integer"/>             <xs:element name="amount"
        type="xs:decimal"/>         </xs:sequence>     </xs:complexType>      <!--
        Complex type for orders -->     <xs:complexType name="OrdersType">
        <xs:sequence>             <xs:element name="items" type="ItemType"
        maxOccurs="unbounded"/>         </xs:sequence>     </xs:complexType>
        <!-- Complex type for the entire request -->     <xs:complexType
        name="RequestType">         <xs:sequence>             <xs:element
        name="orders" type="OrdersType"/>             <xs:element name="mid"
        type="xs:string"/>             <xs:element name="request_id"
        type="xs:string"/>             <xs:element name="ip_address"
        type="xs:string"/>             <xs:element name="notification_urb"
        type="xs:anyURI"/>             <xs:element name="response_urb"
        type="xs:anyURI"/>             <xs:element name="cancel_urb"
        type="xs:anyURI"/>             <xs:element name="mtac_urb"
        type="xs:anyURI"/>             <xs:element name="descriptor_note"
        type="xs:string" minOccurs="0"/>             <xs:element name="name"
        type="xs:string"/>             <xs:element name="lname"
        type="xs:string"/>             <xs:element name="mname" type="xs:string"
        minOccurs="0"/>             <xs:element name="address1"
        type="xs:string"/>             <xs:element name="address2"
        type="xs:string"/>             <xs:element name="city"
        type="xs:string"/>             <xs:element name="state"
        type="xs:string"/>             <xs:element name="country"
        type="xs:string"/>             <xs:element name="zip"
        type="xs:string"/>             <xs:element name="secure3d"
        type="xs:string"/>             <xs:element name="trxType"
        type="xs:string"/>             <xs:element name="email"
        type="xs:string"/>             <xs:element name="phone"
        type="xs:string"/>             <xs:element name="mobile"
        type="xs:string"/>             <xs:element name="client_ip"
        type="xs:string"/>             <xs:element name="amount"
        type="xs:decimal"/>             <xs:element name="currency"
        type="xs:string"/>             <xs:element name="logo_url"
        type="xs:anyURI"/>             <xs:element name="method" type="xs:string"
        minOccurs="0"/>             <xs:element name="signature"
        type="xs:string"/>         </xs:sequence>     </xs:complexType>
        </xs:schema>
      RouteXPath: null
      RouteXPathCondition: null
    protocols:
      - grpc
      - grpcs
      - http
      - https
    route:
      id: 359ede19-a2e3-4e20-9ef4-16e1eaadb47a
    id: 8b684dca-9a53-4710-a5c7-e79be339c816
    ```
4) Test the endpoint

  - Import this cURL to Insomnia or call it as it is in CLI

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

5) See JSON in the echo-ed response instead of the original XML payload - showing the xslt stylesheet transformed the request body from XML to JSON

  ![](/kong-plugin-soap-xml-handling-xslt/images/result.png)
