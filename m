Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92139FB44B8
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 06:26:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0717F6B008C; Fri, 24 Apr 2026 02:26:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3CFE6B0092; Fri, 24 Apr 2026 02:26:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2C3E6B0093; Fri, 24 Apr 2026 02:26:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D0A6B6B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:26:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C3011C0AD9
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:26:35 +0000 (UTC)
X-FDA: 84692465550.17.47A264D
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8724A14000F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:26:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lXFN78sr;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777011993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rTh+Yvx/G+4eA9lbJw6qEK4XyieG3LR31VvrGkRr96o=;
	b=kI7c4ExU8IvXkoIg+lg6Xjx7dDJV2GZoljaSrfnNlsrf6K4dfAjg5+D68SA8Cckd+4wQUH
	q5AVtv+EoNkZGmL87pHtNtDgyUrMMsmzuiTN48u7zRx2RL4/SRI+a2c/Wuz6cDP9J537tf
	OP9r7Mt3nfSUWyIhQPMgMS1BXtgAR1o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lXFN78sr;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777011993; a=rsa-sha256;
	cv=none;
	b=dN2cqOfYBE2icBNY+fYIhixvxZQKNinSeyyjgbV51+RoZmB9R7pbEb4syQYtK/avXNpkE5
	mzbobzOB/OLDPWXw4INh5DlaAmhw6nrO0lDKDR8V1STP/kc6yP1/GPw0ZzPDdBvQhWxQmd
	vIl4OYKKtF5QXpme3Kg+CCrlPS/3A00=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777011989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rTh+Yvx/G+4eA9lbJw6qEK4XyieG3LR31VvrGkRr96o=;
	b=lXFN78sryZ4PB+yHSBlA0WPl5M4L4ogY1eH/biaBzsnxm7WNDoMkzHzGdk7QKgYfxNeOy0
	5st7Qf4OgYppgPfZFHjFoqGEV8pmnNmBKnkB0JO8npFF6lWb+nYs/1TlvCaH5DfMx0R1aR
	DISGE9gPZLPERc1OKnbM0iSsegCiaus=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org,
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
	ioworker0@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 7.2 v10 2/2] x86/tlb: skip redundant sync IPIs for native TLB flush
Date: Fri, 24 Apr 2026 14:25:28 +0800
Message-ID: <20260424062528.71951-3-lance.yang@linux.dev>
In-Reply-To: <20260424062528.71951-1-lance.yang@linux.dev>
References: <20260424062528.71951-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 37ttw1g9e3ysf5poy7ansenje619xqop
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8724A14000F
X-HE-Tag: 1777011993-813092
X-HE-Meta: U2FsdGVkX18AmOz6QqtTbs6EaIRxX86Z7VKBMJcYDo/b1WadO0SNmLFNTg5Y0DN8+PyE4lco4LDAKDunjPTYZnhBdu0NXT+/HobSZnhc/MxKRHqZhSP6w8Z0WGql5SVPAz0awu4QYhEzKQdZDuJomwhoevmaJVOzgzm5ZPo/+XxBbAFzRCZ4fq9tY1oQ5aD5fRuxEk3AD1vTypHrLUQE7p445rpb9qWpUTsVHM15NGt/nhwCzlf4WZLnRigVpdAPBctT76OhHyLH8EYWk+5tOYAOYmJgrbi5yKeDm2SY/zV54S5VWqH2pVpcE/037ZS9o9hu7TRPA0p1x56XPs729XEeD6kx/PGtNGBCX1ssldlH7cK0rRKjKqz41G1NcbvWU9ZfpTUdF69chrRw15K7ky/qCjYl429XY0UL0TwADRYj/ZLmTWXUR40jIF8/ef7aiHhbHKQkPzPznmEGV6S3OBQMuMPWUF26pBui3ABooqHCFkI2kbTtX5V3A+DZNI+fhPkzWcWv8Uk0THZ05scAQ3UIkogKNLs4sloreu/N8c8d5OrYvxyVGThnchAxwr6qR1RSvsJ8KSgtZxIRVI826yUZ3qjksU9ADaBMd48MDxoJzT81EwY0bheUKQk8QInACtCdnHKGZ0JXnVdAx9FRFS5QjJmbiz8TT2E0oAfJUymCpmu+8m706Jhi1rMIjU+VYZcG9CE4CsjFkG5YNHKKqgJ7ZrJ15QTr+vX/na2tkHlZsRbbA3PjR/3aEYe0yvbNSM8OlA6pO2kd6YC8G9P60jVqzP3lAXlJsmlU0zOj3HVHysESjm9KRSU2olfEi8eBXmAGdkbDvONTMstqW+xo3KjIw+KoaIjyYdOBFUMyXHT7Qn18QTLsqjK11i+wlm0GTqnvZsVQFv0iFDaJ2C4xLcF7G5CJRNbvdwrAQviz5N75F208ewUHaYD5eR6g4WqcHB6yv2+yO1LHf//4Ds+
 7U4J3jl3
 O1VJA3p1zTwECqgPKL13kaJ6zlwx0Zyae4lS8uUcywAKUz06D5hg8d3vAR5gYoBpOpUKJy4oTEipy9lXmhZ+moJBacOjbuoFGizyjXn1sewhipu8kAIz019hY4pWYVAfJVZeYsWcZuVrWo39vYhZTcBMjqyY6cVrKeXUQ66T7/kYdQv9V5UKSeb8X9hN0Iy17NOcslzNBwWzMkWMmQKjk+hPpTJYjUjHILxrtAcE20UWH6rR2I3zeLoXTDH8u0Av0xZTg4AJoGKK//UKoleVhpVTfWDi7kYDBrWK2UiEX4FBxebBVbh3xW8+3MCtnLDCnzl7cHKu+kS2qa2xS95ZSwsUkZAzKhIoACeUgAmWdE07/Y+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Some page table operations need to synchronize with software/lockless
