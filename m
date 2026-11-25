Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23393606A327
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 08:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EFAB6B0949; Wed, 25 Nov 2026 03:58:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29FD06B094B; Wed, 25 Nov 2026 03:58:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B6806B094C; Wed, 25 Nov 2026 03:58:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA1166B0949
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:58:22 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7020D1C498E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:58:22 +0000 (UTC)
X-FDA: 85473040044.23.5DC746B
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9026940008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:58:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795597100;
	b=toT7O7YdJ1E0oYHdFLFPHoS6+YQ1zeFX6bXDSSvexk2M04PHpYZTuBjBIXsICfe9rhtXzE
	bc0BovnlilwQTkvigg2W0x7sZSSSSGTxNAuvbMPnQ1uA2Bia9hGcXoHBUsjb9i7mDblUzu
	5kqLanjQR3ManM7uavGN2cmOnMNOO44=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795597100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h7diYLkdZr5W6qtuW1AtNoHbv2j3QI0GxWcbm+u+GGY=;
	b=vo/IH+eqeN8SI6eD9XfDTPOi9Lkik0YOG+D5aavBr2yjYt73gj2m+svnKQ56pBB1UvJcsF
	USZeRt2krfs+sFzA2bb/W9JBwZK5o+bWSWPIQpDvX8yWtizptNlmBir1Qj73PTQxR1TpdU
	cv3gCoAygcaFkCFCpF55Ju4w+0eM2x0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C1D7A6732A; Wed, 25 Nov 2026 09:58:14 +0100 (CET)
Date: Wed, 25 Nov 2026 09:58:14 +0100
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
Message-ID: <20261125085814.GA24887@lst.de>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org> <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com> <ao3y8TtEGjniZ_4f@casper.infradead.org> <20260826050733.GB15122@lst.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826050733.GB15122@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 9026940008
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Stat-Signature: htbb53kcyd97nx7nsyxxyx7zsa19ess3
X-HE-Tag: 1795597100-878549
X-HE-Meta: U2FsdGVkX19ldfM8AohoT2NKAAIiQs4SS9kFpj56w7M3HmWG76pzI02mChRz0nxoLI/N6E0PuS9Oth3o3qTf2GJoZDZNQMY51PG3keu5bKnSc5iFLv6UdFnpEt/jzABTa7eMm2jOYWDKsJ0pmV7eJjoI6+Bm02TpTbEJiRxqJp617axQvEPv5HnTtNCVF3gabYF9zFd1wcNFxZgzBXF5Z9YW8DRGMpHw6DHqzVYZujzhPAj23KegNRMmccss1XuRo2l9jmx4uSs0kc7laWRliDgLghd3TlDymgG4V7aThdjrY1JWdaFAXYmZihBpaG5+Lt/nVUW9U9UStbpo92tAbAqE/GwO9x9NAxGww81V0jQle9kKzOVl7OKGB+7wkUp9Tw/oeSQZ1JhVLQpmUGC7LEqi3z5x1Qpq3BbnvuytCGjOZtwBGm47OCXmKi0E6GHHL/2JuuZPsA0hdq8PKHc1uj+xxzPvOk4lHnTvahUWUvtl+FrRXTXVnCAvVK8aziE7aK8h4+vfNLp9n0xZs0HPob1VKb9qAgsNFI+AbXVfNjvfcGeoMFawpSjL43+OtCtdcgMInLtptRxGRu74T77HBbw2RK+r2sIWuDUof7B7HaKoI/59chw81ON9g0sbhM4qEQgb8qo1f91/0yTj4FWqYadYE0UF6svyBFg2WQF0ViLuH//n3R3/cNiYfn+8dcGhvoLi5DVxFpEALg/kfiCtDFvXjnRuD8eGvcrj6AHk7Rqp04Il1JKgkSvpE38+pFC3oODuHDbEWY/VedbTMDuRZeU5oii/EyqooGNXzWax1t5TEqjIxns6Oe8txdZK1Msk0esJlP6f/SyVHOJHduxSUC9ZAPpQdDfB49KWcRnUBKAlZjbWLoNgMGdcTgVZZWE4cM7loj++bE699t58VW8zHMYSN/Oxk60qY9J9c2oZjeYue30YDl//Z5KZQAee26GBVNhzzUGqjGNos1T4dYh
 m/vWD4JP
 66UJ1x554kQAf7N6CkBjlN0uMJObolJHsqyNqCg6vVxdgW5DHscZTriqX/lZ1Y3j2MQ6hFJzLNcYiUSoUUfwvK24IxdV/cPSP7dTkeqeXY9/XysuSWzB62Ftg/MyFRtCgxAkhd4HHwaZ0+Zy2GCF0EDCw6vLcDBZMQr7hqR7NzPIb1t4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Bringing this back as we're having another slightly discussion of
