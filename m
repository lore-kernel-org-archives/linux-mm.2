Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF521CD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 05:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 178D56B008C; Wed, 27 May 2026 01:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 150C76B0092; Wed, 27 May 2026 01:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F176B0093; Wed, 27 May 2026 01:59:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E614E6B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:59:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80EE2404FD
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:59:06 +0000 (UTC)
X-FDA: 84812146692.22.14C2001
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id AB311A0007
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:59:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="d2/4xwkH";
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779861544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oF+njrVX5zGJh0L+DY2lRBtM2reP8iV7YozZT/RvrYo=;
	b=vqEerjpN4NirDQFO2jtrYYQmFXzV4wCcgqn+CJ2qEGj5sOYu6mTJwee2IfHdcdoyDgXIHF
	Ntae+YmDMc71Zku9zwYTXkEFwJOpcSCtZBHwlE6rHFeQPtXx82K5B+gQ0/fokyaVuD3nJp
	g72q+LeUjKVI4qxePVhNRA9+MwbwdIE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="d2/4xwkH";
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779861544; a=rsa-sha256;
	cv=none;
	b=e/+MHCgT79x6vzYDcLFPzO7uSCY2+4UzEuC1o8xUkAMYsPNkKmKgo25adfxPj6ZGnG3x8r
	5yDciKReFKkofPwr40O2GP61PGG5rRqhQp28gKxL5pu2ZuOHaAW+hMSOgoGhN4CH1sAFR4
	4OHPI2mh9lOCxvNHJr4hInZTllBgJuw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84A3616F2;
	Tue, 26 May 2026 22:58:58 -0700 (PDT)
Received: from [10.164.19.7] (unknown [10.164.19.7])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 95A003F632;
	Tue, 26 May 2026 22:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779861543; bh=ouSFEB5JSyxfV8CdG4ob7/ZqkwxxEzp2bArEI1XtNEw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d2/4xwkHi/rrZvxRu4hDCdxSAU5SxTUdtgVX+1V0pDhGBkT0h9kG+l+RXSh1cpfKG
	 Xlat8gq3hwPNWvd/iFhHO5U68tFwryMc4yBD/JeTsBIi1FsakSeaVDr68BT8Pe4+q/
	 Fqj2xTuMqZchX/LHfzZMCywT632O3Bjh7rSk2oNo=
Message-ID: <46b0f2a7-3c0d-4372-a45d-946d8259d410@arm.com>
Date: Wed, 27 May 2026 11:28:55 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] mm/vmalloc: Extend page table walk to support
 larger page_shift sizes and eliminate page table rewalk
To: Wen Jiang <jiangwenxiaomi@gmail.com>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, urezki@gmail.com
Cc: baohua@kernel.org, Xueyuan.chen21@gmail.com, rppt@kernel.org,
 david@kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com,
 ajd@linux.ibm.com, linux-kernel@vger.kernel.org, jiangwen6@xiaomi.com
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
 <20260522053146.83209-5-jiangwenxiaomi@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260522053146.83209-5-jiangwenxiaomi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nx6wjqx4c6oj38o8113zgn45xpmkthtd
