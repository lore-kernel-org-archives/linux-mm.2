Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C543EA3F25
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 08:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50EFB6B0005; Tue, 10 Feb 2026 03:34:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BC606B0088; Tue, 10 Feb 2026 03:34:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BB546B0089; Tue, 10 Feb 2026 03:34:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B6746B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:34:27 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD7581B315B
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:34:26 +0000 (UTC)
X-FDA: 84427885332.23.1D37441
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf29.hostedemail.com (Postfix) with ESMTP id 05926120009
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:34:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770712465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cUWhJYIqCHE6+fQF466XUzbO26OAh8cHmdRaiCnMAzA=;
	b=4BHECCP+r4V7qvPMsOEHtmyo/+mELstchkLJemymSOrq2RcuJCJ7/6c4qxnTHVQn07ThGI
	j9JFwfek6T96rrvKdPYCRhCyx5TEvhwxcl56ARbitEKKEcHQwJx+7MbVAW4ee9W3pYiiZV
	G5RJ+Ffdyo8itCGSV9LlsZX8KkkQdCI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770712465; a=rsa-sha256;
	cv=none;
	b=i5310CxjUh+/zczROPWa4wX0xSD9WxVSZml0d4ppH/EidyV0Pxcj962XAgQGKASVNaiR/a
	ap41CCw3kOJ2onmKMltc0NCfPBIiKbtQD9gt7G/CyzFqFEl2Lo2R43F5cvPxLFlSeWmbZM
	wxIHoo84BD4atzj65lBOxwEoQInylKQ=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61A8YFsX4138079;
	Tue, 10 Feb 2026 02:34:15 -0600
Message-ID: <0344bfbeb017cafc0f7bd4433eeacd9bc802d9c9.camel@kernel.crashing.org>
Subject: Re: [PATCH] mm: Fix memblock_free_late() when using deferred struct
 page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Alexander Potapenko <glider@google.com>,
        Marco Elver
	 <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 10 Feb 2026 19:34:15 +1100
In-Reply-To: <5a44609fe992624573a3ca0a293888bd623e2a06.camel@kernel.crashing.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <aYJBBs17B-SQXFqq@kernel.org>
	 <279931074239b7f3812c4cb3969f887303c8cc26.camel@kernel.crashing.org>
	 <aYL3zxuTLT8N7C8-@kernel.org>
	 <c3769af482913dd7ee9d5302c8afa990255691a5.camel@kernel.crashing.org>
	 <aYXDeN0WGQG8-cxe@kernel.org>
	 <bf0231accb89709968efb4d8e1be9970aeb716f8.camel@kernel.crashing.org>
	 <e5d5a1105d90ee1e7fe7eafaed2ed03bbad0c46b.camel@kernel.crashing.org>
	 <5a44609fe992624573a3ca0a293888bd623e2a06.camel@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspamd-Server: rspam11
X-Stat-Signature: g5a769sn5rydn6tk9zim14op78g7brrg
X-Rspam-User: 
X-Rspamd-Queue-Id: 05926120009
X-HE-Tag: 1770712464-611296
X-HE-Meta: U2FsdGVkX1/Eylnh9K4XvsOsqtQHGczqUPSBuH7VZXb5jfHk7/aRwYlhViBJdsTLUIfnmSsnOBx77whN99yQoA7BF7KbII4bGZuidrSNLF+A3zpgxGxvXGqPv54tKOH2/goFl2Tt+37xQK7LZba66VdkjwuJ3MKbw4HYiuFST4FfMzDrur1CyRLUUnJQ3Q1GWNxznTNAg5O6gUadYTS32KdVSByVMfPhEjoPZ7X/XuVtWN3kSsVB3SGjhUa7gXtSlAKd7uGjLcC9jw3hFeg/m2oF/iylERXs48+nyS/c27Gq3xxTw3Z8gz0oi9aczBVcm5kFWo6YUrK24wjXvyuFr60cdtXyvwg52Cu1K8FuNonPeKxLQs+aGoPCGaoqRK67HHUE5XO0lt/ICJG9YxhdCprrVEJVXzzKmBlI4WHv+Pj4vH0jR4kqX3vGO2izTn4J64GKx5Ib3LPFhJVBOdcFjBObEKj5alb6gy7odWx0ZcpT2vmokhebOd1lsK7RlTsC1uxorXH3yx6k4qXwFJhcs4vYGA9jUXpiC1RfdRu2Xe6aoW3rK4nR5myNQZH/wwCG5XNuIfTagg3l6OXnFrZd0pHpUjOUYA4em4tnatxClWq/ncZx2t7/ypfRV/6qj2HNaJ97FmvG0ivY6KPzGV/PnuHdbuk+vnRbwam55xnR4OfRwwq4XGiuFPbqiid2q2kO4TmzxFjEC+r+NZ3BmwKrDj2SpTgCi+/N5FI0OS6/++HReDsp7Z5ABY1YddaY5ISCzyRatg11PjM3l8tnInP0PMqq0Djo2eQ6o+4crqu1suRIXPUymxBc1yUMg1UdSJXyiyKKrbWc58wR2avfWRp/w3PE7fXwdcbJdjDKo5+k0RbNV15OwB+iGOsrZ5k/59/BAuBj0VqPKYITsUfizIsyL2puATXTYKbY1k7/68spkh9T4NjjELAS1neP3kTu2B2imQ7whHRlzhQjbNaN1UL
 eX7IuE5e
 MYp9tqfMPZIIbERheHKzwSnysj2nwWuxd8Z6x0D8XGJ9F/bcf1ozeCGysSw1PYyxa4su+vXB8G7WBuh2tkGkxR78WVa6LD/oYJQgMWG25NhejHv8Mrj1NjEQceKi0jqCmwRsbEdV7+uNxkmM0mbtolPGMKBze8hxZOYDOoE9LpFQ8Em2fKWB+Rlmkr2ZRSUEqmdLKcPQ6BTBakv/Y0sSUTPEmpoeLHXlEhy01ZmisKkqE+9s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-02-10 at 17:17 +1100, Benjamin Herrenschmidt wrote:
>=20
> So ... that was a backport to 6.12.68 and my original patch is
> crashing
> the same way ! (it was working last week interestingly enough,
> something else got backported that gets in the way maybe ?).
>=20
> I'm going to have to go back to digging :-(
>=20
> I suspect the pages aren't reserved. I swear this was working :-)

So I rebuilt with a bit of extra debug prints, CONFIG_DEBUG_VM on, and
memblock=3Ddebug ... it's not hitting the reserved check, but it's also
not crashing the same way (still 6.12, I'll play with upstream again
later):

 .../...


[    0.045633] Freeing SMP alternatives memory: 36K
[    0.045633] pid_max: default: 32768 minimum: 301
[    0.045633] memblock_free_late: [0x000000003d36b000-0x000000003d37bfff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] memblock_free_late: [0x000000003b336000-0x000000003d36afff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] memblock_free_late: [0x000000003b317000-0x000000003b335fff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] memblock_free_late: [0x000000003b2f7000-0x000000003b316fff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] memblock_free_late: [0x000000003b000000-0x000000003b1fffff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] memblock_free_late: [0x00000000393de000-0x00000000393defff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] memblock_free_late: [0x0000000038e73000-0x00000000390cdfff] =
efi_free_boot_services+0x11f/0x2e0
[    0.045633] LSM: initializing lsm=3Dlockdown,capability,landlock,yama,sa=
fesetid,selinux,bpf,ima
[    0.045633] landlock: Up and running.
[    0.045633] Yama: becoming mindful.
[    0.045633] SELinux:  Initializing.
[    0.045633] LSM support for eBPF active
[    0.045633] Mount-cache hash table entries: 2048 (order: 2, 16384 bytes,=
 linear)
[    0.045633] Mountpoint-cache hash table entries: 2048 (order: 2, 16384 b=
ytes, linear)
[    0.045633] smpboot: CPU0: Intel(R) Xeon(R) Platinum 8259CL CPU @ 2.50GH=
z (family: 0x6, model: 0x55, stepping: 0x7)
[    0.045633] Performance Events: unsupported p6 CPU model 85 no PMU drive=
r, software events only.
[    0.045633] signal: max sigframe size: 3632
[    0.045633] rcu: Hierarchical SRCU implementation.
[    0.045633] rcu: 	Max phase no-delay instances is 1000.
[    0.045633] Timer migration: 1 hierarchy levels; 8 children per group; 1=
 crossnode level
