radius = 80 / 2;
innerRadius = 61 / 2;
outerThickness = 1.8;
totalHeight = 104;
cutHeight = 63;
cutAngle = 170;
innerRoundingRadius = 3;
bottomHeight = 2.886;
hexagonStarAllowance = 0.2;


module hexagon(r, h) rotate_extrude($fn=6) square([r, h]);
module hexagonStar(r, h) linear_extrude(h) polygon([
    for (angle=[0:30:360]) angle % 60 ? [
        (r + hexagonStarAllowance) * sin(angle), 
        (r + hexagonStarAllowance) * cos(angle), 
    ] : [
        r * sqrt(3) / 2 * sin(angle),
        r * sqrt(3) / 2 * cos(angle),
    ]
]);

module cylinderWithCone(r, cylinderHeight, coneAngle) rotate_extrude($fn=120) polygon([
    [0, 0],
    [r, 0],
    [r, cylinderHeight],
    [0, cylinderHeight + r * tan(coneAngle)]
]);

module cup() // render(convexity=4)
intersection() {
    difference() {
        hexagon(radius - small, totalHeight);
        translate([0, 0, bottomHeight])
            rotate_extrude($fn=120)
                hull() {
                    square(innerRoundingRadius);
                    translate([innerRadius - innerRoundingRadius, innerRoundingRadius]) circle(innerRoundingRadius);
                    translate([innerRadius - innerRoundingRadius, totalHeight]) square(innerRoundingRadius);
                    translate([0, totalHeight]) square(innerRoundingRadius);
                }
    };
    cylinderWithCone(radius, cutHeight, cutAngle - 90);
};

small = 0.001;

module colouredPart(isCut = false) // render(convexity=4)
difference() {
    for (angle=[0:60:360]) rotate([0, 0, angle])
        hull() {
            translate([0, 0, (isCut ? -totalHeight / 4 : small )]) sphere(small);
            intersection() {
                cylinderWithCone(radius, cutHeight, cutAngle - 90);
                translate([0, radius * sqrt(3) / 2, 0])
                    rotate([90, 0, 0])
                        translate([0, totalHeight / 2, 0])
                            linear_extrude(small, scale=[0, 0]) square([radius, totalHeight], center=true);
            };
        };
    if (isCut) hexagon(radius - outerThickness, totalHeight);
    if (!isCut) hexagonStar(radius - outerThickness, totalHeight);
};

module pencilBoxV1inner() difference() { cup(); colouredPart(isCut=true); }
module pencilBoxV1outer()  colouredPart();


echo("VARIANT", variant);
if (variant == "v1inner" ) pencilBoxV1inner();
if (variant == "v1outer" ) pencilBoxV1outer();
