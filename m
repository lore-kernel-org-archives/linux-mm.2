Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 900C1CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 08:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781986B008A; Tue, 23 Jun 2026 04:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7584D6B009F; Tue, 23 Jun 2026 04:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66E6D6B00A1; Tue, 23 Jun 2026 04:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 36E2B6B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:40:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B550C1203E1
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:40:39 +0000 (UTC)
X-FDA: 84910531398.30.6B55559
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8304540007
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:40:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AotjKw9x;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782204037;
	b=ARQYy65i4AlGxOZGkzB1RNu9m8Eifd3rM509feTvmFUSTW6WIslCLl+bC5DXx1TyLeVhBC
	bxL4JGPFTz8VvkKZd843AWPRuinu4jzZDa+MnWXnHoyi0sNp29E5jk60esBEJmv1oU3A1B
	boaXRLHgbvjon1oN8ft7snoz0A5gM6U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782204037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TackL0w4O3TSZZvsVLHQSU3GftCmhECUyDnGn5lnbS0=;
	b=L/Ehmozjb6lpozQ+8NmyIwyFMrQV3dMshajFP2Us7Svk/lcxb7xL4/bSiBTyTA4o1ckvBK
	yCx7/WrMVylco3nhw9bLf38mgrgDA0GOmZhGgrF4AHrRo19hdgEzPN96E7MoejRfMbwHur
	zGQVzS8BTgs4tVCH4o+0E75hRQ0UZ1E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AotjKw9x;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 53BB51A25;
	Tue, 23 Jun 2026 01:40:31 -0700 (PDT)
