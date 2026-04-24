Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C41BFED3EA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F6866B00A3; Fri, 24 Apr 2026 11:41:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CE1A6B00A5; Fri, 24 Apr 2026 11:41:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4066B00A6; Fri, 24 Apr 2026 11:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C8566B00A3
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:41:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D2008978F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:41:13 +0000 (UTC)
X-FDA: 84693863226.04.1D50DE0
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3F7082000E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:41:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FVMiA25d;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777045271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ysp3KPMytxumBnUhViA+YLOkzHtdbcKVPu5U5PduTew=;
	b=1sDlE0V7ZqqCsCsAqDYXU6H0qXQnkqLpkU7YJvfJYO40P4AvamTfp3ngdeNMv78XrQ5MKZ
	c4MZTAsPf1jHU1qpYNyCK3WDLH/hJAMBXXGLdl9w97S4xBCIStYx2VYeGHCy/4RgQM9kgd
	+WX/X17IaalLbMDtslMaHNFnThH4ESg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FVMiA25d;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777045271; a=rsa-sha256;
	cv=none;
	b=6fLVG875sPslKbiWma8gXAXSqjCWCoEo6I57ruDDFGOqjUOWCgoyP/XYCjP8ZrV3rD0cxT
	YhKapf3KvVHiY+Iu9/FUgVHyKFWMfghH+S41SiWvjHJxBQk4lcFb1OHICoPwPc6gC9D2ab
	O1e/ostVTMUE7tzzRIh6zVNm3N7i9Ls=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777045268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ysp3KPMytxumBnUhViA+YLOkzHtdbcKVPu5U5PduTew=;
	b=FVMiA25dgArZNLgbbK4HTmNrusZGey87n92PAC9jHYnERUfYYLftC1BUFSpsuqNc73414b
	R+gednPC/10TAQJi5ow5O05J9ug2nVxVvoj4nTbStoC0J6kfoHCaeWKYeH7cbk2WuhDc5o
	sNw59YsNilfbCrYm2Ai+yQaV/yLAe3s=
From: Lance Yang <lance.yang@linux.dev>
To: lance.yang@linux.dev
Cc: akpm@linux-foundation.org,
	peterz@infradead.org,
	david@kernel.org,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	ypodemsk@redhat.com,
	hughd@google.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	jgross@suse.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ioworker0@gmail.com
Subject: Re: [PATCH 7.2 v10 1/2] mm/mmu_gather: prepare to skip redundant sync IPIs
Date: Fri, 24 Apr 2026 23:40:48 +0800
Message-Id: <20260424154048.61420-1-lance.yang@linux.dev>
In-Reply-To: <20260424062528.71951-2-lance.yang@linux.dev>
References: <20260424062528.71951-2-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 7f8wm5xp6mffydoz3fgzybcy83mumsa6
X-Rspamd-Queue-Id: 3F7082000E
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1777045270-942657
X-HE-Meta: U2FsdGVkX19Wv8JHSsH78eoHK5gt9LqPcyRhRkc20pq3qGZW4g/fxCidowIBlDm7N/Z7s5JoMlRdhkd05OIYUlG+M1nG93VApEHxN6FoN3O8vsKTIQrR7EilYLXx4fUZzGnl3t2+cXFWqqZQMhXCWyoK61I5M6fRE8t0gRKNzAaAbF2rwnxJvnjGKtczBDwQlKTv8oWVWmoi8CSAO+z7iIz9W+40eluLYsbQKEj1+7t9TOMVVB4tu1v2n1KqNQ5uf+wVS0+DpZIh9Gs5MbnwrQN1LRpmHNUOzIq5cKo4mijLw5QYiDkvgvEG9r2Gi1ARdSs1r9tV/v2OIfF1+Ib7QStYwnTlCx24Ld1L1K3fQJllYUxfGbkFLp2YrUbtNHGBY0Pfz9vke+WmdUp2u/3ncxo0IIXcsl+fbXkaJ6OwLh09SBV8wR1u0MFfZ6I2gSZbBCxT89sUztv4E46fP4emEh2VGmvbNBUPHtYCcFjkgnpoviz4a5508Wmhcli96gPXUwPCYBnVRYguDV9aUlHKw9cHgAn+3cMl2gdU9SnxMkPd4+Vy09kVgngCqp3lhG2HbJjMm6mrN8Iroa1JoLtiqn/HGStXKPWsnaGErjtUYTP2CHQilISXx8mZIjKslqxGtTJUZzfym7lwe7j9/NVmCNUWnOWQc1Xw//x5nu4/3WqVdkNfK2XpcpTPnOEn9Go/Dea1RUM1ZEuv2P6tLjDRReJipFjjbguAJIFa56E1ONzehUvoMt2AzgiRKMz4pIgD+IPDTQIYrh5RC8Fq7G0fSs+ppWEqHle2r9/wmMvNjQqU8aEAPF5dZUcfZtocH44PxjlToWGweOHVMFqbGKFxeHQe8IYtalEVWUdz25XY7Q2kOWmnPK5VwDFfBfyYBcFsjKZ5dGaF22LclLu4Uq1dB/ptRvDwSwhKIeDSLcwppJqeDiZROq0QHP6/fn9mBnPUen1ghiITQIk1mlmEIvn
 w6Zsd4eL
 SSgJepmwCOmX90FQLLCcjlAEbIjxEFom2V1v7boQSf3aDw3KGlIPHfPL16LJ9S8CwUDUtMa5QaLoGAEE9Tdle9Yhr5idrXij3JM/WO9J5NcVS6uZJKudvdHWvQDYj2wlf5tLKPSDEBuxiUNtX60zh1zniXk/Svv/JRmVR1/GUrbtWW9guNk+8Sg8YxS5rx93ki40TPHR45f9KPbewr78+Z9xwPOv5uujPOb3MjzaZA/3kCEb+atKcIe5TMSxX3P0xM0sIcHSdhvQvoo2vKhEzPssicxh8KK++u3bfK2NxFK/Z3rIpUtpEOg6oSEN80O1kLWGOYz9AkOb3RLNH8Lkad8dOPqaaYRmi3NtAjcTLRT5ctK0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Apr 24, 2026 at 02:25:27PM +0800, Lance Yang wrote:
