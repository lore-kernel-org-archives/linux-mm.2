Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B776CAC5A5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 04:11:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDE3C8E0068; Fri, 19 Sep 2025 00:11:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8F4E8E0008; Fri, 19 Sep 2025 00:11:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4E78E0068; Fri, 19 Sep 2025 00:11:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AC30F8E0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 00:11:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2838658DD7
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 04:11:52 +0000 (UTC)
X-FDA: 83904676464.06.261A1FE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id E0DB91C0004
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 04:11:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758255110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X06Wp3jLvuQDjv5/mV8WNoSywWzw6yXEpvzoyqeDOrU=;
	b=SxPqdU7Fwlmo8yODoq5bDHa44u6PhXUvcEX0Voo18CWb+PHHVnOHuPSOvgVWLLvbcpahsZ
	iAp9zMkCdeCo4mKS0xjUtw5lmLqtyQa8Iq3ZWAUGB7eykV2plo4rbB7j0tmyxgy4+3Teyk
	/2ywJwc7+4zBgTqwpZDTNl1TUX42N6w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758255110; a=rsa-sha256;
	cv=none;
	b=JJvAbx1KfZY8cc33D9hm8nHsX3e8CrSu3aB1gyGgYoQXmZ/DFsuBXVTPSb12vo0qBMMB0S
	EMMDA++dUxtDAtcU8PGXVXL+yIHwGbWEZoXCHBhjBEj/LW/aWXR8jp6F3l7OvVUJawm3nc
	MjJpHGdAhB57UNyk9ZiVo/CLraV04es=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E5AF1758;
	Thu, 18 Sep 2025 21:11:40 -0700 (PDT)
Received: from [10.164.18.52] (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5D1413F673;
	Thu, 18 Sep 2025 21:11:38 -0700 (PDT)
Message-ID: <6a6f03df-8dc4-44aa-ad25-40f51ad98266@arm.com>
Date: Fri, 19 Sep 2025 09:41:35 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 2/2] mm/khugepaged: abort collapse scan on guard
 PTEs
To: David Hildenbrand <david@redhat.com>, Lance Yang <lance.yang@linux.dev>,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, kirill@shutemov.name, hughd@google.com,
 mpenttil@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250918050431.36855-1-lance.yang@linux.dev>
 <20250918050431.36855-3-lance.yang@linux.dev>
 <a696c734-9f88-4d6f-a852-013071a2dd2a@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <a696c734-9f88-4d6f-a852-013071a2dd2a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E0DB91C0004
X-Stat-Signature: tt4dbs4k9hqhzk175osbgitix8ib8mmr
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758255109-924730
X-HE-Meta: U2FsdGVkX18+lkeIk4UivokN/4Bf08vnpAONF7xB4QKX79hIyjdekRYkoNLfLjmvdjlTHvq6Zz66g5hoK+QZH2BiDhKQEYxKYWgYkplAvynCbAUwKSjGOXgSJB2a0omYFHKDFBk/U3komoa9drInhQFlbcn0hnC73DCIi89dmclg+aewYfbuYg3tj57PrbX9CV/mAL68QO60uZdv0ho85gyenh3SS/sxkhDtKlx96pg+Tpq4LrHvakRHTBK/Y/yFoTz8xQsY4lSy+U/qWPPVVsP08XkqXNoBphqbBXRZdM9sjvNP365IwmzqWs4VPLL3W5i4xLWxGTHC/XmATjPO4qtgydhr6T9SgyZLFlvg1rvM8cETqJM/szh+COPYBn7R8h1UKKTeKLvlwGXCIIrYodNVWtRBMTdhLrhnPk5nQsBs54DkEZaSeZafe1emrjAsgM3vc1EMr4Et4QDi2V3AkooCbjN62gJuhZKQKpY1oYbprNRtRakw0TAmGx6CFZU8CGjqc1VmV01019HIemevAfuWYlATTuL3WNZx2sJygJhCoPl5roUf5kTR1NI1EL4ns7tHidhXJn5tzLk2VezGLZe+9gpah4Y2oVzy7+M9m20Y1quRwO7nD3L/RUeEHFfPV4IMhwCzKujLDy9iieOQIdWtyso9xUkIDUHDapFx27ir0xBuRmkNJUR1kbZoQxdIi7eMqHOjA7PfuKkv9lPOCrtS2oFm4qGCYkphTUKXh2CyPK8f65+1Qd1OgjcipqOTq/rUav8x/rWMkjw8Q/eVa4KgQ9Zkw/Z3+tduvLjCYxZiL3VTGh71oIONNcOE84owe9DWstHGNoA+Bma3O7T6LBUbFBOIKgqJIJy8C0VZkjxPoXtBQvxuPkiSEW4KAOWooN1ywoYb1no58x4srncepjE/XxLzY2bhvSAnMJxpWY5N9YYzv0KBFxD9ndgw0Eqe8nBbGRCaeLKrbPydT7h
 3nxTmBJR
 9OGk+GcRhdgSMHTfHxRIRmddhQjV9mzTRacLbGJ9Ao4YfA4S/bsrpc2dKHx6VI3TiZC8HGkqU05xhiBPI/GsfVj/dy7CgWzeFwngcRTh7/bS6auj8TRqCgVm0PCH17CiiyDYMUH26sBBdQpsD0X0Bie9kds+DAaHlMgxXZJEu6TPVO+/bWepbVBJvJy9XkdQr2lLm9q9mmIGRqJYz9vt9w2LRp9DN6+PVz+KQgHQXQ3f6I6PXdHeR4qIgVdtt21gTNdmYjLK8Yq/zFL8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 19/09/25 12:17 am, David Hildenbrand wrote:
