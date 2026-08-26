Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED58BC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 05:07:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6970C6B0088; Wed, 26 Aug 2026 01:07:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 620D86B008A; Wed, 26 Aug 2026 01:07:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E7E96B008C; Wed, 26 Aug 2026 01:07:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29A7B6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:07:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2BD44402A5
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:07:42 +0000 (UTC)
X-FDA: 85142237964.10.312DED9
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5523D40008
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:07:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf01.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787720860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kYE6uo50ctYt2OqlztctQelhe0ySe0E5mvCBJ0+MHvc=;
	b=qP2H5BNMrOmOxqDjQaJa14MwADj1O3PCcTG6hFLMJD5YGfzOZwSRKVgT8ouxT4qZol2cCt
	ImLaAfk+GQynfYnbpqNeV8txu2D6n5j4uQfe2lhjACrkSxnmEB465OJaNNYLZsf+jIz3rh
	j2jSTZaYPRG5z5WOBH0mdJ6QA1LSsGs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf01.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787720860;
	b=c9ldKrGNs+yMJJdNDR3oQAUTJE2dO997VzmGNmI/juOnmZskQ6nPLDVxPFTEnMuYZGuwgI
	WGYFI6qu4NwY2DoEmiqVYc7FaZhiIDwqyWwLR0Ay1UON/HruhmC2ryl7Kh2HPqHIP2UnNY
	aYjIfVRTcTVpqVqZvuP2em6z879lT/A=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 21E1A68BFE; Wed, 26 Aug 2026 07:07:34 +0200 (CEST)
Date: Wed, 26 Aug 2026 07:07:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: Removing ->dirty_folio
Message-ID: <20260826050733.GB15122@lst.de>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org> <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com> <ao3y8TtEGjniZ_4f@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao3y8TtEGjniZ_4f@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: e8oxqo3uz48q1bphgkgp9gyqu8gwsjgs
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5523D40008
X-Rspam-User: 
X-HE-Tag: 1787720860-70483
X-HE-Meta: U2FsdGVkX19jpHDvJtn/Vl5+4SNsaJkx7dZjjyXrKwBtX4k31vqTrc5H2iD1VoMFifwKOJVn4VwYTdFTsvVd7uA0KBeNFVycTtUq9EAHAV8GmvrdZpRiZycLtSD55hqW5vMZZzGzzT8WtPe1TUkz8OCmdt0Yg68tZEBdBYY2gs1VQ0IifciKWTgSBr4nmL5mCVY7tXwliMMlDHrfPoo4cjh0vbS+DuAZ0nCqi4VzeqVVdTd8FjjV2TezWkSC5R7suokYF4L5uFpLR9F8uKsRc928gG4cTNPB7L0nydRnGuxOfhnR/S6/6myn9OJjlLHtn7TeFp2TiKo2hzgF2M3kKW5HVdrr+6AUjBgAKYNO4nVu8ZBkbweOrvMjlfFyqXf4fxa2Kg8ygp6BrOmDDqQ6HWZ1Fnp84suleQ1+mjaoBujhbM/V+S111oGewXa72L/xcWV+QaHk1q1TVchai1lTqT+i2nmn8m0alHf1M++yKOJ5FJobcbbREY6v1QZ8g4ifkVXN+m3F9L6XQw+tq0vysVfWsGsQcD0EZl4ylA142lu3g33b/nH3m7h+2lQSgauBY/psQs1eKWETdCbcW6vnGtm+e+oCmwrqjaWCmIFR8mVHg5YQD2Iq/yYUi1GrCNC8S4An04mKLT4O2NA78ILuWVQz+Z6rpNv9aI/xdPJYN9tfpYPrFMkfQc4NHM7jYcWmoabVs6rwn99jA0yKAvXMm0scNExb76hHd5xyLJjOZgZ2XZ+z/1xDEY/zQjlbk9NymO+HcqXXplavPLwIk09dl/nkG5qP2RXPmCKS6rGEIPEz97+tn+5X8rrwZpPuFFTwX77kkbFvRoYkPotuAKU2Prr6Rl09u8+LAJ/ugh9qSpYcKtPpzG5iKVefn+KjHYq21BPc6iYezC5u5fCmRofh08YTBlyjpmIPLN2s41+pKykMZw9oQDnCUC3rshfu1D6yHCjEJ52gLmNItDsbJNa
 vqOGCQRJ
 EVLKWDKNRpvg1QI3yJtE9Oph5M0//7dPwbjyJ33xlT/TUMMjR1SdjVrX7Nnyg/boDOdXwGB6n5HYVmd6Dvs8Vai3EQw7NMfBHZ/Vb8o6L2RssCmtLIEnXooe3WpOVmEtT2FUZU69JxG9xeKwbtS73XtrnkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[adding rdma/hmm folks]

