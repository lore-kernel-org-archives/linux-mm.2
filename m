Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21415C44503
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:11:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8BA6B008C; Wed,  8 Jul 2026 10:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC0A76B0092; Wed,  8 Jul 2026 10:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A60916B0093; Wed,  8 Jul 2026 10:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7ABAE6B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:11:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 12EC81C701B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:11:10 +0000 (UTC)
X-FDA: 84965796300.14.F097616
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 72291C000D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:11:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CUQcU9G1;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783519868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ts8+PPYmxoOpLLgVeTglSWE1PasRF+dUNUmJflgeGZM=;
	b=qrJCjDtuCkI53cEkkWazsoL2JbERqGjRMi5AL0RtkcVFnTMwICCOnfSjt9mDgLZl7+jJUe
	PLhcG3CsG7rnAAw7uUUSUe5r4ZybMrdUwRqHinLU8KgiNmzjJiT2feGy67sj2gZko6a6zJ
	lTB1cLt67C8oL/FCNWsx2DEjLFjDhTs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CUQcU9G1;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783519868;
	b=7Ff1Izqp6/ZMeiPRsB9Jl1HaJIoGyBEaW7tIgqeZai8DQeVwMEFn9F5nQHh2APnF5ALB5a
	CpOkm6/+/pj9mUllKOWgETwNF1P/xkr0R3emK1ScIecEK/IWRqXoAdg5hM/71h0GAweqNX
	7bMD0AzfArRL/u20P8ZPSRuksgVeS/w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3E00600AF;
	Wed,  8 Jul 2026 14:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8FD1F00A3A;
	Wed,  8 Jul 2026 14:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783519867;
	bh=ts8+PPYmxoOpLLgVeTglSWE1PasRF+dUNUmJflgeGZM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=CUQcU9G1jJ4xeYZiG3BZOH2n9CAq095h2H4KghWvlIVWxEl4bDX2Cs/id1+GyN5aq
	 Q3Lkbj9ZFwkXKeIeQcwj7JqJQ2Nu3dDoPr91m0JOYW0zR5GgMpOiakj1U+3JrF8n5a
	 0bVwOrQhgjabZlvTy5q50RVhtvLcsIFaFor4qaz9ij1QPS3Vrk6jP7MBS7/zYlOjcn
	 NmpRaiDVSZJvPXrciJ5a75LjjZPYpYsgPjFNy/VQoCFt9JAchFioDo/5OdPV7uODKY
	 24xjzqmhJCl1Mj7NTqHihjOMO3TAFSkAvUQtHFdhGi5uz+Aj0Mb9BZLNz6CgrkC9zh
	 5RmrRS35OcTsQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Alexander Graf <graf@amazon.com>,  Samiullah Khawaja
 <skhawaja@google.com>,  David Matlack <dmatlack@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] kho: Support preserving unsplit high-order pages
