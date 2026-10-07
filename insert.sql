SET @seed_now = CURRENT_TIMESTAMP();
SET @seed_today = CURRENT_DATE();

-- 1. Country
INSERT INTO Country (countryID,isoCode, countryName)
VALUES (1, 'AU', 'Australia'), (2, 'SG', 'Singapore'), (3, 'NZ', 'New Zealand'), (4, 'JP', 'Japan');
    
-- 2. Customer
INSERT INTO Customer ( customerID, customerName, email, phone,countryID, accountType, creditLimit, customerStatus, createdAt)
VALUES (1, 'Bluegum Electronics Pty Ltd', 'operations@bluegum.example', '+61 2 5550 0101', 1, 'PREPAID', 0.00, 'ACTIVE',  DATE_SUB(@seed_now, INTERVAL 420 DAY)),
    (2, 'Wattle Medical Supplies Pty Ltd','freight@wattlemedical.example', '+61 2 5550 0102', 1, 'CREDIT', 20000.00, 'ACTIVE', DATE_SUB(@seed_now, INTERVAL 360 DAY)),
    (3, 'Harbour Homewares Pty Ltd','logistics@harbourhomewares.example', '+61 2 5550 0103', 1, 'CREDIT', 500.00, 'ACTIVE',DATE_SUB(@seed_now, INTERVAL 300 DAY)),
    (4, 'Red Earth Retail Pty Ltd', 'shipping@redearthretail.example', '+61 8 5550 0104', 1, 'PREPAID', 0.00, 'SUSPENDED', DATE_SUB(@seed_now, INTERVAL 240 DAY)),
    (5, 'Merlion Import Services Pte Ltd','imports@merlionservices.example', '+65 5550 0105', 2, 'CREDIT', 10000.00, 'INACTIVE', DATE_SUB(@seed_now, INTERVAL 180 DAY)),
    (6, 'Southern Cross Chemicals Pty Ltd','dispatch@southerncrosschemicals.example', '+61 3 5550 0106', 1, 'PREPAID', 0.00, 'ACTIVE', DATE_SUB(@seed_now, INTERVAL 120 DAY));

-- 3. Port
INSERT INTO Port (portID, portCode, portName, city, countryID,portType)
VALUES
    (1, 'SYD', 'Sydney Kingsford Smith Airport', 'Sydney', 1, 'AIR'),
    (2, 'SIN', 'Singapore Changi Airport', 'Singapore', 2, 'AIR'),
    (3, 'AKL', 'Auckland Airport', 'Auckland', 3, 'AIR'),
    (4, 'NRT', 'Narita International Airport', 'Tokyo', 4, 'AIR'),
    (5, 'AUBTB', 'Port Botany', 'Sydney', 1, 'SEA'),
    (6, 'SGSIN', 'Port of Singapore', 'Singapore', 2, 'SEA'),
    (7, 'NZAKL', 'Port of Auckland', 'Auckland', 3, 'SEA'),
    (8, 'JPTYO', 'Port of Tokyo', 'Tokyo', 4, 'SEA');

-- 4. Carrier
INSERT INTO Carrier (carrierID, carrierCode, carrierName,transportMode, carrierStatus)
VALUES
    (1, 'SKYAIR', 'Skyline Air Cargo', 'AIR', 'ACTIVE'),
    (2, 'OCEANBRIDGE', 'OceanBridge Shipping', 'SEA', 'ACTIVE'),
    (3, 'MERIDIAN', 'Meridian Global Logistics', 'BOTH', 'ACTIVE'),
    (4, 'SOUTHAERO', 'Southern Aero Freight', 'AIR', 'INACTIVE');

-- 5. DocumentType
INSERT INTO DocumentType (documentTypeID, documentCode, documentName, requiresExpiryDate)
VALUES
    (1, 'COMMERCIAL_INVOICE', 'Commercial Invoice', FALSE),
    (2, 'PACKING_LIST', 'Packing List', FALSE),
    (3, 'AIR_WAYBILL', 'Air Waybill', FALSE),
    (4, 'BILL_OF_LADING', 'Bill of Lading', FALSE),
    (5, 'DG_DECLARATION', 'Dangerous Goods Declaration', FALSE),
    (6, 'EXPORT_PERMIT', 'Export Permit', TRUE),
    (7, 'INSURANCE_CERT', 'Insurance Certificate', TRUE);
    
-- 6. DocumentRequirement
INSERT INTO DocumentRequirement (requirementID, documentTypeID, originCountryID, destinationCountryID, transportMode, dangerousGoodsOnly, mandatoryFlag, effectiveFrom, effectiveTo)
VALUES
    (1, 1, NULL, NULL, NULL, FALSE, TRUE, DATE_SUB(@seed_today, INTERVAL 365 DAY), NULL),
    (2, 2, NULL, NULL, NULL, FALSE, TRUE, DATE_SUB(@seed_today, INTERVAL 365 DAY), NULL),
    (3, 3, NULL, NULL, 'AIR', FALSE, TRUE,DATE_SUB(@seed_today, INTERVAL 365 DAY), NULL),
    (4, 4, NULL, NULL, 'SEA', FALSE, TRUE,DATE_SUB(@seed_today, INTERVAL 365 DAY), NULL),
    (5, 5, NULL, NULL, NULL, TRUE, TRUE,DATE_SUB(@seed_today, INTERVAL 365 DAY), NULL),
    (6, 6, 1, 4, 'AIR', FALSE, TRUE, DATE_SUB(@seed_today, INTERVAL 365 DAY), NULL),
    (7, 7, NULL, NULL, NULL, FALSE, FALSE,DATE_SUB(@seed_today, INTERVAL 365 DAY), NULL),
    (8, 6, 3, 1, 'AIR', FALSE, TRUE,DATE_SUB(@seed_today, INTERVAL 365 DAY), NULL);
        

