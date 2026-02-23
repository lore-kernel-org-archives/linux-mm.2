Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 008B6E9A02C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 10:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A4096B0088; Mon, 23 Feb 2026 05:56:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326F96B0089; Mon, 23 Feb 2026 05:56:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 233796B008A; Mon, 23 Feb 2026 05:56:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0C98B6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 05:56:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE3D91A08FB
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:55:59 +0000 (UTC)
X-FDA: 84475416438.24.E6AC51C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id F00B71A000B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:55:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PhToeSxe;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771844158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BEtwd+R5s7gDlTvXvHKOwL3ruNVsU6UKzF/BlCX75FU=;
	b=Dqb7VgtaEvp/2+YLuw1NetXQUK0CaYrm/R6ESKS4N2nJzJ7fKOhKn+ayAXCdtg/ZtCk7oB
	wvQP/v4rciVJ867jzC5NiA5PN7nV3Bqd2y4+FgJq3e3QfrWCFmkfuE2jPO//W7KK5mvZUH
	ffdmfH4dl/dH2Lphubpx+FY7FKrNpZ0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PhToeSxe;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771844158; a=rsa-sha256;
	cv=none;
	b=Y+cYc4HX7FDOuM4aFb0HsZc5g7kL0NVYFAhIXBkeL8H1b24Igex9hhIrfVrBN10ByUx93H
	ukjSljQzVYGgqymjaQiuuoWtCFfBZMBpNaIFi8U3Rv6eZ/8n6fVbsmP0YDbBAn/RO/BuFd
	XCQ1TRsei20gPFD1hWNOX5n9TA7eGng=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C2CAD40C3C;
	Mon, 23 Feb 2026 10:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EAF1C116C6;
	Mon, 23 Feb 2026 10:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771844156;
	bh=Hp/G5bM2cfDXr9AvMTGry72qv+5k5dlSxt17AJXUjBQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PhToeSxeGI/AfzEciOrUYiCwaquvOzKdmUQQxyn/pTX37XJjk0l/22SEwRHvGkA1b
	 6uAreg1DXjppT4wPUy+qDmRPKjP8B4WBdgTHA1h05TaDiOCb1/SqAFGapOfBitjYmR
	 /u+Mtmwr2YJkjAAv069cIgmvOoOoDdxoH6CAxdp982qevVQGunRNTkmCBidYz3Nce/
	 plSnr8T+21sxGn33f3cEo3D2I+LEldHT4G+nbYUIWh3iAuvttW73gnBvbwKwCIllvK
	 FzoDZHO5onuHwH5vGcqU+1EjxesnP78VJ2b5nfK8+6sSaaBCPcDjf550/imijYvFCB
	 I3HhD7AwiozWQ==
Date: Mon, 23 Feb 2026 12:55:48 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@kernel.org>, linux-efi@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/efi: defer freeing of boot services memory
Message-ID: <aZwyNAbEqb8ZwLUM@kernel.org>
References: <20260223075219.2348035-1-rppt@kernel.org>
 <b6f4edf5-7587-45d7-b81a-590d4f3d1ddd@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6f4edf5-7587-45d7-b81a-590d4f3d1ddd@app.fastmail.com>
X-Stat-Signature: rqiktdbzk9bygwg7bcqb1pcxtthi4rcu
X-Rspam-User: 
X-Rspamd-Queue-Id: F00B71A000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1771844157-513441
X-HE-Meta: U2FsdGVkX19X0KA7SmkTebUOPoOEU/0kdtT9AIsjB6NZ1VDpKf39P4NXLEc2NHKvnp1B5xjKSCNe0UGCig+laHA+qInZgdITyavsdgSzwWNwcNxdeN/hMxbAWhVR2bLLAsPaAfOnw4pcC4mSVJmo9Ft0GoORzv6IlV3G4yZIGj9g++r3vQt/jH8IW2xIexpEMTeo8hWWUnmNOLIUyhLRs6vQ7BTRbClNkn9Q4x1VtaoAjjQci+GtbD915/Aj5TDxVLTC8/XCHruf05ey1zcJsagQIEcaHxFnwqvANXQlwCc2ha/4z3d7zhUNREcpKaQA+vYyaD6NqPz87T7VcY7PJLIulMprXv9JopuqIKBISufUVI9Ex2By6qat3LY8SRRdQ8Cix6ZkFqn5mpqFK6K5PnbMH1c0f6eCmXeKQ0eGoA4XItoGAfqeNT1Uab9FUtES/0t24c21hRxosQ4ovWjOfVp0TGeLPpU8YFiPHtP4rg4L1LwArmyYdKycQ4Rwq5Fm6qkHJM0tsr/CFzR9nZ26EeDT61Y4Eu/qb1ld9mo1kdg86OpARpid9LxoM6EaA/ULS3BakvRt1BzJbuCp42KUEhSekYbAPQb9N/sCdgFytuHi9vzlhQKzj01mPh5PJe2yTdb2DsU3uw2zzYp2s8Si2BlLRVWUj389SC0+r31/otmDLxKruwPrET8KwCiNuS2O4mQd/cSRi8C5qJyxTse5JurIt4tVnppczCT07rwyAeRpRfHWBLZII5PiHiJ6NHYiqrofVp5GGeDScDH11h+hj8Zy0yq1QFO3r4xIeSLXzLDbc6kFNH0FzuUeeyBndZUghY47azDzwcP4avCDCnLxBxhrrvxJ9TZILQ4ymvY1CoSnH6Nd3C++w5lNjNgnsKtDZalj6iK5+ge6clOgZtI6yb2jINWdMY6oJfMiOA0YcACy6pLA6cx1Xkzs6NZSy+ZGtlRTVHh4cYhI72OtK/1
 IEFJoR/M
 FTr0Y8efBAwrPYF3869kyAuEqX70av+xlidNF05RUxggXJbeLVx/ygepbDp2SR7hq5CsJLpOeXtdsZG+Ycn6dHOIY6tV/984+6LXYGbzOdyAqbkxOuF6a6VWweCqp5EKiT/sWgXv8wLmtOTD/FCm5pEqZdoTA7ipE/ZeUxlOkazJxSjje/zbb2BKywIhbEDfc8Gf0bEaIqMsPn9B2ErTjeIXZo2sqjAC72cBow+s5gTZgqMBJvZsB1zlywA5jO25PqUJl+VtgLZYAD1W16rKXuQiunW3QVcwkSHq3MI3ED/kwhDr5CBDTb7TyGNbr3PXdf4qEK8e/m87BS+JXGjgUfyg9bg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ard,

