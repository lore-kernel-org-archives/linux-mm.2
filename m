Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F9E9D3CCA7
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 03:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5BAC6B0088; Wed, 14 Jan 2026 22:47:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D09B86B0089; Wed, 14 Jan 2026 22:47:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEB536B008A; Wed, 14 Jan 2026 22:47:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB0FE6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:47:24 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36CB756433
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:47:24 +0000 (UTC)
X-FDA: 84332813208.04.6E190BD
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9F2D6C000A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:47:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tKEz2bV2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768448842; a=rsa-sha256;
	cv=none;
	b=n2moptLF1OjAalGyanFlh8JMQOseU6EncnEBiDztX8355z0bfhVFHSziHHxlys6JCyIUdA
	uzRcoUdmzNcYJIKu9GrFgIPQhGE26l48amNcDJWU/PTadQq2QQyJKKTorHtKcTKNG1xO0o
	ikORJ6vCoNljsVDAhL2j3ZL2gnbwaiU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tKEz2bV2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768448842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6NuGNan8e6U/xEMs4AC1GrNFBgKW5vvEKh59uciMY3Y=;
	b=sdizT2j8HZkw+AHj77zeRD44gocxoUVQirpcd7h5DqVMeaXBXKCkBHcmuCGf2ETl5LpGXU
	mprtdVOMDmzeBizVKmMO0yDCgbB/+d6QFznYxVI9euBXGBW2uItYqJGQ5IzKGRXCZvnJlx
	xzQhe0aMrpHlzXyWJF+RC0Z/RgWAXyI=
Message-ID: <e01a57e0-abbb-4c40-8264-4a212a3ec07b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768448838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6NuGNan8e6U/xEMs4AC1GrNFBgKW5vvEKh59uciMY3Y=;
	b=tKEz2bV2zbbzUWK/Uh6ApIMeNVExEvQkPTlpCS+spEHJMManJ6WHfiGERVFRctxWh0JjkH
	UkV1pt8Fx0rr4WdRICo94O3tceJKGlwVAWW/jq+mjgOnDh+eBiaW3Pe/rvDMpMDBx1EH/V
	mcjaoo/Z1D827V9Qdx73loLpPNqH9Dw=
Date: Thu, 15 Jan 2026 11:47:06 +0800
MIME-Version: 1.0
Subject: Re: [syzbot ci] Re: Eliminate Dying Memory Cgroup
To: syzbot ci <syzbot+ci7d2110b831be06f6@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, apais@linux.microsoft.com,
 axelrasmussen@google.com, cgroups@vger.kernel.org, chengming.zhou@linux.dev,
 chenridong@huawei.com, chenridong@huaweicloud.com, david@kernel.org,
 hamzamahfooz@linux.microsoft.com, hannes@cmpxchg.org, harry.yoo@oracle.com,
 hughd@google.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, mkoutny@suse.com,
 muchun.song@linux.dev, nphamcs@gmail.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, songmuchun@bytedance.com, weixugc@google.com,
 yosry.ahmed@linux.dev, yuanchu@google.com, zhengqi.arch@bytedance.com,
 ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <6967cd38.050a0220.58bed.0001.GAE@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <6967cd38.050a0220.58bed.0001.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: o1w71kk6qxqedjpc7k71f61qgwtmxz95
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9F2D6C000A
X-HE-Tag: 1768448840-148744
X-HE-Meta: U2FsdGVkX1+Z/ptvmkjoTVGT3d4vc2YJQ//TL3xEC3R6fcdcLjgkpCLaHLDzyXbrNk3tT9wtBgNXKz1lXh3djMyD8XUdrmfKwHDuP7B/f0dgl/g7llIyDw0pctEJQntnmOaTAZCceRZ73ISNVbdhG5MxdkhUQQWix9I92iT0tNY8s021GWQYRFeiocJNfFAvylrW+mXu8SSpefslLCJTl9KNey1mFF/HuYPZ+HEuD0MtG1JOA2ErMzBO1cMA5FpYklTvH3DKF05cTCNjgU9V2jH8pIbmlh+8GwkANoBfrFKpaTCoI/ECZwedyeLHcR5NXi+FWhjZL5LByfcFuOYSYqZNlQ0tVFBYeAoRImPKFDAMS76EYRxO7C6Ahp6YxRacbPONfqUMSMXPqaMDVzrM0wzj5TALUP/Y4jJQU1h7hPCv5Kbo/wu7L8nyXLlbQkoohLM+bP29OSSs51ZpsriDIbD3FOZbpEiRyrZYtlG0XMF2qtpthdti30YtSI64kv8RxtXbrKJMQaNA/xq4z1gJA9+yAAwWnt3AFfBUqRfkY59D2463A/iBQlhaHwmi/EmY22sxyhJfH0n8YsiaZh/nvVULn6KnqBoAopFLcy4nYJyXjQbVt47zKAjSoQ1V1K6sHjGYsJqbsidmphKdQVu9Wc2NN1v/NLqWkVN6FghTixAQKc8imLcqfNJF4zBXtgmic8SgL5lZi+fyH2z1BSCR7xpaVBYJ6luEFKJSUEjF0U0EuMFfwkcorc9QkzIlfEpfgpZ8LPk26KCvGQC4lFvLZzU4pyUGuI38F77F7t8Vk9PGKKsdtidXF5wYWDCFTWhIVyBjJothCq+sU6UzvJ1cX+BJhlgvtBt+69xHcei7NF036X2W2Ygj+L0Ydmg/a8prS8wLxKLZXEKNuk1loPxTdDRDcdvX67Gjru/niNQJYPR0meCj+U/2PDh4tv5bEZMTkTef5qdzrrs/o8JP+7U
 Im0gCWJ8
 SKakIFIjHqqvGXY6XFRZNJ6/f6Y8R3ES8eN5adgokcQWd5dyUzK0u1hK7436IsMAcL6DgErF2RNIYLpLj+XR2v3vcsE8RbqxwGuPVEWvKoo5GkES5AqjGZk34CeMti5NA2QMqRhYrRrXNIBeldw+5CDJZi6KSkEiUlQYZrKBPmt/gGOjXdeYGtZxsCWRxK24YcuaRSHNRXJA/J48ET+T8za/NaNUwT92n4msFgr/FJElRKioL+HMpfH5LwO75DqeFTz1/v2vaYrqbBI9AmdnB2B/O1kz0dzvza2qL7BvItx1jydtmlAKyssFUceVYiydM5aI7JcSMebs3PX3Yqminwpd/mBNeJI5NQTPRgbUlWuzeUOXuneSWMbTa+PYga2gPnbawcz1OvixBT1N2UaLSANnF/5AQtSipkv/VmxCI3XrRhZ0kb3oGSZ6q+li+eY44fs01oHm45Xbi986kShllyMnffKHaPqTIhGdBwyVQH4dzy5jlc1XvoV0Nq1uRhZke7bI8Xs18FygHUdjMRpGvJeKTsGBT+wNea6okXYB8hsZRmRnuXcABrLERbi5kXtZrJYPr/NzALzbg0R9ae5AmbIrQAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/15/26 1:07 AM, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v3] Eliminate Dying Memory Cgroup