-- 7. FreightRate
INSERT INTO FreightRate ( rateID, originPortID, destinationPortID, transportMode, ratePerChargeableKg, volumetricFactorKgM3, fuelSurchargePct, dangerousGoodsSurcharge, insuranceRatePct, effectiveFrom, effectiveTo, rateStatus)
VALUES
    (1, 1, 2, 'AIR', 4.5000, 167.000, 12.00, 150.00, 1.00,  DATE_SUB(@seed_today, INTERVAL 180 DAY), NULL, 'ACTIVE'),
    (2, 1, 2, 'AIR', 4.2000, 167.000, 10.00, 140.00, 1.00, DATE_SUB(@seed_today, INTERVAL 730 DAY),  DATE_SUB(@seed_today, INTERVAL 181 DAY), 'INACTIVE'),
    (3, 1, 3, 'AIR', 3.6000, 167.000, 10.00, 120.00, 0.90, DATE_SUB(@seed_today, INTERVAL 180 DAY), NULL, 'ACTIVE'),
    (4, 5, 6, 'SEA', 0.6500, 1000.000, 8.00, 300.00, 0.70, DATE_SUB(@seed_today, INTERVAL 180 DAY), NULL, 'ACTIVE'),
    (5, 2, 1, 'AIR', 4.7500, 167.000, 13.00, 160.00, 1.10, DATE_SUB(@seed_today, INTERVAL 180 DAY), NULL, 'ACTIVE'),
    (6, 4, 1, 'AIR', 5.2500, 167.000, 14.00, 180.00, 1.20, DATE_SUB(@seed_today, INTERVAL 180 DAY), NULL, 'ACTIVE'),
    (7, 1, 4, 'AIR', 5.1000, 167.000, 14.00, 180.00, 1.20, DATE_SUB(@seed_today, INTERVAL 180 DAY), NULL, 'ACTIVE'),
    (8, 5, 7, 'SEA', 0.5500, 1000.000, 7.50, 250.00, 0.65, DATE_SUB(@seed_today, INTERVAL 180 DAY), NULL, 'ACTIVE');
 
-- 8. TransportDeparture
INSERT INTO TransportDeparture (departureID, departureCode, carrierID, originPortID, destinationPortID, transportMode, departureAt, estimatedArrivalAt, maxWeightKg, maxVolumeM3, reservedWeightKg, reservedVolumeM3, departureStatus)
VALUES
    (1, 'AIR-SYD-SIN-01', 1, 1, 2, 'AIR', DATE_ADD(@seed_now, INTERVAL 7 DAY), DATE_ADD(@seed_now, INTERVAL 8 DAY), 1000.000, 10.000, 900.000, 9.000, 'SCHEDULED'),
    (2, 'AIR-SYD-AKL-01', 3, 1, 3, 'AIR', DATE_ADD(@seed_now, INTERVAL 14 DAY), DATE_ADD(@seed_now, INTERVAL 15 DAY),  5000.000, 50.000, 650.000, 2.600, 'SCHEDULED'),
    (3, 'SEA-BTB-SIN-01', 2, 5, 6, 'SEA', DATE_ADD(@seed_now, INTERVAL 20 DAY), DATE_ADD(@seed_now, INTERVAL 35 DAY), 20000.000, 100.000, 500.000, 1.000, 'SCHEDULED'),
    (4, 'AIR-SIN-SYD-01', 1, 2, 1, 'AIR', DATE_SUB(@seed_now, INTERVAL 2 DAY), DATE_ADD(@seed_now, INTERVAL 1 DAY), 3000.000, 30.000, 250.000, 0.700, 'DEPARTED'),
    (5, 'AIR-NRT-SYD-01', 3, 4, 1, 'AIR', DATE_SUB(@seed_now, INTERVAL 5 DAY), DATE_SUB(@seed_now, INTERVAL 3 DAY), 3000.000, 30.000, 200.000, 0.500, 'ARRIVED'),
    (6, 'AIR-SYD-NRT-01', 1, 1, 4, 'AIR', DATE_ADD(@seed_now, INTERVAL 10 DAY), DATE_ADD(@seed_now, INTERVAL 11 DAY), 4000.000, 40.000, 150.000, 0.500, 'SCHEDULED'),
    (7, 'AIR-SYD-SIN-X1', 1, 1, 2, 'AIR', DATE_ADD(@seed_now, INTERVAL 30 DAY), DATE_ADD(@seed_now, INTERVAL 31 DAY), 1000.000, 10.000, 0.000, 0.000, 'CANCELLED');

