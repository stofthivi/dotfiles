local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require 'lazy'.setup({
	'folke/lazy.nvim',
	{
		'neovim/nvim-lspconfig',
		config = function()
			require 'lspconfig'.nil_ls.setup {}
			require 'lspconfig'.lua_ls.setup {}
		end
	},
	{
		'echasnovski/mini.nvim',
		config = function()
			require 'mini.basics'.setup {}
			require 'mini.pairs'.setup {}
		end
	},
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = function()
			local configs = require 'nvim-treesitter.configs'
			configs.setup({
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true }
			})
		end
	},
	{
		'HiPhish/rainbow-delimiters.nvim',
		config = function()
			require 'rainbow-delimiters.setup'.setup {}
		end
	},
	{
		'nvim-lualine/lualine.nvim',
		opts = {}
	},
})

vim.g.mapleader = " "
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', '<leader>f', '<cmd>lua vim.lsp.buf.format{async=true}<CR>', { remap = false })
vim.opt.clipboard = "unnamedplus"


vim.api.nvim_create_autocmd({ 'FileType' }, {
	pattern = 'hyprlang',
	callback = function()
		vim.api.nvim_buf_set_option(0, 'cms', '# %s')
	end
})