Received: from [10.164.19.14] (unknown [10.164.19.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 71B8C3F632;
	Tue, 23 Jun 2026 01:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782204035; bh=XiQydRpXwl93K+PWXATZ3/FDrqkrMfjR/B392rLxffs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AotjKw9xPe0WVaX1GDgz+vOkiKuQ4wzcnl9b3lfkGoXVBWXxpPAxu3zLWAs3YvjLN
	 1X8SZUwFHc90/zc52SJ8oGEkXeGzN0dvIz2DAblavC4eCULY+YoxGOFWtgUxCzxwDP
	 q4ggwyZiRsVCsI6Ds+xPPeFvFMBUUI5/OlVrS61Y=
Message-ID: <6a85489f-8b26-4c4b-8333-38f8ae1b680a@arm.com>
Date: Tue, 23 Jun 2026 14:10:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] mm/rmap: Add try_to_unmap_hugetlb_one
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, chrisl@kernel.org, kasong@tencent.com, hughd@google.com,
 liam@infradead.org
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
 <ee0d499c-de98-4860-bfd0-0bce0b4c1bdc@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <ee0d499c-de98-4860-bfd0-0bce0b4c1bdc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 1b4g531jttpyxc5gfhda1iba5pj46yhe
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8304540007
X-HE-Tag: 1782204036-337827
X-HE-Meta: U2FsdGVkX19Z0BX6DxHPy0em2GNRaph7l7fp0YB0laz/cQlSDCqR57wqwJR6xoGEVPW8V1J3QmdrT2lHjydwiDHjrN15UBDuR2P5YlXAgM37ajcqatpcBmNNOgcj2goadfNoWm50agXJy1tqCeqnCvmuMsh4XYz6vrDRTbv3P+0sHd33mI9N4g1pGIbb4NMc8uAWwoXNbe0GS6z9BSsjxXpuOLR40QUTYZup7ERmvNT8zWuwvSZJrnWj0EYdgXcCZn2XGPpI1JJtb5ZYXozqa3qoQ55xPYS1q+X+LQbF8ydbA1MCkSznZ8DTAsB/AYmbDuQ5GhaGDNoE/qQGr5G1s3Y7JjupYZ5rO9aaV2OIXd/7fsIYnoGpSdLgKUvEpuwdZ/aeaHt5L916z26WNamaDfGpgWnzENgxpxSa4a5zpPkPxvBpi2OGHIov8dJyIi4It0zIRt7JwLTc6Gh7jlZLw/bYtmJyFG5C6UDXVEd5BCMSy8r7tbKhcM3Yr8zQ58Nxx3WqPuH+akxLKEoMQsZNvipaSQeqU7aY8BgGiDmuWTxpgoEGHZdnb7UnzxLk/q3n+CTfJgvibt2fdlB2/r0e+BLDVZx9YLmPSpDW9BzXFUcvDCqeWZAX+gzW+far+NQzm9xq/TmBnZIuVICIjxcfHgl5ps5ltzcNdZxj3Cv/RcTRPV93uMuKDuHus5saf+IEXbkJHT87hnrpVAaSfebC2CAEEnOSCqGn0UrjDJp6cRKS0V8LeeYd0At+x2ZNfZxXKjJnqSwwKLvjcepnZakV1xJwE/K4pZKgYLNli8lKEJ8zj/7+8idV9WR2OLwvBaNyoQs69P83LjJvX+8yjUDTeoZa1nbrmn98bLdPPn9TZZHMc4EQhzp4mr20g4BN6k7KO2UWtG0N1jFfsIZMhzOd+S36jeNhAv86iKrKFOLyakmxh/TpNHDCNPR7SvUrvmrOeo9mhsqNBK5nLQWQ15w
 bJldbVf0
 SaRzAK53DbRaIGUmUsbs5A3rNT2ldLtCJjvlJz/V5ew7EdAmZeRnYM+0Ua7PEl7jDOa1MrxjnhN8dEetPHntvhn/YVjH8R1qMxmkgaZdhFeazxpsNAOxc7XUCoH0fHuKIA+4Wfyvki3yp4GzhJPj10ln8WtOshI5YHeZcJzrHbGeracPXCRPnVKJCuouxlSDktPWPSjXzz4F79RoSYuiy1xB29YJecDjKdWK7/vlSsX1yAEN1q0Idn3igV3q/3Ae28qkg23qcpgxUshYUzTLEOsmAdpIxRQzN/KDWbkYiBYrjTpn+Ts5u0YYt9OoTrGTfsgLen9NeHIz3y1469WqE/EF5lA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/06/26 7:46 pm, David Hildenbrand (Arm) wrote:
> On 5/26/26 08:36, Dev Jain wrote:
>> Simplify try_to_unmap_one by separating out the hugetlb parts into
>> try_to_unmap_hugetlb_one.
>>
>> To understand the correctness of the refactoring, the following points
>> are noted:
>>
>> 1. try_to_unmap() is called for hugetlb folios only when they are
>>    hwpoisoned.
> 
> Ack
> 
>>
>> 2. A hugetlb VMA cannot be mlocked.
> 
> Ack
> 
>>
>> 3. The pvmw API sets pvmw.pte to the base of the hugetlb folio (pvmw.pmd
>>    is NULL).
> 
> Ack
> 
>>
>> 4. We won't ever process a softleaf entry that encodes a hugetlb folio;
>>    hugetlb folios are never swapped out, migration entries will be skipped
>>    (PVMW_MIGRATION not passed) and device-exclusive does not work for
>>    hugetlb.
> 
> Ack, we should always find present entries.
> 
>>
>> 5. uffd-wp bit is lost when converting pvmw.pte to hwpoison softleaf
>>    (therefore no need to call pte_install_uffd_wp_if_needed after
>>    clearing pvmw.pte)
> 
> Are you sure? And if so, can you elaborate why + document?

If you see the current code, we construct pteval from the subpage, losing any
bit state of the previous entry. Also it doesn't make sense anyways to keep
uffd-wp for an hwpoisoned entry.
> 
> 
>>
>> 6. TTU_HWPOISON is always present; for it to not be present, either folio
>>    has to be in swapcache, or mapping_can_writeback() is true (see
>>    unmap_poisoned_folio), none of which is true for hugetlb folios.
> 
> Agreed. That's one very confusing bit in the existing code.
> 
>>
>> 7. hugetlb uses separate counters from normal rss counters, therefore
>>    update_highwater_rss() need not be called.
> 
> Ack.
> 
>>
>> While at it:
>>
>>  - Change VM_BUG_* to VM_WARN_*.
>>
>>  - Do not declare variables which are only used once
>>
>>  - Assert that the subpage derived by the pvmw walk is exactly the head
>>    page. This is because try_to_unmap() does not remember the specific
>>    subpage which was hwpoisoned, and, since we cannot munmap/mremap
>>    across a hugetlb folio partially, the first pte mapping the hugetlb
>>    folio (in case of a contpte or contpmd mapped folio) cannot ever point
>>    to an intermediate page.
> 
> Might want to add a Suggested-by:, so people know directly whom to blame :)

