Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79DC5C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 17:56:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CC736B00BF; Mon,  6 Jul 2026 13:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2A56B00C0; Mon,  6 Jul 2026 13:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B8D96B00C1; Mon,  6 Jul 2026 13:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D61E6B00BF
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:56:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9D216C0A89
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:56:34 +0000 (UTC)
X-FDA: 84959106708.21.F4E8B59
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E1E8C1C000D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:56:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=r8eFaac5;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783360593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nPdY0ByogXxyDQSyK1/UoEx4c72q1eJVOB8wgdz98Bs=;
	b=0EgSX/HNe+cAB7R8VTk5TnAv8CsBxPDMMwEOsiTTVbcnG2jJLjMV/wX3OwtQmod89yisGF
	LeK0eVc5FGX4rAA4VyBw4Mhp4247FmLuTgwLe62hiU6MyMi44wGs16/vDToaW6LWRRtUiJ
	gyxdOOWTeR4tgfifHNERmITNW0UmXWg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783360593;
	b=ud45UFSrlaZl5NDcPiWv9cph+B4zzdZ3UUvdNCuFLR8Ns/w+CiWyai5we2VdctykxiiPCq
	n2Ms6/BRDg1CiHRErHa6j/G6J0NIg/pBEuuVO1RD4gwBz09IvRC0n8zBRfKFvW8WpL3XOS
	qgKYy9nrdGDvYDdVlvWfeP7QR76k8c0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=r8eFaac5;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 09BCA600DA;
	Mon,  6 Jul 2026 17:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D987B1F000E9;
	Mon,  6 Jul 2026 17:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783360591;
	bh=nPdY0ByogXxyDQSyK1/UoEx4c72q1eJVOB8wgdz98Bs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=r8eFaac5cRhGFt2nAQhk+Nw8XuhtQOTH71Zhoqk2uZku7l/Q5lcS2UkNP1+LfSzUH
	 WMTkRf6v98jpjKND07SSxaUtUqq9+LzwaHqFG4UoWNmvVJiJRxsTpm4vH8wG7muiR3
	 zooZrbK9CwZ+ZD6ijy12tH4IiYM2/oSg3jKLDg3A=
Date: Mon, 6 Jul 2026 10:56:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: david@kernel.org, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
 ziy@nvidia.com, linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan
 He <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com,
 hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam R. Howlett
 <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka
 <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org,
 nphamcs@gmail.com, shikemeng@huaweicloud.com, kernel-team@meta.com
Subject: Re: [PATCH v2 0/6] mm: preparatory patches for PMD level swap
 entries
Message-Id: <20260706105630.368ab0d13c1b02d3e1df4af5@linux-foundation.org>
In-Reply-To: <20260706114320.1643046-1-usama.arif@linux.dev>
References: <20260706114320.1643046-1-usama.arif@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E1E8C1C000D
X-Stat-Signature: f916gydjmx5st8ts9oi4dr5gzaz439d5
X-HE-Tag: 1783360592-860018
X-HE-Meta: U2FsdGVkX1+ODhGeBWwEzrhMPG/h1vDuja0lRDuXdq6GawRgaKJ+Pa6BWZftLXUBagjVWUu7N/0crsAPo7xpouqrnmIb7GISUSFNRMXaeI1K3Ag0/K9Kt30kq+07H18EczFuc0u+tDBWMD7IC31xzc+IWYJ+0JY7tahRrSv4bDzRGEEYi5wqoSr8PWpYWSHlN7ugHoZ+pOrOudQ4tqoqTkaOTycSVpZ34gcNXN/jhXZbLbVC5/JUlLCxGEXLqYIdCCteiRdzwdiVjRDkp2aRCBEWE8R0dHUFYWz97wFArl2mv3uBWPkjHOsxwzvUN/l6iMN4AsPBbuHUY5PZHj5UWMzLpwgqkf1P3jfXSeMQmB9y0w/CaLsbnFSqhVIRMTmtbz+k1aQMAXTQETgRcehHucUk1SipoANSsZBbK8uOWyadSq/xlFZNJK9rCcfK4bejcogXtoXPhsq54jINYJXwGclVLvqThT5CfXk5GPMqLNPUgvvu8ajx9Mn08IH4b3H6zNih2R0t0VghMbkouC85l/BadlakkvrJprK9cqohrec5xlOvwR1zEMLnvxTD1WxdTkhb0XVOK3iVpiiUlFzeFthqDa44vxpcGarKL6pdcxBpTrrH6LpmRqwsK4tZoC7/3cOBXNgo2NtJM6VatuvIIgAgwaIJ/LfwM0AdgsyRkraC38FY/MWgc2+gfG1IqGh55jIJ8wF8lY0B/Z4RCt5HSl2KUiyUJ4wbeMQmms3Y/QYHa3MxAsl5mKVt8soganU3yW85auMsZ+A8XeTMtYMIMr643NWQU/SOG7TAyy+TWYj/qTlMrTX4oFmwYBAd11Q5x6LXRJ8NuxbcRbztR0F7+XENQbOHW0hWKEdEPrfkqEFAvb8prh8SAGkJumiQZCvpVYF45gkFJPzPuSUClG0ACFr9xrn/cwsn3NrQA0h6VaYW7uhAf/2CnlTf7EpApCFPzmq77rU3tAyEcGfLN9M
 xkU1xDuD
 q03dsKM22pTMX19kPmFy1rv0gPKfCBFgQKLqLJdCrrO3Y2gahYd8Vt0zdIDK2kERGTviEjzlMU1bBIJ92+0RYxFpPzEsrwGYLSBsaRZqGc7RrU4DuXOQBR4OftrzXhkKqAJPGOhMaIs+YfQXYY2Rm2LJRKdKnfhldYhWf9FOprp0EC+SjdTAY1l7GyoDR7cNRq2xCoVdYlut9HcwfhE1HGHJXuT5zP+ul/yrj2bmEdQOV2t+hgYzhxsWRU/Z5yEnbvtJpAhDaCmKnk0k5aMMT/Zct4RhfgWQ72Im5K/KWTyCvg05RGEu1xBeetL96L0pvWDuKXrP7LW8+1oIhpc3e3DwCJjMWrk00n6DUxRz+Dp3AQHw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Jul 2026 04:42:02 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> This is the preparatory part of the PMD page table swapin work.

