local M = {}

local max = function(list)
  table.sort(list, function(a,b) return b < a end )
  return list[1]
end

local min = function(list)
  table.sort(list, function(a,b) return b > a end )
  return list[1]
end

local decompose_rgb = function (color)
  local B = color % 256
  local G = bit.rshift(color,8) % 256
  local R = bit.rshift(color,16)

  return R, G, B
end

local compose_rgb = function (CR, CG, CB)
  local R = CR
  local G = CG
  local B = CB

  if type(R) == 'table' then
    R = CR[1]
    G = CR[2]
    B = CR[3]
  end

  return (R * 65536 + G * 256 + B)
end

local rgb_to_hsl = function (color)
  local R, G, B

  if type(color) == 'table' then
    R = color[1]
    G = color[2]
    B = color[3]
  else
    R, G, B = decompose_rgb(color)
  end

  R = R / 255
  G = G / 255
  B = B / 255

  local rgb_min = min({R, G, B})
  local rgb_max = max({R, G, B})

  local L = (rgb_min + rgb_max) / 2
  local H = 0
  local S = 0

  if (rgb_max ~= rgb_min) then
    if L <= 0.5 then
      S = (rgb_max - rgb_min)/(rgb_max + rgb_min)
    else
      S = (rgb_max - rgb_min)/(2.0 - rgb_max - rgb_min)
    end

    if rgb_max == R then
      H = (G - B)/(rgb_max - rgb_min)
    elseif rgb_max == G then
      H = 2.0 + (B - R)/(rgb_max - rgb_min)
    else
      H = 4.0 + (R - G)/(rgb_max - rgb_min)
    end

    H = H * 60

    if H < 0 then
      H = H + 360
    end
  end

  return H, S, L
end

local hsl_to_rgb_primary = function (H, S, L, channel)
  local T1

  if L < 0.5 then
    T1 = L * (1.0 + S)
  else
    T1 = L + S - L * S
  end

  local T2 = 2 * L - T1
  local H1 = H / 360
  local TC

  if channel == 'r' then
    TC = H1 + 0.33333
  elseif channel == 'g' then
    TC = H1
  else
    TC = H1 - 0.33333
  end

  if TC < 0 then
    TC = TC + 1
  elseif TC > 1 then
    TC = TC - 1
  end

  local primary

  if (TC * 6) < 1 then
    primary = T2 + (T1 - T2) * 6 * TC
  elseif (TC * 2) < 1 then
    primary = T1
  elseif (TC * 3) < 2 then
    primary = T2 + (T1 - T2) * (0.6666 - TC) * 6
  else
    primary = T2
  end

  return (math.floor(0.5 + primary * 255))
end

local hsl_to_rgb = function (H, S, L)
  local R = 0
  local G = 0
  local B = 0

  if H == 0 then
    R = math.floor(0.5 + L * 255)
    G = R
    B = R

  else
    R = hsl_to_rgb_primary(H, S, L, 'r')
    G = hsl_to_rgb_primary(H, S, L, 'g')
    B = hsl_to_rgb_primary(H, S, L, 'b')
  end

  return {R, G, B}
end

M.fade = function (src_color, dst_color, fade)
  local src_h, src_s, src_l = rgb_to_hsl(src_color)
  local     _, dst_s, dst_l = rgb_to_hsl(dst_color)

  local fade_l = src_l * (1 - fade) + dst_l * fade
  local fade_s = src_s * (1 - fade) + dst_s * fade
  local fade_h = src_h

  local faded_color = hsl_to_rgb(fade_h, fade_s, fade_l)

  if type(src_color) ~= 'table' then
    return compose_rgb(faded_color)
  end

  return faded_color
end

return M
