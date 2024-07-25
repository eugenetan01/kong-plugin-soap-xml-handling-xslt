-- Notes:
-- Some characters, called magic characters, have special meanings when used in a pattern. The magic characters are
-- ( ) . % + - * ? [ ^ $

local helpers = require "spec.helpers"
local request_common = {}

request_common.calculator_Request= [[
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <Add xmlns="http://tempuri.org/">
      <intA>5</intA>
    </Add>
  </soap:Body>
</soap:Envelope>
]]

request_common.calculator_Subtract_Request = [[
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
	<soap:Body>
		<Subtract xmlns="http://tempuri.org/">
			<intA>5</intA>
		</Subtract>
	</soap:Body>
</soap:Envelope>
]]

request_common.calculator_Response = [[
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <soap:Body>
    <AddResponse xmlns="http://tempuri.org/">
      <AddResult>13</AddResult>
    </AddResponse>
  </soap:Body>
</soap:Envelope>
]]

request_common.calculator_Request_XSLT_BEFORE_Failed = [[
<%?xml version="1.0" encoding="utf%-8"%?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema%-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <soap:Body>
    <soap:Fault>
      <faultcode>soap:Client</faultcode>
      <faultstring>Request %- XSLT transformation failed %(before XSD validation%)</faultstring>
    </soap:Fault>
  </soap:Body>
</soap:Envelope>]]

request_common. calculator_Request_XSLT_BEFORE_Failed_XSLT_Error_Verbose = [[
<%?xml version="1.0" encoding="utf%-8"%?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema%-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <soap:Body>
    <soap:Fault>
      <faultcode>soap:Client</faultcode>
      <faultstring>Request %- XSLT transformation failed %(before XSD validation%)</faultstring>
      <detail>Error code: 4, Line: 1, Message: Start tag expected, '<' not found</detail>
    </soap:Fault>
  </soap:Body>
</soap:Envelope>]]

request_common.calculator_Request_XSLT_BEFORE_Failed_401_Error_Verbose = [[
<%?xml version="1.0" encoding="utf%-8"%?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema%-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <soap:Body>
    <soap:Fault>
      <faultcode>soap:Client</faultcode>
      <faultstring>Unauthorized</faultstring>
      <detail>HTTP Error code is 401</detail>
    </soap:Fault>
  </soap:Body>
</soap:Envelope>]]

request_common.calculator_Request_XSLT_BEFORE_Failed_502_Error_Verbose = [[
<%?xml version="1.0" encoding="utf%-8"%?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema%-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <soap:Body>
    <soap:Fault>
      <faultcode>soap:Client</faultcode>
      <faultstring>An invalid response was received from the upstream server</faultstring>
      <detail>HTTP Error code is 502. SOAP/XML Web Service %- HTTP code: 502</detail>
    </soap:Fault>
  </soap:Body>
</soap:Envelope>]]

request_common.calculator_Request_XSLT_BEFORE = [[
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output version="1.0" method="xml" encoding="utf-8" omit-xml-declaration="no"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>   
  <xsl:template match="//*[local-name()='intA']">
    <xsl:copy-of select="."/>
      <intB>8</intB>
  </xsl:template>
</xsl:stylesheet>
]]

request_common.calculator_Request_XSD_VALIDATION = [[
<s:schema elementFormDefault="qualified" targetNamespace="http://tempuri.org/" xmlns:s="http://www.w3.org/2001/XMLSchema">
  <s:element name="Add">
    <s:complexType>
      <s:sequence>
        <s:element minOccurs="1" maxOccurs="1" name="intA" type="s:int" />
        <s:element minOccurs="1" maxOccurs="1" name="intB" type="s:int" />
      </s:sequence>
    </s:complexType>
  </s:element>
  <s:element name="Subtract">
    <s:complexType>
      <s:sequence>
        <s:element minOccurs="1" maxOccurs="1" name="intA" type="s:int" />
        <s:element minOccurs="1" maxOccurs="1" name="intB" type="s:int" />
      </s:sequence>
    </s:complexType>
  </s:element>
</s:schema>
]]

request_common.calculator_Request_XSD_VALIDATION_invalid = [[
s:schema elementFormDefault="qualified" targetNamespace="http://tempuri.org/" xmlns:s="http://www.w3.org/2001/XMLSchema">
</s:schema>
]]

request_common.calculator_Request_XSD_VALIDATION_Failed = [[
<%?xml version="1.0" encoding="utf%-8"%?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema%-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <soap:Body>
    <soap:Fault>
      <faultcode>soap:Client</faultcode>
      <faultstring>Request %- XSD validation failed</faultstring>
    </soap:Fault>
  </soap:Body>
</soap:Envelope>]]

request_common.calculator_Request_XSD_VALIDATION_Failed_verbose = [[
<%?xml version="1.0" encoding="utf%-8"%?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema%-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <soap:Body>
    <soap:Fault>
      <faultcode>soap:Client</faultcode>
      <faultstring>Request %- XSD validation failed</faultstring>
      <detail>WSDL validation %- errMessage Error code: 4, Line: 1, Message: Start tag expected, '<' not found</detail>
    </soap:Fault>
  </soap:Body>
</soap:Envelope>]]

request_common.calculator_Request_XSLT_AFTER = [[
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>   
  <xsl:template match="//*[local-name()='Subtract']">
    <Add xmlns="http://tempuri.org/"><xsl:apply-templates select="@*|node()" /></Add>
  </xsl:template>
</xsl:stylesheet>
]]

request_common.calculator_Request_XSLT_AFTER_invalid = [[
xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
</xsl:stylesheet>
]]

request_common.calculator_Request_XSLT_AFTER_Failed = [[
<%?xml version="1.0" encoding="utf%-8"%?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema%-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <soap:Body>
    <soap:Fault>
      <faultcode>soap:Client</faultcode>
      <faultstring>Request %- XSLT transformation failed %(after XSD validation%)</faultstring>
    </soap:Fault>
  </soap:Body>
</soap:Envelope>]]

request_common.calculator_Request_XSLT_AFTER_Failed_verbose = [[
<%?xml version="1.0" encoding="utf%-8"%?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema%-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <soap:Body>
    <soap:Fault>
      <faultcode>soap:Client</faultcode>
      <faultstring>Request %- XSLT transformation failed %(after XSD validation%)</faultstring>
      <detail>Error code: 4, Line: 1, Message: Start tag expected, '<' not found</detail>
    </soap:Fault>
  </soap:Body>
</soap:Envelope>]]

request_common.calculator_Request_XSLT_AFTER_ROUTING_BY_XPATH = [[
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">   
  <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="node()|@*">
    <xsl:copy>
  <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="//*[local-name()='Subtract']">
    <Add xmlns="http://tempuri.org/"><xsl:apply-templates select="@*|node()" /></Add>
  </xsl:template>
  <xsl:template match="//*[local-name()='intA']">
    <a><xsl:apply-templates select="@*|node()" /></a>
  </xsl:template>
  <xsl:template match="//*[local-name()='intB']">
    <b><xsl:apply-templates select="@*|node()" /></b>
  </xsl:template>
</xsl:stylesheet>
]]

request_common.calculator_Request_XSLT_AFTER_ROUTING_BY_XPATH_Failed_503 = [[
<%?xml version="1.0" encoding="utf%-8"%?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema%-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <soap:Body>
    <soap:Fault>
      <faultcode>soap:Client</faultcode>
      <faultstring>The upstream server is currently unavailable</faultstring>
    </soap:Fault>
  </soap:Body>
</soap:Envelope>]]

request_common.calculator_Request_XSLT_AFTER_ROUTING_BY_XPATH_Failed_503_verbose = [[
<%?xml version="1.0" encoding="utf%-8"%?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema%-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <soap:Body>
    <soap:Fault>
      <faultcode>soap:Client</faultcode>
      <faultstring>The upstream server is currently unavailable</faultstring>
      <detail>HTTP Error code is 503</detail>
    </soap:Fault>
  </soap:Body>
</soap:Envelope>]]

-------------------------------------------------------------------------------
-- SOAP/XML REQUEST plugin: configure the Kong entities (Service/Route/Plugin)
-------------------------------------------------------------------------------
function request_common.lazy_setup (PLUGIN_NAME, blue_print, xsltLibrary)

	local calculator_service = blue_print.services:insert({
		protocol = "http",
		host = "www.dneonline.com",
		port = 80,
		path = "/calculator.asmx",
	})

	--blue_print.plugins:insert {
	--	name = "soap-xml-response-handling",
	--	config = {
	--	}
	--}

	local calculatorXSLT_beforeXSD_route = blue_print.routes:insert{
		service = calculator_service,
		paths = { "/calculatorXSLT_beforeXSD_ok" }
		}
	
	blue_print.plugins:insert {
			name = PLUGIN_NAME,
			route = calculatorXSLT_beforeXSD_route,
			config = {
				VerboseRequest = false,
				xsltLibrary = xsltLibrary,
				xsltTransformBefore = request_common.calculator_Request_XSLT_BEFORE
			}
	}

	local calculatorXSLT_beforeXSD_invalid_route = blue_print.routes:insert{
		service = calculator_service,
		paths = { "/calculatorXSLT_beforeXSD_invalid" }
	}
	blue_print.plugins:insert {
		name = PLUGIN_NAME,
		route = calculatorXSLT_beforeXSD_invalid_route,
		-- it lacks the '<' beginning tag
		config = {
			xsltLibrary = xsltLibrary,
			xsltTransformBefore = [[
				xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
				</xsl:stylesheet>
			]]
		}
	}

	local calculatorXSLT_beforeXSD_invalid_verbose_route = blue_print.routes:insert{
		service = calculator_service,
		paths = { "/calculatorXSLT_beforeXSD_invalid_verbose" }
	}
	blue_print.plugins:insert {
		name = PLUGIN_NAME,
		route = calculatorXSLT_beforeXSD_invalid_verbose_route,
		-- it lacks the '<' beginning tag
		config = {
			VerboseRequest = true,
			xsltLibrary = xsltLibrary,
			xsltTransformBefore = [[
				xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
				</xsl:stylesheet>
			]]
		}	
	}

	local local_req_termination_route = blue_print.routes:insert{
		paths = { "/local_calculator_req_termination" }
	}
	blue_print.plugins:insert {
		name = "request-termination",
		route = local_req_termination_route,
		config = {
			status_code = 200,
			content_type = "text/xml; charset=utf-8",
			body = request_common.calculator_Response
		}	
	}
	local calculator_local_service = blue_print.services:insert({
		protocol = "http",
		host = "localhost",
		port = 9000,
		path = "/local_calculator_req_termination",
	})

	local calculatorXSLT_beforeXSD_request_termination = blue_print.routes:insert{
		service = calculator_local_service,
		paths = { "/calculatorXSLT_beforeXSD_request_termination" }
	}
	blue_print.plugins:insert {
		name = PLUGIN_NAME,
		route = calculatorXSLT_beforeXSD_request_termination,
		config = {
			VerboseRequest = true,
			xsltLibrary = xsltLibrary,
			xsltTransformBefore = request_common.calculator_Request_XSLT_BEFORE
		}
	}

	local calculatorXSLT_beforeXSD_basic_auth_route = blue_print.routes:insert{
		service = calculator_service,
		paths = { "/calculatorXSLT_beforeXSD_basic_auth" }
		}
	blue_print.plugins:insert {
		name = PLUGIN_NAME,
		route = calculatorXSLT_beforeXSD_basic_auth_route,
		config = {
			VerboseRequest = true,
			xsltLibrary = xsltLibrary,
			xsltTransformBefore = request_common.calculator_Request_XSLT_BEFORE
		}
	}
	blue_print.plugins:insert {
		name = "basic-auth",
		route = calculatorXSLT_beforeXSD_basic_auth_route,
		config = {
		}	
	}

	local calculator_invalid_host_service = blue_print.services:insert({
		protocol = "http",
		host = "127.0.0.2",
		port = 80,
		path = "/calculator.asmx",
	})			
	local calculatorXSLT_beforeXSD__invalid_host_route = blue_print.routes:insert{
		service = calculator_invalid_host_service,
		paths = { "/calculatorXSLT_beforeXSD_invalid_host" }
		}
	blue_print.plugins:insert {
		name = PLUGIN_NAME,
		route = calculatorXSLT_beforeXSD__invalid_host_route,
		config = {
			VerboseRequest = true,
			xsltLibrary = xsltLibrary,
			xsltTransformBefore = request_common.calculator_Request_XSLT_BEFORE
		}
	}

	local calculator_xsd_route = blue_print.routes:insert{
		service = calculator_service,
		paths = { "/calculatorXSD_ok" }
		}
	blue_print.plugins:insert {
		name = PLUGIN_NAME,
		route = calculator_xsd_route,
		config = {
			VerboseRequest = true,
			xsltLibrary = xsltLibrary,
			xsltTransformBefore = request_common.calculator_Request_XSLT_BEFORE,
			xsdApiSchema = request_common.calculator_Request_XSD_VALIDATION
		}
	}

	local calculator_xsd_invalid_route = blue_print.routes:insert{
		service = calculator_service,
		paths = { "/calculatorXSD_invalid" }
		}
	blue_print.plugins:insert {
		name = PLUGIN_NAME,
		route = calculator_xsd_invalid_route,
		config = {
			VerboseRequest = false,
			xsltLibrary = xsltLibrary,
			xsltTransformBefore = request_common.calculator_Request_XSLT_BEFORE,
			xsdApiSchema = request_common.calculator_Request_XSD_VALIDATION_invalid
		}
	}

	local calculator_xsd_invalid_verbose_route = blue_print.routes:insert{
		service = calculator_service,
		paths = { "/calculatorXSD_invalid_verbose" }
		}
	blue_print.plugins:insert {
		name = PLUGIN_NAME,
		route = calculator_xsd_invalid_verbose_route,
		config = {
			VerboseRequest = true,
			xsltLibrary = xsltLibrary,
			xsltTransformBefore = request_common.calculator_Request_XSLT_BEFORE,
			xsdApiSchema = request_common.calculator_Request_XSD_VALIDATION_invalid
		}
	}

	local calculatorXSLT_afterXSD_route = blue_print.routes:insert{
		service = calculator_service,
		paths = { "/calculatorXSLT_afterXSD_ok" }
		}
	blue_print.plugins:insert {
		name = PLUGIN_NAME,
		route = calculatorXSLT_afterXSD_route,
		config = {
			VerboseRequest = false,
			xsltLibrary = xsltLibrary,
			xsltTransformBefore = request_common.calculator_Request_XSLT_BEFORE,
			xsdApiSchema = request_common.calculator_Request_XSD_VALIDATION,
			xsltTransformAfter = request_common.calculator_Request_XSLT_AFTER
		}
	}

	local calculatorXSLT_afterXSD_invalid_route = blue_print.routes:insert{
		service = calculator_service,
		paths = { "/calculatorXSLT_afterXSD_invalid" }
		}
	blue_print.plugins:insert {
		name = PLUGIN_NAME,
		route = calculatorXSLT_afterXSD_invalid_route,
		config = {
			VerboseRequest = false,
			xsltLibrary = xsltLibrary,
			xsltTransformBefore = request_common.calculator_Request_XSLT_BEFORE,
			xsdApiSchema = request_common.calculator_Request_XSD_VALIDATION,
			xsltTransformAfter = request_common.calculator_Request_XSLT_AFTER_invalid
		}
	}

	local calculatorXSLT_afterXSD_invalid_verbose_route = blue_print.routes:insert{
		service = calculator_service,
		paths = { "/calculatorXSLT_afterXSD_invalid_verbose" }
		}
	blue_print.plugins:insert {
		name = PLUGIN_NAME,
		route = calculatorXSLT_afterXSD_invalid_verbose_route,
		config = {
			VerboseRequest = true,
			xsltLibrary = xsltLibrary,
			xsltTransformBefore = request_common.calculator_Request_XSLT_BEFORE,
			xsdApiSchema = request_common.calculator_Request_XSD_VALIDATION,
			xsltTransformAfter = request_common.calculator_Request_XSLT_AFTER_invalid
		}
	}

	local upstream_ecs_syr_edu = blue_print.upstreams:insert()
	blue_print.targets:insert({
		upstream = upstream_ecs_syr_edu,
		target = "ecs.syr.edu:443",
	})

	local calculatorRoutingByXPath_upstream_route = blue_print.routes:insert{
		service = calculator_service,
		paths = { "/calculatorRoutingByXPath_upstream_entity_ok" }
		}
	blue_print.plugins:insert {
		name = PLUGIN_NAME,
		route = calculatorRoutingByXPath_upstream_route,
		config = {
			VerboseRequest = false,
			xsltLibrary = xsltLibrary,
			xsltTransformBefore = request_common.calculator_Request_XSLT_BEFORE,
			xsdApiSchema = request_common.calculator_Request_XSD_VALIDATION,
			xsltTransformAfter = request_common.calculator_Request_XSLT_AFTER_ROUTING_BY_XPATH,
			RouteToPath = "https://" .. upstream_ecs_syr_edu.name .. "/faculty/fawcett/Handouts/cse775/code/calcWebService/Calc.asmx",
			RouteXPath = "/soap:Envelope/soap:Body/*[local-name() = 'Add']/*[local-name() = 'a']",
			RouteXPathCondition = "5",
		}
	}

	local calculatorRoutingByXPath_hostname_route = blue_print.routes:insert{
		service = calculator_service,
		paths = { "/calculatorRoutingByXPath_hostname_ok" }
		}
	blue_print.plugins:insert {
		name = PLUGIN_NAME,
		route = calculatorRoutingByXPath_hostname_route,
		config = {
			VerboseRequest = false,
			xsltLibrary = xsltLibrary,
			xsltTransformBefore = request_common.calculator_Request_XSLT_BEFORE,
			xsdApiSchema = request_common.calculator_Request_XSD_VALIDATION,
			xsltTransformAfter = request_common.calculator_Request_XSLT_AFTER_ROUTING_BY_XPATH,
			RouteToPath = "https://ecs.syr.edu:443/faculty/fawcett/Handouts/cse775/code/calcWebService/Calc.asmx",
			RouteXPath = "/soap:Envelope/soap:Body/*[local-name() = 'Add']/*[local-name() = 'a']",
			RouteXPathCondition = "5",
		}
	}

	local calculatorRoutingByXPath_hostname_invalid_route = blue_print.routes:insert{
		service = calculator_service,
		paths = { "/calculatorRoutingByXPath_hostname_invalid" }
		}
	blue_print.plugins:insert {
		name = PLUGIN_NAME,
		route = calculatorRoutingByXPath_hostname_invalid_route,
		config = {
			VerboseRequest = false,
			xsltLibrary = xsltLibrary,
			xsltTransformBefore = request_common.calculator_Request_XSLT_BEFORE,
			xsdApiSchema = request_common.calculator_Request_XSD_VALIDATION,
			xsltTransformAfter = request_common.calculator_Request_XSLT_AFTER_ROUTING_BY_XPATH,
			RouteToPath = "https://ecs.syr.edu.ABCDEFGHIJKLMNOPQRSTU:443/faculty/fawcett/Handouts/cse775/code/calcWebService/Calc.asmx",
			RouteXPath = "/soap:Envelope/soap:Body/*[local-name() = 'Add']/*[local-name() = 'a']",
			RouteXPathCondition = "5",
		}
	}

	local calculatorRoutingByXPath_hostname_invalid_verbose_route = blue_print.routes:insert{
		service = calculator_service,
		paths = { "/calculatorRoutingByXPath_hostname_invalid_verbose" }
		}
	blue_print.plugins:insert {
		name = PLUGIN_NAME,
		route = calculatorRoutingByXPath_hostname_invalid_verbose_route,
		config = {
			VerboseRequest = true,
			xsltLibrary = xsltLibrary,
			xsltTransformBefore = request_common.calculator_Request_XSLT_BEFORE,
			xsdApiSchema = request_common.calculator_Request_XSD_VALIDATION,
			xsltTransformAfter = request_common.calculator_Request_XSLT_AFTER_ROUTING_BY_XPATH,
			RouteToPath = "https://ecs.syr.edu.ABCDEFGHIJKLMNOPQRSTU:443/faculty/fawcett/Handouts/cse775/code/calcWebService/Calc.asmx",
			RouteXPath = "/soap:Envelope/soap:Body/*[local-name() = 'Add']/*[local-name() = 'a']",
			RouteXPathCondition = "5",
		}
	}
end

------------------------------------------
-- SOAP/XML REQUEST plugin: Execute tests
------------------------------------------
function request_common._1_XSLT_BEFORE_XSD_Valid_transformation (assert, client)
		-- invoke a test request
		local r = client:post("/calculatorXSLT_beforeXSD_ok", {
			headers = {
				["Content-Type"] = "text/xml; charset=utf-8",
			},
			body = request_common.calculator_Request,
		})
	
		-- validate that the request succeeded: response status 200, Content-Type and right math
		local body = assert.response(r).has.status(200)
		local content_type = assert.response(r).has.header("Content-Type")
		assert.equal("text/xml; charset=utf-8", content_type)
		assert.matches('<AddResult>13</AddResult>', body)	
end

function request_common._1_XSLT_BEFORE_XSD_Invalid_XSLT_input(assert, client)
	-- invoke a test request
	local r = client:post("/calculatorXSLT_beforeXSD_invalid", {
		headers = {
			["Content-Type"] = "text/xml; charset=utf-8",
		},
		body = request_common.calculator_Request,
	})

	-- validate that the request failed: response status 500, Content-Type and Error message 'XSLT transformation failed'
	local body = assert.response(r).has.status(500)
	local content_type = assert.response(r).has.header("Content-Type")
	assert.equal("text/xml; charset=utf-8", content_type)
	assert.matches(request_common.calculator_Request_XSLT_BEFORE_Failed, body)
end

function request_common._1_XSLT_BEFORE_XSD_Invalid_XSLT_with_Verbose (assert, client)
	-- invoke a test request
	local r = client:post("/calculatorXSLT_beforeXSD_invalid_verbose", {
		headers = {
			["Content-Type"] = "text/xml; charset=utf-8",
		},
		body = request_common.calculator_Request,
	})

	-- validate that the request failed: response status 500, Content-Type and Error message 'XSLT transformation failed'
	local body = assert.response(r).has.status(500)
	local content_type = assert.response(r).has.header("Content-Type")
	assert.equal("text/xml; charset=utf-8", content_type)
	assert.matches(request_common.calculator_Request_XSLT_BEFORE_Failed_XSLT_Error_Verbose, body)
end

function request_common._1_XSLT_BEFORE_XSD_Valid_transformation_with_request_termination_plugin_200 (assert, client)

	-- invoke a test request
	local r = client:post("/calculatorXSLT_beforeXSD_request_termination", {
		headers = {
			["Content-Type"] = "text/xml; charset=utf-8",
		},
		body = request_common.calculator_Request,
	})
	
	-- validate that the request succeeded: response status 200, Content-Type and right math
	local body = assert.response(r).has.status(200)
	local content_type = assert.response(r).has.header("Content-Type")
	assert.equal("text/xml; charset=utf-8", content_type)
	assert.matches('<AddResult>13</AddResult>', body)
end

function request_common._1_XSLT_BEFORE_XSD_Valid_transformation_with_basic_auth_plugin_401_with_Verbose (assert, client)

	-- invoke a test request
	local r = client:post("/calculatorXSLT_beforeXSD_basic_auth", {
		headers = {
			["Content-Type"] = "text/xml; charset=utf-8",
		},
		body = request_common.calculator_Request,
	})
	
	-- validate that the request succeeded: response status 401, Content-Type and right Match
	local body = assert.response(r).has.status(401)
	local content_type = assert.response(r).has.header("Content-Type")
	assert.equal("text/xml; charset=utf-8", content_type)
	assert.matches(request_common.calculator_Request_XSLT_BEFORE_Failed_401_Error_Verbose, body)
end

function request_common._1_XSLT_BEFORE_XSD_Invalid_Hostname_service_502_with_Verbose (assert, client)

	-- invoke a test request
	local r = client:post("/calculatorXSLT_beforeXSD_invalid_host", {
		headers = {
			["Content-Type"] = "text/xml; charset=utf-8",
		},
		body = request_common.calculator_Request,
	})
	
	-- validate that the request succeeded: response status 502, Content-Type and right match
	local body = assert.response(r).has.status(502)
	local content_type = assert.response(r).has.header("Content-Type")
	assert.equal("text/xml; charset=utf-8", content_type)
	assert.matches(request_common.calculator_Request_XSLT_BEFORE_Failed_502_Error_Verbose, body)
end

function request_common._1_2_XSD_Validation_Ok (assert, client)

	-- invoke a test request
	local r = client:post("/calculatorXSD_ok", {
		headers = {
			["Content-Type"] = "text/xml; charset=utf-8",
		},
		body = request_common.calculator_Request,
	})

	-- validate that the request succeeded: response status 200, Content-Type and right math
	local body = assert.response(r).has.status(200)
	local content_type = assert.response(r).has.header("Content-Type")
	assert.equal("text/xml; charset=utf-8", content_type)
	assert.matches('<AddResult>13</AddResult>', body)
end

function request_common._1_2_XSD_Validation_Invalid_XSD_input (assert, client)

	-- invoke a test request
	local r = client:post("/calculatorXSD_invalid", {
		headers = {
			["Content-Type"] = "text/xml; charset=utf-8",
		},
		body = request_common.calculator_Request,
	})

	-- validate that the request succeeded: response status 500, Content-Type and right match
	local body = assert.response(r).has.status(500)
	local content_type = assert.response(r).has.header("Content-Type")
	assert.equal("text/xml; charset=utf-8", content_type)
	assert.matches(request_common.calculator_Request_XSD_VALIDATION_Failed, body)
end

function request_common._1_2_XSD_Validation_Invalid_XSD_input_with_verbose (assert, client)

	-- invoke a test request
	local r = client:post("/calculatorXSD_invalid_verbose", {
		headers = {
			["Content-Type"] = "text/xml; charset=utf-8",
		},
		body = request_common.calculator_Request,
	})

	-- validate that the request succeeded: response status 500, Content-Type and right match
	local body = assert.response(r).has.status(500)
	local content_type = assert.response(r).has.header("Content-Type")
	assert.equal("text/xml; charset=utf-8", content_type)
	assert.matches(request_common.calculator_Request_XSD_VALIDATION_Failed_verbose, body)
end

function request_common._1_2_3_XSLT_AFTER_XSD_Ok (assert, client)

	-- invoke a test request
	local r = client:post("/calculatorXSLT_afterXSD_ok", {
		headers = {
			["Content-Type"] = "text/xml; charset=utf-8",
		},
		body = request_common.calculator_Subtract_Request,
	})

	-- validate that the request succeeded: response status 200, Content-Type and right math
	local body = assert.response(r).has.status(200)
	local content_type = assert.response(r).has.header("Content-Type")
	assert.equal("text/xml; charset=utf-8", content_type)
	assert.matches('<AddResult>13</AddResult>', body)
end

function request_common._1_2_3_XSLT_AFTER_XSD_Invalid_XSLT_input (assert, client)
	
	-- invoke a test request
	local r = client:post("/calculatorXSLT_afterXSD_invalid", {
		headers = {
			["Content-Type"] = "text/xml; charset=utf-8",
		},
		body = request_common.calculator_Subtract_Request,
	})

	-- validate that the request succeeded: response status 500, Content-Type and right math
	local body = assert.response(r).has.status(500)
	local content_type = assert.response(r).has.header("Content-Type")
	assert.equal("text/xml; charset=utf-8", content_type)
	assert.matches(request_common.calculator_Request_XSLT_AFTER_Failed, body)
end

function request_common._1_2_3_XSLT_AFTER_XSD_Invalid_XSLT_input_with_verbose (assert, client)
		
	-- invoke a test request
	local r = client:post("/calculatorXSLT_afterXSD_invalid_verbose", {
		headers = {
			["Content-Type"] = "text/xml; charset=utf-8",
		},
		body = request_common.calculator_Subtract_Request,
	})

	-- validate that the request succeeded: response status 500, Content-Type and right match
	local body = assert.response(r).has.status(500)
	local content_type = assert.response(r).has.header("Content-Type")
	assert.equal("text/xml; charset=utf-8", content_type)
	assert.matches(request_common.calculator_Request_XSLT_AFTER_Failed_verbose, body)
end

function request_common._1_2_3_4_ROUTING_BY_XPATH_with_upstream_entity_Ok (assert, client)
			
	-- invoke a test request
	local r = client:post("/calculatorRoutingByXPath_upstream_entity_ok", {
		headers = {
			["Content-Type"] = "text/xml; charset=utf-8",
		},
		body = request_common.calculator_Subtract_Request,
	})

	-- validate that the request succeeded: response status 200, Content-Type and right match
	local body = assert.response(r).has.status(200)
	local content_type = assert.response(r).has.header("Content-Type")
	assert.equal("text/xml; charset=utf-8", content_type)
	assert.matches('<AddResult>13</AddResult>', body)
end

function request_common._1_2_3_4_ROUTING_BY_XPATH_with_hostname_Ok (assert, client)
			
	-- invoke a test request
	local r = client:post("/calculatorRoutingByXPath_hostname_ok", {
		headers = {
			["Content-Type"] = "text/xml; charset=utf-8",
		},
		body = request_common.calculator_Subtract_Request,
	})

	-- validate that the request succeeded: response status 200, Content-Type and right match
	local body = assert.response(r).has.status(200)
	local content_type = assert.response(r).has.header("Content-Type")
	assert.equal("text/xml; charset=utf-8", content_type)
	assert.matches('<AddResult>13</AddResult>', body)
end

function request_common._1_2_3_4_ROUTING_BY_XPATH_with_hostname_Invalid_Hostname_503 (assert, client)
	
	-- invoke a test request
	local r = client:post("/calculatorRoutingByXPath_hostname_invalid", {
		headers = {
			["Content-Type"] = "text/xml; charset=utf-8",
		},
		body = request_common.calculator_Subtract_Request,
	})

	-- validate that the request succeeded: response status 503, Content-Type and right match
	local body = assert.response(r).has.status(503)
	local content_type = assert.response(r).has.header("Content-Type")
	assert.equal("text/xml; charset=utf-8", content_type)
	assert.matches(request_common.calculator_Request_XSLT_AFTER_ROUTING_BY_XPATH_Failed_503, body)
end

function request_common._1_2_3_4_ROUTING_BY_XPATH_with_hostname_Invalid_Hostname_503_with_verbose (assert, client)
	
	-- invoke a test request
	local r = client:post("/calculatorRoutingByXPath_hostname_invalid_verbose", {
		headers = {
			["Content-Type"] = "text/xml; charset=utf-8",
		},
		body = request_common.calculator_Subtract_Request,
	})

	-- validate that the request succeeded: response status 503, Content-Type and right match
	local body = assert.response(r).has.status(503)
	local content_type = assert.response(r).has.header("Content-Type")
	assert.equal("text/xml; charset=utf-8", content_type)
	assert.matches(request_common.calculator_Request_XSLT_AFTER_ROUTING_BY_XPATH_Failed_503_verbose, body)
end

return request_common