local M = {}


local get_visual_range = function ()
    local start_pos = vim.fn.getpos('v')
    local end_pos = vim.fn.getpos('.')
    if start_pos[2] == end_pos[2] then
        if start_pos[3] == end_pos[3] then
            if vim.fn.mode() == 'V' then
                local line = vim.fn.getline(start_pos[2])
                start_pos[3] = 1
                end_pos[3] = string.len(line)
                return start_pos, end_pos
            end
            print('hipe: no selection')
            return
        elseif start_pos[3] > end_pos[3] then
            -- selection was made from right to left
            return end_pos, start_pos
        else
            return start_pos, end_pos
        end
    elseif start_pos[2] > end_pos[2] then
        -- selection was made from bottom to top
        return end_pos, start_pos
    else
        return start_pos, end_pos
    end
end

local get_selected_text = function ()
    local start_pos, end_pos = get_visual_range()
    if not start_pos or not end_pos then
        print('hipe: no selection')
        return
    end
    if start_pos[2] ~= end_pos[2] then
        print('hipe: selection must be in the same line')
        return
    end
    -- print('start_pos', vim.inspect(start_pos), 'end_pos', vim.inspect(end_pos))
    local line = vim.fn.getline(start_pos[2])
    local selection = string.sub(line, start_pos[3], end_pos[3])

    return selection
end

local overwrite_selection = function (new_text)
    new_text = string.gsub(new_text, '\n', '')
    local start_pos, end_pos = get_visual_range()
    if not start_pos or not end_pos then
        print('hipe: no selection')
        return
    end
    if start_pos[2] ~= end_pos[2] then
        print('hipe: selection must be in the same line')
        return
    end
    local end_col = end_pos[3]
    local line = vim.fn.getline(start_pos[2])
    if string.len(line) < end_col then
        end_col = string.len(line)
    end
    vim.api.nvim_buf_set_text(0, start_pos[2] - 1, start_pos[3] - 1, end_pos[2] - 1, end_col, { new_text })
end


M.pipe_selection = function (cmd)
    local selection = get_selected_text()
    if not selection then
        return
    end
    selection = string.gsub(selection, '\n', '')

    local command = string.format('echo "%s" | %s', selection, cmd)
    local r = vim.fn.system(command)

    if r == '' then
        print('hipe: no output')
        return
    end
    overwrite_selection(r)
end

return M
