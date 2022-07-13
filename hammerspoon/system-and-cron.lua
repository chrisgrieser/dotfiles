require("menubar")
require("utils")
require("window-management")
--------------------------------------------------------------------------------
-- SYNC
repoSyncFrequencyMin = 15
gitDotfileScript = os.getenv("HOME").."/dotfiles/git-dotfile-backup.sh"
gitVaultScript = os.getenv("HOME").."/Library/Mobile Documents/iCloud~md~obsidian/Documents/Main Vault/Meta/git vault backup.sh"
pullScript = os.getenv("HOME").."/dotfiles/pull-sync-repos.sh"

function gitDotfileSync()
	hs.task.new(gitDotfileScript, function (exitCode, _, stdErr)
		if exitCode == 0 then
			notify("✅ dotfiles")
			log ("dotfiles sync ("..deviceName()..") ✅", "$HOME/dotfiles/Cron Jobs/sync.log")
		else
			notify("⚠️️ dotfiles "..stdErr)
			log ("dotfiles sync ("..deviceName()..") ⚠️: "..stdErr, "$HOME/dotfiles/Cron Jobs/sync.log")
		end
		updateDotfileSyncStatusMenuBar()
	end):start()
end

function gitVaultBackup()
	hs.task.new(gitVaultScript, function (exitCode, _, stdErr)
		if exitCode == 0 then
			notify("🟪 vault backup")
			log ("vault sync ("..deviceName()..") ✅", "$HOME/dotfiles/Cron Jobs/sync.log")
		else
			notify("⚠️️ vault "..stdErr)
			log ("⚠️ vault sync ("..deviceName()..") ⚠️: "..stdErr, "$HOME/dotfiles/Cron Jobs/sync.log")
		end
	end):start()
end

function pullSync()
	hs.task.new(pullScript, function (exitCode, _, stdErr)
		if exitCode == 0 then
			notify("✅ pull sync")
			log ("pull sync ("..deviceName()..") ✅", "$HOME/dotfiles/Cron Jobs/sync.log")
		else
			notify("⚠️️ pull "..stdErr)
			log ("⚠️ pull sync ("..deviceName()..") ⚠️: "..stdErr, "$HOME/dotfiles/Cron Jobs/sync.log")
		end
	end):start()
end

--------------------------------------------------------------------------------
-- TRIGGERS
hotkey(hyper, "end", pullSync)

repoSyncTimer = hs.timer.doEvery(repoSyncFrequencyMin * 60, function ()
	gitDotfileSync()
	if isIMacAtHome() then gitVaultBackup() end
end)
repoSyncTimer:start()

function systemShutDown (eventType)
	if not(eventType == hs.caffeinate.watcher.systemWillSleep or eventType == hs.caffeinate.watcher.systemWillPowerOff or eventType == hs.caffeinate.watcher.screensDidSleep or eventType == hs.caffeinate.watcher.screensDidLock) then return end
	gitDotfileSync()
end
shutDownWatcher = hs.caffeinate.watcher.new(systemShutDown)
shutDownWatcher:start()


function systemWake (eventType)
	if not(eventType == hs.caffeinate.watcher.systemDidWake) then return end

	reloadAllMenubarItems()
	hs.shortcuts.run("Send Reminders due today to Drafts")
	if appIsRunning("Obsidian") and appIsRunning("Discord") then
		hs.urlevent.openURL("obsidian://advanced-uri?vault=Main%20Vault&commandid=obsidian-discordrpc%253Areconnect-discord")
	end

	if isIMacAtHome() then homeModeLayout()
	elseif isAtOffice() then officeModeLayout() end

	-- set darkmode if waking between 6:00 and 19:00
	local timeHours = hs.timer.localTime() / 60 / 60
	if timeHours < 19 and timeHours > 6 then
		setDarkmode(false)
	end

	pullSync:start()
end
wakeWatcher = hs.caffeinate.watcher.new(systemWake)
wakeWatcher:start()

-- daily morning run (redundant to Cron job)
if isIMacAtHome() then
	dailyMorningTimer = hs.timer.doAt("06:10", "01d", function()
		setDarkmode(false)
	end, false)
	dailyMorningTimer:start()
end
