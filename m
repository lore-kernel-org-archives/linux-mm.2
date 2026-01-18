Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 478C8CA5FE1
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 11:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E3296B0005; Sun, 18 Jan 2026 06:23:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590C36B0089; Sun, 18 Jan 2026 06:23:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43B906B008A; Sun, 18 Jan 2026 06:23:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 31D446B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 06:23:25 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 092261A051D
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 11:23:23 +0000 (UTC)
X-FDA: 84344848686.16.93D226A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2964A40005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 11:23:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=avS3rjBU;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768735401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C2XMEyXdsQAjcJy+Dlmhs6+GRs2sKX4MosHUlgBn97g=;
	b=dU1XUqLrY64zFYjBQIORNP8h5fClww03nuqRHAuXF3h0AFZ4lVQMHvnIKYJLbdxQvtVWeO
	zlyHljBZIl65j9GvlOEQn9QX7YFO66ugPz6+Ld222ZWKaBn0eHg/P6/ZEZ8oS4Fz/y6nkJ
	2UOZR4TBEIPzNFM1NUIuagatQ8ak7uM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=avS3rjBU;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768735401; a=rsa-sha256;
	cv=none;
	b=KdoabEPb2lcU8veiKx3MiELY3G3mwQxBjX3UpRZ6KI0EX3hy03zvPBfUl9eENIcMevBWrg
	pTVLtXk51HwfDq5MQGwZ9Z60y3eNTiMmTwMmA0XuAsCw6/yc+f9ZALo17KiyoEFdwIdDxZ
	ootUr1JFQ7LUuU2UF1kj+gaGjnbNBkw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 23EE840325;
	Sun, 18 Jan 2026 11:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AECC116D0;
	Sun, 18 Jan 2026 11:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768735400;
	bh=XwrVNWPWDuQvC/65hQWdhB1qgldDR5bI7RvZeEHpoQY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=avS3rjBU8Aipawbri0ncSa+9vjJkwVxSMRz41ZHT/zBOZhER0rSBif2vj2KnPz1/h
	 uFR8exs7zyHuThJVMr9qD7zS7IkoAFK05LXNH8SOBg2aIXF0CLSb/duvRlDM0Niqvr
	 eqrG/fAVRonBb6HFkDtcYvN9o7zUXEtt2sFsLits4UWq51Dc4yYCQISmf/ODlQ8en7
	 pDIp3iu7OOk32l9SqTnfQB/FSlfKqcVNdcRKq6j9yr6i0PFzyWxxmYP7jhwgtoWjR/
	 2d+fWizLzZ4n6uwZoEDkCGOOdMOImAqaasTQ8LEaXlQKtPUxMY7kd8gjqUYlrU1xt/
	 dBBy8fvPfjgdw==
Message-ID: <bef9fc2c-c982-4b46-b16a-8ecbc9584d62@kernel.org>
Date: Sun, 18 Jan 2026 12:23:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] mm: make PT_RECLAIM depends on
 MMU_GATHER_RCU_TABLE_FREE
To: Qi Zheng <qi.zheng@linux.dev>, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, peterz@infradead.org, dev.jain@arm.com,
 akpm@linux-foundation.org, ioworker0@gmail.com, linmag7@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
 <ac2bdb2a66da1edb24f60d1da1099e2a0b734880.1765963770.git.zhengqi.arch@bytedance.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <ac2bdb2a66da1edb24f60d1da1099e2a0b734880.1765963770.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ogrtpnxc3m3g6ohwxhtrrah5wsp74jdx
