Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BD85D5C0C9
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 03:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA44E6B0005; Tue, 16 Dec 2025 22:53:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A52A06B0089; Tue, 16 Dec 2025 22:53:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9506D6B008A; Tue, 16 Dec 2025 22:53:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7DC106B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 22:53:39 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C4DBBB913
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:53:39 +0000 (UTC)
X-FDA: 84227593758.08.724C34A
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf23.hostedemail.com (Postfix) with ESMTP id DA87714000A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:53:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gwaNV91T;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765943617; a=rsa-sha256;
	cv=none;
	b=Jw015XUn7zKqFJoLY03HlOXKXe1TP1qWtg9Z2BPCxuXs5Jhds2RvNhfjH6xB8Y+RGH2S+V
	DZ2Ng+192R0gdr/z/2eXaDZ2MvaqJgnXcLoISqTLANtpzc30nloERCO8b1pE+7kTd1EId2
	nMD7XKgNmn4FPVtA1pu9g1OMpOmijQY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gwaNV91T;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765943617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6wnknxecK7LGdzu4sakhj2hgj6KDw7bH2F2CKgX5JY=;
	b=c5qakYryvFDQSiwTlIJ4sEzTbMRtfqpR7M6kpQ0hpnl+OTFEvRJM8xDAvloPl5wd2+DRuW
	SFQSMOwRV3TdQqHFYUCrth/0L2aqezJwGeDLhs4v7uKqrkvJENN8FtGfzvx3K1NJEjUzbD
	610E18eI/8zE7gDH/e3dk+7UJYPctKA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765943613; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=V6wnknxecK7LGdzu4sakhj2hgj6KDw7bH2F2CKgX5JY=;
	b=gwaNV91TEXcLV0rLCJXTF+y/CHJurD2x9YHC04qgG2Ad/FF/3I5EfQmh4LGx15VQfjDETfiTGU9nYc/t0pmqYPgatCE1T4yd0ezGMBvcgM7kIzLUaxB+XKjY/mFd3faiPxNoFVS4lJUokhlJ5mfMCtT+M1fAdSNr+fbfs7J3MK8=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wv1mvRJ_1765943611 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 17 Dec 2025 11:53:32 +0800
Message-ID: <37915af9-d307-4955-969e-c16ea26f7f4a@linux.alibaba.com>
Date: Wed, 17 Dec 2025 11:53:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] arm64: mm: support batch clearing of the young
 flag for large folios
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <e10f876ce130134fa089befe83f30561b48b9889.1765439380.git.baolin.wang@linux.alibaba.com>
 <5039c6a2-09b6-4c9b-accb-26583ba120db@lucifer.local>
 <1a0001cd-c38d-403b-b3ef-d19e85acd772@linux.alibaba.com>
 <671ac450-4a59-4e26-b098-7cf65add1e75@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <671ac450-4a59-4e26-b098-7cf65add1e75@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DA87714000A
