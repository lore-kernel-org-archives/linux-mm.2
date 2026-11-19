Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07FC8606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 08:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=tychen.cc header.i=@tychen.cc header.a=rsa-sha256 header.s=spacemail header.b=bzff/ZSo
Received: by kanga.kvack.org (Postfix)
	id 032376B05C3; Thu, 19 Nov 2026 03:24:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7436B05C4; Thu, 19 Nov 2026 03:24:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE55A6B05C5; Thu, 19 Nov 2026 03:24:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ADA686B05C3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:24:56 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39281120996
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:24:56 +0000 (UTC)
X-FDA: 85451182992.05.B41EB43
Received: from out-2z4y-a151.jellyfish.systems (out-2z4y-a151.jellyfish.systems [198.54.127.151])
	by imf31.hostedemail.com (Postfix) with ESMTP id 418C220002
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:24:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b="bzff/ZSo";
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf31.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.151 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795076694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPOuzCWYT+Wte+B/uG9zY8ixckJMP+wFc8Qb/K9SHGY=;
	b=ZzX6wRztM3ThjmaNb7j5/sJF21b7VSZAYBmIi7ApeWcwLyungnHp1zcivekzHnLUTBEX/X
	uaDKSRVH43WtWJm03xu57bi11XRp5kwEYkoS8aj8quntTN3mI9WOiKjee84dWMJBmRWPaK
	jGtQ4Pn3oCV9WcWLlWmT0V/t9taoN74=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b="bzff/ZSo";
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf31.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.151 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795076694;
	b=1+SDl9uXXAakjEwYlrjXrLUzmfkKVJs+5LitJjyMWUN9nb/84/6TMKX87nbw5hlaGYWa6u
	ZNQLYXqgwsiod0kYMadgdkxFwndCtTg2JBNmPV+mupRfbjyJMK0vLZB6vQd3BAvRA9r0BX
	zkKNBGL97UPtKRJ6r/NZ0taA8YXdZRM=
