Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9941DCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1103B6B00A0; Mon, 11 May 2026 04:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B6096B00A1; Mon, 11 May 2026 04:53:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0E846B00A2; Mon, 11 May 2026 04:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCAA66B00A0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:53:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC6771C1416
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:38 +0000 (UTC)
X-FDA: 84754525716.20.B0A0C1A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id B50B98000B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=B3tHl1Ie;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0mYDRl963X26o045d2lEYYbnsjlN5rtjKjwNDf/cOAk=;
	b=b1mhrAtFBugUyg73JIz0eDq9QszagdnZKuLGF4GMBsRcrkNbGBVYM5w0xmxKZ9EAKdaWIS
	oSvPTiPolnBqwEl6SVamkihIM8pYhemOotN70GG9IHXB5Bsem0hvVyequPL4M0dBCyKoTz
	Zk8lWEoLaweIZlAkmS63QfyA8W0rpzs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=B3tHl1Ie;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489616; a=rsa-sha256;
	cv=none;
	b=RwvDM0jajVozyZmyElffHnFj0dkRXT8ks65gVrs7x7lwlolKdleIWzJsFkgYhO8kSADRnC
	nx3fo0MemVKILCAh4l2aY2pVEuAfdQS24+a3dZKJJhiApLnZpbNdLxiTRwTl+mT4UUYs/n
	yiUZwC6q4AaciNNAhyB5dwOOGCvQqg8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D5D516F8;
	Mon, 11 May 2026 01:53:30 -0700 (PDT)
Received: from [10.164.148.37] (MacBook-Pro.blr.arm.com [10.164.148.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 819B53F7B4;
	Mon, 11 May 2026 01:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778489615; bh=qDtZ/JtcHu4vyZ/Et0OVI8IWYzPibJSvUK1IXLViM1I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=B3tHl1IeCHcp4XzrkCXVx1rqL/gUgtDrfbpv6Uf+D1Ir+p251ed1lDpwNrsmsFUA5
	 7l0zlTOt5PMDy7DZIqcL1Vv/oeE/inaJsIXnYHZY0ldf/PMEy20058G2a7A1yQLmyP
	 pl9mO8Od5//Oy1ppgdXsFHLMF+bv2lV4KqSIZNw0=
Message-ID: <d2f11bbd-93ec-4a7e-9de3-ed4541914ad9@arm.com>
Date: Mon, 11 May 2026 14:23:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/9] mm/rmap: refactor hugetlb pte clearing in
 try_to_unmap_one
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-3-dev.jain@arm.com>
 <5a4c3c3d-66c8-4ef6-bb6a-2ec0e32694a1@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <5a4c3c3d-66c8-4ef6-bb6a-2ec0e32694a1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B50B98000B
X-Rspamd-Server: rspam06
X-Stat-Signature: qyppms48jpuuj8zhkg8du8m5nn9pgzxr
X-HE-Tag: 1778489616-411783
X-HE-Meta: U2FsdGVkX1+zeIk4BqwSRWitKH54CqcrkvqBg3k94t6vIs8t9pC2FHYnciI8Hqu2oghBvSmC0OEEc9z4KOJ4eSaE5LWCH5787jpN1o3B3JTMFtBgF8jE1jYRGp68+uDWDXLFEUaQ41plxTayhX03/1po+ltE7KlXwQnQYNvOJZi7DIILub3MtoGlInlqojY7KBjyMswkmY6WTOPAt7Dgq4wF/bzHqR1D9/EkQ78axVYiF6Y6CJH1pQoho9YWwey3NNmBvRN6UdAMBbOBWEmC3YniuVWc4139+SbQoYKotvj/dHlP27uG32pS921tXWd5vECkVkOFUtuKsvBdkon5bwmxzbiSjNI7wfyPulPDgwyjGXK45Bsfribo6FRUz43JeTbb5pETq0uDV5VCgxVlXTZ2ENs2qn+l9+ZSA9GZyuzmL3lNaFMIF5B47cIdaqv7KcE2fLvjkbBmvWiCaaYHoJLcPa+jhyPESKVajCwCEABn5OwAAdpr1u7uv9J87wfjTlFnHPos5ZiB9gqc/wL9GbWCtm8qlAwS7YTb2NquuXTDJMl+AnZng6Gs3D75sVrmHgvDeeGYgxuzCiI0hnqTCmwV9x+lHIWU+VIYTNUBnYvKhKe4J+TVpKach71DTGwPLKdD8sT2cyGvg5YoD2hmiCjRufQ/mNOmAqR0eso/c5zwDVGRKXiJcEhBzDtk9vZWEPUA5rqfbLwQssXnfnqqvg9oHzNFjS0o+iJsP4t7CG18K0+nm4af/du6EzvrzLMsAW7wp0wuGqVkM0/3nkw3oDqKKvjNRLwHVBsiYbOuW+Br1tzBzAkLHDdjoxOv5THtAixWmnIglm2JR8IfOkLmx9/tfrlZ3pRykYmTN+2VQl0CsyZR9nBVSvPTEOMTfHYvxfgHL37mv9gVCEp0+9I9GfC+pW6lXaLWzXfMroxQqNnofVXcZlsbgm7qmOA6tCvqsjRWj+HIieJmZL6kI2Z
 R6mfT1xI
 Ce6rJ/vk3VJp1Pf1cwzcYXI7EUITTomSgC+NegeFClwyuwAUYAcXIPWSFAlx/PvSj/YeG6lbsVAJ/FB17pFeqR43TB2XWgoVVYzGJXUvgim1TSTvX0ySONPqEZL1bM6+bagQKg0m+v+JBfRede6Zzn+N5oSGv6W2s4MqF4Et9/oI4Yek6A5+Cpu64DwGWofRxtpKQdtzYtl3mq2FJ08FnBFxj0/bpY3bmtAfzvPCL+QkM7VQoMeInV9dr5qBGHIyOCd5FcVI3r68/4j/F9q/Ap/omYVjRwalrY62jlIa28HFuVfiTmFhJOBuu1zYl1G8/QnL5pbRhPKOFkEUWlDR1UchBMHAHbRxP/8bjh9PHidxpE48=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/05/26 12:40 pm, David Hildenbrand (Arm) wrote:
> On 5/6/26 11:44, Dev Jain wrote:
>> Simplify the code by refactoring the folio_test_hugetlb() branch into
>> a new function.
>>
>> While at it, convert BUG helpers to WARN helpers.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/rmap.c | 117 ++++++++++++++++++++++++++++++++----------------------
>>  1 file changed, 69 insertions(+), 48 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index a5f067a09de0f..a98acdea0530a 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1978,6 +1978,68 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>  				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>>  }
>>  
>> +/* Returns false if unmap needs to be aborted */
>> +static inline bool unmap_hugetlb_folio(struct vm_area_struct *vma,
> 
> I'm wondering whether we should make it clearer that this belongs to the
> try_to_unmap family by calling it
> 
> 	ttu_hugetlb_folio

Yes I had suggested a ttu_ prefix somewhere else in the first version,
Lorenzo didn't like it (or probably he didn't like that specific use
of ttu):

