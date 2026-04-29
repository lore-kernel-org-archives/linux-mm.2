Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AAF4FF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 07:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B25046B0005; Wed, 29 Apr 2026 03:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD60A6B008A; Wed, 29 Apr 2026 03:34:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12B96B008C; Wed, 29 Apr 2026 03:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8E8AF6B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:34:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2663F1BA100
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:34:18 +0000 (UTC)
X-FDA: 84710780196.28.46380E2
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2F1A08000B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:34:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="X2/PZY4O";
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777448056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zIL8K56S9npqUxHnLTScIQqWnQWfossAlk/lIWVrpJQ=;
	b=y6nz6fZEb4hwuq62ehhAR2SeiKNu4WxVt8GScXiqwTuMU+EWpulpV9tM1Hwo2joaywilGq
	tXBm7eMKKP9KBXE5PMO/SFaZdPObuwvhEozpq8T1EBeZekskDJ1+QZ9fNI9hwFhods6R20
	GvyTgAg5vBQTwYs2qnJ3gWHNYzDibeY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="X2/PZY4O";
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777448056; a=rsa-sha256;
	cv=none;
	b=xK8JxCWIVfGvfNSnvHZ1DWBtwJdN82sALbKLl0HkSxrOaqxa5HxeCzSpKH2Th0RGHCD1IR
	fac4+WXDQfYAjA/SV2C4/+INOsrMzCpqJEZMBSFDaBYvbIrhmwTELzzndKs+g0PGNq4UqH
	u+3k81D9Tzhq/ZKaf5oqAYaNYphdv08=
Message-ID: <aa3937bb-7f06-4136-ba36-ce4a06acf80a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777448054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zIL8K56S9npqUxHnLTScIQqWnQWfossAlk/lIWVrpJQ=;
	b=X2/PZY4OO8j6f7/nd4NAkS2hw/5/L+G2uU77o9zwSFWubg7WJkk6AhLQ1/hineBbZbA8gf
	pE8sIk+WiwgXei0G93BbFX7fz8OAFoP2uokF3JIWmypGqq3QXykeTI9ToN/XxehiWx6S4A
	XMphNyFcOF309w9G+DXJKYEoPP1GrD8=
Date: Wed, 29 Apr 2026 15:33:52 +0800
MIME-Version: 1.0
Subject: Re: [PATCH hotfix] mm: fix pmd_special() fallback to observe
 huge_zero
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>, hughd@google.com
Cc: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, dev.jain@arm.com, liam.howlett@oracle.com,
 ljs@kernel.org, mhocko@suse.com, rppt@kernel.org, npache@redhat.com,
 zhengqi.arch@bytedance.com, ryan.roberts@arm.com, surenb@google.com,
 ziy@nvidia.com, linux-mm@kvack.org
References: <e7cbc92b-ce9d-432a-ae5b-c8715dcd922f@kernel.org>
 <20260429065743.67054-1-lance.yang@linux.dev>
 <ea1453a6-14c9-4334-ac7e-2758586393b2@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <ea1453a6-14c9-4334-ac7e-2758586393b2@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2F1A08000B
X-Rspam-User: 
X-Stat-Signature: skz7ytgkdmyutwpmxyeumpzn4stxapwf
X-HE-Tag: 1777448055-727118
X-HE-Meta: U2FsdGVkX1/YYBB3SlS9CifjUBML6RueLuhahjZO5wgulrAvj1EX2cyXqAGKnENoofCaaUDsRKEIs6pAeF53wh2wJ8oU6WNkRgfsl2mF/bebmMlG8RtKdWr/NcaUq05MHnm4fkuFznipXDzKP+8I3/4gjKzCRXp/gDp6HaWzbNhWDVS6GncHkHpK8QsmiyNYuRmvGloMnLd/LF4KD8UpHF1N/vdDht9krWEN7+hC7qL4fS+dsIQeidruLPz9PFYrzF6/W49+B+UJHn9kk8PMyio+6qWWVLBGDIig3XYgOg58YSMxiSfatz9XH9OqjCvAqfG+gJ0oltTo65U5PKwmqzfSHeVF2jdKpkEOXnt1AgUk/8J2e0wqe7HZsZXlZdlMEC45n4eff9j3C5e/BqXCgcCPX/RnNwn2RD8Ap2FRA5Ry4ZTNghhox8eRdsQMQhoU5eLgYjzZWWhe/xJBXUbPvbxXvoz7GIjzgbe0Jelm4rXQO9LSWDyyrUmr46nJS2NrWyhGyZl5uBrNXOITQ29I5vgixkSqjj5IxXOllcKbblvIkAqZYmgfYTop2E9b7GY+fxtda+MyCr46yQtPKV96ezu5Y/0zqnLDbWxnVGSolpxJeb0LJ256aybqPl8c2jkGKC32xOwL0T3qAa8KkwDLqB0v0JY9ql5FnCMW/f0fql93NZv/m1D5sp/CgAy7+kaGRGlRxfM0YJ0+NPsGyMMO0VKPZKc+Ge534TR6nm3vhAqeDKeZoFDk3/xpYbRhe0fMXP5uu7s/VdXuW1yM/xSMEo4T9KWoGg7qlRxn4+IqfT76bOmBaReACNyNgFY4AV0jrCWgZKVxnnKfxuS0W1MeHcAPviFV1MllvogSOuuBluB+swmDT8F0+5rbsDpLkV2B1XfKs8chVnqmlOacicIZ++UF6NfyrQRAkO3Nr/YbutIt50Is233TPJ/A7mDB+b/p542tvyC8qfQIXLTRMIJ
 cuZ7/SDO
 SX8svRpLW85QhKMpij+BPPNJ9UgKOgxJccXXa1AjDUcdihMdHGXAZGOP5NMttPdXOCM+YRw9MGY6YEjnX91EGMP2R8wUjXmIakpc4er5zWziHuzEnNynVjaMMXdB/aFrIxe5/5G2v0KRn6QWIxnY0ZXNitRlep559pzk/1xL3HdBVgP3QoFOEbeye9wK6f6jukbu6goF3B2W2Td1kT0YxStIqvqADKPWYrmdM2kpxm1lhC5iqWx8bSYwAK7LgGfcfldY5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/29 15:14, David Hildenbrand (Arm) wrote:
> On 4/29/26 08:57, Lance Yang wrote:
>>
>> On Wed, Apr 29, 2026 at 08:12:55AM +0200, David Hildenbrand (Arm) wrote:
>>> On 4/29/26 07:54, Lance Yang wrote:
>>>>
>>>>
>>>> Good catch!
>>>>
>>>
>>> Likely it should be
>>>
>>> 	Fixes: d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero folio special")
>>>
>>> Because vm_normal_page_pmd() would return the wrong thing.
>>
>> Right.
>>
>>> But I am surprised that we didn't run into the
>>>
>>> 	VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn));
>>>
>>> earlier. 	
>>
>> The history seems to be:
>>
>> 	2025-09-13 d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero folio special")
>> 	2025-09-13 af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
>>
>> After d82d09e48219, vm_normal_page_pmd() still had the explicit huge
>> zero check before returning the page:
>>
>> --8<---
>> struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
>> 				pmd_t pmd)
>> {
>> 	unsigned long pfn = pmd_pfn(pmd);
>>
>> 	if (unlikely(pmd_special(pmd)))
>> 		return NULL;
>>
>> 	if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
>> 		if (vma->vm_flags & VM_MIXEDMAP) {
>> 			if (!pfn_valid(pfn))
>> 				return NULL;
>> 			goto out;
>> 		} else {
>> 			unsigned long off;
>> 			off = (addr - vma->vm_start) >> PAGE_SHIFT;
>> 			if (pfn == vma->vm_pgoff + off)
>> 				return NULL;
>> 			if (!is_cow_mapping(vma->vm_flags))
>> 				return NULL;
>> 		}
>> 	}
>>
>> 	if (is_huge_zero_pfn(pfn))
>> 		return NULL;
>> 	if (unlikely(pfn > highest_memmap_pfn))
>> 		return NULL;
>>
>> 	/*
>> 	 * NOTE! We still have PageReserved() pages in the page tables.
>> 	 * eg. VDSO mappings can cause them to exist.
>> 	 */
>> out:
>> 	return pfn_to_page(pfn);
>> }
>> ---
>>
>> So even if pmd_mkspecial() was a no-op and pmd_special() stayed false,
>> we would still return NULL there.
>>
>> Then af38538801c6 moved the PMD path into __vm_normal_page():
>>
>> ---8<---
>> struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
>> 				pmd_t pmd)
>> {
>> 	return __vm_normal_page(vma, addr, pmd_pfn(pmd), pmd_special(pmd),
>> 				pmd_val(pmd), PGTABLE_LEVEL_PMD);
>> }
>> ---
>>
>> For CONFIG_ARCH_HAS_PTE_SPECIAL=y, __vm_normal_page() only returns NULL
>> for the huge zero PFN if special == true. On x86 32-bit, pmd_special()
>> stays false, so this can now fall through to VM_WARN_ON_ONCE():
>>
>> ---8<---
>> 	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
>> 		if (unlikely(special)) {
>> 			if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
>> 				return NULL;
>> ...
>> 		}
>> ...
>> 	} else {
>> ...
>> 		if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
>> 			return NULL;
>> 	}
>>
>> ...
>> 	VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn));
>> ...
>> ---
>>
>> So my guess is that the warning above became possible after
>> af38538801c6, IIUC.
> 
> Yes, I think you are right about af38538801c6.
> 
> What about the following then as a temporary solution:

Nice, that works for me :)

> diff --git a/mm/memory.c b/mm/memory.c
> index 199214f8de08..bf447c8b2f57 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -684,7 +684,9 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
>                  unsigned long addr, unsigned long pfn, bool special,
>                  unsigned long long entry, enum pgtable_level level)
>   {
> -       if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
> +       if ((IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL) && level == PGTABLE_LEVEL_PTE) ||
> +           (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && level == PGTABLE_LEVEL_PMD) ||
> +           (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && level == PGTABLE_LEVEL_PUD)) {
>                  if (unlikely(special)) {
>   #ifdef CONFIG_FIND_NORMAL_PAGE
>                          if (vma->vm_ops && vma->vm_ops->find_normal_page)
> 
> 
> We could wrap the check in a fancy helper.


Cheers,
Lance


