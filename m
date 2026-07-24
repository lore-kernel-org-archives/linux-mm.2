Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 418AFC531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49CD56B00A7; Fri, 24 Jul 2026 06:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425996B00AC; Fri, 24 Jul 2026 06:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EE8C6B00AD; Fri, 24 Jul 2026 06:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E64036B00A7
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:39:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 676A7A0CF8
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:39:58 +0000 (UTC)
X-FDA: 85023324876.08.F756430
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D50CE80002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:39:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aXbmem+d;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784889596;
	b=gla5N5ob4IgSfeb4buEZWh5kYcoIr5Qbpuzz6dp1kOCugN2ESqobYDOc5IERh+i1BFkzGG
	jgg1Civ5d5XmZO1o2Z2gNQTujdJzxHTniGuu0LaVXQCEiJq9chnNiWpO7sRBdDouwVEqaz
	KNpxDJeD8JPaa98gVgUlCWiy/4osin0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aXbmem+d;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784889596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k1trzLOTSSBfNm7/sau6v2fY72W8z8j69UrS0D94NOA=;
	b=5culR9IczWUvbtf9t12UKDSTtJ6uIF3IVwnu33dOaPDtp+ynhlxy1cy7TSxBmYW9YBSsJx
	x8cqlEl5YvNkuPpWoypur7XSoHkEoAGuvJSCgA+TYVac5t5AwSMoDBqWphb+inxXKwAaf5
	Op2jRGF3nPmI04tCjVoVLKqQ23eWNHw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4741A600AF;
	Fri, 24 Jul 2026 10:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCAB71F000E9;
	Fri, 24 Jul 2026 10:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784889596;
	bh=k1trzLOTSSBfNm7/sau6v2fY72W8z8j69UrS0D94NOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aXbmem+dAM9EaM9cONRg9ANY7SZTSo+LGgOOT2IbZAxM+q6pB5nQK6uwQ1HVXkye+
	 fHxUKI8wZxjWbdf9YfBX3O0iHMgdbo3cPMsaavHhM092T4Y7Cmwj5xKPUQUKkXmq5Q
	 sj11QRyiuQfNxHpQLpVH+5O1MXYOhluz8vFMkrkObnzDq94fwCQdwagCBRzIaEM4DG
	 PQOhHIcqIlp5kNRpeh2NPAVRM+CE5EvN4lBDcxdMuZgJB6Wpju0pbOEVTW2niv2ah6
	 TSuj8r+3BqzTwlaJvpKwSjgCVa6PJnouB9CPVpIGSkcATKUkmoeJZmJiqDRmtSG95t
	 Htd9ZhHYXxslg==
Date: Fri, 24 Jul 2026 11:39:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev, 
	osalvador@suse.de, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH v3 2/5] mm/rmap: Add try_to_unmap_hugetlb_one
Message-ID: <amMyhkFX6Dj1UqJD@lucifer>
References: <20260713050050.1017741-1-dev.jain@arm.com>
 <20260713050050.1017741-3-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713050050.1017741-3-dev.jain@arm.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D50CE80002
