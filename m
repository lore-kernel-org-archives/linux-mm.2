Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09F97606A33D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 22:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hurH8eEG
Received: by kanga.kvack.org (Postfix)
	id EE8A16B00EF; Mon, 16 Nov 2026 17:35:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9A206B05B0; Mon, 16 Nov 2026 17:35:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAFDE6B05B1; Mon, 16 Nov 2026 17:35:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A28BB6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:35:02 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B6C424020B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:35:01 +0000 (UTC)
X-FDA: 85442438802.28.935A9D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 15EC1100007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:34:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hurH8eEG;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794868500;
	b=DGliESlA5rUsKF3FHxOs8Wj9p1kPhjwL372e5XJ7MUzNwFw+94HD77yUJ0DvEDoYwyiNEH
	NJh52dDv2c4h0lWN0uevmZm4gmQk56vbnsuXlN8nptddpiY5/5iENRVbohX0b/sPQpNpmn
	toEXnTngenVIfPG44UWT6eZsTykGeO8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hurH8eEG;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794868500;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7dJa2fx3aIPmSxSj9kKvNUDNlIFj/kVKjhNbPBSngw=;
	b=fkZ5FCU6EYnacKa6s4lj+x9BxSOfZNOVVVe2oZgUZuKrrllifCMrwsdGcitZLJXFkmJIFG
	X7TzQDXkNdQbbsCh7PJgN1tfVoW639vsSvT/Z7Sb3BYxMpogrdv0rOc+ItMpOUzY0wfid4
	PmnTeFps+mw5unyaU75OToLCgafIbg0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44A5544FFB;
	Mon, 16 Nov 2026 22:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDA41F000C4;
	Mon, 16 Nov 2026 22:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794868499;
	bh=i7dJa2fx3aIPmSxSj9kKvNUDNlIFj/kVKjhNbPBSngw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hurH8eEGPqBw85GwKlLu8u/H5V34LmyZQKsUATeEli0DtY5rjjVLwk8/Hpvmvpyva
	 7SzWnjtuw0DkUuXNbrOVcpL/eCApMjZp/zR7sK0tLnLa2csEsaCaTSH9vvxVR3zzWj
	 tTLKJg6H6jd/bcsKRoiAE7RyrwVCVK//dxLkUusQ1y8T+DdIRoBOf+lJo4U2KMso3U
	 fJZwo1blIFijlxX9WoS6a9P9PY5OzBQeEYC0N2Grl+zDjF0cUfNEvmdNevD4pCVmP1
	 UlWI58X3VgwAli9bRdmsMST6g3rRH1g/bgUpWO79OU6SHuf9lK61fGs4TN+GtmViqr
	 rGH7J31NUUj1w==
Message-ID: <sashiko-outbox-217804@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC nf-next 9/9] selftests: netfilter: exercise nfqueue
 memory accounting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alireza Asgari" <alireza@asgari.net>, linux-mm@kvack.org
Cc: "Johannes Weiner" <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Muchun
 Song" <muchun.song@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Pablo Neira Ayuso" <pablo@netfilter.org>, "Florian
 Westphal" <fw@strlen.de>, "Phil Sutter" <phil@nwl.cc>, "Shuah Khan" <shuah@kernel.org>, "Tejun
 Heo" <tj@kernel.org>, "Vladimir Davydov" <vdavydov.dev@gmail.com>, "Chris
 Down" <chris@chrisdown.name>, "Zhang Jiao" <zhangjiao2@cmss.chinamobile.com>, "Song
 Hu" <husong@kylinos.cn>, mkoutny@suse.com