X-Rspam-User: 
X-Rspamd-Queue-Id: 2964A40005
X-Rspamd-Server: rspam08
X-HE-Tag: 1768735400-57415
X-HE-Meta: U2FsdGVkX19sZBqzjSU3vqGvdDUQaxIg8wJyVobsjAqSNY7b614aIDvGcows/XjcTSoKrcfPHzUpHdRdo4cAiOx+v6qdNIglVDCplifN8zs4DpGTQffsykHN3ihIw96M103WsM5J+7jbPVSZv0kGtdYek4Bw77OYlPy6c/euirp10xHUR1y56sgTWIGkSMYJT83w4QCbLlOq/jRP45cm+IJ8KzXR7QBLVaPaD6CwqBf5Kvm6HMOegRb11UP1g2Oh4AX7/nsfcS5aOkNK4zq4XT79zIjb/1yy2YfGxu8ahPadGbPMcSlgWuxmkfdNc0Uut/BEeAOyoWxd0z/rCkV/DL7AhFpK66+tjfrAzTNKpiV8Wkjyp7KS/UuyDvNGgnZ+TbjmYF0dtJl5boCRN8HxhwozFERKnIFPQ+I/cQN1G5N4ad4DI1ysJzIq8mJepu1U6EHPSae/LdkonsJydyVz5XtwbxIBp4x1PGs4CyJ/glgwvYD1G2Rn6CzwEauINxjoLuuK5HFltkWr2id5lbTZkzgXMzY4oVbVcRdREiTOfi0kYt0kALcXR77hsTRsUEoGyAWhIM0JmziLPsb/TRQoKw9eh8gIrYdpucq/qAdBQHOzAarxGe7psQEBchx9/rbzVooUQi3iwK+MC6XZ0Dljd8TRs1g3XnoSLTqn4eTOeS3rGC0bcUB4VKHOXxlf2kgeu3OFQwbjMYGH19+oozBgzHdjZPieGu+ds1Fi1QPEqa0JIqNFBRD+Ww3sACAfeap+XV8vzjNm7G6L40QM2GNHHsq+epwkXow4steTNLMP7Vz+A8EHht5ESP/CUUL1AjM1IitF+O/NYLAFa1YL4JEk2A+DOQ8XrhN9M8b0T43h875+9oGeAyzecZrtzJD6/fL4IfRrGPxnhEYy29/judCAP0oWPpKWAuO1z0P86FW4b0eYI2PJEHJ27U+9EXLldBdCrxLCRUU5yiRE08d4Oz3
 +8bW/21q
 nh4a0hrnUhZHRPuTK+qYwE3/zV9FNcUqZREx5pkGFpQAyiKBFSOjt4B/f45HrVt4KPZvrtna/mkJH4eF7eGdxmfeao99c2Ksm9T7aWuCWxSiaShhpuztrivrwZhBrrAcIfLlSrau7xHramG60OtPMg8S4clHHPqh9fvgh7kBD1D3p4v7B+Pmy9YS8XLkyEDntSZsYlz+uvcyH27iH5Q6ICbf0fFa3tsTTUxDfe0xDXNtd48WMedihcvQAWYBtdhMyBKMTFgR/zTDEOJ5GxVPE9u9MDcukz/7KgbsQgmgHRqoxEh5UpDAQ6ZiWundygfWo8atRyfJa0p7ZfPEI4vERaHG8EnN1FBNC31R8ZfpzLNEFoJBTJvv42VNnsWwxfztvL8LsV/L0bR7x+bk4Wlk8CU25qbjQfMogUTlrq+Rn/ig2h1sW+2iNvuFtYDhinpNij6+WQZZeIPmVEH8yfMKqm2lB0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/17/25 10:45, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The PT_RECLAIM can work on all architectures that support
> MMU_GATHER_RCU_TABLE_FREE, so make PT_RECLAIM depends on
> MMU_GATHER_RCU_TABLE_FREE.
> 
> BTW, change PT_RECLAIM to be enabled by default, since nobody should want
> to turn it off.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>   arch/x86/Kconfig | 1 -
>   mm/Kconfig       | 9 ++-------
>   2 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 80527299f859a..0d22da56a71b0 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -331,7 +331,6 @@ config X86
>   	select FUNCTION_ALIGNMENT_4B
>   	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>   	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
> -	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
>   	select ARCH_SUPPORTS_SCHED_SMT		if SMP
>   	select SCHED_SMT			if SMP
>   	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
> diff --git a/mm/Kconfig b/mm/Kconfig
> index bd0ea5454af82..fc00b429b7129 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1447,14 +1447,9 @@ config ARCH_HAS_USER_SHADOW_STACK
>   	  The architecture has hardware support for userspace shadow call
>             stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>   
> -config ARCH_SUPPORTS_PT_RECLAIM
> -	def_bool n
> -
>   config PT_RECLAIM
> -	bool "reclaim empty user page table pages"
> -	default y
> -	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
> -	select MMU_GATHER_RCU_TABLE_FREE
> +	def_bool y
> +	depends on MMU_GATHER_RCU_TABLE_FREE
>   	help
>   	  Try to reclaim empty user page table pages in paths other than munmap
>   	  and exit_mmap path.

This patch seems to make s390x compilations sometimes unhappy:

Unverified Warning (likely false positive, kindly check if interested):

     mm/memory.c:1911 zap_pte_range() error: uninitialized symbol 'pmdval'.

