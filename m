Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FFC4C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 11:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8E6C6B00A2; Mon,  6 Jul 2026 07:44:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3F396B00A3; Mon,  6 Jul 2026 07:44:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54D96B00A4; Mon,  6 Jul 2026 07:44:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8523F6B00A2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:44:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C4571C3367
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:44:07 +0000 (UTC)
X-FDA: 84958168134.05.8D05969
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4DD9580005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:44:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T94LuLVG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783338245;
	b=0bwctYzJmIR/LB6VEf08h2kmR01S24NBStNTp3CT99X5XpIhOw0u7Gb7sGnH1wpQLgbvhr
	GJPuNjkliqUUc4+xh8ikRnJzweV/H1OOSo9x03dTeyuVMnhHjUyHa1HWyi02y1rQ2C9v8+
	9RH0rew6VsfO1cTBVVv7zOMW9o5Q5x0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T94LuLVG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783338245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pOKgVYxd/B4WAMLyQUMQsLVXSJu+9q2d0D9TNFlMBkA=;
	b=pY8AaqH6w58vEr3HvdnhCSJVGci7Hl/3JO376TdgLymz601d3rWDxF79LC/nY5gM3nF47o
	QpRMr/cA254sd7JgzKjzJfMHkMcD74L7Cw2T/gTjXvVd+85Qu4bLzRCMHN7lzal14CdUNj
	hpGK9zLuLwebZDsqzD9E24y4dshXejM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783338243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pOKgVYxd/B4WAMLyQUMQsLVXSJu+9q2d0D9TNFlMBkA=;
	b=T94LuLVGRxN0AUr0mC8yeZFstS0zv5xPpTO9PtZGijDolcLwie2r+gLvGWrFppr1Xf1jk/
	5XGb9zKM5XsbcXNwNQa8StyQ84ydOpOC03B45YtV/h67NgOCHpyiyFVHeQSM+joSCURfgS
	0U9Z++LXlgPzXHB9rRzFmMmUlI4E4Po=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2 6/6] mm: rename ARCH_ENABLE_THP_MIGRATION to ARCH_HAS_PMD_SOFTLEAVES
