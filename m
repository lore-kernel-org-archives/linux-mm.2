Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC815CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA5AD6B0005; Tue,  9 Jun 2026 10:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7D656B0088; Tue,  9 Jun 2026 10:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93016B008C; Tue,  9 Jun 2026 10:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A891F6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:16:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77E4CA05D7
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:16:59 +0000 (UTC)
X-FDA: 84860575758.30.01A1A53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 94930180018
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:16:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O23RZQMj;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781014617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DsEYnoTDV2fyR/94awlNA8VKDbOA4a3SsoT5hLiLsw=;
	b=KtmMfyaHoYILM3sdC/e9+y1QRk3RLzXCI8UR2O1CoekMrvu7zX5KOrRkjsEpJAnIiCqizX
	ZjpyzJX44Kppxgbats3O3zBvI/y6SPvARW4kYVdVZXkOauHUbeC9/Og7K6AsRP1lnNV3VN
	sbCw6xmSoxiwiGaWiFzMA8jIIrZ71Mk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O23RZQMj;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781014617;
	b=CQFRTe9U9CBLVqywvcVm4GSaO2eRaJasem4xTsTSNwHdgYEZppipfi48r/xVL3YvUknB6q
	7jI7g6ElRvP0TjBmEQFvT3PrkW/gYuACO9h5PhlO9v58PdScet7UbBoyd940IbJ2hB94da
	GtPNAcSexDJ2aowmfNVx46aZwj5alSQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B8F3C443A7;
	Tue,  9 Jun 2026 14:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4121F00893;
	Tue,  9 Jun 2026 14:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781014616;
	bh=8DsEYnoTDV2fyR/94awlNA8VKDbOA4a3SsoT5hLiLsw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=O23RZQMjulYOhifaRc1NeJG7nl0tKpXfmEe0BIXglKp1iA2azgR4hFzMd/8zWZUtc
	 oPmr7wQ3SgJT8kM74j882Agi7wbjlOoJ1E9fO6/QNk7o1C1yQrYpIsi49tPUgb98Ve
	 WoGD/KW7X6blZ7m2IdXnMLIdiaBLJ8lYFKKiYg4HcVKAQVdkvvX6aE7aZOJsQ/zxu9
	 RnJHoX2cCPZnlxV9ceg0zux8dDibrLDr8lDQavSb/3eLIYghxLB50SxXXESePfoJto
	 8yMSa5y50g0cm1NTZVal5sZxJhVoiGC6vd1MS7rdpWGIb/g1/UzkhwPjiBpfiJW5At
	 FzUunG6xRhrog==
Message-ID: <ee0d499c-de98-4860-bfd0-0bce0b4c1bdc@kernel.org>
Date: Tue, 9 Jun 2026 16:16:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] mm/rmap: Add try_to_unmap_hugetlb_one
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-3-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526063635.61721-3-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 94930180018
X-Stat-Signature: 8z1gfdtimte1xoyaykti878qnp7cti1y
X-Rspam-User: 
X-HE-Tag: 1781014617-311382
X-HE-Meta: U2FsdGVkX19GUwU1zea+5V+eokJHn/XESzxBVE6gDlA1R4ft2prfx0ebMd9pbyuGldXmV2UUJFR+3jvgC7Fy9KaS/M3CpBkaXOFFoI6N+QafWKtOD24eQ1bDOb9fOSqE61PrwSPJYvlNai6Xo778aeRlwQJkgk9xlQigYZgOrZ+sGP/cG8AiFPfKG2jFGvf1tXwyoM7A8s1KnvTS+7NNU3TnN4Zb2PMzGErf0Y9esX+x0vELi7y3ZUQFKab54Ifmwqk9dO8K8PuMb8AhXWkluDkBjkWnaYKmzPqQBrLMxZSxSYa4gzUwc5RPK1aTdi/1HBMNIplxu80/oddYaUPSsoc/t3G+IGEIhBEfoomDMoXI17tzBHHG8ETrw6gDOhSvV4Obllmuut9DQzF5gUWx0k6z5NOFS/9ucOAafah27PYDGu3bzpm3G2Ja7qc2K2F8wIFeqBVL1zsiNqHJo0LmBY7u4kr4INwY83yzAPbE9c1BwnwLnG68CWTpFj/0qxuqTsB8R6GNmDBG6oGnMegfGMHUIB2MtRfCRoRJLKFFajxBJrvh8tdZ6JwdDNMD6RYhYE+TEVqm0FTIqlxO2xpkZ4cxOumUwBk5T52vmROYayTqNYX3WF+n3F8eSqRP5NBAtX5zWuEzC66ch9iARTeKNH+8nppPm+PMGcZv9G0MNE+8kzZ4Y6pTocqlLuF20Fa42CFiGDpmkTK/GZXzGEq8IYGiZZHV+/vIyfF32iglYsUVFGDTNaIfboTT5Ns+QcaxuZw0J8tpxtd9xG94n3dY8jLlJmCjoTB39EQ2GcyT3Zcm1EWhiD8KkipoEy8Ji+XYpiLCpS2JZsX4xfJ+lJt5WuBSiFv1xcde7v8akYNPgwgLnjOPNUbdrmX0aHxU4dJPhtx8Sv+msXtslQKlHyqwObsvgc9ZX2c/rdy70vi4UD4/RTa1eCynszf2UuECicDS37FMXPX0bXrpkLqjrZx
 ApuOBLex
 e5oJBR4JUkfzESoRZP1v4vvMZoBrgiCMIYK3//D9/ME4e4iHmci0m4CUMX30tYKJ2cl4WUVQIgheNkCCIWWjjYfnqdqGs5lBGKHXuunDlmjhrFwf7ZrAGoNTCtLF4q1mL4n6Uf6AlKzs8nCIC6xzCGiBovubpZaGT7j7aGf86EXUJ3SkP0hSDwdLwjJHBiLV1x3RfKPkZYWiFMklYXosSNE4keoNBnYQQ1Ikmqzg1Zvj4IokTbl4IjjrqUXF7oeENKZLr8Tnj6pKyTT0Nty22c1prZuyb2O8TEFFmHbowYWuxuUWIlobPOElswC/hC1VSkkEOZnDd/P3Pa4boF/HsvJzbJA1ucfmep/bqfxC8U+TS+tI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 08:36, Dev Jain wrote:
> Simplify try_to_unmap_one by separating out the hugetlb parts into
> try_to_unmap_hugetlb_one.
> 
> To understand the correctness of the refactoring, the following points
> are noted:
> 
> 1. try_to_unmap() is called for hugetlb folios only when they are
>    hwpoisoned.

Ack

> 
> 2. A hugetlb VMA cannot be mlocked.

Ack

> 
> 3. The pvmw API sets pvmw.pte to the base of the hugetlb folio (pvmw.pmd
>    is NULL).

Ack

> 
> 4. We won't ever process a softleaf entry that encodes a hugetlb folio;
>    hugetlb folios are never swapped out, migration entries will be skipped
>    (PVMW_MIGRATION not passed) and device-exclusive does not work for
>    hugetlb.

Ack, we should always find present entries.

> 
> 5. uffd-wp bit is lost when converting pvmw.pte to hwpoison softleaf
>    (therefore no need to call pte_install_uffd_wp_if_needed after
>    clearing pvmw.pte)

Are you sure? And if so, can you elaborate why + document?


> 
> 6. TTU_HWPOISON is always present; for it to not be present, either folio
>    has to be in swapcache, or mapping_can_writeback() is true (see
>    unmap_poisoned_folio), none of which is true for hugetlb folios.

Agreed. That's one very confusing bit in the existing code.

> 
> 7. hugetlb uses separate counters from normal rss counters, therefore
>    update_highwater_rss() need not be called.

Ack.

> 
> While at it:
> 
>  - Change VM_BUG_* to VM_WARN_*.
> 
>  - Do not declare variables which are only used once
> 
>  - Assert that the subpage derived by the pvmw walk is exactly the head
>    page. This is because try_to_unmap() does not remember the specific
>    subpage which was hwpoisoned, and, since we cannot munmap/mremap
>    across a hugetlb folio partially, the first pte mapping the hugetlb
>    folio (in case of a contpte or contpmd mapped folio) cannot ever point
>    to an intermediate page.

Might want to add a Suggested-by:, so people know directly whom to blame :)

I am very much in favor of decoupling both things cleanly, instead of hacking it
together and make the code all big and confusing.

> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c | 203 ++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 121 insertions(+), 82 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 430c91c8fe2ae..06ab1158d4cd1 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1978,6 +1978,121 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>  				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>  }
>  
> +static bool __try_to_unmap_hugetlb_one(struct folio *folio,
> +		struct vm_area_struct *vma, struct page_vma_mapped_walk *pvmw,
> +		struct mmu_notifier_range *range, enum ttu_flags flags)
> +{
> +	unsigned long hsz = huge_page_size(hstate_vma(vma));

Can be const.

> +	unsigned long address = pvmw->address;

Can be const. But do we even need the temporary variable?

> +	struct mm_struct *mm = vma->vm_mm;
> +	struct page *subpage;

a) subpages do not exist. It's just a folio page.
b) subpages are irrelevant for hugetlb, just drop anything that deals with them.

