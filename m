Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B80AD68BE7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 07:56:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE8B16B0088; Thu, 18 Dec 2025 02:56:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D96266B0089; Thu, 18 Dec 2025 02:56:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C785A6B008A; Thu, 18 Dec 2025 02:56:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B30446B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:56:53 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59FF5160DEB
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:56:53 +0000 (UTC)
X-FDA: 84231835506.02.913A63E
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6761F14000E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:56:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=T9F7C1gG;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766044611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0JWwsnMLFtRDPmHy937hFQvqaYnXb9HUBBi14bcx3eA=;
	b=vITwXTl00ED9XtqjLglTLJeSqujKCMjySgm8JkTwnKQHCQzMuKOTiLaIKeYJGZRR6dylsf
	uxVAwxqxvAlgnIHNTfnBiJL9R4ZOkEy08nfQPy4p6k9DaSd+N7FH8xYQEnEdESy19ZdsA0
	gAEuBPqfXDglf0Tu0+gDyLi9VbF5OM0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766044611; a=rsa-sha256;
	cv=none;
	b=qO8/Qj3jAhmbQTZdXWfdRhWkpQvRXV+KGR0+7Nl7RhaXJ88gVDXsE8r88LSz7eKrNTBcSF
	Dtht75hC8zJfqjWR8AhdQPj7HqgndpDIYRFUkPwQYAo0EGel5he07ydGSbCZRNnmjIGaS3
	BYe8F7c7GnLtiqHgKwiGn8AiwrvNumQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=T9F7C1gG;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766044607; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0JWwsnMLFtRDPmHy937hFQvqaYnXb9HUBBi14bcx3eA=;
	b=T9F7C1gGiMr/4Ci2kDQhie+VG7GG/J25J6kztWHV2+FFOgRhBhglQMb/hBR8/ZQHl2XvyFLCHTWJ/sFLReyINHJSa1NRe/y3r861zVqBaA+RYrp+aWOCC15/JcKN0UT8EhbZkyNJjBQ2hMIPu0YJV9lkcp4K34tJbJi/2oFMExk=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wv7mNd8_1766044605 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Dec 2025 15:56:45 +0800
Message-ID: <a8b5e3b7-e702-4f57-9fab-289cb34345dc@linux.alibaba.com>
Date: Thu, 18 Dec 2025 15:56:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] arm64: mm: support batch clearing of the young
 flag for large folios
