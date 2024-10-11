-- Helper functions provided by Kong Gateway, see https://github.com/Kong/kong/blob/master/spec/helpers.lua
local helpers         = require "spec.helpers"
local request_common  = require "spec.common.request"
local response_common = require "spec.common.response"
local split           = require("kong.tools.string").split

-- matches our plugin name defined in the plugins's schema.lua
local PLUGIN_NAME = "soap-xml-request-handling,soap-xml-response-handling"
local plugins = split(PLUGIN_NAME, ',')
local xsltLibrary = "libxslt"
local pluginRequest  = plugins[1]
local pluginResponse = plugins[2]

for _, strategy in helpers.all_strategies() do
  if strategy == "off" then
    goto continue
  end

	describe(PLUGIN_NAME .. ": [#" .. strategy .. "]", function()
    -- Will be initialized before_each nested test
    local client

    setup(function()
    end)

    -- teardown runs after its parent describe block
    teardown(function()
      helpers.stop_kong(nil, true)
    end)

    -- before_each runs before each child describe
    before_each(function()
      client = helpers.proxy_client()
    end)

    -- after_each runs after each child describe
    after_each(function()
      if client then client:close() end
    end)

    -- a nested describe defines an actual test on the plugin behavior
    describe("libxml+libxslt |", function()
			
			lazy_setup(function()			
        -- A BluePrint gives us a helpful database wrapper to
        --    manage Kong Gateway entities directly.
        -- This function also truncates any existing data in an existing db.
        -- The custom plugin name is provided to this function so it mark as loaded
        local blue_print = helpers.get_db_utils(strategy, nil, { pluginRequest,  pluginResponse })
				
				local calculator_service = blue_print.services:insert({
            protocol = "http",
            host = "www.dneonline.com",
            port = 80,
            path = "/calculator.asmx",
          })
          
        local calculator_fullSoapXml_handling_Request_Response_route = blue_print.routes:insert{
          service = calculator_service,
          paths = { "/calculator_fullSoapXml_handling_Request_Response_ok" }
          }
        blue_print.plugins:insert {
          name = pluginRequest,
          route = calculator_fullSoapXml_handling_Request_Response_route,
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
        blue_print.plugins:insert {
          name = pluginResponse,
          route = calculator_fullSoapXml_handling_Request_Response_route,
          config = {
            VerboseResponse = false,
            xsltLibrary = xsltLibrary,
            xsdApiSchema = response_common.calculator_Response_XSD_VALIDATION,
            xsltTransformBefore = response_common.calculator_Response_XSLT_BEFORE,
            xsltTransformAfter = response_common.calculator_Request_XSLT_AFTER
          }
        }

        local calculator_Request_XSLT_beforeXSD_invalid_route = blue_print.routes:insert{
          service = calculator_service,
          paths = { "/calculator_Request_XSLT_beforeXSD_invalid" }
          }
        blue_print.plugins:insert {
          name = pluginRequest,
          route = calculator_Request_XSLT_beforeXSD_invalid_route,
          config = {
            VerboseRequest = false,
            xsltLibrary = xsltLibrary,
            xsltTransformBefore = [[
              xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
              </xsl:stylesheet>
            ]]
          }
        }
        blue_print.plugins:insert {
          name = pluginResponse,
          route = calculator_Request_XSLT_beforeXSD_invalid_route,
          config = {
            VerboseResponse = false,
            xsltLibrary = xsltLibrary,
            xsdApiSchema = response_common.calculator_Response_XSD_VALIDATION,
            xsltTransformBefore = response_common.calculator_Response_XSLT_BEFORE,
            xsltTransformAfter = response_common.calculator_Request_XSLT_AFTER
          }
        }

        local calculator_Request_XSLT_beforeXSD_invalid_verbose_route = blue_print.routes:insert{
          service = calculator_service,
          paths = { "/calculator_Request_XSLT_beforeXSD_invalid_verbose" }
          }
        blue_print.plugins:insert {
          name = pluginRequest,
          route = calculator_Request_XSLT_beforeXSD_invalid_verbose_route,
          config = {
            VerboseRequest = true,
            xsltLibrary = xsltLibrary,
            xsltTransformBefore = [[
              xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
              </xsl:stylesheet>
            ]]
          }
        }
        blue_print.plugins:insert {
          name = pluginResponse,
          route = calculator_Request_XSLT_beforeXSD_invalid_verbose_route,
          config = {
            VerboseResponse = true,
            xsltLibrary = xsltLibrary,
            xsdApiSchema = response_common.calculator_Response_XSD_VALIDATION,
            xsltTransformBefore = response_common.calculator_Response_XSLT_BEFORE,
            xsltTransformAfter = response_common.calculator_Request_XSLT_AFTER
          }
        }
        
        local calculator_Response_XSLT_afterXSD_invalid_route = blue_print.routes:insert{
          service = calculator_service,
          paths = { "/calculator_Response_XSLT_afterXSD_invalid" }
          }
        blue_print.plugins:insert {
          name = pluginRequest,
          route = calculator_Response_XSLT_afterXSD_invalid_route,
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
        blue_print.plugins:insert {
          name = pluginResponse,
          route = calculator_Response_XSLT_afterXSD_invalid_route,
          config = {
            VerboseResponse = false,
            xsltLibrary = xsltLibrary,
            xsdApiSchema = response_common.calculator_Response_XSD_VALIDATION,
            xsltTransformBefore = response_common.calculator_Response_XSLT_BEFORE,
            xsltTransformAfter = response_common.calculator_Response_XSLT_BEFORE_invalid
          }
        }

        local calculator_Response_XSLT_afterXSD_invalid_verbose_route = blue_print.routes:insert{
          service = calculator_service,
          paths = { "/calculator_Response_XSLT_afterXSD_invalid_verbose" }
          }
        blue_print.plugins:insert {
          name = pluginRequest,
          route = calculator_Response_XSLT_afterXSD_invalid_verbose_route,
          config = {
            VerboseRequest = true,
            xsltLibrary = xsltLibrary,
            xsltTransformBefore = request_common.calculator_Request_XSLT_BEFORE,
            xsdApiSchema = request_common.calculator_Request_XSD_VALIDATION,
            xsltTransformAfter = request_common.calculator_Request_XSLT_AFTER_ROUTING_BY_XPATH,
            RouteToPath = "https://ecs.syr.edu:443/faculty/fawcett/Handouts/cse775/code/calcWebService/Calc.asmx",
            RouteXPath = "/soap:Envelope/soap:Body/*[local-name() = 'Add']/*[local-name() = 'a']",
            RouteXPathCondition = "5",
          }
        }
        blue_print.plugins:insert {
          name = pluginResponse,
          route = calculator_Response_XSLT_afterXSD_invalid_verbose_route,
          config = {
            VerboseResponse = true,
            xsltLibrary = xsltLibrary,
            xsdApiSchema = response_common.calculator_Response_XSD_VALIDATION,
            xsltTransformBefore = response_common.calculator_Response_XSLT_BEFORE,
            xsltTransformAfter = response_common.calculator_Response_XSLT_BEFORE_invalid
          }
        }

        local tempui_org_request_response_xsd = blue_print.routes:insert{
          paths = { "/tempuri.org.request-response.xsd" }
        }
        blue_print.plugins:insert {
          name = "request-termination",
          route = tempui_org_request_response_xsd,
          config = {
            status_code = 200,
            content_type = "text/xml; charset=utf-8",
            body = request_common.calculator_Request_Response_XSD_VALIDATION
          }	
        }
        local calculator_wsdl_ok = blue_print.routes:insert{
          service = calculator_service,
          paths = { "/calculatorWSDL_with_async_download_ok" }
          }
        blue_print.plugins:insert {
          name = pluginRequest,
          route = calculator_wsdl_ok,
          config = {
            VerboseRequest = false,
            ExternalEntityLoader_CacheTTL = 15,
            ExternalEntityLoader_Async = true,
            xsdApiSchema = request_common.calculatorWSDL_with_async_download_Ok
          }
        }
        blue_print.plugins:insert {
          name = pluginResponse,
          route = calculator_wsdl_ok,
          config = {
            VerboseResponse = false,
            ExternalEntityLoader_CacheTTL = 15,
            ExternalEntityLoader_Async = true,
            xsdApiSchema = request_common.calculatorWSDL_with_async_download_Ok
          }
        }

        local calculator_wsdl_invalid_import_request_verbose_route = blue_print.routes:insert{
          service = calculator_service,
          paths = { "/calculatorWSDL_with_async_download_invalid_import_Request_verbose" }
          }
        blue_print.plugins:insert {
          name = pluginRequest,
          route = calculator_wsdl_invalid_import_request_verbose_route,
          config = {
            VerboseRequest = true,
            ExternalEntityLoader_CacheTTL = 15,
            ExternalEntityLoader_Async = true,
            xsdApiSchema = request_common.calculatorWSDL_with_async_download_Failed
          }
        }
        blue_print.plugins:insert {
          name = pluginResponse,
          route = calculator_wsdl_invalid_import_request_verbose_route,
          config = {
            VerboseResponse = true,
            ExternalEntityLoader_CacheTTL = 15,
            ExternalEntityLoader_Async = true,
            xsdApiSchema = request_common.calculatorWSDL_with_async_download_Ok
          }
        }

        local calculator_wsdl_invalid_import_response_verbose_route = blue_print.routes:insert{
          service = calculator_service,
          paths = { "/calculatorWSDL_with_async_download_invalid_import_Response_verbose" }
          }
        blue_print.plugins:insert {
          name = pluginRequest,
          route = calculator_wsdl_invalid_import_response_verbose_route,
          config = {
            VerboseRequest = true,
            ExternalEntityLoader_CacheTTL = 15,
            ExternalEntityLoader_Async = true,
            xsdApiSchema = request_common.calculatorWSDL_with_async_download_Ok
          }
        }
        blue_print.plugins:insert {
          name = pluginResponse,
          route = calculator_wsdl_invalid_import_response_verbose_route,
          config = {
            VerboseResponse = true,
            ExternalEntityLoader_CacheTTL = 15,
            ExternalEntityLoader_Async = true,
            xsdApiSchema = request_common.calculatorWSDL_with_async_download_Failed
          }
        }
        
				-- start kong
				assert(helpers.start_kong({
					-- use the custom test template to create a local mock server
					nginx_conf = "spec/fixtures/custom_nginx.template",
					-- make sure our plugin gets loaded
					plugins = "bundled," .. PLUGIN_NAME
				}))
		
    	end)
      
      it("1+2+3+4+5+6+7|Request and Response plugins|Full SOAP/XML handling - Ok", function()
        -- invoke a test request
        local r = client:post("/calculator_fullSoapXml_handling_Request_Response_ok", {
          headers = {
            ["Content-Type"] = "text/xml; charset=utf-8",
          },
          body = request_common.calculator_Subtract_Request,
        })
        
        -- validate that the request succeeded: response status 200, Content-Type and right match
        local body = assert.response(r).has.status(200)
        local content_type = assert.response(r).has.header("Content-Type")
        assert.equal("text/xml; charset=utf-8", content_type)
        assert.matches(response_common.calculator_Response_XML, body)
      end)

      it("1|Request and Response plugins|XSLT (BEFORE XSD) - Invalid XSLT input", function()
        -- invoke a test request
        local r = client:post("/calculator_Request_XSLT_beforeXSD_invalid", {
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
      end)

      it("1|Request and Response plugins|XSLT (BEFORE XSD) - Invalid XSLT input with Verbose", function()
        -- invoke a test request
        local r = client:post("/calculator_Request_XSLT_beforeXSD_invalid_verbose", {
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
      end)

      it("1+2+3+4+5+6+7|Request and Response plugins|XSLT (AFTER XSD) - Invalid XSLT input", function()
        -- invoke a test request
        local r = client:post("/calculator_Response_XSLT_afterXSD_invalid", {
          headers = {
            ["Content-Type"] = "text/xml; charset=utf-8",
          },
          body = request_common.calculator_Request,
        })
        
        -- validate that the request failed: response status 500, Content-Type and Error message 'XSLT transformation failed'
        local body = assert.response(r).has.status(500)
        local content_type = assert.response(r).has.header("Content-Type")
        assert.equal("text/xml; charset=utf-8", content_type)
        assert.matches(response_common.calculator_Response_XSLT_AFTER_Failed, body)
      end)

      it("1+2+3+4+5+6+7|Request and Response plugins|XSLT (AFTER XSD) - Invalid XSLT input with Verbose", function()
        -- invoke a test request
        local r = client:post("/calculator_Response_XSLT_afterXSD_invalid_verbose", {
          headers = {
            ["Content-Type"] = "text/xml; charset=utf-8",
          },
          body = request_common.calculator_Request,
        })
        
        -- validate that the request failed: response status 500, Content-Type and Error message 'XSLT transformation failed'
        local body = assert.response(r).has.status(500)
        local content_type = assert.response(r).has.header("Content-Type")
        assert.equal("text/xml; charset=utf-8", content_type)
        assert.matches(response_common.calculator_Response_XSLT_AFTER_Failed_verbose, body)
      end)

      it("2+6|Request and Response plugins|WSDL Validation with async download - Ok", function()
        -- invoke a test request
        local r = client:post("/calculatorWSDL_with_async_download_ok", {
          headers = {
            ["Content-Type"] = "text/xml; charset=utf-8",
          },
          body = request_common.calculator_Full_Request,
        })

        -- validate that the request failed: response status 500, Content-Type and right match
        local body = assert.response(r).has.status(200)
        local content_type = assert.response(r).has.header("Content-Type")
        assert.equal("text/xml; charset=utf-8", content_type)
        assert.matches('<AddResult>12</AddResult>', body)
      end)

      it("2|Request and Response plugins|WSDL Validation with async download - Invalid Import on Request plugin with verbose", function()
        -- invoke a test request
        local r = client:post("/calculatorWSDL_with_async_download_invalid_import_Request_verbose", {
          headers = {
            ["Content-Type"] = "text/xml; charset=utf-8",
          },
          body = request_common.calculator_Full_Request,
        })

        -- validate that the request failed: response status 500, Content-Type and right match
        local body = assert.response(r).has.status(500)
        local content_type = assert.response(r).has.header("Content-Type")
        assert.equal("text/xml; charset=utf-8", content_type)
        assert.matches(request_common.calculator_Request_XSD_VALIDATION_Failed_shortened, body)
        assert.matches("<detail>.*Failed to parse the XML resource 'http://localhost:9000/DOES_NOT_EXIST'.*</detail>", body)
      end)

      it("2+6|Request and Response plugins|WSDL Validation with async download - Invalid Import on Response plugin with verbose", function()
        -- invoke a test request
        local r = client:post("/calculatorWSDL_with_async_download_invalid_import_Response_verbose", {
          headers = {
            ["Content-Type"] = "text/xml; charset=utf-8",
          },
          body = request_common.calculator_Full_Request,
        })

        -- validate that the request failed: response status 500, Content-Type and right match
        local body = assert.response(r).has.status(500)
        local content_type = assert.response(r).has.header("Content-Type")
        assert.equal("text/xml; charset=utf-8", content_type)
        assert.matches(response_common.calculator_Response_XSD_VALIDATION_Failed_shortened, body)
        assert.matches("<detail>.*Failed to parse the XML resource 'http://localhost:9000/DOES_NOT_EXIST'.*</detail>", body)
      end)

		end)		
	end)
  ::continue::
end