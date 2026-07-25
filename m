Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B47B6C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 08:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B9B66B007B; Sat, 25 Jul 2026 04:47:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4426A6B0088; Sat, 25 Jul 2026 04:47:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E68A6B008A; Sat, 25 Jul 2026 04:47:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F31E66B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 04:47:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 890761C01B4
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 08:47:12 +0000 (UTC)
X-FDA: 85026669504.24.18ABA58
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 06A5040003
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 08:47:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="P/BgrQJP";
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784969230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phNMYP4wd4VKuWSyDPGynjwEzxMLIHaRG+h/Iejm1Fc=;
	b=fk7eFV3fS0AKmNuk3h2VEYpzovzNP5sku26NpsO5EdPktkW6RmhfwrRj8CrutPWWON+CoS
	omg0TX39yjZ0oIAQ690O/pqa6YJv2p7Wg2/FQ+8Rd8kQiVORHzzsG/E6LxpHvjvL8Zuqzw
	OYsW7iWUYkuMq/sk0DUDafjwwPMPq30=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="P/BgrQJP";
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784969230;
	b=gzAbiFhepn7Rk8iyVNON6D8YfI/T7FmMEw7vvjmzunJFtOx7Q3b5YNdbxGsQR9UDPMEXXo
	wOQfs7vVva4wceanVY3z18S1iaZxO+nebNh7H5NfXoWk2VxtTqe+XceEhY/jYQjdQINB/e
	b7sgd1+KVNMASKM+GMr1T29BWKBVbRA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 424361476;
	Sat, 25 Jul 2026 01:47:04 -0700 (PDT)
