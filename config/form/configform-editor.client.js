document.addEventListener('DOMContentLoaded', function() {
    ((INCLUDE_CSS) => {
        if (document.head.innerHTML.indexOf(INCLUDE_CSS) === -1)
            document.head.innerHTML += `<link href="${INCLUDE_CSS}" rel="stylesheet" >`;
    })("config/form/configform.css");
});


class HTMLConfigFormEditorElement extends HTMLElement {
    constructor() {
        super();
        this.state = {
            configList: [],
            status: null,
            message: null,
        };
        // this.state = {id:-1, flags:[]};
    }

    setState(newState) {
        Object.assign(this.state, newState);
        // this.render();
        this.render();
    }

    connectedCallback() {
        this.addEventListener('change', this.onEvent);
        this.addEventListener('keyup', this.onEvent);
        this.addEventListener('submit', this.onEvent);
        this.render();
        this.requestFormData();
        // this.submit();
    }

    onSuccess(e, response) {
        // if(response.redirect)
        //     setTimeout(() => window.location.href = response.redirect, 3000);
    }
    onError(e, response) {}

    onEvent(e) {
        switch (event.type) {
            case 'submit':
                this.submit(e);
                break;

            case 'keyup':
                // this.requestFormData(e);
                if(e.target.name === 'search')
                    this.renderResults();
                this.checkSubmittable();
                break;

            case 'change':
                this.checkSubmittable();
                // this.state.configs[e.target.name] = e.target.value;
                // this.setState({submittable: true});
                break;
        }
    }

    checkSubmittable() {
        const form = this.querySelector('form');

        let disabled = true;
        const configChanges = {};
        for(let i=0; i<this.state.configList.length; i++) {
            const configItem = this.state.configList[i];
            const formElm = form && form.elements[configItem.name] ? form.elements[configItem.name] : null;
            if(formElm && (configItem.value||'') !== formElm.value) {
                // console.log(configItem.name, configItem.value, formData[configItem.name]);
                disabled = false;
                configChanges[configItem.name] = formElm.value;
            }
        }
        const btnSubmit = this.querySelector('button[type=submit]');
        if(disabled)    btnSubmit.setAttribute('disabled', 'disabled');
        else            btnSubmit.removeAttribute('disabled');
        return configChanges;
    }


    requestFormData() {
        const xhr = new XMLHttpRequest();
        xhr.onload = () => {
            this.setState(Object.assign({
                processing: false,
                status: xhr.status,
            }, xhr.response));
        };
        xhr.responseType = 'json';
        xhr.open ("GET", `:config/:json?getAll=true`, true);
        // xhr.setRequestHeader("Accept", "application/json");
        xhr.send ();
        this.setState({processing: true});
    }

    submit(e) {
        if(e)
            e.preventDefault();
        const form = this.querySelector('form');
        const configChanges = this.checkSubmittable();

        const xhr = new XMLHttpRequest();
        xhr.onload = (e) => {
            const response = Object.assign({
                processing: false,
                status: xhr.status,
            }, xhr.response);
            this.setState(response);

            if(xhr.status === 200) {
                this.onSuccess(e, response);
            } else {
                this.onError(e, response);
            }
        };
        xhr.open(form.getAttribute('method'), form.getAttribute('action'), true);
        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        // xhr.setRequestHeader("Accept", "application/json");
        xhr.responseType = 'json';
        xhr.send(JSON.stringify(configChanges));
        this.setState({processing: true});
    }

    render() {
        const form = this.querySelector('form');
        console.log("RENDER", this.state);
        let searchField = this.querySelector('input[name=search]');
        const selectionStart = searchField ? searchField.selectionStart : null;
        this.innerHTML =
        `<form action="/:config/:edit" method="POST" class="configform configform-editor themed">
            <fieldset ${this.state.processing ? 'disabled="disabled"' : null}>
                <table>
                    <thead>
                        <tr>
                            <td colspan="4">
                                <input type="text" name="search" placeholder="Search Configs" value="${form ? form.search.value||'' : ''}"/>
                            </td>
                        </tr>
                        <tr><td colspan="4"><hr/></td></tr>
                        <tr>
                            <th>Name</th>
                            <th>Value</th>
                        </tr>
                    </thead>
                    <tbody class="results">
                        <tr>
                            <th colspan="4">No Results</th>
                        </tr>
                    </tbody>
                    <tfoot>
                        <tr><td colspan="2"><hr/></td></tr>
                        <tr>
                            <td colspan="2" style="text-align: right;">
                                <button type="submit" disabled>Update Config</button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" class="status">
                                <div class="message">Config Editor</div> 
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </fieldset>
        </form>`;
        searchField = this.querySelector('input[name=search]');
        searchField.focus();
        if(selectionStart)
            searchField.selectionStart = selectionStart;
        this.renderResults();
        this.checkSubmittable();
    }

    renderResults() {
        const form = this.querySelector('form');
        // const formData = this.getFormData();
        const resultsElement = this.querySelector('tbody.results');
        let classOdd = '';
        const search = form ? form.search.value : null;
        resultsElement.innerHTML = this.state.configList
            .filter(config => !search || config.name.indexOf(search) !== -1)
            .map(config => `
            <tr class="results ${classOdd=classOdd===''?'odd':''}">
                <td>${config.name}</td>
                <td>${this.renderConfig(config, form && form.elements[config.name] ? form.elements[config.name].value : null)}</td>
            </tr>
            `).join('');

        const statusElement = this.querySelector('td.status');
        statusElement.innerHTML = this.state.message
            ? `<div class="${this.state.status === 200 ? 'message' : 'error'}">${this.state.message}</div>`
            : `<div class="message">Config Editor</div>`;
    }

    renderConfig(config, value=null) {
        if(value === null)
            value = config.value;
        switch(config.type) {
            default:
                return `<input type='text' name='${config.name}' value='${value||''}' />`;
            case 'text':
            case 'email':
            case 'checkbox':
            case 'password':
                return `<input type='${config.type}' name='${config.name}' value='${value||''}' />`;
            case 'textarea':
                return `<textarea name='${config.name}'>${value||''}</textarea>`;
        }
    }
}
customElements.define('configform-editor', HTMLConfigFormEditorElement);