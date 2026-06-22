Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC34FCD98F0
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 03:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6C5F6B008C; Sun, 21 Jun 2026 23:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1CD96B0092; Sun, 21 Jun 2026 23:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934776B0093; Sun, 21 Jun 2026 23:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C11B6B008C
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 23:13:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2F7BA0574
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:13:03 +0000 (UTC)
X-FDA: 84906077046.18.FF13867
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0026340002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:12:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="b/JPhVoR";
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782097982;
	b=lKjN6LJozd0Zrzajplcl1OUVf1WxLqbVphlYnR4DX29PWADZAYQBScn5W0mm/TGel7sd4b
	I4UT35lGVqdLOLsi5ze6L1mDVHzKM8cY2o7F/DegD9F7fykGKmFAV307Io9X1ZZsU7z9O0
	LfVEL4dSQs4I2v/aJiB+ubTA6I9QRZA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="b/JPhVoR";
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782097982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EVDknkMPYHwtjP5EdM2HdKpVYJO996AavSVHwEl4Jgg=;
	b=uLda/yT8uOXUXUnCxX04fGYBzD00bOiBoV8cYSyxj5rrra4tmwjbd/52WQ7lM2QoMnvpTb
	GaRfCC2vIVGFywx4xfjVxobBHXTL7xwHNYWspP4476A7Vx5v9dEHgPSNOeAN3J1ilYjSVp
	fXA8wGOLek6PzYYRRXvpbOsGBR0VmXs=
Message-ID: <6af11da2-affa-414c-8426-168224cd2f69@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782097977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EVDknkMPYHwtjP5EdM2HdKpVYJO996AavSVHwEl4Jgg=;
	b=b/JPhVoR4HIOdlvHluL12MOhVou49Gn84LSlMtzYCuWS6+mTapMbpQ1g++sabTlfvQkoXd
	Ez/c5VWCYsFwb34UBuCG1yZOZeOZZ7I01V9fsdduYPIynB9CSkwYENorv7+cSS4yNJ8CbI
	z6JsLHAjdHKBihRw+2XcrSFUGSetBbc=
Date: Mon, 22 Jun 2026 11:12:34 +0800
MIME-Version: 1.0
Subject: Re: [BUG] mm: mglru: stale aging batch triggers lru_gen_exit_memcg
 warning
To: Peiyang He <peiyang_he@smail.nju.edu.cn>, akpm@linux-foundation.org,
 hannes@cmpxchg.org, linux-mm@kvack.org
Cc: mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, kasong@tencent.com, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 david@kernel.org, ljs@kernel.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
References: <5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0026340002
X-Stat-Signature: um895x76yrja53iuj5ubbwizdin9db1d
X-HE-Tag: 1782097979-1712
X-HE-Meta: U2FsdGVkX19BkUiX6m5CcJLw6dydQM0xxCt0LNsyHIg3AOKzHHQhMqAeZAzv/Ctn84MciGXIgRD3u3vWGZE1LEdUnVoBCPBmu7hesyeKi216NLNxZLtJ7Q+w19ZKpwlVGs5ocgSWU4HpqoYXHSeATVD+D/8UgeBzFNd46KCSjvtKu6DhExRKrZcqpOVc4HJvf8l+ta4q1CFSue6XdafaRzpUMRzXrtQW1kVEBbqSAZ+rsHbcSt9b/MZjO6XrhrdBF8gE76NB9ei24bC1U5QLElRzXv7jKtPckDhHiSTsc3stRyjbaUgC3W9nHdYfjgg4C8qyOx1S7fRwZ5y8UGl2E0fkKIs0uNTB9XfIBD2bQ/ERnfcMvaDx45vHYrAsWlZ/cXDGlhRc9ChDwky5JpMoVgU22PJmRr55MxLPm7LfNQGvz9pTdgSpJCHJj09oh5Zilg4J8p8C/Zdys7lsXfzX9tWV7ta4nt7uouhmYGiL9U6SewyLpkqyChPYF0vSyHZ3KQipNKSEmEO9ECOqN0dxTtKsO3CFs719EvfT6gddPL6aLcBlV56cBJuKS4VxXg7gmJ2iYqHsBc4yEBcddf1W2Z4XPKxIh5IlEOix0dRNmSTC7ginB5FdJX86TjKYyHQHj3L7Zm7PsyP6OQ1/KAqxDtPzD2/flOSSieotodvvFW1ILuesqcQJQfluOxzKRf7K0uZeSqi2VGKljcL1PSd3ZEE+HVUdls8fdwIoP1C7JnVZMkxAbadmLOfsTEPOZYL4UR1IOL+BZXpvlNxarNsUTzy9/JskxBf5b2RU7QUQqjlcjWYgOzc4UkUhAsgEk8kcDHBPUZF4j6RcjCrArWoy+/EBYIbeOqdu9AO1B31df/0wmEjkptiKuJ94B2ymfuDEyHaSkOGEjRb2fIDoFY5QDkODRaosCuJnVm7gcCCQrURAOBFNxBrVUsc9ZavJIEo4VPc58huDPUSbzMjlvPi
 F3BI53oz
 uUZ4Knyea1zq5vQDF1CCXYdvpwAmvYwT/NuHsOea/8OMsPNsyhl7eD73hayJPiOjrBzkZRl1eJYAxYe5KrCIx7YJUAHB14gtw1uzNbEjyriXjJW3mD8e5QcmQh4cW5bLEw6d0w7BML9A/3/RMwSEOw3rAtat0XjW6TTbroxOw/vnfuSot336lyJE/GMt8iS6gC6ow/lUHJjLB4YxzoLmPeUV5bgpeYBlpSFdzb6Jf/i+BubxZx5wUhsBWhNq1UYHbfpvTZCgfbrVob7V8eKfcKO1O6gtyoVIGGX6Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peiyang,

