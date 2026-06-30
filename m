Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20441C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:42:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9D5A6B00E8; Tue, 30 Jun 2026 12:42:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C28DE6B00E9; Tue, 30 Jun 2026 12:42:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17BD6B00EA; Tue, 30 Jun 2026 12:42:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 466D96B00E8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:42:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8082A0596
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:42:25 +0000 (UTC)
X-FDA: 84937147050.21.BDE002D
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id BC5F240005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:42:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nQ91wK6p;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782837744;
	b=s4kII+Qic0IvoUkPIiHkLnsqm93R9Jy+M68QvmjMnu0FrwPh2s5hAqJKjmG0J2+alsWwuk
	NaUq+zWnmQ8FzY+PaVFhXEkKRKfjHGy4MZc5m3q1w5vMoybn+XSWCvbCmZdySsNHjxWDer
	j6KuK32lAxvc1X42zQG0VgwZBImvINs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782837744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vo93RrZzpqeT6Xcv90jHo0vaMw4M6uNUbW4YCctJZbU=;
	b=FkuZ9HsQmqzwI1ILgBsSGNp9T2eLThcddj2SEc/WfOnsj9czv9/1CzJWOzzVfcLJea5JGc
	8VQx44E2BIck2yoz0VKbdKqZRL6lM17yJsMqnjr9b+pOOE250aRqpyx21lXc/WomFkWOsu
	Ux3gC5M5GVvrMex8nal8kBmnCUN75jw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nQ91wK6p;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782837742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vo93RrZzpqeT6Xcv90jHo0vaMw4M6uNUbW4YCctJZbU=;
	b=nQ91wK6p1ytBSuW2YiNmTpOO45WHxkKJE6n3CXl6I4+BqRIkpj26oqXnNKi/qan2eLVrEE
	+tavsdDV5hWR6zbdexcaRVViRlXNqs55jYdkdtxoMi/Y2pcr8eidT08uaLBxx5ODvu7LrG
	jTle0y0Ia2weW1Jk1FlvGkFEQbEgar0=
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
Subject: [PATCH 6/6] mm: rename ARCH_ENABLE_THP_MIGRATION to ARCH_SUPPORTS_PMD_SOFTLEAF
Date: Tue, 30 Jun 2026 09:34:43 -0700
Message-ID: <20260630164143.1595669-7-usama.arif@linux.dev>
In-Reply-To: <20260630164143.1595669-1-usama.arif@linux.dev>
References: <20260630164143.1595669-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BC5F240005
X-Stat-Signature: rxdtrzbwhktmw7ytjo4pe9sya6y5ns9s
X-HE-Tag: 1782837743-261192
X-HE-Meta: U2FsdGVkX1/F65wNE1VUWvQMW6mPlONePkwEhiyA0GzEpJxR3V9UBkQJTCDTKTTJw6T45PWvdm8+ghFP+t/rDhyf5fBr5mPuD1yGLeyXFXekUxaUhInrSI7dht0sM47r/AEoIMCAzqcTa9MmvrbXQg3BoDmF8v+AyFeaefau1N511uGs5VyWzeSBLKpvS5WYQ59rUCTutzCzyQxk2l7fhFpa+kwHygGxCNPrLJP+653nyDJ1bZ2oL1G5CnVxlofeTbn6zudlBsExvd/fkROGKcZOcCzhXjzFO1c3yuP3rDpmjB+6I/vW72KMO2pC+aZnXJoLh5eRKMFPaqe/MmzlPFm99FbIsM8EDdC00yaf7p5rYLopzlxOPQkuPSrL2upUTjhv8b77FciAWRl70D975kPlNEEvsXfFedoUukBIPQx8mKPCqooWKztR2t/eddmMLAZmYLuj94rkf7nB5I///8L1aMBVBG4Fpl9AiSzrvQsD8nciA7cwoDXcXS6sLJbHA36eRAosixKSpA8KnqqTiFgt1dyEAfZmB445fJg+1aJKCF5FPWCjtm74W72AbKr6nVvg1advwhKRRJts65AdSQiAnytBeHHLWLsQUBJHdCjNTmLIDxYOORg/0nCd5jtcAMRhBBPdRIFnMtXiaiYVZwL4xj57FSVjiQMfd1DvTfiD+VIrgjm1QW8xDKMTQ/Wd5LhjmfDt2CxY+gFGutSG59rOn5BmlCh2x8afi3KG/vA6C+IhEoBc7EKfyUNXvNOsHmq1NlElG04OVE4mHgRF6N0WKEN3T4H/vDRxZGumvsdvVZ6jDXTTCB94q6ZL0vxoF5WfpGbYerE1XW4ELBQCUpnga0yJx4Ns7c3STOS9AyB1fVqkvuIKUr+ri+3RwOq9YJJkqSQw6iwKcGUrRDfsr2+kmW1A1JNxY0b4SCkvGh9nlrJy2ZvS0L94brTXpJZjB68Uvjv+/iYwyxR6Xq+
 hvtv5Q/X
 Go2QvYgFJwWXyLgqEfT9tJNZWfF9seA+MmC8B3sW7OXMXZIkwK0gqLwo7wqGuMfNHar/opYsGuPwU4GRjoZZDHfnh2QB0B5Xjj0vIlyRycspck3ygi7NMvnswLs6CqZCpqejAP7s1qR8c+DioiuxN4kXc9tS0r35JztY/clpoeXQ5LAFCs0c5/57c45eZttmF60sK4W+1nhvzk7cgUm7XI9HqxZZXCdEZb+ia0xbj5eKNoaHhFj7v+SnTiwcB2tdmZ5A4edYPAemDLqN9g8b+FC1cCKeTBN9v+57BPkJcg8JZ8dc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CONFIG_ARCH_ENABLE_THP_MIGRATION started life gating just PMD-level