X-Stat-Signature: 1qrd8h17mjb83ptd7556wwt5pxxpqgzh
X-Rspam-User: 
X-HE-Tag: 1765943615-371645
X-HE-Meta: U2FsdGVkX1+T9Uaf9bwttYEsfIJaQoytkU9JmT/em6K1j14fGIfDYxHdLv5nNtBgQAy3S5de4UI9NtpxARdvaD6scO5LKpIDDVSzz2Y6gGSED3/UL1GKPm0vWwskcWPNDGezFt/XQSLlSp3EwIcH+Y3Mv7C+8kPs6SDYdPYf0zVek5S4A17kGHIE2Bcf1XpbA6VAGOBfZdJsgArOahfQF5VM6V6Bv+LUxKyBKyQumeK+JmsK7XKDgLmH/S9KKncBhtkbtUhHz98ehrdkZclsksgjJvjLmv6uZjSFONEN0CT3GooZsgrHx/bZ0UhjvVa6VmTzMDPYHH7qkuxYKtTpmA8+76jnuqonHdZclB7ZLEwxG3kmfSDu4S64ROyPrZ6kP6OLGbnFrZbddSdxR2LV5IukDcwbubdI5w3kGI3QeYEIG2/knisYLSQ/u1dNva3tGcUllHjaBCVnjf6PsmBFIuMKpiNz/4uihkpov3cG7v+OzQZIqtfomDX/U3boUvhTb7QZsRb5M79VlR+MVDtbgxEe+lq68cLIKeJxmWW2vQVtx47zFZ5Y+JCOv+HgXecjqcgRNGOtE1u981NU9WtN5thyj65Y1eUcrdi20S+CFEWXmL/qP4cwYijXG8pMiYYu1nOjOhXjo1UG4UcnTI0rKez+dgX8L2Zf6Q+ecANKiPfc0BnHLF1ToU5F5ct695Q5YyadCYuTrO1DnCren/Q4pgmfa8ZTTZTIDf3NvzkoAuc7AUqYDDIwlF4TfWa/HynoRnwlnmKERf7WVWRtA2X1h2gz1Xol1MaVCqTkKUSh0rGkLyWm8Bk7tg3tTLejzPQPVi8pXd12dCVobggTdvUG15asAM/x0tLnv1W0PqJ9YFlSOnMQBGh4ppNmSULcXTyIv0vNnncLcUlYOe4BMaSfBOsjLp3jmG7lqZLWgbeqDQT+8BV19FDfAZ6FQp+bcnT2/Dzp4vn+aWiFA48+759
 /JpEU1P7
 NBc7fuJ/BEEEdasAPEZN+lv0MsuWFvXILw+9ibxaq3hhjl9y16USM41rCmW7LASVMwzHyVpHvm3cXosezZIEXlWE25+Yp21+kRHFfciwC8+pq3EAIsu5hLJVk31Pg+P0VD2FSa2pQKg4FUX0ut+hq2Ti4fyf2dIpiTXWDBEPFF/h9uVyiSUCbR9UPCmVff74F4nHH/OKfi1ZAaYywIYuD9oaup6SVybfCQehBm4giWx6XWlMIVCu37hYrDevpfg3L2Xe9p+HYePWazgvAVz4Tn52Anu0JBBNBgJ34kv4mie1vflk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/16 19:11, Lorenzo Stoakes wrote:
> On Tue, Dec 16, 2025 at 11:32:58AM +0800, Baolin Wang wrote:
>>
>>
>> On 2025/12/15 19:36, Lorenzo Stoakes wrote:
>>> On Thu, Dec 11, 2025 at 04:16:54PM +0800, Baolin Wang wrote:
>>>> Currently, contpte_ptep_test_and_clear_young() and contpte_ptep_clear_flush_young()
>>>> only clear the young flag and flush TLBs for PTEs within the contiguous range.
>>>> To support batch PTE operations for other sized large folios in the following
>>>> patches, adding a new parameter to specify the number of PTEs.
>>>>
>>>> While we are at it, rename the functions to maintain consistency with other
>>>> contpte_*() functions.
>>>>
>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> ---
>>>>    arch/arm64/include/asm/pgtable.h | 12 ++++-----
>>>>    arch/arm64/mm/contpte.c          | 44 ++++++++++++++++++++++----------
>>>>    2 files changed, 37 insertions(+), 19 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>>>> index 0944e296dd4a..e03034683156 100644
>>>> --- a/arch/arm64/include/asm/pgtable.h
>>>> +++ b/arch/arm64/include/asm/pgtable.h
>>>> @@ -1679,10 +1679,10 @@ extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
>>>>    extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>>>>    				unsigned long addr, pte_t *ptep,
>>>>    				unsigned int nr, int full);
>>>> -extern int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>>>> -				unsigned long addr, pte_t *ptep);
>>>> -extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
>>>> -				unsigned long addr, pte_t *ptep);
>>>> +extern int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>>>> +				unsigned long addr, pte_t *ptep, unsigned int nr);
>>>> +extern int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
>>>> +				unsigned long addr, pte_t *ptep, unsigned int nr);
>>>
>>> In core mm at least, as a convention, we strip 'extern' from header declarations
>>> as we go as they're not necessary.
>>
>> Sure. I can remove the 'extern'.
> 
> Thanks.
> 
>>
>>> I wonder about this naming convention also. The contpte_xxx_() prefix
>>> obviously implies we are operating upon PTEs in the contiguous range, now
>>> we are doing something... different and 'nr' is a bit vague.
>>>
>>> Is it the nr of contiguous ranges? Well in reality it's nr_pages right? But
>>
>> Yes, 'nr' here means nr_pages, which follows the convention of the
>> parameters in contpte_xxx_() functions.
> 
> Except you're violating the convention already by doing non-contpte stuff in
> contpte functions?