In-Reply-To: <20261115-b4-nfqueue-memory-accounting-v1-9-b9cc30819997@asgari.net>
References: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
 <20261115-b4-nfqueue-memory-accounting-v1-9-b9cc30819997@asgari.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 22:34:57 +0000
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 15EC1100007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: bh9as7re87xygk9c67czz3frnq4scndu
X-Rspam-User: 
X-HE-Tag: 1794868499-149508
X-HE-Meta: U2FsdGVkX19QuzgoHoav/7PPa72rf2gxf9c8CL4AtHIPrT0dH1JppETrshO9bKNnYe/aiiVAoTD1iTv6C4hszyOBLzeAWLIKtO2AqOmITCd0yNogUUftATIsYBy5TWXEgN8nH/AxGTitfWAaeHgFRR8ddai1NZXo8ofQqBbnt7awc67eu/emJksJzLt0fgpETxdnEgHRk6Mn9NrtErGmJS8VHJyLj07WWmgVS9CBAr5bMnmtrHrQRJndqQdEYyV0/gmMq74zQqdCq3nvZvoP3E4dqL2QhQeR1v4faR3VnMsIlxSJ22ltdm6D17CK7JMyG1IKR0Meq9SyOeXsq/CD4bO5Y4r8JhOhW3vXRPpkhE9Dj2ecxFuPwxyYVALB2QcK3KfY4Gw93vACssLpDUjSjKkW9KI0eDJpIE02KXnARF4tWE1yeNkCPKxLTS9jwHYdomELzQzj/U66fXa7UxjGKpJjBkvVz/lUhOl94C/fddtRj/FEkncw+Pyj/GLNbaufIlztdvfvDLRFwtRGDXhnhZe/czvIjfBct4djTKIBsQvBK+WwEKZPPGIflVJKtDcdGerTnw/7YaRLWtT7OFtFPomEkYer6UfHxet9AjhVACi7vxIFK9PxHEfFCXIgMW84h22XLaGH81KhLwTKP2ckSO+eDiXEkX01ZP/ju4CPvy/Um+P8n4aULLL7g0NcL0nI1eztSuY/akB5IIDTF8cQF7Hvbh65Pc/BP7VhmsLwVwa+nlSaGti8MaqkNMZmaeaIsHsFUxkWeviNUwLjLpPytabUQLs50UWXGsmrTjTgyhuIBM7bhtyLciV32KFhzhTeGv2/89jDvrwGv7uJ9daJK3abagAR80/6KcUA8oq3SNG2NSEQyt0mVFmoUJSN0FiQK6y/Wz/8ed6Xs7WNygzF51WP3qXfS84gms8UUVO7usqkqG90n4y4QHK9JUfWJiusfC5PWE3pMSgW362ekuF
 2zcMGGqe
 4CPCSoEMbIS3aVuER3j3pQYCTbo03Uz7dQnVHEY7WxX54B+VWPvBnaNpEgAfM3NW3RC2WsXNXVtYSCd7Jsysq6MSokKoQJC4bXh3FqBN3fqyhfukM9j400jnT9VM4ltYfEwWLVCrLYnaVVyCZUW08q47kNuEpU9iwQoexPEmC+DvO7nRHEqotrA7S5O64MPAzISG1Vu9//gq0IRGwYaLWr3hG0egQMpZ0ojKo1qeN0petdqIMlQ8dpwDrvZ8kPVwpd92GFMzqW2YWNYdFYzibHavDtY3VIE/HJWNS7zwlzvLNIuDflR5jAEBrLvqCqXu+GZjThhNbk0Nu//R+KDS82I/Py6bfi56MINNDiGlI2moxyf2D1KwVCOva31YkI126HhQ4tW063oBNkFx9pw5J+5X7B5ponco2XqdR+61fYCtbN1My7KIBVLC4IqTnJlWskkmqn5MnGOZsgJwh4UX9dQx5ku25KU1k0EVP/cWIY7L/MAdZ8/u3I2IrqTHIpqOwJqyH/Qd8Q9aXIKFiCIK2gCfR5qzvNwZRUdS9Yqyx0SFr1uYb1NdHyNyUA34qtlOfeF0oEr6c5G988Coz4PVwJFx3KoNuxirYT0WoIglH+ay8zp1wcfvfwKoXfJy+JawoSIHwWVCCTCx1OZVNkvySKEMMuQ78ChCCcmFAxE1yYt3bEABlTvvruwnOLYOs/W+pKtvv7VL9skGF5kM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [Medium] selftests: netfilter: missing kernel config skip checks in
  Traffic.__init__()
- [Medium] selftests: netfilter: broken cgroup v2 discovery and
  migration in reservation()
- [Medium] selftests: netfilter: unhandled EOPNOTSUPP on 32-bit kernels
  in reservation()