https://lore.kernel.org/all/a8b06f36-98e1-435c-881f-67242bc4304a@lucifer.local/

Don't know about a better name other than "commit_ttu_lazyfree_folio" in
that case, but for the hugetlb case, I like ttu_hugetlb_folio.

> 
>> +		struct folio *folio, struct page_vma_mapped_walk *pvmw,
>> +		struct page *page, enum ttu_flags flags, pte_t *pteval,
>> +		struct mmu_notifier_range *range, bool *exit_walk)
>> +{
>> +	/*
>> +	 * The try_to_unmap() is only passed a hugetlb page
>> +	 * in the case where the hugetlb page is poisoned.
>> +	 */
>> +	VM_WARN_ON_PAGE(!PageHWPoison(page), page);
> 
> IIRC, we will never actually get a tail page here.
> 
> Can we avoid passing a page by checking instead whether the hugetlb folios is
> marked as having a poisoned page?
> 
> See the folio_test_set_hwpoison() in hugetlb_update_hwpoison().
> 
> So you can simply use folio_test_hwpoison here instead.

Okay I will confirm and do this.

> 
> 
>> +	/*
>> +	 * huge_pmd_unshare may unmap an entire PMD page.
>> +	 * There is no way of knowing exactly which PMDs may
>> +	 * be cached for this mm, so we must flush them all.
>> +	 * start/end were already adjusted above to cover this
>> +	 * range.
>> +	 */
>> +	flush_cache_range(vma, range->start, range->end);
>> +
>> +	/*
>> +	 * To call huge_pmd_unshare, i_mmap_rwsem must be
>> +	 * held in write mode.  Caller needs to explicitly
>> +	 * do this outside rmap routines.
>> +	 *
>> +	 * We also must hold hugetlb vma_lock in write mode.
>> +	 * Lock order dictates acquiring vma_lock BEFORE
>> +	 * i_mmap_rwsem.  We can only try lock here and fail
>> +	 * if unsuccessful.
>> +	 */
>> +	if (!folio_test_anon(folio)) {
>> +		struct mmu_gather tlb;
>> +
>> +		VM_WARN_ON(!(flags & TTU_RMAP_LOCKED));
>> +		if (!hugetlb_vma_trylock_write(vma)) {
>> +			*exit_walk = true;
>> +			return false;
>> +		}
>> +
>> +		tlb_gather_mmu_vma(&tlb, vma);
>> +		if (huge_pmd_unshare(&tlb, vma, pvmw->address, pvmw->pte)) {
>> +			hugetlb_vma_unlock_write(vma);
>> +			huge_pmd_unshare_flush(&tlb, vma);
>> +			tlb_finish_mmu(&tlb);
>> +			/*
>> +			 * The PMD table was unmapped,
>> +			 * consequently unmapping the folio.
>> +			 */
>> +			*exit_walk = true;
>> +			return true;
>> +		}
>> +		hugetlb_vma_unlock_write(vma);
>> +		tlb_finish_mmu(&tlb);
>> +	}
>> +	*pteval = huge_ptep_clear_flush(vma, pvmw->address, pvmw->pte);
>> +	if (pte_dirty(*pteval))
>> +		folio_mark_dirty(folio);
>> +
>> +	*exit_walk = false;
>> +	return true;
> 
> 
> Can we instead introduce some enum that tells the caller how to proceed?
> 
> I assume we have
> 
> (a) Abort walk (ret = false + page_vma_mapped_walk_done())
> 
> (b) Walk done (ret = true + page_vma_mapped_walk_done())
> 
> (c) Continue walk (call page_vma_mapped_walk())
> 
> enum ttu_walk_result {
> 	TTU_WALK_CONTINUE,
> 	TTU_WALK_ABORT,
> 	TTU_WALK_DONE
> }

I had replied to such a suggestion here:

https://lore.kernel.org/all/caa7c455-7472-48eb-a5dc-145e587d67ba@arm.com/

Probably we don't have any other solution : )

> 
>> +}
>> +
>>  /*
>>   * @arg: enum ttu_flags will be passed to this argument
>>   */
>> @@ -2115,56 +2177,15 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  				 PageAnonExclusive(subpage);
>>  
>>  		if (folio_test_hugetlb(folio)) {
>> -			bool anon = folio_test_anon(folio);
>> -
>> -			/*
>> -			 * The try_to_unmap() is only passed a hugetlb page
>> -			 * in the case where the hugetlb page is poisoned.
>> -			 */
>> -			VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
>> -			/*
>> -			 * huge_pmd_unshare may unmap an entire PMD page.
>> -			 * There is no way of knowing exactly which PMDs may
>> -			 * be cached for this mm, so we must flush them all.
>> -			 * start/end were already adjusted above to cover this
>> -			 * range.
>> -			 */
>> -			flush_cache_range(vma, range.start, range.end);
>> +			bool exit_walk;
>>  
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
>> -				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
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
>> +			ret = unmap_hugetlb_folio(vma, folio, &pvmw, subpage,
>> +						  flags, &pteval, &range,
>> +						  &exit_walk);
>> +			if (exit_walk) {
>> +				page_vma_mapped_walk_done(&pvmw);
>> +				break;
> 
> In the old walk_abort case you wouldn't set ret = false?

ret will be set appropriately in unmap_hugetlb_folio.
> 
> When returning the enum you could simply do something like
> 
> switch (ret) {
> case TTU_WALK_ABORT:
> 	goto walk_abort;
> case TTU_WALK_DONE:
> 	goto walk_done;
> default:
> 	break;
> }
> 
> 
> While I like this patch, can we please just move all the hugetlb shite into this
> helper function?
> 
> Essentially, get rid of hugetlb special casing in the remainder of the function.
> 
> That also makes the function name clearer (right now it's only doing a part of
> hugetlb folio unmapping).

Okay I can try that. That would mean splitting the pvmw walk for hugetlb and
non-hugetlb, but I suspect it would be very less code duplication.

> 


