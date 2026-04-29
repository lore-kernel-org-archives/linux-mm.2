Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37960FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B63C6B00A7; Wed, 29 Apr 2026 09:55:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940D16B00A8; Wed, 29 Apr 2026 09:55:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F2A6B00A9; Wed, 29 Apr 2026 09:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CDB56B00A7
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:55:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 12B604027F
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:55:33 +0000 (UTC)
X-FDA: 84711740946.12.4596117
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 448D2180007
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:55:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pDgqQH2l;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777470931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CG8mxvp+9WMeIcWy1wftDi9ZvkCCuGPl8eEXQnOYotI=;
	b=FQq5ROW6PSlFfykgzxNSDozECnkIey6ckTJrjdyVe4XIxESxG/d7vQJRAUpPFzxpOMWM7Q
	qm60YGnIta7XLvQKWoaDVRkEfvscaKNae/VqVeexNZhvN2UlWnYLc4aPmad0GS9IeP38kO
	D6oxs3L+9vO1UpKhsBfXvkXvlKA7kRI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pDgqQH2l;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777470931; a=rsa-sha256;
	cv=none;
	b=SZE/1jNR7ljPjIhY//BsgEbmQkZBzNn0kd3tpAIxFVUQci5pXhBrWsIxU6QhwXK0PFUUJD
	61/d5WI1ztZJ+YgJZnDEAqQK+CZ+7Un5LKOxjJKfFud8chfckR+KdroZpeT8kXPo3UYnKC
	k83vUl693JKai/WGT82PAKLN7DvDJZU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1778B1C01;
	Wed, 29 Apr 2026 06:55:25 -0700 (PDT)
Received: from [10.57.62.76] (unknown [10.57.62.76])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 974983F62B;
	Wed, 29 Apr 2026 06:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777470930; bh=ehd9yGlOl8LsUGnM+WAez4P4lcrk3w5tIJe9Kpk+AvQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pDgqQH2lzWITgRoVEmuoGdabiAmMhLaT1ZMfM7SIK+Rh2M+sx+YhDLMb9+m8i+pq7
	 BFgHX04N0H1Pv832jzce4+t3UqetyKWkvzrjmPbNE0p5uIRsOlTJvPBunsdzPKcuNg
	 t05wSL1xU4xlMdtgk5TP3EQUW4y2jooZdRDRcbsg=
Message-ID: <15555e9f-65ab-4811-b20c-8ada90bdc9d0@arm.com>
Date: Wed, 29 Apr 2026 15:55:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 13/15] arm64: mm: Unmap kernel data/bss entirely from
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
 <20260427153416.2103979-30-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260427153416.2103979-30-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 448D2180007
X-Rspam-User: 
X-Stat-Signature: uekszw4zfrwjbqf8d6j6w7yhhyamer4i
X-HE-Tag: 1777470931-300778
X-HE-Meta: U2FsdGVkX1/cLRiCGXMo3IrRSsiQrAnyYEs1VmRA6sR1dzSNYdmZDCCOrkAMsI2OZw1Lw50+7u/iz6gtWSro9HPUL7ie/0zKGWlzTBkFqU/RWUgmpfJABYDblzkLl5l6x1vA+ik15X7plfZFSpUuOigo21xya1Fme5AYYFhyeEFdf/NVyKuockLw5FsZMCZTN00wXSMJF5r790qLJ0tSdbuRQTlFom7r20b2wW2Mq8F9BHTSiy7EL0oA7K3johiz9QiWYrsGMEY+qhU23bnwKYmnkehRl0ZfFR+RrAFGeaJcyZrUSwahG3oBK3ZHCEcBPDAmCX3ASMCuofhyZW3NiS919ObnlFJCo70mT04vO5mhJodPZi/mxTGoqDe4H16LqSmwmL1eV4wZlcZHhktgfOckL9uKKiB8fw9+vGgO7ZFKxPDFU5E3kwsnTU7Kg8B1JZqRfIxWbeCCbxb6l4H2hxtu5tLv2BIGYpahyPEuDQ+FpEOyceAGTBL9I7+4yZSBmbFLMRy8YE6rgGew1Y9fh3UaJSAzRLl8W9PKN920tCxAskt3+Xe1Kt1A19ya1DQJqkXzroj47C5zlGwb0bU2BzMvxRUBiJQ6xmnqHvd7R0ekLGFx7cE/g3DBU/FFmKecsqjjMestkNYObB7+IDTbaggYTpa5H+SFLJoyZ5xhixBr8vUo0seSTUI1fiMGcEj6tXws4rTsFXJr+0L7ab0taXds4VebSH7CIC7p7Wpf1zJEj1v+o4lp4wR1XUpxLxA04gljJO4VP+k+fRE+mUxkcNhjh8JGOt52fEksUcxVypewb7qciRTLzEDOgMydxKcUnE2fNYIf6rR2DyiKpQdCSRAoGaeii/icG9wOfwleESFIAa4M8T0aNfpFkgAYvtVG7mmbxlnuvPy1CzjdxfI7yxZaQAfyaRVcKe8B1M7izEWq8HYpotn/a1bOutoEMksFmDL9Av3QJaVklclQjaM
 KdzayLkL
 aDcI0lLGjn4Z2hWRmLNwrkGJnk76a6FPgWV0wWHj8NPxuYwMJ9XyQJrLFfv5tNWiJ58g4gA7UhU/W6lfjvznMBiIGVitybt/ONtE4CKwgJyMmv/EofpM5j5yYW80172Kay7NkTyPZ4boDjCh15Myob0pbNkdw4GHBBxTwpSWXCvCpVyVYy2s5Ey7FD+Z35dZh5GS1z1rFWQ6nSLnuj0fUlNKFriNzuwRhHiu9M569zrehogbyV+BXjDMVB75YXjp5xrf0qbaDtFFDEFMnvcnkSa4eXUW7WNFwv6Ch9ypkZ9xwzP8N76sq8lWqbXRXiJwKs1B+OIsHRl7UheTYVJDxeNcNNVkNxNt0E91HCTthq8Y5UX7mcdCHLgKbCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/04/2026 17:34, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> The linear aliases of the kernel text and rodata are mapped read-only in
