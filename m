Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26A0FC4452D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 08:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9530B6B007B; Wed, 22 Jul 2026 04:18:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903CF6B0088; Wed, 22 Jul 2026 04:18:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81C966B0092; Wed, 22 Jul 2026 04:18:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 518956B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:18:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E27D81C06F3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:18:34 +0000 (UTC)
X-FDA: 85015710948.01.2AB3514
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7C984140005
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:18:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=nfwC7Al0;
	spf=pass (imf26.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784708313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lyQy5e8Yk8Yma8inkohDBWXvAh7NYEWORA2vqInjmDo=;
	b=2Qs82FYtW99ZnNAiVpwIMLBEKeqCxOlhqQTV6XplUl3yeYhWAsLzU9pCoHC25sgSExDjLK
	VEQ0SD7RjMGceUvy3odfrz88CARQ5yKDB8AbR08xKwJfsEUlIUD89heiy/wSsvWud/P8rb
	8V5DZEsofz4Oe9BryLSUlNinclCjpSE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=nfwC7Al0;
	spf=pass (imf26.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784708313;
	b=QVe+6TucBjMiftR95dTPoMmBf+HLYeiOPiPkioW6A1YT8Yyxc9ZGpSm8TgogLcngzQJEX9
	1I2aiiPL9OOpyz8LG8BL3pHzgKh6qW5I08s5u9nlocYaOY6bmNcvUOb0s51dfe/sMS6yP8
	gcjH4TsBz9JZy+A0N+ftTqH92nM2sPw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784708306; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=lyQy5e8Yk8Yma8inkohDBWXvAh7NYEWORA2vqInjmDo=;
 b=nfwC7Al04M6gy3YPgXZuEzUWtjF2HttJkosjXac9v0UOP7hnveiSWqnxAI5taH0Qm+XDmy
 EVVjWWlyvW92NZNJIm1TojBAlMv5zxZHe+4GDXnQy+78IQ6mav2MkR8KBFBgkFLc7K0uG3
 x87CAsY1N8FMlNr8tkO9ohk9sLFL1bPn8ouIcRXFWAhEi0v2uG3+RrVFGIZpX6x38EGmil
 IoGKT/gr+1E+sDmnaM1m1d+rjMjti1KFXcharRn/VFcFUKjam/zxhsArj9WSP5iRdVbjXr
 5jaHYWxdOoK7CVRgXxCeC4OlvYecF+79sE+uyvgmZbiJTBJws4FGLx9RawBRQA==
Cc: <apopple@nvidia.com>, <arnd@arndb.de>, <balbirs@nvidia.com>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <linux-arch@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>, 
	<x86@kernel.org>
Subject: Re: [PATCH v7 0/9] mm: optimize zone-device memmap initialization
References: <20260720154334.b619e7b436d2dc2481b233ea@linux-foundation.org>
In-Reply-To: <20260720154334.b619e7b436d2dc2481b233ea@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a607cd0+e201b6+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>
Date: Wed, 22 Jul 2026 16:18:00 +0800
Message-Id: <20260722081800.90085-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7C984140005
X-Stat-Signature: zzcam5rq7dk8q89gmdomref8fsmrstoa
X-HE-Tag: 1784708312-736821
X-HE-Meta: U2FsdGVkX18dL7CMfGO0V4UqEhok5eoVDhuBmkO3Kf318Jg2TX3PzoVqSa/B3ZC+psyE3nnXOEXgDJ6N+5Nspe/Ne/0bL6zlHpyC7DCAldIVRke0/vbBtQCwknRZve/dfDkTg7pibSN3B49hA1ZGx8eg/DVlRoZaagh5z099TCqYk94Dh08pk+MPVvku6nXjZ37Bp7hcoKz9JrmWJaAiINBVnPA5C8Dm1eEyvgvoUNJ0Go04MczMRdRxEjwcMUI5unI2WE/fT9g0Qq6gC7cAKijHmOqjDm8APa+WEll0xDQYiBuSnFSxTJAICVVtQAaHBmKu2i0EDyo5/PxQJJj6sthiDnb1d5dc1wDznTJGjCCE4hduBhnJCcOK9oohu1tZ4pSnlg6i73QTb/cS33iPHJpMUe2sNHrr+2zuMlQnkV7732FSfTi/VT1cMlKSNDQgQQBpViwTO6FMm8JkydElQGZdm/F9NwHkk8k/0J+5HUCnh+7/EQEbZyY60cWnVdKoZY3u0m7V76TrjOWK3BHlDYk2Wl8Qos9dJ29jsbKu+bBg/+ADsZk0rKC/hxS1mjXTEwyHr+VlhnNl9jSVuu2USAfBlP99Ta+gAtjYZM0ggeA1TrCtbp826FukiK5hDjdAd/wEA+o11+e3UElQKoTq6gB7jrLTcO+5tpdmhSalR2RBlBID2O3GA1322SabCtQ4wIJB8KFzbyrhH/R3ZxRwnvuSwpxGno5vUZlU6q/UNiZE52CTSeA5ke3CExCO2e09Mw3dFtDswC959n1b8TpPRjutxGWk/ZBko0ptFUqXbMmIQ0+11Z6TxlE4HoRnyH3nWoW3Wp6kJKx71MEU0KYMAs71xFPWDJuI8DyKbD4qS2LeWZhZNY7Asbt0fFrRuxM+1KhwewhryP4X/ruezVhc9vNOIdQPtRZgtCmbQ8+2BvUGPFAnE4N2KBJ3QUjc/pwg5dcRX20qFiKsIOXQwAg
 f9Yxbdhf
 +nGkghEUqWkyYaz8sLbYYiKcD4qbU+q48tXNkZDGSsHzDuv5nlN8Aay706ehP08da29iLB9O9+peQXb3oVaAWMbzEdybWlZ0w1mnYTD0kbwy8nRaGXtj4PpobsAR1UWavgpfDUg0WRTQhV6pkKy+5auTU3bIvNa+46wz9qHBSUZkKz1wMabhybSzwPnYqL+QVeFOQI0LBhWR66GefOfXCDWmpTiR/SZIe7bxyxo+9qSHU2gcBkt4vYFXXlTCFoEz/E4tmVeLIUWu7zMFeFJwPCzHQ08Myain/Bwu0IYS75k+D2Cl9M9qZIK1yGM/ceR7y8pddmRQ8WP9B6O0GO3YEhS3eKLN6+evFqfvfvkkMHZX4PSZ9GK8ac//BU2t5Uq1adSFj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 15:43:34 -0700, akpm@linux-foundation.org wrote:

> AI review might have found some things, one "critical":
> 	https://sashiko.dev/#/patchset/20260720120259.1545-1-lizhe.67@bytedance.com
> 
> --- Patch [6]: [PATCH v7 6/9] string: introduce memcpy_nontemporal() ---
> commit 48cf815dd31950a95bb4752e1e8e62594a090364
> Author: Li Zhe <lizhe.67@bytedance.com>
> string: introduce memcpy_nontemporal()
> Introduce memcpy_nontemporal() for write-once copy sites that want a
> named non-temporal copy primitive.
> > diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
> > index 4635616863f53..21ae515ae35a3 100644
> > --- a/arch/x86/include/asm/string_64.h
> > +++ b/arch/x86/include/asm/string_64.h
> > @@ -100,6 +100,18 @@ static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t
> >  	}
> >  	__memcpy_flushcache(dst, src, cnt);
> >  }
> > +
> > +#define memcpy_nontemporal memcpy_nontemporal
> > +/*
> > + * Reuse the existing x86 flushcache backend as the non-temporal copy
> > + * primitive.
> > + */
> > +static __always_inline void memcpy_nontemporal(void *dst, const void *src,
> > +		size_t cnt)
> > +{
> > +	memcpy_flushcache(dst, src, cnt);
> > +}
> Does this missing fencing introduce a memory ordering hazard on x86_64?
> Because memcpy_flushcache() uses weakly-ordered movnti instructions, it
> bypasses the x86 Total Store Order (TSO) guarantees. If generic code
> follows memcpy_nontemporal() with smp_store_release() or smp_wmb(), it
> could result in data corruption since those standard SMP barriers only
> compile to compiler barriers on x86_64.
> Is there a plan to add a built-in sfence here, or update the
> documentation to warn callers that wmb() is strictly required?

