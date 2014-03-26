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

var fingerings = [ 
"0\rG", "1\rG", "1\rG", "2\rG", "2\rG", "3\rG", "3#\rG", 
"0\rD", "1\rD", "1\rD", "2\rD", "2\rD", "3\rD", "3#\rD", 
"0\rA", "1\rA", "1\rA", "2\rA", "2\rA", "3\rA", "3#\rA", 
"0\rE", "1\rE", "1\rE", "2\rE", "2\rE", "3\rE", "3#\rE", "4\rE", 
"1", "1", "2", "2", "3", "3",
]; 

//---------------------------------------------------------
//    init
//---------------------------------------------------------

function init()
      {
      }

//-------------------------------------------------------------------
//    run
//-------------------------------------------------------------------

function run()
      {
      if (typeof curScore === 'undefined')	
            return;
      var cursor   = new Cursor(curScore);
      cursor.goToSelectionStart();
   var startStaff = cursor.staff;
   cursor.goToSelectionEnd();
   var endStaff   = cursor.staff;
   if (cursor.eos()) { // if no selection
     startStaff = 0; // start with 1st staff
     endStaff = curScore.staves; // and end with last
   }
   
   for (var staff = startStaff; staff < endStaff; ++staff) {
   cursor.goToSelectionStart();
       cursor.staff = staff;
      cursor.voice = 0;
      cursor.rewind();  // set cursor to first chord/rest
      while (!cursor.eos()) {
            if (cursor.isChord()) {
                  
                  var pitch = cursor.chord().topNote().pitch;
                  var index = pitch - 55;
                  if(index >= 0 && index < fingerings.length){ 
                      var text  = new Text(curScore);
                      text.text = fingerings[index];
                      //text.text = pitch;
                      text.yOffset = 6;
                      //for de laveste:
                      if(index <3 ){
                        text.yOffset = 7;
                      }
                      if(index > 6) {
                        text.yOffset = 5;
                      
                      }
                      cursor.putStaffText(text);
                      }
                  }
            cursor.next();
            }
      }
	}

var mscorePlugin = {
      menu: 'Plugins.Fiddle fingers ',
      init: init,
      run:  run
      };

mscorePlugin;

