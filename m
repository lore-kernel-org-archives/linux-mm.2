Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E9EDCCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A50326B00A4; Wed, 29 Apr 2026 09:54:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DA846B00A5; Wed, 29 Apr 2026 09:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1E46B00A6; Wed, 29 Apr 2026 09:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75AE56B00A4
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:54:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C13C61C02F3
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:54:21 +0000 (UTC)
X-FDA: 84711737922.11.42B8AEC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id E58854000E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:54:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lLNh2XYt;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777470860; a=rsa-sha256;
	cv=none;
	b=l9cs49YdXrKHQBLu3YfPoim+K/dsuhG/x2U4arNpYTYwUXGARAXH/L37PWKTRmHEQ8lT0G
	x5y4FtRiL0wV1/uk/qtTdedSjyFtPyGz4s3W+qRZ/rTtespj9xgTfUI4EwiZTTwnaJyRb+
	w2zyBihbPvkWEUBzbK46Ud7lZ7Vb4cE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lLNh2XYt;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777470860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MeNtVCMTSI6Jd/skjzStvD5kEk+oINwTN2fN2mcs9C8=;
	b=wvCSijaDDHh/Y8gur0tJj4UO+tNXykcQNGbclQ0QPFF3DelW2YkbxvX5KEGisD5IvMk4Vi
	Joa/sp48zDk6hqwSkabEtOIvawkTUpcjVdiHigmPx37BlI6XkT0DGqt+XvYxsiQn+JjaVX
	07Dbw84InsDaQz6rqBm0c4ffgO4Wm6Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 52FA11C01;
	Wed, 29 Apr 2026 06:54:13 -0700 (PDT)
Received: from [10.57.62.76] (unknown [10.57.62.76])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F2ECF3F62B;
	Wed, 29 Apr 2026 06:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777470858; bh=op0PGB2RSdfIzNdbBTKjY7j2TmI/0VCoEC8J4z/6BVM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lLNh2XYt3BMVorNa0t/pHJR9WnAZJGdKKJRuZrRL2Jw8zDzv5mKfd13eRZgUo18bE
	 tqtHwaRW1y1Rq98Fcuu7NWuGV5fJNqwm1VBkGihwLn/V3T5pbJSZ3ik7FdjZyT+94f
	 jNf+YT+GlUAHbAAaM5w0hBAoSnAbx/LjM9mIo84I=
Message-ID: <a8740f95-e167-48ae-ae65-97c6701d9c94@arm.com>
Date: Wed, 29 Apr 2026 15:54:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/15] arm64: mm: Map the kernel data/bss read-only in
 the linear map
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
 <20260427153416.2103979-29-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260427153416.2103979-29-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: iz8tkqpkok9d5n71z4thfef6gnhf3oug
