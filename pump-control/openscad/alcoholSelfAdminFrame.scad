// frame for home cage alcohol self-administration. 
// Hao Chen
// UTHSC
 
$fn=100;
max_w=210;
max_h=138;
max_d=90;

pw=40;// spout holder width x 
ph=45;// spout holder length y
pg=60;// spout holder height z
r=10; // forgot what this is for??
fv=0.1; // for better visualization

module corner(ln=20, wd=30 ){ // a negative part for making a round corner 
	difference (){
		cube([wd,wd,ln]);
		translate([0,0,0])
		cylinder(r=wd, h=ln);
	}
}

module outbox(){ // outside box for the frame
	corner_wd=10;
	corner_ln=max_d;
	difference(){
		cube([max_w-fv,max_d-fv,max_h-fv],center=true);
		union(){
			translate([max_w/2-corner_wd, max_d/2, -max_h/2+corner_wd]) rotate([90,90,0]) corner(ln=corner_ln, wd=corner_wd);
			translate([-max_w/2+corner_wd, max_d/2, -max_h/2+corner_wd]) rotate([90,180,0]) corner(ln=corner_ln, wd=corner_wd);
		}
	}
}

module innerbox(){ // inside box for the frame
	inn_w=max_w-10;
	inn_h=max_h-20;
	inn_d=max_d;
	corner_wd=20;
	corner_ln=max_d;
	difference(){
		cube([inn_w-fv,inn_d-fv,inn_h-fv],center=true);
		union(){
			translate([inn_w/2-corner_wd, inn_d/2, -inn_h/2+corner_wd]) rotate([90,90,0]) corner(ln=corner_ln, wd=corner_wd);
			translate([-inn_w/2+corner_wd, inn_d/2, -inn_h/2+corner_wd]) rotate([90,180,0]) corner(ln=corner_ln, wd=corner_wd);
		}
	}
}

module frame(){
	difference () {
		outbox();
		translate([0,4,-max_h/2]) cube([max_w-20,max_d-7,max_h/2], center=true);
		translate([0,7,-8]) innerbox();
	}
}

module mounting_m25(innR=1.9){ // screw 
	difference(){
		cylinder(r=3.8, h=10);
		cylinder(r=innR, h=10);
	}
}

module mounting_pi(){
	mounting_m25();
	translate([58,0,0]) mounting_m25();
	translate([0,49,0]) mounting_m25();
	translate([58,49,0]) mounting_m25();
} 

module mounting_touch(){
	mounting_m25(innR=1.2);
	translate([28,0,0]) mounting_m25(innR=1.5);
} 

module mounting_RTC(){
	mounting_m25();
	translate([22.5,0,0]) mounting_m25();
}

module mounting_screws(){
	translate([-93,-30, max_h/2-2]) mounting_pi();
	translate([8,-16, max_h/2-2]) mounting_touch();
	translate([20,33, max_h/2-2]) mounting_RTC();
	translate([70,-20, max_h/2+2]) rotate([0,0,0])  step_motor_control();
}



module top_groove(){ // for the top cover
	xw=max_w-5;
	xd=max_d-5;
	difference(){
		union (){
			translate([xw/2-.5, xd/2-.5,-5]) corner2();
			translate([-xw/2+0.5, -xd/2+0.5,-5]) corner2() ;
			translate([-xw/2+0.5, xd/2-0.5,-5]) corner2() ;
			translate([xw/2-0.5, -xd/2+0.5,-5]) corner2() ;
			cube([xw, xd, 10], center=true);
		}
		translate([0,0, -5.6])round_corner_box(r0=5, wd=max_w-24, lg=max_d-24,ht=11);
	}
}

module corner2(){
	//rotate([0,0,45]) scale([0.7,1,1]) cylinder(r=1.5	,h=10);
	 cylinder(r=1.5	,h=10);
}


