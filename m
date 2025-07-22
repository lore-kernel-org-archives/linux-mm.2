Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D2DC83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 11:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98C716B00A9; Tue, 22 Jul 2025 07:26:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D286B00AA; Tue, 22 Jul 2025 07:26:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87A706B00AB; Tue, 22 Jul 2025 07:26:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 794BF6B00A9
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:26:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 26008130B35
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:26:15 +0000 (UTC)
X-FDA: 83691671910.28.6E09980
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 70A9740007
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:26:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753183573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PglEKky0Wq+mNsm8+6+40YWPaya7WhWv4c9+SwC7MWI=;
	b=QUIywmi9u0w1zcX9Nv604HefQler1GJkW2Ueler4D+7PAkR+8vXSvXkPGbUZdcuhSZuukI
	+Nzp+u58fb167wS0vymNUBOMUWdN9BnUlVHZ5xqv/dArnGAlvvVhdsRzec0a8WJn71soCk
	UZfJBA8yJjWGL+OwJQD6kGffpgjQa1w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753183573; a=rsa-sha256;
	cv=none;
	b=1Gj/finj9fXhN/bIRFfOuyqNL/B1AIBe70z3uvyzkrJTY1bD+0QvtAWLhsxRvwpgh1USEF
	uYB4Hv380tHFQEZW/dDKXEhPLbU9junIu7uzIOw53VfQeCXdiFAWzasFv99n774rjdyDqO
	RLE6C8AN0dMAxUvStmgevmHQ8mtoLt4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5BE64152B;
	Tue, 22 Jul 2025 04:26:07 -0700 (PDT)
Received: from [10.1.30.167] (XHFQ2J9959.cambridge.arm.com [10.1.30.167])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD9293F66E;
	Tue, 22 Jul 2025 04:26:09 -0700 (PDT)
Message-ID: <3b105623-95c2-4d4b-b49f-dd087eaa652b@arm.com>
Date: Tue, 22 Jul 2025 12:26:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/7] mm: Optimize mprotect() for MM_CP_PROT_NUMA by
 batch-skipping PTEs
Content-Language: en-GB
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org
Cc: david@redhat.com, willy@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, vbabka@suse.cz,
 jannh@google.com, anshuman.khandual@arm.com, peterx@redhat.com,
 joey.gouly@arm.com, ioworker0@gmail.com, baohua@kernel.org,
 kevin.brodsky@arm.com, quic_zhenhuah@quicinc.com,
 christophe.leroy@csgroup.eu, yangyicong@hisilicon.com,
 linux-arm-kernel@lists.infradead.org, hughd@google.com,
 yang@os.amperecomputing.com, ziy@nvidia.com
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-3-dev.jain@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20250718090244.21092-3-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 70A9740007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ysn93w9qmo6sg9n6pco5npixt8i4hgpn
X-HE-Tag: 1753183573-395179
X-HE-Meta: U2FsdGVkX197D+cJeOCw4Fiy4GZzNrZhcA26C2b2AkmCgymT1MiL+sI7M6z3jHTVlfyjkdGFf0SGVPqdpG5UMZKQK6+RUSrYt8fDkrdlIlVtBdElKPdYpDWHtEPKs+oJO+aplVWCRbTQw+p+/dT6mV/rTgcOsM7vfB79I3IyGhM1Dx18P8jAoiSBeIpiK21/P3EeDBwjVW5z8p/H7Y7LcFrWnNW4319PPXEArvrJ9gUqn4su7sB5Qvfh1w7/IApNSB6ajsxzn+1CmYAm8fmBl+h0Rx2z+6QVsTjZASB6SPL0fywgNJIPG4369DkmK8uHpI6wFZZjs8nNwW2JICagdHfLxZ7/DnaWLw4XGRo7CKCEgqnFZp88RGSXZl0DQDgO3quJmjvYW5syDJROXXf5EX+spLBsQeebmX06cgGlJSPNByhjYCASgwXwdBwefTv2/z8IY0b01ye3zjekrDFL/WnYNLxGYaD9g806Z945GHe/luEyGVAVLKBq4ylq6YQ4yj5NoylU5x7Tmukx4qlkKw8k+RGylo/d2NBqfkloL7tuU4dSV14gRIcGIICSTxXAl+X8XqGaKewb/X5Qstck2y6dAdHD+vTcKmi5aV3cxt2wXiHLsix++NyzSLKPHb1djAka/eQo/E2G/unqNZtNXaJwkwHuSWueopax+VQRG34zrIlCaaRdHy9r3BXywu0L1NJJSC3dPRaFIoIf4mXByn/xRCI17LWqpZ+IIpX22N9eRF3dLZH4aejxJRzYU4Ztg4aUaKA+pMbuzwLFy75iKMIyUrsdx9CoU3lRMBPymP88Qvo4Cy3T5XEYVbN0d7SbFAKCZ6TVGQ6jVlY7vq93IE0WfijKSCn/qLTW/NzG9y4KzN3fSk8ac9j2zQ/8C9hZHqJu8bZbVfGIxJ6I8IkIJyGNaLRhYmWJuN3sEr5b70HQN5kpI7T3kgtAzMiBKxH7tAnrs/+T/bTrXYLmlGW
 yqUNUfRT
 0hYoltBUKyxl7tzO082BNeVqNY/QZF0rckBQNmeVp9xL/nelQs5Hk6fsZmsPFP3Zz20Usq4XkUH7Oui7sA2HwvHtHW6/DMhZrTqX5iZmL80SPPLFncvBp7iUIXLPMRCN6LCrwL98A63ZliShn1DHWDcQUY3k3lhi8+/kbXItfgVqxtYogTofpfSknk4JzKleIxixJh1JEsAFbpyeQ3jR+paFNWAH/eyMp0X+TyA0ZZVyDuzWJK/lEA+WxpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/07/2025 10:02, Dev Jain wrote:
