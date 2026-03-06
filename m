Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D363F01828
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:51:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34AC6B008C; Fri,  6 Mar 2026 06:51:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF4426B0092; Fri,  6 Mar 2026 06:51:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C353B6B0093; Fri,  6 Mar 2026 06:51:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5BCF6B008C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:51:09 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 872A5B9C82
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:51:09 +0000 (UTC)
X-FDA: 84515472258.24.62C813D
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id CECC41C0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:51:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772797868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=B5gMiIShQvkxNKZXto2z8CDnaz5k0eiYIC/cza0j0z0=;
	b=vogkPuqNQ1aOnjz+dfKO1swoMibaRp1nQXsYsIhPq9W/EwacyIiRAI0w4bUkZZWgmvR4eI
	z8W0ZTMX0hPeSPvUVZYxLhSun0NK2CVgql5u+RJ+o4yB9YQp/YdRTjl4DhRFUKJQX9JNFc
	+vO/PJs1mnedXrCqn2kOfRZZkteLPZU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772797868; a=rsa-sha256;
	cv=none;
	b=0hP2zqFTooqKBiqA1PRkHKnW2xaEL89prjd8ZcghlP7czLXj5xciDmSbQZUcIYlIE6boGy
	SXt+3oTG7HoZDnxE0MudxnGCAk1BxIlBFljlSHLemIDo/FjmggQt6zbMj2meXwjn7/16IR
	rOBGjFhC4ixJqQuSrbjvPf2x1WAT5kU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH 0/2] mm/swap: fix missing locks in swap_reclaim_work()
Date: Fri,  6 Mar 2026 19:50:35 +0800
Message-ID: <cover.1772797581.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CECC41C0005
X-Stat-Signature: 794t4qw8r4xtqe9ammpzdfbmyuo8keth
X-Rspam-User: 
X-HE-Tag: 1772797867-969595
X-HE-Meta: U2FsdGVkX19mduTR6mD8GhrW/xG87u0kykEwtPHh6rT27G/6Xmap/aPBz4mU+ed5gdQVJneA09nxU20jqCsMDMCwKNSbu4ATCYFbEJ+Yi4R0kW7zhQ0oQHmWewS9EpzUYI0MYIje8200bYXBWLZVS/iT82jglVcwqKWfa5HgH53Y/zWwbOgod9OaCNiagR3DJGf5en5xtv9M1c3VdijugLYeDP3/sfICYHOHG4XH9ERF5q5/rgJ75PtJWcnf9yygZRkMKKTg4C6CyDu6X/5H5cRmKZLjlkjLnGlSJsmxGOu8omufQDaFllgKgozTGaX00rkz1LkDoiuM54978nkOxZVK3hOg9S7sEROPtodtUQY3YO+WO65q8ynPeLmXOIQ16wfbO2pVeEnOalp3sevkvcbHudwZxeQkWTAdjS5xcStcfd+CIYE68UuLGWX7qmqVeTU53L54vzp95jVbipniePT/YiC5+gXMG95yYqzNzONfRwPHlx1tiuRccA+FtRc9dtkTamFMDyMpudMGRpZvFLlYjiOt7p9HhA13E3BTqXos0A6hznW4GWl+vuKmyNtJZq/BSWMsBlI35K44L2HmtGXURQj2g++PQ0iBCq+/JYdK18I24piPGmoApBOBrD+8GUY4M7pgVXSw4HNOr03fDQ3bn08/x1B5eJ6R78z/9LLSmjkpD0V0hy2X46VKI7bUJI0665IZCi+YZdXVpUOnezNdxyj98gDIcWmonu0zBNkpqTIb7oPu/fM30K1GJNtsdpmUHCQQTCPosPC92UioprVWzZqaD13H3cpSUSgOxordNwlT3fepSmXj6y37wNuBnV4I+M4cch/17WpuRFDdztzGjDoMfbX6+8G6yji3t+vf9jpUkwasH/l2Q9n54FFGAgwm8B9T7iH45OMPE45JDmFeNwZv3fX368LUq37Ub4uVBcV+7EBKOpqS6H3flEp6/nRfTDx5DGn8FjCE6Bm
 zjwIp44L
 19KlgRXxtgm5gLMvZ6xPHiwLvrTEaK0Dz4rDrB46/JphykdKYpr4BlUyRxYY6aIvgq7PQbLCOq6mUNyS1hL25v85NNpEmRqGryUaLcbfZg9qmsH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

swap_cluster_alloc_table() assumes that the caller holds the following
locks:
ci->lock
percpu_swap_cluster.lock
si->global_cluster_lock (required for non-SWP_SOLIDSTATE devices)

There are five call paths leading to swap_cluster_alloc_table():
swap_alloc_hibernation_slot->cluster_alloc_swap_entry
->alloc_swap_scan_list->isolate_lock_cluster->swap_cluster_alloc_table

swap_alloc_slow->cluster_alloc_swap_entry->alloc_swap_scan_list
->isolate_lock_cluster->swap_cluster_alloc_table

swap_alloc_hibernation_slot->cluster_alloc_swap_entry
->swap_reclaim_full_clusters->isolate_lock_cluster
->swap_cluster_alloc_table

swap_alloc_slow->cluster_alloc_swap_entry->swap_reclaim_full_clusters
->isolate_lock_cluster->swap_cluster_alloc_table

swap_reclaim_work->swap_reclaim_full_clusters->isolate_lock_cluster
->swap_cluster_alloc_table

