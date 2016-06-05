/* 
 * Project Name: Dial Knob Generator
 * Author: Kamikaze Joe
 * 
 * Description:
 * 
 * Generate a model for adjustment knobs on POTS, switches, etc.
 */



// *** VARIABLES ***
standard_fn = 60;



knob_diameter = 25;
knob_height = 10;
knob_edge = .85;

stem_diameter = 7;
notches = 2;

notch_depth = .5;
notch_angle = 0;




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



module dial_knob(notch=0, angle=0) {
	
	
	difference() {
		
		union() {
			knob_base();
			knob_grip();
		}
		
		translate([ 0, 0, 0 - (knob_height / 2) ])
			cylinder(h=knob_height * 2, d=stem_diameter);
		
	}
	
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
