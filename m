Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06CA0EB7EA4
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 08:17:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016776B0088; Wed,  4 Mar 2026 03:17:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F30AA6B0089; Wed,  4 Mar 2026 03:17:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E30246B008A; Wed,  4 Mar 2026 03:17:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF7416B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:17:20 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6019F1C638
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:17:20 +0000 (UTC)
X-FDA: 84507675840.24.A9C51BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id AB61740003
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:17:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XkNWm/Jl";
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772612238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJf6FKHAFwKwi7y791AnyyRb8/hUI9QqzQgbd7RSIMU=;
	b=SsStLswLFCzam/LXdspllaUS+jMBundmRmEeBOITJducRylRveIRdizj0ZvyVqFAevDiRZ
	n9+LwnC0jX0aSMPabChepqOgtwoZZpj8xH77EpEkfnGjqA0v6mHyoWbUzaedeAkr72x8ZM
	TLnLrKJ3yn1jiaAXLdEYwqx6NOoK2NQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XkNWm/Jl";
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772612238; a=rsa-sha256;
	cv=none;
	b=NbYtnPAbNE6cHWsN40BPpe6DEHWJBditLDtT1s0kl/liln+DYz2PxnS9AlmQjvpYdMp+QN
	3NRJsEDBWaLhtijuXtNFsk+e1HgEfrjEdyqpKjE1Mxu4Bt4dzM4O9UhYjkboQLl3MoAPJb
	n/7pqq4uM6BV9eOoNWykgJ2ClZmq5TE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D47540AB8;
	Wed,  4 Mar 2026 08:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911FFC19423;
	Wed,  4 Mar 2026 08:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772612237;
	bh=hHEQX82pLAavXA3KfQ27txuW9+UXTV4nQHbLANQ3ags=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XkNWm/JlfdmOsdc9lJ5EIVyC4M7Aau4FuAmmJkHvgV+ZsArAV3bl0t6jMz69wDh6W
	 KFSzPRZoahLHVJ7nMV7MBA5d9nndSu2+vTfysbUql6hIfxbFaJ6bYr1/UyBm3Jwq8v
	 Kw4BORufVOSJ1S43xzJ1LUDkgkyjhiNCcr1Rb6wvAhSrkKq2EBqwtKZzQIhFhgAxBr
	 XpaRf5Phk7D/h0TSB/JE02nYmVn2Ta/XzjN9QMRSuBpIcAqmnkM5YqSPckt6NuZPy8
	 3WUNG8YrQLZyJA+5sp85ZsC1EHmtErmW34AvkffpMnzQHKiN97jOIbb8EY/Br6+azL
	 IfAM52jbI7cpg==
Date: Wed, 4 Mar 2026 10:17:09 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@kernel.org>,
	linux-efi@vger.kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86/efi: defer freeing of boot services memory
