require("utils")

-- FINDER: when activated
-- - Bring all windows forward
-- - hide sidebar
-- - enlarge window if it's too small
-- - hide Finder when no window
function finderWatcher(appName, eventType, appObject)
	if not(eventType == hs.application.watcher.activated and appName == "Finder") then return end

	appObject:selectMenuItem({"Window", "Bring All to Front"})
	appObject:selectMenuItem({"View", "Hide Sidebar"})

	local finderWin = appObject:focusedWindow()
	local isInfoWindow = finderWin:title():match(" Info$")
	if isInfoWindow then return end

	local win_h = finderWin:frame().h
	local max_h = finderWin:screen():frame().h
	local max_w = finderWin:screen():frame().w
	local target_w = 0.6 * max_w
	local target_h = 0.8 * max_h
	if (win_h / max_h) < 0.7 then
		finderWin:setSize({w = target_w, h = target_h})
	end

	hs.osascript.applescript([[
		tell application "Finder"
			if (count of window) is 0
				tell application "System Events" to tell process "Finder" to set visible to false
			end if
		end tell
	]])
end
finderAppWatcher = hs.application.watcher.new(finderWatcher)
finderAppWatcher:start()

-- ZOOM: don't leave behind tab when opening URL
function zoomWatcher(appName, eventType)
	if not(eventType == hs.application.watcher.launched and appName == "zoom.us") then return end
	hs.osascript.applescript([[
		delay 2
		tell application "Brave Browser"
			set window_list to every window
			repeat with the_window in window_list
				set tab_list to every tab in the_window
				repeat with the_tab in tab_list
					set the_url to the url of the_tab
					if the_url contains ("zoom.us") then
						close the_tab
					end if
				end repeat
			end repeat
		end tell
	]])
end
zoomAppWatcher = hs.application.watcher.new(zoomWatcher)
zoomAppWatcher:start()

-- HIGHLIGHTS:
-- - Sync Dark & Light Mode
-- - Start with Highlight as Selection
function highlightsWatcher(appName, eventType)
	if not(eventType == hs.application.watcher.launching and appName == "Highlights") then return end
	hs.osascript.applescript([[
		tell application "System Events"
			tell appearance preferences to set isDark to dark mode
			if (isDark is false) then set targetView to "Default"
			if (isDark is true) then set targetView to "Night"
			delay 0.6

			tell process "Highlights"
				set frontmost to true
				click menu item targetView of menu of menu item "PDF Appearance" of menu "View" of menu bar 1
				click menu item "Highlight" of menu "Tools" of menu bar 1
				click menu item "Yellow" of menu of menu item "Color" of menu "Tools" of menu bar 1
			end tell
		end tell
	]])
end
highlightsAppWatcher = hs.application.watcher.new(highlightsWatcher)
highlightsAppWatcher:start()

-- DRAFTS: Hide Toolbar on launch
function draftsLaunchWake(appName, eventType, appObject)
	if not(appName == "Drafts") then return end

	if (eventType == hs.application.watcher.launched) then
		runDelayed(0.5, function ()
			appObject:selectMenuItem({"View", "Hide Toolbar"})
		end)
	elseif (eventType == hs.application.watcher.activated) then
		appObject:selectMenuItem({"View", "Hide Toolbar"})
	end
end
draftsWatcher3 = hs.application.watcher.new(draftsLaunchWake)
draftsWatcher3:start()

-- BRAVE: Hide when no window on activation
function braveActivation(appName, eventType)
	if not(appName == "Brave Browser" and eventType == hs.application.watcher.activated) then return end

	hs.osascript.applescript([[
		tell application "Brave Browser"
			if (count of window) is 0
				tell application "System Events" to tell process "Brave Browser" to set visible to false
			end if
		end tell
	]])
end
braveWatcher = hs.application.watcher.new(braveActivation)
braveWatcher:start()