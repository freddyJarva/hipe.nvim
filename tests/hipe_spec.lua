local spec_dir = '/tmp/hipe-spec'

describe("hipe", function ()
    before_each(function ()
        vim.fn.mkdir(spec_dir)
    end)

    after_each(function()
        if next(vim.fs.find('hipe-spec', {
            path = '/tmp'
        })) then
            vim.cmd('!rm -r '..spec_dir)
        end
        -- require('hipe')._reset_config()
    end)

    it("can be required", function()
        require("hipe")
    end)

    -- it("can create a new buffer with a hipe path from current buffer - php config", function()
    --     vim.fn.chdir(spec_dir)
    --     local bufnr = vim.fn.bufadd(spec_dir..'/src/controller/LameController.php')
    --     vim.cmd.buffer(bufnr)
    --     require("hipe").pipe_selection()

    --     assert.are.same(spec_dir..'/tests/controller/LameControllerTest.php', vim.api.nvim_buf_get_name(0))
    -- end)

    -- it("can create a new buffer with a srcfile  path from current buffer - php config", function()
    --     vim.fn.chdir(spec_dir)
    --     local bufnr = vim.fn.bufadd(spec_dir..'/tests/controller/LameControllerTest.php')
    --     vim.cmd.buffer(bufnr)
    --     require("hipe").pipe_selection()

    --     assert.are.same(spec_dir..'/src/controller/LameController.php', vim.api.nvim_buf_get_name(0))
    -- end)
end)