module top_cover(){
   union(){
	   rotate([180,0,180]) translate([104,13.5,-38]) rfid_antenna_housing();//box on side to hold antennae
		difference(){  
			translate([0,40,0]) rotate([90,0,270]) slant_box();//outside
				difference() {
				translate([0,38,-2]) rotate([90,0,270]) scale([0.95, 1, 0.98]) slant_box(); //inside    
				translate([-70,42,23]) rotate([90,0,0]) drill(); // for dev board
		}
		translate([-130,0,4]) rotate([0,90,0]) cylinder(r=1.9, h=240); //screw hole for the top cover on the side;
		translate([max_w/2-10,8,15]) rotate([90,0,90]) round_corner_box(r0=1, wd=14.5,lg=2.5, ht=20); // sd card slot
		translate([101-14,max_d/2,19]) rotate([90,0,0]) round_corner_box(r0=1, wd=12,lg=11, ht=21); // power cord 
		translate([0,max_d/2,6]) rotate([90,0,0]) round_corner_box(r0=1, wd=25,lg=10, ht=14); // new, longer wire hole
		translate([-max_w/2+5,14,-1]) round_corner_box(r0=0.5, wd=5,lg=1, ht=19); // side wire hole for antennae
		translate([-70,42,23]) rotate([90,0,0]) alltheholes();
		}
	}
}
    
    

module slant_box()
{
linear_extrude(height=max_w-8,center=true) polygon(points=[[0,0],[0,58],[55,58],[max_d-9,29],[max_d-9,0]]);
}

//translate([0,40,0]) rotate([90,0,270]) difference()
//{slant_box();
//translate([2,-1,0]) scale([0.95,1,0.98]) slant_box();}
    
    



module switch() //holes for the switch buttons
{
    translate([11,23,0]) cube([8,7,7]);
    translate([29,23,0]) cube([8,7,7]);
}
module led() // hole for the LED lights
{
    translate([19,0,0]) cube([10,5,7]);
}
module column(){cylinder(2.5,4,4);} //the inside column
module drill() //all four inside columns
{
    translate([4,4,2.23]) column();
    translate([44,4,2.23]) column();
    translate([4,26,2.23]) column();
    translate([44,26,2.23]) column();
}
module hollow() {cylinder(9.1,1.5,1.5);} //the screw holes
module drillholes() //all four screw holes for switches board
{
translate([4,4,0]) hollow();
    translate([44,4,0]) hollow();
   translate([4,26,0]) hollow();
   translate([44,26,0]) hollow();
}
module alltheholes() //holes for the screws, LED, and buttons
{
 union()
{
    switch();
    led();
    drillholes();
}
}





//dev_board is now obsolete
module dev_board(){
//	difference(){
//		cube([72,47,1],center=true);
		translate([72/2-3, 47/2-3,0])cylinder(r=2, h=10);
		translate([-72/2+3, -47/2+3,0])cylinder(r=2, h=10);
		translate([-72/2+3, 47/2-3,0])cylinder(r=2, h=10);
		translate([72/2-3, -47/2+3,0])cylinder(r=2, h=10);
		cube([40,20,30],center=true);
//	}
}



module round_corner_box( r0=10, wd=20, ht=30, lg=40) { // generic 
	hull(){
	translate([wd/2,lg/2,0])
	cylinder(r=r0, h=ht);
	translate([wd/2,-lg/2,0]) cylinder(r=r0, h=ht);
	translate([-wd/2,-lg/2,0]) cylinder(r=r0,h=ht);
	translate([-wd/2,lg/2,0]) cylinder(r=r0, h=ht);
	}
}

module step_motor_control(){
	difference(){
		cube([22+20, 17+4, 5],center=true);
		union(){
			translate([15,0,-3]) cylinder(r=1.5, h=8);
			translate([-15,0,-3]) cylinder(r=1.5, h=8);
			cube([22, 17, 9], center=true);
		}
	}

} 


module step_motor_fastener (){
	difference(){
		cube([13, 9, 3],center=true);
		translate([4,0,-3]) cylinder(r=1.7, h=8);
	}
}


module motion_sensor (){
	translate([-14,0,5]) cylinder(r=1, h=7);
	translate([14,0,5]) cylinder(r=1,h=7);
	cylinder(r=4.5, h=20);
	cylinder(r1=20,r2=4.5, h=6);
}

module spout_holder_inner (sh_x=70, sh_y=40){
			translate([-sh_x,-sh_y+10,15]) rotate([90,0,0]) round_corner_box(r0=3,wd=pw-6, ht=ph+5,lg=pg-16); // spout holder inside
}

