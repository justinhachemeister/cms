const express = require('express');
const path = require('path');

const { HTTPServer } = require('../http/http.server');
const { DatabaseManager } = require('../database/database.manager');
const { ContentRenderer } = require('../content/content.renderer');
const { ConfigDatabase } = require("./config.database");
const { UserTable } = require("../user/user.table");
// const { ContentAPI } = require('../content/content.api');
const { UserAPI } = require('../user/user.api');
const { SessionAPI } = require('../user/session/session.api');

const DIR_CONFIG = path.resolve(__dirname);

class ConfigAPI {
    get ContentAPI() { return require('../content/content.api').ContentAPI; }
    constructor() {
    }


    getMiddleware() {
        // Configure Routes
        const router = express.Router();
        router.use(express.urlencoded({ extended: true }));
        router.use(express.json());
        router.use(SessionAPI.getMiddleware());

        // Handle Config requests
        router.get('/[:]config/[:]json',                    async (req, res) => await this.renderConfigJSON(req, res));
        router.all('/[:]config(/[:]edit)?',                 async (req, res) => await this.renderConfigEditor(req, res));

        // User Asset files
        router.get('/[:]config/[:]client/*',                async (req, res, next) => await this.handleConfigStaticFiles(req, res, next));


        return (req, res, next) => {
            if(!req.url.startsWith('/:config'))
                return next();
            return router(req, res, next);
        }
    }

    async handleConfigStaticFiles(req, res, next) {
        const routePrefix = '/:config/:client/';
        if(!req.url.startsWith(routePrefix))
            throw new Error("Invalid Route Prefix: " + req.url);
        const assetPath = req.url.substr(routePrefix.length);

        const staticFile = path.resolve(DIR_CONFIG + '/client/' + assetPath);
        await this.ContentAPI.renderStaticFile(req, res, next, staticFile);
    }

    async renderConfigJSON(req, res) {
        try {
            const database = await DatabaseManager.selectDatabaseByRequest(req);
            const userTable = new UserTable(database);
            const configDB = new ConfigDatabase(database);
            const sessionUser = req.session && req.session.userID ? await userTable.fetchUserByID(req.session.userID) : null;
            if(!sessionUser || !sessionUser.isAdmin())
                throw new Error("Not authorized");

            // Handle POST
            const configList = await configDB.selectAllConfigValues();
            const configValues = configDB.parseConfigValues(configList);

            return res.json({
                message: `${configList.length} Config${configList.length !== 1 ? 's' : ''} queried successfully`,
                config: configValues,
                configList,
            });
        } catch (error) {
            await this.renderError(error, req, res, true);
        }
    }

    async renderConfigEditor(req, res) {
        try {
            const database = await DatabaseManager.selectDatabaseByRequest(req);
            const userTable = new UserTable(database);
            const configDB = new ConfigDatabase(database);
            const configList = await configDB.selectAllConfigValues();
            const configValues = configDB.parseConfigValues(configList);

            const sessionUser = req.session && req.session.userID ? await userTable.fetchUserByID(req.session.userID) : null;

            switch(req.method) {
                case 'GET':
                    await ContentRenderer.send(req, res,{
                        title: `Edit Site Config`,
                        data: `<config-editor></config-editor>`
                    });
                    break;

                default:
                case 'OPTIONS':

                    return res.json({
                        message: `${configList.length} Config${configList.length !== 1 ? 's' : ''} queried successfully`,
                        editable: !!sessionUser && sessionUser.isAdmin(),
                        config: configValues,
                        configList,
                    });

                case 'POST':
                    if(!sessionUser || !sessionUser.isAdmin())
                        throw new Error("Not authorized");

                    // Handle POST
                    const database = await DatabaseManager.selectDatabaseByRequest(req);
                    const configDB = new ConfigDatabase(database);
                    let affectedRows = 0;
                    for(let i=0; i<configList.length; i++) {
                        const configName = configList[i].name;
                        if(typeof req.body[configName] !== 'undefined' && req.body[configName] !== configList[i].value) {
                            affectedRows += await configDB.updateConfigValue(configName, req.body[configName])
                        }
                    }

                    return res.json({
                        message: `<div class='success'>${affectedRows.length} config setting${affectedRows.length !== 1 ? 's' : ''} updated successfully</div>`,
                        affectedRows,
                        configList
                    });
            }
        } catch (error) {
            await this.renderError(error, req, res);
        }
    }


    async renderError(error, req, res, json=null) {
        console.error(`${req.method} ${req.url}:`, error);
        res.status(400);
        if(error.redirect) {
            res.redirect(error.redirect);
        } else if(req.method === 'GET' && !json) {
            await ContentRenderer.send(req, res, `<section class='error'><pre>${error.stack}</pre></section>`);
        } else {
            res.json(Object.assign({}, {
                message: error.message,
                error: error.stack,
                code: error.code,
            }, json));
        }
    }
}


module.exports = {ConfigAPI: new ConfigAPI()};

