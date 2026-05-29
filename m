Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40344CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 08:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9766F6B008C; Fri, 29 May 2026 04:29:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94DC36B0092; Fri, 29 May 2026 04:29:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88ADB6B0095; Fri, 29 May 2026 04:29:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4C66B008C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:29:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 488451A117B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:29:57 +0000 (UTC)
X-FDA: 84819784434.28.C8888FF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 836B640008
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:29:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lsoxhOxi;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780043395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQVon7otOC8tUidq6mZ66TIYmxH1F3ZWevqgSsL0xBQ=;
	b=7CNJYsFtojqhPDxQRwsAdUr9i5RWEqRgKdyd4cgdYvmaBHoPG3qqEex1Bs15YPsCu5pW6v
	FlP0sJyDcJJgyhFO96rUVd5GbWiqlDHtuLf97LEu83NfrZiWLYuVFGqf9clXErm9x5uYqK
	pziiZAwV2hjZuFCCvhjLbU99uGZjFoQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lsoxhOxi;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780043395; a=rsa-sha256;
	cv=none;
	b=H1Tdup02ztvM6fuggV7XuI53zxPXJ65D9K3JgIuCi6bvelbsmrzveHo6FvssXC1q4Fdr1J
	qTwpZTF/IQFb9rIjP3Kub9WP8B11ZN+gctZzZIW6VTf6nbJ4JPab57zbNqEe0VpGy1xqcM
	tjmmLU66l+2TXGrK2Nzq0OA32Wzt+1E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4B8632E5;
	Fri, 29 May 2026 01:29:49 -0700 (PDT)
Received: from [10.57.91.162] (unknown [10.57.91.162])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6892D3F632;
	Fri, 29 May 2026 01:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780043394; bh=LpGrRJmNWPcHaRlBV5w3lZl9XAW9wUfZkoWTWBy1nFU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lsoxhOxibEyJ5lHCGdr76YlKUY9UPjWMsbTlSjV42xLs3UC50ylcZ0jNiRAuX0LGv
	 ROtFFBK8bd+Dt4HWaxYhwBs7wmthKtbXrEd5RFcjHrtddOa2uIt79pP/Ld+WjmS07W
	 9VlU1fIqvgS6mSD3ptke3Hza5XxLJoHl2kJtRHTA=
Message-ID: <22042b98-cfcc-428e-bb08-ebcfe785eb69@arm.com>
Date: Fri, 29 May 2026 10:29:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 15/15] arm64: mm: Unmap kernel data/bss entirely from
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
 <20260526175846.2694125-32-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260526175846.2694125-32-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 7gnm8w6xsxi6coeaho6bfp9kn9o6jkkq