Sure.

> 
> I am very much in favor of decoupling both things cleanly, instead of hacking it
> together and make the code all big and confusing.
> 
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/rmap.c | 203 ++++++++++++++++++++++++++++++++----------------------
>>  1 file changed, 121 insertions(+), 82 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 430c91c8fe2ae..06ab1158d4cd1 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1978,6 +1978,121 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>  				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>>  }
>>  
>> +static bool __try_to_unmap_hugetlb_one(struct folio *folio,
>> +		struct vm_area_struct *vma, struct page_vma_mapped_walk *pvmw,
>> +		struct mmu_notifier_range *range, enum ttu_flags flags)
>> +{
>> +	unsigned long hsz = huge_page_size(hstate_vma(vma));
> 
> Can be const.

Ok.

> 
>> +	unsigned long address = pvmw->address;
> 
> Can be const. But do we even need the temporary variable?

It is being used 3 times in this function, so temporary variable is fine.

> 
>> +	struct mm_struct *mm = vma->vm_mm;
>> +	struct page *subpage;
> 
> a) subpages do not exist. It's just a folio page.
> b) subpages are irrelevant for hugetlb, just drop anything that deals with them.

Ok.

> 
>> +	bool ret = true;
>> +	pte_t pteval;
>> +
> 
> Worth adding a comment here, why we don't need a loop.
> 
> /* There is only a single mapping in a VMA. */

Ok.

> 
>> +	if (!page_vma_mapped_walk(pvmw))
>> +		return true;
>> +
>> +	pteval = ptep_get(pvmw->pte);
> 
> Should we now properly use huge_ptep_get()?

Sending a series to fix this soon : )

> 
>> +	VM_WARN_ON(!pte_present(pteval));
>> +	subpage = folio_page(folio, pte_pfn(pteval) - folio_pfn(folio));
> 
> No need for subpages.

Ok.

> 
>> +	VM_WARN_ON(folio_page(folio, 0) != subpage);
> 
> 	VM_WARN_ON(pte_pfn(pteval) != folio_pfn(folio));
> 
> 
> I assume both can be VM_WARN_ON_ONCE()

Ok.

> 
>> +
>> +	/*
>> +	 * huge_pmd_unshare may unmap an entire PMD page. There is no way of
>> +	 * knowing exactly which PMDs may be cached for this mm, so we must
>> +	 * flush them all. start/end were already adjusted above to cover this
>> +	 * range.
>> +	 */
>> +	flush_cache_range(vma, range->start, range->end);
>> +
>> +	/*
>> +	 * To call huge_pmd_unshare, i_mmap_rwsem must be held in write mode.
>> +	 * Caller needs to explicitly do this outside rmap routines.
>> +	 *
>> +	 * We also must hold hugetlb vma_lock in write mode. Lock order dictates
>> +	 * acquiring vma_lock BEFORE i_mmap_rwsem. We can only try lock here and
>> +	 * fail if unsuccessful.
>> +	 */
>> +	if (!folio_test_anon(folio)) {
>> +		struct mmu_gather tlb;
>> +
>> +		VM_WARN_ON(!(flags & TTU_RMAP_LOCKED));
>> +		if (!hugetlb_vma_trylock_write(vma)) {
>> +			ret = false;
>> +			goto walk_done;
>> +		}
>> +
>> +		tlb_gather_mmu_vma(&tlb, vma);
>> +		if (huge_pmd_unshare(&tlb, vma, address, pvmw->pte)) {
>> +			hugetlb_vma_unlock_write(vma);
>> +			huge_pmd_unshare_flush(&tlb, vma);
>> +			tlb_finish_mmu(&tlb);
>> +			/*
>> +			 * The PMD table was unmapped, consequently unmapping
>> +			 * the folio.
>> +			 */
>> +			goto walk_done;
>> +		}
>> +		hugetlb_vma_unlock_write(vma);
>> +		tlb_finish_mmu(&tlb);
>> +	}
>> +	pteval = huge_ptep_clear_flush(vma, address, pvmw->pte);
>> +	if (pte_dirty(pteval))
> 
> Should we now use huge_pte_dirty() for consistency?

