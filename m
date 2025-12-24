Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D447BE74916
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 11:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46FC36B0005; Wed, 24 Dec 2025 06:35:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447966B0088; Wed, 24 Dec 2025 06:35:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3499D6B008A; Wed, 24 Dec 2025 06:35:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2486F6B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 06:35:45 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF1721370A4
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 11:35:44 +0000 (UTC)
X-FDA: 84254159808.07.60408E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 23C964000B
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 11:35:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xyh3uCiq;
	spf=pass (imf12.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766576143; a=rsa-sha256;
	cv=none;
	b=4kdCjsCJrpG+q0rC2YurAGTot+BCMPVoU+P0jG4beTSVwATu0at4oXbNWQAIBLSHvpXFOy
	gt2Yt9m6ddaF6K6igyNsmgNs91k/fjCoQGlB8ZeF4aW3Sug2DiiNmMVk+IcL8WZ5GhJQV0
	LooDuzQkT4VcznuSAnYiWCV26GCihcs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xyh3uCiq;
	spf=pass (imf12.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766576143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aPfIf24VliWQq0f8Kj4Kw8bFV8BRu0VC6Nhx23FKLvY=;
	b=qHNCmbnInNiHyn+TagK+3P+GmVjKsRvarGCr1weUdBvQHN9mArAqeYvhYM2mtf18fKzxYQ
	d10HTL82UwNjtQnRQkMreGKFawUiROK9881F7KG6tbSH8FvoQfCEH5pZkuDLTFxk/8JzvY
	2dpP6kENnY9BB/gl0AGAhY4FTnOsWOA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CEE260010;
	Wed, 24 Dec 2025 11:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A511C4CEFB;
	Wed, 24 Dec 2025 11:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766576142;
	bh=rcZ3nMY4d65lf7YZ3P3xmWEvn3BCIy1Hqxm5btFypgE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Xyh3uCiqBwLSFzvpXcwS7OgzIHuc0bPj2+++1C+l1eEdHzwH9vJxSkiPqkRFMbS1y
	 ps9iufDkUHMFc+Ubsp/Ih+8vg/xG8gALVWWcXY8qNStsjwnxrLOqaekU8um42jJEfS
	 Lc4m/ukrr2IIbJASAXqg+HHenooEDls2rLMRH+jytjJ6hh1g6L3+GcX8wqn7OZWMYC
	 HKN4ffk7wlUSVmn8o1KLxUx+Ck8RnJ4pswDZfnYqLfRA9T9YiYmihb5Eh3YYjWHQxH
	 H4dgYwbOm0YyQODKZahb3AHHHOWVb79bXnGIvQqAB1Qib22CmyKuAdU37Gl3WgD+CW
	 8Arj0xFK1ZM8A==
Message-ID: <6089e76b-80aa-4254-af70-12b96d115a2e@kernel.org>
Date: Wed, 24 Dec 2025 12:35:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] arch/*: increase lowmem size to avoid highmem use
To: Arnd Bergmann <arnd@kernel.org>, linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
 Andreas Larsson <andreas@gaisler.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Linus Walleij <linus.walleij@linaro.org>,
 Matthew Wilcox <willy@infradead.org>, Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Michal Simek <monstr@monstr.eu>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nishanth Menon <nm@ti.com>, Lucas Stach <l.stach@pengutronix.de>
References: <20251219161559.556737-1-arnd@kernel.org>
 <20251219161559.556737-2-arnd@kernel.org>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20251219161559.556737-2-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 23C964000B
X-Rspamd-Server: rspam04
X-Stat-Signature: 679dauezqahjbqs1qheoc8ibjujfikt9
X-HE-Tag: 1766576143-710185
X-HE-Meta: U2FsdGVkX19I/ldKg2wmlncpQ0TpbsfECbwmc+0eJMM7M6KzqicV9OFqY3YW5QizB8+Ygpo6dboxo2OfYSEdwUnM6Z8yfCF/mwmCprp9FGrcOlZ033NfW83jyNwfi+RA8dSOoBM5Zkcn7BwrW0SN0qWzy2yFJknR6CszlTAwtQuLmTMG3VatLJT9cyDgwLF1+ThvKkKsVAp4VWq4Yc79FgXm793ObxE3KkgrLDjxd/SElnwbapH+lHdILUWoQnpUPn4pZJauuWZyvhMJsqfyubJ5PXKSwTNU2YQOii4FUaUFMyfXc3forXZxcoNldiaBJmdXEux67k2fRbXeO91qbQhb4C+khq3MLIW0DYJ4VNVAANHxF+/wxhEXpyHIFQ8oGeYkQD4gobhFB9L2P/aXkZyTt94bZT0+LGsCZkHp5m2CCxPSEhgbO32Mdw1jCciB6aDa/4y2+CryjyRNMb1bvYVwmjBXljXbpS65j0Nx1uTUoMJ6Dhgy5Do0xbItdTx1XNSXkmmHm8beynKi0imFnhtwYHrFYFaa5LhNQDUGLkd4l7ymcVwmOn7UoX3r7h11JrDcQ425qKGPkQmXxVwNgac/Dms2D/fRs9yxNzuoyffObAWfmBoVrGBSvGZMAa+833L+8Q4ItyANfOVFe8NoMHGQABdX7vXcciQrPeSWxQDoPxE4fVKhmQXmKWrhSBOzWHhfcnkD4vWqYMnEmi9miHkwUd2vp+r3MJOetokDAHtj/alabqe/XIH+m3GVqv7drc/SfaIkv87goYq49sHrIx6P/0DV+lULxO5bKYf7SaEV+cIcZMMgZYKcuukMEDQwvxT4EL8xMG9JCBREGCJrjGVpjzEqpI0rFH5waxgrYBe5xZanAp6d5rXXO225svlhUjEMkwS31tdNwztLY8OD95t5PJ0vte8kOLIYFEpx/GiKf41USTXbrzMhzfM+jXekb8hOIHPhsGEz6Vj5GKv
 Hez9F3tT
 GdPPg6aj13S01vTBU9Ly36etxuTrGE+gKwAMTl/RQC16QmVocJvBhl0n/o5sp+ZEdhEDMYhKqKlbF/KJV7GLKE2STz21HlGEn8p4qgsQd+hSaFLednluyh9Bm6saffhmoKiRufOWFVwYuzuOracGz1OOmXu6fPoc6gXC4FffMSu21jY1ckp+0bFRw/ZpgdCaZQONt4VnbQhReKWQ2PJZNEomfgjVQfhGYdvHw24+iqXfDAL7kDgYRJr6ylA4CIPQ4JV5Pd5C7NA7X8/RukYN+NypsHWkJ7iExp7Jc3XuQDmegBM74y9vO5+5WeWBgD0zQJxQHbFjy77cQtYhX8zyO+ovrfBcKmKuYpfoc34FTUHbSyfU15Yk/6b2NYog8BhmtT0ZKCDxkj0xYjDRlUn+De4gp3b4fe/KVp6qDu8zC2x+6fNCJaz9mbMpxF1kCskWDhLOsEOZGoZlIMckohwjVeB++EmGLXacw3ULis8xfZnmi1buCBLFKjMGMqB0OLMn7HmNG6Qaroz1XTUsTguQsx/ivj5HzkZkI5/tXM9lCfJWnf1eVk44R6VLK+A4avxVaH8r8ozUvnudyKUdSXnuiDj6l7K20C81cjNZHOpTAggxNlHp6h40o6l/3UhqzJQNJhkS2uepktTEMF6R6mopbIlQzDyX0BHcQYDS2eJu4V3DApTBChvSrxT+HP92fDEdET2lwox5IGvYzGSyk74tusBSEJhreqJbSvY765Qnjd2s6BWwYQZEs9EXWKlBtAb5sY0UmLyx23B4+fLS5pD9NoLQvbQRbXBjgKm7IehgOcNkSH81ofgEjoF+zJKgU3KljUVDe4XpSIiPIRxmRAEcluVliCUXJMQAkHPg+S6ox0sJKB0YQNQkr4BIaluzBmCcLWSahNOE/bEHCII9NrN62SuJ3J08ipnTKp0lCOwPE400gFKaJJkPn/XzleiWRrftIbJY7Q16Qao3fZP1QRvBnzgTSW11t
 wPbAAS7k
 XeVDJMyVi2zwvz47c/vku8fvVLr0OBninvwT3UeEZDJcgfsn+kvDKmt+LwmcqqVeImMNWRQGML4Cta57mtILGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 19/12/2025 à 17:15, Arnd Bergmann a écrit :
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Most of the common 32-bit architectures (x86, arm, powerpc) all use the
> default virtual memory layout that was already in place for i386 systems
> in the 1990s, using exactly 3GiB of user TASK_SIZE, with the upper 1GiB
> of addresses split between (at most 896MiB) lowmem and vmalloc.
> 
> Linux-2.3 introduced CONFIG_HIGHMEM for large x86 server machines that
> had 4GiB of RAM or more, with the VMSPLIT_3G/2G/1G options added in
> v2.6.16 for machines that had one or two gigabytes of memory but wanted
> to avoid the overhead from managing highmem. Over time, similar options
> appeared on other 32-bit architectures.
> 
> Twenty years later, it makes sense to reconsider the default settings,
> as the tradeoffs have changed a bit:
> 
>   - Configurations with more than 2GiB have become extremely rare,
>     as any users with large memory have moved on to 64-bit systems.
>     There were only ever a few Laptop models in this category: Apple
>     Powerbook G4 (2005), Macbook (2006), IBM Thinkpad X60 (2006), Arm
>     Chromebooks based on Exynos 5800 (2014), Tegra K1 (2014) and RK3288
>     (2015), and manufacturer support for all of these has ended in 2020
>     or (much) earlier.
>     Embedded systems with more than 2GiB use additional SoCs of a
>     similar vintage: Intel Atom Z5xx (2008), Freescale QorIQ (2008),
>     Marvell Armada XP (2010), Freescale i.MX6Q (2011), LSI Axxia (2013),
>     TI Keystone2 (2014), Renesas RZ/G1M (2015). Most boards based on
>     these have stopped receiving kernel upgrades. Newer 32-bit chips
>     only support smaller memory configurations, though in particular the
>     i.MX6Q and Keystone2 families have expected support cycles past 2035.
>     While 32-bit server installations used to support even larger memory,
>     none of those seem to still be used in production on any architecture.
> 
>   - While general-purpose distributes for 32-bit targets were common,
>     it was rather risky to change the CONFIG_VMSPLIT setting because
>     there is always a possibility of running into device driver bugs or
>     applications that need a large virtual memory size. Presumably
>     a lot of these issues have been resolved now, so most setups should
>     be fine using a custom vmsplit instead of highmem now.
> 
>   - As fewer users test highmem, the expectation is that it will
>     increasingly break in the future, so getting users to change the
>     vmsplit means that even if there is a bug to fix initially,
>     it improves the situation in the long run.
> 
>   - Highmem will ultimately need to be removed, at least for the page
>     cache and most other code using it today. In a previous discussion, I
>     had suggested doing this as early as 2029, but based on the discussions
>     since ELC, the plan is now to leave highmem-enabled page cache as an
>     option until at least 2029, at which point remaining users will have
>     the choice between no longer updating kernels or using a combination of
>     a custom vmsplit and zram/zswap. Changing the defaults now should both
>     speed up the highmem deprecation and make it less painful for users.
> 
>   - The most VM space intensive applications tend to be web browsers,
>     specifcally Chrome/ChromeOS and Firefox. Both have now stopped
>     providing binary updates, but Firefox can still be built from source.
>     Testing various combinations on Debian/armhf, I found that Firefox 140
>     can still show complex websites with VMSPLIT_2G_OPT with and without
>     HIGHMEM, though it failed for me both with the small address space
>     of VMSPLIT_1G and the small lowmem of VMSPLIT_3G_OPT when HIGHMEM
>     is disabled.
>     This is likely to get worse with future versions, so embedded users
>     may still be forced to migrate to specialized browsers like WPE Webkit
>     when HIGHMEM pagecache is finally removed.
> 
> Based on the above observations and the discussion at the kernel summit,
> change the defaults to the most appropriate values: use 1GiB of lowmem on
> non-highmem configurations, and either 2GiB or 1.75GiB of lowmem on highmem
> builds, depending on what is available on the architecture.  As ARM_LPAE
> and X86_PAE builds both require a gigabyte-aligned vmsplit, those get
> to use VMSPLIT_2G. The result is that the majority of previous highmem
> users now only need lowmem. For platform specific defconfig files that
> are known to only support up to 1GiB of RAM, drop the CONFIG_HIGHMEM line
> as well as a simplification.
> 
> On PowerPC and Microblaze, the options have somewhat different names but
> should have the same effect. MIPS and Xtensa cannot support a larger
> than 512MB of lowmem but are limited to small DDR2 memory in most
> implementations, with MT7621 being a notable exception. ARC and C-Sky
> could support a configurable vmsplit in theory, but it's not clear
> if anyone still cares.
> SPARC is currently limited to 192MB of lowmem and should get patched
> to behave either like arm/x86 or powerpc/microblaze to support 2GiB
> of lowmem.
> 
> There are likely going to be regressions from the changed defaults,
> in particular when hitting previously hidden device driver bugs
> that fail to set the correct DMA mask, or from applications that
> need a large virtual address space.
> Ideally the in-kernel problems should all be fixable, but the previous
> behavior is still selectable as a fallback with CONFIG_EXPERT=y
> 
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: x86@kernel.org
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: linux-mm@kvack.org
> Cc: Richard Weinberger <richard@nod.at>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Nishanth Menon <nm@ti.com>
> Cc: Andreas Larsson <andreas@gaisler.com>
> Cc: Lucas Stach <l.stach@pengutronix.de>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   arch/arm/Kconfig                            |  5 ++++-
>   arch/arm/configs/aspeed_g5_defconfig        |  1 -
>   arch/arm/configs/dove_defconfig             |  2 --
>   arch/arm/configs/mv78xx0_defconfig          |  2 --
>   arch/arm/configs/u8500_defconfig            |  1 -
>   arch/arm/configs/vt8500_v6_v7_defconfig     |  3 ---
>   arch/arm/mach-omap2/Kconfig                 |  1 -
>   arch/microblaze/Kconfig                     |  9 ++++++---
>   arch/microblaze/configs/mmu_defconfig       |  1 -
>   arch/powerpc/Kconfig                        | 17 +++++++++++------
>   arch/powerpc/configs/44x/akebono_defconfig  |  1 -
>   arch/powerpc/configs/85xx/ksi8560_defconfig |  1 -
>   arch/powerpc/configs/85xx/stx_gp3_defconfig |  1 -

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

Be aware that it will likely trivialy conflict with 
https://lore.kernel.org/linuxppc-dev/6a2575420770d075cd090b5a316730a2ffafdee4.1766574657.git.chleroy@kernel.org/

Another point is that it will increase the overall memory usage when 
people activate KASAN as KASAN reserves 1/8 of RAM for lowmem memory. I 
think we need to look at the impact on available virtual memory, because 
1/8 of 2G is 256M which is the size of the last segment shared by KASAN 
shadow mem and vmalloc.

Christophe