>From: Lance Yang <lance.yang@linux.dev>
>
>When page table operations require synchronization with software/lockless
>walkers, they call tlb_remove_table_sync_{one,rcu}() after flushing the
>TLB (tlb->freed_tables or tlb->unshared_tables).
>
>On architectures where the TLB flush already sends IPIs to all target CPUs,
>the subsequent sync IPI broadcast is redundant. This is not only costly on
>large systems where it disrupts all CPUs even for single-process page table
>operations, but has also been reported to hurt RT workloads[1].
>
>Introduce tlb_table_flush_implies_ipi_broadcast() to check if the prior TLB
>flush already provided the necessary synchronization. When true, the sync
>calls can early-return.
>
>A few cases rely on this synchronization:
>
>1) hugetlb PMD unshare[2]: The problem is not the freeing but the reuse
>   of the PMD table for other purposes in the last remaining user after
>   unsharing.
>
>2) khugepaged collapse[3]: Ensure no concurrent GUP-fast before collapsing
>   and (possibly) freeing the page table / re-depositing it.
>
>Currently always returns false (no behavior change). The follow-up patch
>will enable the optimization for x86.
>
>[1] https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/
>[2] https://lore.kernel.org/linux-mm/6a364356-5fea-4a6c-b959-ba3b22ce9c88@kernel.org/
>[3] https://lore.kernel.org/linux-mm/2cb4503d-3a3f-4f6c-8038-7b3d1c74b3c2@kernel.org/
>
>Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Signed-off-by: Lance Yang <lance.yang@linux.dev>
>---
> include/asm-generic/tlb.h | 17 +++++++++++++++++
> mm/mmu_gather.c           | 15 +++++++++++++++
> 2 files changed, 32 insertions(+)
>
>diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
>index bdcc2778ac64..cb41cc6a0024 100644
>--- a/include/asm-generic/tlb.h
>+++ b/include/asm-generic/tlb.h
>@@ -240,6 +240,23 @@ static inline void tlb_remove_table(struct mmu_gather *tlb, void *table)
> }
> #endif /* CONFIG_MMU_GATHER_TABLE_FREE */
> 
>+/**
>+ * tlb_table_flush_implies_ipi_broadcast - does TLB flush imply IPI sync
>+ *
>+ * When page table operations require synchronization with software/lockless
>+ * walkers, they flush the TLB (tlb->freed_tables or tlb->unshared_tables)
>+ * then call tlb_remove_table_sync_{one,rcu}(). If the flush already sent
>+ * IPIs to all CPUs, the sync call is redundant.
>+ *
>+ * Returns false by default. Architectures can override by defining this.
>+ */
>+#ifndef tlb_table_flush_implies_ipi_broadcast
>+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
>+{
>+	return false;
>+}
>+#endif
>+
> #ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
> /*
>  * This allows an architecture that does not use the linux page-tables for
>diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
>index 3985d856de7f..37a6a711c37e 100644
>--- a/mm/mmu_gather.c
>+++ b/mm/mmu_gather.c
>@@ -283,6 +283,14 @@ void tlb_remove_table_sync_one(void)
> 	 * It is however sufficient for software page-table walkers that rely on
> 	 * IRQ disabling.
> 	 */
>+
>+	/*
>+	 * Skip IPI if the preceding TLB flush already synchronized with
>+	 * all CPUs that could be doing software/lockless page table walks.
>+	 */
>+	if (tlb_table_flush_implies_ipi_broadcast())
>+		return;

