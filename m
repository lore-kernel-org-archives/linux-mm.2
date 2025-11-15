Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C466CEB2C7
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 09:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668358E0009; Sat, 15 Nov 2025 04:37:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617FC8E0005; Sat, 15 Nov 2025 04:37:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5070D8E0009; Sat, 15 Nov 2025 04:37:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 29F068E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 04:37:14 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C87C14DA21
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 09:37:13 +0000 (UTC)
X-FDA: 84112337946.29.1EA3984
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf04.hostedemail.com (Postfix) with ESMTP id 75CE340005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 09:37:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763199431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KRSbS6BXI4D/KBq+34SOTawVeX+U6PfIE+nE+9GQxW8=;
	b=tOzUEynO5FnxcguoQTDyxVSv1iu48pnRUle9gG2opqQ5JP3CXeBg7fHTYZpJzPmBzYlOAY
	JRjY5v0zjPc++8xWpZK5ygkqa9nY1cMs1lJvYj/QmsAA0ZihFHBCXWg+xKlBVwGtD2q2Rb
	Xt8MazOhoWRzBqzQ/l7tgwsFXLPafXM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763199431; a=rsa-sha256;
	cv=none;
	b=NZiTB3m5pGyLZ1vdIiNVWyn8/0FeEzotpfzaAKrqr88FF7ghg0LqY9bygV5VrnSbtE1hUU
	rtpuCXx2O+/IGPh2lkM34i2GxgQQCs16HLBjPZx9H6reKyC5kPaJytEqTq+k88vZV2/W4K
	DZwBt/bUwC7DbqK9juSI+3J4LDsxbKI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4d7pnJ3RdWz9sSf;
	Sat, 15 Nov 2025 10:37:08 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rSndbvcbPBGm; Sat, 15 Nov 2025 10:37:08 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4d7pnJ26rnz9sSY;
	Sat, 15 Nov 2025 10:37:08 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 2AFF08B770;
	Sat, 15 Nov 2025 10:37:08 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id 8AuJ7JBTv9yp; Sat, 15 Nov 2025 10:37:08 +0100 (CET)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 3D45F8B76E;
	Sat, 15 Nov 2025 10:37:07 +0100 (CET)
Message-ID: <fb95d369-dda3-47a9-b294-6d5038cee4d4@csgroup.eu>
Date: Sat, 15 Nov 2025 10:37:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
 Sourabh Jain <sourabhjain@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Donet Tom
 <donettom@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nathan Chancellor <nathan@kernel.org>
