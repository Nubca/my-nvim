vim.loader.enable()

local cmd = vim.cmd
local opt = vim.o

--vim heresy
opt.encoding = "utf-8"
opt.mouse = "a"
cmd.aunmenu({ "PopUp.How-to\\ disable\\ mouse" })
cmd.aunmenu({ "PopUp.-1-" })

--indenting

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

-- folding with lsp/treesitter
opt.foldmethod = 'expr'
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- These are the key settings you're missing:
opt.foldlevel = 99      -- Start with all folds open
opt.foldlevelstart = 99 -- Always start with all folds open
opt.foldenable = true   -- Enable folding
opt.foldcolumn = "auto"

opt.cmdheight = 0
opt.updatetime = 50
opt.timeout = false
opt.tm = 1000
opt.hidden = true
opt.undofile = true
opt.splitbelow = true
opt.splitright = true
opt.signcolumn = "yes:2"
opt.ai = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.visualbell = false
opt.errorbells = false

opt.number = true
opt.relativenumber = true

opt.clipboard = "unnamedplus"

opt.cursorline = true
opt.cursorlineopt = "both"
opt.cursorcolumn = true
opt.colorcolumn = "100"
opt.shiftround = true
opt.showbreak = "↪ "
opt.wrap = true

-- Search down into subfolders
opt.path = vim.o.path .. '**'

opt.lazyredraw = true
opt.showmatch = true -- Highlight matching parentheses, etc

opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
opt.colorcolumn = '100'

opt.hlsearch = false
opt.incsearch = true

opt.spell = true
opt.ignorecase = true
opt.smartcase = true
opt.spelllang = "en_us"

opt.scrolloff = 10
opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.g.cursorline_timeout = 0

opt.shortmess:append({ I = true, c = true })

opt.exrc = true

WK = require("which-key")
WK.setup()
WK.add({ " ", "<Nop>", { silent = true, remap = false } })
vim.g.mapleader = " "
vim.g.maplocalleader = ' '

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'gj', 'j')
vim.keymap.set('n', 'gk', 'k')

--theming
opt.termguicolors = true

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#111111" })
    vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#111111" })
  end
})

if not vim.g.vscode then
  vim.g.moonflyCursorColor = true
  vim.g.moonflyNormalFloat = true
  vim.g.moonflyTerminalColors = true
  vim.g.moonflyTransparent = true
  vim.g.moonflyUndercurls = false
  vim.g.moonflyUnderlineMatchParen = true
  vim.g.moonflyVirtualTextColor = true
  vim.cmd.colorscheme("moonfly")
end

-- stop hiding double quotes in json files
vim.g.indentLine_setConceal = 0

vim.g.cursorline_timeout = 0

-- Show spaces when Highlighted
opt.listchars = {
  space = '·',
  trail = '·',
  tab = '>·'
}
vim.api.nvim_create_autocmd({"ModeChanged"}, {
  pattern = {"*:v", "*:V", "*:\x16"},
  callback = function()
    vim.opt.list = true
  end
})
vim.api.nvim_create_autocmd({"ModeChanged"}, {
  pattern = {"v:n", "V:n", "\x16:n"},
  callback = function()
    vim.opt.list = false
  end
})
WK.add({
  { "Q", "<Nop>", { noremap = false } },
})
-- keymaps
WK.add({
  {
    mode = { "v" },
    { "J", ":m '>+1<CR>gv=gv" },
    { "K", ":m '<-2<CR>gv=gv" },
  },
  {
    { "C-d>", "<C-d>zz" },
    { "C-u>", "<C-u>zz" },
    { "n", "nzzzv" },
    { "N", "Nzzzv" },
  },
  {
    mode = { "x" },
    { "<leader>p", '"_dP' },
  },
})

-- automatically create directories on save if they don't exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "PageConnect",
  callback = function()
    vim.opt.spell = false
  end,
})

-- See :h <option> to see what the options do

-- Configure Neovim diagnostic messages

local function prefix_diagnostic(prefix, diagnostic)
  return string.format(prefix .. ' %s', diagnostic.message)
end

vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    format = function(diagnostic)
      local severity = diagnostic.severity
      if severity == vim.diagnostic.severity.ERROR then
        return prefix_diagnostic('󰅚', diagnostic)
      end
      if severity == vim.diagnostic.severity.WARN then
        return prefix_diagnostic('⚠', diagnostic)
      end
      if severity == vim.diagnostic.severity.INFO then
        return prefix_diagnostic('ⓘ', diagnostic)
      end
      if severity == vim.diagnostic.severity.HINT then
        return prefix_diagnostic('󰌶', diagnostic)
      end
      return prefix_diagnostic('■', diagnostic)
    end,
  },
  signs = {
    text = {
      -- Requires Nerd fonts
      [vim.diagnostic.severity.ERROR] = '󰅚',
      [vim.diagnostic.severity.WARN] = '⚠',
      [vim.diagnostic.severity.INFO] = 'ⓘ',
      [vim.diagnostic.severity.HINT] = '󰌶',
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
}

-- Native plugins
cmd.filetype('plugin', 'indent', 'on')
cmd.packadd('cfilter') -- Allows filtering the quickfix list with :cfdo

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')
