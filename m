Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B2DDC4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 14:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A8CD6B0095; Sat, 18 Jul 2026 10:28:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 280456B0099; Sat, 18 Jul 2026 10:28:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD706B009D; Sat, 18 Jul 2026 10:28:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9D5B6B0099
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 10:28:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4EE664036D
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 14:28:48 +0000 (UTC)
X-FDA: 85002128736.28.FCE3BCA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B045B1A0002
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 14:28:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e2Uj07DO;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784384926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cN4SFoY/tZY29HdeZMDLAXwiTzxCSnJElqCY0zELtGs=;
	b=PfNz7F3911OVLOFb15OtXfG01ZYI856ChQ/nKK9m/Lpl+0fmComjv9AkejaYevXTUKbpdZ
	mSj0Abz+IT+crzdMkiON/nkn6vrEzqr1COD+dE6msF18+Wz6qgi9hM66s/4kG3H/Gb2hpf
	OjoUPMg/jPYbi5Nb8opgtI6MgmWT1v0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e2Uj07DO;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784384926;
	b=anvUslQ4SQB7YVVHJHCHjFtdZ7ZHqNsViO+u2S5bC2sMSR3Zg6/pU8fCAL35Y4YyCrQBSG
	tp3AwzEmbqb+NCJQBKesmoDtavnVufZo56b16MKchNGH9TibsZ8ulH9aiTVypO4+J7g3M5
	Xnf453/viJGv9LftupKpMYIFHaySUA8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2864B60018;
	Sat, 18 Jul 2026 14:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7DD1F000E9;
	Sat, 18 Jul 2026 14:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784384925;
	bh=cN4SFoY/tZY29HdeZMDLAXwiTzxCSnJElqCY0zELtGs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e2Uj07DOjH/TQ82jaKLRrQ0tj27mcvpntC4p3PJATIngsRHYlFU3X3lofLYviPBbs
	 u5SyLmqiWfPcoz5tpuccs2N0KK12Od0OysNEMnnoYf6Ykh6Sy5OFYiUIoom5d8w5U1
	 GUGdRFnntCxA4dVhZGQx7NjUHixCXMFqML9lUABHYf1QbdQYTkuwl6x0rdGQOsQoN+
	 MrdDSuVD6+gdakknmWXozFPIxdXvFolH0Ka3+st04WOm7vqEifB/e5avrrzrslKj/h
	 jZXYC+c+KKbCZ+E03rv7Y58wu4KoW0RstJn2j3yEL01YMhErUicAUA+uvQy8a78y/K
	 pl0KFFOHijohQ==
Date: Sat, 18 Jul 2026 15:28:25 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, David Carlier <devnexen@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	"Denis V. Lunev" <den@virtuozzo.com>, stable@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes v5 3/5] x86/mm/pat: acquire init_mm read lock
 on attribute change to avoid UAF
Message-ID: <aluLf-2NcDKylRP_@lucifer>
References: <20260717-series-vmap-race-fix-v5-0-606a0ac6d3e5@kernel.org>
 <20260717-series-vmap-race-fix-v5-3-606a0ac6d3e5@kernel.org>
 <altbeuTZ0HCz_7HS@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <altbeuTZ0HCz_7HS@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B045B1A0002
X-Stat-Signature: ce6oy3h547kih67h9fznup58p44bfzej
X-HE-Tag: 1784384926-387624
X-HE-Meta: U2FsdGVkX1+CcsgbGtFm+1mzhaMpTKv6Cc19+X+2Mseo1QwylkNp2j5FwMvKjuCN7jVYgZG3yPvr1i5G0ps3XCR3MVQExnagO76klRSJI2XcYMdgMgkMZkEpbYs81NQT3keCF+Ji+GWNp/aK6395Y4a+G+aKiF+NCQk+xQEf/lmB0/TRsnjL8y8xEiOySDY52frBJ1T3LtHCBSLG+G5quvVxaVXcPdVRqj72+X0kR4KbaAbVBBCMkC0qgF5Xon0zbG5q4UKnV/xq2Y1aN+1BRtbr1hPoL1oclgqBmz0M5RIAtuctBag20QxKPuHWRoCACoR8uWj1l3issu/HRgqx8aFTxfTF+L+a67ZSpFae+h4RuRJ3O/KO06Lk5IDON9ZcT8st/WCtRzcluF3Hhkgx9uGvMFx58Su4ZbPJshsiAihuISTlUXY58nXz1AZUNWx9thZMn/ZgUD0FFxoMzWgZC60jyzhTBkzKRe40PgiPYwRq+4vDff+YxPmzVEtgC34In8f6yJdseW/Q00/32Y1BFzeIkdfToRTDbDD9iCcFTbCMoyFqkWSPKzCgQkPfjbsfwiFbPocZGSSA9sNXt2f0Fg/xcYNvszUt0JUudTeyhIMw7K8R7C/DFm4LLlw5V5sO+KmbPpYR/3KCwbv2yvgOdEpmhcVDx/EN7TpFC82qYPSntAHKQ4QlSs+9s5fX24z4sc/59h/IK7A4B58oTpUZTfGcMiA68xbgL8diHIar5t1M1P/coUKbhWLuq/IffMrbjuCtTDVuEM33I5IM4CNpjoGgbg5L04UF6uhZIdgDX+XrHm4XWpR1q8hZYXcNVr+XEROwm+E7OppMoeyzvBlzvyU6D9xsBeegyyF2eQ6TktrMPzjO829T6wmvdYpgcTD+4+xq0VII0XbU8z9fCb3LJqxII/EwYQBkdYEHSrIDyaorDXikXngJ7ZszQtxS8dAItO2JG97qZ1WrDV9pzGE
 HlrSZgTz
 +8w7eBQhlCqr1czWOG9pj5McW1+uRHBlUQggPYqbMJKPQo6DrTygnRGMC0pF9Yu0dzRb/aw6z+N5eGSrHB1w6RM7P7+0sT+DVRx2+udVGyQxNSR9ihJzU88N2YBJ9/uztqGbapcup665gX4dXvd26/nv+PUvpfYv4lAQC7p6NS7GkBmqW/h7jLmhgIWfDKl9C5X6jtFr4mBdX3f3pJPMyzPhlepk54eIOeFd8ukn2ebmZm6C7fES5VUaw8qgcj7iOLYAbJHuGrxuC+GVSrOgb0RpHG20b853RIhUNe4J9Iojd9PFgq6+qCxnPqK49JDATW43SRirLnBo/fKJDGyvCj8vPWRfXGjy6aI3t4nVb0Mxm4onBB9P6UHkfpE/kU1XrR04B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 18, 2026 at 01:54:50PM +0300, Mike Rapoport wrote:
> On Fri, Jul 17, 2026 at 06:30:09PM +0100, Lorenzo Stoakes (ARM) wrote:
> > A previous commit protected us against races between ptdump and CPA
> > collapse, however one still exists between attribute changes and collapse
> > as reported by Denis V. Lunev (linked).
> >
> > When an attribute change arises, a lockless page table walker obtains a PTE
> > entry, which is later written to via set_pte_atomic():
> >
> > ...
> > -> change_page_attr_set_clr()
> > -> __change_page_attr_set_clr()
> > -> __change_page_attr()
> > 	-> _lookup_address_cpa()
> > 	-> lookup_address_in_pgd_attr()
> > 	-> [ lockless page table walker ]
> > -> set_pte_atomic()
> >
> > There is nothing preventing a concurrent CPA collapse which can free the
> > PTE that was retrieved here, resulting in a use-after-free.
> >
> > With the mmap write lock taken on init_mm over CPA collapse, we can now
> > resolve this race by acquiring an mmap read lock on init_mm over
> > __change_page_attr_set_clr().
> >
> > This locks across the whole operation over which the walk and the PTE entry
> > write occurs, solving the race.
> >
> > It is safe to do this here, as no spinlocks are held upon entry to
> > __change_page_attr_set_clr().
> >
> > The CPA_COLLAPSE flag is only set by set_memory_rox(), which exclusively
> > operates upon vmalloc ranges, and on x86 only within the module mapping
> > space.
> >
> > This is important, because some callers directly invoke
> > __change_page_attr_set_clr(), bypassing this lock. However, none of these
> > operate within the module mapping space.
> >
> > * cpa_process_alias() - a recursive helper called by
> >   __change_page_attr_set_clr().
> > * __set_memory_enc_pgtable() - operates on the direct mapping and (via
> >   __vmbus_establish_gpadl()) the vmalloc mapping space.
> > * __set_pages_[n]p() - called by set_direct_map_[invalid, default,
> >   valid]_noflush(), __kernel_map_pages() - operates on the direct map.
> > * kernel_[un]map_pages_in_pgd() - operates on EFI ranges.
> >
> > This work is based upon Denis V. Lunev's excellent analysis of the bug with
> > gratitude.
> >
> > Link: https://lore.kernel.org/all/20260626163213.2284080-1-den@openvz.org/
> > Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  arch/x86/mm/pat/set_memory.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> > index d1e63f7d267f..301fb9e77d91 100644
> > --- a/arch/x86/mm/pat/set_memory.c
> > +++ b/arch/x86/mm/pat/set_memory.c
> > @@ -2122,7 +2122,9 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
> >  	cpa.curpage = 0;
> >  	cpa.force_split = force_split;
> >
> > -	ret = __change_page_attr_set_clr(&cpa, 1);
> > +	/* Avoid race with concurrent CPA collapse. */
> > +	scoped_guard(mmap_read_lock, &init_mm)
> > +		ret = __change_page_attr_set_clr(&cpa, 1);
>
> There's a small issue with this. debug_pagealloc_unmap_pages() ends up here
> and since it's called from __free_pages() it can be in an atomic context.

Not the case - the callstack is:

debug_pagealloc_unmap_pages()
-> __kernel_map_pages()
-> __set_pages_[n]p()
-> __change_page_attr_set_clr()

So it calls __change_page_attr_set_clr() not change_page_addr_set_clr()
and doesn't hit this code.

As per the commit msg, it (and all the other bare
__change_page_attr_set_clr() callers) do not hit ranges that can be
collapsed so the race doesn't exist there.

Also the CPA_NO_CHECK_ALIAS flag is set, meaning there's no weird aliasing
recursion via cpa_process_alias() (which in any case, also calls
__change_page_attr_set_clr() directly anyway).

>
> >
> >  	/*
> >  	 * Check whether we really changed something:
> >
> > --
> > 2.55.0
> >
>
> --
> Sincerely yours,
> Mike.

Thanks, Lorenzo

