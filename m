Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FAC8C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 07:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D0B86B0098; Fri, 18 Sep 2026 03:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A8E06B0099; Fri, 18 Sep 2026 03:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4971E6B009B; Fri, 18 Sep 2026 03:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 191D76B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:21:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 37B721C2BF7
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:21:36 +0000 (UTC)
X-FDA: 85226037792.25.7B8A4F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 87EE4A0009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:21:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WeEVSiUS;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789716094;
	b=pWpSZ+wN88fXOtF6U0lfC53sPSB8EaCM/kgfrK9k9UUQss4gYZnXB4UzsieiDaosePYQWZ
	kg6eWMcz6LHW2kJdnTg65PgNHd4no01xmpb5GhiJJhHadfcLMzGKDtbcmyuyk3QYWnihQT
	UnK80VkISzROX+gDRd7tt/RKOFTHAgQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WeEVSiUS;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789716094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xgfnuI9TWr6i2G+cWkoQuVzfkr0TXI4SYd1cnBio1Rw=;
	b=M2hj+1+161c5UBl7u2V/tq0AWds5LCDgnAeyUujDKyMUryXpPMv/XBXlrw4w/rIRXBvedb
	BRnzjADkzPcIyA4JaabGNLGqSGAJ3/t4feWVikz+NuGOVi/QvN18S4fhzciTedxLNfehi3
	A0GRBUzWubYYmBWkEDklk0+EPbds5Nc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7B0E40581;
	Fri, 18 Sep 2026 07:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA911F00893;
	Fri, 18 Sep 2026 07:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789716093;
	bh=xgfnuI9TWr6i2G+cWkoQuVzfkr0TXI4SYd1cnBio1Rw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WeEVSiUSVGNxGH7poJBl8BMLQzWHt9ePEhZ1af+Vmeklz5WOmx2pZK+2tAuVyDUth
	 RFzK63DnascmRaIu+z8a9jFjaVW/BdUdInE8B7B2DZuoJfYWJAng2wnwUvXuAlYyYj
	 FbCLQgbipfTvMZmP2D0LNfQ70XOyyPMw7rlh0/FxtHThXgjAYuX/y7lR/wdCS4XlfQ
	 vZTmEnhg22/fXwo7hNe/MLsU4tMkAxeTuIHKZPgJthixZaQga9qrLR3dBTl4ckpnKq
	 xskdp0ifpjBVI4o0AOOLsh1i8fSi4RlD0lvsxBOKv1jIBls5rwu667Q/0SIgeHQXnz
	 t3cL7hJReH9yg==
Date: Fri, 18 Sep 2026 10:21:21 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] docs/mm: describe set_memory() and set_direct_map() APIs
Message-ID: <aqzmcdr7ISpa9r8k@kernel.org>
References: <20260909-set-memory-docs-v1-1-6065d3f208e4@kernel.org>
 <2817ca55-cf04-4874-bed6-8408606e1a41@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2817ca55-cf04-4874-bed6-8408606e1a41@arm.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 87EE4A0009
X-Rspam-User: 
X-Stat-Signature: m1fgn6yxisgfsdhbrduasmamaarq3egk
X-HE-Tag: 1789716094-566487
X-HE-Meta: U2FsdGVkX19qqxjMXKtsUVJvGCco+8+BAhwWmfmR76XhD+D8pROqvvOhQeBUoLI6dJx2SyiqF6Qqv4f1BuZ0917rmoxZFbXkdrNA7npIygytzqolP2sZChu4TFPaO3/DKFP3LG84d+hKNs2D38GoSgpmDm3Sydww62TVWCpE/Y+d5s8EBrfIYpP4S6PwoRLgfton4yzg5BIm+b081o0G3rUa0RCtrFcqT5LvlHRkrqrrTaqkGjA7pDF8CZZY/3FGk1e8mSyy4G59qdy1sKUJOKkoT3Bf5QlOJX0D6ihIVFuanxoDVqipUMCzcvNn7BVVQiK0gRZkzGfLZr/OV3R9HErHvGhVCdGonFBveOh/828Uv9ZSkidKOOBs6LQiLGfldCAHTaI7I+myFB2zEnY1N/Y1QpSjGIRXu//yBXfjZAVlq6HGURMEqk4pofr98vgk0UZdJPSiUfeRJ2enxoFPkitFQezcnDlYfjAb/+EWxLcn98d2hR5xWN5bsZ/Unjs1QvknNny3aBjz8GYHHzPenYwVV9HvfQtYfHLQH59ZuyQoK5//9mRp6YElqU9JI2BLlWwoZksMESw9j6gEHTqIi2uHj5Ykwuwt0E+Ht12nU/En43zS8Jtu3lzcsBmx/5+0EVutWu/OIgYKSojRd5GsUMizMuzZWwvzg9THapU9MGGVQOkiOhWT6yWR6JjNypiwDXf8wNw3/yFr5gnPh2UjcXgu6ZGYws2dFZKIZ7to0LTZ/5irowGUllgaFYNdh5ieVLeAlP6xXaN0kFFGWkZUEvxLlNrTv7fAHELhfq6iZoiiM7uzpx1lDmmwELbvQriUMNMqjxOQONhLlZ5ZmoWV4cfYbCiw4QtqIKeKfKBws30eXiBw4v8AhqXmavJqbdNZH6XQF9Jesvq6db0Gmyl+q73KK94mXmpNBdRuR2f24HyDGusZokJ6gbDAWj4gnoW3pl+T3NKHMnjbymvTwQi
 TtHbwSlo
 NAc3DfbYsiQACjJA4fsrfZTzxxdj4UUQ3ocBN4QGA4OlLnq9Ygb/oGRYOY0iMXT1M6/VRZW9+6+P/luzwXfP7NEaU0fDXptb+55ELDPT8sd0MBZ+OWw4d377sXL7RQS/POipqbZr8m7SbG7rTDc1W6vFHH+qNKu/LL0cfmImABPbeylzl4R6Hrp7XT8EE+j7o+WKGlbvm4eGNyOY/CGwOo05VSJASNFux6ppQng6l37VOQgY1DOKI3En5iRvXPJzlG3OhjcK2phQ/rMdQ1FgYKjOAjr417oKEa4mcGQwiicjvpmRmCK6piuYfuX/MroX6fEp1+a5WWPwdYPjD7ufIbTzpXcY9aaY0/5xI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 08:44:17PM +0200, Kevin Brodsky wrote:
> On 09/09/2026 11:45, Mike Rapoport (Microsoft) wrote:
> > The set_memory() and set_direct_map() APIs change permissions of existing
> > kernel mappings, but their semantics are only described by the code, and
> > that code differs from architecture to architecture.
> >
> > Add Documentation/mm/kernel-page-tables.rst that briefly describes what the
> > kernel page tables consist of, defines the semantics both APIs have in
> > common, including the parts that are easy to get wrong, and lists the
> > differences between the architecture implementations.
> >
> > Add kernel-doc comments for the generic set_memory() and set_direct_map()
> > stubs and link them into Documentation/core-api/mm-api.rst.
> >
> > Assisted-by: copilot:claude-opus
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Thanks for doing this Mike, I wish there had been such a document when I
> started using those APIs!
> 
> Much of that document feels like an excruciating FIXME list... which is

It is :)

> exactly the state of set_memory/set_direct_map, and better to have it
> documented than letting every new user stumble upon the same gotchas.
> 
> Overall looks good to me, some minor comments below.
> 
> > [...]
> >
> > +Modifying the kernel page tables
> > +================================
> > +
> > +Except for the vmalloc area, the kernel page tables are mostly static. Still,
> > +there are cases when the permissions of existing kernel mappings have to be
> > +updated, for instance when a module is loaded and its text becomes read-only
> > +and executable, or when a page is temporarily removed from the direct map to
> > +reduce its exposure.
> > +
> > +There are two families of functions for this, both declared in
> > +`include/linux/set_memory.h`:
> > +
> > +* `set_memory_*()` change permissions of an arbitrary kernel mapping. They
> > +  take a kernel virtual address and the number of pages.
> > +
> > +* `set_direct_map_*()` change permissions of the direct map alias of a
> > +  `struct page`. They take a `struct page` pointer and the number of
> > +  pages.
> 
> "direct map alias of a struct page" is rather confusing, are we talking
> about the mapping of struct page itself?

How about "... permissions of the direct mapping of the page frame
represented by a struct page"?
 
> > +
> > +Architectures that implement `set_memory()` select `CONFIG_ARCH_HAS_SET_MEMORY`
> > +
> > +Architectures that implement `set_direct_map()` select
> > +`CONFIG_ARCH_HAS_SET_DIRECT_MAP`.
> > [...]
> >
> > +Architecture specific differences
> > +=================================
> > +
> > +The APIs are implemented by seven architectures and, beyond the common
> > +semantics described above, their behaviour differs in several respects.
> > +
> > +Which of the APIs are implemented:
> > +
> > +=========  =====================  =========================
> > +Arch       `ARCH_HAS_SET_MEMORY`  `ARCH_HAS_SET_DIRECT_MAP`
> > +=========  =====================  =========================
> > +arm        yes                    no
> > +arm64      yes                    yes
> > +loongarch  yes                    yes
> > +powerpc    yes                    no
> > +riscv      yes (MMU only)         yes (MMU only)
> > +s390       yes                    yes
> > +x86        yes                    yes
> > +=========  =====================  =========================
> > +
> > +Only set_memory_ro(), set_memory_rw(), set_memory_x() and set_memory_nx() are
> > +available everywhere, and even these are not universal: some architectures do
> > +not implement any of them for the direct map, and the architectures that may
> 
> "do not implement any of them for the direct map" feels ambiguous - I
> think what we really mean is that they reject direct map addresses, e.g.
> what arm64 does (only accept addresses to kernel VMAs)?

