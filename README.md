# devstack

This is a bootstrap script I use when working on projects with multiple services. The project relies on [docker-compose](https://docs.docker.com/compose/). It basically combines the different docker-compose.yml files of individual services into a new file. It also allows us to enable or disable individual services.

## How to run

* Init using the following command. This will create a directory structure and and empty docker-compose.yml file for the services. If the services were added manually, run the command without any services just to create the necessary directory structure.

    ```bash
    devstack init [service_1 ... service_n]
    ```

* Complete the generated docker-compose files with project specific details

* Run the following command and provide the necessary inputs. This will generate the combined docker-compose.yml file.

    ```bash
    devstack update
    ```

* If some changes are made in the files of already enabled services, run the following command to recreate the docker-compose.yml file

    ```bash
    devstack reload
    ```

## Replacements

The script does the following replacements in all of the files in *available_services* directory
| Placeholder     | With                                                      |
|-----------------|-----------------------------------------------------------|
| ${PROJECT_DIR}  | The path to the source code of the service                |
| ${SERVICE_DIR}  | The path to the enabled services directory of the service |
| ${SERVICE_NAME} | The name of the service                                   |

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
