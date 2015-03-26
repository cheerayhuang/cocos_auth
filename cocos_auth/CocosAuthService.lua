local assert = assert
local tostring = tostring
local ngx_redirect = nil
if ngx then ngx_redirect = ngx.redirect end
local string_format = string.format
local json_decode = json.decode

local httpClient = require("httpclient").new()

local _SSO_SERVER_URL = "http://passsport.cocos.com/"
local _SSO_SERVER_IS_SIGNIN_URL = _SSO_SERVER_URL .. "sso/is_signin"
local _SSO_SERVER_ST_VALIDATE_URL = _SSO_SERVER_URL .. "sso/st_validate"
local _SSO_SERVER_SIGNIN_URL = _SSO_SERVER_URL .. "sso/signin"

local CocosAuthService = class("CocosAuthService")

function CocosAuthService:ctor(clientId)
    assert(ngx, "CocosAuthService should be loaded in nginx env.")
    assert(clientId, "CocosAuthService should be loaded with clientId.")

    self._clientId = clientId
end

function CocosAuthService:isLogin()
    local url = _SSO_SERVER_IS_SIGNIN_URL .. "?client_id=" .. tostring(self._clientId)

    local reply = httpClient:get(url) 
    if not reply.body then
        throw("Check whether it is login failed: %s", res.err)
    end

    local body, err = json_decode(reply.body)
    if not body then
        throw("Check whether it is login failed: %s", err)
    end

    return body
end

function CocosAuthService:login(url)
    local param = "?client_id=" .. tostring(self._clientId)
    if url then
        param = param .. "&url=" .. tostring(url)
    end

    return _SSO_SERVER_SIGNIN_URL .. param
end

function CocosAuthService:validateTicket(ticket)
    if not ticket or type(ticket) ~= "string" then
        throw("validateTicket failed: ticket is invalid.")
    end

    local reqData = string_format("client_id=%s&st=%s", tostring(clientId), ticket)
    local res = httpClient:post(_SSO_SERVER_ST_VALIDATE_URL, reqData)
    if not res.body then
        throw("validateTicket failed: %s", res.err)
    end

    local body, err = json_decode(res.body)
    if not body  then
        throw("validateTicket failed: %s", err)
    end

    return body
end

return CocosAuthService
