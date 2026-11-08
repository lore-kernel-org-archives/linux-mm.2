Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9888E606A320
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 12:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=wfSrKb2F
Received: by kanga.kvack.org (Postfix)
	id 977A46B05B2; Sun,  8 Nov 2026 07:52:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9290C6B05B3; Sun,  8 Nov 2026 07:52:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83ECE6B05B4; Sun,  8 Nov 2026 07:52:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BC416B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:52:20 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D26611A049A
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 12:52:19 +0000 (UTC)
X-FDA: 85411939998.14.DB56256
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7783C160004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 12:52:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wfSrKb2F;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794142338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svpyZhT0hr8kOvzNa4hgV0HZTm00COyuBAK63ukUXY4=;
	b=WT1yqfLP6wA8d4QW91FWLGg7T5EZX+HwZ6r2ZVdwkx3WPF+ch4jb5n26LSG4c1rIRQTVo3
	PDcC1tRe8miyFx5Ur/hoj7mONyL+yuLz2CuD5LeIHNgSnxOohiZfTGar6eWoHnECU7e1Ag
	SPFsye3L4RNMrChnE8N7GaUW5c+WfxQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wfSrKb2F;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794142338;
	b=m1f67CC9QJmlz6KQ2GvVE/l6H7+me6Q0NN1Fxvbu9bL2aXItZabSoRpMVrT+cZfKZ8fHAh
	l5q1evD3Uenly7qbpabZyY5vbJKZknCP0Mku/iRxoN1UpkpGL5Ts4dy7sLZqCVKfgd5z/V
	/kRJAv1rSWHUDR9womA2Eo8N4aBncpg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794142333; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=svpyZhT0hr8kOvzNa4hgV0HZTm00COyuBAK63ukUXY4=;
	b=wfSrKb2FCjxjba1tjikMVoxJClCJbBu1WFPrGxjJecXsuUo96D4KLGSj8ZwBtHL/OJcgPOX5ohykwAz0qGYnRvSVwcjlku1Y9mWsksFB9GUdBM8oxmNxR/WX972ZxlXwYlGd53fqN2tLTQuZdYZYn3Mk6zQ/PSjKJkK3PL38juE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R551e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0XEGtSIY_1794142328;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0XEGtSIY_1794142328 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 08 Nov 2026 20:52:09 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Zhiteng Qiu <qiuzhiteng@hygon.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Zi Yan <ziy@nvidia.com>,  Matthew Brost
 <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,
  Byungchul Park <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,
  Alistair Popple <apopple@nvidia.com>,  Xin Hao <xhao@linux.alibaba.com>,
  Dave Hansen <dave.hansen@linux.intel.com>,  <linux-mm@kvack.org>,
  <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mm/migrate: don't batch the TLB flush when there is
 nothing to batch
In-Reply-To: <20261107143456.1590658-1-qiuzhiteng@hygon.cn> (Zhiteng Qiu's
	message of "Sat, 7 Nov 2026 22:34:55 +0800")
References: <20261106041628.1177963-1-qiuzhiteng@hygon.cn>
	<20261107143456.1590658-1-qiuzhiteng@hygon.cn>