> https://lore.kernel.org/all/cover.1768389889.git.zhengqi.arch@bytedance.com
> * [PATCH v3 01/30] mm: memcontrol: remove dead code of checking parent memory cgroup
> * [PATCH v3 02/30] mm: workingset: use folio_lruvec() in workingset_refault()
> * [PATCH v3 03/30] mm: rename unlock_page_lruvec_irq and its variants
> * [PATCH v3 04/30] mm: vmscan: prepare for the refactoring the move_folios_to_lru()
> * [PATCH v3 05/30] mm: vmscan: refactor move_folios_to_lru()
> * [PATCH v3 06/30] mm: memcontrol: allocate object cgroup for non-kmem case
> * [PATCH v3 07/30] mm: memcontrol: return root object cgroup for root memory cgroup
> * [PATCH v3 08/30] mm: memcontrol: prevent memory cgroup release in get_mem_cgroup_from_folio()
> * [PATCH v3 09/30] buffer: prevent memory cgroup release in folio_alloc_buffers()
> * [PATCH v3 10/30] writeback: prevent memory cgroup release in writeback module
> * [PATCH v3 11/30] mm: memcontrol: prevent memory cgroup release in count_memcg_folio_events()
> * [PATCH v3 12/30] mm: page_io: prevent memory cgroup release in page_io module
> * [PATCH v3 13/30] mm: migrate: prevent memory cgroup release in folio_migrate_mapping()
> * [PATCH v3 14/30] mm: mglru: prevent memory cgroup release in mglru
> * [PATCH v3 15/30] mm: memcontrol: prevent memory cgroup release in mem_cgroup_swap_full()
> * [PATCH v3 16/30] mm: workingset: prevent memory cgroup release in lru_gen_eviction()
> * [PATCH v3 17/30] mm: thp: prevent memory cgroup release in folio_split_queue_lock{_irqsave}()
> * [PATCH v3 18/30] mm: zswap: prevent memory cgroup release in zswap_compress()
> * [PATCH v3 19/30] mm: workingset: prevent lruvec release in workingset_refault()
> * [PATCH v3 20/30] mm: zswap: prevent lruvec release in zswap_folio_swapin()
> * [PATCH v3 21/30] mm: swap: prevent lruvec release in lru_gen_clear_refs()
> * [PATCH v3 22/30] mm: workingset: prevent lruvec release in workingset_activation()
> * [PATCH v3 23/30] mm: do not open-code lruvec lock
> * [PATCH v3 24/30] mm: memcontrol: prepare for reparenting LRU pages for lruvec lock
> * [PATCH v3 25/30] mm: vmscan: prepare for reparenting traditional LRU folios
> * [PATCH v3 26/30] mm: vmscan: prepare for reparenting MGLRU folios
> * [PATCH v3 27/30] mm: memcontrol: refactor memcg_reparent_objcgs()
> * [PATCH v3 28/30] mm: memcontrol: prepare for reparenting state_local
> * [PATCH v3 29/30] mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios
> * [PATCH v3 30/30] mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance helpers
> 
> and found the following issue:
> UBSAN: array-index-out-of-bounds in reparent_memcg_lruvec_state_local
> 
> Full report is available here:
> https://ci.syzbot.org/series/45c0b58d-255a-4579-9880-497bdbd4fb99
> 
> ***
> 
> UBSAN: array-index-out-of-bounds in reparent_memcg_lruvec_state_local
> 
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
> base:      b775e489bec70895b7ef6b66927886bbac79598f
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/4d8819ab-0f94-42e8-bd70-87c7e83c37d2/config
> syz repro: https://ci.syzbot.org/findings/7850f5dd-4ac7-4b74-85ff-a75ddddebbee/syz_repro
> 
> ------------[ cut here ]------------
> UBSAN: array-index-out-of-bounds in mm/memcontrol.c:530:3
> index 33 is out of range for type 'long[33]'

