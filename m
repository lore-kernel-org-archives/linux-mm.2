Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88114CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 16:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE02E8E0029; Fri, 17 Oct 2025 12:34:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6B0B8E001F; Fri, 17 Oct 2025 12:34:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32898E0029; Fri, 17 Oct 2025 12:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ABA938E001F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 12:34:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3412F140272
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:34:22 +0000 (UTC)
X-FDA: 84008153964.05.3EC3D85
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4A3E310000A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:34:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=myr4SkXl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760718860; a=rsa-sha256;
	cv=none;
	b=zWtwztYY8NgTk/j3C2KHH7ISZUJstA7gz/CfjmeJr4/lRZIFYSMLhljdGYUMxaydAUhM0o
	2nGcsg+pfzGmbOXx/jVfCAMlp2mMq5Q9I84AUvoPzgRxwqQrFfrCz/Ey1QFtRZWvl+pgu5
	pSEQrLunZ1Xn/ZI5UlaTcoJA5wW3Fvs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=myr4SkXl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760718860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=63B5giuwsrqD1TGKgD2XpSY/kJTU39pBIfxGfSElwbE=;
	b=kHN/ker+1G8zMU43iDssmc1vS+r9pDoTl2Mr11T3sG+Mvx34ZsK7tHHcnfJhyew+gAlS7j
	2KhRSDCGH9WgqR3kK5vDuWqKBpiJ3KrutosbtphN4xZVR07OZvZE0TqwrYhIudwvI+UccL
	AqPdetpeN1AvM1MNJznRHhltKgcgGNI=
Message-ID: <b5627e83-489c-4e16-910c-fe7e56912793@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760718854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=63B5giuwsrqD1TGKgD2XpSY/kJTU39pBIfxGfSElwbE=;
	b=myr4SkXlD/tSQXoAAqWnIf/m5D6HT9/H7eXzK5HeGTxdmgUN3DYlbUnK+zxNqiiSySBSoV
	hNkDgI6sWXwlX03YMuBVX5jcBMo51F+f3hhbmX2dVdi836d3Q/f87KGWA3+03tT/g2JgIJ
	UqXYROFPCR1U/jG0JEkVo3IGM8hX1JE=
Date: Sat, 18 Oct 2025 00:33:33 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: guard is_zero_pfn() calls
 with pte_present()
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Wei Yang <richard.weiyang@gmail.com>
References: <20251017093847.36436-1-lance.yang@linux.dev>
 <699b143a-cca4-486c-a4ad-d0be561d4ab2@lucifer.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <699b143a-cca4-486c-a4ad-d0be561d4ab2@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4A3E310000A