walkers after a TLB flush by calling tlb_remove_table_sync_{one,rcu}().
On x86, that extra synchronization is redundant when the preceding TLB
flush already broadcast IPIs to all relevant CPUs.

native_pv_tlb_init() checks whether native_flush_tlb_multi() is in use.
On CONFIG_PARAVIRT systems, it checks pv_ops; on non-PARAVIRT, native
flush is always in use.

It decides once at boot whether to enable the optimization: if using
native TLB flush and INVLPGB is not supported, we know IPIs were sent
and can skip the redundant sync. The decision is fixed via a static
key as Peter suggested[1].

PV backends (KVM, Xen, Hyper-V) typically have their own implementations
and don't call native_flush_tlb_multi() directly, so they cannot be trusted
to provide the IPI guarantees we need.

Also rename the x86 flush_tlb_info bit from freed_tables to wake_lazy_cpus,
as Dave suggested[2], to match the behavior it controls: whether the remote
flush may skip CPUs in lazy TLB mode. Both freed_tables and unshared_tables
set it, because lazy-TLB CPUs must receive IPIs before page tables can be
freed or reused. With that guarantee in place,
tlb_table_flush_implies_ipi_broadcast() can safely skip the later sync IPI.

Two-step plan as David suggested[3]:

Step 1 (this patch): Skip redundant sync when we're 100% certain the TLB
flush sent IPIs. INVLPGB is excluded because when supported, we cannot
guarantee IPIs were sent, keeping it clean and simple.

Step 2 (future work): Send targeted IPIs only to CPUs actually doing
software/lockless page table walks, benefiting all architectures.

Regarding Step 2, it obviously only applies to setups where Step 1 does
not apply: like x86 with INVLPGB or arm64.

[1] https://lore.kernel.org/linux-mm/20260302145652.GH1395266@noisy.programming.kicks-ass.net/
[2] https://lore.kernel.org/linux-mm/f856051b-10c7-4d65-9dbe-6b1677af74bd@intel.com/
[3] https://lore.kernel.org/linux-mm/bbfdf226-4660-4949-b17b-0d209ee4ef8c@kernel.org/

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 arch/x86/hyperv/mmu.c           |  4 ++--
 arch/x86/include/asm/tlb.h      | 19 +++++++++++++++-
 arch/x86/include/asm/tlbflush.h |  6 +++--
 arch/x86/kernel/smpboot.c       |  1 +
 arch/x86/mm/tlb.c               | 39 +++++++++++++++++++++++----------
 5 files changed, 52 insertions(+), 17 deletions(-)

