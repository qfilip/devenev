require "paq" {
    "savq/paq-nvim", -- Let Paq manage itself
    "neovim/nvim-lspconfig",
    { "lervag/vimtex", opt = true }, -- Use braces when passing options
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope.nvim', tag = '0.1.6', build = ':TSInstall! lua' },
    { 'mason-org/mason.nvim' }
}