Date: Sun, 08 Nov 2026 20:52:07 +0800
Message-ID: <878q33wknc.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7783C160004
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: oajnpxzhumxp74njhsjps9bjxf38wiyq
X-HE-Tag: 1794142336-9572
X-HE-Meta: U2FsdGVkX18m4cR6xUvNtp7HnGELCNvpYuyaN1/Eiq4DYlRuoQ98J979BFQcp6irGrGhDgE1ioNRScOoIPTJ5I2ENwM/hNPWHtu3UAcrgEqKQzVErQwNiagNsSVRunzPBaRyuaNDWnMELYhLVsxIHVyk6Ptg8PGEXP2zhmJBSt5I9aT3/jsYkNitAY2qpYyEFxVIBsogfjbhGviQ7OTpzuUc7hLYzVs112VV5ss99Zph3ZsUX16PJGEOn3lEITf9D8bJUI4vvadpHdiMFvlm8A6PaN33uL4p2JmSwKDph0J29ADjsh5l2G9KRl5dWVtso0yeMSYkvGpzBoYvnRrj/u9W9Xk3V+YuUYqkU1A2GJ5UGii1LIupR9NTCpoTGuyxPBjaJgjAzCuPT1/21CMjh7NahNYgWpvi+VLzlXTwxX7xopZX+SgYgSE0TVw3JtbTO8Sk37+SemM7/LQbvWsbt4joxegUxmUigucQQLI/GUayHa5Hx2rhSXfAT5auhn5tQ0klagbGVEEfalqiV9BBaBOvdB4pZfaxx2pCM9G6BISb3e7a27P46yyGynSsTs0rgrv9o8AAPBu2+RkOsCSQPT79Bz3RnJYnsRUy3OELHHhk2squhQI3qtu7GHn9PZN+YtD9gwYD/+5fmFo9rBu+rR9LoHpaL5LKT4CcGYxusOGB9DIHGr34J1jdnB7Bb7dfJYNz6YRKBKMSXGpgPOL1YCD48VFWzgMFPlvtvZnLZ1Ay7aeiuUpu78QUd9y2nf1X4/hXCHxhlviC93S0aN666vqdvJYhOe7d5Y3XcloeFR0yuoH9pZRX45FoB95PLl8NcRAn70VjAR+iQwpsP6rzwtLLFEmp42Y8Sgb9D2ko4RCpWFPTPMbjWcYcA+Jfh1W8r1jfbcVUaxx8VbE0DoqTi9sMYoh55mK6Mk+cXZWcxPHN3JOCj3X3HWWGVLUHiAwN5Zt3gyagRkEP2yLrRWI
 rTiY/CBw
 e1gWdlHWDm6gC5wwiYEiLAnu+Vrny1Cg8jZ2sOdNHGiPAFFqOKtxntvrYh8QKf0R83Y+rQkWRBllzeWmtF6ZVtGBKvXzWeS74827cGIwKK1F4m6q/gJ8fLe13rQ2XcU8jWdx0xJ2PpejKnlTx8LjkKx3eJXoSO6wkwJ078RZHAh6IyoPKIoh/IVnkkr0i2EnE4nN769dhufeNs4+ZijN70PPaZV7CmBw6MUgfwVTfFpqYsiA6Ht0cGvyVLz4MynOSsexFyfMSOCpWlonveMgCAeYAXvu52hAJTilAtj7STbuhaxexEK8an5eRQwQmADlOHklPXsV4j2XWQtAx/a7xqFFSqc66/nN38plhXAhRqrSf5vCuX3QApWWa7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Zhiteng Qiu <qiuzhiteng@hygon.cn> writes:

> Since commit 7e12beb8ca2a ("migrate_pages: batch flushing TLB"), every
> MIGRATE_ASYNC migration unmaps with TTU_BATCH_FLUSH.  That includes NUMA
> balancing and memory-tiering promotion, which migrate one folio per call
> through migrate_misplaced_folio().  For such a call there is nothing to
> batch, but the batched path still has two side effects:
>
>  - Each batched unmap bumps mm->tlb_flush_batched, and only
>    flush_tlb_batched_pending() marks it flushed.  While NUMA balancing
>    keeps migrating, the scanner's change_pte_range() therefore does a
>    flush_tlb_mm() for every PTE table it changes, which makes the scan
>    much slower.
>
>  - The PTE being migrated is PROT_NONE, which normally needs no flush
>    (b99a342d4f11).  But pte_accessible() treats PROT_NONE as accessible
>    while mm->tlb_flush_pending is raised (on x86, arm64 and riscv),
>    and it is raised for the whole, now much longer, scan.  On x86,
>    each migration that overlaps a scan then does a full
>    arch_tlbbatch_flush() to every CPU in mm_cpumask().
>
> One pass on an unpatched kernel:
>
>   CPU A (task_numa_work)          CPU B..N (workload threads)
>   ----------------------          ---------------------------
>   tlb_gather_mmu()
>     tlb_flush_pending++
>   change_pte_range(table 1)
>     PTEs -> PROT_NONE
>                                   access page in table 1
>                                   do_numa_page()
>                                    migrate_misplaced_folio()
>                                     try_to_migrate_one()
>                                      PROT_NONE, but pending set:
>                                      pte_accessible() == true
>                                      tlb_flush_batched++
>                                     try_to_unmap_flush()
>                                      full flush, IPI to ~380 CPUs
>   change_pte_range(table 2)
>     flush_tlb_batched_pending()
>       pending != flushed:
>       flush_tlb_mm(), IPI to ~380 CPUs
>     PTEs -> PROT_NONE
>                                   (same for pages in table 2)
>   ... 128 PTE tables, ~0.7 ms each ...
>   tlb_finish_mmu()                    pass took ~90 ms, not ~7 ms
>     tlb_flush_pending--
>
> The scan period is long, but the passes are not independent of the
> faults: passes cover only 9-12% of wall time, yet 33-42% of the
> hint-fault migrations overlap one (two separate runs).  60% of those
> are for pages in the chunk being scanned, nearly all the rest for
> pages scanned one or two passes earlier.  The scan creates the faults
> that then overlap it.
>
> On a 2-socket, 384-CPU x86 server without INVLPGB, a 4 KiB-page,
> memory-heavy multithreaded workload takes about 200 TLB shootdown
> interrupts per page migrated by NUMA balancing, and balancing costs it
> 13-16% of its throughput.  With bpftrace on that workload, the scanner
> did about 11,600 full flushes in 55 s, its average mmu_gather took
> about 90 ms (6.7 ms with this patch), and 42% of the migrations saw
> tlb_flush_pending set (3.5% with this patch).  All NUMA balancing
> tunables were at their defaults (scan_delay_ms 1000,
> scan_period_min_ms 1000, scan_period_max_ms 60000, scan_size_mb 256).
>
> Skip the batched flush only when the batch cannot merge anything: the
> folio is the only one in this migrate_pages_batch() call, it is not a
> large folio, and it is mapped only once.  The rmap walk then meets at
> most one PTE, and ptep_clear_flush() invalidates just that page
> without touching mm->tlb_flush_batched.  Everything else keeps the
> batched flush, including PTE-mapped large folios, folios mapped more
> than once, and the batch of sub-folios produced when a partially
> mapped large folio is split during migration.
>
> PMD-mapped THPs already invalidate their mappings through
> set_pmd_migration_entry(), independently of TTU_BATCH_FLUSH, so their
> flush behaviour is unchanged.  arm64 has the same pte_accessible()
> rule, but its flushes are broadcast TLBIs rather than IPIs; the effect
> there has not been measured.
>
> migrate_folio_unmap() cannot see how many folios its caller is
> migrating, so migrate_pages_batch() passes that down.
>
> Measured on v7.3: 120 GiB anonymous working set, 384 threads, 180 s per
> run, three A/B pairs (numa_balancing on vs. off, same boot) per kernel.
>
>                                     v7.3            patched
>   throughput loss from balancing   13.0-16.5%      0.5-6.3%
>   kernel cycles per hinting PTE    1.18-1.22M      0.28-0.31M
>   TLB interrupts / migrated page   202-210         12.7-13.6

IMHO, the description above is a bit too long.  Could you try to make it
more concise?

