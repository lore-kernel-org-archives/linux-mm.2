Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92789CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8746D8E000C; Mon, 20 Oct 2025 10:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 825408E0002; Mon, 20 Oct 2025 10:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73B208E000C; Mon, 20 Oct 2025 10:59:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 600458E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:59:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C5AFC01AD
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:59:03 +0000 (UTC)
X-FDA: 84018800166.29.F955E96
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id 197568000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:59:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nP6Iqe3S;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760972341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m0ma2WKO11obahVHhDWDsmsHYDqO6Dhx6s7hPUoAius=;
	b=n9rM4Vdlcu8aquWjPnI2H8coDt4/9VtFHitDCBShXZPKpp3UU9A/5YcHHH1OsBpOjQkO86
	8KZ1NO2GVqA5d5tILQ7pfMH9Y8SF0AGpH5NNzK0fWoKzkfCOSYxu85m7VSyHTi6E3wtT+o
	04BUWb3k2RrybB1dMCld+SfxW3a629E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760972341; a=rsa-sha256;
	cv=none;
	b=aM0kqS9rjPwNI7hzRGRtmAs5xO6747oWt8vBY0u+Es1wVMWQegDy+8U9UOIh4vM5UBNOhw
	7sUt4Psfa4394o9OesDj5TMeuUPGnrHXAXMIhhMkMZ32ek0gjG8GAx/QdRUGKlYwBY1vhH
	CpGNeF/ZqKh7SnFjVH2HDHWSbPKGDfs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nP6Iqe3S;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <c1f01a29-e283-4557-8c76-3d17c0233ce8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760972338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m0ma2WKO11obahVHhDWDsmsHYDqO6Dhx6s7hPUoAius=;
	b=nP6Iqe3S4byuBHsYB6xrj4GYA5+Um0vVMnkFv+Gt80VtlRWuYhTB4SYNhlbPLfq4urNka7
	o0BfciXYyepX9fLYxx/iHk/ImRU67JfsAk11uGiAk7UaoQcb1Fu5AHNj3pIJJ0jP4D1hXf
	ohtxfJ/XWAKa1+nRV+NlGAJlOKoJWk8=
Date: Mon, 20 Oct 2025 22:58:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: guard is_zero_pfn() calls
 with pte_present()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Wei Yang <richard.weiyang@gmail.com>
References: <20251017093847.36436-1-lance.yang@linux.dev>
 <699b143a-cca4-486c-a4ad-d0be561d4ab2@lucifer.local>
 <b5627e83-489c-4e16-910c-fe7e56912793@linux.dev>
 <2caf088c-e321-428e-afce-b1c11f52bc3f@lucifer.local>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <2caf088c-e321-428e-afce-b1c11f52bc3f@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: fgwp9ccr64ez9xjrqzkyrqqrq6dusn5r
X-Rspam-User: 
X-Rspamd-Queue-Id: 197568000E
X-HE-Tag: 1760972340-458696
X-HE-Meta: U2FsdGVkX1+yfLYVOA63W4VD3m+ywKnm4EnikQiLwfo1axaNCsbTS6yU+t8YKGLFr9hIt7zEjMq21YFXLGyDB3zxTkW5PjfB9VTGEhQNcchODKHMDX5iaxXiSiYIwBh5/s6/dWTS5Z/8kmtLp5kO4nx6SIgvazx6QfE8cWZZT6ftccsWc80FwzMqzlnerM9ifMkdI7VW3EcUVv2WR8k88KEAzeRB6OKDVIbe4H1VENGoRvgmObJY5wn0A1MSJtQXuI1SzlCZ9yzUGLlWY5+TemOL2dBgANZH+CgxRITVNxSMFFfn4zW/byIUouVNmzYwPLsLVwd65J6tSfGAqem6iszBpvX4nT97zeLnwoOggt3LkqqM7SUS8qeTKsYd6zay2mRtt7PdkFdl7qFPl+9HXPbyMOXWShv70S/SzWy5rcRVRSH3wc0JXZV7NvtpAy6z2SK/ekBF7OEJE6kWQKeczBy2bUikP7J/NbtRaMFbmROLdm6kk7YpyVrIb7oPc+y2pY7WppcLZos6X+eUTDWUv0E208NBaN4Qik72+xuFZZmRknVsL6zjWbS4LEKDUmXGMCNyYFV9T/MqqUx2/LjZKuVFaVioQcpLjfShULvJtD99xvP/lf6b7LqVUXBjeEPlBhQMoECD7s2pmhiJJ2PDZMdOe58wsWlYOV2YCqV9KS2ADK3Aazgf0JHzBj6oX3SUOIV6mfs68E8lXKfbi/mtaoCYxSrThwuEG1wja4p+6xZWHILha7p7tBu79AJIYKWxQawZWx6+S/XcMIeYd82M5wVult/2hF3SD1cDQQjEHj4fnpXMoYv6V0msbNKyJzqe/SV4CWi4JzTML1trvvJC32IlSpzgz+rQzVx5b7zPVS7jqONG4JeRoN35Q6jmwGN/vYlLnSlivPYpjM8IvPoC5dO7Q/66mJBCyECej0ZJLJjuwl+IYEONiCq12c+JBsA4doo0aJMlS7LJAN4CZW2
 DOJvVcpr
 THJz1IEkRNmXDLALlIOrsRS9tave+yAijrcEXQUbmdabxlyGCMumAUhNXIK69E1qdGdxNiRHEuGLlcHRRdlPmteOiuEq8d4G5/JoY5JNmjocqahOoZYL6UmFok5b5Cj0gxQuBQWCcZayPaiNvcaN1J1MvYyOxD4M4erbUA3f9tqi4jan43zL4m4WBsFYsr7rbnuzZTDOFuqbkPDO4kOPdtxr4g54qXtDZCMOrHMZl1bD6A7MsDziXF/L0h2b8ULD52Nd7yHPLZ/rsbkSMdjGLuKgUlOP2lhvrtfINlWBxs76FBzoKWqAGEe/zF/uMu/LZOkG1NoX0k5b6hWxneCQ4N/SwfdZnAZXanTDEiXc5j1rAtbwiDlADTlPFwPJNpIPDzhhCZG7Ay/1aG4q3Tbp7ac+PZG+r5t8JclJ/O8M9vgTf+4TZqik/c5bvwcTNwMDPqgGfCGpVtI/GwHcsOEqwghFtqL5P6KEUr+vX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/20 21:55, Lorenzo Stoakes wrote:
> On Sat, Oct 18, 2025 at 12:33:33AM +0800, Lance Yang wrote:
>>
>>
>> On 2025/10/17 23:44, Lorenzo Stoakes wrote:
>>> On Fri, Oct 17, 2025 at 05:38:47PM +0800, Lance Yang wrote:
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> A non-present entry, like a swap PTE, contains completely different data
>>>> (swap type and offset). pte_pfn() doesn't know this, so if we feed it a
>>>> non-present entry, it will spit out a junk PFN.
>>>
>>> It feels like this somewhat contradicts points I've made on the original series
>>> re the is_swap_pte() stuff. Sigh.
>>
>> My bad. I didn't get your point before ...
> 
> Don't worry, this is a problem that existed already and needs addressing, series
> incoming :)

Nice!

> 
>>
>> And this patch is not intended to touch is_swap_pte() ...
> 
> Ack
> 
>>
>>>
>>> I guess that's _such a mess_ it's hard to avoid though.
>>>
>>> And I guess it's reasonable that !pte_present() means we can't expect a valid
>>> PFN though.
>>
>> Yes, I think we expect a valid PFN must be under pte_present().
> 
> Yes
> 
>>
>>>
>>>>
>>>> What if that junk PFN happens to match the zeropage's PFN by sheer
>>>> chance? While really unlikely, this would be really bad if it did.
>>>>
>>>> So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
>>>> in khugepaged.c are properly guarded by a pte_present() check.
>>>>
>>>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>
>>> Not sure I really suggested something that strictly contradicts points I
>>> made... but I guess I did suggest guarding this stuff more carefully.
>>
>> Sorry, I didn't catch you again ... Will drop the Suggested-by tag.
> 
> Nah it's fine sorry, I think in general you are doing what I asked.

Thanks for clarifying! I'll keep the Suggested-by tag then ;)

> 
> I'm going to address the is_swap_pte() stuff separately anyway :) have discussed
> with David off-list a lot. Think I have a sensible plan...

That's great to hear!