diff --git a/arch/x86/hyperv/mmu.c b/arch/x86/hyperv/mmu.c
index cfcb60468b01..2cf1eeaffd6f 100644
--- a/arch/x86/hyperv/mmu.c
+++ b/arch/x86/hyperv/mmu.c
@@ -63,7 +63,7 @@ static void hyperv_flush_tlb_multi(const struct cpumask *cpus,
 	struct hv_tlb_flush *flush;
 	u64 status;
 	unsigned long flags;
-	bool do_lazy = !info->freed_tables;
+	bool do_lazy = !info->wake_lazy_cpus;
 
 	trace_hyperv_mmu_flush_tlb_multi(cpus, info);
 
@@ -198,7 +198,7 @@ static u64 hyperv_flush_tlb_others_ex(const struct cpumask *cpus,
 
 	flush->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
 	nr_bank = cpumask_to_vpset_skip(&flush->hv_vp_set, cpus,
-			info->freed_tables ? NULL : cpu_is_lazy);
+			info->wake_lazy_cpus ? NULL : cpu_is_lazy);
 	if (nr_bank < 0)
 		return HV_STATUS_INVALID_PARAMETER;
 
diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 866ea78ba156..fb256fd95f95 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -5,22 +5,39 @@
 #define tlb_flush tlb_flush
 static inline void tlb_flush(struct mmu_gather *tlb);
 
+#define tlb_table_flush_implies_ipi_broadcast tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void);
+
 #include <asm-generic/tlb.h>
 #include <linux/kernel.h>
 #include <vdso/bits.h>
 #include <vdso/page.h>
 
+DECLARE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
+
+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+	return static_branch_likely(&tlb_ipi_broadcast_key);
+}
+
 static inline void tlb_flush(struct mmu_gather *tlb)
 {
 	unsigned long start = 0UL, end = TLB_FLUSH_ALL;
 	unsigned int stride_shift = tlb_get_unmap_shift(tlb);
 
+	/*
+	 * Both freed_tables and unshared_tables must wake lazy-TLB CPUs, so
+	 * they receive IPIs before reusing or freeing page tables, allowing
+	 * us to safely implement tlb_table_flush_implies_ipi_broadcast().
+	 */
+	bool wake_lazy_cpus = tlb->freed_tables || tlb->unshared_tables;
+
 	if (!tlb->fullmm && !tlb->need_flush_all) {
 		start = tlb->start;
 		end = tlb->end;
 	}
 
-	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
+	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, wake_lazy_cpus);
 }
 
 static inline void invlpg(unsigned long addr)
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 5a3cdc439e38..39b9454781c3 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -18,6 +18,8 @@
 
 DECLARE_PER_CPU(u64, tlbstate_untag_mask);
 
+void __init native_pv_tlb_init(void);
+
 void __flush_tlb_all(void);
 
 #define TLB_FLUSH_ALL	-1UL
@@ -225,7 +227,7 @@ struct flush_tlb_info {
 	u64			new_tlb_gen;
 	unsigned int		initiating_cpu;
 	u8			stride_shift;
-	u8			freed_tables;
+	u8			wake_lazy_cpus;
 	u8			trim_cpumask;
 };
 
@@ -315,7 +317,7 @@ static inline bool mm_in_asid_transition(struct mm_struct *mm) { return false; }
 extern void flush_tlb_all(void);
 extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 				unsigned long end, unsigned int stride_shift,
-				bool freed_tables);
+				bool wake_lazy_cpus);
 extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
 
 static inline void flush_tlb_page(struct vm_area_struct *vma, unsigned long a)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 294a8ea60298..df776b645a9c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1256,6 +1256,7 @@ void __init native_smp_prepare_boot_cpu(void)
 		switch_gdt_and_percpu_base(me);
 
 	native_pv_lock_init();
