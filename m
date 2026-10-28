Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 022EF606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 10:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DRvFT3Qg
Received: by kanga.kvack.org (Postfix)
	id 28DEF6B05B3; Wed, 28 Oct 2026 06:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265B46B05B7; Wed, 28 Oct 2026 06:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A35E6B05B9; Wed, 28 Oct 2026 06:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB9746B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:06:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3274C0BC3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:06:16 +0000 (UTC)
X-FDA: 85371604752.19.966B253
Received: from mta1.migadu.com (out-30.mta1.migadu.com [95.215.58.30])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6263420003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:06:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DRvFT3Qg;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.30 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gmHmsZMgq8R8AlD94kwTcgJuLE0oJANffXWy8BFPRM0=;
	b=U2UcGoCSDjwyQFssWLMvSG393e3cZSWdKdThy7pUvYLf2pi27fNVI9ZO3t4rTzLONl+0J2
	vVG0+ScvLWJ1IVpLteolldx4/IBdJ6PTYfT23wVR2E6WDQRdAvzf2fNhe0t9PB/dYl0918
	8cq2iGxVX4L/dHg5EP3Cfg78qUCTS98=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DRvFT3Qg;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.30 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181975;
	b=YmwazqLWEbHt+DPXrCZ0oQAF+OcUnviQz9E0eMUiTs744dFdVqLkjsgWLLojSD61BAgwHQ
	fsVLsqLWQpCeX8zztwcM4ZGZ90Z1EnpOoG5FY7dZEOZJUw3qIEisyvXUjWxZs5VbPRdNpi
	BY0UQ9BGqmkLjaqKsPCr/3736sCGWJM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UZgn8pD2NttZaxDu84FvSOmqRpKSe97dXDTfaW/QOy0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793181972; v=1; x=1793786772;
 b=DRvFT3Qg5ybNjAuTH0NM46MesOI+rjF9kN30N9aj4PbuyhyvbsoPKiuv+l1zIXzfSW9Gzy+3
 u4J5Oki02E8wBp2kRJay6v2JYU91f8zVJBy98HnK8G2oJqQKdUrpjHQl6Bi4v+AsmDE8NQELh7y
 Wbolsj366Qb9n8pENCfC1qo4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 8bb92c80f9064327;
	Wed, 28 Oct 2026 10:06:11 +0000
X-Mizu-Trace-ID: 8bb92c80f9064327
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH] mm/vmstat: annotate data race in zone_page_state_snapshot()
Date: Wed, 28 Oct 2026 18:05:49 +0800
Message-ID: <20261028100549.70689-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6263420003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: u379hmksgaxi4w6deih19pyjytfce6c5
X-HE-Tag: 1793181973-210839
X-HE-Meta: U2FsdGVkX1/NbwB0BDGjTpLAAc3lrN/sR9L5aER7D+EZopGZqF0Fy8f64SG+LBhLUI2WDatTBHn4aFFGMtO8bZkvXT31Zlm4UJxgzU49mg65DNq8D+Cl61nXIAkzIa6AxmXmDYeORXXfOeZ06s1hv6OlxsGbaRohDGdFkfaQHn26fvTDT1pyfm3nm8xkhtqKKfYtdV1nogVbDg5gLVv/WYlaMo1tbk8PygL06MTkXcHyEoWcdnbGYvixMMEGkjox98OEMS2zcP7VnQYs7KNVQ9KzC5X6pCm1/Z8UwHpBReAkaxtKvHTYJ2dLSLkWbuQK0UPnaGd8Cfa6Ise9C4E/xsDJyFChQ3oJmLIZe+4I2tryaOk4csCZTRILbOWYykbj+KUm8gArn+hf8NlG4ExZ4e9xckqbAOTIHqVSJ6sdgBNgojWuUvWJ/5wpBQJf7/B9A4OUOFF0DhQmzECZq+8ZZmVVXusM3t9jVdeBe7hdTcGCi9iT6nf8yc9iIIYUFzSCtaqo4Vug4O+XLmhynW10/YSbgAsqGGUIEYSjPTZUjlCRQhFJk9N/df5xwbz/wGP1wj7G5ETr+climH3NnvLKc8OGO/C//MltRtgYpw1QeZc2HyjrOui7P0u+RW5EyD6bsilpMX2fg6MO4XD7HeoZPJ3L+hOjT91JxQfRC0V5QM/6sFdiOX3J/+K84ovauQjgODm4/E1pA9Vm9Y7dz4G28M2INy1dp0ZFqKNOCDFu6+Stzx0mAwi7neNeV5qRpVTgqz+f9pwlyFSh7Xdx83Kf9XJtXa87SoxsTpLm4Ta7KdEKvcY9y18suBomU420dOyLI042V3dt0xCvxqIqS4fDq0rwqeXfzBu5Ly99gyL0NjD8obJ6twldgFG6HgCSUTqXzlvwQPEg+AY37PQQK3PpoCDKINSO+ZJL1PWVi8whYYGeSvk+kmhVFsKcLJYHwHKT/45ufn39++/gyjw3NBg
 lVWKdf5Y
 /cJN2aBhGJCE60u0uhJRqiEfvPw5wlmg4FDHuEBc1KVPXGl+SCOcsYgre3MgDTSm5N1y0VgN0vWXpqfnql/auyl6K3zn9JX6yyrg4jnxPD7fHGhwXD71kPEGdnLIZFudS2pGEtpDSKE3E2JFjHC+LnwsfhprhjPepmYm3Hgkz3oV663KrWBvrLjG+Dtu/ShIWw86RJNZTp3VJbMYVw5qc+/Ia7k9SkceIKwLwROk5kTr5pw+C6GZtI94f5KtB3gUVXoKXDL0WWw2fsbiLvC/nfZ0UJqQDfj+Ts9qj57iJ3cjLR4FPZzmNoRv7MX4Zp3aWe8rsQsC0c2/71tjQS9NFJJpmaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hui Zhu <zhuhui@kylinos.cn>

