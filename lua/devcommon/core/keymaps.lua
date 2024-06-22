-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

keymap.set("n", "<leader>pv", vim.cmd.Ex) -- exit current page
-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

keymap.set("n", "<leader>th", ":split term://zsh<CR>", { desc = "Open terminal in horizontal split" })
keymap.set("n", "<leader>tv", ":vsplit term://zsh<CR>", { desc = "Open terminal in vertical split" })
keymap.set("n", "<leader>tt", ":tabnew | zsh<CR>", { desc = "Open terminal in new tab" })

-- Move to the terminal split (assuming it's on the bottom)
keymap.set("n", "<leader>tj", "<C-w>j", { desc = "Move to the terminal split" })

-- Move back to the previous split (assuming it's on the top)
keymap.set("n", "<leader>tk", "<C-w>k", { desc = "Move back to the previous split" })

keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" }) -- exit terminal mode using <Esc>
keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "Move to left window" })
keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { desc = "Move to lower window" })
keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "Move to upper window" })
keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "Move to right window" })
