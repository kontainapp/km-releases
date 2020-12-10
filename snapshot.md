## Snapshot Overview

A KM snapshot is a file that contains a point-in-time image of a running KM guest process. When a KM process is resumed, the guest process continues from the point where the snapshot was taken.

There are two ways to create KM snapshots:

- Internal: the guest program links with the KM API and calls `snapshot.take()`.
- External: an external agent uses the `km_cli` command to create a snapshot.

A KM snapshot file is an ELF format core file with KM specific records in the NOTES section. This means that KM snapshot files can be read by standard `binutil` tools. 