GUP semantics right now and this discussion stopped before it really
started.

Any comments on my idea in here?  If someone on the mm side could
come up with a way to figure out if a folio is pinned longterm or
not and we get a pre-pin method into the fs I could start looking
into the fs and writeback side of this.

On Wed, Aug 26, 2026 at 07:07:33AM +0200, Christoph Hellwig wrote:
> [adding rdma/hmm folks]
> 
> On Tue, Aug 25, 2026 at 08:54:25PM +0100, Matthew Wilcox wrote:
> > On Tue, Aug 25, 2026 at 09:35:57PM +0200, Jann Horn wrote:
> > > > The problem is GUP.  We have no way to force the GUP caller to go
> > > > through page_mkwrite again.  So instead we make the GUP caller call
> > > > folio_mark_dirty_lock() which many just don't, and generally we get away
> > > > with it.  But it's a bug, and a bad interface.
> > > 
> > > We currently have get_user_pages*() and pin_user_pages*(), where only
> > > the pin_*() version is properly usable for write access, right? And
> > > dropping such pins should always go through unpin_*() helpers?
> > 
> > Right.  I'm stuffing cheese into my ears and pretending that people
> > aren't calling get_user_pages() to do write accesses.  We should be
> > able to use this work to flush out the last remaining ones -- we
> > can put in various assertions that folios should still be dirty where
> > we currently have folio_mark_dirty() calls.
> 
> Last time I checked quite a few places still did.  Including various
> network file system O_DIRECT implementations (some got fixed, and
> for NFS a series is outstanding) and some really odd looking networking
> code.
> 
> I wish we could somehow force them to stop doing that, but I can't
> think of any. 
> 
> > Yes.  I think the only alternative would be storing a checksum of the
> > contents of the folio and seeing if it changed since the last write.
> > As you say, this is userspace doing something incredibly odd (I really
> > don't think people make a habit of mmap()ing files shared writable and
> > then giving RDMA longterm write accesses to them.  Not on machines with
> > poor quality flash storage anyway).
> > 
> > Or we could say "these pages only get written back on requested fsync()
> > rather than periodically".
> 
> Take one step back.  For regular pins we should be able to just wait for
> them given that they are by definition short lived, where short lived
> is defined by typical I/O latency for a wide range of "typical".
> We'll need the right helpers from the MM for that, and make sure
> we have a good way to debug file system hangs caused by incorrect
> use of the pinning, but all that is a solvable problem.
> Splitting read vs write pincounts would be really helpful to reduce
> the overhead of that.
> 
> The interesting case is FOLL_LONGTERM, as it can pin I/O for a much
> longer time.  And that also means IFF the user of FOLL_LONGTERM actually
> wants to be able to persist data on a shared mmap, it has to manually
> dirty folios one or more times during the FOLL_LONGTERM pin, because
> otherwise the file system would never know there is dirty data.
> The set_page_dirty call in ib_umem_odp_unmap_dma_pages is an example
> for that.
> 
> So what we'll need is:
> 
>  - a way for the file system to know if a dma pin on a folio is for a
>    short-term writable pin vs everything else.
>  - for the short term writable pin wait for it for data integrity syncs,
>    or otherwise just skip it.
>  - for FOLL_LONGTERM users we need an interface to (re-dirty) folios
>    while the long term pin persists.  This also needs a way for the
>    file system to reserve space.  Either as a rolling / bank switched
>    reservation for the whole life time of the mapping (although for
>    large mappings this might use up a lot of space), or to do that
>    ahead of whatever triggers the dirtying.
>    And maybe a way for file systems (or vm ops) to reject long
>    term writable pins if they don't want to deal with all this.
---end quoted text---

