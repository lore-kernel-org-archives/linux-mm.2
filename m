Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0059CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 12:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13A2A8E0010; Tue,  9 Sep 2025 08:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1117B8E0001; Tue,  9 Sep 2025 08:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04E9E8E0010; Tue,  9 Sep 2025 08:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9BC48E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:17:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4307B9B86
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:17:41 +0000 (UTC)
X-FDA: 83869612722.14.096CEA6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id EBA0F1A000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:17:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IFg7XF5C;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757420260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UNqNdIyyKvlQsffc32Vo1vye5nnPAB3Xttji1HxWmGo=;
	b=pjgqluq0XxXO4znC57pCXRdgRAlvlrTArxbF37e6zUvV5Yzpbbeq+C4CAYpvjpoOkV5Rlq
	IooZuqfWFNOB1P0TxUOxABpxhn1KjyNSxacAlH/DrRM5XnNqFEVdWyoek3voydMAsce91T
	olAaEWw8OMP2P6d52whCH9p35+X7ReE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757420260; a=rsa-sha256;
	cv=none;
	b=PEwEjxtI+IcQeEuUya4fsH+ebMQyaCoEYtsoqJZF6KSA2YtnNkN6oOwZS1Vo2H1wH0p3fp
	c0M9LWduF13DjQTXXhM6zi9p2+Q6zYX7cWoAQAdp1apQSLPrLbqPDE4RSF45WPXl3hRJUL
	UDvQolHP+68EnYEU6v9SwKT7jz+WcUc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IFg7XF5C;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A41D4045D;
	Tue,  9 Sep 2025 12:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F2BC4CEF4;
	Tue,  9 Sep 2025 12:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757420258;
	bh=CINqC1yuoC6EN3JTqav2e34BO45tJWHN4hfmBhvxPS0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=IFg7XF5CNMe84ZyievChiP1ILlqSCeMTZctwDIz45qv4ppTlVwgySeVsyMhey4TIZ
	 HPJB087o01tclncA+qQFNTwJ+5slt7Neo2Ybi2YKxfpNMdUjskKBEt70norm4UjrH8
	 6xmeU6/C2nzTUxrOhKxG3ByoMFqgvx952HpSIbGXXfTmFgJso6E0a1/lVzLCYMWtTI
	 ME4x1Cd0o187Z3d/Zf38O/NHoGJcQdNd/hyaop6xvqBnIM9TF9AK/XGFJ4kMoWPo/h
	 J2N8U1CU5gqWbDwUKKQ/p8B40uXxaPCKMaK1kHMk7QJ/CmfhaVq1oq2tTWLKRBm3hw
	 9A3L+M93ZW1dA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: Ard Biesheuvel <ardb@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Alexander Graf <graf@amazon.com>,  Changyuan Lyu <changyuanl@google.com>,
  Andrew Morton <akpm@linux-foundation.org>,  Baoquan He <bhe@redhat.com>,
  <kexec@lists.infradead.org>,  <linux-mm@kvack.org>,
  <linux-efi@vger.kernel.org>,  <linux-kernel@vger.kernel.org>,
  <nh-open-source@amazon.com>
Subject: Re: [PATCH v3 2/2] efi: Support booting with kexec handover (KHO)
In-Reply-To: <b34da9fd50c89644cd4204136cfa6f5533445c56.1755721529.git.epetron@amazon.de>
References: <cover.1755721529.git.epetron@amazon.de>
	<b34da9fd50c89644cd4204136cfa6f5533445c56.1755721529.git.epetron@amazon.de>
Date: Tue, 09 Sep 2025 14:17:35 +0200
Message-ID: <mafs0segvlt0g.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: gtgcktrnuird6jj5kxr4nxxzqmdwe6wr
X-Rspam-User: 
X-Rspamd-Queue-Id: EBA0F1A000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1757420259-878655
X-HE-Meta: U2FsdGVkX18QzPh2pTFH/pecLkid/G3HRIvcbN5+lyBdvAuEwWnQoh4I7GPZvfk/DqViL5IvgWf49k0kq7fffuIvVqhIXsFsG4MrUDvlfeWMqzG+KsgctdrxnkQS7FHCz/iG42SPLDs/RsMnAlE8DlbYwoKxglo5Kf4UpGreM1gUA07wV7C+59uW7/hnlBJPDNGC6Ible/VgLOCRnn0eIlRm8DLytKKKZrsoWEKUURGaCGEqDC3VMYnm0JCf9AaKpq+KjAY6Yqg1vyXtB5cGKl1vCW92vr5EiJwAfpOdwKOdlp58Twb3wh8wh6yByU/FIJjQGj6SaI/bPk459NL8jJ1e5cR+mXhPItXFGXaVVZ2/6VZ/y3zZAeWtlzu9M+2xnToUs09ZQn9UvvQDG3eotddRGudhn7FZXWvkE8CiIW8I9JUfQApc4kJcSBkMOn6g/GyF8VbZVmZrXQkrLSiWiyBH0TzR38S0xFXLERdVVkTaha+IqQvwXhLtJBM1GSbJkftqS6U3dL1EscA5jnNJl6ZnPJkuJnnclR2SMu1nfCxRIcxCBq5ShNe6BJw05HSaWwbkQmtslK8EbvtdF+myoI5xyfB31w3apxwgl/CjOi+fpRR/5Bs+Gu5M/OU0D1ojHHhG/nvEJrPNTx11wpHeB++kmH5s6tg2AZmTB9NqCdFyp0eKX7m9txPjhUEoapQ6fYMO4/JIGYHlLXvES9GQDTZyy3TzBzi7OTmqLp7kTLsfHzYO9cqvPm5Ssk+uwz1E5ghE3dqO+ovfxFMxBTIzpupBLNHaB3BZ/gdcVCiXNviO/dayzRIqWETwBwb3oZ7UZGccWdQ/xdIr7BDqwQQj80agbRZBbzcoBX72MVBLWJjon77plQPOUaoHTx+G3s/yAPz6iGYiXNF/6b0C+I0ZPKKmgx5QpzfZVs8fBP3fLnMTLp69wUqiSGDv9Y4NVc83MTvn3ymFxOxqnzYEg5x
 gXHmSW8v
 +Rv79ZN3txgK8c0p10QQPrJYjl41LtBOnL6Lqa9KXymOoLAiahn9UZ/so+0heeblyarKvcUNbPAVJP6ebwwoAOXjp/dsIMs7jsMrW4QtueiyWE1VW+acCKsJnZWeZx/o7hyizT5Afu/CCx7+2HVJKQ9mXN8VOxvtbxTEJyv9SKjBJBP5lMOa0I2fh+DcRd/u+rSmaO8kpypXy4XJUKmeWCry1KBylPOrb+gWoNbSXZtOHzIA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21 2025, Evangelos Petrongonas wrote:

> When KHO (Kexec HandOver) is enabled, it sets up scratch memory regions
> early during device tree scanning. After kexec, the new kernel
> exclusively uses this region for memory allocations during boot up to
> the initialization of the page allocator
>
> However, when booting with EFI, EFI's reserve_regions() uses
> memblock_remove(0, PHYS_ADDR_MAX) to clear all memory regions before
> rebuilding them from EFI data. This destroys KHO scratch regions and
> their flags, thus causing a kernel panic, as there are no scratch
> memory regions.
>
> Instead of wholesale removal, iterate through memory regions and only
> remove non-KHO ones. This preserves KHO scratch regions, which are
> good known memory, while still allowing EFI to rebuild its memory map.
>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> ---
> Changes in v3:
> 	- Improve the code comments, by stating that the scratch regions are
> 	good known memory
>
> Changes in v2:
> 	- Replace the for loop with for_each_mem_region
> 	- Fix comment indentation
> 	- Amend commit message to specify that scratch regions
> 	are known good regions
>
>  drivers/firmware/efi/efi-init.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/firmware/efi/efi-init.c b/drivers/firmware/efi/efi-init.c
> index a00e07b853f2..a65c2d5b9e7b 100644
> --- a/drivers/firmware/efi/efi-init.c
> +++ b/drivers/firmware/efi/efi-init.c
> @@ -12,6 +12,7 @@
>  #include <linux/efi.h>
>  #include <linux/fwnode.h>
>  #include <linux/init.h>
> +#include <linux/kexec_handover.h>
>  #include <linux/memblock.h>
>  #include <linux/mm_types.h>
>  #include <linux/of.h>
> @@ -164,12 +165,32 @@ static __init void reserve_regions(void)
>  		pr_info("Processing EFI memory map:\n");
>  
>  	/*
> -	 * Discard memblocks discovered so far: if there are any at this
> -	 * point, they originate from memory nodes in the DT, and UEFI
> -	 * uses its own memory map instead.
> +	 * Discard memblocks discovered so far except for KHO scratch
> +	 * regions. Most memblocks at this point originate from memory nodes
> +	 * in the DT and UEFI uses its own memory map instead. However, if
> +	 * KHO is enabled, scratch regions, which are good known memory
> +	 * must be preserved.
>  	 */
>  	memblock_dump_all();
> -	memblock_remove(0, PHYS_ADDR_MAX);
> +
> +	if (is_kho_boot()) {
> +		struct memblock_region *r;
> +
> +		/* Remove all non-KHO regions */
> +		for_each_mem_region(r) {
> +			if (!memblock_is_kho_scratch(r)) {
> +				memblock_remove(r->base, r->size);
> +				r--;

Hmm, this caught me off-guard. I had to do a double take to realize that
memblock_remove() would decrease memblock.memory.cnt and move the whole
regions array back. A comment would have been nice here.

But then, I wouldn't want you to do a full resend of the series for this
minor nitpick. So perhaps whoever is taking this patch can add one when
applying? Either way is fine though...

Acked-by: Pratyush Yadav <pratyush@kernel.org>

> +			}
> +		}
> +	} else {
> +		/*
> +		 * KHO is disabled. Discard memblocks discovered so far:
> +		 * if there are any at this point, they originate from memory
> +		 * nodes in the DT, and UEFI uses its own memory map instead.
> +		 */
> +		memblock_remove(0, PHYS_ADDR_MAX);
> +	}
>  
>  	for_each_efi_memory_desc(md) {
>  		paddr = md->phys_addr;

-- 
Regards,
Pratyush Yadav