On x86 it intentionally follows the existing memcpy_flushcache() style:
it performs the non-temporal copy, but it does not imply a drain or a
publication barrier.

Callers that use memcpy_nontemporal() as part of a producer-consumer or
device-visible handoff must add the required ordering at the handoff
point. On x86, that means a real write barrier such as wmb() or pmem_wmb();
smp_wmb() and smp_store_release() are not sufficient for ordering
non-temporal stores before such a handoff.

This patchset does not need such a drain in the ZONE_DEVICE template-copy
path. The copy is followed by more local struct page initialization on
the same CPU, not by a publication store to another CPU or device.

> Will this bypass KASAN memory safety instrumentation and FORTIFY_SOURCE
> bounds checking on x86_64?
> The inline wrapper doesn't use __FORTIFY_INLINE, and calling
> memcpy_flushcache() directly skips the usual kasan_check_write() and
> kasan_check_read() protections that the generic memcpy macro preserves.

On x86, memcpy_nontemporal() is only a thin wrapper around the existing
memcpy_flushcache() backend. I would prefer to keep the wrapper at that
level and not add a separate FORTIFY_SOURCE layer here, since the backend
it wraps does not provide one either.

For this series, bypassing KASAN/KMSAN instrumentation in the final
ZONE_DEVICE template-copy path is expected and is called out in the final
cleanup patch.

