Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C32EAD3569F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 05:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1C976B0088; Thu, 29 Jan 2026 00:35:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA1F6B0089; Thu, 29 Jan 2026 00:35:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9046B008A; Thu, 29 Jan 2026 00:35:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79E486B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 00:35:45 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0CB65C2B92
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 05:35:45 +0000 (UTC)
X-FDA: 84383889450.16.0A2AE6E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id ED59340009
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 05:35:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769664943; a=rsa-sha256;
	cv=none;
	b=zmnFdHj6HWvsFNb73qGgeHJ6UigGUYyWc2bY1rz0TPL4TbbjmPenJ0Disj7gPQbANynBd9
	dnEG1m9iemi7d9n83jbY/hh0XwB16lxQdOPjnqKy6IQvdlEevt2fzejGrZ/Qzdx1fhgvig
	LP/BVtHbEstEwzvLwZy3KQ0FRARi7z4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769664943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bd5KwmirMaBUVWq0YdRmtYq78dmZNjy8Xi8y2D1oq7Y=;
	b=6A7u8ZKeiQO9Tt9WkV3k/xKTy2lST9EQIKPj5oQNpLwIRxyhYDuFnkAmdSkgtX+c23hQ8Y
	J5ze4HbjzIPnK+mY85hx6nWMQcx/wt0wPdPJrlTtQN25mMQTXs8of4jZT0Vgho1uvgsZCA
	xonlwApvf9NfcrLHYtKqpr/A4a9I+so=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5275B1516;
	Wed, 28 Jan 2026 21:35:35 -0800 (PST)
Received: from [10.164.18.94] (unknown [10.164.18.94])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 129BE3F73F;
	Wed, 28 Jan 2026 21:35:38 -0800 (PST)
Message-ID: <7c4b5933-7bbd-4ad7-baef-830304a09485@arm.com>
Date: Thu, 29 Jan 2026 11:05:36 +0530
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
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <4exllw7pf4yfhfzpyg3ictsnznf5lepv5tjd7zvycldjwmh6jm@j6rara3ogrux>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ED59340009
X-Stat-Signature: 87iy18t5sk9pmpbqp3mnyttsk6czpyqu
X-HE-Tag: 1769664942-614827
X-HE-Meta: U2FsdGVkX1/rpKVN4Che48vssJEzdpp+cD9WJ2RA8fGV7JLJwSrOqhgT3px8/BvmRUHpG2uazzPIcRhWDKNJGys3r9hsLE9z47ZnTNgS/qKcO2+xlGoWPmMxNo8sXj2Agk6pF2cU+NpOJZ7gGlA6xvwO8mWVqOByiywf6ea48TMcX7t66HXQQaBJoXt40Rsb4Es6IkCIlBb3+zI6sakphEMf0XdFhcCITpsu6GeJjbR9Wr0vf3XR7vdLnKdZaUdAA4TNQhIJNBA5ZkMrH4o3NPXdG4w0yJFZl0U6YhBdHsZw8aylubTXZmtt0es/XzW8yAH+f5g3TwlwUvaMoQVdSCIiZX9yGlHlUTfPQEv6bwUc62JNu15PgttFSfC0bie19KfG+mfb9dd70XgBGmB/KNVBAwi2G2EqT9L1dijaXjKMsVSa2v0gu90dkwq/o2Y9SLoTXrEPHVgsfChjicsdIIGzbfNryIliNERCdCfWqGsRgR/J1QkRXaywzafPgFPcioxIM6507RdnTPkspz6AZmoexmO6M+wU8oYjZSNyrorpit6f3s7ykiG+zWkQ2yDQzIA0uRGcxsOKoFHE2gTcZo9NKKz+IcY74LJTEFaH50vajYf895TiE4NI96EhtFwivJ0qOKVcIE8IIWMStdGTbS0P8SnJEWlWK4rah04munqgdOGvdcDWI86RDRQmXoM7G+VnqZcKL6Xxq1DHgSN1uV6g13ea5BKe4WwkOQGsCtfcLS7pA3aYh6S4V+PZt4XbbFZhxnyiVS05IzpkvS9qgpw87B8eTX+JDWdiFYrXqZjeu+UZC/t3tD1ccGqM5QEIfzNEpWak2mPwGwQgGANY1/vTgiiGAsnzR7w/bIwZP9UgAg4fnxuPT9N8JAbGiGb7cfG6bby1y+IF7xBcofF8pyp1ntlU7qH2iikswpzpnBH82tEJJ0oL7AhI0tO+Kughfsy0cADxlTk/z+EHe7X
 O8YvXixv
 o2fMs1iiXnVuNYwVzmur7Hz6i02ORH+yJnTrbS/LE782JHwQvwNIg78RL1z7GMvAIGe/V4I0ZEjPXo/wYLfn2NgbUodJLOttlozBZcrocQmegPDZmJofyVnQRBRBrXU323W/J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 28/01/26 8:04 pm, Vernon Yang wrote:
> On Wed, Jan 28, 2026 at 01:59:33PM +0530, Dev Jain wrote:
>> On 23/01/26 1:52 pm, Vernon Yang wrote:
>>> From: Vernon Yang <yanglincheng@kylinos.cn>
>>>
>>> Currently, each scan always increases "progress" by HPAGE_PMD_NR,
>>> even if only scanning a single PTE/PMD entry.
>>>
>>> - When only scanning a sigle PTE entry, let me provide a detailed
>>>   example:
>>>
>>> static int hpage_collapse_scan_pmd()
>>> {
>>> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>> 	     _pte++, addr += PAGE_SIZE) {
>>> 		pte_t pteval = ptep_get(_pte);
>>> 		...
>>> 		if (pte_uffd_wp(pteval)) { <-- first scan hit
>>> 			result = SCAN_PTE_UFFD_WP;
>>> 			goto out_unmap;
>>> 		}
>>> 	}
>>> }
>>>
>>> During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
>>> directly. In practice, only one PTE is scanned before termination.
>>> Here, "progress += 1" reflects the actual number of PTEs scanned, but
>>> previously "progress += HPAGE_PMD_NR" always.
>>>
>>> - When the memory has been collapsed to PMD, let me provide a detailed
>>>   example:
>>>
>>> The following data is traced by bpftrace on a desktop system. After
>>> the system has been left idle for 10 minutes upon booting, a lot of
>>> SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
>>> by khugepaged.
>>>
>>> @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
>>> @scan_pmd_status[6]: 2           ## SCAN_EXCEED_SHARED_PTE
>>> @scan_pmd_status[3]: 142         ## SCAN_PMD_MAPPED
>>> @scan_pmd_status[2]: 178         ## SCAN_NO_PTE_TABLE
>> Could you elaborate what is [1], [6] etc and 1,2,142, etc?
> These 1,6 are value of "enum scan_result", you can directly refer to the
> notes on the right.
>
> These 1,2,142,178 are number of different "enum scan_result" from
> trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file.
>
> as example, SCAN_PMD_MAPPED has 142 times during a full scan by
> khugepaged.

Thanks. Can you please mention this in the patch description. You can simply
right it like this:

"From trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file, the
following statuses were observed, with frequency mentioned next to them:

SCAN_SUCCEED: 1
SCAN_PMD_MAPPED: 142
....."

and so on.