Thanks for reporting this issue!

On 6/21/26 9:50 PM, Peiyang He wrote:
> Hello,
> 
> I hit the following warning while fuzzing other kernel code with Syzkaller.
> 
> The original Syzkaller report:
> 
> WARNING: mm/vmscan.c:5867 at lru_gen_exit_memcg+0x26f/0x300 mm/ 
> vmscan.c:5867, CPU#0: kworker/0:0/9
> Modules linked in:
> CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Not tainted 7.1.0 #2 PREEMPT(full)
> Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 
> 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> Workqueue: cgroup_free css_free_rwork_fn
> RIP: 0010:lru_gen_exit_memcg+0x26f/0x300 mm/vmscan.c:5867
> Code: 89 de e8 d4 62 ba ff 49 83 fd 3f 0f 86 9c fe ff ff 48 83 c4 08 5b 
> 5d 41 5c 41 5d 41 5e 41 5f e9 17 68 ba ff e8 12 68 ba ff 90 <0f> 0b 90 
> e9 b0 fe ff ff e8 04 68 ba ff 66 90 e8 fd 67 ba ff 90 0f
> RSP: 0018:ffffc900001afb78 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff82049e88
> RDX: ffff888016f35c40 RSI: ffffffff8204a02e RDI: ffff88801d4103b8
> RBP: dffffc0000000000 R08: 0000000000000005 R09: 0000000000000040
> R10: 0000000000000000 R11: 0000000000002ba4 R12: ffff8880481f1600
> R13: ffff88801d410650 R14: ffff88801d410040 R15: dead000000000100
> FS:  0000000000000000(0000) GS:ffff888098d91000(0000) 
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055ac6490c1d8 CR3: 00000000249b0000 CR4: 0000000000350ef0
> Call Trace:
>   <TASK>
>   mem_cgroup_free mm/memcontrol.c:3972 [inline]
>   mem_cgroup_css_free+0x76/0xb0 mm/memcontrol.c:4241
>   css_free_rwork_fn+0x125/0x1260 kernel/cgroup/cgroup.c:5575
>   process_one_work+0xa0d/0x1c30 kernel/workqueue.c:3314
>   process_scheduled_works kernel/workqueue.c:3397 [inline]
>   worker_thread+0x645/0xe80 kernel/workqueue.c:3478
>   kthread+0x367/0x480 kernel/kthread.c:436
>   ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>   </TASK>
> 
> Kernel version: commit 8cd9520d35a6c38db6567e97dd93b1f11f185dc6 (tag v7.1)
> 
> Relevant kernel config:
> 
>    CONFIG_MEMCG=y
>    CONFIG_LRU_GEN=y
>    CONFIG_LRU_GEN_ENABLED=y
>    CONFIG_LRU_GEN_WALKS_MMU=y
>    CONFIG_NUMA=y
> 
> Root Cause:
> 
> The bug is a race between two code paths that each hold `lruvec- 
>  >lru_lock`, but at
> non-overlapping times.
> 
> Component 1 - `reset_batch_size()`:
> 
> During `walk_mm()`, `update_batch_size()` accumulates per-generation 
> page deltas into
> `walk->nr_pages` WITHOUT holding `lruvec_lock`.  After 
> `mmap_read_unlock(mm)`, the
> walker reacquires `lruvec_lock` and `reset_batch_size()` writes those 
> deltas
> UNCONDITIONALLY into `lrugen->nr_pages`.
> 
> Component 2 - `lru_gen_reparent_memcg()`:
> 
> When a memcg is offlined, `lru_gen_reparent_memcg()` moves all folios to 
> the parent
> lruvec and zeros the child's `lrugen->nr_pages`, all under `lruvec_lock`.
> 
> I have not bisected the issue.  Based on code inspection, the important 
> interaction
> appears to be the reparenting path that clears the child's `nr_pages` while
> `reset_batch_size()` can still commit a batch that was generated before 
> the memcg
> went offline.  This looks related to f304652609ea ("mm: vmscan: prepare for
> reparenting MGLRU folios").
> 
> Race sequence:
> 
>      1. The aging path enters walk_mm() for the child memcg lruvec.
> 
>      2. walk_page_range() scans PTEs and update_batch_size() stores 
> deltas in
>         walk->nr_pages.  At this point the deltas have not been 
> committed to
>         lruvec->lrugen.nr_pages yet.
> 
>      3. walk_mm() drops mmap_read_lock(mm).  Before it reaches
>         reset_batch_size(), the child memcg is killed and removed.
> 
>      4. The memcg offline path runs lru_gen_reparent_memcg().  Under
>         lruvec_lock, it moves the child folios to the parent and clears the
>         child's lrugen.nr_pages.
> 
>      5. The old aging walk resumes, takes lruvec_lock, and 
> reset_batch_size()
>         writes the stale walk->nr_pages deltas back into the original child
>         lruvec.
> 
>      6. Later, lru_gen_exit_memcg(child) checks the child's 
> lrugen.nr_pages with
>         memchr_inv(...).  Since the stale batch made some slots non-zero 
> again,
>         VM_WARN_ON_ONCE() triggers.

It seems this race can actually happen.

> 
> The two critical sections are serialized by `lruvec_lock`, but the batch 
> accumulation
> in `walk->nr_pages` happens outside that lock, so there is no ordering 
> between the
> accumulation and the reparenting zeroing.
> 
> The relevant code path:
> 
>    mm/vmscan.c:
>      run_cmd('+')              selects the target memcg and child lruvec
>      try_to_inc_max_seq()      stores the child lruvec in walk->lruvec
>      update_batch_size()       accumulates deltas in walk->nr_pages
>      walk_mm()                 calls walk_page_range(), then later 
> reset_batch_size()
>      reset_batch_size()        writes cached deltas into walk->lruvec- 
>  >lrugen.nr_pages
>      lru_gen_reparent_memcg()  reparents child MGLRU state and clears 
> child nr_pages
>      lru_gen_exit_memcg()      warns if the exiting memcg has non-zero 
> nr_pages
> 
>    mm/memcontrol.c:
>      mem_cgroup_css_offline()  calls memcg_reparent_objcgs() and 
> lru_gen_offline_memcg()
>      mem_cgroup_free()         calls lru_gen_exit_memcg()
> 
> Reproducer:
> 
> The C reproducer and the helper script for running it are provided in 
> the attachments.
> 
> The PoC creates a leaf memory cgroup, moves a victim process into it, 
> and makes the victim fault and continuously touch file-backed pages so 
> MGLRU aging can produce cached generation deltas for that memcg. A 
> separate `lru_ager` thread repeatedly writes aging commands to `/sys/ 
> kernel/debug/lru_gen`; when the instrumentation reports that the ager is 
> delayed just before `reset_batch_size()`, the PoC kills the victim and 
> removes the leaf cgroup, forcing memcg offline/reparenting before the 
> stale batch is committed.
> 
> The helper script builds the PoC, creates a temporary qcow2 overlay, 
> boots the instrumented kernel in QEMU with fake NUMA and SSH port 
> forwarding, copies the PoC into the guest, runs it, and scans the serial 
> console for `exit_nonzero`, `WARNING: mm/vmscan.c`, or `Kernel panic`. 
> It writes the full serial console, extracted kernel events, and guest 
> stdout/stderr under the chosen output directory.
> 
> The example command:
> 
>    ./repros/lru_gen_exit_memcg/run_poc_qemu.sh /tmp/lru_gen_poc_manual 
> 10450 20 32
> 
> The arguments are:
> 
>    /tmp/lru_gen_poc_manual  output directory for the overlay, console log,
>                             extracted events and guest log
>    10450                    host TCP port forwarded to guest SSH
>    20                       number of PoC iterations to run
>    32                       file-backed working-set size in MiB per 
> iteration
> 
> The script uses default `KERNEL`, `IMAGE` and `SSH_KEY` paths, or they 
> can be
> overridden with environment variables.
> 
> Since this bug requires a specific race window, kernel instrumentation 
> is needed
> to enlarge the race window in order to reproduce the bug more reliably.  
> The
> instrumentation patch is also included in the attachments.
> 
> The patch only instruments `mm/vmscan.c`: it delays the PoC aging task just
> before `reset_batch_size()`, logs when a stale batch is written into an 
> already
> offlined and zeroed memcg lruvec, and dumps the non-zero 
> `lrugen.nr_pages` slots
> before `lru_gen_exit_memcg()` triggers the warning.
> 
> A successful run reports `status=repro_triggered`, and the extracted events
> include a warning like:
> 
>    WARNING: mm/vmscan.c:5943 at lru_gen_exit_memcg+0x420/0x520
> 
> Proposed Fix:
> 
> One possible fix direction is to make `reset_batch_size()` skip writing 
> back the
> stale delta when the memcg is no longer online. `reset_batch_size()` is 
> called
> under `lruvec_lock`, the same lock that `lru_gen_reparent_memcg()` holds 
> when it
> zeroes `nr_pages`, so this should avoid committing a batch after 
> reparenting has
> completed.
> 
> Possible fix direction, not a tested patch:
> 
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -... reset_batch_size() ...
>   static void reset_batch_size(struct lru_gen_mm_walk *walk)
>   {
>       int gen, type, zone;
>       struct lruvec *lruvec = walk->lruvec;
>       struct lru_gen_folio *lrugen = &lruvec->lrugen;
> +    struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> 
>       walk->batched = 0;
> 
>       for_each_gen_type_zone(gen, type, zone) {
>           enum lru_list lru = type * LRU_INACTIVE_FILE;
>           int delta = walk->nr_pages[gen][type][zone];
> 
>           if (!delta)
>               continue;
> 
>           walk->nr_pages[gen][type][zone] = 0;
> +
> +        /*
> +         * If the memcg went offline while we were walking page tables,
> +         * lru_gen_reparent_memcg() has already zeroed nr_pages and moved
> +         * all folios to the parent.  Writing our stale batch delta back
> +         * would corrupt the offline child and trigger WARN_ON in
> +         * lru_gen_exit_memcg().  Discard the delta; the parent lruvec
> +         * already owns the pages and accounts for them correctly.
> +         */
> +        if (memcg && !mem_cgroup_online(memcg))
> +            continue;

This check is insufficient, because offline_css() clears the CSS_ONLINE
after ss->css_offline(css). And we can not simple drop the delta.

Thanks,
Qi

> +
>           WRITE_ONCE(lrugen->nr_pages[gen][type][zone],
>                  lrugen->nr_pages[gen][type][zone] + delta);
> 
>           if (lru_gen_is_active(lruvec, gen))
>               lru += LRU_ACTIVE;
>           __update_lru_size(lruvec, lru, zone, delta);
>       }
>   }
> 
> Thanks