> 
> > diff --git a/include/linux/string.h b/include/linux/string.h
> > index 5702daca4326b..9815c08867d72 100644
> > --- a/include/linux/string.h
> > +++ b/include/linux/string.h
> [ ... ]
> > @@ -278,6 +278,18 @@ static inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
> >  }
> >  #endif
> >  
> > +#ifndef memcpy_nontemporal
> > +/*
> > + * memcpy_nontemporal() requests a non-temporal copy when the
> > + * architecture has a suitable backend. Architectures without a
> > + * specialized backend fall back to memcpy(). Keep this as a macro alias
> > + * so the compiler can still see the original memcpy() call site and
> > + * preserve the usual FORTIFY coverage when object sizes remain visible
> > + * there.
> > + */
> > +#define memcpy_nontemporal memcpy
> > +#endif
> Could this macro definition cause build failures due to a return type
> mismatch across architectures?
> The generic fallback here aliases to memcpy, which implicitly returns
> void *, while the x86_64 backend explicitly returns void. If a caller
> attempts to use the return value on x86_64, the build will fail with a
> void value error, whereas it will compile cleanly on fallback
> architectures.
> Should this macro cast the result to void to enforce a uniform API?
> For example: #define memcpy_nontemporal(d, s, l) ((void)memcpy(d, s, l))

Agreed. The return value should not be part of the memcpy_nontemporal()
API. I will make the generic fallback a void function-like macro. This
keeps the API consistent with memcpy_flushcache(), which also returns
void, and makes accidental use of a return value fail consistently
across architectures.