Received: from [10.164.11.99] (unknown [10.164.11.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 66A033F66F;
	Sat, 25 Jul 2026 01:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784969228; bh=JC7qvFm13x/JBcoWe4Ge2Uk8md7NPQHh5D8CPqqOWeg=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=P/BgrQJPY+N+00IjjUMF3tT6dlnhJXUrLOJ6N1Lo0/36c/Cz9vpxhHDw7uLP8XjB+
	 W4d9g/8DtC9ErkX37v/i0TApBtP/DlasdCa6MHvxvpmcNSU5rQywwrUwcX+/u0MAHn
	 FIssAu/dNRiz31qXWsZaJ9AzPT5uayXh1m+lT8ZI=
Message-ID: <91d4a218-3afb-487a-956a-f9fd7f67e5eb@arm.com>
Date: Sat, 25 Jul 2026 14:17:01 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Dev Jain <dev.jain@arm.com>
Subject: Re: [PATCH v3 2/5] mm/rmap: Add try_to_unmap_hugetlb_one
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
 osalvador@suse.de, riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260713050050.1017741-1-dev.jain@arm.com>
 <20260713050050.1017741-3-dev.jain@arm.com> <amMyhkFX6Dj1UqJD@lucifer>
Content-Language: en-US
In-Reply-To: <amMyhkFX6Dj1UqJD@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 06A5040003
X-Stat-Signature: mu46ze3giw6ynfzjnythmx9pon3rzeg4
X-HE-Tag: 1784969229-567261
X-HE-Meta: U2FsdGVkX19z64G1CSiJkwxryhTJ2m2VJmkEgSzjBZjs1EUGAH8Uhv6zjJa/UFmXDTY4YDkzjFub7leFM/UmpGaLDhclNWjl8geQrCREx/ltTz7wXI8GG21bGqZVkt9SnzpZfqPIG2BXqxD1VHu/K3hYzC3yXRg7RL9oC08gvoWv04I4n+bvLUkNcJHkw4Gbu275oDi0h2sDh+k2jKuBR+n5qCd8sUTJcChqjZQewhrv9hQlNU+ivaIOoUZTjgGOCWGo1gVPO2f8n864hsvrF8bkMQPF3N8rhhZsrU3eHFXO3Ar0Cncnl8G5pfVBwKqZTj8mrZdZxXVZy85vVfKAT39O8ErRpdQH6YGxxYS//XlIOHcHmqA693DKqw8tCqdZzuSWmudL76zwJjLPoSMxoDHynvzpI/KrD+1F1vuJ9nnO+ERgdeyJFE24+sXxNeO+3X/YWNsCZOI9whoG2DDcj8Cadr9gLMD9Rx0pjBmyclO3BLpyJK6rgvnHLIikT/yjvUjB3BQv0bPKmA0RP7L/Ta5m7EMsAxCoPNj/j7EoPpQgyCCPLQLiyVH2ME+/lksuNnm1ECkiQSQsOgtqed2w73EKKEF/7LgOg85d3edpC8p4fh1MqIqWTB8MPbTIDaWO+wUBduOzzFmVTlWHD136Obt5xv1X/j2d5ShXqrv02kBO4zri1pnN06kQXbO6P5o7SDZ0BI96DSJ70aGjzkaU2g+2KfsGvLVAukVunAVZZ0pk1VQ7AUPC6Qz5NWuEKDVGdP/IDi0N7dqHiMmptEasjSosBWnMTKq02upeqlEdFszKm4dId6vKtQD/CH3W55t6FE3Z2OdIGS6SC4xZIlfVXEJipOO3Jwgirn0JAjWx9Y8Tkw2UvhfiHNAiy5lE983c5hfGbUtuVhySj2NpdDLSIzQl5dpp1Ma08rO7TtoCkdFbHw1P2kXEx0uUmNZY490PdgZW3pcWLZ7dhNVWepV
 suyhBT0y
 BWuyDTKhWSE79xsMPZ9Wwst/PIS2ZkaInbT+3LWoCQ7QrBrWUaptKgJorg1knW3KqMj5RRqH6M/Jw5llYjpjzjwyF+FbQrT18zDvPcbQf6e0fxuZ7rFf4hQujG/LA1QdbiIoW1+DVoJhRgbyQgVoTGIRXrXm2a+R59h5cNRfxLAlu6Yvm2KHlkgTVSR/SWSGhsU4Y1VLihHq//Jf8tj9CTLjIli2c5Tny2lx6OFFpG8LJ92VN9LPP7vNTU/3umi7xHckAJ43LBZpv0+e/LrewDDHjvbBvwEsMm0spBZwNLNVEwkEYcxSZD2CXsJSiO9AlCG7k0vMYiDZ9C/kdP42PRSOLVhSkDrukqS0oFmr9w6fPzEi+2YvRtYq9lA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/07/26 4:09 pm, Lorenzo Stoakes (ARM) wrote:
> On Mon, Jul 13, 2026 at 05:00:45AM +0000, Dev Jain wrote:
>> Simplify try_to_unmap_one() by separating the hugetlb parts into
>> try_to_unmap_hugetlb_one().
> 
> I hate that we have this separate hugetlb stuff but while we have it,
> better to be explicit :)
> 
>>
>> To understand the correctness of the refactoring, the following points
>> are noted:
>>
>> 1. try_to_unmap() is called for hugetlb folios only when they are
>>    hwpoisoned.
>>
>> 2. A hugetlb VMA cannot be mlocked.
>>
>> 3. page_vma_mapped_walk() returns at most one hugetlb mapping in a VMA,
>>    and that mapping points at the head PFN.
>>
>> 4. We won't ever process a softleaf entry that encodes a hugetlb folio;
>>    hugetlb folios are never swapped out, migration entries will be
>>    skipped (PVMW_MIGRATION not passed), and device-exclusive does not
>>    work for hugetlb.
>>
>> 5. The hwpoison entry is constructed from the poisoned folio, just as in
>>    the pre-refactor code. Any previous uffd-wp state is deliberately not
>>    preserved for the hwpoison entry.
>>
>> 6. TTU_HWPOISON is always present; for it to not be present, either the
>>    folio has to be in swapcache, or mapping_can_writeback() is true (see
>>    unmap_poisoned_folio), none of which is true for hugetlb folios.
>>
>> 7. Hugetlb uses separate counters from normal rss counters, therefore
>>    update_highwater_rss() need not be called.
> 
> I wonder whether you could bundle some of this up into a comment around
> try_to_unmap_hugetlb_one()?

I don't think that is going to simplify things. All of the above mentioned
stuff is obvious if you know you are looking at hugetlb code, but isn't
obvious when the hugetlb bits are tangled with non-hugetlb, that is why
I had to mention all of these points.

> 
>>
>> While at it:
>>
>>  - Change VM_BUG_* to VM_WARN_*.
>>
>>  - Do not declare variables which are only used once.
>>
>>  - Constify some variables.
>>
>>  - Add some more VM_WARN_* to assert some invariants.
>>
>> Except the above 4 points, no functional change intended.
>>
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> 
> A bunch of nits but those addressed LGTM:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
> Thanks very much for doing this is a big improvement!

Thanks. I remember two years back looking at try_to_unmap_one and
thinking what the hell is this :) getting to refactor it almost
feels cathartic.

