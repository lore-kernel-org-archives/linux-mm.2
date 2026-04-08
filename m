Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72C7C1073C99
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 11:08:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D48BD6B0088; Wed,  8 Apr 2026 07:08:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20AB6B0089; Wed,  8 Apr 2026 07:08:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5DAD6B008A; Wed,  8 Apr 2026 07:08:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B94E56B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:08:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 543BD5BF85
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:08:47 +0000 (UTC)
X-FDA: 84635115894.07.B204937
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8C14040002
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:08:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=g9HlyYXz;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775646525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m0H9zJfL6IkwhaRz6UhQTjJE34tHlIxmApDpb7jLyMw=;
	b=gL7tRQTykFM2BbAss8nb7ZMNWHEVWdcIGi+ViIp1qLR6B9lIMXNaXfb9uwbuEW7Lzo5fXz
	OeL/TbdVv13G+ckdt/WMUPigUT9LefYAUuqHRdoWDIMoB7XRayMgX2b3DBDdfor7NvqMxF
	k5Dq2BvhxE+X49gTkjv5ASmeI/9oR34=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=g9HlyYXz;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775646525; a=rsa-sha256;
	cv=none;
	b=kYTP49KtGaSMhih6WoPw8C+UR2xpOcvgsNz401TEo8/dJykvSlVUat4wTzquU4seex32Qo
	broaKwbPk6rrEMjjwKhUdBfCbBa2nHhRD39zhTeegIcZFgnReif8u09GSL5ACGCnzBPecm
	dUcBN2sT6BzcTVCRunP3m8QOhm6cj9E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0369B32E3;
	Wed,  8 Apr 2026 04:08:39 -0700 (PDT)
Received: from [10.164.148.132] (unknown [10.164.148.132])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 857EF3F641;
	Wed,  8 Apr 2026 04:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775646524; bh=WusmM/JN0uOT9i9wjTFqibLgRU744Qp8wkgjMexj9do=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=g9HlyYXzT1sjXsGodnTVTmGGq4Mh2oNyVIwEu/pdYfuHvn3ZgIUqe1Nh9SkZYtWSk
	 Ox3Q6id5to3JfUsc54ciQLX+BpNGb9mA3Hn4PJtuFw3S6TMCtePHIAJZss+zFqaQe4
	 020mO5z8wnXArz9eUbbV6pKiLo73uOxYmuPQiUMA=
Message-ID: <f661064f-269c-4e1d-8d6c-a9a2e50cd82c@arm.com>
Date: Wed, 8 Apr 2026 16:38:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/8] mm/vmalloc: Extend
 vmap_small_pages_range_noflush() to support larger page_shift sizes
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, urezki@gmail.com
Cc: linux-kernel@vger.kernel.org, anshuman.khandual@arm.com,
 ryan.roberts@arm.com, ajd@linux.ibm.com, rppt@kernel.org, david@kernel.org,
 Xueyuan.chen21@gmail.com
References: <20260408025115.27368-1-baohua@kernel.org>
 <20260408025115.27368-4-baohua@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260408025115.27368-4-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8C14040002
X-Stat-Signature: nkm64qn9bfodrx4be87mn9jzaddfqhyj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775646525-576445
X-HE-Meta: U2FsdGVkX1/msQoeEB5Z+OeYZ4BXd/oGkC27HUDotg3nBwSbIbYNyZXVt/fQseGKQktXGg8of8zYma9cigQ36F7ZlbdmWvMRnhB1Z7i2baCKjtcFDw2kvheWqEsouY0JjZ5t6ib3aZvUJfqNGxlGnK3/3d/aaWCI9weM1c7Kenk8i7yJsU2d+23RVjNurpJddyjLNuzhPEoPl1+B+8OLj3S2vm0j3vdPWGy5Hdz/FYxv09NEyk44Bx3vfZZ1q8wifT5yBzjHlauwma4lIU7irXqwoocNVjJupurJFqGdqJ1AxhaQgtVLX5Qctmf5/jzbsMnUK/jIvFTW23y008rZI/C/bMTS15H4TzklWEtF5N6HIUyRzYtercPV6qEor2ZPE6orAA7bLMcBHdOVJV7fOwo4J6u8/e6QZ8+Q/ml34gcrkA82aF/XohPNxvtArDffYHbExxMFvDTE/o2RuE6QqGM2mqXXSQvn3k7iKqgvYBJVnBd5Ox+LQ4KITay2fvGU1Vp3yu5FEJBWJpGL2q5T17e/y8UjN/ZcC6Ui6YCLQB5qfx+KYZPcuH5satriFLFh7HJeKsstQN6WlYMrL5LDh+HVtt7bkltJb36mDhDzLIDhsaMTYxEL0TX0MG84pj5XrGgH/ssT9v95koY3ZNoc4IPpyhkozliTtCtFsXlkq5X0xloKoKpAWJwRoDZDMMAdMI7pca9QIw0xKOHUb/XyPeVMoklQTGXdIm1PJwcTwJGhtKQ+Dqi8rD0Q16rhzkvHqAQaoiBqwNI4xAcj12Gpr8hD3j75vo5mr1hshyQdKs5YrW1r9yyvVF+HT+fX6X2dLCIk2gJ7/LibZ2r/0b3OA3Hm428hKDaWDFxDvr8wo7VA6QfoNA8s3+Cacrd1fdm42xzc21CC6xxH7LFBJQ1QlZ2RL/ZPvYYESpqUsgXabR2MbFdO219qt5jL5LANWrDzuuvK0dtufRSXOBthDAn
 5M6hOOOe
 XjWidiv2xThXo5r32FHm3Mftoei2o6AuhDT13jOQ5Gs55LhICFWYLEM9r3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/04/26 8:21 am, Barry Song (Xiaomi) wrote:
> vmap_small_pages_range_noflush() provides a clean interface by taking
> struct page **pages and mapping them via direct PTE iteration. This
> avoids the page table zigzag seen when using

"Zigzag" is ambiguous. Just say "page table rewalk". Also please
elaborate on why the rewalk is happening currently.

> vmap_range_noflush() for page_shift values other than PAGE_SHIFT.
> 
> Extend it to support larger page_shift values, and add PMD- and
> contiguous-PTE mappings as well.

So we can drop the "small" here since now it supports larger chunks
as well.

Also at this point the code you add is a no-op since you pass PAGE_SHIFT.
Let us just squash patch 4 into this. This patch looks weird retaining
the pagetable-rewalk algorithm when it literally adds functionality
to avoid that.

> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmalloc.c | 54 ++++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 42 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 57eae99d9909..5bf072297536 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -524,8 +524,9 @@ void vunmap_range(unsigned long addr, unsigned long end)
>  
>  static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
> +	unsigned int steps = 1;
>  	int err = 0;
>  	pte_t *pte;
>  
> @@ -543,6 +544,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  	do {
>  		struct page *page = pages[*nr];
>  
> +		steps = 1;
>  		if (WARN_ON(!pte_none(ptep_get(pte)))) {
>  			err = -EBUSY;
>  			break;
> @@ -556,9 +558,24 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  			break;
>  		}
>  
> +#ifdef CONFIG_HUGETLB_PAGE
> +		if (shift != PAGE_SHIFT) {
> +			unsigned long pfn = page_to_pfn(page), size;
> +
> +			size = arch_vmap_pte_range_map_size(addr, end, pfn, shift);
> +			if (size != PAGE_SIZE) {
> +				steps = size >> PAGE_SHIFT;
> +				pte_t entry = pfn_pte(pfn, prot);
> +
> +				entry = arch_make_huge_pte(entry, ilog2(size), 0);
> +				set_huge_pte_at(&init_mm, addr, pte, entry, size);
> +				continue;
> +			}
> +		}
> +#endif
> +
>  		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
> -		(*nr)++;
> -	} while (pte++, addr += PAGE_SIZE, addr != end);
> +	} while (pte += steps, *nr += steps, addr += PAGE_SIZE * steps, addr != end);
>  
>  	lazy_mmu_mode_disable();
>  	*mask |= PGTBL_PTE_MODIFIED;
> @@ -568,7 +585,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>  
>  static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
>  	pmd_t *pmd;
>  	unsigned long next;
> @@ -578,7 +595,20 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>  		return -ENOMEM;
>  	do {
>  		next = pmd_addr_end(addr, end);
> -		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask))
> +
> +		if (shift == PMD_SHIFT) {
> +			struct page *page = pages[*nr];
> +			phys_addr_t phys_addr = page_to_phys(page);
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
> @@ -586,7 +616,7 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>  
>  static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
>  	pud_t *pud;
>  	unsigned long next;
> @@ -596,7 +626,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
>  		return -ENOMEM;
>  	do {
>  		next = pud_addr_end(addr, end);
> -		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
> +		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift))
>  			return -ENOMEM;
>  	} while (pud++, addr = next, addr != end);
>  	return 0;
> @@ -604,7 +634,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
>  
>  static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
>  		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -		pgtbl_mod_mask *mask)
> +		pgtbl_mod_mask *mask, unsigned int shift)
>  {
>  	p4d_t *p4d;
>  	unsigned long next;
> @@ -614,14 +644,14 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
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
>  static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
> -		pgprot_t prot, struct page **pages)
> +		pgprot_t prot, struct page **pages, unsigned int shift)
>  {
>  	unsigned long start = addr;
>  	pgd_t *pgd;
> @@ -636,7 +666,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>  		next = pgd_addr_end(addr, end);
>  		if (pgd_bad(*pgd))
>  			mask |= PGTBL_PGD_MODIFIED;
> -		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
> +		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
>  		if (err)
>  			break;
>  	} while (pgd++, addr = next, addr != end);
> @@ -665,7 +695,7 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>  
>  	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
>  			page_shift == PAGE_SHIFT)
> -		return vmap_small_pages_range_noflush(addr, end, prot, pages);
> +		return vmap_small_pages_range_noflush(addr, end, prot, pages, PAGE_SHIFT);
>  
>  	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
>  		int err;


