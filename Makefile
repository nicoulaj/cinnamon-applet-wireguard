# cinnamon-applet-wireguard - https://github.com/nicoulaj/cinnamon-applet-wireguard
# copyright (c) 2019 cinnamon-applet-wireguard contributors
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# ----------------------------------------------------------------------

SHELL := /bin/bash
DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
UUID := wireguard@nicoulaj.net
PREFIX := ~/.local

install:
	@rm -rf $(PREFIX)/share/cinnamon/applets/$(UUID)
	@cp -ar $(DIR)/$(UUID) $(PREFIX)/share/cinnamon/applets/$(UUID)
	@cinnamon-xlet-makepot -i $(UUID)
	@printf '%(%H:%M:%S)T'; echo ': installed extension to $(PREFIX)/share/cinnamon/applets'

reload:
	@dbus-send --session --dest=org.Cinnamon.LookingGlass --type=method_call /org/Cinnamon/LookingGlass org.Cinnamon.LookingGlass.ReloadExtension string:'$(UUID)' string:'APPLET'

watch:
	@inotifywait -qrme modify,close_write,moved_to,create,delete --exclude '.*___jb.*' $(UUID) | xargs -I {} $(MAKE) install reload

logs:
	@tail -1000f ~/.xsession-errors | grep --line-buffered -v '^Cinnamon warning'

pot:
	@cinnamon-xlet-makepot $(UUID)
