Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2D02C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:49:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E052B6B0126; Wed, 29 Jul 2026 10:49:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB51F6B0127; Wed, 29 Jul 2026 10:49:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAA6F6B0128; Wed, 29 Jul 2026 10:49:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A62B6B0126
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:49:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 327521A055D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:49:16 +0000 (UTC)
X-FDA: 85042097112.23.BFD73E1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 981004000A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:49:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=phZVmtHs;
	spf=pass (imf07.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785336554;
	b=a7etEn+AgteKKfhzpz7TcRIxOkAOFN/AYO7zCsqCD8bUdLXh+pHIl8w2XZ2t5652Ar7xsD
	q4TA/iMhgJR3Osr9EMJCvdt4TZblxlGSdP7mPzDQyIufHEn1Vhhss1OnhvlLX90VDQMHyR
	9DOzlLq8InIGlhUiI8DOu9eGRgDAyfg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=phZVmtHs;
	spf=pass (imf07.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785336554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHXgeatDUGs2QMlgNfa/xZvYZWtxm9XsdP0TtXFZ9dU=;
	b=7EcYm40njyCbk8sC1w2v+EF6J4IA+cYeeS4TLIu1IfjRfHpO2AZmFnDKxfc3bi0JH686Uo
	JQM1+qBgnawPBwV9Fj/BDxxRz/wg7YDRowJ0+lNrt8HHFWBEYWp3xO0gMTP0dqBN7rTGkd
	liP4tkOaM3qkc1UyAdd9cLtKysd99tI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aHXgeatDUGs2QMlgNfa/xZvYZWtxm9XsdP0TtXFZ9dU=; b=phZVmtHsb+NwjYJh2REWWSJasA
	gKTFDXBOtzlkaA7XVdUsm+D0+ycEQjQuvIUqUCq+LG2Old61PKZFX8+IV0PPREhF4iXWWfGFkpY7T
	liJNRMKKb2YY7kE4PaeHOF35Yy46QCF/C/P3TrN3ytYsYd6JRB674syS4MmqWXC8l2xUqor9j33T2
	HishjnvdxiLLaWCoGnW+Oevs1uMK6smmiXm3mXRhcFK5ob1hX8b3DE2t0gjq0otH8RIvfzzCvQ1Ro
	/jMH4odRDDzbZDzlEVRq/PdzUC4wahhQNEQ/p/l52/7X8hbUYoGKbEnHV15gYtBgyNmU13PKxw2cs
	cBD9Hlyg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp5aK-00000007mYk-0Rm3;
	Wed, 29 Jul 2026 14:48:40 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 7C3A9300882; Wed, 29 Jul 2026 16:48:38 +0200 (CEST)
Date: Wed, 29 Jul 2026 16:48:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH 3/3] x86/mm: Fix and document DEBUG_PAGEALLOC
Message-ID: <20260729144838.GM651302@noisy.programming.kicks-ass.net>
References: <20260729110807.797920433@infradead.org>
 <20260729111119.604452135@infradead.org>
 <amoKo2LoJvfndqHn@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amoKo2LoJvfndqHn@kernel.org>
X-Stat-Signature: 8ida34oxs95pu8azsffjsc1o9jrnds4f
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 981004000A
X-Rspam-User: 
X-HE-Tag: 1785336553-32546
X-HE-Meta: U2FsdGVkX1/qtzmKEl3Orn/6ch7u5dmHMnCbmzEwe/kogM12drGcxwXQ8AWCqngVyNXMyGxcJYut3wo83wwV4pfB7lhW2qgCwAyIdunRZjbWCj7UcC6VW75U7VblH99os9X1ELSQA3goPAl9S8BzUkJSkgkl/mfO3ep8AordSxhb+dOJ3HU7bVeEFArqjvxvZUHSclnNBhpSFVGU8KkVQE3qYsrRreL4yxubwfWl8ndxuoArMC5C5/PMSUrg03BgHrI0aCI845ol2uRaEhwNAmeTyNCuQRsfN6Na0qTJ6j5KR5M3nfEXgIWUnbtGE2ltf5251ASXju6OjOY+nQvJAwdZJayckaV1ydg818VQRr+WUPIoECHTwhAxIUE9M/mgGm/7QKzQszenqjrfukThK3IAKu0Xol79lRwFkSsVa0+k13K7BFzG7GG+/Zo/eAVPFgMIgqTIMJ9LgWBlZhD8UIDvIpAv2HGRZ2bkf21u1XOnhjvKIpvPf+txQECR6otxoiiIUtJFsD9mIY+fXpSonncJZOXAxUqqpRDBtmNQ2aJzlDT21OLRvr2kE/a6TBcRzHD4mLvpKtbDr9n+xWDBsh6hcrw9YxB6f5WGxVNEl/teExT7z4h+xa4BGsQpgcGVO0t6ZgUetrBUy4O3JKpYqziH2vDWILd+8TWrZ4LnTb/WD9HwBd9M81qS8YcYS+kcqOyYbRCdTdDv3Zgi845WhdmfS7M4PTxl8urDD4grjiqrx6AyBN6YWQInyLLbpQ7WzLivymBX/MDGR86ZaiBDXqTKJxD3ybRdvUVbcBsMP8Lp8nKuFevlCozFQJVHt+qUFNZkOHcL2ZKkZqrlEJ8hAJRMqYZUz0Q3sQJuuAwO+0/+5F0AeEsbXUXg12tzsawbRNxuehGEJP7G0mZ77UqTucouCicWeA6tBWrnRkyrJKf/7x+ErE7vm7VIomXaZ646WiIw/swG5G41AFUTK2I
 3G2/jKPY
 bZKmkKIAhkzNYCVdo/v7yaXT+IHNxB/gPY79HtdZ+QReprG0eViV50qI2d1tPPJsX9fRsbgrhQMjkL+08KwTjDvWkYw2oFOAPla8FtW3jMT8cxRwdPSgI2x20VrA6OCVFX/o+5/vhkezPpoEK1xHvANrbwAsmvdn4T2nQRPqMFA5kBh0geI6Fk562eqxLXiWb0gKRcehh3RPT1iwqGQGY3dPWlcxcTVi/tflMarz6ybb7obwUAtWUMj67wBAc7KYN3aza9JZXC6Rcpf1v74Tuwywo61Gx/lphbqpKtIQ1R4TQ39SUQjl9TX+0Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 05:13:55PM +0300, Mike Rapoport wrote:
> On Wed, Jul 29, 2026 at 01:08:10PM +0200, Peter Zijlstra wrote:
> > It turns out that commit 5fce67641a3e ("x86/mm/pat: Don't gate
> > cpa_lock on debug_pagealloc_enabled()") was a little too quick to
> > remove the debug_pagealloc exception for cpa_lock.
> > 
> > Notably __kernel_map_pages() is used by the page-allocator from any
> > context the page-allocator itself is used, which violates the cpa_lock
> > rules.
> > 
> > Re-instate the exception, except make it specific to the
> > __kernel_map_pages() such that any other cpa() usage is still fully
> > serialized by cpa_lock. Also note that since cpa() should not be used
> > on memory that isn't allocated, the page-allocator locking and cpa are
> > infact mutually exclusive and all cpa usage in fully serialized.
> > 
> > Add a comment explaining this and other 'funnies' surrounding
> > DEBUG_PAGEALLOC, including how pgd_lock is not affected and the TLB
> > trickery.
> > 
> > Fixes: 5fce67641a3e ("x86/mm/pat: Don't gate cpa_lock on debug_pagealloc_enabled()")
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> >
> > +	/*
> > +	 * DEBUG_PAGEALLOC is special; it is called from any context the
> > +	 * page-allocator is, which violates the normal cpa_lock locking
> > +	 * rules.
> > +	 *
> > +	 * However, since it is part of the page-allocator, things are still
> > +	 * properly serialized by the page-allocator locking and the fact that
> > +	 * when a page is owned by the page-allocator, it isn't owned by
> > +	 * anybody else. That is, you *SHOULD* not be calling cpa() on memory
> 
>                                      *SHOULD NOT* ?

Well yeah, d'0h.

> > +	 * that isn't allocated.
> > +	 *
> > +	 * Additionally, DEBUG_PAGEALLOC ensures (per probe_page_size_mask())
> > +	 * that the kernel mapping is 4k pages, therefore there are no large
> > +	 * pages to split/collapse.
> > +	 *
> > +	 * Furthermore, the page-allocator strictly manages pages that
> > +	 * *exist*, avoiding pgd_lock.
> > +	 *
> > +	 * Therefore, it is safe to not take cpa_lock.
> > +	 */
> > +	if (debug_pagealloc_enabled() && (cpa->flags & CPA_DEBUG_PAGEALLOC))
> > +		lock = false;
> > +
> >  	while (rempages) {
> >  		/*
> >  		 * Store the remaining nr of pages for the large page
> > @@ -2008,9 +2033,12 @@ static int __change_page_attr_set_clr(st
> >  		if (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))
> >  			cpa->numpages = 1;
> >  
> > -		spin_lock(&cpa_lock);
> > -		ret = __change_page_attr(cpa, primary);
> > -		spin_unlock(&cpa_lock);
> > +		if (lock) {
> > +			guard(spinlock)(&cpa_lock);
> > +			ret = __change_page_attr(cpa, primary);
> > +		} else {
> > +			ret = __change_page_attr(cpa, primary);
> > +		}
> 
> This does make DEBUG_PAGEALLOC exception more explicit *here*, but OTOH the
> spin_(un)lock(&cpa_lock) in split_large_page() becomes confusing.

So as the comment states, with DEBUG_PAGEALLOC there are no large pages,
so you should never hit split_large_page().

It is the same as pgd_lock; that isn't guarded anywhere either, and
works by the same reasons; DEBUG_PAGEALLOC isn't ever supposed to hit
those paths.

> I like my version with your comments added there more as it localizes the
> DEBUG_PAGEALLOC exception in the lock wrappers.

So I don't like removing cpa_lock entirely; it is still serializing cpa
usage, even though it isn't as critical on 4k only. Having cpa behave
significantly different for DEBUG_PAGEALLOC just seems like a very dodgy
situation.

And again, pdg_lock is in the same spot. It all works because the code
'magically' never hits the pgd_lock taking paths.

> >  		if (ret)
> >  			goto out;
> >  
> > @@ -2661,15 +2689,23 @@ void __kernel_map_pages(struct page *pag
> >  	 * and hence no memory allocations during large page split.
> >  	 */
> 
> I'd also return early and maybe even WARN if !debug_pagealloc_enabled(). 

The callsites be like:

	if (debug_pagealloc_enabled_static())
		__kernel_map_pages();


> >  	if (enable)
> > -		__set_pages_p(page, numpages);
> > +		__set_pages_p(page, numpages, CPA_DEBUG_PAGEALLOC);
> >  	else
> > -		__set_pages_np(page, numpages);
> > +		__set_pages_np(page, numpages, CPA_DEBUG_PAGEALLOC);

