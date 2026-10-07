#******************************** Instruciton Before Tables creation *************************************#

-- use your unit code followed by your group ID. 
-- For example, if you are enrolled in COMP2350, and your group ID is G09
-- then, replace XXX with COMP2350_G09
-- CREATE DATABASE XXX; 
-- USE XXX;
#*********************************************************************************************************#

-- 1. Country
CREATE TABLE Country (
    countryID      INT         NOT NULL,
    isoCode        CHAR(2)     NOT NULL,
    countryName    VARCHAR(80) NOT NULL,

    CONSTRAINT pk_country PRIMARY KEY (countryID),
    CONSTRAINT uq_country_iso_code UNIQUE (isoCode),
    CONSTRAINT uq_country_name UNIQUE (countryName)
);


-- 2. Customer
CREATE TABLE Customer (
    customerID      INT                                  NOT NULL,
    customerName    VARCHAR(100)                         NOT NULL,
    email           VARCHAR(100)                         NOT NULL,
    phone           VARCHAR(25)                              NULL,
    countryID       INT                                  NOT NULL,
    accountType     ENUM('PREPAID', 'CREDIT')            NOT NULL,
    creditLimit     DECIMAL(12,2)                        NOT NULL DEFAULT 0.00,
    customerStatus  ENUM('ACTIVE', 'SUSPENDED','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    createdAt       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_customer PRIMARY KEY (customerID),
    CONSTRAINT uq_customer_email UNIQUE (email),
    CONSTRAINT chk_customer_credit_nonnegative CHECK (creditLimit >= 0),
    CONSTRAINT chk_customer_prepaid_credit CHECK (accountType = 'CREDIT' OR creditLimit = 0),
    CONSTRAINT fk_customer_country FOREIGN KEY (countryID) REFERENCES Country (countryID)
	);

-- 3. Port
CREATE TABLE Port (
    portID       INT                NOT NULL,
    portCode     VARCHAR(10)        NOT NULL,
    portName     VARCHAR(100)       NOT NULL,
    city         VARCHAR(80)        NOT NULL,
    countryID    INT                NOT NULL,
    portType     ENUM('AIR', 'SEA') NOT NULL,

    CONSTRAINT pk_port PRIMARY KEY (portID),
    CONSTRAINT uq_port_code UNIQUE (portCode),
    CONSTRAINT fk_port_country  FOREIGN KEY (countryID) REFERENCES Country (countryID)
);

-- 4. Carrier
CREATE TABLE Carrier (
    carrierID       INT                              NOT NULL,
    carrierCode     VARCHAR(15)                      NOT NULL,
    carrierName     VARCHAR(100)                     NOT NULL,
    transportMode   ENUM('AIR', 'SEA', 'BOTH')      NOT NULL,
    carrierStatus   ENUM('ACTIVE', 'INACTIVE')       NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT pk_carrier PRIMARY KEY (carrierID),
    CONSTRAINT uq_carrier_code UNIQUE (carrierCode)
);


-- 5. TransportDeparture
CREATE TABLE TransportDeparture (
    departureID        INT                               NOT NULL,
    departureCode      VARCHAR(20)                       NOT NULL,
    carrierID          INT                               NOT NULL,
    originPortID       INT                               NOT NULL,
    destinationPortID  INT                               NOT NULL,
    transportMode      ENUM('AIR', 'SEA')                NOT NULL,
    departureAt        DATETIME                          NOT NULL,
    estimatedArrivalAt DATETIME                          NOT NULL,
    maxWeightKg        DECIMAL(12,3)                     NOT NULL,
    maxVolumeM3        DECIMAL(12,3)                     NOT NULL,
    reservedWeightKg   DECIMAL(12,3)                     NOT NULL DEFAULT 0.000,
    reservedVolumeM3   DECIMAL(12,3)                     NOT NULL DEFAULT 0.000,
    departureStatus    ENUM('SCHEDULED', 'CLOSED','DEPARTED', 'ARRIVED','CANCELLED') NOT NULL DEFAULT 'SCHEDULED',

    CONSTRAINT pk_transport_departure PRIMARY KEY (departureID),
    CONSTRAINT uq_transport_departure_code UNIQUE (departureCode),
    CONSTRAINT chk_departure_ports CHECK (originPortID <> destinationPortID),
    CONSTRAINT chk_departure_times CHECK (estimatedArrivalAt > departureAt),
    CONSTRAINT chk_departure_max_weight CHECK (maxWeightKg > 0),
    CONSTRAINT chk_departure_max_volume CHECK (maxVolumeM3 > 0),
    CONSTRAINT chk_departure_reserved_weight CHECK (reservedWeightKg BETWEEN 0 AND maxWeightKg),
    CONSTRAINT chk_departure_reserved_volume CHECK (reservedVolumeM3 BETWEEN 0 AND maxVolumeM3),
    CONSTRAINT fk_departure_carrier FOREIGN KEY (carrierID) REFERENCES Carrier (carrierID),
    CONSTRAINT fk_departure_origin_port FOREIGN KEY (originPortID) REFERENCES Port (portID),
    CONSTRAINT fk_departure_destination_port FOREIGN KEY (destinationPortID) REFERENCES Port (portID)
);


-- 6. FreightRate
CREATE TABLE FreightRate (
    rateID                    INT                 NOT NULL,
    originPortID              INT                 NOT NULL,
    destinationPortID         INT                 NOT NULL,
    transportMode             ENUM('AIR', 'SEA')  NOT NULL,
    ratePerChargeableKg       DECIMAL(10,4)       NOT NULL,
    volumetricFactorKgM3      DECIMAL(8,3)        NOT NULL,
    fuelSurchargePct          DECIMAL(5,2)        NOT NULL DEFAULT 0.00,
    dangerousGoodsSurcharge   DECIMAL(12,2)       NOT NULL DEFAULT 0.00,
    insuranceRatePct          DECIMAL(5,2)        NOT NULL DEFAULT 0.00,
    effectiveFrom             DATE                NOT NULL,
    effectiveTo               DATE                    NULL,
    rateStatus                ENUM('ACTIVE', 'INACTIVE')    NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT pk_freight_rate PRIMARY KEY (rateID),
    CONSTRAINT uq_freight_rate_version UNIQUE (originPortID, destinationPortID, transportMode, effectiveFrom),
    CONSTRAINT chk_freight_rate_ports CHECK (originPortID <> destinationPortID),
    CONSTRAINT chk_freight_rate_amount CHECK (ratePerChargeableKg > 0),
    CONSTRAINT chk_freight_rate_volume_factor CHECK (volumetricFactorKgM3 > 0),
    CONSTRAINT chk_freight_rate_fuel_pct CHECK (fuelSurchargePct BETWEEN 0 AND 100),
    CONSTRAINT chk_freight_rate_dg_surcharge CHECK (dangerousGoodsSurcharge >= 0),
    CONSTRAINT chk_freight_rate_insurance_pct CHECK (insuranceRatePct BETWEEN 0 AND 100),
    CONSTRAINT chk_freight_rate_dates  CHECK (effectiveTo IS NULL OR effectiveTo >= effectiveFrom),
    CONSTRAINT fk_freight_rate_origin_port FOREIGN KEY (originPortID) REFERENCES Port (portID),
    CONSTRAINT fk_freight_rate_destination_port FOREIGN KEY (destinationPortID) REFERENCES Port (portID)
);

-- 7. Shipment
CREATE TABLE Shipment (
    shipmentID          INT                                  NOT NULL,
    customerID          INT                                  NOT NULL,
    originPortID        INT                                  NOT NULL,
    destinationPortID   INT                                  NOT NULL,
    transportMode       ENUM('AIR', 'SEA')                   NOT NULL,
    selectedDepartureID INT                                      NULL,
    insuranceRequired   BOOLEAN                              NOT NULL DEFAULT FALSE,
    shipmentStatus      ENUM('DRAFT', 'QUOTED', 'BOOKED',
                             'LOADED', 'DISPATCHED',
                             'IN_TRANSIT', 'DELIVERED',
                             'CANCELLED')                    NOT NULL DEFAULT 'DRAFT',
    createdAt           DATETIME                             NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_shipment PRIMARY KEY (shipmentID),
    CONSTRAINT chk_shipment_ports CHECK (originPortID <> destinationPortID),
    CONSTRAINT chk_shipment_insurance CHECK (insuranceRequired IN (FALSE, TRUE)),
    CONSTRAINT fk_shipment_customer FOREIGN KEY (customerID) REFERENCES Customer (customerID),
    CONSTRAINT fk_shipment_origin_port FOREIGN KEY (originPortID) REFERENCES Port (portID),
    CONSTRAINT fk_shipment_destination_port FOREIGN KEY (destinationPortID) REFERENCES Port (portID),
    CONSTRAINT fk_shipment_departure FOREIGN KEY (selectedDepartureID) REFERENCES TransportDeparture (departureID)
);

-- 8. ShipmentItem
CREATE TABLE ShipmentItem (
    shipmentItemID       INT            NOT NULL,
    shipmentID           INT            NOT NULL,
    itemDescription      VARCHAR(150)   NOT NULL,
    quantity             INT            NOT NULL,
    unitWeightKg         DECIMAL(12,3)  NOT NULL,
    unitVolumeM3         DECIMAL(12,3)  NOT NULL,
    unitDeclaredValue    DECIMAL(12,2)  NOT NULL,
    dangerousGoodsFlag   BOOLEAN        NOT NULL DEFAULT FALSE,
    dangerousGoodsClass  VARCHAR(20)        NULL,

    CONSTRAINT pk_shipment_item PRIMARY KEY (shipmentItemID),
    CONSTRAINT chk_shipment_item_quantity CHECK (quantity > 0),
    CONSTRAINT chk_shipment_item_weight CHECK (unitWeightKg > 0),
    CONSTRAINT chk_shipment_item_volume CHECK (unitVolumeM3 > 0),
    CONSTRAINT chk_shipment_item_value CHECK (unitDeclaredValue > 0),
    CONSTRAINT chk_shipment_item_dangerous_goods CHECK ((dangerousGoodsFlag = FALSE AND dangerousGoodsClass IS NULL)
            OR
            (dangerousGoodsFlag = TRUE AND dangerousGoodsClass IS NOT NULL)
        ),
    CONSTRAINT fk_shipment_item_shipment  FOREIGN KEY (shipmentID) REFERENCES Shipment (shipmentID)
);


-- 9. Quotation
CREATE TABLE Quotation (
    quotationID         INT              NOT NULL,
    shipmentID          INT              NOT NULL,
    rateID              INT              NOT NULL,
    issuedAt            DATETIME         NOT NULL,
    expiresAt           DATETIME         NOT NULL,
    chargeableWeightKg  DECIMAL(12,3)    NOT NULL,
    freightCharge       DECIMAL(12,2)    NOT NULL,
    quotationStatus     ENUM('DRAFT', 'ISSUED', 'ACCEPTED','REJECTED', 'EXPIRED') NOT NULL DEFAULT 'DRAFT',
    acceptedAt          DATETIME             NULL,

    CONSTRAINT pk_quotation PRIMARY KEY (quotationID),
    CONSTRAINT chk_quotation_dates CHECK (expiresAt > issuedAt),
    CONSTRAINT chk_quotation_weight CHECK (chargeableWeightKg > 0),
    CONSTRAINT chk_quotation_charge CHECK (freightCharge > 0),
    CONSTRAINT chk_quotation_acceptance
        CHECK (
            (quotationStatus = 'ACCEPTED' AND acceptedAt IS NOT NULL)
            OR
            (quotationStatus <> 'ACCEPTED' AND acceptedAt IS NULL)
        ),
    CONSTRAINT chk_quotation_acceptance_time CHECK ( acceptedAt IS NULL OR acceptedAt BETWEEN issuedAt AND expiresAt),
    CONSTRAINT fk_quotation_shipment FOREIGN KEY (shipmentID) REFERENCES Shipment (shipmentID),
    CONSTRAINT fk_quotation_freight_rate FOREIGN KEY (rateID) REFERENCES FreightRate (rateID)
);


-- 10. CapacityReservation
CREATE TABLE CapacityReservation (
    shipmentID        INT                         NOT NULL,
    departureID       INT                         NOT NULL,
    reservedWeightKg  DECIMAL(12,3)               NOT NULL,
    reservedVolumeM3  DECIMAL(12,3)               NOT NULL,
    reservationStatus ENUM('ACTIVE', 'RELEASED')  NOT NULL DEFAULT 'ACTIVE',
    reservedAt        DATETIME                    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    releasedAt        DATETIME                        NULL,

    CONSTRAINT pk_capacity_reservation PRIMARY KEY (shipmentID),
    CONSTRAINT chk_reservation_weight CHECK (reservedWeightKg > 0),
    CONSTRAINT chk_reservation_volume CHECK (reservedVolumeM3 > 0),
    CONSTRAINT chk_reservation_release CHECK ((reservationStatus = 'ACTIVE' AND releasedAt IS NULL)
            OR
            (reservationStatus = 'RELEASED' AND releasedAt IS NOT NULL AND releasedAt >= reservedAt)),
    CONSTRAINT fk_reservation_shipment FOREIGN KEY (shipmentID) REFERENCES Shipment (shipmentID),
    CONSTRAINT fk_reservation_departure FOREIGN KEY (departureID) REFERENCES TransportDeparture (departureID)
);


-- 11. DocumentType
CREATE TABLE DocumentType (
    documentTypeID      INT           NOT NULL,
    documentCode        VARCHAR(20)   NOT NULL,
    documentName        VARCHAR(100)  NOT NULL,
    requiresExpiryDate  BOOLEAN       NOT NULL DEFAULT FALSE,

    CONSTRAINT pk_document_type PRIMARY KEY (documentTypeID),
    CONSTRAINT uq_document_type_code UNIQUE (documentCode),
    CONSTRAINT uq_document_type_name UNIQUE (documentName),
    CONSTRAINT chk_document_type_expiry_flag CHECK (requiresExpiryDate IN (FALSE, TRUE))
);


-- 12. DocumentRequirement
CREATE TABLE DocumentRequirement (
    requirementID         INT                 NOT NULL,
    documentTypeID        INT                 NOT NULL,
    originCountryID       INT                     NULL,
    destinationCountryID  INT                     NULL,
    transportMode         ENUM('AIR', 'SEA')      NULL,
    dangerousGoodsOnly    BOOLEAN             NOT NULL DEFAULT FALSE,
    mandatoryFlag         BOOLEAN             NOT NULL DEFAULT TRUE,
    effectiveFrom         DATE                NOT NULL,
    effectiveTo           DATE                    NULL,

    CONSTRAINT pk_document_requirement PRIMARY KEY (requirementID),
    CONSTRAINT chk_document_requirement_countries CHECK ( originCountryID IS NULL
            OR destinationCountryID IS NULL
            OR originCountryID <> destinationCountryID),
    CONSTRAINT chk_document_requirement_dg_flag CHECK (dangerousGoodsOnly IN (FALSE, TRUE)),
    CONSTRAINT chk_document_requirement_mandatory_flag CHECK (mandatoryFlag IN (FALSE, TRUE)),
    CONSTRAINT chk_document_requirement_dates CHECK (effectiveTo IS NULL OR effectiveTo >= effectiveFrom),
    CONSTRAINT fk_document_requirement_type FOREIGN KEY (documentTypeID) REFERENCES DocumentType (documentTypeID),
    CONSTRAINT fk_document_requirement_origin_country FOREIGN KEY (originCountryID) REFERENCES Country (countryID),
    CONSTRAINT fk_document_requirement_destination_country FOREIGN KEY (destinationCountryID) REFERENCES Country (countryID)
);

-- 13. ShipmentDocument
CREATE TABLE ShipmentDocument (
    shipmentDocumentID  INT             NOT NULL,
    shipmentID          INT             NOT NULL,
    documentTypeID      INT             NOT NULL,
    documentReference   VARCHAR(50)     NOT NULL,
    fileName            VARCHAR(255)    NOT NULL,
    submittedAt         DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expiryDate          DATE                NULL,
    documentStatus      ENUM('SUBMITTED', 'APPROVED','REJECTED', 'EXPIRED') NOT NULL DEFAULT 'SUBMITTED',
    decisionAt          DATETIME            NULL,
    decisionBy          VARCHAR(100)        NULL,

    CONSTRAINT pk_shipment_document PRIMARY KEY (shipmentDocumentID),
    CONSTRAINT uq_shipment_document_reference UNIQUE (documentReference),
    CONSTRAINT uq_shipment_document_type UNIQUE (shipmentID, documentTypeID),
    CONSTRAINT chk_shipment_document_decision_pair CHECK ((decisionAt IS NULL AND decisionBy IS NULL)
            OR
            (decisionAt IS NOT NULL AND decisionBy IS NOT NULL)
        ),
    CONSTRAINT chk_shipment_document_decision_time CHECK (decisionAt IS NULL OR decisionAt >= submittedAt),
    CONSTRAINT chk_shipment_document_decision_status CHECK ((documentStatus = 'SUBMITTED'AND decisionAt IS NULL
             AND decisionBy IS NULL) OR (documentStatus IN ('APPROVED', 'REJECTED')
             AND decisionAt IS NOT NULL
             AND decisionBy IS NOT NULL)
            OR
            documentStatus = 'EXPIRED'
        ),
    CONSTRAINT fk_shipment_document_shipment FOREIGN KEY (shipmentID) REFERENCES Shipment (shipmentID),
    CONSTRAINT fk_shipment_document_type FOREIGN KEY (documentTypeID) REFERENCES DocumentType (documentTypeID)
);


-- 14. DocumentAlert
CREATE TABLE DocumentAlert (
    shipmentID      INT                                 NOT NULL,
    documentTypeID  INT                                 NOT NULL,
    alertType       ENUM('MISSING', 'EXPIRING',
                         'EXPIRED')                     NOT NULL,
    alertMessage    VARCHAR(255)                        NOT NULL,
    createdAt       DATETIME(6)                         NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    alertStatus     ENUM('OPEN', 'RESOLVED')            NOT NULL DEFAULT 'OPEN',
    resolvedAt      DATETIME(6)                             NULL,

    CONSTRAINT pk_document_alert PRIMARY KEY (shipmentID, documentTypeID, alertType, createdAt),
    CONSTRAINT chk_document_alert_resolution CHECK ((alertStatus = 'OPEN' AND resolvedAt IS NULL)
            OR (alertStatus = 'RESOLVED' AND resolvedAt IS NOT NULL AND resolvedAt >= createdAt)),
    CONSTRAINT fk_document_alert_shipment FOREIGN KEY (shipmentID) REFERENCES Shipment (shipmentID),
    CONSTRAINT fk_document_alert_type FOREIGN KEY (documentTypeID) REFERENCES DocumentType (documentTypeID)
);


-- 15. Invoice
CREATE TABLE Invoice (
    shipmentID       INT                                  NOT NULL,
    invoiceNumber    VARCHAR(20)                          NOT NULL,
    issuedAt         DATETIME                             NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dueAt            DATETIME                             NOT NULL,
    totalAmount      DECIMAL(12,2)                        NOT NULL,
    adjustmentAmount DECIMAL(12,2)                        NOT NULL DEFAULT 0.00,
    amountPaid       DECIMAL(12,2)                        NOT NULL DEFAULT 0.00,
    invoiceStatus    ENUM('UNPAID', 'PARTIALLY_PAID',
                          'PAID', 'CANCELLED',
                          'REFUND_REQUIRED')              NOT NULL DEFAULT 'UNPAID',

    CONSTRAINT pk_invoice PRIMARY KEY (shipmentID),
    CONSTRAINT uq_invoice_number UNIQUE (invoiceNumber),
    CONSTRAINT chk_invoice_due CHECK (dueAt >= issuedAt),
    CONSTRAINT chk_invoice_total CHECK (totalAmount > 0),
    CONSTRAINT chk_invoice_adjustment CHECK (adjustmentAmount BETWEEN 0 AND totalAmount),
    CONSTRAINT chk_invoice_paid CHECK (amountPaid BETWEEN 0 AND totalAmount),
    CONSTRAINT fk_invoice_shipment FOREIGN KEY (shipmentID) REFERENCES Shipment (shipmentID)
);


-- 16. Payment
CREATE TABLE Payment (
    paymentID        INT                                      NOT NULL,
    shipmentID       INT                                      NOT NULL,
    paymentReference VARCHAR(50)                              NOT NULL,
    paymentAt        DATETIME                                 NOT NULL,
    amount           DECIMAL(12,2)                            NOT NULL,
    paymentMethod    ENUM('CARD', 'BANK_TRANSFER',
                          'BPAY', 'OTHER')                     NOT NULL,
    transCustomeractionType  ENUM('PAYMENT', 'REFUND')                NOT NULL DEFAULT 'PAYMENT',
    paymentStatus    ENUM('PENDING', 'CONFIRMED',
                          'DECLINED', 'REVERSED')              NOT NULL DEFAULT 'PENDING',

    CONSTRAINT pk_payment PRIMARY KEY (paymentID),
    CONSTRAINT uq_payment_reference UNIQUE (paymentReference),
    CONSTRAINT chk_payment_amount CHECK (amount > 0),
    CONSTRAINT fk_payment_invoice FOREIGN KEY (shipmentID) REFERENCES Invoice (shipmentID)
);


-- 17. TrackingEvent
CREATE TABLE TrackingEvent (
    eventReference    VARCHAR(50)  NOT NULL,
    shipmentID        INT          NOT NULL,
    eventType         ENUM('DISPATCHED', 'DEPARTED',
                           'IN_TRANSIT', 'CUSTOMS_HOLD',
                           'CUSTOMS_CLEARED', 'ARRIVED',
                           'DELIVERED', 'EXCEPTION')
                                         NOT NULL,
    eventAt           DATETIME     NOT NULL,
    locationPortID    INT              NULL,
    eventDescription  VARCHAR(255)     NULL,
    recordedAt        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_tracking_event PRIMARY KEY (eventReference),
    CONSTRAINT fk_tracking_event_shipment FOREIGN KEY (shipmentID) REFERENCES Shipment (shipmentID),
    CONSTRAINT fk_tracking_event_location_port FOREIGN KEY (locationPortID) REFERENCES Port (portID)
);


-- 18. ShipmentStatusHistory
CREATE TABLE ShipmentStatusHistory (
    shipmentID   INT                                  NOT NULL,
    changedAt    DATETIME(6)                          NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    oldStatus    ENUM('DRAFT', 'QUOTED', 'BOOKED',
                      'LOADED', 'DISPATCHED',
                      'IN_TRANSIT', 'DELIVERED',
                      'CANCELLED')                    NOT NULL,
    newStatus    ENUM('DRAFT', 'QUOTED', 'BOOKED',
                      'LOADED', 'DISPATCHED',
                      'IN_TRANSIT', 'DELIVERED',
                      'CANCELLED')                    NOT NULL,
    changedBy    VARCHAR(100)                         NOT NULL,
    changeReason VARCHAR(255)                             NULL,

    CONSTRAINT pk_shipment_status_history PRIMARY KEY (shipmentID, changedAt),
    CONSTRAINT chk_shipment_status_history_change CHECK (oldStatus <> newStatus),
    CONSTRAINT fk_shipment_status_history_shipment FOREIGN KEY (shipmentID) REFERENCES Shipment (shipmentID)
);

