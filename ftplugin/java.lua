
local jdtls = require("jdtls")


 local bundles = {
      vim.fn.glob("/Users/bishalthapa/opt/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.53.1.jar")
 }

-- Needed for running/debugging unit tests
vim.list_extend(bundles, vim.split(vim.fn.glob("/Users/bishalthapa/.local/share/nvim/mason/share/java-test/*.jar", 1), "\n"))


local config = {
 -- cmd is the command that starts the language server. Whatever is placed
  -- here is what is passed to the command line to execute jdtls.
  -- Note that eclipse.jdt.ls must be started with a Java version of 17 or higher
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  -- for the full list of options
  cmd = {
    '/Users/bishalthapa/.local/share/sdkman/candidates/java/21.0.1-amzn/bin/java', 
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-javaagent:/Users/bishalthapa/.local/share/nvim/mason/packages/jdtls/lombok.jar',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    -- 💀
    '-jar', '/Users/bishalthapa/opt/jdt-language-server-1.43.0/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
         -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
         -- Must point to the                                                     Change this to
         -- eclipse.jdt.ls installation                                           the actual version
    -- 💀
    '-configuration', '/Users/bishalthapa/opt/jdt-language-server-1.43.0/config_mac/',
                    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
                    -- Must point to the                      Change to one of `linux`, `win` or `mac`
                    -- eclipse.jdt.ls installation            Depending on your system.
    -- 💀
    -- See `data directory configuration` section in the README
    '-data', '/Users/bishalthapa/jdtls-workspace/'
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  --
  -- vim.fs.root requires Neovim 0.10.
  -- If you're using an earlier version, use: require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
  root_dir = vim.fs.root(0, {".git", "mvnw", "gradlew"}),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      format = {
        settings = {
          -- Use Google Java style guidelines for formatting
          -- To use, make sure to download the file from https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
          -- and place it in the ~/.local/share/eclipse directory or ~/opt/eclipse-java-google-style.xml
          url = "/Users/bishalthapa/opt/eclipse-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },
    
      configuration = {
        updateBuildConfiguration = "interactive",
        -- TODO Update this by adding any runtimes that you need to support your Java projects and removing any that you don't have installed
        -- The runtime name parameters need to match specific Java execution environments.  See https://github.com/tamago324/nlsp-settings.nvim/blob/2a52e793d4f293c0e1d61ee5794e3ff62bfbbb5d/schemas/_generated/jdtls.json#L317-L334
        runtimes = {
          {
            name = "JavaSE-11",
            path = "/Users/bishalthapa/.local/share/sdkman/candidates/java/11.0.21-amzn/bin/java",
          },
          {
            name = "JavaSE-17",
            path = "/Users/bishalthapa/.local/share/sdkman/candidates/java/17.0.9-amzn/bin/java",
          },
          {
            name = "JavaSE-19",
            path = "/Users/bishalthapa/.local/share/sdkman/candidates/java/19.0.2-zulu/bin/java",
          },
          {
            name = "JavaSE-21",
            path = "/Users/bishalthapa/.local/share/sdkman/candidates/java/21.0.1-amzn/bin/java",
          },
        },
      },
    }
  },

  -- Needed for auto-completion with method signatures and placeholders
  capabilities = require("cmp_nvim_lsp").default_capabilities(),

  init_options = {
    bundles = bundles,
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
  },
}

-- Needed for debugging
config["on_attach"] = function(client, bufnr)
  jdtls.setup_dap({ hotcodereplace = "auto" })
  require("jdtls.dap").setup_dap_main_class_configs()
end

-- This starts a new client & server, or attaches to an existing client & server based on the `root_dir`.
jdtls.start_or_attach(config)
