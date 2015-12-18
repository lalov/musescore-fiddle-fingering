//=============================================================================
//  MuseScore
//  Music Composition & Notation
//
//  Fiddle Fingering
//  Baised on Note Names Plugin
//
//  Copyright (C) 2012 Werner Schweer
//  Copyright (C) 2013, 2014 Joachim Schmitz
//  Copyright (C) 2014 Jörn Eichler
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2
//  as published by the Free Software Foundation and appearing in
//  the file LICENCE.GPL
//=============================================================================

import QtQuick 2.0
import MuseScore 1.0

MuseScore {
   version: "2.0"
   description: qsTr("This plugin adds Fiddle Fingering as staff text")
   menuPath: "Plugins.Notes." + qsTr("Fiddle Fingering") // this does not work, why?

   function nameChord (notes, text) {
      for (var i = 0; i < notes.length; i++) {
         var sep = ","; // change to "\n" if you want them vertically
         if ( i > 0 )
            text.text = sep;

         if (typeof notes[i].pitch === "undefined") // just in case
            return
         switch (notes[i].pitch) {
            case 55: text.text = qsTr("0"); break;
            case 56: text.text = qsTr("1L"); break;
            case 57: text.text = qsTr("1"); break;
            case 58: text.text = qsTr("2L"); break;
            case 59: text.text = qsTr("2"); break;
            case 60: text.text = qsTr("3"); break;
            case 61: text.text = qsTr("3H"); break;
            case 62: text.text = qsTr("0") ; break;
            case 63: text.text = qsTr("1L") ; break;

            case 64: text.text = qsTr("1") ; break;
            case 65: text.text = qsTr("2L") ; break;
            case 66: text.text = qsTr("2") ; break;
            case 67: text.text = qsTr("3") ; break;
            case 68: text.text = qsTr("3H") ; break;
            case 69: text.text = qsTr("0")  ; break;
            case 70: text.text = qsTr("1L")  ; break;
            case 71: text.text = qsTr("1")  ; break;
            case 72: text.text = qsTr("2L")  ; break;
            case 73: text.text = qsTr("2")  ; break;
            case 74: text.text = qsTr("3")  ; break;
            case 75: text.text = qsTr("3H")  ; break;

            case 76: text.text = qsTr("0") ; break;
            case 77: text.text = qsTr("1") ; break;
            case 78: text.text = qsTr("2L") ; break;
            case 79: text.text = qsTr("2") ; break;
            case 80: text.text = qsTr("3L") ; break;
            case 81: text.text = qsTr("3") ; break;
            case 82: text.text = qsTr("3H") ; break;
            default: text.text = qsTr("?")  ; break;
         } // end switch pitch

         // octave, middle C being C4
         //text.text += (Math.floor(notes[i].pitch / 12) - 1)
         // or
         //text.text += (Math.floor(notes[i].ppitch / 12) - 1)

      } // end for note
   }

   onRun: {
      if (typeof curScore === 'undefined')
        Qt.quit();
      var cursor = curScore.newCursor();
      var startStaff;
      var endStaff;
      var endTick;
      var fullScore = false;
      cursor.rewind(1);
      if (!cursor.segment) { // no selection
        fullScore = true;
        startStaff = 0; // start with 1st staff
        endStaff  = curScore.nstaves - 1; // and end with last
      } else {
        startStaff = cursor.staffIdx;
        cursor.rewind(2);
        if (cursor.tick == 0) {
          // this happens when the selection includes
          // the last measure of the score.
          // rewind(2) goes behind the last segment (where
          // there's none) and sets tick=0
          endTick = curScore.lastSegment.tick + 1;
        } else {
          endTick = cursor.tick;
        }
        endStaff   = cursor.staffIdx;
      }
      console.log(startStaff + " - " + endStaff + " - " + endTick)

      for (var staff = startStaff; staff <= endStaff; staff++) {
        for (var voice = 0; voice < 4; voice++) {
          cursor.rewind(1); // beginning of selection
          cursor.voice    = voice;
          cursor.staffIdx = staff;

          if (fullScore)  // no selection
            cursor.rewind(0); // beginning of score

          while (cursor.segment && (fullScore || cursor.tick < endTick)) {
            if (cursor.element && cursor.element.type == Element.CHORD) {
              var text = newElement(Element.STAFF_TEXT);

              var graceChords = cursor.element.graceNotes;
              for (var i = 0; i < graceChords.length; i++) {
                // iterate through all grace chords
                var notes = graceChords[i].notes;
                nameChord(notes, text);
                // there seems to be no way of knowing the exact horizontal pos.
                // of a grace note, so we have to guess:
                text.pos.x = -2.5 * (graceChords.length - i);
                switch (voice) {
                  case 0: text.pos.y =  1; break;
                  case 1: text.pos.y = 10; break;
                  case 2: text.pos.y = -1; break;
                  case 3: text.pos.y = 12; break;
                }

                cursor.add(text);
                // new text for next element
                text  = newElement(Element.STAFF_TEXT);
              }

              var notes = cursor.element.notes;
              nameChord(notes, text);

              switch (voice) {
                case 0: text.pos.y =  1; break;
                case 1: text.pos.y = 10; break;
                case 2: text.pos.y = -1; break;
                case 3: text.pos.y = 12; break;
              }
              if ((voice == 0) && (notes[0].pitch > 83))
                text.pos.x = 1;
              cursor.add(text);
            } // end if CHORD
            cursor.next();
          } // end while segment
        } // end for voice
      } // end for staff
      Qt.quit();
   } // end onRun
}

