Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A13C4CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7703C6B0093; Fri, 26 Jun 2026 05:14:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747ED6B009E; Fri, 26 Jun 2026 05:14:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684736B009F; Fri, 26 Jun 2026 05:14:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FCFE6B0093
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:14:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CDD1E1A03B9
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:14:41 +0000 (UTC)
X-FDA: 84921503562.30.3E07EAE
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8A11EC0002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:14:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T7Moi+hM;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782465280;
	b=E8EDt2yt7Ggv2lOSr2y3nEdd5UYkBueCAxVt2pU/fUQfLn+198VJq0QCnqIEGDcXUk8xqF
	Keow0U2z7LygFeWacISWGozJkIH4E55wFfkICco55cXt1Al/VAl1TR0okmk4XVFUXqnZ/z
	w+aUHPigZvy9xOh8R1sv188Or791jis=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782465280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGkNXoDW7vkQPBFhvgku7f4WZ/LdspfionMDkNs4wus=;
	b=akiaPv7S8ffNHIA1E07hl3F/NuFltM1Zf3qXk1i/kcuqKQKyI/X19HHGPIsBRa6r7Y5MT1
	XtTaNHAS1xuJW8jv9tJYkMeDtX3NDY2CTR5L412Foy34bPqRzKuvRKdi95L1QIt6h2tkIT
	br1L28sKnmkQHzpvR1d6CTmvY7AXNtY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T7Moi+hM;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <6adeecc1-7204-4d2b-8381-45e13633be57@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782465275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wGkNXoDW7vkQPBFhvgku7f4WZ/LdspfionMDkNs4wus=;
	b=T7Moi+hM7BpfWhMpIMJR9KVAP0rdMWWq1CBE6ZzZhxMG6sqFmMpykRL2sHculkidiIlFhD
	aVrhifHc069IM7bStV5KZT3EheUxNmdM+QPc4fhmjhzNIj3+Ii7AeTez66Q0mZwiZMWXsw
	iqz+Mz1SHIRdfvtcxiXwpqAmVY9TigY=
Date: Fri, 26 Jun 2026 17:14:12 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] mm/page_vma_mapped: use huge_ptep_get() for hugetlb
Content-Language: en-US
To: dev.jain@arm.com, linmiaohe@huawei.com
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260626074855.97652-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: htwafa8xehd8xu1zxuqesdgiz43wor54
X-Rspamd-Queue-Id: 8A11EC0002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782465277-946032
X-HE-Meta: U2FsdGVkX1/Owm34PwD4LnI6pywL6mIabNhUxP+Ax5dpSajcRuA5Ua3IPtewIlbB5Mk/ryxVblKHOkB9lWVxlGAuM6I+ax9zeNhZfQ3HKnk50fjM3+sfyOiOmX1TMg5HAhwBnfVeOoBhlaciX1LGMeYfbcAAfoR9HCqLpMlMCP1iYevJXDQQW3GzEviRBXzSlsPa7Yl31pGimdBon+8NIjGbB1WgBPFZHtOGA+K10PgMTlDkzOfXqfZO1DIwTzCMr2nJTy893bAvbljeVN8LVj8M3bAmUzTL6Rx8xGXUks3smFk44fJ9tK8/WxNXi61bPngKr6fwvwjzJAtd2ipAXx9zJ+KXGPC1UL2qDw+roi1Rmbh0jtYiiT3bDP1FoqcSTSeRyAYOcVx3NhMVuOuMp+QJrH2Gl4f3KLiPm5WY/72BTCfqi2QTWyFLLSFu4FciGITjXwhaluuIq2lvZZTYPII+q42emfAmQEAro8bsdeCDKfhXLs59KCfNKRgKMcfizqiR3Ekgne02HPZiIJTPauZ6ejIHRC//GmZnjhmlfVedgDzPi62Ddgd8SwrPOr/fA/c73iD+kCMpDLVcHW74Cxz+BY3T11H9lqaFAO9AbEJ+/O89Lt0A/hd43ezt7larzNRKZV3LOu3TtsLxrlkZ0Z9+g9o3Cfu5Ivxf5lfjaQLoJUuu2ykJRtLGSoVr1Fyl9HixF9YnaN84bQpHP9v5azeIspO0Qy8NcYZ66Uxw2giWeaqAXYeADpT01Jf2mFJTEqt/enM7L8zfUTz1jWEZT/9M6lOLffCDD6mZB/fI2E80SauglF4vPjI/ne7CquHtiRVUR0gVojssJnUTP7T8oP0vERDWcR/3Ak8L5Xgu26IL5wLEg0DYdmEeKFjRfIQXrWkLLDDCOiSiw6XJt9DBG4GC/hWk25YBEzC6hoIWuCVC/IbB+HXikHtElKQGEw/aocHOE6H48Re03u2S97D
 SbDfXFbd
 2wTqrEA1unlvZW6zJKvTs+dNlzwVn7mo/QwtBsS4cGrqr8S7WTMmaHZ0WyLoJBH5MYfN9lb8+HgV/xujyBx0eA2wyCndCrgMHMnGSem2cqeCZr0SrNy/43I5Co3V6KgaHjKsCxPfyuQHfDdU0NDWRnB+RWY5+VtAmabyTbrxP8sOM/YW+cI4GnqCbj83rxGOPPzPxn5MJBmtIReM5TTFHxbVGzkyJFiRj7Db3Hzvg37wVfr1sNfEnUTIHXxrsp63qVK7gCJbEZRdZOMTq+lirUPfQtQ6DhB4r4arqdVyzXHO626sujIYyFSsi1erlDj8/b7zo0ktOZ6MhxwBSSIv0RiSDEJyPp/vdfmY4ns0mQdKqiaF4g1GH68mNBgcjqv8sKwoWLKEWkBYRLigMijgS0p3UT4+dZwq0rSpx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/26 15:48, Lance Yang wrote:
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

In addition:

Went through all arch code that has its own huge_ptep_get(); only
arm64 and powerpc actually use addr, and there addr has to match the
ptep, IIUC.

So I am wondering whether all huge_ptep_get() callers satisfy that
requirement.

Cheers, Lance

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
>   	unsigned long pfn;
>   	pte_t ptent;
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
>   		ptent = ptep_get(pvmw->pte);
> +	}
> 
>   	if (pvmw->flags & PVMW_MIGRATION) {
>   		const softleaf_t entry = softleaf_from_pte(ptent);
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