In-Reply-To: <20260703020832.1731864-1-praan@google.com> (Pranjal
	Shrivastava's message of "Fri, 3 Jul 2026 02:08:28 +0000")
References: <20260703020832.1731864-1-praan@google.com>
Date: Wed, 08 Jul 2026 16:11:04 +0200
Message-ID: <2vxz7bn5mv0n.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: mp67pmwyqnz7b7ysf9fstmsc9u1htqmz
X-Rspamd-Queue-Id: 72291C000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783519868-204901
X-HE-Meta: U2FsdGVkX198qm52ELzyTIl+pYSksbRL5yamlPBFkl2gSCxFRP4X/O+Z8FM9B19Vdy+6OlWy4gG1lZcZHAs4ktibbFJS/RqZOh/gxx6rb04i/P5EQpcooC1AFzmtQlUfQ1WklKK923M9CqGbeBKrp6AV9ptCNMy1ISVmagynxEM8vOlKO3dKxhR++T0CWHTfOeGD2nznTpfWmxw5TaBLoWnElcN0SUwcVFKpUeC+WJ0ujKL+TkUXlRBDOFn8c0dfcnBC2iLVScb0ilhjAw7Tk/Fx4zN0ZgtWS9TQKSlf0OH7QW2uyC4q5oPDCrq5oktEiVnsYkfAkKUxVgaUmpiPy0ulRacuGaPoR2D5gAtOER8Ra+PW2FJFqZq8X35mM4io/8jK7WIfGfhHy0wgHoK8FNzqqMzPNwlynIVxNBsApm0J9eBV2yzYwAbu2ZYfrJbZcFKED1lCIfnG0dn2gcYzmdXJ4wVuqmrqkBuxaOYbHPBBOOaUVULVPqOaWTYErPMrO90xq4m6eqHvFxgw65Xl3Rp2jR+H6iO8YHPcgw0giPUd8ht4DnrFn+Tn7IChQvGXHRgDT2dNpo6llXjorBVqzcP+eO9JMLqCC32kjdiyiKpN9JvgWdjgkYXcQYjAtHY0+G0EA3Dy4qj/Aeih8/E45wyzYpZU+oO7uZn5nLQXd4R2SP4jEQD2kwPUfCFxnEOf37Q5qqDIpDSHk6X2QkKu7eML9CqSqMFNe49stX3+iL/NCwm9qiD0KVOxiYHUQZCw394RF3Ym8ievtCV90Bb58SQJ1icMjmJwFOW1cl50DJ5JFErBb33XYEER5dwUYTJWio2eJ3ITfa8Qialwqu5qR/0RWa67z7Q9DDJ1mr1gqI/W50kYtvlyXgnKdOXdde9/fI4gllEB3KihSuxBB5SILjmP/1F2tEVpmRhCJfATM1cRCiAZKjpcx6oVJnc8xryJE4p4qjlbeActoPm1aaN
 WkMPaXEv
 ZsbjfWZyf5b4f61C3prQ7rkngZfc8/zFJPunV6iXUfldU/iGWOiV1vlKOg2oBOmFuETrYhH7y9WNwigqiXFVrhh2OcDQmDNyuNJRtEkbL/GTVNIPfbxbScY4ZX+AmXZV3KvkQi2Gxq8z1lxfUYuQehk/DHjaJIBNAqrm5JHo41xpOfCL8JoOfwcJ8/mQfCc+iEZv+NfyVjW4zRoiu8VQC9eDy/tuE+f6A0WPmS/MinimBzEBYwDNVWTTHiGqyiqaIMrRBIjrfZOlZ13a+alKGmvlHzBXi4FOxME94oZ7lcV0w81nTMnWHosp9PE9/pQLaftcY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03 2026, Pranjal Shrivastava wrote:

> This series is required for the ongoing effort to preserve DMA allocations
> across KHO [1]. It addresses a fundamental mismatch between the current KHO
> restoration logic and adds support for high-order buddy allocations.
>
> The Problem
> ===========
> The current KHO restore implementation treats all multi-page blocks as 
> split pages during restoration, i.e. kho_restore_pages() initializes 
> every 4KB page with a refcount of 1.
>
> However, many kernel subsystems, most notably the DMA allocator (via
> dma_alloc_coherent), frequently return high-order non-compound pages. 
> In this unsplit state, only the head page carries a refcount of 1, 
> while all tail pages have a reference count of 0.
>
> Consequently, when these contiguous but unsplit blocks are restored by 
> KHO in the new kernel, the forced refcount of 1 on tail pages causes some 
> trouble with the buddy allocator. Downstream of the eventual free path
> the __free_pages_prepare() [2] ends up calling page_expected_state() [3] 
> when is_check_pages_enabled() returns true (only when CONFIG_DEBUG_VM or
> debug_pagealloc=on).
>
> This detects the non-zero refcounts on tail pages [4] and incorrectly
> taints the kernel while leaking the pages in question.
>
> Proposed Solution
> =================
> This series introduces a "Page Type" field to the KHO ABI to track the
> refcount pattern of the preserved pages.
>
> 1. KHO detects the physical state (CONTIG vs SPLIT) during preservation
>    by peeking at the refcount of the second page in each buddy block.
>
> 2. The type bit is preserved in the high bits of the KHO radix tree key
>    (Bit 63) and stashed in page->private metadata during boot.

The KHO radix tree today only guarantees support for 53 bit wide keys.
Although in practice, on 4k pages the math works out to support 60 bit
wide keys in practice because we have 6 table levels.

Still, you can't preserve a key with the 63rd bit set. So how does your
code even work?

Also, if you do this, it comes with a side effect. It will increase the
memory usage of the radix tree, since now you have two branches of the
tree, one with the high bit set, and one without it. So that is more
intermediate table pages allocated.

>
> 3. kho_restore_page() applies the correct refcount pattern based on the
>    preserved metadata.

Why do you need to save the type of pages in KHO metadata? For example,
for pages or folios, we don't store any type information and leave it to
the caller choose the right API. So reserve-mem and kho vmalloc need
pages, they can call kho_{preserve,restore}_pages(), and memfd needs
folios so it can call kho_{preserve,restore}_folio(). The radix tree
itself does not hold the information. The caller knows what its memory
is supposed to be so it calls the right restore API.

So why can't we add a kho_{preserve,restore}_page_multi() (pick a better
name; we can argue about the naming later)? Then your driver knows it is
restoring DMA buffers so it can call kho_restore_page_multi(), and KHO
takes care of initializing the pages with the right refcounts.

