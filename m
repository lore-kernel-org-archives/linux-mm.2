Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67386CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 06:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 853966B008C; Wed, 14 Oct 2026 02:04:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803966B0092; Wed, 14 Oct 2026 02:04:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2FC6B0095; Wed, 14 Oct 2026 02:04:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3006B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:04:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48FEA1C289D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:03:59 +0000 (UTC)
X-FDA: 85320190998.14.30E7A4B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2A9F940007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:03:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NGFOsBqQ;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791957837;
	b=NQsHnLHPg8ZMxg8LRVfOZ6tSYPMriufNXV7ZYTkSuzEkv6zRvjNnUC94pAn6rCNSU8OVTY
	XMiyi7rDnjJeWW0oRNoAqpYVvZ3MANsderQ2GqCq6IJ6PUcnU3CB4AOXJT1Yh97a7YJoM/
	mhe6bynfLPXj/IRjQrAuavQ58ZE07tc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NGFOsBqQ;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791957837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESeptom+XdILDBZ1SV9z+qsZLUlrAdxL/MtsJa3zQY8=;
	b=PY7VRL6qYzQ4mgpGKo9GunNVNWsG4ouSQ5yjM87GfzAKnDahu97jM+49yLPwlmWoCGMT/i
	Cquu/9unAce1BpG05NYaYAg5X2LY19z+ndjvDJUkwU69JfprsWwSYixOLRxLr+Fd0TUm/x
	ZOwp6pcI4KgSbDlYcIdm/BuWvxbP3Tk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98CEA15A1;
	Tue, 13 Oct 2026 23:03:52 -0700 (PDT)