[    0.045633] smp: Bringing up secondary CPUs ...
[    0.045633] smpboot: x86: Booting SMP configuration:
[    0.045633] .... node  #0, CPUs:      #1
[    0.045633] MDS CPU bug present and SMT on, data leak possible. See http=
s://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for more de=
tails.
[    0.045633] MMIO Stale Data CPU bug present and SMT on, data leak possib=
le. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/processo=
r_mmio_stale_data.html for more details.
[    0.045633] smp: Brought up 1 node, 2 CPUs
[    0.045633] smpboot: Total of 2 processors activated (9999.97 BogoMIPS)
[    0.045633] node 0 deferred pages initialised in 0ms
[    0.045633] Memory: 900460K/999468K available (16384K kernel code, 9440K=
 rwdata, 11364K rodata, 3740K init, 6440K bss, 94600K reserved, 0K cma-rese=
rved)
[    0.045633] devtmpfs: initialized
[    0.045633] x86/mm: Memory block size: 128MB
[    0.045633] ------------[ cut here ]------------
[    0.045633] page type is 1, passed migratetype is 0 (nr=3D16)
[    0.045633] WARNING: CPU: 1 PID: 2 at mm/page_alloc.c:721 rmqueue_bulk+0=
x82e/0x880
[    0.045633] Modules linked in:
[    0.045633] CPU: 1 UID: 0 PID: 2 Comm: kthreadd Not tainted 6.12.68-93.1=
23.amzn2023.x86_64 #1
[    0.045633] Hardware name: Amazon EC2 t3.micro/, BIOS 1.0 10/16/2017
[    0.045633] RIP: 0010:rmqueue_bulk+0x82e/0x880
[    0.045633] Code: c6 05 be be 13 02 01 e8 b0 b5 ff ff 44 89 e9 8b 14 24 =
48 c7 c7 a8 6d 51 8e 48 89 c6 b8 01 00 00 00 d3 e0 89 c1 e8 32 4f d2 ff <0f=
> 0b 4c 8b 44 24 48 e9 79 fc ff ff 48 c7 c6 e0 77 51 8e 4c 89 e7
[    0.045633] RSP: 0000:ffffd592c002f898 EFLAGS: 00010086
[    0.045633] RAX: 0000000000000000 RBX: ffff8e363b2cbc80 RCX: ffffffff8f1=
f0c68
[    0.045633] RDX: 0000000000000000 RSI: 00000000fffeffff RDI: 00000000000=
00001
[    0.045633] RBP: fffffb9c40e3a408 R08: 0000000000000000 R09: ffffd592c00=
2f740
[    0.045633] R10: ffffd592c002f738 R11: ffffffff8f370ca8 R12: fffffb9c40e=
3a400
[    0.045633] R13: 0000000000000004 R14: 0000000000000003 R15: 00000000000=
38e90
[    0.045633] FS:  0000000000000000(0000) GS:ffff8e3639f00000(0000) knlGS:=
0000000000000000
[    0.045633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.045633] CR2: 0000000000000000 CR3: 000000001bc34001 CR4: 00000000007=
706f0
[    0.045633] PKRU: 55555554
[    0.045633] Call Trace:
[    0.045633]  <TASK>
[    0.045633]  __rmqueue_pcplist+0x233/0x2c0
[    0.045633]  rmqueue.constprop.0+0x4b6/0xe80
[    0.045633]  ? _raw_spin_unlock+0xa/0x30
[    0.045633]  ? rmqueue.constprop.0+0x557/0xe80
[    0.045633]  ? _raw_spin_unlock_irqrestore+0xa/0x30
[    0.045633]  get_page_from_freelist+0x16e/0x5f0
[    0.045633]  __alloc_pages_noprof+0x18a/0x350
[    0.045633]  alloc_pages_mpol_noprof+0xf2/0x1e0
[    0.045633]  ? shuffle_freelist+0x126/0x1b0
[    0.045633]  allocate_slab+0x2b3/0x410
[    0.045633]  ___slab_alloc+0x396/0x830
[    0.045633]  ? switch_hrtimer_base+0x8e/0x190
[    0.045633]  ? timerqueue_add+0x9b/0xc0
[    0.045633]  ? dup_task_struct+0x2d/0x1b0
[    0.045633]  ? _raw_spin_unlock_irqrestore+0xa/0x30
[    0.045633]  ? start_dl_timer+0xb0/0x140
[    0.045633]  kmem_cache_alloc_node_noprof+0x271/0x2e0
[    0.045633]  ? dup_task_struct+0x2d/0x1b0
[    0.045633]  dup_task_struct+0x2d/0x1b0
[    0.045633]  copy_process+0x195/0x17e0
[    0.045633]  kernel_clone+0x9a/0x3b0
[    0.045633]  ? psi_task_switch+0x105/0x290
[    0.045633]  kernel_thread+0x6b/0x90
[    0.045633]  ? __pfx_kthread+0x10/0x10
[    0.045633]  kthreadd+0x276/0x2d0
[    0.045633]  ? __pfx_kthreadd+0x10/0x10
[    0.045633]  ret_from_fork+0x30/0x50
[    0.045633]  ? __pfx_kthreadd+0x10/0x10
[    0.045633]  ret_from_fork_asm+0x1a/0x30
[    0.045633]  </TASK>
[    0.045633] ---[ end trace 0000000000000000 ]---
[    0.045633] ------------[ cut here ]------------
[    0.045633] page type is 1, passed migratetype is 0 (nr=3D8)
[    0.045633] WARNING: CPU: 1 PID: 2 at mm/page_alloc.c:686 expand+0x1af/0=
x1e0
[    0.045633] Modules linked in:
[    0.045633] CPU: 1 UID: 0 PID: 2 Comm: kthreadd Tainted: G        W     =
     6.12.68-93.123.amzn2023.x86_64 #1
