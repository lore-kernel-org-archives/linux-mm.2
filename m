Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4878606A33A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JWSD75Qk
Received: by kanga.kvack.org (Postfix)
	id 1892D6B05B4; Fri,  6 Nov 2026 04:30:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 161F96B05B6; Fri,  6 Nov 2026 04:30:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 050516B05B7; Fri,  6 Nov 2026 04:29:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBAA26B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:29:59 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 586C280CA2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:29:59 +0000 (UTC)
X-FDA: 85404172518.07.8A7B960
Received: from mta0.migadu.com (out-96.mta0.migadu.com [91.218.175.96])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3AF1140005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:29:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JWSD75Qk;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.96 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793957397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dgVnwcVyRL5r7FbTkKdlbPx0jKtwnlLXDYPwAlo0Rqs=;
	b=ZJbDZZIBogy4Bb62IXKvnm8PH++MQKUHRwOUYcn1DSu2LwQrVi+9Nzw5wsZkQSaPjPTd7L
	rERs8W8NLI32z5cCNAnX4dBDqG5k/nNsQ868RUXJmovhFGKSvl++CK0ICExegtHhYuyfef
	ti0sBxpULtdWzdC8R1gmvycdKDXgQ2U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793957397;
	b=kq3atzhL0GnrFz+6KXAMCKLpHe8whJRBRWUmztOUlMsmEV9h7/GIbfCbXvylpT55Sm+2lp
	TcB6R7ouaNobCug4il97pw7YkZ6WfgQe3qTmfKO/f1PCOHeb18J5ZCcdr42sGD6BzEMC6q
	ukZBXM+IirhIQfPF36cVTyvIJYpdm2o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JWSD75Qk;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.96 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fX4k36rbLJvsBWNAGcXTUmpAPCnDY00gcSOCzvETUGI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793957395; v=1; x=1794562195;
 b=JWSD75QksglvCndpzVxSygCHV94Yc8bj2n5IczJXMqmQaylMbAr5fRxmB/+BISjD4beh7+j7
 wjGCJ9+qRi8JOLoiYDUgDTGFgqZJvi0dDf3CUugKgjW6s+suldIYDiIYVQ6XxpOquLYx7+8/FJe
 VROG9JlTsaBeJXampLQoUryA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0dede42dda7479ec;
	Fri, 06 Nov 2026 09:29:55 +0000
X-Mizu-Trace-ID: 0dede42dda7479ec
X-Migadu-Flow: FLOW_OUT
Message-ID: <09095de1-3916-43a9-a217-ae8564ba4d4c@linux.dev>
Date: Fri, 6 Nov 2026 17:29:36 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
Content-Language: en-US
To: baolin.wang@linux.alibaba.com
Cc: baohua@kernel.org, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, qi.zheng@linux.dev, pfalcato@suse.de,
 ayushr@modal.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <453e2c18-4e79-4db2-b565-1af881925f08@linux.alibaba.com>
 <20261106091510.67980-1-lance.yang@linux.dev>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20261106091510.67980-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hunf6eb6kmseuop483emey44u5ghueaq
X-Rspamd-Queue-Id: 3AF1140005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793957396-216778
X-HE-Meta: U2FsdGVkX19rzIx+cM3aPIMp7vXcamH3UZup/TonY+AIKhYSswwLTCnrrXPFfnvBDS/Ul/9ETms8DN8J6uZsWF3DebcV1iEngF7ALj5hr/d8//rbchTuUt4y9BERVwQm0y8F0dXHoY/mqRPoHjo5nOQeLcecPgvxvxHixPLWXvtVi3O+SVnnOw26B7ZHoQEiVYzWC9qTMEy3TY2jeWZtlZeGJ51Zb5FIe3VMTSXPoVSdXeeN6qCSbp0AoBDwqRAiYYbtWNQtMdufGnbW59wHPZYvMZWzl6BqRVsmxNUxvKjHHZy2U1CYrPXFWLxw6o5rXeZeVWfQHG0tjyp+uNihOU5jctZepbXvjdKwmtSSDE6VSC+CnQ+brokZ4eXGCclvfHCNw/NjQ5Gxqx5ypzHWt15y5Tkuz1Xv81IgJvGszSfrHoB69mptcOWffmQTSpVGWzwGbVhSv+W5lI+o2pY2W760z3vLTJpSkPCOkV5ugZskM8p8LWy51VJbjiZwahggZbQtjo+0rRB+uRAvcfik2U07JpZflY8jRXc938vMgPwDWryUT6q1EwMbbkEI4VY9229XYdnoO8/c8QtfKTAldH7QTKljbYzrhMvGz7UH05OMAo/MEoSSkJqMXq8IRZfnjUY11ZJ3vUbEG75gF/mOaR4z54tRpn/pghmjnSunUqEqmSJQ2lEPgaboddetyYtQZgUvWxwUuQKzzI1QB2rce5GBkbUn/7P8LifVNv202S1G8zcGr/pFw6rbPC7cqn6NHE66Aiqm/rW9bddMnjQMVCFjSJt8rx2uMDGWY1I+mV341gZs8e4gR9EcF0It/fKKdduzEezkTucvl2P13kkC6Ui1F9EquWoPL+bjIyvwZcr1//dbrv/C9CfWhcxbVJWrvnPqfo+UaTDzwKNeNqTTPOnkubggN3/hgi9/4EmY2/o3LgfF+Xe92Ajro7jUhG38lYcvpw6h4RSAvbKy5hx
 vHd8each
 HS+dzYEQg+cIdWPwerjWjqcOd4qnTL9EEn/mKPZAkQIzDR4IvvZXdtPnfaJqjVPTqpt/rGOZoUYDAfpZLFHcSFtcHiHW3KWF8YRhfuecazml8j6zdUGngRgOwXjR2pB8pblUPAVd8V50wiGEgapRrio/Vo8xomaziVtZpW+WondahBmbTcSwKtM3MsmEWSXDO/VPv2T/moApxJyCSctWGRSncGQjiMI3Y4Wdj1D93ua9wsYkVlyOUJNOLz58dLXh6O6NFhBAiRsGtNBPu9UhXHCaTjAw+Zpw8qy3PyYrwu+2MLncWSt+2OuPhzYyyZZWPwXHcAUT9/PNatOe6zBi9ztc22Fd0xKReMhZ0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/6 17:15, Lance Yang wrote:
> 
> On Fri, Nov 06, 2026 at 04:54:44PM +0800, Baolin Wang wrote:
>>
>>
>> On 11/6/26 2:24 PM, Barry Song wrote:
>>> On Thu, Nov 5, 2026 at 5:00 PM Baolin Wang
>>> <baolin.wang@linux.alibaba.com> wrote:
>>>>
>>>> CC Barry, who added the TTU_SYNC in shrink_folio_list().
>>>>
>>>> On 11/5/26 1:48 PM, Lance Yang wrote:
>>>>>
>>>>>
>>>>> On 2026/11/5 12:54, Lance Yang wrote:
>>>>>>
>>>>>> On Thu, Nov 05, 2026 at 10:56:28AM +0800, Baolin Wang wrote:
>>>>>>> Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing
>>>>>>> mapped
>>>>>>> folios"), the '!pmd_present()' check in page_vma_mapped_walk() can
>>>>>>> also race
>>>>>>> with concurrent page table reclamation via zap_empty_pte_table().
>>>>>>
>>>>>> Good catch!
>>>>>>
>>>>>>> page_vma_mapped_walk() is used by many functions including
>>>>>>> try_to_unmap(),
>>>>>>> try_to_migrate(), folio_mkclean(), pfn_mkclean_range(),
>>>>>>> remove_migration_ptes(),
>>>>>>> page_mapped_in_vma(), and mapping_wrprotect_range(). Except for
>>>>>>> try_to_unmap()
>>>>>>> and try_to_migrate(), the other callers do not perform post-walk
>>>>>>> accounting
>>>>>>> checks, so the race has no observable impact on them.
>>>>>>>
>>>>>>> For migration, the race can cause unnecessary retries. For reclaim via
>>>>>>> try_to_unmap(), the race can cause failure to reclaim a folio that is in
>>>>>>> fact already unmapped (as shown below), which may lead to unexpected OOM
>>>>>>> or increased refaults.
>>>>>>>
>>>>>>> CPU 0 (reclaim)                      CPU 1 (MADV_DONTNEED)
>>>>>>> --------------------------------    --------------------------------
>>>>>>> folio_lock(F)
>>>>>>> try_to_unmap(F, TTU_SYNC)
>>>>>>>                                       zap_pte_range(full PMD range)
>>>>>>>                                         spin_lock(ptl)
>>>>>>>                                         clear PTEs
>>>>>>>                                         zap_empty_pte_table()
>>>>>>>                                           spin_trylock(pml)
>>>>>>>                                           pmd_clear()
>>>>>>>                                           spin_unlock(pml)
>>>>>>>
>>>>>>>     page_vma_mapped_walk()
>>>>>>>       observe !pmd_present(pmde)
>>>>>>>       nr_pages < HPAGE_PMD_NR
>>>>>>>       skip synchronization
>>>>>>>       return false
>>>>>>>
>>>>>>> try_to_unmap() returns
>>>>>>> folio_mapped(F) == true
>>>>>>> nr_unmap_fail += folio_nr_pages(F)
>>>>>>>                                       tlb_flush_mmu_tlbonly()
>>>>>>>                                       tlb_flush_rmaps()
>>>>>>>                                         remove F's rmaps
>>>>>>>                                       spin_unlock(ptl)
>>>>>>>
>>>>>>> Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped
>>>>>>> folios")
>>>>>>> has already moved the PMD clear operation (via zap_empty_pte_table()) to
>>>>>>> after tlb_flush_rmaps(). Similarly, page_vma_mapped_walk() also needs to
>>>>>>> use sync_with_folio_pmd_zap() to synchronize and avoid memory ordering
>>>>>>> issues on weakly ordered CPUs.
>>>>>>>
>>>>>>> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in
>>>>>>> madvise(MADV_DONTNEED)")
>>>>>>> Cc: stable@vger.kernel.org
>>>>>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>>>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>> ---
>>>>>>> mm/page_vma_mapped.c | 5 +----
>>>>>>> 1 file changed, 1 insertion(+), 4 deletions(-)
>>>>>>>
>>>>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>>>>> index e6b6170c2f4f..8797467b6f0c 100644
>>>>>>> --- a/mm/page_vma_mapped.c
>>>>>>> +++ b/mm/page_vma_mapped.c
>>>>>>> @@ -293,10 +293,7 @@ bool page_vma_mapped_walk(struct
>>>>>>> page_vma_mapped_walk *pvmw)
>>>>>>>               spin_unlock(pvmw->ptl);
>>>>>>>               pvmw->ptl = NULL;
>>>>>>>           } else if (!pmd_present(pmde)) {
>>>>>>> -            if ((pvmw->flags & PVMW_SYNC) &&
>>>>>>> -                thp_vma_suitable_order(vma, pvmw->address,
>>>>>>> -                           PMD_ORDER) &&
>>>>>>> -                (pvmw->nr_pages >= HPAGE_PMD_NR))
>>>>>>> +            if (pvmw->flags & PVMW_SYNC)
>>>>>>
>>>>>> Right. Whether the folio can be PMD-mapped doesn't tell us whether its
>>>>>> PTE table can be reclaimed, so those extra checks can skip
>>>>>> synchronization
>>>>>> that the caller explicitly asked for ;)
>>>>>
>>>>> Ouch ... one thing I missed ... what about order-0 reclaim?
>>>>>
>>>>> shrink_folio_list() only sets TTU_SYNC for large folio, so can't we still
>>>>> hit the same race there?
>>>>
>>>> Thanks Lance. But this matches the purpose of the TTU_SYNC flag, which
>>>> is used to avoid racy checks with PVMW_SYNC. If no TTU_SYNC flag is set,
>>>> it means the caller can tolerate some racy checks.
>>>>
>>>> For this case, I think we should set TTU_SYNC unconditionally in
>>>> shrink_folio_list(). Barry, what do you think?
>>>
>>> Baolin, thanks for reaching out to me. I added that flag
>>> mainly for large folios.
>>>
>>> I observed cases where PTEs for large folios are partially
>>> cleared during certain transition states, for example, when
>>> PTEs are cleared before being modified:
>>>
>>> pte = ptep_get_and_clear();
>>> pte modification;
>>> set_pte_at();
>>>
>>> In such cases, page_vma_mapped_walk() skips the empty
>>> entries and starts from the next valid one.
>>>
>>> This may result in partially unmapping PTEs for large folios
>>> and trigger unexpected folio splits. At the time, I was
>>> particularly concerned about unnecessary folio splitting,
>>> so my focus was mainly on large folios.
>>
>> Thanks for the information.
>>
>>> However, I also noticed that a similar race can occur with
>>> small folios. In that case, the folio may simply remain
>>> unreclaimed by the reclamation path.
>>>
>>> However, my main concern at the time was avoiding
>>> unnecessary folio splits.
>>>
>>> Your new race also seems to amplify the same situation.
>>> However, I don't think this problem necessarily depends on
>>> the commit you mentioned. It has been around for a long time.
>>
>> Agree.
>>
>>> If the concern is reclaim failure, I agree that there is no
>>> fundamental difference between large folios and small folios.
>>
>> OK. And I did a quick measurement to reclaim anon and file folios via
>> the memory.reclaim interface.
>>
>>  From test results, reclaiming 1G small anonymous folios (using zram as
>> swap) shows no significant performance change. However, reclaiming 1G
>> mapped clean small file folios does show an observable regression if the
>> TTU_SYNC flag is set.
>>
>> Without TTU_SYNC for small folios:
>> time echo 1G > /sys/fs/cgroup/test/memory.reclaim
>> real	0m0.178s
>> user	0m0.000s
>> sys	0m0.178s
>>
>> With TTU_SYNC for small folios:
>> real	0m0.315s
>> user	0m0.000s
>> sys	0m0.314s
> 
> Nice numbers, cool!
> 
>> So for the current patch, I'd prefer to keep things as is: only sync
>> when TTU_SYNC is set. Without setting the TTU_SYNC flag, keep the
>> original logic, meaning the caller can tolerate some racy checks.
>>
>> Any other thoughts?
> 
> One thing I want to pin down first, for the order-0 folios, was that run
> with TTU_SYNC going through the pmd lock, or did it already go the
> smp_rmb() way?
> 
> My guess is the first one, right?
> 
> If so, please keep the fix as is and only sync when the caller asks for
> it (at least, order-0 folios should not go the pmd lock way) :D

In addition:

For order-0 folios, we'd miss reclaim and reactivate a cold folio.

That doesn't sound too bad, especially for such a rare race.

so keeping the current behavior seems reasonable given the sync
overhead ;)

> Cheers, Lance


