Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADB74CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 08:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04B316B0005; Fri, 29 May 2026 04:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023146B0088; Fri, 29 May 2026 04:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1BB6B008A; Fri, 29 May 2026 04:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC5876B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:27:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C5F6A0BCD
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:27:49 +0000 (UTC)
X-FDA: 84819779058.04.57B3415
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id C250680009
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:27:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sZLc3D9c;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780043267; a=rsa-sha256;
	cv=none;
	b=jNcfo1csrUOrTS/1NMHuEpp1wtCH35kx7TXOxH9SHyqwOHvkFn3cD4ahPurEkUQ/3iM2Yt
	K1FzESkjreqMMAxMgnlY9sL6FRh7R0EoMXud2pl1qdPdrWIm3Td3yqMAWoABDxsV8vkCDP
	DLdfvERvoVZnZD5QO7paUX+VE0bHrz0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sZLc3D9c;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780043267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CH0z2W4yhgf/tO2JKbxj0lz1C+rTr91+0P7YFlO3hzg=;
	b=Sw+9a4xU1mqpv9xLa1CqViGCQTg4FAmQSzZy9+U2ORZnIeuuPiXqCQ0UrBTajez/JxjSj7
	4iUAi5ahYFu6zs1xfJ2mlY20Dlt5P/lloAW/yw2I6oeGePbb7QFIjHMLDrgqW0V8arKaBE
	RpU0IbynBj9Sboe+rL4sH1EqBz+le50=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2265201B;
	Fri, 29 May 2026 01:27:41 -0700 (PDT)
Received: from [10.57.91.162] (unknown [10.57.91.162])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F36E3F632;
	Fri, 29 May 2026 01:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780043266; bh=vGqKwtowp8PNMRvBO7niOdxzr80Af+Ycpil33LSytq8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sZLc3D9chfT7SLPciBg3CzU4tEgQd2MgnitSwynPVzMJkASztCzaS8U6eG48NlXUj
	 NjlYJAnCst9GC7POcH6vB4eJQPJcLzWDvzqPHQrCfUmthlePWs5wgYHTV4sko2IV+Z
	 aIr2mh8cXNbx5h2aQZIulPua6F09KFpwA+oUzHNk=
Message-ID: <2a6f9f05-ac57-4ef8-9328-74cc8ccfea16@arm.com>
Date: Fri, 29 May 2026 10:27:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 09/15] arm64: Move fixmap and kasan page tables to end
 of kernel image
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
 <20260526175846.2694125-26-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260526175846.2694125-26-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C250680009
X-Stat-Signature: mfi36ykxgyg95j9tmj963m1w6gtpc4qh
X-HE-Tag: 1780043267-893624
X-HE-Meta: U2FsdGVkX1+nX7Pb5hwZpc6V4c4PLFWsJhIztPnbLAXAx69EjDqisPyqtfncgEcsZHPzklrMz3AwfLy6y7KM2r5OUsQ8R/61TugWT4zjhRBIMeve4ZsG/zzRuJBXSpktEdMbl/es2NP15n0qwUx2yCysAMU2NVsCThQZa6bJl543WV90ErrCSrqJGPtTdMxdhCynqSgLPvISXJDKGgUGG/UiDHTMHySu+5KowHsNDHnxVjXMndths8YTpB7BteFIZyI3mgz15gkYIg+jfpl9HTbQrOqPvoBNppp2IIJrcoI59jY8GmbFv+IoAJzDpiaR+xI19fQeMuPhCuBcjwTgjLQqHshC2P9ZBX8iwmsmr/IZsEUoRQfMoq3qFrUUj2UzfMxy9XvqM3hATyBUdgx8eVqUA0fZOoNsqScddtFrKLVEYhZf7V0wiXjwDO04BEzJEbkqC4qS36TG2Ke/pth9gnjVxM0q7OkqMPkrzYXKtY4I7P+ypiEs5W4CkwoiXbHVA5GjdxtffUrOs4qo4E+uRqgFocXlZ22xR/BcNyf10PDHuQyfnlbOcnVUgSl1dXvblb9bFq7Db9VogZWuCm19PKNjPs0LMXpZDOSpchEiOGiQP5v13InilfC3cvdXWRCJtdM1HcpBMGkb0g0z6oxkGrtiP1h1zB2OXO6RvJNLHLGS0ElWJYS6NUWOVuaNfUdX8nkDUmpUMA0blFVoXPxWlr6/h3bsx0wet6dEAhan50Kp1OHMmpjRZFAF0MOzMtxuqK7Cepy05VTsDRQxFR/zlg/8CWzKEJ29+JjOfkQnPPYkbB4LYFOP33vAGhn/+cPkktpM5ej6yvTf6FnXQL8pB1+41WqM+WKCLSgGUeq999F4rE+ZBYOKlZE6n5nsxXNqPahekExs7NXbDWdAxnKvwhAI5fEi2f5ziawzul28B6s8fJMmXx1bdq5x9o2D2W6Nwh7i3Pu2l7IqK9Dd8Fg
 BhQCHDM0
 XUeUnvoIH/bvbJ3T/NwDAKOvhVj/9L3zDxaqJ8Y8l5OQrDRBg2wTPnH78O7u8i5RRuQgjH1aSdWJP+ww33sdJoF4ucWHOqKLWcWRfMzyv56p4fviurbdGbJ5iQNey3f88fhOt5g48KXuyfiSBzmc1l3k8WjFF7akxk0CKOl015iXLkLnEVtp2dZE3YTtGLjY6UI6BCUHMnVPOzTozO9mR0mq9OnNYlNlZjlvnLrV1Kbw23sWBoKJIzGbNEomGcHh6IybvM5T8wsKWx59IMwXJTkEj60Bmni2ieAbFfU0kMjKCBu43gNpoXNm9cFFnSvQcW++gWBXC8UWisGlE9YvNxMI8KP5E5jIpsO0p6nacqd4QeHECrw4s15BRXqGKCJ6YwtAR3bFVZeUg4d4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/2026 19:58, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> Move the fixmap and kasan page tables out of the BSS section, and place
