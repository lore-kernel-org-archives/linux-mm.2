Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96300C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 22:29:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D2816B00D2; Mon, 29 Jun 2026 18:29:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AAD16B00D8; Mon, 29 Jun 2026 18:29:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 372516B00DD; Mon, 29 Jun 2026 18:29:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03F396B00D2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:29:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82F1E1C65C6
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 22:29:55 +0000 (UTC)
X-FDA: 84934393950.17.02E7D6E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7AFD9160003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 22:29:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WAAC7NQu;
	spf=pass (imf08.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782772193;
	b=zhUNR2pMWHZMQRNpagISfQDKLJlg23sAS/SZh4jxamW2qeuOLNjdS0zxXq8pAM2aBHsXAa
	crE2Pj67yZ3juxK7HT6ou261auTeybHR/sk7cFAvy7nihTx7N3H/rou+ZTfnz3u4aUv49z
	OhRyPP8kmd2KOM29m4jpCfHiuek1m0c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782772193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NtIIb742Pf6cF3AY+7k7uQvPd7AU7NsUgcNEtRmc3Sc=;
	b=kADUrAMvl9fKe+494bt1bZ6Zht+/q816jcLd8+Lfs87D0gi2SXk4oI3JanB8l1fIjUdGZi
	6suYXr7E6QESM8wcM2IGI/wktT/2YNP5gXZCoBaekD1xcfQCGgAG08wlLJokXouXUvQeo6
	xRDJrZFG3+M6akeweQyIEAPXZQy+mr4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WAAC7NQu;
	spf=pass (imf08.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782772192; x=1814308192;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qN27ZZ5ZzGfSo/GRH6t7qweo4vTozdVddXjQAw2mYlY=;
  b=WAAC7NQuE+cxGO2sOx+iOmex89+4hhoUDm5UTqrc7rdVnqPQr8TdXByb
   G/QGuHbGKKsxiHd7eeEZ2QOkdt6x5aqLfASJYNQeeaNPX4x7ZHGCDLreT
   6fT8zf6Kx4g6d6cxwuoLKsk559qHeQv6pTRSIFKIpYYub43+6ccSobZGS
   RVtMXQQ5pq9TFUmoTevnT+5EdzJGiBkN81BeZZiyTFE9v/ReQdFHbhj6A
   qFxc+ogneljaY9d/x5Ti8itBQkULAupA2+Y0MGTTouzmK/SqxI6o5cUUB
   ZTcf9vbOMum2QsGtWpQ/Jyve9LIbAseGGIvW/QctZ4VNQ1EXUzyYv37r/
   A==;
X-CSE-ConnectionGUID: PTJQLlbUTxKQNmuoFrH76Q==
X-CSE-MsgGUID: B+Zi7pQzSdm5pFvEqKMJ4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11832"; a="94078652"
X-IronPort-AV: E=Sophos;i="6.24,232,1774335600"; 
   d="scan'208";a="94078652"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 15:29:51 -0700
X-CSE-ConnectionGUID: SRfUAOd5Tjq/SQlJ91rkAg==
X-CSE-MsgGUID: htcNs0YER3+r+Bg6LK9GRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,232,1774335600"; 
   d="scan'208";a="251685594"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.109.197]) ([10.125.109.197])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 15:29:50 -0700
Message-ID: <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
Date: Mon, 29 Jun 2026 15:29:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: Xiang Mei <xmei5@asu.edu>, Kees Cook <kees@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, linux-hardening@vger.kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
 "Gustavo A . R . Silva" <gustavoars@kernel.org>,
 "H . Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>,
 Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>,
 Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>,
 Yan Shoshitaishvili <yans@asu.edu>