X-Rspam-User: 
X-Rspamd-Queue-Id: E58854000E
X-Rspamd-Server: rspam07
X-HE-Tag: 1777470859-588653
X-HE-Meta: U2FsdGVkX1/o5kf3tqzHZpblgjn3ll8dCUBZHfXxNzX5ZqAxnjVGcblGg012yOiQ/wYrmynP8qghcAJW/RFUBantIZUiyvkn+2Uli34O+7wogHebOO6Aqb6ltg89/+OOvOcBGAJjzPYNYVJtW0XElBIv6nL13VH5iL1cAebh90xdXYK12Oqxx7qsUjn9WiLoZMGx7mtcHVJrGXdMfY3c4pgULiQbjCDhiVke9tF9feuTOT5t96mRKtmCNZW/ChS97BvNbXy3d0ldNz2jYYn5EsCQT3xQ6TgV8Q4T5t4mmSqsKV5Vy5QhYb+Oz27qvpjzqa0KJcQ3nydC+y2lc1Y6fHjkpV1rDVJMhVAfCOLi3Q5lXAWTVIduux6l03mQO2NgMOACnP6MkcwvwsYV16IuCfyK4HV3JSgtNJjWIcV5DRDwKuYBLClUi1UJY9aiZ5bUakJc9HnZ03cletxisYK/yh/zVpsveBa9b+fiF8GWqUUh7Xm8/vmlq9L0U13ZQUA/rrNjjfz3ZS8ELGhjp9L0gJjzG3vIM5VhyZwfWVgB7juudyRtsHVZIr5vRr93YWQiYj1S2Oy6bZ5+rr5cdEGKGDCcx++VaNjvj+wV7md+is34MrgzGlMfGK9sydJ+Zo8lgXb9IZ05kZDMyHEPRfpPCCeZUx7+7QPSUrcg7GVOeZYCkKoxxcEOh1a5pMwx7qu7Lzh0EO19G776W0FSnUoEUHBBW/D5tEChYnzqKdcaGSs8bfszjlCmMg3kWk0K6ftw34yfcG/GrFp16SIdFprgCf4G77rQx2QJ0yjbv3qWtdspDCmwjR4ndZcWslANkj3CGNUZctndzRpRjjn2dQPofBUD0Datj00EFyAiO3Sl/dImfnKnPq9m9O6V+lCtnMGbm2qsxUKY+xUL0fM6EapbxPn+dlg8EH2WPtX4Nk/JOzWpuKbKIrxQHPE6uuX3jfn/iNz+Wdu4dT6tJ9ehfH/
 S+Q7Pn1b
 G4jjoUlBT4o1E8hUjNTC4L+TNd2lohW3c+/YKpeY03RsHb1rekbmSYlt89hrfsn8FOODosR1h6apes+2VIWAOOFwoV9CWXabDdjomPhY6tjdMS6DkOWFq+J+/JvrfJ+TtW3mxBATSB6+wWrg68mutdo8pqTzo0HIS67L6RhbUcVvtA+LQYETzQbCPRHD6HPiqKGEm8ynxUPb5d1nh+8XgI9e0JBvXDRfhO/fD5/b00hiKUHsCGGH5mMBfQRwP6HLcg0CU1jKwSFWla0/1wqrXjx43tp9snf+e60YKcEs3ujv/hLxCbSS7POSjzujicICLQpBb2ck6V2NjJg4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/04/2026 17:34, Ard Biesheuvel wrote:
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
> ---
>  arch/arm64/include/asm/sections.h |  1 +
>  arch/arm64/mm/mmu.c               | 16 ++++++++++++++--
>  2 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
> index 51b0d594239e..32ec21af0823 100644
> --- a/arch/arm64/include/asm/sections.h
> +++ b/arch/arm64/include/asm/sections.h
> @@ -23,6 +23,7 @@ extern char __irqentry_text_start[], __irqentry_text_end[];
>  extern char __mmuoff_data_start[], __mmuoff_data_end[];
>  extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
>  extern char __relocate_new_kernel_start[], __relocate_new_kernel_end[];
> +extern char __fixmap_pgdir_start[];
>  
>  static inline size_t entry_tramp_text_size(void)
>  {
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 1a4b4337d29a..9361b7efb848 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1122,7 +1122,9 @@ static void __init map_mem(void)
>  {
>  	static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
>  	phys_addr_t kernel_start = __pa_symbol(_text);
> -	phys_addr_t kernel_end = __pa_symbol(__init_begin);
> +	phys_addr_t init_begin = __pa_symbol(__init_begin);
> +	phys_addr_t init_end = __pa_symbol(__init_end);
> +	phys_addr_t kernel_end = __pa_symbol(__fixmap_pgdir_start);

Using fixmap_pgdir as an anchor seems a bit arbitrary... Couldn't we use
__bss_end instead?

It could also be helpful to add comments in vmlinux.lds.S clarifying
which sections are RO/RW in the linear map, it's getting pretty
difficult to follow.

>  	phys_addr_t start, end;
>  	int flags = NO_EXEC_MAPPINGS;
>  	u64 i;
> @@ -1155,7 +1157,11 @@ static void __init map_mem(void)
>  	 * of the region accessible to subsystems such as hibernate,
>  	 * but protects it from inadvertent modification or execution.
>  	 */
> -	__map_memblock(kernel_start, kernel_end, pgprot_tagged(PAGE_KERNEL),
> +	__map_memblock(kernel_start, init_begin, pgprot_tagged(PAGE_KERNEL),
> +		       flags);
> +
> +	/* Map the kernel data/bss so it can be remapped later */
> +	__map_memblock(init_end, kernel_end, pgprot_tagged(PAGE_KERNEL),

Maybe I'm missing something obvious, but considering patch 3/4 couldn't
we directly map the range RO here?

- Kevin

>  		       flags);
>  
>  	/* map all the memory banks */
> @@ -1168,6 +1174,12 @@ static void __init map_mem(void)
>  		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
>  			       flags);
>  	}
> +
> +	/* Map the kernel data/bss read-only in the linear map */
> +	__map_memblock(init_end, kernel_end, pgprot_tagged(PAGE_KERNEL_RO),
> +		       flags);
> +	flush_tlb_kernel_range((unsigned long)lm_alias(__init_end),
> +			       (unsigned long)lm_alias(__fixmap_pgdir_start));
>  }
>  
>  void mark_rodata_ro(void)