X-Stat-Signature: uen7mknjtqzphow7iax7yq44wnhk1o9t
X-Rspam-User: 
X-HE-Tag: 1784889596-520542
X-HE-Meta: U2FsdGVkX18HL1fQ3l7jEA3dHeK3eYfHjK1Fv0YgiJbgHGUxHafZb/INe8IANLAaBXJPHI3iYRP726eaFii12KKZ5cLjQ6feFncUIwyh6NZDF3zsO5HKArX1Nyz8BqYo9VqN6mpTuLAp7Fhikq9TMogSuoDk048zCSEKN1kSyvbdC8nsFGdnn5u97NNvjRCSYwRx/Qm1odj4JrKDzenDyrEEV5n035pX+gBotLZPF9G5k/aEjT+8Q0YFlup3253b+wS24y7GL8Uefa1Rm5y8ifmu5BApJIrlNJFHzuaz0KF6Z0ynUkH22UtMUgNcInNIfbQ2G/s1J5x9mzPnNBb13rM8RgfZXHAJvYNozJpHAL1nVURQXAP84Y3+idoN76ti501C6aPDZ3HhwfeBBrWLajOB4pby0haYHJyz0Sd7TFyooPjF6G+gD/2ZsnYZC4J9MXRTK+4G5tUbaZzcoRY/SduksMqw+mHR7HwyQgp4bDDm9oOaJnkPRAVyG4KczDdyJxrrReyRr2nv3LAX5iNskY12VZluQewvU0N8yGoB6jcwRBSJZXRoTqaweaCJ4E4mhIoLuwVkTDWC7CO//8TrZoAix7FA+6fqud4vK/Fj2vXxIxaXh1F0BVVlWpwdeZGdnyt5jjycfjhX7PAhWL1NkPcK9hX/1d5QTSTIT4nK8ATjpcHjtRlUxdNU6zjdpYO32+D9Cc+VVjg4hyr8k9H6dbuSxpbhiseqF/iFY/xYG2C/X2MaxO2ckrddTviRvrptqxkrGmswbgpTaDu0y4tSUUaE6F6E97nDz5Bw7h/7fEZXycDMn8JFr4OpiE0CPNLrpWNxlxGn9o0olwzsuoqhQOpqhG4Ivczj/PC/Pzeu3YOPPk3EQdfcMxu04Dnf3I5W9MAl0dEgJ9wl6TIeAEwn739kvP9F89Vta40S0cMy1g8FTplnAsO5nkAvMkA0BU8rvDODu9TwPCk1fxCA4XF
 +NVAlleF
 v0JZn5OPAkOUfWosvFLcJ8sUxFbD5EQnGyoRfKIrSBfANhwaz25CtgXIz4FTk9hY6foNMyZBlF1buo1wewge8U7Y+1OMM4XRy3Q17b4lc6OYzp+2Kklai3AvvLYnG4i+xP6tEPp3L4HDBcH/2Rjvv8yj+WQgezXX40PgW6N4tZegV8FOmx+mFohPiCDQnU3UGC4Ki06RwX8bsKb2sRm6tS0mMI6C2laO8m7bu0qh3d23IZqVe+xvFdsAG/m27FvFehcLytm7934u/um5vvIs6hx4g8fcMERyjkPZhYlDSTgYyDktU12P1rJtmbFFdE2wUEydeaT/Lf+7Ow00VmFm1mLtus/c6+Uk/nm5F3QXWLewr4EYuCEn0F8dsxU7LUR1kIQbI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 05:00:45AM +0000, Dev Jain wrote:
> Simplify try_to_unmap_one() by separating the hugetlb parts into
> try_to_unmap_hugetlb_one().

I hate that we have this separate hugetlb stuff but while we have it,
better to be explicit :)

>
> To understand the correctness of the refactoring, the following points
> are noted:
>
> 1. try_to_unmap() is called for hugetlb folios only when they are
>    hwpoisoned.
>
> 2. A hugetlb VMA cannot be mlocked.
>
> 3. page_vma_mapped_walk() returns at most one hugetlb mapping in a VMA,
>    and that mapping points at the head PFN.
>
> 4. We won't ever process a softleaf entry that encodes a hugetlb folio;
>    hugetlb folios are never swapped out, migration entries will be
>    skipped (PVMW_MIGRATION not passed), and device-exclusive does not
>    work for hugetlb.
>
> 5. The hwpoison entry is constructed from the poisoned folio, just as in
>    the pre-refactor code. Any previous uffd-wp state is deliberately not
>    preserved for the hwpoison entry.
>
> 6. TTU_HWPOISON is always present; for it to not be present, either the
>    folio has to be in swapcache, or mapping_can_writeback() is true (see
>    unmap_poisoned_folio), none of which is true for hugetlb folios.
>
> 7. Hugetlb uses separate counters from normal rss counters, therefore
>    update_highwater_rss() need not be called.