> +	bool ret = true;
> +	pte_t pteval;
> +

Worth adding a comment here, why we don't need a loop.

/* There is only a single mapping in a VMA. */

> +	if (!page_vma_mapped_walk(pvmw))
> +		return true;
> +
> +	pteval = ptep_get(pvmw->pte);

Should we now properly use huge_ptep_get()?

> +	VM_WARN_ON(!pte_present(pteval));
> +	subpage = folio_page(folio, pte_pfn(pteval) - folio_pfn(folio));

No need for subpages.

> +	VM_WARN_ON(folio_page(folio, 0) != subpage);

	VM_WARN_ON(pte_pfn(pteval) != folio_pfn(folio));


I assume both can be VM_WARN_ON_ONCE()

> +
> +	/*
> +	 * huge_pmd_unshare may unmap an entire PMD page. There is no way of
> +	 * knowing exactly which PMDs may be cached for this mm, so we must
> +	 * flush them all. start/end were already adjusted above to cover this
> +	 * range.
> +	 */
> +	flush_cache_range(vma, range->start, range->end);
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
> +		if (huge_pmd_unshare(&tlb, vma, address, pvmw->pte)) {
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
> +	pteval = huge_ptep_clear_flush(vma, address, pvmw->pte);
> +	if (pte_dirty(pteval))

Should we now use huge_pte_dirty() for consistency?

> +		folio_mark_dirty(folio);
> +
> +	VM_WARN_ON(!(flags & TTU_HWPOISON));

This should be checked right at the very beginning of try_to_unmap_hugetlb_one().

> +	pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
> +	hugetlb_count_sub(folio_nr_pages(folio), mm);
> +	set_huge_pte_at(mm, address, pvmw->pte, pteval, hsz);
> +	hugetlb_remove_rmap(folio);
> +	folio_put_refs(folio, 1);
> +
> +walk_done:
> +	page_vma_mapped_walk_done(pvmw);
> +	return ret;
> +}
> +
> +static bool try_to_unmap_hugetlb_one(struct folio *folio,
> +		struct vm_area_struct *vma, unsigned long address, void *arg)
> +{
> +	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
> +	struct mmu_notifier_range range;
> +	enum ttu_flags flags = (enum ttu_flags)(long)arg;
> +	bool ret;
> +
> +	/*
> +	 * The try_to_unmap() is only passed a hugetlb folio in the case
> +	 * where the hugetlb folio contains a poisoned page.
> +	 */
> +	VM_WARN_ON_FOLIO(!folio_contain_hwpoisoned_page(folio), folio);

As discussed, I'd prefer to just have folio_test_hwpoison() here.

> +
> +	/*
> +	 * When racing against e.g. zap_pte_range() on another cpu,
> +	 * in between its ptep_get_and_clear_full() and folio_remove_rmap_*(),
> +	 * try_to_unmap() may return before folio_mapped() has become false,
> +	 * if page table locking is skipped: use TTU_SYNC to wait for that.
> +	 */

The comment should be updated to mention hugetlb primitives ... but

... it's a good question whether that is required *at all* ...

> +	if (flags & TTU_SYNC)
> +		pvmw.flags = PVMW_SYNC;

... and in fact, looking at page_vma_mapped_walk(), PVMW_SYNC is irrelevant.

> +
> +	/*
> +	 * For hugetlb, it could be much worse than THP if we need pud
> +	 * invalidation in the case of pmd sharing.

I don't understand that comment. Is it really helpful?

> +	 *
> +	 * Note that the folio can not be freed in this function as call of

"cannot" ?

> +	 * try_to_unmap() must hold a reference on the folio.
> +	 */

Do we really need this comment entirely? We don't even look at the folio after
unmapping it.

> +	range.end = vma_address_end(&pvmw);
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
> +				address, range.end);
> +	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
> +	mmu_notifier_invalidate_range_start(&range);
> +	ret = __try_to_unmap_hugetlb_one(folio, vma, &pvmw, &range,
> +					 flags);

Is it really worth it moving that stuff to a separate function?


> +	mmu_notifier_invalidate_range_end(&range);
> +	return ret;
> +}
> +


-- 
Cheers,

David