You won't have to muck about with the ABI in that case.

>
> 4. A new helper, kho_split_preserved_pages(), is provided for subsystems
>    that may need to split memory after it has already been preserved.

Umm, that sounds scary... Why do you need to do that? What's the use
case? Why is the driver reconfiguring its memory after preservation? I
assume these are DMA buffers, so why do they suddenly look different?

And in either case, why does KHO need to do the split? Why can't the
driver unpreserve old preservation, then split the pages, and then
preserve the new ones?

>
> Considerations
> ==============
>
> 1. A primary goal of this approach is to prevent driver/subsystem code
>    from peeking into MM internals. Drivers should not need to understand
>    the distinction between head/tail pages or compound metadata. The KHO
>    core handles this internally.
>
> 2. To handle rare cases where a caller might wish to split a high-order 
>    block after preservation, we provide kho_split_preserved_pages().
>  
> 3. The callers must ensure that the split_page() doesn't race with
>    kho_preserve_pages for consistency.
>
> 4. Folios are always implicitly considered of the CONTIG type
>
> Thanks,
> Praan
>
> [1] https://lore.kernel.org/all/20260505002737.2213734-1-skhawaja@google.com/
> [2] https://elixir.bootlin.com/linux/v7.1.1/source/mm/page_alloc.c#L1370
> [3] https://elixir.bootlin.com/linux/v7.1.1/source/mm/page_alloc.c#L1027
> [4] https://elixir.bootlin.com/linux/v7.1.1/source/mm/page_alloc.c#L1034
>
> Pranjal Shrivastava (4):
>   kho: Introduce infrastructure to track preserved page types
>   kho: Detect preserved page types
>   kho: Implement page-aware refcount restoration
>   kho: Introduce kho_split_preserved_pages() helper
>
>  include/linux/kexec_handover.h     |   7 ++
>  include/linux/kho_radix_tree.h     |  17 +++-
>  kernel/liveupdate/kexec_handover.c | 144 +++++++++++++++++++++--------
>  3 files changed, 124 insertions(+), 44 deletions(-)
>
>
> base-commit: 87320be9f0d24fce67631b7eef919f0b79c3e45c

-- 
Regards,
Pratyush Yadav