KCSAN reports a data-race on v6.6 which also exists on mainline:

BUG: KCSAN: data-race in zone_page_state_snapshot root/klinux/./include/linux/vmstat.h:232 [inline]
BUG: KCSAN: data-race in allow_direct_reclaim+0x150/0x290 root/klinux/mm/vmscan.c:6328

race at unknown origin, with read to 0xffff9e0575410740 of 1 bytes by task 209280 on cpu 15:
zone_page_state_snapshot root/klinux/./include/linux/vmstat.h:232 [inline]
allow_direct_reclaim+0x150/0x290 root/klinux/mm/vmscan.c:6328
throttle_direct_reclaim+0x1c4/0x480 root/klinux/mm/vmscan.c:6402
try_to_free_pages+0x177/0x590 root/klinux/mm/vmscan.c:6466
__perform_reclaim root/klinux/mm/page_alloc.c:3966 [inline]
__alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3988 [inline]
__alloc_pages_slowpath.constprop.0+0x3b3/0xdf0 root/klinux/mm/page_alloc.c:4395
__alloc_pages_noprof+0x28a/0x2d0 root/klinux/mm/page_alloc.c:4794
alloc_pages_mpol_noprof+0x181/0x470 root/klinux/mm/mempolicy.c:2270
alloc_pages_noprof+0x7a/0xe0 root/klinux/mm/mempolicy.c:2347
io_mem_alloc_compound root/klinux/io_uring/io_uring.c:2848 [inline]
io_pages_map+0xb9/0x330 root/klinux/io_uring/io_uring.c:2892
io_allocate_scq_urings+0x231/0x300 root/klinux/io_uring/io_uring.c:3933
io_uring_create+0x29c/0x9c0 root/klinux/io_uring/io_uring.c:4091
io_uring_setup+0xb6/0x100 root/klinux/io_uring/io_uring.c:4203
__do_sys_io_uring_setup root/klinux/io_uring/io_uring.c:4230 [inline]
__se_sys_io_uring_setup root/klinux/io_uring/io_uring.c:4224 [inline]
__x64_sys_io_uring_setup+0x66/0xe0 root/klinux/io_uring/io_uring.c:4224
x64_sys_call+0x1816/0x1d90 root/klinux/./arch/x86/include/generated/asm/syscalls_64.h:426
do_syscall_x64 root/klinux/arch/x86/entry/common.c:51 [inline]
do_syscall_64+0x70/0x2a0 root/klinux/arch/x86/entry/common.c:81
entry_SYSCALL_64_after_hwframe+0x76/0xe0

value changed: 0xdd -> 0xb6

Reported by Kernel Concurrency Sanitizer on:
CPU: 15 PID: 209280 Comm: syz-executor.13 Tainted: G S ------- ---- 6.6.89+ #1250
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014

Found by KCSAN testing on an older kernel; the same race still exists on
mainline.

zone_page_state_snapshot() sums the per-cpu vm_stat_diff[] deltas of all
online CPUs with a plain load, while the allocation and free fast paths
update the local delta through this_cpu_cmpxchg() and friends.  Those are
inline asm, and page_alloc.o is excluded from KCSAN, so the writer is not
instrumented and the report is of unknown origin.

The race is benign: the function already documents that the result cannot be
exactly accurate, and every consumer is a reclaim or compaction heuristic
that tolerates an estimate.  Annotate the read with data_race(), following
commit af1c31acc853 ("mm/vmstat: annotate data race for
zone->free_area[order].nr_free").

No functional change intended.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 include/linux/vmstat.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 5b31d8e7ae405..9df3587a29685 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -236,9 +236,15 @@ static inline unsigned long zone_page_state_snapshot(struct zone *zone,
 	long x = atomic_long_read(&zone->vm_stat[item]);
 
 #ifdef CONFIG_SMP
+	struct per_cpu_zonestat __percpu *pzstats = zone->per_cpu_zonestats;
 	int cpu;
+
 	for_each_online_cpu(cpu)
-		x += per_cpu_ptr(zone->per_cpu_zonestats, cpu)->vm_stat_diff[item];
+		/*
+		 * Access to vm_stat_diff is lockless as the result is only
+		 * an estimate. Use data_race to avoid KCSAN warning.
+		 */
+		x += data_race(per_cpu_ptr(pzstats, cpu)->vm_stat_diff[item]);
 
 	if (x < 0)
 		x = 0;
-- 
2.43.0


