return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        require("bufferline").setup({
            options = {
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    local s = " "
                    for e, n in pairs(diagnostics_dict) do
                        local sym = e == "error" and " " or (e == "warning" and " " or " ")
                        s = s .. n .. sym
                    end
                    return s
                end,
            },
        })

        vim.keymap.set("n", "gb", "<cmd>BufferLinePick<CR>")
        vim.keymap.set("n", "gn", "<cmd>BufferLineCycleNext<CR>")
        vim.keymap.set("n", "gp", "<cmd>BufferLineCyclePrev<CR>")
        vim.keymap.set("n", "gq", "<cmd>BufferLinePickClose<CR>")
    end,
}
