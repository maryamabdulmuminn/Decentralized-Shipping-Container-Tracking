# Decentralized Shipping Container Tracking System

A blockchain-based solution for transparent, secure, and efficient tracking of shipping containers throughout the global supply chain.

## Overview

This system leverages blockchain technology to revolutionize container shipping logistics by providing an immutable record of container movements, condition monitoring, and customs documentation. By creating a decentralized platform for all stakeholders in the shipping industry, we enable unprecedented visibility, efficiency, and trust in global trade operations.

## Core Components

### Container Registration Contract

Establishes the digital identity for shipping containers:
- Container specifications (size, type, capacity, manufacturing details)
- Ownership and leasing information
- Unique container identifiers (BIC codes)
- Maintenance history and certification records
- Insurance documentation
- Expected lifespan and depreciation tracking
- Digital twin creation for virtualized container management

### Location Tracking Contract

Monitors container movements throughout the supply chain:
- GPS and port-based location updates
- Estimated and actual arrival/departure times
- Route visualization and deviation alerts
- Dwell time tracking at ports and terminals
- Intermodal transfer verification (ship to rail to truck)
- Geofencing capabilities for restricted areas
- Historical movement data for pattern analysis

### Condition Monitoring Contract

Tracks environmental factors and container status:
- Temperature and humidity monitoring
- Shock/impact detection
- Door security status
- Cargo weight verification
- Gas/contaminant detection for specialized cargo
- Power status for refrigerated containers
- Threshold alerts for condition violations
- Integration with IoT sensors and data feeds

### Customs Clearance Contract

Manages documentation for international shipping:
- Digital Bill of Lading
- Customs declaration forms
- Phytosanitary certificates
- Certificate of origin
- Dangerous goods documentation
- Import/export licenses
- Verification of document authenticity
- Multi-jurisdictional compliance tracking

## Getting Started

### Prerequisites

- Node.js (v16.0+)
- Truffle or Hardhat development framework
- Web3 wallet for blockchain interactions
- IoT device integration capabilities
- GPS tracking system compatibility

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/container-tracking.git
cd container-tracking

# Install dependencies
npm install

# Compile smart contracts
npx truffle compile
# or
npx hardhat compile
```

### Deployment

```bash
# Deploy to testnet
npx truffle migrate --network goerli
# or
npx hardhat run scripts/deploy.js --network goerli

# Deploy to mainnet
npx truffle migrate --network mainnet
# or
npx hardhat run scripts/deploy.js --network mainnet
```

## Usage Examples

### For Container Owners/Leasing Companies

```javascript
// Register a new container
await containerRegistrationContract.registerContainer(
  "MSCU1234567", // BIC code
  "Standard 40ft High Cube", // Container type
  manufacturingDate,
  certificationDetails,
  ownershipDetails,
  { from: ownerAddress }
);

// Update container maintenance record
await containerRegistrationContract.addMaintenanceRecord(
  containerId,
  maintenanceDate,
  "Structural inspection and repair",
  "ipfs://QmXgbTyCRSzXKGbEJUg4SX8soWgFSQRVJKobjxpo8Kdj8j", // Documentation hash
  nextInspectionDate,
  { from: authorizedServiceProvider }
);
```

### For Shipping Companies

```javascript
// Record container loading
await locationTrackingContract.recordContainerAction(
  containerId,
  "LOADED",
  "Port of Singapore",
  coordinates,
  timestamp,
  vesselId,
  { from: authorizedPortOperator }
);

// Update container position during voyage
await locationTrackingContract.updateContainerPosition(
  containerId,
  newCoordinates,
  timestamp,
  estimatedArrivalTime,
  { from: authorizedShippingCompany }
);
```

### For IoT Device Integration

```javascript
// Record temperature reading
await conditionMonitoringContract.recordTemperature(
  containerId,
  temperatureReading,
  timestamp,
  { from: authorizedIoTDevice }
);

