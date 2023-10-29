radius = 80 / 2;
innerRadius = 61 / 2;
outerThickness = 1.8;
totalHeight = 104;
cutHeight = 63;
cutHeightStep = 2;
cutAngle = 170;
innerRoundingRadius = 3;
bottomHeight = 2.886;
hexagonStarAllowance = 0.2;

v2colouredPartOffset = 5;
small = 0.001;


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

module cylinderWithCone(r, cylinderHeight, coneAngle, coneScale=1) rotate_extrude($fn=120) polygon([
    [0, 0],
    [r, 0],
    [r, cylinderHeight],
    [0, cylinderHeight + r * tan(coneAngle) * coneScale]
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

faceDistance = radius * sqrt(3) / 2;

module dot() sphere(small);

module colouredPart(isCut = false) union() {
    intersection() {
        cylinderWithCone(radius, cutHeight, cutAngle - 90);
        difference() {
            rotate_extrude($fn=6) polygon([
                [radius - outerThickness, 0],
                [radius, 0],
                [radius, cutHeight + cutHeightStep * 2],
                [radius - outerThickness, cutHeight + cutHeightStep],
            ]);
            if (isCut) hexagon(radius - outerThickness, cutHeight + cutHeightStep * 2);
            if (!isCut) hexagonStar(radius - outerThickness, cutHeight + cutHeightStep * 2);
        };
    };
    difference() {
        intersection() {
            hexagon(radius, totalHeight);
            for (angle=[0:60:360]) rotate([0, 0, angle])
                hull() for (i=[0, outerThickness * 2]) translate([0, -i * outerThickness * 2, 0]) {
                    translate([0, faceDistance - small, small]) dot();
                    translate([radius / 2 - i * outerThickness * 4, faceDistance - small, small]) dot();
                    translate([-radius / 2 + i * outerThickness * 4, faceDistance - small, small]) dot();
                    translate([radius / 2 - i * outerThickness * 4, faceDistance - small, cutHeight - small]) dot();
                    translate([-radius / 2 + i * outerThickness * 4, faceDistance - small, cutHeight - small]) dot();
                    intersection() {
                        cylinderWithCone(
                            radius,
                            cutHeight - outerThickness * 9 * i,
                            cutAngle - 90, coneScale=(i ? 3 : 1),
                        );
                        translate([0, faceDistance, 0])
                            rotate([90, 0, 0])
                                translate([0, totalHeight / 2, 0])
                                    linear_extrude(small, scale=[0, 0]) square([radius, totalHeight], center=true);
                    };
                };
        };
        if (isCut) hexagon(radius - outerThickness, totalHeight);
        if (!isCut) hexagonStar(radius - outerThickness, totalHeight);
    };
};

module v2CutCylinder() linear_extrude(cutHeight - v2colouredPartOffset) circle(radius * 2);
module colouredPartV2(isCut = false) {
    intersection() { cup(); v2CutCylinder(); }
    difference() { colouredPart(isCut=isCut); v2CutCylinder(); }
}

module pencilBoxV1inner() difference() { cup(); colouredPart(isCut=true); }
module pencilBoxV1outer() colouredPart();
module pencilBoxV2inner() translate([0, 0, totalHeight]) rotate([0, 180, 0])
    difference() { cup(); colouredPartV2(isCut=true); }
module pencilBoxV2outer() colouredPartV2();


echo("VARIANT", variant);
if (variant == "v1inner" ) pencilBoxV1inner();
if (variant == "v1outer" ) pencilBoxV1outer();
if (variant == "v2inner" ) pencilBoxV2inner();
if (variant == "v2outer" ) pencilBoxV2outer();