Received: from [10.164.19.62] (unknown [10.164.19.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6D3F03F7B4;
	Tue, 13 Oct 2026 23:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791957835; bh=a+ePuoScWznFCdZL7kuuIwctTxuRzsdaAnI868FjqvY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NGFOsBqQlkYzYRc6c9oeI62OwONXctPXAWs1X+w9O0ZGSX08mzBFLCRloqvuXoEcs
	 l+RKSocjuhfxG9ajTVLYRvJo74qsxS3Fa4vk2551oznUYNciNmnhrtaKCzGd4OvWLE
	 xxJq6dznjLsg4ngtYlAUgjw44+L1Kvxk1pfNNxrY=
Message-ID: <7b3c3a39-4cf3-430d-9fd3-ba83e5175e72@arm.com>
Date: Wed, 14 Oct 2026 11:33:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 01/10] arm64/mm: add pte_set_huge() and
 pte_clear_huge()
To: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org
Cc: Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com,
 baohua@kernel.org, chleroy@kernel.org, david@kernel.org,
 jiangwen6@xiaomi.com, leo.yan@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org,
 ryan.roberts@arm.com
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
 <20261002090947.869220-2-jiangwen6@xiaomi.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261002090947.869220-2-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2A9F940007
X-Rspam-User: 
X-Stat-Signature: b9sh5tnpxibhw8feuftpeserikky1mcn
X-HE-Tag: 1791957837-702606
X-HE-Meta: U2FsdGVkX1+oRJ9eIrvd1mc5DhO5y7exGJd4VAu+2HSexuJCHxzFh2EwVc8sA75AI5LikK7MA+kO80K/UiIeOImS6AKTOM43PtQ+ID4yZ2bwosGbFVeCcW04/PEHvtzlHQDBEA3qTnnfp4Wg7hNtMtNZBTd0Koq1N1b8wMu7a1XvGXDSbDmIu7susaBZNx9wfSwHiQwo1lTB0jW1F8oG8yWsLvDHHYk49xkuE7ldTrOb0pnXPkwJkYywuRNkswPZwt+gs/QPOxyA44JwEmdDU1rcS1HnPCYGSfQgVCdJlcgl8YOP6pPvheNgutM/zzhweASc9tdEKvsGCgwy+qKLjK4WdxiM9kPPvvBTCESO6CzRhousysW0SUbRrkiTSjJSv6mzeLPxzqu/oG16st9BomJranWLORf20WxXMEKWqnmv1hJ4GdVEtptg/0dhrx+8Y3cGXlq3KA4mKrpILD+wYQUxCRvMJOtVdCHMlCZoghvBULXGlf+hTbZtj9VuUej3KCBXDjSAKKnNTlEpZmhA6qw9t7SbYqk3IBoPF6w+xQCBYYdw51+Zsk58vFVsq4pxkFkMNuDVcYZvn/blnhPIY/Vm9voE0ylJR/yWifj2uSkVl1aTxhyG40cpAVDO0Ba31DedOcYA7yHdNScWtqBfpHH74fesaR1+UAvZjVwwLef0ucsHyXr7b2of7n6wuVM1BFvKBAaAoPWTKQdYzAzdy6jDCw7MhROZUz7BYFfxkyLHnsnDXSOZyZG+gjGTv8fFHTag8eroZY+8TNPNvDbRdOoHt5lDvCM+GQb1YPp3DGH73V+fm1ALa6XXAQ01hKY6QI9ODqiLwbACH3ZRZ+8UTfJo5u8XUr51S/bXqfidKnMcLKUhszZgngsCQOGIcAxgrxvvF7gnx9yOt2MKmHDlP7lZWZXyd3Eqmegnjo1kwJhP60YyRDxag+nfiODj/ZYXfdFf8Qrp1VQP3t/umvx
 kGKfajty
 r0HPVjgcB4/1OBEc9JgoCL04+Fn2EX3kQ96LCthxDuGy5bmpZSY1sURATS83+if5XVlZQSjKhEg33J3Aussgz+Z7aMpVUuaw9skXe7sXQ80wGeOtcuH/J1+hbPVu/dbgabM1LZzHA0nEyPbSsrulMfx3R8U8ZQBkOU3Gis2iDBK099mdjEDs56IXZVcZgTnSJpZ4fPsRK4UGzCQu0eM9f9RDP0GpoV79bH+G8hTdfbO6Ml71KQs3pp8bTa+LhZ2pPZgrNkVSmWLS0WSMy985YggY6TcDnPw6qo3UpSZScUA8fQGijDCJKk2S2T3/XGTMnQIDfpdSwdNPTjLgTYitbwjilL2rvl5Jd/7D6pOJA1CPSwQHjm0bKBnzJeQ08OKtipkNen8mIclCpklSCLe9NVBxhtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/10/26 2:39 pm, Wen Jiang wrote:
> vmap installs PTE-level block mappings (PTE_CONT on arm64) by reusing
> set_huge_pte_at() and huge_ptep_get_and_clear(), which are HugeTLB
> helpers gated by CONFIG_HUGETLB_PAGE. This makes the feature silently
> unavailable on CONFIG_HUGETLB_PAGE=n kernels and couples mm/vmalloc.c to
> HugeTLB internals it does not otherwise need.
> 
> Add pte_set_huge()/pte_clear_huge() to arm64, joining the existing
> pmd_set_huge()/pud_set_huge() family in mm/mmu.c. They build on
> __set_ptes() and __get_and_clear_full_ptes() directly, so they do not
> depend on CONFIG_HUGETLB_PAGE.
> 
> There is no caller yet: mm/vmalloc.c is converted later in this series,
> once the generic fallbacks are in place.
> 
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---
>  arch/arm64/include/asm/pgtable.h |  6 ++++++
>  arch/arm64/mm/mmu.c              | 23 +++++++++++++++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 6000905a2e865..9b762eb68cff0 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1978,6 +1978,12 @@ static inline void clear_young_dirty_ptes(struct vm_area_struct *vma,
>  
>  #endif /* CONFIG_ARM64_CONTPTE */
>  
> +#define __HAVE_ARCH_PTE_SET_HUGE
> +void pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
> +		  pgprot_t prot, unsigned long size);
> +#define __HAVE_ARCH_PTE_CLEAR_HUGE
> +pte_t pte_clear_huge(pte_t *ptep, unsigned long addr, unsigned long size);
> +
>  #endif /* !__ASSEMBLER__ */
>  
>  #endif /* __ASM_PGTABLE_H */
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 79d90226fd5dc..ae2f15618c97d 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1912,6 +1912,29 @@ int pmd_clear_huge(pmd_t *pmdp)
>  	return 1;
>  }
>  
> +void pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
> +		  pgprot_t prot, unsigned long size)
> +{
> +	unsigned long pfn = __phys_to_pfn(phys);
> +	pte_t pte = pte_mkcont(pfn_pte(pfn, prot));
> +	unsigned int nr = size >> PAGE_SHIFT;
> +
> +	VM_WARN_ON(!IS_ALIGNED(size, CONT_PTE_SIZE));
> +	VM_WARN_ON(!IS_ALIGNED(addr, CONT_PTE_SIZE));
> +	VM_WARN_ON(!IS_ALIGNED(pfn, CONT_PTES));
> +
> +	/* For vmap, there is no valid -> valid transition */
> +	VM_WARN_ON(pte_valid(__ptep_get(ptep)));
> +
> +	__set_ptes(&init_mm, addr, ptep, pte, nr);
> +}
> +
> +pte_t pte_clear_huge(pte_t *ptep, unsigned long addr, unsigned long size)
> +{
> +	return __get_and_clear_full_ptes(&init_mm, addr, ptep,
> +					 size >> PAGE_SHIFT, 0);
> +}

I think we should have the same VM_WARN_ON() checks here, as for
pte_clear_huge(), in addition to also warning for
current->mm != &init_mm.

We should make it clear that pte_clear_huge() gets called only for
kernel mappings, and the range we operate on is definitely an aligned
CONT range - which is why we do not go through get_and_clear_full_ptes ->
contpte_get_and_clear_full_ptes, and possibly contpte_try_unfold(), but
directly use __get_and_clear_full_ptes.


> +
>  int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
>  {
>  	pte_t *table;


