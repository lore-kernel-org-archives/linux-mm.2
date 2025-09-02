Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CEC7CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 19:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A62EF8E0007; Tue,  2 Sep 2025 15:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13D68E0001; Tue,  2 Sep 2025 15:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9510B8E0007; Tue,  2 Sep 2025 15:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 81B9B8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:04:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 218651188E3
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:04:03 +0000 (UTC)
X-FDA: 83845235166.27.114D750
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 12DB8100006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:03:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gHWZDwQx
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756839841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7Ie2dG9qkYKH7KdCTL7krIVQ90q2mc6V65Pm721pbc0=;
	b=CtTOHu3k95uw3skC7iueQUV3XU7AczvoQRwmwF7rbIediE9F4VdPg3jo1auiixkjsZm3Mf
	Kycvxdp+Gcu+c9PbwlwDsGkNMF5lKMFEKSXIvjXfJvG2tnKqORoPISa2XUm1Nw+L27vnzQ
	+DEAeYkHxiSiblmAN2zZAXkwINER3J4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gHWZDwQx;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756839841; a=rsa-sha256;
	cv=none;
	b=PLqESZRJXpCxdclp60GrXPV6efzoWFXas3Sv+kNbbHkvb0yt8tkLVggVdwZwBEM/xpWshT
	Ew2oXoHSNGLBA/A1L2jEPy/E+hz10ivVF7moHSnnyCzXOGO1VAgrbscWMJpYnw7KqZyxrN
	ycURI78I1gjXOiAS4JyWcFup9UWEXJg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=7Ie2dG9qkYKH7KdCTL7krIVQ90q2mc6V65Pm721pbc0=; b=gHWZDwQxFrGO0FpYnvcarxu2tZ
	0rpwSrP5w+obtDj7vbRGld4t00AWfSimTyAKUvZnjYL9sVm65mAL48QNrxhuy1d0hRzD3kIlAoBtl
	IUxncxN2CIoynv2QZ6VbdPEKB+OJoxq5U8WKFW6UaSBcGOlL0aq50KkbKmWVfDUaSym0fROgZ/Dss
	bPe5/clGhR1eZKb/6Xez8QPGK0gYtp+47KD3BTHKwdCUPNw5w/ZU762dON9a+Q7RhCSjhSWoI4yAo
	O48uUcX6q2Ez3W9jz2Xh4m7TuP5BMf8MXeH774buMcpLVwSp1ydJTMn6h0GVf3N+Ix1iGV1/W/cJp
	3yBA5O1g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1utWIP-0000000AMiB-3pjT;
	Tue, 02 Sep 2025 19:03:57 +0000
