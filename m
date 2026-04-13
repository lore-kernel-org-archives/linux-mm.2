Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CCE4F34C58
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 14:18:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B93586B008A; Mon, 13 Apr 2026 10:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6A3E6B0092; Mon, 13 Apr 2026 10:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80AF6B0093; Mon, 13 Apr 2026 10:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 97A956B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:18:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B9F6B6E48
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:18:16 +0000 (UTC)
X-FDA: 84653737392.01.5C2D030
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8BDAB180012
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:18:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tBefiOTT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776089894; a=rsa-sha256;
	cv=none;
	b=DivzzAoIsNInOk85SaeiXE9n8Za/CGlyfyG7V0VsO8TxCFaCrUCLeoMrClbiQStJiPYOkx
	R7tyEuD1VabAPMFCOV2RyO35iAlwRmXRPvwt5tB9ZJm0zWckl4fo/acuj+611jUCFoi9y8
	Ynhl1F7IGGMrlgADi54l6yCfQM5yzOc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tBefiOTT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776089894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4RHoOIK8SOpVG3qc2g0HEm4zchC2wPLOtDTDq0SD58=;
	b=DNhz6p85fLLimsyjBp6sPnYVfm7yd+dC9s/vuhfocKInZApu+pi4e3da8YfjOPY6SdxJtI
	6hs90OFT4oVkCUSOY9RtNmi2sGoKzIE7hADBG3w2ioyQtSBqkqK3Lk4QDIE43i3b7ehTpn
	MYTlWsyiEoh/RqgpAHNrhMhFKThU+V0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776089891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+4RHoOIK8SOpVG3qc2g0HEm4zchC2wPLOtDTDq0SD58=;
	b=tBefiOTTqKVckKWV32Hn10mlesb4C1xi2yD8GhkGlJNwelt/mkppBph5yEkSk8L3MdftyM
	AVn3mezaoy4y1vLBSIPeC06lBt/4HAGtcdTHzp4qlJ20+6ZO+yxEP2iNVZUm1OfshDkYE9
	fJ2UmxP1EoCJpBR6QaAEJRW11PDNF0c=
