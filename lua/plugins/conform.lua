return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				python = { "black" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				rust = { "rustfmt" },
				lua = { "stylua" },
			},
			format_on_save = {
				timeout_ms = 2000,
				lsp_fallback = false,
			},
			formatters = {
				black = {
					prepend_args = { "--line-length", "88" },
				},
				rustfmt = {
					prepend_args = { "--edition", "2021" },
				},
			},
		})

		-- Toggle format-on-save for current buffer
		vim.keymap.set("n", "<leader>tf", function()
			vim.b.disable_autoformat = not vim.b.disable_autoformat
			print("Format on save: " .. (vim.b.disable_autoformat and "OFF" or "ON"))
		end, { desc = "Toggle format on save" })
	end,
}
