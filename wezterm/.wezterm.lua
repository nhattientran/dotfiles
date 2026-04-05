local wezterm = require("wezterm")
local act = wezterm.action

-- Use the config builder for better error messages
local config = wezterm.config_builder()

-- ---------------------------------------------------------
-- 1. Appearance & Fonts
-- ---------------------------------------------------------
-- Options: 'Dracula', 'OneDark', 'Tokyo Night', 'Catppuccin Mocha'
config.color_scheme = "Catppuccin"
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" })
-- You can specify some parameters to influence the font selection;
-- for example, this selects a Bold, Italic font variant.
--config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })
config.font_size = 11.0
config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
	"Fira Code",
	"DengXian",
})
config.initial_cols = 120
config.initial_rows = 28

-- Window styling (Optional: acrylic/blur effect on Windows 11)
config.window_background_opacity = 0.95
-- config.win32_system_backdrop = "Acrylic"
config.window_background_image = "D:/TienTN/Pictures/nier-automata-2B-dark-desktop-wallpaper.jpg"

config.window_background_image_hsb = {
	-- Darken the background image by reducing it to 1/3rd
	brightness = 0.03,

	-- You can adjust the hue by scaling its value.
	-- a multiplier of 1.0 leaves the value unchanged.
	hue = 1.0,

	-- You can adjust the saturation also.
	saturation = 0.8,
}

-- Remove the title bar but keep the borders so you can resize
-- config.window_decorations = "RESIZE"

-- ---------------------------------------------------------
-- 2. Shell Configuration (Windows Specific)
-- ---------------------------------------------------------
-- Default to PowerShell Core (pwsh) or standard PowerShell (powershell)
-- If you prefer WSL by default, comment this out and use the Launch Menu
config.default_prog = { "pwsh.exe", "-NoLogo" }
config.wsl_domains = {
  {
    name = 'WSL:Ubuntu',        -- tên hiển thị trong launcher
    distribution = 'Ubuntu',    -- phải khớp với `wsl -l`
    default_cwd = '~',          -- OK, sẽ vào home
  },
}
-- Launch Menu - Chọn shell khi nhấn LEADER + l
config.launch_menu = {
	{
		label = "PowerShell Core",
		args = { "pwsh.exe", "-NoLogo" },
	},
	{
		label = "Windows PowerShell",
		args = { "powershell.exe", "-NoLogo" },
	},
	{
		label = "Command Prompt",
		args = { "cmd.exe" },
  },
  {
    label = 'Ubuntu',
    domain = { DomainName = 'WSL:Ubuntu' },
  },
}

config.window_padding = {
  bottom = 0,
}

-- Thêm keybinding để mở Launch Menu
-- Sẽ thêm vào keys table ở dưới

-- ---------------------------------------------------------
-- 3. Keybindings
-- ---------------------------------------------------------
-- Set a "Leader" key (like tmux prefix)
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }

config.keys = {
	-- SPLIT PANES (Leader + - or \)
	{ key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- NAVIGATION (Leader + hjkl to move between panes)
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },

	-- RESIZE PANES (Leader + Arrow Keys)
	{ key = "LeftArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "RightArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 5 }) },
	{ key = "UpArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "DownArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 5 }) },

	-- COPY/PASTE (Standard Windows keys)
	{ key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	{ key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },

	-- COMMAND PALETTE (CTRL+SHIFT+P)
	{ key = "p", mods = "CTRL|SHIFT", action = act.ActivateCommandPalette },
	-- CLOSE CURRENT PANEL
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

	-- ZOOM FONT (CTRL + +/- or CTRL + 0 to reset)
	{ key = "=", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
	{ key = "0", mods = "CTRL", action = act.ResetFontSize },

	-- TOGGLE FULLSCREEN (F11)
	{ key = "F11", mods = "", action = act.ToggleFullScreen },

	-- RELOAD CONFIG (LEADER + r)
	{ key = "r", mods = "LEADER", action = act.ReloadConfiguration },

	-- SCROLLBACK (PageUp/PageDown or Shift+Arrow)
	{ key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-1) },
	{ key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(1) },
	{ key = "UpArrow", mods = "SHIFT", action = act.ScrollByLine(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = act.ScrollByLine(1) },
	{ key = "Home", mods = "SHIFT", action = act.ScrollToTop },
	{ key = "End", mods = "SHIFT", action = act.ScrollToBottom },

	-- QUICK SELECT MODE (LEADER + s - copy text nhanh)
	{ key = "s", mods = "LEADER", action = act.QuickSelect },

	-- WORKSPACE SWITCHER (LEADER + w)
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "WORKSPACES" }) },

	-- NEW TAB (LEADER + c)
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },

	-- CLOSE TAB (LEADER + d)
	{ key = "d", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },

	-- TAB NAVIGATION (LEADER + number or LEADER + n/p)
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
	{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
	{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },

	-- SPAWN NEW WINDOW (LEADER + N)
	{ key = "N", mods = "LEADER|SHIFT", action = act.SpawnWindow },

	-- LAUNCH MENU (LEADER + m - chọn shell)
	{ key = "m", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "LAUNCH_MENU_ITEMS" }) },

  {
    key = 'n',
    mods = 'ALT', -- Nhấn Alt + N để mở NixOS
    action = act.SpawnCommandInNewTab {
      domain = { DomainName = 'WSL:Ubuntu' },
    },
  },
}