References: <20260629214712.1198680-1-xmei5@asu.edu>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260629214712.1198680-1-xmei5@asu.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bcugwru56kpxknqn7tt6ax9m7q999w9s
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7AFD9160003
X-HE-Tag: 1782772192-869435
X-HE-Meta: U2FsdGVkX1+awk8EuQczEkHUJ+rLK1vWVGYA6lfmdRnoWi7J8l0gF5jEopFuCaWszMd4dqYREPy0nDXEWwsrDmPKpBB8FSpxzQA1ngLPtcJxTORJjI/wbo9hhF1AbxKvtHtuPX7unJ5B0nqReu0F6HJbw/ND7CXNbxuwOmPI6ySaJSeUHI3HPaqDNczzt/ZprWFGFGuGZuoarzgTdvx2Nrdb4cPuuQIHAqQ0U80lqDtOSm2KkVxzLLHTisEcuQK/h/zqFYjP7k0z9S1RMFAXMb2Nq3UBflR8R3eiaFSfkSJ0CRCsykBvpP4SDoiwa3mOy6SHsFtCRHhFhVNQPyG8Yi2Cvxx+22l0Iv0yPftgE8aT85Iob9UOKAkD5uCNVl6MzAZWbnSH4pMWdern56ucQ9kzjdZAu9h20pcUYqyJbUBB2aOytrkb3+qxadJiWmEKRFZVvtSeR0KVoAoQe0/hpCT/3Cx/A1OKuOR9hS1SHIMUHRwDUkwJ/iyj93yWFuyqyBC+j3RHB/IpiaCcK4IUOk5BWetfbRMdCxqsRiy/+hvynWkl+4DjZJCMhxDZkWTvFQZW7al8pbQ0dB28CkI5Fl+RNeUCT89TwBiUcbFbhu6RvBWdv5Gfd4d0Yk4U7SUyN/JurVavx5gycRLetTTsxPA6kUvwyv5JUsf6cd26OyrT+zmq/sEM/JbP2p8l5n3qrDnoKu/Jn06J9ZTPsQCWkoHBqxsFxb9Em2XchsqDF4Xy8tdZCoXGhnAD0ihycPel+baCyzarA6dFngVzXm9evpc+eTTzi7CIhKsqmhEqKK+9c6E6S0LfnDTaA/sSlXSsfjZofE1ysyD2506B/4owQm6rmbigfZQESI/coUVMff9EVbHYTzN+EbUOj+57wlyz8zspSPFDM+62Zf+nYKmB+oM+6eJWD6O/+0KtGRfEWoZ/u0uIqDDKIPUEMwj4ACPed6hz30rRmkoD6jJ4E5p
 mpSPjhdl
 q2d36qBYqsHSoREgihVYs/Jx/Gb0hmVehhNfUaPZffYSgHZJoVwbYWsHASRZ+5YQu5hmgEW7VrHcuHY9EKzf8jxAZL9P8hcGhz7rG2/RS353tx0yF2/YaadzER3v95hQpvsZBhvBNr8105Rr1p/KeMl23ZEJZ8mAqMRBEFmMvawoTiAO8RG2pAx9UaVRr5v/9ePPQjWfUjYV8PQ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 14:47, Xiang Mei wrote:
> With CONFIG_VMAP_STACK, kernel stacks are allocated in the vmalloc area,
> which an unprivileged user can surround with attacker-controlled data by
> spraying vmap allocations adjacent to a target stack (for example via
> XDP_UMEM_REG, though other vmalloc spray paths work too). Today each
> guarded vmalloc allocation is followed by a single unmapped guard page.
> 
> A single guard page is not enough to contain the x86_64 ENTER
> instruction used as a one-instruction stack pivot. ENTER imm16, imm8
> builds a stack frame and lowers RSP by:
> 
> 	imm16 + 8 * (L + 1),  L = imm8 & 0x1f
> 
> imm16 is an unsigned 16-bit operand (ENTER never raises RSP), and L is
> in [0, 31], so the maximum displacement of a single ENTER is:
> 
> 	0xffff + 8 * 0x20 = 0x100ff bytes

This needs some more discussion of why this _specific_ instruction is so
important and why a good old 'add'. Peter asked about this on v1 and it
didn't make it into v2.

I think it boils down to ENTER doing a bunch of useful stuff setting up
a new frame in a single instruction. That single instruction is easier
to conjure up from another exploit or bad control flow than actually
setting up a stack frame.

But, really, if ENTER is so evil and nobody uses it, shouldn't we just
have an MSR bit somewhere to tell the CPU to #UD for it rather than
playing these stack games?

