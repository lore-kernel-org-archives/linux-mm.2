Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ECBCCAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 04:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82DB78E0003; Sat, 20 Sep 2025 00:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DE248E0001; Sat, 20 Sep 2025 00:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CCC48E0003; Sat, 20 Sep 2025 00:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 587FE8E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 00:31:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DD0D511B051
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 04:31:03 +0000 (UTC)
X-FDA: 83908353606.17.8DF80D4
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf07.hostedemail.com (Postfix) with ESMTP id B573740002
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 04:31:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QVtNtYe2;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758342662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sIzDrxTT/PlsUo0WXoDh3v/RmpMjmuDZFpujOAdnjAE=;
	b=tluunrxBqfvsYfqMtOgjSggHXz2Sq8ToL5ko/JC3O81qzYruEO6/M4R6Yt4bnWBqR+E06e
	DjORSq6R/nE6cHnq3dUefk+01QYZWpMEyzmVIvQ1Sc4BpjV8e36vkvX0vef+7ddB4O+yvz
	nq09+JA6GzOsgH9xKXS1+6BFRJpeNqU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QVtNtYe2;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758342662; a=rsa-sha256;
	cv=none;
	b=J9T9nVjyCoH9uNjL0Mtiv7Gt9kt07ObvKXQ01fnGZtjJz922ll1jZAQrc/Qp6tAisaQQ+3
	1uDY99LpNZfXHIqo+aikbG4QplQbnWc+Mf6O78Vj4mdH69okvpZDjMbh/Khd50ZtvGzdLe
	u80NbXe/r3ZbBTnAmy6urqyQavqOJjg=
Message-ID: <b1a8925b-8bb6-43b2-81e8-abb377905d48@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758342659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sIzDrxTT/PlsUo0WXoDh3v/RmpMjmuDZFpujOAdnjAE=;
	b=QVtNtYe2iAu8rErs3nYsX4pUNuU/hHdPPNwei0NQYpU6ChNFDW33l/S3wIWgvCDPAmPHpr
	wm1YGWmPMZK5Qvip+nhi50fXSHk6uQyPPGsC8v/oLdudqUEFVu0IpRRI6birBeccPIptRB
	PLt2GRo0jmj5qq0Yy5dpWiXaSvBuwJk=
Date: Sat, 20 Sep 2025 12:30:52 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/khugepaged: use [pmd|pte]_addr for better reading
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, lorenzo.stoakes@oracle.com, baohua@kernel.org,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, dev.jain@arm.com,
 david@redhat.com, npache@redhat.com, ziy@nvidia.com,
 akpm@linux-foundation.org, baolin.wang@linux.alibaba.com
