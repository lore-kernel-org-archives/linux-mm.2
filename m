Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27113C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 16:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048026B009F; Fri, 26 Jun 2026 12:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3A9A6B00A1; Fri, 26 Jun 2026 12:46:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E297E6B00A3; Fri, 26 Jun 2026 12:46:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD5116B009F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:46:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3CDD0167954
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:46:56 +0000 (UTC)
X-FDA: 84922643232.01.816DB0B
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6292880006
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:46:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HOJOa/Ld";
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782492414;
	b=Cw4IAUEr3GOiLobcstxObP+vaQQ4R+6md/fPSmYx2V1xN6TZ0V0qt6l1NebDh7yQq2NQhO
	nBd2V9UmHrexDNhInQAxsVEpml5gFw5x6JEq5lJFGnF07dKkK+B4s3eX1A1/Fvwz31nHLW
	N4EAhhJbzD29cI/s/60SPF3V8yOccrw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782492414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FGwxxWe+QCDMvLSkrZ/qxbUzFrLihkdj28Ia6nPKpIo=;
	b=fNiXvnmfe/gB4xFfTW7eqBPFhisCNkizWrC6McGQDjPX9/x4m0oet1GC4r1MQNo/W3dE2h
	eProP/+i/AV3twmd5aPiHpsq71xaW5PEd7Oh56swLFnLaTXv8Ug+r+ZwXAmXANsST+kq6F
	O0nz9vYnU4LD3VLcyziQYl3CVO6R3Sw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HOJOa/Ld";
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <edee8461-34c6-41e9-ae0c-076380d92ebb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782492411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FGwxxWe+QCDMvLSkrZ/qxbUzFrLihkdj28Ia6nPKpIo=;
	b=HOJOa/LdmSrgdvreMbVWnSMNdFb3o+bICnC0yutu2zdn9Pkw/GFuSzgPpiz7cM9SE0vUsr
	r4i94ApppN6XHHe2YJvCDyobhQOU+JcFxBpLHC/Wi56ZjAu0xjJ99caDiEm497lv8B3xAi
	7wLYeYTMD+L51EkeTu3wuwS97CkpL3k=
Date: Sat, 27 Jun 2026 00:46:38 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] mm/page_vma_mapped: use huge_ptep_get() for hugetlb
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>, linmiaohe@huawei.com
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
 ljs@kernel.org, david@kernel.org, liam@infradead.org, riel@surriel.com,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, kas@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcampbell@nvidia.com,
 apopple@nvidia.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, mel@csn.ul.ie,
 nao.horiguchi@gmail.com, ak@linux.intel.com, j-nomura@ce.jp.nec.com,
 pfalcato@suse.de, dave.hansen@intel.com, tglx@kernel.org,
 jpoimboe@kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com,
 stable@vger.kernel.org
References: <e6d1b813-0893-458e-9d58-8d3a9bd979c4@arm.com>
 <20260626141031.14309-1-lance.yang@linux.dev>
 <61e9fcf7-02a5-4285-948b-62fba4dcd69c@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <61e9fcf7-02a5-4285-948b-62fba4dcd69c@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: eodt35kker9mx8gjyiwxxt35t5awmz4p