Thanks, I updated mm.git to this version.

Sashiko might have found several serious looking pre-existing issues:
	https://sashiko.dev/#/patchset/20260706114320.1643046-1-usama.arif@linux.dev

> v1 -> v2: https://lore.kernel.org/all/20260630164143.1595669-1-usama.arif@linux.dev/
> - Remove unnecessary comment in patch 2 (David)
> - s/ARCH_SUPPORTS_PMD_SOFTLEAF/ARCH_HAS_PMD_SOFTLEAVES/ and rewrite
>   the commit message (David)
>  

Here's how v2 altered mm.git:


 arch/arm64/Kconfig                           |    2 +-
 arch/arm64/include/asm/pgtable.h             |    4 ++--
 arch/loongarch/Kconfig                       |    2 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h |    2 +-
 arch/powerpc/platforms/Kconfig.cputype       |    2 +-
 arch/riscv/Kconfig                           |    2 +-
 arch/riscv/include/asm/pgtable.h             |    8 ++++----
 arch/s390/Kconfig                            |    2 +-
 arch/s390/include/asm/pgtable.h              |    2 +-
 arch/x86/Kconfig                             |    2 +-
 arch/x86/include/asm/pgtable.h               |    2 +-
 include/linux/huge_mm.h                      |    2 +-
 include/linux/leafops.h                      |    8 ++++----
 include/linux/pgtable.h                      |    2 +-
 include/linux/swapops.h                      |    6 +++---
 mm/Kconfig                                   |    2 +-
 mm/debug_vm_pgtable.c                        |    8 ++++----
 mm/hmm.c                                     |    4 ++--
 mm/huge_memory.c                             |    2 +-
 mm/internal.h                                |    3 ---
 mm/migrate.c                                 |    4 ++--
 mm/migrate_device.c                          |    6 +++---
 mm/rmap.c                                    |    2 +-
 23 files changed, 38 insertions(+), 41 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~b
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1534,10 +1534,10 @@ static inline pmd_t pmdp_establish(struc
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(swp)	((pte_t) { (swp).val })
 
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 #define __pmd_to_swp_entry(pmd)		((swp_entry_t) { pmd_val(pmd) })
 #define __swp_entry_to_pmd(swp)		__pmd((swp).val)
-#endif /* CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
+#endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 /*
  * Ensure that there are not more swap files than can be encoded in the kernel
--- a/arch/arm64/Kconfig~b
+++ a/arch/arm64/Kconfig
@@ -17,7 +17,7 @@ config ARM64
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
-	select ARCH_SUPPORTS_PMD_SOFTLEAF if TRANSPARENT_HUGEPAGE
+	select ARCH_HAS_PMD_SOFTLEAVES if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_CC_PLATFORM
 	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
--- a/arch/loongarch/Kconfig~b
+++ a/arch/loongarch/Kconfig
@@ -12,7 +12,7 @@ config LOONGARCH
 	select ARCH_NEEDS_DEFER_KASAN
 	select ARCH_DISABLE_KASAN_INLINE
 	select ARCH_ENABLE_MEMORY_HOTPLUG
-	select ARCH_SUPPORTS_PMD_SOFTLEAF if TRANSPARENT_HUGEPAGE
+	select ARCH_HAS_PMD_SOFTLEAVES if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CPU_FINALIZE_INIT
 	select ARCH_HAS_CURRENT_STACK_POINTER
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~b
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1060,7 +1060,7 @@ static inline pte_t *pmdp_ptep(pmd_t *pm
 #define pmd_mksoft_dirty(pmd)  pte_pmd(pte_mksoft_dirty(pmd_pte(pmd)))
 #define pmd_clear_soft_dirty(pmd) pte_pmd(pte_clear_soft_dirty(pmd_pte(pmd)))
 
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 #define pmd_swp_mksoft_dirty(pmd)	pte_pmd(pte_swp_mksoft_dirty(pmd_pte(pmd)))
 #define pmd_swp_soft_dirty(pmd)		pte_swp_soft_dirty(pmd_pte(pmd))
 #define pmd_swp_clear_soft_dirty(pmd)	pte_pmd(pte_swp_clear_soft_dirty(pmd_pte(pmd)))
--- a/arch/powerpc/platforms/Kconfig.cputype~b
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -112,7 +112,7 @@ config PPC_THP
        depends on PPC_RADIX_MMU || (PPC_64S_HASH_MMU && PAGE_SIZE_64KB)
        select HAVE_ARCH_TRANSPARENT_HUGEPAGE
        select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-       select ARCH_SUPPORTS_PMD_SOFTLEAF if TRANSPARENT_HUGEPAGE
+       select ARCH_HAS_PMD_SOFTLEAVES if TRANSPARENT_HUGEPAGE
 
 choice
 	prompt "CPU selection"
--- a/arch/riscv/include/asm/pgtable.h~b
+++ a/arch/riscv/include/asm/pgtable.h
@@ -946,7 +946,7 @@ static inline pmd_t pmd_clear_soft_dirty
 	return pte_pmd(pte_clear_soft_dirty(pmd_pte(pmd)));
 }
 
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 static inline bool pmd_swp_soft_dirty(pmd_t pmd)
 {
 	return pte_swp_soft_dirty(pmd_pte(pmd));
@@ -961,7 +961,7 @@ static inline pmd_t pmd_swp_clear_soft_d
 {
 	return pte_pmd(pte_swp_clear_soft_dirty(pmd_pte(pmd)));
 }
-#endif /* CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
+#endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
@@ -1208,10 +1208,10 @@ static inline pte_t pte_swp_clear_exclus
 	return __pte(pte_val(pte) & ~_PAGE_SWP_EXCLUSIVE);
 }
 
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 #define __pmd_to_swp_entry(pmd) ((swp_entry_t) { pmd_val(pmd) })
 #define __swp_entry_to_pmd(swp) __pmd((swp).val)
-#endif /* CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
+#endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 /*
  * In the RV64 Linux scheme, we give the user half of the virtual-address space
--- a/arch/riscv/Kconfig~b
+++ a/arch/riscv/Kconfig
@@ -22,7 +22,7 @@ config RISCV
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM_VMEMMAP
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
-	select ARCH_SUPPORTS_PMD_SOFTLEAF if TRANSPARENT_HUGEPAGE
+	select ARCH_HAS_PMD_SOFTLEAVES if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_BINFMT_FLAT
 	select ARCH_HAS_CC_CAN_LINK
 	select ARCH_HAS_CURRENT_STACK_POINTER
--- a/arch/s390/include/asm/pgtable.h~b
+++ a/arch/s390/include/asm/pgtable.h
@@ -903,7 +903,7 @@ static inline pmd_t pmd_clear_soft_dirty
 	return clear_pmd_bit(pmd, __pgprot(_SEGMENT_ENTRY_SOFT_DIRTY));
 }
 
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 #define pmd_swp_soft_dirty(pmd)		pmd_soft_dirty(pmd)
 #define pmd_swp_mksoft_dirty(pmd)	pmd_mksoft_dirty(pmd)
 #define pmd_swp_clear_soft_dirty(pmd)	pmd_clear_soft_dirty(pmd)