migration entries, but has grown to gate the entire PMD-level softleaf
machinery: migration entries, device-private entries, and soon swap
entries.

Rename CONFIG_ARCH_ENABLE_THP_MIGRATION to CONFIG_ARCH_SUPPORTS_PMD
_SOFTLEAF to make this clear.  This is a pure rename: the set of
selecting architectures (x86, arm64, s390, riscv, loongarch, and
powerpc on PPC_BOOK3S_64) and the gating semantics are unchanged.

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
index b3afe0688919..3eb94f36c77e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -17,7 +17,7 @@ config ARM64
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
-	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+	select ARCH_SUPPORTS_PMD_SOFTLEAF if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_CC_PLATFORM
 	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 27689c62bd25..984badfa9a74 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1534,10 +1534,10 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(swp)	((pte_t) { (swp).val })
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
 #define __pmd_to_swp_entry(pmd)		((swp_entry_t) { pmd_val(pmd) })
 #define __swp_entry_to_pmd(swp)		__pmd((swp).val)
-#endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif /* CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
 
 /*
  * Ensure that there are not more swap files than can be encoded in the kernel
diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index d8d252325017..550142b7ee10 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -12,7 +12,7 @@ config LOONGARCH
 	select ARCH_NEEDS_DEFER_KASAN
 	select ARCH_DISABLE_KASAN_INLINE
 	select ARCH_ENABLE_MEMORY_HOTPLUG
-	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+	select ARCH_SUPPORTS_PMD_SOFTLEAF if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CPU_FINALIZE_INIT
 	select ARCH_HAS_CURRENT_STACK_POINTER
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index e67e64ac6e8c..6f30aa8a6490 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1060,7 +1060,7 @@ static inline pte_t *pmdp_ptep(pmd_t *pmd)
 #define pmd_mksoft_dirty(pmd)  pte_pmd(pte_mksoft_dirty(pmd_pte(pmd)))
 #define pmd_clear_soft_dirty(pmd) pte_pmd(pte_clear_soft_dirty(pmd_pte(pmd)))
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
 #define pmd_swp_mksoft_dirty(pmd)	pte_pmd(pte_swp_mksoft_dirty(pmd_pte(pmd)))
 #define pmd_swp_soft_dirty(pmd)		pte_swp_soft_dirty(pmd_pte(pmd))
 #define pmd_swp_clear_soft_dirty(pmd)	pte_pmd(pte_swp_clear_soft_dirty(pmd_pte(pmd)))
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index bac02c83bb3e..4a0fa681bf98 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -112,7 +112,7 @@ config PPC_THP
        depends on PPC_RADIX_MMU || (PPC_64S_HASH_MMU && PAGE_SIZE_64KB)
        select HAVE_ARCH_TRANSPARENT_HUGEPAGE
        select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-       select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+       select ARCH_SUPPORTS_PMD_SOFTLEAF if TRANSPARENT_HUGEPAGE
 
 choice
 	prompt "CPU selection"
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 3f0a647218e4..bf7b271cccd8 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -22,7 +22,7 @@ config RISCV
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM_VMEMMAP
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
-	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+	select ARCH_SUPPORTS_PMD_SOFTLEAF if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_BINFMT_FLAT
 	select ARCH_HAS_CC_CAN_LINK
 	select ARCH_HAS_CURRENT_STACK_POINTER
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 5d5756bda82e..2aa529e882d3 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -946,7 +946,7 @@ static inline pmd_t pmd_clear_soft_dirty(pmd_t pmd)
 	return pte_pmd(pte_clear_soft_dirty(pmd_pte(pmd)));
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
 static inline bool pmd_swp_soft_dirty(pmd_t pmd)
 {
 	return pte_swp_soft_dirty(pmd_pte(pmd));
@@ -961,7 +961,7 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
 {
 	return pte_pmd(pte_swp_clear_soft_dirty(pmd_pte(pmd)));
 }
-#endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif /* CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
@@ -1208,10 +1208,10 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return __pte(pte_val(pte) & ~_PAGE_SWP_EXCLUSIVE);
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
 #define __pmd_to_swp_entry(pmd) ((swp_entry_t) { pmd_val(pmd) })
 #define __swp_entry_to_pmd(swp) __pmd((swp).val)
-#endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif /* CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
 
 /*
  * In the RV64 Linux scheme, we give the user half of the virtual-address space
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 84404e6778d5..0719f68de0f3 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -82,7 +82,7 @@ config S390
 	select ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
 	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
-	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+	select ARCH_SUPPORTS_PMD_SOFTLEAF if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_CC_CAN_LINK
 	select ARCH_HAS_CPU_FINALIZE_INIT
 	select ARCH_HAS_CURRENT_STACK_POINTER
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 859ce7c7d454..6faccfa63b09 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -903,7 +903,7 @@ static inline pmd_t pmd_clear_soft_dirty(pmd_t pmd)
 	return clear_pmd_bit(pmd, __pgprot(_SEGMENT_ENTRY_SOFT_DIRTY));
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
 #define pmd_swp_soft_dirty(pmd)		pmd_soft_dirty(pmd)
 #define pmd_swp_mksoft_dirty(pmd)	pmd_mksoft_dirty(pmd)
 #define pmd_swp_clear_soft_dirty(pmd)	pmd_clear_soft_dirty(pmd)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bdad90f210e4..50e00d8417aa 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -70,7 +70,7 @@ config X86
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if X86_64 && HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if (PGTABLE_LEVELS > 2) && (X86_64 || X86_PAE)
-	select ARCH_ENABLE_THP_MIGRATION if X86_64 && TRANSPARENT_HUGEPAGE
+	select ARCH_SUPPORTS_PMD_SOFTLEAF if X86_64 && TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CPU_ATTACK_VECTORS	if CPU_MITIGATIONS
 	select ARCH_HAS_CACHE_LINE_SIZE
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index ac295ca6c92f..e0fd318d4004 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1545,7 +1545,7 @@ static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
 	return pte_clear_flags(pte, _PAGE_SWP_SOFT_DIRTY);
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
 static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
 {
 	return pmd_set_flags(pmd, _PAGE_SWP_SOFT_DIRTY);
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index ad20f7f8c179..1487bf4af1a7 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -567,7 +567,7 @@ static inline struct folio *get_persistent_huge_zero_folio(void)
 
 static inline bool thp_migration_supported(void)
 {
-	return IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION);
+	return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF);
 }
 
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 803d312437df..88888daeb018 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -81,7 +81,7 @@ static inline pte_t softleaf_to_pte(softleaf_t entry)
 	return swp_entry_to_pte(entry);
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
 /**
  * softleaf_from_pmd() - Obtain a leaf entry from a PMD entry.
  * @pmd: PMD entry.
@@ -587,7 +587,7 @@ static inline bool pte_is_uffd_marker(pte_t pte)
 	return false;
 }
 
-#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_ENABLE_THP_MIGRATION)
+#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF)
 
 /**
  * pmd_is_device_private_entry() - Check if PMD contains a device private swap
@@ -606,14 +606,14 @@ static inline bool pmd_is_device_private_entry(pmd_t pmd)
 	return softleaf_is_device_private(softleaf_from_pmd(pmd));
 }
 
-#else  /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#else  /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
 
 static inline bool pmd_is_device_private_entry(pmd_t pmd)
 {
 	return false;
 }
 
-#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
 
 /**
  * pmd_is_migration_entry() - Does this PMD entry encode a migration entry?
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index d52d2a976e5a..e38f069c1c91 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1839,7 +1839,7 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 #endif
 
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
-#ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifndef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
 static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
 {
 	return pmd;
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 8cfc966eae48..705a84154d28 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -321,7 +321,7 @@ static inline swp_entry_t make_guard_swp_entry(void)
 
 struct page_vma_mapped_walk;
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
 extern int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page);
 
@@ -338,7 +338,7 @@ static inline pmd_t swp_entry_to_pmd(swp_entry_t entry)
 	return __swp_entry_to_pmd(arch_entry);
 }
 
-#else  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#else  /* CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
 static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page)
 {
@@ -358,7 +358,7 @@ static inline pmd_t swp_entry_to_pmd(swp_entry_t entry)
 	return __pmd(0);
 }
 
-#endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif  /* CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
 
 #endif /* CONFIG_MMU */
 #endif /* _LINUX_SWAPOPS_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index 9e0ca4824905..04fe5171bb8c 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -703,7 +703,7 @@ config DEVICE_MIGRATION
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
 
