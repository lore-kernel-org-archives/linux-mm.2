Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68670FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 14:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1E736B0092; Tue, 28 Apr 2026 10:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6196B0093; Tue, 28 Apr 2026 10:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0C006B0095; Tue, 28 Apr 2026 10:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AFA3E6B0092
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:33:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A8D7A01B3
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:33:32 +0000 (UTC)
X-FDA: 84708207864.28.6D86C25
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 47C591C001B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:33:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="czB/0boF";
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777386810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QPmpUeA7Dc6q8MNKSsp4Zcbwxx3Qyn+YReqAo7QuZLQ=;
	b=k2midJO7UPy2Ft7IJDgiRc6w6MRMKIzYVf23l63oOyZoea7/gke+tKiSoTbacLbVU9+w43
	KpOwDMMdPr0hp1k6UvVn2Z4ImUfa54kAFdAOmxhmWIw6uHBTSeVeIS66L+7sf7O5T76t/L
	jwgyhrcC2LqzqWHGjGGAEwgL+pzj/gA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="czB/0boF";
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777386810; a=rsa-sha256;
	cv=none;
	b=Tze2cBIVZFFopeSE28V4DXUH+IYs1SLTN6/+7dOEKHKcAJYPgLKbmgc+bJY1V+cVD3mmuz
	1SfVKxDtnrfsRXYdUCtbt6rYjr7dLQ54NcO75K/ZKYEGiNJpRBhUCeja//RJttS4UCFm8s
	3SD9Xv8HwF+ngArcwvu8WwouZ1bSLKA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A58DC1C2B;
	Tue, 28 Apr 2026 07:33:23 -0700 (PDT)
