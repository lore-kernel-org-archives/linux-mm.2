Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1E8DCDC165
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 11:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 161116B009F; Tue,  6 Jan 2026 06:51:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13F1F6B00A0; Tue,  6 Jan 2026 06:51:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0551C6B00A1; Tue,  6 Jan 2026 06:51:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E880C6B009F
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:51:44 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9CF9160555
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:51:44 +0000 (UTC)
X-FDA: 84301374528.09.E711653
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0108020005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:51:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iMG81bgl;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767700303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aCKTGrv+k6ub8F4AW6v/G5VPK3mcKpwM4TC/1V+pwcA=;
	b=GMzOPQcSSqUsBxQHo0Se64k+11u2V7aBeLKF2k2UfscelmVgaLH0b7ZoYc1CWt6wgSfS+h
	XixaBkk0jAHo1GB97fMTQj/MmPbaNJZkFef/PirX5NTI9+PHHl+bzMbImwe0p4JZszwnXb
	2DXHSdUy5RcW6+nDqBNLJD3nZ8zdEx8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767700303; a=rsa-sha256;
	cv=none;
	b=Mww756kTHgToqJdXb/XxbLfl993Dgkdu2RK70/cBmImZe2DwRRRpgBn/zApg6b9H3azLZV
	NB3ZeHD4N3UXVocg4n62cNk2yyPSCJWgdashFRDHP7T7EyhL9BURpooTN/vzXVL/pwkjAR
	coHT/fPRAe5q1yQp3wKoI6cwiiqcv58=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iMG81bgl;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767700300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aCKTGrv+k6ub8F4AW6v/G5VPK3mcKpwM4TC/1V+pwcA=;
	b=iMG81bglXc/pBXxZCytB59WHt3CkSpHYOHuD+F+wOBsYMgsfwLfOlkoBH264MyWBPbPeke
	ngRBzqAOVuGasjKeex54TwJ9nzzOqtzooXC8YB2eOauxaxevea7yfToYS92Hf5rlMHecfC
	4Ts2PQ5EeyXlESrcFq4YLtrzsQcnJxg=
From: lance.yang@linux.dev
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	lorenzo.stoakes@oracle.com,
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
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ioworker0@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v3 1/2] mm/tlb: skip redundant IPI when TLB flush already synchronized
Date: Tue,  6 Jan 2026 19:50:52 +0800
Message-ID: <20260106115053.32328-2-lance.yang@linux.dev>
In-Reply-To: <20260106115053.32328-1-lance.yang@linux.dev>
References: <20260106115053.32328-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 9niko8qqf15dm37hgzdizzxiprz15sk8
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0108020005
X-Rspam-User: 
X-HE-Tag: 1767700302-877094
X-HE-Meta: U2FsdGVkX19fWKDcsmyHexnTdXM0IMK65yzuFbAUpr2QWcIkRhTQI/vF92aUhfR5IBGojzfCPO0mSmLM8CESIcgRAkoSVTyJ/CTnwh6oLs6M6fQYpjTc3RTBq1Lf1Y4pNw4AlCgYobiAinMSPUjG6mifbzQDXBd0iumv9bswk0+iTGmYfXXxyUp/DdDzKRI3mQa+RBjFUSl41fcKCnXP/2Vg10e9cqi86pF40YsqemtzBCHBcvJEmB0PXDtw0peBMRUWYmT9m5onSIO58TVRebvvPB4TLJoSIOouqQvM6UxYbZPCCr60PTAhXe72US1YCz21CwHufCzUr0we4vrKGlHpUuz7wepv99+jxOYPAfWbn0DHT2EveviGW8O6G6vpL2wwQNLhNWSyMyreR0e59oksQiPxQyxw4K6Uz5IZ+wLRr93cdaWLJEmkJpju0UwATmG1zpX0fX79EsMFss67sBgW4FTnPkQL/kjrSl8PugcD1mYeJRua5esowQE774SpVf66K/0p3OB9O5eVBgkOPA/qmcq2emZ9b/REOXBo02kHI+ooasJ3AsbOx76vKT3pCFuM+2A7sV2M92oQhKA3LtjMhgdSKwTWqeKItIHhtNDUPd5t9o7d4tmLoLJeepS6vbhtaDgPjvsvd7GlzJ8d64CHhQECYRG8crNCs/EaL9fR3J5kNhjHf6ahPvCsNxn9alSHpkI2Qqgfav7RWIAF35K3dMe4tnJY/B+d7hu9vopB0NWffCqxI8pyzDh52DXTebLXrmaW97u3iRpLobFtPSedATJnkAKdRsx4bbBKRogHKSYnOxvy5ckUs2slnT4+IAKD3Ec/tcKJNAuF6Y0UqcJz+fcBOvvMcEcLRr3KnxnNe6/8vXzGBebfP5M2hxoyrQyx2CXmXC2LtduOBQOTOYLYACm8bOfD8BFXKZORnn8or5o/22ttwt57G/h5ow0q2JJerznk+OUVWsCThEN
 f/DdY3fx
 dMYrPi+d7Msmng3AauWX9xRAKVYTZF/VyqG8QBRJ7iBOpWTI8z6j0FPbmf8zaJft+BxH8AUvgMu24K9HWsrubDtlRYkhc3L/tnMD3KfJuqWIt9sKeVdwLyk8m7TW/VZWCH2z36AL7Y0mea17RZ2Y6mqrbQQYUVVPNKt/uMn8/AauavovdnZOPBfpLN7x+ZBpY8Xzufx3h3gfXPqLG7/4SBfCpN3uo4+JJrh66yQp6n25CIlcCg0wgGv5x3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When unsharing hugetlb PMD page tables, we currently send two IPIs: one
