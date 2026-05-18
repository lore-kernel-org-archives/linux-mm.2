Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 768A5CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:43:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B412D6B0088; Mon, 18 May 2026 02:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA4786B008C; Mon, 18 May 2026 02:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B9706B0092; Mon, 18 May 2026 02:43:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8CEEF6B0088
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:43:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 330819117D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:43:13 +0000 (UTC)
X-FDA: 84779598666.22.F703ED5
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	by imf18.hostedemail.com (Postfix) with ESMTP id A80C71C0009
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:43:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=i31chAN0;
	spf=pass (imf18.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779086591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1uMcYsnAueAHkyj/kIiT/h0LeS9UcsyZLDsT8MbHGj8=;
	b=IlU6nZmRKtf40lUPvToynBkZadxl0OHYYN7e2AW2VA/UxQsIhNzePM3mMaOnGGsmeIrxGf
	MJ/+mfhuz9iWGses/laHT6wVA5tirWKa2+VbKhqjy8OJ8NP1sAmdDtuTFUo6F6jW72WU5i
	FjfiMDh+9eRbowGJ7ZL6cQ9Sx76DAk8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=i31chAN0;
	spf=pass (imf18.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779086591; a=rsa-sha256;
	cv=none;
	b=7DugQLkp+HR4kfd9jb5tKbTF71iApCyR7y+QUUuSYAPjJZmsNIaQ3VB5AYUIo4KhcFwvPy
	u32jLx5qnsY80vvM0RkJFLmAI6J/KXuDMSuXNKUWdaBVzrQUQQGx5kEfiRCPwGTTzuLV9m
	xW1VzClnv1RgMPgKohNtME5j1H+Kb+A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779086585; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=1uMcYsnAueAHkyj/kIiT/h0LeS9UcsyZLDsT8MbHGj8=;
 b=i31chAN0GyoPD2c1Kth03fWJlYhxYzuxWjKdSaNLhSSe2EeWQizP6N7LRNux26I8E4mJMn
 yAHpD31l8GIju2KkGFMjxu2Is9DmBSsZ3A6d/dJ36KVjafrqpe8dQx229joHWhPb2Sw0UN
 0pRTjdeWi7ZN5Fp8UgmsQ8LukTgM2KPQQqlrZeVu5JEm+iSyKiICpUJkwFGji8PKFakKA3
 cO2VJYVpOmpHlLVlatgguIwfO1QTAfeuOsUr9eXLwh9oBwhFYRGT1Q4EV2n9x/W9beKMZh
 l/0aZNlFIbHkrA6iegTC22LBE1qb0BL9NXy8d0t/e4ADWb3zVdHQU+BdfL1UgA==
References: <agpaXHqh1gJE_xcQ@nvdebian.thelocal>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a0ab4f7+064869+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <agpaXHqh1gJE_xcQ@nvdebian.thelocal>
Cc: <akpm@linux-foundation.org>, <arnd@arndb.de>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>, <x86@kernel.org>
Message-Id: <20260518064242.57313-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
To: <apopple@nvidia.com>
Date: Mon, 18 May 2026 14:42:42 +0800
Mime-Version: 1.0
Subject: Re: [PATCH 4/4] mm: use arch store helpers in zone-device template copies
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Queue-Id: A80C71C0009
X-Rspamd-Server: rspam06
X-Stat-Signature: 5ud3cazxohgg58xaziugxfpr3xi9ro61
X-HE-Tag: 1779086590-100911
X-HE-Meta: U2FsdGVkX18Sp3e137zjNmDP6AqfKHzOuQW5742z1XyufWr6/kS/VXsbRe2tNUks0lxGVIzI6cFXQiqYgiZKk0oHQlZM2f2E54HFFg+LGbSTwN4MrvVF8XNeR4c4k/loGbFzmJNb5/Wf0VuBa5toxrcQGOVN4SKK/lireeASVQxNThpXoaZAyNCXbCKGP1CuNWb3OQpuwL3Rn4iN2GtXaSuhZ+HevsYaVf0WMqlIQ8RmavajL+PVaC8dXvIPYd2q3SVZlXthiQU4GNpEFKWcKSfUydEth7FxLbs0ElpU03RtoluYcf1zYBC3oZalLgHnPDPwBkLSkVrpFvjpKTaexWksTi5glyLIWcjQ95uCfOI8C/YbWqPCVg2WERKR3IA6PCnLrvW9Xi/Hb/lSFz9mzYG40pM+nPsMu3nuhM8vTWhqBf538GPyeCkTRPJDBh1c7H3vhFc2vFlGP0stDTc4NKYClb7p87B9e+DoANkTefDqjHtUG8f1lXPPJ1XBR0AVvtgctYkUNnc8zcdbJjQWFg7iqpDcpaeuB4XAty6z9SGKiOD8lXmQS+oZNPwj+Wk5EcaLKWLFwu+ZMmjqMtR9c1gWkUjfyP2skz0HWrkFbU/35F2zCvYAy58SJMtXKHGtPG1nXhJKvOto0onsiCeVQkvs2OR7x3yd0yze8Hyz18+a78nd+ASo03oxXcDSsaJs0nQxde6xrYHtA21pSNbGzlae3YR4AimzAHcYAXfEADR25Exp+GeCPhreRoA9YUhKtPE+lEbkAE+sucZK+Wy8zp3tA31gH/kVcnAtUqHRlLgRVS6MN6cTuz0sXtD0nQAyeYLdlHXnDKHcDNzPheRiStrf3y3vM5uNnW30wR1KkzJGbrGWv9sJ4h/lEQVdl3hl2d9GabRJkP5md51bkeVpmQ3JH94yWSdVUaFRR+si3AHnCK6Q6wVRedLJG80dk0HtUTuzu09roH4HCBpI+Nx
 f0sI5i8/
 q9Wb6XtCJbqnbPBTuASvblhCUOmQCbkLXHsEJbn+keLGF6dGN4gEyf7uvQfWKfTuOvnNMPRXOdcDKgkVd9ua1tKNjD8EqKoAVat/cs36Bvx+PSmU5Bs14eW1bLqjVNcPgZq1a+Tcir3p1yr+gyRG11pJTVXnUzHHQarb483vGfMCtze12llGDKjYadWvcdtSbpvyRej0wjia7H5eIlFEDfl218P2p1ExsfyN6kKWRaL9MMnIqRBTRrR6TXHdbk8vXIjrNRND2aeDKkuM9fUrK9Geo7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 10:32:03 +1000, apopple@nvidia.com wrote:

> On 2026-05-15 at 18:20 +1000, Li Zhe <lizhe.67@bytedance.com> wrote...
> > The template-based fast path still leaves the actual copy sequence up to
> > the compiler. On x86-64 that can easily degrade back into a runtime copy
> > loop in the hot path, which leaves performance on the table.
> >
> > Introduce arch_optimize_store_u64() and arch_optimize_store_drain(),
> > with a generic fallback and an x86-64 MOVNTI/SFENCE implementation, and
> > use them in the template copy path. Also open-code the word-at-a-time
> > copy so the compiler emits fixed-offset stores for the hot path instead
> > of a runtime loop.
> >
> > On x86-64, MOVNTI is a better fit for this write-once, streaming
> > initialization pattern than normal cached stores. It reduces the
> > write-allocate traffic and cache pollution that a regular store sequence
> > would otherwise generate while filling large ranges of struct page.
> 
> The perf improvement looks good so thanks for looking at this, however open
> coding this and introducing arch-specific code layout into a generic layer is
> not the right approach. The correct solution would be to implement a memcpy
> implementation/variant that is optimised for write-once streaming operations
> that can transparently degrade to memcpy on unoptimised architectures.
> 
> A grep of the kernel sources for movnti shows there is a memcpy_flushcache()
> variant. Maybe that could work here?

Thank you for pointing this out. Using memcpy_flushcache is indeed a
more generic approach. I will implement the fix in the v2 revision.

I found that memcpy_flushcache() is implemented on multiple architectures,
although not all of them can achieve performance benefits during
ZONE_DEVICE memmap initialization from it. For example, the arm64
implementation of memcpy_flushcache() simply uses memcpy in conjunction
with dcache_clean_pop. Therefore, I believe it would be a reasonable choice
on x86 to introduce a new memcpy variant that invokes memcpy_flushcache().

> > Refresh the PFN-dependent section bits and page->virtual state in the
> > reusable template before each copy, instead of patching the destination
> > page afterwards. This keeps the hot path as a fixed-offset store
> > sequence and avoids post-copy normal stores to cachelines that were
> > just written with non-temporal stores.
> >
> > Because non-temporal stores are not ordered against later normal stores,
> > drain outstanding stores before memmap_init_compound() updates compound
> > heads and before memmap_init_zone_device() returns.
> >
> > Disable the x86-64 override under KASAN or KMSAN so those builds keep
> > their instrumented stores through the generic fallback.
> >
> > Tested in a VM with a 100 GB fsdax namespace device configured with
> > map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
> > server.
> >
> > Test procedure:
> > Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
> > initialization time from the pr_debug() output of
> > memmap_init_zone_device().
> >
> > Base(v7.1-rc3):
> >   First binding for nd_pmem driver: 1486 ms
> >   Average of subsequent rebinds: 273.52 ms
> >
> >   First binding for dax_pmem driver: 1515 ms
> >   Average of subsequent rebinds: 313.45 ms
> >
> > With this patch:
> >   First binding for nd_pmem driver: 1272 ms
> >   Average of subsequent rebinds: 104.59 ms
> >
> >   First binding for dax_pmem driver: 1286 ms
> >   Average of subsequent rebinds: 116.93 ms
> >
> 
> > This reduces the average rebind time by about 61.8% for nd_pmem and
> > 62.7% for dax_pmem.
> 
> Nice - is this the improvment from applying the whole patch series or just this
> change?

These performance improvements are attributable to the entire patch series.
Maybe It would be clearer to use "With this series" instead of the above
"With this patch".

> 
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > ---
> >  arch/x86/include/asm/struct_page_init.h | 28 ++++++++
> >  include/asm-generic/Kbuild              |  1 +
> >  include/asm-generic/struct_page_init.h  | 17 +++++
> >  mm/mm_init.c                            | 89 +++++++++++++++++++++----
> >  4 files changed, 122 insertions(+), 13 deletions(-)
> >  create mode 100644 arch/x86/include/asm/struct_page_init.h
> >  create mode 100644 include/asm-generic/struct_page_init.h
> >
> > diff --git a/arch/x86/include/asm/struct_page_init.h b/arch/x86/include/asm/struct_page_init.h
> > new file mode 100644
> > index 000000000000..de8b4eab44de
> > --- /dev/null
> > +++ b/arch/x86/include/asm/struct_page_init.h
> > @@ -0,0 +1,28 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_X86_STRUCT_PAGE_INIT_H
> > +#define _ASM_X86_STRUCT_PAGE_INIT_H
> > +
> > +#include <linux/compiler.h>
> > +#include <linux/types.h>
> > +
> > +/*
> > + * x86-64 guarantees SSE2, so MOVNTI and SFENCE are always available there.
> > + *
> > + * KASAN/KMSAN rely on compiler-instrumented stores. Keep the x86 override
> > + * disabled for those configs and fall back to plain stores instead.
> > + */
> > +#if defined(CONFIG_X86_64) && !defined(CONFIG_KASAN) && !defined(CONFIG_KMSAN)
> > +static __always_inline void arch_optimize_store_u64(u64 *dst, u64 val)
> > +{
> > +	asm volatile("movnti %1, %0" : "=m"(*dst) : "r"(val));
> > +}
> > +
> > +static __always_inline void arch_optimize_store_drain(void)
> > +{
> > +	asm volatile("sfence" : : : "memory");
> > +}
> > +#else
> > +#include <asm-generic/struct_page_init.h>
> > +#endif
> > +
> > +#endif /* _ASM_X86_STRUCT_PAGE_INIT_H */
> > diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
> > index 2c53a1e0b760..3a493fed6803 100644
> > --- a/include/asm-generic/Kbuild
> > +++ b/include/asm-generic/Kbuild
> > @@ -65,3 +65,4 @@ mandatory-y += vermagic.h
> >  mandatory-y += vga.h
> >  mandatory-y += video.h
> >  mandatory-y += word-at-a-time.h
> > +mandatory-y += struct_page_init.h
> > diff --git a/include/asm-generic/struct_page_init.h b/include/asm-generic/struct_page_init.h
> > new file mode 100644
> > index 000000000000..45a722103a51
> > --- /dev/null
> > +++ b/include/asm-generic/struct_page_init.h
> > @@ -0,0 +1,17 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_GENERIC_STRUCT_PAGE_INIT_H
> > +#define _ASM_GENERIC_STRUCT_PAGE_INIT_H
> > +
> > +#include <linux/compiler.h>
> > +#include <linux/types.h>
> > +
> > +static __always_inline void arch_optimize_store_u64(u64 *dst, u64 val)
> > +{
> > +	*dst = val;
> > +}
> > +
> > +static __always_inline void arch_optimize_store_drain(void)
> > +{
> > +}
> > +
> > +#endif /* _ASM_GENERIC_STRUCT_PAGE_INIT_H */
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index 5a9e6ecfa894..a3211666ccd4 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -37,6 +37,7 @@
> >  #include "shuffle.h"
> >
> >  #include <asm/setup.h>
> > +#include <asm/struct_page_init.h>
> >
> >  #ifndef CONFIG_NUMA
> >  unsigned long max_mapnr;
> > @@ -1078,9 +1079,21 @@ static inline bool zone_device_page_init_optimization_enabled(void)
> >  	return !page_ref_tracepoint_active(page_ref_set);
> >  }
> >
> > +/*
> > + * The fast path copies struct page with fixed-offset u64 stores instead of
> > + * a runtime loop. Keep that copy sequence in sync with the struct page
> > + * layouts supported by this build.
> > + *
> > + * The sequence below requires struct page to be u64-aligned and currently
> > + * handles layouts from 7 to 12 u64 words (56 to 96 bytes). If a future
> > + * layout falls outside that range, fail the build so the store sequence is
> > + * updated together with the layout change.
> > + */
> >  static inline void struct_page_layout_check(void)
> >  {
> >  	BUILD_BUG_ON(sizeof(struct page) & (sizeof(u64) - 1));
> > +	BUILD_BUG_ON(sizeof(struct page) < 56);
> > +	BUILD_BUG_ON(sizeof(struct page) > 96);
> 
> This would be uneccessary without the open-coded memcpy and is another reason to
> prefer a more generic approach.

Yes, I will fix this issue in v2.

> >  }
> >
> >  static inline void init_template_head_page(struct page *template,
> > @@ -1108,30 +1121,67 @@ static inline void init_template_tail_page(struct page *template,
> >  }
> >
> >  /*
> > - * Initialize parts that differ from the template
> > + * 'template' is a reusable page prototype rather than a strictly immutable
> > + * object. Most ZONE_DEVICE fields stay constant across the pages covered by
> > + * the current template, but section bits and page->virtual may still depend
> > + * on the PFN. Refresh those PFN-dependent fields in the template before
> > + * copying it into @page.
> >   */
> > -static inline void generic_init_zone_device_page_finish(struct page *page,
> > -							unsigned long pfn)
> > +static inline void zone_device_page_update_template(struct page *template,
> > +						    unsigned long pfn)
> >  {
> >  #ifdef SECTION_IN_PAGE_FLAGS
> > -	set_page_section(page, pfn_to_section_nr(pfn));
> > +	set_page_section(template, pfn_to_section_nr(pfn));
> >  #endif
> >  #ifdef WANT_PAGE_VIRTUAL
> >  	if (!is_highmem_idx(ZONE_DEVICE))
> > -		set_page_address(page, __va(pfn << PAGE_SHIFT));
> > +		set_page_address(template, __va(pfn << PAGE_SHIFT));
> >  #endif
> >  }
> >
> >  static void init_zone_device_page_from_template(struct page *page,
> > -		unsigned long pfn, const struct page *template)
> > +		unsigned long pfn, struct page *template)
> >  {
> >  	const u64 *src = (const u64 *)template;
> >  	u64 *dst = (u64 *)page;
> > -	unsigned int i;
> >
> > -	for (i = 0; i < sizeof(struct page) / sizeof(u64); i++)
> > -		dst[i] = src[i];
> > -	generic_init_zone_device_page_finish(page, pfn);
> > +	/*
> > +	 * 'template' carries the invariant portion of a ZONE_DEVICE struct
> > +	 * page. Update the PFN-dependent fields in place before copying it
> > +	 * to the destination page.
> > +	 */
> > +	zone_device_page_update_template(template, pfn);
> > +
> > +	/*
> > +	 * Keep the copy open-coded so the compiler emits fixed-offset stores
> > +	 * for the hot path instead of a runtime copy loop.
> > +	 */
> > +	switch (sizeof(struct page)) {
> > +	case 96:
> > +		arch_optimize_store_u64(&dst[11], src[11]);
> > +		fallthrough;
> > +	case 88:
> > +		arch_optimize_store_u64(&dst[10], src[10]);
> > +		fallthrough;
> > +	case 80:
> > +		arch_optimize_store_u64(&dst[9], src[9]);
> > +		fallthrough;
> > +	case 72:
> > +		arch_optimize_store_u64(&dst[8], src[8]);
> > +		fallthrough;
> > +	case 64:
> > +		arch_optimize_store_u64(&dst[7], src[7]);
> > +		fallthrough;
> > +	case 56:
> > +		arch_optimize_store_u64(&dst[6], src[6]);
> > +		arch_optimize_store_u64(&dst[5], src[5]);
> > +		arch_optimize_store_u64(&dst[4], src[4]);
> > +		arch_optimize_store_u64(&dst[3], src[3]);
> > +		arch_optimize_store_u64(&dst[2], src[2]);
> > +		arch_optimize_store_u64(&dst[1], src[1]);
> > +		arch_optimize_store_u64(&dst[0], src[0]);
> > +	}
> > +
> 
> I don't think unrolling the copy here is the right approach. This belongs in
> some kind of generic streaming memcpy routine.

Yes. I've taken a look at the memcpy_flushcache() implementation on x86,
and it only unrolls for sizes of 4, 8, and 16 bytes; all other sizes fall
back to the generic loop. I think we need to extend the x86 implementation
of memcpy_flushcache() so that its fast path covers at least
sizeof(struct page).

Thanks,
Zhe

