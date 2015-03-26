local ngx_redirect = nil
if ngx then ngx_redirect = ngx.redirect end

local cocosAuthService = cc.load("cocos_auth").service

local _COCOS_CLIENT_ID = 167

local PmrAction = class("PmrAction")

function PmrAction:ctor(connect)
    self._connect = connect
    self._cocosAuth = cocosAuthService:create(_COCOS_CLIENT_ID)
end

function PmrAction:loginAction(arg)
    local cocosUrl = self._cocosAuth:login(arg.url)

    return ngx_redirect(cocosUrl)
end

function PmrAction:isloginAction(arg)
    local res = self._cocosAuth:isLogin()
    local resp = {}

    if res.sign_status == "yes" then
        local st = resp.st
        resp = self:_validateTicket({ticket=st})
    else
        resp.status = "failure"
        resp.msg = "login failed."
    end

    return resp
end

function PmrAction:callbackAction(arg) 
    

end

function PmrAction:_validateticket(arg)
    if not arg.ticket then
        throw("param(ticket) is missed.")
    end
    return self._cocosAuth(arg.ticket)
end

return PmrAction