I wonder whether you could bundle some of this up into a comment around
try_to_unmap_hugetlb_one()?

>
> While at it:
>
>  - Change VM_BUG_* to VM_WARN_*.
>
>  - Do not declare variables which are only used once.
>
>  - Constify some variables.
>
>  - Add some more VM_WARN_* to assert some invariants.
>
> Except the above 4 points, no functional change intended.
>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

A bunch of nits but those addressed LGTM:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks very much for doing this is a big improvement!

> ---
>  include/linux/hugetlb.h |   1 +
>  mm/rmap.c               | 183 +++++++++++++++++++++-------------------
>  2 files changed, 98 insertions(+), 86 deletions(-)
>
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 4115076e4922a..bf7e163e3779d 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -1271,6 +1271,7 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
>  }
>
>  pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
> +unsigned long huge_pte_dirty(pte_t pte);
>
>  static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
>  					  unsigned long addr, pte_t *ptep)
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 2b74668f356d6..7720c49ada4c3 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1978,6 +1978,96 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>  				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>  }
>
> +static bool try_to_unmap_hugetlb_one(struct folio *folio,
> +		struct vm_area_struct *vma, unsigned long address, void *arg)
> +{
> +	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
> +	const unsigned long hsz = huge_page_size(hstate_vma(vma));
> +	const enum ttu_flags flags = (enum ttu_flags)(long)arg;
> +	struct mm_struct *mm = vma->vm_mm;
> +	struct mmu_notifier_range range;
> +	bool ret = true;
> +	pte_t pteval;
> +
> +	/*
> +	 * The try_to_unmap() is only passed a hugetlb folio in the case
> +	 * where the hugetlb folio is poisoned.
> +	 */

I wonder if the function should be try_to_unmap_poisoned_hugetlb_one() as a
result?

> +	VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);

NIT: Should be VM_WARN_ON_ONCE_FOLIO() for consistency with below and to avoid
repeated warnings?

> +	VM_WARN_ON_ONCE(!(flags & TTU_HWPOISON));
> +
> +	range.end = vma_address_end(&pvmw);
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
> +				address, range.end);
> +	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
> +	mmu_notifier_invalidate_range_start(&range);
> +
> +	/* There is only a single mapping in a VMA. */
> +	if (!page_vma_mapped_walk(&pvmw))
> +		goto range_end;
> +
> +	VM_WARN_ON_ONCE(address != pvmw.address);
> +
> +	pteval = huge_ptep_get(mm, address, pvmw.pte);
> +	VM_WARN_ON_ONCE(!pte_present(pteval));
> +	VM_WARN_ON_ONCE(pte_pfn(pteval) != folio_pfn(folio));

I guess no TTU_SYNC is possible for hugetlb poison unmap?

