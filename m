Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FEF1CA5FE1
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 01:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38AEB6B0005; Sat, 17 Jan 2026 20:09:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30E286B0089; Sat, 17 Jan 2026 20:09:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 210B66B008A; Sat, 17 Jan 2026 20:09:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1178F6B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 20:09:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9555CB98A2
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 01:09:27 +0000 (UTC)
X-FDA: 84343301574.05.F979C00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id CF2EA80006
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 01:09:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZfJMiAml;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768698566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yxdhKraFFT7/QmqpZx802f+6Kex6Qh+Q/ATGgC7qhbw=;
	b=yRZBRUyn95mziqWr2boGH0mjcmw9AaBfy/bePGr7ujhL2MtErJ6lra5f419o+/IPaFFxt1
	iSQkhtYV9ZNq0L2W24zAVJbDjLOaMI4IHSUfRyj1+iQONngSjv7PMXRJrcUTeenZdFNtI6
	uBEPqclhMBiZsxRfscCL+yxcfDAosEQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZfJMiAml;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768698566; a=rsa-sha256;
	cv=none;
	b=wuhRKmZuluqdsjE9hQytSzyj9Yyl1PdVYvPtmDxZ03NmpiDu0cxGG7q/TNvf98VL3jncHm
	N7f03QytdDo83UVIARK6K5TYlplqLRTPpBk4Jz1Tt/KYt3SVSRFsUg4p9v8hD6B5WYnY52
	o8L6ZT8AxVNMtR7yhxNpz3i3CpmUdNU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D4267434BB;
	Sun, 18 Jan 2026 01:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7588AC4CEF7;
	Sun, 18 Jan 2026 01:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768698564;
	bh=TTkhei+cPeMgKIMcltIoko3GtbvF9Mp6tYUNOAa15ms=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZfJMiAmlDGllLVBJIBviMsDm7OBsxRoPAs2LV1hY2IfIOc4eb1DiIVufmycGG6+0E
	 Q4BZfbhB4e2gzuk7gjB2DxFs+zVWTIabOXqUtRYEHD/XxewYtEo03XLRGFyOiwJ1OG
	 HaDQdLlRTGlhYO+HOasOau8rHN45FcgZmvljfWSg=
Date: Sat, 17 Jan 2026 17:09:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>
Subject: Re: [PATCH v2] percpu: add basic double free check
Message-Id: <20260117170923.71d856cdc65505e1ea841ef2@linux-foundation.org>
In-Reply-To: <aWsa9SdO9kLJTfz4@snowbird>
References: <20260116023216.14515-1-dennis@kernel.org>
	<20260116191548.7df814c2a9eea1a9fa3c4cb5@linux-foundation.org>
	<aWsa9SdO9kLJTfz4@snowbird>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CF2EA80006
X-Stat-Signature: 7w9jj3ksuyxbu1b51zujxd6zuj3xkhwt
X-HE-Tag: 1768698565-51128
X-HE-Meta: U2FsdGVkX18ThFof3nVT4DEORJhUUyPyuMxk+WOtnEOzJl+EoRf2CvchXbV1EoCAj/kg4rs+1bqzufXKFaG5+nkC26q6/t1M4P30eC8jYtUUqDZqkffIMFfA0Ffx8qtaAt2eY5HX7dAPYz7FX4+EQfS7nZ5wBddQcDt+Z27TjiyZEIlY1oLy8nWolA8t3tu9rZYxy3Q73HgQngA3mLpMjRQEoBuVPViw4fA6ZNaTs78QTPVuXxG9qccu1LC2TCbKkEwM7d/1M/RWl8o34YK68xRcJtRzGma2EIMokJ4Jqxuj8QL9rK7iRz6Ys1iOmnKeZxsoJa8Pith6IthUXndFwCPsTTYsYuFqvwkp3/AymaER/xNjWnRv5lZQl8a/Gy3urNJy77xhussFg+uY31o+KIo0KZr+DPYZ+t5LHnOrwcCl+gMkG1So3NDfUUpWri1ngErYKxeU7akJ3abLh4IJ4u0VR7GYK7YmhzsqRx456L6QpfVMWhGBrrzCCvbqkFQgRRPniRAg9jz5rV3CFeyHJwRY6WEbA36f+MH+EHxFtUWq4BSM5tzWuNDwo5lC6wHR8Hh4JZ+bErF36CSsTO5Q+rjrXjujkXOkWAO+DhHFc7qzfae1fDqV0dyHdMYokeisC18X/g99sUOf81WzqarYvqDVUe6CRQeR7ddZvLKnK97k03N9P6bfMZ13CLz8GRzPfC/5EOTZmMA8rsA/ITwO4PjBNoU4Y8gTYER4qMdoDX49vvTfJJ6Qh/Ry4sMADUyCb1ZGBn+NWboVLiuKeXs95TBFIBtrmhhIHEnqA1W9jCaaSJm0AXixQ8GCz7ZOYj/4xtLiJbBJop0BXC6osN2OG4bIsFKm0Saa7HzfdMMyNid8ENTMGjL9hhgnp0+zsN6wscsogAbA00tEJXQJAhCas/AvV/A1QB/g2rLpoqgZq29XIlHs6KFDiiTm3+ahPHEE3jI5K+dGt+Rg0nj4CjK
 2ixdUiMi
 B6oUsshqg6M6wr8JjtqpqdbLMpWrALyiplaA/rscDND396ACC1y4TLXwBPzLLDL38Uz3LCiZnwqDE4yZ7elOFTQQgdYVPlDBnDpSnUpdYE+TUWr0Gr1nKT4GDi6kk2ONVmbG0YuAsNN2ibV8/wEtkII1d3InLzBVfvwkImMn67/Aa1k97Da+z3iimtSIx4IJ0Lx9EFGynEOwzFzUXXce79mrht5LM1UU0l6K9i+W/Ox+K4mv+D+LbIuTc32iz+pLC6IvuoXS1ibmc9Qk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Jan 2026 21:15:33 -0800 Dennis Zhou <dennis@kernel.org> wrote:

> On Fri, Jan 16, 2026 at 07:15:48PM -0800, Andrew Morton wrote:
> > On Thu, 15 Jan 2026 18:32:16 -0800 Dennis Zhou <dennis@kernel.org> wrote:
> > 
> > > This adds a basic double free check by validating the first bit of the
> > > allocation in alloc_map and bound_map are set. If the alloc_map bit is
> > > not set, then this means the area is currently unallocated. If the
> > > bound_map bit is not set, then we are not freeing from the beginning of
> > > the allocation.
> > > 
> > > This is a respin of [1] adding the requested changes from me and
> > > Christoph.
> > > 
> > > ...
> > >
> > > @@ -1276,18 +1277,24 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int alloc_bits,
> > >  static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
> > >  {
> > >  	struct pcpu_block_md *chunk_md = &chunk->chunk_md;
> > > +	int region_bits = pcpu_chunk_map_bits(chunk);
> > >  	int bit_off, bits, end, oslot, freed;
> > >  
> > >  	lockdep_assert_held(&pcpu_lock);
> > > -	pcpu_stats_area_dealloc(chunk);
> > >  
> > >  	oslot = pcpu_chunk_slot(chunk);
> > >  
> > >  	bit_off = off / PCPU_MIN_ALLOC_SIZE;
> > > +	if (unlikely(bit_off < 0 || bit_off >= region_bits))
> > > +		return 0;
> > 
> > This (which looks sensible) wasn't changelogged?
> > 
> 
> Sorry that's my fault. I can respin and add it if you'd like.

Yes please, I'm thinking a respin is needed anyway....

> > > @@ -2242,6 +2252,13 @@ void free_percpu(void __percpu *ptr)
> > >  
> > >  	spin_lock_irqsave(&pcpu_lock, flags);
> > >  	size = pcpu_free_area(chunk, off);
> > > +	if (size == 0) {
> > > +		spin_unlock_irqrestore(&pcpu_lock, flags);
> > > +
> > > +		if (__ratelimit(&_rs))
> > > +			WARN(1, "percpu double free or bad ptr\n");
> > 
> > Is ratelimiting really needed?  A WARN_ON_ONCE is enough to tell people
> > that this kernel is wrecked?
> > 
> 
> I can see running multiple tests that might give me additional debug /
> signal to how badly I screwed up. In production a WARN_ON_ONCE is
> definitely more than enough, but might as well offer the chance to try
> and trigger it more than once.

If this is happening at development-time then developer can turn that
into WARN_ON() or whatever.

I dunno, I do feel that WARN_ON_ONCE is sufficient but no strong
feelings.

> > > +		return;
> > > +	}
> > 
> > The patch does appear to do that which it set out to do.  But do we
> > want to do it?  Is there a history of callers double-freeing percpu
> > memory?  Was there some bug which would have been more rapidly and
> > easily solved had this change been in place?
> > 
> 
> Originally, Sebastian posted he ran into the issue where he double freed
> in [1] (linked in patch). Maybe he can elaborate how that bug was
> introduced.
> 
> Wrt do we want to do it - I think it doesn't hurt and makes it more
> explicit that something very wrong occurred. Percpu memory really 
> expects users to be good samaritans. If you do happen to accidentally
> double free without the warning, in a contrived case you could
> experience unexplained behavior for some time before crashing in a spot
> that would leave your head scratching. If anything I think there could
> be an argument to fail louder.
> 
> [1] https://lore.kernel.org/linux-mm/20250904143514.Yk6Ap-jy@linutronix.de/

Could you please get this justification into the changelog?  It's
pretty important - explain to the world why we feel that Linux needs
alteration and what benefit we're providing.


