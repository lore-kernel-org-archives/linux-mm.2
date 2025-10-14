Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3061ACCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85C2C8E012B; Tue, 14 Oct 2025 10:26:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833F58E010A; Tue, 14 Oct 2025 10:26:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770808E012B; Tue, 14 Oct 2025 10:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 661608E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:26:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 260DE5BDDF
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:26:33 +0000 (UTC)
X-FDA: 83996945466.30.C47710F
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf07.hostedemail.com (Postfix) with ESMTP id D3EE540009
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:26:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S2d02oP1;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760451991; a=rsa-sha256;
	cv=none;
	b=Boy/hVLVT4576rKOrOqZ4pZhtuFQLXGTHgB3IlJRSCt3dLRM3HP9is9KVw/VkxHIkw42i7
	nNS9ZUZb6L15RNeGB2bBNZL3tPHCaSJeWmb6lo0tnTK9RDAQ9T8l0NrgopwGXzhPExTx7K
	Xtj7URn6OvE1VzR0q7beLa1Opbm2Oms=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S2d02oP1;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760451991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKOwPD9G8+OZsBs9+tZFf861qaxj85J1wxUDauqNxYI=;
	b=tA8Nuv4amQG3MmnKXgRUkiUFWhcxoTWSH4g2LoJvfBZ/IDXl0zBR7nBvdWDj9xepspSFrS
	lekxRrYwbQ7KQ7XikaHsTO/xeBCjJSHsXvcRIzXkKUx7tjCWvUdxoMM/reUvnjGANRe69E
	vji/8a/2+5ziS6Z7mcQ56vA5Tr2JhIE=
Message-ID: <0bfdbccd-9d4a-409f-ae43-b44bb7347d70@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760451987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yKOwPD9G8+OZsBs9+tZFf861qaxj85J1wxUDauqNxYI=;
	b=S2d02oP1UEv0IRpH1hPdj4EYsQk3cuYBa+siMbrG6yg8lsb0Eb54XTRSWFCRjW1mKap5LU
	Lcj0vNxI9p3glvUB3dU0luEwJyWUrP0wvGsGG/YKJGBq7XeW7N9eZ46svhm166sLw1rVV9
	M2GDxG1qcN0Vf8qmrEzHerBdJO7aWc8=
Date: Tue, 14 Oct 2025 22:26:20 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, Liam.Howlett@oracle.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, dev.jain@arm.com,
 hughd@google.com, ioworker0@gmail.com, kirill@shutemov.name,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mpenttil@redhat.com,
 npache@redhat.com, ryan.roberts@arm.com, ziy@nvidia.com,
 richard.weiyang@gmail.com
References: <20251008032657.72406-1-lance.yang@linux.dev>
 <f33735d3-b38d-4b6a-aeba-b415e6b24ea2@lucifer.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <f33735d3-b38d-4b6a-aeba-b415e6b24ea2@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 8sunxcipokzi31iaic65dbok3oiq9xym
X-Rspamd-Queue-Id: D3EE540009
X-Rspamd-Server: rspam09
X-HE-Tag: 1760451989-418726
X-HE-Meta: U2FsdGVkX1/5waOpLBU3uPRmE4Dm3I7YeEx2747agdMGA3The3xb/ypN9IlozxEoDpQA18DNXhFnvHnP+jYNH7KVpd+TDpjSxbLuJNmyqPzFWLFOb0ccSHTfZesrJvrXvNKfSW5Wwc6Mu7mn9zsW5zXMEBmK2nfcExx8m+xGMFvq/oYBMcTjFJoyYMfsbo4PG74cTvd3w1L4p5ffB/Xwhncb1A9piCBgJanxFpyGbE+Eithv/oVjHxMbodyOi6M9QRVEujkaw7vimuSIEFUbkC7AvZlR94uQyD0GGyOW2zhEnky13XN+AOjxt/u6B2IRZOJG4RV9MD1e5Ip3inM67Oc9oFSr/l1O7yt43+c+QXxcHXh2+8oFeiCBWblqll8/tqZM9l0KEGpeio8xvkyWKa+OznArVBNVtOcl53a8Rk1Q6QxVMK/MbnAPIneL3dAtx0NzLro+ObRUdORalMuwTOxJcPS5AKBXwBKAPh322NMZ6YGCRUIjEq+JcUrLrA4ySbNCRes4wM8zRMSJsmtALxRRXfVs02rsAW+zvTmzeddPmm6xmzRFUvafYzHo1HTisuaFes497jD3Ax3Apq6p6lZXldly3HRbLgHld5lD/bRAE+9LbQhF3zFRm54AIkrN/Rm7H6x/5OzLRTpa9nf5C26XQm7ZEHzZajqmmT/bZd3XVHpkfWQgd2tZzsQ62aWCiKm8FaCgjAtbdlQe4tLNn1/fvWi3ePUKygY76z48D9f8XdyO6HGVY7f4+AiayDzKZ6mYi6ttpmCOg+UJJsIWQoSU7Ot9Kpvz5kAq64ZD5hc+Y4UB202X0INzvzpoBL0GXa28L9IM2UOwAsDq3GmfcOJPP9Q2cRwBziTLqitSMKlZRoG3rCNz8h0MGC8v7UNDOFIfiVaTF8O3jsxXnlOS8+fNYuHsYKNn+522WUwxnoetnFKgd7UQ8nfEO3W8lbZ7kJ9AGHjo0Qe+IIZZFWU
 RlRlRP2m
 iCubV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/14 19:08, Lorenzo Stoakes wrote:
> On Wed, Oct 08, 2025 at 11:26:57AM +0800, Lance Yang wrote:
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index abe54f0043c7..bec3e268dc76 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1020,6 +1020,11 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
>>   		if (!is_swap_pte(vmf.orig_pte))
>>   			continue;
>>
>> +		if (non_swap_entry(pte_to_swp_entry(vmf.orig_pte))) {
>> +			result = SCAN_PTE_NON_PRESENT;
>> +			goto out;
>> +		}
> 
> OK seems in line with what we were discussing before...

Yep. That's the idea :)

> 
>> +
>>   		vmf.pte = pte;
>>   		vmf.ptl = ptl;
>>   		ret = do_swap_page(&vmf);
>> @@ -1281,7 +1286,23 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>   	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>   	     _pte++, addr += PAGE_SIZE) {
>>   		pte_t pteval = ptep_get(_pte);
>> -		if (is_swap_pte(pteval)) {
>> +		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> +			++none_or_zero;
>> +			if (!userfaultfd_armed(vma) &&
>> +			    (!cc->is_khugepaged ||
>> +			     none_or_zero <= khugepaged_max_ptes_none)) {
>> +				continue;
>> +			} else {
>> +				result = SCAN_EXCEED_NONE_PTE;
>> +				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>> +				goto out_unmap;
>> +			}
>> +		} else if (!pte_present(pteval)) {
>> +			if (non_swap_entry(pte_to_swp_entry(pteval))) {
> 

Thanks for pointing that out!

> Hm but can't this be pte_protnone() at this stage (or something else)? And then

Yeah. The funny thing is, a protnone pte cannot actually get here, IIUC.

```
static inline int pte_protnone(pte_t pte)
{
	return (pte_flags(pte) & (_PAGE_PROTNONE | _PAGE_PRESENT))
		== _PAGE_PROTNONE;
}

static inline int pte_present(pte_t a)
{
	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
}
```

On x86, pte_present() returns true for a protnone pte. And I'd assume
other archs behave similarly ...

> we're just assuming pte_to_swp_entry() is operating on a swap entry when it in
> fact might not be?
> 
> Couldn't we end up with false positives here?

Emm, I think we're good here and the code is doing the right thing.

> 
>> +				result = SCAN_PTE_NON_PRESENT;
>> +				goto out_unmap;
>> +			}
>> +
>>   			++unmapped;
>>   			if (!cc->is_khugepaged ||
>>   			    unmapped <= khugepaged_max_ptes_swap) {
>> @@ -1290,7 +1311,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>   				 * enabled swap entries.  Please see
>>   				 * comment below for pte_uffd_wp().
>>   				 */
>> -				if (pte_swp_uffd_wp_any(pteval)) {
>> +				if (pte_swp_uffd_wp(pteval)) {
> 
> Again you're assuming it's a swap entry but you're not asserting this is a swap
> entry in this branch?

As we discussed above, the non_swap_entry() check has already kicked out
anything that isn't a true swap entry, right?

> 
> Also an aside - I hate, hate, hate how this uffd wp stuff has infiltrated all
> kinds of open-coded stuff. It's so gross (not your fault, just a general
> comment...)

Haha, tell me about it. No argument from me there ;)

Thanks,
Lance

