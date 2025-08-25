<!doctype html>

<html lang="bn">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Termux Toolbox — Free Web UI</title>
  <style>
    :root{--bg:#0f1724;--card:#0b1220;--accent:#06b6d4;--muted:#9aa6b2}
    *{box-sizing:border-box}
    body{margin:0;font-family:Inter,ui-sans-serif,system-ui,Segoe UI,Roboto,'Noto Sans',Arial;background:linear-gradient(180deg,#021124 0%, #061829 100%);color:#e6eef6}
    header{padding:24px 20px;display:flex;align-items:center;gap:16px}
    .logo{width:48px;height:48px;border-radius:10px;background:linear-gradient(135deg,var(--accent),#7c3aed);display:flex;align-items:center;justify-content:center;font-weight:700}
    h1{font-size:20px;margin:0}
    p.lead{margin:4px 0 0;color:var(--muted)}
    .container{max-width:1100px;margin:18px auto;padding:0 18px}
    .row{display:grid;grid-template-columns:1fr 360px;gap:18px}
    .card{background:rgba(255,255,255,0.03);padding:16px;border-radius:12px;box-shadow:0 6px 20px rgba(2,6,23,0.6)}
    .search{display:flex;gap:8px;align-items:center}
    input.searchbox{flex:1;padding:10px 12px;border-radius:8px;border:1px solid rgba(255,255,255,0.04);background:transparent;color:inherit}
    .tools{display:grid;grid-template-columns:repeat(auto-fill,minmax(230px,1fr));gap:12px;margin-top:12px}
    .tool{padding:12px;border-radius:10px;background:linear-gradient(180deg,rgba(255,255,255,0.02),transparent);border:1px solid rgba(255,255,255,0.02)}
    .tool h3{margin:0 0 6px;font-size:16px}
    .tool p{margin:0;color:var(--muted);font-size:13px}
    .actions{display:flex;gap:8px;margin-top:10px}
    button{cursor:pointer;padding:8px 10px;border-radius:8px;border:0;background:var(--accent);color:#042024;font-weight:600}
    button.ghost{background:transparent;border:1px solid rgba(255,255,255,0.06);color:var(--muted);font-weight:500}
    aside.card{height:fit-content}
    .note{font-size:13px;color:var(--muted);background:rgba(255,255,255,0.02);padding:10px;border-radius:8px}
    footer{max-width:1100px;margin:18px auto;padding:0 18px;color:var(--muted);font-size:13px}
    .small{font-size:12px;color:var(--muted)}
    /* modal */
    .modal{position:fixed;inset:0;display:none;align-items:center;justify-content:center;background:rgba(2,6,23,0.6)}
    .modal .panel{background:var(--card);padding:18px;border-radius:10px;max-width:720px;width:95%}
    pre{background:#061424;padding:12px;border-radius:8px;overflow:auto}
    @media(max-width:880px){.row{grid-template-columns:1fr}.logo{display:none}}
  </style>
</head>
<body>
  <header>
    <div class="logo">T</div>
    <div>
      <h1>Termux Toolbox</h1>
      <p class="lead">Termux-এর জন্য প্রয়োজনীয় প্যাকেজ, কমান্ড এবং টিউটোরিয়াল — নিরাপদ ও আইনের সীমার মধ্যে ব্যবহার করো।</p>
    </div>
  </header>  <main class="container">
    <div class="row">
      <section class="card">
        <div class="search">
          <input id="q" class="searchbox" placeholder="Search tools, e.g. git, python, openssh..." />
          <button id="searchBtn">Search</button>
        </div><div style="margin-top:14px" class="small">Tools list — টেক্সট কপি করে Termux-এ পেস্ট করে চালাতে পারো।</div>

    <div id="tools" class="tools">
      <!-- tools injected by JS -->
    </div>

  </section>

  <aside class="card">
    <h3>Quick Start</h3>
    <div class="note">
      <ol>
        <li>Termux ইনস্টল: F-Droid বা GitHub থেকে ইনস্টল করো।</li>
        <li>প্রথমে প্যাকেজ আপডেট: <code>pkg update && pkg upgrade -y</code></li>
        <li>এখান থেকে command কপি করে Termux-এ পেস্ট করো।</li>
      </ol>
    </div>

    <h3 style="margin-top:12px">Ethical Use</h3>
    <div class="note">এই ওয়েবসাইটটি শিক্ষামূলক উদ্দেশ্যে। অনৈতিক বা অবৈধ কাজের জন্য টুল ব্যবহার করা যাবে না।</div>

    <h3 style="margin-top:12px">Useful Links</h3>
    <div class="small" style="margin-top:8px">
      <div>- Termux GitHub: <a href="https://github.com/termux/termux-app" target="_blank">github/termux-app</a></div>
      <div>- F-Droid (Termux): <a href="https://f-droid.org" target="_blank">f-droid.org</a></div>
    </div>
  </aside>
</div>

  </main>  <footer>
    <div>Made with ❤️ — কপি করে GitHub Pages/Netlify এ host করো।</div>
  </footer>  <!-- modal for commands -->  <div id="modal" class="modal" role="dialog">
    <div class="panel">
      <h3 id="modalTitle">টুল কমান্ড</h3>
      <pre id="modalCmd">রেডি কমান্ড...</pre>
      <div style="margin-top:10px;display:flex;gap:8px;justify-content:flex-end">
        <button id="copyCmd">Copy to clipboard</button>
        <button id="closeModal" class="ghost">Close</button>
      </div>
    </div>
  </div>  <script>
    const toolsList = [
      {id:'pkg',name:'Basic Packages',desc:'Update & install core packages',cmd:'pkg update && pkg upgrade -y\npkg install git python clang vim -y'},
      {id:'openssh',name:'OpenSSH (SSH client/server)',desc:'Install ssh client & openssh-server',cmd:'pkg install openssh -y\nsshd'},
      {id:'git',name:'Git',desc:'Version control (git)',cmd:'pkg install git -y\ngit --version'},
      {id:'python',name:'Python',desc:'Python environment (pip included)',cmd:'pkg install python -y\npython --version'},
      {id:'node',name:'Node.js',desc:'Node.js and npm',cmd:'pkg install nodejs -y\nnode --version'},
      {id:'curl',name:'curl & wget',desc:'HTTP clients for downloads',cmd:'pkg install curl wget -y'},
      {id:'nmap',name:'nmap (network scanner)',desc:'Network inventory — use only for authorized testing',cmd:'pkg install nmap -y\nnmap --version'},
      {id:'termux-api',name:'Termux:API',desc:'Access device features from Termux (requires Termux:API app)',cmd:'pkg install termux-api -y'},
      {id:'pip-tools',name:'pip packages',desc:'Common Python tools',cmd:'pip install requests beautifulsoup4'},
    ];

    const toolsEl = document.getElementById('tools');
    const q = document.getElementById('q');

    function render(list){
      toolsEl.innerHTML = '';
      list.forEach(t=>{
        const el = document.createElement('div'); el.className='tool';
        el.innerHTML = `<h3>${t.name}</h3><p>${t.desc}</p><div class="actions"><button data-id="${t.id}">Show Command</button><button class="ghost" data-link>Tutorial</button></div>`;
        toolsEl.appendChild(el);
      });
    }

    render(toolsList);

    // event delegation
    toolsEl.addEventListener('click', e=>{
      const btn = e.target.closest('button'); if(!btn) return;
      const id = btn.getAttribute('data-id');
      if(id){
        const t = toolsList.find(x=>x.id===id);
        showModal(t.name, t.cmd);
      }
    });

    toolsEl.addEventListener('click', e=>{
      const btn = e.target.closest('button[data-link]'); if(!btn) return;
      alert('Tutorial button: তুমি নিজে চাইলে টিউটোরিয়াল লিংক যোগ করতে পারো। এটি ডেমো বাটন।');
    });

    document.getElementById('searchBtn').addEventListener('click', ()=>doSearch());
    q.addEventListener('keypress', e=>{ if(e.key==='Enter') doSearch(); });

    function doSearch(){
      const val = q.value.trim().toLowerCase();
      if(!val){ render(toolsList); return; }
      const filt = toolsList.filter(t=> (t.name+t.desc).toLowerCase().includes(val));
      render(filt);
    }

    // modal logic
    const modal = document.getElementById('modal');
    const modalCmd = document.getElementById('modalCmd');
    const modalTitle = document.getElementById('modalTitle');
    function showModal(title, cmd){ modalTitle.textContent = title; modalCmd.textContent = cmd; modal.style.display='flex'; }
    document.getElementById('closeModal').addEventListener('click', ()=> modal.style.display='none');
    document.getElementById('copyCmd').addEventListener('click', ()=>{
      navigator.clipboard.writeText(modalCmd.textContent).then(()=>{
        alert('Command copied — Termux এ পেস্ট করো।');
      }).catch(()=>{ alert('Copy failed.'); });
    });

    // close when clicking backdrop
    modal.addEventListener('click', e=>{ if(e.target===modal) modal.style.display='none'; });
  </script></body>
</html>
