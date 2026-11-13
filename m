Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 553FB606A896
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IVa1pdaT
Received: by kanga.kvack.org (Postfix)
	id 4AF2F6B00EF; Fri, 13 Nov 2026 13:29:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45FBD6B05B0; Fri, 13 Nov 2026 13:29:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3286B6B05B1; Fri, 13 Nov 2026 13:29:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 085AD6B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:29:10 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE57FA77D6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:29:07 +0000 (UTC)
X-FDA: 85430932734.14.93AD02A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4798A10000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:29:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IVa1pdaT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794594546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VA8bk9ERwXuNEDBoJnHNSRw6hKUgevqXTx1c8nNVso8=;
	b=TmaYu5mbjkSx0PmboDXYdEYpr6tif+/dGvjmEwSBuz7gc5fZVugn83fbjGt1RRSror3sHR
	YZkGIv3SNkTN1IC6IR6mC+zESuro7KLKqz0obp2W3CnIiQ8FSQR0De1VdsCR3bFvoH9gb5
	4eZacrxPaWVdYeQHR5/ntvMSuUxjcVw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IVa1pdaT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794594546;
	b=JNf2jYFzlcNUGGv3TXR42K8oOgF/WzljiY7OxEwNNXkoHLemtfr1iHQca+dMWHiuCLhGce
	HArP4DO7W1HfpnaS9paFzrQfhFUvFkeoEMw5gCKC3Z+2jPjp1c4IiiQxoY5GNOp161Z4p1
	V++Cyk0H7D3glg/ki5n+d2rEf2wl3Jw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A73C7609ED;
	Fri, 13 Nov 2026 18:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B26B1F000C5;
	Fri, 13 Nov 2026 18:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794594545;
	bh=VA8bk9ERwXuNEDBoJnHNSRw6hKUgevqXTx1c8nNVso8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IVa1pdaTdvJPJW//quHT797JAknHetwTWP7XqIoxrHXy3p4kDfkDlbx/DJJxbKsog
	 rVFaQbg1Xck2HGSyWeu56XkGjrKwJPV0lS+xf5BDNqkkNmvShfyS2sbc1jFKZIOewA
	 dJiBcGQ9c5b79av0BG88cuTvdQG51W4RdcMPeVA/yOq6gfQ9JazFJwgKGV1TsFFpez
	 G3/qzHYX9Fsiu09GVI+/44p89d/EhN8NqzC+7WCjmY2yfIdF6US3wYkdAj9qcHtMmW
	 ulHbdzl8VNIr0omw2Ava7FxqFWAvagnGxDQdCSQB/MMZ6HIsYv3Bza2BR2Dz0h2hSV
	 Lt4YVL9fVueKA==
Date: Fri, 13 Nov 2026 18:28:58 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Andreas Larsson <andreas@gaisler.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Matthew Wilcox <willy@infradead.org>, 
	Malin Jonsson <malin.jonsson@est.tech>, Richard Weinberger <richard@nod.at>, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Subject: Re: [PATCH v2 1/6] ARM: remove support for highmem on VIVT
Message-ID: <avdWJOWX3X2KlZfr@gremlin>
References: <20261112112528.1116405-1-arnd@kernel.org>
 <20261112112528.1116405-2-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112112528.1116405-2-arnd@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4798A10000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: riigyor43rwu5s9o763wr7aeiwcexta8
