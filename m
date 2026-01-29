Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D3D1D6100C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 12:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CBCA6B0088; Thu, 29 Jan 2026 07:46:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 079936B0089; Thu, 29 Jan 2026 07:46:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73A46B008A; Thu, 29 Jan 2026 07:46:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D43EC6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 07:46:57 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 873861AF3E4
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 12:46:57 +0000 (UTC)
X-FDA: 84384976074.24.A96FB9F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7346BA0007
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 12:46:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769690816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=stES/bTK/R7N6FAeh3L18SIP0HdjR/z2HJf1lCWqsV0=;
	b=0+K658FuclOMjHQmGl4oIEW7L7nhzmDT2ia8UjCNkazEOxKfyzxDoYE0TIp/AiTEXYcG8Q
	rlh2iujqAHkKjxA80hu00iwyeul9SXw04ZHP0eHTvF0j1lDaPQU8q0lHpoAEw89Zm4J6Gb
	65Pd1Q9EYp8ctr71VbTP0ko/rENOTaE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769690816; a=rsa-sha256;
	cv=none;
	b=2lQO9ScVs5WBvRcTfnPi6KWjgPPiaA9it2FUih4JzLL0jau8DcDrCfy29fcfxy/tgUD2Eh
	Tbkesm9QnUuwLTuroGHVKIgtjaAFngdwmujiqxSykblyLxDsjxfRdlrr5RNduWLHLdBq3O
	vxP8F00qdhZl+iN7rZ40GzxapAKasDs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1214153B;
	Thu, 29 Jan 2026 04:46:47 -0800 (PST)
Received: from [10.164.18.94] (unknown [10.164.18.94])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3DA7F3F632;
	Thu, 29 Jan 2026 04:46:51 -0800 (PST)
Message-ID: <4c35391e-a944-4e62-9103-4a1c4961f62a@arm.com>
Date: Thu, 29 Jan 2026 18:16:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v5 2/5] mm: khugepaged: refine scan progress number
To: Vernon Yang <vernon2gm@gmail.com>, lance.yang@linux.dev
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260123082232.16413-1-vernon2gm@gmail.com>
 <20260123082232.16413-3-vernon2gm@gmail.com>
 <72dfd11f-dca4-447e-89c5-7a87cb675bda@arm.com>
 <4exllw7pf4yfhfzpyg3ictsnznf5lepv5tjd7zvycldjwmh6jm@j6rara3ogrux>
 <7c4b5933-7bbd-4ad7-baef-830304a09485@arm.com>
 <gzhittxi6dn2o6a3wf4qx4fafkdc2pumfuz3xtprh3ifs2t47q@slsfcb6kqqcr>
 <dab88ab4-2580-444b-9ea2-579005de71ac@arm.com>
 <CACZaFFNGXDK7S82q2bCbMt_0UOa--xi85kwJFcj5NtNpwmW0pg@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CACZaFFNGXDK7S82q2bCbMt_0UOa--xi85kwJFcj5NtNpwmW0pg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7346BA0007