Other paths correctly acquire the necessary locks before calling
swap_cluster_alloc_table().
But the swap_reclaim_work() path fails to acquire
percpu_swap_cluster.lock and, for non-SWP_SOLIDSTATE devices,
si->global_cluster_lock.

The first patch ensures swap_reclaim_work() correctly acquires
percpu_swap_cluster.lock and si->global_cluster_lock before calling
swap_reclaim_full_clusters(). Without these locks, the preconditions
for swap_cluster_alloc_table() are not met.

The second patch adds lockdep assertions in swap_cluster_alloc_table()
to help catch such locking inconsistencies early.

I tried to reproduce this naturally, but the swap_reclaim_work path
rarely hits the !cluster_table_is_alloced(found) condition. To verify
the fix, I used GDB to force found->table to NULL, which triggered
the following warning due to the missing locks:
[  554.388797] ------------[ cut here ]------------
[  554.388932] WARNING: mm/swapfile.c:480 at isolate_lock_cluster+0x199/0x470, CPU#6: kworker/6:2/656
[  554.388947] Modules linked in:
[  554.388990] CPU: 6 UID: 0 PID: 656 Comm: kworker/6:2 Not tainted 7.0.0-rc2+ #28 PREEMPT(full)
[  554.388995] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  554.389013] Workqueue: events swap_reclaim_work
[  554.389020] RIP: 0010:isolate_lock_cluster+0x199/0x470
[  554.389025] Code: 02 0f 0b 8b 35 dc 69 57 02 85 f6 74 b0 65 48 8b 05 f4 20 af 02 be ff ff ff ff 48 8d b8 60 98 31 84 e8 2b 0e f5 00 85 c0 75 93 <0f> 0b eb 8f 48 89 df e8 0b 78 f6 00 41 f6 45 10 10 0f 84 0b 01 00
[  554.389028] RSP: 0018:ffffc9000183bd68 EFLAGS: 00010246
[  554.389033] RAX: 0000000000000000 RBX: ffff88810a410060 RCX: 0000000000000000
[  554.389037] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[  554.389046] RBP: ffffc9000183bd88 R08: 0000000000000000 R09: 0000000000000000
[  554.389048] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88811108e878
[  554.389049] R13: ffff88811108e800 R14: ffff88811108ea90 R15: ffff888101e41e40
[  554.389051] FS:  0000000000000000(0000) GS:ffff8881b7812000(0000) knlGS:0000000000000000
[  554.389053] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  554.389054] CR2: 000000c000637f80 CR3: 000000010cfd5006 CR4: 0000000000770ef0
[  554.389065] PKRU: 55555554
[  554.389067] Call Trace:
[  554.389068]  <TASK>
[  554.389080]  swap_reclaim_full_clusters+0x6b/0x350
[  554.389083]  ? __pfx_swap_reclaim_work+0x10/0x10
[  554.389090]  ? swap_reclaim_full_clusters+0x52/0x350
[  554.389094]  swap_reclaim_work+0x1a/0x30
[  554.389097]  process_one_work+0x223/0x770
[  554.389106]  worker_thread+0x1c6/0x3b0
[  554.389110]  ? __pfx_worker_thread+0x10/0x10
[  554.389113]  kthread+0xfe/0x140
[  554.389117]  ? __pfx_kthread+0x10/0x10
[  554.389121]  ret_from_fork+0x3d4/0x480
[  554.389125]  ? __pfx_kthread+0x10/0x10
[  554.389129]  ret_from_fork_asm+0x1a/0x30
[  554.389141]  </TASK>
[  554.389142] irq event stamp: 9775
[  554.389144] hardirqs last  enabled at (9781): [<ffffffff8148ca99>] __up_console_sem+0x79/0xa0
[  554.389150] hardirqs last disabled at (9786): [<ffffffff8148ca7e>] __up_console_sem+0x5e/0xa0
[  554.389153] softirqs last  enabled at (8676): [<ffffffff813b3aff>] __irq_exit_rcu+0x13f/0x160
[  554.389156] softirqs last disabled at (8615): [<ffffffff813b3aff>] __irq_exit_rcu+0x13f/0x160
[  554.389159] ---[ end trace 0000000000000000 ]---
[  554.477105] ------------[ cut here ]------------
[  554.477253] WARNING: mm/swapfile.c:480 at isolate_lock_cluster+0x199/0x470, CPU#6: kworker/6:2/656
[  554.477264] Modules linked in:
[  554.477277] CPU: 6 UID: 0 PID: 656 Comm: kworker/6:2 Tainted: G        W           7.0.0-rc2+ #28 PREEMPT(full)
[  554.477284] Tainted: [W]=WARN
[  554.477288] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  554.477291] Workqueue: events swap_reclaim_work
[  554.477294] RIP: 0010:isolate_lock_cluster+0x199/0x470
[  554.477296] Code: 02 0f 0b 8b 35 dc 69 57 02 85 f6 74 b0 65 48 8b 05 f4 20 af 02 be ff ff ff ff 48 8d b8 60 98 31 84 e8 2b 0e f5 00 85 c0 75 93 <0f> 0b eb 8f 48 89 df e8 0b 78 f6 00 41 f6 45 10 10 0f

Hui Zhu (2):
  mm/swap: fix missing locks in swap_reclaim_work()
  mm/swap: add lockdep for si->global_cluster_lock in
    swap_cluster_alloc_table()

 mm/swapfile.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

-- 
2.43.0


