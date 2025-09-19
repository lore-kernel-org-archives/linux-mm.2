Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EED9CAC597
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 02:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A4F28E0053; Thu, 18 Sep 2025 22:42:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97CD58E0008; Thu, 18 Sep 2025 22:42:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B9988E0053; Thu, 18 Sep 2025 22:42:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 79D288E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:42:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 01D451DF7BB
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:42:02 +0000 (UTC)
X-FDA: 83904450126.21.9416A44
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id E728FA0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:42:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MKGEJivH;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758249721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LOUYmorl2vXwXIh7NZzsymKhAVYTrNuSDHQ/iAUV2PM=;
	b=eX/1YmszvK5jhToECLAq6p/QyEwP68l6p69rg5R4sGZIqOh5CFi+x+CC9kirzrchrIzcmc
	lUxMZJNuwL3pECGZ9Mo6XIziF69q0uOSpqJGvBB+7NvxGaEyygNll3P2btDAQAprKSM8Ks
	bkJSfonOtaEpcD9fYe9oyFtR2rzWDXM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MKGEJivH;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758249721; a=rsa-sha256;
	cv=none;
	b=ezDAlbnV86Y4P8oh9jCUlEJONfXSQYSOR6uofdIxkHTTLeBQAHHsa8VPZy4rgaQaJ8QXa5
	7Jq9HXaoyIf9WUGM+UOawDmda8K88nTbAwIj8uh9sX1wWijveUhYimTX6dMKs0UVDh1Vxz
	dLlPr3jbY1YgikM8mYBUa8a1LbCX9Ks=
Message-ID: <eabd866a-aed3-4e28-a139-13b7c1d4e715@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758249718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LOUYmorl2vXwXIh7NZzsymKhAVYTrNuSDHQ/iAUV2PM=;
	b=MKGEJivHc42R/NfCjKmZBd9XndL1e1w2iM+yb8YZwTHrId6TWcSYGjiKSX7sRiZAHwNOb9
	qieUWzLl8HTtNL7lz++Hv9jmKKrj+ksJOqEEptglJbcoV1CkSnmO/1ZBNiyXMakjXcG+gC
	BEE1Xne7+KnPXT/NAt8Zeu8zjX08zjA=
Date: Fri, 19 Sep 2025 10:41:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v2 2/2] mm/khugepaged: abort collapse scan on guard
 PTEs
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, ioworker0@gmail.com, kirill@shutemov.name,
 hughd@google.com, mpenttil@redhat.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <20250918050431.36855-1-lance.yang@linux.dev>
 <20250918050431.36855-3-lance.yang@linux.dev>
 <a696c734-9f88-4d6f-a852-013071a2dd2a@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <a696c734-9f88-4d6f-a852-013071a2dd2a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E728FA0008
X-Stat-Signature: nqwsyuk5fnup4mfgwe1y9b1jwd995q6g
X-HE-Tag: 1758249720-93364
X-HE-Meta: U2FsdGVkX1+6KIcbseSXBbfFj78JbwZHTsrXun7yTKPY5YpPDpPg+3ecEkGryyiv0xA0grwalLWb29nXu4CU10rLh3B4KG28iwFP2fJ5EPSQFSwGgV6gSkAgTLgjPS3gqYzdcDRWIdz1uGqkIzgoU/ixQLDz8LdIMFmOGGnyI+LOkoHIDv0MXP/1BspGuVzEuKBAwlXlnzletV0ygE1NVU3pybrxJRhwgPAWxEBgemFr+eD6eeTP6C+MKKQCvVd4lLALQNiguU+4kfEEfhovmk0sQAVy8eWEM0VHKLyZaTzvTLwoRBwWtZNrFxknWClX6lYlJb2jw23WDBQoJ3yHUIBWIrfgnPvAL8nsDvFUUm1LNcyeY7lP10RdDtr2lH+VpQGJ/29zxIa3LG8vTC188M6M9RO1k2pCJ9hInOdrVUBafwNOo1PfoSO/l/6zVW4NwvhcLlSlz+NhcxZxHchZwgeP7jv8zEbl2uuCZQxVk4ltySMhWX1ycaTkHeljxr05U/Ef8rDuypZBJ2U1T9h76BeqvkBXTMwmLp/34alPgFjcp1JVw6fdnx0nl1KPY44BWI0icHk6vpwF/TxXBBrExax0RBiKAhT1oq6/7mYTKz5TiEJMfYc+7udYQ3mpPCu1GpBpkns4pgOig8c1qD6upb1sqWq6RWRx9YTk659+EclWvXYCnA8ztxRay2jODSfpypiruLhzOQxmXcU5Bh+j1L9Kvd7glwQ+vT5Vzku3eASMFcrHlGbCsrE8OdT+72bmPvX0glSyOO54iSsSU19aZtkN8hiWYuSDFMVdXR9wlu9SjS+KgZmgeWWi8iV4PeyxkMRsONa1wYd9vPNZdjJp1n2CJTxNH88Id2z53wSAHq9yi7DjMvKc8jXEPBrUPlMTt/5f2lqSDAjilpqFKYhQEJmKui1ZS/wEXwdX1detMwTCn70TtSAQnyid35fJU+UH7hJhJcDbNV5tW8Pkauo
 oe6Bei9y
 FFcD+4RnZ6u2vFUk7z6pIKaph+91OduHm6yKwKpAQmrHN9lKa3/CR//yWqZ7/vHhoAZjOTatfzKSwtqrEDlOXa/IXZLcGl1YFLjEJVzWfZ5xEzudLORaHudW9D2gLqHr2TXrgti09heQihklSnUZnHT2jIFsfd2fuCx3TViVBcWT+4U1lVb3UdI9g496mfkoPP5hjCvYLtuCfyTh+iD+kPZ/R09yhNzu4P4yX+IFVrJdvf8ptE+RKwp3AzgA+ohEWVmJcoC0+HCK2fEF3rOjB5dYgybybRebV7FVqS0kgGpcGbJFPJzmLKa1EC+/iBC6dDw1GR4tnKuj0aWA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/19 02:47, David Hildenbrand wrote:
