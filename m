Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97061C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 21:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87B666B0095; Mon, 24 Aug 2026 17:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82C226B0096; Mon, 24 Aug 2026 17:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C4A6B0099; Mon, 24 Aug 2026 17:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BB326B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:05:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D0EF980258
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:05:52 +0000 (UTC)
X-FDA: 85137394944.23.97D2B69
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id CD168A0003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:05:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=acSTKIE8;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787605551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+LSKnKKqszrwqaH5kpE+1z9+lg3HT1GwCXbZtfOytxc=;
	b=dmsyAPBjnNoXyoA/smyTFRHWHErOmCNKMvh5Km4Wmh3KhmW3KIBb5x3a1c7zjAAZlHwcR4
	7/s6aTsiulZfblfqH4zSP9nGF1fZgudt8+bdSxkbps1fZk4BPtplORAYHWci8a2/3P9CCY
	ELZVR+8XUyJi3J57eZof57ixQRNux9w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=acSTKIE8;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787605551;
	b=RbHOZZVte7SIzA6FAP4Kw6bks0Rv2LayxB4ihZUrYAQKI7vyWFOBNIiy1wjwicU+tDyKk7
	G6DeQScbrkcAbcZ3j7N7x9g7GR4RTACSg/z0Gk67qlybj+HTyacFxB9nshY5qPqfSarh0m
	ngC8JeN/AvLypePFjKuZ4CBOYMnX/10=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+LSKnKKqszrwqaH5kpE+1z9+lg3HT1GwCXbZtfOytxc=; b=acSTKIE8r0eFrM8rCaUyueqk/y
	x4ij5/ugleIUGdVP9alCWHtV4wohqt2sooIADen/YUA0AeBYqD8Y6K3LdnTp6+qFNYi0d+CIpySi3
	fH+hw1+bFj9873pI5/kWyEtK+M94G10GsefX6QVN0W49WH0BJdJk6GbNNs2RkVyLBd4IyPM6h/5Kn
	g/oeZpBXKFosO0M5EDSMb6yj30pwRWeWTxrfFjR67VSF7q+mYNs/XjYhk60DBpPhIlmMmRy56U6/x
	dMqM/031tSXT4CTorKkmPibgf2JrpL/dG+C57Fg7aH6dSAvExR5jIvzm9p/DaymlYNLk5EZKRgUCY
	0ahaWXbA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wybrR-00000007q0b-0jWo;
	Mon, 24 Aug 2026 21:05:41 +0000
Date: Mon, 24 Aug 2026 22:05:41 +0100
From: Matthew Wilcox <willy@infradead.org>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>,
	Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <aoyyJQz4AFq-ilMV@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <5f4ed03c-e91f-4641-8964-cca0391971ba@nvidia.com>
 <aoye694JQLwUuqxC@casper.infradead.org>
 <764f2f23-09ba-4203-a304-94c0fba32db7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <764f2f23-09ba-4203-a304-94c0fba32db7@nvidia.com>
X-Stat-Signature: 493xrsdkwuechegxuobg5xn4p4pcczy6
X-Rspamd-Queue-Id: CD168A0003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787605550-896448
X-HE-Meta: U2FsdGVkX19vPU5+S+Su7XlLkXA8rtEC/Pdos+PuSsq7LXE6Z2MU20P2Kz6oGvhKmkijbyxeG2Q+n9jBk1uJDzrNdAZsE+GfMETjuyTJujr1JR+nLQ8m3WGJoedb3XGhwTU3OK9CrBbIezagt5lRTowHpptYI/utFkt0A/DV74G6yEkMwfK+8x7hSXEwlXitgkfizq2aQyZ8bm5MvDUJYyXX1xFoZOKpddOeAMB84kXyYr+wUDg5OiKNaFYZPQZTEa6jB9ACUwflcUCjzdDf43kFKbs90VqS2vwbFStl0aQE7r/TL2daFUypmQnay7uf1qpmpXVblzW2FfimQXLc8C1H3bp/rroGNQ9HQo22iEIHWY8OkJmydme169fOETAxaAtQCPak0Cw0dmHXiyvaI1ss0UzA8+h1xNWLsOnDkQlvnmdZyHe/lD0Vv53FCmetW+AQpwY5qeccXYrV4yd59DwuGaOH4AoXLBTX7FaLcdEfyQYAVW+22Fc1xvbnR4X+aBeqOL6oCaC+rtmKMq1/bU/lUd9z7OUfk9zSYNtRUnReZHDvozwYPIk4V/vROxnoxVA8RpnvnkfFHsjtJgAXy3YAn6zpCUsOQzJ+PuUwUUwqNwVrtPaz09XGN0Ewrk6KKdORohscPEtChpSRjb9+nvVcMGvC37r2FEo8pabrlqYHZON2ArGMU3wVahRHVNC9/SFEU1EkRzGX4HYjy78AlziQZTeVZBVbs6poO5kQPZZvfPW0jAiasoESIHUlaqAy3+CQj84D7rwa8YKkboo2wgFJriwbk+Rx2SrWFHB6Q3zfpDH83K1OJ5R3LIERYGrvFp5/45WtI2Gvreu3hF8Lsb93OEcq8TI44QelDssTmu/M7d9O1L31DIPVR7QP1NGuibCEwSgSwjfnXoozdXUxouatVbXxMP/fgc+MYol14fm/ZYiJ1KAQunX6oOaFYJS3XgCIouwLSVBqNG7Iukw
 g0syrd9b
 HtYk7V5cD7zhhj5TED6gd+wz8nKUHVL+jukBx8mZadIUTreWYYBojZLPxKQxtp6NQpgNomzj6amPxUlStjOGuEuFSPKdvm+XYeZpHKkGYUWlxEkKNMXCt53TwX3Dhl5SPFFOr3H63QpVpBx4sVl4XmkoD0DRXEvh4hyIy1My2qf8Njf6Ll9z29p+zYo6ujeTPQ8YIpEDzz4CuJHxlhELL5YVTR35SvfXoJy2Q7qSDP4INLtbVQaKK6dbOR0m33b6vkKNRQ0FI7n+51MNwRm8sOXtF/ErFi9eNaAGI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 12:51:43PM -0700, John Hubbard wrote:
> On 8/24/26 12:43 PM, Matthew Wilcox wrote:
> > On Mon, Aug 24, 2026 at 12:25:42PM -0700, John Hubbard wrote:
> >>> My proposal is this:
> >>>
> >>>  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
> >>>    If it's true, do the writeback, but retain/recreate whatever data
> >>>    structures you need in order to write the folio again; behave as if
> >>>    ->page_mkdirty() had been called again for each page in the folio is
> >>>    marked as dirty.
> >>
> >> Yes, that would work nicely.
> >>
> >>>  - The MM behaves similarly; we do not clear the writeback flag for
> >>>    folio_maybe_dma_pinned().
> >>>
> >>> This will have the effect of writing pinned folios back every time the
> >>> inode is scheduled for writeback.  But since we have no idea whether
> >>> the folio is actually dirty (because the GUP user won't tell us),
> >>> this is the correct behaviour.
> >>>
> >>> I'm probably missing some stuff here.  Let me know.
> >>
> >> OK, so working through the end of the pinning, I think it still is
> >> correct: device finishes writing to pinned memory, device driver
> >> unpins the memory but the page has been left marked dirty the whole
> 
> oh, I just thought of a minor hole that we need to fill: how to mark the
> page dirty in the first place, in the absence of mark_[page|folio]_dirty()?
> 
> Under this new scheme, we will need to pin first, then mark dirty, to
> set up. The filesystem can't do everything, because even if it were to
> call page_mkdirty(), a writeback could clear that before the page gets
> pinned.

The page fault path:

handle_mm_fault()
  __handle_mm_fault()
    handle_pte_fault()
      do_wp_page() [just assuming the pte is present, but !writable]
        wp_page_shared()
	  do_page_mkwrite()
	    vmf->vma->vm_ops->page_mkwrite(vmf)

and that's where the filesystem gets notified that this page is about
to become writable.

So your concern is obviously "how do we prevent the writeout from
happening before we set the pincount", and I think it's that the
writeout path will make the PTE read-only before it does writeback,
and we hold the mmap_lock which prevents the page table entry from being 
made read-only.

But I'm only about 80% sure that's what happens.

> > @@ -2717,7 +2719,8 @@ static inline bool folio_maybe_dma_pinned(struct folio *folio)
> >          * Here, for that overflow case, use the sign bit to count a little
> >          * bit higher via unsigned math, and thus still get an accurate result.
> >          */
> > -       return ((unsigned int)folio_ref_count(folio)) >=
> > +       mapcount = folio_mapcount(folio);
> > +       return (folio_ref_count(folio) - mapcount) >=
> 
> As long as the math works: need to not underflow. I guess mapcount is
> always less than refcount, so OK.
> 
> So it *seems* correct to me, fwiw. :)

Yeah, and if we hold the folio locked, it's true.  But we could sample
mapcount, then have a few unmaps come in before we read refcount, and
we've got an underflow.  I mean, it's only "maybe" mapped ... ;-)

Perhaps we could have two functions, one for if you have the folio
locked (like in the writeback path) where you can rely on mapcount
not changing, and thus refcount always being > mapcount.