> That is more than enough to step off the current stack, across the
> one-page guard, and into the adjacent sprayed pages. When those pages
> contain a return sled feeding a ROP chain, reaching any ENTER gadget
> (opcode 0xc8, abundant as both intended and unintended gadgets) turns a
> control-flow hijack into full ROP execution without any register control
> at the hijack site, making it a one-gadget-style primitive that
> significantly eases exploitation. The pivot happens after the control
> transfer, so it is not constrained by CFI (kCFI/FineIBT).

This all sounds super theoretical.

I don't think we should mess with any of this without there being some
sign that this is an actual, practical juicy exploit target.

> Introduce a VMAP_GUARD_PAGES knob that defaults to a single page (no
> change for current architectures) and can be overridden per arch via
> asm/vmalloc.h, and set it to 0x11 on x86_64. This is deliberately scoped
> to x86_64: the 0x100ff bound is a property of the ENTER opcode, and ENTER
> is also a one-byte opcode (0xc8) that appears as abundant unintended
> gadgets. Other architectures (e.g. arm64) have no equivalent
> single-instruction, immediate-controlled pivot reachable as an unaligned
> unintended gadget, so they keep the one-page guard and pay no cost.

To even be considered, this series needs to be refactored properly.
Making this VMAP_GUARD_PAGES a separate patch is the bare minimum.

> The override is gated on CONFIG_X86_64 rather than applying to all of x86:
> VMAP_STACK is selected only on x86_64, so 32-bit kernel stacks are not in
> the vmalloc area and the technique does not apply there. 32-bit x86 also
> has a far smaller vmalloc window, where widening every guarded area by 16
> pages would needlessly pressure the address space.

Shouldn't you condition it on HAVE_ARCH_VMAP_STACK, not X86_64 directly?

> The guard pages are never populated, so there is no extra physical
> memory and no additional page-table population beyond the larger virtual
> span; the cost is virtual address space and vmap_area bookkeeping, which
> is negligible against the 64-bit vmalloc window. get_vm_area_size() is
> adjusted by the same VMAP_GUARD_SIZE so the usable size reported to
> callers is unchanged.

Let's be thorough here, though, please. You're arguing that there's no
real cost to this. It's going to make the vmalloc() address space more
sparse and put pressure on the intermediate paging structure caches.
Whether that pressure matters is debatable.

But I do think you owe at least some rudimentary performance checks on this.

BTW, this is LLM-wordy. If you send another version of this, please work
on making it more concicse.

> On x86 this widens the guard for all guarded vmap areas, not only thread
> stacks. ret2enter targets the stack specifically, so a narrower
> alternative is to apply the wider guard only on the thread-stack
> allocation path via a dedicated VM_ flag; we kept the change in the
> common path as defense in depth for any vmalloc-adjacent pivot target,
> but are happy to scope it to stacks if maintainers prefer.

The simplest code thing for now is to just make it apply to all
vmalloc() allocations. That also theoretically has the largest impact,
but it's probably the best patch to start with.

> While widening the guard, also mark percpu vmap areas VM_NO_GUARD.
> pcpu_get_vm_areas() and pcpu_page_first_chunk() size each area exactly and
> reserve no guard, so get_vm_area_size() would subtract a guard that was
> never added and underflow if an area were smaller than the guard. This is
> a latent correctness fix only: on x86_64 percpu areas are megabyte-scale,
> far larger than the guard.

Honestly, I think this is just a sign that the code needs refactoring
rather than hacks.

If you go forward with this, I think vm_struct just needs a
area->guard_nr_pages. Then the internal users of the structure just set
area->size and the guard size. They don't have to fiddle with VM_NO_GUARD.