Date: Mon,  6 Jul 2026 04:42:08 -0700
Message-ID: <20260706114320.1643046-7-usama.arif@linux.dev>
In-Reply-To: <20260706114320.1643046-1-usama.arif@linux.dev>
References: <20260706114320.1643046-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4DD9580005
X-Rspam-User: 
X-Stat-Signature: 7wtawz49ossi8d34u4odwmmmki3eds9g
X-Rspamd-Server: rspam03
X-HE-Tag: 1783338245-944461
X-HE-Meta: U2FsdGVkX1+Zag5WA2RGSwCP71guX2ekY7Iy+51zH22vpiah+25Rbb7fzHU6lqG6Yd9hAwOeuLkSoFWVsvW0v9YRxETzYgJdgIOrKf845FJbYNnyBgXSIi3vne2hCWN5d/Qocp8wkB4ThbDVoRvYnqi0aq6awB9hMsJ14yeccVr8cXaoBFoHmeca4U6OP0wfyrohnG1NWh9OcZF5s4awewdHtS1BkSRmY7ZUSg3oe4Rbuhrg/DFQk1McWeS99AaUFoOhwmgV4m6Z9HJWwwEMhMpb3zz28w9+ix7EOiWqb5pPoMVqamkwzHS4uMWF07P7f0gffY3KTkwKjZfkargCiiZB/EqfLMkHEe8JJDRPrLzXQx0cICayvMhSPwFF80FD6xirHcOMEu1y4CEjG1hIriSrnyB9kxBugjhaw2KgPjCN1YjirViwqCJE0QAi+/EpxtG2hF31aFea3Aw+7WSP2I+jRFCsg66pdxZLdmbjUAacWU14cvcthJX8DVydwA3KUGrKITn2m71zFFhsXCdaBueq3yw/b9oFG6ph6ApVSxk+bI7FA3nSpmh7HcVqXbH8B0oXDk6CYSDC3ivSYswYd03+ewGBCFH/PuNab77fNW5xnpTy/gglRWJEyTaO2WYKT6Nh+qCB3MOG9ISEbsqTVWqSKDlk0trW1ObEc+Z4C3jaAcS8Or7KAxRI9w2ChV4/SivpkgQDngUSzcK0lUz5tru2f1z0KGURgmMks2fyDWuga/JgDlz6AMBrtmSHjC3GJcL61aBdScSv7vmtzzs955uMF0NVSXLFIa+Qp9SWV1RGDp4guMh5wki7lXYlSz0zl/NdIGoaYBhDMRhK2Q4q8uoD2QypB9s8XuemIVZYMXOTwAsBdDIuzS1EOgdCt299OIe6GIWHG84xz2+bO+FXt/09S5buMZr6W57MU8LniP9lsOxqhV8n5BEiD8PTvCB5vfxewnGilmlh70vVtmF
 9JLN5cqi
 BBo1YtpYRLG5vjVHaSZHjbkoJjoOY3u66uORwhWom8/e9epA9IDHiJmwUFml3VJhOEcN1qCEw6FDHKJNdStIs4SSGGywLCoQXP5U0X3zSc4Zkg+gX6hNEJPvcYGAvaA1rDDpEcTp1f7n58oJL4TbVjavovf6zWZOo21mbQHQRdNGlr4PYu00EAbftpi+GpX6OHSgFUXoYxbRYBkvmvKRlBjX24EoCUKWZpyEC03jA1OxOJm5Rsc0ysBzIAVr7JHY3mSzdI1HQNyjptpGxXAu2gPwb4UF1isKQ4wrHPESbLGRhtxU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CONFIG_ARCH_ENABLE_THP_MIGRATION gates PMD-level migration entries.
PMD-level device-private entries use the same migration mechanism and
therefore require the same architecture support.

Upcoming PMD-level swap entries can use the same PMD softleaf helpers
without depending on page migration, so rename the architecture gate to
CONFIG_ARCH_HAS_PMD_SOFTLEAVES.  This describes the PMD entry capability
rather than one current user of it.

This is a pure rename: the set of selecting architectures (x86, arm64,
s390, riscv, loongarch, and powerpc on PPC_BOOK3S_64) and the gating
semantics are unchanged.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/arm64/Kconfig                           | 2 +-
 arch/arm64/include/asm/pgtable.h             | 4 ++--
 arch/loongarch/Kconfig                       | 2 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h | 2 +-
 arch/powerpc/platforms/Kconfig.cputype       | 2 +-
 arch/riscv/Kconfig                           | 2 +-
 arch/riscv/include/asm/pgtable.h             | 8 ++++----
 arch/s390/Kconfig                            | 2 +-
 arch/s390/include/asm/pgtable.h              | 2 +-
 arch/x86/Kconfig                             | 2 +-
 arch/x86/include/asm/pgtable.h               | 2 +-
 include/linux/huge_mm.h                      | 2 +-
 include/linux/leafops.h                      | 8 ++++----
 include/linux/pgtable.h                      | 2 +-
 include/linux/swapops.h                      | 6 +++---
 mm/Kconfig                                   | 2 +-
 mm/debug_vm_pgtable.c                        | 8 ++++----
 mm/hmm.c                                     | 4 ++--
 mm/huge_memory.c                             | 2 +-
 mm/migrate.c                                 | 4 ++--
 mm/migrate_device.c                          | 6 +++---
 mm/rmap.c                                    | 2 +-
 22 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b3afe0688919..e136e5abdb33 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -17,7 +17,7 @@ config ARM64
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
-	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+	select ARCH_HAS_PMD_SOFTLEAVES if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_CC_PLATFORM
 	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 27689c62bd25..ed1cc6dba780 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1534,10 +1534,10 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(swp)	((pte_t) { (swp).val })
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 #define __pmd_to_swp_entry(pmd)		((swp_entry_t) { pmd_val(pmd) })
 #define __swp_entry_to_pmd(swp)		__pmd((swp).val)
