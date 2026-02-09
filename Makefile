IMG_TAR_FILE = ../spinalenvfull.tar
IMG_NAME = spinalenvfull:v1.0
PRJ_NAME = MySpinalProj
ENV_NAME = spinalenv
VERILOG_TOP = MyTopLevelVerilog

save_env_image:
	docker save $(IMG_NAME) -o $(IMG_TAR_FILE)

load_env_image:
	docker load -i $(IMG_TAR_FILE)

run_container:
	docker run -d -v .:/home/$(PRJ_NAME) --name $(ENV_NAME) $(IMG_NAME) sleep infinity

sbt_compile:
	docker exec --workdir /home/$(PRJ_NAME) $(ENV_NAME) bash -c "cp -rf ../project . && cp -rf ../target ."
	docker exec --workdir /home/$(PRJ_NAME) $(ENV_NAME) chown -R $(shell id -u):$(shell id -g) project target
	docker exec --workdir /home/$(PRJ_NAME) $(ENV_NAME) sbt "compile"

rm_env:
	-docker stop $(ENV_NAME)
	-docker rm $(ENV_NAME)

build_env: load_env_image run_container sbt_compile

run:
	docker exec --workdir /home/$(PRJ_NAME) $(ENV_NAME) sbt "runMain $(PRJ_NAME).$(VERILOG_TOP)"
	docker exec --workdir /home/$(PRJ_NAME) $(ENV_NAME) chown -R $(shell id -u):$(shell id -g) hw/gen

clean:
	rm -rf hw/gen/*

format:
	docker exec --workdir /home/$(PRJ_NAME) $(ENV_NAME) sbt "scalafmtAll"

check_format:
	docker exec --workdir /home/$(PRJ_NAME) $(ENV_NAME) sbt "scalafmtCheckAll"