> On 18.09.25 07:04, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> Guard PTE markers are installed via MADV_GUARD_INSTALL to create
>> lightweight guard regions.
>>
>> Currently, any collapse path (khugepaged or MADV_COLLAPSE) will fail when
>> encountering such a range.
>>
>> MADV_COLLAPSE fails deep inside the collapse logic when trying to swap-in
>> the special marker in __collapse_huge_page_swapin().
>>
>> hpage_collapse_scan_pmd()
>>   `- collapse_huge_page()
>>       `- __collapse_huge_page_swapin() -> fails!
>>
>> khugepaged's behavior is slightly different due to its max_ptes_swap 
>> limit
>> (default 64). It won't fail as deep, but it will still needlessly scan up
>> to 64 swap entries before bailing out.
>>
>> IMHO, we can and should detect this much earlier.
>>
>> This patch adds a check directly inside the PTE scan loop. If a guard
>> marker is found, the scan is aborted immediately with 
>> SCAN_PTE_NON_PRESENT,
>> avoiding wasted work.
>>
>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   mm/khugepaged.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 9ed1af2b5c38..70ebfc7c1f3e 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1306,6 +1306,16 @@ static int hpage_collapse_scan_pmd(struct 
>> mm_struct *mm,
>>                       result = SCAN_PTE_UFFD_WP;
>>                       goto out_unmap;
>>                   }
>> +                /*
>> +                 * Guard PTE markers are installed by
>> +                 * MADV_GUARD_INSTALL. Any collapse path must
>> +                 * not touch them, so abort the scan immediately
>> +                 * if one is found.
>> +                 */
>> +                if (is_guard_pte_marker(pteval)) {
>> +                    result = SCAN_PTE_NON_PRESENT;
>> +                    goto out_unmap;
>> +                }
> 
> Thinking about it, this is interesting.
> 
> Essentially we track any non-swap swap entries towards 
> khugepaged_max_ptes_swap, which is rather weird.
> 
> I think we might also run into migration entries here and hwpoison entries?
> 
> So what about just generalizing this:
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index af5f5c80fe4ed..28f1f4bf0e0a8 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1293,7 +1293,24 @@ static int hpage_collapse_scan_pmd(struct 
> mm_struct *mm,
>          for (_address = address, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>               _pte++, _address += PAGE_SIZE) {
>                  pte_t pteval = ptep_get(_pte);
> -               if (is_swap_pte(pteval)) {
> +
> +               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> +                       ++none_or_zero;
> +                       if (!userfaultfd_armed(vma) &&
> +                           (!cc->is_khugepaged ||
> +                            none_or_zero <= khugepaged_max_ptes_none)) {
> +                               continue;
> +                       } else {
> +                               result = SCAN_EXCEED_NONE_PTE;
> +                               count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +                               goto out_unmap;
> +                       }
> +               } else if (!pte_present(pteval)) {
> +                       if (non_swap_entry(pte_to_swp_entry(pteval))) {
> +                               result = SCAN_PTE_NON_PRESENT;
> +                               goto out_unmap;
> +                       }
> +
>                          ++unmapped;
>                          if (!cc->is_khugepaged ||
>                              unmapped <= khugepaged_max_ptes_swap) {
> @@ -1313,18 +1330,7 @@ static int hpage_collapse_scan_pmd(struct 
> mm_struct *mm,
>                                  goto out_unmap;
>                          }
>                  }
> -               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> -                       ++none_or_zero;
> -                       if (!userfaultfd_armed(vma) &&
> -                           (!cc->is_khugepaged ||
> -                            none_or_zero <= khugepaged_max_ptes_none)) {
> -                               continue;
> -                       } else {
> -                               result = SCAN_EXCEED_NONE_PTE;
> -                               count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> -                               goto out_unmap;
> -                       }
> -               }
> +
>                  if (pte_uffd_wp(pteval)) {
>                          /*
>                           * Don't collapse the page if any of the small
> 
> 
> With that, the function flow looks more similar to 
> __collapse_huge_page_isolate(),
> except that we handle swap entries in there now.

Ah, indeed. I like this crazy idea ;p

> 
> 
> And with that in place, couldn't we factor out a huge chunk of both 
> scanning
> functions into some helper (passing whether swap entries are allowed or 
> not?).

Yes. Factoring out the common scanning logic into a new helper is a
good suggestion. It would clean things up ;)

> 
> Yes, I know, refactoring khugepaged, crazy idea.

I'll look into that. But let's do this separately :)

Cheers,
Lance



