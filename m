Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5172D79779
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 07:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46FD76B0092; Mon,  2 Feb 2026 02:47:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44D1D6B0093; Mon,  2 Feb 2026 02:47:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363436B0095; Mon,  2 Feb 2026 02:47:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 275E16B0092
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 02:47:11 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D5A0F8CCCD
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 07:47:10 +0000 (UTC)
X-FDA: 84398735820.16.C87DCD7
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3241620003
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 07:47:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D5A9eCaq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770018429; a=rsa-sha256;
	cv=none;
	b=xQYdIqc1pFnPoKy5BGgp7KErz0JU0vYRURDBoM4lFKvTGPuL90jddKm2JAJdoZpHOP7L+9
	rR8bc6JCunskVl+SbTGShWJ3ZLHu9i4Pa7uDBYAgUq/atP7xs3vee7C4NQWdSmikk/eMmn
	rh+0JrRojfgOUA6pM23x7LS9bMSKh7c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D5A9eCaq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770018429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=isCUzTGbqG3bOQ3RuuUP2N5J/vxqd6Q7qV+0hYo+bgg=;
	b=movhxtjwYz4lJMFuBmOVlcIxiQ6LYI4rbH4WeanE4pPpPGkD5rhFlqp/SJlW16soV15fOC
	yzA1iBazfQgwLEnJyr3S9jyjv7dRbHp46y36IJ7p8RgA5Eck0K5V51f+meUXzNPk9BzVV/
	1O8c6EZnr2J+IU/vDsLfJlhBCdFO8ko=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770018427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=isCUzTGbqG3bOQ3RuuUP2N5J/vxqd6Q7qV+0hYo+bgg=;
	b=D5A9eCaqnDwPfPlsPpp1aRvf1ZE+NM/c95SgXDrGmAR44MyygQktcjUSU8XXvyPNYQaWk9
	qcl8JQRK/IR1Ut1hUF03zTtPVT1QYpBajRDaL9tMaezJYNweSBRbD2uETbtApbcSOdWO/7
	emFfeNqqDRnsBQgk6p5oB0F0XfVXwP8=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	ypodemsk@redhat.com,
	hughd@google.com,
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
Subject: [PATCH v4 3/3] x86/tlb: add architecture-specific TLB IPI optimization support
Date: Mon,  2 Feb 2026 15:45:57 +0800
Message-ID: <20260202074557.16544-4-lance.yang@linux.dev>
In-Reply-To: <20260202074557.16544-1-lance.yang@linux.dev>
References: <20260202074557.16544-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3241620003
X-Stat-Signature: u8dgwa3xannjexkepghfyx15rix6nuhh
X-HE-Tag: 1770018428-490181
X-HE-Meta: U2FsdGVkX184WVs30s4Kyxf+TAec+FUnBUBKUFl2XLfmZXwDJclmRZFJcCpRhLM9eRmlWfoVfLcO4AKbrwv6E7XPZPeOiUOBf5I0kohBkt1UdNimls+0fkUjqPiOTyHwN0gmF0vtpmutLRz0q8qFNJ+m58DP3LBliWHjDFXqOUdiOSoxjM1A7DbQhJxWxmYcU52NkByk+zqlDXkDWjzsyRh7qCC1RSmfe/+oaxno9iK71GH2M5eDCyxhNIMADuKAZLYRgmDq+Ca3swAM1qjAnPuHdJQP+0bEqmyQB15f1cMSUGKPq/x0iPkl8rIh06e+8735bMlL1730aZDy5Azjq2CqfZ77jKnhTsGWb+1QtqXqlT97XiVz0mfp2H0xy8OKLbFiaUG+JHvnWf60bIQMkhCCQH9Qd9sappVG3f/0yGPy847IgI9b5HX5K2bk6V7OuKylGG8WkpbcFpZY6o4iNk613BiaIOmjY/Jk7NvaZ/L1HmM7VvBl+zRluC8J+RegvHLvt+K4R+f2+ggcywmIudkva3xtBhqtKxDw/ts6byMVI7eeqpCsNpR9ydn+2QIn6MlUnkhwXOK6fNgvNAvT6Ql0OJGMSQPkJ5l0RJCR5Dh41ReKKrUwYGNSBGVDPiLc5qavSRVGz/uJJ//AnF4bKjm6U9S19dXrDR1UoYsEBNtUi2Qvz1FnbG2sNaV6F2XMBqPN5Qn2QDHnB/02KFuZMP6MPe72zqQU7nN9klDR/F+Yik//E+Hxpap0zQDZvZY4lV5DYwXEk82SFSc3iG85iKeBCZgQSkiEzNvFMN559F/0G0jj/o4zsMYLmckHPH9taMhoD/gENPKm7ZuB96XhAwFh8yEyORyVxm6dTxLX1s01+KDC03CGkiAVESGV1jOVTB/YBzSMm0IQYeaS77u+QciPYPKS9ECg3AWIzSWnTGbxHfG7+79e8UJZgiZnctHzNZTdcMsRWvYsRCqqVHm
 QJMm/Nyq
 A13KzPZ8RuBdjTHYGuh6Dpcm2LJCp31cL9eKuGwmnqzZmjRhEGamRpGItCL3ZewkywDL23D8sawdrbhu6TsV6DIpi0dgosNsIu0hnMx7I81g//+iFFQMP8xvG3KN0wTe6aW4cKEXkHAco2NhFrz9ftTLc3S5Yq1PUYr0d9Xep7hBvG2e79bDbP2QPh3VU7kY3Z0xUPCAkg5g88o4chniJCTUUNHWvce5MLxty
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When the TLB flush path already sends IPIs (e.g. native without INVLPGB,
or KVM), tlb_remove_table_sync_mm() does not need to send another round.