References: <20251114214920.2550676-1-david@kernel.org>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <20251114214920.2550676-1-david@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 61bqkwmyza7oexq3f8dfbzx7eh81uq3q
X-Rspam-User: 
X-Rspamd-Queue-Id: 75CE340005
X-Rspamd-Server: rspam01
X-HE-Tag: 1763199431-159575
X-HE-Meta: U2FsdGVkX19O1sMCaAKS9FkOBUKfaNjaAvisGmUPSxMyuqYcbOERVKRXNr8He6wNQIggKdVL7M2UVJO0a+O+McEtJkKw6tt1+tp9ElNZ7yLq+YygUQ0qRj3D3YSDaLkW+gO1P3NdiIFu84ZeCRSOvNprlrvZEfKDHqZd/HyWCreNLLf/k2Ky4FDsdVLUG2KdW9FPM+u8L/GpazX2cJ6zCa68ZvXMPd6nQbrwu6N5SdnuCmv0N722A5syxHcrMOBApWXvMNDzqGiz0Z2CbI2CeYosNBbPcBI1Pzb1ZcZE/nY1tyVwk4uuKn/NYL1N6vMMxm9kRwgtaXbwjNEF4MhnRmebsLLzXeAn3YxDuT8S+RPiTUt9oiJKwyHrCK/zyXIP/23QQreLW4uop/gVy5yMxijsF/O1W0Od9V3Gg1owMA7Pe0Fo/ZEDdROTeGJ6dAakEja0SKYim9HRE1B0dvHln+otbIp8JY2ys/hpknmoUS4BZ1xBzC/MMNPACeAN1iVP1UEB86DuynCplA+F+cxO3vnnFaVBV+6riWPMIAMwHTjCLljQMv7HWj2UVMrbg9zqtO4/E1IWeeSvbPeEF3rL8dftbvUJyispQrNWqdT7T7rPMRn7/T5PJ4O6spjwBlJhywVOu2tTREc0YuxMsjtHcHwDE4WypP+LQ5PtXJsSFl/1Ox9LHDXebE89nLP/fK2XZMqLcTdvUYJaP5De0Rdb3jp36PAF3wewVASCDgxR2jsvHzdj5hpCjr7F4b+7EsufyhLfAwAq+/BYbYIDjeiTsNursdw20TxLEOzCyHEr7qTDCRzP5VsxROnBjYCXsKhYI2veaL4fm6A4AEv+MtaTY88gLxsKidRiFilNVlONBRXwRp1c8yPZthRTJ1j/SWWxozyACUgqjGaDdOWdJV678mhQJjNmu525LYLVB29LxBP/NSohAoFYJMyvOCwgBD8iw/kDkBk8OUNXvfFTJA5
 HmbxH9+q
 EWoN2RW+Lae+906Om355DHXwcQX2oNVg1autg3dXeCgi0Uv0638uZ59rb4/yx561bM92MIqrYfSlVhRhamLpz+xVMTIMVWZZmHs/BsHNUmT4qwzV8TDl/YPuXDmFwOtV4ctCc6qGjIvpe7ZNLFhMCVGbyiGE+XCfllpSA+8Q+ez1AXLUq0yWX5WuKi1W9HWvQ27Clc6xUgByKgq7/Z+SyXlaGhhB1t/rJDhOz+APrfXuSaYDkoGdAlhoHNyCvbubMBaROnH0m2Fhp5eaZhx8R9msSGK765BAvEGXXvr7Dlk/EvFH7DN3XjIEjhKWksRkxB93DP7o4oi6Ddv4TMKpjE0D4/CtYvRq+52D74aS2jZcqOyeCDVpy95elJ6whMg1AUjk4DAHmUwNIVA37LS3CLqItH3ICNlYhnSHQr2HmUS41RWtHWqODunHSoLP+VYCFiTlGk/OJXnlzq3yEqNlBPna5vwcpaSJh0PaOcTrj05HQOHKAA65HYx+4axP9WHhGlHQolmsUM50rsKk88httKNrApDP1lJjsAyoXGxRy6KA7aSy1MqhuT/9Gf6ozyrDWmbh1tFoLkSbInLIJDndo7lYbfBCBZJqIu+tI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 14/11/2025 à 22:49, David Hildenbrand (Red Hat) a écrit :
> In the past, CONFIG_ARCH_HAS_GIGANTIC_PAGE indicated that we support
> runtime allocation of gigantic hugetlb folios. In the meantime it evolved
> into a generic way for the architecture to state that it supports
> gigantic hugetlb folios.
> 
> In commit fae7d834c43c ("mm: add __dump_folio()") we started using
> CONFIG_ARCH_HAS_GIGANTIC_PAGE to decide MAX_FOLIO_ORDER: whether we could
> have folios larger than what the buddy can handle. In the context of
> that commit, we started using MAX_FOLIO_ORDER to detect page corruptions
> when dumping tail pages of folios. Before that commit, we assumed that
> we cannot have folios larger than the highest buddy order, which was
> obviously wrong.
> 
> In commit 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes
> when registering hstate"), we used MAX_FOLIO_ORDER to detect
> inconsistencies, and in fact, we found some now.
> 
> Powerpc allows for configs that can allocate gigantic folio during boot
> (not at runtime), that do not set CONFIG_ARCH_HAS_GIGANTIC_PAGE and can
> exceed PUD_ORDER.
> 
> To fix it, let's make powerpc select CONFIG_ARCH_HAS_GIGANTIC_PAGE with
> hugetlb on powerpc, and increase the maximum folio size with hugetlb to 16
> GiB on 64bit (possible on arm64 and powerpc) and 1 GiB on 32 bit (powerpc).
> Note that on some powerpc configurations, whether we actually have gigantic
> pages depends on the setting of CONFIG_ARCH_FORCE_MAX_ORDER, but there is
> nothing really problematic about setting it unconditionally: we just try to
> keep the value small so we can better detect problems in __dump_folio()
> and inconsistencies around the expected largest folio in the system.
> 
> Ideally, we'd have a better way to obtain the maximum hugetlb folio size
> and detect ourselves whether we really end up with gigantic folios. Let's
> defer bigger changes and fix the warnings first.
> 
> While at it, handle gigantic DAX folios more clearly: DAX can only
> end up creating gigantic folios with HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD.
> 
> Add a new Kconfig option HAVE_GIGANTIC_FOLIOS to make both cases
> clearer. In particular, worry about ARCH_HAS_GIGANTIC_PAGE only with
> HUGETLB_PAGE.
> 
> Note: with enabling CONFIG_ARCH_HAS_GIGANTIC_PAGE on powerpc, we will now
> also allow for runtime allocations of folios in some more powerpc configs.
> I don't think this is a problem, but if it is we could handle it through
> __HAVE_ARCH_GIGANTIC_PAGE_RUNTIME_SUPPORTED.

Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>