From: Usama Arif <usama.arif@linux.dev>
To: Oscar Salvador <osalvador@suse.de>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 5/7] mm: Make /proc/pid/smaps use the new generic pagewalk API
Date: Mon, 13 Apr 2026 07:18:00 -0700
Message-ID: <20260413141801.1465873-1-usama.arif@linux.dev>
In-Reply-To: <20260412174244.133715-6-osalvador@suse.de>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: eno6xbhkke31am5i77uf4z3fdbcnp1ax
X-Rspamd-Queue-Id: 8BDAB180012
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776089894-101821
X-HE-Meta: U2FsdGVkX1/pJgsBUi9y/2+Jd9TyBeLDUXzV68Ld2EU69GNtG0rwHWo8rXJMNG1yJLoUwGy0ivLEKDmoqDAuT1gLH9pgpZ3oFfPB+AeWz+n9FzC7eiMicgbo9rhhQ3Ofl2E4HgeK39ci63mejC6IZ+5UJHDiXEYxXhme8p+7Df3zkeZ/b7iz7DZFtvN0yARtJW6zQuouLR5T3QaMQ1qdUk9WGMHxDqpyiPnllVP4I8J9cFqIkiUspAQLHyXNGj2NEzNBE0ZA9hRfX7Tgth6KJLD5Gs/5PDWq6xVjGPwxudsstmEIJaWG3lj+UwnGJ9sjLP7xtv63XwVJcExyjeiDU12QmSriZ19izBbeItsrtp7tq71xYDHKctG6vhZ3pkYvhJI9UMtyHu7oMzIM14slEtIpsGfUecJxYKbHgKJ67r8TrdWtnkN7LTuSqWPb+6x6FFAW6x888HZocUngjNANtHufUtltntWxIir1YgV/kh9gr8gJqqoJuMcjAmcHkftDO8X93P8uosa5inncdF9dz1KAxlvh3r6BSGXTLwvggh3du8WJp/YRy845K6mQJQsW9GDYncxqkzdYnrT53vfhJv6VvfQK62oOSEPOXx19fTx/ZNEqZFlbpbXXmIMs3tOWwCY+J4MK1DWKQAs8OKwhvsL0IYHAnSnkZ4WQ05kavUzQ51vGiGbLBPAwINeeeadDJoQDQGbzkfByoIg6NDbH8/tfHWL3e2oyQQSIoMZA/SIFy+YqL0ZgLiiGwf+XzNYM4V2WB7toAyEk1Y8q+aU+jJ/eCcr6PNxGg4jZmDMgsXM+Q4tucHjPDeIdpd6BDEh/D3dAXXr2c+yetxp43G6pJlP0YLPD/eFsJbc20HP2A2udEZiUjfEzjQfFL7bUtyBuB2Q/0imbEUbBxAGZUQ18XH9gpigik3b1qz6iOjHzdFeALs024aVcC2E+2cK4hKX9GtYlKhVc3exK583yDNe
 DNwm9cDD
 pJI0/AmHiyCNBTMLrY4NTYDNnAEpP3LjeboFBEryx61IGdUgDjCSzCffMorDNh79oasWEIVs7YKbu3I1SMt1gtpBHltrg0G0urqXmcqiS1TjIc+CK3qp7dmAb5/ohnj77jwMLCEVDzD+NJVbBftNN39jzYrrGEjhTcI7/Pc+guXSgc9uWkTKURbnLNryhRRg1aHZ9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 12 Apr 2026 19:42:42 +0200 Oscar Salvador <osalvador@suse.de> wrote:

> Have /proc/pid/smaps make use of the new generic API, and remove
> the code which was using the old one.
> 
> Signed-off-by: Oscar Salvador <osalvador@suse.de>
> ---
>  fs/proc/task_mmu.c | 309 ++++++++++++---------------------------------
>  1 file changed, 84 insertions(+), 225 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e091931d7ca1..afbcdb11ad80 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -915,7 +915,7 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
>  
>  static void smaps_account(struct mem_size_stats *mss, struct page *page,
>  		bool compound, bool young, bool dirty, bool locked,
> -		bool present)
> +		bool present, int ssize)
>  {
>  	struct folio *folio = page_folio(page);
>  	int i, nr = compound ? compound_nr(page) : 1;
> @@ -923,6 +923,11 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
>  	bool exclusive;
>  	int mapcount;
>  
> +	if (ssize) {
> +		nr = ssize / PAGE_SIZE;
> +		size = ssize;
> +	}
> +
>  	/*
>  	 * First accumulate quantities that depend only on |size| and the type
>  	 * of the compound page.
> @@ -988,150 +993,6 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
>  	}
>  }
>  
> -#ifdef CONFIG_SHMEM
> -static int smaps_pte_hole(unsigned long addr, unsigned long end,
> -			  __always_unused int depth, struct mm_walk *walk)
> -{
> -	struct mem_size_stats *mss = walk->private;
> -	struct vm_area_struct *vma = walk->vma;
> -
> -	mss->swap += shmem_partial_swap_usage(walk->vma->vm_file->f_mapping,
> -					      linear_page_index(vma, addr),
> -					      linear_page_index(vma, end));
> -
> -	return 0;
> -}
> -#else
> -#define smaps_pte_hole		NULL
> -#endif /* CONFIG_SHMEM */
> -
> -static void smaps_pte_hole_lookup(unsigned long addr, struct mm_walk *walk)
> -{
> -#ifdef CONFIG_SHMEM
> -	if (walk->ops->pte_hole) {
> -		/* depth is not used */
> -		smaps_pte_hole(addr, addr + PAGE_SIZE, 0, walk);
> -	}
> -#endif
> -}
> -
> -static void smaps_pte_entry(pte_t *pte, unsigned long addr,
> -		struct mm_walk *walk)
> -{
> -	struct mem_size_stats *mss = walk->private;
> -	struct vm_area_struct *vma = walk->vma;
> -	bool locked = !!(vma->vm_flags & VM_LOCKED);
> -	struct page *page = NULL;
> -	bool present = false, young = false, dirty = false;
> -	pte_t ptent = ptep_get(pte);
> -
> -	if (pte_present(ptent)) {
> -		page = vm_normal_page(vma, addr, ptent);
> -		young = pte_young(ptent);
> -		dirty = pte_dirty(ptent);
> -		present = true;
> -	} else if (pte_none(ptent)) {
> -		smaps_pte_hole_lookup(addr, walk);
> -	} else {
> -		const softleaf_t entry = softleaf_from_pte(ptent);
> -
> -		if (softleaf_is_swap(entry)) {
> -			int mapcount;
> -
> -			mss->swap += PAGE_SIZE;
> -			mapcount = swp_swapcount(entry);
> -			if (mapcount >= 2) {
> -				u64 pss_delta = (u64)PAGE_SIZE << PSS_SHIFT;
> -
> -				do_div(pss_delta, mapcount);
> -				mss->swap_pss += pss_delta;
> -			} else {
> -				mss->swap_pss += (u64)PAGE_SIZE << PSS_SHIFT;
> -			}
> -		} else if (softleaf_has_pfn(entry)) {
> -			if (softleaf_is_device_private(entry))
> -				present = true;
> -			page = softleaf_to_page(entry);
> -		}
> -	}
> -
> -	if (!page)
> -		return;
> -
> -	smaps_account(mss, page, false, young, dirty, locked, present);
> -}
> -
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
> -		struct mm_walk *walk)
> -{
> -	struct mem_size_stats *mss = walk->private;
> -	struct vm_area_struct *vma = walk->vma;
> -	bool locked = !!(vma->vm_flags & VM_LOCKED);
> -	struct page *page = NULL;
> -	bool present = false;
> -	struct folio *folio;
> -
> -	if (pmd_none(*pmd))
> -		return;
> -	if (pmd_present(*pmd)) {
> -		page = vm_normal_page_pmd(vma, addr, *pmd);
> -		present = true;
> -	} else if (unlikely(thp_migration_supported())) {
> -		const softleaf_t entry = softleaf_from_pmd(*pmd);
> -
> -		if (softleaf_has_pfn(entry))
> -			page = softleaf_to_page(entry);
> -	}
> -	if (IS_ERR_OR_NULL(page))
> -		return;
> -	folio = page_folio(page);
> -	if (folio_test_anon(folio))
> -		mss->anonymous_thp += HPAGE_PMD_SIZE;
> -	else if (folio_test_swapbacked(folio))
> -		mss->shmem_thp += HPAGE_PMD_SIZE;
> -	else if (folio_is_zone_device(folio))
> -		/* pass */;
> -	else
> -		mss->file_thp += HPAGE_PMD_SIZE;
> -
> -	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd),
> -		      locked, present);
> -}
> -#else
> -static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
> -		struct mm_walk *walk)
> -{
> -}
> -#endif
> -
> -static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> -			   struct mm_walk *walk)
> -{
> -	struct vm_area_struct *vma = walk->vma;
> -	pte_t *pte;
> -	spinlock_t *ptl;
> -
> -	ptl = pmd_trans_huge_lock(pmd, vma);
> -	if (ptl) {
> -		smaps_pmd_entry(pmd, addr, walk);
> -		spin_unlock(ptl);
> -		goto out;
> -	}
> -
> -	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> -	if (!pte) {
> -		walk->action = ACTION_AGAIN;
> -		return 0;
> -	}
> -	for (; addr != end; pte++, addr += PAGE_SIZE)
> -		smaps_pte_entry(pte, addr, walk);
> -	pte_unmap_unlock(pte - 1, ptl);
> -out:
> -	cond_resched();
> -	return 0;
> -}
> -
>  static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
>  {
>  	/*
> @@ -1228,58 +1089,6 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
>  	seq_putc(m, '\n');
>  }
>  
> -#ifdef CONFIG_HUGETLB_PAGE
> -static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
> -				 unsigned long addr, unsigned long end,
> -				 struct mm_walk *walk)
> -{
> -	struct mem_size_stats *mss = walk->private;
> -	struct vm_area_struct *vma = walk->vma;
> -	struct folio *folio = NULL;
> -	bool present = false;
> -	spinlock_t *ptl;
> -	pte_t ptent;
> -
> -	ptl = huge_pte_lock(hstate_vma(vma), walk->mm, pte);
> -	ptent = huge_ptep_get(walk->mm, addr, pte);
> -	if (pte_present(ptent)) {
> -		folio = page_folio(pte_page(ptent));
> -		present = true;
> -	} else {
> -		const softleaf_t entry = softleaf_from_pte(ptent);
> -
> -		if (softleaf_has_pfn(entry))
> -			folio = softleaf_to_folio(entry);
> -	}
> -
> -	if (folio) {
> -		/* We treat non-present entries as "maybe shared". */
> -		if (!present || folio_maybe_mapped_shared(folio) ||
> -		    hugetlb_pmd_shared(pte))
> -			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
> -		else
> -			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
> -	}
> -	spin_unlock(ptl);
> -	return 0;
> -}
> -#else
> -#define smaps_hugetlb_range	NULL
> -#endif /* HUGETLB_PAGE */
> -
> -static const struct mm_walk_ops smaps_walk_ops = {
> -	.pmd_entry		= smaps_pte_range,
> -	.hugetlb_entry		= smaps_hugetlb_range,
> -	.walk_lock		= PGWALK_RDLOCK,
> -};
> -
> -static const struct mm_walk_ops smaps_shmem_walk_ops = {
> -	.pmd_entry		= smaps_pte_range,
> -	.hugetlb_entry		= smaps_hugetlb_range,
> -	.pte_hole		= smaps_pte_hole,
> -	.walk_lock		= PGWALK_RDLOCK,
> -};
> -
>  /*
>   * Gather mem stats from @vma with the indicated beginning
>   * address @start, and keep them in @mss.
> @@ -1287,40 +1096,90 @@ static const struct mm_walk_ops smaps_shmem_walk_ops = {
>   * Use vm_start of @vma as the beginning address if @start is 0.
>   */
>  static void smap_gather_stats(struct vm_area_struct *vma,
> -		struct mem_size_stats *mss, unsigned long start)
> +				  struct mem_size_stats *mss,
> +				  unsigned long start)
>  {
> -	const struct mm_walk_ops *ops = &smaps_walk_ops;
> -
> -	/* Invalid start */
> -	if (start >= vma->vm_end)
> -		return;
> +	struct pt_range_walk ptw = {
> +		.mm = vma->vm_mm
> +	};
> +	enum pt_range_walk_type type;
> +	pt_type_flags_t flags = PT_TYPE_ALL;
>  
> -	if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
> -		/*
> -		 * For shared or readonly shmem mappings we know that all
> -		 * swapped out pages belong to the shmem object, and we can
> -		 * obtain the swap value much more efficiently. For private
> -		 * writable mappings, we might have COW pages that are
> -		 * not affected by the parent swapped out pages of the shmem
> -		 * object, so we have to distinguish them during the page walk.
> -		 * Unless we know that the shmem object (or the part mapped by
> -		 * our VMA) has no swapped out pages at all.
> -		 */
> -		unsigned long shmem_swapped = shmem_swap_usage(vma);
> +	if (!start)
> +		start = vma->vm_start;
> +
> +	flags &= ~(PT_TYPE_NONE|PT_TYPE_PFN);
> +
> +	type = pt_range_walk_start(&ptw, vma, start, vma->vm_end, flags);
> +	while (type != PTW_DONE) {
> +		bool locked = !!(vma->vm_flags & VM_LOCKED);
> +		bool compound = false, account = false;
> +		unsigned long swap_size;
> +		int mapcount;
> +
> +		switch (type) {
> +		case PTW_FOLIO:
> +		case PTW_MIGRATION:
> +		case PTW_HWPOISON:
> +		case PTW_DEVICE:
> +			/*
> +			 * We either have a folio because vm_normal_folio was
> +			 * successful, or because we had a special swap entry
> +			 * and could retrieve it with softleaf_to_page.
> +			 */
> +			if (is_vm_hugetlb_page(vma)) {
> +				/* HugeTLB */
> +				unsigned long size = huge_page_size(hstate_vma(ptw.vma));
> +
> +				if (!ptw.present || folio_maybe_mapped_shared(ptw.folio) ||
> +				    ptw.pmd_shared)
> +					mss->shared_hugetlb += size;
> +				else
> +					mss->private_hugetlb += size;
> +			} else {
> +				account = true;
> +				if (ptw.level == PTW_PMD_LEVEL) {
> +					/* THP */
> +					compound = true;
> +					if (folio_test_anon(ptw.folio))
> +						mss->anonymous_thp += ptw.size;
> +					else if (folio_test_swapbacked(ptw.folio))
> +						mss->shmem_thp += ptw.size;
> +					else if (folio_is_zone_device(ptw.folio))
> +						/* pass */;
> +					else
> +						mss->file_thp += ptw.size;
> +				} else if (ptw.level == PTW_PTE_LEVEL && ptw.nr_entries > 1) {
> +					compound = true;
> +				}
> +			}
> +			break;
> +		case PTW_SWAP:
> +			account = true;
> +			swap_size = PAGE_SIZE * ptw.nr_entries;
> +			mss->swap += swap_size;
> +			mapcount = swp_swapcount(ptw.softleaf_entry);
> +			if (mapcount >= 2) {
> +				u64 pss_delta = (u64)swap_size << PSS_SHIFT;
>  
> -		if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
> -					!(vma->vm_flags & VM_WRITE))) {
> -			mss->swap += shmem_swapped;
> -		} else {
> -			ops = &smaps_shmem_walk_ops;


The old smap_gather_stats had special handling for shmem swap
accounting.  For shared or readonly shmem mappings it used
shmem_swap_usage() to efficiently account swapped-out shmem pages.
For private writable shmem mappings it used smaps_pte_hole() via
smaps_shmem_walk_ops to call shmem_partial_swap_usage() for each
PTE hole.

The new code removes all of this.  The pt_range_walk API does not
have pte_hole callbacks, so shmem pages that are swapped out (and
thus have no PTE) would not be counted in the Swap field of smaps?


> +				do_div(pss_delta, mapcount);
> +				mss->swap_pss += pss_delta;
> +			} else {
> +				mss->swap_pss += (u64)swap_size << PSS_SHIFT;
> +			}
> +			break;
> +		default:
> +			/* Ooops */
> +			break;
>  		}
> +
> +		if (account && ptw.folio)
> +			smaps_account(mss, ptw.page, compound, ptw.young,
> +				      ptw.dirty, locked, ptw.present, ptw.size);
> +		type = pt_range_walk_next(&ptw, vma, start, vma->vm_end, flags);
>  	}
>  
> -	/* mmap_lock is held in m_start */
> -	if (!start)
> -		walk_page_vma(vma, ops, mss);
> -	else
> -		walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
> +	pt_range_walk_done(&ptw);
>  }
>  
>  #define SEQ_PUT_DEC(str, val) \
> -- 
> 2.35.3
> 
> 

