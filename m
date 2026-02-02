Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 207E1E73150
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 09:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DA836B0088; Mon,  2 Feb 2026 04:43:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 587DB6B0089; Mon,  2 Feb 2026 04:43:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469AF6B008A; Mon,  2 Feb 2026 04:43:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32FCD6B0088
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:43:01 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C23B5C34F5
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:43:00 +0000 (UTC)
X-FDA: 84399027720.24.865D4CE
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf13.hostedemail.com (Postfix) with ESMTP id 84CF420003
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:42:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=fkusEo0w;
	spf=none (imf13.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770025379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oA2mTx9XxUiJSxogtOuiyEA+2ImHcX6vZMJQITNKwPc=;
	b=uIG9bT1kTqFtGU/M0plpjpmmBfDvAR6a/RgE+KrSZudXE6aSaWlGRGKvb4rZwD21sKvSlX
	6uZE378SeUnXrhcUdqxHbCvj4yYMttuHCsrhnDRq7VO2UW94d5cEOTd4Yh8nkSIr0ivVOb
	qyOX1u2G4n5vpdjpEWiuhwjkPmzYtCw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770025379; a=rsa-sha256;
	cv=none;
	b=WtlD2RHp/6aJO8yOPWCeN161EWIq9gIlzW0MnYDQNb00uCKhePRiLwWtLdbv1MY7ZHOlvY
	rTLF7916RCwiVLlA8csfUIvUFquxNyioG3L7uuyFCVclpNnc/BeD5DptVytszDjcEPb64/
	MpL72D13VbWLaFaLBh+WS+d4St2pEKo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=fkusEo0w;
	spf=none (imf13.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oA2mTx9XxUiJSxogtOuiyEA+2ImHcX6vZMJQITNKwPc=; b=fkusEo0wd83Wa+L6nS30Qd162p
	ooargwvzx45CzCG/9menBx8zHXd/kf6ILBhmg/+4byhOZPPH5/5T229MsFqHRvyq8F3qMK625FUKz
	YCh8TbBO0DrR1CYh+BQbEsCLhgDP0yLcCtPQCHQt/yiKFVDA5ABlds80znO+r3NqzqNtmQ6R8ibD1
	5mPJJ+k2cYE8/eek30ShsvYFdJhMh9rAVO8BY6GgcdSxiCpNAkjyyWAr1MyHaJHJv3ZOBFlygNuD6
	OY/ALWvrbTQ9kSq3L/XI6B77BZk5qppABWQ1pt4kPrw+SE2tjjbeAZwxzfuezIZS1NeTUS1MLI6gY
	/cypfgGw==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmqSE-0000000EBfi-1iKT;
	Mon, 02 Feb 2026 09:42:46 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 3A4FC303047; Mon, 02 Feb 2026 10:42:45 +0100 (CET)
Date: Mon, 2 Feb 2026 10:42:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, shy828301@gmail.com,
	riel@surriel.com, jannh@google.com, jgross@suse.com,
	seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ioworker0@gmail.com
Subject: Re: [PATCH v4 1/3] mm: use targeted IPIs for TLB sync with lockless
 page table walkers
Message-ID: <20260202094245.GD2995752@noisy.programming.kicks-ass.net>
References: <20260202074557.16544-1-lance.yang@linux.dev>
 <20260202074557.16544-2-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202074557.16544-2-lance.yang@linux.dev>
X-Rspamd-Queue-Id: 84CF420003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: sb5jjrbdyncrfz9utwpgzz4itg9mdntn
X-HE-Tag: 1770025378-918419
X-HE-Meta: U2FsdGVkX19Vgkjj9B77r439sOQuP3lu6JlogQpSddxpQC7/vETxgsklIc2iMTYa1b87a27y9q5fHtn57qsWsbKLZ7GH2QbhWTVH6lACPAmJmHQj3wcvydTxArwrD+dmjNw3ypBKRCoL7mIlsUNp74guEHK6y3CswEZqBfc5bvGpcwX3RfvcP2W000moe6dpZOTlv/NF9JnB4X20T1/mLqyeNyaWM3+UbKgmaPBcGvJ5ABxYr2R7l9er0bZghlHTWKBQS+SOAIF0WWvwLaYu9emuwmLzYZzqjS3fD32qW4mPyeyePL3UmjAc3NyxqPkc7SeZDgvFjt6CZR61gWZ8SmmFl/7o7DYzDKQHPIo5sFGCy5RmPLfuZ6kEiUTcrjMORiysW2dhLwzCAKutGFfpGy6pYs+jBb6YraOCJRMmCDW/7b/FArsCL3qBhFdPtnFpDC5bG8rssLPQbm+ooVdeCxYAE/KawoS6iQEmNcVs6AM1HRwwP+pZbA4QzjWrq8hwzVwLTg3z7TjddDLgGJ7VkDXPUcrUY1xuWxYfu59uBH76weMhkQjBXaCe2ayA8DpJAyuSudhUiOHClORwplT5R/C9QhtrPTcpBhOhlKnMNK/YQi9weVkqBSOgWn5NvUvtDcJPwbnelP+3CCgwfKL1cDTAhRIq4rU3A96+fhR6JsDXjD+AfLu3NAmVcsnZeXx1/j+8zhUZuUwiAn38UDT6uRMK2M1AEwFH4zYt4rtvlaCtPJfE2Isu3LT77c5tLcfWjUiRb+AyK+M+oSC9EB9224dHbh37KLy7EGnIs4grW/i9EF50QtmdM49Ev443/W+O4s4wvqpNSz6XiAF2hzmYjtvZhRg0MdVI+JXt75nNMsfcarUyc5ECYc0Li6asEDK+DGVA5bUGA4RlrUqLFf1NLfp/zwDRm089bn2n7bhUqtDUnkNuge0/gWl9eou9PT/neT13dk1gufU0HFhzoX/
 gwkVcqSq
 /2XuvJYOWZjNtWZiMkqxHsXM8p9H7I/w9CXhVxj31QQ2mMsX9H1VITbYmYRik4hKI6ZLzHWAgYfqEcGKSnPU4C51KFSnaFWhV5cDNzzeqtge4iH1LddONnjAVl4a0OsN+LVjwwcAKquGODV5zHTTcB3husWLbGK1tiOSEXmW3rG+X8m+n+ioFc+QDgZHwuKJl7Yj38GImeEyTBjjc4EXcc2rvl2ss9jAuXZJx43V4S+SBAZ6cabioMxw15Vt7Pv+2wLCdZ6JHhN22dq2QKv2/76bepQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 03:45:55PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> Currently, tlb_remove_table_sync_one() broadcasts IPIs to all CPUs to wait
> for any concurrent lockless page table walkers (e.g., GUP-fast). This is
> inefficient on systems with many CPUs, especially for RT workloads[1].
> 
> This patch introduces a per-CPU tracking mechanism to record which CPUs are
> actively performing lockless page table walks for a specific mm_struct.
> When freeing/unsharing page tables, we can now send IPIs only to the CPUs
> that are actually walking that mm, instead of broadcasting to all CPUs.
> 
> In preparation for targeted IPIs; a follow-up will switch callers to
> tlb_remove_table_sync_mm().
> 
> Note that the tracking adds ~3% latency to GUP-fast, as measured on a
> 64-core system.

What architecture, and that is acceptable?

> +/*
> + * Track CPUs doing lockless page table walks to avoid broadcast IPIs
> + * during TLB flushes.
> + */
> +DECLARE_PER_CPU(struct mm_struct *, active_lockless_pt_walk_mm);
> +
> +static inline void pt_walk_lockless_start(struct mm_struct *mm)
> +{
> +	lockdep_assert_irqs_disabled();
> +
> +	/*
> +	 * Tell other CPUs we're doing lockless page table walk.
> +	 *
> +	 * Full barrier needed to prevent page table reads from being
> +	 * reordered before this write.
> +	 *
> +	 * Pairs with smp_rmb() in tlb_remove_table_sync_mm().
> +	 */
> +	this_cpu_write(active_lockless_pt_walk_mm, mm);
> +	smp_mb();

One thing to try is something like:

	xchg(this_cpu_ptr(&active_lockless_pt_walk_mm), mm);

That *might* be a little better on x86_64, on anything else you really
don't want to use this_cpu_() ops when you *know* IRQs are already
disabled.

> +}
> +
> +static inline void pt_walk_lockless_end(void)
> +{
> +	lockdep_assert_irqs_disabled();
> +
> +	/*
> +	 * Clear the pointer so other CPUs no longer see this CPU as walking
> +	 * the mm. Use smp_store_release to ensure page table reads complete
> +	 * before the clear is visible to other CPUs.
> +	 */
> +	smp_store_release(this_cpu_ptr(&active_lockless_pt_walk_mm), NULL);
> +}
> +
>  int get_user_pages_fast(unsigned long start, int nr_pages,
>  			unsigned int gup_flags, struct page **pages);
>  int pin_user_pages_fast(unsigned long start, int nr_pages,

> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index 2faa23d7f8d4..35c89e4b6230 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -285,6 +285,56 @@ void tlb_remove_table_sync_one(void)
>  	smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
>  }
>  
> +DEFINE_PER_CPU(struct mm_struct *, active_lockless_pt_walk_mm);
> +EXPORT_PER_CPU_SYMBOL_GPL(active_lockless_pt_walk_mm);

Why the heck is this exported? Both users are firmly core code.

> +/**
> + * tlb_remove_table_sync_mm - send IPIs to CPUs doing lockless page table
> + * walk for @mm
> + *
> + * @mm: target mm; only CPUs walking this mm get an IPI.
> + *
> + * Like tlb_remove_table_sync_one() but only targets CPUs in
> + * active_lockless_pt_walk_mm.
> + */
> +void tlb_remove_table_sync_mm(struct mm_struct *mm)
> +{
> +	cpumask_var_t target_cpus;
> +	bool found_any = false;
> +	int cpu;
> +
> +	if (WARN_ONCE(!mm, "NULL mm in %s\n", __func__)) {
> +		tlb_remove_table_sync_one();
> +		return;
> +	}
> +
> +	/* If we can't, fall back to broadcast. */
> +	if (!alloc_cpumask_var(&target_cpus, GFP_ATOMIC)) {
> +		tlb_remove_table_sync_one();
> +		return;
> +	}
> +
> +	cpumask_clear(target_cpus);
> +
> +	/* Pairs with smp_mb() in pt_walk_lockless_start(). */

Pairs how? The start thing does something like:

	[W] active_lockless_pt_walk_mm = mm
	MB
	[L] page-tables

So this is:

	[L] page-tables
	RMB
	[L] active_lockless_pt_walk_mm

?

> +	smp_rmb();
> +
> +	/* Find CPUs doing lockless page table walks for this mm */
> +	for_each_online_cpu(cpu) {
> +		if (per_cpu(active_lockless_pt_walk_mm, cpu) == mm) {
> +			cpumask_set_cpu(cpu, target_cpus);

You really don't need this to be atomic.

> +			found_any = true;
> +		}
> +	}
> +
> +	/* Only send IPIs to CPUs actually doing lockless walks */
> +	if (found_any)
> +		smp_call_function_many(target_cpus, tlb_remove_table_smp_sync,
> +				       NULL, 1);

Coding style wants { } here. Also, isn't this what we have
smp_call_function_many_cond() for?

> +	free_cpumask_var(target_cpus);
> +}
> +
>  static void tlb_remove_table_rcu(struct rcu_head *head)
>  {
>  	__tlb_remove_table_free(container_of(head, struct mmu_table_batch, rcu));
> -- 
> 2.49.0
> 