X-Stat-Signature: pu561sa3gxp8usmtpqny58jtau7bfair
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769690815-996338
X-HE-Meta: U2FsdGVkX18QSJZPixqbcQn2P79CaFNZcX/kgoVcGfl+2amUqEw79EThX8ePhafaim3qx5irny4NE7B5K/T3uHDESr23LA96pg6X+ugjPO84IQ8NU+M1MpchhrrNm/XBlVKNnrPzbyW60PWU6qpaHi93H6pl1VQmVfN4Cjt7FNjQYOW7zSx9DzKfrdmPQeGcUmB4T30aFyF9qrQEADiqGSQzOeDWJzrsMqWEm9hc/QnZfxsB0O+tHIjhriYBUZnimy3uH9hzKmIxy+KAf33X86W6mCHsyJfI0AR9bIP8kSAgvWqcMQz+jPs1iWYuuF5UXb5QToJAM8OgE9qdpQRMDJZuR8FU5VtJOR3Y/9KjGU8+gX7fddq4R3jgwAH7t9cym1FrSue6ZTzqrjANoVwW5bsPTy6TZdV5/HPNwBrOphunC7KH5E8eAKAngSaeA4iPMbzrzvqKQ9OeFYhRhCipBvoSnnmU++8al+axBUykfvhatiKGFCfvXfuY3XEpEqc8kNUPneTRzOu2DJBVJJyCs+cvm/crJRRZld2jmWWdsQrEskKONhy5w/0Y2Oz3mbBSH4DTnV4TGMspJl+Ltx9RELhQS1E7eeibgCeH+9dkzRzVQCeyKJzaD/fxZAf8Ur90cn+mFRVONwqfHUQaMkiTGjuH4v8bSnBv8qFxlY0qqWziZ3Oa/UejImq64zJDbufVP7jMRS+WQ961C02WH58NkYlf90RyD7TIB3j202wT4X0jwKPYk3Z4qsz4VkULZ/x3PIUWSsTuphhBWgCi3QW96tBubJqt/WwhPvMJzesxb5ts6Jwh2m8/zs54FDo7v9HBs4TSIChSwOdeFbDdzHytTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 29/01/26 5:54 pm, Vernon Yang wrote:
> On Thu, Jan 29, 2026 at 4:32 PM Dev Jain <dev.jain@arm.com> wrote:
>> On 29/01/26 1:29 pm, Vernon Yang wrote:
>>> On Thu, Jan 29, 2026 at 11:05:36AM +0530, Dev Jain wrote:
>>>> On 28/01/26 8:04 pm, Vernon Yang wrote:
>>>>> On Wed, Jan 28, 2026 at 01:59:33PM +0530, Dev Jain wrote:
>>>>>> On 23/01/26 1:52 pm, Vernon Yang wrote:
>>>>>>> From: Vernon Yang <yanglincheng@kylinos.cn>
>>>>>>>
>>>>>>> Currently, each scan always increases "progress" by HPAGE_PMD_NR,
>>>>>>> even if only scanning a single PTE/PMD entry.
>>>>>>>
>>>>>>> - When only scanning a sigle PTE entry, let me provide a detailed
>>>>>>>   example:
>>>>>>>
>>>>>>> static int hpage_collapse_scan_pmd()
>>>>>>> {
>>>>>>>   for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>>>>>>        _pte++, addr += PAGE_SIZE) {
>>>>>>>           pte_t pteval = ptep_get(_pte);
>>>>>>>           ...
>>>>>>>           if (pte_uffd_wp(pteval)) { <-- first scan hit
>>>>>>>                   result = SCAN_PTE_UFFD_WP;
>>>>>>>                   goto out_unmap;
>>>>>>>           }
>>>>>>>   }
>>>>>>> }
>>>>>>>
>>>>>>> During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
>>>>>>> directly. In practice, only one PTE is scanned before termination.
>>>>>>> Here, "progress += 1" reflects the actual number of PTEs scanned, but
>>>>>>> previously "progress += HPAGE_PMD_NR" always.
>>>>>>>
>>>>>>> - When the memory has been collapsed to PMD, let me provide a detailed
>>>>>>>   example:
>>>>>>>
>>>>>>> The following data is traced by bpftrace on a desktop system. After
>>>>>>> the system has been left idle for 10 minutes upon booting, a lot of
>>>>>>> SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
>>>>>>> by khugepaged.
>>>>>>>
>>>>>>> @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
>>>>>>> @scan_pmd_status[6]: 2           ## SCAN_EXCEED_SHARED_PTE
>>>>>>> @scan_pmd_status[3]: 142         ## SCAN_PMD_MAPPED
>>>>>>> @scan_pmd_status[2]: 178         ## SCAN_NO_PTE_TABLE
>>>>>> Could you elaborate what is [1], [6] etc and 1,2,142, etc?
>>>>> These 1,6 are value of "enum scan_result", you can directly refer to the
>>>>> notes on the right.
>>>>>
>>>>> These 1,2,142,178 are number of different "enum scan_result" from
>>>>> trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file.
>>>>>
>>>>> as example, SCAN_PMD_MAPPED has 142 times during a full scan by
>>>>> khugepaged.
>>>> Thanks. Can you please mention this in the patch description. You can simply
>>>> right it like this:
>>>>
>>>> "From trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file, the
>>>> following statuses were observed, with frequency mentioned next to them:
>>>>
>>>> SCAN_SUCCEED: 1
>>>> SCAN_PMD_MAPPED: 142
>>>> ....."
>>>>
>>>> and so on.
>>> LGTM, I will do it in the next version. Thanks!
>>>
>>>>>>> total progress size: 674 MB
>>>>>>> Total time         : 419 seconds ## include khugepaged_scan_sleep_millisecs
>>>>>>>
>>>>>>> The khugepaged_scan list save all task that support collapse into hugepage,
>>>>>>> as long as the task is not destroyed, khugepaged will not remove it from
>>>>>>> the khugepaged_scan list. This exist a phenomenon where task has already
>>>>>>> collapsed all memory regions into hugepage, but khugepaged continues to
>>>>>>> scan it, which wastes CPU time and invalid, and due to
>>>>>>> khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
>>>>>>> scanning a large number of invalid task, so scanning really valid task
>>>>>>> is later.
>>>>>>>
>>>>>>> After applying this patch, when the memory is either SCAN_PMD_MAPPED or
>>>>>>> SCAN_NO_PTE_TABLE, just skip it, as follow:
>>>>>>>
>>>>>>> @scan_pmd_status[6]: 2
>>>>>>> @scan_pmd_status[3]: 147
>>>>>>> @scan_pmd_status[2]: 173
>>>>>>> total progress size: 45 MB
>>>>>>> Total time         : 20 seconds
>>>>>>>
>>>>>>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>>>>>>> ---
>>>>>>>  include/linux/xarray.h |  9 ++++++++
>>>>>>>  mm/khugepaged.c        | 47 ++++++++++++++++++++++++++++++++++--------
>>>>>>>  2 files changed, 47 insertions(+), 9 deletions(-)
>>>>>>>
>>>>>>> diff --git a/include/linux/xarray.h b/include/linux/xarray.h
>>>>>>> index be850174e802..f77d97d7b957 100644
>>>>>>> --- a/include/linux/xarray.h
>>>>>>> +++ b/include/linux/xarray.h
>>>>>>> @@ -1646,6 +1646,15 @@ static inline void xas_set(struct xa_state *xas, unsigned long index)
>>>>>>>   xas->xa_node = XAS_RESTART;
>>>>>>>  }
>>>>>>>
>>>>>>> +/**
>>>>>>> + * xas_get_index() - Get XArray operation state for a different index.
>>>>>>> + * @xas: XArray operation state.
>>>>>>> + */
>>>>>>> +static inline unsigned long xas_get_index(struct xa_state *xas)
>>>>>>> +{
>>>>>>> + return xas->xa_index;
>>>>>>> +}
>>>>>>> +
>>>>>>>  /**
>>>>>>>   * xas_advance() - Skip over sibling entries.
>>>>>>>   * @xas: XArray operation state.
>>>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>>>> index 6f0f05148765..de95029e3763 100644
>>>>>>> --- a/mm/khugepaged.c
>>>>>>> +++ b/mm/khugepaged.c
>>>>>>> @@ -68,7 +68,10 @@ enum scan_result {
>>>>>>>  static struct task_struct *khugepaged_thread __read_mostly;
>>>>>>>  static DEFINE_MUTEX(khugepaged_mutex);
>>>>>>>
>>>>>>> -/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
>>>>>>> +/*
>>>>>>> + * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
>>>>>>> + * every 10 second.
>>>>>>> + */
>>>>>>>  static unsigned int khugepaged_pages_to_scan __read_mostly;
>>>>>>>  static unsigned int khugepaged_pages_collapsed;
>>>>>>>  static unsigned int khugepaged_full_scans;
>>>>>>> @@ -1240,7 +1243,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>>>>>>>  }
>>>>>>>
>>>>>>>  static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>>>> -         struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
>>>>>>> +         struct vm_area_struct *vma, unsigned long start_addr,
>>>>>>> +         bool *mmap_locked, unsigned int *cur_progress,
>>>>>>>           struct collapse_control *cc)
>>>>>>>  {
>>>>>>>   pmd_t *pmd;
>>>>>>> @@ -1255,6 +1259,9 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>>>>
>>>>>>>   VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>>>>>>>
>>>>>>> + if (cur_progress)
>>>>>>> +         *cur_progress += 1;
>>>>>> Why not be a little more explicit, and do this addition if find_pmd_or_thp_or_none fails,
>>>>>> or pte_offset_map_lock fails? The way you do it right now is not readable - it gives no
>>>>>> idea as to why on function entry we do a +1 right away. Please do add some comments too.
>>>>> If this way is not clear enough, we can directly add 1 in
>>>>> find_pmd_or_thp_or_none() etc, BUT it's a bit redundant.
>>>>> Please take a look at which one is better.
>>>>>
>>>>> case 1:
>>>>> as the V4 PATCH #2 [1] and #3 [2], only hpage_collapse_scan_pmd().
>>>>> [1] https://lore.kernel.org/linux-mm/20260111121909.8410-3-yanglincheng@kylinos.cn
>>>>> [2] https://lore.kernel.org/linux-mm/20260111121909.8410-4-yanglincheng@kylinos.cn
>>>>>
>>>>> static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>>             struct vm_area_struct *vma, unsigned long start_addr,
>>>>>             bool *mmap_locked, unsigned int *cur_progress,
>>>>>             struct collapse_control *cc)
>>>>> {
>>>>>     ...
>>>>>     result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>>>>>     if (result != SCAN_SUCCEED) {
>>>>>             if (cur_progress)
>>>>>                     *cur_progress += 1; // here
>>>>>             goto out;
>>>>>     }
>>>>>     ...
>>>>>     pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>>>>>     if (!pte) {
>>>>>             if (cur_progress)
>>>>>                     *cur_progress += 1; // here
>>>>>             result = SCAN_NO_PTE_TABLE;
>>>>>             goto out;
>>>>>     }
>>>>>
>>>>>     for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>>>>          _pte++, addr += PAGE_SIZE) {
>>>>>             if (cur_progress)
>>>>>                     *cur_progress += 1; // here
>>>>>             ...
>>>>>     }
>>>>> }
>>>>>
>>>>> case 2:
>>>>>
>>>>> static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>>             struct vm_area_struct *vma, unsigned long start_addr,
>>>>>             bool *mmap_locked, unsigned int *cur_progress,
>>>>>             struct collapse_control *cc)
>>>>> {
>>>>>     ...
>>>>>     result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>>>>>     if (result != SCAN_SUCCEED) {
>>>>>             if (cur_progress)
>>>>>                     *cur_progress += 1; // here
>>>> Let us be more explicit and set this equal to 1, instead of adding 1.
>>> LGTM, I will do it in the next version. Thanks!
>>>
>>>>>             goto out;
>>>>>     }
>>>>>     ...
>>>>>     pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>>>>>     if (!pte) {
>>>>>             if (cur_progress)
>>>>>                     *cur_progress += 1; // here
>>>> Same comment as above.
>>>>
>>>>>             result = SCAN_NO_PTE_TABLE;
>>>>>             goto out;
>>>>>     }
>>>>>
>>>>>     for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>>>>          _pte++, addr += PAGE_SIZE) {
>>>>>             ...
>>>>>     }
>>>>>     ...
>>>>> out_unmap:
>>>>>     if (cur_progress) {
>>>>>             if (_pte >= pte + HPAGE_PMD_NR)
>>>>>                     *cur_progress += HPAGE_PMD_NR;   // here
>>>>>             else
>>>>>                     *cur_progress += _pte - pte + 1; // here
>>>>>     }
>>>>> }
>>>> I will vote case 2. In case 1 I don't like the fact that the if (cur_progress)
>>>> branch will be checked each iteration - and I don't think the compiler can
>>>> optimize this since the body of the loop is complex, so this check cannot
>>>> be hoisted out of the loop.
>>>>
>>>>
>>>>> case 3:
>>>>>     current patch, and add more comments to clearer.
>>>>>
>>>>>>> +
>>>>>>>   result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>>>>>>>   if (result != SCAN_SUCCEED)
>>>>>>>           goto out;
>>>>>>> @@ -1396,6 +1403,12 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>>>>           result = SCAN_SUCCEED;
>>>>>>>   }
>>>>>>>  out_unmap:
>>>>>>> + if (cur_progress) {
>>>>>>> +         if (_pte >= pte + HPAGE_PMD_NR)
>>>>>>> +                 *cur_progress += HPAGE_PMD_NR - 1;
>>>>>>> +         else
>>>>>>> +                 *cur_progress += _pte - pte;
>>>>>>> + }
>>>>>>>   pte_unmap_unlock(pte, ptl);
>>>>>>>   if (result == SCAN_SUCCEED) {
>>>>>>>           result = collapse_huge_page(mm, start_addr, referenced,
>>>>>>> @@ -2286,8 +2299,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>>>>>>   return result;
>>>>>>>  }
>>>>>>>
>>>>>>> -static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>>>>>>> -         struct file *file, pgoff_t start, struct collapse_control *cc)
>>>>>>> +static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
>>>>>>> +         unsigned long addr, struct file *file, pgoff_t start,
>>>>>>> +         unsigned int *cur_progress, struct collapse_control *cc)
>>>>>>>  {
>>>>>>>   struct folio *folio = NULL;
>>>>>>>   struct address_space *mapping = file->f_mapping;
>>>>>>> @@ -2376,6 +2390,18 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>>>>>>>                   cond_resched_rcu();
>>>>>>>           }
>>>>>>>   }
>>>>>>> + if (cur_progress) {
>>>>>>> +         unsigned long idx = xas_get_index(&xas) - start;
>>>>>>> +
>>>>>>> +         if (folio == NULL)
>>>>>>> +                 *cur_progress += HPAGE_PMD_NR;
>>>>>> I think this whole block needs some comments. Can you explain, why you
>>>>>> do a particular increment in each case?
>>>>>>
>>>>>>> +         else if (xa_is_value(folio))
>>>>>>> +                 *cur_progress += idx + (1 << xas_get_order(&xas));
>>>>>>> +         else if (folio_order(folio) == HPAGE_PMD_ORDER)
>>>>>>> +                 *cur_progress += idx + 1;
>>>>>>> +         else
>>>>>>> +                 *cur_progress += idx + folio_nr_pages(folio);
>>>>>>> + }
>>>>> The "idx" represent PTEs number already scanned when exiting
>>>>> xas_for_each().
>>>>>
>>>>> However, the last valid folio size was not counted in "idx" (except
>>>>> folio == NULL, "idx" equal to HPAGE_PMD_NR), which can be further
>>>>> divided into three cases:
>>>> But, the number of PTEs you account in these three cases, are *not*
>>>> scanned, right? So we can simply drop these 3 cases.
>>> No, these three cases are the last scanning folio to break, I think we
>>> need to add them. Imagine that if we trigger HPAGE_PMD_ORDER folio
>>> firstly, "idx" is equal to 0.
>> If you hit a large folio and break, you don't consume any extra iterations.
>> The number of iterations is completely determined by xa_index. This is kind
>> of analogous to SCAN_PMD_MAPPED - in one "iteration", you decide to stop
>> scanning, and set progress to 1.
>>
>> In any case, the problem which you describe in the patch description is
>> completely solved by setting progress to 1 upon failure of find_pmd_or_thp_or_none.
>> So anything else which you do (like counting iterations in hpage_collapse_scan_pmd
>> or hpage_collapse_scan_file) is extra and it is not clear if it has a practical
>> benefit. The patch benefits us because there are a lot of SCAN_PMD_MAPPED and SCAN_PMD_NONE.
>> Will we practically also encounter a large number of SCAN_EXCEED_PTE_SWAP, PTE_NONE, etc?
>>
>> I tilt towards keeping the other bits of the patch, if they can be simplified, and
>> because this patch is relatively harmless. Just like you count the number of iterations
>> in hpage_collapse_scan_pmd(), you can do the same here using xa_index.
> The semantics of hpage_collapse_scan_pmd() _pte and hpage_collapse_scan_file()
> xas.xa_index are different.
>
> Let me give a detailed example :)
>
> xas->xa_index represents the starting address of the last folio when exiting
> xas_for_each().
>
> Assuming each folio size is 32KB, when we iterate "folio1 -> folio2" and break,
> xas->xa_index equals the starting address of folio2, so "idx = 8". However,
> folio2 is not counted in "idx".
>
> In reality, folio2 has been scanned, so we need to add the folio2 size, making
> "idx = 16" the correct value.

