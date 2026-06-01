Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E90DDCD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 10:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 383BB6B0316; Mon,  1 Jun 2026 06:43:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 334B56B0317; Mon,  1 Jun 2026 06:43:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24B196B0318; Mon,  1 Jun 2026 06:43:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 130806B0316
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:43:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A0FA814064F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:43:03 +0000 (UTC)
X-FDA: 84831006246.04.C22D97E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5546F14000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:43:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=L7vvyWyP;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780310581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w+Nusdc80UxxlxkRbJQVlsMrz4yOsTaBzGC7whbZUGQ=;
	b=isacACgmcB+YvgAbee12JpC2oSunlzapgLOYxMej2HQMtAUGrVd5e8Rvj4wpt0SupsdDHx
	FMVqicXp3lZUDD3PSeMpePx1QSyGYR+n29/m4/CK6xV7fUOdz2wHTgiUuV2F1cSIwkHEJe
	DgzFCDAlcPDS9FKDmlP8uF3wbzuEefA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=L7vvyWyP;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780310581; a=rsa-sha256;
	cv=none;
	b=kJSGO9BuYK7cbYn/YIFDUt8KyRLIhkBuiSgftnTx/9xGju3ETKlLikns32VOiLqWppa74Y
	WbFQdeDc+vItNYM3aCNM8AcwyPkygogVZbCRE0s0BR/hbd2LL67O43FTSjZSko9mwmhFgC
	PGGEdr1vQABA9N/FP8sXZ9Mbi8a7iR0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2DF0B1516;
	Mon,  1 Jun 2026 03:42:55 -0700 (PDT)