-- 9. Shipment
INSERT INTO Shipment (shipmentID, customerID, originPortID, destinationPortID, transportMode, selectedDepartureID, insuranceRequired, shipmentStatus, createdAt)
VALUES
    (1, 1, 1, 3, 'AIR', NULL, FALSE, 'DRAFT', DATE_SUB(@seed_now, INTERVAL 2 DAY)),
    (2, 2, 1, 2, 'AIR', NULL, TRUE, 'DRAFT', DATE_SUB(@seed_now, INTERVAL 2 DAY)),
    (3, 1, 1, 3, 'AIR', 2, FALSE, 'QUOTED', DATE_SUB(@seed_now, INTERVAL 3 DAY)),
    (4, 1, 1, 3, 'AIR', 2, FALSE, 'QUOTED', DATE_SUB(@seed_now, INTERVAL 12 DAY)),
    (5, 2, 1, 2, 'AIR', 1, FALSE, 'BOOKED', DATE_SUB(@seed_now, INTERVAL 11 DAY)),
    (6, 1, 1, 2, 'AIR', 1, FALSE, 'QUOTED', DATE_SUB(@seed_now, INTERVAL 2 DAY)),
    (7, 2, 1, 2, 'AIR', 1, FALSE, 'QUOTED', DATE_SUB(@seed_now, INTERVAL 2 DAY)),
    (8, 6, 5, 6, 'SEA', 3, TRUE, 'LOADED', DATE_SUB(@seed_now, INTERVAL 15 DAY)),
    (9, 1, 1, 3, 'AIR', 2, FALSE, 'LOADED', DATE_SUB(@seed_now, INTERVAL 11 DAY)),
    (10, 2, 1, 3, 'AIR', 2, FALSE, 'LOADED',DATE_SUB(@seed_now, INTERVAL 10 DAY)),
    (11, 3, 1, 3, 'AIR', 2, FALSE, 'LOADED', DATE_SUB(@seed_now, INTERVAL 10 DAY)),
    (12, 1, 1, 3, 'AIR', 2, FALSE, 'BOOKED', DATE_SUB(@seed_now, INTERVAL 8 DAY)),
    (13, 1, 1, 3, 'AIR', 2, TRUE, 'LOADED', DATE_SUB(@seed_now, INTERVAL 9 DAY)),
    (14, 2, 2, 1, 'AIR', 4, FALSE, 'IN_TRANSIT', DATE_SUB(@seed_now, INTERVAL 22 DAY)),
    (15, 1, 4, 1, 'AIR', 5, FALSE, 'DELIVERED', DATE_SUB(@seed_now, INTERVAL 30 DAY)),
    (16, 2, 1, 4, 'AIR', 6, FALSE, 'BOOKED', DATE_SUB(@seed_now, INTERVAL 9 DAY));

-- 10. ShipmentItem
INSERT INTO ShipmentItem (shipmentItemID,shipmentID, itemDescription, quantity, unitWeightKg, unitVolumeM3, unitDeclaredValue, dangerousGoodsFlag, dangerousGoodsClass)
VALUES
    (1, 1, 'Wireless earbud cartons', 2, 50.000, 0.100, 500.00, FALSE, NULL),
    (2, 1, 'Bluetooth speaker cartons', 1, 20.000, 0.050, 300.00, FALSE, NULL),
    (3, 2, 'Yoga mat cartons', 1, 10.000, 0.600, 2000.00, FALSE, NULL),
    (4, 2, 'Exercise ball cartons', 2, 5.000, 0.200, 500.00, FALSE, NULL),
    (5, 3, 'Air fryer cartons', 2, 40.000, 0.100, 800.00, FALSE, NULL),
    (6, 4, 'Coffee machine cartons', 1, 60.000, 0.200, 1000.00, FALSE, NULL),
    (7, 5, 'Laptop accessory pallets', 1, 900.000, 9.000, 15000.00, FALSE, NULL),
    (8, 6, 'Wireless earbud pallet', 1, 100.000, 1.000, 2000.00, FALSE, NULL),
    (9, 7, 'Smartwatch pallet', 1, 100.000, 1.000, 2200.00, FALSE, NULL),
    (10, 8, 'Cleaning solvent drums', 4, 100.000, 0.200, 1000.00, TRUE, 'CLASS_3'),
    (11, 8, 'Protective packaging pallets', 2, 50.000, 0.100, 500.00, FALSE, NULL),
    (12, 9, 'Kitchen appliance cartons', 2, 50.000, 0.200, 1000.00, FALSE, NULL),
    (13, 9, 'Appliance spare-parts carton', 1, 20.000, 0.100, 500.00, FALSE, NULL),
    (14, 10, 'Medical equipment crate', 1, 100.000, 0.300, 3000.00, FALSE, NULL),
    (15, 10, 'Medical consumable cartons', 2, 25.000, 0.100, 500.00, FALSE, NULL),
    (16, 11, 'Foam furniture packages', 1, 100.000, 1.000, 2000.00, FALSE, NULL),
    (17, 12, 'Office chair pallet', 1, 200.000, 0.400, 3500.00, FALSE, NULL),
    (18, 13, 'Camera equipment crate', 1, 80.000, 0.200, 5000.00, FALSE, NULL),
    (19, 14, 'Pharmaceutical cool boxes', 1, 200.000, 0.500, 4000.00, FALSE, NULL),
    (20, 14, 'Diagnostic equipment case', 1, 50.000, 0.200, 1000.00, FALSE, NULL),
    (21, 15, 'Ceramic cookware crates', 1, 150.000, 0.400, 3000.00, FALSE, NULL),
    (22, 15, 'Cookware replacement parts', 1, 50.000, 0.100, 1000.00, FALSE, NULL),
    (23, 16, 'Laboratory instrument crate', 1, 100.000, 0.300, 5000.00, FALSE, NULL),
    (24, 16, 'Laboratory accessory cartons', 2, 25.000, 0.100, 1000.00, FALSE, NULL);

