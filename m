Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5810A606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 08:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=f64KMnHy
Received: by kanga.kvack.org (Postfix)
	id 6C4FE6B05B0; Fri,  6 Nov 2026 03:54:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64EDB6B05B5; Fri,  6 Nov 2026 03:54:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 517886B05B6; Fri,  6 Nov 2026 03:54:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5DF6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:54:57 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 15073C0CE2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:54:56 +0000 (UTC)
X-FDA: 85404084192.09.4A358D8
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2F3D4A0003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:54:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=f64KMnHy;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793955292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UG+Vd2lCqlDemW3CNow5760DJLHqRau7ZSJd7q+P4Rc=;
	b=nwO4rgkwViWudzQMf8b3LbJNexFF1LrnImetIdAPrx+bREo/92aJGL+tD/h3Kqguvu/e/+
	KHi6/WONflZRT7P5pSMKhwWLBURk3oQFCizYMr91HagTmNy65Wr931p1/Dyo9iMGEhh2KN
	TXyM9kKqzEnHOLtSMEXZLu4wNBT+oBM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793955292;
	b=6xXKsUq0o6kG0ZP8yDNvTeePtx27bOLDWZnG/whJEC67KITk4+pPUKXrRHlQss1VC+GWcQ
	Bqofk17MJ0MtKhpjCeU3+Ba76EKsboIXcthqnGfro/sG1t5G6HdKmB5a5pVnt1doagdcPb
	4D4BgaBGmlj69dq1S1vFu//Cp3yuhmY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=f64KMnHy;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793955287; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UG+Vd2lCqlDemW3CNow5760DJLHqRau7ZSJd7q+P4Rc=;
	b=f64KMnHyxWcwrS+DLX0Xyd1+/7QoViarrVYgWkAEE7XjaZ9nq5Cxd0h5tpAFbPZdrZ1IJp/L4GOSXCH6BrLcqR2olh4XhLVFId3weg6db0M9+A8ws8ihqpI3jLaGt5+UjfeM6CdHXA0YFrIIR1t+U3EyXLMo1UQOZgEnqv9fgMg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XEBGmJx_1793955285;
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEBGmJx_1793955285 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 16:54:46 +0800
Message-ID: <453e2c18-4e79-4db2-b565-1af881925f08@linux.alibaba.com>
Date: Fri, 6 Nov 2026 16:54:44 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
To: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, qi.zheng@linux.dev,
 pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
 <20261105045406.39871-1-lance.yang@linux.dev>
 <0ddaf336-7cb7-4e83-af2c-f60d23f7aafd@linux.dev>
 <f7bd740e-1328-473e-96f5-89658a08d514@linux.alibaba.com>
 <CAGsJ_4zHtv7hBCaW=wdfiM7yA4OJS7pcFomSo22bEzWHizYAXQ@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4zHtv7hBCaW=wdfiM7yA4OJS7pcFomSo22bEzWHizYAXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 3hmhgbg3e5aosxn3qgyuwreeohepag3o
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2F3D4A0003
X-Rspam-User: 
X-HE-Tag: 1793955290-264470
X-HE-Meta: U2FsdGVkX1/ABYau4bEM8QaXzX3D4hEgoxTlQRn50SGuY4ycwWhHDJj74A+Hacbh4ACY0kNEk4XuZOXtawW90kxASFarvYntROC1tdXyg2XXOU/2DDKGER456Q/O/80j8DLGcEJU+/sEAU7JOSI6xKqQUiS3UirtcrQ2f4bLGQO1qSM0SvVRJscEAkSXmABo9Jyy+SXvO4sN3yLxBG+mGoLI5dxNQb/xwOD49FWhakvS4lDLlFgvtVoHbTSv+9xM5I7qWF5rooMtQv68OD2DJiIWS+wRtUeCSQL4GgDsUfyf0jfVivCL2BiwdEamrp2dJcGNEnBAzv4qdW+bm6yzCm73p9OfwXRY1bKYITi5+a2EvRbesi3dY06kN3BDdFhkxxU1Tty9v9KkIOyDSEjgNyAWRWoUYCjjitUek1deB0KVPyshHdBZrh/7P6iR7Kl0QnBItTOm2liDt8hgEPkSKvhHqQ99P6ggokXtFaW5bDB/k6qLbf8FAhHSvxR1r0AweqT8qT0UoLXFsrKONy7Blv/ZibL2QOuEu2bLqvIVRM3XpfoscvuayHx0t/9kwO/3bDkgJk0qnRISVlpvKlQxr2MVSqlkmRMtl3GTtlInMElPRKts1b+i1/xWaUiwIWdpobts/O5UYeHQDhRRyi3JIWoc1eeJbn4SAs4XHDf2cClMl9d7F8rLyK5HdqKcbacs9MgZoeP+SRdcLcZqW6den2p515/nt+n32Lx3MEgGB8CnpajLH+z0LWG1uuD5dY4v7/f9psScb3NOhSOepzGLP0SmAfr37flqjCmNXDHNuYD8OxwKwQb1FGL9gCgLJh3MYnyHutlhbwWYqUrxv3807TbWPOZDTXsG6vH5CpXgt/pYWyowk9CIDzfUeRSepU8fATCsLXRVWDZuKaYmyMPCpW1DhKnh0SWigkaFpx/NGsxnbonzokNhF023vGwPvM7wWKMq2yk2NWUcfOgqUz8
 W0vBEdKv
 c+xAm2k5ZaVO9qxP46KPem8bCsL5BR+S6jQmz07HrBrlCnpXVND88lOdToW7g9oIBOjzPIOXKWBAPcvseWAOLAAgrFmjjWlg/U/9QaOIoDUDEqj04/nZwsSGeks1H/wlbe4PmC7nsgX1FlB357qDDn6v8WRVitGHCjrMb7U5J6Ba6TNhmoDsBykYwZkTfUADVrodlrYMi8kXr0BfbuRG1w8ghcLMgLm2Sh7lZBUJpVqZlzCONT/x17b3ocoE5xa0iJOYqe9ps0Gl+LVQbM/mKLB+upMz4pupXvAMk0pn0CuIPKokpuamsmJ1Omlj1qwRUUsaAQMKjYgf1odmTcBSrG1u5a8ugqjSewGNJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/6/26 2:24 PM, Barry Song wrote:
> On Thu, Nov 5, 2026 at 5:00 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>> CC Barry, who added the TTU_SYNC in shrink_folio_list().
>>
>> On 11/5/26 1:48 PM, Lance Yang wrote:
>>>
>>>
>>> On 2026/11/5 12:54, Lance Yang wrote:
>>>>
>>>> On Thu, Nov 05, 2026 at 10:56:28AM +0800, Baolin Wang wrote:
>>>>> Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing
>>>>> mapped
>>>>> folios"), the '!pmd_present()' check in page_vma_mapped_walk() can
>>>>> also race
>>>>> with concurrent page table reclamation via zap_empty_pte_table().
>>>>
>>>> Good catch!
>>>>
>>>>> page_vma_mapped_walk() is used by many functions including
>>>>> try_to_unmap(),
>>>>> try_to_migrate(), folio_mkclean(), pfn_mkclean_range(),
>>>>> remove_migration_ptes(),
>>>>> page_mapped_in_vma(), and mapping_wrprotect_range(). Except for
>>>>> try_to_unmap()
>>>>> and try_to_migrate(), the other callers do not perform post-walk
>>>>> accounting
>>>>> checks, so the race has no observable impact on them.
>>>>>
>>>>> For migration, the race can cause unnecessary retries. For reclaim via
>>>>> try_to_unmap(), the race can cause failure to reclaim a folio that is in
>>>>> fact already unmapped (as shown below), which may lead to unexpected OOM
>>>>> or increased refaults.
>>>>>
>>>>> CPU 0 (reclaim)                      CPU 1 (MADV_DONTNEED)
>>>>> --------------------------------    --------------------------------
>>>>> folio_lock(F)
>>>>> try_to_unmap(F, TTU_SYNC)
>>>>>                                      zap_pte_range(full PMD range)
>>>>>                                        spin_lock(ptl)
>>>>>                                        clear PTEs
>>>>>                                        zap_empty_pte_table()
>>>>>                                          spin_trylock(pml)
>>>>>                                          pmd_clear()
>>>>>                                          spin_unlock(pml)
>>>>>
>>>>>    page_vma_mapped_walk()
>>>>>      observe !pmd_present(pmde)
>>>>>      nr_pages < HPAGE_PMD_NR
>>>>>      skip synchronization
>>>>>      return false
>>>>>
>>>>> try_to_unmap() returns
>>>>> folio_mapped(F) == true
>>>>> nr_unmap_fail += folio_nr_pages(F)
>>>>>                                      tlb_flush_mmu_tlbonly()
>>>>>                                      tlb_flush_rmaps()
>>>>>                                        remove F's rmaps
>>>>>                                      spin_unlock(ptl)
>>>>>
>>>>> Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped
>>>>> folios")
>>>>> has already moved the PMD clear operation (via zap_empty_pte_table()) to
>>>>> after tlb_flush_rmaps(). Similarly, page_vma_mapped_walk() also needs to
>>>>> use sync_with_folio_pmd_zap() to synchronize and avoid memory ordering
>>>>> issues on weakly ordered CPUs.
>>>>>
>>>>> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in
>>>>> madvise(MADV_DONTNEED)")
>>>>> Cc: stable@vger.kernel.org
>>>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>> ---
>>>>> mm/page_vma_mapped.c | 5 +----
>>>>> 1 file changed, 1 insertion(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>>> index e6b6170c2f4f..8797467b6f0c 100644
>>>>> --- a/mm/page_vma_mapped.c
>>>>> +++ b/mm/page_vma_mapped.c
>>>>> @@ -293,10 +293,7 @@ bool page_vma_mapped_walk(struct
>>>>> page_vma_mapped_walk *pvmw)
>>>>>              spin_unlock(pvmw->ptl);
>>>>>              pvmw->ptl = NULL;
>>>>>          } else if (!pmd_present(pmde)) {
>>>>> -            if ((pvmw->flags & PVMW_SYNC) &&
>>>>> -                thp_vma_suitable_order(vma, pvmw->address,
>>>>> -                           PMD_ORDER) &&
>>>>> -                (pvmw->nr_pages >= HPAGE_PMD_NR))
>>>>> +            if (pvmw->flags & PVMW_SYNC)
>>>>
>>>> Right. Whether the folio can be PMD-mapped doesn't tell us whether its
>>>> PTE table can be reclaimed, so those extra checks can skip
>>>> synchronization
>>>> that the caller explicitly asked for ;)
>>>
>>> Ouch ... one thing I missed ... what about order-0 reclaim?
>>>
>>> shrink_folio_list() only sets TTU_SYNC for large folio, so can't we still
>>> hit the same race there?
>>
>> Thanks Lance. But this matches the purpose of the TTU_SYNC flag, which
>> is used to avoid racy checks with PVMW_SYNC. If no TTU_SYNC flag is set,
>> it means the caller can tolerate some racy checks.
>>
>> For this case, I think we should set TTU_SYNC unconditionally in
>> shrink_folio_list(). Barry, what do you think?
> 
> Baolin, thanks for reaching out to me. I added that flag
> mainly for large folios.
> 
> I observed cases where PTEs for large folios are partially
> cleared during certain transition states, for example, when
> PTEs are cleared before being modified:
> 
> pte = ptep_get_and_clear();
> pte modification;
> set_pte_at();
> 
> In such cases, page_vma_mapped_walk() skips the empty
> entries and starts from the next valid one.
> 
> This may result in partially unmapping PTEs for large folios
> and trigger unexpected folio splits. At the time, I was
> particularly concerned about unnecessary folio splitting,
> so my focus was mainly on large folios.

