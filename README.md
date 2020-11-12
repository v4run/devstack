# devstack

This is a bootstrap script I use when working on projects with multiple services. The project relies on [docker-compose](https://docs.docker.com/compose/). It basically creates a replacement docker-compose command which includes all the docker-compose files of the individual services. It also includes a provision to select a subset of available services to work with.

## How to run

* Init using the following command. This will create a directory structure and and empty docker-compose.yml file for the services.

    ```bash
    devstack init service_1 ... service_n
    ```

* Complete the generated docker-compose files

* Run the following command and provide the necessary inputs. This will generate a replacement docker-compose executable file.

    ```bash
    devstack update
    ```

* Run the generated *docker-compose* file as you would normally do with the original docker-compose command
    eg.

    ```bash
    ./docker-compose up -d ## instead of docker-compose up -d
    ```

## Adding new service

* ```bash
  devstack init new_service_1 ... new_service_n
  ```

* Remaining steps are same as above

## NOTES

* Requires [*whiptail*](https://linux.die.net/man/1/whiptail).
* In osx, install [*newt*](https://formulae.brew.sh/formula/newt).

    ```brew
    brew install newt
    ```