Add a property on pv_mmu_ops so each paravirt backend can indicate whether
its flush_tlb_multi sends real IPIs; if so, tlb_remove_table_sync_mm() is
a no-op.

Native sets it in native_pv_tlb_init() when still using
native_flush_tlb_multi() and INVLPGB is disabled. KVM sets it true; Xen and
Hyper-V set it false because they use hypercalls.

Also pass both freed_tables and unshared_tables from tlb_flush() into
flush_tlb_mm_range() so lazy-TLB CPUs get IPIs during hugetlb unshare.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 arch/x86/hyperv/mmu.c                 |  5 +++++
 arch/x86/include/asm/paravirt.h       |  5 +++++
 arch/x86/include/asm/paravirt_types.h |  6 ++++++
 arch/x86/include/asm/tlb.h            | 20 +++++++++++++++++++-
 arch/x86/kernel/kvm.c                 |  6 ++++++
 arch/x86/kernel/paravirt.c            | 18 ++++++++++++++++++
 arch/x86/kernel/smpboot.c             |  1 +
 arch/x86/xen/mmu_pv.c                 |  2 ++
 include/asm-generic/tlb.h             | 15 +++++++++++++++
 mm/mmu_gather.c                       |  7 +++++++
 10 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/arch/x86/hyperv/mmu.c b/arch/x86/hyperv/mmu.c
index cfcb60468b01..fc8fb275f295 100644
--- a/arch/x86/hyperv/mmu.c
+++ b/arch/x86/hyperv/mmu.c
@@ -243,4 +243,9 @@ void hyperv_setup_mmu_ops(void)
 
 	pr_info("Using hypercall for remote TLB flush\n");
 	pv_ops.mmu.flush_tlb_multi = hyperv_flush_tlb_multi;
+	/*
+	 * Hyper-V uses hypercalls for TLB flush, not real IPIs.
+	 * Keep the property as false.
+	 */
+	pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = false;
 }
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 13f9cd31c8f8..1fdbe3736f41 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -698,6 +698,7 @@ static __always_inline unsigned long arch_local_irq_save(void)
 
 extern void default_banner(void);
 void native_pv_lock_init(void) __init;
+void native_pv_tlb_init(void) __init;
 
 #else  /* __ASSEMBLER__ */
 
@@ -727,6 +728,10 @@ void native_pv_lock_init(void) __init;
 static inline void native_pv_lock_init(void)
 {
 }
+
+static inline void native_pv_tlb_init(void)
+{
+}
 #endif
 #endif /* !CONFIG_PARAVIRT */
 
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 3502939415ad..d8aa519ef5e3 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -133,6 +133,12 @@ struct pv_mmu_ops {
 	void (*flush_tlb_multi)(const struct cpumask *cpus,
 				const struct flush_tlb_info *info);
 
+	/*
+	 * Indicates whether flush_tlb_multi IPIs provide sufficient
+	 * synchronization during TLB flush when freeing or unsharing page tables.
+	 */
+	bool flush_tlb_multi_implies_ipi_broadcast;
+
 	/* Hook for intercepting the destruction of an mm_struct. */
 	void (*exit_mmap)(struct mm_struct *mm);
 	void (*notify_page_enc_status_changed)(unsigned long pfn, int npages, bool enc);
diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 866ea78ba156..1e524d8e260a 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -5,10 +5,23 @@
 #define tlb_flush tlb_flush
 static inline void tlb_flush(struct mmu_gather *tlb);
 
+#define tlb_table_flush_implies_ipi_broadcast tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void);
+
 #include <asm-generic/tlb.h>
 #include <linux/kernel.h>
 #include <vdso/bits.h>
 #include <vdso/page.h>
+#include <asm/paravirt.h>
+
+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+#ifdef CONFIG_PARAVIRT
+	return pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast;
+#else
+	return !cpu_feature_enabled(X86_FEATURE_INVLPGB);
+#endif
+}
 
 static inline void tlb_flush(struct mmu_gather *tlb)
 {
@@ -20,7 +33,12 @@ static inline void tlb_flush(struct mmu_gather *tlb)
 		end = tlb->end;
 	}
 
