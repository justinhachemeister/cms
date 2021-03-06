{
    function loadCSS() {
        ((INCLUDE_CSS) => {
            if (document.head.innerHTML.indexOf(INCLUDE_CSS) === -1)
                document.head.innerHTML += `<link href="${INCLUDE_CSS}" rel="stylesheet" >`;
        })(":content/:client/nav/content-nav.css");
    }

    const DEFAULT_PATHS = '/;/article;/upload;/about';
    class ThemeDefaultNavMenu extends HTMLElement{
        constructor() {
            super();
            this.state = {
                src: '/:content/:json',
                paths: ['/','/about','/upload','/contact'],
                // userID: null,
                menu: []
            };
            loadCSS();
            // this.state = {id:-1, flags:[]};
        }

        setState(newState) {
            for(let i=0; i<arguments.length; i++)
               Object.assign(this.state, arguments[i]);
            this.render();
        }


        connectedCallback() {
            // this.addEventListener('change', e => this.onChange(e));
            // this.addEventListener('submit', e => this.onSubmit(e));

            this.render();

            let paths = this.getAttribute('paths');
            if(paths) {
                paths = paths.split(/[,;]/g).filter(p => !!p);
                this.setState({paths});
            } else {
            }
            // if(userID)
            //     this.setState({userID});
            this.requestFormData();
        }

        requestFormData() {
            const xhr = new XMLHttpRequest();
            xhr.onload = () => {
                const response = typeof xhr.response === 'object' ? xhr.response : {message: xhr.response};
                this.setState({processing: false}, response);
            };
            xhr.responseType = 'json';
            xhr.open ('GET', this.state.src, true);
            xhr.send ();
            this.setState({processing: true});
        }

        buildMenu() {
            let menu = [];
            if(this.state.contentList) {
                let rootPaths = this.state.paths.slice();
                // for (let i = 0; i < this.state.contentList.length; i++) {
                //     const contentEntry = this.state.contentList[i];
                //     if (!contentEntry.path)
                //         continue;
                //
                //     const rootPath = '/' + contentEntry.path.split('/')[1].split(/\W/g)[0];
                //     if (rootPaths.indexOf(rootPath) === -1)
                //         rootPaths.push(rootPath);
                // }

                console.log("TODO: ", this.state.paths, rootPaths, this.innerHTML);

                menu = rootPaths.map(rootPath => {
                    const menuEntry = {title:null, path: rootPath, content: null, subMenu: []};
                    for (let i = 0; i < this.state.contentList.length; i++) {
                        const contentEntry = this.state.contentList[i];
                        if (!contentEntry.path)
                            continue;

                        if (contentEntry.path === rootPath) {
                            menuEntry.content = contentEntry;
                        } else if (contentEntry.path.indexOf(rootPath) === 0) {
                            if (rootPath !== '/')
                                menuEntry.subMenu.push(contentEntry);
                        }
                    }
                    if(menuEntry.content)
                        menuEntry.title = menuEntry.content.title;
                    else
                        menuEntry.title = menuEntry.path.replace('/', '').replace(/[_-]+/g, ' ').replace(/^([a-z])|\s+([a-z])/g, function ($1) {
                            return $1.toUpperCase();
                        });
                    return menuEntry;
                });
            }


            const contentID = (document.head.querySelector('meta[name="content:id"]') || {}).content || null;
//             console.log(menu, rootPaths, this.state.contentList);
            const menuSubMenu = [];
            menu.push({
                title: 'Menu',
                path: '#',
                subMenu: menuSubMenu
            });

            if(contentID) {
                menuSubMenu.push({
                    path: `/:content/${contentID}/:edit`,
                    title: 'Edit Page Content',
                });
                menuSubMenu.push('<hr/>');
            }

            // Check for log in session userID
            const userID = (document.head.querySelector('meta[name="session:userID"]') || {}).content || null;

            if(userID) {
                menuSubMenu.push({
                    path: `/:user/${userID}`,
                    title: 'My Profile',
                });
                menuSubMenu.push({
                    path: `/:user/${userID}/:edit`,
                    title: 'Edit Profile',
                });
                menuSubMenu.push({
                    path: `/:user/:logout`,
                    title: 'Log Out',
                });

            } else {
                menuSubMenu.push({
                    path: '/:user/:login',
                    title: 'Log In',
                });
                menuSubMenu.push({
                    path: '/:user/:register',
                    title: 'Register'
                });
            }
            menuSubMenu.push('<hr/>');

            menuSubMenu.push({
                path: '/:user',
                title: 'Browse Users'
            });
            menuSubMenu.push({
                path: '/:task',
                title: `Browse Tasks`
            });
            menuSubMenu.push({
                path: '/:content',
                title: 'Site Index'
            });
            menuSubMenu.push({
                path: '/:config',
                title: 'Configure Site'
            });


            return menu;
        }
        
        render() {
            const menu = this.buildMenu();
//             console.log("RENDER", this.state, menu);
            this.innerHTML =
                `
                <ul class="nav-menu">
                    ${menu.map(menuItem => `
                    <li>
                        <a href="${menuItem.path}">${menuItem.title}</a>
                        ${menuItem.subMenu && menuItem.subMenu.length === 0 ? `` : `
                        <ul class="nav-submenu">
                            ${menuItem.subMenu.map(subMenuItem => {
                                if(typeof subMenuItem === "string")
                                    return subMenuItem;
            
                                return `<li><a href="${subMenuItem.path}">${subMenuItem.title}</a></li>`;
                            }).join('')}
                        </ul>
                        `}
                    </li>
                    `).join('')}
                </ul>
`;
        }
    }
    customElements.define('content-nav', ThemeDefaultNavMenu);

}


// TODO: live load articles
// (function() {
//
//     window.addEventListener('hashchange', onHashChange);
//
//     function onHashChange(e) {
//         const hash = window.location.hash.substr(1);
//         if(hash) {
//             document.querySelectorAll('article.page-view').forEach(function (articleElm) {
//                 articleElm.classList.toggle('selected', articleElm.getAttribute('data-path') === hash);
//             });
//             if(!document.querySelector('article.page-view.selected'))
//                 document.querySelector('article.page-view-default').classList.toggle('selected');
//             e.preventDefault();
//         }
//     }
//     document.addEventListener('DOMContentLoaded', onHashChange);
// })()