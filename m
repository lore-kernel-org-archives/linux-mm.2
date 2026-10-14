Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47CC4CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 08:33:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A2B06B0095; Wed, 14 Oct 2026 04:33:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 359446B0096; Wed, 14 Oct 2026 04:33:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B3D6B0098; Wed, 14 Oct 2026 04:33:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF6016B0095
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:33:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A97BA048D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:33:40 +0000 (UTC)
X-FDA: 85320568200.19.B59E537
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 911D51C0009
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:33:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dsBcaX0m;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791966818;
	b=zCqyt9pSUx8XP0IzPKY93QOc9AQOLFedVnk58QcgLO3kQsvV3O6x6SXPdeoViwskmBpIt0
	jRsIFpewlxscFI4LD71LssP4ZYme20w00NYxSY86b6g1pO6gM9Wv902HGX8Ukm9KdSJrWA
	IAImmFeKWdjYB6td3b7XW8yzzWmGuyg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dsBcaX0m;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791966818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IqVi8QCU6hknC7H9M7ml2uXrA0673INlwwrSFLl3/oA=;
	b=TIbjyoRUnNDcsO6Is6iLg1WmWTvyEOO+Z5T5UBsb4k+j5YsSGi85FNmXX5R39F+4fPTrWI
	7WPzKgIS1Bw7OBhESFb+vuISwlR/D9b/Qh+Fii1C8WiLTUqOrq0Qgy96B+EoJiJcfZSHa/
	OKJfRWBtPi7zuRR1WcqNxGDQ4WZqX2g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E0321596;
	Wed, 14 Oct 2026 01:33:34 -0700 (PDT)
