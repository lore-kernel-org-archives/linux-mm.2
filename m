Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19F64C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 10:03:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0533F6B00A6; Wed,  1 Jul 2026 06:03:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02AE96B00A8; Wed,  1 Jul 2026 06:03:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAA176B00AC; Wed,  1 Jul 2026 06:03:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C404B6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:03:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 444411A02F7
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:03:43 +0000 (UTC)
X-FDA: 84939771126.22.D3C3188
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf28.hostedemail.com (Postfix) with ESMTP id 00793C0004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:03:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=neHSFNYg;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782900221;
	b=CZe3Y1BTvCvuCAZEfwlOEJYI0AOHEeE+sep9JqZWP7XGr6pLfuGPa0ox695cS1k58MGlOW
	0HzIYhylbQa7pU7LJf/YAgzaGtFWTcGBgXh+BFA0/jLbvshn1hfQvmtcDFDd8llI2TWIiZ
	hDMk3iqAbqQZv6/+2TTtfr2qGD4NTlw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782900221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mNFFO4VPeScOrYJf3hXGt7ANdsY5Px/4ndX+cXNT6ZM=;
	b=aVvbbyiHolIFdnAa1Y5YA75OX76YpmEE6N2Vs7DwTh6F95nTXB+p0yIwkQOantU9vQURbi
	4erZ2ULmLGOA9V2n/WJ/9iHQNkF0XLB2alEIXqWcsKqBU/E2CEhKp23gpmZZq8Qy9msNEU
	zfMp3PQqzVBIPgMV+978c+rVUUMiPVk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=neHSFNYg;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782900215; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mNFFO4VPeScOrYJf3hXGt7ANdsY5Px/4ndX+cXNT6ZM=;
	b=neHSFNYgW0Uiomg231jvPGdTO4DbZVxM4G/+XXG5ELDThtQcum5KP7zCq/1YROoZxK89Sbl4OrMfM0sMZpkkJcWdq7g9ImMsqro3d6BLuSpmI0Iyp6F81qJHk2ASR7cP3iU8bNukdGuPjgFujp88SWkHK1+69Nr4w+EmW0pi0b4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X66r03a_1782900213;
Received: from 30.74.144.109(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X66r03a_1782900213 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 01 Jul 2026 18:03:34 +0800
Message-ID: <623db71c-daab-451c-909f-a8efa56b998b@linux.alibaba.com>
Date: Wed, 1 Jul 2026 18:03:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] shmem: shmem_get_folio_gfp livelock
To: =?UTF-8?B?6ams6LaF?= <machao26@xiaomi.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 =?UTF-8?B?55Sw5a2d5paM?= <tianxiaobin@xiaomi.com>, =?UTF-8?B?5L+e5Lic5paM?=
 <yudongbin@xiaomi.com>, =?UTF-8?B?5p2O6bmP56iL?= <xiaoyaoli@xiaomi.com>,
 "hughd@google.com" <hughd@google.com>, Kairui Song <kasong@tencent.com>
References: <e1c290782eeb419e8c3e18ac6b1f49eb@xiaomi.com>
 <126cb4ced14f4a3fa40c3189bf8a5920@xiaomi.com>
 <49858bc642844e3bbf6449c0f241af04@xiaomi.com>
 <700a2cbf90a2484f979aac858f08f5d4@xiaomi.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <700a2cbf90a2484f979aac858f08f5d4@xiaomi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1bwkwaymar556caz7pj7mgbx87ufmg5q