- [Low] selftests: netfilter: hand-rolled TAP runner and netns setup in
  main()
- [Low] selftests: netfilter: unrefunded queues before cgroup reuse in
  reservation()
--

commit 4752a896acbd3189476bf1437e148eaf01569f85
Author: Alireza Asgari <alireza@asgari.net>

selftests: netfilter: exercise nfqueue memory accounting

This commit adds a raw-Netlink NFQUEUE selftest exercising packet memory
retention, resizing, payload replacement, segmentation, and cgroup v2 memory
reservation accounting.

> diff --git a/tools/testing/selftests/net/netfilter/nft_queue_memory.py b/=
tools/testing/selftests/net/netfilter/nft_queue_memory.py
> new file mode 100755
> index 0000000000000..35ae4db09a484
> --- /dev/null
> +++ b/tools/testing/selftests/net/netfilter/nft_queue_memory.py

[ ... ]

> +    def stats(self):
> +        path =3D Path("/proc/self/net/netfilter/nfnetlink_queue")
> +        for line in path.read_text().splitlines():
> +            values =3D [int(value) for value in line.split()]
> +            if values[0] =3D=3D self.number:
> +                return values
> +        raise AssertionError("bound queue missing from procfs")
> +
> +
> +class Traffic:
> +    def __init__(self):
> +        self.rx =3D socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
> +        self.rx.bind(("127.0.0.1", 0))
> +        self.destination =3D self.rx.getsockname()
> +        rules =3D f"""table ip nfq_memory {{
> + chain output {{
> +  type filter hook output priority 0; policy accept;
> +  udp dport {self.destination[1]} queue num 1
> + }}
> +}}
> +"""
> +        subprocess.run(["nft", "-f", "-"], input=3Drules, text=3DTrue, c=
heck=3DTrue)

[Severity: Medium]
Does Traffic.__init__() fail with an unhandled CalledProcessError instead of
skipping when the kernel lacks nftables or nft_queue support?

main() instantiates Traffic() before the test loop without catching
subprocess.CalledProcessError, so a missing CONFIG_NF_TABLES,
CONFIG_NF_TABLES_IPV4, or CONFIG_NFT_QUEUE aborts the script with exit code=
 1
(and leaks self.rx because contextlib.closing() is never entered) rather th=
an
returning the kselftest skip code 4.  Likewise, if
CONFIG_NETFILTER_NETLINK_QUEUE or CONFIG_PROC_FS is disabled, Queue.__init_=
_(),
Queue.request(), or Queue.stats() raises OSError or TimeoutError, which mai=
n()
reports as test failures rather than skips.

[ ... ]

> +def reservation(traffic, parent):
> +    if not parent:
> +        return "supply --cgroup with a delegated cgroup v2 parent in a t=
est guest"
> +    parent =3D Path(parent).resolve()
> +    check("memory" in (parent / "cgroup.subtree_control").read_text().sp=
lit(),
> +          "parent must already delegate the memory controller")
> +    membership =3D next(line[3:] for line in Path("/proc/self/cgroup").r=
ead_text().splitlines()
> +                      if line.startswith("0::"))
> +    original =3D Path("/sys/fs/cgroup") / membership.lstrip("/")
> +    group =3D parent / f"nfq-memory-{os.getpid()}"
> +    group.mkdir()
> +    try:
> +        (group / "memory.max").write_text(str(64 << 20))
> +        (group / "cgroup.procs").write_text(str(os.getpid()))

[Severity: Medium]
Can reservation() and reservation_startup() fail with EBUSY or StopIteratio=
n,
and are they ever exercised by default kselftest runs?

Standard kselftest runs do not pass --cgroup, and main() never probes
/sys/fs/cgroup by default, so both cgroup tests are unconditionally skipped.
When --cgroup is passed and the test process starts inside that non-root
delegated parent cgroup (original =3D=3D parent), parent has memory enabled=
 in
cgroup.subtree_control and a child directory (group), so migrating the proc=
ess
back to original / "cgroup.procs" while group still exists violates the cgr=
oup
v2 no-internal-processes rule and fails with OSError(EBUSY), including in t=
he
finally block where it prevents group.rmdir() from running.