Date: Tue, 2 Sep 2025 20:03:57 +0100
From: Matthew Wilcox <willy@infradead.org>
To: linux-mm@kvack.org
Cc: David Hildenbrand <david@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>
Subject: Where to put page->memdesc initially
Message-ID: <aLc_nckaDc2ePRv7@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 12DB8100006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 9yagn1pwpkpw7eba815rccriadqbtzzz
X-HE-Tag: 1756839839-873617
X-HE-Meta: U2FsdGVkX19nf6CmEkF+axG2mDiizJ3AwDT9r+WCgSkZWcau1G5iiRmTxKXLsm0TDJLvS85dtwVJaoE13Y7l7a13rcuizJ/7Ia2DsRmGoZkWzZuvKn5rsu4B5PtD/W4zm+X7yjWGtrKwbPCQp/kifu82LkmNIYu5BayHA554TFMiz4gp/Vp28mx27X4a16AhxPdS07MddZU/mxT8lnUn16G8ezjQ7qZJkgsQEs7J50y+bt+kb2zdwvnl0bE33UckIdajQxR5Lckf2v0OXGduhtxEOL4bfT/QXyEBO84Pt8s6/tiMtYAoBDgXcZIVkdtdJ79gePA4v6HGVqVybDZGaaVFYwHC/4VwlAWICJSnJzoJXocLJ3u6tkl3SMvCwVXE8NB6WBAIvCnboerIkOGNke4+qiKdc85VYMb+/vdR3HZQII14fcuhpXZRrjDc6jymDh0g4UHOABztZGFDmawUZskhMF+KYjZey4Mcq4doYMZSc7P72GR7Ab/0fV8x06gVj/uPGveaeSNjCRBzpU1lkq8MBxRPiE0DVK39PkERiI0o//enHEVcLDBlMVpoMrP8mC1/mXEd8Wf4XjZPxJyvjMS982ezVXYpw5+KCUB13bJh0S8gCehKdYLy9A97uNvwI/kR6aA0Jx5HtxwlQ/MUJ0UppDdLUGSvOSVWOQpIlErGYZJ/Oeb978PmolCQVTs4mwDgTikD1XWGWQZVvnbFKmdGqPmXNXGXzBVPetLstSMPRd6Y+3QxYddLf/Vd+46K2B5W3CFTIa7CRZDrCYr1ZcCiyvAUBs4VRJwLV8/XgZWvqRXtj3F/Ir8ao72dk7DwzVv2hrN9nYjCfGt1X+K/3fPrDCuUPrfI8uuG/bPxYyulARM1tSqv2q6iKNIqtbJNCjIpcFHdkBCBO5oIn4t/VtfaYSyEV7MVKbU0n2u8tgdxTwXY4kRWCbYPVAYcCIEZrr2mDGnsxbqKTqcY8Ns
 WG4oo6v4
 59lnhIY2wc6C8dXk7nETtc9h280E63vrQrS6ka49h08k3PN8tuvR4kqbRfGl35SYuRp9wM54WM7aJM2pw7hYllMCF+6ORmlmT0lAQn+iB+6LnNkZ/7v8UNNliAw27JEhHwHaqza659smgUmKBPSx629iFnH59j/ZJkP5rDo3dzKMsUrEJW76b/XOt5aXXpmYA4RRqLZ1qKvj5KEdtvf4PkENpTejIBTsvT+Fp11u5f0G+atQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With the recent patches to slab, I'm just about ready to allocate struct
slab separately from struct page.  This will not be an immediate win,
of course.  Indeed, it will likely be a slowdown (overhead of a second
allocation per slab).  So there's no urgency to do this until we're
ready to shrink struct page, when we can at least point to that win
as justification.

Still, we should understand how we're going to get to Page2025 [1] one
step at a time.  I had been thinking about coopting compound_head to point
to struct slab.  But looking at the places which call folio_test_slab()
[an oxymoron in the New York Interpretation], it becomes apparent that
we need to keep compound_head() and page_folio() working for all pages
for a while.

As a reminder, compound_head() will _eventually_ return NULL for
slabs & folios.  It will only be defined to work for page allocations.
Likewise page_folio() will return NULL for any pages not part of a folio
and page_slab() will return NULL for any pages not part of a slab.

My best offer right now is to use page->lru.prev.  At least one of the
bottom two bits will be set to indicate that it's a memdesc (we're only
going to use thirteen of the memdesc types initially).

There are a few overlapping uses of these bits in struct page, so if we do
nothing we may get confused.  We can deal with mlock_count and order (for
pcp_llist).  But the biggest problem is the first tail page of a folio.
Depending on word size and endianness, there are four different atomic_t
fields that overlap with page->lru.prev.  That can't be solved by using
a different field in struct page; the first tail page is jam-packed.

So, page_slab() will first load page->memdesc (the same bits as
page->lru.prev), check the bottom four bits match the slab memdesc, and
also check page->page_type matches PGTY_slab.  I don't like this a lot,
because it's two loads rather than one atomic load, but it should only
be present for one commit.

In the next commit, we can separately allocate struct folio, make
page->memdesc point to struct folio and drop the PGTY_slab check (as
there will be no more uses of the first tail page for the mapcount stuff).

[1] https://kernelnewbies.org/MatthewWilcox/Memdescs/Path

