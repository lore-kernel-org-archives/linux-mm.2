Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63384EA4FAE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 11:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B72A6B0088; Mon, 23 Feb 2026 06:41:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83A516B0089; Mon, 23 Feb 2026 06:41:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7469D6B008A; Mon, 23 Feb 2026 06:41:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8746B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 06:41:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 102DA1408CF
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:41:03 +0000 (UTC)
X-FDA: 84475530006.16.1FB00B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 78ADCC000A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:41:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G75sdQiC;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771846861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lS9R/3yITU7WmuoEkjn57Ww3cKVIi++JE8T59b8H+MI=;
	b=2fTI4XHcn1AZiesUz9p8kYXxva7XQCuzz4Y3AzDpoh/FfXZs1sincU6ysgz8WV+xhI4h4q
	DXs72XuptaVfJwxeSjfppAoO/9t4/Ko5tS0xCiyFozWlYPRUGo0sIqIYH+oM5voCRJnl3N
	5+BiwhpKMSuOc46HuXtbVPkO5027IJ8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G75sdQiC;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771846861; a=rsa-sha256;
	cv=none;
	b=HPmK1dP36+LGV9kAppCDy/UZeQB+qrL+8LyFtnviRemo8E88XjEACiMxMHYa8ceZrYDsDR
	0D2/Rowc/ZXS2gHDVtfYYxjLfvBq0aIrqYDrVUpVTlPm8f22Qv89QY4p7efi9FkGAxPQmE
	RigFhWs9GALXWFmXI0Y/ufPpU1ZcSJY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B80A160053;
	Mon, 23 Feb 2026 11:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0950C116C6;
	Mon, 23 Feb 2026 11:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771846860;
	bh=qrXa/Wr53xTJqgHdzVRXulaaQTYzTEAq+rdxL37Pyos=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G75sdQiCUW2hAwslW/UziV6cmDnamVeOib744rgleMOjenaV1r49JpJsGpuADv/bm
	 MOuQuuo4Rfg64VRkqPgxnqsOmi6vvW0EkBLi6QGlJbnNlGjVkHMiUg8M00vF9U79Iu
	 W7qgQ2gRB9YoS7FJU1KOO84nGrJgKLY2qKQHxcyJpvK7DVTtrXPkQ44U3uzx3NEgF6
	 V1g4om58LSSMy1tmul2XG6bV1YXrrkF9oRfXPBsXpNVZ2j8rG5KqTt1+txUafiTKDn
	 f0efF1hjGJr2j2Fh8A1wsRaBfIewJvAFO1Rh0thJ+Ju5y46bRsJNxorGtjlC4hcolr
	 SD/4+ZPh+qD7A==
Date: Mon, 23 Feb 2026 13:40:53 +0200
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
Message-ID: <aZw8xSI-TM-Gz84t@kernel.org>
References: <20260223075219.2348035-1-rppt@kernel.org>
 <b6f4edf5-7587-45d7-b81a-590d4f3d1ddd@app.fastmail.com>
 <aZwyNAbEqb8ZwLUM@kernel.org>
 <e2ad0845-2f87-418a-9f87-5ce619e004ef@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2ad0845-2f87-418a-9f87-5ce619e004ef@app.fastmail.com>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 78ADCC000A
X-Stat-Signature: cuwtbq7384ukgmuhofbpafip8h9dy9f4
X-HE-Tag: 1771846861-308159
X-HE-Meta: U2FsdGVkX1/TfuX8ynHxCSSwoq8oL7BYfnWntHIHZJ/2BDDIdOBnp4mBj04/1JJifCxNHcMUZGstMrY//3vR8lO4jV4x6+fK24kNEHJxJn9GdZDTIvZTekm/GM/E5VvODSbIlt9ZeqM7IKUjlipJKZCkUpmCbqOsbXciR4CUTb0QFXl+LAajASspJmiPSU4Ge4N7kcObKfEfJ8+/4AgjfnPdPu2Mhpp29Ijj2JkDodF4nWYvnIiHO4fgLT9nnp7YkUZj3n4Eema25wzZaazw8WPs7LTV9WfJI6HV0YRKRCinO/cYs1pTL54MdYHPlQM7YKCoFklh/sdoZuINFJmmhDpnGVMfoyidBtRJAIIb1JMP90vvA/S+wj3Iro4YcgwpsvCvpOm3zQzBwiT6FIttasoO6bb/lqRTyU8f8+GIiXtekPOxkDzeBAWfEhJ+jdzriJtSumQwhD/41JOzsLd6w8VVx7BSPIpJebozeLUD39JbuTd39EYSIw8sYYQfW8LxwRvjRkiCOyxHBGeMV09YvkvjQy+GAbOPtBzYw/GUydckTC1V49ZTAHCkIuzwabEpJQdUdWJg5USjQFS1hEZRz9Pi1r7i6eKfvibIjNkJX9daA057GusS2V+EBbC5nuZ7D3LwRyBwimGmg4YTGdDLY3+dnfQZiDVHUy/bW/lgW4fkTZtIoOSgff+sw/8490idXC+QBAsDKzAv6PZMwI/Gx6Dte92KMG3jH27lpmoeU5b3go7UAjbIgMoO6KFPKrhpyEjGFjIAgTftgfLm3xxNUf+thkua9lkD6ncxM1q3NV/wYLDYmJSPxyf8FNmfGKbTNtwC/vM3CYbtiqHNfLcQLI4rVDH7MVMZYX+vRLhuV8qgCLz2U5WOTl3e4l6b9BkzmDQaBnLtxUTkaS4cuCKjxEec9ifQ7KOVxYou8nZTAwCIcRJZwJV1c+bR3JCqJkDFZMZRfoK51e2PdoOpSte
 RG1Oi3Bf
 26pEoU+rn0gNpnzF68CXJ/xSBn9+bBGGY3y+LH4hx5VWAcnIOgFrIc4KCOOk9eFl6m4cEcRN7BRLBpWyIWNt0BbI8ewQ0qm4sL/e/3c6N9s4LniRk3o6S1CFhoIuyekMoMr8/TuMcSx8oYvPmlfiKbtIOvu5M3w9PMi6NkcyHD0/NI7LOH8QHNI9LuS/tn3FhNt/elmneS9Xb8oFlHNbqQdIYPJu8rfruwM22Fuk5JY4ws8GRwQ6m+bCPC4SCL3tLnxyNr3BZpkzs9KS4Tf9bJevUiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 12:17:22PM +0100, Ard Biesheuvel wrote:
> 
> On Mon, 23 Feb 2026, at 11:55, Mike Rapoport wrote:
> > Hi Ard,
> >
> > On Mon, Feb 23, 2026 at 09:08:29AM +0100, Ard Biesheuvel wrote:
> >> Hi Mike,
> >> 
> >> On Mon, 23 Feb 2026, at 08:52, Mike Rapoport wrote:
> >> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >> >
> >> > efi_free_boot_services() frees memory occupied by EFI_BOOT_SERVICES_CODE
> >> > and EFI_BOOT_SERVICES_DATA using memblock_free_late().
> >> >
> >> > There are two issue with that: memblock_free_late() should be used for
> >> > memory allocated with memblock_alloc() while the memory reserved with
> >> > memblock_reserve() should be freed with free_reserved_area().
> >> >
> >> > More acutely, with CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
> >> > efi_free_boot_services() is called before deferred initialization of the
> >> > memory map is complete.
> >> >
> >> > Benjamin Herrenschmidt reports that this causes a leak of ~140MB of
> >> > RAM on EC2 t3a.nano instances which only have 512MB or RAM.
> >> >
> >> > If the freed memory resides in the areas that memory map for them is
> >> > still uninitialized, they won't be actually freed because
> >> > memblock_free_late() calls memblock_free_pages() and the latter skips
> >> > uninitialized pages.
> >> >
> >> > Using free_reserved_area() at this point is also problematic because
> >> > __free_page() accesses the buddy of the freed page and that again might
> >> > end up in uninitialized part of the memory map.
> >> >
> >> > Delaying the entire efi_free_boot_services() could be problematic
> >> > because in addition to freeing boot services memory it updates
> >> > efi.memmap without any synchronization and that's undesirable late in
> >> > boot when there is concurrency.
> >> >
> >> > More robust approach is to only defer freeing of the EFI boot services
> >> > memory.
> >> >
> >> > Make efi_free_boot_services() collect ranges that should be freed into
> >> > an array and add an initcall efi_free_boot_services_memory() that walks
> >> > that array and actually frees the memory using free_reserved_area().
> >> >
> >> 
> >> Instead of creating another table, could we just traverse the EFI memory
> >> map again in the arch_initcall(), and free all boot services code/data
> >> above 1M with EFI_MEMORY_RUNTIME cleared ?
> > 
> > Currently efi_free_boot_services() unmaps all boot services code/data with
> > EFI_MEMORY_RUNTIME cleared and removes them from the efi.memmap.
> 
> Ah yes, I failed to spot that those entries are long gone by initcall
> time. Other architectures don't touch the EFI memory map at all, but x86
> mangles it beyond recognition :-)

Heh, EFI on x86 does a lot of, hmm, interesting things with memory, like
memremaping kmalloced memory and I it really begs for cleanups :)
 
> > I wasn't sure it's Ok to only unmap them, but leave in efi.memmap, that's
> > why I didn't use the existing EFI memory map.
> >
> > Now thinking about it, if the unmapping can happen later, maybe we'll just
> > move the entire efi_free_boot_services() to an initcall?
> >
> 
> As long as it is pre-SMP, as that code also contains a quirk to allocate
> the real mode trampoline if all memory below 1 MB is used for boot
> services.

initcall is long after SMP. It the real mode trampoline allocation is the
only thing that should happen pre-SMP?
 
> But actually, that should be a separate quirk to begin with, rather than
> being integrated into an unrelated function that happens to iterate over
> the boot services regions. The only problem, I guess, is that
> memblock_reserve()'ing that sub-1MB region in the old location in the
> ordinary way would cause it to be freed again in the initcall?

Right now we anyway don't free anything below 1M, I don't see why it should
change. 

> But yes, in general I think it is fine to unmap those regions from the
> EFI page tables during an initcall.

Thanks for confirming. I'll look into extracting the allocation of the real
mode trampoline to a separate quirk and then making the entire
efi_free_boot_services() an initcall.

-- 
Sincerely yours,
Mike.

