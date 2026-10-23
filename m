Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42E4B606A321
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 22:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=XHHPswRg
Received: by kanga.kvack.org (Postfix)
	id 630326B0BF8; Fri, 23 Oct 2026 18:23:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6074C6B0BFB; Fri, 23 Oct 2026 18:23:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 544F46B0BFF; Fri, 23 Oct 2026 18:23:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 233606B0BF8
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:23:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF960C0269
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:23:26 +0000 (UTC)
X-FDA: 85355318412.09.6A237CF
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf20.hostedemail.com (Postfix) with ESMTP id 529911C0003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:23:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XHHPswRg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3W97bagkKCOQZPSKXIOKXMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--tjmercier.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3W97bagkKCOQZPSKXIOKXMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--tjmercier.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792794205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=m7KKbTD6zkxGWQDQagVs7cuoj2KRJ/Aw4DV65L9A76w=;
	b=5Cqj7CG76n+kNnbJQyHQBXX8djYsDLUQaY3tuKtF5GcXdAZxWIqfqQBPDMZRWPSGk4qV3o
	o/MJ+E+p4FoZPW9i1s1LHOd2Ql02tgZrBoNjlCcyi2yyqcMB1csdZeNKPTFcI2uuxd5Svj
	fxJRPm77R4r2Ok3SEJcAJ78D+IsaB2M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XHHPswRg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3W97bagkKCOQZPSKXIOKXMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--tjmercier.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3W97bagkKCOQZPSKXIOKXMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--tjmercier.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792794205;
	b=yKVq8qljuQ+5we+Obv/krdSb+NEXiIYzSZUlAR35suM2v0sXWPJdxYxdCw6ihAWC0s7BIK
	9Hvf15KvmRVUSj+LPEhj0G5rggdq7DmBIKRrgM/5F/ApUpCUmg0gp+SS3YeY0RvL12p0Mc
	89CjKwN+eeZaX1wW9BW2/viod6CgJrU=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc7d2ff0087so847152a12.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792794204; x=1793399004; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=m7KKbTD6zkxGWQDQagVs7cuoj2KRJ/Aw4DV65L9A76w=;
        b=XHHPswRg49DyxlHFsVPGCogd8dRRkAdsI6xxIgpUQkERJfbe9mamfgo/0/CthzYFCq
         650HOaNadENrJXf6BiCl8n3NBtFv/kngciqrxvPsurTZEmprmt/eFvTVpwYtz0NeNsWQ
         dF/EZwm98CwLPIAPBUdsN815RPuD72IQSl17Etn8FLphr7mJDFD5jMbJbwSlIGhenk2A
         uZZELmAFLz2oPg9be+o/NfpJmWgH9JCGGkaKGR/Pq1e/cz4/eJuTpoIcDxyHME1o7wEi
         xeVrNHGeEeK9doNPfdZE4B4Nx4Pt7G6n3F80nPXhbFNodsy0WaIQK2bmI1kAdovctB3w
         u56Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792794204; x=1793399004;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m7KKbTD6zkxGWQDQagVs7cuoj2KRJ/Aw4DV65L9A76w=;
        b=cN908rpDTO3v86jsbsngCX8PaRyHhszV7FoYktXtLbzsldjhditFpEBbQCSspgfOs7
         Dcpz4ZMFttrJd7/72nLa/GPcu8ivVsur3LcW72r7gsod4r1xEytqwfWv6cKy9SO+uE6I
         9mSCYazr9eY01H28dvy+loLUln/rGu/fhYXZ7z94uB9HbZ+XYr1RsFrkWazfiuXBKQO7
         dfPSZ6s5q4Y/DQqzEMwraLNIWUT5GFL2PIK/zCEBGETH34dzhfNLegyltSytAMmg2Frr
         veOzP1uo4OKs36sYx4tKT9Tz3//UN3tJ1rtiIKEYVdbBFeFQRKPJWJ5wxn9YSDE0c7sI
         PgRA==
X-Forwarded-Encrypted: i=1; AKwUvBywJBiyotFcsAwjjfS6hJaSNeYLTXSKqjgDRXCYhqTtLwZWCGdPaW9UsFcqmLzaK5pUpgkvh3buNQ==@kvack.org
X-Gm-Message-State: AFq9FYIrKpKzzK0ARdkv4xgCic0nnYJdq0pU48Aa0NSx1m7z7hHVWQNC
	b6/VT0LyR4jVQHs5oi+tSzWhn3M0Ki5sHSfHxm3c1hR7W6YI4fcG9bF05pZKfRIZUT2Nb+IZE9u
	QiAe/qG8THF7h4+mGpg==
