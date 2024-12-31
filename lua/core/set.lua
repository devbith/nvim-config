vim.opt.number = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim-undodir"
vim.opt.undofile = true

vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.wildignore:append("*./target/.*")
vim.opt.wildignore:append("*/.git/*,*/node_modules/*")  -- Example: Add more directories to ignore

vim.cmd[[
  augroup highlight_yank
  autocmd!
 au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=400})
  augroup END
]]


