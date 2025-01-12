#!/usr/bin/env bash


#使用说明
usage() {
	echo "Usage:	./deploy COMMAND"
	echo ""
	echo "【GAF应用部署程序】"
	echo ""
	echo "Commands:"
	echo "  help          查看帮助"
	echo "  all           一键部署所有GAF应用"
	echo "  delete-all    一键删除所有GAF应用以及挂载卷"
}

workspace() {
    #设置工作目录
    export Root_Current_Dir=$(cd `dirname $0`;pwd)
    cd $Root_Current_Dir
    #命令文件权限
    find $Root_Current_Dir -name "*.sh"|xargs chmod +x
    #加载GAF函数
    source $Root_Current_Dir/bin/gaf-func.sh
    #加载环境变量
    source $Root_Current_Dir/.env
}

#一键部署所有GAF应用
all() {
    set -euo pipefail
    #设置工作目录
    workspace

    #检查命令
    check_commands

    #创建docker网络
    create_docker_network gaf-net

    #创建挂载卷
    mkdir -p ${GAF_VOL_DIR}

    #拷贝挂载数据
    cp -rf $Root_Current_Dir/data/vol/. ${GAF_VOL_DIR}
    cp -rf $Root_Current_Dir/conf/GAF_ENV_CONFIG.env ${GAF_VOL_DIR}

    #替换GAF_ENV_CONFIG.env里的变量
    sed_config_env

    #构建打包所有GAF应用
    build_all

    #启动GAF基础环境数据存储应用
    docker-compose up -d gaf-postgres gaf-redis gaf-minio gaf-s3fs-mount gaf-elasticsearch gaf-fluentd-es gaf-zipkin

    #添加数据库数据
    load_db_data

    #启动GAF基础环境监控应用
    docker-compose up -d gaf-cadvisor gaf-node-exporter gaf-prometheus gaf-grafana

    #修改某些挂载卷的权限
    edit_vol_permission

    #启动GAF应用
    docker-compose up -d gaf-microservice-rigister gaf-microservice-conf gaf-microservice-api gaf-microservice-gateway gaf-sys-mgt gaf-authentication gaf-authority gaf-microservice-governance gaf-portal gaf-map gaf-data-mgt gaf-storage gaf-monitor gaf-analysis gaf-webapp gaf-mapapp

    #提示
    echo "启动GAF成功！！！GAF地址：http://${HOSTIP}:30777"
}

#一键删除所有GAF应用及挂载
delete-all() {
    #设置工作目录
    workspace
    #关闭容器，删除容器，删除镜像
    docker-compose down -v --rmi local
    #删除挂载
    rm -rf ${GAF_VOL_DIR}
}

#命令判断
case "$1" in
"help")
	usage
;;
"all")
    all
;;
"delete-all")
    delete-all
;;
*)
	usage
	exit 1
;;
esac