The "scanning" of folio2 is O(1). It is *not* proportional to the number of ptes
covered by folio2 (which is 8), as we break immediately.

As I said above, you will be contradicting the patch's objective here - if you
see a PMD_ORDER folio and set progress = HPAGE_PMD_NR, that exactly corresponds
to seeing a PMD mapping in the anon collapse path, and setting progress = HPAGE_PMD_NR.
But that is not appropriate - deducing that the PMD maps a PMD folio, is an O(1)
operation w.r.t the number of ptes.

>
> There are two ways for folio2:
> 1. shmem swap entries (xa_is_value), breaking out of the xas_for_each loop
>    due to SCAN_EXCEED_SWAP_PTE.
> 2. Normal folio, breaking out of the xas_for_each loop due to
>    SCAN_SCAN_ABORT/SCAN_PAGE_LRU/SCAN_PAGE_COUNT.
>
> Move Lance suggestion to here.
>> if (cur_progress)
>>       *cur_progress = max(xas.xa_index - start, 1UL);
> If we use the code suggested by Lance, we will miss the folio2 size,
> the result is "idx = 8".
> Is this the result we wanted? If Yes, Lance's suggested code is perfect.
>
> Another more specific scenario is when the first iterated folio is
> HPAGE_PMD_ORDER, "idx = 0", Yep, we can directly set "cur_progress = 1",
> it's simple enough.