for TLB invalidation, and another to synchronize with concurrent GUP-fast
walkers via tlb_remove_table_sync_one().

However, if the TLB flush already sent IPIs to all CPUs (when freed_tables
or unshared_tables is true), the second IPI is redundant. GUP-fast runs
with IRQs disabled, so when the TLB flush IPI completes, any concurrent
GUP-fast must have finished.

To avoid the redundant IPI, we add a flag to mmu_gather to track whether
the TLB flush sent IPIs. We pass the mmu_gather pointer through the TLB
flush path via flush_tlb_info, so native_flush_tlb_multi() can set the
flag when it sends IPIs for freed_tables. We also set the flag for
local-only flushes, since disabling IRQs provides the same guarantee.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 arch/x86/include/asm/tlb.h      |  3 ++-
 arch/x86/include/asm/tlbflush.h |  9 +++++----
 arch/x86/kernel/alternative.c   |  2 +-
 arch/x86/kernel/ldt.c           |  2 +-
 arch/x86/mm/tlb.c               | 22 ++++++++++++++++------
 include/asm-generic/tlb.h       | 14 +++++++++-----
 mm/mmu_gather.c                 | 26 +++++++++++++++++++-------
 7 files changed, 53 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 866ea78ba156..c5950a92058c 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -20,7 +20,8 @@ static inline void tlb_flush(struct mmu_gather *tlb)
 		end = tlb->end;
 	}
 
-	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
+	flush_tlb_mm_range(tlb->mm, start, end, stride_shift,
+			   tlb->freed_tables || tlb->unshared_tables, tlb);
 }
 
 static inline void invlpg(unsigned long addr)
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 00daedfefc1b..83c260c88b80 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -220,6 +220,7 @@ struct flush_tlb_info {
 	 *   will be zero.
 	 */
 	struct mm_struct	*mm;
+	struct mmu_gather	*tlb;
 	unsigned long		start;
 	unsigned long		end;
 	u64			new_tlb_gen;
@@ -305,23 +306,23 @@ static inline bool mm_in_asid_transition(struct mm_struct *mm) { return false; }
 #endif
 
 #define flush_tlb_mm(mm)						\
-		flush_tlb_mm_range(mm, 0UL, TLB_FLUSH_ALL, 0UL, true)
+		flush_tlb_mm_range(mm, 0UL, TLB_FLUSH_ALL, 0UL, true, NULL)
 
 #define flush_tlb_range(vma, start, end)				\
 	flush_tlb_mm_range((vma)->vm_mm, start, end,			\
 			   ((vma)->vm_flags & VM_HUGETLB)		\
 				? huge_page_shift(hstate_vma(vma))	\
-				: PAGE_SHIFT, true)
+				: PAGE_SHIFT, true, NULL)
 
 extern void flush_tlb_all(void);
 extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 				unsigned long end, unsigned int stride_shift,