Warning ids grouped by kconfigs:

recent_errors
`-- s390-randconfig-r072-20260117
     `-- mm-memory.c-zap_pte_range()-error:uninitialized-symbol-pmdval-.

I assume the compiler is not able to figure out that only when
try_get_and_clear_pmd() returns false that pmdval could be uninitialized.

Maybe it has to do with LTO?


After all, that function resides in a different compilation unit.

Which makes me wonder whether we want to just move try_get_and_clear_pmd()
and reclaim_pt_is_enabled() to internal.h or even just memory.c?

But then, maybe we could remove pt_reclaim.c completely and just have
try_to_free_pte() in memory.c as well?


I would just do the following cleanup:

 From cfe97092f71fcc88f729f07ee0bc6816e3e398f0 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Date: Sun, 18 Jan 2026 12:20:55 +0100
Subject: [PATCH] mm: move pte table reclaim code to memory.c

Let's move the code and clean it up a bit along the way.

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
  MAINTAINERS     |  1 -
  mm/internal.h   | 18 -------------
  mm/memory.c     | 70 ++++++++++++++++++++++++++++++++++++++++++-----
  mm/pt_reclaim.c | 72 -------------------------------------------------
  4 files changed, 64 insertions(+), 97 deletions(-)
  delete mode 100644 mm/pt_reclaim.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 11720728d92f2..28e8e28bca3e5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16692,7 +16692,6 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
  R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
  L:	linux-mm@kvack.org
  S:	Maintained
-F:	mm/pt_reclaim.c
  F:	mm/vmscan.c
  F:	mm/workingset.c
  
diff --git a/mm/internal.h b/mm/internal.h
index 9508dbaf47cd4..ef71a1d9991f2 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1745,24 +1745,6 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
  			  unsigned long end, const struct mm_walk_ops *ops,
  			  pgd_t *pgd, void *private);
  
-/* pt_reclaim.c */
-bool try_get_and_clear_pmd(struct mm_struct *mm, pmd_t *pmd, pmd_t *pmdval);
-void free_pte(struct mm_struct *mm, unsigned long addr, struct mmu_gather *tlb,
-	      pmd_t pmdval);
-void try_to_free_pte(struct mm_struct *mm, pmd_t *pmd, unsigned long addr,
-		     struct mmu_gather *tlb);
-
-#ifdef CONFIG_PT_RECLAIM
-bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
-			   struct zap_details *details);
-#else
-static inline bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
-					 struct zap_details *details)
-{
-	return false;
-}
-#endif /* CONFIG_PT_RECLAIM */
-
  void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm);
  int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
  
diff --git a/mm/memory.c b/mm/memory.c
index f2e9e05388743..a09226761a07f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1824,11 +1824,68 @@ static inline int do_zap_pte_range(struct mmu_gather *tlb,
  	return nr;
  }
  
