Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 823A2C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 03:54:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B6396B0005; Fri, 26 Jun 2026 23:54:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08D036B0098; Fri, 26 Jun 2026 23:54:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBDEF6B0099; Fri, 26 Jun 2026 23:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B9A466B0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 23:54:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28D8F1203FF
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 03:54:23 +0000 (UTC)
X-FDA: 84924325206.12.A1E2394
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf24.hostedemail.com (Postfix) with ESMTP id D84E0180002
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 03:54:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KWgtvn2K;
	spf=pass (imf24.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782532461;
	b=M0mQe9ariCNnrYY+xGPdZ3nrb33/ksXnrw5j4nPskLbpk2msCqAPwjQFlhFkoPiPbpB59I
	AWAAXanxsfcwRx1+6gokUc1v4DGrzOlffHIIXsCK6A+CX1c0T6hRYeUVfWZKxJoAUMroAw
	+tncS02Fj7329A1oCL0kN8c5cFSMJjg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782532461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMhnwwyr0X6eIrWWVrP1kSsfT0hNEAccTRRDjQENV44=;
	b=Rm1yg3NBEmhy0eIlTzIh8AM98QKTm6I09z3C/Cw85zezFUrKJTu+XgwIJkZGrZB3tcvmw1
	4mVisTEWZKn9Q5b4GjyFC5oGixZLVxK81ylzz4bVrsXYP9TGq6jkiqxfmCdLLa+i2HX8XW
	J9m5J2cO7B1njUvBmDG8X1YHIeGumac=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KWgtvn2K;
	spf=pass (imf24.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=dMhnwwyr0X6eIrWWVrP1kSsfT0hNEAccTRRDjQENV44=;
	b=KWgtvn2K4B7BlitRHRQ4x/eeeMg3htlDB6rTLjt4qc/CTdVG8G/DiL+ehp3X7ZPg8q3RkSxaP
	QGVZMK0a7LXjTSQKPsmPY3WPxNVZw+Dqd0x639x3nvkJ7vqG2zmM+qbWaEtTHgdFfbHyR/JDqfS
	bbdX33wv7gMf4pyzdK3Z/B8=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gnJNd1mxCzpSvr;
	Sat, 27 Jun 2026 11:45:53 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 97E7E40577;
	Sat, 27 Jun 2026 11:54:13 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 27 Jun 2026 11:54:13 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 27 Jun 2026 11:54:10 +0800
Subject: Re: [PATCH 4/5] mm/page_vma_mapped: use huge_ptep_get() for hugetlb
To: Lance Yang <lance.yang@linux.dev>, Dev Jain <dev.jain@arm.com>
CC: <muchun.song@linux.dev>, <osalvador@suse.de>, <akpm@linux-foundation.org>,
	<ljs@kernel.org>, <david@kernel.org>, <liam@infradead.org>,
	<riel@surriel.com>, <vbabka@kernel.org>, <harry@kernel.org>,
	<jannh@google.com>, <kas@kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <rcampbell@nvidia.com>, <apopple@nvidia.com>,
	<ziy@nvidia.com>, <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>,
	<rakie.kim@sk.com>, <byungchul@sk.com>, <gourry@gourry.net>,
	<ying.huang@linux.alibaba.com>, <mel@csn.ul.ie>, <nao.horiguchi@gmail.com>,
	<ak@linux.intel.com>, <j-nomura@ce.jp.nec.com>, <pfalcato@suse.de>,
	<dave.hansen@intel.com>, <tglx@kernel.org>, <jpoimboe@kernel.org>,
	<ryan.roberts@arm.com>, <anshuman.khandual@arm.com>, <stable@vger.kernel.org>
References: <e6d1b813-0893-458e-9d58-8d3a9bd979c4@arm.com>
 <20260626141031.14309-1-lance.yang@linux.dev>
 <61e9fcf7-02a5-4285-948b-62fba4dcd69c@arm.com>
 <edee8461-34c6-41e9-ae0c-076380d92ebb@linux.dev>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <cb5bd857-adb1-b59a-d257-412965886184@huawei.com>
Date: Sat, 27 Jun 2026 11:54:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <edee8461-34c6-41e9-ae0c-076380d92ebb@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D84E0180002
X-Stat-Signature: nwauonk3hq7d15f6gb4d77784wy5fqay
X-HE-Tag: 1782532459-927586
X-HE-Meta: U2FsdGVkX18mOUZp8I29lWqbbLJ/+zBD+woAWmWEh2o0ft8dZWSbNXvVmu+P0I1O+aeoT4iJY8zTQJueRdeopmNQ+cd6qEyiwQvMMCOEnjzD+2jauG/SAoV3wMlDq2BZTei+R4Esxtx3+b6jlMymWMN0v8Y0itcTzF/S1UM6bQxm4rOAiFxyWKrpbkZ9LE1yaCzlUXUC1nEpsLb/0ZOv6mdI+l6tjqMM30deFf/G88t7TfDtRYCs0hy4RwUDPsUqtuDGIyNlVKa5avMvUkBvhvohk+wgwd5GBmKvsPbo4BvS5vecIe52/cKpOKSanGux2A101pkYvWrj9AWG6ePWiSGe2XLtYlclLeIVKTa3YMSDlR8r/ag4sJvbEYW5+03n2Gc52h3htZs67uxc++ROS+DpzZgSBLqx3045N4qPPIW4rg0vIMH3AyuPnIfpWf1jjXFHWOAMsvH8Af9pNebqmog3kdGOzxHWP7GYzufbpxrKWGjzpAVCECC9xQZ/1BqNQgiqUO4SM/aQxbb95iGYTzCLgU1ib6ItvSDYhLHbEqWfEq5yrCYxahjWA47+AiHNGhRMnuNppk/Tc+IogZvfAPNFA+4JcDbW83LezA9UFkOB9LiK/go/V/Lk1m3T5qdce1qA3BxRAF9vP8/cyoh1EsPr3YS+IYo6Rs/ETt9QuqTF4hdIRlI8iQMeV0MTmzKEi4JYvY610nDK+HEcDoVkF4WkacWV9CHXSsZQrnwztW+KsZLeVuEZ/DpCgaaA1hj7QSKY9aGHdtkMJk2nV04s8t3r7ve9ZI+sw+CMeXsAUTiOxIu6ellhW8zsqCxH44uIEBUdCEnFBwVxKUL35ra9LOFWzr1z1kDwG75Dr2VnPLLoAnxOvjsgPyhUjbdyfZQRgSTD5G5j1qzr2ehbp27jrF7pf9PdLzxoIv+JkFVDazQ8BuONxE6MtLMohCow7sw1+pwG1LShlJ8rURWyVfB
 9bBabwfO
 KX9j/JGV6EekshzOj7bRG86Vck2FJX7s00xau/Pni56k7cyx66eSJsbXx05nU3gx08nUPKJ+mmw7zq0EDrqMAtFt6/QV9DqJuv0xLCI8N5sm+qh6QgLdP91CUeQ4aJezVWFQ5XLWLsEwd5XGyLsa7mcBAaZm/ZJczd7Zz8zQIvcw25giHArDrK7vL7UZJghXgZjdU7aoIsWP/ZePpAfarcBEsrD+g+1oNcX0WXXxJslj5ZJLXkiqFePIty6aEHIa8x6Cabl/tRHVmYmlHU4aM2T37RKv48pVlwKOVNKTMCn4tLpegdUiooTxSp0I8DyLE2pyh3PxWIONJLHf/wk4nmzkn1ZbAs+bYMcpwtaUESW11k+DBNE5EbHXmVKhuYvblTmePCwa5NMrOgb72mSTKXH3z3rVH55/9WwmiHXF5WO+rtuPNyocVcmq+FrGDPYxec5BOc0oGjJ2nyczUH1lG6iGK/ingRpgE51fLLTMU5hk+m6jUdjxQvIQcYoShczQrOJyT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/27 0:46, Lance Yang wrote:
> 
> 
> On 2026/6/26 23:26, Dev Jain wrote:
>>
>>
>> On 26/06/26 7:40 pm, Lance Yang wrote:
>>>
>>> On Fri, Jun 26, 2026 at 06:53:10PM +0530, Dev Jain wrote:
>>>>
>>>>
>>>> On 26/06/26 1:18 pm, Lance Yang wrote:
>>>>>
>>>>> On Thu, Jun 25, 2026 at 11:29:53AM +0000, Dev Jain wrote:
>>>>>> check_pte() is the final validation step in page_vma_mapped_walk().
>>>>>> It reads pvmw->pte with ptep_get() to decide whether the entry maps
>>>>>> the PFN range being walked. For hugetlb VMAs, that pointer refers
>>>>>> to a hugetlb entry.
>>>>>>
>>>>>> On arches which provide their own huge_ptep_get() to dereference a huge
>>>>>> pte pointer, accessing via ptep_get() would cause pte_pfn(),
>>>>>> pte_present() etc to misbehave.
>>>>>>
>>>>>> It is not clear whether this has a trivially visible effect to userspace.
>>>>>>
>>>>>> Use huge_ptep_get() to dereference a huge pte pointer.
>>>>>>
>>>>>> Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>>>>> ---
>>>>>> mm/page_vma_mapped.c | 8 +++++++-
>>>>>> 1 file changed, 7 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>>>> index 2ccbabfb2cc17..18e1d341f463c 100644
>>>>>> --- a/mm/page_vma_mapped.c
>>>>>> +++ b/mm/page_vma_mapped.c
>>>>>> @@ -107,7 +107,13 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,
>>>>>> static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>>>>>> {
>>>>>>     unsigned long pfn;
>>>>>> -    pte_t ptent = ptep_get(pvmw->pte);
>>>>>> +    pte_t ptent;
>>>>>> +
>>>>>> +    if (is_vm_hugetlb_page(pvmw->vma))
>>>>>> +        ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>>>>>> +                      pvmw->pte);
>>>>>
>>>>> I think check_pte() can pass a wrong address to huge_ptep_get() ...
>>>>
>>>> Won't this be handled by rmap_walk_anon/rmap_walk_file - they are the ones
>>>> performing the rmap traversal and passing address to try_to_unmap_one/folio_referenced_one
>>>> etc ...
>>>
>>> Right, that should cover the rmap callbacks. The bit I was worried about
>>> is page_mapped_in_vma() though.
>>>
>>>>>
>>>>> Not sure that is wrong in the first place. For memory failure,
>>>>> page_mapped_in_vma() can be called with a poisoned tail page of a hugetlb
>>>>> folio. In that case, pvmw->address need not be hugepage-aligned.
>>>>>
>>>>> @Miaohe
>>>
>>> For hugetlb memory failure we start with the poisoned PFN:
>>>
>>> static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
>>> {
>>>     ...
>>>     struct page *p = pfn_to_page(pfn);
>>>     struct folio *folio;
>>>     ...
>>>
>>>     folio = page_folio(p);
>>>
>>>     ...
>>>
>>>     if (!hwpoison_user_mappings(folio, p, pfn, flags)) {
>>>         ...
>>>     }
>>>
>>>     ...
>>> }
>>>
>>> and pass the same p down:
>>>
>>> static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
>>>         unsigned long pfn, int flags)
>>> {
>>>     ...
>>>
>>>     collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
>>>
>>>     ...
>>> }
>>>
>>> static void collect_procs(const struct folio *folio, const struct page *page,
>>>         struct list_head *tokill, int force_early)
>>> {
>>>     ...
>>>
>>>     if (unlikely(folio_test_ksm(folio)))
>>>         ...
>>>     else if (folio_test_anon(folio))
>>>         collect_procs_anon(folio, page, tokill, force_early);
>>>     else
>>>         ...
>>> }
>>>
>>> So collect_procs_anon() still gets the poisoned page, not &folio->page:
>>>
>>> static void collect_procs_anon(const struct folio *folio,
>>>         const struct page *page, struct list_head *to_kill,
>>>         int force_early)
>>> {
>>>     ...
>>>
>>>     pgoff = page_pgoff(folio, page);
>>>     rcu_read_lock();
>>>     for_each_process(tsk) {
>>>         ...
>>>        
>>>         anon_vma_interval_tree_foreach(vmac, &av->rb_root,
>>>                            pgoff, pgoff) {
>>>             ...
>>>             addr = page_mapped_in_vma(page, vma);
>>>             ...
>>>         }
>>>     }
>>>     rcu_read_unlock();
>>>     anon_vma_unlock_read(av);
>>> }
>>>
>>> page_mapped_in_vma() then builds pvmw for that page:
>>>
>>> unsigned long page_mapped_in_vma(const struct page *page,
>>>         struct vm_area_struct *vma)
>>> {
>>>     const struct folio *folio = page_folio(page);
>>>     struct page_vma_mapped_walk pvmw = {
>>>         .pfn = page_to_pfn(page),
>>>         .nr_pages = 1,
>>>         .vma = vma,
>>>         .flags = PVMW_SYNC,
>>>     };
>>>
>>>     pvmw.address = vma_address(vma, page_pgoff(folio, page), 1);
>>>     ...
>>> }
>>>
>>> and page_pgoff() includes the subpage index:
>>>
>>> static inline pgoff_t page_pgoff(const struct folio *folio,
>>>         const struct page *page)
>>> {
>>>     return folio->index + folio_page_idx(folio, page);
>>> }
>>>
>>> So if the poisoned PFN points to a tail page, pvmw->address can be offset
>>> from the start of the hugetlb mapping by
>>>
>>> folio_page_idx(folio, page) << PAGE_SHIFT
>>>
>>> Should check_pte() pass the hugepage-aligned address to huge_ptep_get()
>>> for that case?
>>
>> Thanks! This looks correct.
>>

Thanks both.

>> I can indeed fix this up in check_pte. But in the memory-failure path
>> it has always been confusing to me for hugetlb folios why we are bothering

IIUC, the hugetlb tail page is used to calculate the specified hwpoisoned address
and send it to userspace through SIGBUS.

>> with the tail page. I am sure that area can also be simplified. But for
>> now I'll just do a simple fix here itself.
> 
> Just thinking out loud: given that huge_ptep_get() already assumes that
> addr matches the huge pte, at least on arm64, would it make sense to
> have a small hugetlb wrapper around it that takes hstate and aligns
> the address before calling the arch helper?

This proposal looks good to me given the assumption.

Thanks.
.

> 
> Might make the rule clearer, and a bit harder to get wrong again :)
> 
> Thanks, Lance
> 
>>
>>>
>>> Cheers, Lance
>>>
>>>>>
>>>>> For arm64, CONT_PMD_SIZE is one supported HugeTLB size. With such a VMA,
>>>>> page_vma_mapped_walk() passes that size to hugetlb_walk():
>>>>>
>>>>> bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>>> {
>>>>>     ...
>>>>>     if (unlikely(is_vm_hugetlb_page(vma))) {
>>>>>         ...
>>>>>         pvmw->pte = hugetlb_walk(vma, pvmw->address, size);
>>>>>         ...
>>>>>     }
>>>>>     ...
>>>>> }
>>>>>
>>>>> hugetlb_walk() then calls arm64 huge_pte_offset(mm, addr, sz). For
>>>>> sz == CONT_PMD_SIZE, huge_pte_offset() aligns its local addr before
>>>>> calculating pmdp:
>>>>>
>>>>> pte_t *huge_pte_offset(struct mm_struct *mm,
>>>>>                unsigned long addr, unsigned long sz)
>>>>> {
>>>>>     ...
>>>>>     if (sz == CONT_PMD_SIZE)
>>>>>         addr &= CONT_PMD_MASK;
>>>>>
>>>>>     pmdp = pmd_offset(pudp, addr);
>>>>>     pmd = READ_ONCE(*pmdp);
>>>>>     ...
>>>>> }
>>>>>
>>>>> So for that case, pvmw->pte is calculated from the aligned addr, not
>>>>> necessarily from the original pvmw->address. But check_pte() passes the
>>>>> original address together with pvmw->pte:
>>>>>
>>>>> +        ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>>>>> +                      pvmw->pte);
>>>>>
>>>>> arm64 then uses that addr again to choose ncontig:
>>>>>
>>>>> pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
>>>>> {
>>>>>     ...
>>>>>     ncontig = find_num_contig(mm, addr, ptep, &pgsize);
>>>>>     for (i = 0; i < ncontig; i++, ptep++) {
>>>>>         ...
>>>>>     }
>>>>>     return orig_pte;
>>>>> }
>>>>>
>>>>> static int find_num_contig(struct mm_struct *mm, unsigned long addr,
>>>>>                pte_t *ptep, size_t *pgsize)
>>>>> {
>>>>>     pgd_t *pgdp = pgd_offset(mm, addr);
>>>>>     p4d_t *p4dp;
>>>>>     pud_t *pudp;
>>>>>     pmd_t *pmdp;
>>>>>
>>>>>     *pgsize = PAGE_SIZE;
>>>>>     p4dp = p4d_offset(pgdp, addr);
>>>>>     pudp = pud_offset(p4dp, addr);
>>>>>     pmdp = pmd_offset(pudp, addr);
>>>>>     if ((pte_t *)pmdp == ptep) {
>>>>>         *pgsize = PMD_SIZE;
>>>>>         return CONT_PMDS;
>>>>>     }
>>>>>     return CONT_PTES;
>>>>> }
>>>>>
>>>>> With a tail address, pmdp may no longer point at pvmw->pte, so
>>>>> find_num_contig() can return CONT_PTES for a CONT_PMD HugeTLB mapping.
>>>>>
>>>>> On 16K arm64, that changes ncontig from 32 to 128. So huge_ptep_get()
>>>>> can walk past the CONT_PMD entries, and possibly past the PMD table.
>>>>>
>>>>> Should check_pte() pass the address matching pvmw->pte, sth like:
>>>>>
>>>>> ---8<---
>>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>>> index 406fd50bbd8f..58463493bd3d 100644
>>>>> --- a/mm/page_vma_mapped.c
>>>>> +++ b/mm/page_vma_mapped.c
>>>>> @@ -109,11 +109,14 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>>>>>       unsigned long pfn;
>>>>>       pte_t ptent;
>>>>>
>>>>> -    if (is_vm_hugetlb_page(pvmw->vma))
>>>>> -        ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>>>>> -                      pvmw->pte);
>>>>> -    else
>>>>> +    if (is_vm_hugetlb_page(pvmw->vma)) {
>>>>> +        struct hstate *hstate = hstate_vma(pvmw->vma);
>>>>> +        unsigned long haddr = pvmw->address & huge_page_mask(hstate);
>>>>> +
>>>>> +        ptent = huge_ptep_get(pvmw->vma->vm_mm, haddr, pvmw->pte);
>>>>> +    } else {
>>>>>           ptent = ptep_get(pvmw->pte);
>>>>> +    }
>>>>>
>>>>>       if (pvmw->flags & PVMW_MIGRATION) {
>>>>>           const softleaf_t entry = softleaf_from_pte(ptent);
>>>>> -- 
>>>>>
>>>>> while leaving pvmw->address unchanged for page_mapped_in_vma()?
>>>>>
>>>>> Cheers, Lance
>>>>>
>>>>>> +    else
>>>>>> +        ptent = ptep_get(pvmw->pte);
>>>>>>
>>>>>>     if (pvmw->flags & PVMW_MIGRATION) {
>>>>>>         const softleaf_t entry = softleaf_from_pte(ptent);
>>>>>> -- 
>>>>>> 2.43.0
>>>>>>
>>>>>>
>>>>
>>>>
>>>
>>
> 
> .


