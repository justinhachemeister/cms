const fs = require('fs');
const path = require('path');
const express = require('express');

const { LocalConfig } = require('../config/local.config');

const { DatabaseManager } = require('../database/database.manager');
const { UserAPI } = require('../user/user.api');
const { ArticleAPI } = require('../article/article.api');
const { FileAPI } = require('../file/file.api');

const BASE_DIR = path.resolve(path.dirname(__dirname));

class APIServer {
    constructor() {
        this.router = null;
    }

    async configure(interactive=false, config=null) {
        const localConfig = new LocalConfig(interactive, config, !config);
        const serverConfig = await localConfig.get('server');
        // let saveConfig = false;
        // if(!configCallback) {
        //     saveConfig = true;
        // }
        // if(typeof config.server === "undefined")      config.server = {};
        // if(typeof config.server.port === "undefined") config.server.port = 8080;
        // if(typeof config.database === "undefined")      config.database = {};
        // Init Database

        // hostname = (hostname || require('os').hostname()).toLowerCase();
        // if(typeof globalConfig.server.session === 'undefined') {
        //     globalConfig.server.session = {};
        // }

        if(!serverConfig.port)  await localConfig.promptValue('server.port', `Please enter the Server Port`, 8080);


        await DatabaseManager.configure(interactive);
        await UserAPI.configure(interactive);
        await ArticleAPI.configure(interactive);
        await FileAPI.configure(interactive);

        const router = express.Router();
        // Routes
        router.use(UserAPI.getMiddleware());
        router.use(ArticleAPI.getMiddleware());
        router.use(FileAPI.getMiddleware());

        // CMS Asset files
        router.use(express.static(BASE_DIR));
        this.router = router;
        return serverConfig;
    }

    getMiddleware() {
        if(!this.router)
            this.configure(false);

        return (req, res, next) => {
            return this.router(req, res, next);
        }
    }

    async listen(ports=null) {
        const config = await this.configure(true);
        if(!ports)
            ports = config.port;
        const app = express();
        app.use(this.getMiddleware());

        // HTTP
        ports = Array.isArray(ports) ? ports : [ports];
        for(let i=0; i<ports.length; i++) try {
            app.listen(ports[i]);
            console.log(`Listening on ${ports[i]}`);
        } catch (e) {
            console.log(`Could not listen on ${ports[i]}: ${e.message}`);
        }
        return app;
    }
}

exports.APIServer = new APIServer();
