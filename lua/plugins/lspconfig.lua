return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local function on_attach(client, bufnr)
			local opts = { noremap = true, silent = true, buffer = bufnr }

			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

			-- Disable LSP formatting — conform handles all of it
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false

			if client.server_capabilities.inlayHintProvider then
				vim.lsp.inlay_hint.enable(true)
			end
		end

		local lsps = {
			{
				"pyright",
				{
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "standard",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								diagnosticMode = "workspace",
							},
						},
					},
				},
			},
			{
				"clangd",
				{
					capabilities = capabilities,
					on_attach = on_attach,
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--completion-style=detailed",
						"--header-insertion=iwyu",
						"--suggest-missing-includes",
					},
					filetypes = { "c", "cpp", "objc", "objcpp" },
					root_dir = function(bufnr, on_dir)
						on_dir(vim.fs.root(bufnr, { "compile_commands.json", "compile_flags.txt", ".clangd", ".git" }))
					end,
				},
			},
			{
				"rust_analyzer",
				{
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						["rust-analyzer"] = {
							cargo = { allFeatures = true },
							checkOnSave = true,
							check = { command = "clippy" },
							inlayHints = {
								bindingModeHints = { enable = true },
								chainingHints = { enable = true },
								closingBraceHints = { enable = true, minLines = 10 },
								parameterHints = { enable = true },
								typeHints = { enable = true },
							},
							procMacro = { enable = true },
						},
					},
				},
			},
			{
				"lua_ls",
				{
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								library = vim.api.nvim_get_runtime_file("", true),
							},
							diagnostics = { globals = { "vim" } },
							telemetry = { enable = false },
						},
					},
				},
			},
			{
				"neocmake",
				{
					cmd = { "neocmakelsp", "stdio" },
					capabilities = capabilities,
					on_attach = on_attach,
					filetypes = { "cmake" },
					root_dir = function(bufnr, on_dir)
						on_dir(vim.fs.root(bufnr, { ".git" }))
					end,
					single_file_support = true, -- suggested
					init_options = {
						format = {
							enable = true,
						},
						lint = {
							enable = true,
						},
						scan_cmake_in_package = true, -- default is true
					},
				},
			},
		}

		for _, lsp in pairs(lsps) do
			local name, config = lsp[1], lsp[2]
			vim.lsp.enable(name)
			vim.lsp.config(name, config)
		end
	end,
}
