return {
  {
    "luasnip",
    lazy = false,
    after = function()
      local luasnip = require("luasnip")
      
      -- Load friendly-snippets if you want pre-made snippets
      -- require("luasnip.loaders.from_vscode").lazy_load()
      
      -- Basic LuaSnip configuration
      luasnip.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
      })
    end,
  },
}