-- 11. Quotation
INSERT INTO Quotation ( quotationID, shipmentID, rateID, issuedAt, expiresAt, chargeableWeightKg, freightCharge, quotationStatus, acceptedAt)
VALUES
    (3, 3, 3, DATE_SUB(@seed_now, INTERVAL 2 DAY), DATE_ADD(@seed_now, INTERVAL 5 DAY), 80.000, 316.80, 'ACCEPTED', DATE_SUB(@seed_now, INTERVAL 1 DAY)),
    (4, 4, 3, DATE_SUB(@seed_now, INTERVAL 10 DAY), DATE_SUB(@seed_now, INTERVAL 2 DAY), 60.000, 237.60, 'EXPIRED', NULL),
    (5, 5, 1, DATE_SUB(@seed_now, INTERVAL 10 DAY), DATE_SUB(@seed_now, INTERVAL 5 DAY), 1503.000, 7575.12, 'ACCEPTED', DATE_SUB(@seed_now, INTERVAL 9 DAY)),
    (6, 6, 1, DATE_SUB(@seed_now, INTERVAL 1 DAY), DATE_ADD(@seed_now, INTERVAL 4 DAY), 167.000, 841.68, 'ACCEPTED', DATE_SUB(@seed_now, INTERVAL 12 HOUR)),
    (7, 7, 1, DATE_SUB(@seed_now, INTERVAL 1 DAY), DATE_ADD(@seed_now, INTERVAL 4 DAY),167.000, 841.68, 'ACCEPTED', DATE_SUB(@seed_now, INTERVAL 10 HOUR)),
    (8, 8, 4, DATE_SUB(@seed_now, INTERVAL 14 DAY), DATE_SUB(@seed_now, INTERVAL 8 DAY),1000.000, 1037.00, 'ACCEPTED', DATE_SUB(@seed_now, INTERVAL 13 DAY)),
    (9, 9, 3, DATE_SUB(@seed_now, INTERVAL 10 DAY), DATE_SUB(@seed_now, INTERVAL 5 DAY),120.000, 475.20, 'ACCEPTED',DATE_SUB(@seed_now, INTERVAL 9 DAY)),
    (10, 10, 3, DATE_SUB(@seed_now, INTERVAL 9 DAY), DATE_SUB(@seed_now, INTERVAL 4 DAY), 150.000, 594.00, 'ACCEPTED', DATE_SUB(@seed_now, INTERVAL 8 DAY)),
    (11, 11, 3, DATE_SUB(@seed_now, INTERVAL 9 DAY),DATE_SUB(@seed_now, INTERVAL 4 DAY), 167.000, 661.32, 'ACCEPTED', DATE_SUB(@seed_now, INTERVAL 8 DAY)),
    (12, 12, 3, DATE_SUB(@seed_now, INTERVAL 7 DAY), DATE_SUB(@seed_now, INTERVAL 2 DAY), 200.000, 792.00, 'ACCEPTED', DATE_SUB(@seed_now, INTERVAL 6 DAY)),
    (13, 13, 3, DATE_SUB(@seed_now, INTERVAL 8 DAY), DATE_SUB(@seed_now, INTERVAL 3 DAY), 80.000, 361.80, 'ACCEPTED', DATE_SUB(@seed_now, INTERVAL 7 DAY)),
    (14, 14, 5, DATE_SUB(@seed_now, INTERVAL 20 DAY),DATE_SUB(@seed_now, INTERVAL 15 DAY), 250.000, 1341.88, 'ACCEPTED', DATE_SUB(@seed_now, INTERVAL 19 DAY)),
    (15, 15, 6, DATE_SUB(@seed_now, INTERVAL 28 DAY), DATE_SUB(@seed_now, INTERVAL 23 DAY),200.000, 1197.00, 'ACCEPTED', DATE_SUB(@seed_now, INTERVAL 27 DAY)),
    (16, 16, 7, DATE_SUB(@seed_now, INTERVAL 8 DAY),DATE_ADD(@seed_now, INTERVAL 2 DAY),150.000, 872.10, 'ACCEPTED', DATE_SUB(@seed_now, INTERVAL 7 DAY));


-- 12. CapacityReservation
INSERT INTO CapacityReservation (shipmentID, departureID, reservedWeightKg, reservedVolumeM3, reservationStatus, reservedAt, releasedAt)
VALUES
    (5,  1, 900.000, 9.000, 'ACTIVE', DATE_SUB(@seed_now, INTERVAL 9 DAY),  NULL),
    (8,  3, 500.000, 1.000, 'ACTIVE', DATE_SUB(@seed_now, INTERVAL 13 DAY), NULL),
    (9,  2, 120.000, 0.500, 'ACTIVE', DATE_SUB(@seed_now, INTERVAL 9 DAY),  NULL),
    (10, 2, 150.000, 0.500, 'ACTIVE', DATE_SUB(@seed_now, INTERVAL 8 DAY),  NULL),
    (11, 2, 100.000, 1.000, 'ACTIVE', DATE_SUB(@seed_now, INTERVAL 8 DAY),  NULL),
    (12, 2, 200.000, 0.400, 'ACTIVE', DATE_SUB(@seed_now, INTERVAL 6 DAY),  NULL),
    (13, 2,  80.000, 0.200, 'ACTIVE', DATE_SUB(@seed_now, INTERVAL 7 DAY),  NULL),
    (14, 4, 250.000, 0.700, 'ACTIVE', DATE_SUB(@seed_now, INTERVAL 19 DAY), NULL),
    (15, 5, 200.000, 0.500, 'ACTIVE', DATE_SUB(@seed_now, INTERVAL 27 DAY), NULL),
    (16, 6, 150.000, 0.500, 'ACTIVE', DATE_SUB(@seed_now, INTERVAL 7 DAY),  NULL);

