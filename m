Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 169F4D358E8
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 09:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3A46B0088; Thu, 29 Jan 2026 04:18:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494636B0089; Thu, 29 Jan 2026 04:18:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0B46B008A; Thu, 29 Jan 2026 04:18:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 266DC6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 04:18:51 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C115B1408FE
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:18:50 +0000 (UTC)
X-FDA: 84384451620.25.E7022BE
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id BF304140003
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:18:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wlkICQ//";
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769678329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FgKOp/1UIU/SbIK6o+WBT2cNTYn8wxY0OTA6VkD3/l8=;
	b=FRwsVz2y6ga23BAFZg58ref9cntUm/CqLKH6fWD/Ptly0oJ1Uf40xh40Vl5z1bxljDKQeA
	cJbCHPrub+ukBdK+5L75BRiMnr9iQcESefJPn0oTors63A79ZT/ashF+kW1s7ol5KiwP2L
	QDl9AuVgcDu3GoRG9w9KHD2JFjngujQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wlkICQ//";
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769678329; a=rsa-sha256;
	cv=none;
	b=mfyn0IHxsdepoQrpF4M/CTN8u/n7knsnwelb5eEY1uOPM3xfqr3OMCb29hnbmRo0VWFW7O
	5u4YifdlgoNaUc44U3xyF9/6fDbdQ4rMIAsN49DN5x/k8v6b3BDO7eb9FaflDYGEJNaOXj
	CItIqHIR5yLAIjgR/6NP22Zblnbu6gg=
Message-ID: <d719e478-4849-4c5f-9e6c-f45d9771b37b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769678324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FgKOp/1UIU/SbIK6o+WBT2cNTYn8wxY0OTA6VkD3/l8=;
	b=wlkICQ//uF4lTsovrNGtkBbaLGwvaco9datftfKAy5LMDtB+LWNv4R9XULkXS+PD0bOsZV
	Wr/XxEcMkDTUIcBiHQB/oCUZrkm0RUQ/niqx2smRNgPQpmhQTCFuq428ohsBnTQCJOosA6
	wS6hcFKZQN2bC0/7JBHLaCrKUBrSsLM=
Date: Thu, 29 Jan 2026 17:18:37 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v5 2/5] mm: khugepaged: refine scan progress number
Content-Language: en-US
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Dev Jain <dev.jain@arm.com>,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260123082232.16413-1-vernon2gm@gmail.com>
 <20260123082232.16413-3-vernon2gm@gmail.com>
 <72dfd11f-dca4-447e-89c5-7a87cb675bda@arm.com>
 <4exllw7pf4yfhfzpyg3ictsnznf5lepv5tjd7zvycldjwmh6jm@j6rara3ogrux>
 <7c4b5933-7bbd-4ad7-baef-830304a09485@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <7c4b5933-7bbd-4ad7-baef-830304a09485@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: yoiw77n9mxr9e3zzpb9rbtutc1be7iz5
X-Rspamd-Queue-Id: BF304140003
X-Rspam-User: 
X-HE-Tag: 1769678328-234239
X-HE-Meta: U2FsdGVkX1+bidY2fSNwAI4KEuFzfi7rjJaokG7m3wCvZRG05i5EdDfjFh+E6iaVGIv4lurcbgKOr8fQ4HImJ4+q5Sv+k2TMp1NYN+OdIdxxn02Px3QnDJcVL4DTdO3FFeH5pgbJzACHaZe4VXd5TIlkRIrFB42XOJ6nOCMIsW9bt289Fd/m4GeO10FEt4S3QOc6m3H/DYJLSFhrqsoZem/b2JTBxGqjTRFYEwK9oQASASSVOoQ6y4bmM2k8xf8Bof7cWtJHgwU765hwt826BO3CZzxhXPsGHe+XMWY0IJ1vG8ywOp83urvl1tLpnJOTMiv7f/3peb6xrSTp0Xugh0U1/cqx8XiuOIBU2TG68lSZ+whsbmE2TZKcReg0p6SWTzw54FMISJlVG1DxvkkPwKBiq5nXD7dtQY6r/fLcTCP++6o+qjVgnJXTNpRLxDkunCOwEFpowHIMlS+tqwFkLYZugEegJzUMXC4Q1gFWvpXZCK99ZR0M8ojAvTZMQ42wSyMTKPs3BaITe1CvAQVwG5VY+XzVZn1dAnQxDAmhhk0+TwDfWVhApcdSn4JDOY5hEFAzXaMeY7pME4a0vpHdZMUNHWfW/ynrUkHDxpiGLoiskiXR5VxUgHPAU7941yp+UVWNcCk+kmzcm7ZC2ynNWsWyK4Om+Cpt1WiDP14WixFCvJLfjVDzMrAYryJpvjck2l1CBXz/oVJ7f5JInI+Q+zq/72RKLyR35P4L6UkSpuezthK00a/QDb9MguDxfL89KPfCsIWhenq3iRfTrLnLmAmnn/Ae+yDBptB+YrbF61HbuiZ3f/wR64b9Xqi28GJWNsdMZ0n+W1ngezY/gQN/vDrCVumCS5qHozx3QJRqw5K7u0lFZbqXs2bkQT3of0Smk1LYJUdhTPFBzNz+mMAep8eeze0BV3nFylKRZ9do5fSuRsMfZwp35Z6AEkcyoJCuXWL5HxEyD8UZ7siV362
 twQNJ5v0
 qCH978lNNG11lfxXbP+m5VO3KAWh0OA26w9GJ8XzFYorY07+6TSGa2rKsiEVO+yXOA6fpQOAzEsuyjCUapQEg/x52b4srPLN3Rc3d/qpAfkwZUzLcLx985woT5kqtM64RrNhl4hToN133L58ODaDlH+uqXUxjD2ZaqHBBzTKBQ7j+fvJS5Oelsrux5HDzoeRZA5llez5a9kluDZoUmvjo+L8je6sFeUQdcqg/dBwMOc1sCKc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/29 13:35, Dev Jain wrote:
> 
> On 28/01/26 8:04 pm, Vernon Yang wrote:
>> On Wed, Jan 28, 2026 at 01:59:33PM +0530, Dev Jain wrote:
>>> On 23/01/26 1:52 pm, Vernon Yang wrote:
>>>> From: Vernon Yang <yanglincheng@kylinos.cn>
>>>>
>>>> Currently, each scan always increases "progress" by HPAGE_PMD_NR,
>>>> even if only scanning a single PTE/PMD entry.
>>>>
>>>> - When only scanning a sigle PTE entry, let me provide a detailed
>>>>    example:
>>>>
>>>> static int hpage_collapse_scan_pmd()
>>>> {
>>>> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>>> 	     _pte++, addr += PAGE_SIZE) {
>>>> 		pte_t pteval = ptep_get(_pte);
>>>> 		...
>>>> 		if (pte_uffd_wp(pteval)) { <-- first scan hit
>>>> 			result = SCAN_PTE_UFFD_WP;
>>>> 			goto out_unmap;
>>>> 		}
>>>> 	}
>>>> }
>>>>
>>>> During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
>>>> directly. In practice, only one PTE is scanned before termination.
>>>> Here, "progress += 1" reflects the actual number of PTEs scanned, but
>>>> previously "progress += HPAGE_PMD_NR" always.
>>>>
>>>> - When the memory has been collapsed to PMD, let me provide a detailed
>>>>    example:
>>>>
>>>> The following data is traced by bpftrace on a desktop system. After
>>>> the system has been left idle for 10 minutes upon booting, a lot of
>>>> SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
>>>> by khugepaged.
>>>>
>>>> @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
>>>> @scan_pmd_status[6]: 2           ## SCAN_EXCEED_SHARED_PTE
>>>> @scan_pmd_status[3]: 142         ## SCAN_PMD_MAPPED
>>>> @scan_pmd_status[2]: 178         ## SCAN_NO_PTE_TABLE
>>> Could you elaborate what is [1], [6] etc and 1,2,142, etc?
>> These 1,6 are value of "enum scan_result", you can directly refer to the
>> notes on the right.
>>
>> These 1,2,142,178 are number of different "enum scan_result" from
>> trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file.
>>
>> as example, SCAN_PMD_MAPPED has 142 times during a full scan by
>> khugepaged.
> 
> Thanks. Can you please mention this in the patch description. You can simply
> right it like this:
> 
> "From trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file, the
> following statuses were observed, with frequency mentioned next to them:
> 
> SCAN_SUCCEED: 1
> SCAN_PMD_MAPPED: 142
> ....."
> 
> and so on.
> 
>>
>>>> total progress size: 674 MB
>>>> Total time         : 419 seconds ## include khugepaged_scan_sleep_millisecs
>>>>
>>>> The khugepaged_scan list save all task that support collapse into hugepage,
>>>> as long as the task is not destroyed, khugepaged will not remove it from
>>>> the khugepaged_scan list. This exist a phenomenon where task has already
>>>> collapsed all memory regions into hugepage, but khugepaged continues to
>>>> scan it, which wastes CPU time and invalid, and due to
>>>> khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
>>>> scanning a large number of invalid task, so scanning really valid task
>>>> is later.
>>>>
>>>> After applying this patch, when the memory is either SCAN_PMD_MAPPED or
>>>> SCAN_NO_PTE_TABLE, just skip it, as follow:
>>>>
>>>> @scan_pmd_status[6]: 2
>>>> @scan_pmd_status[3]: 147
>>>> @scan_pmd_status[2]: 173
>>>> total progress size: 45 MB
>>>> Total time         : 20 seconds
>>>>
>>>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>>>> ---
>>>>   include/linux/xarray.h |  9 ++++++++
>>>>   mm/khugepaged.c        | 47 ++++++++++++++++++++++++++++++++++--------
>>>>   2 files changed, 47 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/include/linux/xarray.h b/include/linux/xarray.h
>>>> index be850174e802..f77d97d7b957 100644
>>>> --- a/include/linux/xarray.h
>>>> +++ b/include/linux/xarray.h
>>>> @@ -1646,6 +1646,15 @@ static inline void xas_set(struct xa_state *xas, unsigned long index)
>>>>   	xas->xa_node = XAS_RESTART;
>>>>   }
>>>>
>>>> +/**
>>>> + * xas_get_index() - Get XArray operation state for a different index.
>>>> + * @xas: XArray operation state.
>>>> + */
>>>> +static inline unsigned long xas_get_index(struct xa_state *xas)
>>>> +{
>>>> +	return xas->xa_index;
>>>> +}
>>>> +
>>>>   /**
>>>>    * xas_advance() - Skip over sibling entries.
>>>>    * @xas: XArray operation state.
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index 6f0f05148765..de95029e3763 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -68,7 +68,10 @@ enum scan_result {
>>>>   static struct task_struct *khugepaged_thread __read_mostly;
>>>>   static DEFINE_MUTEX(khugepaged_mutex);
>>>>
>>>> -/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
>>>> +/*
>>>> + * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
>>>> + * every 10 second.
>>>> + */
>>>>   static unsigned int khugepaged_pages_to_scan __read_mostly;
>>>>   static unsigned int khugepaged_pages_collapsed;
>>>>   static unsigned int khugepaged_full_scans;
>>>> @@ -1240,7 +1243,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>>>>   }
>>>>
>>>>   static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>> -		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
>>>> +		struct vm_area_struct *vma, unsigned long start_addr,
>>>> +		bool *mmap_locked, unsigned int *cur_progress,
>>>>   		struct collapse_control *cc)
>>>>   {
>>>>   	pmd_t *pmd;
>>>> @@ -1255,6 +1259,9 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>
>>>>   	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>>>>
>>>> +	if (cur_progress)
>>>> +		*cur_progress += 1;
>>> Why not be a little more explicit, and do this addition if find_pmd_or_thp_or_none fails,
>>> or pte_offset_map_lock fails? The way you do it right now is not readable - it gives no
>>> idea as to why on function entry we do a +1 right away. Please do add some comments too.
>> If this way is not clear enough, we can directly add 1 in
>> find_pmd_or_thp_or_none() etc, BUT it's a bit redundant.
>> Please take a look at which one is better.
>>
>> case 1:
>> as the V4 PATCH #2 [1] and #3 [2], only hpage_collapse_scan_pmd().
>> [1] https://lore.kernel.org/linux-mm/20260111121909.8410-3-yanglincheng@kylinos.cn
>> [2] https://lore.kernel.org/linux-mm/20260111121909.8410-4-yanglincheng@kylinos.cn
>>
>> static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>> 		struct vm_area_struct *vma, unsigned long start_addr,
>> 		bool *mmap_locked, unsigned int *cur_progress,
>> 		struct collapse_control *cc)
>> {
>> 	...
>> 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>> 	if (result != SCAN_SUCCEED) {
>> 		if (cur_progress)
>> 			*cur_progress += 1; // here
>> 		goto out;
>> 	}
>> 	...
>> 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>> 	if (!pte) {
>> 		if (cur_progress)
>> 			*cur_progress += 1; // here
>> 		result = SCAN_NO_PTE_TABLE;
>> 		goto out;
>> 	}
>>
>> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>> 	     _pte++, addr += PAGE_SIZE) {
>> 		if (cur_progress)
>> 			*cur_progress += 1; // here
>> 		...
>> 	}
>> }
>>
>> case 2:
>>
>> static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>> 		struct vm_area_struct *vma, unsigned long start_addr,
>> 		bool *mmap_locked, unsigned int *cur_progress,
>> 		struct collapse_control *cc)
>> {
>> 	...
>> 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>> 	if (result != SCAN_SUCCEED) {
>> 		if (cur_progress)
>> 			*cur_progress += 1; // here
> 
> Let us be more explicit and set this equal to 1, instead of adding 1.
> 
>> 		goto out;
>> 	}
>> 	...
>> 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>> 	if (!pte) {
>> 		if (cur_progress)
>> 			*cur_progress += 1; // here
> 
> Same comment as above.
> 
>> 		result = SCAN_NO_PTE_TABLE;
>> 		goto out;
>> 	}
>>
>> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>> 	     _pte++, addr += PAGE_SIZE) {
>> 		...
>> 	}
>> 	...
>> out_unmap:
>> 	if (cur_progress) {
>> 		if (_pte >= pte + HPAGE_PMD_NR)
>> 			*cur_progress += HPAGE_PMD_NR;   // here
>> 		else
>> 			*cur_progress += _pte - pte + 1; // here
>> 	}
>> }
> 
> I will vote case 2. In case 1 I don't like the fact that the if (cur_progress)
> branch will be checked each iteration - and I don't think the compiler can
> optimize this since the body of the loop is complex, so this check cannot
> be hoisted out of the loop.
> 
> 
>>
>> case 3:
>> 	current patch, and add more comments to clearer.
>>
>>>> +
>>>>   	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>>>>   	if (result != SCAN_SUCCEED)
>>>>   		goto out;
>>>> @@ -1396,6 +1403,12 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>   		result = SCAN_SUCCEED;
>>>>   	}
>>>>   out_unmap:
>>>> +	if (cur_progress) {
>>>> +		if (_pte >= pte + HPAGE_PMD_NR)
>>>> +			*cur_progress += HPAGE_PMD_NR - 1;
>>>> +		else
>>>> +			*cur_progress += _pte - pte;
>>>> +	}
>>>>   	pte_unmap_unlock(pte, ptl);
>>>>   	if (result == SCAN_SUCCEED) {
>>>>   		result = collapse_huge_page(mm, start_addr, referenced,
>>>> @@ -2286,8 +2299,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>>>   	return result;
>>>>   }
>>>>
>>>> -static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>>>> -		struct file *file, pgoff_t start, struct collapse_control *cc)
>>>> +static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
>>>> +		unsigned long addr, struct file *file, pgoff_t start,
>>>> +		unsigned int *cur_progress, struct collapse_control *cc)
>>>>   {
>>>>   	struct folio *folio = NULL;
>>>>   	struct address_space *mapping = file->f_mapping;
>>>> @@ -2376,6 +2390,18 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>>>>   			cond_resched_rcu();
>>>>   		}
>>>>   	}
>>>> +	if (cur_progress) {
>>>> +		unsigned long idx = xas_get_index(&xas) - start;
>>>> +
>>>> +		if (folio == NULL)
>>>> +			*cur_progress += HPAGE_PMD_NR;
>>> I think this whole block needs some comments. Can you explain, why you
>>> do a particular increment in each case?
>>>
>>>> +		else if (xa_is_value(folio))
>>>> +			*cur_progress += idx + (1 << xas_get_order(&xas));
>>>> +		else if (folio_order(folio) == HPAGE_PMD_ORDER)
>>>> +			*cur_progress += idx + 1;
>>>> +		else
>>>> +			*cur_progress += idx + folio_nr_pages(folio);
>>>> +	}
>> The "idx" represent PTEs number already scanned when exiting
>> xas_for_each().
>>
>> However, the last valid folio size was not counted in "idx" (except
>> folio == NULL, "idx" equal to HPAGE_PMD_NR), which can be further
>> divided into three cases:
> 
> But, the number of PTEs you account in these three cases, are *not*
> scanned, right? So we can simply drop these 3 cases.
> 
>>
>> 1. shmem swap entries (xa_is_value), add folio size.
>> 2. the folio is HPAGE_PMD_ORDER, the memory has been collapsed
>>     to PMD, so add 1 only.
>> 3. Normal folio, add folio size.
>>
>> Is the version below more readable?
>>
>> 	if (cur_progress) {
>> 		*cur_progress += xas.xa_index - start;
>>
>> 		if (folio) {
>> 			if (xa_is_value(folio))
>> 				*cur_progress += 1 << xas_get_order(&xas);
>> 			else if (folio_order(folio) == HPAGE_PMD_ORDER)
>> 				*cur_progress += 1;
>> 			else
>> 				*cur_progress += folio_nr_pages(folio);
>> 		}
>> 	}
> 
> Yep, this is unneeded complexity. This looks really ugly and the benefits of
> this are not clear. You can simply do
> 
> if (cur_progress)
> 	*cur_progress = xas.xa_index - start;
> 

I agree with Dev here. The extra complexity in hpage_collapse_scan_file()
doesn't seem worth it.

Suggest:

if (cur_progress)
	*cur_progress = max(xas.xa_index - start, 1UL);

Just keeps it simple, and handles the idx=0 case you mentioned as well.

[...]