X-Rspamd-Queue-Id: 00793C0004
X-Rspamd-Server: rspam06
X-HE-Tag: 1782900219-495274
X-HE-Meta: U2FsdGVkX1+uKAOIEaU1977LLGgdeiLWlV7W/TFGgQcLOqJAM6+3KjdfvEcaauoR4EZGAaQmYkx5W7DLq/pYJqSRkRvxwQLOOxGno6IqKeCG9UKVv4+5cypzBJ7vb1ujMGoYUw12PxtCw4eyH7G6i8h2fUP38OT6Ke1aGunMQip+LLomP9t7vt1ZimX4OkGqHyr6EfdDJ8CO15D18zfSPEsLXcsGPu1SkFP3hVMlFTiGSW+OEWi3N+6X+vOsEZOlKI40jugKk+v8tikuk0C/Oa/tWeX2RM+OZrkll0tz2ZysFgIGQJWNpHHleBjUmN0SJfMnEHzkgiuGItjEYD1GVaYedGIPmZl0kkktfQNNdQzXTcgbKqRKfD50BYaOd85q/fwXtVVYf0ZK68aqrYRGfyMB1seLj+7fBkSoP6l4+4Ct68EW0aENatkEK/FAQhNkGkE0wVo6Tf2NHfsGy7WOiO1yKqts3hIEC3vyxpVnfF/3KKK9ZP8GDnuwW+WXT9RDt41RFl33tJKKTgls7MwkPJ4mZPD+l3NTVQ677Zjcf3n3zlPd1Kplkz2f4AkEURAIxMG3+bhmoQXpVh7nzY8+ui6UvcdXngliH7gmVdD83m0giJUWyDESrmlxMrbiDnS/2PzCqAfoFJuUQj/mz7dS332U/BOLWRiUdcRzi174F0vpKT7sA+4dr9uiN2jD9cjYbQ1kzskH/H4Cv+ez6CkSmCIjOe+LIf+ipNoDiHgvMl9/UfZQT9KPx92oBf0OdFTA2uQVMIqh5kYgsNPiVQsyIgG3VJh4IkwYEAFZOO3mZ7jWAueSDQoVoV/jiNzs6oLvp0KnddekI/5lqbQbIpCOdPAXpTPkuJLnQybloaj9OF9leW/ToGZeZn5XEGyZmqel9Dv1EDqc7njLul2YQgnC6hX5tgOvFJTbUZSWVw6Kxp0/MoxEeps919QpL4FA2dOXgWNpCWAfa+jyOx/D43/
 z/QYVCZf
 jZVkzGQWyDL6JYV9fdih0EuW/0kfWPXvKygmOXUWAox8CxXTGLmJVlMmkf4HF85NpUK7eTzJjOeuPHIHY1n7BzhfPx/A6zjHZgeLxdtxk2xjBfL2p7x/Oy6Dpu5jrWbOUX/DmVezADpGfFPV0Fr+WMOMgDcouQgZL06e+eLrSZN9YDC39rq1cbve2kt3wmdPUfs9rXxqQCESiMsEuz+P3CXiL24l7jmckgQk5KmKScglEjcG97W/6AT2mhlBLtcSnZBN7FSEoAgooGXkebk+N4peoKlLSiXfM1So1B5YNwlMwD1ULN05zKCI1QCO80kacleJBKaBjQWTSDmkkzlh0JqNu4KX0b8cl/IRyq/bS0jJ/XZ4ffvG65gqU0LvKS9KwzNMqI+nECNisVq7zX8o04Es/sZFKpVrkypY7k+fVnOJd8bRHnQnduzEGxnkpwrkxLTkJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CC Hugh and Kairui.

