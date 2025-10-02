Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE3DFCAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 07:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1673C8E000B; Thu,  2 Oct 2025 03:27:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13F438E0002; Thu,  2 Oct 2025 03:27:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07BDB8E000B; Thu,  2 Oct 2025 03:27:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED1118E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:27:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 97AEE1A0389
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:27:39 +0000 (UTC)
X-FDA: 83952344238.30.3345521
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id AB982180004
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:27:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IJuo9suh;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759390057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tf8z5q3IrTjEa1scLQkDrmTv4dYy/I6ofHkuRkCTr8Q=;
	b=OMKnAXWUbNFUIlRJfsPw/B+17Yjt6kZX3yxXWXSfT5FLLczY7aRB1+6hjnqbXaJRZ4Utqa
	MhBYJfY3gHBjU8gDEjkhhuydz3g2ocAPH4vfSabfNL0NZaTvcWfiMMFbLI0Kidh6YXEAsU
	zsIjbk7ovUGbHKx92ousES1zjzEi2HA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759390057; a=rsa-sha256;
	cv=none;
	b=0ap+zlybMusd9KOrS+KeeavmjlHIKgs8zPuLHSf7yv+PYe/7jPvHTZdGa0FppPpU9ToI48
	5LzbZ+LNUt/DkFg0A/+WbOCS/TWT98RSK1qgZQ91gQPwqop0YakVsEk4D4GSO1TFGo7xPE
	sh+0SZh9sQDaqylcWzymqPq0XB5qkCY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IJuo9suh;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <51e0b689-02fa-465c-896b-1178497085c6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759390055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tf8z5q3IrTjEa1scLQkDrmTv4dYy/I6ofHkuRkCTr8Q=;
	b=IJuo9suhBO7mPis8m/CD6PeN8fi++MYV7WCQCMrD+3fBnQ2nStg/ZIQ1fcND3dOuHF5LnZ
	Pc9R2lIccS0rdH4i04CauQvPVxWXPyEgI5aIeZPyDSJJoPCMhgQDA9LcdSgxAO7VvYt9oD
	yIMmVHgtsWlaUu9WrRdYTbop2IYsCno=
Date: Thu, 2 Oct 2025 15:27:33 +0800
MIME-Version: 1.0
Subject: Re: [Patch v2] mm/huge_memory: add pmd folio to ds_queue in
 do_huge_zero_wp_pmd()
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 wangkefeng.wang@huawei.com, linux-mm@kvack.org, stable@vger.kernel.org
References: <20251002013825.20448-1-richard.weiyang@gmail.com>
 <20251002014604.d2ryohvtrdfn7mvf@master>
 <fa3f9e82-c6c8-43f2-803f-b8bb0fe56f37@linux.dev>
 <20251002031743.4anbofbyym5tlwrt@master>
 <a4b5589a-1607-4e67-939d-f86f98a395a6@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <a4b5589a-1607-4e67-939d-f86f98a395a6@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: AB982180004
X-Stat-Signature: xcs551m15js34jixh1uhb35wz3mi13ik
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759390057-998744
X-HE-Meta: U2FsdGVkX18A9GDBCGwbk52QbyUeQFQXOShbh5NZZOZ2H1YI0jWaE4rDW5OX/G867xQ09psz+tD7Wdy6DV3OWiq49NKDerHbLuoN0fiCr0rpMyc4OrwmW9ZvtHpM4TUnU638MtU/oM20SMIT5i/Fz82UC6LFhGgHH7RFMR35B24PO+AxSkzSYF7epKI1Ki8DbiMIDp3kNJEy2vJUIJ2JIngIkBvv9sVz5KbyzXbxa0tuTWjIVc46EYOlZR9UAAGCKfPB8vOT4Jaf4DiVrSrwq6C+iNXswACnGbGsjAfHJRy+DO26dQWPN4Oor2xBZGG028uv8xAAYhojvEh14pETk49c7sIJlwkL0f0J8uPNKBNdv/0EgLkF0Jh3yty4n73UAHE/Rt+WrJDmldQ8z58kQ9+yBLclhdsz2N7WcnNlE3MIHQXjq/vt+0mBQPNvOA9ozS7Nn7rMdo4AEXcVvYrnlDDiNXE4dQCuBk/68+iGWqKI7XsRhh3QgKEOhPHx2aaFIsxvW1cbizdinV8TfdcpNkf5tU/mZCeMzqTxHw1Cl0D8lYHgMq68pW+nejrst5qy49+48SAyb67VezLuIG+KoycMZVnlWsagoYacvh8vDLxoVmune6ux/nHRww3lHuamiIR36xQb3iYp4ydsISLhohPeGVeSKFY/Vl1H7fXopIctW5T/BCyJ+8zSgfzf3jbDbtulCOrFsKp3zrntjFqC9nScDQTdSIwryG/lUT0HNsgFXRaPoGhw4ALvXN7F/eDnZ7ao9L90fHwr5UQ7o6BQ281laZTig4DqtNBNciqK7a9Qm6POarV+dirWq0/3kKiaGMcciTYWcz53S2acrunN8Rjp9LCNeR5YOJrNQyLl4SeBJHSeuV09VgPlWvPbTkA+B/hmTCoFtTJp2ihW09L282qIqvF1Ki6IRdGe5YPGQbwEBF2cc3aFvzah00clsKD5PaXjnIi5+NeL7FL6y2v
 zmdSTp0v
 1NhxKCbmlREt8wGr7eN9dsIRNSBlZ9iY8PE+q+ksriKPWA/0XeFVOWP2NeKDtKv316OuOjmpAagOOwoG6iHeu/9WyCQeNmJPtSOFCqJ/F/nxxDuUXqVPb6DRTMXCa5VC5D+NpboIO8Lf+2M05ndmnTMRds/ZF34FpfRQz9z8VA9ohIq7p4FC3TNw9JQ423dYNsX8gox7KVssTw7KgPF7S5UMHGvlsGWPgmWcaTYXUB+nhHFwq5w/5aXFmCK/YyAL7nX1l5gTMJ+ED/pmkbNnSz+jRNBoFuU5dzqKGc4bn1hTEHHkr1wRgKHLONQAJ1HFtYdl6svhXl1jdtYB7jjvJ5/EtLrJUYg5E3pJd2c0TRdiBXizVgy3eXeszrhhJ2wXyUbAs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/2 15:16, David Hildenbrand wrote:
> On 02.10.25 05:17, Wei Yang wrote:
>> On Thu, Oct 02, 2025 at 10:31:53AM +0800, Lance Yang wrote:
>>>
>>>
>>> On 2025/10/2 09:46, Wei Yang wrote:
>>>> On Thu, Oct 02, 2025 at 01:38:25AM +0000, Wei Yang wrote:
>>>>> We add pmd folio into ds_queue on the first page fault in
>>>>> __do_huge_pmd_anonymous_page(), so that we can split it in case of
>>>>> memory pressure. This should be the same for a pmd folio during wp
>>>>> page fault.
>>>>>
>>>>> Commit 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") miss
>>>>> to add it to ds_queue, which means system may not reclaim enough 
>>>>> memory
>>>>> in case of memory pressure even the pmd folio is under used.
>>>>>
>>>>> Move deferred_split_folio() into map_anon_folio_pmd() to make the pmd
>>>>> folio installation consistent.
>>>>>
>>>>
>>>> Since we move deferred_split_folio() into map_anon_folio_pmd(), I am 
>>>> thinking
>>>> about whether we can consolidate the process in collapse_huge_page().
>>>>
>>>> Use map_anon_folio_pmd() in collapse_huge_page(), but skip those 
>>>> statistic
>>>> adjustment.
>>>
>>> Yeah, that's a good idea :)
>>>
>>> We could add a simple bool is_fault parameter to map_anon_folio_pmd()
>>> to control the statistics.
>>>
>>> The fault paths would call it with true, and the collapse paths could
>>> then call it with false.
>>>
>>> Something like this:
>>>
>>> ```
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 1b81680b4225..9924180a4a56 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -1218,7 +1218,7 @@ static struct folio 
>>> *vma_alloc_anon_folio_pmd(struct
>>> vm_area_struct *vma,
>>> }
>>>
>>> static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
>>> -        struct vm_area_struct *vma, unsigned long haddr)
>>> +        struct vm_area_struct *vma, unsigned long haddr, bool is_fault)
>>> {
>>>     pmd_t entry;
>>>
>>> @@ -1228,10 +1228,15 @@ static void map_anon_folio_pmd(struct folio 
>>> *folio,
>>> pmd_t *pmd,
>>>     folio_add_lru_vma(folio, vma);
>>>     set_pmd_at(vma->vm_mm, haddr, pmd, entry);
>>>     update_mmu_cache_pmd(vma, haddr, pmd);
>>> -    add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>>> -    count_vm_event(THP_FAULT_ALLOC);
>>> -    count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
>>> -    count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
>>> +
>>> +    if (is_fault) {
>>> +        add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>>> +        count_vm_event(THP_FAULT_ALLOC);
>>> +        count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
>>> +        count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
>>> +    }
>>> +
>>> +    deferred_split_folio(folio, false);
>>> }
>>>
>>> static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index d0957648db19..2eddd5a60e48 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -1227,17 +1227,10 @@ static int collapse_huge_page(struct 
>>> mm_struct *mm,
>>> unsigned long address,
>>>     __folio_mark_uptodate(folio);
>>>     pgtable = pmd_pgtable(_pmd);
>>>
>>> -    _pmd = folio_mk_pmd(folio, vma->vm_page_prot);
>>> -    _pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
>>> -
>>>     spin_lock(pmd_ptl);
>>>     BUG_ON(!pmd_none(*pmd));
>>> -    folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
>>> -    folio_add_lru_vma(folio, vma);
>>>     pgtable_trans_huge_deposit(mm, pmd, pgtable);
>>> -    set_pmd_at(mm, address, pmd, _pmd);
>>> -    update_mmu_cache_pmd(vma, address, pmd);
>>> -    deferred_split_folio(folio, false);
>>> +    map_anon_folio_pmd(folio, pmd, vma, address, false);
>>>     spin_unlock(pmd_ptl);
>>>
>>>     folio = NULL;
>>> ```
>>>
>>> Untested, though.
>>>
>>
>> This is the same as I thought.
>>
>> Will prepare a patch for it.
> 
> Let's do that as an add-on patch, though.

Yeah, let’s do that separately ;)