X-Received: from pgby12-n2.prod.google.com ([2002:a05:6a02:650c:20b0:cc7:aab6:f8a6])
 (user=tjmercier job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:7789:b0:3e2:8fdc:a6c4 with SMTP id adf61e73a8af0-3e7bfa57360mr294406637.31.1792794203997;
 Fri, 23 Oct 2026 15:23:23 -0700 (PDT)
Date: Fri, 23 Oct 2026 15:23:13 -0700
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261023222313.3979455-1-tjmercier@google.com>
Subject: [PATCH] mm: memcontrol: fix NULL pointer deref in high_work_func() on
 dying memcg
From: "T.J. Mercier" <tjmercier@google.com>
To: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev
Cc: zhengqi.arch@bytedance.com, akpm@linux-foundation.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, "T.J. Mercier" <tjmercier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 529911C0003
X-Stat-Signature: sipxebhfaznyu4paexjuohjoytamjoq9
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792794205-671246
X-HE-Meta: U2FsdGVkX1+hLlNfnwRautcYFSt8UASbfn8jhuHoq1Vs58vcYfuhZE7OHJtPpzuBKHkNYrxGmgXRXn+EcxoDYlDJnk7TnW7da6pQxv3EJt/DQV7K+X00mGEnUXXYWqpBvDlVBhxI/ZQuxZkc+piuc3YehQzPRNgvPg6wTNsUdxfEF/t2Bq0BqKvMnT3un/W4SJasH0b8h188x7GH6KpYT86Dg5zfx9sYGKIoubm0ryshTDDqNAKX38h2ZRVuLLdbqfJzPT1fc0og+dZTmj+6D8bDBZr8hMVEHttvodescnDG6WcTI1A2lGwvH1DKadyBUE/wTdGBGvANlAgY5niMC+y5KsuNDQI8qCrySvTbF3PD7C6QeYmP9NJcyIHNta1TgMaPP6IYicPCuEl8xZrMj47g9FTxQo5wtssKsztq1QPkKP2wEFK0UmNnAEvMzDiY+JNtkWKZU4yRf9NCC0sBUqGO36iDlKUxf3a4OGmdfxMx8/EDzFbKbVtcMgH2fQLXO9euSB6sDD6y5BojX6E6JqfitwszLKsUdU3/24hXmu2fLu8sA75hsUstQeulkz0oSE6sC+hx/egFfnzye7bz6ZW4Ydic31PePM+GQZxs3Tv3yZT2rcoXb7I6hlfDCLnBRrcFh+uxscFPAAlXVrQiVSixGvFQ+DTu+Zv0aSQH0qiyUGqb+6YAXyati5ka3abG00Dish5ZuXd7uvEUxl8B3L9DH6d2EbpMJHW9+Ua3kJK5/IyZ4TLGFv0Zhx7T8cDX9z7ghl9UYxC+9T4v7o37pLf6uS40fLKCrr+T99q9tuL3gBf6f3Z8wtxzhDPZyY5szdIYfVxh6VP0ZcEgVliAkPVGO5HDuL6134bCDKGSO56m4CdtOjYE+HFNVT4eJUSe7Pko3NhwAK+fbrLuiiBYfsjQWv8W6aJokK9T2LHIwq4s37auJFHQW1nZYPFoGnyfXSnKUTxJ+EeBFY+BWsZ
 tDltFU9x
 QejVA5GdeedSCv6SDsA1anEJCblmHDj+FKyoHsF9eJ8UuzO77KVjp3YXDLNJIo0XDh76tMLSe2jalH0hzTIsgY/VSAxY/CZoNdQgMsrBnynU7jm1Lyv9XvUItWADGd7rvOTowCNxwZSp9wD2ITZ9HMAHQiG7wb7cvHoHK9FdghXnpwu/dB1bT6HjWDV8sHw/m+jyne6/AL7FiPVlx1IVCQxRZmEE3AoHi1JUs4lJnsTzdrC2Y04zlCP9fL1Aee2Aqg9UF6ts1x8phCtRp98s9tct7FTliLU5d/u6oj6FHljjTx04BjAtnE3312kL/OhGHYwT27+pjbIscFlntKBPqEdzvJyKNEdNR7z52SHOZTlsIpqr+vwy99a12FELaCyYx2+yz66q8BDVaNxxS4Ms5S5JSzq0++z1ke1aUV3LvM20uT2/i4+DTp+d3BTH/QVaWkt+vgUKMLrzFB8ZIuf+V2GviJUCf/jtBDtF7V6BPojEx0Zygrj6uBHuGT358+ts46BcxdP4KhP1TIePUs/LRHccCqmhd+uXn1UaQiaMiCoU40WaorEawgKB9YemGu/tdhvRZbJLt6/789JXTh5miAo5EEBYQf0tq43bKjgneu96+/d4Q45iwifaYAf7nHbR0PnRYhbjpSBn0RM2t2db00ZAH97OVt1YnwUNG+hIVfgb7BDM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When memory.high is exceeded in non-task context, try_charge_memcg()
schedules memcg->high_work without taking a CSS reference on the memcg,
and high_work_func() invokes reclaim_high() without pinning the memcg.

Before commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
dying memory cgroup for LRU folios"), memory usage above memory.high
kept the memcg's refcount non-zero. With reparenting, folios and objcgs
charged to a child memcg are reparented to its parent in
mem_cgroup_css_offline(), leaving the offlined child's memory usage
permanently above its memory.high even after its last reference is
dropped.

cancel_work_sync(&memcg->high_work) only runs at the end of teardown in
mem_cgroup_css_free(), so high_work_func() can start or still be running
reclaim_high() after mem_cgroup_css_released() or shrink_many() has
called lru_gen_release_memcg() and unhashed lruvec->lrugen.list. This
causes lru_gen_rotate_memcg() to dereference a NULL pprev pointer.

Fix this by acquiring a reference with css_tryget_online() in
high_work_func() before calling reclaim_high(), and by resetting
memory.high and swap.high to PAGE_COUNTER_MAX in
mem_cgroup_css_offline() so that charges via references on an offlined
memcg do not trigger high_work on the dead child or skip checking live
ancestors in try_charge_memcg().

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 27 Comm: kworker/1:0 Tainted: G    B   W           7.3.0-rc5-g2bba28e98578 #284 PREEMPT(full) <- Taint from lru_gen_rotate_memcg() VM_WARN_ON_ONCE
Tainted: [B]=BAD_PAGE, [W]=WARN
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
Workqueue: events high_work_func
RIP: 0010:lru_gen_rotate_memcg+0x1a3/0xe90
Code: fd 7f 09 45 84 ed 0f 85 64 0c 00 00 48 89 cf c6 83 6a 07 00 00 00 48 c1 ef 03 88 83 69 07 00 00 48 b8 00 00 00 00 00 fc ff df <80> 3c 07 00 0f 85 ec 0b 00 00 48 89 31 40 f6 c6 01 0f 85 4e 00
RSP: 0018:ffa00000001ef4c8 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ff1100000779e440 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ff1100000779b9b0 RDI: 0000000000000000
RBP: ff110000bffd8e40 R08: 0000000000000000 R09: ff1100000779ebb8
R10: ff1100000779ebb0 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: ffa00000001efb30 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ff1100011c0e7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000251ac88 CR3: 0000000009d6c000 CR4: 0000000000751ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? read_ctrl_pos+0x22f/0x3f0
 shrink_lruvec+0x16cb/0x1b80
 ? ret_from_fork_asm+0x1a/0x30
 ? lapic_next_event+0x15/0x20
 ? clockevents_program_event+0x2bb/0x6f0
 ? lapic_next_event+0x15/0x20
 ? __pfx_shrink_lruvec+0x10/0x10
 ? __pfx_clockevents_program_event+0x10/0x10
 ? _raw_spin_lock+0x84/0xe0
 ? __pfx__raw_spin_lock+0x10/0x10
 ? kasan_save_stack+0x30/0x50
 ? psi_group_change+0x381/0x740
 ? __pfx_sched_clock_cpu+0x10/0x10
 ? save_fpregs_to_fpstate+0xc4/0x2c0
 ? finish_task_switch.isra.0+0x1de/0xac0
 ? __schedule+0xf62/0x42c0
 ? __pfx___schedule+0x10/0x10
 ? __pfx___irq_work_queue_local+0x10/0x10
 ? shrink_node+0x626/0x31e0
 shrink_node+0x626/0x31e0
 ? ring_buffer_unlock_commit+0x11d/0x5c0
 ? kswapd_clear_hopeless+0xa0/0x150
 ? __pfx_shrink_node+0x10/0x10
 ? 0xffffffffc0000095
 do_try_to_free_pages+0x255/0x13b0
 ? ring_buffer_unlock_commit+0x11d/0x5c0
 ? reclaim_high+0x10a/0x1b0
 try_to_free_mem_cgroup_pages+0x1f9/0x5a0
 ? __pfx_try_to_free_mem_cgroup_pages+0x10/0x10
 ? irqentry_exit+0xc6/0x670
 reclaim_high+0x10a/0x1b0
 ? __pfx_reclaim_high+0x10/0x10
 ? process_one_work+0x5ff/0x1030
 ? __pfx_high_work_func+0x10/0x10
 process_one_work+0x6e2/0x1030
 ? __pfx___schedule+0x10/0x10
 ? __pfx_process_one_work+0x10/0x10
 worker_thread+0x422/0xbb0
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x2cd/0x3a0
 ? recalc_sigpending+0x15c/0x200
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x368/0x590
 ? __pfx_ret_from_fork+0x10/0x10
 ? __switch_to+0x588/0xf50
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios")
Cc: stable@vger.kernel.org
Signed-off-by: T.J. Mercier <tjmercier@google.com>
---
 mm/memcontrol.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a05d9a8baa1b..84f4a8fd4d16 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2457,7 +2457,10 @@ static void high_work_func(struct work_struct *work)
 	struct mem_cgroup *memcg;
 
 	memcg = container_of(work, struct mem_cgroup, high_work);
+	if (!css_tryget_online(&memcg->css))
+		return;
 	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
+	css_put(&memcg->css);
 }
 
 static void high_irq_work_func(struct irq_work *work)
@@ -4463,6 +4466,8 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
+	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
+	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 
 	zswap_memcg_offline_cleanup(memcg);
 

base-commit: 2bba28e98578de622ef307d00875aa8f8bca3d10
-- 
2.56.0.257.gf7497c7d27-goog