--- a/arch/s390/Kconfig~b
+++ a/arch/s390/Kconfig
@@ -82,7 +82,7 @@ config S390
 	select ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
 	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
-	select ARCH_SUPPORTS_PMD_SOFTLEAF if TRANSPARENT_HUGEPAGE
+	select ARCH_HAS_PMD_SOFTLEAVES if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_CC_CAN_LINK
 	select ARCH_HAS_CPU_FINALIZE_INIT
 	select ARCH_HAS_CURRENT_STACK_POINTER
--- a/arch/x86/include/asm/pgtable.h~b
+++ a/arch/x86/include/asm/pgtable.h
@@ -1545,7 +1545,7 @@ static inline pte_t pte_swp_clear_soft_d
 	return pte_clear_flags(pte, _PAGE_SWP_SOFT_DIRTY);
 }
 
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
 {
 	return pmd_set_flags(pmd, _PAGE_SWP_SOFT_DIRTY);
--- a/arch/x86/Kconfig~b
+++ a/arch/x86/Kconfig
@@ -70,7 +70,7 @@ config X86
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if X86_64 && HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if (PGTABLE_LEVELS > 2) && (X86_64 || X86_PAE)
-	select ARCH_SUPPORTS_PMD_SOFTLEAF if X86_64 && TRANSPARENT_HUGEPAGE
+	select ARCH_HAS_PMD_SOFTLEAVES if X86_64 && TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CPU_ATTACK_VECTORS	if CPU_MITIGATIONS
 	select ARCH_HAS_CACHE_LINE_SIZE
--- a/include/linux/huge_mm.h~b
+++ a/include/linux/huge_mm.h
@@ -567,7 +567,7 @@ static inline struct folio *get_persiste
 
 static inline bool thp_migration_supported(void)
 {
-	return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF);
+	return IS_ENABLED(CONFIG_ARCH_HAS_PMD_SOFTLEAVES);
 }
 
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
--- a/include/linux/leafops.h~b
+++ a/include/linux/leafops.h
@@ -81,7 +81,7 @@ static inline pte_t softleaf_to_pte(soft
 	return swp_entry_to_pte(entry);
 }
 
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 /**
  * softleaf_from_pmd() - Obtain a leaf entry from a PMD entry.
  * @pmd: PMD entry.
@@ -587,7 +587,7 @@ static inline bool pte_is_uffd_marker(pt
 	return false;
 }
 
-#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF)
+#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_HAS_PMD_SOFTLEAVES)
 
 /**
  * pmd_is_device_private_entry() - Check if PMD contains a device private swap
@@ -606,14 +606,14 @@ static inline bool pmd_is_device_private
 	return softleaf_is_device_private(softleaf_from_pmd(pmd));
 }
 
-#else  /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
+#else  /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 static inline bool pmd_is_device_private_entry(pmd_t pmd)
 {
 	return false;
 }
 
-#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
+#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 /**
  * pmd_is_migration_entry() - Does this PMD entry encode a migration entry?
--- a/include/linux/pgtable.h~b
+++ a/include/linux/pgtable.h
@@ -1839,7 +1839,7 @@ static inline pgprot_t pgprot_modify(pgp
 #endif
 
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
-#ifndef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
+#ifndef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
 {
 	return pmd;
--- a/include/linux/swapops.h~b
+++ a/include/linux/swapops.h
@@ -321,7 +321,7 @@ static inline swp_entry_t make_guard_swp
 
 struct page_vma_mapped_walk;
 
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 extern int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page);
 
@@ -338,7 +338,7 @@ static inline pmd_t swp_entry_to_pmd(swp
 	return __swp_entry_to_pmd(arch_entry);
 }
 
-#else  /* CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
+#else  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page)
 {
@@ -358,7 +358,7 @@ static inline pmd_t swp_entry_to_pmd(swp
 	return __pmd(0);
 }
 
-#endif  /* CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
+#endif  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 #endif /* CONFIG_MMU */
 #endif /* _LINUX_SWAPOPS_H */
