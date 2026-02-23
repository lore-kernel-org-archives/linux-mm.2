Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC9A7E98DFE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 08:08:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57AD6B0088; Mon, 23 Feb 2026 03:08:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05346B0089; Mon, 23 Feb 2026 03:08:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE6906B008A; Mon, 23 Feb 2026 03:08:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A9F566B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 03:08:55 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F15CD5B866
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:08:54 +0000 (UTC)
X-FDA: 84474995388.14.E757C12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0511D40008
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:08:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DGhJycFJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771834133; a=rsa-sha256;
	cv=none;
	b=qMbLz9JOv2PENHl5NkbU3+DBi+Nz3aI2XKQRlAo7ZWsQ9whZFUglu+ELd/P4MjyUQMSw7e
	vBrt6WTggNPp9vQUoMCH1WOfEINYuHdb+/dkZkUzp36wq0zqYGFUKJNCacz3//SGJAka3d
	PBJCM27zYIvcdfyiHvsUX1zLEekLOQM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DGhJycFJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771834133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sSkEdhKgSJnJIs7mLlQQuC+XYY13C06kNGYOTpke7rI=;
	b=KzvyQmpM+EslJ3t7PwQ+s4cMS90FEKp7KGc2taJFtzpOZ+jP2kTjCSxQiwg1hO+TNbQ7u1
	rYIUSb+hEOpCOTTTDPO+fPTx7vaQC+GU8TFBXAstchoLELrK7feAINTGRmCtZWNFUAJ2sN
	8wkehAxMZMso/ahFG7Fpm9M8U4p2CoY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 049E960097
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700CEC4AF09;
	Mon, 23 Feb 2026 08:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771834131;
	bh=4jL6dEH0dwKlTrgzY8EtdsryVX+Azgl/T/uP3QlbNho=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=DGhJycFJOZgZ3tLtc3+s7Io7z5vbt4M/GphPcVv15G36+cJbJfcSnvofy6UXewxtM
	 EjrQdQsOAruwz68dvdvK0t5MG84Ab5KA8ubAhKAdMAAtOvFKk5Or9G8RbveU6wcfHq
	 0Me63ocEAwnYlou6QTxEF/sRr1i/cuviUpo5bj9EWfogcFfgm5aIoRoAmztYsYQODn
	 26WFvbQGDVNXf3psTtCTCvUNGDnQIr7zLp9EdN9lhM2lrJwU+cOHjJ3+L4gAtJdbRI
	 58p+STpA5YRcqpLWd8MZ/sJltu8dAdcCjjhSVUraDq8Fk7cgjiKAOXrBHDZ5aC4+b4
	 x2pqIBI6i7vlw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 573A8F40068;
	Mon, 23 Feb 2026 03:08:50 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 23 Feb 2026 03:08:50 -0500
X-ME-Sender: <xms:EgucaUnfN7oRRb0lzyLtC6vgYQG0RgaRAqVk97QjYtYql-jRF7_ZoQ>
    <xme:Egucaep7QH1SqanEdtDTSAPrGjJFMSeuTokvM6461v6quQG_RBQcVslrc2tyBP-Wu
    7cSJr-ntR63vN2ufZdHtTjAJi0tvDpGnSfGEVvfY5G5X2aU_D2jwHE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvfeeijedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeeftddthefgvdehteehhfeludfgfffhffelfeefvddthfekffdvgefgveet
    ieffveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhmvghmmhgrphdrnhhrnecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrugdomhgv
    shhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledqfeefvdduie
    egudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtghomhdp
    nhgspghrtghpthhtohepudefpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegsph
    esrghlihgvnhekrdguvgdprhgtphhtthhopegsvghnhheskhgvrhhnvghlrdgtrhgrshhh
    ihhnghdrohhrghdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpth
    htohepthhglhigsehkvghrnhgvlhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtph
    htthhopehilhhirghsrdgrphgrlhhoughimhgrsheslhhinhgrrhhordhorhhgpdhrtghp
    thhtohepuggrvhgvrdhhrghnshgvnheslhhinhhugidrihhnthgvlhdrtghomhdprhgtph
    htthhopehmihhnghhosehrvgguhhgrthdrtghomh
X-ME-Proxy: <xmx:EgucaUfAksPMlidh_hv9oZFsn-UeFkN2lMeVsmn8V6UwRikzeQj0DQ>
    <xmx:EgucaVznzY-nYogE-pa0WH2LAlII1jjIUaU7QGBuKc-6KhL_VZSJrA>
    <xmx:EgucaZ290ysiPNfrowKJgrtF3ViPcjFy3YRECAnKVuz980PMc_W7LA>
    <xmx:EgucacdJHxnwohK1Bwfrauv3gClLu9Nsg2GPoJ4qqfOrsbZ5XTRYbQ>
    <xmx:EgucaeXEyqZ4ZBPz-Sx5p0q-1a_D01KjTdUStKxa0BQWHpVNBSFW00eq>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 32331700065; Mon, 23 Feb 2026 03:08:50 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AF0NZ4OlJH_7
Date: Mon, 23 Feb 2026 09:08:29 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Mike Rapoport" <rppt@kernel.org>, x86@kernel.org,
 linux-kernel@vger.kernel.org