Thanks for the information.

> However, I also noticed that a similar race can occur with
> small folios. In that case, the folio may simply remain
> unreclaimed by the reclamation path.
> 
> However, my main concern at the time was avoiding
> unnecessary folio splits.
> 
> Your new race also seems to amplify the same situation.
> However, I don't think this problem necessarily depends on
> the commit you mentioned. It has been around for a long time.

Agree.

> If the concern is reclaim failure, I agree that there is no
> fundamental difference between large folios and small folios.

OK. And I did a quick measurement to reclaim anon and file folios via 
the memory.reclaim interface.

 From test results, reclaiming 1G small anonymous folios (using zram as 
swap) shows no significant performance change. However, reclaiming 1G 
mapped clean small file folios does show an observable regression if the 
TTU_SYNC flag is set.

Without TTU_SYNC for small folios:
time echo 1G > /sys/fs/cgroup/test/memory.reclaim
real	0m0.178s
user	0m0.000s
sys	0m0.178s

With TTU_SYNC for small folios:
real	0m0.315s
user	0m0.000s
sys	0m0.314s

So for the current patch, I'd prefer to keep things as is: only sync 
when TTU_SYNC is set. Without setting the TTU_SYNC flag, keep the 
original logic, meaning the caller can tolerate some racy checks.

Any other thoughts?