X-Rspam-User: 
X-Rspamd-Queue-Id: 6292880006
X-Rspamd-Server: rspam02
X-HE-Tag: 1782492414-297711
X-HE-Meta: U2FsdGVkX18cShKD2Ehn7Y5njTz1JeBt2X5RIE/+3RyGFBiK+aOdCa1h5PlylwTA5WDokOhf3JxuE9/IXwie1CKlcaMNgwgFN792naViYcer24XlRryVHDPYdu0Nt0JDq6gB0MD52ShUyWfJCAbaz4mKvPT75uQCcNhVdM2mnKNuNjvTl9+DbswT352K2gCao1AS/PRLluhKKABxVR/wxNWsc6jg7HFDySbdn9F0XJCU+zlPYEsuSLOW25oUGqp5a0gdZKDUSn/9wAy+llJzNuBj9gIZLjpjA0flwsalJ59eKKkHbBBJqiYXfix5TkZwa4YqPeNuzTUuGVYKLtbAYOBNYkPiHOK7JKnTHRsTyLEAQgwDmjfhEoxaDz33sEw6uELU0ocaElE2fKmeBzxkiJIErQHN8l0cED/gw2DMqywZDvTubPSFjH6lMeY5jpf1tM1OobA04Lrh2xet3lcdgeeiODptihhlja9vChkyMpiM18gTvVVfwoq8LNUu0xSM5K442YkZqSFinv1Xfhtz3da76n2J4hT4TcmpzR24UUeYUcC4l6gUabkZ2sZsvigHGwWtXkaEFsAtb9CWdRF6tnhsGksdtyTW4yl7gCbggmM1BKJchD7nqmY615TEX1okVWacjlAwW9qlBXMKGRmoRkffCT3eMt8KWI+nQ0r8xDJ3ws58H/e0P/iocmRZyjS5AZALgayE8hGs+BFR0PMQm9xyqgpK7QUlv/jrztF2FgIgf6U7/cvnJpOWjynJxzHLTWe5TsZgFn6e21SI5o1i0YMnJztlnkSAbavF12YytYUcUM1N5Fbz1UFFWoWm/78W+8JUVGRWItmilTFbUQEsEvccpjvj7DWOgq/853ciaw41wiCNgVtVk2ahnPVwrpXVJgsn1CKjwhliEyVWM0zR1CFiIP6RqD6i69ca/tqEV/CA0OrnNH2e2mu6vSl/2fns3nWHd6Jm35G7ytx2/O5
 TwBVcGYd
 7P4pADKVbFPXF6fpnb/7KGIcM3CosrEgtF27HB0L100P8Be6u4gMIhB8Xx0mQtGHFOLrpnjlWLiK10pouFcbezlvdlLtClojxeoHAsXcIiMrfHpdyVMCmRqT10psfXBUwP+ROmULTcp6Fh+YHiXxtXYQ5MWz9hRHFof6vXLKhHfiL5Wm9+X4gTJ1M0bgekuypGx+xdBLaoREYrofl8aJvwKTUGo1FD8gNPUa14QHPHsUf/ze8DRmsrluq3L0E3uW3v0uSnZC34uz43M9rEFTXOtm8iGBCKOIlWtZ1Ks/JwKPbFukiFEHbn4U/XnDxf6P4wTATV6hJ/6CmsKAIP2FpMBGj5mYP+3X1RDMjx3Uj5ttu9U3qFaBmbmaP4XrVKmbLpyFmvbEeoPoFjwQhDpvgZsuFGyPt7sjCpCxH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/26 23:26, Dev Jain wrote:
> 
> 
> On 26/06/26 7:40 pm, Lance Yang wrote:
>>
>> On Fri, Jun 26, 2026 at 06:53:10PM +0530, Dev Jain wrote:
>>>
>>>
>>> On 26/06/26 1:18 pm, Lance Yang wrote:
>>>>
>>>> On Thu, Jun 25, 2026 at 11:29:53AM +0000, Dev Jain wrote:
>>>>> check_pte() is the final validation step in page_vma_mapped_walk().
>>>>> It reads pvmw->pte with ptep_get() to decide whether the entry maps
>>>>> the PFN range being walked. For hugetlb VMAs, that pointer refers
>>>>> to a hugetlb entry.
>>>>>
>>>>> On arches which provide their own huge_ptep_get() to dereference a huge
>>>>> pte pointer, accessing via ptep_get() would cause pte_pfn(),
>>>>> pte_present() etc to misbehave.
>>>>>
>>>>> It is not clear whether this has a trivially visible effect to userspace.
>>>>>
>>>>> Use huge_ptep_get() to dereference a huge pte pointer.
>>>>>
>>>>> Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
>>>>> Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>>>> ---
>>>>> mm/page_vma_mapped.c | 8 +++++++-
>>>>> 1 file changed, 7 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>>> index 2ccbabfb2cc17..18e1d341f463c 100644
>>>>> --- a/mm/page_vma_mapped.c
>>>>> +++ b/mm/page_vma_mapped.c
>>>>> @@ -107,7 +107,13 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,
>>>>> static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>>>>> {
>>>>> 	unsigned long pfn;
>>>>> -	pte_t ptent = ptep_get(pvmw->pte);
>>>>> +	pte_t ptent;
>>>>> +
>>>>> +	if (is_vm_hugetlb_page(pvmw->vma))
>>>>> +		ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>>>>> +				      pvmw->pte);
>>>>
>>>> I think check_pte() can pass a wrong address to huge_ptep_get() ...
>>>
>>> Won't this be handled by rmap_walk_anon/rmap_walk_file - they are the ones
>>> performing the rmap traversal and passing address to try_to_unmap_one/folio_referenced_one
>>> etc ...
>>
>> Right, that should cover the rmap callbacks. The bit I was worried about
>> is page_mapped_in_vma() though.
>>
>>>>
>>>> Not sure that is wrong in the first place. For memory failure,
>>>> page_mapped_in_vma() can be called with a poisoned tail page of a hugetlb
>>>> folio. In that case, pvmw->address need not be hugepage-aligned.
>>>>
>>>> @Miaohe
>>
>> For hugetlb memory failure we start with the poisoned PFN:
>>
>> static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
>> {
>> 	...
>> 	struct page *p = pfn_to_page(pfn);
>> 	struct folio *folio;
>> 	...
>>
>> 	folio = page_folio(p);
>>
>> 	...
>>
>> 	if (!hwpoison_user_mappings(folio, p, pfn, flags)) {
>> 		...
>> 	}
>>
>> 	...
>> }
>>
>> and pass the same p down:
>>
>> static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
>> 		unsigned long pfn, int flags)
>> {
>> 	...
>>
>> 	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
>>
>> 	...
>> }
>>
>> static void collect_procs(const struct folio *folio, const struct page *page,
>> 		struct list_head *tokill, int force_early)
>> {
>> 	...
>>
>> 	if (unlikely(folio_test_ksm(folio)))
>> 		...
>> 	else if (folio_test_anon(folio))
>> 		collect_procs_anon(folio, page, tokill, force_early);
>> 	else
>> 		...
>> }
>>
>> So collect_procs_anon() still gets the poisoned page, not &folio->page:
>>
>> static void collect_procs_anon(const struct folio *folio,
>> 		const struct page *page, struct list_head *to_kill,
>> 		int force_early)
>> {
>> 	...
>>
>> 	pgoff = page_pgoff(folio, page);
>> 	rcu_read_lock();
>> 	for_each_process(tsk) {
>> 		...
>> 		
>> 		anon_vma_interval_tree_foreach(vmac, &av->rb_root,
>> 					       pgoff, pgoff) {
>> 			...
>> 			addr = page_mapped_in_vma(page, vma);
>> 			...
>> 		}
>> 	}
>> 	rcu_read_unlock();
>> 	anon_vma_unlock_read(av);
>> }
>>
>> page_mapped_in_vma() then builds pvmw for that page:
>>
>> unsigned long page_mapped_in_vma(const struct page *page,
>> 		struct vm_area_struct *vma)
>> {
>> 	const struct folio *folio = page_folio(page);
>> 	struct page_vma_mapped_walk pvmw = {
>> 		.pfn = page_to_pfn(page),
>> 		.nr_pages = 1,
>> 		.vma = vma,
>> 		.flags = PVMW_SYNC,
>> 	};
>>
>> 	pvmw.address = vma_address(vma, page_pgoff(folio, page), 1);
>> 	...
>> }
>>
>> and page_pgoff() includes the subpage index:
>>
>> static inline pgoff_t page_pgoff(const struct folio *folio,
>> 		const struct page *page)
>> {
>> 	return folio->index + folio_page_idx(folio, page);
>> }
>>
>> So if the poisoned PFN points to a tail page, pvmw->address can be offset
>> from the start of the hugetlb mapping by
>>
>> folio_page_idx(folio, page) << PAGE_SHIFT
>>
>> Should check_pte() pass the hugepage-aligned address to huge_ptep_get()
>> for that case?
> 
> Thanks! This looks correct.
> 
> I can indeed fix this up in check_pte. But in the memory-failure path
> it has always been confusing to me for hugetlb folios why we are bothering
> with the tail page. I am sure that area can also be simplified. But for
> now I'll just do a simple fix here itself.

Just thinking out loud: given that huge_ptep_get() already assumes that
addr matches the huge pte, at least on arm64, would it make sense to
have a small hugetlb wrapper around it that takes hstate and aligns
the address before calling the arch helper?

Might make the rule clearer, and a bit harder to get wrong again :)

Thanks, Lance