On Tue, Aug 25, 2026 at 08:54:25PM +0100, Matthew Wilcox wrote:
> On Tue, Aug 25, 2026 at 09:35:57PM +0200, Jann Horn wrote:
> > > The problem is GUP.  We have no way to force the GUP caller to go
> > > through page_mkwrite again.  So instead we make the GUP caller call
> > > folio_mark_dirty_lock() which many just don't, and generally we get away
> > > with it.  But it's a bug, and a bad interface.
> > 
> > We currently have get_user_pages*() and pin_user_pages*(), where only
> > the pin_*() version is properly usable for write access, right? And
> > dropping such pins should always go through unpin_*() helpers?
> 
> Right.  I'm stuffing cheese into my ears and pretending that people
> aren't calling get_user_pages() to do write accesses.  We should be
> able to use this work to flush out the last remaining ones -- we
> can put in various assertions that folios should still be dirty where
> we currently have folio_mark_dirty() calls.

Last time I checked quite a few places still did.  Including various
network file system O_DIRECT implementations (some got fixed, and
for NFS a series is outstanding) and some really odd looking networking
code.

I wish we could somehow force them to stop doing that, but I can't
think of any. 

> Yes.  I think the only alternative would be storing a checksum of the
> contents of the folio and seeing if it changed since the last write.
> As you say, this is userspace doing something incredibly odd (I really
> don't think people make a habit of mmap()ing files shared writable and
> then giving RDMA longterm write accesses to them.  Not on machines with
> poor quality flash storage anyway).
> 
> Or we could say "these pages only get written back on requested fsync()
> rather than periodically".

Take one step back.  For regular pins we should be able to just wait for
them given that they are by definition short lived, where short lived
is defined by typical I/O latency for a wide range of "typical".
We'll need the right helpers from the MM for that, and make sure
we have a good way to debug file system hangs caused by incorrect
use of the pinning, but all that is a solvable problem.
Splitting read vs write pincounts would be really helpful to reduce
the overhead of that.

The interesting case is FOLL_LONGTERM, as it can pin I/O for a much
longer time.  And that also means IFF the user of FOLL_LONGTERM actually
wants to be able to persist data on a shared mmap, it has to manually
dirty folios one or more times during the FOLL_LONGTERM pin, because
otherwise the file system would never know there is dirty data.
The set_page_dirty call in ib_umem_odp_unmap_dma_pages is an example
for that.

So what we'll need is:

 - a way for the file system to know if a dma pin on a folio is for a
   short-term writable pin vs everything else.
 - for the short term writable pin wait for it for data integrity syncs,
   or otherwise just skip it.
 - for FOLL_LONGTERM users we need an interface to (re-dirty) folios
   while the long term pin persists.  This also needs a way for the
   file system to reserve space.  Either as a rolling / bank switched
   reservation for the whole life time of the mapping (although for
   large mappings this might use up a lot of space), or to do that
   ahead of whatever triggers the dirtying.
   And maybe a way for file systems (or vm ops) to reject long
   term writable pins if they don't want to deal with all this.