> +/*
> + * The x86 ENTER instruction can be used as a one-instruction stack pivot:
> + * ENTER imm16, imm8 lowers RSP by imm16 + 8 * (L + 1), L = imm8 & 0x1f.
> + * imm16 is an unsigned 16-bit operand (ENTER never raises RSP) and L is in
> + * [0, 31], so a single ENTER can lower RSP by at most
> + * 0xffff + 8 * 0x20 = 0x100ff bytes. With CONFIG_VMAP_STACK the kernel
> + * stack lives in the vmalloc area, where an unprivileged user can spray
> + * adjacent allocations; a single-page guard is too small to contain such a
> + * pivot. Use 0x11 guard pages (0x11000 bytes), the smallest whole-page
> + * span exceeding 0x100ff, so the pivot faults in the guard instead of
> + * landing in attacker-controlled memory.
> + *
> + * Restrict this to 64-bit: VMAP_STACK is selected only on x86_64, so 32-bit
> + * kernel stacks are not in the vmalloc area and the technique does not apply.
> + * 32-bit also has a far smaller vmalloc window, where a 16-page-per-area
> + * widening would needlessly pressure the address space.
> + */
> +#ifdef CONFIG_X86_64
> +#define VMAP_GUARD_PAGES	0x11
> +#endif

That comment is way too big. What is it protecting? What does the number
come from? We don't need to see the gory details in the comment.

/*
 * Protect against control flow hijacks to gadgets using the ENTER
 * instruction. Those can jump a bit over 64k on the stack so make the
 * guard 64k+4k.
 */
#ifdef CONFIG_VMAP_STACK
#define VMAP_GUARD_PAGES	0x11
#endif

Right? What else do you really need?

>  #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
>  
>  #ifdef CONFIG_X86_64
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index 3b02c0c6b371..b8546e519deb 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -49,6 +49,18 @@ struct iov_iter;		/* in uio.h */
>  #define IOREMAP_MAX_ORDER	(7 + PAGE_SHIFT)	/* 128 pages */
>  #endif
>  
> +/*
> + * Number of unmapped guard pages appended to each guarded vmalloc
> + * allocation. The default is a single page; an architecture may override
> + * VMAP_GUARD_PAGES (via asm/vmalloc.h) when a wider guard is needed to
> + * contain a worst-case single-instruction stack pivot into an adjacent,
> + * attacker-controlled vmap allocation (see arch/x86 for the ENTER case).
> + */

Heh, are you getting paid by the word here? These are way too verbose.

> +#ifndef VMAP_GUARD_PAGES
> +#define VMAP_GUARD_PAGES	1
> +#endif
> +#define VMAP_GUARD_SIZE		(VMAP_GUARD_PAGES * PAGE_SIZE)

This could also be quite trivially expressed in Kconfig:

config VMAP_GUARD_PAGES
	int
	default 1
	default ARCH_VMAP_GUARD_PAGES if ARCH_VMAP_GUARD_PAGES

>  struct vm_struct {
>  	union {
>  		struct vm_struct *next;	  /* Early registration of vm_areas. */
> @@ -236,8 +248,8 @@ int vmap_pages_range(unsigned long addr, unsigned long end, pgprot_t prot,
>  static inline size_t get_vm_area_size(const struct vm_struct *area)
>  {
>  	if (!(area->flags & VM_NO_GUARD))
> -		/* return actual size without guard page */
> -		return area->size - PAGE_SIZE;
> +		/* return actual size without guard region */
> +		return area->size - VMAP_GUARD_SIZE;
>  	else
>  		return area->size;
>  
> diff --git a/mm/percpu.c b/mm/percpu.c
> index b0676b8054ed..9f7262228be1 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -3243,7 +3243,7 @@ int __init pcpu_page_first_chunk(size_t reserved_size, pcpu_fc_cpu_to_node_fn_t
>  	}
>  
>  	/* allocate vm area, map the pages and copy static data */
> -	vm.flags = VM_ALLOC;
> +	vm.flags = VM_ALLOC | VM_NO_GUARD;
>  	vm.size = num_possible_cpus() * ai->unit_size;
>  	vm_area_register_early(&vm, PAGE_SIZE);

Yeah, I'd much rather see:

	vm.size  = num_possible_cpus() * ai->unit_size;
	vm.guard = 0;

(or whatever we name the structure member) in cases like this.

So, yeah, this is a cute PoC hack. But it's gluing about 10 different
things into one patch instead of doing proper refactoring. Plus, I'm not
really even sure it's worth it in the first place.

