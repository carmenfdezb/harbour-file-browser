/*
 * This file is part of File Browser.
 *
 * SPDX-FileCopyrightText: 2019-2020 Mirian Margiani
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * File Browser is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * File Browser is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    property alias text: label.text
    property alias placeholderText: waiterLabel.text
    height: label.visible ? label.height : waiterLabel.height

    y: Theme.paddingSmall
    anchors {
        left: parent.horizontalCenter
        right: parent.right
        leftMargin: Theme.paddingSmall
        rightMargin: Theme.horizontalPageMargin
    }

    Label {
        id: label
        visible: !spinner.visible
        horizontalAlignment: Text.AlignLeft
        color: Theme.highlightColor
        font.pixelSize: Theme.fontSizeSmall
        wrapMode: Text.Wrap
    }

    BusyIndicator {
        id: spinner
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        visible: parent.text === ""
        size: BusyIndicatorSize.ExtraSmall
        running: true
    }

    Label {
        id: waiterLabel
        visible: spinner.visible
        anchors.left: spinner.right
        anchors.leftMargin: Theme.paddingSmall
        horizontalAlignment: Text.AlignLeft
        color: Theme.highlightColor
        font.pixelSize: Theme.fontSizeSmall
        wrapMode: Text.Wrap
    }
}