// Trigger environmental alert
await conditionMonitoringContract.triggerAlert(
  containerId,
  "TEMPERATURE_EXCEEDED",
  temperatureValue,
  timestamp,
  { from: authorizedIoTDevice }
);
```

### For Customs Authorities

```javascript
// Submit customs declaration
await customsClearanceContract.submitDeclaration(
  containerId,
  "IMPORT",
  "United States",
  declarationDetails,
  "ipfs://QmYbTcRZMGnSj9jWxsmxQRijbKBbJLCUGZmUYb3QJxNRnD", // Documentation hash
  { from: authorizedCustomsBroker }
);

// Approve customs clearance
await customsClearanceContract.approveCustomsClearance(
  containerId,
  declarationId,
  "RELEASED",
  inspectionNotes,
  timestamp,
  { from: customsAuthorityAddress }
);
```

## System Architecture

The system architecture consists of four primary smart contracts that interact with each other:

1. **ContainerRegistration**: Establishes container identity and serves as the foundation
2. **LocationTracking**: Monitors movements throughout the supply chain
3. **ConditionMonitoring**: Tracks environmental conditions and container status
4. **CustomsClearance**: Manages documentation and regulatory compliance

The system leverages:
- IoT devices for real-time condition monitoring
- GPS and AIS (Automatic Identification System) for location tracking
- IPFS for decentralized storage of documentation
- Oracles for external data validation
- Zero-knowledge proofs for sensitive commercial information

## Interfaces and Integration

### Mobile Application

Features:
- Container tracking and visualization
- Push notifications for status changes
- Document scanning and submission
- Environmental condition monitoring
- Incident reporting and resolution tracking

### Enterprise Dashboard

Features:
- Fleet management and analytics
- Customs compliance monitoring
- Exception management and alerts
- Performance metrics and KPIs
- Predictive ETA calculations
- Integration with existing TMS/ERP systems

### API Integration

The system provides RESTful APIs for integration with:
- Terminal Operating Systems (TOS)
- Warehouse Management Systems (WMS)
- Transportation Management Systems (TMS)
- Enterprise Resource Planning (ERP) systems
- Customs Single Window platforms
- Port Community Systems

## Key Benefits

- **Enhanced Visibility**: Real-time tracking and condition monitoring
- **Improved Security**: Tamper-evident records and cargo integrity verification
- **Increased Efficiency**: Streamlined documentation and customs processes
- **Reduced Disputes**: Immutable record of container handling and condition
- **Lower Insurance Costs**: Better risk management and incident documentation
- **Regulatory Compliance**: Simplified adherence to international regulations
- **Data Analytics**: Rich datasets for optimizing supply chain operations

## Roadmap

- **Phase 1**: Core smart contract development and testing
- **Phase 2**: IoT device integration and mobile application development
- **Phase 3**: Enterprise dashboard and analytics platform
- **Phase 4**: Integration with major shipping lines and port authorities
- **Phase 5**: Customs authority integration and international expansion
- **Phase 6**: Advanced features (predictive analytics, carbon footprint tracking)

## Security Considerations

- Role-based access control for different stakeholders
- Encrypted transmission of sensitive data
- Tamper-proof IoT device integration
- Regular security audits of smart contracts
- Privacy-preserving computation for competitive information
- Multi-signature requirements for critical operations

## Legal Considerations

This system is designed to comply with:
- International Maritime Organization (IMO) regulations
- World Customs Organization (WCO) standards
- Electronic Bill of Lading regulations
- Data protection and privacy laws
- Cross-border data transfer requirements
- Electronic signature validity in shipping documentation

## Contributing

We welcome contributions from shipping industry experts, blockchain developers, and IoT specialists. Please read our contributing guidelines before submitting pull requests.

## License

This project is licensed under the Apache License 2.0 - see the LICENSE file for details.

## Contact

For questions, support, or partnership inquiries, please contact the development team at dev@containertracking.com
