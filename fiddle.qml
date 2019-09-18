//=============================================================================
//  Fiddle fingering plugin
//
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
//=============================================================================
import QtQuick 2.0
import MuseScore 1.0

MuseScore {
    menuPath: "Plugins.Fiddle fingers"

        onRun: {

        var fingerings = [
            "0\nG", "1L\nG", "1\nG", "2L\nG", "2\nG", "3\nG", "3H\nG",
            "0\nD", "1L\nD", "1\nD", "2L\nD", "2\nD", "3\nD", "3H\nD",
            "0\nA", "1L\nA", "1\nA", "2L\nA", "2\nA", "3\nA", "3H\nA",
            "0\nE", "1L\nE", "1\nE", "2L\nE", "2\nE", "3\nE", "3H\nE", "4\nE",
            "1", "1", "2", "2", "3", "3",
        ];


        if (typeof curScore === 'undefined') {
            console.log("score undefined");
            return;
        }
        var cursor = curScore.newCursor();
        for (var track = 0; track < curScore.ntracks; ++track) {

            cursor.track = track;
            cursor.rewind(0); // set cursor to first chord/rest

            while (cursor.segment) {

                if (cursor.element && cursor.element.type == Element.CHORD) {

                    var pitch = cursor.element.notes[0].pitch;
                    var index = pitch - 55;

                    if (index >= 0 && index < fingerings.length) {

                        var text = newElement(Element.TEXT, curScore);
                        text.text = qsTr("<font size=\"9\"/><font face=\"Times\"/>") + fingerings[index];

                        var offset = 8;
                        //put the text a bit further below
                        if (index < 3) {
                            offset = 9;
                        }
                        if (index > 6) {
                            offset = 6;
                        }
                        text.pos.y += offset;

                        cursor.add(text);
                    }

                }
                cursor.next();
            }
        }

        Qt.quit()

    }
}