X-Rspamd-Queue-Id: AB311A0007
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779861544-828559
X-HE-Meta: U2FsdGVkX19I0Lf8MB4ME6h946k4EHJEojiZPoq3sXkSGZLvmhM71q4LfOs3PYKUCmf2HpGPo27BljPNapK/pq0zavGbi+rLPuO3Tfpubm7Y0/FbDllRb1FPUaON32hVDDIOxnjtk6vEw4fRzlfZqNZkGkDK86QrDevuNv4oe4Ovg+GZjuJV4VgVQ6I09pWs7WlwUaPBVAhRvFHk5neqPid6j38zjqZaDiU93xx7jENVzyu8hz33FpeoMS0wkEI8BlrkTbGLxKrFs9JgNRlgUW0TNQSXQoUwCQKHurrYU6UBN0Kitq98VKmlhCsRQaabqidFiCrb0GssdmZlgr6Ck6gE5PulI00APCSDJ9wXppuWt9U/2LFFtYq/HUcoAGlkYP3BPFAVEQMxaD0ZE0ww8QmZexCQkJ6+4SuQO7O6QGRNlzlm26u/GppUsNORD4EYpAw3M4efhnaAtr40l2/puRIeKIFNz6OERr2nV/rdjSOdmz0rxWmtY14EPPEXL/FnMdm7uhTMcLM3etHELkAZgzF4+jhzK0heKaDPwd5ByMkgCb6sIzxSVs4dyW2DifudrJU6nUnNwSUcPTnhImuh56orMjU6Ngs3Glwkp1nJi2Gr+4qBOsVh/x8Aab1JySkZrIlixcTmwvqtEC/WHmliFBT64vKg2T8NyvLLC4gAnYbiL3LqDQzSnS0ngedRBzUCNvjIh+snfMqQk6LrlXH48VnNUZFVWQ+oW1H9zeYn8yUyqob3qcpYde/g2UMpTPc7vwDVn+Vw3f9CnSCfjsXDey+lUpb2DQvPSakq+ITAc3LphJJkoTziYE+IiS1V3bUNCTh1+8OSBz4sNjs3aPrs4SByE2KR00x7/fXDgPXVnsF+wkIiee2JeXZ2GbcoTy6/LMX1lOPji/HUG8HAGRlYtNdZbAwK24/4/LlS+0SZFApkx1TY+sBqaoT1kZH/mpXmWZmXhHQCbmQ+c8XRffV
 BH0y3QzW
 cv5BvxWn9a7bbq/yXj0xh4lVenH7LxlcmRF634Lm5rP+60qScdtPzULv2XnzIdkrxdiDEExhQU8oCQqqaXbffPOm4+hBcRcP252IL5jQ2NUB8/OkYpVg4VAvTTO64mjZ9W0Tm/Wkxckr2ei0UAsnCCkZgy0JlBkNlXSlLnfUAt670BR98gHVv815RSq11nBjgkHuqhxuZvpTFFIqTCTMjokQwbA4HDIeBCb92COKQ7EHZpHzup/0cETiHrqcst6bPTwkDhhtKQ6gFfphN4Bf8YvtstYn8pxeEeltQ5ukZokDQDzPd+qHpjsdFYWnDnkff1wKpUyYlMM9gxj6Osnz3YwireS4z/X+fopWHovsFpwzzj1/cO/3rasGF3L9hlKohpfOOLCSgAuOqwR+RXmplsq69YUIo4YrG4HSmSR8XJEVtj+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/05/26 11:01 am, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> vmap_pages_range_noflush_walk() (formerly vmap_small_pages_range_noflush())