X-HE-Tag: 1794594546-48499
X-HE-Meta: U2FsdGVkX19IfMi7q5/XgokpK0I0oxWh2JOB0UMMGkpo6v+2VTdQ8iMgMx2DUnZ2pDJqvIt0YF1QuZc0zKkBPl4lIUeUzuB/9yhgG5VGHDf0kzRgYkwy1prQ7YiRLZSGg+12sHmMXzL7lQ777qCqGAyi/9FFE5JmxZ6H5B0oWB8a2DLhUGyyTgvMTx+c7VjdgjS5Up3ZhjW1KxcIfJPZqQsG0Wy9gL3n46xXRgkWXDBOpbEvlsLOATvgIystz1gSo6usTkpm1eI5B2Nw6OogrrCfIkKtIUT1NJO3BGMPCF3/u4pspAeOKZiNSnJEtYYQueULcQPlA8AfcXCff7d99HrzOtlhxTAo0kZ+Mq9qK8j9l/5FltDUs9xIlLyWOJP0nIzPtoItZamJi9J5V50DXt+XEKJpgkVNpeVwaHd4xVb+9ZENpYcVSi2+sL8G3Wk6WStb4LeowvOHhcZHdID3xPEWLKXXyRi1w6ss+z/gAQ8JHvsYO1ngV4ZGvGVTv92ZMj7B6Pwhp4qY9i381GLm+qnJBBImhqkqnZRMlbFrnrF7mqm0rc9ES4xrUipgUaNxGDBhPn23DbLMBwpbcoWuowWW7+V72tlYO6xhEu5JVClNNzSRhqjnZye9SDVWR+OEMp0bm85docXViVFTkXpb3edPMpvt8nqA20nNsARXANLSv62r0CSp1yzqbGthdKRTmnjbSSXMOhYykgB6DI7f9Eg8uZAXGeQ5YEzwtiExgRrGbkLmcIZ1kXxOlW0lEMlu+gomw2sjIXZtM+c3p8H9eWqOgB4VB8qIpgdNseonQN2SpPQ4Z9VVb3qFXk88qWNrSV8UDyhqIKnGA2pWCRHv/ykge7BtdavsQIghUbDGpDGYvKOHI38z4ab9ZeQ1XCS5ho91Zl+RMNbicveOaPL/vzO0EoLm9sAe4Te46cNw189FV8NRFcl2dihtmeu5OQw+KIxDEh4zzsCYVGmXglk
 fACUZqsi
 aYlyuCtDWAPTlp7UJBLvUC9hU9Wqk9CWB38mzsrEY4E/ohxg2JyLJczzfcqTsX5q9jgO91ZXJw9/oToYoxOEBFOC8BvremBF5NXzGoOACpEIK/YC5mFmJvV7Ig2RYaGn1CNUsbxzMUkWk84L/uQwecfyXk7gEFipmCP4/K6lTcNAfOWCBECfhz2yskBcfcuSK6LDVeG2d94dBl/wGGLlbM+pV4k7xRCAbD6hO1tU4C+WI8FjF//Vb7f4IXk6Di4obanwuKqj3tNf9z7Ynh8ZLFdd445kYbSZRHIGGSDKDceRC3+0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 12:25:23PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> As Jason Gunthorpe noticed, supporting VIVT caches adds some complications
