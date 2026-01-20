Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B241ED2ED11
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 03:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2286B0354; Mon, 19 Jan 2026 22:31:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870176B0356; Mon, 19 Jan 2026 22:31:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A6456B0357; Mon, 19 Jan 2026 22:31:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 69F596B0354
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 22:31:33 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2ED01603CA
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 03:31:32 +0000 (UTC)
X-FDA: 84350917224.29.FDC34E1
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf24.hostedemail.com (Postfix) with ESMTP id B8455180006
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 03:31:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ioEScEfl;
	spf=pass (imf24.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768879891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CI6UmdMcFqf8rwwZqOoFO1hODPoe7JMWY4/2PUOhoFY=;
	b=MK0+bBSTY31TeIgnj+pArseciE89dvnh7EUbgr9Hjf05TyvheUJ3TypBraRNFXuobG+5ro
	ivx4o7m5l2aXVJ2l6G2TL4uRMm1q+nTjj/tb51K3HkiV1ZuRoGt3QMOq09gThpSKWDuCEY
	1Rs/byH/bLYS/63Ls8xgBlNALMQwD9o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ioEScEfl;
	spf=pass (imf24.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768879891; a=rsa-sha256;
	cv=none;
	b=lzq79ld3mG60g9icCOdjjnFw48taGZTMxJf1KzHoSWr0FjAi++b1CB7pNAJ/1tkH4Egx6R
	1dYlBbi3phs/pz49u7CyrG2lTTQ4lHiOSdtESPo7dmhsYQe8oS9HMOcwztctUrm4U8U9UP
	KorMqNlqQFVQn5iao/3jhO43k0GCp4U=
Message-ID: <0f40850a-13fd-44ae-805a-f2ffb30a44e5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768879888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CI6UmdMcFqf8rwwZqOoFO1hODPoe7JMWY4/2PUOhoFY=;
	b=ioEScEflwZetn59zpPCTSrSg6Mim7LbaQZcmfOb9JSIu+Jib0u6vwo/9wbA72RAZJ7RvMO
	QsQ0PYDRJWK5i8o8rA9GFL1dvKR4z3r6Xzu2oChSM9n51xdLseL4RulZAkzCHgf94B9JP0
	cXSvLvypB6OgwApaSx8SktHX+ye835c=
Date: Tue, 20 Jan 2026 11:30:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 1/2] mm: move pte table reclaim code to memory.c
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260119220708.3438514-1-david@kernel.org>
 <20260119220708.3438514-2-david@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260119220708.3438514-2-david@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B8455180006
X-Stat-Signature: d9c6hpnmu196tqk3c53mcmpu7yonbaot
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768879890-658383
X-HE-Meta: U2FsdGVkX1+G07bGHwdJbQumsrC0aXsz+O8zYqe/z5LAMApkQX3drngFghQbsvxq1EU/fl85beMfM4cZzvSNr0MDF4baMtGm2hm+lGLYJqho/In6rTXK0zFcCZScuOgXLZU4VBfxjxnbHp3qKEI2peg9CnMM6MAl/luz6cZle7SeMex8aY2u2EX3Wgh5ApgnBHKZCm4EbRnzp/l9omELd9SDfLCUJOuNUSYNrWiirsaDIkQ4THLwP5y+6VX9sP/Rkkxc+SOL0SKMiqwq4BLuAfrKSxNaMSR3F1aQ1UMvldvWnGq7lmfHFzspETYxsZwd2tGxyHZdHEpqqCxC2ulcLxLjZpJV6IeqTnsBYVT0KKK6muKRinAwe3EbID7fArD8EFstazWp3YPJhI/YTC70OkD2hGQYk1F35z9mufJM4Gi991yvqeIUoosEBjz8sLXMROPJAu+bKHYUbllgkA42qUcvMPBY7wFV9pGT79uY9Q2W8IhnDtNU9sHntzBlYbYY5pcV46I+A69Ko0mnJmd9FqRfse443R1e0fWhcUe2r1IgA7dIoGTKhtjD3ZH79H5JfOkHjj5/AuWfPf0aW6S//GV8XMTc+rUet/OhN1R3ogHJ6aJpRTOlt+44TdTfqXnU5aUM2taWfGFpbCWFpBeBC8o4PRywzEhrslJ39M7eIxFuESerkBtKvEnRi3Vmdy8vAyDMUuCbs/U0Kv/IJB/6nbc77IKMstqFP0cKQbuCjO8bzVjF27e/M5UDK7csdPEnZfBdtPTUq93qzEP9w2wqGKnjkMyMOUG/HVD0hWG0jwFLkEoBKAVPQpp2/LbHEdC3rIfSuVgP1qBAzTRnouNBsQlbMaAVCELfgRIe3IySn0rPNCEdn6Kik9+ODc8aD2ZKSaFKcIDV9JTGvVzbrkigT1dSk2UorLf1GRrDf4kZ2YlOrQo0EmDIPkFCbVNrSDuf/YuH9ox+lH1t10yILCG
 nbXJnujK
 ERhEqgzzbg/pOtkqEngBF1exrcT+CLFenp3cEpJlD06FAaEBNZr6mbEZD7doy4DPemdEgUnbvkk9RKcx4V5UCcAp+SzcYZCVKNc+TyD+Hh6GpSF28ai5pQY6NePPYYB/2Bum9z+IaRa5qL9FVBB1SBHUqnNwTsViVqGL9LpmgHBUXGn73PudXinGwSscmzooEaAkq1KnrkvbQqQU3yeeywnoG+71MP0+fhnA31+ovI5401OeRLTTmFkHoWIH4ddAIvJUxpHX57Jjo7g3CA6gt2cw551Brz9cj1pkTBJYtamNf46/TuugOEyL7hxactNV7GVcbQ1NSkpGf3xPrlz51XM1o4UXCevHo4rJ2gOB6/7FQ/53gP8BBbs3fKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/20/26 6:07 AM, David Hildenbrand (Red Hat) wrote:
> The pte-table reclaim code is only called from memory.c, while zapping
> pages, and it better also stays that way in the long run. If we ever
> have to call it from other files, we should expose proper high-level
> helpers for zapping if the existing helpers are not good enough.
> 
> So, let's move the code over (it's not a lot) and slightly clean it up a
> bit by:
> - Renaming the functions.
> - Dropping the "Check if it is empty PTE page" comment, which is now
>    self-explaining given the function name.
> - Making zap_pte_table_if_empty() return whether zapping worked so the
>    caller can free it.
> - Adding a comment in pte_table_reclaim_possible().
> - Inlining free_pte() in the last remaining user.
> - In zap_empty_pte_table(), switch from pmdp_get_lcokless() to
>    pmd_clear(), we are holding the PMD PT lock.
> 
> By moving the code over, compilers can also easily figure out when
> zap_empty_pte_table() does not initialize the pmdval variable, avoiding
> false-positive warnings about the variable possibly not being
> initialized.
> 
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---
>   MAINTAINERS     |  1 -
>   mm/Makefile     |  1 -
>   mm/internal.h   | 18 -------------
>   mm/memory.c     | 68 +++++++++++++++++++++++++++++++++++++++++-----
>   mm/pt_reclaim.c | 72 -------------------------------------------------
>   5 files changed, 62 insertions(+), 98 deletions(-)
>   delete mode 100644 mm/pt_reclaim.c

