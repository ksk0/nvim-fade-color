-- ============================================
-- aserts:
--   is     - test is true
--   is_not - test is not true
--   has    - same as is
--   equal  - comparing if same object
--   same   - comparing if content of object are eqaul
--
--   no.errors   - run without errors
--   has.errors  - run with errors


--
-- eqaul objects:
--   A = {element = 1}
--   B = A
--
-- same objects:
--   A = {element = 1}
--   B = {element = 1}



-- ============================================
-- disable output of notifications from plugin
---
-- vim.notify = function() end

local F

print("")
describe("Module:", function ()
  it("Requiring module [OK]", function ()
    assert.no.errors(function() F = require("fade-color") end)
  end)
end)

-- test sample colors
--
local src_color_rgb = {240, 97, 44}
local src_color_int = 240*65536 +  97*256 + 44
-- local src_color_hsl = {16, 86.7, 55.7}

local dst_color_rgb = {103, 55, 31}
local dst_color_int = 103*65536 +  55*256 + 31
-- local dst_color_hsl = {20, 53.7, 26.3}

local faded_050_rgb = {178, 71, 31}
local faded_050_int = 178*65536 + 71 * 256 + 31

local faded_100_rgb = {103, 50, 31}
local faded_100_int = 103*65536 + 50 * 256 + 31

print("")
it("Return value is list [OK]", function ()
  local faded = F.fade(src_color_rgb, dst_color_rgb, 0)
  assert.equal('table', type(faded))
end)

it("Return value is number [OK]", function ()
  local faded = F.fade(src_color_int, dst_color_int, 0)
  assert.equal('number', type(faded))
end)

print("")
describe("List of RGB values:", function ()
  it("Fade =   0% [OK]", function ()
    local faded = F.fade(src_color_rgb, dst_color_rgb, 0)
    assert.same(src_color_rgb, faded)
  end)

  it("Fade =  50% [OK]", function ()
    local faded = F.fade(src_color_rgb, dst_color_rgb, 0.5)
    assert.same(faded_050_rgb, faded)
  end)

  it("Fade = 100% [OK]", function ()
    local faded = F.fade(src_color_rgb, dst_color_rgb, 1)
    assert.same(faded_100_rgb, faded)
  end)
end)

print("")
describe("Color as integer value:", function ()
  it("Fade =   0% [OK]", function ()
    local faded = F.fade(src_color_int, dst_color_int, 0)
    assert.same(src_color_int, faded)
  end)

  it("Fade =  50% [OK]", function ()
    local faded = F.fade(src_color_int, dst_color_int, 0.5)
    assert.same(faded_050_int, faded)
  end)

  it("Fade = 100% [OK]", function ()
    local faded = F.fade(src_color_int, dst_color_int, 1)
    assert.same(faded_100_int, faded)
  end)
end)
