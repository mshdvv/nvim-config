-- Neovim basic config :D
-- Author: msh/mshdevv@gmail.com

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
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
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
      completion = { documentation = { auto_show = true, auto_show_delay_ms = 200, }, },
    },
  },


  {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },
    config = function()
      local blink = require('blink.cmp')

      vim.lsp.config('clangd', {
	capabilities = blink.get_lsp_capabilities(),

	cmd = { "clangd", "--background-index", "--clang-tidy" },

	root_dir = function(bufnr)
	  local fname = vim.api.nvim_buf_get_name(bufnr)

	  local root = vim.fs.root(fname, {
	    'compile_commands.json',
	    'compile_flags.txt',
	    '.clangd',
	    '.git',
	  })

	  return root or vim.fn.getcwd()
	end,
      })

      vim.lsp.enable('clangd')
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
	float = {
	  enable = false,
	  quit_on_focus_loss = true,
	  open_win_config = {
	    relative = "editor",
	    border = "rounded",
	    width = 30,
	    height = 30,
	    row = 1,
	    col = 1,
	  },
	},
      },

      renderer = {
	group_empty = true,

	indent_markers = {
	  enable = true;
	},

	icons = {
	  web_devicons = {
	    file = {
	      enable = true,
	      color = true,
	    },
	    folder = {
	      enable = false,
	      color = true,
	    },
	  },
	  git_placement = "after",
	  modified_placement = "after",
	  diagnostics_placement = "signcolumn",
	  bookmarks_placement = "signcolumn",
	  padding = " ",
	  symlink_arrow = " -> ",
	  show = {
	    file = true,
	    folder = true,
	    folder_arrow = true,
	    git = true,
	    modified = true,
	    diagnostics = true,
	    bookmarks = true,
	  },
	  glyphs = {
	    default = "",
	    symlink = "",
	    bookmark = "󰆤",
	    modified = "●",
	    folder = {
	      arrow_closed = "",
	      arrow_open = "",
	      default = "",
	      open = "",
	      empty = "",
	      empty_open = "",
	      symlink = "",
	      symlink_open = "",
	    },
	    git = {
	      unstaged = "✗",
	      staged = "✓",
	      unmerged = "",
	      renamed = "➜",
	      untracked = "★",
	      deleted = "",
	      ignored = "◌",
	    },
	  },
	},
      },

      filters = {
	dotfiles = false,
      },
    } 
  },

  { 
    'akinsho/toggleterm.nvim', 
    version = "*", 
    opts = { 
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
	border = "rounded",
	winblend = 0,
	width = 88,
	height = 28,
	winblend = 15,
	highlights = {
	  border = "Normal",
	  background = "Normal",
	},
      },
    } 
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },

  { 'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' }, 
  opts = {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {
	statusline = {},
	winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
	statusline = 1000,
	tabline=1000,
	winbar = 1000,
	refresh_time = 16, -- ~60fps
      }
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename'},
      lualine_x = {'encoding','filetype', 'hostname'},
      lualine_y = {'progress'},
      lualine_z = {'location', 'lsp_status'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {'filename'},
      lualine_c = {'branch', 'diff', 'diagnostics'},
      lualine_x = {'filetype'},
      lualine_y = {'location'},
      lualine_z = {}
    },
    tabline = {
      lualine_a = {'buffers'},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {'tabs'}
    },
    winbar = { 
      lualine_a = {{'filename', path = 4}},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {}
    },
    inactive_winbar = { 
      lualine_a = {{'filename', path = 4}},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {}
    },
    extensions = {}

  } },
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'karb94/neoscroll.nvim', config = true },  
  { 'lewis6991/gitsigns.nvim', config = true },  
  { 'windwp/nvim-autopairs', event = "InsertEnter", config = true },
  { "kylechui/nvim-surround", version = "^4.0.0", event = "VeryLazy", }

})

-- shitty color fix :D

vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#191919" })