-- 13. Invoice
INSERT INTO Invoice ( shipmentID, invoiceNumber, issuedAt, dueAt, totalAmount, adjustmentAmount, amountPaid, invoiceStatus)
VALUES
    (5,  'INV-0005', DATE_SUB(@seed_now, INTERVAL 9 DAY), DATE_ADD(@seed_now, INTERVAL 5 DAY), 7575.12, 0.00, 0.00,    'UNPAID'),
    (8,  'INV-0008', DATE_SUB(@seed_now, INTERVAL 13 DAY), DATE_SUB(@seed_now, INTERVAL 8 DAY), 1037.00, 0.00, 1037.00, 'PAID'),
    (9,  'INV-0009', DATE_SUB(@seed_now, INTERVAL 9 DAY), DATE_SUB(@seed_now, INTERVAL 4 DAY), 475.20,  0.00, 0.00,    'UNPAID'),
    (10, 'INV-0010', DATE_SUB(@seed_now, INTERVAL 8 DAY), DATE_ADD(@seed_now, INTERVAL 6 DAY), 594.00,  0.00, 0.00,    'UNPAID'),
    (11, 'INV-0011', DATE_SUB(@seed_now, INTERVAL 8 DAY), DATE_ADD(@seed_now, INTERVAL 6 DAY), 661.32,  0.00, 0.00,    'UNPAID'),
    (12, 'INV-0012', DATE_SUB(@seed_now, INTERVAL 6 DAY), DATE_SUB(@seed_now, INTERVAL 1 DAY), 792.00,  0.00, 0.00,    'UNPAID'),
    (13, 'INV-0013', DATE_SUB(@seed_now, INTERVAL 7 DAY), DATE_SUB(@seed_now, INTERVAL 2 DAY), 361.80,  0.00, 361.80,  'PAID'),
    (14, 'INV-0014', DATE_SUB(@seed_now, INTERVAL 19 DAY), DATE_SUB(@seed_now, INTERVAL 5 DAY), 1341.88, 0.00, 500.00,  'PARTIALLY_PAID'),
    (15, 'INV-0015', DATE_SUB(@seed_now, INTERVAL 27 DAY), DATE_SUB(@seed_now, INTERVAL 22 DAY), 1197.00, 0.00, 1197.00, 'PAID'),
    (16, 'INV-0016', DATE_SUB(@seed_now, INTERVAL 7 DAY), DATE_ADD(@seed_now, INTERVAL 7 DAY), 872.10,  0.00, 0.00,    'UNPAID');

-- 14. Payment
INSERT INTO Payment ( paymentID, shipmentID, paymentReference, paymentAt, amount, paymentMethod, transCustomeractionType, paymentStatus)
VALUES
    (1, 8,  'PAY-S08-001', DATE_SUB(@seed_now, INTERVAL 12 DAY), 1037.00, 'BANK_TRANSFER', 'PAYMENT', 'CONFIRMED'),
    (2, 13, 'PAY-S13-REV', DATE_SUB(@seed_now, INTERVAL 6 DAY), 361.80, 'CARD', 'PAYMENT', 'REVERSED'),
    (3, 13, 'PAY-S13-001', DATE_SUB(@seed_now, INTERVAL 5 DAY),  361.80, 'CARD', 'PAYMENT', 'CONFIRMED'),
    (4, 14, 'PAY-S14-001', DATE_SUB(@seed_now, INTERVAL 18 DAY),  500.00, 'BPAY', 'PAYMENT', 'CONFIRMED'),
    (5, 14, 'PAY-S14-DEC', DATE_SUB(@seed_now, INTERVAL 17 DAY), 200.00, 'CARD', 'PAYMENT', 'DECLINED'),
    (6, 15, 'PAY-S15-001', DATE_SUB(@seed_now, INTERVAL 26 DAY),  600.00, 'BANK_TRANSFER', 'PAYMENT', 'CONFIRMED'),
    (7, 15, 'PAY-S15-002', DATE_SUB(@seed_now, INTERVAL 25 DAY), 597.00, 'BANK_TRANSFER', 'PAYMENT', 'CONFIRMED');