Tested on powerpc 8xx with CONFIG_ARCH_FORCE_MAX_ORDER=8 instead of 9.
It is now possible to add hugepages with the following command:

echo 4 > /sys/kernel/mm/hugepages/hugepages-8192kB/nr_hugepages

But only if CONFIG_CMA is set.

Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>

> 
> While __dump_page()/__dump_folio was also problematic (not handling dumping
> of tail pages of such gigantic folios correctly), it doesn't seem
> critical enough to mark it as a fix.
> 
> Fixes: 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes when registering hstate")
> Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Closes: https://lore.kernel.org/r/3e043453-3f27-48ad-b987-cc39f523060a@csgroup.eu/
> Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> Closes: https://lore.kernel.org/r/94377f5c-d4f0-4c0f-b0f6-5bf1cd7305b1@linux.ibm.com/
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Donet Tom <donettom@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---
> 
> v1 -> v2:
> * Adjust patch description (typo, 16G vs 1G)
> * Remove ARCH_HAS_GIGANTIC_PAGE from arch/powerpc/platforms/Kconfig.cputype
> * Mention CONFIG_HAVE_GIGANTIC_FOLIOS in comment
> * Use 1 GiB on 32bit to avoid unsigned-long capacity issues
> 
> I yet have to boot-test this on 32bit powerpc. Something for Monday.
> 
> ---
>   arch/powerpc/Kconfig                   |  1 +
>   arch/powerpc/platforms/Kconfig.cputype |  1 -
>   include/linux/mm.h                     | 13 ++++++++++---
>   mm/Kconfig                             |  7 +++++++
>   4 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index e24f4d88885ae..9537a61ebae02 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -137,6 +137,7 @@ config PPC
>   	select ARCH_HAS_DMA_OPS			if PPC64
>   	select ARCH_HAS_FORTIFY_SOURCE
>   	select ARCH_HAS_GCOV_PROFILE_ALL
> +	select ARCH_HAS_GIGANTIC_PAGE		if ARCH_SUPPORTS_HUGETLBFS
>   	select ARCH_HAS_KCOV
>   	select ARCH_HAS_KERNEL_FPU_SUPPORT	if PPC64 && PPC_FPU
>   	select ARCH_HAS_MEMBARRIER_CALLBACKS
> diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
> index 7b527d18aa5ee..4c321a8ea8965 100644
> --- a/arch/powerpc/platforms/Kconfig.cputype
> +++ b/arch/powerpc/platforms/Kconfig.cputype
> @@ -423,7 +423,6 @@ config PPC_64S_HASH_MMU
>   config PPC_RADIX_MMU
>   	bool "Radix MMU Support"
>   	depends on PPC_BOOK3S_64
> -	select ARCH_HAS_GIGANTIC_PAGE
>   	default y
>   	help
>   	  Enable support for the Power ISA 3.0 Radix style MMU. Currently this
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index d16b33bacc32b..7c79b3369b82c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2074,7 +2074,7 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
>   	return folio_large_nr_pages(folio);
>   }
>   
> -#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
> +#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
>   /*
>    * We don't expect any folios that exceed buddy sizes (and consequently
>    * memory sections).
> @@ -2087,10 +2087,17 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
>    * pages are guaranteed to be contiguous.
>    */
>   #define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
> -#else
> +#elif defined(CONFIG_HUGETLB_PAGE)
>   /*
>    * There is no real limit on the folio size. We limit them to the maximum we
> - * currently expect (e.g., hugetlb, dax).
> + * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
> + * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
> + */
> +#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
> +#else
> +/*
> + * Without hugetlb, gigantic folios that are bigger than a single PUD are
> + * currently impossible.
>    */
>   #define MAX_FOLIO_ORDER		PUD_ORDER
>   #endif
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 0e26f4fc8717b..ca3f146bc7053 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -908,6 +908,13 @@ config PAGE_MAPCOUNT
>   config PGTABLE_HAS_HUGE_LEAVES
>   	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
>   
> +#
> +# We can end up creating gigantic folio.
> +#
> +config HAVE_GIGANTIC_FOLIOS
> +	def_bool (HUGETLB_PAGE && ARCH_HAS_GIGANTIC_PAGE) || \
> +		 (ZONE_DEVICE && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
> +
>   # TODO: Allow to be enabled without THP
>   config ARCH_SUPPORTS_HUGE_PFNMAP
>   	def_bool n
> 
> base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0


