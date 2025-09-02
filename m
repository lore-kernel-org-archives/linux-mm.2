Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97A8ECA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 19:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E04718E000D; Tue,  2 Sep 2025 15:52:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDBE78E0001; Tue,  2 Sep 2025 15:52:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18618E000D; Tue,  2 Sep 2025 15:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB2938E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:52:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6707811999A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:52:48 +0000 (UTC)
X-FDA: 83845358016.23.39FC70E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 88F4C80004
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:52:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=p+WgA7Cv
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756842766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rlojIfTuIlTc8Wo9xot7aej39JoIWDQCWyib0x3FC3w=;
	b=Nu4SGicvnAQUXAur06BUT+QEIo7w3OTw6EZTg3aQ6IjUuDKSdW8P2HabWjMDQwYtsKmpi2
	he9K3mwbc0VQ5zSefB1cVAcSV75tOh16DwA91/orOhq1LCNHY02sBvjRGvKl9yKLSyERB/
	uclM5SX/JXcaRqeBNhX4H+LgdxbR4NU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=p+WgA7Cv;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756842766; a=rsa-sha256;
	cv=none;
	b=261BGVfFxWVHldCm85M7dZL+yg/CMJI8qNGY1/uW3CnDon/I5zHvBtGkGcGmpVXNXnEWkV
	gbUkr8qDQY2woKg30y62DgL6/Ew2UQMEiTWY10dvjSsY1ou39xyaxWdIsWwy+/1w+A5+Dy
	T80vwsyQpaMEsdm1Ajp7bibd6QPBrw8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rlojIfTuIlTc8Wo9xot7aej39JoIWDQCWyib0x3FC3w=; b=p+WgA7CvNZSwF15FR4yWHDSRY5
	tyFVdG1asANnYNi2TkrNonIZwLmemLm+gZmA9Om8bmOO8pTsSrp0yUXdQAJdM33GAhUsGEPjABq2x
	N7c+4+0eV5eRomQ7xDtjslFzACXWtLPttzqpUNyZdAzvO4F4nxjRU5JpipP8aKEeALU5gQC66VyDh
	BOZXLPwflxiYWHMg4NB51KnENKgKOzm3nQbV1CPivSJzIlt4qeO50NHb5WB4fQbBzIv53VEvcfCH6
	mGhgyg53gHT1DkIsg4wO0PJgcmr8avjV5jN2qOV70CVDdxT04wfCf0v6F9/jVLNAXxSesaikZHlrR
	bcRbIDiw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1utX3c-0000000ArnQ-16hV;
	Tue, 02 Sep 2025 19:52:44 +0000
Date: Tue, 2 Sep 2025 20:52:44 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Hildenbrand <david@redhat.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: tag kernel stack pages
Message-ID: <aLdLDEW2d3hK4gUV@casper.infradead.org>
References: <20250820202029.1909925-1-vishal.moola@gmail.com>
 <96148baf-f008-449b-988b-ea4f07d18528@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96148baf-f008-449b-988b-ea4f07d18528@redhat.com>
