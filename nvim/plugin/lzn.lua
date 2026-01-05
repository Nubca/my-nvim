-- nvim/plugin/lzn.lua
vim.g.lzn_auto_require = true

-- Optional: add debug output
vim.api.nvim_create_autocmd("User", {
  pattern = "LznPluginsLoaded",
  callback = function()
    print("LZN plugins loaded!")
  end,
})