> For the MM_CP_PROT_NUMA skipping case, observe that, if we skip an
> iteration due to the underlying folio satisfying any of the skip
> conditions, then for all subsequent ptes which map the same folio, the
> iteration will be skipped for them too. Therefore, we can optimize
> by using folio_pte_batch() to batch skip the iterations.
> 
> Use prot_numa_skip() introduced in the previous patch to determine whether
> we need to skip the iteration. Change its signature to have a double
> pointer to a folio, which will be used by mprotect_folio_pte_batch() to
> determine the number of iterations we can safely skip.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>

LGTM:

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  mm/mprotect.c | 55 +++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 42 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 2a9c73bd0778..97adc62c50ab 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -83,28 +83,43 @@ bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
>  	return pte_dirty(pte);
>  }
>  
> +static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
> +				    pte_t pte, int max_nr_ptes)
> +{
> +	/* No underlying folio, so cannot batch */
> +	if (!folio)
> +		return 1;
> +
> +	if (!folio_test_large(folio))
> +		return 1;
> +
> +	return folio_pte_batch(folio, ptep, pte, max_nr_ptes);
> +}
> +
>  static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
> -			   pte_t oldpte, pte_t *pte, int target_node)
> +			   pte_t oldpte, pte_t *pte, int target_node,
> +			   struct folio **foliop)
>  {
> -	struct folio *folio;
> +	struct folio *folio = NULL;
> +	bool ret = true;
>  	bool toptier;
>  	int nid;
>  
>  	/* Avoid TLB flush if possible */
>  	if (pte_protnone(oldpte))
> -		return true;
> +		goto skip;
>  
>  	folio = vm_normal_folio(vma, addr, oldpte);
>  	if (!folio)
> -		return true;
> +		goto skip;
>  
>  	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
> -		return true;
> +		goto skip;
>  
>  	/* Also skip shared copy-on-write pages */
>  	if (is_cow_mapping(vma->vm_flags) &&
>  	    (folio_maybe_dma_pinned(folio) || folio_maybe_mapped_shared(folio)))
> -		return true;
> +		goto skip;
>  
>  	/*
>  	 * While migration can move some dirty pages,
> @@ -112,7 +127,7 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
>  	 * context.
>  	 */
>  	if (folio_is_file_lru(folio) && folio_test_dirty(folio))
> -		return true;
> +		goto skip;
>  
>  	/*
>  	 * Don't mess with PTEs if page is already on the node
> @@ -120,7 +135,7 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
>  	 */
>  	nid = folio_nid(folio);
>  	if (target_node == nid)
> -		return true;
> +		goto skip;
>  
>  	toptier = node_is_toptier(nid);
>  
> @@ -129,11 +144,15 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
>  	 * balancing is disabled
>  	 */
>  	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) && toptier)
> -		return true;
> +		goto skip;
>  
> +	ret = false;
>  	if (folio_use_access_time(folio))
>  		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
> -	return false;
> +
> +skip:
> +	*foliop = folio;
> +	return ret;
>  }
>  
>  static long change_pte_range(struct mmu_gather *tlb,
> @@ -147,6 +166,7 @@ static long change_pte_range(struct mmu_gather *tlb,
>  	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
>  	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
>  	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
> +	int nr_ptes;
>  
>  	tlb_change_page_size(tlb, PAGE_SIZE);
>  	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> @@ -161,8 +181,11 @@ static long change_pte_range(struct mmu_gather *tlb,
>  	flush_tlb_batched_pending(vma->vm_mm);
>  	arch_enter_lazy_mmu_mode();
>  	do {
> +		nr_ptes = 1;
>  		oldpte = ptep_get(pte);
>  		if (pte_present(oldpte)) {
> +			int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
> +			struct folio *folio;
>  			pte_t ptent;
>  
>  			/*
> @@ -170,9 +193,15 @@ static long change_pte_range(struct mmu_gather *tlb,
>  			 * pages. See similar comment in change_huge_pmd.
>  			 */
>  			if (prot_numa) {
> -				if (prot_numa_skip(vma, addr, oldpte, pte,
> -						   target_node))
> +				int ret = prot_numa_skip(vma, addr, oldpte, pte,
> +							 target_node, &folio);
> +				if (ret) {
> +
> +					/* determine batch to skip */
> +					nr_ptes = mprotect_folio_pte_batch(folio,
> +						  pte, oldpte, max_nr_ptes);
>  					continue;
> +				}
>  			}
>  
>  			oldpte = ptep_modify_prot_start(vma, addr, pte);
> @@ -289,7 +318,7 @@ static long change_pte_range(struct mmu_gather *tlb,
>  				pages++;
>  			}
>  		}
> -	} while (pte++, addr += PAGE_SIZE, addr != end);
> +	} while (pte += nr_ptes, addr += nr_ptes * PAGE_SIZE, addr != end);
>  	arch_leave_lazy_mmu_mode();
>  	pte_unmap_unlock(pte - 1, ptl);
>  


