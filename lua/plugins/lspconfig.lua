return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "jay-babu/mason-null-ls.nvim",
        "nvimtools/none-ls.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {
                library = {
                    { path = "luvit-meta/library", words = { "vim%.uv" } },
                },
            },
        },
        { "Bilal2453/luvit-meta", lazy = true },
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
        local lspconfig = require("lspconfig")
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require("mason-tool-installer")
        local mason_null_ls = require("mason-null-ls")
        local null_ls = require("null-ls")
        local configs = require("lspconfig.configs")
        local cmp = require("cmp")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local default_capabilities = vim.lsp.protocol.make_client_capabilities()

        local server_configs = {
            -- place language server names and their configuration here as a key-value pair
            lua_ls = {
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                        diagnostics = {
                            disable = {
                                "missing-fields",
                            },
                        },
                    },
                },
            },
        }

        mason.setup()

        local mason_ensure_installed = vim.tbl_keys(server_configs or {})
        vim.list_extend(mason_ensure_installed, {
            "stylua",
            "pyright",
        })
        mason_tool_installer.setup({
            ensure_installed = mason_ensure_installed,
        })
        mason_null_ls.setup({
            ensure_installed = { "black" },
        })

        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.black,
            },
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ async = false })
                        end,
                    })
                end
            end,
        })

        vim.g.rustfmt_autosave = 1

        mason_lspconfig.setup({
            handlers = {
                function(server_name)
                    local server_config = server_configs[server_name] or {}
                    server_config.capabilities =
                        vim.tbl_deep_extend("force", default_capabilities, server_config.capabilities or {})
                    lspconfig[server_name].setup(server_config)
                end,
            },
        })

        default_capabilities = vim.tbl_deep_extend("force", default_capabilities, cmp_nvim_lsp.default_capabilities())

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lsp-attach-keybinds", { clear = true }),
            callback = function(e)
                local keymap = function(keys, func)
                    vim.keymap.set("n", keys, func, { buffer = e.buf })
                end
                local builtin = require("telescope.builtin")

                keymap("gd", builtin.lsp_definitions)
                vim.keymap.set("n", "gv", ":vsplit<CR>gd")
                keymap("gD", vim.lsp.buf.declaration)
                keymap("gr", builtin.lsp_references)
                keymap("gI", builtin.lsp_implementations)
                keymap("ga", vim.lsp.buf.code_action)
                keymap("<leader>D", builtin.lsp_type_definitions)
                keymap("<leader>ds", builtin.lsp_document_symbols)
                keymap("<leader>ws", builtin.lsp_dynamic_workspace_symbols)
                keymap("<leader>rn", vim.lsp.buf.rename)
                keymap("<leader>ca", vim.lsp.buf.code_action)
                keymap("K", vim.lsp.buf.hover)
            end,
        })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(true)
                end
                -- whatever other lsp config you want
            end,
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<Tab>"] = cmp.mapping.confirm({ select = true }),
                -- ['<C-m>'] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" }, -- For luasnip users.
                { name = "amazonq" },
            }, {
                { name = "buffer" },
            }),
        })
    end,
}