> provides a clean interface by taking struct page **pages and mapping them
> via direct PTE iteration. This avoids the page table rewalk seen when
> using vmap_range_noflush() for page_shift values other than PAGE_SHIFT.
> 
> Extend it to support larger page_shift values, and add PMD- and
> contiguous-PTE mappings as well. Rename it to vmap_pages_range_noflush_walk()
> since it now handles more than just small pages.
> 
> For vmalloc() allocations with VM_ALLOW_HUGE_VMAP, we no longer need to
> iterate over pages one by one via vmap_range_noflush(), which would
> otherwise lead to page table rewalk. The code is now unified with the
> PAGE_SHIFT case by simply calling vmap_pages_range_noflush_walk().
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/vmalloc.c | 71 +++++++++++++++++++++++++++++-----------------------
>  1 file changed, 40 insertions(+), 31 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 53fd4ee460ea4..deb764abc0571 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -543,8 +543,10 @@ void vunmap_range(unsigned long addr, unsigned long end)
>  
>  static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
> +	unsigned long pfn, size;
> +	unsigned int steps;
>  	int err = 0;
>  	pte_t *pte;
>  
> @@ -575,9 +577,10 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  			break;
>  		}
>  
> -		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
> -		(*nr)++;
> -	} while (pte++, addr += PAGE_SIZE, addr != end);
> +		pfn = page_to_pfn(page);
> +		size = vmap_set_ptes(pte, addr, end, pfn, prot, shift);
> +		steps = PFN_DOWN(size);
> +	} while (pte += steps, *nr += steps, addr += size, addr != end);
>  
>  	lazy_mmu_mode_disable();
>  	*mask |= PGTBL_PTE_MODIFIED;
> @@ -587,7 +590,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  
>  static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
>  	pmd_t *pmd;
>  	unsigned long next;
> @@ -597,7 +600,27 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>  		return -ENOMEM;
>  	do {
>  		next = pmd_addr_end(addr, end);
> -		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask))
> +
> +		if (shift == PMD_SHIFT) {
> +			struct page *page = pages[*nr];
> +			phys_addr_t phys_addr;
> +
> +			if (WARN_ON(!page))
> +				return -ENOMEM;
> +			if (WARN_ON(!pfn_valid(page_to_pfn(page))))
> +				return -EINVAL;


So I know these !page and !pfn_valid checks have been copied from vmap_pages_pte_range,
but do they mean anything?

I think pfn_valid() makes sense in that someone may take a random VA/PA, convert it into a struct
page and pass to vmap layer. But I don't see how anyone would pass page == NULL? At the
very least, returning ENOMEM does not make sense because the pages are not being
allocated by vmap() but have already been allocated.

> +
> +			phys_addr = page_to_phys(page);
> +
> +			if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot,
> +						shift)) {
> +				*mask |= PGTBL_PMD_MODIFIED;
> +				*nr += 1 << (shift - PAGE_SHIFT);
> +				continue;
> +			}
> +		}
> +
> +		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask, shift))
>  			return -ENOMEM;
>  	} while (pmd++, addr = next, addr != end);
>  	return 0;
> @@ -605,7 +628,7 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>  
>  static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
>  	pud_t *pud;
>  	unsigned long next;
> @@ -615,7 +638,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
>  		return -ENOMEM;
>  	do {
>  		next = pud_addr_end(addr, end);
> -		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
> +		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift))
>  			return -ENOMEM;
>  	} while (pud++, addr = next, addr != end);
>  	return 0;
> @@ -623,7 +646,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
>  
>  static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
>  	p4d_t *p4d;
>  	unsigned long next;
> @@ -633,14 +656,14 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
>  		return -ENOMEM;
>  	do {
>  		next = p4d_addr_end(addr, end);
> -		if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask))
> +		if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask, shift))
>  			return -ENOMEM;
>  	} while (p4d++, addr = next, addr != end);
>  	return 0;
>  }
>  
> -static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
> -		pgprot_t prot, struct page **pages)
> +static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
> +		pgprot_t prot, struct page **pages, unsigned int shift)
>  {
>  	unsigned long start = addr;
>  	pgd_t *pgd;
> @@ -655,7 +678,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>  		next = pgd_addr_end(addr, end);
>  		if (pgd_bad(*pgd))
>  			mask |= PGTBL_PGD_MODIFIED;
> -		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
> +		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
>  		if (err)
>  			break;
>  	} while (pgd++, addr = next, addr != end);
> @@ -678,27 +701,13 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>  int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>  		pgprot_t prot, struct page **pages, unsigned int page_shift)
>  {
> -	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
> -
>  	WARN_ON(page_shift < PAGE_SHIFT);
>  
> -	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> -			page_shift == PAGE_SHIFT)
> -		return vmap_small_pages_range_noflush(addr, end, prot, pages);
> +	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
> +		page_shift = PAGE_SHIFT;
>  
> -	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> -		int err;
> -
> -		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> -					page_to_phys(pages[i]), prot,
> -					page_shift);
> -		if (err)
> -			return err;
> -
> -		addr += 1UL << page_shift;
> -	}
> -
> -	return 0;
> +	return vmap_pages_range_noflush_walk(addr, end, prot, pages,
> +			min(page_shift, PMD_SHIFT));


We can easily extend to PUD huge mappings right? Not sure whether we
should keep everything symmetric to how vmap_range_noflush() operates
right now, since P4D mappings don't exist, but PUD looks worthwhile.

>  }
>  
>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,


