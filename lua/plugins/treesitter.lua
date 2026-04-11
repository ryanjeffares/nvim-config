return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	tag = "v0.10.0",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects", -- smart text objects
	},
	config = function()
		require("nvim-treesitter.configs").setup({

			ensure_installed = {
				"c",
				"cpp",
				"python",
				"rust",
				"lua",
				-- extras worth having
				"bash",
				"json",
				"toml",
				"yaml",
				"markdown",
				"vim",
				"vimdoc",
			},

			highlight = {
				enable = true,
			},

			indent = {
				enable = true, -- treesitter-based indentation (works alongside sleuth)
			},

			-- Incremental selection: expand/contract selection by syntax node
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<CR>", -- start selection at cursor
					node_incremental = "<CR>", -- expand to next node
					node_decremental = "<BS>", -- shrink back
					scope_incremental = "<S-CR>", -- expand to enclosing scope
				},
			},

			-- Text objects: treat syntax nodes as motions
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- jump forward to next match automatically
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["aa"] = "@parameter.outer", -- aa = "an argument"
						["ia"] = "@parameter.inner",
						["ab"] = "@block.outer",
						["ib"] = "@block.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- adds to jumplist so <C-o> works
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.inner",
					},
					goto_prev_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.inner",
					},
				},
				swap = {
					enable = true,
					swap_next = { ["<leader>sn"] = "@parameter.inner" },
					swap_previous = { ["<leader>sp"] = "@parameter.inner" },
				},
			},
		})
	end,
}