Message-ID: <aafqhcG67FoNrF41@kernel.org>
References: <20260225065555.2471844-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225065555.2471844-1-rppt@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: AB61740003
X-Rspamd-Server: rspam08
X-Stat-Signature: gwf6ou8c8un4xbwbpcrzpb5ojewnmkhp
X-HE-Tag: 1772612238-661013
X-HE-Meta: U2FsdGVkX19aop7V3xmbi7AyYTqFGum5zmxOU/GUF7JjGmD8YAE3oFrbm0+8Egi6vF7y1PA/3VAd+BwD4WUFw0DHs+4Lhm2qJ1Re92JDrfF0rOdSArBIXLYk4smpJyLk770WOwyA0yxt0vmcXpcclbO+SD8WmvSOsLjuvFbhUFUd8SJeZWXo34Wu+BI7POfHQbFLyDz+Ptl+Rb8qhTIYldT2RCzea3iQ1StWCz5TDdv7jtGsFhRyAi7y2rFPitxQkS1F3tOnR5RIdSumAOLy+Lyc+UizajIhrL/iOEpkxh78kKYJn6ZxE4K2afks3TwAvrDkDo07t2KS759oTkmDNoiDUPqx+YKjhQ+kv1LA7WdtJ+n61knWmWYY0ukqKXEjamdQgYii8XyyqEM5bMLvz13AMUvdhfU3Xz1YDqj8lcyoa4NT9yfX5mV0Zwb8/Ry+r1ACW1Kx7xadesoa+mSfn65nfVaS/JOoXnDFFrUjkOhQHBz3v8ULt2NG2D+bLV3wPJ4Du3p9xRNMXmlAaHVGncveCZ5NSoCJT+yBNXX0nKSWE7n97tRD7u0RbrTtJJcoetdL0j2yhafv5oGTTmmX7lYcSmKfQkz6uYdMSJVPB963iKFrNF19U7CW1lWvErSXJ2xyJh/GrnLSBGo7taQr9UgHVZlpk9uB9OsiA4m4ybfpnj+UijrEiwQFIXG5RSb7Pp8xUOw6+cQt/3DNkVAEu1OEsYpkcV7Skf4I9FOce1HyzXlO4odUM/4B4ZcfMcJrSFFJrQ0XF1eLTMh0+2Hk1PblZ90mxNuDjBZFxkLL2gxGL9yF/EcnATMd7qF+MOy01KW9ixd3JUX2Uw+zTo8d/S4uP1v6VyznK/KZayELumEsjPXw8aGDdbMA0XYepP84fL/rqGaaP5NXDIkw+bXZXfFINqSePjZv7dQJ+RQ4F93o8B6cTJI4/lnfm/eK1jWDKK1X282STQz/+XqHPR+
 EA0/J0V/
 RdOnYKvec8HKHH+Tq6cl3hXcKKud9qH4/k4wEzErWqdi23KSS+1u7zh86ineqOeeu7NOc0nkIbbgDxw3+utKYulrTE6ZYHlNmG/K62C/GVhs2UezTyGTrvaiH7rQhIrwfR8Fxzmmvde2nGtkTPoE1yYRjQdvpd63rKy9Msv9ig8U6N0ms6f1S5wC05aSrpS4AtNKi8mNFTjKP5yMPUeCM1lHmcZ+W7jbiALFPi0dxDIKe8R1j7u7G41yA6IyrtTMRtqyTvnJa6312ifK35m8tAP3guDpzK45kO99/T0TAnkRK7Udq1t2GeeM639D4OJTKtn6PSfDYyC723dtp03a00pdOxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gentle ping?