To: Ryan Roberts <ryan.roberts@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com,
 jannh@google.com, willy@infradead.org, baohua@kernel.org,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <e10f876ce130134fa089befe83f30561b48b9889.1765439380.git.baolin.wang@linux.alibaba.com>
 <5039c6a2-09b6-4c9b-accb-26583ba120db@lucifer.local>
 <1a0001cd-c38d-403b-b3ef-d19e85acd772@linux.alibaba.com>
 <671ac450-4a59-4e26-b098-7cf65add1e75@lucifer.local>
 <37915af9-d307-4955-969e-c16ea26f7f4a@linux.alibaba.com>
 <16d6642b-6f22-4d7b-94d6-92692b63cbd9@lucifer.local>
 <fac9dd13-0c1b-40de-a5ac-d2c4c2012385@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <fac9dd13-0c1b-40de-a5ac-d2c4c2012385@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: si1w5fyypoeq1yn7a69a7898dc3xjf3s
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6761F14000E
X-Rspam-User: 
X-HE-Tag: 1766044610-857636
X-HE-Meta: U2FsdGVkX1+1u5j8Gb9NIFqqQxMQLlFOvqjZJbMTgLrhUn+FLDJMOteDZ/HSw2x8/M65uoyKVkSR/IrjRK7LlF+hWznkQ8Jr53oMiTwdaTWT40lw3gMqqBAn9cE5sqxbWN/63DBXG2XR8nmPyNlEunppMIjDx+KE5BqvANSQWJahkUvz9eUZVP+pHCJADVGMVkQlHFeHgUhDZQt+p84D5Z/Bc20C6fA9O0Uo2ccQ6CN1fZKJXwTF3lysEFCOQbTCfpoa21erdG7VpY6USElkEEHc/+eP/23RtrcJylOmHvfiP0pbyV8pJIDiF/koeZFwuCliU0B4YJXNeT7ELOAUW8gMc6drzFi6JGjqxsDwBWXih/oiZeiO6OMbxV4z1Rz9iexToG+hZ+4odjFFsS3ZNCZRaRea+zEq3gwamoMZBCH4RbhpzL4y410AjFGFTzcWE2d+Go+VMiZxYHOWlkq1gn2h+wB1QRFjMh9Lk/6GXp20OnBSz7rnix5VRJ1MdSA75ptO0QUo1NHqRC7VSoeMGpOGsR0kFVFC70Rd0PAx5Gidkg/p26FPmBB61SXbFfIvAAq5PmKpFmDhYlUhJVd9x1/fwj3ic/sDr9a4gag1adMB/5IR70FjWE/oDa3z3/RupJTkdEBASxe+aFYYJwYxUUjuVl6Ezq8bK4ih4jssIa0qdOpDpLxZGTQbPLBDEsdUdQK28i8DUS+a52OxVkkRI5OYvm9rHnm0eCL9DGrnt67VU+S9A6hcVxVkNvoKp6EtlpvvdRfSxJIbDMnDIYUR3XTgiNMAWPXh4MM9A8Hai8FMjcx41W5xcphgxDHL3GyLsZfURC34gOp0hdSMdpGMWIu/yPCfIBPt1b4K5HmWQGqEzISRSaR/dX4Bky1+XVARtNFAN9M/wEFCP8QIwMcfZmDfPni5hTXYMKYiPMuscZk+PM3OA/q8Otb8LgBmJe55XwCKF3292mueIrNS2At
 LCreT0Tu
 W4P/T7ueHoAqsZNWJbg5lnPXbx5O+sya+PipykgElSw1Ms0JwVTqhUOzPIbxIQz9pfFPvuob9Mq+nefmcLt7u8CbfyL3pqIGw53xeL+HpQxgIFOE03fbFwCutLu4jwsvhSWr3lYYfGrXxkcEOZRN7uUKVpXOwdTAgipvFBspfd9z6ezkRVoNtSPVsSOUJI4J8B5J1uUsRsQpHIDewjg6WAUAAsQAyGLk7gaRSAgOfokYdaVvSozfg24woMydD2HrN/GMSuS1V2buj0cExrttQd7LSO5u/57uNGEmkcpjTggpLfow=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/18 00:06, Ryan Roberts wrote:
> On 17/12/2025 14:50, Lorenzo Stoakes wrote:
>> On Wed, Dec 17, 2025 at 11:53:31AM +0800, Baolin Wang wrote:
>>>
>>>
>>> On 2025/12/16 19:11, Lorenzo Stoakes wrote:
>>>> On Tue, Dec 16, 2025 at 11:32:58AM +0800, Baolin Wang wrote:
>>>>>
>>>>>
>>>>> On 2025/12/15 19:36, Lorenzo Stoakes wrote:
>>>>>> On Thu, Dec 11, 2025 at 04:16:54PM +0800, Baolin Wang wrote:
>>>>>>> Currently, contpte_ptep_test_and_clear_young() and contpte_ptep_clear_flush_young()
>>>>>>> only clear the young flag and flush TLBs for PTEs within the contiguous range.
>>>>>>> To support batch PTE operations for other sized large folios in the following
>>>>>>> patches, adding a new parameter to specify the number of PTEs.
>>>>>>>
>>>>>>> While we are at it, rename the functions to maintain consistency with other
>>>>>>> contpte_*() functions.
>>>>>>>
>>>>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>> ---
>>>>>>>     arch/arm64/include/asm/pgtable.h | 12 ++++-----
>>>>>>>     arch/arm64/mm/contpte.c          | 44 ++++++++++++++++++++++----------
>>>>>>>     2 files changed, 37 insertions(+), 19 deletions(-)
>>>>>>>
>>>>>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>>>>>>> index 0944e296dd4a..e03034683156 100644
>>>>>>> --- a/arch/arm64/include/asm/pgtable.h
>>>>>>> +++ b/arch/arm64/include/asm/pgtable.h
>>>>>>> @@ -1679,10 +1679,10 @@ extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
>>>>>>>     extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>>>>>>>     				unsigned long addr, pte_t *ptep,
>>>>>>>     				unsigned int nr, int full);
>>>>>>> -extern int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>>>>>>> -				unsigned long addr, pte_t *ptep);
>>>>>>> -extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
>>>>>>> -				unsigned long addr, pte_t *ptep);
>>>>>>> +extern int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>>>>>>> +				unsigned long addr, pte_t *ptep, unsigned int nr);
>>>>>>> +extern int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
>>>>>>> +				unsigned long addr, pte_t *ptep, unsigned int nr);
>>>>>>
>>>>>> In core mm at least, as a convention, we strip 'extern' from header declarations
>>>>>> as we go as they're not necessary.
>>>>>
>>>>> Sure. I can remove the 'extern'.
>>>>
>>>> Thanks.
>>>>
>>>>>
>>>>>> I wonder about this naming convention also. The contpte_xxx_() prefix
>>>>>> obviously implies we are operating upon PTEs in the contiguous range, now
>>>>>> we are doing something... different and 'nr' is a bit vague.
>>>>>>
>>>>>> Is it the nr of contiguous ranges? Well in reality it's nr_pages right? But
>>>>>
>>>>> Yes, 'nr' here means nr_pages, which follows the convention of the
>>>>> parameters in contpte_xxx_() functions.
>>>>
>>>> Except you're violating the convention already by doing non-contpte stuff in
>>>> contpte functions?
>>>
>>> Nope. Sorry for my poor English, which might have caused some confusion. I
>>> followed the contpte's convention, and let me try to explain it again below.
>>>
>>>> The confusion is between nr of contpte ranges and nr of pages, so I think we
>>>> should be explicit.
>>>>
>>>>>
>>>>>> now we're not saying they're necessarily contiguous in the sense of contpte...
>>>>>>
>>>>>> I wonder whether we'd be better off introducing a new function that
>>>>>> explicitly has 'batch' or 'batched' in the name, and have the usual
>>>>>> contpte_***() stuff and callers that need batching using a new underlying helper?
>>>>>
>>>>> OK. I get your point. However, this is outside the scope of my patchset.
>>>>
>>>> Well, no, this is review feedback that needs to be addressed, I really don't
>>>> like this patch as-is.
>>>>
>>>> So for this to be upstreamable you really need to separate this out.
>>>>
>>>>>
>>>>> Perhaps we can clean up all the contpte_xxx_() functions if everyone agrees
>>>>> that this is confusing.
>>>>
>>>> I mean, unless Ryan explicitly makes a case for this being fine, I'm inclined to
>>>> reject the patch unless we do this.
>>>>
>>>> The contpte logic is already very confusing, and this is only adding to it.
>>>>
>>>>>
>>>>>> Obviously I defer to Ryan on all this, just my thoughts...
>>>>>>
>>>>>>>     extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>>>>>>>     				pte_t *ptep, unsigned int nr);
>>>>>>>     extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
>>>>>>> @@ -1854,7 +1854,7 @@ static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
>>>>>>>     	if (likely(!pte_valid_cont(orig_pte)))
>>>>>>>     		return __ptep_test_and_clear_young(vma, addr, ptep);
>>>>>>>
>>>>>>> -	return contpte_ptep_test_and_clear_young(vma, addr, ptep);
>>>>>>> +	return contpte_test_and_clear_young_ptes(vma, addr, ptep, CONT_PTES);
>>>>>>>     }
>>>>>>>
>>>>>>>     #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
>>>>>>> @@ -1866,7 +1866,7 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
>>>>>>>     	if (likely(!pte_valid_cont(orig_pte)))
>>>>>>>     		return __ptep_clear_flush_young(vma, addr, ptep);
>>>>>>>
>>>>>>> -	return contpte_ptep_clear_flush_young(vma, addr, ptep);
>>>>>>> +	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
>>>>>>>     }
>>>>>>>
>>>>>>>     #define wrprotect_ptes wrprotect_ptes
>>>>>>> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
>>>>>>> index c0557945939c..19b122441be3 100644
>>>>>>> --- a/arch/arm64/mm/contpte.c
>>>>>>> +++ b/arch/arm64/mm/contpte.c
>>>>>>> @@ -488,8 +488,9 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>>>>>>>     }
>>>>>>>     EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
>>>>>>>
>>>>>>> -int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>>>>>>> -					unsigned long addr, pte_t *ptep)
>>>>>>> +int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>>>>>>> +					unsigned long addr, pte_t *ptep,
>>>>>>> +					unsigned int nr)
>>>>>>>     {
>>>>>>>     	/*
>>>>>>>     	 * ptep_clear_flush_young() technically requires us to clear the access
>>>>>>> @@ -500,39 +501,56 @@ int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>>>>>>>     	 * having to unfold.
>>>>>>>     	 */
>>>>>>
>>>>>> Hmm shouldn't you need to update this comment now 'nr' is a thing? E.g.:
>>>>>>
>>>>>> "And since we only create a contig range when the range is covered by a single
>>>>>> folio, we can get away with clearing young for the whole contig range here, so
>>>>>> we avoid having to unfold."
>>>>>
>>>>> I think the original comments are still clear:
>>>>> "
>>>>> /*
>>>>>    * ptep_clear_flush_young() technically requires us to clear the access
>>>>>    * flag for a _single_ pte. However, the core-mm code actually tracks
>>>>>    * access/dirty per folio, not per page. And since we only create a
>>>>>    * contig range when the range is covered by a single folio, we can get
>>>>>    * away with clearing young for the whole contig range here, so we avoid
>>>>>    * having to unfold.
>>>>>    */
>>>>> "
>>>>
>>>> Except nr means you can span more than a single contig pte range? So this
>>>> comment is no longer applicable as-is?
>>>
>>> The nr means consecutive (present) PTEs that map consecutive pages of the
>>> same large folio in a single VMA and a single page table.
>>>
>>> I think this is a prerequisite. If you think it's necessary to explain it, I
>>> can add it to the comments.
>>>
>>>> You've changed the function, the comment needs to change too.
>>>>
>>>>>
>>>>>> However now you're allowing for large folios that are not contpte?
>>>>>>
>>>>>> Overall feeling pretty iffy about implementing this this way.
>>>>>
>>>>> Please see the above comments, which explain why we should do that.
>>>>
>>>> You haven't explained anything? Maybe I missed it?
>>>>
>>>> Can you explain clearly what nr might actually be in relation to contpte's? I'm
>>>> confused even as to the utility here.
>>>>
>>>> Is it batched ranges of contptes? But then why are you trying to see if end is a
>>>> contpte + expand the range if so?
>>>
>>> See below.
>>>
>>>>>>> +	unsigned long start = addr;
>>>>>>> +	unsigned long end = start + nr * PAGE_SIZE;
>>>>>>
>>>>>> So now [addr, addr + nr * PAGE_SIZE) must for sure be within a single PTE
>>>>>> table?
>>>>>
>>>>> Caller has made sure that (see folio_referenced_one()).
>>>>
>>>> You should comment this somehow, I hate this nested assumptions stuff 'function
>>>> X which calls function Y which calls function Z makes sure that parameter A
>>>> fulfils requirements B but we don't mention it anywhere'.
>>>
>>> Sure.
>>>
>>>>>>>     	int young = 0;
>>>>>>>     	int i;
>>>>>>>
>>>>>>> -	ptep = contpte_align_down(ptep);
>>>>>>> -	addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
>>>>>>> +	if (pte_cont(__ptep_get(ptep + nr - 1)))
>>>>>>> +		end = ALIGN(end, CONT_PTE_SIZE);
>>>>>>
>>>>>> OK so I guess for PTE_CONT to be set, it must be aligned to CONT_PTE_SIZE,
>>>>>> with other PTE entries present there not having PTE_CONT set (Ryan - do
>>>>>> correct me if I'm wrong!)
>>>>>>
>>>>>> I guess then no worry about running off the end of the PTE table here.
>>>>>>
>>>>>> I wonder about using pte_cont_addr_end() here, but I guess you are not
>>>>>> intending to limit to a range here but rather capture the entire contpte
>>>>>> range of the end.
>>>>>
>>>>> Right.
>>>>>
>>>>>> I don't love that now a function prefixed with contpte_... can have a
>>>>>> condition where part of the input range is _not_ a contpte entry, or is
>>>>>> specified partially...
>>>>>
>>>>> Like I said above, this is outside the scope of my patchset. If Ryan also
>>>>> thinks we need to do some cleanups for all the contpte_xxx() functions in
>>>>> the contpte.c file, we can send a follow-up patchset to rename all the
>>>>> contpte_xxx() functions to make it clear.
>>>>
>>>> It's really not outside of the scope of the patch set, this is review feedback
>>>> you have to address :) trying not to be a grumpy kernel dev here :>)
>>>>
>>>> In general in the kernel we don't accept confusing patches then defer making
>>>> them not-confusing until later.
>>>>
>>>> We review until the series is at the correct standard to be accepted before we
>>>> merge.
>>>>
>>>> As always I'm happy to be convinced that I'm mistaken or something's not
>>>> necesary, however!
>>>
>>> Yes, let me try to explain it again. See below.
>>>
>>>>>>> -	for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
>>>>>>> -		young |= __ptep_test_and_clear_young(vma, addr, ptep);
>>>>>>> +	if (pte_cont(__ptep_get(ptep))) {
>>>>>>> +		start = ALIGN_DOWN(start, CONT_PTE_SIZE);
>>>>>>> +		ptep = contpte_align_down(ptep);
>>>>>>> +	}
>>>>>>> +
>>>>>>> +	nr = (end - start) / PAGE_SIZE;
>>>>>>
>>>>>> Hm don't love this reuse of input param.
>>>>>
>>>>> OK. Will use another local variable instead.
>>>>
>>>> Thanks.
>>>>
>>>>>
>>>>>>
>>>>>>> +	for (i = 0; i < nr; i++, ptep++, start += PAGE_SIZE)
>>>>>>> +		young |= __ptep_test_and_clear_young(vma, start, ptep);
>>>>>>
>>>>>> Again, overall find it a bit iffy that we are essentially overloading the
>>>>>> code with non-contpte behaviour.
>>>>>
>>>>> Let me clarify further: this is the handling logic of the contpte_xxx()
>>>>> functions in the contpte.c file. For example, the function
>>>>> contpte_set_ptes() has a parameter 'nr', which may be greater than
>>>>> CONT_PTES, meaning that it can handle multiple CONT_PTES range sizes of a
>>>>> large folio.
>>>>>
>>>>> It might be a bit confusing, and I understand this is why you want to change
>>>>> the 'contpte_' prefix to the 'batch_' prefix. Of course, we can hope Ryan
>>>>> can provide some input on this.
>>>>>
>>>>> Thanks for reviewing.
>>>>
>>>> OK so we have some reeeeal confusion here. And this speaks to the patch needing
>>>> work.
>>>>
>>>> This seems to answer what I asked above - basically - are we doing _batches_ of
>>>> _contpte_ entries, or are we just accepting arbitrary large folios here and
>>>> batching up operations on them, including non-contpte entries.
>>>>
>>>> Presumably from the above you're saying - this is dealing with batches of
>>>> contpte entries.
>>>>
>>>> In which case this has to be made _super_ clear. Not just adding an arbitrary
>>>> 'nr' parameter and letting people guess.
>>>>
>>>> The contpte code is _already_ confusing and somewhat surprising if you're not
>>>> aware of it, we need to be going in the other direction.
>>>
>>> Sure. Sorry for causing confusion. I try to explain it again to make it
>>> clear.
>>>
>>> First, it is necessary to explain how the contpte implementation in Arm64 is
>>> exposed, using set_ptes() as an example.
>>>
>>> Arm64 defines an arch-specific implementation of set_ptes():
>>> "
>>> static __always_inline void set_ptes(struct mm_struct *mm, unsigned long
>>> addr,
>>> 				pte_t *ptep, pte_t pte, unsigned int nr)
>>> {
>>> 	pte = pte_mknoncont(pte);
>>>
>>> 	if (likely(nr == 1)) {
>>> 		contpte_try_unfold(mm, addr, ptep, __ptep_get(ptep));
>>> 		__set_ptes(mm, addr, ptep, pte, 1);
>>> 		contpte_try_fold(mm, addr, ptep, pte);
>>> 	} else {
>>> 		contpte_set_ptes(mm, addr, ptep, pte, nr);
>>> 	}
>>> }
>>> "
>>>
>>> Here, 'nr' refers to consecutive (present) PTEs that map consecutive pages
>>> of the same large folio within a single VMA and a single page table. Based
>>> on 'nr', it determines whether the PTE_CONT attribute should be set or not.
>>>
>>> Second, the underlying implementation of contpte_set_ptes() also calculates
>>> 'end' based on 'nr' and checks whether the PTE_CONT attribute should be set.
>>> For example:
>>>
>>> For a large folio with order = 3 (nr = 8), the PTE_CONT attribute will not
>>> be set since the 'next' is not aligned with CONT_PTE_MASK.
>>>
>>> For a large folio with order = 4 (nr = 16), it aligns perfectly, allowing
>>> the PTE_CONT attribute to be set for the entire PTE entries of the large
>>> folio.
>>>
>>> For a large folio with order = 5 (nr = 32), this involves two ranges of
>>> CONT_PTE_SIZE (16 PTEs in each range), requiring the PTE_CONT attribute to
>>> be set separately for each range.
>>>
>>> "
>>> void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
>>> 					pte_t *ptep, pte_t pte, unsigned int nr)
>>> {
>>> 	.......
>>>
>>> 	end = addr + (nr << PAGE_SHIFT);
>>> 	pfn = pte_pfn(pte);
>>> 	prot = pte_pgprot(pte);
>>>
>>> 	do {
>>> 		next = pte_cont_addr_end(addr, end);
>>> 		nr = (next - addr) >> PAGE_SHIFT;
>>> 		pte = pfn_pte(pfn, prot);
>>>
>>> 		if (((addr | next | (pfn << PAGE_SHIFT)) & ~CONT_PTE_MASK) == 0)
>>> 			pte = pte_mkcont(pte);
>>> 		else
>>> 			pte = pte_mknoncont(pte);
>>>
>>> 		__set_ptes(mm, addr, ptep, pte, nr);
>>>
>>> 		addr = next;
>>> 		ptep += nr;
>>> 		pfn += nr;
>>>
>>> 	} while (addr != end);
>>> }
>>> "
>>>
>>> Third, regarding the implementation of my patch, I have followed the contpte
>>> logic here by adding the 'nr' parameter to
>>> contpte_ptep_test_and_clear_young() for batch processing consecutive
>>> (present) PTEs. Moreover, the semantics of 'nr' remain consistent with the
>>> original contpte functions, and I have not broken the existing contpte
>>> implementation logic.
>>
>> OK that helps a lot thanks.
>>
>> So the nr will be number of PTEs that are consecutive, belong to the same folio,
>> and have the same PTE bit set excluding accessed, writable, dirty, soft-dirty.
> 
> I'm not sure test_and_clear_young_ptes() would technically require all of these
> constraints. I think it would be sufficient to just ensure that all the PTEs in
> the batch are pte_present(). And I assume the return value is intended to
> indicate if *any* of the PTEs in the batch were previously young?

