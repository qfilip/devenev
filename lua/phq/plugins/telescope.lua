return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
-- or                              , branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        local telescope = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
        --vim.keymap.set('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", {})
        --vim.keymap.set('n', '<leader>fg', "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", {})
        vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
        vim.keymap.set('n', '<leader>fb', telescope.buffers, {})
        vim.keymap.set('n', '<leader>fh', telescope.help_tags, {})
      end
    }