Sashiko told me[1]:

"
Could skipping the global IPI fail to synchronize with lockless walkers
running outside the mm_cpumask?

tlb_remove_table_sync_one() is used (e.g., by khugepaged during THP collapse)
to wait for lockless page table walkers to finish. On 32-bit architectures
like x86 PAE, pmdp_get_lockless() disables interrupts to prevent torn reads
of 64-bit PMDs.

While the preceding TLB flush sends IPIs to CPUs in the target mm's
mm_cpumask, lockless walkers such as pte_offset_map() are frequently executed
by background threads unrelated to the target mm (e.g., kswapd via
page_vma_mapped_walk()). These threads run on CPUs outside of mm_cpumask
and would not receive the TLB flush IPI.

If the global smp_call_function(..., 1) IPI is skipped, the modifying thread
might not wait for kswapd. Could this allow it to overwrite the PMD while the
out-of-context reader is reading it, resulting in a torn PMD?
"

Afraid not.

When CONFIG_MMU_GATHER_RCU_TABLE_FREE=n, tlb_remove_table_sync_one() is
just a NOP.

So if lockless walkers outside mm_cpumask really required a separate
global IPI here, systems running with CONFIG_MMU_GATHER_RCU_TABLE_FREE=n
would already be broken today, because there is no such IPI there to
begin with :)

[1] https://sashiko.dev/#/patchset/20260424062528.71951-1-lance.yang@linux.dev

>
> 	smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
> }
> 
>@@ -312,6 +320,13 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
>  */
> void tlb_remove_table_sync_rcu(void)
> {
>+	/*
>+	 * Skip RCU wait if the preceding TLB flush already synchronized
>+	 * with all CPUs that could be doing software/lockless page table walks.
>+	 */
>+	if (tlb_table_flush_implies_ipi_broadcast())
>+		return;
>+

And Sashiko also pointed out[2]:

"
Does skipping synchronize_rcu() here violate the RCU lifetime guarantee of
page tables?

Generic software page table walkers, such as pte_offset_map(), rely strictly
on rcu_read_lock() to protect page table pages from being freed concurrently.
Crucially, they execute with hardware interrupts enabled.

Under CONFIG_PREEMPT_RCU, an IPI broadcast does not wait for rcu_read_lock()
critical sections to complete. The IPI simply interrupts the reader, executes
the flush, and returns immediately.

Could this allow the page table to be freed while the reader is still actively
accessing it, leading to a use-after-free for concurrent pte_offset_map()
readers?
"

Nop.

tlb_remove_table_sync_rcu() still has a single caller: the
!CONFIG_PT_RECLAIM __tlb_remove_table_one() fallback. It was introduced
for that slow batch-allocation-failure path in 1fb3d8c20bfa
("mm/mmu_gather: replace IPI with synchronize_rcu() when batch
allocation fails"), replacing the previous tlb_remove_table_sync_one()
there.

So if pte_offset_map() readers really required a full RCU grace period
in that fallback path, that concern would already have existed before
1fb3d8c20bfa.

So we're safe here :)

[2] https://sashiko.dev/#/patchset/20260424062528.71951-1-lance.yang@linux.dev

> 	synchronize_rcu();
> }
> 
>-- 
>2.49.0
>
>

