document.addEventListener('DOMContentLoaded', function() {
    ((INCLUDE_CSS) => {
        if (document.head.innerHTML.indexOf(INCLUDE_CSS) === -1)
            document.head.innerHTML += `<link href="${INCLUDE_CSS}" rel="stylesheet" >`;
    })(":user/:client/form/user-form.css");
});

{
    class HTMLUserLogoutElement extends HTMLElement{
        constructor() {
            super();
            this.state = {
                message: "In order to end your session, please hit 'Log out' below",
                status: 0,
                email: "",
                password: ""
            };
            // this.state = {id:-1, flags:[]};
        }

        setState(newState) {
            for(let i=0; i<arguments.length; i++)
               Object.assign(this.state, arguments[i]);
            this.render();
        }


        connectedCallback() {
            this.addEventListener('change', e => this.onChange(e));
            this.addEventListener('submit', e => this.onSubmit(e));

            this.render();
            this.state.userID = this.getAttribute('userID');
        }


        onSuccess(e, response) {
            console.log(response);
            if(response.redirect) {
                this.setState({processing: true});
                setTimeout(() => window.location.href = response.redirect, 3000);
            }
        }

        onError(e, response) {
            console.error(e, response);
        }

        onChange(e) {
            if(typeof this.state[e.target.name] !== 'undefined')
                this.state[e.target.name] = e.target.value;
        }


        onSubmit(e) {
            e.preventDefault();
            const form = e.target;
            const formValues = Array.prototype.filter
                .call(form ? form.elements : [], (input, i) => !!input.name && (input.type !== 'checkbox' || input.checked))
                .map((input, i) => input.name + '=' + encodeURI(input.value))
                .join('&');
            const method = form.getAttribute('method');
            const action = form.getAttribute('action');

            const xhr = new XMLHttpRequest();
            xhr.onload = (e) => {
                const response = typeof xhr.response === 'object' ? xhr.response : {message: xhr.response};
                this.setState({processing: false, status: xhr.status}, response);
                if(xhr.status === 200) {
                    this.onSuccess(e, response);
                } else {
                    this.onError(e, response);
                }
            };
            xhr.open(method, action, true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.responseType = 'json';
            xhr.send(formValues);
            this.setState({processing: true});
        }

        render() {
            // console.log("STATE", this.state);
            this.innerHTML =
                `
                <form action="/:user/:logout" method="POST" class="user user-form-logout themed">
                    <table class="user themed">
                        <caption>Log Out</caption>
                        <thead>
                            <tr>
                                <td colspan="2">
                                    <div class="${this.state.status === 200 ? 'success' : (!this.state.status ? 'message' : 'error')} status-${this.state.status}">
                                        ${this.state.message}
                                    </div>
                                </td>
                            </tr>
                        </thead>
                        <tfoot>
                            <tr><td colspan="2"><hr/></td></tr>
                            <tr>
                                <td>
                                </td>
                                <td style="text-align: right;">
                                    <button type="submit" ${this.state.processing ? 'disabled="disabled"' : null}>Log Out</button>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </form>
`;
        }
    }
    customElements.define('user-form-logout', HTMLUserLogoutElement);

}