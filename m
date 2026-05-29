Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A31E7CD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 08:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 074456B0088; Fri, 29 May 2026 04:28:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04BA36B008A; Fri, 29 May 2026 04:28:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECAF46B008C; Fri, 29 May 2026 04:28:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E009E6B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:28:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8915A140C64
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:28:55 +0000 (UTC)
X-FDA: 84819781830.19.A4B1CF5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id ADD0CC0008
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:28:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YZ2yU0au;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780043333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+looN2hpXJFOKD3iMnMkMDkkykfhbyT/ok6fM1Am568=;
	b=szDef0Mnc9r9SUU9d9UykMBbKkrib8hgDt0UAyxUcIfJkMokJuBe/00NfASKHkvyeGahMN
	bFxsaeR9Ywe6R8ednpdSr+1fDrbyD0Sn0KT737R42tQn7usE1nz/E84X/tAdcIrHhkkO42
	zIbEaeXe2gXWzT8h7XFXXsI11tZc/4E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780043333; a=rsa-sha256;
	cv=none;
	b=2iw2sccJWFKvTvYS5rgkUi71h39IJZvYKkwD0XTWcZFU/RFIz7cLX84VLb6+NeoO/sRIhO
	XG8bL61NQbPRC4hdDanQ0hAKZ0jCO3xuGX3wbsWl3m0aMb6ogqBpdVZwJpP02d4Gcqv3pq
	zWW3RPtVGaRl12k2BizE3q5Sl5C/VqM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YZ2yU0au;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D07B032E5;
	Fri, 29 May 2026 01:28:47 -0700 (PDT)
Received: from [10.57.91.162] (unknown [10.57.91.162])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 83FD73F632;
	Fri, 29 May 2026 01:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780043332; bh=Z2DB+SWpensbVmMniGSAriQUagND4+fkmRPKJtuCrJg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YZ2yU0auvFCW6viVlHGdHypyUVjfOW4ehecevzbX/zX9r4auet18CifsIvnfhrncg
	 Zh7kDsvXXHA1moz9xnVz2EB1X3ShgEYeP5pwX7OYBplU5hJ8Xiotq7kTPCe0AxPDhS
	 eLs2oxITo6qysD5YozkjUxNKKEiKfXYeDyGoA+bM=
Message-ID: <9566e664-3f54-4bcc-97c8-86e15dc927f2@arm.com>
Date: Fri, 29 May 2026 10:28:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/15] arm64: mm: Map the kernel data/bss read-only in
 the linear map
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
References: <20260526175846.2694125-17-ardb+git@google.com>
 <20260526175846.2694125-28-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260526175846.2694125-28-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: xk6uxeqerogmtxwu5qzda1873jozmy7c