+	native_pv_tlb_init();
 }
 
 void __init native_smp_cpus_done(unsigned int max_cpus)
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 621e09d049cb..3ce254a3982c 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -26,6 +26,8 @@
 
 #include "mm_internal.h"
 
+DEFINE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
+
 #ifdef CONFIG_PARAVIRT
 # define STATIC_NOPV
 #else
@@ -1360,16 +1362,16 @@ STATIC_NOPV void native_flush_tlb_multi(const struct cpumask *cpumask,
 				(info->end - info->start) >> PAGE_SHIFT);
 
 	/*
-	 * If no page tables were freed, we can skip sending IPIs to
-	 * CPUs in lazy TLB mode. They will flush the CPU themselves
-	 * at the next context switch.
+	 * If lazy-TLB CPUs do not need to be woken, we can skip sending
+	 * IPIs to them. They will flush themselves at the next context
+	 * switch.
 	 *
-	 * However, if page tables are getting freed, we need to send the
-	 * IPI everywhere, to prevent CPUs in lazy TLB mode from tripping
-	 * up on the new contents of what used to be page tables, while
-	 * doing a speculative memory access.
+	 * However, if page tables are getting freed or unshared, we need
+	 * to send the IPI everywhere, to prevent CPUs in lazy TLB mode
+	 * from tripping up on the new contents of what used to be page
+	 * tables, while doing a speculative memory access.
 	 */
-	if (info->freed_tables || mm_in_asid_transition(info->mm))
+	if (info->wake_lazy_cpus || mm_in_asid_transition(info->mm))
 		on_each_cpu_mask(cpumask, flush_tlb_func, (void *)info, true);
 	else
 		on_each_cpu_cond_mask(should_flush_tlb, flush_tlb_func,
@@ -1402,7 +1404,7 @@ static DEFINE_PER_CPU(unsigned int, flush_tlb_info_idx);
 
 static struct flush_tlb_info *get_flush_tlb_info(struct mm_struct *mm,
 			unsigned long start, unsigned long end,
-			unsigned int stride_shift, bool freed_tables,
+			unsigned int stride_shift, bool wake_lazy_cpus,
 			u64 new_tlb_gen)
 {
 	struct flush_tlb_info *info = this_cpu_ptr(&flush_tlb_info);
@@ -1429,7 +1431,7 @@ static struct flush_tlb_info *get_flush_tlb_info(struct mm_struct *mm,
 	info->end		= end;
 	info->mm		= mm;
 	info->stride_shift	= stride_shift;
-	info->freed_tables	= freed_tables;
+	info->wake_lazy_cpus	= wake_lazy_cpus;
 	info->new_tlb_gen	= new_tlb_gen;
 	info->initiating_cpu	= smp_processor_id();
 	info->trim_cpumask	= 0;
@@ -1448,7 +1450,7 @@ static void put_flush_tlb_info(void)
 
 void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 				unsigned long end, unsigned int stride_shift,
-				bool freed_tables)
+				bool wake_lazy_cpus)
 {
 	struct flush_tlb_info *info;
 	int cpu = get_cpu();
@@ -1457,7 +1459,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 	/* This is also a barrier that synchronizes with switch_mm(). */
 	new_tlb_gen = inc_mm_tlb_gen(mm);
 
-	info = get_flush_tlb_info(mm, start, end, stride_shift, freed_tables,
+	info = get_flush_tlb_info(mm, start, end, stride_shift, wake_lazy_cpus,
 				  new_tlb_gen);
 
 	/*
@@ -1834,3 +1836,16 @@ static int __init create_tlb_single_page_flush_ceiling(void)
 	return 0;
 }
 late_initcall(create_tlb_single_page_flush_ceiling);
+
+void __init native_pv_tlb_init(void)
+{
+#ifdef CONFIG_PARAVIRT
+	if (pv_ops.mmu.flush_tlb_multi != native_flush_tlb_multi)
+		return;
+#endif
+
+	if (cpu_feature_enabled(X86_FEATURE_INVLPGB))
+		return;
+
+	static_branch_enable(&tlb_ipi_broadcast_key);
+}
-- 
2.49.0


