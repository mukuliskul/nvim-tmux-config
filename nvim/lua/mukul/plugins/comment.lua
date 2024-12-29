return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		-- import comment plugin safely
		local comment = require("Comment")

		local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

		-- enable comment
		comment.setup({
			-- for commenting tsx, jsx, svelte, html files
			pre_hook = ts_context_commentstring.create_pre_hook(),

			-- Custom mappings using Unimpaired
			-- vim.api.nvim_set_keymap("n", "[c", "g{", { noremap = true, silent = true }), -- Move to previous comment
			-- vim.api.nvim_set_keymap("n", "]c", "g}", { noremap = true, silent = true }), -- Move to next comment
		})
	end,
}
