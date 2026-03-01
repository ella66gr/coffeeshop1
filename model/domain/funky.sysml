private import ScalarValues::*;

package Funky {

    doc /* A domain model for a funky music festival - 
           toy exercise for learning SysML v2 */

    // -- Enumerations -------------------------

    enum def MusicGenre {
        rock;
        jazz;
        funk;
        soul;
        hipHop;
        electronic;
    }

    enum def TicketType {
        generalAdmission;
        vip;
        backstagePass;
    }

    // -- Core domain definitions ---------------

    part def Performer {
        doc /* A performer at the festival */

        attribute name : String;
        attribute genre : MusicGenre;
        attribute isHeadliner : Boolean;
    }

    part def Stage {
        doc /* A stage at the festival */

        attribute name : String;
        attribute capacity : Integer;           // ScalarValue::Integer
    }

    part def Ticket {
        doc /* A ticket for the festival */

        attribute type : TicketType;
        attribute price : Real;                // ScalarValue::Real
    }

}