Nope. Sorry for my poor English, which might have caused some confusion. 
I followed the contpte's convention, and let me try to explain it again 
below.

> The confusion is between nr of contpte ranges and nr of pages, so I think we
> should be explicit.
> 
>>
>>> now we're not saying they're necessarily contiguous in the sense of contpte...
>>>
>>> I wonder whether we'd be better off introducing a new function that
>>> explicitly has 'batch' or 'batched' in the name, and have the usual
>>> contpte_***() stuff and callers that need batching using a new underlying helper?
>>
>> OK. I get your point. However, this is outside the scope of my patchset.
> 
> Well, no, this is review feedback that needs to be addressed, I really don't
> like this patch as-is.
> 
> So for this to be upstreamable you really need to separate this out.
> 
>>
>> Perhaps we can clean up all the contpte_xxx_() functions if everyone agrees
>> that this is confusing.
> 
> I mean, unless Ryan explicitly makes a case for this being fine, I'm inclined to
> reject the patch unless we do this.
> 
> The contpte logic is already very confusing, and this is only adding to it.
> 
>>
>>> Obviously I defer to Ryan on all this, just my thoughts...
>>>
>>>>    extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>>>>    				pte_t *ptep, unsigned int nr);
>>>>    extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
>>>> @@ -1854,7 +1854,7 @@ static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
>>>>    	if (likely(!pte_valid_cont(orig_pte)))
>>>>    		return __ptep_test_and_clear_young(vma, addr, ptep);
>>>>
>>>> -	return contpte_ptep_test_and_clear_young(vma, addr, ptep);
>>>> +	return contpte_test_and_clear_young_ptes(vma, addr, ptep, CONT_PTES);
>>>>    }
>>>>
>>>>    #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
>>>> @@ -1866,7 +1866,7 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
>>>>    	if (likely(!pte_valid_cont(orig_pte)))
>>>>    		return __ptep_clear_flush_young(vma, addr, ptep);
>>>>
>>>> -	return contpte_ptep_clear_flush_young(vma, addr, ptep);
>>>> +	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
>>>>    }
>>>>
>>>>    #define wrprotect_ptes wrprotect_ptes
>>>> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
>>>> index c0557945939c..19b122441be3 100644
>>>> --- a/arch/arm64/mm/contpte.c
>>>> +++ b/arch/arm64/mm/contpte.c
>>>> @@ -488,8 +488,9 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>>>>    }
>>>>    EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
>>>>
>>>> -int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>>>> -					unsigned long addr, pte_t *ptep)
>>>> +int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>>>> +					unsigned long addr, pte_t *ptep,
>>>> +					unsigned int nr)
>>>>    {
>>>>    	/*
>>>>    	 * ptep_clear_flush_young() technically requires us to clear the access
>>>> @@ -500,39 +501,56 @@ int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>>>>    	 * having to unfold.
>>>>    	 */
>>>
>>> Hmm shouldn't you need to update this comment now 'nr' is a thing? E.g.:
>>>
>>> "And since we only create a contig range when the range is covered by a single
>>> folio, we can get away with clearing young for the whole contig range here, so
>>> we avoid having to unfold."
>>
>> I think the original comments are still clear:
>> "
>> /*
>>   * ptep_clear_flush_young() technically requires us to clear the access
>>   * flag for a _single_ pte. However, the core-mm code actually tracks
>>   * access/dirty per folio, not per page. And since we only create a
>>   * contig range when the range is covered by a single folio, we can get
>>   * away with clearing young for the whole contig range here, so we avoid
>>   * having to unfold.
>>   */
>> "
> 
> Except nr means you can span more than a single contig pte range? So this
> comment is no longer applicable as-is?

The nr means consecutive (present) PTEs that map consecutive pages of 
the same large folio in a single VMA and a single page table.

I think this is a prerequisite. If you think it's necessary to explain 
it, I can add it to the comments.

> You've changed the function, the comment needs to change too.
> 
>>
>>> However now you're allowing for large folios that are not contpte?
>>>
>>> Overall feeling pretty iffy about implementing this this way.
>>
>> Please see the above comments, which explain why we should do that.
> 
> You haven't explained anything? Maybe I missed it?
> 
> Can you explain clearly what nr might actually be in relation to contpte's? I'm
> confused even as to the utility here.
> 
> Is it batched ranges of contptes? But then why are you trying to see if end is a
> contpte + expand the range if so?

See below.

>>>> +	unsigned long start = addr;
>>>> +	unsigned long end = start + nr * PAGE_SIZE;
>>>
>>> So now [addr, addr + nr * PAGE_SIZE) must for sure be within a single PTE
>>> table?
>>
>> Caller has made sure that (see folio_referenced_one()).
> 
> You should comment this somehow, I hate this nested assumptions stuff 'function
> X which calls function Y which calls function Z makes sure that parameter A
> fulfils requirements B but we don't mention it anywhere'.

Sure.

>>>>    	int young = 0;
>>>>    	int i;
>>>>
>>>> -	ptep = contpte_align_down(ptep);
>>>> -	addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
>>>> +	if (pte_cont(__ptep_get(ptep + nr - 1)))
>>>> +		end = ALIGN(end, CONT_PTE_SIZE);
>>>
>>> OK so I guess for PTE_CONT to be set, it must be aligned to CONT_PTE_SIZE,
>>> with other PTE entries present there not having PTE_CONT set (Ryan - do
>>> correct me if I'm wrong!)
>>>
>>> I guess then no worry about running off the end of the PTE table here.
>>>
>>> I wonder about using pte_cont_addr_end() here, but I guess you are not
>>> intending to limit to a range here but rather capture the entire contpte
>>> range of the end.
>>
>> Right.
>>
>>> I don't love that now a function prefixed with contpte_... can have a
>>> condition where part of the input range is _not_ a contpte entry, or is
>>> specified partially...
>>
>> Like I said above, this is outside the scope of my patchset. If Ryan also
>> thinks we need to do some cleanups for all the contpte_xxx() functions in
>> the contpte.c file, we can send a follow-up patchset to rename all the
>> contpte_xxx() functions to make it clear.
> 
> It's really not outside of the scope of the patch set, this is review feedback
> you have to address :) trying not to be a grumpy kernel dev here :>)
> 
> In general in the kernel we don't accept confusing patches then defer making
> them not-confusing until later.
> 
> We review until the series is at the correct standard to be accepted before we
> merge.
> 
> As always I'm happy to be convinced that I'm mistaken or something's not
> necesary, however!

