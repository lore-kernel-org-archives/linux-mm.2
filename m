Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4999C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 05:55:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C20A66B0005; Mon, 29 Jun 2026 01:55:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD1A86B0088; Mon, 29 Jun 2026 01:55:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE8936B008A; Mon, 29 Jun 2026 01:55:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8AEBD6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 01:55:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7AEC12056B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:54:59 +0000 (UTC)
X-FDA: 84931886718.06.6D11BF9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 13B484000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:54:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XpwbJMbX;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782712498;
	b=46Bmv8iGk2hOG1dTJ3W9HK8lRcaVSMqd9K6KAn9PMUXr2LUjtUyOugXFvNC/T/hDN3ShYb
	dXMUu0F9ZbGRV8as9zcdl7eOl4Mmt+hfLlddu4pK74JzLfIfjwgj0lKEMzDef4swrpVHdA
	bYlilXvwNH+NRZYdeJj74SGzHpVnDwo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782712498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ovwOI+hzFwt2cW+UwFEe1mkwXl5Iadp2UTL8OL/Kuk=;
	b=0SbldomXgknNaRVXVzuNIWT5e5DUzG4Sp4y7H/xThAOhX4MEIGWKTJZgDD6lGR6OYwh0H/
	GEVl99VE2KafRmRXBqrW5MXdRztrmxW6JfeBi6/YAJpeVU/HytW7EvJ19Rbz0Y37WcEFE3
	2M0PYh8QMbwBxz/P/mnEvJfkdqugIkE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XpwbJMbX;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A868F1A2D;
	Sun, 28 Jun 2026 22:54:52 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B62133F836;
	Sun, 28 Jun 2026 22:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782712497; bh=B+yi1Bdg44hMjMR1L4zCtY4m3s0YUR4/m7per8eojKg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XpwbJMbXv8k8Om8XvR64ryOt/uZaEQI1W+MyncoF4wcQ+Z3VuDnxtrfA9wrXgYs2A
	 bv4FDrG3lX+yvzTUBJMcBReSjYr8Ry99yfX3mlgtMpMJeYaSC7HfTgjrIWk+h7qCPe
	 jSf7yHxQekQxZfzuX0utNRRg7kVhEV2o/lDL/K74=
Message-ID: <a8ff2b34-5e5c-43c8-9de2-cf7929265853@arm.com>
Date: Mon, 29 Jun 2026 11:24:50 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/6] mm/vmalloc: Extract vmap_set_ptes() to consolidate
 PTE mapping logic
To: Wen Jiang <jiangwenxiaomi@gmail.com>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, urezki@gmail.com
Cc: baohua@kernel.org, Xueyuan.chen21@gmail.com, rppt@kernel.org,
 david@kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com,
 ajd@linux.ibm.com, linux-kernel@vger.kernel.org, jiangwen6@xiaomi.com,
 shanghaoqiang@xiaomi.com
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
 <20260618084726.1070022-4-jiangwen6@xiaomi.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260618084726.1070022-4-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 1gnyicunp1qfnm7wne3nktacukesdfgh
X-Rspamd-Queue-Id: 13B484000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1782712497-145729
X-HE-Meta: U2FsdGVkX1/FLaRQR3USryqguFYANe0MdW+V9YcGF1l8kO8NlfA3F0neCT5+65iuj+qtKko7CGjuO2ShVC9adRtdk/Ol9SO3G+Mb8DRnb+KamG82kePvtSnKQ3EJOhRMLyUnvQ91xdhw1I2UV3TJYmy68AJSeGbPfzWPeDd3nuJKKZuUeu+i8N89Gx7XPedeDcMhkvznTksfNyyGXKF7EuKUfz3Mly4Llw/vuzw4aonQqRgA2MBWnsRNB3txaPuROwozeXTPw7zrq/J4SL0nYJksPKXhOsXTJV1onF2hgeXVsudHWCl8k9VH4haO3DV4yvosnP9FSJXfZ7Sl0NAZaX5zgVOiE/kHVhVBLeguSnymk2XK/IKXSRT6RhqaH1hjmWbfxt8+PgsTD5A9ESgLc1fDdi3xTKvEqlf01tRxqb1gSeUupuC8Pl2ryco4ukGDx0nQ7AkHWUs2l5kPa/1USFagtJhOA02Q/7TsO5TcKp5DZ/GLVmT9CcaNHg3AoMNydT0LHmxMP7MMNfL2tvM2h7uPOt9ZVK68ifquXjO27JZ91TJ6Vqkye7o/YIwCKr3UqmxmnsX997qtZcoXh3fMe0z7mmi0FlXE6UceaOYDfx8me7v6L4bxCr1Ig7T8iWoSO+UnNPCc36yXVVMINr1lwwRqWSpG4tfc9xd4qCvhJrZ/b/rq7apqJ0LhBGLymq5iUFsaoalLl/O/K5kS/7YA4gHftnuekkn3UYlIsb1NzMGoKw0Wox2BYpUTtYgDaR/60uDMR9ZV8dPWrCprmhJh8Mej56oIIQpHzegZjE3ko0UkaDwuxQDrxZNkuSnKKerVz/bRTYqCzfqiUgxRBSb8udwJp2X4A2DSr3ZBvht9FGX4GtVLc/dCx3najLYMIMkiQizvtZS5R47TPr0tqCKhvFTfjmN30n2cBXSH9N0SfNHZsZlS2FOS7eKhUlAmJvfk8K4G1Yk5qekbo8DGH4v
 0j3U0ajz
 LC8HD+Znpl9stVN5sPsCwRXcGfcUaID34neBtTryJ3sZUjWP4Pf5lnGu2kXOOhXwXU0q60K4izVYWMD5UP/M0b7LNx2qsg3BlvDkf9mGT3hlMPbI/ApojW6gfjDaHkhtpZiGyu43htrSLJPld9xs4/79ryv8lH9exBhVhMOlOnG+7DNyg7xZwzE5JHJUepMPkOJW1mUTVY2Yu+geH9ZbcRFBV6EjGbEgtQenw6hF79WjQyUVW0Rvj/Egz09w/m4wxk7Nl6rem+gmCZ31nrt6F70cbeBhK8LeB6U4Qac5KCf2rHPALW6EsJfWWshd7Fei5E64DfhEL3cRax5FmN6XD0Hn5SyyHsyXzl+/qScyCHpHXrYHoHoJDl5umtwaEQQMpXRaXVCsDujheJX8lPr2mazxErBYZYqpi3EOiFFoqeXxm2iitLKxojDsdWEb0Q8lomaztjogj3jn1vrQENwscCvduPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/06/26 2:17 pm, Wen Jiang wrote:
> Extract the common PTE mapping logic from vmap_pte_range() into a
> shared helper vmap_set_ptes(). This handles both CONT_PTE and regular
> PTE mappings in a single function, preparing for the next patch which
> will extend vmap_pages_pte_range() to also use this helper.
> 
> The #ifdef CONFIG_HUGETLB_PAGE guard is moved inside vmap_set_ptes(),
> so callers no longer need to handle the conditional compilation.
> 
> No functional change.
> 
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/vmalloc.c | 44 +++++++++++++++++++++++++++++++-------------
>  1 file changed, 31 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 2c2f74a07f396..6660f240d27c9 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -91,6 +91,35 @@ struct vfree_deferred {
>  static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
>  
>  /*** Page table manipulation functions ***/
> +
> +/*
> + * Set PTE mappings for the given PFN. Try CONT_PTE mappings first when

CONT_PTE is arm64-specific, doesn't feel right to mention this in generic code.

If you really want to put a comment, just say:

"Try contiguous mappings at the PTE level for arches which support them, and if
requested by the caller. Fall back to PAGE_SIZE mappings otherwise.

Return: mapping size."
> + * supported, otherwise fall back to PAGE_SIZE mappings.
> + *
> + * Return: mapping size.
> + */
> +static __always_inline unsigned long vmap_set_ptes(pte_t *pte,
> +		unsigned long addr, unsigned long end, u64 pfn,
> +		pgprot_t prot, unsigned int max_page_shift)
> +{
> +#ifdef CONFIG_HUGETLB_PAGE
> +	if (max_page_shift > PAGE_SHIFT) {

This if block is not needed, max_page_shift > PAGE_SHIFT is handled by
arch_vmap_pte_range_map_size.

With that:

Reviewed-by: Dev Jain <dev.jain@arm.com>


> +		unsigned long size;
> +
> +		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
> +		if (size != PAGE_SIZE) {
> +			pte_t entry = pfn_pte(pfn, prot);
> +
> +			entry = arch_make_huge_pte(entry, ilog2(size), 0);
> +			set_huge_pte_at(&init_mm, addr, pte, entry, size);
> +			return size;
> +		}
> +	}
> +#endif
> +	set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
> +	return PAGE_SIZE;
> +}
> +
>  static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  			phys_addr_t phys_addr, pgprot_t prot,
>  			unsigned int max_page_shift, pgtbl_mod_mask *mask)
> @@ -119,19 +148,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  			BUG();
>  		}
>  
> -#ifdef CONFIG_HUGETLB_PAGE
> -		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
> -		if (size != PAGE_SIZE) {
> -			pte_t entry = pfn_pte(pfn, prot);
> -
> -			entry = arch_make_huge_pte(entry, ilog2(size), 0);
> -			set_huge_pte_at(&init_mm, addr, pte, entry, size);
> -			pfn += PFN_DOWN(size);
> -			continue;
> -		}
> -#endif
> -		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
> -		pfn++;
> +		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
> +		pfn += PFN_DOWN(size);
>  	} while (pte += PFN_DOWN(size), addr += size, addr != end);
>  
>  	lazy_mmu_mode_disable();


