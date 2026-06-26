Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82C96C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 13:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 508296B0005; Fri, 26 Jun 2026 09:23:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B9186B0088; Fri, 26 Jun 2026 09:23:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CEBD6B008A; Fri, 26 Jun 2026 09:23:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12F8D6B0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:23:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA9921C6369
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:23:25 +0000 (UTC)
X-FDA: 84922130370.10.75B91A9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id ACB0680002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:23:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aTQKqclQ;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782480204;
	b=EOR7CBZqCsPKPiZqRiEj5MIKW0p9kutOpjnjfmrJcfpciEzy1fbETrkXNVZJ0OhFKSRsR1
	SiQ2U9Itnh4o852l1JRWlu6ULEyZhGzx1rpaXYlx1XaIRBTx50aUdw6yqVo7A9wvhqYHmV
	iBbQ3rGNtHfB5kPCp1FaZlTAwKAlBw4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782480204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CtXlg3YxEAyeFBY59TYGUP8iUHZDPwsjspbYVny1m4c=;
	b=GMnPeD3fSpQ8J9g7aIHcuHOIHYIUkMXEZ1pKx0yGrvBPJtKCJj9JfpMBphjaFKv/q+3gBU
	G26a1svCtFRp8NT6fbmX4RX81/UT+Ufnnw+4crphFouwIvzm+F9Z8YAn6AMWX/rZHVbrFY
	NqY8/4waU1WnCncv2t9V6P57wtzISiE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aTQKqclQ;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E66EF1570;
	Fri, 26 Jun 2026 06:23:17 -0700 (PDT)
