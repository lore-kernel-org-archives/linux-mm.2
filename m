Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 668A4C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EBAE6B0088; Fri, 10 Jul 2026 09:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C366B008A; Fri, 10 Jul 2026 09:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 464F96B008C; Fri, 10 Jul 2026 09:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27E786B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:17:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AEE508E414
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:17:02 +0000 (UTC)
X-FDA: 84972917484.12.D60A5CE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id C2B5940006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:17:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CjOhcGxh;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783689420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GlIQbCMbmaWi49ojUWLBRa7NzB8V+jxfjTxUsdrh+qM=;
	b=j2svnLRVkIVtIAvqJlvMYOuSf01qyEpoBto223EOl5zSQZ/aepQdI3n+LFB8DUBuAVg4sK
	X4+T79jTNg50bmbJGID2gHoBS1nEtK0D5TUqqPtMekh7eYkkT8ZHQ3tx9qBRwxHuCKzdtG
	WPpBCFDjJ2X8IsRT8OfwfbwhuJGhhEw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CjOhcGxh;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783689420;
	b=GdLHEX0KuirK0ryp4f1GnOZLrjX8LbyIugDv0NmO48xWQL/aQSRU6U4i1ptBZ27lGd8Z9X
	uPDB1nFnS3NHphPrFy+bae/NVGkbl9nDu/vL+R6JKmNzyAeM9blgrg2ocTixcYpumSqzSe
	OLKO+NgKQvUt88AHh/j8NTjKJwJs4oI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9069B176A;
	Fri, 10 Jul 2026 06:16:55 -0700 (PDT)
