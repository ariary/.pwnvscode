<div align=center>
<h1>😈 .vscode 📁</h1>

<strong> Automatically perform RCE when open it with `vscode` </strong>
</div>

## How to use it?
* **Specify payload**: `./build.sh "[YOUR_RCE_PAYLOAD]"`
* **Inject the malicious `.vscode`** configuration folder somewhere where the victim may open it with `vscode`
   * Spread it using Social Engineering, malicious commit, etc...
* Wait


## Notes
* Target developers using `vscode` (**~50%** use it)
* Not a vulnerability, rather a trick
* It is not the stealthest RCE of the world, but sometimes `.vscode` folder is not checked/changed by devs and can thus pass under the radar