[    0.045633] Tainted: [W]=3DWARN
[    0.045633] Hardware name: Amazon EC2 t3.micro/, BIOS 1.0 10/16/2017
[    0.045633] RIP: 0010:expand+0x1af/0x1e0
[    0.045633] Code: c6 05 af 06 14 02 01 e8 9f fd ff ff 89 e9 8b 54 24 34 =
48 c7 c7 a8 6d 51 8e 48 89 c6 b8 01 00 00 00 d3 e0 89 c1 e8 21 97 d2 ff <0f=
> 0b e9 e5 fe ff ff 48 c7 c6 e0 6d 51 8e 4c 89 ff e8 eb 23 fc ff
[    0.045633] RSP: 0000:ffffd592c002f828 EFLAGS: 00010082
[    0.045633] RAX: 0000000000000000 RBX: ffff8e363b2cbc80 RCX: ffffffff8f1=
f0c68
[    0.045633] RDX: 0000000000000000 RSI: 00000000fffeffff RDI: 00000000000=
00001
[    0.045633] RBP: 0000000000000003 R08: 0000000000000000 R09: ffffd592c00=
2f6d0
[    0.045633] R10: ffffd592c002f6c8 R11: ffffffff8f370ca8 R12: 00000000000=
00008
[    0.045633] R13: 0000000000038e98 R14: 0000000000000003 R15: fffffb9c40e=
3a600
[    0.045633] FS:  0000000000000000(0000) GS:ffff8e3639f00000(0000) knlGS:=
0000000000000000
[    0.045633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.045633] CR2: 0000000000000000 CR3: 000000001bc34001 CR4: 00000000007=
706f0
[    0.045633] PKRU: 55555554
[    0.045633] Call Trace:
[    0.045633]  <TASK>
[    0.045633]  rmqueue_bulk+0x541/0x880
[    0.045633]  __rmqueue_pcplist+0x233/0x2c0
[    0.045633]  rmqueue.constprop.0+0x4b6/0xe80
[    0.045633]  ? _raw_spin_unlock+0xa/0x30
[    0.045633]  ? rmqueue.constprop.0+0x557/0xe80
[    0.045633]  ? _raw_spin_unlock_irqrestore+0xa/0x30
[    0.045633]  get_page_from_freelist+0x16e/0x5f0
[    0.045633]  __alloc_pages_noprof+0x18a/0x350
[    0.045633]  alloc_pages_mpol_noprof+0xf2/0x1e0
[    0.045633]  ? shuffle_freelist+0x126/0x1b0
[    0.045633]  allocate_slab+0x2b3/0x410
[    0.045633]  ___slab_alloc+0x396/0x830
[    0.045633]  ? switch_hrtimer_base+0x8e/0x190
[    0.045633]  ? timerqueue_add+0x9b/0xc0
[    0.045633]  ? dup_task_struct+0x2d/0x1b0
[    0.045633]  ? _raw_spin_unlock_irqrestore+0xa/0x30
[    0.045633]  ? start_dl_timer+0xb0/0x140
[    0.045633]  kmem_cache_alloc_node_noprof+0x271/0x2e0
[    0.045633]  ? dup_task_struct+0x2d/0x1b0
[    0.045633]  dup_task_struct+0x2d/0x1b0
[    0.045633]  copy_process+0x195/0x17e0
[    0.045633]  kernel_clone+0x9a/0x3b0
[    0.045633]  ? psi_task_switch+0x105/0x290
[    0.045633]  kernel_thread+0x6b/0x90
[    0.045633]  ? __pfx_kthread+0x10/0x10
[    0.045633]  kthreadd+0x276/0x2d0
[    0.045633]  ? __pfx_kthreadd+0x10/0x10
[    0.045633]  ret_from_fork+0x30/0x50
[    0.045633]  ? __pfx_kthreadd+0x10/0x10
[    0.045633]  ret_from_fork_asm+0x1a/0x30
[    0.045633]  </TASK>
[    0.045633] ---[ end trace 0000000000000000 ]---

> >=20
>=20


