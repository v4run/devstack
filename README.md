# devstack

This is a bootstrap script I use when working on projects with multiple services. The project relies on [docker-compose](https://docs.docker.com/compose/). It basically creates a replacement docker-compose command which includes all the docker-compose files of the individual services. It also includes a provision to select a subset of available services to work with. This script expects the following directory structure.

```bash
├── available_services
│   ├── <service_1>
│   │   ├── <service specific file_1>
│   │   ├── <service specific file_2>
│   │   ├── ...
│   │   ├── ...
│   │   ├── <service specific file_n>
│   │   └── docker-compose.yml
│   ├── ...
│   ├── ...
│   └── <service_n>
│       ├── <service specific file_1>
│       ├── ...
│       ├── ...
│       ├── <service specific file_n>
│       └── docker-compose.yml
└── init.sh
```

## How to run

* Place the docker-compose files in the `available_services` directory with separate directory for each service
* Run the script (`./init.sh`)
* Run the generated *docker-compose* file as you would normally do with the original docker-compose command (`./docker-compose` instead of `docker-compose`)
    eg.

    ```bash
    ./docker-compose up -d ## instead of docker-compose up -d
    ```

## Adding new service

* Add a new directory in `available_services` for the service
* Add the docker-compose file in the directory
* Run `./init.sh` again and select the new service

## NOTES

* Requires `whiptail`. Tested only in Ubuntu.