Received: from [10.164.19.14] (unknown [10.164.19.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ACEA63F632;
	Fri, 26 Jun 2026 06:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782480202; bh=nb4rFe3Q3YhM3Qx4t4fYGfUdPmERHrvA3QR5e1Bgchs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aTQKqclQjcgTkbNI4MumvFvF1LbJskNozCfFLIsoNnWnqeI0E2opjFTOglwCnW/5s
	 gHI3Xv8ss7i1SM+cK0FhKuJ5VaYRtmMsTiNT3ugLPzlHOsEMNrz9P/ugc9GqfDVzay
	 zUTxuwmrdRA0ns2koM7wqjGkpjQqXPcPMk1XhL2w=
Message-ID: <e6d1b813-0893-458e-9d58-8d3a9bd979c4@arm.com>
Date: Fri, 26 Jun 2026 18:53:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] mm/page_vma_mapped: use huge_ptep_get() for hugetlb
To: Lance Yang <lance.yang@linux.dev>, linmiaohe@huawei.com
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
References: <20260625112955.3254283-5-dev.jain@arm.com>
 <20260626074855.97652-1-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260626074855.97652-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c3j1ynxbfpmwrh8hrnzy4z9urj4y59u8
X-Rspam-User: 
X-Rspamd-Queue-Id: ACB0680002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782480203-207123
X-HE-Meta: U2FsdGVkX18ufNH82n3VyhV+Y/O1Wqe7UVaaYi1MJAWF1+KzPdoD6OmlXUlz7HmpnqL+GyDe1VqI+J22M6LINpKzsRHETR1eM7GcsyBvsBXki/9Wvy9f5DBCb3Ut4Db/sp+bWj4HlISe/I3yywcnxRHLlSQWMTE6xO7h4D02NAPIdBjo8lXSqGWcG8Sr0iZugu3Kdru7dq1GCYU0OplEOxe2J2iiQ+2d5QCp5EX02RZdqVzXpZneGa1ftAntbqVbJD4S/BXuPVzLjvcjCBq5R7b1EDv2HxQxsHdaojuEXfu3hyvmbJCDiijIlHKe3IccFCdMhYfDBs8q8ffy4LYvS7jic/k4qh2tLSAYtt64P6BPGJyiVL3J0LmyWcIuwbr0KaGwQBkrq8qOIw2m/GAZZ1oI32M7UG8rd/u8XIOUl7vttUqWcMfftMFaO71PTb52Y25cB6hlCwwnPaJS4CB6JzqFWwi4VR7005U2wxXcax0Hnb4jVARgOIBo42H/T+86YGTkzT6eNFmkqhQX7JknRm10W3CtDUwo+qsh7k4R0fuLFbHNaMjup/uFZODfqpSFyyQlVo+srLOp57jNlZ2RBVkkoiji+IUlMtUba2mdUEruMo3z/0BzJp+/3N8E8wa42d+eJUZVvgqodoIxsvJBkThH53Snu7ZTUrKuigf9TN+elI8WKl3f5pQAW7GV4QU+teZR4A76kU0YbGNd+w8Gmm1aO/KoWDnSz0tKd5HgDGrCcn+gGvMBKXw0hBR2Agr9kRt7ech9VMXJpvuk3nUIoqmm7DEamqwOc87EKOwIohk1IIdq3Tm4UiSfantPtxr/abpSJgHQiAiOAzp/V8hQFEMDZc938x1+FC+juaGNCFIZdxVgfAJX/4TV/kqOn2jThbHR1A1eUJ+YHAaQcxFZ8XMxO9ziJ8yeKkXv8c5YHv3ikihbh9WkMFRG4T31FCn/qscie1rdVGTZ2dvTJeQ
 OrmtT/Kk
 w9omzcergn4el/VKgb40VGTqKL6q43T1ZH2O3Dt6CVglojyUOu1JXBqWIX0B/kHphiUwqD/ldaJK3kR/jD6BKjbSM+P/UaMVm2SX4FHFdbwmerjb4wzlj8f/21WNVY2SJBXIif5vigsR1u+ml70WT9aEuF4xp5QEG8NMATO5quw1agNhnFkPUGi3NggBVbeBgohc9YwOjQM/cmefj9ap0BGWn4fRHlCMkc59dNCK1VwBtRDC6Enw2QsugksVpbbSFckm9xjgVtiIbIab1SyYvTsonNLCNiFEHVwyu4Onw5g4Jn27v4fLk6UyqiKIxomIA3QedpjbI4T63Lu4fsYC8jO8Bp3E3hJzcbnfzZgw/We7AMGgAaJUd4rLr9nz5oLQep641lqo/NU3Tle/2wdPVR+veGaePH4hDRxWAmjSHqmPaczkuOe8+cnMPkkAei00UujTB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/06/26 1:18 pm, Lance Yang wrote:
> 
> On Thu, Jun 25, 2026 at 11:29:53AM +0000, Dev Jain wrote:
>> check_pte() is the final validation step in page_vma_mapped_walk().
>> It reads pvmw->pte with ptep_get() to decide whether the entry maps
>> the PFN range being walked. For hugetlb VMAs, that pointer refers
>> to a hugetlb entry.
>>
>> On arches which provide their own huge_ptep_get() to dereference a huge
>> pte pointer, accessing via ptep_get() would cause pte_pfn(),
>> pte_present() etc to misbehave.
>>
>> It is not clear whether this has a trivially visible effect to userspace.
>>
>> Use huge_ptep_get() to dereference a huge pte pointer.
>>
>> Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>> mm/page_vma_mapped.c | 8 +++++++-
>> 1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> index 2ccbabfb2cc17..18e1d341f463c 100644
>> --- a/mm/page_vma_mapped.c
>> +++ b/mm/page_vma_mapped.c
>> @@ -107,7 +107,13 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,
>> static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>> {
>> 	unsigned long pfn;
>> -	pte_t ptent = ptep_get(pvmw->pte);
>> +	pte_t ptent;
>> +
>> +	if (is_vm_hugetlb_page(pvmw->vma))
>> +		ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>> +				      pvmw->pte);
> 
> I think check_pte() can pass a wrong address to huge_ptep_get() ...

Won't this be handled by rmap_walk_anon/rmap_walk_file - they are the ones
performing the rmap traversal and passing address to try_to_unmap_one/folio_referenced_one
etc ...

> 
> Not sure that is wrong in the first place. For memory failure,
> page_mapped_in_vma() can be called with a poisoned tail page of a hugetlb
> folio. In that case, pvmw->address need not be hugepage-aligned.
> 
> @Miaohe
> 
> For arm64, CONT_PMD_SIZE is one supported HugeTLB size. With such a VMA,
> page_vma_mapped_walk() passes that size to hugetlb_walk():
> 
> bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> {
> 	...
> 	if (unlikely(is_vm_hugetlb_page(vma))) {
> 		...
> 		pvmw->pte = hugetlb_walk(vma, pvmw->address, size);
> 		...
> 	}
> 	...
> }
> 
> hugetlb_walk() then calls arm64 huge_pte_offset(mm, addr, sz). For
> sz == CONT_PMD_SIZE, huge_pte_offset() aligns its local addr before
> calculating pmdp:
> 
> pte_t *huge_pte_offset(struct mm_struct *mm,
> 		       unsigned long addr, unsigned long sz)
> {
> 	...
> 	if (sz == CONT_PMD_SIZE)
> 		addr &= CONT_PMD_MASK;
> 
> 	pmdp = pmd_offset(pudp, addr);
> 	pmd = READ_ONCE(*pmdp);
> 	...
> }
> 
> So for that case, pvmw->pte is calculated from the aligned addr, not
> necessarily from the original pvmw->address. But check_pte() passes the
> original address together with pvmw->pte:
> 
> +		ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
> +				      pvmw->pte);
> 
> arm64 then uses that addr again to choose ncontig:
> 
> pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
> {
> 	...
> 	ncontig = find_num_contig(mm, addr, ptep, &pgsize);
> 	for (i = 0; i < ncontig; i++, ptep++) {
> 		...
> 	}
> 	return orig_pte;
> }
> 
> static int find_num_contig(struct mm_struct *mm, unsigned long addr,
> 			   pte_t *ptep, size_t *pgsize)
> {
> 	pgd_t *pgdp = pgd_offset(mm, addr);
> 	p4d_t *p4dp;
> 	pud_t *pudp;
> 	pmd_t *pmdp;
> 
> 	*pgsize = PAGE_SIZE;
> 	p4dp = p4d_offset(pgdp, addr);
> 	pudp = pud_offset(p4dp, addr);
> 	pmdp = pmd_offset(pudp, addr);
> 	if ((pte_t *)pmdp == ptep) {
> 		*pgsize = PMD_SIZE;
> 		return CONT_PMDS;
> 	}
> 	return CONT_PTES;
> }
> 
> With a tail address, pmdp may no longer point at pvmw->pte, so
> find_num_contig() can return CONT_PTES for a CONT_PMD HugeTLB mapping.
> 
> On 16K arm64, that changes ncontig from 32 to 128. So huge_ptep_get()
> can walk past the CONT_PMD entries, and possibly past the PMD table.
> 
> Should check_pte() pass the address matching pvmw->pte, sth like:
> 
> ---8<---
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index 406fd50bbd8f..58463493bd3d 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -109,11 +109,14 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>  	unsigned long pfn;
>  	pte_t ptent;
> 
> -	if (is_vm_hugetlb_page(pvmw->vma))
> -		ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
> -				      pvmw->pte);
> -	else
> +	if (is_vm_hugetlb_page(pvmw->vma)) {
> +		struct hstate *hstate = hstate_vma(pvmw->vma);
> +		unsigned long haddr = pvmw->address & huge_page_mask(hstate);
> +
> +		ptent = huge_ptep_get(pvmw->vma->vm_mm, haddr, pvmw->pte);
> +	} else {
>  		ptent = ptep_get(pvmw->pte);
> +	}
> 
>  	if (pvmw->flags & PVMW_MIGRATION) {
>  		const softleaf_t entry = softleaf_from_pte(ptent);
> --
> 
> while leaving pvmw->address unchanged for page_mapped_in_vma()?
> 
> Cheers, Lance
> 
>> +	else
>> +		ptent = ptep_get(pvmw->pte);
>>
>> 	if (pvmw->flags & PVMW_MIGRATION) {
>> 		const softleaf_t entry = softleaf_from_pte(ptent);
>> -- 
>> 2.43.0
>>
>>


