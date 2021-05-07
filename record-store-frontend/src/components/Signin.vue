<template>
    <form @submit.prevent = "signin">
        <div v-if="error">{{error}}</div>
        <div class="mb-6">
            <label for="email" class="form-control">Email Address</label>
            <input type="email" v-model="email" id="email" class="form-control">
        </div>
        <br>
        <div class="mb-6">
            <label for="password" class="form-control">Password</label>
            <input type="password" v-model="password" id="password" class="form-control">
        </div>
        <button type="submit">Signin</button>
        <div>
            <router-link to="/signup">Sign Up</router-link>
        </div>
    </form>
</template>

<script>
/* eslint-disable */
export default {
    name: 'Signin',
    data(){
        return {
            email: '',
            password: '',
            error: ''
        }
    },
    created(){
        this.checkSignedIn()
    }, 
    updated(){
        this.checkSignedIn()
    },
    methods: {
        signedIn(){
            this.$http.plain.post('/signin', {email: this.email, password: this.password})
            .then(response => this.signinSuccessful(response))
            .catch(error => this.signinFailed(error))
        },
        signinSuccessful(response){
            if(!response.data.csrf){
                this.signinFailed(response)
                return
            }
            localStorage.csrf = response.data.csrf
            localStorage.signedIn = true
            this.error = ''
            this.$router.replace('/records')
        },
        signinFailed(error){
            this.error = (error.response && error.response.data && error.response.data.error )
        }
    }
}
</script>
