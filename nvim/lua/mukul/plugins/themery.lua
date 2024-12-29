return {
	"zaldih/themery.nvim",
	lazy = false,
	config = function()
		require("themery").setup({
			-- TODO: Add more themes
			-- themes = { "gruvbox", "ayu", "kanagawa" },
		})
	end,
}