-	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
+	/*
+	 * During TLB flushes, pass both freed_tables and unshared_tables
+	 * so lazy-TLB CPUs receive IPIs.
+	 */
+	flush_tlb_mm_range(tlb->mm, start, end, stride_shift,
+			   tlb->freed_tables || tlb->unshared_tables);
 }
 
 static inline void invlpg(unsigned long addr)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 37dc8465e0f5..6a5e47ee4eb6 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -856,6 +856,12 @@ static void __init kvm_guest_init(void)
 #ifdef CONFIG_SMP
 	if (pv_tlb_flush_supported()) {
 		pv_ops.mmu.flush_tlb_multi = kvm_flush_tlb_multi;
+		/*
+		 * KVM's flush implementation calls native_flush_tlb_multi(),
+		 * which sends real IPIs when INVLPGB is not available.
+		 */
+		if (!cpu_feature_enabled(X86_FEATURE_INVLPGB))
+			pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
 		pr_info("KVM setup pv remote TLB flush\n");
 	}
 
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index ab3e172dcc69..1af253c9f51d 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -60,6 +60,23 @@ void __init native_pv_lock_init(void)
 		static_branch_enable(&virt_spin_lock_key);
 }
 
+void __init native_pv_tlb_init(void)
+{
+	/*
+	 * Check if we're still using native TLB flush (not overridden by
+	 * a PV backend) and don't have INVLPGB support.
+	 *
+	 * In this case, native IPI-based TLB flush provides sufficient
+	 * synchronization for GUP-fast.
+	 *
+	 * PV backends (KVM, Xen, HyperV) should set this property in their
+	 * own initialization code if their flush implementation sends IPIs.
+	 */
+	if (pv_ops.mmu.flush_tlb_multi == native_flush_tlb_multi &&
+	    !cpu_feature_enabled(X86_FEATURE_INVLPGB))
+		pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
+}
+
 struct static_key paravirt_steal_enabled;
 struct static_key paravirt_steal_rq_enabled;
 
@@ -173,6 +190,7 @@ struct paravirt_patch_template pv_ops = {
 	.mmu.flush_tlb_kernel	= native_flush_tlb_global,
 	.mmu.flush_tlb_one_user	= native_flush_tlb_one_user,
 	.mmu.flush_tlb_multi	= native_flush_tlb_multi,
+	.mmu.flush_tlb_multi_implies_ipi_broadcast = false,
 
 	.mmu.exit_mmap		= paravirt_nop,
 	.mmu.notify_page_enc_status_changed	= paravirt_nop,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5cd6950ab672..3cdb04162843 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1167,6 +1167,7 @@ void __init native_smp_prepare_boot_cpu(void)
 		switch_gdt_and_percpu_base(me);
 
 	native_pv_lock_init();
+	native_pv_tlb_init();
 }
 
 void __init native_smp_cpus_done(unsigned int max_cpus)
diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index 7a35c3393df4..b6d86299cf10 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -2185,6 +2185,8 @@ static const typeof(pv_ops) xen_mmu_ops __initconst = {
 		.flush_tlb_kernel = xen_flush_tlb,
 		.flush_tlb_one_user = xen_flush_tlb_one_user,
 		.flush_tlb_multi = xen_flush_tlb_multi,
+		/* Xen uses hypercalls for TLB flush, not real IPIs */
+		.flush_tlb_multi_implies_ipi_broadcast = false,
 
 		.pgd_alloc = xen_pgd_alloc,
 		.pgd_free = xen_pgd_free,
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 40eb74b28f9d..fae97c8bcceb 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -240,6 +240,21 @@ static inline void tlb_remove_table(struct mmu_gather *tlb, void *table)
 }
 #endif /* CONFIG_MMU_GATHER_TABLE_FREE */
 
+/*
+ * Architectures can override this to indicate whether TLB flush operations
+ * send IPIs that are sufficient to synchronize with lockless page table
+ * walkers (e.g., GUP-fast). If true, tlb_remove_table_sync_mm() becomes
+ * a no-op as the TLB flush already provided the necessary IPI.
+ *
+ * Default is false, meaning we need explicit IPIs via tlb_remove_table_sync_mm().
+ */
+#ifndef tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+	return false;
+}
+#endif
+
 #ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
 /*
  * This allows an architecture that does not use the linux page-tables for
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 76573ec454e5..9620480c11ce 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -303,6 +303,13 @@ void tlb_remove_table_sync_mm(struct mm_struct *mm)
 	bool found_any = false;
 	int cpu;
 
+	/*
+	 * If the architecture's TLB flush already sent IPIs that are sufficient
+	 * for synchronization, we don't need to send additional IPIs.
+	 */
+	if (tlb_table_flush_implies_ipi_broadcast())
+		return;
+
 	if (WARN_ONCE(!mm, "NULL mm in %s\n", __func__)) {
 		tlb_remove_table_sync_one();
 		return;
-- 
2.49.0