X-Rspam-User: 
X-Rspamd-Queue-Id: 836B640008
X-HE-Tag: 1780043395-975290
X-HE-Meta: U2FsdGVkX18gkhkMSajD42zrC5QwxzQwDIBxteEqFKMIET91A/lc3+guOHIhdNfImrgt8NK7Lw6rVhnMTW5D7jr6dt1sfOjwEr5MAkStmjDJhQ1GzQajTx75S8kX0VTKVeUlbj7qujnUiv9sfKKsbRrr+keauvHG2ZjbYZ7LKfFS6XchYspoFCjeTu3W7Y1sFF2i/NRFcAkZGUTwFE1x/AgKlOTqgNJ6LJcEDdjvS/F9aGBzAJZtnNnSwPeM+TDybyNR30URzg0TsrAJulBSiCrCttyK9+JO/pJP4JaLIKt6xG9LHCMooJlKLdnVcpix5mEPzK0VI9YJEAU7Rn5jXNLwUOohWdL3octWbc/a+iniBMW5GMKUOPiRmuGHIEjliHeZeATkFIh/4Fyl5R9e8zMOT6Oej1q+gYEyocdoyBpG4+2tk/72ZMjMn6vOFNGKpPOu1IVqamU94hWFRDDq5+GjPWxJXI+a0BU+wYTb9e9oXv9ZPaqhny2SZuGsL97WSsnxs99uWVYSiECwPklvArkReP/KvcSQLnqPWH0G+58NwC0v4ff3QKTtjjTQypE2yowNO2MHRLRWzvsBTPd2IteLBPgIrVMka/nJ0lmEN/KYHGht+KCz3SKO1/gXP34H/M82BxPrETK1hk+BJO4BbP1O+EkbrfLzNBBZdpUQ2S4NvMis0Pn8eoPJ5CgjUmkTgZJeBEe8cXD0Ln2733RM8vS2z+Qh1tfTXqW/xUzpUedJ24flt/ze7LDPhcI7a1e3k8ncC3oKdE+40P44DBCH6zBlmVgtWuH1hBuZ6bYZ3cBq+YgVFqNIvMdQ4lUT26PxK8JQ5b+fpPH2uB3iSvX+GKlFaF4VOqsP6TKswdsAls/lFsKDxricN7sc51KFFSJnG3T0mN6OZlA0BEduBYeRiMOA+NqwJYRV041pxp7ntrpaxhALjVb2zRNE+dAOeSWrwwXj8pjtXcccAQb2LlY
 M3RKoORi
 Oml3/EbTFnLEdTY10pfWLV38BQvES2dxc1H3qs9nAYuM7uu2/JdRtlmVEWh2gZZO9v30AqclvtA/eCcxugaw9v42Aa5fcXIAeqNOYEuEtU9ERGqbW1x4DN0HrqtdmSV0EoX1N1LPc22vscPfcxGLrEDdYXsh9QI1wHB6gV0DeEmAcVHh7y7yUCKpR9nQYYkZcuDQWerAC51w8mSyNUyczSp66wJWKkFb+eQuhaTzaWok5ITMt70cExmq22Wz2aGJuD4duCnQRxkuNp3nMkWLxEZB1lWbXwJRWIB8NHi4c2gl7CJ11I8zjRTcGf51Aktf29WWLXmCNA3Bpm0d4CAlCJE4CdczkqLCTc9P4/+kpRZhvF3yaCKoAbWWvDM3D5MR1SP6kg+1qheEvMHmNDhu/XM4xNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/2026 19:59, Ard Biesheuvel wrote:
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
> So let's unmap these entirely in the linear map when the kernel is
> running normally.
>
> When going into hibernation or waking up from it, these regions need to
> be mapped, so map the region initially, and toggle the valid bit so
> map/unmap the region as needed. (While the hibernation snapshot logic
> seems able to map inaccessible pages as needed, it currently disregards
> non-present pages entirely.)

I'm not sure I understand this, is there something wrong with the
kernel_page_present() check in safe_copy_page()?

> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/mm/mmu.c | 39 +++++++++++++++++---
>  1 file changed, 34 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index e7ca53d20b87..cb00e42abbe1 100644
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
> @@ -1056,6 +1057,29 @@ static void __init __map_memblock(phys_addr_t start, phys_addr_t end,
>  				 end - start, prot, early_pgtable_alloc, flags);
>  }
>  
> +static void remap_linear_data_alias(bool unmap)
> +{
> +	set_memory_valid((unsigned long)lm_alias(__init_end),
> +			 (unsigned long)(__bss_stop - __init_end) / PAGE_SIZE,
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
> +		remap_linear_data_alias(true);
> +		break;
> +	case PM_HIBERNATION_PREPARE:
> +		remap_linear_data_alias(false);
> +		break;
> +	}
> +	return 0;
> +}
> +
>  void __init mark_linear_text_alias_ro(void)
>  {
>  	/*
> @@ -1064,6 +1088,16 @@ void __init mark_linear_text_alias_ro(void)
>  	update_mapping_prot(__pa_symbol(_text), (unsigned long)lm_alias(_text),
>  			    (unsigned long)__init_begin - (unsigned long)_text,
>  			    PAGE_KERNEL_RO);
> +
> +	remap_linear_data_alias(true);

As suggested on v4, something like mark_linear_data_alias_valid(false)
would be clearer.

Also, is there anything stopping us from doing that directly in map_mem()?

- Kevin

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
> @@ -1189,11 +1223,6 @@ static void __init map_mem(void)
>  		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
>  			       flags);
>  	}
> -
> -	/* Map the kernel data/bss read-only in the linear map */
> -	__map_memblock(init_end, kernel_end, PAGE_KERNEL_RO, flags);
> -	flush_tlb_kernel_range((unsigned long)lm_alias(__init_end),
> -			       (unsigned long)lm_alias(__bss_stop));
>  }
>  
>  void mark_rodata_ro(void)