> Signed-off-by: Zhiteng Qiu <qiuzhiteng@hygon.cn>
> ---
> Changes in v2:
>  - Pass the try_to_migrate() flags directly and use single_folio in
>    the VM_WARN_ON_ONCE(), as suggested by Ying.  No functional change.
>  - Rewrote the changelog after measuring why b99a342d4f11 does not
>    avoid the flush here (see the discussion on v1:
>    https://lore.kernel.org/r/20261106041628.1177963-1-qiuzhiteng@hygon.cn).
>
> Notes:
>
> An earlier version decided on reason == MR_NUMA_MISPLACED.  That also
> dropped batching for the split sub-folio batch mentioned above.  In a
> test that splits partially mapped 2 MiB THPs during NUMA migration, the
> earlier version raised TLB interrupts per migrated page from 0.13 to
> 16.1; this version keeps them at 0.11.  For 64 KiB mTHP and for a
> MAP_SHARED mapping used by two processes, this version behaves like the
> base kernel (TLB interrupts per migrated page: mTHP 2.2-2.7 patched vs.
> 2.6-3.3 base; shared 31.3-31.5 vs. 31.2-31.7).
>
> The earlier version behaves the same as this one for order-0, private,
> single-mapped memory.  These results were measured with it:
>  - 192 CPUs (SMT off, 192 threads, 4 pairs): balancing loss
>    3.1-14.7% patched vs. 7.4-54.3% base.
>  - Memory first-touched on the remote socket, threads on the local
>    socket (6 runs per kernel): no regression in time to convergence or
>    in throughput after convergence.
>  - 2 MiB THP (2 pairs): no difference, as expected for PMD-mapped
>    folios.
>  - A 30-minute run with compaction forced every 30 s: no warnings.
>
> With this version, tools/testing/selftests/mm/migration passes 6/6
> (including the THP and hugetlb cases), the LTP move_pages and
> migrate_pages cases pass 14/14, and the scenario tests above saw no data
> mismatches.
>
> There is no Fixes: tag.  This changes a performance trade-off in code
> that has been there since v6.4, and nobody has reported it as a
> regression.  Please add one if you see it that way.
>
>  mm/migrate.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index cb699ea59d33..c2131169317d 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1222,7 +1222,7 @@ static void migrate_folio_done(struct folio *src,
>  static int migrate_folio_unmap(new_folio_t get_new_folio,
>  		free_folio_t put_new_folio, unsigned long private,
>  		struct folio *src, struct folio **dstp, enum migrate_mode mode,
> -		struct list_head *ret)
> +		bool single_folio, struct list_head *ret)
>  {
>  	struct folio *dst;
>  	int rc = -EAGAIN;
> @@ -1344,7 +1344,19 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>  		/* Establish migration ptes */
>  		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
>  			       !folio_test_ksm(src) && !anon_vma, src);
> -		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
> +		enum ttu_flags ttu = mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0;
> +
> +		/*
> +		 * Batching only pays off when the rmap walk can meet more than
> +		 * one PTE.  A lone order-0 folio with a single mapping has
> +		 * exactly one: batching it gains nothing, and it leaves
> +		 * mm->tlb_flush_batched pending, so later page table changes
> +		 * in this mm (e.g. NUMA scanning) flush the whole mm.
> +		 */
> +		if (single_folio && !folio_test_large(src) &&
> +		    !folio_maybe_mapped_shared(src))
> +			ttu &= ~TTU_BATCH_FLUSH;

Is it possible to use a simplified version as below?

        enum ttu_flags ttu = 0;

        if (mode == MIGRATE_ASYNC &&
            (!single_folio || folio_mapcount(src) > 1))
                ttu = TTU_BATCH_FLUSH;

> +		try_to_migrate(src, ttu);
>  		old_folio_state |= FOLIO_WAS_MAPPED;
>  	}
>  
> @@ -1835,9 +1847,10 @@ static int migrate_pages_batch(struct list_head *from,
>  	LIST_HEAD(unmap_folios);
>  	LIST_HEAD(dst_folios);
>  	bool nosplit = (reason == MR_NUMA_MISPLACED);
> +	bool single_folio = list_is_singular(from);
>  
>  	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
> -			!list_empty(from) && !list_is_singular(from));
> +			!list_empty(from) && !single_folio);
>  
>  	for (pass = 0; pass < nr_pass && retry; pass++) {
>  		retry = 0;
> @@ -1925,7 +1938,8 @@ static int migrate_pages_batch(struct list_head *from,
>  			}
>  
>  			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
> -					private, folio, &dst, mode, ret_folios);
> +					private, folio, &dst, mode, single_folio,
> +					ret_folios);
>  			/*
>  			 * The rules are:
>  			 *	0: folio will be put on unmap_folios list,
>
> base-commit: 56b90edee105e976d4870b9a048e6965dc0eac56

---
Best Regards,
Huang, Ying