-- 15. ShipmentDocument
INSERT INTO ShipmentDocument ( shipmentDocumentID, shipmentID, documentTypeID, documentReference, fileName, submittedAt, expiryDate, documentStatus, decisionAt, decisionBy)
VALUES
    (1, 5, 1, 'DOC-S05-CI', 's05_commercial_invoice.pdf',DATE_SUB(@seed_now, INTERVAL 8 DAY), NULL, 'APPROVED',  DATE_SUB(@seed_now, INTERVAL 7 DAY), 'Mia Chen'),
    (2, 5, 2, 'DOC-S05-PL', 's05_packing_list.pdf', DATE_SUB(@seed_now, INTERVAL 8 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 7 DAY), 'Mia Chen'),
    (3, 5, 3, 'DOC-S05-AWB', 's05_air_waybill.pdf', DATE_SUB(@seed_now, INTERVAL 8 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 7 DAY), 'Mia Chen'),
    (4, 8, 1, 'DOC-S08-CI', 's08_commercial_invoice.pdf',DATE_SUB(@seed_now, INTERVAL 12 DAY), NULL, 'APPROVED',DATE_SUB(@seed_now, INTERVAL 11 DAY), 'Noah Williams'),
    (5, 8, 2, 'DOC-S08-PL', 's08_packing_list.pdf', DATE_SUB(@seed_now, INTERVAL 12 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 11 DAY), 'Noah Williams'),
    (6, 8, 4, 'DOC-S08-BOL', 's08_bill_of_lading.pdf', DATE_SUB(@seed_now, INTERVAL 12 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 11 DAY), 'Noah Williams'),
    (7, 8, 7, 'DOC-S08-INS', 's08_insurance_certificate.pdf', DATE_SUB(@seed_now, INTERVAL 12 DAY), DATE_ADD(@seed_today, INTERVAL 90 DAY),'APPROVED', DATE_SUB(@seed_now, INTERVAL 11 DAY), 'Noah Williams'),
    (8, 9, 1, 'DOC-S09-CI', 's09_commercial_invoice.pdf', DATE_SUB(@seed_now, INTERVAL 8 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 7 DAY), 'Mia Chen'),
    (9, 9, 2, 'DOC-S09-PL', 's09_packing_list.pdf', DATE_SUB(@seed_now, INTERVAL 8 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 7 DAY), 'Mia Chen'),
    (10, 9, 3, 'DOC-S09-AWB', 's09_air_waybill.pdf', DATE_SUB(@seed_now, INTERVAL 8 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 7 DAY), 'Mia Chen'),

    (11, 10, 1, 'DOC-S10-CI', 's10_commercial_invoice.pdf', DATE_SUB(@seed_now, INTERVAL 7 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 6 DAY), 'Mia Chen'),
    (12, 10, 2, 'DOC-S10-PL', 's10_packing_list.pdf', DATE_SUB(@seed_now, INTERVAL 7 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 6 DAY), 'Mia Chen'),
    (13, 10, 3, 'DOC-S10-AWB', 's10_air_waybill.pdf', DATE_SUB(@seed_now, INTERVAL 7 DAY), NULL, 'APPROVED',  DATE_SUB(@seed_now, INTERVAL 6 DAY), 'Mia Chen'),

    (14, 11, 1, 'DOC-S11-CI', 's11_commercial_invoice.pdf', DATE_SUB(@seed_now, INTERVAL 7 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 6 DAY), 'Mia Chen'),
    (15, 11, 2, 'DOC-S11-PL', 's11_packing_list.pdf', DATE_SUB(@seed_now, INTERVAL 7 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 6 DAY), 'Mia Chen'),
    (16, 11, 3, 'DOC-S11-AWB', 's11_air_waybill.pdf', DATE_SUB(@seed_now, INTERVAL 7 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 6 DAY), 'Mia Chen'),

    (17, 13, 1, 'DOC-S13-CI', 's13_commercial_invoice.pdf', DATE_SUB(@seed_now, INTERVAL 6 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 5 DAY), 'Ava Thompson'),
    (18, 13, 2, 'DOC-S13-PL', 's13_packing_list.pdf', DATE_SUB(@seed_now, INTERVAL 6 DAY), NULL, 'APPROVED',  DATE_SUB(@seed_now, INTERVAL 5 DAY), 'Ava Thompson'),
    (19, 13, 3, 'DOC-S13-AWB', 's13_air_waybill.pdf', DATE_SUB(@seed_now, INTERVAL 6 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 5 DAY), 'Ava Thompson'),
    (20, 13, 7, 'DOC-S13-INS', 's13_expired_insurance_certificate.pdf', DATE_SUB(@seed_now, INTERVAL 8 DAY), DATE_SUB(@seed_today, INTERVAL 1 DAY), 'EXPIRED', NULL, NULL),

    (21, 14, 1, 'DOC-S14-CI', 's14_commercial_invoice.pdf', DATE_SUB(@seed_now, INTERVAL 18 DAY), NULL, 'APPROVED',DATE_SUB(@seed_now, INTERVAL 17 DAY), 'Noah Williams'),
    (22, 14, 2, 'DOC-S14-PL', 's14_packing_list.pdf', DATE_SUB(@seed_now, INTERVAL 18 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 17 DAY), 'Noah Williams'),
    (23, 14, 3, 'DOC-S14-AWB', 's14_air_waybill.pdf', DATE_SUB(@seed_now, INTERVAL 18 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 17 DAY), 'Noah Williams'),

    (24, 15, 1, 'DOC-S15-CI', 's15_commercial_invoice.pdf', DATE_SUB(@seed_now, INTERVAL 26 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 25 DAY), 'Ava Thompson'),
    (25, 15, 2, 'DOC-S15-PL', 's15_packing_list.pdf', DATE_SUB(@seed_now, INTERVAL 26 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 25 DAY), 'Ava Thompson'),
    (26, 15, 3, 'DOC-S15-AWB', 's15_air_waybill.pdf', DATE_SUB(@seed_now, INTERVAL 26 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 25 DAY), 'Ava Thompson'),

    (27, 16, 1, 'DOC-S16-CI', 's16_commercial_invoice.pdf', DATE_SUB(@seed_now, INTERVAL 6 DAY), NULL, 'APPROVED',DATE_SUB(@seed_now, INTERVAL 5 DAY), 'Mia Chen'),
    (28, 16, 2, 'DOC-S16-PL', 's16_packing_list.pdf', DATE_SUB(@seed_now, INTERVAL 6 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 5 DAY), 'Mia Chen'),
    (29, 16, 3, 'DOC-S16-AWB', 's16_air_waybill.pdf', DATE_SUB(@seed_now, INTERVAL 6 DAY), NULL, 'APPROVED', DATE_SUB(@seed_now, INTERVAL 5 DAY), 'Mia Chen'),
    (30, 16, 6, 'DOC-S16-EXP', 's16_export_permit.pdf', DATE_SUB(@seed_now, INTERVAL 6 DAY), DATE_ADD(@seed_today, INTERVAL 5 DAY),'APPROVED', DATE_SUB(@seed_now, INTERVAL 5 DAY), 'Mia Chen');


