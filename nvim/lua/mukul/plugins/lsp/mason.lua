return {
	"williamboman/mason.nvim",
	event = { "BufEnter" },
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		local lspconfig = require("lspconfig")
		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"lua_ls",
				"pyright",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"stylua",
				"ruff",
				"sonarlint-language-server",
			},
		})

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup({})
			end,
			["svelte"] = function()
				-- configure svelte server
				lspconfig["svelte"].setup({
					on_attach = function(client, bufnr)
						vim.api.nvim_create_autocmd("BufWritePost", {
							pattern = { "*.js", "*.ts" },
							callback = function(ctx)
								-- Here use ctx.match instead of ctx.file
								client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
							end,
						})
					end,
				})
			end,
			["pyright"] = function()
				-- configure pyright server
				lspconfig["pyright"].setup({
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "off", -- Disable strict type checking (similar to Pylance)
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								diagnosticMode = "workspace", -- Diagnostics for the whole workspace
							},
						},
					},
				})
			end,
			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,
		})
	end,
}