>
>>> total progress size: 674 MB
>>> Total time         : 419 seconds ## include khugepaged_scan_sleep_millisecs
>>>
>>> The khugepaged_scan list save all task that support collapse into hugepage,
>>> as long as the task is not destroyed, khugepaged will not remove it from
>>> the khugepaged_scan list. This exist a phenomenon where task has already
>>> collapsed all memory regions into hugepage, but khugepaged continues to
>>> scan it, which wastes CPU time and invalid, and due to
>>> khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
>>> scanning a large number of invalid task, so scanning really valid task
>>> is later.
>>>
>>> After applying this patch, when the memory is either SCAN_PMD_MAPPED or
>>> SCAN_NO_PTE_TABLE, just skip it, as follow:
>>>
>>> @scan_pmd_status[6]: 2
>>> @scan_pmd_status[3]: 147
>>> @scan_pmd_status[2]: 173
>>> total progress size: 45 MB
>>> Total time         : 20 seconds
>>>
>>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>>> ---
>>>  include/linux/xarray.h |  9 ++++++++
>>>  mm/khugepaged.c        | 47 ++++++++++++++++++++++++++++++++++--------
>>>  2 files changed, 47 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/include/linux/xarray.h b/include/linux/xarray.h
>>> index be850174e802..f77d97d7b957 100644
>>> --- a/include/linux/xarray.h
>>> +++ b/include/linux/xarray.h
>>> @@ -1646,6 +1646,15 @@ static inline void xas_set(struct xa_state *xas, unsigned long index)
>>>  	xas->xa_node = XAS_RESTART;
>>>  }
>>>
>>> +/**
>>> + * xas_get_index() - Get XArray operation state for a different index.
>>> + * @xas: XArray operation state.
>>> + */
>>> +static inline unsigned long xas_get_index(struct xa_state *xas)
>>> +{
>>> +	return xas->xa_index;
>>> +}
>>> +
>>>  /**
>>>   * xas_advance() - Skip over sibling entries.
>>>   * @xas: XArray operation state.
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 6f0f05148765..de95029e3763 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -68,7 +68,10 @@ enum scan_result {
>>>  static struct task_struct *khugepaged_thread __read_mostly;
>>>  static DEFINE_MUTEX(khugepaged_mutex);
>>>
>>> -/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
>>> +/*
>>> + * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
>>> + * every 10 second.
>>> + */
>>>  static unsigned int khugepaged_pages_to_scan __read_mostly;
>>>  static unsigned int khugepaged_pages_collapsed;
>>>  static unsigned int khugepaged_full_scans;
>>> @@ -1240,7 +1243,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>>>  }
>>>
>>>  static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>> -		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
>>> +		struct vm_area_struct *vma, unsigned long start_addr,
>>> +		bool *mmap_locked, unsigned int *cur_progress,
>>>  		struct collapse_control *cc)
>>>  {
>>>  	pmd_t *pmd;
>>> @@ -1255,6 +1259,9 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>
>>>  	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>>>
>>> +	if (cur_progress)
>>> +		*cur_progress += 1;
>> Why not be a little more explicit, and do this addition if find_pmd_or_thp_or_none fails,
>> or pte_offset_map_lock fails? The way you do it right now is not readable - it gives no
>> idea as to why on function entry we do a +1 right away. Please do add some comments too.
> If this way is not clear enough, we can directly add 1 in
> find_pmd_or_thp_or_none() etc, BUT it's a bit redundant.
> Please take a look at which one is better.
>
> case 1:
> as the V4 PATCH #2 [1] and #3 [2], only hpage_collapse_scan_pmd().
> [1] https://lore.kernel.org/linux-mm/20260111121909.8410-3-yanglincheng@kylinos.cn
> [2] https://lore.kernel.org/linux-mm/20260111121909.8410-4-yanglincheng@kylinos.cn
>
> static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> 		struct vm_area_struct *vma, unsigned long start_addr,
> 		bool *mmap_locked, unsigned int *cur_progress,
> 		struct collapse_control *cc)
> {
> 	...
> 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> 	if (result != SCAN_SUCCEED) {
> 		if (cur_progress)
> 			*cur_progress += 1; // here
> 		goto out;
> 	}
> 	...
> 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> 	if (!pte) {
> 		if (cur_progress)
> 			*cur_progress += 1; // here
> 		result = SCAN_NO_PTE_TABLE;
> 		goto out;
> 	}
>
> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> 	     _pte++, addr += PAGE_SIZE) {
> 		if (cur_progress)
> 			*cur_progress += 1; // here
> 		...
> 	}
> }
>
> case 2:
>
> static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> 		struct vm_area_struct *vma, unsigned long start_addr,
> 		bool *mmap_locked, unsigned int *cur_progress,
> 		struct collapse_control *cc)
> {
> 	...
> 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> 	if (result != SCAN_SUCCEED) {
> 		if (cur_progress)
> 			*cur_progress += 1; // here

Let us be more explicit and set this equal to 1, instead of adding 1.

> 		goto out;
> 	}
> 	...
> 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> 	if (!pte) {
> 		if (cur_progress)
> 			*cur_progress += 1; // here

Same comment as above.

> 		result = SCAN_NO_PTE_TABLE;
> 		goto out;
> 	}
>
> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> 	     _pte++, addr += PAGE_SIZE) {
> 		...
> 	}
> 	...
> out_unmap:
> 	if (cur_progress) {
> 		if (_pte >= pte + HPAGE_PMD_NR)
> 			*cur_progress += HPAGE_PMD_NR;   // here
> 		else
> 			*cur_progress += _pte - pte + 1; // here
> 	}
> }

I will vote case 2. In case 1 I don't like the fact that the if (cur_progress)
branch will be checked each iteration - and I don't think the compiler can
optimize this since the body of the loop is complex, so this check cannot
be hoisted out of the loop.