+static bool pte_table_reclaim_enabled(unsigned long start, unsigned long end,
+		struct zap_details *details)
+{
+	if (!IS_ENABLED(CONFIG_PT_RECLAIM))
+		return false;
+	return details && details->reclaim_pt && (end - start >= PMD_SIZE);
+}
+
+static bool zap_empty_pte_table(struct mm_struct *mm, pmd_t *pmd, pmd_t *pmdval)
+{
+	spinlock_t *pml = pmd_lockptr(mm, pmd);
+
+	if (!spin_trylock(pml))
+		return false;
+
+	*pmdval = pmdp_get_lockless(pmd);
+	pmd_clear(pmd);
+	spin_unlock(pml);
+
+	return true;
+}
+
+static bool zap_pte_table_if_empty(struct mm_struct *mm, pmd_t *pmd,
+		unsigned long addr, pmd_t *pmdval)
+{
+	spinlock_t *pml, *ptl = NULL;
+	pte_t *start_pte, *pte;
+	int i;
+
+	pml = pmd_lock(mm, pmd);
+	start_pte = pte_offset_map_rw_nolock(mm, pmd, addr, pmdval, &ptl);
+	if (!start_pte)
+		goto out_ptl;
+	if (ptl != pml)
+		spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
+
+	for (i = 0, pte = start_pte; i < PTRS_PER_PTE; i++, pte++) {
+		if (!pte_none(ptep_get(pte)))
+			goto out_ptl;
+	}
+	pte_unmap(start_pte);
+
+	pmd_clear(pmd);
+
+	if (ptl != pml)
+		spin_unlock(ptl);
+	spin_unlock(pml);
+	return true;
+out_ptl:
+	if (start_pte)
+		pte_unmap_unlock(start_pte, ptl);
+	if (ptl != pml)
+		spin_unlock(pml);
+	return false;
+}
+
  static unsigned long zap_pte_range(struct mmu_gather *tlb,
  				struct vm_area_struct *vma, pmd_t *pmd,
  				unsigned long addr, unsigned long end,
  				struct zap_details *details)
  {
+	bool can_reclaim_pt = pte_table_reclaim_enabled(addr, end, details);
  	bool force_flush = false, force_break = false;
  	struct mm_struct *mm = tlb->mm;
  	int rss[NR_MM_COUNTERS];
@@ -1837,7 +1894,6 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
  	pte_t *pte;
  	pmd_t pmdval;
  	unsigned long start = addr;
-	bool can_reclaim_pt = reclaim_pt_is_enabled(start, end, details);
  	bool direct_reclaim = true;
  	int nr;
  
@@ -1878,7 +1934,7 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
  	 * from being repopulated by another thread.
  	 */
  	if (can_reclaim_pt && direct_reclaim && addr == end)
-		direct_reclaim = try_get_and_clear_pmd(mm, pmd, &pmdval);
+		direct_reclaim = zap_empty_pte_table(mm, pmd, &pmdval);
  
  	add_mm_rss_vec(mm, rss);
  	lazy_mmu_mode_disable();
@@ -1907,10 +1963,12 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
  	}
  
  	if (can_reclaim_pt) {
-		if (direct_reclaim)
-			free_pte(mm, start, tlb, pmdval);
-		else
-			try_to_free_pte(mm, pmd, start, tlb);
+		if (!direct_reclaim)
+			direct_reclaim = zap_pte_table_if_empty(mm, pmd, start, &pmdval);
+		if (direct_reclaim) {
+			pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
+			mm_dec_nr_ptes(mm);
+		}
  	}
  
  	return addr;
diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
deleted file mode 100644
index 46771cfff8239..0000000000000
--- a/mm/pt_reclaim.c
+++ /dev/null
@@ -1,72 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <linux/hugetlb.h>
-#include <linux/pgalloc.h>
-
-#include <asm/tlb.h>
-
-#include "internal.h"
-
-bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
-			   struct zap_details *details)
-{
-	return details && details->reclaim_pt && (end - start >= PMD_SIZE);
-}
-
-bool try_get_and_clear_pmd(struct mm_struct *mm, pmd_t *pmd, pmd_t *pmdval)
-{
-	spinlock_t *pml = pmd_lockptr(mm, pmd);
-
-	if (!spin_trylock(pml))
-		return false;
-
-	*pmdval = pmdp_get_lockless(pmd);
-	pmd_clear(pmd);
-	spin_unlock(pml);
-
-	return true;
-}
-
-void free_pte(struct mm_struct *mm, unsigned long addr, struct mmu_gather *tlb,
-	      pmd_t pmdval)
-{
-	pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
-	mm_dec_nr_ptes(mm);
-}
-
-void try_to_free_pte(struct mm_struct *mm, pmd_t *pmd, unsigned long addr,
-		     struct mmu_gather *tlb)
-{
-	pmd_t pmdval;
-	spinlock_t *pml, *ptl = NULL;
-	pte_t *start_pte, *pte;
-	int i;
-
-	pml = pmd_lock(mm, pmd);
-	start_pte = pte_offset_map_rw_nolock(mm, pmd, addr, &pmdval, &ptl);
-	if (!start_pte)
-		goto out_ptl;
-	if (ptl != pml)
-		spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
-
-	/* Check if it is empty PTE page */
-	for (i = 0, pte = start_pte; i < PTRS_PER_PTE; i++, pte++) {
-		if (!pte_none(ptep_get(pte)))
-			goto out_ptl;
-	}
-	pte_unmap(start_pte);
-
-	pmd_clear(pmd);
-
-	if (ptl != pml)
-		spin_unlock(ptl);
-	spin_unlock(pml);
-
-	free_pte(mm, addr, tlb, pmdval);
-
-	return;
-out_ptl:
-	if (start_pte)
-		pte_unmap_unlock(start_pte, ptl);
-	if (ptl != pml)
-		spin_unlock(pml);
-}
-- 
2.52.0


Completely untested, of course.

-- 
Cheers

David