-config ARCH_ENABLE_THP_MIGRATION
+config ARCH_SUPPORTS_PMD_SOFTLEAF
 	bool
 
 config HUGETLB_PAGE_SIZE_VARIABLE
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 18411fb09aab..507fbd1ae7e5 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -751,7 +751,7 @@ static void __init pmd_leaf_soft_dirty_tests(struct pgtable_debug_args *args)
 	pmd_t pmd;
 
 	if (!pgtable_supports_soft_dirty() ||
-	    !IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION))
+	    !IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF))
 		return;
 
 	if (!has_transparent_hugepage())
@@ -819,7 +819,7 @@ static void __init pte_swap_tests(struct pgtable_debug_args *args)
 	WARN_ON(memcmp(&pte1, &pte2, sizeof(pte1)));
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
 static void __init pmd_softleaf_tests(struct pgtable_debug_args *args)
 {
 	swp_entry_t arch_entry;
@@ -837,9 +837,9 @@ static void __init pmd_softleaf_tests(struct pgtable_debug_args *args)
 	pmd2 = __swp_entry_to_pmd(arch_entry);
 	WARN_ON(memcmp(&pmd1, &pmd2, sizeof(pmd1)));
 }
-#else  /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#else  /* !CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
 static void __init pmd_softleaf_tests(struct pgtable_debug_args *args) { }