X-Stat-Signature: 49nnom1qnwg6zu7gijfq58xgk14sircf
X-HE-Tag: 1760718860-600942
X-HE-Meta: U2FsdGVkX1/emGXvis1hYNqr09VqFkhpvxQbGZw+JvBojhZnzNQ5uuMvjXqfWnA769VIGOic9MYV78xEc/vm3hhjBn/vaMEDNlAfzQDJfmRwndq+In9kdjxfMcWTPXQ7B0jg35D6HQk1GfkqdBtRgllyHrHez7e64+QiDw6Fh2plm3/FCBQvzcvQ8og3PkmCm8xCShJ0y8RgQ8uJPPM2OFSBD7g5h+l2Sni/DFe8MOaRLC3USa2T0Vq6gl4zBzvcqaPc8Go3cAptfOAUmFBtf3BCY5hb3Tb0JZfAAJvpGOn1c8Qx8cUFZtdiXXJGF59THbNsPTqh0lwSMh23xoPQFlxeM6r65gwfxHZG6IDjLyka74V2A7EaKmkrCFdlekInztb1pG6bauO93MydsndbZ5+AbNDzhxiYyPCeBH4qTzOX3CFu5brlyT7Z6GPjuH6fILowtr6LmR/n8fHiYvrRDzlifBlwS1M7dWBVcrHx0wm091Y+ZgU8S9sASUXEh9vXAyWRHI7LZYScObZ9ftfkgeddDl46rhCdi2PBPzGn1lIH6QRaOK4ZkAN3p6vM1l0x/MxJ+EKyHEJhhw1LF+rTEj6DO1GzjFCO/Fr3sGrOTM3+orbp3i+vGRIflpCPPicbkCr0dRrTciYUrmKXMTMHPNvOFh78GlN5lVsDFru6v6ecImDMafF6w1nRIV/kqtHJJ1uYNXshaGVrUO0ZeU+KcJHM4qjJwTBW9cldayAo1cOL9J/GRbNiI1FeF05Cgnih2MI8Saj2f5DD9nkmqaL1HKGeoErWy4kVhHXZuQt8MwUupntc7F3Yv+Y2WGl5O7cBrv8riIeGXSt9/2THhPb1ymHPe2xGy9gEU+AwDI+hucUz7+jnK0ksBazK5/UVazyvpsXlwf4Q21R/9JutMKUpsyAc1TZOzqAaTBru74v0GkF+fkm0xn1QwcL1zFoL2Ff6sN/k2H0Tne8hO25xtNM
 jV7QHm5j
 TonSNDsFwdqkljPr/Jwp/RqI1ClW1AZEGBXHw0+QDfXCgBm+T9d1pmKFe09zMvlCHQ23HtbV5xs/TnGDEGeB6HLGfB7j8BAii9HETs+NOuO8+Dt3lVbCpAeYuWCAw6kILMvz61F/ttW5kdoZE8QDOIAknaZ1wHo8vDTdDNPTi43lp1QR/y5T6g3J4WDVIpbCYVIU+VSIgvSRKxIgJ1dQJfyEPYyitssRRmUngbzyBRWU679FUL/T8M9+cYZoHxwgpQ1NxW5QQzyYze6xbH3mhgPKK0Y29YMaRuXltvy0+gOsTPdMhRRDjLzIJOqLPrBSFdi2SoXWMAU7yrSCuWGEpYn7kACJkNheB6gDimDkz1xBdVzV42NUVncXUwJZzIqLjnlBZPg8ZJ1X31sbaNFd9oJ3tFdXzR3hVVb5A/1evqQPt5OhqEh8AgsvYl2VAEKXdlLdCXBjbi9aK5mZdH5y+Si4PL9CgQ+BgrFvy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/17 23:44, Lorenzo Stoakes wrote:
> On Fri, Oct 17, 2025 at 05:38:47PM +0800, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> A non-present entry, like a swap PTE, contains completely different data
>> (swap type and offset). pte_pfn() doesn't know this, so if we feed it a
>> non-present entry, it will spit out a junk PFN.
> 
> It feels like this somewhat contradicts points I've made on the original series
> re the is_swap_pte() stuff. Sigh.

My bad. I didn't get your point before ...

And this patch is not intended to touch is_swap_pte() ...

> 
> I guess that's _such a mess_ it's hard to avoid though.
> 
> And I guess it's reasonable that !pte_present() means we can't expect a valid
> PFN though.

Yes, I think we expect a valid PFN must be under pte_present().

> 
>>
>> What if that junk PFN happens to match the zeropage's PFN by sheer
>> chance? While really unlikely, this would be really bad if it did.
>>
>> So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
>> in khugepaged.c are properly guarded by a pte_present() check.
>>
>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
> Not sure I really suggested something that strictly contradicts points I
> made... but I guess I did suggest guarding this stuff more carefully.

Sorry, I didn't catch you again ... Will drop the Suggested-by tag.