> 
>>
>>>
>>>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>>>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>> ---
>>>> Applies against commit 0f22abd9096e in mm-new.
>>>>
>>>> v1 -> v2:
>>>>    - Collect Reviewed-by from Dev, Wei and Baolin - thanks!
>>>>    - Reduce a level of indentation (per Dev)
>>>>    - https://lore.kernel.org/linux-mm/20251016033643.10848-1-lance.yang@linux.dev/
>>>>
>>>>    mm/khugepaged.c | 29 ++++++++++++++++-------------
>>>>    1 file changed, 16 insertions(+), 13 deletions(-)
>>>>
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index d635d821f611..648d9335de00 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -516,7 +516,7 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>>>>    		pte_t pteval = ptep_get(_pte);
>>>>    		unsigned long pfn;
>>>>
>>>> -		if (pte_none(pteval))
>>>> +		if (!pte_present(pteval))
>>>>    			continue;
>>>>    		pfn = pte_pfn(pteval);
>>>>    		if (is_zero_pfn(pfn))
>>>> @@ -690,17 +690,18 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>>>>    	     address += nr_ptes * PAGE_SIZE) {
>>>>    		nr_ptes = 1;
>>>>    		pteval = ptep_get(_pte);
>>>> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>>> +		if (pte_none(pteval) ||
>>>> +		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>>>>    			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
>>>> -			if (is_zero_pfn(pte_pfn(pteval))) {
>>>> -				/*
>>>> -				 * ptl mostly unnecessary.
>>>> -				 */
>>>> -				spin_lock(ptl);
>>>> -				ptep_clear(vma->vm_mm, address, _pte);
>>>> -				spin_unlock(ptl);
>>>> -				ksm_might_unmap_zero_page(vma->vm_mm, pteval);
>>>> -			}
>>>> +			if (pte_none(pteval))
>>>> +				continue;
>>>
>>> Yeah I'm not sure I really love this refactoring.
>>>
>>> Can be:
>>>
>>> 		if (!is_swap_pte(pteval)) {
>>> 			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
>>> 			if (!is_zero_pfn(pte_pfn(pteval)))
>>> 				continue;
>>>
>>> 			...
>>> 		}
>>>
>>> Doing pte_pfn() on a pte_none() PTE is fine.
>>>
>>> Obviously as theree's a lot of hate for is_swap_pte() you could also do:
>>>
>>> 		if (pte_none(pteval) || pte_present(pteval)) {
>>> 			...
>>> 		}
>>>
>>> Which literally open-codes !is_swap_pte().
>>>
>>> At the same time, this makes very clear that PTE none is OK.
>>
>> Emm, I'd prefer the new helper pte_none_or_zero() here:
>>
>> if (pte_none_or_zero(pteval)) {
>> 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
>> 	if (pte_none(pteval))
>> 		continue;
>> 	....
>> }
>> That looks really clean and simple for me ;)
> 
> Haha yeah sure that's better :)

Glad you like the pte_none_or_zero() helper. I'll go with that.

> 
>>
>>>
>>>> +			/*
>>>> +			 * ptl mostly unnecessary.
>>>> +			 */
>>>> +			spin_lock(ptl);
>>>> +			ptep_clear(vma->vm_mm, address, _pte);
>>>> +			spin_unlock(ptl);
>>>> +			ksm_might_unmap_zero_page(vma->vm_mm, pteval);
>>>>    		} else {
>>>>    			struct page *src_page = pte_page(pteval);
>>>>
>>>> @@ -794,7 +795,8 @@ static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
>>>>    		unsigned long src_addr = address + i * PAGE_SIZE;
>>>>    		struct page *src_page;
>>>>
>>>> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>>> +		if (pte_none(pteval) ||
>>>> +		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>>>>    			clear_user_highpage(page, src_addr);
>>>>    			continue;
>>>>    		}
>>>> @@ -1294,7 +1296,8 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>    				goto out_unmap;
>>>>    			}
>>>>    		}
>>>> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>>> +		if (pte_none(pteval) ||
>>>> +		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>>>>    			++none_or_zero;
>>>>    			if (!userfaultfd_armed(vma) &&
>>>>    			    (!cc->is_khugepaged ||
>>>> --
>>>> 2.49.0
>>>>
>>>
>>> I mean all of this seems super gross anyway. We're constantly open-coding the
>>> same check over and over again.
>>>
>>> static inline bool pte_is_none_or_zero(pte_t pteval)
>>> {
>>> 	if (is_swap_pte(pteval))
>>> 		return false;
>>>
>>> 	return is_zero_pfn(pte_pfn(pteval));
>>> }
>>>
>>> Put somewhere in a relevant header file.
>>>
>>> Or again, if there's distaste at is_swap_pte(), and here maybe it's more valid
>>> not to use it (given name of function).
>>>
>>> static inline bool pte_is_none_or_zero(pte_t pteval)
>>> {
>>> 	/* Non-present entries do not have a PFN to check. */
>>> 	if (!pte_present(pteval))
>>> 		return false;
>>>
>>> 	if (pte_none(pteval))
>>> 		return true;
>>>
>>> 	return is_zero_pfn(pte_pfn(pteval));
>>> }
>>
>> Yeah, I'll put pte_none_or_zero() in this file first.
>>
>> static inline bool pte_none_or_zero(pte_t pte)
>> {
>> 	if (pte_none(pte))
>> 		return true;
>> 	return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
>> }
> 
> Well I intended this to be in some general header file, but it's not obvious
> actually where would make sense so feel free to put here as a static (no need
> for inline).

Thanks! I will make it a static function in this file for now :)

> 
>>
>>>
>>> I think I'm going to do a series to addres the is_swap_pte() mess actually, as
>>> this whole thing is very frustrating.
>>
>> Excellent! Looking forward to your series to clean that up ;)
> 
> Already started on it :)

Cool! Really looking forward to the is_swap_pte() cleanup series!

Thanks,
Lance