> On 18.09.25 07:04, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> Guard PTE markers are installed via MADV_GUARD_INSTALL to create
>> lightweight guard regions.
>>
>> Currently, any collapse path (khugepaged or MADV_COLLAPSE) will fail 
>> when
>> encountering such a range.
>>
>> MADV_COLLAPSE fails deep inside the collapse logic when trying to 
>> swap-in
>> the special marker in __collapse_huge_page_swapin().
>>
>> hpage_collapse_scan_pmd()
>>   `- collapse_huge_page()
>>       `- __collapse_huge_page_swapin() -> fails!
>>
>> khugepaged's behavior is slightly different due to its max_ptes_swap 
>> limit
>> (default 64). It won't fail as deep, but it will still needlessly 
>> scan up
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
> I think we might also run into migration entries here and hwpoison 
> entries?
>
> So what about just generalizing this:
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index af5f5c80fe4ed..28f1f4bf0e0a8 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1293,7 +1293,24 @@ static int hpage_collapse_scan_pmd(struct 
> mm_struct *mm,
>         for (_address = address, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>              _pte++, _address += PAGE_SIZE) {
>                 pte_t pteval = ptep_get(_pte);
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
> + count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +                               goto out_unmap;
> +                       }
> +               } else if (!pte_present(pteval)) {
> +                       if (non_swap_entry(pte_to_swp_entry(pteval))) {
> +                               result = SCAN_PTE_NON_PRESENT;
> +                               goto out_unmap;
> +                       }
> +
>                         ++unmapped;
>                         if (!cc->is_khugepaged ||
>                             unmapped <= khugepaged_max_ptes_swap) {
> @@ -1313,18 +1330,7 @@ static int hpage_collapse_scan_pmd(struct 
> mm_struct *mm,
>                                 goto out_unmap;
>                         }
>                 }
> -               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> -                       ++none_or_zero;
> -                       if (!userfaultfd_armed(vma) &&
> -                           (!cc->is_khugepaged ||
> -                            none_or_zero <= khugepaged_max_ptes_none)) {
> -                               continue;
> -                       } else {
> -                               result = SCAN_EXCEED_NONE_PTE;
> - count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> -                               goto out_unmap;
> -                       }
> -               }
> +
>                 if (pte_uffd_wp(pteval)) {
>                         /*
>                          * Don't collapse the page if any of the small
>
>
> With that, the function flow looks more similar to 
> __collapse_huge_page_isolate(),
> except that we handle swap entries in there now.

This looks good!


>
>
> And with that in place, couldn't we factor out a huge chunk of both 
> scanning
> functions into some helper (passing whether swap entries are allowed 
> or not?).
>
> Yes, I know, refactoring khugepaged, crazy idea.
>

