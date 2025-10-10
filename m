Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39280CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94AF58E0006; Fri, 10 Oct 2025 11:34:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9203F8E0003; Fri, 10 Oct 2025 11:34:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85D808E0006; Fri, 10 Oct 2025 11:34:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 74C558E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:34:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F54513AAAD
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:34:36 +0000 (UTC)
X-FDA: 83982601752.14.8220087
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id E2EAFC0009
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:34:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NTnmzvmL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760110474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m4qsKbpNSIpA/NVXxQj6liAluALHkPVnznxBwYjjPvc=;
	b=tBMOc+2NfW2Ybjst3JbMFnwKQIhN9s1I2xomFP3eJnr8KDLLuDaz2HTTpiwE/9QnJuAL39
	3nahRe62sKjG2BNw4u5GaxNJ37ak5Fm98L5TS59Ps8G0anxU71rtvDibWdLXcFWuPjUxdl
	k2QwgxuCbFJ4KE6z9JqgFxGiRoW69YA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NTnmzvmL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760110474; a=rsa-sha256;
	cv=none;
	b=YQtRkNZyS8DiwtuaipUwFdZX3S9Xl+7yclCZY13GcbucGFtBZUBoAHKBjNCJYiWqXgi5OJ
	4uGuHVndAobRdRTzd/4Riu+oVIRoAcZK3h5QsyN/zVGvzBWAqleAWM9e89tAVoZ+9wrxk6
	xP9F9KCyBXfTRjzbyUSreRJ0nEDKsLc=
Message-ID: <73bbc22f-2739-4f0e-b8d7-b8e344a3fead@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760110471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m4qsKbpNSIpA/NVXxQj6liAluALHkPVnznxBwYjjPvc=;
	b=NTnmzvmLuwBW42Vk6+G3ozKCQJmkscoHymC893MAgN1qpa4PviLFOlDB1uQxBSZgx+l+XC
	i5mjGyk+JMIUsIJmmI0jtEJF0NJrj7lm1+32dA/+0+UkSEhUm3zNpnBN4nx76fkZ2f6EGY
	edCr0qTAYdQRDkYmxDewwapgxliu5O0=
Date: Fri, 10 Oct 2025 23:34:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, hughd@google.com, ioworker0@gmail.com,
 kirill@shutemov.name, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mpenttil@redhat.com, npache@redhat.com, ryan.roberts@arm.com,
 richard.weiyang@gmail.com
References: <20251008032657.72406-1-lance.yang@linux.dev>
 <3ABDAD81-A650-4C9A-BB4B-5515180F0743@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <3ABDAD81-A650-4C9A-BB4B-5515180F0743@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: E2EAFC0009
X-Rspamd-Server: rspam03
X-Stat-Signature: dkgiw4is4ro45arasw71u4sj7ewanuxx
X-HE-Tag: 1760110473-987234
X-HE-Meta: U2FsdGVkX18VsPgP88faakjUkhMEfvQeMzeW4dwNILImHZkl6Lorsczjn3QnVpA4wgWQkCnhSJam3CXrbBJ7zyK2d86h46gUFwc2wx5TqUvDHgZxWQo4VPcLwvHZHVaCew/lbwi4F5tKl01RhIAFL0ciOWnhVfAJiGrptOr3M1+DuZE2OU+WF4BOCAN4Np8foWENtjZsAg0WEytxYiEdc3+GMQB8Y3kbOU0w5hWYH5qq7KGxZk4+LydGNPdbhkb9ojN8TfXLQBt7BIbnJVanmRftWeQAj46b/ZGBgnZMqtcwEomkO1u5yR3w1KG3yc9eieP7loU4vX6dY9xoc543diz0DeI68huVb1vOvw8JZHK0fUyktvi8ZA3x9vBSdheZyyqQSMyRAl6SEgFjTvVWJv0Eqws8wgW+Q7jKo+ATiMTVNQ30eZMVf4t/Q98RhiWhRkcgRMcQHDSS0aBvIpnMICP+CvsgzdF671CBAfCOmKBFTOG5htdKxAg5q7E20jcX9h6eqhpu8v1ZyTqWhs3N3kLnU0v3vyaKtUFESZheIX6eewdZJGEK00SpJfeHPuxDZhg6dIA1T0QYjoOGy0f+Fq5CQs4MCNHB2Ej4WyZ4LMqBAgOgHXXa9S2U6ZWlmPrp1mE7c1AGMowbSvCP/9lol36cX4qEtufZISIaiQpe1/w+0Wvq+rnDfmoZZq+HWNxaVPsRJ8DPJnX7XtjDihoFJY+j33jWPucAZrqL298u8UIEPl1TN78oOfFpfKd9bk4JZ1njz38/0HH5RoNLD8LoGxC9+12MyybXgfRALL3nMSq+3alwXDLsGA8sT/7BhNA8yOHLK0u3J7uPj+CmvV/i4+izKMAsim8kp9DLufRuLLp7HijQpGyUwOqLIk5KpM5J8MVkkKBcSv+ut2gTbiywulFxSD3TqMOo2x+Kkc0sRlXiW4aVYoQDyW5xWk0XgjhJj0dcDoH4c7JHWcNpgNB
 NPwscqQv
 /eXiN8XoaAew3EP9LQdDbLT70n8JHlA91Gb0A0YpP1dvMQSSAr4AeItq3jejpLK/yX/DAXpsqKqmqjfYl/j2kDtWqlNVBjtBkz+0y/GpxFPia0LoB8zER04s+4Ti6SA6kYixDjZqH6hVnmCroEeSyTna2aRRrMFNdyWYG5VWswerlnExKWWVcuVgFR76+75J7sKf4zc3Z3OZgtXtRjsGB2P9n5NZy9A3Tc8zEZ/Tnx7TWlbYNHf8PP9B7H4I3AE9CyoFSEhJhoMAvURwq0OUyBDXTsqb2d8sszXaWDq3qswh9mjpuEsowf+t+0g9gSXn1Ky3pTt9+CiCoyJ8HxVsp8tPzD4BSlqFUCG6DHTakuJNAm+JVkZDuFv3o7H1m/wHBIlUKDG0F9hk0G6303plEjndMzgv2RwObpyjRM2RvnJHL4AXfrX8rZa3vKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/10 23:21, Zi Yan wrote:
> On 7 Oct 2025, at 23:26, Lance Yang wrote:
> 
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> Currently, special non-swap entries (like PTE markers) are not caught
>> early in hpage_collapse_scan_pmd(), leading to failures deep in the
>> swap-in logic.
>>
>> A function that is called __collapse_huge_page_swapin() and documented
>> to "Bring missing pages in from swap" will handle other types as well.
>>
>> As analyzed by David[1], we could have ended up with the following
>> entry types right before do_swap_page():
>>
>>    (1) Migration entries. We would have waited.
>>        -> Maybe worth it to wait, maybe not. We suspect we don't stumble
>>           into that frequently such that we don't care. We could always
>>           unlock this separately later.
>>
>>    (2) Device-exclusive entries. We would have converted to non-exclusive.
>>        -> See make_device_exclusive(), we cannot tolerate PMD entries and
>>           have to split them through FOLL_SPLIT_PMD. As popped up during
>>           a recent discussion, collapsing here is actually
>>           counter-productive, because the next conversion will PTE-map
>>           it again.
>>        -> Ok to not collapse.
>>
>>    (3) Device-private entries. We would have migrated to RAM.
>>        -> Device-private still does not support THPs, so collapsing right
>>           now just means that the next device access would split the
>>           folio again.
>>        -> Ok to not collapse.
>>
>>    (4) HWPoison entries
>>        -> Cannot collapse
>>
>>    (5) Markers
>>        -> Cannot collapse
>>
>> First, this patch adds an early check for these non-swap entries. If
>> any one is found, the scan is aborted immediately with the
>> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
>> work. While at it, convert pte_swp_uffd_wp_any() to pte_swp_uffd_wp()
>> since we are in the swap pte branch.
>>
>> Second, as Wei pointed out[3], we may have a chance to get a non-swap
>> entry, since we will drop and re-acquire the mmap lock before
>> __collapse_huge_page_swapin(). To handle this, we also add a
>> non_swap_entry() check there.
>>
>> Note that we can unlock later what we really need, and not account it
>> towards max_swap_ptes.
>>
>> [1] https://lore.kernel.org/linux-mm/09eaca7b-9988-41c7-8d6e-4802055b3f1e@redhat.com
>> [2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local
>> [3] https://lore.kernel.org/linux-mm/20251005010511.ysek2nqojebqngf3@master
>>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>> v2 -> v3:
>>   - Collect Acked-by from David - thanks!
>>   - Collect Reviewed-by from Wei and Dev - thanks!
>>   - Add a non_swap_entry() check in __collapse_huge_page_swapin() (per Wei
>>     and David) - thanks!
>>   - Rework the changelog to incorporate David's detailed analysis of
>>     non-swap entry types - thanks!!!
>>   - https://lore.kernel.org/linux-mm/20251001032251.85888-1-lance.yang@linux.dev/
>>
>> v1 -> v2:
>>   - Skip all non-present entries except swap entries (per David) thanks!
>>   - https://lore.kernel.org/linux-mm/20250924100207.28332-1-lance.yang@linux.dev/
>>
>>   mm/khugepaged.c | 37 +++++++++++++++++++++++--------------
>>   1 file changed, 23 insertions(+), 14 deletions(-)
>>
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
> pte_swp_uffd_wp_any() returns true for both pte_swp_uffd_wp() and
> pte_marker_uffd_wp(). Why is it OK to just check pte_swp_uffd_wp() here?

+		} else if (!pte_present(pteval)) {
+			if (non_swap_entry(pte_to_swp_entry(pteval))) { <--
+				result = SCAN_PTE_NON_PRESENT;
+				goto out_unmap;
+			}

IIUC, we have just handled all non-swap entries above (which would
include pte_marker_uffd_wp()), right?

> 
>>   					result = SCAN_PTE_UFFD_WP;
>>   					goto out_unmap;
>>   				}
>> @@ -1301,18 +1322,6 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>   				goto out_unmap;
>>   			}
>>   		}
>> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> -			++none_or_zero;
>> -			if (!userfaultfd_armed(vma) &&
>> -			    (!cc->is_khugepaged ||
>> -			     none_or_zero <= khugepaged_max_ptes_none)) {
>> -				continue;
>> -			} else {
>> -				result = SCAN_EXCEED_NONE_PTE;
>> -				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>> -				goto out_unmap;
>> -			}
>> -		}
>>   		if (pte_uffd_wp(pteval)) {
>>   			/*
>>   			 * Don't collapse the page if any of the small
>> -- 
>> 2.49.0
> 
> 
> --
> Best Regards,
> Yan, Zi


