include <../OpenSCADdesigns/MakeInclude.scad>
use <../OpenSCADdesigns/torus.scad>

in2mm = 25.4;

OD = (2+7/16)*in2mm;
height = 1.25*in2mm;
outerEdgeRadius = 3;

cupRadius = 7/16*in2mm;
cupOffsetZ = 5/8*in2mm;
cupBottomDiameter = 1*in2mm;
cupBottomEdgeRadius = 3/8*in2mm;

bottomThickness = 3/16*in2mm;

cupInsideCenterRadius = cupBottomEdgeRadius - bottomThickness;
wallInsideBottomRadius = 3;
wallID = 2.25*in2mm;

module mastCup()
{
difference()
  {
    exterior();
    interior();
  }
}

module interior()
{
  centerBottomOD = cupBottomDiameter+2*bottomThickness;
  centerTopOD = 2*cupRadius+2*bottomThickness;
  m = (centerBottomOD-centerTopOD)/(cupOffsetZ-bottomThickness);
  cbo = centerBottomOD - m*(cupInsideCenterRadius);
  cto = centerTopOD - m*(30+bottomThickness + cupInsideCenterRadius-cupOffsetZ);
  translate([0,0,bottomThickness + cupInsideCenterRadius]) torus2a(cupInsideCenterRadius, (cbo+2*cupInsideCenterRadius)/2);
  translate([0,0,bottomThickness + wallInsideBottomRadius]) torus3a(wallID, 2*wallInsideBottomRadius);
  translate([0,0,bottomThickness + cupInsideCenterRadius]) tube1(cbo, cto, wallID, h=30);
  translate([0,0,bottomThickness + wallInsideBottomRadius]) tube(wallID-wallInsideBottomRadius, wallID, h=30);
  translate([0,0,bottomThickness]) tube(cbo+2*cupInsideCenterRadius, wallID-2*wallInsideBottomRadius, h=30);
  translate([0,0,cupOffsetZ]) difference()
  {
    cylinder(d=centerTopOD+10, h=30);
    sphere(d=centerTopOD);
  }

}

module tube(ID, OD, h)
{
  difference()
  {
    cylinder(d=OD, h=h);
    translate([0,0,-0.01]) cylinder(d=ID, h=h+0.02);
  }
}

module tube1(ID1, ID2, OD, h)
{
  difference()
  {
    cylinder(d=OD, h=h);
    translate([0,0,-0.01]) cylinder(d1=ID1, d2=ID2, h=h+0.02);
  }
}


module exterior()
{
  difference()
  {
    // The outside surface:
    translate([0,0,outerEdgeRadius]) hull()
    {
      torus3a(OD, 2*outerEdgeRadius);
      cylinder(d=OD, h=height-outerEdgeRadius);
    }

    // The Cup:
    hull()
    {
      translate([0,0,cupOffsetZ]) sphere(r=cupRadius);
      translate([0,0,cupBottomEdgeRadius/2-0.01]) cylinder(d=cupBottomDiameter, h=0.01);
    }

    translate([0,0,-10+cupBottomEdgeRadius/2]) cylinder(d=cupBottomDiameter+cupBottomEdgeRadius, h=10);
  }
  translate([0,0,cupBottomEdgeRadius/2]) torus(cupBottomDiameter, cupBottomDiameter+2*cupBottomEdgeRadius);
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() mastCup();
}
else
{
	mastCup();
}
