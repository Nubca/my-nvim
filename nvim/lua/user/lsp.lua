---@mod user.lsp
---
---@brief [[
---LSP related functions
---@brief ]]

local M = {}

---Gets a 'ClientCapabilities' object for LSP servers
---Updated to use blink.cmp instead of nvim-cmp
---@return lsp.ClientCapabilities
function M.make_client_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  
  -- Use blink.cmp to extend capabilities
  local ok, blink = pcall(require, 'blink.cmp')
  if ok then
    return blink.get_lsp_capabilities(capabilities)
  end
  
  return capabilities
end

return M