> +
> +	/*
> +	 * huge_pmd_unshare may unmap an entire PMD page. There is no way of
> +	 * knowing exactly which PMDs may be cached for this mm, so we must
> +	 * flush them all. start/end were already adjusted above to cover this
> +	 * range.
> +	 */
> +	flush_cache_range(vma, range.start, range.end);
> +
> +	/*
> +	 * To call huge_pmd_unshare, i_mmap_rwsem must be held in write mode.
> +	 * Caller needs to explicitly do this outside rmap routines.
> +	 *
> +	 * We also must hold hugetlb vma_lock in write mode. Lock order dictates
> +	 * acquiring vma_lock BEFORE i_mmap_rwsem. We can only try lock here and
> +	 * fail if unsuccessful.
> +	 */
> +	if (!folio_test_anon(folio)) {
> +		struct mmu_gather tlb;
> +
> +		VM_WARN_ON(!(flags & TTU_RMAP_LOCKED));

VM_WARN_ON_ONCE()?

> +		if (!hugetlb_vma_trylock_write(vma)) {

How I hate that hugetlb calls their lock a 'VMA lock'...

> +			ret = false;
> +			goto walk_done;
> +		}
> +
> +		tlb_gather_mmu_vma(&tlb, vma);
> +		if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
> +			hugetlb_vma_unlock_write(vma);
> +			huge_pmd_unshare_flush(&tlb, vma);
> +			tlb_finish_mmu(&tlb);
> +			/*
> +			 * The PMD table was unmapped, consequently unmapping
> +			 * the folio.
> +			 */
> +			goto walk_done;
> +		}
> +		hugetlb_vma_unlock_write(vma);
> +		tlb_finish_mmu(&tlb);
> +	}
> +	pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
> +	if (huge_pte_dirty(pteval))
> +		folio_mark_dirty(folio);
> +
> +	pteval = swp_entry_to_pte(make_hwpoison_entry(folio_page(folio, 0)));
> +	hugetlb_count_sub(folio_nr_pages(folio), mm);
> +	set_huge_pte_at(mm, address, pvmw.pte, pteval, hsz);
> +	hugetlb_remove_rmap(folio);
> +	folio_put_refs(folio, 1);

Do we want an assert here somehow that we are only walking one folio?

