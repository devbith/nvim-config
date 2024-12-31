-- LSP Support
return {
  -- LSP Configuration
  -- https://github.com/neovim/nvim-lspconfig
  'neovim/nvim-lspconfig',
  dependencies = {
   { 
      'williamboman/mason.nvim',
      opts = {
        ui = {
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
          },
        },
      }
   },
   { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
   { 'williamboman/mason-lspconfig.nvim' },
  },

  config = function ()
    require('mason').setup()
    require('mason-lspconfig').setup({
      -- Install these LSPs automatically
      ensure_installed = { 'bashls', 'cssls', 'html', 'gradle_ls', 'groovyls', 
        'lua_ls', 'jdtls', 'jsonls', 'lemminx', 'marksman', 'quick_lint_js', 'yamlls', 
      }
    })


    require('mason-tool-installer').setup({
      -- Install these linters, formatters, debuggers automatically
      ensure_installed = {
        'java-debug-adapter',
        'java-test',
      },
    })

    local lspconfig = require('lspconfig')

     -- Call setup on each LSP server
    require('mason-lspconfig').setup_handlers({
      function(server_name)
        -- Don't call setup for JDTLS Java LSP because it will be setup from a separate config
        if server_name ~= 'jdtls' then
          lspconfig[server_name].setup({
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
          })
        end
      end
    })



  end
}
