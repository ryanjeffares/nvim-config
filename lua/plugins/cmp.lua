return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- LSP source
		"hrsh7th/cmp-buffer", -- words from current buffer
		"hrsh7th/cmp-path", -- filesystem paths
		"L3MON4D3/LuaSnip", -- snippet engine (required by cmp)
		"saadparwaiz1/cmp_luasnip", -- snippet source
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			mapping = cmp.mapping.preset.insert({
				-- Arrow keys to cycle
				["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
				["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

				-- Tab: confirm first item if nothing selected, else cycle down
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						local entry = cmp.get_active_entry()
						if entry then
							cmp.confirm({ select = false })
						else
							cmp.confirm({ select = true })
						end
					else
						fallback()
					end
				end, { "i", "s" }),

				-- Shift-Tab to cycle back up
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
					else
						fallback()
					end
				end, { "i", "s" }),

				-- Explicit confirm with Enter (optional but useful)
				["<CR>"] = cmp.mapping.confirm({ select = false }),

				-- Close the menu
				["<C-e>"] = cmp.mapping.abort(),
			}),

			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}, {
				{ name = "buffer" },
				{ name = "path" },
			}),

			-- Pre-select the first item so Tab always has something to confirm
			preselect = cmp.PreselectMode.Item,

			completion = {
				completeopt = "menu,menuone,noinsert",
			},
		})
	end,
}
