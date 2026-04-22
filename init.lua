-- Neovim basic config :D
-- msh/mshdevv@gmail.com

local opt = vim.opt

opt.syntax = "on"
opt.background = "dark"
opt.wrap = false
opt.shiftwidth = 2
opt.number = true
opt.termguicolors = true
opt.cursorline = true
opt.mouse = ""
opt.swapfile = false
opt.numberwidth = 1
opt.clipboard = "unnamedplus"
opt.ruler = true
opt.encoding = "UTF-8"
opt.showmatch = true
opt.laststatus = 2
opt.showmode = false
opt.hidden = true
opt.splitright = true
opt.splitbelow = true

-- Keymappings

local key = vim.keymap.set
vim.g.mapleader = " "

-- Files saving and quit

key('n', '<leader>w', ':w<cr>')
key('n', '<leader>q', ':q<cr>')
key('n', '<leader>qq', ':q!<cr>')
key('n', '<leader>ww', ':wq<cr>')

-- Marks

key('n', '<leader>rr', '``<cr>')
key('n', '<leader>r', '`')

-- Window navigation

key('n', '<c-h>', '<c-w>h')
key('n', '<c-j>', '<c-w>j')
key('n', '<c-k>', '<c-w>k')
key('n', '<c-l>', '<c-w>l')

-- File searching

key('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
key('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
key('n', '<leader>s', ':noh<cr>')

-- Buffer navigation

key('n', '<leader>>', ':bnext<cr>')
key('n', '<leader><', ':bprevious<cr>')
key('n', '<leader>bd', ':bdelete<cr>')

-- Tab navigation

key('n', '<leader>.', ':tabnext<cr>')
key('n', '<leader>,', ':tabprevious<cr>')
key('n', '<leader>n', ':tabnew<cr>')

-- NvimTree toggle

key('n', '<leader>nc', ':NvimTreeToggle<cr>')
key('n', '<leader>nt', ':NvimTreeFindFile<cr>')
key('n', '<leader>nr', ':NvimTreeRefresh<cr>')

-- Term

key('n', '<leader>ft', '<cmd>ToggleTerm<cr>')
key('n', '<leader>t', '<cmd>ToggleTerm direction=horizontal size=15<cr>')

-- Lazy shit

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    'sainnhe/gruvbox-material',
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_foreground = 'original'
      vim.g.gruvbox_material_background = 'hard'
      vim.g.gruvbox_material_transparent_background = 2
      vim.cmd('colorscheme gruvbox-material')
    end
  },

  {
    'saghen/blink.cmp',
    version = '*',
    opts = {
      keymap = { preset = 'default' },
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
      completion = { documentation = { auto_show = true, auto_show_delay_ms = 200 } },
    },
  },

  {
  'neovim/nvim-lspconfig',
  dependencies = { 'saghen/blink.cmp' },
  config = function()
    local blink = require('blink.cmp')
    local capabilities = blink.get_lsp_capabilities()

    local function setup(server, opts)
      opts = opts or {}
      opts.capabilities = capabilities
      vim.lsp.config(server, opts)
      vim.lsp.enable(server)
    end

    setup('clangd', {
      cmd = { "clangd", "--background-index", "--clang-tidy" },
      root_dir = vim.fs.root(0, {
        'compile_commands.json',
        'compile_flags.txt',
        '.clangd',
        '.git',
      }),
    })

    setup('ts_ls')
    setup('rust_analyzer')
    setup('lua_ls')
  end
},

  {
    'nvim-tree/nvim-tree.lua',
    opts = {
      actions = {
	open_file = {
	  quit_on_open = true,
	},
      },
      view = {
	centralize_selection = true,
	cursorline = true,
	debounce_delay = 15,
	side = "left",
	preserve_window_proportions = false,
	number = false,
	relativenumber = false,
	signcolumn = "yes",
	width = 35,
      },
      renderer = {
	group_empty = true,
	indent_markers = { enable = true },
      },
      filters = { dotfiles = false },
    }
  },

  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      direction = "float",
      float_opts = {
	border = "rounded",
	width = 88,
	height = 28,
	winblend = 15,
      },
    }
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {}
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false,
    config = function()
      require('nvim-treesitter').install({ 'c', 'lua', 'rust', 'javascript', 'markdown', 'markdown_inline' })
    end,
  },

  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    opts = {},
  },

  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'karb94/neoscroll.nvim', config = true },
  { 'lewis6991/gitsigns.nvim', config = true },
  { 'windwp/nvim-autopairs', event = "InsertEnter", config = true },
  { "kylechui/nvim-surround", version = "^4.0.0", event = "VeryLazy" },
  { 'wakatime/vim-wakatime', lazy = false }

}, {
    rocks = {
      enabled = false,
    }
  })


-- shitty color fix :D

vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#191919" })

-- treesitter nvim

vim.api.nvim_create_autocmd('FileType', {
  pattern = { "c", "lua", "rust", "javascript", "markdown" },
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

vim.diagnostic.config({
  float = { border = 'rounded' },
  virtual_text = true,
  severity_sort = true,
})
