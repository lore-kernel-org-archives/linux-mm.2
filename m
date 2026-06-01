Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB87ACD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 10:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E8C66B0319; Mon,  1 Jun 2026 06:43:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0996B031B; Mon,  1 Jun 2026 06:43:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FCF26B031C; Mon,  1 Jun 2026 06:43:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E4BA6B0319
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:43:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AFCE99019F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:43:42 +0000 (UTC)
X-FDA: 84831007884.02.6AC7486
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id D9CF31C000F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:43:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ATGD2KEF;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780310621; a=rsa-sha256;
	cv=none;
	b=xh5hpD3dcl2LAvKWDZ2jgyMR/MmsdzbDrludz61Gg0cRkhMjzJ3MKCXoMF2lj49ihbIQuJ
	E3ubf7gyF3bhAj7pecIx9fnAI6rn8RWKjKCCZZmTFwVfPLuM1HXyBg7lKxSLOS9BBjnQQz
	hI9S7E+mas2WzCp+Erx+gUiCoEmOHfo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ATGD2KEF;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780310621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BdxzfLXr6/G/k/tGtVLcYYbC4QvrQHAxO2smMCOSTy4=;
	b=DsyT983MMpoK2ve2+10w5rU73sdYIEb4oNltnIYcF2B9MD9G2sU7h8AaNZ+cAX/MGROii7
	Y9p0IBh4daz4dGbeADFE5ldMFouAzmY9P+vkkK73dQ3a0llFiPSxWDG+9yArWdqrj9zLru
	iXmXXH7UN+G67wdxRGluOFGnR1lZaRg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB1D41516;
	Mon,  1 Jun 2026 03:43:34 -0700 (PDT)