Oh, the size of lruvec_stats->state_local is NR_MEMCG_NODE_STAT_ITEMS,
but memcg1_stats contains MEMCG_SWAP, which is outside the array range.

It seems that only the following items need to be reparented:

1). NR_LRU_LISTS
2). NR_SLAB_RECLAIMABLE_B + NR_SLAB_UNRECLAIMABLE_B

But for 2), since we reparented the slab page a long time ago, it seems
there has always been a problem. So this patchset will only handle 1).


> CPU: 1 UID: 0 PID: 31 Comm: kworker/1:1 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> Workqueue: cgroup_offline css_killed_work_fn
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>   ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
>   __ubsan_handle_out_of_bounds+0xe8/0xf0 lib/ubsan.c:455
>   reparent_memcg_lruvec_state_local+0x34f/0x460 mm/memcontrol.c:530
>   reparent_memcg1_lruvec_state_local+0xa7/0xc0 mm/memcontrol-v1.c:1917
>   reparent_state_local mm/memcontrol.c:242 [inline]
>   memcg_reparent_objcgs mm/memcontrol.c:299 [inline]
>   mem_cgroup_css_offline+0xc7c/0xc90 mm/memcontrol.c:4054
>   offline_css kernel/cgroup/cgroup.c:5760 [inline]
>   css_killed_work_fn+0x12f/0x570 kernel/cgroup/cgroup.c:6055
>   process_one_work+0x949/0x15a0 kernel/workqueue.c:3279
>   process_scheduled_works kernel/workqueue.c:3362 [inline]
>   worker_thread+0x9af/0xee0 kernel/workqueue.c:3443
>   kthread+0x388/0x470 kernel/kthread.c:467
>   ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>   </TASK>
> ---[ end trace ]---
> Kernel panic - not syncing: UBSAN: panic_on_warn set ...
> CPU: 1 UID: 0 PID: 31 Comm: kworker/1:1 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> Workqueue: cgroup_offline css_killed_work_fn
> Call Trace:
>   <TASK>
>   vpanic+0x1e0/0x670 kernel/panic.c:490
>   panic+0xc5/0xd0 kernel/panic.c:627
>   check_panic_on_warn+0x89/0xb0 kernel/panic.c:377
>   __ubsan_handle_out_of_bounds+0xe8/0xf0 lib/ubsan.c:455
>   reparent_memcg_lruvec_state_local+0x34f/0x460 mm/memcontrol.c:530
>   reparent_memcg1_lruvec_state_local+0xa7/0xc0 mm/memcontrol-v1.c:1917
>   reparent_state_local mm/memcontrol.c:242 [inline]
>   memcg_reparent_objcgs mm/memcontrol.c:299 [inline]
>   mem_cgroup_css_offline+0xc7c/0xc90 mm/memcontrol.c:4054
>   offline_css kernel/cgroup/cgroup.c:5760 [inline]
>   css_killed_work_fn+0x12f/0x570 kernel/cgroup/cgroup.c:6055
>   process_one_work+0x949/0x15a0 kernel/workqueue.c:3279
>   process_scheduled_works kernel/workqueue.c:3362 [inline]
>   worker_thread+0x9af/0xee0 kernel/workqueue.c:3443
>   kthread+0x388/0x470 kernel/kthread.c:467
>   ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>   </TASK>
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
> 
> 
> ***
> 
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>    Tested-by: syzbot@syzkaller.appspotmail.com
> 
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.