Reviewed-by: Qi Zheng <zhengqi.arch@bytedance.com>

Thanks!

> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 11720728d92f2..28e8e28bca3e5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16692,7 +16692,6 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
>   R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>   L:	linux-mm@kvack.org
>   S:	Maintained
> -F:	mm/pt_reclaim.c
>   F:	mm/vmscan.c
>   F:	mm/workingset.c
>   
> diff --git a/mm/Makefile b/mm/Makefile
> index 0d85b10dbdde4..53ca5d4b1929b 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -146,5 +146,4 @@ obj-$(CONFIG_GENERIC_IOREMAP) += ioremap.o
>   obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
>   obj-$(CONFIG_EXECMEM) += execmem.o
>   obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
> -obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
>   obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
> diff --git a/mm/internal.h b/mm/internal.h
> index 9508dbaf47cd4..ef71a1d9991f2 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1745,24 +1745,6 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
>   			  unsigned long end, const struct mm_walk_ops *ops,
>   			  pgd_t *pgd, void *private);
>   
> -/* pt_reclaim.c */
> -bool try_get_and_clear_pmd(struct mm_struct *mm, pmd_t *pmd, pmd_t *pmdval);
> -void free_pte(struct mm_struct *mm, unsigned long addr, struct mmu_gather *tlb,
> -	      pmd_t pmdval);
> -void try_to_free_pte(struct mm_struct *mm, pmd_t *pmd, unsigned long addr,
> -		     struct mmu_gather *tlb);
> -
> -#ifdef CONFIG_PT_RECLAIM
> -bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
> -			   struct zap_details *details);
> -#else
> -static inline bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
> -					 struct zap_details *details)
> -{
> -	return false;
> -}
> -#endif /* CONFIG_PT_RECLAIM */
> -
>   void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm);
>   int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
>   
> diff --git a/mm/memory.c b/mm/memory.c
> index f2e9e05388743..c3055b2577c27 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1824,11 +1824,68 @@ static inline int do_zap_pte_range(struct mmu_gather *tlb,
>   	return nr;
>   }
>   
> +static bool pte_table_reclaim_possible(unsigned long start, unsigned long end,
> +		struct zap_details *details)
> +{
> +	if (!IS_ENABLED(CONFIG_PT_RECLAIM))
> +		return false;
> +	/* Only zap if we are allowed to and cover the full page table. */
> +	return details && details->reclaim_pt && (end - start >= PMD_SIZE);
> +}
> +
> +static bool zap_empty_pte_table(struct mm_struct *mm, pmd_t *pmd, pmd_t *pmdval)
> +{
> +	spinlock_t *pml = pmd_lockptr(mm, pmd);
> +
> +	if (!spin_trylock(pml))
> +		return false;
> +
> +	*pmdval = pmdp_get(pmd);
> +	pmd_clear(pmd);
> +	spin_unlock(pml);
> +	return true;
> +}
> +
> +static bool zap_pte_table_if_empty(struct mm_struct *mm, pmd_t *pmd,
> +		unsigned long addr, pmd_t *pmdval)
> +{
> +	spinlock_t *pml, *ptl = NULL;
> +	pte_t *start_pte, *pte;
> +	int i;
> +
> +	pml = pmd_lock(mm, pmd);
> +	start_pte = pte_offset_map_rw_nolock(mm, pmd, addr, pmdval, &ptl);
> +	if (!start_pte)
> +		goto out_ptl;
> +	if (ptl != pml)
> +		spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
> +
> +	for (i = 0, pte = start_pte; i < PTRS_PER_PTE; i++, pte++) {
> +		if (!pte_none(ptep_get(pte)))
> +			goto out_ptl;
> +	}
> +	pte_unmap(start_pte);
> +
> +	pmd_clear(pmd);
> +
> +	if (ptl != pml)
> +		spin_unlock(ptl);
> +	spin_unlock(pml);
> +	return true;
> +out_ptl:
> +	if (start_pte)
> +		pte_unmap_unlock(start_pte, ptl);
> +	if (ptl != pml)
> +		spin_unlock(pml);
> +	return false;
> +}
> +
>   static unsigned long zap_pte_range(struct mmu_gather *tlb,
>   				struct vm_area_struct *vma, pmd_t *pmd,
>   				unsigned long addr, unsigned long end,
>   				struct zap_details *details)
>   {
> +	bool can_reclaim_pt = pte_table_reclaim_possible(addr, end, details);
>   	bool force_flush = false, force_break = false;
>   	struct mm_struct *mm = tlb->mm;
>   	int rss[NR_MM_COUNTERS];
> @@ -1837,7 +1894,6 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>   	pte_t *pte;
>   	pmd_t pmdval;
>   	unsigned long start = addr;
> -	bool can_reclaim_pt = reclaim_pt_is_enabled(start, end, details);
>   	bool direct_reclaim = true;
>   	int nr;
>   
> @@ -1878,7 +1934,7 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>   	 * from being repopulated by another thread.
>   	 */
>   	if (can_reclaim_pt && direct_reclaim && addr == end)
> -		direct_reclaim = try_get_and_clear_pmd(mm, pmd, &pmdval);
> +		direct_reclaim = zap_empty_pte_table(mm, pmd, &pmdval);
>   
>   	add_mm_rss_vec(mm, rss);
>   	lazy_mmu_mode_disable();
> @@ -1907,10 +1963,10 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>   	}
>   
>   	if (can_reclaim_pt) {
> -		if (direct_reclaim)
> -			free_pte(mm, start, tlb, pmdval);
> -		else
> -			try_to_free_pte(mm, pmd, start, tlb);
> +		if (direct_reclaim || zap_pte_table_if_empty(mm, pmd, start, &pmdval)) {
> +			pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
> +			mm_dec_nr_ptes(mm);
> +		}
>   	}
>   
>   	return addr;
> diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
> deleted file mode 100644
> index 46771cfff8239..0000000000000
> --- a/mm/pt_reclaim.c
> +++ /dev/null
> @@ -1,72 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -#include <linux/hugetlb.h>
> -#include <linux/pgalloc.h>
> -
> -#include <asm/tlb.h>
> -
> -#include "internal.h"
> -
> -bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
> -			   struct zap_details *details)
> -{
> -	return details && details->reclaim_pt && (end - start >= PMD_SIZE);
> -}
> -
> -bool try_get_and_clear_pmd(struct mm_struct *mm, pmd_t *pmd, pmd_t *pmdval)
> -{
> -	spinlock_t *pml = pmd_lockptr(mm, pmd);
> -
> -	if (!spin_trylock(pml))
> -		return false;
> -
> -	*pmdval = pmdp_get_lockless(pmd);
> -	pmd_clear(pmd);
> -	spin_unlock(pml);
> -
> -	return true;
> -}
> -
> -void free_pte(struct mm_struct *mm, unsigned long addr, struct mmu_gather *tlb,
> -	      pmd_t pmdval)
> -{
> -	pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
> -	mm_dec_nr_ptes(mm);
> -}
> -
> -void try_to_free_pte(struct mm_struct *mm, pmd_t *pmd, unsigned long addr,
> -		     struct mmu_gather *tlb)
> -{
> -	pmd_t pmdval;
> -	spinlock_t *pml, *ptl = NULL;
> -	pte_t *start_pte, *pte;
> -	int i;
> -
> -	pml = pmd_lock(mm, pmd);
> -	start_pte = pte_offset_map_rw_nolock(mm, pmd, addr, &pmdval, &ptl);
> -	if (!start_pte)
> -		goto out_ptl;
> -	if (ptl != pml)
> -		spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
> -
> -	/* Check if it is empty PTE page */
> -	for (i = 0, pte = start_pte; i < PTRS_PER_PTE; i++, pte++) {
> -		if (!pte_none(ptep_get(pte)))
> -			goto out_ptl;
> -	}
> -	pte_unmap(start_pte);
> -
> -	pmd_clear(pmd);
> -
> -	if (ptl != pml)
> -		spin_unlock(ptl);
> -	spin_unlock(pml);
> -
> -	free_pte(mm, addr, tlb, pmdval);
> -
> -	return;
> -out_ptl:
> -	if (start_pte)
> -		pte_unmap_unlock(start_pte, ptl);
> -	if (ptl != pml)
> -		spin_unlock(pml);
> -}


