Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 414A7D358E2
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 08:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81A856B0088; Thu, 29 Jan 2026 03:32:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C8106B0089; Thu, 29 Jan 2026 03:32:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9AA6B008A; Thu, 29 Jan 2026 03:32:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5729B6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:32:35 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 00E4A1A08DE
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:32:34 +0000 (UTC)
X-FDA: 84384335070.26.C7A6942
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id EBCC0140004
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:32:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769675553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RMgFspW6Nwfcfsqq4Oc5NDEiXldRyG4nB/iR8gxu9b8=;
	b=xTR7c/2vcJPodatCx+ODcF5dEGEcuTN0IIKXYhZh/Hfy0wT4SZyu0+o7vLO6cKN188LluL
	nVlspywbZWW8zyMHYlivcrFaFZoOiyaSb8BfiG7ZlnZ2bS6lp8sGRCp0p/Al4wVnzmPl5h
	Tb2rE29BO/zveyQOCjAk9F1RLc5F/YE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769675553; a=rsa-sha256;
	cv=none;
	b=lv6dtKK/ctZtv9wg73HtFGPWxwsx1OHBste69a8LU7gVmELs4JjCd+eQUW5L6OH48CrEfX
	PZy6iqbPrDbF4+4ctegtFEbN729Oqg2FXyWqhB7LcZV6BipobV2Dl4N9XnjSYNx9ZvEkhR
	LRBJARGtcZNzA3WoCWzbYrFt/shUzlQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 477B21516;
	Thu, 29 Jan 2026 00:32:25 -0800 (PST)
Received: from [10.164.18.94] (unknown [10.164.18.94])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B96173F632;
	Thu, 29 Jan 2026 00:32:28 -0800 (PST)
Message-ID: <dab88ab4-2580-444b-9ea2-579005de71ac@arm.com>
Date: Thu, 29 Jan 2026 14:02:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v5 2/5] mm: khugepaged: refine scan progress number
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260123082232.16413-1-vernon2gm@gmail.com>
 <20260123082232.16413-3-vernon2gm@gmail.com>
 <72dfd11f-dca4-447e-89c5-7a87cb675bda@arm.com>
 <4exllw7pf4yfhfzpyg3ictsnznf5lepv5tjd7zvycldjwmh6jm@j6rara3ogrux>
 <7c4b5933-7bbd-4ad7-baef-830304a09485@arm.com>
 <gzhittxi6dn2o6a3wf4qx4fafkdc2pumfuz3xtprh3ifs2t47q@slsfcb6kqqcr>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <gzhittxi6dn2o6a3wf4qx4fafkdc2pumfuz3xtprh3ifs2t47q@slsfcb6kqqcr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: buoee67txh1c9io7u3uo34i79efsobpo
X-Rspamd-Queue-Id: EBCC0140004
X-Rspam-User: 
X-HE-Tag: 1769675552-726892
X-HE-Meta: U2FsdGVkX18NPvK2cyIqrT4/AAiuUKVa3Qx5NC1lOZJL0I+bkjevgeWPg23iqyT7Up9EmzWOHvzsY1SBItLo/R8Us/n478RmTCHGYZc9UybmiU7qnpM7xLP3cNuNISVFuyWQGuF+BDkHH58IgZAvsaOes4EKY3tbqIvSCmsTO4Jdx8w2izaVP8817u1M3n2qJ0gR2RZZvMpDJbTqP8leOj4FUmKaQkQWN8Nuo6h+3J7SMMgJldvOM8Cr+qqX21GLbk+anCsfdD1v3rOhUmh3VqNKdCDrvKiY3OjDgcc47G06ncPKc0TUI1dSKTbj4ezYJ0l8Pu8facL+GgfX8WGbtDH+bnFySOqzkyYcCvj0hokl4CtfvmqDZNDpXOgvigI1CtuHrHfd7C4f53KrjULJXo4VeFzZPH4RUD3qGrdWEXQhLApEA+2Qc7xBB1orB4EU+J90nwaL54Ucn9GvNhvvCoKZtEXUFYr9e9ZMZE6T5ml2GcC0FqkxMysTXqHACEqprl9/jn//UZRAvqgDP+onq0tBtEubm5AkFmME+EaAYwifOP/mZP6x3VHv14xSjczmyGiWWpa49Nn2JkQk0tqiERqMdmf6M7ebr+S87g0yJmzCz72SJoqTtr8ndV8WxsR1fk3Bhjemzky08QdRm6VJ8LKCIDa9a+UQEikbC9Ae+uT9OEieKPkalisCxdRtga9XRGZmqk4TVaBWAb+Jrgr/TUAcUVrl5ymI4/tR5qFHxX6iBt1MG+2Rw0xgeqRvnVVfk1RKRscKO8ICPk1jmgXEt8AHUCj87T+vyD1FphJUFCKqKug2zxs5CMsR+6w2n9IjGeNtwEhZ3zpL0YcR9A3gwaTmRX6yS70+4G8A1VpRCGR12MsxTj02MCo6BjM/Nzb0+YKYprtZMjriep11uNiH1bqY78Gof2RMeHuA4q0srmsiCcPoPRRo3eXcatchvyGHvjjR6QfGe9ufOAv21NF
 CkuJ0naz
 V/Tf8dsjUNCX81FIJuGBSMnh4puT+a9LWykecGaimJ53E0+8aOpmApmyxin0dCbIOKvH1wyLjrwIyimfX2DJTAAikBVddOxlH5oPNHtlVABOKLAWYP0R5/p5qA27PhgrRyEiNL/Fwi33vCrVUXI6rRyQ6fY58c30lJsGY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 29/01/26 1:29 pm, Vernon Yang wrote:
> On Thu, Jan 29, 2026 at 11:05:36AM +0530, Dev Jain wrote:
>> On 28/01/26 8:04 pm, Vernon Yang wrote:
>>> On Wed, Jan 28, 2026 at 01:59:33PM +0530, Dev Jain wrote:
>>>> On 23/01/26 1:52 pm, Vernon Yang wrote:
>>>>> From: Vernon Yang <yanglincheng@kylinos.cn>
>>>>>
>>>>> Currently, each scan always increases "progress" by HPAGE_PMD_NR,
>>>>> even if only scanning a single PTE/PMD entry.
>>>>>
>>>>> - When only scanning a sigle PTE entry, let me provide a detailed
>>>>>   example:
>>>>>
>>>>> static int hpage_collapse_scan_pmd()
>>>>> {
>>>>> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>>>> 	     _pte++, addr += PAGE_SIZE) {
>>>>> 		pte_t pteval = ptep_get(_pte);
>>>>> 		...
>>>>> 		if (pte_uffd_wp(pteval)) { <-- first scan hit
>>>>> 			result = SCAN_PTE_UFFD_WP;
>>>>> 			goto out_unmap;
>>>>> 		}
>>>>> 	}
>>>>> }
>>>>>
>>>>> During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
>>>>> directly. In practice, only one PTE is scanned before termination.
>>>>> Here, "progress += 1" reflects the actual number of PTEs scanned, but
>>>>> previously "progress += HPAGE_PMD_NR" always.
>>>>>
>>>>> - When the memory has been collapsed to PMD, let me provide a detailed
>>>>>   example:
>>>>>
>>>>> The following data is traced by bpftrace on a desktop system. After
>>>>> the system has been left idle for 10 minutes upon booting, a lot of
>>>>> SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
>>>>> by khugepaged.
>>>>>
>>>>> @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
>>>>> @scan_pmd_status[6]: 2           ## SCAN_EXCEED_SHARED_PTE
>>>>> @scan_pmd_status[3]: 142         ## SCAN_PMD_MAPPED
>>>>> @scan_pmd_status[2]: 178         ## SCAN_NO_PTE_TABLE
>>>> Could you elaborate what is [1], [6] etc and 1,2,142, etc?
>>> These 1,6 are value of "enum scan_result", you can directly refer to the
>>> notes on the right.
>>>
>>> These 1,2,142,178 are number of different "enum scan_result" from
>>> trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file.
>>>
>>> as example, SCAN_PMD_MAPPED has 142 times during a full scan by
>>> khugepaged.
>> Thanks. Can you please mention this in the patch description. You can simply
>> right it like this:
>>
>> "From trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file, the
>> following statuses were observed, with frequency mentioned next to them:
>>
>> SCAN_SUCCEED: 1
>> SCAN_PMD_MAPPED: 142
>> ....."
>>
>> and so on.
> LGTM, I will do it in the next version. Thanks!
>
>>>>> total progress size: 674 MB
>>>>> Total time         : 419 seconds ## include khugepaged_scan_sleep_millisecs
>>>>>
>>>>> The khugepaged_scan list save all task that support collapse into hugepage,
>>>>> as long as the task is not destroyed, khugepaged will not remove it from
>>>>> the khugepaged_scan list. This exist a phenomenon where task has already
>>>>> collapsed all memory regions into hugepage, but khugepaged continues to
>>>>> scan it, which wastes CPU time and invalid, and due to
>>>>> khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
>>>>> scanning a large number of invalid task, so scanning really valid task
>>>>> is later.
>>>>>
>>>>> After applying this patch, when the memory is either SCAN_PMD_MAPPED or
>>>>> SCAN_NO_PTE_TABLE, just skip it, as follow:
>>>>>
>>>>> @scan_pmd_status[6]: 2
>>>>> @scan_pmd_status[3]: 147
>>>>> @scan_pmd_status[2]: 173
>>>>> total progress size: 45 MB
>>>>> Total time         : 20 seconds
>>>>>
>>>>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>>>>> ---
>>>>>  include/linux/xarray.h |  9 ++++++++
>>>>>  mm/khugepaged.c        | 47 ++++++++++++++++++++++++++++++++++--------
>>>>>  2 files changed, 47 insertions(+), 9 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/xarray.h b/include/linux/xarray.h
>>>>> index be850174e802..f77d97d7b957 100644
>>>>> --- a/include/linux/xarray.h
>>>>> +++ b/include/linux/xarray.h
>>>>> @@ -1646,6 +1646,15 @@ static inline void xas_set(struct xa_state *xas, unsigned long index)
>>>>>  	xas->xa_node = XAS_RESTART;
>>>>>  }
>>>>>
>>>>> +/**
>>>>> + * xas_get_index() - Get XArray operation state for a different index.
>>>>> + * @xas: XArray operation state.
>>>>> + */
>>>>> +static inline unsigned long xas_get_index(struct xa_state *xas)
>>>>> +{
>>>>> +	return xas->xa_index;
>>>>> +}
>>>>> +
>>>>>  /**
>>>>>   * xas_advance() - Skip over sibling entries.
>>>>>   * @xas: XArray operation state.
>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>> index 6f0f05148765..de95029e3763 100644
>>>>> --- a/mm/khugepaged.c
>>>>> +++ b/mm/khugepaged.c
>>>>> @@ -68,7 +68,10 @@ enum scan_result {
>>>>>  static struct task_struct *khugepaged_thread __read_mostly;
>>>>>  static DEFINE_MUTEX(khugepaged_mutex);
>>>>>
>>>>> -/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
>>>>> +/*
>>>>> + * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
>>>>> + * every 10 second.
>>>>> + */
>>>>>  static unsigned int khugepaged_pages_to_scan __read_mostly;
>>>>>  static unsigned int khugepaged_pages_collapsed;
>>>>>  static unsigned int khugepaged_full_scans;
>>>>> @@ -1240,7 +1243,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>>>>>  }
>>>>>
>>>>>  static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>> -		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
>>>>> +		struct vm_area_struct *vma, unsigned long start_addr,
>>>>> +		bool *mmap_locked, unsigned int *cur_progress,
>>>>>  		struct collapse_control *cc)
>>>>>  {
>>>>>  	pmd_t *pmd;
>>>>> @@ -1255,6 +1259,9 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>>
>>>>>  	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>>>>>
>>>>> +	if (cur_progress)
>>>>> +		*cur_progress += 1;
>>>> Why not be a little more explicit, and do this addition if find_pmd_or_thp_or_none fails,
>>>> or pte_offset_map_lock fails? The way you do it right now is not readable - it gives no
>>>> idea as to why on function entry we do a +1 right away. Please do add some comments too.
>>> If this way is not clear enough, we can directly add 1 in
>>> find_pmd_or_thp_or_none() etc, BUT it's a bit redundant.
>>> Please take a look at which one is better.
>>>
>>> case 1:
>>> as the V4 PATCH #2 [1] and #3 [2], only hpage_collapse_scan_pmd().
>>> [1] https://lore.kernel.org/linux-mm/20260111121909.8410-3-yanglincheng@kylinos.cn
>>> [2] https://lore.kernel.org/linux-mm/20260111121909.8410-4-yanglincheng@kylinos.cn
>>>
>>> static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>> 		struct vm_area_struct *vma, unsigned long start_addr,
>>> 		bool *mmap_locked, unsigned int *cur_progress,
>>> 		struct collapse_control *cc)
>>> {
>>> 	...
>>> 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>>> 	if (result != SCAN_SUCCEED) {
>>> 		if (cur_progress)
>>> 			*cur_progress += 1; // here
>>> 		goto out;
>>> 	}
>>> 	...
>>> 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>>> 	if (!pte) {
>>> 		if (cur_progress)
>>> 			*cur_progress += 1; // here
>>> 		result = SCAN_NO_PTE_TABLE;
>>> 		goto out;
>>> 	}
>>>
>>> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>> 	     _pte++, addr += PAGE_SIZE) {
>>> 		if (cur_progress)
>>> 			*cur_progress += 1; // here
>>> 		...
>>> 	}
>>> }
>>>
>>> case 2:
>>>
>>> static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>> 		struct vm_area_struct *vma, unsigned long start_addr,
>>> 		bool *mmap_locked, unsigned int *cur_progress,
>>> 		struct collapse_control *cc)
>>> {
>>> 	...
>>> 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>>> 	if (result != SCAN_SUCCEED) {
>>> 		if (cur_progress)
>>> 			*cur_progress += 1; // here
>> Let us be more explicit and set this equal to 1, instead of adding 1.
> LGTM, I will do it in the next version. Thanks!
>
>>> 		goto out;
>>> 	}
>>> 	...
>>> 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>>> 	if (!pte) {
>>> 		if (cur_progress)
>>> 			*cur_progress += 1; // here
>> Same comment as above.
>>
>>> 		result = SCAN_NO_PTE_TABLE;
>>> 		goto out;
>>> 	}
>>>
>>> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>> 	     _pte++, addr += PAGE_SIZE) {
>>> 		...
>>> 	}
>>> 	...
>>> out_unmap:
>>> 	if (cur_progress) {
>>> 		if (_pte >= pte + HPAGE_PMD_NR)
>>> 			*cur_progress += HPAGE_PMD_NR;   // here
>>> 		else
>>> 			*cur_progress += _pte - pte + 1; // here
>>> 	}
>>> }
>> I will vote case 2. In case 1 I don't like the fact that the if (cur_progress)
>> branch will be checked each iteration - and I don't think the compiler can
>> optimize this since the body of the loop is complex, so this check cannot
>> be hoisted out of the loop.
>>
>>
>>> case 3:
>>> 	current patch, and add more comments to clearer.
>>>
>>>>> +
>>>>>  	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>>>>>  	if (result != SCAN_SUCCEED)
>>>>>  		goto out;
>>>>> @@ -1396,6 +1403,12 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>>  		result = SCAN_SUCCEED;
>>>>>  	}
>>>>>  out_unmap:
>>>>> +	if (cur_progress) {
>>>>> +		if (_pte >= pte + HPAGE_PMD_NR)
>>>>> +			*cur_progress += HPAGE_PMD_NR - 1;
>>>>> +		else
>>>>> +			*cur_progress += _pte - pte;
>>>>> +	}
>>>>>  	pte_unmap_unlock(pte, ptl);
>>>>>  	if (result == SCAN_SUCCEED) {
>>>>>  		result = collapse_huge_page(mm, start_addr, referenced,
>>>>> @@ -2286,8 +2299,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>>>>  	return result;
>>>>>  }
>>>>>
>>>>> -static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>>>>> -		struct file *file, pgoff_t start, struct collapse_control *cc)
>>>>> +static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
>>>>> +		unsigned long addr, struct file *file, pgoff_t start,
>>>>> +		unsigned int *cur_progress, struct collapse_control *cc)
>>>>>  {
>>>>>  	struct folio *folio = NULL;
>>>>>  	struct address_space *mapping = file->f_mapping;
>>>>> @@ -2376,6 +2390,18 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>>>>>  			cond_resched_rcu();
>>>>>  		}
>>>>>  	}
>>>>> +	if (cur_progress) {
>>>>> +		unsigned long idx = xas_get_index(&xas) - start;
>>>>> +
>>>>> +		if (folio == NULL)
>>>>> +			*cur_progress += HPAGE_PMD_NR;
>>>> I think this whole block needs some comments. Can you explain, why you
>>>> do a particular increment in each case?
>>>>
>>>>> +		else if (xa_is_value(folio))
>>>>> +			*cur_progress += idx + (1 << xas_get_order(&xas));
>>>>> +		else if (folio_order(folio) == HPAGE_PMD_ORDER)
>>>>> +			*cur_progress += idx + 1;
>>>>> +		else
>>>>> +			*cur_progress += idx + folio_nr_pages(folio);
>>>>> +	}
>>> The "idx" represent PTEs number already scanned when exiting
>>> xas_for_each().
>>>
>>> However, the last valid folio size was not counted in "idx" (except
>>> folio == NULL, "idx" equal to HPAGE_PMD_NR), which can be further
>>> divided into three cases:
>> But, the number of PTEs you account in these three cases, are *not*
>> scanned, right? So we can simply drop these 3 cases.
> No, these three cases are the last scanning folio to break, I think we
> need to add them. Imagine that if we trigger HPAGE_PMD_ORDER folio
> firstly, "idx" is equal to 0.