-#endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 /*
  * Ensure that there are not more swap files than can be encoded in the kernel
diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index d8d252325017..c6c611f44f3f 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -12,7 +12,7 @@ config LOONGARCH
 	select ARCH_NEEDS_DEFER_KASAN
 	select ARCH_DISABLE_KASAN_INLINE
 	select ARCH_ENABLE_MEMORY_HOTPLUG
-	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+	select ARCH_HAS_PMD_SOFTLEAVES if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CPU_FINALIZE_INIT
 	select ARCH_HAS_CURRENT_STACK_POINTER
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index e67e64ac6e8c..800ff3cc5f71 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1060,7 +1060,7 @@ static inline pte_t *pmdp_ptep(pmd_t *pmd)
 #define pmd_mksoft_dirty(pmd)  pte_pmd(pte_mksoft_dirty(pmd_pte(pmd)))
 #define pmd_clear_soft_dirty(pmd) pte_pmd(pte_clear_soft_dirty(pmd_pte(pmd)))
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 #define pmd_swp_mksoft_dirty(pmd)	pte_pmd(pte_swp_mksoft_dirty(pmd_pte(pmd)))
 #define pmd_swp_soft_dirty(pmd)		pte_swp_soft_dirty(pmd_pte(pmd))
 #define pmd_swp_clear_soft_dirty(pmd)	pte_pmd(pte_swp_clear_soft_dirty(pmd_pte(pmd)))
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index bac02c83bb3e..9f6847b53e37 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -112,7 +112,7 @@ config PPC_THP
        depends on PPC_RADIX_MMU || (PPC_64S_HASH_MMU && PAGE_SIZE_64KB)
        select HAVE_ARCH_TRANSPARENT_HUGEPAGE
        select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-       select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+       select ARCH_HAS_PMD_SOFTLEAVES if TRANSPARENT_HUGEPAGE
 
 choice
 	prompt "CPU selection"
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 3f0a647218e4..c7c4efbddf15 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -22,7 +22,7 @@ config RISCV
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM_VMEMMAP
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
-	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+	select ARCH_HAS_PMD_SOFTLEAVES if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_BINFMT_FLAT
 	select ARCH_HAS_CC_CAN_LINK
 	select ARCH_HAS_CURRENT_STACK_POINTER
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 5d5756bda82e..23eae82c26a6 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -946,7 +946,7 @@ static inline pmd_t pmd_clear_soft_dirty(pmd_t pmd)
 	return pte_pmd(pte_clear_soft_dirty(pmd_pte(pmd)));
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 static inline bool pmd_swp_soft_dirty(pmd_t pmd)
 {
 	return pte_swp_soft_dirty(pmd_pte(pmd));
@@ -961,7 +961,7 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
 {
 	return pte_pmd(pte_swp_clear_soft_dirty(pmd_pte(pmd)));
 }
-#endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
@@ -1208,10 +1208,10 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return __pte(pte_val(pte) & ~_PAGE_SWP_EXCLUSIVE);
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 #define __pmd_to_swp_entry(pmd) ((swp_entry_t) { pmd_val(pmd) })
 #define __swp_entry_to_pmd(swp) __pmd((swp).val)
-#endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 /*
  * In the RV64 Linux scheme, we give the user half of the virtual-address space
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 84404e6778d5..6b317717bf48 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -82,7 +82,7 @@ config S390
 	select ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
 	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
-	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+	select ARCH_HAS_PMD_SOFTLEAVES if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_CC_CAN_LINK
 	select ARCH_HAS_CPU_FINALIZE_INIT
 	select ARCH_HAS_CURRENT_STACK_POINTER
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 859ce7c7d454..645fa2d99c6a 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -903,7 +903,7 @@ static inline pmd_t pmd_clear_soft_dirty(pmd_t pmd)
 	return clear_pmd_bit(pmd, __pgprot(_SEGMENT_ENTRY_SOFT_DIRTY));
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 #define pmd_swp_soft_dirty(pmd)		pmd_soft_dirty(pmd)
 #define pmd_swp_mksoft_dirty(pmd)	pmd_mksoft_dirty(pmd)
 #define pmd_swp_clear_soft_dirty(pmd)	pmd_clear_soft_dirty(pmd)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bdad90f210e4..50acb2830570 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -70,7 +70,7 @@ config X86
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if X86_64 && HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if (PGTABLE_LEVELS > 2) && (X86_64 || X86_PAE)
-	select ARCH_ENABLE_THP_MIGRATION if X86_64 && TRANSPARENT_HUGEPAGE
+	select ARCH_HAS_PMD_SOFTLEAVES if X86_64 && TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CPU_ATTACK_VECTORS	if CPU_MITIGATIONS
 	select ARCH_HAS_CACHE_LINE_SIZE
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index ac295ca6c92f..f69b02c1d3d3 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1545,7 +1545,7 @@ static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
 	return pte_clear_flags(pte, _PAGE_SWP_SOFT_DIRTY);
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
 {
 	return pmd_set_flags(pmd, _PAGE_SWP_SOFT_DIRTY);
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index ad20f7f8c179..b34e8e5e5f9a 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -567,7 +567,7 @@ static inline struct folio *get_persistent_huge_zero_folio(void)
 
 static inline bool thp_migration_supported(void)
 {
-	return IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION);
+	return IS_ENABLED(CONFIG_ARCH_HAS_PMD_SOFTLEAVES);
 }
 
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 803d312437df..ef84ac1cce19 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -81,7 +81,7 @@ static inline pte_t softleaf_to_pte(softleaf_t entry)
 	return swp_entry_to_pte(entry);
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 /**
  * softleaf_from_pmd() - Obtain a leaf entry from a PMD entry.
  * @pmd: PMD entry.
@@ -587,7 +587,7 @@ static inline bool pte_is_uffd_marker(pte_t pte)
 	return false;
 }
 
-#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_ENABLE_THP_MIGRATION)
+#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_HAS_PMD_SOFTLEAVES)
 
 /**
  * pmd_is_device_private_entry() - Check if PMD contains a device private swap
@@ -606,14 +606,14 @@ static inline bool pmd_is_device_private_entry(pmd_t pmd)
 	return softleaf_is_device_private(softleaf_from_pmd(pmd));
 }
 
-#else  /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#else  /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 static inline bool pmd_is_device_private_entry(pmd_t pmd)
 {
 	return false;
 }
 
-#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 /**
  * pmd_is_migration_entry() - Does this PMD entry encode a migration entry?
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index d52d2a976e5a..3df6db1e9e39 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1839,7 +1839,7 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 #endif
 
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
-#ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifndef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
 {
 	return pmd;
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 8cfc966eae48..1125401b787e 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -321,7 +321,7 @@ static inline swp_entry_t make_guard_swp_entry(void)
 
 struct page_vma_mapped_walk;
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 extern int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page);
 
@@ -338,7 +338,7 @@ static inline pmd_t swp_entry_to_pmd(swp_entry_t entry)
 	return __swp_entry_to_pmd(arch_entry);
 }
 
-#else  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#else  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page)
 {
@@ -358,7 +358,7 @@ static inline pmd_t swp_entry_to_pmd(swp_entry_t entry)
 	return __pmd(0);
 }
 
-#endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 #endif /* CONFIG_MMU */
 #endif /* _LINUX_SWAPOPS_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index 9e0ca4824905..a360861c74fa 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -703,7 +703,7 @@ config DEVICE_MIGRATION
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
 
-config ARCH_ENABLE_THP_MIGRATION
+config ARCH_HAS_PMD_SOFTLEAVES
 	bool
 
 config HUGETLB_PAGE_SIZE_VARIABLE
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 18411fb09aab..7987962950c1 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -751,7 +751,7 @@ static void __init pmd_leaf_soft_dirty_tests(struct pgtable_debug_args *args)
 	pmd_t pmd;
 
 	if (!pgtable_supports_soft_dirty() ||
-	    !IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION))
+	    !IS_ENABLED(CONFIG_ARCH_HAS_PMD_SOFTLEAVES))
 		return;
 
 	if (!has_transparent_hugepage())