-- 16. DocumentAlert
INSERT INTO DocumentAlert (shipmentID, documentTypeID, alertType, alertMessage,createdAt, alertStatus,resolvedAt)
VALUES
    (16, 6, 'EXPIRING','Export permit expires within seven days of alert creation.',  now(), 'OPEN', NULL);


SET @seed_today = CURRENT_DATE();
-- 17. TrackingEvent
SET @seed_now = CURRENT_TIMESTAMP();
SET @seed_now = NOW();
SET @seed_today = CURDATE();
INSERT INTO TrackingEvent ( eventReference, shipmentID, eventType, eventAt, locationPortID, eventDescription, recordedAt)
VALUES
    ('TRK-S14-001', 14, 'DISPATCHED', DATE_SUB(@seed_now, INTERVAL 4 DAY), 2, 'Shipment released from the Singapore cargo terminal.', DATE_SUB(@seed_now, INTERVAL 4 DAY)),
    ('TRK-S14-002', 14, 'DEPARTED', DATE_SUB(@seed_now, INTERVAL 2 DAY), 2, 'Flight departed Singapore for Sydney.', DATE_SUB(@seed_now, INTERVAL 2 DAY)),
    ('TRK-S14-003', 14, 'IN_TRANSIT', DATE_SUB(@seed_now, INTERVAL 36 HOUR), NULL, 'Shipment is in international transit.', DATE_SUB(@seed_now, INTERVAL 35 HOUR)),
    ('TRK-S14-004', 14, 'CUSTOMS_HOLD', DATE_SUB(@seed_now, INTERVAL 12 HOUR), 1, 'Shipment is awaiting routine customs inspection.',  DATE_SUB(@seed_now, INTERVAL 11 HOUR)),
    ('TRK-S15-001', 15, 'DISPATCHED', DATE_SUB(@seed_now, INTERVAL 10 DAY), 4, 'Shipment released from the Narita cargo terminal.', DATE_SUB(@seed_now, INTERVAL 10 DAY)),
    ('TRK-S15-002', 15, 'DEPARTED', DATE_SUB(@seed_now, INTERVAL 5 DAY), 4, 'Flight departed Narita for Sydney.', DATE_SUB(@seed_now, INTERVAL 5 DAY)),
    ('TRK-S15-003', 15, 'IN_TRANSIT', DATE_SUB(@seed_now, INTERVAL 4 DAY), NULL, 'Shipment is in international transit.', DATE_SUB(@seed_now, INTERVAL 4 DAY)),
    ('TRK-S15-004', 15, 'CUSTOMS_CLEARED', DATE_SUB(@seed_now, INTERVAL 3 DAY), 1, 'Australian customs clearance completed.', DATE_SUB(@seed_now, INTERVAL 3 DAY)),
    ('TRK-S15-005', 15, 'ARRIVED', DATE_SUB(@seed_now, INTERVAL 2 DAY), 1, 'Shipment received at the Sydney cargo terminal.', DATE_SUB(@seed_now, INTERVAL 2 DAY)),
    ('TRK-S15-006', 15, 'DELIVERED', DATE_SUB(@seed_now, INTERVAL 1 DAY), 1,'Shipment delivered to the consignee.', DATE_SUB(@seed_now, INTERVAL 1 DAY));