On Mon, Feb 23, 2026 at 09:08:29AM +0100, Ard Biesheuvel wrote:
> Hi Mike,
> 
> On Mon, 23 Feb 2026, at 08:52, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > efi_free_boot_services() frees memory occupied by EFI_BOOT_SERVICES_CODE
> > and EFI_BOOT_SERVICES_DATA using memblock_free_late().
> >
> > There are two issue with that: memblock_free_late() should be used for
> > memory allocated with memblock_alloc() while the memory reserved with
> > memblock_reserve() should be freed with free_reserved_area().
> >
> > More acutely, with CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
> > efi_free_boot_services() is called before deferred initialization of the
> > memory map is complete.
> >
> > Benjamin Herrenschmidt reports that this causes a leak of ~140MB of
> > RAM on EC2 t3a.nano instances which only have 512MB or RAM.
> >
> > If the freed memory resides in the areas that memory map for them is
> > still uninitialized, they won't be actually freed because
> > memblock_free_late() calls memblock_free_pages() and the latter skips
> > uninitialized pages.
> >
> > Using free_reserved_area() at this point is also problematic because
> > __free_page() accesses the buddy of the freed page and that again might
> > end up in uninitialized part of the memory map.
> >
> > Delaying the entire efi_free_boot_services() could be problematic
> > because in addition to freeing boot services memory it updates
> > efi.memmap without any synchronization and that's undesirable late in
> > boot when there is concurrency.
> >
> > More robust approach is to only defer freeing of the EFI boot services
> > memory.
> >
> > Make efi_free_boot_services() collect ranges that should be freed into
> > an array and add an initcall efi_free_boot_services_memory() that walks
> > that array and actually frees the memory using free_reserved_area().
> >
> 
> Instead of creating another table, could we just traverse the EFI memory
> map again in the arch_initcall(), and free all boot services code/data
> above 1M with EFI_MEMORY_RUNTIME cleared ?
 
Currently efi_free_boot_services() unmaps all boot services code/data with
EFI_MEMORY_RUNTIME cleared and removes them from the efi.memmap.

I wasn't sure it's Ok to only unmap them, but leave in efi.memmap, that's
why I didn't use the existing EFI memory map.

Now thinking about it, if the unmapping can happen later, maybe we'll just
move the entire efi_free_boot_services() to an initcall?