> to highmem that can be avoided these days:
>
> While all ARMv4 and ARMv5 CPUs use virtually indexed caches, they no
> longer really need highmem because we have practically discontinued
> support for large-memory configurations already.  The only machines I
> could find anywhere for memory on ARMv5 are:
>
>  - The Intel IOP platform was used on relatively large memory
>    configurations but we dropped kernel support in 2019 and 2022,
>    respectively.
>
>  - The Marvell mv78xx0 platform was the initial user of Arm highmem,
>    with the DB-78x00-BP supporting 2GB of memory. The only remaining
>    board file is for Buffalo WLX (Terastation Duo), which has only
>    512MB and is going to be removed soon.
>
>  - The Kirkwood platform supports 2GB, and there are actually boards
>    with that configuration that can still work. However, there are
>    no known users of the OpenBlocks A7, and the Freebox V6 is already
>    using CONFIG_VMSPLIT_2G to avoid enabling highmem.
>
> Remove the Arm specific portions here, making CONFIG_HIGHMEM conditional
> on modern caches. Since the cache type is enforced by Kconfig, no
> boot time check is needed here.
>
> Link: https://lore.kernel.org/all/20251219171412.GG254720@nvidia.com/
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Really lovely! All looks reasonable AFAICT so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/arm/Kconfig                    |  1 +
>  arch/arm/configs/gemini_defconfig   |  1 -
>  arch/arm/configs/multi_v5_defconfig |  1 -
>  arch/arm/configs/mvebu_v5_defconfig |  1 -
>  arch/arm/include/asm/highmem.h      | 56 ++---------------------------
>  arch/arm/mach-omap2/Kconfig         |  2 +-
>  arch/arm/mm/cache-feroceon-l2.c     | 31 ++--------------
>  arch/arm/mm/cache-xsc3l2.c          | 47 +++---------------------
>  arch/arm/mm/dma-mapping.c           | 12 ++-----
>  arch/arm/mm/flush.c                 | 19 +++-------
>  10 files changed, 17 insertions(+), 154 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 0cc289a7184a..fd01ccab9c12 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1208,6 +1208,7 @@ config ARCH_SPARSEMEM_ENABLE
>  config HIGHMEM
>  	bool "High Memory Support"
>  	depends on MMU
> +	depends on !CPU_CACHE_VIVT
>  	select KMAP_LOCAL
>  	select KMAP_LOCAL_NON_LINEAR_PTE_ARRAY
>  	help
> diff --git a/arch/arm/configs/gemini_defconfig b/arch/arm/configs/gemini_defconfig
> index 5860b2fe7d1f..95debf46581b 100644
> --- a/arch/arm/configs/gemini_defconfig
> +++ b/arch/arm/configs/gemini_defconfig
> @@ -11,7 +11,6 @@ CONFIG_KEXEC=y
>  CONFIG_ARCH_MULTI_V4=y
>  # CONFIG_ARCH_MULTI_V7 is not set
>  CONFIG_ARCH_GEMINI=y
> -CONFIG_HIGHMEM=y
>  CONFIG_CMDLINE="console=ttyS0,115200n8"
>  CONFIG_PM=y
>  CONFIG_PARTITION_ADVANCED=y
> diff --git a/arch/arm/configs/multi_v5_defconfig b/arch/arm/configs/multi_v5_defconfig
> index a0d2fb2fcf9a..bc34b6026e37 100644
> --- a/arch/arm/configs/multi_v5_defconfig
> +++ b/arch/arm/configs/multi_v5_defconfig
> @@ -27,7 +27,6 @@ CONFIG_MACH_D2NET_DT=y
>  CONFIG_MACH_MSS2_DT=y
>  CONFIG_ARCH_SUNXI=y
>  CONFIG_ARCH_VERSATILE=y
> -CONFIG_HIGHMEM=y
>  CONFIG_ARM_APPENDED_DTB=y
>  CONFIG_ARM_ATAG_DTB_COMPAT=y
>  CONFIG_CPU_FREQ=y
> diff --git a/arch/arm/configs/mvebu_v5_defconfig b/arch/arm/configs/mvebu_v5_defconfig
> index dbc6c511e70b..5adf6c75304e 100644
> --- a/arch/arm/configs/mvebu_v5_defconfig
> +++ b/arch/arm/configs/mvebu_v5_defconfig
> @@ -13,7 +13,6 @@ CONFIG_MACH_RD88F5182_DT=y
>  CONFIG_MACH_LINKSTATION_MINI=y
>  CONFIG_MACH_D2NET_DT=y
>  CONFIG_MACH_MSS2_DT=y
> -CONFIG_HIGHMEM=y
>  CONFIG_ARM_APPENDED_DTB=y
>  CONFIG_ARM_ATAG_DTB_COMPAT=y
>  CONFIG_CPU_FREQ=y
> diff --git a/arch/arm/include/asm/highmem.h b/arch/arm/include/asm/highmem.h
> index bdb209e002a4..67ed46d1922b 100644
> --- a/arch/arm/include/asm/highmem.h
> +++ b/arch/arm/include/asm/highmem.h
> @@ -11,66 +11,14 @@
>  #define PKMAP_NR(virt)		(((virt) - PKMAP_BASE) >> PAGE_SHIFT)
>  #define PKMAP_ADDR(nr)		(PKMAP_BASE + ((nr) << PAGE_SHIFT))
>
> -#define flush_cache_kmaps() \
> -	do { \
> -		if (cache_is_vivt()) \
> -			flush_cache_all(); \
> -	} while (0)
> +#define flush_cache_kmaps() do { } while (0)
>
>  extern pte_t *pkmap_page_table;
>
> -/*
> - * The reason for kmap_high_get() is to ensure that the currently kmap'd
> - * page usage count does not decrease to zero while we're using its
> - * existing virtual mapping in an atomic context.  With a VIVT cache this
> - * is essential to do, but with a VIPT cache this is only an optimization
> - * so not to pay the price of establishing a second mapping if an existing
> - * one can be used.  However, on platforms without hardware TLB maintenance
> - * broadcast, we simply cannot use ARCH_NEEDS_KMAP_HIGH_GET at all since
> - * the locking involved must also disable IRQs which is incompatible with
> - * the IPI mechanism used by global TLB operations.
> - */
> -#define ARCH_NEEDS_KMAP_HIGH_GET
> -#if defined(CONFIG_SMP) && defined(CONFIG_CPU_TLB_V6)
> -#undef ARCH_NEEDS_KMAP_HIGH_GET
> -#if defined(CONFIG_HIGHMEM) && defined(CONFIG_CPU_CACHE_VIVT)
> -#error "The sum of features in your kernel config cannot be supported together"
> -#endif
> -#endif
> -
> -/*
> - * Needed to be able to broadcast the TLB invalidation for kmap.
> - */
> -#ifdef CONFIG_ARM_ERRATA_798181
> -#undef ARCH_NEEDS_KMAP_HIGH_GET
> -#endif
> -
> -#ifdef ARCH_NEEDS_KMAP_HIGH_GET
> -extern void *kmap_high_get(const struct page *page);
> -
> -static inline void *arch_kmap_local_high_get(const struct page *page)
> -{
> -	if (IS_ENABLED(CONFIG_DEBUG_HIGHMEM) && !cache_is_vivt())
> -		return NULL;
> -	return kmap_high_get(page);
> -}
> -#define arch_kmap_local_high_get arch_kmap_local_high_get
> -
> -#else /* ARCH_NEEDS_KMAP_HIGH_GET */
> -static inline void *kmap_high_get(const struct page *page)
> -{
> -	return NULL;
> -}
> -#endif /* !ARCH_NEEDS_KMAP_HIGH_GET */
> -
>  #define arch_kmap_local_post_map(vaddr, pteval)				\
>  	local_flush_tlb_kernel_page(vaddr)
>
> -#define arch_kmap_local_pre_unmap(vaddr)				\
> -do {									\
> -	if (cache_is_vivt())						\
> -		__cpuc_flush_dcache_area((void *)vaddr, PAGE_SIZE);	\
> -} while (0)
> +#define arch_kmap_local_pre_unmap(vaddr) do { } while (0)
>
>  #define arch_kmap_local_post_unmap(vaddr)				\
>  	local_flush_tlb_kernel_page(vaddr)
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index 79f8afe3a6bf..f0f1d7a8640c 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -135,7 +135,7 @@ config ARCH_OMAP2PLUS_TYPICAL
>  	bool "Typical OMAP configuration"
>  	default y
>  	select AEABI
> -	select HIGHMEM
> +	select HIGHMEM if !CPU_CACHE_VIVT
>  	select I2C
>  	select I2C_OMAP
>  	select MENELAUS if ARCH_OMAP2
> diff --git a/arch/arm/mm/cache-feroceon-l2.c b/arch/arm/mm/cache-feroceon-l2.c
> index 2bfefb252ffd..1316b6ab295a 100644
> --- a/arch/arm/mm/cache-feroceon-l2.c
> +++ b/arch/arm/mm/cache-feroceon-l2.c
> @@ -12,7 +12,6 @@
>  #include <linux/init.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> -#include <linux/highmem.h>
>  #include <linux/io.h>
>  #include <asm/cacheflush.h>
>  #include <asm/cp15.h>
> @@ -38,30 +37,6 @@
>   * between which we don't want to be preempted.
>   */
>
> -static inline unsigned long l2_get_va(unsigned long paddr)
> -{
> -#ifdef CONFIG_HIGHMEM
> -	/*
> -	 * Because range ops can't be done on physical addresses,
> -	 * we simply install a virtual mapping for it only for the
> -	 * TLB lookup to occur, hence no need to flush the untouched
> -	 * memory mapping afterwards (note: a cache flush may happen
> -	 * in some circumstances depending on the path taken in kunmap_atomic).
> -	 */
> -	void *vaddr = kmap_atomic_pfn(paddr >> PAGE_SHIFT);
> -	return (unsigned long)vaddr + (paddr & ~PAGE_MASK);
> -#else
> -	return __phys_to_virt(paddr);
> -#endif
> -}
> -
> -static inline void l2_put_va(unsigned long vaddr)
> -{
> -#ifdef CONFIG_HIGHMEM
> -	kunmap_atomic((void *)vaddr);
> -#endif
> -}
> -
>  static inline void l2_clean_pa(unsigned long addr)
>  {
>  	__asm__("mcr p15, 1, %0, c15, c9, 3" : : "r" (addr));
> @@ -78,14 +53,13 @@ static inline void l2_clean_pa_range(unsigned long start, unsigned long end)
>  	 */
>  	BUG_ON((start ^ end) >> PAGE_SHIFT);
>
> -	va_start = l2_get_va(start);
> +	va_start = __phys_to_virt(start);
>  	va_end = va_start + (end - start);
>  	raw_local_irq_save(flags);
>  	__asm__("mcr p15, 1, %0, c15, c9, 4\n\t"
>  		"mcr p15, 1, %1, c15, c9, 5"
>  		: : "r" (va_start), "r" (va_end));
>  	raw_local_irq_restore(flags);
> -	l2_put_va(va_start);
>  }
>
>  static inline void l2_clean_inv_pa(unsigned long addr)
> @@ -109,14 +83,13 @@ static inline void l2_inv_pa_range(unsigned long start, unsigned long end)
>  	 */
>  	BUG_ON((start ^ end) >> PAGE_SHIFT);
>
> -	va_start = l2_get_va(start);
> +	va_start = __phys_to_virt(start);
>  	va_end = va_start + (end - start);
>  	raw_local_irq_save(flags);
>  	__asm__("mcr p15, 1, %0, c15, c11, 4\n\t"
>  		"mcr p15, 1, %1, c15, c11, 5"
>  		: : "r" (va_start), "r" (va_end));
>  	raw_local_irq_restore(flags);
> -	l2_put_va(va_start);
>  }
>
>  static inline void l2_inv_all(void)
> diff --git a/arch/arm/mm/cache-xsc3l2.c b/arch/arm/mm/cache-xsc3l2.c
> index d20d7af02d10..477077387039 100644
> --- a/arch/arm/mm/cache-xsc3l2.c
> +++ b/arch/arm/mm/cache-xsc3l2.c
> @@ -5,7 +5,6 @@
>   * Copyright (C) 2007 ARM Limited
>   */
>  #include <linux/init.h>
> -#include <linux/highmem.h>
>  #include <asm/cp15.h>
>  #include <asm/cputype.h>
>  #include <asm/cacheflush.h>
> @@ -55,34 +54,6 @@ static inline void xsc3_l2_inv_all(void)
>  	dsb();
>  }
>
> -static inline void l2_unmap_va(unsigned long va)
> -{
> -#ifdef CONFIG_HIGHMEM
> -	if (va != -1)
> -		kunmap_atomic((void *)va);
> -#endif
> -}
> -
> -static inline unsigned long l2_map_va(unsigned long pa, unsigned long prev_va)
> -{
> -#ifdef CONFIG_HIGHMEM
> -	unsigned long va = prev_va & PAGE_MASK;
> -	unsigned long pa_offset = pa << (32 - PAGE_SHIFT);
> -	if (unlikely(pa_offset < (prev_va << (32 - PAGE_SHIFT)))) {
> -		/*
> -		 * Switching to a new page.  Because cache ops are
> -		 * using virtual addresses only, we must put a mapping
> -		 * in place for it.
> -		 */
> -		l2_unmap_va(prev_va);
> -		va = (unsigned long)kmap_atomic_pfn(pa >> PAGE_SHIFT);
> -	}
> -	return va + (pa_offset >> (32 - PAGE_SHIFT));
> -#else
> -	return __phys_to_virt(pa);
> -#endif
> -}
> -
>  static void xsc3_l2_inv_range(unsigned long start, unsigned long end)
>  {
>  	unsigned long vaddr;
> @@ -92,13 +63,11 @@ static void xsc3_l2_inv_range(unsigned long start, unsigned long end)
>  		return;
>  	}
>
> -	vaddr = -1;  /* to force the first mapping */
> -
>  	/*
>  	 * Clean and invalidate partial first cache line.
>  	 */
>  	if (start & (CACHE_LINE_SIZE - 1)) {
> -		vaddr = l2_map_va(start & ~(CACHE_LINE_SIZE - 1), vaddr);
> +		vaddr = __phys_to_virt(start & ~(CACHE_LINE_SIZE - 1));
>  		xsc3_l2_clean_mva(vaddr);
>  		xsc3_l2_inv_mva(vaddr);
>  		start = (start | (CACHE_LINE_SIZE - 1)) + 1;
> @@ -108,7 +77,7 @@ static void xsc3_l2_inv_range(unsigned long start, unsigned long end)
>  	 * Invalidate all full cache lines between 'start' and 'end'.
>  	 */
>  	while (start < (end & ~(CACHE_LINE_SIZE - 1))) {
> -		vaddr = l2_map_va(start, vaddr);
> +		vaddr = __phys_to_virt(start);
>  		xsc3_l2_inv_mva(vaddr);
>  		start += CACHE_LINE_SIZE;
>  	}
> @@ -117,13 +86,11 @@ static void xsc3_l2_inv_range(unsigned long start, unsigned long end)
>  	 * Clean and invalidate partial last cache line.
>  	 */
>  	if (start < end) {
> -		vaddr = l2_map_va(start, vaddr);
> +		vaddr = __phys_to_virt(start);
>  		xsc3_l2_clean_mva(vaddr);
>  		xsc3_l2_inv_mva(vaddr);
>  	}
>
> -	l2_unmap_va(vaddr);
> -
>  	dsb();
>  }
>
> @@ -135,13 +102,11 @@ static void xsc3_l2_clean_range(unsigned long start, unsigned long end)
>
>  	start &= ~(CACHE_LINE_SIZE - 1);
>  	while (start < end) {
> -		vaddr = l2_map_va(start, vaddr);
> +		vaddr = __phys_to_virt(start);
>  		xsc3_l2_clean_mva(vaddr);
>  		start += CACHE_LINE_SIZE;
>  	}
>
> -	l2_unmap_va(vaddr);
> -
>  	dsb();
>  }
>
> @@ -178,14 +143,12 @@ static void xsc3_l2_flush_range(unsigned long start, unsigned long end)
>
>  	start &= ~(CACHE_LINE_SIZE - 1);
>  	while (start < end) {
> -		vaddr = l2_map_va(start, vaddr);
> +		vaddr = __phys_to_virt(start);
>  		xsc3_l2_clean_mva(vaddr);
>  		xsc3_l2_inv_mva(vaddr);
>  		start += CACHE_LINE_SIZE;
>  	}
>
> -	l2_unmap_va(vaddr);
> -
>  	dsb();
>  }
>
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index fb2eb0ed7bb8..917a546af0b9 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -647,18 +647,10 @@ static void dma_cache_maint_page(phys_addr_t phys, size_t size,
>  			if (len + offset > PAGE_SIZE)
>  				len = PAGE_SIZE - offset;
>
> -			if (cache_is_vipt_nonaliasing()) {
> -				vaddr = kmap_atomic_pfn(pfn);
> +			vaddr = kmap_atomic(phys_to_page(phys));
> +			if (vaddr) {
>  				op(vaddr + offset, len, dir);
>  				kunmap_atomic(vaddr);
> -			} else {
> -				struct page *page = phys_to_page(phys);
> -
> -				vaddr = kmap_high_get(page);
> -				if (vaddr) {
> -					op(vaddr + offset, len, dir);
> -					kunmap_high(page);
> -				}
>  			}
>  		} else {
>  			phys += offset;
> diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
> index 66270904f874..e21c5af6f34c 100644
> --- a/arch/arm/mm/flush.c
> +++ b/arch/arm/mm/flush.c
> @@ -208,21 +208,10 @@ void __flush_dcache_folio(struct address_space *mapping, struct folio *folio)
>  					folio_size(folio));
>  	} else {
>  		unsigned long i;
> -		if (cache_is_vipt_nonaliasing()) {
> -			for (i = 0; i < folio_nr_pages(folio); i++) {
> -				void *addr = kmap_local_folio(folio,
> -								i * PAGE_SIZE);
> -				__cpuc_flush_dcache_area(addr, PAGE_SIZE);
> -				kunmap_local(addr);
> -			}
> -		} else {
> -			for (i = 0; i < folio_nr_pages(folio); i++) {
> -				void *addr = kmap_high_get(folio_page(folio, i));
> -				if (addr) {
> -					__cpuc_flush_dcache_area(addr, PAGE_SIZE);
> -					kunmap_high(folio_page(folio, i));
> -				}
> -			}
> +		for (i = 0; i < folio_nr_pages(folio); i++) {
> +			void *addr = kmap_local_folio(folio, i * PAGE_SIZE);
> +			__cpuc_flush_dcache_area(addr, PAGE_SIZE);
> +			kunmap_local(addr);
>  		}
>  	}
>
> --
> 2.53.0
>

--
Cheers, Lorenzo