> 
>> ---
>>  include/linux/hugetlb.h |   1 +
>>  mm/rmap.c               | 183 +++++++++++++++++++++-------------------
>>  2 files changed, 98 insertions(+), 86 deletions(-)
>>
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 4115076e4922a..bf7e163e3779d 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -1271,6 +1271,7 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
>>  }
>>
>>  pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
>> +unsigned long huge_pte_dirty(pte_t pte);
>>
>>  static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
>>  					  unsigned long addr, pte_t *ptep)
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 2b74668f356d6..7720c49ada4c3 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1978,6 +1978,96 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>  				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>>  }
>>
>> +static bool try_to_unmap_hugetlb_one(struct folio *folio,
>> +		struct vm_area_struct *vma, unsigned long address, void *arg)
>> +{
>> +	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
>> +	const unsigned long hsz = huge_page_size(hstate_vma(vma));
>> +	const enum ttu_flags flags = (enum ttu_flags)(long)arg;
>> +	struct mm_struct *mm = vma->vm_mm;
>> +	struct mmu_notifier_range range;
>> +	bool ret = true;
>> +	pte_t pteval;
>> +
>> +	/*
>> +	 * The try_to_unmap() is only passed a hugetlb folio in the case
>> +	 * where the hugetlb folio is poisoned.
>> +	 */
> 
> I wonder if the function should be try_to_unmap_poisoned_hugetlb_one() as a
> result?

I can, no strong opinion here.


> 
>> +	VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
> 
> NIT: Should be VM_WARN_ON_ONCE_FOLIO() for consistency with below and to avoid
> repeated warnings?

Ok.

> 
>> +	VM_WARN_ON_ONCE(!(flags & TTU_HWPOISON));
>> +
>> +	range.end = vma_address_end(&pvmw);
>> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
>> +				address, range.end);
>> +	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
>> +	mmu_notifier_invalidate_range_start(&range);
>> +
>> +	/* There is only a single mapping in a VMA. */
>> +	if (!page_vma_mapped_walk(&pvmw))
>> +		goto range_end;
>> +
>> +	VM_WARN_ON_ONCE(address != pvmw.address);
>> +
>> +	pteval = huge_ptep_get(mm, address, pvmw.pte);
>> +	VM_WARN_ON_ONCE(!pte_present(pteval));
>> +	VM_WARN_ON_ONCE(pte_pfn(pteval) != folio_pfn(folio));
> 
> I guess no TTU_SYNC is possible for hugetlb poison unmap?

Yes.


> 
>> +
>> +	/*
>> +	 * huge_pmd_unshare may unmap an entire PMD page. There is no way of
>> +	 * knowing exactly which PMDs may be cached for this mm, so we must
>> +	 * flush them all. start/end were already adjusted above to cover this
>> +	 * range.
>> +	 */
>> +	flush_cache_range(vma, range.start, range.end);
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
> 
> VM_WARN_ON_ONCE()?

Okay.