> --- Patch [7]: [PATCH v7 7/9] x86/string: extend memcpy_flushcache() fixed-size fastpaths ---
> commit 882d29aec39f30f4e6b01548ec298e08ca1ab787
> Author: Li Zhe <lizhe.67@bytedance.com>
> x86/string: extend memcpy_flushcache() fixed-size fastpaths
> This commit adds larger fixed-size fast paths (32 to 96 bytes) to
> memcpy_flushcache() using inline movnti helpers. It also explicitly removes
> the 8-byte destination alignment check for these sizes based on microbenchmark
> results showing improved performance for unaligned copies.
> > diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
> > --- a/arch/x86/include/asm/string_64.h
> > +++ b/arch/x86/include/asm/string_64.h
> [ ... ]
> > +static __always_inline void movnti_8(void *dst, const void *src)
> > +{
> > +	asm volatile("movntiq %1, %0"
> > +		     : "=m"(*(u64 *)dst)
> > +		     : "r"(*(const u64 *)src)
> Does casting an unaligned void pointer to a strictly-aligned u64 pointer and
> dereferencing it invoke undefined behavior here?
> Since this fast path handles unaligned addresses, the compiler might assume the
> memory operand is naturally 8-byte aligned based on the u64 type. Could this
> allow the compiler to incorrectly optimize away subsequent alignment checks or
> emit invalid aligned optimizations?

I do not see an 8-byte alignment requirement for MOVNTI in the Intel SDM.
This also matches the existing memcpy_flushcache() fixed-size cases: the
8-byte and 16-byte cases already use MOVNTI without a separate alignment
check.

So I do not think this series needs to add an alignment fallback for the
new 32/48/64/80/96-byte fixed-size cases. Please correct me if I am wrong.

> > +		     : "memory");
> Is this global "memory" clobber necessary given the specific "=m" output
> constraint?
> When this helper is nested to create larger copies like movnti_64(), it
> generates up to 8 consecutive full compiler memory barriers. Does this force
> the compiler to unnecessarily spill and reload locally cached variables from
> registers, preventing instruction scheduling across each 8-byte chunk?

The "memory" clobber is intentional here. The goal is to keep the
fixed-size copy as a compact sequence of MOVNTI stores and avoid the
compiler moving other memory accesses into the middle of that streaming
store sequence. The "=m" operand describes the destination memory
operand, but it does not express that broader scheduling constraint.

The largest fixed-size copy added by this patch is still small, and the
measured result for the final memcpy_flushcache() path is still favorable
for the ZONE_DEVICE struct page copies that motivated this series. So I
would prefer to keep the conservative clobber in this version unless
there is a demonstrated code generation or performance regression from
it. Please correct me if I am wrong.

> > +}
> [ ... ]
> > +static __always_inline void memcpy_flushcache(void *dst, const void *src,
> > +					      size_t cnt)
> >  {
> [ ... ]
> > +			case 32:
> > +				movnti_32(dst, src);
> > +				return;
> Does skipping the 8-byte alignment check here break the cache bypass guarantee
> required for persistent memory (PMEM) durability?
> The memcpy_flushcache() API guarantees that written data bypasses the CPU cache
> so PMEM updates are durable without requiring manual clflush. On x86, unaligned
> non-temporal stores (MOVNTI) crossing cache lines silently fall back to
> temporal Read-For-Ownership cache allocations.
> Because this inline fast path bypasses __memcpy_flushcache() (which correctly
> aligns the destination using normal memcpy and clflushopt), will the unaligned
> data silently sit in the CPU L1/L2 cache instead of reaching the PMEM module?
> Is it possible that the microbenchmark speedup mentioned in the commit message
> (0.410us vs 0.962us for unaligned offsets) was achieved precisely because the
> stores hit the fast L1 cache instead of actually flushing to memory?

I do not see anything in the Intel SDM saying that an unaligned
non-temporal MOVNTI store that crosses a cache line silently falls back
to temporal RFO cache allocations. The existing 4/8/16-byte
memcpy_flushcache() fixed-size cases already use MOVNTI without such an
alignment check. Please correct me if I am wrong.

The microbenchmark is only used as the performance motivation for keeping
these small constant-size copies in the inline path. It is not intended
as a durability proof.

> --- Patch [8]: [PATCH v7 8/9] mm: use memcpy_nontemporal() in zone-device template copies ---
> commit ebc6b81ea2e4b12a555515b9468c89fd0bdfe4f1
> Author: Li Zhe <lizhe.67@bytedance.com>
> mm: use memcpy_nontemporal() in zone-device template copies
> The template fast path currently uses memcpy() for the actual struct page
> copy. Switch zone_device_page_init_from_template() to memcpy_nontemporal()
> to reduce write-allocate cache traffic.
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index 2668acef4fe60..2a723a518f413 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> [ ... ]
> > @@ -1110,7 +1120,7 @@ static void zone_device_page_init_from_template(struct page *page,
> >  	 * to the destination page.
> >  	 */
> >  	zone_device_page_update_template(template, pfn);
> > -	memcpy(page, template, sizeof(*page));
> > +	memcpy_nontemporal(page, template, sizeof(*page));
> Could this mix of non-temporal and temporal stores to the same memory location
> cause data corruption on x86?
> During DAX device binding, memmap_init_zone_device() copies the template to
> the head page using this memcpy_nontemporal() call, and then immediately
> calls memmap_init_compound():
> mm/mm_init.c:memmap_init_zone_device() {
>     ...
> 		} else {
> 			zone_device_page_init_from_template(page, pfn,
> 							    &template);
> 		}
>     ...
> 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
> 				     compound_nr_pages(pfn, altmap, pgmap),
> 				     use_template);
>     ...
> }
> Inside memmap_init_compound(), a normal temporal store is applied to the
> head page:
> mm/mm_init.c:memmap_init_compound() {
>     ...
> 	/*
> 	 * We have to initialize the pages, including setting up page links.
> 	 * prep_compound_page() does not take care of that, so instead we
> 	 * open-code prep_compound_page() so we can take care of initializing
> 	 * the pages in the same go.
> 	 */
> 	__SetPageHead(head);
>     ...
> }
> The commit message states:
> "The ordinary stores that follow in this path, such as compound-page setup,
> are part of the same CPU's initialization sequence; they are not used as a
> publication store that tells another CPU or device to consume data written
> by the non-temporal copy. Therefore this call site does not need a helper-
> level drain for correctness."
> However, because x86 does not maintain coherency between write-combining (WC)
> buffers and temporal cache lines for the same address, a pending WC buffer
> flush can unpredictably overwrite the L1 cache updates from the same CPU. This
> could cause the PG_head bit to be lost.
> Does this path actually require an intervening memory barrier (like sfence)
> before the temporal writes to guarantee correctness?

I do not think an sfence is required between the template copy and the
following compound-page setup.

The weak-ordering concern for non-temporal stores is about when those
stores become visible to other agents, and about ordering them before an
external handoff. The following __SetPageHead() store is not such a
handoff. It is still part of the same CPU's construction of the same
struct page metadata.

I do not think the x86 memory-ordering rules imply that a later
same-CPU temporal update to the same struct page can be silently lost
behind an earlier non-temporal store. The required fence is for ordering
non-temporal stores before an external observer or handoff.

So the relevant ordering point would be before publishing data written by
non-temporal stores to another CPU or device. This path does not do that
between the memcpy_nontemporal() call and the following compound-page
stores. It is only continuing local initialization of the struct page.

Thanks,
Zhe

