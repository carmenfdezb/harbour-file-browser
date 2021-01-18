/*
 * This file is part of File Browser.
 *
 * SPDX-FileCopyrightText: 2013-2014 Kari Pihkala
 * SPDX-FileCopyrightText: 2016 Malte Veerman
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

#include "globals.h"
#include <QLocale>
#include <QProcess>

QString suffixToIconName(QString suffix)
{
    // only formats that are understood by File Browser or Sailfish get a special icon
    if (suffix == "txt") return "file-txt";
    if (suffix == "rpm") return "file-rpm";
    if (suffix == "apk") return "file-apk";
    if (   suffix == "png"
        || suffix == "jpeg"
        || suffix == "jpg"
        || suffix == "gif") return "file-image";
    if (   suffix == "wav"
        || suffix == "mp3"
        || suffix == "flac"
        || suffix == "aac"
        || suffix == "ogg"
        || suffix == "opus"
        || suffix == "m4a") return "file-audio";
    if (   suffix == "mp4"
        || suffix == "mkv"
        || suffix == "ogv"
        || suffix == "avi"
        || suffix == "m4v") return "file-video";
    if (suffix == "pdf") return "file-pdf";
    if (   suffix == "zip"
        || suffix == "tar"
        || suffix == "gz"
        || suffix == "bz2"
        || suffix == "xz") return "file-compressed";

    return "file";
}

QString permissionsToString(QFile::Permissions permissions)
{
    char str[] = "---------";
    if (permissions & 0x4000) str[0] = 'r';
    if (permissions & 0x2000) str[1] = 'w';
    if (permissions & 0x1000) str[2] = 'x';
    if (permissions & 0x0040) str[3] = 'r';
    if (permissions & 0x0020) str[4] = 'w';
    if (permissions & 0x0010) str[5] = 'x';
    if (permissions & 0x0004) str[6] = 'r';
    if (permissions & 0x0002) str[7] = 'w';
    if (permissions & 0x0001) str[8] = 'x';
    return QString::fromLatin1(str);
}

QString filesizeToString(qint64 filesize)
{
    // convert to kB, MB, GB: use 1000 instead of 1024 as divisor because it seems to be
    // the usual way to display file size (like on Ubuntu)
    QLocale locale;
    if (filesize < 1000LL)
        return QObject::tr("%1 bytes").arg(locale.toString(filesize));

    if (filesize < 1000000LL)
        return QObject::tr("%1 kB").arg(locale.toString((double)filesize/1000.0, 'f', 2));

    if (filesize < 1000000000LL)
        return QObject::tr("%1 MB").arg(locale.toString((double)filesize/1000000.0, 'f', 2));

    return QObject::tr("%1 GB").arg(locale.toString((double)filesize/1000000000.0, 'f', 2));
}

QString datetimeToString(QDateTime datetime, bool longFormat)
{
    // return time for today or date+time for older
    // include more information if 'longFormat' is true
    if (datetime.date() == QDate::currentDate()) {
        return datetime.toString(QObject::tr("hh:mm:ss"));
    } else {
        if (longFormat) {
            return datetime.toString(QObject::tr("dd MMM yyyy, hh:mm:ss t"));
        } else {
            return datetime.toString(QObject::tr("dd.MM.yy, hh:mm"));
        }
    }
}

QString infoToIconName(const StatFileInfo &info)
{
    if (info.isSymLink() && info.isDirAtEnd()) return "folder-link";
    if (info.isDir()) return "folder";
    if (info.isSymLink()) return "link";
    if (info.isFileAtEnd()) {
        QString suffix = info.suffix().toLower();
        return suffixToIconName(suffix);
    }
    return "file";
}

QString execute(QString command, QStringList arguments, bool mergeErrorStream)
{
    QProcess process;
    process.setReadChannel(QProcess::StandardOutput);
    if (mergeErrorStream)
        process.setProcessChannelMode(QProcess::MergedChannels);
    process.start(command, arguments);
    if (!process.waitForStarted())
        return QString();
    if (!process.waitForFinished())
        return QString();

    QByteArray result = process.readAll();
    return QString::fromUtf8(result);
}