-- ---------------------------------------------------------
-- 4. Scrollback & Mouse Configuration
-- ---------------------------------------------------------
-- Số dòng scrollback buffer
config.scrollback_lines = 10000

-- Cho phép chọn text bằng chuột
config.enable_scroll_bar = true

-- Mouse bindings
config.mouse_bindings = {
	-- Chọn và copy text bằng chuột trái
	{
		event = { Down = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.SelectTextAtMouseCursor("Cell"),
	},
	{
		event = { Drag = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.ExtendSelectionToMouseCursor("Cell"),
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.CompleteSelection("Clipboard"),
	},
	-- Double-click để chọn word
	{
		event = { Down = { streak = 2, button = "Left" } },
		mods = "NONE",
		action = act.SelectTextAtMouseCursor("Word"),
	},
	-- Triple-click để chọn dòng
	{
		event = { Down = { streak = 3, button = "Left" } },
		mods = "NONE",
		action = act.SelectTextAtMouseCursor("Line"),
	},
	-- Chuột phải để paste
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = act.PasteFrom("Clipboard"),
	},
	-- Scroll wheel để scroll
	{
		event = { Down = { streak = 1, button = { WheelUp = 1 } } },
		mods = "NONE",
		action = act.ScrollByCurrentEventWheelDelta,
	},
	{
		event = { Down = { streak = 1, button = { WheelDown = 1 } } },
		mods = "NONE",
		action = act.ScrollByCurrentEventWheelDelta,
	},
}

-- ---------------------------------------------------------
-- 5. Tab Bar & Status Bar
-- ---------------------------------------------------------
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = true

-- Status bar hiển thị thông tin
wezterm.on("update-status", function(window, pane)
	-- Lấy thông tin workspace hiện tại
	local workspace = window:active_workspace()

	-- Lấy thông tin battery (nếu có)
	local battery = ""
	for _, b in ipairs(wezterm.battery_info()) do
		local charge = b.state_of_charge * 100
		local icon = "🔋"
		if b.state == "Charging" then
			icon = "⚡"
		elseif charge < 20 then
			icon = "🪫"
		end
		battery = string.format("%s %.0f%%", icon, charge)
	end

	-- Lấy thờigian hiện tại
	local time = wezterm.strftime("%H:%M:%S")

	-- Lấy tên domain (shell hiện tại)
	local domain = pane:get_domain_name() or ""

	-- Format status line
	local left_status = string.format("  [%s]  ", workspace)
	local right_status = string.format("  %s  |  %s  |  %s  ", domain, battery, time)

	window:set_left_status(left_status)
	window:set_right_status(right_status)
end)

-- Format tab title hiển thị tên process
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local pane = tab.active_pane
	local title = pane.title
	local index = tab.tab_index + 1

	-- Nếu có nhiều pane trong tab, hiển thị số lượng
	if #panes > 1 then
		title = string.format("%s (%d)", title, #panes)
	end

	-- Giới hạn độ dài
	if #title > 20 then
		title = string.sub(title, 1, 17) .. "..."
	end

	-- Màu sắc cho tab active/inactive
	if tab.is_active then
		return {
			{ Text = string.format(" %d: %s ", index, title) },
		}
	else
		return {
			{ Text = string.format(" %d: %s ", index, title) },
		}
	end
end)

-- ---------------------------------------------------------
-- 6. Workspace Configuration
-- ---------------------------------------------------------
-- Tự động tạo workspace mặc định khi khởi động
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:set_workspace("default")
end)

return config