References: <20250920005416.5865-1-richard.weiyang@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20250920005416.5865-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B573740002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: drotihppfuw3tfz4octrko8ame6pw83a
X-HE-Tag: 1758342661-319922
X-HE-Meta: U2FsdGVkX1+PI+N2NGMPzB9iikibThnFBxQ3LB5Zt5RJ7W4LF6k34qi0RCgG7sNyv+W25f0THAUWsoDpTHJzpMUFMe+2BVDD3Z366GAtV7NYEFttqdgdYTyqVLHASl9zCRs8SCNL+GJTpGAgGZv40OrT/u4GK/SV7Wta2hRp6dzfMRRzWeepXsDuj5SaMrX1VP+GQpgwnzOa3bgSjuU1bj5KT1kYO7AkkBXoAMjSwqY9iZxeFBgtBHlNzl/7YMjDHAJtyYvqSO+BAFYz0m7tRCxCou9UrzVobVsjRzXZb6oQgwT0zev9gCcRhjmyIo0npg8mJ/9DrtilQ+aIs1IUWsTzTpB1mS4KddRFq5WOn57nRCBaE+idro6uBaNr8PgQH2/p7Zk00xoyJwJEMUNP403z4wsZZpo2NyRia1Dh18chJ1d1su2yYvGpm1Lh/5+aXC/5i9oZFubPhD0LdFwL81UG0Htv5d9Sm8NmlTmRH/hgi/z25D0rPhFU4bQ6jGOu9yu+/RUQ8CuWHgZ42kJuP7Xa0JUIQf8nhGFY3andR+X7flcV6v6zCnls2ulpzhPw3N+PcsIFkoZ6kfO+PbK4oBcFFl7ahgEcL4Q5PUGO0gBcWX2gGoMsmMUJJWSG7IKYa5N4QthTbMjodDjA+VyPZJ1hbzD/XRBfx52hNfbgp7JKEU7bJfjhmePSG4m1UYdXmHLCMCAEuxwwVNBoxfxk/3EuTeb3xujOM7oWuvd5kllOavrzkdA/QpfZglIeKnygf0DauVWQXm9BOkuGa0RGCl8TVPh5Np+yy9i5IxQrd4UaDH9cg/0M8SpwUd+KM+Bx5B0PtzSBdmfbiVZlAI5sRQypxPkxBs7Rbe7nzDr4UuTz55kq1E159pvODXwDe5LMHdjVmFU0mzdffNZTRWgycFmyYnTLiKXIg40uS+vnhhcK716jZBkbGavbEScacQlR2qlXnSL0HOorjZrCDzH
 GYytvXSF
 BJh4lDifvReLWPfcZMjARzIAHQK6HQfYzyVM+4e0QY4KBjKAME7ZjkPVOZZMcW/8LCwD1Uaigq5de+KZE2aW6vu3hl7R2ONlxa55uHaQT5NxVGZalWCt2ZUxrnB5rXcLDGc0YaeqsLFw17324mdvYs7C0HZgkzGk7RW6OOvs1Iv8ZKlVx1r/SS4MZc5jgFmYiS0jNc+tzEsEsJU1AFKgUMANq/0/CxFd4wJD0nZXrHV4W0wYHraq9oENWWz7a28MSbBEu3B//UMMHJl7nUKHXJsGK2mgAnt4cBsaDOIAVW06O/JYSYLiteJBIl23pqOXx9kgvw7Ki6vHSCjdiSsewprAGz15793NSOQjRm07q87e2x9oqRubyPL56ZaHf6KFqmZnPxyb5+rFktRKd5cFtphkZ7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2025/9/20 08:54, Wei Yang wrote:
> When collapse a pmd, there are two address in use:
> 
>    * address points to the start of pmd
>    * address points to each individual page
> 
> Current naming is not easy to distinguish these two and error prone.
> 
> Name the first one to pmd_addr and second one to pte_addr.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Suggested-by: David Hildenbrand <david@redhat.com>

This renaming makes the code much easier to follow, but just
some minor style nits below :)

Acked-by: Lance Yang <lance.yang@linux.dev>