... some architectures restrict ranges that can be modified. For
instance arm64 rejects direct map addresses.
 
> > +run on hardware without an execute permission bit, like x86 and s390, silently
> > +skip the update of the executable bit there.
> > +
> > +set_memory_rox() has a generic implementation that calls set_memory_ro() and
> > +set_memory_x() in turn; PowerPC, s390 and x86 override it with a single-pass
> > +version.
> > +
> > +Making a mapping present or not present is spelled differently: set_memory_p()
> > +and set_memory_np() on x86 and PowerPC, set_memory_valid() on arm64 and arm.
> 
> I'm not sure we should even document set_memory_valid(). It doesn't at
> all behave like the other set_memory_* on amr64 (no check whatsoever, no
> handling of aliases) and is (fortunately) only used from arch code. I've
> been meaning to make its name scarier (__set_memory_valid?) for that reason.

Here it's an example of arch-private APIs, so I'd rather keep it. I'll
extend the intro sentence to make it more clear.
 
> > +
> > +The direct map and the kernel image are normally mapped with the largest
> > +possible pages, and changing the permissions of a single page inside such a
> > +mapping requires splitting it, which not every architecture can do.
> > +
> > +arm
> > +---
> > +
> > +* Does not implement `set_direct_map()`.
> > +* Provides set_memory_valid().
> > +* set_memory_ro(), set_memory_rw(), set_memory_x() and set_memory_nx() accept
> > +  only vmalloc and module addresses.
> > +* set_memory_valid() accepts any address.
> > +* Does not update mapping aliases.
> > +
> > +arm64
> > +-----
> > +
> > +* Provides set_memory_valid().
> > +* Provides the memory encryption helpers, which are effective only when the
> > +  kernel runs as a confidential guest.
> > +* set_memory_ro(), set_memory_rw(), set_memory_x() and set_memory_nx() accept
> > +  only vmalloc and module addresses:
> > +
> > +  - the range must fit in the VM area that contains its start
> > +  - the VM area must have `VM_ALLOC` set and `VM_ALLOW_HUGE_VMAP` clear
> > +
> > +* set_memory_valid() accepts any address.
> > +* The encryption helpers accept only the direct map addresses.
> 
> s/the//
> 
> > +* Propagates the read-only and the read-write changes to the direct map alias
> > +  when `rodata=full` is in effect.
> 
> That is, set_memory_<perms> propagate those changes.

Ack.

> 
> > +* Splits leaf mappings before the update on the hardware that supports it.
> > +  Without such support an update that covers a leaf entry only partially fails
> > +  with a WARN()ing and `-EINVAL`.
> 
> What does "partially fails" mean?  The splitting may be partial, but no
> permission change should occur.

Yes, the split may be partial and. I'll make it clearer.
 
> > +* The `set_direct_map()` functions return 0 without doing anything when the
> > +  direct map cannot be modified, see can_set_direct_map().
> > +* Skips the TLB flush in `set_memory()` when the update only turns an invalid
> > +  mapping into a valid one.
> > +* Does not flush TLB in `set_direct_map()`.
> > +
> > +LoongArch
> > +---------
> > +
> > +* Accepts only the addresses above the hardware window and silently returns
> > +  success for the rest, see `Direct map`_.
> > +* Does not update mapping aliases.
> > +* Does not split anything: a leaf entry is updated as a whole, which changes
> > +  the permissions of the entire large mapping.
> 
> Ouch!

I liked more their set_direct_map part :)
 
> > +* Flushes the TLB in `set_direct_map()`.
> > +
> > +x86
> > +---
> > +
> > +* Provides the largest set of operations on top of the common ones:
> > +
> > +  - the cache attribute helpers: set_memory_uc(), set_memory_wc(),
> > +    set_memory_wb()
> > +  - presence control: set_memory_np() and set_memory_p()
> > +  - set_memory_4k()
> > +  - set_memory_global() and set_memory_nonglobal()
> > +  - the array variants that operate on `struct page` arrays or arrays of
> > +    virtual addresses
> > +  - memory encryption: set_memory_encrypted() and set_memory_decrypted()
> > +
> > +* The `set_memory()` functions accept any mapped kernel address, including the
> > +  direct map, and silently succeed for the unmapped holes inside it.
> > +* Does nothing in set_memory_x() and set_memory_nx() when the CPU has no
> > +  execute permission bit.
> > +* Applies the change to the direct map alias and, for the kernel image, to the
> > +  high kernel mapping. The NX bit is never propagated, so that the direct map
> > +  stays non-executable.
> 
> Same as above, bettermake the subject explicit (set_memory()?).

Ack.
 
> - Kevin

-- 
Sincerely yours,
Mike.