X-Rspamd-Queue-Id: 88F4C80004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: g1tmd1o5muhmb4eao8zsqf3y7zj3mgbu
X-HE-Tag: 1756842766-550164
X-HE-Meta: U2FsdGVkX19VbsUh7BEKLJQoOHZQOTvaAXw+TqQWZRyVxvxoPkyH9gWBUPlo0YbM6YOssm69dkGehgzHcEqTBrNEpXRM5CK4wTaQh6d+z+hY/zQsCh6EkX6oywL6RJpHHroHO+PxK1Xj0rgOKXGPXFfnsYoGWoLbvqbSgWhpkwKLROMNi57v1fdCklZ9YFiM4CORN2FINNL7wR6jX53MePf9azKuEXQ3re9n5UkP/9gEQE1NRT3myDIM2csGbKnXcVleW/kPTS/vc1ouLV0ka2spRZDAW08s5zfrpcge9mBTSgDy/+jcn6m9TGmkgctu6npIVzCkvPr5yZPrVRIRIOCHXlyPLOyElyJRVszNhFkdoPScNpW8746w0CSAbjvSw2u1W7Yx20hz9ChNbz3tclfuSG8xPAa32iZ1JqG1MJVYX5trTYSGOAK6dvpg3XDL55Eoq844jBXDYOGmZBYf3/5UypWFJFCRACg0UK0NfI0T4FNJMZfxgh+m/4qupZIBKRid14LA6o+ZmNVas2TKNISjIPzbrLovPEZ0mQGHtF5e98+OyQ0QyMo4/bOQsUTubS4ZaudmwdAXPAQYfEKH/Y7Yh2cnCJiNK+6g3RFTdbYKKTj4JQvNcfkKCAKXvLyPq6DzeRVScA7cKsHrTUJDYVi1oKPYD/vNY4PvQFC3vHb8xHqEyjSPLLAlrouqdkoSbqAicXTdJHfFPLQDgZ9kIOLt4zA7TH4TVLDFNyklOHFijxqr7GdShhknyoBGU3NOMLsQk6gHW2j76DquqNuCNwDAdFTQoNZCwXB3rHrpoZETRXUk24ZMBtUHt7IFVS1m2i8XBFTlyP9KOXCiLvoZR4wi3uiuJpaT77TNxFmPKDlMIjzi4x/8HAu+sp/XMOze2vuEsoU5qyr3/iNShJW3/34WuFWjN1R1VZ44G24IKxaP4rbg9pPtsGvnl/tKx7Zcsq7Tkrubd2w/xsMiV9P
 PVW6xgvt
 VTWypbG3f3gmVkKylbndQ8SUpeAdWEfYtGEUV40HtoW53vcuw5MfgykggJAYIaFq0DwpZ9y+EBCgBkYAv7MBzpbgBT3MTXEgV37cQnfNcj+Hey3Y+PHmCHuULI2VUTrEvnf+iv+5bWkIFMk0Nz7KcszWxuCFe4p8vZn7FZzCRzSf3vmBU5mlPCFzIbO9F83Ir5o/owYL1fk4Fgve937b9jlfpOLLvI/0vMA5YQ91hgHOpF54VbYjeOXvbewGehYOwMe/wH6r84xfz6yB6ZWahcp0vUPBRXDWmNalZLbQa/L5C8I8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 02:44:31PM +0200, David Hildenbrand wrote:
> On 20.08.25 22:20, Vishal Moola (Oracle) wrote:
> > Currently, we have no way to distinguish a kernel stack page from an
> > unidentified page. Being able to track this information can be
> > beneficial for optimizing kernel memory usage (i.e. analyzing
> > fragmentation, location etc.). Knowing a page is being used for a kernel
> > stack gives us more insight about pages that are certainly immovable and
> > important to kernel functionality.
> 
> It's a very niche use case. Anything that's not clearly a folio or a special
> movable_ops page is certainly immovable. So we can identify pretty reliable
> what's movable and what's not.
> 
> Happy to learn how you would want to use that knowledge to reduce
> fragmentation. :)
> 
> So this reads a bit hand-wavy.

I have a theory that we should always be attempting to do aligned
allocations if we can, falling back to individual allocations if
we can't.  This is an attempt to gather some data to inform us whether
that theory is true, and to help us measure whether any effort we
take to improve that situation is effective.

Eyeballing the output of tools/testing/page-types certainly lends
some credence to this.  On x86-64 with its 16KiB stacks and 4KiB
page size, we often see four consecutive pages allocated as type
KernelStack, and as you'd expect only about 25% of the time are they
aligned to a 16KiB boundary.  That is, at least 75% of the time they
prevent _two_ order-2 pages from being available.

As you say, they're not movable.  I'm not sure if it makes sense to
go to the effort of making them movable; it'd require interacting
with the scheduler (to prevent the task we're relocating from
being scheduled), and I don't think the realtime people would be
terribly keen on that idea.  So that isn't one of the ideas we
have on the table for improving matters.

Ideas we have been batting around:

 - Have kernel stacks try to do an order-N allocation and vmap()
   the result, fall back to current implementation
 - Have vmalloc try to do an order-N allocation, fall back down the
   orders on failure to allocate
 - Change the alloc_bulk implementation to do the order-N allocation
   and fall back

I'm sure other possibilities also exist.

> staring at [1], we allocate from vmalloc, so I would assume that these will
> be vmalloc-typed pages in the future and we cannot change the type later.
> 
> [1] https://kernelnewbies.org/MatthewWilcox/Memdescs

I see the vmalloc subtype as being a "we don't know any better" type.
We could allocate another subtype of type 0 to mean "kernel stacks"
and have it be implicit that kernel stacks are allocated from vmalloc.
This would probably require that we have a vmalloc interface that lets us
specify a subtype, which I think is probably something we'd want anyway.

I think it's fine to say "This doesn't add enough value to merge it
upstream".  I will note one minor advantage which is that typing these
pages as PGTY_kstack today prevents them from being inadvertently mapped
to userspace (whether by malicious code or innocent bug).