@@ -819,7 +819,7 @@ static void __init pte_swap_tests(struct pgtable_debug_args *args)
 	WARN_ON(memcmp(&pte1, &pte2, sizeof(pte1)));
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 static void __init pmd_softleaf_tests(struct pgtable_debug_args *args)
 {
 	swp_entry_t arch_entry;
@@ -837,9 +837,9 @@ static void __init pmd_softleaf_tests(struct pgtable_debug_args *args)
 	pmd2 = __swp_entry_to_pmd(arch_entry);
 	WARN_ON(memcmp(&pmd1, &pmd2, sizeof(pmd1)));
 }
-#else  /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#else  /* !CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 static void __init pmd_softleaf_tests(struct pgtable_debug_args *args) { }
-#endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 static void __init swap_migration_tests(struct pgtable_debug_args *args)
 {
diff --git a/mm/hmm.c b/mm/hmm.c
index c72c9ddfdb2f..e5c1f4deed24 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -331,7 +331,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 	return hmm_vma_fault(addr, end, required_fault, walk);
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 				     unsigned long end, unsigned long *hmm_pfns,
 				     pmd_t pmd)
@@ -391,7 +391,7 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 		return -EFAULT;
 	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
 }
-#endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 static int hmm_vma_walk_pmd(pmd_t *pmdp,
 			    unsigned long start,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6ada1e862983..fb2d7dd17de0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4868,7 +4868,7 @@ static int __init split_huge_pages_debugfs(void)
 late_initcall(split_huge_pages_debugfs);
 #endif
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page)
 {
diff --git a/mm/migrate.c b/mm/migrate.c
index 806508be3dec..e47b85075c80 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -362,7 +362,7 @@ static bool remove_migration_pte(struct folio *folio,
 			idx = linear_page_index(vma, pvmw.address) - pvmw.pgoff;
 		new = folio_page(folio, idx);
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 		/* PMD-mapped THP migration entry */
 		if (!pvmw.pte) {
 			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
@@ -545,7 +545,7 @@ void migration_entry_wait_huge(struct vm_area_struct *vma, unsigned long addr, p
 }
 #endif
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
 {
 	spinlock_t *ptl;
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 36287e958b2a..57aaf526db69 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -771,7 +771,7 @@ int migrate_vma_setup(struct migrate_vma *args)
 }
 EXPORT_SYMBOL(migrate_vma_setup);
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 /**
  * migrate_vma_insert_huge_pmd_page: Insert a huge folio into @migrate->vma->vm_mm
  * at @addr. folio is already allocated as a part of the migration process with
@@ -926,7 +926,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
 		migrate->src[i+idx] = migrate_pfn(pfn + i) | flags;
 	return ret;
 }
-#else /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#else /* !CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 					 unsigned long addr,
 					 struct page *page,
@@ -947,7 +947,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
 static unsigned long migrate_vma_nr_pages(unsigned long *src)
 {
 	unsigned long nr = 1;
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 	if (*src & MIGRATE_PFN_COMPOUND)
 		nr = HPAGE_PMD_NR;
 #else
diff --git a/mm/rmap.c b/mm/rmap.c
index b93caabd186f..408e542649b5 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2472,7 +2472,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 				page_vma_mapped_walk_restart(&pvmw);
 				continue;
 			}
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 			pmdval = pmdp_get(pvmw.pmd);
 			if (likely(pmd_present(pmdval)))
 				pfn = pmd_pfn(pmdval);
-- 
2.53.0-Meta