> 
>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>> Applies against commit 0f22abd9096e in mm-new.
>>
>> v1 -> v2:
>>   - Collect Reviewed-by from Dev, Wei and Baolin - thanks!
>>   - Reduce a level of indentation (per Dev)
>>   - https://lore.kernel.org/linux-mm/20251016033643.10848-1-lance.yang@linux.dev/
>>
>>   mm/khugepaged.c | 29 ++++++++++++++++-------------
>>   1 file changed, 16 insertions(+), 13 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index d635d821f611..648d9335de00 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -516,7 +516,7 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>>   		pte_t pteval = ptep_get(_pte);
>>   		unsigned long pfn;
>>
>> -		if (pte_none(pteval))
>> +		if (!pte_present(pteval))
>>   			continue;
>>   		pfn = pte_pfn(pteval);
>>   		if (is_zero_pfn(pfn))
>> @@ -690,17 +690,18 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>>   	     address += nr_ptes * PAGE_SIZE) {
>>   		nr_ptes = 1;
>>   		pteval = ptep_get(_pte);
>> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> +		if (pte_none(pteval) ||
>> +		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>>   			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
>> -			if (is_zero_pfn(pte_pfn(pteval))) {
>> -				/*
>> -				 * ptl mostly unnecessary.
>> -				 */
>> -				spin_lock(ptl);
>> -				ptep_clear(vma->vm_mm, address, _pte);
>> -				spin_unlock(ptl);
>> -				ksm_might_unmap_zero_page(vma->vm_mm, pteval);
>> -			}
>> +			if (pte_none(pteval))
>> +				continue;
> 
> Yeah I'm not sure I really love this refactoring.
> 
> Can be:
> 
> 		if (!is_swap_pte(pteval)) {
> 			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
> 			if (!is_zero_pfn(pte_pfn(pteval)))
> 				continue;
> 
> 			...
> 		}
> 
> Doing pte_pfn() on a pte_none() PTE is fine.
> 
> Obviously as theree's a lot of hate for is_swap_pte() you could also do:
> 
> 		if (pte_none(pteval) || pte_present(pteval)) {
> 			...
> 		}
> 
> Which literally open-codes !is_swap_pte().
> 
> At the same time, this makes very clear that PTE none is OK.

Emm, I'd prefer the new helper pte_none_or_zero() here:

if (pte_none_or_zero(pteval)) {
	add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
	if (pte_none(pteval))
		continue;
	....
}
That looks really clean and simple for me ;)

> 
>> +			/*
>> +			 * ptl mostly unnecessary.
>> +			 */
>> +			spin_lock(ptl);
>> +			ptep_clear(vma->vm_mm, address, _pte);
>> +			spin_unlock(ptl);
>> +			ksm_might_unmap_zero_page(vma->vm_mm, pteval);
>>   		} else {
>>   			struct page *src_page = pte_page(pteval);
>>
>> @@ -794,7 +795,8 @@ static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
>>   		unsigned long src_addr = address + i * PAGE_SIZE;
>>   		struct page *src_page;
>>
>> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> +		if (pte_none(pteval) ||
>> +		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>>   			clear_user_highpage(page, src_addr);
>>   			continue;
>>   		}
>> @@ -1294,7 +1296,8 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>   				goto out_unmap;
>>   			}
>>   		}
>> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> +		if (pte_none(pteval) ||
>> +		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>>   			++none_or_zero;
>>   			if (!userfaultfd_armed(vma) &&
>>   			    (!cc->is_khugepaged ||
>> --
>> 2.49.0
>>
> 
> I mean all of this seems super gross anyway. We're constantly open-coding the
> same check over and over again.
> 
> static inline bool pte_is_none_or_zero(pte_t pteval)
> {
> 	if (is_swap_pte(pteval))
> 		return false;
> 
> 	return is_zero_pfn(pte_pfn(pteval));
> }
> 
> Put somewhere in a relevant header file.
> 
> Or again, if there's distaste at is_swap_pte(), and here maybe it's more valid
> not to use it (given name of function).
> 
> static inline bool pte_is_none_or_zero(pte_t pteval)
> {
> 	/* Non-present entries do not have a PFN to check. */
> 	if (!pte_present(pteval))
> 		return false;
> 
> 	if (pte_none(pteval))
> 		return true;
> 
> 	return is_zero_pfn(pte_pfn(pteval));
> }

Yeah, I'll put pte_none_or_zero() in this file first.

static inline bool pte_none_or_zero(pte_t pte)
{
	if (pte_none(pte))
		return true;
	return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
}

> 
> I think I'm going to do a series to addres the is_swap_pte() mess actually, as
> this whole thing is very frustrating.

Excellent! Looking forward to your series to clean that up ;)

Thanks,
Lance