-- 18. ShipmentStatusHistory
INSERT INTO ShipmentStatusHistory ( shipmentID, changedAt, oldStatus, newStatus,changedBy,changeReason)
VALUES
    (3, DATE_SUB(@seed_now, INTERVAL 2 DAY), 'DRAFT', 'QUOTED', 'system', 'Quotation issued.'),
    (4, DATE_SUB(@seed_now, INTERVAL 10 DAY), 'DRAFT', 'QUOTED','system', 'Quotation issued.'),
    (5, DATE_SUB(@seed_now, INTERVAL 10 DAY), 'DRAFT', 'QUOTED', 'system', 'Quotation issued.'),
    (5, DATE_SUB(@seed_now, INTERVAL 9 DAY), 'QUOTED', 'BOOKED','booking.team', 'Accepted quotation and capacity reservation confirmed.'),
    (6, DATE_SUB(@seed_now, INTERVAL 1 DAY), 'DRAFT', 'QUOTED', 'system', 'Quotation issued.'),
    (7, DATE_SUB(@seed_now, INTERVAL 1 DAY), 'DRAFT', 'QUOTED','system', 'Quotation issued.'),
    (8, DATE_SUB(@seed_now, INTERVAL 14 DAY), 'DRAFT', 'QUOTED','system', 'Quotation issued.'),
    (8, DATE_SUB(@seed_now, INTERVAL 13 DAY), 'QUOTED', 'BOOKED','booking.team', 'Accepted quotation and capacity reservation confirmed.'),
    (8, DATE_SUB(@seed_now, INTERVAL 2 DAY), 'BOOKED', 'LOADED', 'warehouse.team', 'Cargo loaded pending dangerous-goods document.'),
    (9, DATE_SUB(@seed_now, INTERVAL 10 DAY), 'DRAFT', 'QUOTED', 'system', 'Quotation issued.'),
    (9, DATE_SUB(@seed_now, INTERVAL 9 DAY), 'QUOTED', 'BOOKED','booking.team', 'Accepted quotation and capacity reservation confirmed.'),
    (9, DATE_SUB(@seed_now, INTERVAL 2 DAY), 'BOOKED', 'LOADED', 'warehouse.team', 'Cargo loaded; prepaid invoice remains unpaid.'),
    (10, DATE_SUB(@seed_now, INTERVAL 9 DAY), 'DRAFT', 'QUOTED', 'system', 'Quotation issued.'),
    (10, DATE_SUB(@seed_now, INTERVAL 8 DAY), 'QUOTED', 'BOOKED', 'booking.team', 'Accepted quotation and capacity reservation confirmed.'),
    (10, DATE_SUB(@seed_now, INTERVAL 2 DAY), 'BOOKED', 'LOADED', 'warehouse.team', 'Cargo loaded for credit customer.'),
    (11, DATE_SUB(@seed_now, INTERVAL 9 DAY), 'DRAFT', 'QUOTED', 'system', 'Quotation issued.'),
    (11, DATE_SUB(@seed_now, INTERVAL 8 DAY), 'QUOTED', 'BOOKED','booking.team', 'Accepted quotation and capacity reservation confirmed.'),
    (11, DATE_SUB(@seed_now, INTERVAL 2 DAY), 'BOOKED', 'LOADED', 'warehouse.team', 'Cargo loaded; dispatch subject to credit-limit check.'),
    (12, DATE_SUB(@seed_now, INTERVAL 7 DAY), 'DRAFT', 'QUOTED', 'system', 'Quotation issued.'),
    (12, DATE_SUB(@seed_now, INTERVAL 6 DAY), 'QUOTED', 'BOOKED', 'booking.team', 'Accepted quotation and capacity reservation confirmed.'),
    (13, DATE_SUB(@seed_now, INTERVAL 8 DAY), 'DRAFT', 'QUOTED', 'system', 'Quotation issued.'),
    (13, DATE_SUB(@seed_now, INTERVAL 7 DAY), 'QUOTED', 'BOOKED', 'booking.team', 'Accepted quotation and capacity reservation confirmed.'),
    (13, DATE_SUB(@seed_now, INTERVAL 2 DAY), 'BOOKED', 'LOADED', 'warehouse.team', 'Cargo loaded; booking can no longer be cancelled.'),
    (14, DATE_SUB(@seed_now, INTERVAL 20 DAY), 'DRAFT', 'QUOTED','system', 'Quotation issued.'),
    (14, DATE_SUB(@seed_now, INTERVAL 19 DAY), 'QUOTED', 'BOOKED','booking.team', 'Accepted quotation and capacity reservation confirmed.'),
    (14, DATE_SUB(@seed_now, INTERVAL 6 DAY), 'BOOKED', 'LOADED', 'warehouse.team', 'Cargo loaded.'),
    (14, DATE_SUB(@seed_now, INTERVAL 4 DAY), 'LOADED', 'DISPATCHED','dispatch.team', 'Shipment dispatched from Singapore.'),
    (14, DATE_SUB(@seed_now, INTERVAL 2 DAY), 'DISPATCHED', 'IN_TRANSIT', 'tracking.system', 'Carrier departure event recorded.'),
    (15, DATE_SUB(@seed_now, INTERVAL 28 DAY), 'DRAFT', 'QUOTED','system', 'Quotation issued.'),
    (15, DATE_SUB(@seed_now, INTERVAL 27 DAY), 'QUOTED', 'BOOKED','booking.team', 'Accepted quotation and capacity reservation confirmed.'),
    (15, DATE_SUB(@seed_now, INTERVAL 12 DAY), 'BOOKED', 'LOADED','warehouse.team', 'Cargo loaded.'),
    (15, DATE_SUB(@seed_now, INTERVAL 10 DAY), 'LOADED', 'DISPATCHED','dispatch.team', 'Shipment dispatched from Narita.'),
    (15, DATE_SUB(@seed_now, INTERVAL 5 DAY), 'DISPATCHED', 'IN_TRANSIT', 'tracking.system', 'Carrier departure event recorded.'),
    (15, DATE_SUB(@seed_now, INTERVAL 1 DAY), 'IN_TRANSIT', 'DELIVERED','tracking.system', 'Delivery event recorded.'),
    (16, DATE_SUB(@seed_now, INTERVAL 8 DAY), 'DRAFT', 'QUOTED', 'system', 'Quotation issued.'),
    (16, DATE_SUB(@seed_now, INTERVAL 7 DAY), 'QUOTED', 'BOOKED', 'booking.team', 'Accepted quotation and capacity reservation confirmed.');
