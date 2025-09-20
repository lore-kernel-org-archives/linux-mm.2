Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65D40CAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 04:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7F98E0006; Sat, 20 Sep 2025 00:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A58BD8E0001; Sat, 20 Sep 2025 00:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 995DE8E0006; Sat, 20 Sep 2025 00:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8A3348E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 00:52:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 17A561DFCD7
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 04:52:07 +0000 (UTC)
X-FDA: 83908406694.04.447C31C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id BEB9D40005
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 04:52:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758343925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jcuGk6JLs/vKNVABa4HL+wPHu7Dn7CNSVTOhIaNCUsU=;
	b=LZ7DK137PGVas1ohLQOR7sxH20sWMiv+PU0zfiNqRpVH4c9++kh2un1o6u4x4ggqx/o+J3
	u0MZyUeViMTWSdOmZTu1Wgr0gzEO4n9a0Hxhrh/GRyqfz1AN5RthldkBglkr0hBilKcR7n
	2EHHR2dDELcBRRsHISc0y6sjUTc+rFk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758343925; a=rsa-sha256;
	cv=none;
	b=LhLb6PtZMYBBJ7MRjKhRzVisAyV83U4DKaO8ttsfEwDKnFeJ6BWtz5izuVFIA7b2YRJqFQ
	+nY6g5MeQKvlTnNDZ8KybrobOJVt+/vBXFYn44Cf3HV922eGRpWBjsVrxEZUowmi3ZLcf/
	16CUAURvgMokYUARgnCn6Eusk8c6eDk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 81D951688;
	Fri, 19 Sep 2025 21:51:55 -0700 (PDT)
Received: from [10.163.75.121] (unknown [10.163.75.121])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 83E833F673;
	Fri, 19 Sep 2025 21:51:59 -0700 (PDT)
Message-ID: <4fb37530-3826-4ff5-ad7a-dc9dac4937de@arm.com>
Date: Sat, 20 Sep 2025 10:21:56 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: use [pmd|pte]_addr for better reading
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20250920005416.5865-1-richard.weiyang@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250920005416.5865-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 68zr659h6h6j3ehf35dcrdw4ayk3n3id
X-Rspam-User: 
X-Rspamd-Queue-Id: BEB9D40005
X-Rspamd-Server: rspam10
X-HE-Tag: 1758343924-852851
X-HE-Meta: U2FsdGVkX1/lmdzu9hpF9UCN9yuFjlXEcf2iFmi2MUlcu6TAv0PdnVn61julOBGL2BCeUAzS/GD4ALYAsLL5tirIzHJ0NZvoWtpqiheI9vpYq3rbE5lZ0s2ztQpj+33IjM6SjqHGpuEY1IVMWm94CsJkaonA9CAclOM/bCQtqe0oV1rIBbiglvcDMpNBYdq171q57x6K+s/2xLBFSwXT/HNVHdbtT8+BLMo4SVIPCfI586TifjSyL/gW2GMv4nZ1yVAszySV2p5d/tSWwX7X1RE0tNs3ZWZOTrqCYiXz4Pcv+mrZ5DslP5oYku4apip68rrgy+v+yiJ3el0Pz7SWOiCX6DIC1d4Zm8eJ5l3N9b05OcIXQScIh2UtUmkhxsVX+9nHHYz4RVNFsrTORkRaHBxPNExiEWO2VdLJQjpurPDJL6MC++AvMSI4pqeUzklzy+4HQsjcpZ9YgZNhx0FsXp6eRavHkshJZMkHdW6cdK8elI3yJgb5u+OShl6v4FCX59AHoJRIfsj7y0I7rD8sbirZoGJ9royBqDBGEG61HPOJdO9vBpwuO7eT5k4OsSC1K+nltOzhlV+B6LjImXNdddIrv9wMiuipewc0ZgU7d5DgowE7OKNXY6a9IclDkOZiW7fD8MlkrkLP6VmI+vuL5BolNEIaFNa5h3Fo99VJY1eBMGVGIsNDk5fPuMuU+7ptC8B6Cq8okXvj4N1xruDpKyOmeHB5gH9VfQ26O9HAZSUPzMYUrjT2IxNEjUxhNpLgi9cE1VDOe1N55fBUBr5gvFOWjyMmF2JCMjRsoW/Z2MUn+kpQcARsFX/nfCoe69ZxIoeNYCXPxe1NnLgdnQj5ZyeqaP0tcxjAlXHxZX+noTBnr0orZNrqP3sW1Gd7CnQUeUCfv0bYRO0fy9ZUOFub02Awompx5KK+ANqTJbtu535PFBkpmm0KRflKKMH9+AMjM0UM7JethhETz7DqeNt
 pxhT4jG6
 Se0z8GE/vkVX1sM7pwedxPzTJY0PunXwYuypeT0mHmIoO6u9wx22wk7TF3Fzf4w7CgPCjJvGgLXbacpICmmgSkBL4755E60+n7yjzCEGG4w95GJiTjDBMFNNiD044PiUDydF0z6pfYzanA1ekI2Q7Fh4aU3+KY0ID8CdPCwLfSBD8c0+EcetAZzN8q46x8hR0C9A7ipxLl3FVVh/TUVC8thXf/Ir9B08oGSL3anZU9Tkn7s4K8b1vKvYDclwtHDvV0weZXfnIjIhAKLQpoLgRbZslKGko2fw1OHdOBbOIzVsKEB4b61sdZzaqSBswm+rWrzr7l+8HNhZGJ7K3LgnIJutcpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20/09/25 6:24 am, Wei Yang wrote:
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

Will this be a problem when mTHP collapse is in? You may have the starting
address lying in the PTE table.

Personally "haddr" is pretty clear to me - I read it as "huge-aligned addr".
I will vote for naming the starting addresses everywhere as "haddr", and use
addr as the loop iterator. This is a short name and haddr will imply that it
is aligned to the huge order we are collapsing for.

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

Here we can change the address parameter of hpage_collapse_scan_pmd to
haddr and _address to addr. And so on.

>   	spinlock_t *ptl;
>   	int node = NUMA_NO_NODE, unmapped = 0;
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