Yes, let me try to explain it again. See below.

>>>> -	for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
>>>> -		young |= __ptep_test_and_clear_young(vma, addr, ptep);
>>>> +	if (pte_cont(__ptep_get(ptep))) {
>>>> +		start = ALIGN_DOWN(start, CONT_PTE_SIZE);
>>>> +		ptep = contpte_align_down(ptep);
>>>> +	}
>>>> +
>>>> +	nr = (end - start) / PAGE_SIZE;
>>>
>>> Hm don't love this reuse of input param.
>>
>> OK. Will use another local variable instead.
> 
> Thanks.
> 
>>
>>>
>>>> +	for (i = 0; i < nr; i++, ptep++, start += PAGE_SIZE)
>>>> +		young |= __ptep_test_and_clear_young(vma, start, ptep);
>>>
>>> Again, overall find it a bit iffy that we are essentially overloading the
>>> code with non-contpte behaviour.
>>
>> Let me clarify further: this is the handling logic of the contpte_xxx()
>> functions in the contpte.c file. For example, the function
>> contpte_set_ptes() has a parameter 'nr', which may be greater than
>> CONT_PTES, meaning that it can handle multiple CONT_PTES range sizes of a
>> large folio.
>>
>> It might be a bit confusing, and I understand this is why you want to change
>> the 'contpte_' prefix to the 'batch_' prefix. Of course, we can hope Ryan
>> can provide some input on this.
>>
>> Thanks for reviewing.
> 
> OK so we have some reeeeal confusion here. And this speaks to the patch needing
> work.
> 
> This seems to answer what I asked above - basically - are we doing _batches_ of
> _contpte_ entries, or are we just accepting arbitrary large folios here and
> batching up operations on them, including non-contpte entries.
> 
> Presumably from the above you're saying - this is dealing with batches of
> contpte entries.
> 
> In which case this has to be made _super_ clear. Not just adding an arbitrary
> 'nr' parameter and letting people guess.
> 
> The contpte code is _already_ confusing and somewhat surprising if you're not
> aware of it, we need to be going in the other direction.