> 
>>
>> Cheers, Lance
>>
>>>>
>>>> For arm64, CONT_PMD_SIZE is one supported HugeTLB size. With such a VMA,
>>>> page_vma_mapped_walk() passes that size to hugetlb_walk():
>>>>
>>>> bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>> {
>>>> 	...
>>>> 	if (unlikely(is_vm_hugetlb_page(vma))) {
>>>> 		...
>>>> 		pvmw->pte = hugetlb_walk(vma, pvmw->address, size);
>>>> 		...
>>>> 	}
>>>> 	...
>>>> }
>>>>
>>>> hugetlb_walk() then calls arm64 huge_pte_offset(mm, addr, sz). For
>>>> sz == CONT_PMD_SIZE, huge_pte_offset() aligns its local addr before
>>>> calculating pmdp:
>>>>
>>>> pte_t *huge_pte_offset(struct mm_struct *mm,
>>>> 		       unsigned long addr, unsigned long sz)
>>>> {
>>>> 	...
>>>> 	if (sz == CONT_PMD_SIZE)
>>>> 		addr &= CONT_PMD_MASK;
>>>>
>>>> 	pmdp = pmd_offset(pudp, addr);
>>>> 	pmd = READ_ONCE(*pmdp);
>>>> 	...
>>>> }
>>>>
>>>> So for that case, pvmw->pte is calculated from the aligned addr, not
>>>> necessarily from the original pvmw->address. But check_pte() passes the
>>>> original address together with pvmw->pte:
>>>>
>>>> +		ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>>>> +				      pvmw->pte);
>>>>
>>>> arm64 then uses that addr again to choose ncontig:
>>>>
>>>> pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
>>>> {
>>>> 	...
>>>> 	ncontig = find_num_contig(mm, addr, ptep, &pgsize);
>>>> 	for (i = 0; i < ncontig; i++, ptep++) {
>>>> 		...
>>>> 	}
>>>> 	return orig_pte;
>>>> }
>>>>
>>>> static int find_num_contig(struct mm_struct *mm, unsigned long addr,
>>>> 			   pte_t *ptep, size_t *pgsize)
>>>> {
>>>> 	pgd_t *pgdp = pgd_offset(mm, addr);
>>>> 	p4d_t *p4dp;
>>>> 	pud_t *pudp;
>>>> 	pmd_t *pmdp;
>>>>
>>>> 	*pgsize = PAGE_SIZE;
>>>> 	p4dp = p4d_offset(pgdp, addr);
>>>> 	pudp = pud_offset(p4dp, addr);
>>>> 	pmdp = pmd_offset(pudp, addr);
>>>> 	if ((pte_t *)pmdp == ptep) {
>>>> 		*pgsize = PMD_SIZE;
>>>> 		return CONT_PMDS;
>>>> 	}
>>>> 	return CONT_PTES;
>>>> }
>>>>
>>>> With a tail address, pmdp may no longer point at pvmw->pte, so
>>>> find_num_contig() can return CONT_PTES for a CONT_PMD HugeTLB mapping.
>>>>
>>>> On 16K arm64, that changes ncontig from 32 to 128. So huge_ptep_get()
>>>> can walk past the CONT_PMD entries, and possibly past the PMD table.
>>>>
>>>> Should check_pte() pass the address matching pvmw->pte, sth like:
>>>>
>>>> ---8<---
>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>> index 406fd50bbd8f..58463493bd3d 100644
>>>> --- a/mm/page_vma_mapped.c
>>>> +++ b/mm/page_vma_mapped.c
>>>> @@ -109,11 +109,14 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>>>>   	unsigned long pfn;
>>>>   	pte_t ptent;
>>>>
>>>> -	if (is_vm_hugetlb_page(pvmw->vma))
>>>> -		ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>>>> -				      pvmw->pte);
>>>> -	else
>>>> +	if (is_vm_hugetlb_page(pvmw->vma)) {
>>>> +		struct hstate *hstate = hstate_vma(pvmw->vma);
>>>> +		unsigned long haddr = pvmw->address & huge_page_mask(hstate);
>>>> +
>>>> +		ptent = huge_ptep_get(pvmw->vma->vm_mm, haddr, pvmw->pte);
>>>> +	} else {
>>>>   		ptent = ptep_get(pvmw->pte);
>>>> +	}
>>>>
>>>>   	if (pvmw->flags & PVMW_MIGRATION) {
>>>>   		const softleaf_t entry = softleaf_from_pte(ptent);
>>>> --
>>>>
>>>> while leaving pvmw->address unchanged for page_mapped_in_vma()?
>>>>
>>>> Cheers, Lance
>>>>
>>>>> +	else
>>>>> +		ptent = ptep_get(pvmw->pte);
>>>>>
>>>>> 	if (pvmw->flags & PVMW_MIGRATION) {
>>>>> 		const softleaf_t entry = softleaf_from_pte(ptent);
>>>>> -- 
>>>>> 2.43.0
>>>>>
>>>>>
>>>
>>>
>>
> 