--- a/mm/debug_vm_pgtable.c~b
+++ a/mm/debug_vm_pgtable.c
@@ -751,7 +751,7 @@ static void __init pmd_leaf_soft_dirty_t
 	pmd_t pmd;
 
 	if (!pgtable_supports_soft_dirty() ||
-	    !IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF))
+	    !IS_ENABLED(CONFIG_ARCH_HAS_PMD_SOFTLEAVES))
 		return;
 
 	if (!has_transparent_hugepage())
@@ -819,7 +819,7 @@ static void __init pte_swap_tests(struct
 	WARN_ON(memcmp(&pte1, &pte2, sizeof(pte1)));
 }
 
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 static void __init pmd_softleaf_tests(struct pgtable_debug_args *args)
 {
 	swp_entry_t arch_entry;
@@ -837,9 +837,9 @@ static void __init pmd_softleaf_tests(st
 	pmd2 = __swp_entry_to_pmd(arch_entry);
 	WARN_ON(memcmp(&pmd1, &pmd2, sizeof(pmd1)));
 }
-#else  /* !CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
+#else  /* !CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 static void __init pmd_softleaf_tests(struct pgtable_debug_args *args) { }
-#endif /* CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
+#endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 static void __init swap_migration_tests(struct pgtable_debug_args *args)
 {
--- a/mm/hmm.c~b
+++ a/mm/hmm.c
@@ -331,7 +331,7 @@ fault:
 	return hmm_vma_fault(addr, end, required_fault, walk);
 }
 
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 				     unsigned long end, unsigned long *hmm_pfns,
 				     pmd_t pmd)
