Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63821CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 10:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0C38E0007; Wed,  1 Oct 2025 06:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 749C78E0002; Wed,  1 Oct 2025 06:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638578E0007; Wed,  1 Oct 2025 06:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4DDB88E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 06:48:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0164744C45
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:48:22 +0000 (UTC)
X-FDA: 83949221286.10.57DE24D
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id ED293C000A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:48:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="CEz9D/G6";
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759315701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DQUujdosur72Brf3SU3nUTaWVwV5A6tLlSLe6abHjBM=;
	b=m5ze97TqUY2mvDWegfw9p/EjHZdkzaJSxBG8Bv8m4uZTr0yeYl4MameyGWPZrxeyViW2WW
	lR/mBc+D4wO4D55uBJOuQN/fSBfvgYPcayL2JTRX8fwvxY+2ZkAxcEz88vWLilRpN+X5n6
	lj1m5lik+vTME7Wvv+7l430ShPo+qvc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759315701; a=rsa-sha256;
	cv=none;
	b=AhX4xCOGywqFnUOPEQhmKfC9cIE2DtyVbFthTU0acAe9u36AZGGOFFYP/atjXvsV+hpQSg
	hfDN66QN0DV77ukJAGWO6j0GjYroJUUOgyABm8JgEecbPf792pJHkb1ztTeTshPyBs+7wm
	hwXk7STjQF3Y+aGaZdWIm6gUuzCT0Cg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="CEz9D/G6";
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <35c9a208-a7e6-41ab-aa3e-dbfdffaf5f44@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759315698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DQUujdosur72Brf3SU3nUTaWVwV5A6tLlSLe6abHjBM=;
	b=CEz9D/G6FWs96Xm7MfIttlI2vT8a4OKRqIi+Z63tvSyfSJakEey4bMpwr/5BZiuUl3xD4o
	+4zuHS711gNpBhLZEQ0tqOaVBeqXvlWf/BRBhQjMkPwtVovRtm6EJCnVeVYJb305EAbziK
	FJR2NlqCa6FhRHe/URVjtXXm7qN8MNc=
Date: Wed, 1 Oct 2025 18:48:07 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, hughd@google.com,
 ioworker0@gmail.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mpenttil@redhat.com, npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com, richard.weiyang@gmail.com,
 akpm@linux-foundation.org
References: <20251001032251.85888-1-lance.yang@linux.dev>
 <a1df234c-d003-4696-8f1f-609a360fdeda@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <a1df234c-d003-4696-8f1f-609a360fdeda@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ED293C000A
X-Stat-Signature: ke6gcc589wjbi95aatao1x3wo375fo8q
X-Rspam-User: 
X-HE-Tag: 1759315700-317061
X-HE-Meta: U2FsdGVkX181wGq+sq5ck4NGoxuVZmwZf59g4IbigvxZTePotqlao9wjjIYA692at4oQyDIMgXxrEhQQa5yfxKTzfbjKXPy0CjdP6bkmJPJSruK9UEnjPBfYlInH9bnuH+fjQTOoWdN4di/H+DMUIxs2gfI9T5zMKBrqR8AFyMKyzGhN72yQsDl7Wf/WPV5SZYG8rjSpzSggztcwOr7rZhcNC9SJLSEirJ+1Uv6jf4x/TNOZz5zl2rWaGNF63fEhVTuLsN/KLlYK0w4Zjo2zdGxHv/BUVNUmX2uWEui90GRCQUaR6AcNjN24rZ/fYy6P5jNpdGdqsAp19rSuNMlMIKH+xz4CGTsUlJKPzlwEzfQ3FEcP8jIaRzEjdlEVMgPYsSFwlxBwJYYwih2SmYbYtWzL7PJamrAsEeUF6PUPvYzwipZnDICKZG111VSH4cLBl/M6X3sDqX45H8zQeBOZJMDOuFglmL7+9Gnr2vDNJ+mVBiDgqajYbPsIZmWA9XTu8q8v53jgyRVGBxyaMEQ/RIhWreKFHGCPWfsOt1sz+XOtS8Zxfv5gLx6k6KyiAFYIcQH7OsT6vuN8k84WP6cji+lRUnxndXb5Q9zuGCnZxnodnqvED0GPydSn930MIWfEuopJi0JXndESncy64Nzhx+eBtWyJwZluctQ3/J7+D9laeQzSwX6YlgFarW/yexyZv/Rpji0jmY5kw2YvpqcQ/kHjRsum+STM4YnUZUgko/0XRqYSlJHYFm+ciWKfJCHeWPESX3s5sqd4yE91e+zdvtk41YJf3gYQAKd7o7Sp2VIRFFokhNnMKOmfD1AMgq0jIl5midYWnYqVQDYZ4iTgYZVrzLKACkErSmhmvlRXPVca39DAlEt57dEXjBc3TtSx5lmuNSLTO56FYAYJtFcq2NzGXr+SOJ1U0d7wKspyNGeLkYt8jjwhBdcYVOpEbozJ0xhe57B5ywTeF8uBc4H
 TZZ/XsGI
 TgpbPQ53YrbUaPOSYX6Ky+ZboFD/X3M+5sgajg4NcgL7Cg6ckqZE4wbUha3vtqenIoO9KUkLtptKYRu1/uiYPdWA60qt+HFcKi6nOBSBEmy+7jnbPgsAVO9Z3yN78UR3Bpf6hQiEWRwnU1U+T6kvZ/fHxMRy4SsUz/kNidldSRrt16oOzp6KU80H+Ga3+8tPsjlU5vhN5OXihC3+EOuVm0pjkUJbBPPaYpBIiF6c+YN6sXFKYBnX1Bp0gljgKeL7nsjPiEfWgPKyotQAHguhP5JiXZKk5KEiL3MHYOUrgQGPs+D9TNz/uwUEPtO7oYlKB/s5uYYd1xRk9eLZXS93QBeh0pv0bSaVrb821iwQphhQ7xCKjrcXUuI7gKdI051TSvZ89wfHJZIPcJZs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/1 18:20, Dev Jain wrote:
> 
> On 01/10/25 8:52 am, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> Currently, special non-swap entries (like migration, hwpoison, or PTE
>> markers) are not caught early in hpage_collapse_scan_pmd(), leading to
>> failures deep in the swap-in logic.
>>
>> hpage_collapse_scan_pmd()
>>   `- collapse_huge_page()
>>       `- __collapse_huge_page_swapin() -> fails!
>>
>> As David suggested[1], this patch skips any such non-swap entries
>> early. If any one is found, the scan is aborted immediately with the
>> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
>> work.
>>
>> [1] https://lore.kernel.org/linux-mm/7840f68e-7580-42cb- 
>> a7c8-1ba64fd6df69@redhat.com
>> [2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680- 
>> dcd55219c8bd@lucifer.local
>>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>> v1 -> v2:
>>   - Skip all non-present entries except swap entries (per David) thanks!
>>   - https://lore.kernel.org/linux-mm/20250924100207.28332-1- 
>> lance.yang@linux.dev/
>>
>>   mm/khugepaged.c | 32 ++++++++++++++++++--------------
>>   1 file changed, 18 insertions(+), 14 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 7ab2d1a42df3..d0957648db19 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1284,7 +1284,23 @@ static int hpage_collapse_scan_pmd(struct 
>> mm_struct *mm,
>>       for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>            _pte++, addr += PAGE_SIZE) {
>>           pte_t pteval = ptep_get(_pte);
>> -        if (is_swap_pte(pteval)) {
>> +        if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> +            ++none_or_zero;
>> +            if (!userfaultfd_armed(vma) &&
>> +                (!cc->is_khugepaged ||
>> +                 none_or_zero <= khugepaged_max_ptes_none)) {
>> +                continue;
>> +            } else {
>> +                result = SCAN_EXCEED_NONE_PTE;
>> +                count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>> +                goto out_unmap;
>> +            }
>> +        } else if (!pte_present(pteval)) {
> 
> If you are trying to merge this with the _isolate() conditions, we can do
> a micro-optimization here - is_swap_pte, (pte_none && is_zero_pfn), and 
> pte_uffd_wp
> are disjoint conditions, so we can use if-else-if-else-if to write them.

Ah, indeed, thanks!

I think it would fit better into the follow-up patch that unifies the
scanning logic, and I'll make sure to include it there ;p

> 
>> +            if (non_swap_entry(pte_to_swp_entry(pteval))) {
>> +                result = SCAN_PTE_NON_PRESENT;
>> +                goto out_unmap;
>> +            }
>> +
>>               ++unmapped;
>>               if (!cc->is_khugepaged ||
>>                   unmapped <= khugepaged_max_ptes_swap) {
>> @@ -1293,7 +1309,7 @@ static int hpage_collapse_scan_pmd(struct 
>> mm_struct *mm,
>>                    * enabled swap entries.  Please see
>>                    * comment below for pte_uffd_wp().
>>                    */
>> -                if (pte_swp_uffd_wp_any(pteval)) {
>> +                if (pte_swp_uffd_wp(pteval)) {
>>                       result = SCAN_PTE_UFFD_WP;
> 
> Could have mentioned in the changelog "while at it, convert 
> pte_swp_uffd_wp_any to
> pte_swp_uffd_wp since we are in the swap pte branch".

Right, that would have been clearer.

I'll add that if a next version is needed :)

> 
>>                       goto out_unmap;
>>                   }
>> @@ -1304,18 +1320,6 @@ static int hpage_collapse_scan_pmd(struct 
>> mm_struct *mm,
>>                   goto out_unmap;
>>               }
>>           }
>> -        if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> -            ++none_or_zero;
>> -            if (!userfaultfd_armed(vma) &&
>> -                (!cc->is_khugepaged ||
>> -                 none_or_zero <= khugepaged_max_ptes_none)) {
>> -                continue;
>> -            } else {
>> -                result = SCAN_EXCEED_NONE_PTE;
>> -                count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>> -                goto out_unmap;
>> -            }
>> -        }
>>           if (pte_uffd_wp(pteval)) {
>>               /*
>>                * Don't collapse the page if any of the small
> 
> Otherwise LGTM
> 
> Reviewed-by: Dev Jain <dev.jain@arm.com>

Cheers!