Yes, let us do that.

>
>>>>> 1. shmem swap entries (xa_is_value), add folio size.
>>>>> 2. the folio is HPAGE_PMD_ORDER, the memory has been collapsed
>>>>>    to PMD, so add 1 only.
>>>>> 3. Normal folio, add folio size.
>>>>>
>>>>> Is the version below more readable?
>>>>>
>>>>>     if (cur_progress) {
>>>>>             *cur_progress += xas.xa_index - start;
>>>>>
>>>>>             if (folio) {
>>>>>                     if (xa_is_value(folio))
>>>>>                             *cur_progress += 1 << xas_get_order(&xas);
>>>>>                     else if (folio_order(folio) == HPAGE_PMD_ORDER)
>>>>>                             *cur_progress += 1;
>>>>>                     else
>>>>>                             *cur_progress += folio_nr_pages(folio);
>>>>>             }
>>>>>     }
>>>> Yep, this is unneeded complexity. This looks really ugly and the benefits of
>>>> this are not clear. You can simply do
>>>>
>>>> if (cur_progress)
>>>>      *cur_progress = xas.xa_index - start;
>>>>
>>>>>>>   rcu_read_unlock();
>>>>>>>
>>>>>>>   if (result == SCAN_SUCCEED) {
>>>>>>> @@ -2456,6 +2482,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>>>>>>>
>>>>>>>           while (khugepaged_scan.address < hend) {
>>>>>>>                   bool mmap_locked = true;
>>>>>>> +                 unsigned int cur_progress = 0;
>>>>>>>
>>>>>>>                   cond_resched();
>>>>>>>                   if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
>>>>>>> @@ -2472,7 +2499,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>>>>>>>                           mmap_read_unlock(mm);
>>>>>>>                           mmap_locked = false;
>>>>>>>                           *result = hpage_collapse_scan_file(mm,
>>>>>>> -                                 khugepaged_scan.address, file, pgoff, cc);
>>>>>>> +                                 khugepaged_scan.address, file, pgoff,
>>>>>>> +                                 &cur_progress, cc);
>>>>>>>                           fput(file);
>>>>>>>                           if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
>>>>>>>                                   mmap_read_lock(mm);
>>>>>>> @@ -2486,7 +2514,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>>>>>>>                           }
>>>>>>>                   } else {
>>>>>>>                           *result = hpage_collapse_scan_pmd(mm, vma,
>>>>>>> -                                 khugepaged_scan.address, &mmap_locked, cc);
>>>>>>> +                                 khugepaged_scan.address, &mmap_locked,
>>>>>>> +                                 &cur_progress, cc);
>>>>>>>                   }
>>>>>>>
>>>>>>>                   if (*result == SCAN_SUCCEED)
>>>>>>> @@ -2494,7 +2523,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>>>>>>>
>>>>>>>                   /* move to next address */
>>>>>>>                   khugepaged_scan.address += HPAGE_PMD_SIZE;
>>>>>>> -                 progress += HPAGE_PMD_NR;
>>>>>>> +                 progress += cur_progress;
>>>>>>>                   if (!mmap_locked)
>>>>>>>                           /*
>>>>>>>                            * We released mmap_lock so break loop.  Note
>>>>>>> @@ -2817,7 +2846,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>>>>>                   mmap_locked = false;
>>>>>>>                   *lock_dropped = true;
>>>>>>>                   result = hpage_collapse_scan_file(mm, addr, file, pgoff,
>>>>>>> -                                                   cc);
>>>>>>> +                                                   NULL, cc);
>>>>>>>
>>>>>>>                   if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
>>>>>>>                       mapping_can_writeback(file->f_mapping)) {
>>>>>>> @@ -2832,7 +2861,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>>>>>                   fput(file);
>>>>>>>           } else {
>>>>>>>                   result = hpage_collapse_scan_pmd(mm, vma, addr,
>>>>>>> -                                                  &mmap_locked, cc);
>>>>>>> +                                                  &mmap_locked, NULL, cc);
>>>>>>>           }
>>>>>>>           if (!mmap_locked)
>>>>>>>                   *lock_dropped = true;
>>>>> --
>>>>> Thanks,
>>>>> Vernon