Received: from [10.164.19.62] (unknown [10.164.19.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3BAA13F7B4;
	Wed, 14 Oct 2026 01:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791966817; bh=ASu3IcGFyeYmVPuaDkdWQXD8Os9G+pzrChDjE/h2Abc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dsBcaX0mp6gvZs61sBhw4L/q40NPdO3Kc7UzRP8R8o9kzYplOo0TELA4mansDr9QY
	 gVDypdY8MeK7tLUiqaEO54LuxZB5+ugc2XA9+TqKgbXQiqQcv5LDAhz05f/vbjMflO
	 fXnHzM1uCU0ZQKE0+r4ukFIL9JxHuaSXVrZ0qePg=
Message-ID: <47c5b406-1298-4e64-84dc-e27910dc5f7c@arm.com>
Date: Wed, 14 Oct 2026 14:03:29 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/10] mm/vmalloc: extract vmap_set_ptes() to
 consolidate PTE mapping logic
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
 <20261002090947.869220-7-jiangwen6@xiaomi.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261002090947.869220-7-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3gf7wjusaaegbcoj619ktnf9fiawzx79
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 911D51C0009
X-HE-Tag: 1791966818-128862
X-HE-Meta: U2FsdGVkX186qujp6RRFdPuMFt0fyTnh0l6dbKXEhuPmEKIqVHhzKuGCdFNKKSarffGh8MZFyuY0Ih6uNGFd93HXabEHz9LPMcr8OHuKABTHdvoRPN3RInfJQBpz2w11Z+ubK5A5G/eJ9+A1Lb5+IQJFcZuPiw1Tg9cacCvQRIVfq6jsr94TD5XWbqaM6+w3nVVy4i/HakOiFu5g2er5fZ5c2P6h0kbD6IeRYuTZsYXAsakVNtPYi8WXluQGSp0OJ8Sw34HwOoY7wYqmbTc2VYipsuk7wBDhBuul5e9wJIgbq1TcwWmRCkqVjtBGrYGRpf6maO+v7HAKNBucXZtXgcSfyxd55vjZERRaTWGbbjpEVukMDsuAS57aZkMm4V0Ag5jVECkRePiSzJ/SxcFcb12pdTVMO6LqZLunaBcMi0JNlEwNZ3vhJkkPJYPcrJhXJ3VI0PBVf3yMerBVBqKRN/PnvnTnjY+71ab/Q/6SkIEwWMNHR1MYPFEM93UPNOaiJhG2eWvqmn/zqLtkDltZcormzBd98s6snIyFtb9GM3Nt67c/IBGHg+pS2dYv0xlAoyxe2Ndcw4KRYarVZBATHHvfcQ7aY8PdN3XejFARrcy+fEcy4mimD3POd9hQDvhIWyzjXmPyLTm+scod8IE5/uZMnxbhyVJs1y2thQqAtWF8D5JNUdO508hNrU7lKtA3UsBWZNlWGwmn1krlYEQv05x0GRrLvk9yOGIpQKfABFuDr5qSMdMcpz+zdQSUZHc7YTT5qQ67GxpOJ5FKIfrNyfVXR3poaP6avpzWJpJR1pIH8KvGPMLekBWcyA8PZWYNamcRK4Ka7Szv5i6aOC5jUAYUA9TfCTCjxc8BUTdJxuB0ykSuifs8948SVia/pBRQ6brYJV8Idbug1pIluFgi0uxGtZ/S/QuW8p8LfPJrugkcjik1uXcf4c17gd2QOXqNiy026oCMijZx3u54wuP
 UShR5h6s
 MZnfx4drDnriuR63oyCa1YBBKg6dbmxCoPM42129ZZSNooQP2HGCT+a5cehWDCnYnak4V0pHVuUdOM/WbV4E7yWBLpDLaU3wGsuNsn86ho1wvIJzfN2bJygFpd7dLEcvjYY8UYFX5I0o5Jnog3gzxiZTN6Qz19aRFMtY0qoGL9FqQM74lhkWGXeiVfPrsU+p4A8uJ7uGsY5B1tza34jp3OqscmIY+Ry0Vxh9pLmdPIQs8ukDeXbjsofGg8KPgj41qpy0/xoM10v8/0orT0oQQ6gp46LDyQR3R8l9lydWo3XiQ7Z04/R8X3bufCMFlNhvmnMCttLdsC6DXBm8kbX2glk43r2R/PeO4RFsGBVedHDDBjJUr2gD2bvB0mOnTsuW+mntEq7oQHdnO4yNeOOYAzBd/1EgvVPBdadAXARQcyg1BLPmWYQ4HKEo6kmiFzgJ1CQzDz6AIwngLGbGnsBwFQ8JoGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/10/26 2:39 pm, Wen Jiang wrote:
> Extract the common PTE mapping logic from vmap_pte_range() into a
> shared helper vmap_set_ptes(). This handles both CONT_PTE and regular
> PTE mappings in a single function, preparing for the next patch which
> will extend vmap_pages_pte_range() to also use this helper.
> 
> No functional change.
> 
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/vmalloc.c | 36 +++++++++++++++++++++++++++---------
>  1 file changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index fb757d95bde25..72ec1b48a76de 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -92,6 +92,29 @@ struct vfree_deferred {
>  static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
>  
>  /*** Page table manipulation functions ***/
> +
> +/*
> + * Try contiguous mappings at the PTE level for arches which support them, and if
> + * requested by the caller. Fall back to PAGE_SIZE mappings otherwise.
> + *
> + * Return: mapping size.
> + */
> +static __always_inline unsigned long vmap_set_ptes(pte_t *ptep,
> +		unsigned long addr, unsigned long end, u64 pfn,
> +		pgprot_t prot, unsigned int max_page_shift)
> +{
> +	unsigned long size;
> +
> +	size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
> +	if (size != PAGE_SIZE) {
> +		pte_set_huge(ptep, addr, PFN_PHYS(pfn), prot, size);
> +		return size;
> +	}
> +
> +	set_pte_at(&init_mm, addr, ptep, pfn_pte(pfn, prot));
> +	return PAGE_SIZE;
> +}
> +
>  static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  			phys_addr_t phys_addr, pgprot_t prot,
>  			unsigned int max_page_shift, pgtbl_mod_mask *mask)
> @@ -100,6 +123,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	u64 pfn;
>  	struct page *page;
>  	unsigned long size;
> +	unsigned int nr_pages;
>  
>  	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
>  		return -EINVAL;
> @@ -120,15 +144,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  			BUG();
>  		}
>  
> -		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
> -		if (size != PAGE_SIZE) {
> -			pte_set_huge(pte, addr, PFN_PHYS(pfn), prot, size);
> -			pfn += PFN_DOWN(size);
> -			continue;
> -		}
> -		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
> -		pfn++;
> -	} while (pte += PFN_DOWN(size), addr += size, addr != end);
> +		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
> +		nr_pages = PFN_DOWN(size);
> +	} while (pte += nr_pages, pfn += nr_pages, addr += size, addr != end);
>  
>  	lazy_mmu_mode_disable();
>  	*mask |= PGTBL_PTE_MODIFIED;