> 
>> +		if (!hugetlb_vma_trylock_write(vma)) {
> 
> How I hate that hugetlb calls their lock a 'VMA lock'...
> 
>> +			ret = false;
>> +			goto walk_done;
>> +		}
>> +
>> +		tlb_gather_mmu_vma(&tlb, vma);
>> +		if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
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
>> +	pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
>> +	if (huge_pte_dirty(pteval))
>> +		folio_mark_dirty(folio);
>> +
>> +	pteval = swp_entry_to_pte(make_hwpoison_entry(folio_page(folio, 0)));
>> +	hugetlb_count_sub(folio_nr_pages(folio), mm);
>> +	set_huge_pte_at(mm, address, pvmw.pte, pteval, hsz);
>> +	hugetlb_remove_rmap(folio);
>> +	folio_put_refs(folio, 1);
> 
> Do we want an assert here somehow that we are only walking one folio?

I did not get you. For the try_to_* family in rmap.c, everywhere we
walk only one folio don't we?


> 
>> +
>> +walk_done:
>> +	page_vma_mapped_walk_done(&pvmw);
>> +range_end:
>> +	mmu_notifier_invalidate_range_end(&range);
>> +	return ret;
>> +}
>> +
>>  /*
>>   * @arg: enum ttu_flags will be passed to this argument
>>   */
>> @@ -1993,7 +2083,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  	enum ttu_flags flags = (enum ttu_flags)(long)arg;
>>  	unsigned long nr_pages = 1, end_addr;
>>  	unsigned long pfn;
>> -	unsigned long hsz = 0;
>>  	int ptes = 0;
>>
>>  	/*
>> @@ -2007,8 +2096,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>
>>  	/*
>>  	 * For THP, we have to assume the worse case ie pmd for invalidation.
>> -	 * For hugetlb, it could be much worse if we need to do pud
>> -	 * invalidation in the case of pmd sharing.
>>  	 *
>>  	 * Note that the folio can not be freed in this function as call of
>>  	 * try_to_unmap() must hold a reference on the folio.
>> @@ -2016,17 +2103,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  	range.end = vma_address_end(&pvmw);
>>  	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
>>  				address, range.end);
>> -	if (folio_test_hugetlb(folio)) {
>> -		/*
>> -		 * If sharing is possible, start and end will be adjusted
>> -		 * accordingly.
>> -		 */
>> -		adjust_range_if_pmd_sharing_possible(vma, &range.start,
>> -						     &range.end);
>> -
>> -		/* We need the huge page size for set_huge_pte_at() */
>> -		hsz = huge_page_size(hstate_vma(vma));
>> -	}
>>  	mmu_notifier_invalidate_range_start(&range);
>>
>>  	while (page_vma_mapped_walk(&pvmw)) {
>> @@ -2111,66 +2187,13 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  			const softleaf_t entry = softleaf_from_pte(pteval);
>>
>>  			pfn = softleaf_to_pfn(entry);
>> -			VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
>>  		}
>>
>>  		subpage = folio_page(folio, pfn - folio_pfn(folio));
>>  		anon_exclusive = folio_test_anon(folio) &&
>>  				 PageAnonExclusive(subpage);
>>
>> -		if (folio_test_hugetlb(folio)) {
>> -			bool anon = folio_test_anon(folio);
>> -
>> -			/*
>> -			 * The try_to_unmap() is only passed a hugetlb folio
>> -			 * in the case where the hugetlb folio contains a
>> -			 * poisoned page.
>> -			 */
>> -			VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
>> -			/*
>> -			 * huge_pmd_unshare may unmap an entire PMD page.
>> -			 * There is no way of knowing exactly which PMDs may
>> -			 * be cached for this mm, so we must flush them all.
>> -			 * start/end were already adjusted above to cover this
>> -			 * range.
>> -			 */
>> -			flush_cache_range(vma, range.start, range.end);
>> -
>> -			/*
>> -			 * To call huge_pmd_unshare, i_mmap_rwsem must be
>> -			 * held in write mode.  Caller needs to explicitly
>> -			 * do this outside rmap routines.
>> -			 *
>> -			 * We also must hold hugetlb vma_lock in write mode.
>> -			 * Lock order dictates acquiring vma_lock BEFORE
>> -			 * i_mmap_rwsem.  We can only try lock here and fail
>> -			 * if unsuccessful.
>> -			 */
>> -			if (!anon) {
>> -				struct mmu_gather tlb;
>> -
>> -				VM_BUG_ON(!(flags & T][\TU_RMAP_LOCKED));
>> -				if (!hugetlb_vma_trylock_write(vma))
>> -					goto walk_abort;
>> -
>> -				tlb_gather_mmu_vma(&tlb, vma);
>> -				if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
>> -					hugetlb_vma_unlock_write(vma);
>> -					huge_pmd_unshare_flush(&tlb, vma);
>> -					tlb_finish_mmu(&tlb);
>> -					/*
>> -					 * The PMD table was unmapped,
>> -					 * consequently unmapping the folio.
>> -					 */
>> -					goto walk_done;
>> -				}
>> -				hugetlb_vma_unlock_write(vma);
>> -				tlb_finish_mmu(&tlb);
>> -			}
>> -			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
>> -			if (pte_dirty(pteval))
>> -				folio_mark_dirty(folio);
>> -		} else if (likely(pte_present(pteval))) {
>> +		if (likely(pte_present(pteval))) {
>>  			nr_pages = folio_unmap_pte_batch(folio, &pvmw, flags, pteval);
>>  			end_addr = address + nr_pages * PAGE_SIZE;
>>  			flush_cache_range(vma, address, end_addr);
>> @@ -2205,20 +2228,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  		/* Update high watermark before we lower rss */
>>  		update_hiwater_rss(mm);
>>
>> -		/*
>> -		 * With TTU_HWPOISON, we only expect small folios or hugetlb
>> -		 * folios here for now.
>> -		 */
>> +		/* With TTU_HWPOISON, we only expect small folios here. */
> 
> I mean you can further simplify the simplified version this way :)
> 
>>  		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
>>  			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
>> -			if (folio_test_hugetlb(folio)) {
>> -				hugetlb_count_sub(folio_nr_pages(folio), mm);
>> -				set_huge_pte_at(mm, address, pvmw.pte, pteval,
>> -						hsz);
>> -			} else {
>> -				dec_mm_counter(mm, mm_counter(folio));
>> -				set_pte_at(mm, address, pvmw.pte, pteval);
>> -			}
>> +			dec_mm_counter(mm, mm_counter(folio));
>> +			set_pte_at(mm, address, pvmw.pte, pteval);
>>  		} else if (likely(pte_present(pteval)) && pte_unused(pteval) &&
>>  			   !userfaultfd_armed(vma)) {
>>  			/*
>> @@ -2346,11 +2360,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
>>  		}
>>  discard:
>> -		if (unlikely(folio_test_hugetlb(folio))) {
>> -			hugetlb_remove_rmap(folio);
>> -		} else {
>> -			folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
>> -		}
>> +		folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
>>  		if (vma->vm_flags & VM_LOCKED)
>>  			mlock_drain_local();
>>  		folio_put_refs(folio, nr_pages);
>> @@ -2398,7 +2408,8 @@ static int folio_not_mapped(struct folio *folio)
>>  void try_to_unmap(struct folio *folio, enum ttu_flags flags)
>>  {
>>  	struct rmap_walk_control rwc = {
>> -		.rmap_one = try_to_unmap_one,
>> +		.rmap_one = folio_test_hugetlb(folio) ?
>> +				try_to_unmap_hugetlb_one : try_to_unmap_one,
>>  		.arg = (void *)flags,
>>  		.done = folio_not_mapped,
>>  		.anon_lock = folio_lock_anon_vma_read,
>> --
>> 2.43.0
>>
> 
> Cheers, Lorenzo