-				bool freed_tables);
+				bool freed_tables, struct mmu_gather *tlb);
 extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
 
 static inline void flush_tlb_page(struct vm_area_struct *vma, unsigned long a)
 {
-	flush_tlb_mm_range(vma->vm_mm, a, a + PAGE_SIZE, PAGE_SHIFT, false);
+	flush_tlb_mm_range(vma->vm_mm, a, a + PAGE_SIZE, PAGE_SHIFT, false, NULL);
 }
 
 static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 28518371d8bf..006f3705b616 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -2572,7 +2572,7 @@ static void *__text_poke(text_poke_f func, void *addr, const void *src, size_t l
 	 */
 	flush_tlb_mm_range(text_poke_mm, text_poke_mm_addr, text_poke_mm_addr +
 			   (cross_page_boundary ? 2 : 1) * PAGE_SIZE,
-			   PAGE_SHIFT, false);
+			   PAGE_SHIFT, false, NULL);
 
 	if (func == text_poke_memcpy) {
 		/*
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index 0f19ef355f5f..d8494706fec5 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -374,7 +374,7 @@ static void unmap_ldt_struct(struct mm_struct *mm, struct ldt_struct *ldt)
 	}
 
 	va = (unsigned long)ldt_slot_va(ldt->slot);
-	flush_tlb_mm_range(mm, va, va + nr_pages * PAGE_SIZE, PAGE_SHIFT, false);
+	flush_tlb_mm_range(mm, va, va + nr_pages * PAGE_SIZE, PAGE_SHIFT, false, NULL);
 }
 
 #else /* !CONFIG_MITIGATION_PAGE_TABLE_ISOLATION */
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index f5b93e01e347..be45976c0d16 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -1374,6 +1374,9 @@ STATIC_NOPV void native_flush_tlb_multi(const struct cpumask *cpumask,
 	else
 		on_each_cpu_cond_mask(should_flush_tlb, flush_tlb_func,
 				(void *)info, 1, cpumask);
+
+	if (info->freed_tables && info->tlb)
+		info->tlb->tlb_flush_sent_ipi = true;
 }
 
 void flush_tlb_multi(const struct cpumask *cpumask,
@@ -1403,7 +1406,7 @@ static DEFINE_PER_CPU(unsigned int, flush_tlb_info_idx);
 static struct flush_tlb_info *get_flush_tlb_info(struct mm_struct *mm,
 			unsigned long start, unsigned long end,
 			unsigned int stride_shift, bool freed_tables,
-			u64 new_tlb_gen)
+			u64 new_tlb_gen, struct mmu_gather *tlb)
 {
 	struct flush_tlb_info *info = this_cpu_ptr(&flush_tlb_info);
 
@@ -1433,6 +1436,7 @@ static struct flush_tlb_info *get_flush_tlb_info(struct mm_struct *mm,
 	info->new_tlb_gen	= new_tlb_gen;
 	info->initiating_cpu	= smp_processor_id();
 	info->trim_cpumask	= 0;
+	info->tlb		= tlb;
 
 	return info;
 }
@@ -1447,8 +1451,8 @@ static void put_flush_tlb_info(void)
 }
 
 void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
-				unsigned long end, unsigned int stride_shift,
-				bool freed_tables)
+			unsigned long end, unsigned int stride_shift,
+			bool freed_tables, struct mmu_gather *tlb)
 {
 	struct flush_tlb_info *info;
 	int cpu = get_cpu();
@@ -1458,7 +1462,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 	new_tlb_gen = inc_mm_tlb_gen(mm);
 
 	info = get_flush_tlb_info(mm, start, end, stride_shift, freed_tables,
-				  new_tlb_gen);
+				  new_tlb_gen, tlb);
 
 	/*
 	 * flush_tlb_multi() is not optimized for the common case in which only
@@ -1476,6 +1480,12 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 		local_irq_disable();
 		flush_tlb_func(info);
 		local_irq_enable();
+		/*
+		 * Only current CPU uses this mm, so we can treat this as
+		 * having synchronized with GUP-fast. No sync IPI needed.
+		 */
+		if (tlb && freed_tables)
+			tlb->tlb_flush_sent_ipi = true;
 	}
 
 	put_flush_tlb_info();
@@ -1553,7 +1563,7 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 	guard(preempt)();
 
 	info = get_flush_tlb_info(NULL, start, end, PAGE_SHIFT, false,
-				  TLB_GENERATION_INVALID);
+				  TLB_GENERATION_INVALID, NULL);
 
 	if (info->end == TLB_FLUSH_ALL)
 		kernel_tlb_flush_all(info);
@@ -1733,7 +1743,7 @@ void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 	int cpu = get_cpu();
 
 	info = get_flush_tlb_info(NULL, 0, TLB_FLUSH_ALL, 0, false,
-				  TLB_GENERATION_INVALID);
+				  TLB_GENERATION_INVALID, NULL);
 	/*
 	 * flush_tlb_multi() is not optimized for the common case in which only
 	 * a local TLB flush is needed. Optimize this use-case by calling
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 3975f7d11553..cbbe008590ee 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -249,6 +249,7 @@ static inline void tlb_remove_table(struct mmu_gather *tlb, void *table)
 #define tlb_needs_table_invalidate() (true)
 #endif
 
+void tlb_gather_remove_table_sync_one(struct mmu_gather *tlb);
 void tlb_remove_table_sync_one(void);
 
 #else
@@ -257,6 +258,7 @@ void tlb_remove_table_sync_one(void);
 #error tlb_needs_table_invalidate() requires MMU_GATHER_RCU_TABLE_FREE
 #endif
 
+static inline void tlb_gather_remove_table_sync_one(struct mmu_gather *tlb) { }
 static inline void tlb_remove_table_sync_one(void) { }
 
 #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
@@ -378,6 +380,12 @@ struct mmu_gather {
 	 */
 	unsigned int		fully_unshared_tables : 1;
 