Received: from [10.57.63.26] (unknown [10.57.63.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AA91D3F763;
	Tue, 28 Apr 2026 07:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777386809; bh=3Tjsh0Mi9ttoZCdrFqo6Hf9TG+BdK8gmbIDZCKmHfgI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=czB/0boF7tK8yvbH/uwt6i6voyaRFSIx9N4QyPaWFgVEyb2orx+Vk61PNatG0TFgm
	 ogtob/NZKbg0T6W56P7AkgMXiOjJEJk2WgzMT7ZfaSimH7G7SbXx6uQWVbXLqpg89p
	 a5zADVDui8oYggRNAMTOAwua68gAwueUcc+dzheM=
Message-ID: <666f0251-773b-4c71-9c68-5d0791297e31@arm.com>
Date: Tue, 28 Apr 2026 16:33:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/15] arm64: mm: Drop redundant pgd_t* argument from
 map_mem()
To: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com,
 mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-23-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260427153416.2103979-23-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 47C591C001B
X-Rspamd-Server: rspam06
X-Stat-Signature: 6dncokqdrdtdah7hc8gxuzwmjiiq85hq
X-HE-Tag: 1777386810-853980
X-HE-Meta: U2FsdGVkX1/vXcFHHqlk+cA7p5KsxW8ikQCSf7lqPVeuJkCMwu7UTcNhAVo7SPw5H6T4fwUTXizws32zVaHHeiLHLqa6BTRzP6htRLFVV7+I8xJvFLycktBGs0L15QmxS+oWS2QRnH4HvY8TPqfE3qj6bl9aI2t7/FhtZZjN5KClfZmR2xH4koS4zFpJi/OmAKh3J8YTCkv3dfhWHW6QdcpClM4SbBtsVp+oOtzMwAecxMNtSQxFzUlYvnhLjeTEGWBMpsKmtqtDU4ju14vGNeNsncgx0Sy4JN+7wkvtKJ81ocBYehDWc3DKdTRVcSNkcO9pqMFgiayF1/qjGmrdZYIlTHytlLe4EnjTX59WL79YtNqwGkJ9bGSH2iO0SVBvtAswfxjuUVIwnzYm1NGcGp0AAnGbTAIT92r9NQwiHK8laEvbI/ZSxKBqEWx0y/a2iqTuCOxhYWXg/zTTIdZ2emPvJCAi5HVyQIb7cQRR1HHADQv9eU6tKYCLjSuOLs9UcUMK3qI1Gc29d8qGPAzx+PfDtIApCzDzI4OAywXXeSRdKGM9l5QltZtxjrlSajZTjB1kgB60cUlVMOR6bO2e7Mt4UgImunc3zVWvHTLFEBUb/tpMFqnlZdSHlHqk5C/Xi5HOzAR7negNzGGjTmQZU/1PNbqe1dRolsUE9Xax+YTn02o3Mf23Q6En1B6MaVou1LX99WAod+zYwk0mDggbQX79WQK3eHllLtRV0jDV3ju47q4eLhsubsq7cdbnZPnXVVA350q2TmTiQh0bF5xp2n39ZL2pUb+IV1bI1Y9SscrNhDVDNaI1VRLfNyfHXKXFZRU7uf/jHl+7Lf2vWuKirwbsYp5DRiSebYUhlbI6d92eDWjIlk17yPkIOqd0vzTwbxFcENJ9Acgn64wJ959RcycWzgwiDOh0zmVC7iWH+oWKRZBLIlxdSHR+PKnpaTtYjqU6dSWx8fyqt8+2g79
 RmvaFXPi
 owkMdWOYqRsGNaBF9PUHsIe51Bw+WRNnJWDkCHF3/PFU7uenz928mBtqxZVnLP+hZ9VmDBwAg/8NtFGYkTaIUt7KblcohichGcjQOXBx1c+LfU1Q6SiwC7vVSI8uRM61yxpkPy7pKDxtvkTwMfNHiqUgKywSguw++PpwMplL8IoZ8ZDpG3oXSGH/E/ZR86pFLwG6aBaQqiO8efbGBj48yxDyMu7s99IrO1S3fGt4d4S4FPlvlCeJR9nd2lGNcdeXIDPzaFL6ADEu4v8j/frpF6yL/ZWdqCIPVdz/C/Ft3jJ+Gt8nT1GoPWXFctndYOf/Szzip6z7cM7YSkq3+G2l++HXXpu5ubt0xrdi7RbPdA5PpFaEclgFyuQj1q9QfpJ+FsZiz0zIUqqW4D1rqtZR4rX3W5VlbVyqcQnn5rtfH3YPIc6P9JyWSazfLQqdPYauNc38B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/04/2026 17:34, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> __map_memblock() and map_mem() always operate on swapper_pg_dir, so
> there is no need to pass around a pgd_t pointer between them.
>
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

> ---
>  arch/arm64/mm/mmu.c | 25 ++++++++++----------
>  1 file changed, 12 insertions(+), 13 deletions(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index bfbf3fe0d1be..9610dd2d7bd9 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1039,11 +1039,11 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
>  	flush_tlb_kernel_range(virt, virt + size);
>  }
>  
> -static void __init __map_memblock(pgd_t *pgdp, phys_addr_t start,
> -				  phys_addr_t end, pgprot_t prot, int flags)
> +static void __init __map_memblock(phys_addr_t start, phys_addr_t end,
> +				  pgprot_t prot, int flags)
>  {
> -	early_create_pgd_mapping(pgdp, start, __phys_to_virt(start), end - start,
> -				 prot, early_pgtable_alloc, flags);
> +	early_create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
> +				 end - start, prot, early_pgtable_alloc, flags);
>  }
>  
>  void __init mark_linear_text_alias_ro(void)
> @@ -1091,13 +1091,13 @@ static phys_addr_t __init arm64_kfence_alloc_pool(void)
>  	return kfence_pool;
>  }
>  
> -static void __init arm64_kfence_map_pool(phys_addr_t kfence_pool, pgd_t *pgdp)
> +static void __init arm64_kfence_map_pool(phys_addr_t kfence_pool)
>  {
>  	if (!kfence_pool)
>  		return;
>  
>  	/* KFENCE pool needs page-level mapping. */
> -	__map_memblock(pgdp, kfence_pool, kfence_pool + KFENCE_POOL_SIZE,
> +	__map_memblock(kfence_pool, kfence_pool + KFENCE_POOL_SIZE,
>  			pgprot_tagged(PAGE_KERNEL),
>  			NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS);
>  	memblock_clear_nomap(kfence_pool, KFENCE_POOL_SIZE);
> @@ -1133,11 +1133,11 @@ bool arch_kfence_init_pool(void)
>  #else /* CONFIG_KFENCE */
>  
>  static inline phys_addr_t arm64_kfence_alloc_pool(void) { return 0; }
> -static inline void arm64_kfence_map_pool(phys_addr_t kfence_pool, pgd_t *pgdp) { }
> +static inline void arm64_kfence_map_pool(phys_addr_t kfence_pool) { }
>  
>  #endif /* CONFIG_KFENCE */
>  
> -static void __init map_mem(pgd_t *pgdp)
> +static void __init map_mem(void)
>  {
>  	static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
>  	phys_addr_t kernel_start = __pa_symbol(_text);
> @@ -1182,7 +1182,7 @@ static void __init map_mem(pgd_t *pgdp)
>  		 * if MTE is present. Otherwise, it has the same attributes as
>  		 * PAGE_KERNEL.
>  		 */
> -		__map_memblock(pgdp, start, end, pgprot_tagged(PAGE_KERNEL),
> +		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
>  			       flags);
>  	}
>  
> @@ -1196,10 +1196,9 @@ static void __init map_mem(pgd_t *pgdp)
>  	 * Note that contiguous mappings cannot be remapped in this way,
>  	 * so we should avoid them here.
>  	 */
> -	__map_memblock(pgdp, kernel_start, kernel_end,
> -		       PAGE_KERNEL, NO_CONT_MAPPINGS);
> +	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, NO_CONT_MAPPINGS);
>  	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
> -	arm64_kfence_map_pool(early_kfence_pool, pgdp);
> +	arm64_kfence_map_pool(early_kfence_pool);
>  }
>  
>  void mark_rodata_ro(void)
> @@ -1421,7 +1420,7 @@ static void __init create_idmap(void)
>  
>  void __init paging_init(void)
>  {
> -	map_mem(swapper_pg_dir);
> +	map_mem();
>  
>  	memblock_allow_resize();
>  