If you hit a large folio and break, you don't consume any extra iterations.
The number of iterations is completely determined by xa_index. This is kind
of analogous to SCAN_PMD_MAPPED - in one "iteration", you decide to stop
scanning, and set progress to 1.

In any case, the problem which you describe in the patch description is
completely solved by setting progress to 1 upon failure of find_pmd_or_thp_or_none.
So anything else which you do (like counting iterations in hpage_collapse_scan_pmd
or hpage_collapse_scan_file) is extra and it is not clear if it has a practical
benefit. The patch benefits us because there are a lot of SCAN_PMD_MAPPED and SCAN_PMD_NONE.
Will we practically also encounter a large number of SCAN_EXCEED_PTE_SWAP, PTE_NONE, etc?

I tilt towards keeping the other bits of the patch, if they can be simplified, and
because this patch is relatively harmless. Just like you count the number of iterations
in hpage_collapse_scan_pmd(), you can do the same here using xa_index.

>
>>> 1. shmem swap entries (xa_is_value), add folio size.
>>> 2. the folio is HPAGE_PMD_ORDER, the memory has been collapsed
>>>    to PMD, so add 1 only.
>>> 3. Normal folio, add folio size.
>>>
>>> Is the version below more readable?
>>>
>>> 	if (cur_progress) {
>>> 		*cur_progress += xas.xa_index - start;
>>>
>>> 		if (folio) {
>>> 			if (xa_is_value(folio))
>>> 				*cur_progress += 1 << xas_get_order(&xas);
>>> 			else if (folio_order(folio) == HPAGE_PMD_ORDER)
>>> 				*cur_progress += 1;
>>> 			else
>>> 				*cur_progress += folio_nr_pages(folio);
>>> 		}
>>> 	}
>> Yep, this is unneeded complexity. This looks really ugly and the benefits of
>> this are not clear. You can simply do
>>
>> if (cur_progress)
>> 	*cur_progress = xas.xa_index - start;
>>
>>>>>  	rcu_read_unlock();
>>>>>
>>>>>  	if (result == SCAN_SUCCEED) {
>>>>> @@ -2456,6 +2482,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>>>>>
>>>>>  		while (khugepaged_scan.address < hend) {
>>>>>  			bool mmap_locked = true;
>>>>> +			unsigned int cur_progress = 0;
>>>>>
>>>>>  			cond_resched();
>>>>>  			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
>>>>> @@ -2472,7 +2499,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>>>>>  				mmap_read_unlock(mm);
>>>>>  				mmap_locked = false;
>>>>>  				*result = hpage_collapse_scan_file(mm,
>>>>> -					khugepaged_scan.address, file, pgoff, cc);
>>>>> +					khugepaged_scan.address, file, pgoff,
>>>>> +					&cur_progress, cc);
>>>>>  				fput(file);
>>>>>  				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
>>>>>  					mmap_read_lock(mm);
>>>>> @@ -2486,7 +2514,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>>>>>  				}
>>>>>  			} else {
>>>>>  				*result = hpage_collapse_scan_pmd(mm, vma,
>>>>> -					khugepaged_scan.address, &mmap_locked, cc);
>>>>> +					khugepaged_scan.address, &mmap_locked,
>>>>> +					&cur_progress, cc);
>>>>>  			}
>>>>>
>>>>>  			if (*result == SCAN_SUCCEED)
>>>>> @@ -2494,7 +2523,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>>>>>
>>>>>  			/* move to next address */
>>>>>  			khugepaged_scan.address += HPAGE_PMD_SIZE;
>>>>> -			progress += HPAGE_PMD_NR;
>>>>> +			progress += cur_progress;
>>>>>  			if (!mmap_locked)
>>>>>  				/*
>>>>>  				 * We released mmap_lock so break loop.  Note
>>>>> @@ -2817,7 +2846,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>>>  			mmap_locked = false;
>>>>>  			*lock_dropped = true;
>>>>>  			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
>>>>> -							  cc);
>>>>> +							  NULL, cc);
>>>>>
>>>>>  			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
>>>>>  			    mapping_can_writeback(file->f_mapping)) {
>>>>> @@ -2832,7 +2861,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>>>  			fput(file);
>>>>>  		} else {
>>>>>  			result = hpage_collapse_scan_pmd(mm, vma, addr,
>>>>> -							 &mmap_locked, cc);
>>>>> +							 &mmap_locked, NULL, cc);
>>>>>  		}
>>>>>  		if (!mmap_locked)
>>>>>  			*lock_dropped = true;
>>> --
>>> Thanks,
>>> Vernon