@@ -391,7 +391,7 @@ static int hmm_vma_handle_absent_pmd(str
 		return -EFAULT;
 	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
 }
-#endif  /* CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
+#endif  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 static int hmm_vma_walk_pmd(pmd_t *pmdp,
 			    unsigned long start,
--- a/mm/huge_memory.c~b
+++ a/mm/huge_memory.c
@@ -4868,7 +4868,7 @@ static int __init split_huge_pages_debug
 late_initcall(split_huge_pages_debugfs);
 #endif
 
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page)
 {
--- a/mm/internal.h~b
+++ a/mm/internal.h
@@ -1955,9 +1955,6 @@ static inline int get_sysctl_max_map_cou
 bool may_expand_vm(struct mm_struct *mm, const vma_flags_t *vma_flags,
 		   unsigned long npages);
 
-/*
- * Ensure @mm is on the init_mm.mmlist so swapoff can find it.
- */
 static inline void mm_prepare_for_swap_entries(struct mm_struct *mm)
 {
 	if (list_empty(&mm->mmlist)) {
--- a/mm/Kconfig~b
+++ a/mm/Kconfig
@@ -703,7 +703,7 @@ config DEVICE_MIGRATION
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
 
-config ARCH_SUPPORTS_PMD_SOFTLEAF
+config ARCH_HAS_PMD_SOFTLEAVES
 	bool
 
 config HUGETLB_PAGE_SIZE_VARIABLE
--- a/mm/migrate.c~b
+++ a/mm/migrate.c
@@ -362,7 +362,7 @@ static bool remove_migration_pte(struct
 			idx = linear_page_index(vma, pvmw.address) - pvmw.pgoff;
 		new = folio_page(folio, idx);
 
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 		/* PMD-mapped THP migration entry */
 		if (!pvmw.pte) {
 			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
@@ -545,7 +545,7 @@ fail:
 }
 #endif
 
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
 {
 	spinlock_t *ptl;
--- a/mm/migrate_device.c~b
+++ a/mm/migrate_device.c
@@ -771,7 +771,7 @@ int migrate_vma_setup(struct migrate_vma
 }
 EXPORT_SYMBOL(migrate_vma_setup);
 
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 /**
  * migrate_vma_insert_huge_pmd_page: Insert a huge folio into @migrate->vma->vm_mm
  * at @addr. folio is already allocated as a part of the migration process with
@@ -926,7 +926,7 @@ static int migrate_vma_split_unmapped_fo
 		migrate->src[i+idx] = migrate_pfn(pfn + i) | flags;
 	return ret;
 }
-#else /* !CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF */
+#else /* !CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 					 unsigned long addr,
 					 struct page *page,
@@ -947,7 +947,7 @@ static int migrate_vma_split_unmapped_fo
 static unsigned long migrate_vma_nr_pages(unsigned long *src)
 {
 	unsigned long nr = 1;
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 	if (*src & MIGRATE_PFN_COMPOUND)
 		nr = HPAGE_PMD_NR;
 #else
--- a/mm/rmap.c~b
+++ a/mm/rmap.c
@@ -2472,7 +2472,7 @@ static bool try_to_migrate_one(struct fo
 				page_vma_mapped_walk_restart(&pvmw);
 				continue;
 			}
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 			pmdval = pmdp_get(pvmw.pmd);
 			if (likely(pmd_present(pmdval)))
 				pfn = pmd_pfn(pmdval);
_


