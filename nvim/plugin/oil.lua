return {
  "oil.nvim",
  lazy = false,
  opts = {
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,  -- Always show hidden/dotfiles
      is_always_hidden = function(name, bufnr) return false end,
      is_always_hidden = function(name, _)
          return name == "node_modules" or name == ".git"
        end,
    },
  },
  after = function()
    require("oil").setup({
      keymaps = {
        ["<C-c>"] = false,
        ["<leader>o"] = "actions.close",
      },
    })
  end,
  wk = {
    { "<leader>t", "<CMD>Oil<CR>", desc = "Toggle Oil" },
  },
}