Received: from [10.57.94.8] (unknown [10.57.94.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE8AB3F905;
	Mon,  1 Jun 2026 03:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780310580; bh=Surtzdfsfons0Igc45K6QS/muGPLmDhB31E+s1aspA8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=L7vvyWyP5yYoDEKRDyQEcn+KUcyIZLm2/zPqf2mFWbJd8f5vtwRD9mJ+gjQLemSmG
	 61GJ7fElvuDmqzB0boUzsETOcCIg+LT5X96dfHbuAGeuIYJbp6tPCru3g6Uz1zZTsM
	 dtan6SzPh6XJ40fqoV65vNcSw4ucQjj+39rNxGKw=
Message-ID: <502eadae-089f-41cb-a871-9ad6b8169e0d@arm.com>
Date: Mon, 1 Jun 2026 12:42:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/15] arm64: kfence: Avoid NOMAP tricks when mapping
 the early pool
To: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com,
 mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org
References: <20260529150150.1670604-17-ardb+git@google.com>
 <20260529150150.1670604-24-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260529150150.1670604-24-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5546F14000A
X-Stat-Signature: utsxxcm7j67psujbbrmxpibg39hodxra
X-HE-Tag: 1780310581-933209
X-HE-Meta: U2FsdGVkX1+OHDgHt+JSlz3rgRSLTzdZzrmeLiVE1uBsKqQMyZYg1LlnANnVJJ3EVQ/Nr6M+TEzfT48JeFijSIiEI03rZC8yFCCi6ytY5o5IOjC8c0B3a1oL9xkkknroA/pbWGwPhTuhkdsi0Ke0zBVYOZTI+6iV9/LCn/TgPUlK+Rv/h26Xu0C5uEadKPisIx/S/0i6YUuPI6fO+V1vMF6j/m/h39kPGoINEQ87lIzDV3vtcw2IFU1wPR0zUzYHve2UT1bCP3GXBP/Ew6+fSCU/aoa11ieUYVayzdZFLZ/EJv4XXH5C3ZMdigjU2pIi32CZIaolZEdqI0ny17E840HhrKNOUHAkzngMyvkOte+QCumT54366+xIKwgyaVOuG3FNQ8tu1PssiozsktOCN0Kb2vpxqrqUqB7P4bDgJDq2WB6nm1UGLsldFxI3Mr9DXM7TLsJLoBicT+uOybGJkTsDiDGh8sd6bIIt9CI+M0cx4nz/HorLso/OTkKETMUPyjl+8SrTcEsWes4Oilu7VoqIX+8YfpWSBaBoftmRbVd/TiLKDJ2SmLzHBOs3PPWsjIlwrsQaY4D3P2wmjanRV98eHcV7DoBDhRDmVHxQ6KoslRfyq6nW2HH/IIF3sNiPsHyV5RnRHQoqiZlzXpd69Buh6q7LdXVbzKYrkXHXK50uuuS7i9pN0q0myuMisMQJv5FwawgnTTt7ecScaoe/a/04svZCooARI7YlfigVa3gTjqDRE/yB95JwXpqMy61hSON3zCn0urXHSRqRa5NsPVHpnzEipV181WOydFdOm9SSfXy6CV39g/lcf6BHmdvdHHjHuPqN7kiYg5me62MFGtuNv/xCgldXovwhdMdRZ4ivRs/T2KfZpiQD/uCdJmGywBa4DyOvVCPw17zAW/lhObp9ha2nsx0PK21r/Kxqnbrz+l3SvEfa2NJoSjCUqspaZqqxnk6GxzIeQDCCnpP
 6/gKWM5l
 7FCt5NWC8bUjNOmDF0XPtlGN7oh7J0ZyDvPYTjY/a3IX2TM/Pabp6ihswz7/LYoqraOhX4/aLlTbBOxAUCRckbP97iY8vyCxRoIaOMhutrrwZyh9usm6BcPQXB/XiZU1veKO7gDsuYhhepBhZ90tt6bbA1us9N5Qg7hUCFbjI9PGueGGfDLIAFCYXun9o5PBQSs8l7tkPX3VvUJ8bSfu5baE1lGQkQ7da4V8lO07JOCKYoJOTsl8yaKtFtYmmTcwg5w7aseplBs5dz/0vqVukNd1nEw8/FRDVifuLooUi+QMGkCxWa2gmjls/5QyXF4w8UbPhIJ7lhVVK+1JjgsqazGr5kPZN2SPDfi1N0dbu7v5xO4xsBYw2MXS6BKyupTlq1ciNlRoxDsk/9II=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/05/2026 17:01, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> Now that the map_mem() routines respect existing page mappings and
> contiguous granule sized blocks with the contiguous bit cleared, there
> is no longer a reason to play tricks with the memblock NOMAP attribute.
>
> Instead, the kfence pool can be allocated and mapped with page
> granularity first, and this granularity will be respected when the rest
> of DRAM is mapped later, even if block and contiguous mappings are
> allowed for the remainder of those mappings.
>
> Add the NO_EXEC_MAPPINGS flag to ensure that hierarchical XN attributes
> are set on the intermediate page tables that are allocated when mapping
> the pool.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

> ---
>  arch/arm64/mm/mmu.c | 27 +++++---------------
>  1 file changed, 6 insertions(+), 21 deletions(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index d7a6991e1844..cdf8b3510229 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1083,36 +1083,24 @@ static int __init parse_kfence_early_init(char *arg)
>  }
>  early_param("kfence.sample_interval", parse_kfence_early_init);
>  
> -static phys_addr_t __init arm64_kfence_alloc_pool(void)
> +static void __init arm64_kfence_map_pool(void)
>  {
>  	phys_addr_t kfence_pool;
>  
>  	if (!kfence_early_init)
> -		return 0;
> +		return;
>  
>  	kfence_pool = memblock_phys_alloc(KFENCE_POOL_SIZE, PAGE_SIZE);
>  	if (!kfence_pool) {
>  		pr_err("failed to allocate kfence pool\n");
>  		kfence_early_init = false;
> -		return 0;
> -	}
> -
> -	/* Temporarily mark as NOMAP. */
> -	memblock_mark_nomap(kfence_pool, KFENCE_POOL_SIZE);
> -
> -	return kfence_pool;
> -}
> -
> -static void __init arm64_kfence_map_pool(phys_addr_t kfence_pool)
> -{
> -	if (!kfence_pool)
>  		return;
> +	}
>  
>  	/* KFENCE pool needs page-level mapping. */
>  	__map_memblock(kfence_pool, kfence_pool + KFENCE_POOL_SIZE,
>  			pgprot_tagged(PAGE_KERNEL),
> -			NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS);
> -	memblock_clear_nomap(kfence_pool, KFENCE_POOL_SIZE);
> +			NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS | NO_EXEC_MAPPINGS);
>  	__kfence_pool = phys_to_virt(kfence_pool);
>  }
>  
> @@ -1144,8 +1132,7 @@ bool arch_kfence_init_pool(void)
>  }
>  #else /* CONFIG_KFENCE */
>  
> -static inline phys_addr_t arm64_kfence_alloc_pool(void) { return 0; }
> -static inline void arm64_kfence_map_pool(phys_addr_t kfence_pool) { }
> +static inline void arm64_kfence_map_pool(void) { }
>  
>  #endif /* CONFIG_KFENCE */
>  
> @@ -1155,7 +1142,6 @@ static void __init map_mem(void)
>  	phys_addr_t kernel_start = __pa_symbol(_text);
>  	phys_addr_t kernel_end = __pa_symbol(__init_begin);
>  	phys_addr_t start, end;
> -	phys_addr_t early_kfence_pool;
>  	int flags = NO_EXEC_MAPPINGS;
>  	u64 i;
>  
> @@ -1172,7 +1158,7 @@ static void __init map_mem(void)
>  	BUILD_BUG_ON(pgd_index(direct_map_end - 1) == pgd_index(direct_map_end) &&
>  		     pgd_index(_PAGE_OFFSET(VA_BITS_MIN)) != PTRS_PER_PGD - 1);
>  
> -	early_kfence_pool = arm64_kfence_alloc_pool();
> +	arm64_kfence_map_pool();
>  
>  	linear_map_requires_bbml2 = !force_pte_mapping() && can_set_direct_map();
>  
> @@ -1210,7 +1196,6 @@ static void __init map_mem(void)
>  	 */
>  	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, NO_CONT_MAPPINGS);
>  	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
> -	arm64_kfence_map_pool(early_kfence_pool);
>  }
>  
>  void mark_rodata_ro(void)