+	/*
+	 * Did the TLB flush for freed/unshared tables send IPIs to all CPUs?
+	 * If true, we can skip the redundant IPI in tlb_remove_table_sync_one().
+	 */
+	unsigned int		tlb_flush_sent_ipi : 1;
+
 	unsigned int		batch_count;
 
 #ifndef CONFIG_MMU_GATHER_NO_GATHER
@@ -833,13 +841,9 @@ static inline void tlb_flush_unshared_tables(struct mmu_gather *tlb)
 	 *
 	 * We only perform this when we are the last sharer of a page table,
 	 * as the IPI will reach all CPUs: any GUP-fast.
-	 *
-	 * Note that on configs where tlb_remove_table_sync_one() is a NOP,
-	 * the expectation is that the tlb_flush_mmu_tlbonly() would have issued
-	 * required IPIs already for us.
 	 */
 	if (tlb->fully_unshared_tables) {
-		tlb_remove_table_sync_one();
+		tlb_gather_remove_table_sync_one(tlb);
 		tlb->fully_unshared_tables = false;
 	}
 }
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 2faa23d7f8d4..da36de52b281 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -273,8 +273,14 @@ static void tlb_remove_table_smp_sync(void *arg)
 	/* Simply deliver the interrupt */
 }
 
-void tlb_remove_table_sync_one(void)
+void tlb_gather_remove_table_sync_one(struct mmu_gather *tlb)
 {
+	/* Skip the IPI if the TLB flush already synchronized with other CPUs */
+	if (tlb && tlb->tlb_flush_sent_ipi) {
+		tlb->tlb_flush_sent_ipi = false;
+		return;
+	}
+
 	/*
 	 * This isn't an RCU grace period and hence the page-tables cannot be
 	 * assumed to be actually RCU-freed.
@@ -285,6 +291,11 @@ void tlb_remove_table_sync_one(void)
 	smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
 }
 
+void tlb_remove_table_sync_one(void)
+{
+	tlb_gather_remove_table_sync_one(NULL);
+}
+
 static void tlb_remove_table_rcu(struct rcu_head *head)
 {
 	__tlb_remove_table_free(container_of(head, struct mmu_table_batch, rcu));
@@ -328,7 +339,7 @@ static inline void __tlb_remove_table_one_rcu(struct rcu_head *head)
 	__tlb_remove_table(ptdesc);
 }
 
-static inline void __tlb_remove_table_one(void *table)
+static inline void __tlb_remove_table_one(void *table, struct mmu_gather *tlb)
 {
 	struct ptdesc *ptdesc;
 
@@ -336,16 +347,16 @@ static inline void __tlb_remove_table_one(void *table)
 	call_rcu(&ptdesc->pt_rcu_head, __tlb_remove_table_one_rcu);
 }
 #else
-static inline void __tlb_remove_table_one(void *table)
+static inline void __tlb_remove_table_one(void *table, struct mmu_gather *tlb)
 {
-	tlb_remove_table_sync_one();
+	tlb_gather_remove_table_sync_one(tlb);
 	__tlb_remove_table(table);
 }
 #endif /* CONFIG_PT_RECLAIM */
 
-static void tlb_remove_table_one(void *table)
+static void tlb_remove_table_one(void *table, struct mmu_gather *tlb)
 {
-	__tlb_remove_table_one(table);
+	__tlb_remove_table_one(table, tlb);
 }
 
 static void tlb_table_flush(struct mmu_gather *tlb)
@@ -367,7 +378,7 @@ void tlb_remove_table(struct mmu_gather *tlb, void *table)
 		*batch = (struct mmu_table_batch *)__get_free_page(GFP_NOWAIT);
 		if (*batch == NULL) {
 			tlb_table_invalidate(tlb);
-			tlb_remove_table_one(table);
+			tlb_remove_table_one(table, tlb);
 			return;
 		}
 		(*batch)->nr = 0;
@@ -427,6 +438,7 @@ static void __tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm,
 	tlb->vma_pfn = 0;
 
 	tlb->fully_unshared_tables = 0;
+	tlb->tlb_flush_sent_ipi = 0;
 	__tlb_reset_range(tlb);
 	inc_tlb_flush_pending(tlb->mm);
 }
-- 
2.49.0