>
> case 3:
> 	current patch, and add more comments to clearer.
>
>>> +
>>>  	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>>>  	if (result != SCAN_SUCCEED)
>>>  		goto out;
>>> @@ -1396,6 +1403,12 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>  		result = SCAN_SUCCEED;
>>>  	}
>>>  out_unmap:
>>> +	if (cur_progress) {
>>> +		if (_pte >= pte + HPAGE_PMD_NR)
>>> +			*cur_progress += HPAGE_PMD_NR - 1;
>>> +		else
>>> +			*cur_progress += _pte - pte;
>>> +	}
>>>  	pte_unmap_unlock(pte, ptl);
>>>  	if (result == SCAN_SUCCEED) {
>>>  		result = collapse_huge_page(mm, start_addr, referenced,
>>> @@ -2286,8 +2299,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>>  	return result;
>>>  }
>>>
>>> -static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>>> -		struct file *file, pgoff_t start, struct collapse_control *cc)
>>> +static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
>>> +		unsigned long addr, struct file *file, pgoff_t start,
>>> +		unsigned int *cur_progress, struct collapse_control *cc)
>>>  {
>>>  	struct folio *folio = NULL;
>>>  	struct address_space *mapping = file->f_mapping;
>>> @@ -2376,6 +2390,18 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>>>  			cond_resched_rcu();
>>>  		}
>>>  	}
>>> +	if (cur_progress) {
>>> +		unsigned long idx = xas_get_index(&xas) - start;
>>> +
>>> +		if (folio == NULL)
>>> +			*cur_progress += HPAGE_PMD_NR;
>> I think this whole block needs some comments. Can you explain, why you
>> do a particular increment in each case?
>>
>>> +		else if (xa_is_value(folio))
>>> +			*cur_progress += idx + (1 << xas_get_order(&xas));
>>> +		else if (folio_order(folio) == HPAGE_PMD_ORDER)
>>> +			*cur_progress += idx + 1;
>>> +		else
>>> +			*cur_progress += idx + folio_nr_pages(folio);
>>> +	}
> The "idx" represent PTEs number already scanned when exiting
> xas_for_each().
>
> However, the last valid folio size was not counted in "idx" (except
> folio == NULL, "idx" equal to HPAGE_PMD_NR), which can be further
> divided into three cases:

But, the number of PTEs you account in these three cases, are *not*
scanned, right? So we can simply drop these 3 cases.

>
> 1. shmem swap entries (xa_is_value), add folio size.
> 2. the folio is HPAGE_PMD_ORDER, the memory has been collapsed
>    to PMD, so add 1 only.
> 3. Normal folio, add folio size.
>
> Is the version below more readable?
>
> 	if (cur_progress) {
> 		*cur_progress += xas.xa_index - start;
>
> 		if (folio) {
> 			if (xa_is_value(folio))
> 				*cur_progress += 1 << xas_get_order(&xas);
> 			else if (folio_order(folio) == HPAGE_PMD_ORDER)
> 				*cur_progress += 1;
> 			else
> 				*cur_progress += folio_nr_pages(folio);
> 		}
> 	}

Yep, this is unneeded complexity. This looks really ugly and the benefits of
this are not clear. You can simply do

if (cur_progress)
	*cur_progress = xas.xa_index - start;

>
>>>  	rcu_read_unlock();
>>>
>>>  	if (result == SCAN_SUCCEED) {
>>> @@ -2456,6 +2482,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>>>
>>>  		while (khugepaged_scan.address < hend) {
>>>  			bool mmap_locked = true;
>>> +			unsigned int cur_progress = 0;
>>>
>>>  			cond_resched();
>>>  			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
>>> @@ -2472,7 +2499,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>>>  				mmap_read_unlock(mm);
>>>  				mmap_locked = false;
>>>  				*result = hpage_collapse_scan_file(mm,
>>> -					khugepaged_scan.address, file, pgoff, cc);
>>> +					khugepaged_scan.address, file, pgoff,
>>> +					&cur_progress, cc);
>>>  				fput(file);
>>>  				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
>>>  					mmap_read_lock(mm);
>>> @@ -2486,7 +2514,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>>>  				}
>>>  			} else {
>>>  				*result = hpage_collapse_scan_pmd(mm, vma,
>>> -					khugepaged_scan.address, &mmap_locked, cc);
>>> +					khugepaged_scan.address, &mmap_locked,
>>> +					&cur_progress, cc);
>>>  			}
>>>
>>>  			if (*result == SCAN_SUCCEED)
>>> @@ -2494,7 +2523,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>>>
>>>  			/* move to next address */
>>>  			khugepaged_scan.address += HPAGE_PMD_SIZE;
>>> -			progress += HPAGE_PMD_NR;
>>> +			progress += cur_progress;
>>>  			if (!mmap_locked)
>>>  				/*
>>>  				 * We released mmap_lock so break loop.  Note
>>> @@ -2817,7 +2846,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>  			mmap_locked = false;
>>>  			*lock_dropped = true;
>>>  			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
>>> -							  cc);
>>> +							  NULL, cc);
>>>
>>>  			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
>>>  			    mapping_can_writeback(file->f_mapping)) {
>>> @@ -2832,7 +2861,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>  			fput(file);
>>>  		} else {
>>>  			result = hpage_collapse_scan_pmd(mm, vma, addr,
>>> -							 &mmap_locked, cc);
>>> +							 &mmap_locked, NULL, cc);
>>>  		}
>>>  		if (!mmap_locked)
>>>  			*lock_dropped = true;
> --
> Thanks,
> Vernon