Received: from [10.164.19.51] (unknown [10.164.19.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F3FE73F66F;
	Fri, 10 Jul 2026 06:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783689419; bh=yRj20X14NCMjYSEiJHRXqL4eiXU3Nbn9/26tDFT6lO0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CjOhcGxhjr6wueChJ/51O+PdyG4ey8PXlyH/OHfBjnkRQ/s73w0tWZuO2IXttc5FU
	 gOq3MXiRsVUp+jtZA2oKRaaa5npruhYn1TwrckVpZBbA+4G97mIhlLFaJrMq1D57D6
	 bQY3YLmYbxnpcSQxXwjUiVW+8vueWi+RuT8guCKM=
Message-ID: <49b408b9-6d10-4892-916f-ad8e7ef875e5@arm.com>
Date: Fri, 10 Jul 2026 18:46:53 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] mm/rmap: Add try_to_unmap_hugetlb_one
To: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 muchun.song@linux.dev, osalvador@suse.de
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260710055915.638659-1-dev.jain@arm.com>
 <20260710055915.638659-3-dev.jain@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260710055915.638659-3-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C2B5940006
X-Stat-Signature: b5a7hi8s3h6tpn8jo3msm7rx6ffjg9fa
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783689420-722709
X-HE-Meta: U2FsdGVkX198t+pD7szqdHiut4Fi7YutFWFIte4AfhNI5jp2ds/64BvqwoeQFNSOUEUGztf3Vgfdoci2j+rjWkjzPteYBdUX21kIZaYXuPv0zsbVW6idN1cX0RyL2X7vphmZLE9i2LcwouPIV80q+ijWcZCCoOBFrpoPWmgLXQeAnZQjogx2G6ZypvnwAPfjt9hMTMrbwD+H/VfgmkB/VkeuViKkXptvmvsEBs0JNX7cUtUG5vqh7qEHsiOonezrlEjzimRYw+lX1Xt1XYQAd58maM7rm16O4t9XeG6yLR6UnasTHtG/eCFMQl/7/nQc3L6TVsciRyr1btd9ey4JMqXiNescc7o0tutPZPBg0cccn+V4m/LtBsos1Hunwm4GEEz6aFdExpahnuTTGTzrmLEmQ8TVDjzfRt5NEAeYl7tfx0D4PjMD0T3SlArLa3oFjXlTxKwLWLzISbz2Dx/QCx2V7se9pGnx8oC1i+qZeR2jRM7xSds8k1xUwYxs1wH3eDXTGfdBj6MjXUcg0JxQQ9sxRQvw/ttPffZhZfkuTl5HAYkwS/vugwhkrxad29NiVa4kaJko+F221otgfWWcq1AlrJLfdArUs00nidhUDvrUK3hPt4YePj/O1sTu0Ox01jo67YGmYfdy2k7QNHjTyosZtoMpJ0X8qaRaMmnUMtMnOYGj8pTwOPivJAMMWNmmPQeG9jxYS/2uv3KGypAzbYBWRUocYMmKhfvBwoT6poIAbKX8qcb5AOI7G7km7P+ZAs3GH79yajUUU2ZObZLhUQdxHr8xXiWBBOTtmn5qq4rlL9kPiYO3rpWah/R3cSM24wzlw9WllL5BTZMQ8kaZ94orBW/P6wlMCoyMNrMtLa439Wf3J4lG137iWC69ZWwn0R9Wjisr6ss0qFV98uJ3vBIOnJyqdxKFLMoo4nHhMDKYLdEikCxaOtq8bIVXM4bl9Lwyqve9S/BSUvoC8QE
 hPytQe8r
 xznakxm7oxWx3OF4RSGJwdR2o2Bh7GBqx9SM/C/BpKhMMZ8EXIXQ5GwRXXWpzuWXP3orzWDaovTKb9tZoG5HvPXCNZhKNI360vYd1sZ7ctbZ52PIKvdc3zktX7m5SXUa1zwPrN/A5WLV4/PkidONg4pVBmbjRDyTdbBePtHqwhzdd1IYLzzH+gcDKfTw9jT3fFayaj+lWAOwGiy8A7CFlH/5lP/4Duos3+hyzwzZKgZ0PXjntqA7btfewvrZAZ3yBgJN+P5r9THXnQ3CPu2uNKetex0lQCuvNoGTq9lMEuCL7h/3CT89RhVZzRJ9nExl6VtV1h6w+VgAV2iC2D9pIR7CLegLislPPdfE/ggxrYlEzmGMSjoj9xTL+8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/07/26 11:29 am, Dev Jain wrote:
> Simplify try_to_unmap_one() by separating the hugetlb parts into
> try_to_unmap_hugetlb_one().
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
> ---

Andrew, could you squash the following diff:

diff --git a/mm/rmap.c b/mm/rmap.c
index cf02b315a2ead..b61051b879c4c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2229,8 +2229,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
                update_hiwater_rss(mm);

                /*
-                * With TTU_HWPOISON, we only expect small folios or hugetlb
-                * folios here for now.
+                * With TTU_HWPOISON, we only expect small folios here.
                 */
                if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
                        pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));


>  include/linux/hugetlb.h |   1 +
>  mm/rmap.c               | 178 ++++++++++++++++++++++------------------
>  2 files changed, 97 insertions(+), 82 deletions(-)
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
> index dbb077f8443e3..cf02b315a2ead 100644
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
> +	VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
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
> +		if (!hugetlb_vma_trylock_write(vma)) {
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
> -				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
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
> @@ -2211,14 +2234,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		 */
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
> @@ -2346,11 +2363,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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
> @@ -2398,7 +2411,8 @@ static int folio_not_mapped(struct folio *folio)
>  void try_to_unmap(struct folio *folio, enum ttu_flags flags)
>  {
>  	struct rmap_walk_control rwc = {
> -		.rmap_one = try_to_unmap_one,
> +		.rmap_one = folio_test_hugetlb(folio) ?
> +				try_to_unmap_hugetlb_one : try_to_unmap_one,
>  		.arg = (void *)flags,
>  		.done = folio_not_mapped,
>  		.anon_lock = folio_lock_anon_vma_read,