> > Link: 
> > https://lore.kernel.org/all/ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org
> > Fixes: 916f676f8dc0 ("x86, efi: Retain boot service code until after 
> > switching to virtual mode")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  arch/x86/include/asm/efi.h          |  2 +-
> >  arch/x86/platform/efi/efi.c         |  2 +-
> >  arch/x86/platform/efi/quirks.c      | 55 +++++++++++++++++++++++++++--
> >  drivers/firmware/efi/mokvar-table.c |  2 +-
> >  4 files changed, 55 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> > index f227a70ac91f..51b4cdbea061 100644
> > --- a/arch/x86/include/asm/efi.h
> > +++ b/arch/x86/include/asm/efi.h
> > @@ -138,7 +138,7 @@ extern void __init efi_apply_memmap_quirks(void);
> >  extern int __init efi_reuse_config(u64 tables, int nr_tables);
> >  extern void efi_delete_dummy_variable(void);
> >  extern void efi_crash_gracefully_on_page_fault(unsigned long phys_addr);
> > -extern void efi_free_boot_services(void);
> > +extern void efi_unmap_boot_services(void);
> > 
> >  void arch_efi_call_virt_setup(void);
> >  void arch_efi_call_virt_teardown(void);
> > diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> > index d00c6de7f3b7..d84c6020dda1 100644
> > --- a/arch/x86/platform/efi/efi.c
> > +++ b/arch/x86/platform/efi/efi.c
> > @@ -836,7 +836,7 @@ static void __init __efi_enter_virtual_mode(void)
> >  	}
> > 
> >  	efi_check_for_embedded_firmwares();
> > -	efi_free_boot_services();
> > +	efi_unmap_boot_services();
> > 
> >  	if (!efi_is_mixed())
> >  		efi_native_runtime_setup();
> > diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> > index 553f330198f2..35caa5746115 100644
> > --- a/arch/x86/platform/efi/quirks.c
> > +++ b/arch/x86/platform/efi/quirks.c
> > @@ -341,7 +341,7 @@ void __init efi_reserve_boot_services(void)
> > 
> >  		/*
> >  		 * Because the following memblock_reserve() is paired
> > -		 * with memblock_free_late() for this region in
> > +		 * with free_reserved_area() for this region in
> >  		 * efi_free_boot_services(), we must be extremely
> >  		 * careful not to reserve, and subsequently free,
> >  		 * critical regions of memory (like the kernel image) or
> > @@ -404,17 +404,33 @@ static void __init efi_unmap_pages(efi_memory_desc_t *md)
> >  		pr_err("Failed to unmap VA mapping for 0x%llx\n", va);
> >  }
> > 
> > -void __init efi_free_boot_services(void)
> > +struct efi_freeable_range {
> > +	u64 start;
> > +	u64 end;
> > +};
> > +
> > +static struct efi_freeable_range *ranges_to_free;
> > +
> > +void __init efi_unmap_boot_services(void)
> >  {
> >  	struct efi_memory_map_data data = { 0 };
> >  	efi_memory_desc_t *md;
> >  	int num_entries = 0;
> > +	int idx = 0;
> > +	size_t sz;
> >  	void *new, *new_md;
> > 
> >  	/* Keep all regions for /sys/kernel/debug/efi */
> >  	if (efi_enabled(EFI_DBG))
> >  		return;
> > 
> > +	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
> > +	ranges_to_free = kzalloc(sz, GFP_KERNEL);
> > +	if (!ranges_to_free) {
> > +		pr_err("Failed to allocate storage for freeable EFI regions\n");
> > +		return;
> > +	}
> > +
> >  	for_each_efi_memory_desc(md) {
> >  		unsigned long long start = md->phys_addr;
> >  		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
> > @@ -471,7 +487,15 @@ void __init efi_free_boot_services(void)
> >  			start = SZ_1M;
> >  		}
> > 
> > -		memblock_free_late(start, size);
> > +		/*
> > +		 * With CONFIG_DEFERRED_STRUCT_PAGE_INIT parts of the memory
> > +		 * map are still not initialized and we can't reliably free
> > +		 * memory here.
> > +		 * Queue the ranges to free at a later point.
> > +		 */
> > +		ranges_to_free[idx].start = start;
> > +		ranges_to_free[idx].end = start + size;
> > +		idx++;
> >  	}
> > 
> >  	if (!num_entries)
> > @@ -512,6 +536,31 @@ void __init efi_free_boot_services(void)
> >  	}
> >  }
> > 
> > +static int __init efi_free_boot_services(void)
> > +{
> > +	struct efi_freeable_range *range = ranges_to_free;
> > +	unsigned long freed = 0;
> > +
> > +	if (!ranges_to_free)
> > +		return 0;
> > +
> > +	while (range->start) {
> > +		void *start = phys_to_virt(range->start);
> > +		void *end = phys_to_virt(range->end);
> > +
> > +		free_reserved_area(start, end, -1, NULL);
> > +		freed += (end - start);
> > +		range++;
> > +	}
> > +	kfree(ranges_to_free);
> > +
> > +	if (freed)
> > +		pr_info("Freeing EFI boot services memory: %ldK\n", freed / SZ_1K);
> > +
> > +	return 0;
> > +}
> > +arch_initcall(efi_free_boot_services);
> > +
> >  /*
> >   * A number of config table entries get remapped to virtual addresses
> >   * after entering EFI virtual mode. However, the kexec kernel requires
> > diff --git a/drivers/firmware/efi/mokvar-table.c 
> > b/drivers/firmware/efi/mokvar-table.c
> > index 4ff0c2926097..6842aa96d704 100644
> > --- a/drivers/firmware/efi/mokvar-table.c
> > +++ b/drivers/firmware/efi/mokvar-table.c
> > @@ -85,7 +85,7 @@ static struct kobject *mokvar_kobj;
> >   * as an alternative to ordinary EFI variables, due to 
> > platform-dependent
> >   * limitations. The memory occupied by this table is marked as 
> > reserved.
> >   *
> > - * This routine must be called before efi_free_boot_services() in order
> > + * This routine must be called before efi_unmap_boot_services() in 
> > order
> >   * to guarantee that it can mark the table as reserved.
> >   *
> >   * Implicit inputs:
> >
> > base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
> > -- 
> > 2.51.0

-- 
Sincerely yours,
Mike.