In addition, check("memory" in ...) fails the test with AssertionError inst=
ead
of enabling +memory or skipping when the controller is not delegated,
next(... if line.startswith("0::")) raises an uncaught StopIteration if cgr=
oup
v2 is not mounted, and original hardcodes /sys/fs/cgroup even when --cgroup
points to a different mount point.

> +        with contextlib.closing(Queue()) as queue:
> +            try:
> +                queue.configure(1 << 20, bind=3DTrue)
> +            except OSError as error:
> +                check(error.errno =3D=3D errno.ENOMEM, f"unexpected BIND=
 refusal: {error}")

[Severity: Medium]
Does queue.configure() fail with EOPNOTSUPP instead of skipping on 32-bit
kernels?

In mm/memcontrol.c, mem_cgroup_reservation_resize() returns -EOPNOTSUPP when
!IS_ENABLED(CONFIG_64BIT) and res->objcg is non-NULL during positive
reservation growth.  Because the script runs in an unshared network namespa=
ce,
instance_create() initializes inst->memcg via mem_cgroup_reservation_init(),
causing reservation(), reservation_startup(), and any test started inside a
non-root cgroup (such as a systemd slice) to raise OSError(EOPNOTSUPP) on
32-bit kernels and fail instead of skipping.

[ ... ]

> +            check(queues and refused is not None,
> +                  "expected successful queues followed by aggregate refu=
sal")
> +            queues[0].configure(0)
> +            refused.configure(4096, bind=3DTrue)
> +        # Reparent an occupied reservation, then grow and refund it in i=
ts parent.
> +        (group / "cgroup.procs").write_text(str(os.getpid()))
> +        with contextlib.closing(Queue()) as queue:
> +            queue.configure(32, bind=3DTrue)
> +            (original / "cgroup.procs").write_text(str(os.getpid()))
> +            group.rmdir()
> +            queue.configure(64)
> +            queue.configure(0)

[Severity: Low]
Does leaving the ExitStack block without calling configure(0) on queues[1:]
and refused leave 63 MiB charged to group when the reparenting test starts?

Closing a queue socket without shrinking its limit to 0 first defers
mem_cgroup_reservation_destroy() to instance_destroy_work() via
queue_rcu_work().  Until the RCU grace period and workqueue finish, 63 MiB =
of
the 64 MiB memory.max limit remains charged, which can cause the subsequent
queue.configure(32, bind=3DTrue) call (which uses GFP_NOWAIT try_charge() w=
ithout
draining remote per-CPU stock caches, especially on 64K-page kernels where
MEMCG_CHARGE_BATCH is 4 MiB) to fail with ENOMEM and causes group.rmdir() to
reparent the dying queues alongside the 32-slot queue.  Calling configure(0=
) on
each open queue before closing makes the refund synchronous.

[ ... ]

> +def main():
> +    parser =3D argparse.ArgumentParser(description=3D__doc__)
> +    parser.add_argument("--cgroup")
> +    parser.add_argument("--inside-netns", action=3D"store_true", help=3D=
argparse.SUPPRESS)
> +    args =3D parser.parse_args()
> +    if not all(shutil.which(tool) for tool in ("nft", "ip", "unshare")):
> +        print("1..0 # SKIP nft, ip and unshare are required")
> +        return 4
> +    if not args.inside_netns:
> +        probe =3D subprocess.run(["unshare", "-n", "true"], capture_outp=
ut=3DTrue)
> +        if probe.returncode:
> +            print("1..0 # SKIP cannot create a network namespace")
> +            return 4
> +        return subprocess.call(["unshare", "-n", sys.executable,
> +                                str(Path(__file__).resolve()), "--inside=
-netns",
> +                                *(["--cgroup", args.cgroup] if args.cgro=
up else [])])

[Severity: Low]
Could this test use the shared Python kselftest helpers in
tools/testing/selftests/net/lib/py/ (ksft.py and netns.py) and factor the
duplicated cgroup setup in reservation() and reservation_startup() into a
shared helper?

Using the shared harness avoids hand-rolling namespace creation and KTAP
formatting (where early skips omit the "TAP version 13" header and multiline
exception messages print without a "#" prefix).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115-b4-nfqueue=
-memory-accounting-v1-0-b9cc30819997@asgari.net?part=3D9

