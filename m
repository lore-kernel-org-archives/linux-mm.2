Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A892FD7F91
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 10:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AE5B6B0005; Fri, 27 Feb 2026 05:47:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385B36B0088; Fri, 27 Feb 2026 05:47:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2847F6B0089; Fri, 27 Feb 2026 05:47:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D8EA6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 05:47:50 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8636BA3D5
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:47:49 +0000 (UTC)
X-FDA: 84489911058.27.E444885
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id D962C1A000B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:47:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=H9pzLPx9;
	spf=pass (imf19.hostedemail.com: domain of 3UXahaQgKCBg7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3UXahaQgKCBg7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772189268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIZdtDXTxmY5bMoPqmkr1xnlX1DtFVenM/eaR2GkvVM=;
	b=bTyZ06p+4dORrYszbUXv6CqLwEbRjHxbMpDPJEe768d2VykT2xBuoGFjjN6FUjbNiJKVi+
	MMIehiRh6llrkDw4HYZqCrKOBUN4rPXc9dHs8E81zLBIj3ubQIM2q4KFRCvURBWaFAS0ik
	A2zBz70l3V7gpmskDNdZ73T0rpLp8VI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=H9pzLPx9;
	spf=pass (imf19.hostedemail.com: domain of 3UXahaQgKCBg7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3UXahaQgKCBg7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772189268; a=rsa-sha256;
	cv=none;
	b=R7//3GCer0q0I/nQrzzOivA13gpJVcUBlwWmNgodSjFev1vwRVWAzTwRJI+7QY0y0NhlxP
	0WVFq+h2MA2bnqELLvtU3ogwdCGvZknzliTSPJj46+2Awnipj4qsdx/CNNPgG7zAv00b76
	5uB3SjVpzBX3baWemmvGNBQbhDi1KPU=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48379489438so18521835e9.2
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772189266; x=1772794066; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MIZdtDXTxmY5bMoPqmkr1xnlX1DtFVenM/eaR2GkvVM=;
        b=H9pzLPx9QHIPySGtxQUqZJNxnVIoDnJkE8FGCAQJzUowPCaY900IXs1EMOGmG6Kg3i
         UIihz0OYQGTyBuHTWXJIqMM+Ee1sm+gn3+G9htqk4/rbr4NGkTKhzzQR75lpHjxfu3WS
         x1+kNneW1imTUl49p8DAofO7Y7Dtgb70a85EE7wpxhHx49KiGJop9Zuw/JWvvNR16Zxl
         T9frQv3dInMm31yt8jPKzsQRPfP/nPAjLfvviLVT4BunAa9ODuVZRg0xEFxIztQ14+o7
         AM4z7Pv1N6qJq5OpRJMGTg6gTOKuvz1NQz0WjCNgRAwe8kWzdGIS8sWa4k0BTeacG9B0
         Va0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772189266; x=1772794066;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MIZdtDXTxmY5bMoPqmkr1xnlX1DtFVenM/eaR2GkvVM=;
        b=GL2LiPMuYwfUhk+2KtZMrktwB/WU4Lh0PliE/NN8eEuXQiUP6Cltc5mCJTdsvFW1IX
         mdBtKS+OrDmTVqrXCDtVL/9ny+gEqxLdNScFqHZezkSMPpFfT6ofcQDSriWbFLLsJZWj
         yZR5A3YdLvtiokmXgatbSnAtpKMAH9yj5S0wwt4sldwVKMzW4uN81YdJVAnrgJ0tpMUr
         NOxThpDWAWXbF5ORCLT5HjOyeDxEDlqP7B3KKZCv61wbA+VOQ9d44LQ1PyYnD6rSk05f
         5qMQoZRFE47I/pMsMow7IYq50W6ExsVdU7Ub/GXs+CHD0NxYlhj2u40mEnbUGS9R+hWY
         CS1w==
X-Gm-Message-State: AOJu0YyFbQdPP1pjh9gkK2i9H4CEECW/yrKsnD2xvsoWXUvIXtfJ7nvq
	IS6gCJrnwwboYAPA0HTZp28ZPOWMNBPYXeSUng7tCpbHrSIST3Y61XXEjqYM3WgBiT5BYsHUM5K
	jiqSQlEpaaBmNkg==
X-Received: from wmjf8.prod.google.com ([2002:a7b:cd08:0:b0:483:291c:7f23])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:6447:20b0:477:98f7:2aec with SMTP id 5b1f17b1804b1-483c9ba7e34mr24732745e9.3.1772189265937;
 Fri, 27 Feb 2026 02:47:45 -0800 (PST)
Date: Fri, 27 Feb 2026 10:47:45 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-4-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com> <20260225-page_alloc-unmapped-v1-4-e8808a03cd66@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DGPONXAKU7ZG.11C48FZY9OCPT@google.com>
Subject: Re: [PATCH RFC 04/19] x86/mm: introduce the mermap
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, 
	<rppt@kernel.org>, Sumit Garg <sumit.garg@oss.qualcomm.com>, <derkling@google.com>, 
	<reijiw@google.com>, Will Deacon <will@kernel.org>, <rientjes@google.com>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D962C1A000B
X-Stat-Signature: g69xfoi9c1tjte1ky8dpfdfdy4mnbwe7
X-HE-Tag: 1772189267-747915
X-HE-Meta: U2FsdGVkX19WF1u+GIVNW8XVb4UJ9XY9BBy+HiJBgLNw2znoEZqQn8VlVp6vohrwRozaKCYaARIXmXEqa+3RHotFWfUBCqCNUI5tJpmrB68ekATAqWtRS+vWUojzIGqy+q8l16aHbtZsHaUXb0oLTdGlf8D/qh211qsuHIlWoF/0hrDLDewQt4LObsb+RQCFFsunHT1UrMIYV5c1ZX31kHj07VcXCuYcMuudTVG6wVob1dnMiXyj/nWcDi1/DHLUj8iHV+EAjm5KfTmk1bI+5kohKgUHma/kX2L/+GCx38tanFVuvknl+EigKs6OPv1IAEyJKHUKtJ8SBHbXZoJv3NJejMg+oPh0Z4lIxshRY1APB6ixprOk9R7xsLKNLjqteExTty2laS5U8esSpgGCm1ZpYAYMm0GN3zbskXaeH8nz5zOzWrrycGXgEwJnQBF+fC6JBKdENxd9/hPwhAq5V4YImQkoPObn+hk20y3OHm0l+wbrQRWIRmivBF/Hq5STOZ7iy/Ub24dUtZmy/ueZjuRz3Rp1qwqJ1RrExVaTp5uoB7ciZiV2AnhhNmDqu+LJYe+CLZzGrR4lJIhlfwzeRyULKgh3VcITzC/PqwNTpSkp86sDcID0NDVXCei2XT68Ym1oQSkOQ3bsLkI9uP+EEJBUJxPfC25AWZ2KsTqhq3D8d5axzYWOvDDWkptY0Yt8PHNLXOlIwCeybadAoL2WRcGe8iyHvX3pVdzsAVJjnwK8UvhFkK0HFUieH18WA5eehz0DSWf3PU/CVwS+5nGQ2GXBEc/iM6oRHXIOo/OztbON65nkJz67nUs0azdrrrbtcZKCwvw6Jro8hndzLXpstRAvB5YhRLPWBEv+ykrh0niqNkfg0xrWBCNTAPWLSf7Fy1j4CjPv29U6CWetFyH0UDcQRdzD708m65TZvUq1JhWBjDnexq2VTmqGKVDCYaQht8zQpkzIAflDggMPCON
 TtIzvg/O
 1vns5C+mhGjcBFRKbncJEt7aDdEf2deddZVR6PDNK622OWlaKHjk/t/KYueOi0qvb9ud+iWIFHpZsdBFgVYysYSezp6Pcff/mIKFHdTkOUSA62o3K5LiCQJlgIXyvpeyg7Qy7ZuXALy/yZ0kETzB/2xq8nNU2KjZsi/JVsjFFiY1tP5vOjBOlYL0aVsVJ3xD3ChaCkTWOhrA5CMy/WEXFn7IpGdtb+I04hN3M2fhL/JefIM+jBKtAJM1Y9ykrZuPVw8Ai6T+Ayx/om3dzJgkcLFFteXgkBedmcylBCRw/P6xvUvxksKqR+hgP0mPWGG6symK2DIl0N5wgrV5rc/AfSaSjJCdlNXfpKJ5q5Yaf67fYbunaBIt91dI0FQiUGab84S7y3sxY5A9OYMhmFoTQUILRAb4VrQIUZzp5vGkSK3G6o+0lepGJLSn4B2cM+7ppVNK11r3llF0dUHbrkIwKFCzPKERSdJz58uP5OB3AgThiKSaMlyiBts3lccOAEq4fkHh7RjsHJbE7ydkjKY+QLWUbBZXfCobp4iIAMpit0XjJefxfGsxiy8+8LBIXo+9BHjvARpq5us8WnKrnjg7gY3pc4YBk2nYe7dEoYID9N5Vpf33vb7hYXaIK6SOdTKpROMk+VTywmBTrhgpy2LnezlxDktssk+rIpSnU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Relaying some code review from an AI that I wasn't able to run before
sending...

(This isn't the AI's verbatim output I'm filtering it and rephrasing).

On Wed Feb 25, 2026 at 4:34 PM UTC, Brendan Jackman wrote:

> +
> +/* Call with migration disabled. */
> +static inline struct mermap_alloc *mermap_alloc(struct mm_struct *mm,
> +						unsigned long size, bool use_reserve)
> +{
> +	int cpu = raw_smp_processor_id();
> +	struct mermap_cpu *mc = this_cpu_ptr(mm->mermap.cpu);
> +	unsigned long cpu_end = mermap_cpu_end(cpu);
> +	struct mermap_alloc *alloc = NULL;
> +
> +	/*
> +	 * This is an extremely stupid allocator, there can only ever be a small
> +	 * number of allocations so everything just works on linear search.
> +	 *
> +	 * Allocations are "in order", i.e. if the whole region is free it
> +	 * allocates from the beginning. If there are any existing allocations
> +	 * it allocates from right after the last (highest address) one. Any
> +	 * free space before that goes unused.
> +	 *
> +	 * Once an allocation has been freed, the space it occupied must be flushed
> +	 * from the TLB before it can be reused.
> +	 *
> +	 * Visual example of how this is suppose to behave (A for allocated, T for
> +	 * TLB-flush-pending):
> +	 *
> +	 *  _______________ Start with everything free.
> +	 *  AaaA___________ Allocate something.
> +	 *  TttT___________ Free it. (Region needs a TLB flush now).
> +	 *  TttTAaaaaaaaA__ Allocate something else.
> +	 *  TttTAaaaaaaaAAA Allocate the remaining space.
> +	 *  TttTTtttttttTAA Free the allocation before last.
> +	 *  ^^^^^^^^^^^^^   This could all be reused now but for simplicity it
> +	 *                  isn't. Another allocation at this point  will fail.
> +	 *  TttTTtttttttTTT Free the last allocation.
> +	 *  _______________ Next time we allocate, first flush the TLB
> +	 *  AA_____________ Now we're back at the beginning.
> +	 */
> +
> +	if (use_reserve) {
> +		if (WARN_ON_ONCE(size != PAGE_SIZE))
> +			return NULL;
> +		lockdep_assert_preemption_disabled();
> +	} else {
> +		cpu_end -= PAGE_SIZE;
> +	}
> +
> +	if (WARN_ON_ONCE(!in_task()))
> +		return NULL;
> +	guard(preempt)();
> +
> +	/* Out of already-available space? */
> +	if (mc->next_addr + size > cpu_end) {
> +		unsigned long new_next = mermap_cpu_base(cpu);
> +
> +		/* Would we have space after a TLB flush? */
> +		for (int i = 0; i < ARRAY_SIZE(mc->allocs); i++) {
> +			struct mermap_alloc *alloc = &mc->allocs[i];
> +
> +			/*
> +			 * The space between the uppermost allocated alloc->end
> +			 * (or the base of the CPU's region if there are no
> +			 * current allocations) and mc->next_addr has been
> +			 * unmapped in the pagetables, but not flushed from the
> +			 * TLB. Set new_next to point to the beginning of that
> +			 * space.
> +			 */
> +			if (READ_ONCE(alloc->in_use))
> +				new_next = max(new_next, alloc->end);
> +		}
> +		if (size > cpu_end - new_next)
> +			return NULL;
> +
> +		mermap_flush_tlb(cpu, mc);
> +		mc->next_addr = new_next;
> +	}
> +
> +	/* Find an alloc-tracking structure to use */
> +	for (int i = 0; i < ARRAY_SIZE(mc->allocs); i++) {
> +		if (!READ_ONCE(mc->allocs[i].in_use)) {
> +			alloc = &mc->allocs[i];
> +			break;
> +		}
> +	}
> +	if (!alloc)
> +		return NULL;

Oops, I forgot to account for @use_reserve here. The alloc-tracking
structures should have a reservation like how the virtual address space
does otherwise allocations can fail where they aren't supposed to.

> +	alloc->in_use = true;
> +	alloc->base = mc->next_addr;
> +	alloc->end = alloc->base + size;
> +	mc->next_addr += size;
> +
> +	return alloc;
> +}
> +
> +struct set_pte_ctx {
> +	pgprot_t prot;
> +	unsigned long next_pfn;
> +};
> +
> +static inline int do_set_pte(pte_t *pte, unsigned long addr, void *data)
> +{
> +	struct set_pte_ctx *ctx = data;
> +
> +	set_pte(pte, pfn_pte(ctx->next_pfn, ctx->prot));
> +	ctx->next_pfn++;
> +
> +	return 0;
> +}
> +
> +static struct mermap_alloc *
> +__mermap_get(struct mm_struct *mm, struct page *page,
> +	     unsigned long size, pgprot_t prot, bool use_reserve)
> +{
> +	struct mermap_alloc *alloc = NULL;
> +	struct set_pte_ctx ctx;
> +	int err;
> +
> +	if (size > MERMAP_CPU_REGION_SIZE || WARN_ON_ONCE(!mm || !mm->mermap.cpu))
> +		return NULL;
> +	if (WARN_ON_ONCE(!arch_mermap_pgprot_allowed(prot)))
> +		return NULL;
> +
> +	size = PAGE_ALIGN(size);
> +
> +	migrate_disable();
> +
> +	alloc = mermap_alloc(mm, size, use_reserve);
> +	if (!alloc) {
> +		migrate_enable();
> +		return NULL;
> +	}
> +
> +	/* This probably wants to be optimised. */
> +	ctx.prot = prot;
> +	ctx.next_pfn = page_to_pfn(page);
> +	err = apply_to_existing_page_range(mm, alloc->base, size, do_set_pte, &ctx);

This takes a PTE lock, and we may have preemption off here, so this may be
broken on PREEMPT_RT? Haven't checked. (Maybe I can just test this by
running it with PREEMPT_RT and lockdep enabled?)

If that's indeed broken, this is yet another point to discuss in about
requirements for a pagetable library [0]. The lock is not needed at all
here - we need a way to modify pagetables that lets you take advantage
of higher-level synchronization.

[0] https://lore.kernel.org/all/20260219175113.618562-1-jackmanb@google.com/

> +	if (err) {
> +		WRITE_ONCE(alloc->in_use, false);
> +		return NULL;

Forgot migrate_enable().

(Is there a way to prevent this with the lovely new
__attribute__((cleanup)) magic?)

> +	}
> +
> +	return alloc;
> +}
> +
> +/*
> + * Allocate a region of virtual memory, and map the page into it. This tries
> + * pretty hard to be fast but doesn't try very hard at all to actually succeed.
> + *
> + * The returned region is physically local to the current mm. It is _logically_
> + * local to the current CPU but this is not enforced by hardware so it can be
> + * exploited to mitigate CPU vulns. This means the caller must not map memory
> + * here that doesn't belong to the current process. The caller must also perform
> + * a full TLB flush of the region before freeing the pages that have been mapped
> + * here.
> + *
> + * This may only be called from process context, and the caller must arrange to
> + * first call mermap_mm_prepare(). (It would be possible to support this in IRQ,
> + * but it seems unlikely there's a valid usecase given the TLB flushing
> + * requirements). If it succeeds, it disables migration until you call
> + * mermap_put().
> + *
> + * This is guaranteed not to allocate.

This one isn't from AI, but I just realised that's a pretty confusing
thing for an allocator to say. It should say it's guaranteed not to call
the page allocator. (This is important coz I want to use it from the
page allocator).

> + *
> + * Use mermap_addr() to get the actual address of the mapped region.
> + */
> +struct mermap_alloc *mermap_get(struct page *page, unsigned long size, pgprot_t prot)
> +{
> +	return __mermap_get(current->mm, page, size, prot, false);
> +}
> +EXPORT_SYMBOL(mermap_get);
> +
> +/*
> + * Allocate a single PAGE_SIZE page via mermap_get(), requiring preemption to be
> + * off until it is freed. This always succeeds.
> + */
> +void *mermap_get_reserved(struct page *page, pgprot_t prot)

Oops, that should return mermap_alloc *.

> +/* Clean up mermap stuff on mm teardown. */
> +void mermap_mm_teardown(struct mm_struct *mm)
> +{
> +	int cpu;
> +
> +	if (!mm->mermap.cpu)
> +		return;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct mermap_cpu *mc = this_cpu_ptr(mm->mermap.cpu);

Oops, this should be per_cpu_ptr(..., cpu) or whatever it is.