On Wed, Feb 25, 2026 at 08:55:55AM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> efi_free_boot_services() frees memory occupied by EFI_BOOT_SERVICES_CODE
> and EFI_BOOT_SERVICES_DATA using memblock_free_late().
> 
> There are two issue with that: memblock_free_late() should be used for
> memory allocated with memblock_alloc() while the memory reserved with
> memblock_reserve() should be freed with free_reserved_area().
> 
> More acutely, with CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
> efi_free_boot_services() is called before deferred initialization of the
> memory map is complete.
> 
> Benjamin Herrenschmidt reports that this causes a leak of ~140MB of
> RAM on EC2 t3a.nano instances which only have 512MB or RAM.
> 
> If the freed memory resides in the areas that memory map for them is
> still uninitialized, they won't be actually freed because
> memblock_free_late() calls memblock_free_pages() and the latter skips
> uninitialized pages.
> 
> Using free_reserved_area() at this point is also problematic because
> __free_page() accesses the buddy of the freed page and that again might
> end up in uninitialized part of the memory map.
> 
> Delaying the entire efi_free_boot_services() could be problematic
> because in addition to freeing boot services memory it updates
> efi.memmap without any synchronization and that's undesirable late in
> boot when there is concurrency.
> 
> More robust approach is to only defer freeing of the EFI boot services
> memory.
> 
> Split efi_free_boot_services() in two. First efi_unmap_boot_services()
> collects ranges that should be freed into an array then
> efi_free_boot_services() later frees them after deferred init is complete.
> 
> Link: https://lore.kernel.org/all/ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org
> Fixes: 916f676f8dc0 ("x86, efi: Retain boot service code until after switching to virtual mode")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> v1: https://lore.kernel.org/all/20260223075219.2348035-1-rppt@kernel.org
> * update the commit message with correct function names (Ben)
> 
>  arch/x86/include/asm/efi.h          |  2 +-
>  arch/x86/platform/efi/efi.c         |  2 +-
>  arch/x86/platform/efi/quirks.c      | 55 +++++++++++++++++++++++++++--
>  drivers/firmware/efi/mokvar-table.c |  2 +-
>  4 files changed, 55 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index f227a70ac91f..51b4cdbea061 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -138,7 +138,7 @@ extern void __init efi_apply_memmap_quirks(void);
>  extern int __init efi_reuse_config(u64 tables, int nr_tables);
>  extern void efi_delete_dummy_variable(void);
>  extern void efi_crash_gracefully_on_page_fault(unsigned long phys_addr);
> -extern void efi_free_boot_services(void);
> +extern void efi_unmap_boot_services(void);
>  
>  void arch_efi_call_virt_setup(void);
>  void arch_efi_call_virt_teardown(void);
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index d00c6de7f3b7..d84c6020dda1 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -836,7 +836,7 @@ static void __init __efi_enter_virtual_mode(void)
>  	}
>  
>  	efi_check_for_embedded_firmwares();
> -	efi_free_boot_services();
> +	efi_unmap_boot_services();
>  
>  	if (!efi_is_mixed())
>  		efi_native_runtime_setup();
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 553f330198f2..35caa5746115 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -341,7 +341,7 @@ void __init efi_reserve_boot_services(void)
>  
>  		/*
>  		 * Because the following memblock_reserve() is paired
> -		 * with memblock_free_late() for this region in
> +		 * with free_reserved_area() for this region in
>  		 * efi_free_boot_services(), we must be extremely
>  		 * careful not to reserve, and subsequently free,
>  		 * critical regions of memory (like the kernel image) or
> @@ -404,17 +404,33 @@ static void __init efi_unmap_pages(efi_memory_desc_t *md)
>  		pr_err("Failed to unmap VA mapping for 0x%llx\n", va);
>  }
>  
> -void __init efi_free_boot_services(void)
> +struct efi_freeable_range {
> +	u64 start;
> +	u64 end;
> +};
> +
> +static struct efi_freeable_range *ranges_to_free;
> +
> +void __init efi_unmap_boot_services(void)
>  {
>  	struct efi_memory_map_data data = { 0 };
>  	efi_memory_desc_t *md;
>  	int num_entries = 0;
> +	int idx = 0;
> +	size_t sz;
>  	void *new, *new_md;
>  
>  	/* Keep all regions for /sys/kernel/debug/efi */
>  	if (efi_enabled(EFI_DBG))
>  		return;
>  
> +	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
> +	ranges_to_free = kzalloc(sz, GFP_KERNEL);
> +	if (!ranges_to_free) {
> +		pr_err("Failed to allocate storage for freeable EFI regions\n");
> +		return;
> +	}
> +
>  	for_each_efi_memory_desc(md) {
>  		unsigned long long start = md->phys_addr;
>  		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
> @@ -471,7 +487,15 @@ void __init efi_free_boot_services(void)
>  			start = SZ_1M;
>  		}
>  
> -		memblock_free_late(start, size);
> +		/*
> +		 * With CONFIG_DEFERRED_STRUCT_PAGE_INIT parts of the memory
> +		 * map are still not initialized and we can't reliably free
> +		 * memory here.
> +		 * Queue the ranges to free at a later point.
> +		 */
> +		ranges_to_free[idx].start = start;
> +		ranges_to_free[idx].end = start + size;
> +		idx++;
>  	}
>  
>  	if (!num_entries)
> @@ -512,6 +536,31 @@ void __init efi_free_boot_services(void)
>  	}
>  }
>  
> +static int __init efi_free_boot_services(void)
> +{
> +	struct efi_freeable_range *range = ranges_to_free;
> +	unsigned long freed = 0;
> +
> +	if (!ranges_to_free)
> +		return 0;
> +
> +	while (range->start) {
> +		void *start = phys_to_virt(range->start);
> +		void *end = phys_to_virt(range->end);
> +
> +		free_reserved_area(start, end, -1, NULL);
> +		freed += (end - start);
> +		range++;
> +	}
> +	kfree(ranges_to_free);
> +
> +	if (freed)
> +		pr_info("Freeing EFI boot services memory: %ldK\n", freed / SZ_1K);
> +
> +	return 0;
> +}
> +arch_initcall(efi_free_boot_services);
> +
>  /*
>   * A number of config table entries get remapped to virtual addresses
>   * after entering EFI virtual mode. However, the kexec kernel requires
> diff --git a/drivers/firmware/efi/mokvar-table.c b/drivers/firmware/efi/mokvar-table.c
> index 4ff0c2926097..6842aa96d704 100644
> --- a/drivers/firmware/efi/mokvar-table.c
> +++ b/drivers/firmware/efi/mokvar-table.c
> @@ -85,7 +85,7 @@ static struct kobject *mokvar_kobj;
>   * as an alternative to ordinary EFI variables, due to platform-dependent
>   * limitations. The memory occupied by this table is marked as reserved.
>   *
> - * This routine must be called before efi_free_boot_services() in order
> + * This routine must be called before efi_unmap_boot_services() in order
>   * to guarantee that it can mark the table as reserved.
>   *
>   * Implicit inputs:
> 
> base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
> -- 
> 2.51.0
> 

-- 
Sincerely yours,
Mike.