> the linear map as well. Given that the contents of these regions are
> mostly identical to the version in the loadable image, mapping them
> read-only and leaving their contents visible is a reasonable hardening
> measure.
>
> Data and bss, however, are now also mapped read-only but the contents of
> these regions are more likely to contain data that we'd rather not leak.

That sounds like a good rationale but I wonder, is there anything
stopping us from unmapping text/rodata as well?

> So let's unmap these entirely in the linear map when the kernel is
> running normally.
>
> When going into hibernation or waking up from it, these regions need to
> be mapped, so map the region initially, and toggle the valid bit so
> map/unmap the region as needed.

Doesn't safe_copy_page() already handle that? I suppose this is an
optimisation to avoid modifying the linear map for every page, but if so
it would be good to spell it out.

> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/mm/mmu.c | 44 ++++++++++++++++----
>  1 file changed, 37 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 9361b7efb848..a464f3d2d2df 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -24,6 +24,7 @@
>  #include <linux/mm.h>
>  #include <linux/vmalloc.h>
>  #include <linux/set_memory.h>
> +#include <linux/suspend.h>
>  #include <linux/kfence.h>
>  #include <linux/pkeys.h>
>  #include <linux/mm_inline.h>
> @@ -1040,6 +1041,31 @@ static void __init __map_memblock(phys_addr_t start, phys_addr_t end,
>  				 end - start, prot, early_pgtable_alloc, flags);
>  }
>  
> +static void remap_linear_data_alias(bool unmap)
> +{
> +	set_memory_valid((unsigned long)lm_alias(__init_end),
> +			 (unsigned long)(__fixmap_pgdir_start - __init_end) / PAGE_SIZE,
> +			 !unmap);
> +}
> +
> +static int arm64_hibernate_pm_notify(struct notifier_block *nb,
> +				     unsigned long mode, void *unused)
> +{
> +	switch (mode) {
> +	default:
> +		break;
> +	case PM_POST_HIBERNATION:
> +	case PM_POST_RESTORE:
> +		remap_linear_data_alias(true);
> +		break;
> +	case PM_HIBERNATION_PREPARE:
> +	case PM_RESTORE_PREPARE:
> +		remap_linear_data_alias(false);
> +		break;
> +	}
> +	return 0;
> +}
> +
>  void __init mark_linear_text_alias_ro(void)
>  {
>  	/*
> @@ -1048,6 +1074,16 @@ void __init mark_linear_text_alias_ro(void)
>  	update_mapping_prot(__pa_symbol(_text), (unsigned long)lm_alias(_text),
>  			    (unsigned long)__init_begin - (unsigned long)_text,
>  			    pgprot_tagged(PAGE_KERNEL_RO));
> +
> +	remap_linear_data_alias(true);

It's really hard to know what this does without looking at the function.
How about mark_linear_data_alias_valid(false)?

> +
> +	if (IS_ENABLED(CONFIG_HIBERNATION)) {
> +		static struct notifier_block nb = {
> +			.notifier_call = arm64_hibernate_pm_notify
> +		};
> +
> +		register_pm_notifier(&nb);
> +	}
>  }
>  
>  #ifdef CONFIG_KFENCE
> @@ -1162,7 +1198,7 @@ static void __init map_mem(void)
>  
>  	/* Map the kernel data/bss so it can be remapped later */
>  	__map_memblock(init_end, kernel_end, pgprot_tagged(PAGE_KERNEL),
> -		       flags);
> +		       flags | NO_BLOCK_MAPPINGS);

Might be an obvious question but why do we need this?

- Kevin

>  
>  	/* map all the memory banks */
>  	for_each_mem_range(i, &start, &end) {
> @@ -1174,12 +1210,6 @@ static void __init map_mem(void)
>  		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
>  			       flags);
>  	}
> -
> -	/* Map the kernel data/bss read-only in the linear map */
> -	__map_memblock(init_end, kernel_end, pgprot_tagged(PAGE_KERNEL_RO),
> -		       flags);
> -	flush_tlb_kernel_range((unsigned long)lm_alias(__init_end),
> -			       (unsigned long)lm_alias(__fixmap_pgdir_start));
>  }
>  
>  void mark_rodata_ro(void)