Agree.

> The usual order for adding new batched PTE helpers is to define the generic
> function along with it's spec in a comment block and provide a default
> implementation that is implemented as a loop around the existing non-batched
> version of the interface. Then you can convert the core-mm to use that API. And
> finally you can opt arm64 into overriding the API with a more efficient
> implementation.
> 
> If you were to do it in that order, it tells a better story and is easier to
> follow, I think.

Good point. Let me rearrange the patch set.

> 
>>
>> But since we are retrieving accessed bit state (young), isn't it a problem we're
>> ignoring this bit when considering what goes into the batch?
>>
>> I mean now it's going to return true even if some do not have the accessed flag
>> set?
> 
> test_and_clear_young_ptes() is exploiting the fact that the kernel tracks young
> (and dirty) per *folio*. So having a young and dirty bit per PTE is providing
> more information than the kernel needs if a large folio is mapped across
> multiple PTEs. Which is why returning the logical OR of the access bits is ok here.

Right. Agree.

>> I am more convinced things are correct in style at least then this way as, as
>> you say, this is the approach taken in set_ptes().
> 
> I'm personally ok with the style and I believe the implementation is correct.
> But it would help to reformulate the series in the order I suggest above since
> then we can review against the spec of what the core-mm helper is supposed to do.

Sure. Thanks for reviewing.