On 6/30/26 9:15 PM, 马超 wrote:
> Hello,
> I encountered a bug in the shmem subsystem. Details below.
> 
> [Summary]
> shmem_get_folio_gfp() can livelock when multiple threads fault on the
> same shmem page concurrently. The -EEXIST retry loop (goto repeat) has
> no cond_resched(), causing busy-looping threads to starve the thread
> that holds the swapcache slot, resulting in an indefinite RCU stall and
> system hang.
> [Environment]
> 1.Kernel: 6.18.21 (ARM64, PREEMPT, CONFIG_LRU_GEN=y)
> 2.Triggered by: multi-threaded app with threads constrained to 2 CPUs
> via cpuset
> [Root Cause]
> When multiple threads in the same process fault on the same shmem
> swap entry:
> 1.Thread A enters shmem_swap_alloc_folio(), succeeds at
> swapcache_prepare() (sets SWAP_HAS_CACHE), then enters
> workingset_refault() → lru_gen_refault() → rcu_read_lock().
> While inside the RCU read-side critical section, it is
> preempted via preempt_schedule_irq (IRQ exit path detects
> TIF_NEED_RESCHED).
> 2.Threads B & C enter shmem_swap_alloc_folio(), fail at
> swapcache_prepare() (slot already taken by A), return -EEXIST.
> 3.In shmem_get_folio_gfp():
>      error = shmem_swapin_folio(...);
>      if (error == -EEXIST)
>          goto repeat;// no cond_resched(), tight loop
> 4.Threads B & C spin at 100% CPU on the retry loop. All three
> threads share the same cpuset (CPU0-1,cpus_allowed=0x3).Thread A
> is perpetually preempted and starved — it cannot complete the
> few instructions needed to call rcu_read_unlock().
> 5.The held RCU read lock blocks the grace period indefinitely,
> causing all synchronize_rcu() callers (cgroup operations,
> fd allocation, etc.) to hang, eventually blocking init.
> [Scheduling Details]
> Key observations:
> 1.Thread A was RCU-boosted to prio 98 but accumulated only
> 99ms of execution over the entire stall period (~1200s).
> It was effectively starved despite the priority boost.
> 2.Threads B & C have vruntime=0 and prio 91, indicating
> they run in an RT-equivalent scheduling class (SCHED_FIFO/RT
> policy). Each accumulated ~1134 seconds of execution with
> only ~1600 context switches, meaning they ran uninterrupted
> for ~700ms per scheduling quantum on average.
> 3.Thread A cannot preempt Threads B & C: Although RCU boost
> raised Thread A to prio 98, Threads B & C at prio 91 (lower
> numeric value = higher priority in RT class) have equal or
> higher effective priority. The busy-looping threads never
> voluntarily yield (no cond_resched(), no blocking calls in
> the loop), so Thread A never gets scheduled.
> 4.CPU contention: CPU0 had nr_running=28 and CPU1 had
> nr_running=24, with 3-4 RT tasks per CPU. Thread A competed
> with Thread B on CPU0 but could not win scheduling.
> [Observed Impact]
> 1.RCU stall lasting 910+ seconds (19 consecutive stall
> warnings, grace period g=4398761 never advanced)
> 2.synchronize_rcu_expedited() callers blocked 742+ seconds
> 3.init process hung > 720 seconds → system unresponsive
> [Call Traces]
> Thread A (RCU stall source, sampled 19 times identically):
> __switch_to+0x1a4/0x360 (T)
> __schedule+0x96c/0xf3c
> preempt_schedule_irq+0xec/0x198
> raw_irqentry_exit_cond_resched+0x2c/0x44
> irqentry_exit+0x38/0x64
> exit_to_kernel_mode+0x28/0x38
> el1_interrupt+0x5c/0xa8
> el1h_64_irq_handler+0x18/0x24
> el1h_64_irq+0x84/0x88
> workingset_refault+0x16c/0x79c (P)
>    shmem_swapin_folio+0x8e4/0xd44
>      shmem_get_folio_gfp+0xb8/0x710
>        shmem_fault+0xa0/0x174
>          __do_fault
> do_pte_missing
> handle_mm_fault
> do_page_fault
> el0_ia
> 
> Thread B (busy-loop on CPU0, sum_exec_runtime=1134s):
> xas_load+0x78/0xe4 (P)
>    shmem_swapin_folio+0x950/0xd44
>      shmem_get_folio_gfp+0xb8/0x710
>        shmem_fault → ... → el0_ia
> 
> Thread C (busy-loop on CPU1, sum_exec_runtime=1134s):
> xas_load+0x50/0xe4 (P)
>    shmem_swapin_folio+0xd8/0xd44
>      shmem_get_folio_gfp+0xb8/0x710
>        shmem_fault → ... → el0_ia
> [Question]
> What is the recommended approach to fix this livelock?
> We are considering adding a cond_resched() before the
> goto repeat in shmem_get_folio_gfp() to break the tight
> loop and allow the swapcache-holding thread to make
> progress. Would this be an acceptable fix, or is there
> a better strategy (e.g., bounded retry with fallback,
> or yielding to the specific waiter)?

IIRC, the scheduler maintainers are not a fan of continuing to sprinkle 
random cond_resched() calls throughout the kernel. The scheduling 
decisions should be left to the scheduler itself.

Regarding your issue, could you try the latest kernel? IIUC, this 
problem has already been fixed there (likely from Kairui's swap 
refactoring work [1]).

Now the shmem swapin call trace should be:

shmem_swapin_folio()
   -> shmem_swap_alloc_folio() (I think you use the SYNC swap device)
     -> swapin_sync()

In swapin_sync(), it first checks whether a folio is already present in 
the swapcache. If so, it returns immediately. In your case, threads B/C 
would get the folio that has already been added to the swapcache and 
continue onward, instead of retrying in a loop.

struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long 
orders,
                            struct vm_fault *vmf, struct mempolicy 
*mpol, pgoff_t ilx)
{
         struct folio *folio;

         do {
                 folio = swap_cache_get_folio(entry);
                 if (folio)
                         return folio;
                 folio = swap_cache_alloc_folio(entry, gfp, orders, vmf, 
mpol, ilx);
         } while (PTR_ERR(folio) == -EEXIST);

         if (IS_ERR(folio))
                 return folio;

         swap_read_folio(folio, NULL);
         return folio;
}


[1] 
https://lore.kernel.org/all/20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.c