X-Rspamd-Queue-Id: ADD0CC0008
X-Rspam-User: 
X-HE-Tag: 1780043333-278226
X-HE-Meta: U2FsdGVkX185lDUrUvQIubEmLu58vaxmVMDfQsES3efCsRr+RXSEPyupE2GagKnZ4z/7WvYY4tJTzQZbl0plp1rWR1xrLxfnv52D7zwY5o7IpzmMejTiopL6sO72a1bX5MOzMi5b/GsoN8Srp4eT7BuW9ySqOXvXj6IlX13R0AgWVBny3BQE/9uuIt86FyFXH62C3SToREFNzUOEfm/iyguI2mlbWnOLqJxVCdYhb2Y/VPN8w6agzhFiWRZi18EWg2o323oNLTOEbi1Tq1Dh3ecxVJfgl00/pf5e4bLqoQKtj9dwaqrG7r6IM7LImnxTB9hcgMzcbJCVDb/br5u4omyPc6IkJ/9RwNnpaGDCrO+WAWarayQQ6/dWpBsIQBsbBS44sb4Jfgwwis3M4gibgnqFvwT8NoMoX6T5+rVc2K7HMW0J+04ZEiKisgUYgoNqdA9ngrmf3uo+wi7yZMe/Qwq6n2sDiFa7uuM7lP9lLBv/WCAgNgMe4Hv+DnQoPdnsuneG7iUZNwl26juXOnNn0tfzPR7XWzJK8SO4H99QWsP9cZc1sgec03AqoGaRzd36W22oWSxWO28qsbVzGGNlar8ph3CWCBtJgxNEmRj2tpiO3K617bkQ/zWZVbUygDixBL5R8tW4OFEU/cLVeBUYrk3Ru/hsuF7mTsPpjLSPk2OwpoB/Emu6IBOjG8j/9lzGr8WHlnSLNH3ndQOh3XSzHGRcO7s0awFm7lm9QlS1G97E64rTfnsXkoB3oRtPRyS7SstBd613+/NvhFQgNtlJ0ho5BzDuRpI1K5iql/MRjP9Xi3VcB5yYv4vIze14h0OZaHjybbb+x33SQ9GviZf4mjfAW1qhv1A5drDCY8arAaMyCaAH+agXl9wuzKLzKZfehreTYxzLIcQlwrZxlBNpMKgrv9gEIGdmCr8q1jXX2LpMT+v3S0hsetfwjCBvVAEDuB34gTFOB8WnboLosc8
 BcBfjvdn
 imN45GuBO05k8U/LqeftbEOSMcK+QXfpnE2ZvuNdjtTyHhCrPGMl/Dd2fy/193gTr+Kviu1v7OHs3MegE8Jo4+n/kwy128/mNz8L9UZXIUCh01fetazifXCkXxEUtblEFsu6/8ebXClr9SeeYmurfme1LIcsEeFbBj5Ahx09O9hCbFEsoNAB4ruqBNuL+ny8ST2sKxI35G/vu1IZ+D/psR4UwqExqMgMIZejdp5Ud2+cNrF+x+KPInBA7sCTxlpK4POCAYZUdiLtUBHTZ4qFDHqFSnf+ii1MDlWfDBYoQclCrzMfUC8IDh9D/x3B9jhPjGOVXK9a6ePgKl1TeBLIJUd5XPJyA6Jy6vakSHtPZkQtpJA0XBsCttJsVDMTPdB8bOTkrqtWE5XyWjj0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/2026 19:58, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> On systems where the bootloader adheres to the original arm64 boot
> protocol, the placement of the kernel in the physical address space is
> highly predictable, and this makes the placement of its linear alias in
> the kernel virtual address space equally predictable, given the lack of
> randomization of the linear map.
>
> The linear aliases of the kernel text and rodata regions are already
> mapped read-only, but the kernel data and bss are mapped read-write in
> this region. This is not needed, so map them read-only as well.
>
> Note that the statically allocated kernel page tables do need to be
> modifiable via the linear map, so leave these mapped read-write.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

> ---
>  arch/arm64/mm/mmu.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index b20c76b8381d..e7ca53d20b87 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1138,7 +1138,9 @@ static void __init map_mem(void)
>  {
>  	static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
>  	phys_addr_t kernel_start = __pa_symbol(_text);
> -	phys_addr_t kernel_end = __pa_symbol(__init_begin);
> +	phys_addr_t init_begin = __pa_symbol(__init_begin);
> +	phys_addr_t init_end = __pa_symbol(__init_end);
> +	phys_addr_t kernel_end = __pa_symbol(__bss_stop);
>  	phys_addr_t start, end;
>  	int flags = NO_EXEC_MAPPINGS;
>  	u64 i;
> @@ -1171,7 +1173,11 @@ static void __init map_mem(void)
>  	 * of the region accessible to subsystems such as hibernate,
>  	 * but protects it from inadvertent modification or execution.
>  	 */
> -	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, flags);
> +	__map_memblock(kernel_start, init_begin, PAGE_KERNEL, flags);
> +
> +	/* Map the kernel data/bss so it can be remapped later */
> +	__map_memblock(init_end, kernel_end, pgprot_tagged(PAGE_KERNEL),
> +		       flags);
>  
>  	/* map all the memory banks */
>  	for_each_mem_range(i, &start, &end) {
> @@ -1183,6 +1189,11 @@ static void __init map_mem(void)
>  		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
>  			       flags);
>  	}
> +
> +	/* Map the kernel data/bss read-only in the linear map */
> +	__map_memblock(init_end, kernel_end, PAGE_KERNEL_RO, flags);
> +	flush_tlb_kernel_range((unsigned long)lm_alias(__init_end),
> +			       (unsigned long)lm_alias(__bss_stop));
>  }
>  
>  void mark_rodata_ro(void)