> +
> +walk_done:
> +	page_vma_mapped_walk_done(&pvmw);
> +range_end:
> +	mmu_notifier_invalidate_range_end(&range);
> +	return ret;
> +}
> +
>  /*
>   * @arg: enum ttu_flags will be passed to this argument
>   */
> @@ -1993,7 +2083,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  	enum ttu_flags flags = (enum ttu_flags)(long)arg;
>  	unsigned long nr_pages = 1, end_addr;
>  	unsigned long pfn;
> -	unsigned long hsz = 0;
>  	int ptes = 0;
>
>  	/*
> @@ -2007,8 +2096,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>
>  	/*
>  	 * For THP, we have to assume the worse case ie pmd for invalidation.
> -	 * For hugetlb, it could be much worse if we need to do pud
> -	 * invalidation in the case of pmd sharing.
>  	 *
>  	 * Note that the folio can not be freed in this function as call of
>  	 * try_to_unmap() must hold a reference on the folio.
> @@ -2016,17 +2103,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  	range.end = vma_address_end(&pvmw);
>  	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
>  				address, range.end);
> -	if (folio_test_hugetlb(folio)) {
> -		/*
> -		 * If sharing is possible, start and end will be adjusted
> -		 * accordingly.
> -		 */
> -		adjust_range_if_pmd_sharing_possible(vma, &range.start,
> -						     &range.end);
> -
> -		/* We need the huge page size for set_huge_pte_at() */
> -		hsz = huge_page_size(hstate_vma(vma));
> -	}
>  	mmu_notifier_invalidate_range_start(&range);
>
>  	while (page_vma_mapped_walk(&pvmw)) {
> @@ -2111,66 +2187,13 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  			const softleaf_t entry = softleaf_from_pte(pteval);
>
>  			pfn = softleaf_to_pfn(entry);
> -			VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
>  		}
>
>  		subpage = folio_page(folio, pfn - folio_pfn(folio));
>  		anon_exclusive = folio_test_anon(folio) &&
>  				 PageAnonExclusive(subpage);
>
> -		if (folio_test_hugetlb(folio)) {
> -			bool anon = folio_test_anon(folio);
> -
> -			/*
> -			 * The try_to_unmap() is only passed a hugetlb folio
> -			 * in the case where the hugetlb folio contains a
> -			 * poisoned page.
> -			 */
> -			VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
> -			/*
> -			 * huge_pmd_unshare may unmap an entire PMD page.
> -			 * There is no way of knowing exactly which PMDs may
> -			 * be cached for this mm, so we must flush them all.
> -			 * start/end were already adjusted above to cover this
> -			 * range.
> -			 */
> -			flush_cache_range(vma, range.start, range.end);
> -
> -			/*
> -			 * To call huge_pmd_unshare, i_mmap_rwsem must be
> -			 * held in write mode.  Caller needs to explicitly
> -			 * do this outside rmap routines.
> -			 *
> -			 * We also must hold hugetlb vma_lock in write mode.
> -			 * Lock order dictates acquiring vma_lock BEFORE
> -			 * i_mmap_rwsem.  We can only try lock here and fail
> -			 * if unsuccessful.
> -			 */
> -			if (!anon) {
> -				struct mmu_gather tlb;
> -
> -				VM_BUG_ON(!(flags & T][\TU_RMAP_LOCKED));
> -				if (!hugetlb_vma_trylock_write(vma))
> -					goto walk_abort;
> -
> -				tlb_gather_mmu_vma(&tlb, vma);
> -				if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
> -					hugetlb_vma_unlock_write(vma);
> -					huge_pmd_unshare_flush(&tlb, vma);
> -					tlb_finish_mmu(&tlb);
> -					/*
> -					 * The PMD table was unmapped,
> -					 * consequently unmapping the folio.
> -					 */
> -					goto walk_done;
> -				}
> -				hugetlb_vma_unlock_write(vma);
> -				tlb_finish_mmu(&tlb);
> -			}
> -			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
> -			if (pte_dirty(pteval))
> -				folio_mark_dirty(folio);
> -		} else if (likely(pte_present(pteval))) {
> +		if (likely(pte_present(pteval))) {
>  			nr_pages = folio_unmap_pte_batch(folio, &pvmw, flags, pteval);
>  			end_addr = address + nr_pages * PAGE_SIZE;
>  			flush_cache_range(vma, address, end_addr);
> @@ -2205,20 +2228,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		/* Update high watermark before we lower rss */
>  		update_hiwater_rss(mm);
>
> -		/*
> -		 * With TTU_HWPOISON, we only expect small folios or hugetlb
> -		 * folios here for now.
> -		 */
> +		/* With TTU_HWPOISON, we only expect small folios here. */

I mean you can further simplify the simplified version this way :)

>  		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
>  			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
> -			if (folio_test_hugetlb(folio)) {
> -				hugetlb_count_sub(folio_nr_pages(folio), mm);
> -				set_huge_pte_at(mm, address, pvmw.pte, pteval,
> -						hsz);
> -			} else {
> -				dec_mm_counter(mm, mm_counter(folio));
> -				set_pte_at(mm, address, pvmw.pte, pteval);
> -			}
> +			dec_mm_counter(mm, mm_counter(folio));
> +			set_pte_at(mm, address, pvmw.pte, pteval);
>  		} else if (likely(pte_present(pteval)) && pte_unused(pteval) &&
>  			   !userfaultfd_armed(vma)) {
>  			/*
> @@ -2346,11 +2360,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
>  		}
>  discard:
> -		if (unlikely(folio_test_hugetlb(folio))) {
> -			hugetlb_remove_rmap(folio);
> -		} else {
> -			folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
> -		}
> +		folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
>  		if (vma->vm_flags & VM_LOCKED)
>  			mlock_drain_local();
>  		folio_put_refs(folio, nr_pages);
> @@ -2398,7 +2408,8 @@ static int folio_not_mapped(struct folio *folio)
>  void try_to_unmap(struct folio *folio, enum ttu_flags flags)
>  {
>  	struct rmap_walk_control rwc = {
> -		.rmap_one = try_to_unmap_one,
> +		.rmap_one = folio_test_hugetlb(folio) ?
> +				try_to_unmap_hugetlb_one : try_to_unmap_one,
>  		.arg = (void *)flags,
>  		.done = folio_not_mapped,
>  		.anon_lock = folio_lock_anon_vma_read,
> --
> 2.43.0
>

Cheers, Lorenzo