Sure. Sorry for causing confusion. I try to explain it again to make it 
clear.

First, it is necessary to explain how the contpte implementation in 
Arm64 is exposed, using set_ptes() as an example.

Arm64 defines an arch-specific implementation of set_ptes():
"
static __always_inline void set_ptes(struct mm_struct *mm, unsigned long 
addr,
				pte_t *ptep, pte_t pte, unsigned int nr)
{
	pte = pte_mknoncont(pte);

	if (likely(nr == 1)) {
		contpte_try_unfold(mm, addr, ptep, __ptep_get(ptep));
		__set_ptes(mm, addr, ptep, pte, 1);
		contpte_try_fold(mm, addr, ptep, pte);
	} else {
		contpte_set_ptes(mm, addr, ptep, pte, nr);
	}
}
"

Here, 'nr' refers to consecutive (present) PTEs that map consecutive 
pages of the same large folio within a single VMA and a single page 
table. Based on 'nr', it determines whether the PTE_CONT attribute 
should be set or not.

Second, the underlying implementation of contpte_set_ptes() also 
calculates 'end' based on 'nr' and checks whether the PTE_CONT attribute 
should be set. For example:

For a large folio with order = 3 (nr = 8), the PTE_CONT attribute will 
not be set since the 'next' is not aligned with CONT_PTE_MASK.

For a large folio with order = 4 (nr = 16), it aligns perfectly, 
allowing the PTE_CONT attribute to be set for the entire PTE entries of 
the large folio.

For a large folio with order = 5 (nr = 32), this involves two ranges of 
CONT_PTE_SIZE (16 PTEs in each range), requiring the PTE_CONT attribute 
to be set separately for each range.

"
void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
					pte_t *ptep, pte_t pte, unsigned int nr)
{
	.......

	end = addr + (nr << PAGE_SHIFT);
	pfn = pte_pfn(pte);
	prot = pte_pgprot(pte);

	do {
		next = pte_cont_addr_end(addr, end);
		nr = (next - addr) >> PAGE_SHIFT;
		pte = pfn_pte(pfn, prot);

		if (((addr | next | (pfn << PAGE_SHIFT)) & ~CONT_PTE_MASK) == 0)
			pte = pte_mkcont(pte);
		else
			pte = pte_mknoncont(pte);

		__set_ptes(mm, addr, ptep, pte, nr);

		addr = next;
		ptep += nr;
		pfn += nr;

	} while (addr != end);
}
"

Third, regarding the implementation of my patch, I have followed the 
contpte logic here by adding the 'nr' parameter to 
contpte_ptep_test_and_clear_young() for batch processing consecutive 
(present) PTEs. Moreover, the semantics of 'nr' remain consistent with 
the original contpte functions, and I have not broken the existing 
contpte implementation logic.