> ---
>   mm/khugepaged.c | 43 ++++++++++++++++++++++---------------------
>   1 file changed, 22 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4c957ce788d1..6d03072c1a92 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -537,18 +537,19 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>   }
>   
>   static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
> -					unsigned long address,
> +					unsigned long pmd_addr,
>   					pte_t *pte,
>   					struct collapse_control *cc,
>   					struct list_head *compound_pagelist)
>   {
>   	struct page *page = NULL;
>   	struct folio *folio = NULL;
> +	unsigned long pte_addr = pmd_addr;
>   	pte_t *_pte;
>   	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;

Nit: could we refactor this block into the "reverse christmas tree" style?

>   
>   	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
> -	     _pte++, address += PAGE_SIZE) {
> +	     _pte++, pte_addr += PAGE_SIZE) {
>   		pte_t pteval = ptep_get(_pte);
>   		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>   			++none_or_zero;
> @@ -570,7 +571,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>   			result = SCAN_PTE_UFFD_WP;
>   			goto out;
>   		}
> -		page = vm_normal_page(vma, address, pteval);
> +		page = vm_normal_page(vma, pte_addr, pteval);
>   		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
>   			result = SCAN_PAGE_NULL;
>   			goto out;
> @@ -655,8 +656,8 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>   		 */
>   		if (cc->is_khugepaged &&
>   		    (pte_young(pteval) || folio_test_young(folio) ||
> -		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
> -								     address)))
> +		     folio_test_referenced(folio) ||
> +		     mmu_notifier_test_young(vma->vm_mm, pte_addr)))
>   			referenced++;
>   	}
>   
> @@ -985,21 +986,21 @@ static int check_pmd_still_valid(struct mm_struct *mm,
>    */
>   static int __collapse_huge_page_swapin(struct mm_struct *mm,
>   				       struct vm_area_struct *vma,
> -				       unsigned long haddr, pmd_t *pmd,
> +				       unsigned long pmd_addr, pmd_t *pmd,
>   				       int referenced)
>   {
>   	int swapped_in = 0;
>   	vm_fault_t ret = 0;
> -	unsigned long address, end = haddr + (HPAGE_PMD_NR * PAGE_SIZE);
> +	unsigned long pte_addr, end = pmd_addr + (HPAGE_PMD_NR * PAGE_SIZE);
>   	int result;
>   	pte_t *pte = NULL;
>   	spinlock_t *ptl;

Same nit as above.

>   
> -	for (address = haddr; address < end; address += PAGE_SIZE) {
> +	for (pte_addr = pmd_addr; pte_addr < end; pte_addr += PAGE_SIZE) {
>   		struct vm_fault vmf = {
>   			.vma = vma,
> -			.address = address,
> -			.pgoff = linear_page_index(vma, address),
> +			.address = pte_addr,
> +			.pgoff = linear_page_index(vma, pte_addr),
>   			.flags = FAULT_FLAG_ALLOW_RETRY,
>   			.pmd = pmd,
>   		};
> @@ -1009,7 +1010,7 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
>   			 * Here the ptl is only used to check pte_same() in
>   			 * do_swap_page(), so readonly version is enough.
>   			 */
> -			pte = pte_offset_map_ro_nolock(mm, pmd, address, &ptl);
> +			pte = pte_offset_map_ro_nolock(mm, pmd, pte_addr, &ptl);
>   			if (!pte) {
>   				mmap_read_unlock(mm);
>   				result = SCAN_PMD_NULL;
> @@ -1252,7 +1253,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>   
>   static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>   				   struct vm_area_struct *vma,
> -				   unsigned long address, bool *mmap_locked,
> +				   unsigned long pmd_addr, bool *mmap_locked,
>   				   struct collapse_control *cc)
>   {
>   	pmd_t *pmd;
> @@ -1261,26 +1262,26 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>   	int none_or_zero = 0, shared = 0;
>   	struct page *page = NULL;
>   	struct folio *folio = NULL;
> -	unsigned long _address;
> +	unsigned long pte_addr;
>   	spinlock_t *ptl;
>   	int node = NUMA_NO_NODE, unmapped = 0;

Ditto.

>   
> -	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> +	VM_BUG_ON(pmd_addr & ~HPAGE_PMD_MASK);
>   
> -	result = find_pmd_or_thp_or_none(mm, address, &pmd);
> +	result = find_pmd_or_thp_or_none(mm, pmd_addr, &pmd);
>   	if (result != SCAN_SUCCEED)
>   		goto out;
>   
>   	memset(cc->node_load, 0, sizeof(cc->node_load));
>   	nodes_clear(cc->alloc_nmask);
> -	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
> +	pte = pte_offset_map_lock(mm, pmd, pmd_addr, &ptl);
>   	if (!pte) {
>   		result = SCAN_PMD_NULL;
>   		goto out;
>   	}
>   
> -	for (_address = address, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> -	     _pte++, _address += PAGE_SIZE) {
> +	for (pte_addr = pmd_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> +	     _pte++, pte_addr += PAGE_SIZE) {
>   		pte_t pteval = ptep_get(_pte);
>   		if (is_swap_pte(pteval)) {
>   			++unmapped;
> @@ -1328,7 +1329,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>   			goto out_unmap;
>   		}
>   
> -		page = vm_normal_page(vma, _address, pteval);
> +		page = vm_normal_page(vma, pte_addr, pteval);
>   		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
>   			result = SCAN_PAGE_NULL;
>   			goto out_unmap;
> @@ -1397,7 +1398,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>   		if (cc->is_khugepaged &&
>   		    (pte_young(pteval) || folio_test_young(folio) ||
>   		     folio_test_referenced(folio) ||
> -		     mmu_notifier_test_young(vma->vm_mm, _address)))
> +		     mmu_notifier_test_young(vma->vm_mm, pte_addr)))
>   			referenced++;
>   	}
>   	if (cc->is_khugepaged &&
> @@ -1410,7 +1411,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>   out_unmap:
>   	pte_unmap_unlock(pte, ptl);
>   	if (result == SCAN_SUCCEED) {
> -		result = collapse_huge_page(mm, address, referenced,
> +		result = collapse_huge_page(mm, pmd_addr, referenced,
>   					    unmapped, cc);
>   		/* collapse_huge_page will return with the mmap_lock released */
>   		*mmap_locked = false;