-#endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif /* CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
 
 static void __init swap_migration_tests(struct pgtable_debug_args *args)
 {
diff --git a/mm/hmm.c b/mm/hmm.c
index c72c9ddfdb2f..4f3f627d2b47 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -331,7 +331,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 	return hmm_vma_fault(addr, end, required_fault, walk);
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
 static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 				     unsigned long end, unsigned long *hmm_pfns,
 				     pmd_t pmd)
@@ -391,7 +391,7 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 		return -EFAULT;
 	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
 }
-#endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif  /* CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
 
 static int hmm_vma_walk_pmd(pmd_t *pmdp,
 			    unsigned long start,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4aca9cdff73f..4b6e441ae931 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4864,7 +4864,7 @@ static int __init split_huge_pages_debugfs(void)
 late_initcall(split_huge_pages_debugfs);
 #endif
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
 int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page)
 {
diff --git a/mm/migrate.c b/mm/migrate.c
index 49e10feeb094..c48dc5127e6a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -362,7 +362,7 @@ static bool remove_migration_pte(struct folio *folio,
 			idx = linear_page_index(vma, pvmw.address) - pvmw.pgoff;
 		new = folio_page(folio, idx);
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
 		/* PMD-mapped THP migration entry */
 		if (!pvmw.pte) {
 			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
@@ -545,7 +545,7 @@ void migration_entry_wait_huge(struct vm_area_struct *vma, unsigned long addr, p
 }
 #endif
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
 void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
 {
 	spinlock_t *ptl;
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 36287e958b2a..2f8b646302c2 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -771,7 +771,7 @@ int migrate_vma_setup(struct migrate_vma *args)
 }
 EXPORT_SYMBOL(migrate_vma_setup);
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
 /**
  * migrate_vma_insert_huge_pmd_page: Insert a huge folio into @migrate->vma->vm_mm
  * at @addr. folio is already allocated as a part of the migration process with
@@ -926,7 +926,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
 		migrate->src[i+idx] = migrate_pfn(pfn + i) | flags;
 	return ret;
 }
-#else /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#else /* !CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
 static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 					 unsigned long addr,
 					 struct page *page,
@@ -947,7 +947,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
 static unsigned long migrate_vma_nr_pages(unsigned long *src)
 {
 	unsigned long nr = 1;
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
 	if (*src & MIGRATE_PFN_COMPOUND)
 		nr = HPAGE_PMD_NR;
 #else
diff --git a/mm/rmap.c b/mm/rmap.c
index b93caabd186f..0fb7a1b82cf3 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2472,7 +2472,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 				page_vma_mapped_walk_restart(&pvmw);
 				continue;
 			}
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
 			pmdval = pmdp_get(pvmw.pmd);
 			if (likely(pmd_present(pmdval)))
 				pfn = pmd_pfn(pmdval);
-- 
2.53.0-Meta


