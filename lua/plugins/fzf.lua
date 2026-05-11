return {
	"ibhagwan/fzf-lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local fzf = require("fzf-lua")
		fzf.setup({})

		vim.keymap.set("n", "<C-\\>", fzf.buffers)
		vim.keymap.set("n", "<C-p>", fzf.files)
		vim.keymap.set("n", "<C-g>", fzf.grep)
		vim.keymap.set("n", "<C-l>", fzf.live_grep)
		vim.keymap.set("n", "<C-k>", fzf.builtin)
	end,
}