Ok.

> 
>> +		folio_mark_dirty(folio);
>> +
>> +	VM_WARN_ON(!(flags & TTU_HWPOISON));
> 
> This should be checked right at the very beginning of try_to_unmap_hugetlb_one().

Ok.

> 
>> +	pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
>> +	hugetlb_count_sub(folio_nr_pages(folio), mm);
>> +	set_huge_pte_at(mm, address, pvmw->pte, pteval, hsz);
>> +	hugetlb_remove_rmap(folio);
>> +	folio_put_refs(folio, 1);
>> +
>> +walk_done:
>> +	page_vma_mapped_walk_done(pvmw);
>> +	return ret;
>> +}
>> +
>> +static bool try_to_unmap_hugetlb_one(struct folio *folio,
>> +		struct vm_area_struct *vma, unsigned long address, void *arg)
>> +{
>> +	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
>> +	struct mmu_notifier_range range;
>> +	enum ttu_flags flags = (enum ttu_flags)(long)arg;
>> +	bool ret;
>> +
>> +	/*
>> +	 * The try_to_unmap() is only passed a hugetlb folio in the case
>> +	 * where the hugetlb folio contains a poisoned page.
>> +	 */
>> +	VM_WARN_ON_FOLIO(!folio_contain_hwpoisoned_page(folio), folio);
> 
> As discussed, I'd prefer to just have folio_test_hwpoison() here.

Ok.

> 
>> +
>> +	/*
>> +	 * When racing against e.g. zap_pte_range() on another cpu,
>> +	 * in between its ptep_get_and_clear_full() and folio_remove_rmap_*(),
>> +	 * try_to_unmap() may return before folio_mapped() has become false,
>> +	 * if page table locking is skipped: use TTU_SYNC to wait for that.
>> +	 */
> 
> The comment should be updated to mention hugetlb primitives ... but
> 
> ... it's a good question whether that is required *at all* ...
> 
>> +	if (flags & TTU_SYNC)
>> +		pvmw.flags = PVMW_SYNC;
> 
> ... and in fact, looking at page_vma_mapped_walk(), PVMW_SYNC is irrelevant.

You are right, I'll drop this.

> 
>> +
>> +	/*
>> +	 * For hugetlb, it could be much worse than THP if we need pud
>> +	 * invalidation in the case of pmd sharing.
> 
> I don't understand that comment. Is it really helpful?
> 
>> +	 *
>> +	 * Note that the folio can not be freed in this function as call of
> 
> "cannot" ?
> 
>> +	 * try_to_unmap() must hold a reference on the folio.
>> +	 */
> 
> Do we really need this comment entirely? We don't even look at the folio after
> unmapping it.

Yeah I just blindly copied it, looks like historical baggage, I can't understand
that comment at all. I'll drop it entirely.

> 
>> +	range.end = vma_address_end(&pvmw);
>> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
>> +				address, range.end);
>> +	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
>> +	mmu_notifier_invalidate_range_start(&range);
>> +	ret = __try_to_unmap_hugetlb_one(folio, vma, &pvmw, &range,
>> +					 flags);
> 
> Is it really worth it moving that stuff to a separate function?

I derive pleasure in a code style of:

foo():
  lock/start
  __foo()
  unlock/end

Although, I think this is entirely pointless here since foo() has barely
anything apart from __foo(), and that __foo() has 5 function parameters.
So I'll collapse into a single function.
> 
> 
>> +	mmu_notifier_invalidate_range_end(&range);
>> +	return ret;
>> +}
>> +
> 
> 