Received: from [10.57.94.8] (unknown [10.57.94.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 38E4D3F905;
	Mon,  1 Jun 2026 03:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780310619; bh=C3+Nupy9epvTU9YJN+UUOeTEoo2XErmrS9cELXLEaTU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ATGD2KEFk9zH6A/3/wbmsLo8Bk16zruKAja2MWpstRHrcKrUHTc7cCqmaTsy1kze4
	 vG+kAYpgRYGrfxsVM+k07lFcID8aETdcpIWAaY6POEOlyHhT7SAbyCaNPXgf688bb2
	 NWAccF9tR54IJl/TxpZC5Vs/Yx5VmFz06QrmL7VQ=
Message-ID: <e9187fdb-b4dc-4b82-8783-fe1eb221d885@arm.com>
Date: Mon, 1 Jun 2026 12:43:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 15/15] arm64: mm: Unmap kernel data/bss entirely from
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
References: <20260529150150.1670604-17-ardb+git@google.com>
 <20260529150150.1670604-32-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260529150150.1670604-32-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D9CF31C000F
X-Stat-Signature: nzdj17zfbyn5rkcmkqpcqb6au6z7q77o
X-HE-Tag: 1780310620-192111
X-HE-Meta: U2FsdGVkX18K/MkrD9KEaDkaLl+xcLyj74Bu5rz0pSffM+4+bjadiE28RqU6s+DOQGpfMpm4oCLsU/4A9cvcuPiF6MgzJWI6cwql/6qoJmp4xwzLiINUq+FiRcVKEseNljlXUHcJHMRAJGW5xsv8Cfl1H73h5ZUW8hrHTiO2/vEp3EAD6aYST6bRHm1K1KOpk7uXbfY/EoGSnC1vO4/3cnLqq1O/HFjtO6uIxEkWiET3HhM6g8WGSoKyGUdt/xiR53ay2s+fh1RypYpWdOHdyagyedGuwp8ExYrKZJW06chss6d/iYkCX1YmHxmIeEA67/hNz1Tcs9uJekaAjkJbWrZLG3F9nWscW+LI3y8pYMJ01uFUORKyrnw2jEgUNPyRCZLdefkWQqnAGm77EZFDD5HVDFAgFqxSP86T5UOcsHIxDcNEYOuWfDxyw6Yr2EP1FB8sXCiLdMY4fZtrZIZNx3RJyXgW2IYE9TEekEhxQKhjLrmLdevNaGFF2VxttR98cIjhIu2YKJyBNdNV61vAdpWkSnfF+auTVet8LzNEb+DGJJA3I43lUXYkKDG/VmJ+g+6OPOmppmesrXjoyJ5pDL/c67xNGJHoNb2vAYKc5qGTUhB5BiFidnPk7WJp8cLL4UXeqlnuIzbL0vDYt1E2TP7QwUWvyGBaNQZwmYGZvjImkg/soZxNaemI+9fuzQhwJa7xvfXA1PUOJipwctz0OmP1j04jPQhQSVy6VY0dA075fEHkz7DxisVHApJGt27J7VPxDrDRS+2fijXyK23rr0aypVvcgWudpHxAUt30jUnRejD1G99ausKQ2/AAbGbncT1vBD3pMHvG3ky3UzEqsLVxH6W5Hkovj+tH6oMiJtXsbLd15jBN/hmiJqkrN8k2iQOZeRXibPSLH28+fHCSRonP/wz8dx+RRMO4jhlw3gSDeG0Sj9pyoVeey30Pc4+UAO5ZGF119PxlIoZ9xIZ
 5wt2zdSL
 iFB+g/MibeL4M3Uq8s3FbaW46Uiirg0otqS1HTfwXVRRna9hRbTjod8JdXssSr9JxJmKWgMSEGkn8liSBs40q2Pk/5dCNA7lh3pHnPRCfvQGw/YRv0pnVk9zNkndkJV+VCkNBG0ndHTJJampnvUhHIso6h40IGi9o3Ti60BUrf8UaCnzD7otUPsTOu7R1t/qgGFj++Mqv8npiLvgBAUM+ovROuVaZpMOIRmDCt1U51Lg+24u0xUT4EuCE0PuHpS3eMlBMe59UMKq6yab5QgPBC50MfL8cebQC8dDYiKoMvf9rFaQgOxW66pNjAKtQKHVQ85LkaCXv1cEF6puNKd+3mVWbf68irDeNJ1ocLCjkR6IwFRuqbrpXrJJZc6pwGajYHe0dJuJRfepjx70=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/05/2026 17:02, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> The linear aliases of the kernel text and rodata are also mapped
> read-only in the linear map. Given that the contents of these regions
> are mostly identical to the version in the loadable image, mapping them
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
> map/unmap the region as needed.

s/so map/to map/? Also not sure what "initially" is referring to here.

Otherwise:

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

I don't know much about hibernation though, would be good for someone
knowledgeable to have a look.

- Kevin

> Doing so is required because pages covering the kernel image are marked
> as PageReserved, and therefore disregarded for snapshotting by the
> hibernate logic unless they are mapped.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/mm/mmu.c | 45 ++++++++++++++++++--
>  1 file changed, 41 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 7b18dc2f1721..07a6fa210171 100644
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
> +static void mark_linear_data_alias_valid(bool valid)
> +{
> +	set_memory_valid((unsigned long)lm_alias(__init_end),
> +			 (unsigned long)(__bss_stop - __init_end) / PAGE_SIZE,
> +			 valid);
> +}
> +
> +static int arm64_hibernate_pm_notify(struct notifier_block *nb,
> +				     unsigned long mode, void *unused)
> +{
> +	switch (mode) {
> +	default:
> +		break;
> +	case PM_POST_HIBERNATION:
> +		mark_linear_data_alias_valid(false);
> +		break;
> +	case PM_HIBERNATION_PREPARE:
> +		mark_linear_data_alias_valid(true);
> +		break;
> +	}
> +	return 0;
> +}
> +
>  void __init mark_linear_text_alias_ro(void)
>  {
>  	/*
> @@ -1064,6 +1088,21 @@ void __init mark_linear_text_alias_ro(void)
>  	update_mapping_prot(__pa_symbol(_text), (unsigned long)lm_alias(_text),
>  			    (unsigned long)__init_begin - (unsigned long)_text,
>  			    PAGE_KERNEL_RO);
> +
> +	/*
> +	 * Register a PM notifier to remap the linear alias of data/bss as
> +	 * valid read-only before hibernation. This is needed because the
> +	 * snapshot logic disregards PageReserved pages (such as the ones
> +	 * covering the kernel image) unless they are mapped in the linear
> +	 * map.
> +	 */
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
> @@ -1193,10 +1232,8 @@ static void __init map_mem(void)
>  			       flags);
>  	}
>  
> -	/* Map the kernel data/bss read-only in the linear map */
> -	__map_memblock(init_end, kernel_end, PAGE_KERNEL_RO, flags);
> -	flush_tlb_kernel_range((unsigned long)lm_alias(__init_end),
> -			       (unsigned long)lm_alias(__bss_stop));
> +	/* Map the kernel data/bss as invalid in the linear map */
> +	mark_linear_data_alias_valid(false);
>  }
>  
>  void mark_rodata_ro(void)