Cc: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Ingo Molnar" <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 "Thomas Gleixner" <tglx@kernel.org>, linux-efi@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
Message-Id: <b6f4edf5-7587-45d7-b81a-590d4f3d1ddd@app.fastmail.com>
In-Reply-To: <20260223075219.2348035-1-rppt@kernel.org>
References: <20260223075219.2348035-1-rppt@kernel.org>
Subject: Re: [PATCH] x86/efi: defer freeing of boot services memory
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 35mwyt9r7im7kjqz4a9o3fnftj6mgany
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0511D40008
X-HE-Tag: 1771834132-597096
X-HE-Meta: U2FsdGVkX18PAVlGqJHSpZD0Uf+hHpZKNuoaYbWwyJPffgZoJp5CWGCm/oHjRaxglHZCzlrWUGEOksynfGjQyWO9iOprwaw8EFvqFcKskNazsQJwyPhx8gaM7Falj+I97Jyz0KwQr4I8KLsWExa9Z9qfzw5mDxzxba84jjhI3SwsIgBpTq3UgFMHzMaP0O0UMrMvfN7AUuSH3/ACDQDYB+7RItWnDLIlITO2ENh3reZXNTh3Ex78UOTH7ZtVKAF8fWj29TAKn1Ypi3n1IP812P9NLo2KiUGDjfcMMJD85bE7ZIr6SJA8Vu5Aep+BIJGW8O3QqvfxcOax+0yvRuoe5G0mmmLwurQuo/o8c3akE11lgL6NH56DRWkEUBf8uMvvWO2ajHAPLyg1QpcxQcLMi9ydWK0Tfb/GG0IJ135xi6q8OHPxF0qNnACBxW0YDm15vm2jHdcQI61xon5n9tPzIG80QPTyrA66nCo4knewhQ8ZSzt2ffI4nquc3EDyTqaay3zUM8lhNYVo9KqN2MrngWch8/30qiVNfTmQBLOoiEX4OkdT64dq3vLs7cZQI2HCAHwcWsIcKbGfCeDP3L82bEhoZ1bkq8xAruUGoMSJZIqnb97X0aloizCsFD3QdgybBqVMuLCt46GSpxHmjmJFy4iyWjJgVbgTkggjwthybi+RPSh7BqmNf/jtfNomTfX4oQKV1BHrsUN6WwC12g8/FvZwIbmdTaodkRk1UeuaTLJFna9Lfo5e5kHS7CkVr15hcTE9hrgf+sN1qN9x9WOK9yimWVmXDfDlmS8f9XQI1oxq26R05nzeTorP0b4lGnC/9DT048VD46ke1+hkegAmLrdpWWWDpDxuDw2PxzyDvsL+b+O1ddbtILhBqT0LIqMvspz5uXb/JrpWRUFPolcm41RYVtjANsqfx9GHPsOvP5cfaZedouB2DdnJ+cEElt9KNKzSyze/z0F6akDnRoF
 wiPngQev
 UK0Oq3/VR4WtVppiyCFnUs9nLo4QNlJne9qLH/xm/Je0Y3zgdflB5XnaEIBVre5xnCTdsGPl3F1GGCVAwcwaV9v6U/JJNuymVqyYXg7MP8T0zFlKK1VJFbHryyVBRppDGiVcKC2p2pqPjRV2aOgncoYNsMtlqMGdUX/BrDiYybeR3TKGLi8H21UacglZJHUVeecXSGpX5gyhN16xbFl1BVJRmP1+MIksrk0dM6WvsH85Q8C5oWJR52uWPCoWoJjNpIbS5oRAA9Q2F99OXIlhl6sB1W+cz6wyT9jyeSuazW4UL2pYc3u3VN+Cgl0vsaluVNYrtSIIz0ZghFDWhkseRwYFZ9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Mon, 23 Feb 2026, at 08:52, Mike Rapoport wrote:
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
> Make efi_free_boot_services() collect ranges that should be freed into
> an array and add an initcall efi_free_boot_services_memory() that walks
> that array and actually frees the memory using free_reserved_area().
>

Instead of creating another table, could we just traverse the EFI memory map again in the arch_initcall(), and free all boot services code/data above 1M with EFI_MEMORY_RUNTIME cleared ?


> Link: 
> https://lore.kernel.org/all/ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org
> Fixes: 916f676f8dc0 ("x86, efi: Retain boot service code until after 
> switching to virtual mode")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
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
> diff --git a/drivers/firmware/efi/mokvar-table.c 
> b/drivers/firmware/efi/mokvar-table.c
> index 4ff0c2926097..6842aa96d704 100644
> --- a/drivers/firmware/efi/mokvar-table.c
> +++ b/drivers/firmware/efi/mokvar-table.c
> @@ -85,7 +85,7 @@ static struct kobject *mokvar_kobj;
>   * as an alternative to ordinary EFI variables, due to 
> platform-dependent
>   * limitations. The memory occupied by this table is marked as 
> reserved.
>   *
> - * This routine must be called before efi_free_boot_services() in order
> + * This routine must be called before efi_unmap_boot_services() in 
> order
>   * to guarantee that it can mark the table as reserved.
>   *
>   * Implicit inputs:
>
> base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
> -- 
> 2.51.0