Received: from fedora (ec2-52-197-241-54.ap-northeast-1.compute.amazonaws.com [52.197.241.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4jVWjX0qYPz2x9C;
	Thu, 19 Nov 2026 08:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1795076690;
	bh=jPOuzCWYT+Wte+B/uG9zY8ixckJMP+wFc8Qb/K9SHGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzff/ZSocNEM1TrwDRHxIv/tZkA+TIGpXE8B2jhkLprincQtbi6Wz2fakmGkRJqaR
	 gZRVn3cl7aP8L36cip8XuMeTTCYc4s8/rdGqvnQqLnKgGkWFnKW4u9v71H6Z/us1rx
	 UIGGfKKLD7+vpKrRzoCgxk14sL+BkaqyQxJB04QQKHFCy+KaYps2kVzGA3/ei0nGn0
	 LI4Bhc0RUKaNSa/6E9Y3TmwTFOlqikJ7O3yF5Xdt6A5XYrsh5CR6Av08UkZOktt++m
	 /Clw4Y0//Z0NgW4geHJKA9cmSFUSSDhqHu+/bXvC9qElM5Bn8c2nk1yj9lpD+3zopU
	 kUJSvC123cNzQ==
From: Tianyi Chen <hi@tychen.cc>
To: Kairui Song <ryncsn@gmail.com>
Cc: Maxim Muzafarov <maxmuzaf@gmail.com>,
	linux-mm@kvack.org,
	Kairui Song <kasong@tencent.com>
Subject: Re: [RFC PATCH 0/1] mm/mglru: MADV_RANDOM page cache never ages and thrashes the oldest generation
Date: Thu, 19 Nov 2026 17:24:40 +0900
Message-ID: <20261119082441.196139-1-hi@tychen.cc>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <av3vMMhFbiaop7zA@KASONG-MC4>
References: <20261101160427.85701-1-maxmuzaf@gmail.com> <179502478384.194898.8139869410612997037.streamfolio@tychen.cc> <av3vMMhFbiaop7zA@KASONG-MC4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Envelope-From: hi@tychen.cc
X-Rspamd-Queue-Id: 418C220002
X-Stat-Signature: osto3nixumaet1ogntg979es6qkfcix3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795076693-567743
X-HE-Meta: U2FsdGVkX19EBA9EveRr7lK4wHR2aZo+ZE+t/m1UxY2g0iDI/mJLIMKLl4o4huMsJ4+4r/VGudmcNs4hfdpCsIV9rXMjM+DWtUKBuhWcUWusGoBoD3PHxRn4+9dU6pTe4+E+SHw1VMv/7CmEYkqCB9oQ1YUUwtuEB0Ey068KFdtm650ZLL6UdHf0y5UsX+OTsIIyphI6LloZeWxNU5bUGWplgco0QSdc5NipHBBmSEPrWe+Iy662NHvAQyNPVcYFg0Ue/qxkRN6tkrb7prJpCwx8ZnVmGSHJISn/3x/dfZnTW3hGb4IRw82YIZrDhZXODywnLtRKqPCj9VrdhRXmB3Os4Dq5mcpI/kYJUAyZrh6wogPR5f0ywKG4C5hQ6sCvYXLZbS5cTZC5kJW9PxYwC3zVkc1rV7WGP/jaalUMB2QWJOF2oQYSo3BLp4fLf9bGs4Q2oiz0614tpqU78gF7qLcXQKjkxablX64u8jN0ZJSzIXgiW9Qg05uUNMyn1XfMMBnirSey2k2CARGsKYkLR7xv30P7mHR/cEsgLCL+Qg9Pm88BCi/7dGZrWi1/L9W3ph1l8iA3MsswKgwVUE9c1UBTr4eQTbRc9UAA2aVN87qzv0f1Ni+gXUnt074wwLs2WGzRxurX+8m2ckp4xAurLflsVUJi9Rf1375os5V+gM1yD+MJlfxosXBlNmC6rvJBSv/nf+IQTfafzBc+LJ+plZ/lZLHFDRqWihBZJTVgpXJU65bJ+LX44Fpqahm+ESBuS5zeKs8TOwdvfbRqRSTrOPjf7qtghzQbwqk+f52JIzbWldHDf5KwMFQkbR4PZq+6t8XbCSih39E1QOm0hcN2CnBz5oj9fry5Mmlblh4JXZvPA1Di5zuDaMqmsrOuXlh3LFVHGvU5/596t2jWxrX7lZXA6Xcq9lWlCsVrtP4BpWGnktXOt5TkiV5VLFMMIYTMR37V2azKpJYjuuA6t7e
 iQuPMdrt
 x0+Km3UwWsQdbS05hqXzMTF28rgp/RuNmnnfs24ofHHnactFKHpEJ8RD3HQJ+mDVAcpaSPFuHiohb5uAm1UIDY3dQPFb2huxpFJDh4BtZ9g3CLjPwra+pyeLUdRuIc6lvcs1N45h2k5SFMO0sSqZ329LHXghB2wq2oIBVqgkBtZGaexlHwwiYC3LyOJIZIkF5RMPLYb9Ax1PLedeQ8y0R3nQb2O7U8trBLQWFwF719mxaq5lCnxkIdmmEN36W1Tz+SHV2zGdTZ6TwzWCY3w0F3IkGGLaviScT2YPpBFQdnuqktHSMyI+ZiiWf3ZbYvI3qj2QNN4sdOKG27IBsPcdFeQJSomKW+RQsCSG5eE3e2ebmxjflTsW2FYQR6oFOD/E+oQnXaWGPR+VOr282fJ5Ri7Pu8MTT1YSFBymKl+Y0c5ixlIl6OEAirAz/ybYigtU9oQ8qcr6MfWdM4h4Qx5oulOVb3bUl/UDeNHnOHmGrutimqdUdj62tkuNV8nr0yttKM2YwdbnEK1xMuYPtVHYh04BexMEMxEsXFrVV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Can you share the test step on that one?

Yes. The script I used for the rerun is below. I'd missed your
discussion of MADV_RANDOM in the FG v4 cover and your note about
vma_has_recency() earlier in this thread.

I ran OpenSearch 3.6.0 with k-NN 3.6.0.0 and a 384 MiB heap. The
index is one Lucene HNSW segment: 80,000 vectors, 384 dimensions,
m=16, ef_construction=80, mmapfs. Two HTTP connections issue top-10
queries. After 3,200 warmup and 1,600 measured queries, I pause the
client and mmap-read a cold 96 MiB file once. The scanner and server
share a 1 GiB cgroup with no swap. I then run 700 queries followed
by another 1,000; the p99 below is for those last 1,000 only.

Save the script as repro.py. As root in a spare x86-64 VM with
cgroup v2, CONFIG_LRU_GEN, Python 3.11+ and curl, run:

    python3 repro.py build
    python3 repro.py sweep

The first command downloads the two packages and builds the index.
The second restarts OpenSearch on a cold copy for each run; it sets
/sys/kernel/mm/lru_gen/enabled to 7 or 0. No global cache drop.

On the same mm-unstable commit (1b697248a755), this time with 5 GiB
in the VM, median p99 over five seeds was 78.1 ms with MGLRU and
2.1 ms with classic LRU. Before the scan both had the full 117.2 MiB
.vec file in cache. During the scan MGLRU dropped it to about 64 MiB,
while classic LRU kept all of it. Over the last 1,000 queries the
cgroup saw about 159k file refaults with MGLRU and none with classic
LRU, and .vec stayed at about 98 MiB. Look for the PHASE line with
phase set to late.

This is a synthetic index, not Maxim's workload. I've only run it
on x86-64, with stock MGLRU on and off, not your refault-distance
series.

If you point me to a branch, I can run the same test on it.

Thanks,
Tianyi

Assisted-by: LLM

---8<---
#!/usr/bin/env python3
"""Run as root in a spare x86-64 Linux VM, not on a shared host."""
import ctypes, hashlib, http.client, json, math, mmap, os, random
import re, resource, shutil, signal, socket, subprocess, sys, tarfile
import time, zipfile, zlib
from concurrent.futures import ThreadPoolExecutor
from contextlib import closing
from pathlib import Path
M = 1 << 20
W = Path("/var/lib/sf-os-repro")
APP = W / "opensearch-3.6.0"
LIVE, BASE, SCAN = (W / x for x in ("live", "index-base", "scan"))
CGROOT = Path("/sys/fs/cgroup")
CG = CGROOT / ("sf-search-%d" % os.getpid())
LRU = Path("/sys/kernel/mm/lru_gen/enabled")
PORT = 19280
ARCHIVE = "opensearch-min-3.6.0-linux-x64.tar.gz"
PLUGIN = "opensearch-knn-3.6.0.0.zip"
ART = "https://artifacts.opensearch.org/releases/core/opensearch/3.6.0/"
MAV = "https://repo.maven.apache.org/maven2/org/opensearch/plugin/"
FILES = [(ARCHIVE, ART + ARCHIVE,
          "d12356c98bc544567f033d76236d4fcf"
          "2a644abe705a6ba917304cf7388e67d4"),
         (PLUGIN, MAV + "opensearch-knn/3.6.0.0/" + PLUGIN,
          "ac392ca28a39b3bf290648a422ef30cb"
          "149dda2963a9d7feb26060e932341c9a")]
def emit(kind, **d):
    print(kind, json.dumps(d, sort_keys=True), flush=True)
def install():
    for name, url, wanted in FILES:
        p = Path(name)
        if not p.exists():
            subprocess.run(["curl", "-fL", "--retry", "2", "-o",
                            name + ".part", url], check=True)
            Path(name + ".part").rename(p)
        with p.open("rb") as f:
            got = hashlib.file_digest(f, "sha256").hexdigest()
            assert got == wanted, (name, got)
    W.mkdir(mode=0o755)  # refuse to overwrite an earlier installation
    with tarfile.open(ARCHIVE) as t:
        t.extractall(W)  # both distribution digests checked above
    with zipfile.ZipFile(PLUGIN) as z:
        z.extractall(APP / "plugins/opensearch-knn")
    cfg = APP / "config/opensearch.yml"
    cfg.write_text(f"""cluster.name: sf-os-repro
node.name: sf
discovery.type: single-node
network.host: 127.0.0.1
http.port: {PORT}
transport.port: 19380
path.data: {LIVE}
path.logs: {W}/logs
knn.memory.circuit_breaker.enabled: true
knn.memory.circuit_breaker.limit: 256mb
""")
    for p in [LIVE, W/"logs", W/"home", APP/"logs", APP/"config"]:
        p.mkdir(exist_ok=True)
        os.chown(p, 65534, 65534)
    for p in (APP/"config").rglob("*"):
        os.chown(p,65534,65534)
    with SCAN.open("xb") as f:
        for _ in range(96):
            f.write(os.urandom(M))
def conn():
    return http.client.HTTPConnection("127.0.0.1", PORT, timeout=240)

def req(c, method, url, obj=None, bulk=False):
    data = obj if isinstance(obj, bytes) else (
        json.dumps(obj,separators=(",",":")).encode() if obj else None)
    typ = "application/x-ndjson" if bulk else "application/json"
    c.request(method, url, data, {"Content-Type":typ})
    r = c.getresponse()
    raw = r.read()
    if r.status // 100 != 2:
        raise RuntimeError((url, r.status, raw[:1200]))
    return raw
rng = random.Random(1919)
centers = [[rng.randrange(-40, 41) for _ in range(384)]
           for _ in range(128)]
def vec(group, r):
    return [a + (b >> 4) - 8 for a,b in
            zip(centers[group], r.randbytes(384))]

def build(c):
    ix = {"knn":True, "number_of_shards":1, "number_of_replicas":0,
          "refresh_interval":"-1", "compound_format":False,
          "store.type":"mmapfs"}
    method = {"name":"hnsw", "engine":"lucene", "space_type":"l2",
              "parameters":{"m":16, "ef_construction":80}}
    field = {"type":"knn_vector", "dimension":384, "method":method}
    req(c, "PUT", "/sf", {"settings":{"index":ix}, "mappings":{
        "_source":{"enabled":False}, "properties":{"v":field}}})
    r = random.Random(9917)
    for i in range(0, 80000, 400):
        rows = bytearray()
        for j in range(i, i+400):
            rows += b'{"index":{}}\n' + json.dumps(
                {"v":vec(j%128, r)}, separators=(",", ":")).encode()
            rows += b"\n"
        url = "/sf/_bulk?filter_path=errors,items.index.error"
        result = json.loads(req(c,"POST",url,bytes(rows),True))
        assert not result["errors"], str(result)[:1500]
        if (i+400)%20000 == 0:
            req(c,"POST","/sf/_flush?force=true")
            emit("INDEX", docs=i+400)
    req(c,"POST","/sf/_refresh")
    req(c,"POST","/sf/_forcemerge?max_num_segments=1&flush=true")
    assert json.loads(req(c,"GET","/sf/_count"))["count"] == 80000
    assert len(list(LIVE.rglob("*.vec"))) == 1
def phase(seed, n):
    r = random.Random(seed)
    queries = []
    for _ in range(n):
        v = {"v":{"vector":vec(r.randrange(128),r),"k":10}}
        q = {"size":10,"track_total_hits":False,"_source":False,
             "query":{"knn":v}}
        queries.append(json.dumps(q,separators=(",",":")).encode())
    url = ("/sf/_search?request_cache=false&filter_path="
           "took,hits.hits._id,error")
    def worker(qs):
        t, crc = [], 0
        with closing(conn()) as c:
            for q in qs:
                start = time.perf_counter_ns()
                raw = req(c,"POST",url,q)
                t.append((time.perf_counter_ns()-start)/1e6)
                found = json.loads(raw)["hits"]["hits"]
                hits = [x["_id"] for x in found]
                assert len(hits) == 10
                crc = zlib.crc32(",".join(hits).encode(), crc)
        return t, crc
    with ThreadPoolExecutor(2) as pool:
        a,b = pool.map(worker, (queries[::2], queries[1::2]))
    t = sorted(a[0]+b[0])
    return dict(n=n, p50_ms=t[math.ceil(.5*n)-1],
                p99_ms=t[math.ceil(.99*n)-1], hits=[a[1],b[1]])
def resident(p):
    with p.open("rb") as f, mmap.mmap(f.fileno(), 0,
                                      access=mmap.ACCESS_COPY) as m:
        bits = (ctypes.c_ubyte * math.ceil(len(m)/mmap.PAGESIZE))()
        addr = ctypes.addressof(ctypes.c_char.from_buffer(m))
        mc = ctypes.CDLL(None).mincore
        assert not mc(ctypes.c_void_p(addr), ctypes.c_size_t(len(m)),
                      bits)
        return sum(x&1 for x in bits)*mmap.PAGESIZE
def cold(p):
    with p.open("rb") as f:
        os.fsync(f.fileno())
        os.posix_fadvise(f.fileno(), 0, 0, os.POSIX_FADV_DONTNEED)
def advice():
    seen = set()
    for pid in (CG/"cgroup.procs").read_text().split():
        try:
            lines = Path("/proc",pid,"smaps").read_text().splitlines()
        except FileNotFoundError:
            continue
        ext = ""
        for s in lines:
            if re.match(r"^[0-9a-f]+-[0-9a-f]+ ", s):
                ext = Path(s.split()[-1]).suffix
            if ext in (".vec",".vex") and s.startswith("VmFlags:"):
                assert "rr" in s.split(), s
                seen.add(ext)
    assert seen == {".vec",".vex"}
    emit("SMAPS", rr=sorted(seen))

def test(seed, arm, files):
    def snap():
        stat = dict(x.split() for x in (CG/"memory.stat")
                    .read_text().splitlines())
        return int(stat["workingset_refault_file"])
    def report(name, old, **extra):
        rss = {x.suffix:resident(x) for x in files}
        emit("PHASE", phase=name, seed=seed, arm=arm, resident_B=rss,
             mem_B=int((CG/"memory.current").read_text()),
             refault_pages=snap()-old, **extra)
    for i,(name,n) in enumerate((("warm",3200),("pre",1600),
                                 ("early",700),("late",1000))):
        if name == "early":
            assert resident(SCAN) == 0
            old = snap()
            pid = os.fork()
            if not pid:
                try:
                    (CG/"cgroup.procs").write_text("0")
                    with SCAN.open("rb") as f, mmap.mmap(f.fileno(),0,
                           access=mmap.ACCESS_READ) as m:
                        m.madvise(mmap.MADV_NORMAL)
                        sum(m[j] for j in range(0,len(m),4096))
                except BaseException:
                    os._exit(1)
                os._exit(0)
            assert os.waitpid(pid,0)[1] == 0
            report("scan", old, scan_B=resident(SCAN))
        old = snap()
        report(name, old, **phase(seed+i,n))
        if name == "warm":
            advice()

def trial(arm=None, seed=0):
    oldmask = LRU.read_text().strip()
    files = []
    if arm is not None:
        shutil.copytree(BASE, LIVE)
        for p in [LIVE,*LIVE.rglob("*")]:
            os.chown(p,65534,65534)
            if p.is_file():
                cold(p)
        for p in APP.rglob("*"):
            if p.is_file() and not p.is_symlink():
                cold(p)
        cold(SCAN)
        files = [p for p in LIVE.rglob("*") if p.suffix in (
            ".vec",".vex")]
        assert sorted(p.suffix for p in files) == [".vec",".vex"]
        assert all(resident(p)==0 for p in [*files,SCAN])
    with socket.socket() as s:
        s.setsockopt(socket.SOL_SOCKET,socket.SO_REUSEADDR,1)
        s.bind(("127.0.0.1",PORT))
    (CGROOT/"cgroup.subtree_control").write_text("+memory")
    CG.mkdir()
    proc = None
    def enter():
        (CG/"cgroup.procs").write_text("0")
        os.setgroups([])
        os.setgid(65534)
        os.setuid(65534)
    try:
        if arm is not None:
            LRU.write_text(str(arm))
            assert int(LRU.read_text(),0) == arm
            (CG/"memory.max").write_text(str(1024*M))
        (CG/"memory.swap.max").write_text("0")
        emit("START", seed=seed, arm=arm, kernel=os.uname().release,
             vec_bytes={p.suffix:p.stat().st_size for p in files})
        opts = ("-Xms384m -Xmx384m -XX:ActiveProcessorCount=4 "
                "--enable-native-access=ALL-UNNAMED")
        with (W/f"server-{arm}-{seed}.log").open("wb") as log:
            proc = subprocess.Popen([APP/"bin/opensearch"], cwd=APP,
                stdout=log, stderr=log, preexec_fn=enter, env={
                **os.environ,"HOME":str(W/"home"),
                "OPENSEARCH_JAVA_HOME":str(APP/"jdk"),
                "OPENSEARCH_JAVA_OPTS":opts},start_new_session=True)
            with closing(conn()) as c:
                for _ in range(240):
                    if proc.poll() is not None:
                        raise RuntimeError(f"see {log.name}")
                    try:
                        info = json.loads(req(c,"GET","/"))
                        break
                    except (OSError,http.client.HTTPException):
                        c.close()
                        time.sleep(.5)
                else:
                    raise TimeoutError("OpenSearch startup")
                assert info["cluster_name"] == "sf-os-repro"
                assert info["version"]["number"] == "3.6.0"
                assert info["version"]["lucene_version"] == "10.4.0"
                h = "/_cluster/health?wait_for_status=yellow"
                assert not json.loads(req(c,"GET",h))["timed_out"]
                if arm is None:
                    build(c)
                else:
                    test(seed,arm,files)
        events = (CG/"memory.events").read_text().splitlines()
        assert "oom_kill 0" in events, events
    finally:
        if proc and proc.poll() is None:
            os.killpg(proc.pid,signal.SIGTERM)
            try:
                proc.wait(timeout=90)
            except subprocess.TimeoutExpired:
                os.killpg(proc.pid,signal.SIGKILL)
                proc.wait()
        LRU.write_text(str(int(oldmask,0)))
        CG.rmdir()
    if arm is None:
        LIVE.rename(BASE)
    else:
        shutil.rmtree(LIVE)
    emit("DONE",arm=arm,seed=seed)

if __name__ == "__main__":
    if not __debug__ or os.getuid() or os.uname().machine!="x86_64":
        sys.exit("use root, x86-64 Linux, and Python without -O")
    resource.setrlimit(resource.RLIMIT_NOFILE,(65536,65536))
    args = sys.argv[1:]
    if args == ["build"]:
        install()
        trial()
    elif args == ["sweep"]:
        for seed in range(8091,8096):
            arms = [0,7]
            random.Random(seed).shuffle(arms)
            for arm in arms:
                trial(arm,seed)
    elif len(args)==3 and args[0]=="run" and args[1] in ("0","7"):
        trial(int(args[1]),int(args[2]))
    else:
        sys.exit("usage: repro.py build | sweep | run {0,7} SEED")

