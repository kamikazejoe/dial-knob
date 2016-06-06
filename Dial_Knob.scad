/* 
 * Project Name: Dial Knob Generator
 * Author: Kamikaze Joe
 * 
 * Description:
 * 
 * Generate a model for adjustment knobs on POTS, switches, etc.
 * 
 * Who needs to spend multiple dollars at a hardware store just for a 
 * replacement knob for a broken appliance? 
 * 
 * With a $1000 3D printer, and an hour or so of fabrication,
 * you never have to be a slave to the consumer economy again!
 */



// *** VARIABLES ***

knob_diameter = 25;	// Overall diameter of the knob.
					// Slightly larger due to beveling at the bottom.
					
knob_height = 10;	// Hieght of the beveled base of the knob.
					// Pointer grip is twice this height.
					
knob_edge = .85;	// Percentage adjusts how steep the bevel is.

stem_diameter = 7;
notches = 1;		// Number of notches on the shaft to hold the knob.

notch_depth = .5;	// How far in does the key-notch extend.
notch_angle = 0;	// Degree the notch is offset from pointer.

add_grip = true;	// Set to 'false' to remove the pointer grip.
//add_grip = false;

knob_label = "LABEL";

standard_fn = 60;



// *** MODULES AND FUNCTIONS *** //

module knob_base() {

	minkowski() {
		cylinder(knob_height, 
				 d1=knob_diameter, 
				 d2=knob_diameter * knob_edge);
		
		sphere( d=knob_diameter - ( knob_diameter * knob_edge ));
	}
	
}



module knob_grip() {
	
	minkowski() {
		
		hull() {
			translate([knob_diameter / 2, 0, 0])
				cylinder( h=knob_height * 2, d=knob_diameter / 4);
				
			translate([0 - (knob_diameter / 4), 0, 0])
				cylinder( h=knob_height * 2, d=knob_diameter / 4);
			}
			
		sphere( d=(knob_diameter / 2) - ( (knob_diameter / 2) * knob_edge ));
		
		}
	
}


module text_label() {
	
	text = knob_label;
	font = "Liberation Sans";
	size = knob_diameter / 6;
	height = knob_height;
	
	linear_extrude(height = height) {
		text(text = text, 
		     font = font, 
		     size = size, 
		     valign = "center", 
		     halign = "center");
	}
}


module dial_knob(notch=0, angle=0) {
	
	
		
	difference() {
		
		// Build base and grip
		union() {
			knob_base();
			
			if (add_grip==true) {
				
				knob_grip();
			}
		}
		
		// If pointer grip is enabled, then hole is twice as deep.
		if (add_grip==true) {
			
			translate([ 0, 0, 0 - (knob_height / 2) ])
				cylinder(h=knob_height * 2, d=stem_diameter);
			
		}
		else {
			
			translate([ 0, 0, 0 - (knob_height / 2) ])
				cylinder(h=knob_height, d=stem_diameter);
			
		}
		
		// Label text.
		translate([ 0, 
					0, 
					(knob_height * 2)])
			rotate([0,0,0])
				text_label();
		
	}
	
	// Add key-notches
	if (notch>0) {
		
		for (i = [1:notch]) {
			
		    rotate([0,0, ((360 / notch) * i)])
				translate([ 0 - (stem_diameter / 2),
						    0 - (stem_diameter / 2),
								0 - ((knob_diameter 
								- ( knob_diameter * 
								knob_edge )) / 2) ])
					cube([notch_depth, stem_diameter, knob_height]);
		}
	}	
	
}



module build_it() {
	
	dial_knob(notches, notch_angle);
	
}

// *** MAIN *** 
$fn=standard_fn;
build_it();
