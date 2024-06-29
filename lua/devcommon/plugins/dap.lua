-- lua/devcommon/plugins/dap.lua

return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate", -- :MasonUpdate updates registry contents
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"mfussenegger/nvim-dap",
			"mfussenegger/nvim-dap-python",
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"nvim-telescope/telescope.nvim", -- Add telescope.nvim
			"nvim-telescope/telescope-dap.nvim", -- Add telescope-dap.nvim
			"williamboman/mason.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()
			require("mason-nvim-dap").setup({
				ensure_installed = { "debugpy" },
			})

			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()

			-- Automatically open and close the dapui on debug sessions
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				--dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				--dapui.close()
			end
			dap.listeners.before.event_stopped["dapui_config"] = function()
				dap.repl.open() -- Ensure the REPL stays open if execution stops due to an error
			end

			-- Configure nvim-dap-python
			require("dap-python").setup("python") -- This assumes 'python' is in your PATH. Adjust the path if necessary.

			-- Define a configuration similar to the one in your launch.json
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "payment_config",
					program = "${workspaceFolder}/app/manage.py",
					args = { "runserver", "6000", "--settings=payment_config.settings.develop" },
					django = true,
					justMyCode = true,
				},
				{
					type = "debugpy",
					name = "epos",
					request = "launch",
					program = "${workspaceFolder}/app/manage.py",
					args = { "runserver", "8800", "--settings=epos.settings.develop" },
					django = true,
					justMyCode = true,
				},
				{
					type = "debugpy",
					name = "Python debug current file",
					request = "launch",
					program = "${file}",
					console = "integratedTerminal",
				},
			}

			-- Keybindings
			vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
			vim.keymap.set("n", "<F5>", function()
				require("telescope").extensions.dap.configurations()
			end, { desc = "Select and start debug configuration" })
			vim.keymap.set("n", "<F10>", dap.step_over)
			vim.keymap.set("n", "<F11>", dap.step_into)
			vim.keymap.set("n", "<F12>", dap.step_out)
			vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<Leader>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end)
			vim.keymap.set("n", "<Leader>lp", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end)
			vim.keymap.set("n", "<Leader>dr", dap.repl.open)
			vim.keymap.set("n", "<Leader>dl", dap.run_last)
			vim.keymap.set("n", "<Leader>dq", dap.terminate, { desc = "Close all dap" }) -- Add this line to set a keybinding for terminating the debug session

			-- Custom command to close all DAP windows
			vim.api.nvim_create_user_command("DapCloseAll", function()
				dapui.close()
				dap.repl.close()
				-- Close any remaining DAP-related buffers
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if
						vim.bo[buf].filetype == "dapui_scopes"
						or vim.bo[buf].filetype == "dapui_breakpoints"
						or vim.bo[buf].filetype == "dapui_stacks"
						or vim.bo[buf].filetype == "dapui_watches"
						or vim.bo[buf].filetype == "dap-repl"
					then
						vim.api.nvim_buf_delete(buf, { force = true })
					end
				end
			end, { desc = "Close all DAP windows" })

			-- Keybinding to close all DAP windows
			vim.keymap.set("n", "<Leader>dc", ":DapCloseAll<CR>", { desc = "Close all DAP windows" })

			-- Setup telescope-dap
			require("telescope").load_extension("dap")
		end,
	},
}