> them at the end of the image, right before the init_pg_dir section where
> some of the other statically allocated page tables live.
>
> These page tables are currently the only data objects in vmlinux that
> are meant to be accessed via the kernel image's linear alias, and so
> placing them together allows the remainder of the data/bss section to be
> remapped read-only or unmapped entirely.
>
> Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/include/asm/mmu.h    | 2 ++
>  arch/arm64/kernel/vmlinux.lds.S | 8 +++++++-
>  arch/arm64/mm/fixmap.c          | 6 +++---
>  arch/arm64/mm/kasan_init.c      | 2 +-
>  4 files changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
> index 5e1211c540ab..fb95754f2876 100644
> --- a/arch/arm64/include/asm/mmu.h
> +++ b/arch/arm64/include/asm/mmu.h
> @@ -13,6 +13,8 @@
>  
>  #ifndef __ASSEMBLER__
>  
> +#define __pgtbl_bss __section(".pgdir.bss") __aligned(PAGE_SIZE)
> +
>  #include <linux/refcount.h>
>  #include <asm/cpufeature.h>
>  
> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index e1ac876200a3..2b0ebfb30c63 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -349,9 +349,15 @@ SECTIONS
>  	_edata = .;
>  
>  	/* start of zero-init region */
> -	BSS_SECTION(SBSS_ALIGN, 0, 0)
> +	BSS_SECTION(SBSS_ALIGN, 0, PAGE_SIZE)
>  	__pi___bss_start = __bss_start;
>  
> +	/* fixmap BSS starts here - preceding data/BSS is omitted from the linear map */
> +	.pgdir.bss (NOLOAD) : ALIGN(PAGE_SIZE) {

Do we actually need the NOLOAD type here?

Aside from that:

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

> +		*(.pgdir.bss)
> +	}
> +	ASSERT(ADDR(.pgdir.bss) == __bss_stop, ".pgdir.bss must follow BSS")
> +
>  	. = ALIGN(PAGE_SIZE);
>  	__pi_init_pg_dir = .;
>  	. += INIT_DIR_SIZE;
> diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
> index c5c5425791da..1a3bbd67dd76 100644
> --- a/arch/arm64/mm/fixmap.c
> +++ b/arch/arm64/mm/fixmap.c
> @@ -31,9 +31,9 @@ static_assert(NR_BM_PMD_TABLES == 1);
>  
>  #define BM_PTE_TABLE_IDX(addr)	__BM_TABLE_IDX(addr, PMD_SHIFT)
>  
> -static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __page_aligned_bss;
> -static pmd_t bm_pmd[PTRS_PER_PMD] __page_aligned_bss __maybe_unused;
> -static pud_t bm_pud[PTRS_PER_PUD] __page_aligned_bss __maybe_unused;
> +static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __pgtbl_bss;
> +static pmd_t bm_pmd[PTRS_PER_PMD] __pgtbl_bss __maybe_unused;
> +static pud_t bm_pud[PTRS_PER_PUD] __pgtbl_bss __maybe_unused;
>  
>  static inline pte_t *fixmap_pte(unsigned long addr)
>  {
> diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
> index abeb81bf6ebd..dbf22cae82ee 100644
> --- a/arch/arm64/mm/kasan_init.c
> +++ b/arch/arm64/mm/kasan_init.c
> @@ -214,7 +214,7 @@ asmlinkage void __init kasan_early_init(void)
>  		 * shadow pud_t[]/p4d_t[], which could end up getting corrupted
>  		 * when the linear region is mapped.
>  		 */
> -		static pte_t tbl[PTRS_PER_PTE] __page_aligned_bss;
> +		static pte_t tbl[PTRS_PER_PTE] __pgtbl_bss;
>  		pgd_t *pgdp = pgd_offset_k(KASAN_SHADOW_START);
>  
>  		set_pgd(pgdp, __pgd(__pa_symbol(tbl) | PGD_TYPE_TABLE));