module spout_holder(sh_x=70, sh_y=40, sh_z=20){
	//sh_x: spout holder x
	//sh_y: spout holder y
	//sh_z: spout holder z
	difference(){
		union(){
			translate([-sh_x,-sh_y,sh_z]) rotate([90,0,0]) round_corner_box(r0=3,wd=pw, ht=ph,lg=pg); //spout holder outside
			translate([-sh_x,-sh_y,sh_z-pg/2-6]) rotate([90,0,0]) round_corner_box(r0=2,ht=5,wd=13,lg=8); //positive for attachment screw, bottom 
			translate([-sh_x,-sh_y,sh_z+pg/2+6]) rotate([90,0,0]) round_corner_box(r0=2,ht=5,wd=13,lg=8); //positive for attachment screw, top
		}
		union(){
			translate([-sh_x,-sh_y+10,sh_z-5]) rotate([90,0,0]) round_corner_box(r0=3,wd=pw-6, ht=ph+5,lg=pg-16); // spout holder inside
			translate([-sh_x-30,-sh_y-10,sh_z]) rotate([0,90,0]) cylinder(r=2.5, h=55); //holes for alignment of the spout tip 

			translate([-sh_x,-sh_y-10,sh_z+18]) rotate([25,0,0])
				union(){
				cylinder(r=2.75, h=18); //hole for cue LED 
				cylinder(r1=5, r2=2.75, h=5); //hole for cue LED 
				}

//			translate([-sh_x,-sh_y-10,sh_z+18]) rotate([25,0,0]) 

			translate([-sh_x,-sh_y,sh_z]) rotate([90,0,0]) cylinder(r=12, h=55); //holes for obverving the rat 
			translate([-sh_x,-sh_y-10,sh_z]) rotate([35,0,0]) cylinder(r=4.6, h=55); // location of the spout 
			translate([-sh_x,-sh_y-42, sh_z+31]) rotate([-55, 0,0]) cube([8.4, 18, 4.1], center=true);// hex screw for spout 
			translate([-sh_x,-sh_y-60,sh_z+14]) rotate([-55,0,0]) cylinder(r=1.9, h=50); //screw hole for tightening the spout 
			translate([-sh_x,-sh_y-10,sh_z-pg/2-7]) rotate([-90,0,0]) cylinder(r=1.9, h=25); //negative for attachment screw, top
			translate([-sh_x,-sh_y-10,sh_z+pg/2+7]) rotate([-90,0,0]) cylinder(r=1.9, h=25); //negative for attachment screw, top
		}
	}
}

module rfid_antenna_housing()//to hold RFID antennae
	{
    rotate([270,0,270]) difference(){
		cube([53,40,7], center=true); // rfid antenna outside;
	translate([0,-6,-2]) cube([47,46,6], center=true); // rfid antenna groove;
	cube([36,25,15], center=true); //rfid antenna loop inside  
	}
}

module the_thing (){
 difference(){
    union(){
		difference(){
			//	pw=40;// spout holder width x 
			//	ph=40;// spout holder length y
			//	pg=50;// spout holder height z
			frame();
			union(){
				translate([0,0,max_h/2-4]) top_groove();
				rotate([90,0,0]) translate([0,0,34]) motion_sensor();
				translate([-max_w/2,0,65]) rotate([0,90,0]) cylinder(r=1.9, h=10); //screw hole for the top cover on the side;
				translate([max_w/2-10,0,65]) rotate([0,90,0]) cylinder(r=1.9, h=10); //screw hole for the top cover on the side; 
				spout_holder_inner(sh_x=-70);
				spout_holder_inner(sh_x=70);
				spout_holder(sh_x=70, sh_y=44.7, sh_z=20);
				spout_holder(sh_x=-70, sh_y=44.7, sh_z=20);
				//mounting holes for the spout holders
				translate([-70,-45,20-pg/2-7]) rotate([-90,0,0]) cylinder(r=1.7, h=7);
				translate([70,-45,20-pg/2-7]) rotate([-90,0,0]) cylinder(r=1.7, h=7); 
				translate([-70,-45,20+pg/2+7]) rotate([-90,0,0]) cylinder(r=1.7, h=7);
				translate([70,-45,20+pg/2+7]) rotate([-90,0,0]) cylinder(r=1.7, h=7); 
			}
		}
		mounting_screws();
	}
    translate([78,30,67]) cube([11.5,3,5],center=true); // rfid board connection via the pins in groove; 
}
}

//translate([0,0,68])top_cover();

spout_holder(sh_x=70, sh_y=40, sh_z=20);
//top_groove();
//the_thing();
//step_motor_fastener();
//the_thing is printed in two halves to save time
//difference() { the_thing(); translate([0,0,65]) cube([212,120,30],center=true);} //bottom half
//translate([0,0,30]) difference(){ the_thing(); translate([0,0,-15]) cube([212,120,132],center=true);}//top half
