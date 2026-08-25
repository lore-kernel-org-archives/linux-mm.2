Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 773FDC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 18:35:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DE046B008C; Tue, 25 Aug 2026 14:35:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78D6F6B0092; Tue, 25 Aug 2026 14:35:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 658B86B0095; Tue, 25 Aug 2026 14:35:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 439336B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:35:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C7D1A140135
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:35:31 +0000 (UTC)
X-FDA: 85140644862.29.9CB8F4E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6A94C140003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:35:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LXRyEqv3;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787682930;
	b=jlXpLPqwWxD6qLmxpmPlZYAafEGKjxlEUGpMiGiibEmPzCb+d3loQO7bjC0gL1rma82Xpq
	4gCVuT9kbAvO/Ag7SoR9BvoWGPmuPqr7jPrVxwe5gWdEjxpv9x0+gDLtvy8/JO7q/chLmQ
	yb93IDK8Q0dV4gWihlPqIF9cP7BKd6E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LXRyEqv3;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787682930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NzdQdDzy9an+ad2ujHM4K87j7IVbsCNSw+/FSI8vDqQ=;
	b=T4sv3UkG7toqOGCqrwa7onTIGTJr3dzhgWxf6SK5zSwqzz1QAkvnbEmP1qLr+xoBqxiMOS
	YGZhRJL42qENZRy29IJqYfZ7cd/S3qOdzmI46b5FxpSF6ARDINRUrKA2nXGzFSJYAPkwOl
	22K56NTcgi6ASqbY8TF6tIv24V/MdUI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NzdQdDzy9an+ad2ujHM4K87j7IVbsCNSw+/FSI8vDqQ=; b=LXRyEqv3luyRGaNhx9QcZkACii
	0DKvqLDdWONegOg3YmykHdEwYxNA9R2kquCB42nIt6EHrA52otHoe1WjbQaoNFK2aqqtusT/gQeXJ
	JFYkgLHg/zad0zJTzOD3lPUyJ/0d610qpC4N7p+Cca9zrtE0GoEpBhjIy8mxRyWc7WCMe3atU/7aL
	J+ijmZJBfx98iQhq+I1AnO1TilXv/52BDJqbhElR8iF9vCIUpYc4rH2jhdxbgIeCHeuP7o17REHnW
	soR2dy9Jws0Ymq/BznZz1WeI/jfpgBbeA8Qhyx/qceFGgSJybEJf75RNf9waPdG7MwxL/Zokf2XRc
	QvpQTY/A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyvzR-00000009XHS-2xcn;
	Tue, 25 Aug 2026 18:35:17 +0000
Date: Tue, 25 Aug 2026 19:35:17 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Jann Horn <jannh@google.com>,
	David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <ao3gZRa7HOEg209P@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <ao1Lo6TKhPcqV42B@pedro-suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao1Lo6TKhPcqV42B@pedro-suse>
X-Rspam-User: 
X-Stat-Signature: mba54t74gasioaooa4x53cmnocqd6eeb
X-Rspamd-Queue-Id: 6A94C140003
X-Rspamd-Server: rspam06
X-HE-Tag: 1787682929-385824
X-HE-Meta: U2FsdGVkX1+cKTHdDQ/TJK5dTl4XUv02oCHjjKHChGqglYjY27uSD0kJfj5L5sTPZCFjnrKM1/MzZcJAInBDWU6XAauBJDvTjfvyK8dOV4UloTe/C6LC2NPnQ0T5vUC0oUSw0i7qbYXqFaLDU0KOF44UfK6CCH/m9jsFnDUr3ucf9gPr0Sw1hzI6Q8fg6I/QQh4nFBRwQeLatZNqYEm5bHozMmPVSVXir0S2b3QQZMYvEpXtcHL+LeKX3qswJ5kuvGXZw84gN8neRL9RDnnQ/OSQHODizyXCSjrT9qKXWAZCBqXPbCoWKrpo4/KgJf26wusqzCiymMmohWxTP1PLpG308IXnwBMbVx8AzKBwIODH85IM0oyGzxlxVGCd9DoE1YwTdA6NkDFOUTpt2pQ9uTgsA1NyIZelyhZfJYRQsdP0EJG2ohDmieafvojigqDXBpqh6KP08yxXqflBqkUfx8Es40+soYtgu1BeYlsrzm1ZQvqDb8H+fFGCiQL5P3kRoBM6VewYS1CCjEco8aRAwnYfs44OuG+xqLokysPcPT1NeU52sMtHPoVMws0ji4MpaG4Tlvo8T5TEOKW3CD15zxLGNJRXBXb2h6CBr2wnkjUiFoJL9rPIaU6z540MVe8+LuQU8VFKPjyO12wbyp5eoKvphC7pxMxmW3B0z0ec6furSvvjnhpnUoDVQ+eYEhMQdh/4tLfrfQ+k534cmDfKAXEcqgHAGFnnng77kDB8uTV9Nnt7w0ih7ysZT7UXDxgg4gJ8M/lAFD4dWNqOIMHiUftGXsUXl7qXg7d6aBkap8MF2Yf6Q8ewkqwUt5L4n09mmfVDcmKMYaUjqAlZ949MHO2/tgNGXkFEBlqwfq9LOu9VfRYTX6OLe7y+y0t7gi9E3NCJs+zemTdFKxmVkPrgqpBhTBuJV7VcnZZrotNIJU1T9kOVsrdYflUDnBdOE60iPWJd8JfC41SwokEaBPI
 niLmKQWc
 jMeDbmRvq1sBfIQd1dk/Az145acIdcG0wO0a3V7YOjV2BV0c/Ll7Izpe/kxHZ6VDfwpZdGexax2tQEDXS6liPyVjib43A8l69UZvSMBAVXGIhz8hpmyphfEA76+6otJEGTGWoMOGMjzE7bn4bHHWfcp9czwYr5YdooHEhhiSoRF+XXyG0QzMA8+kR3RP2cSWejP0c/lGJ3oysMEYbhJ8SRw9dLenViMFl2eMe2N5HdQnQCu/ikqE8u+J69S9VHTiPOfZZaL7A1iANkF1SxSmwKuDCaS9qOnVoMSfX+CO3xpAOY9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 09:25:53AM +0100, Pedro Falcato wrote:
> On Mon, Aug 24, 2026 at 08:08:06PM +0100, Matthew Wilcox wrote:
> > I think it's time to remove folio_mark_dirty(), ->dirty_folio() and so on.
> > 
> > This is not how filesystems want to be informed of folio dirtying.
> > It was fine for ext2, but anything that's journalled or COW has work
> > to do before the folio is made dirty, and it's hard to do that work
> > under the page table spinlock (not all callers hold that lock, but the
> > filesystem has to be able to handle the cases where it is.
> > 
> > Filesystems want the page_mkwrite() entry point to be how they find out
> > about a folio being dirtied -- and that works great!  Except that we
> > can writeback the folio for a number of reasons.  If it's been dirtied
> > due to a shared writable mmap, that's fine; we map the folio read-only
> > and any subsequent writes will re-enter the page_mkwrite path.
> > 
> > The problem is GUP.  We have no way to force the GUP caller to go
> > through page_mkwrite again.  So instead we make the GUP caller call
> > folio_mark_dirty_lock() which many just don't, and generally we get away
> > with it.  But it's a bug, and a bad interface.
> > 
> > There's also the problem that GUP users bypass the folio_wait_stable()
> > mechanism.  If a page is written to while somebody is creating a
> > checksum over that page, the checksum will be corrupted.  If we want
> > to fix this, we have to bounce-buffer the page.  There's no way to
> > prevent or delay a GUP user from writing to the page.  Enjoy your RAID.
> > 
> > My proposal is this:
> > 
> >  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
> >    If it's true, do the writeback, but retain/recreate whatever data
> >    structures you need in order to write the folio again; behave as if
> >    ->page_mkdirty() had been called again for each page in the folio is
> 
> I don't think you can do this for stable writes. It's probably ok for
> !stable writes filesystem stacks, as long as the filesystem & writeback
> can handle making no progress at all. But since stable writes' writeback
> can't race with "writes", I don't think you can Just Do It as long as the
> folio is DMA pinned.

Ah, yes, I forgot to specify that.  For mappings which need stable pages,
we have to bounce buffer them.  I wonder if that's something we should
do inside the VFS or if each filesystem should try to do it itself?

> Perhaps we should give up trying to writeback these folios, and start
> writeback right after they're unpinned? at least on the stable case.

The thing is, what do we do for somebody calling fsync()?  I don't
think that "Oh, sorry, someone gave its address to an RDMA device
so we just didn't bother" is acceptable as an answer.

> >    marked as dirty.
> >  - The MM behaves similarly; we do not clear the writeback flag for
> >    folio_maybe_dma_pinned().
> 
> This sounds like a problem. You don't want users expecting writeback to make
> progress to suddenly stall on e.g folio_wait_writeback() indefinitely.

I should have written "the dirty flag" there.  I do not propose to keep
the writeback flag set indefinitely; it should be cleared after I/O has
completed, as it is now.

> I don't quite understand what your plan for getting rid of dirty_folio,
> et al is. page_mkwrite has the fatal flaw of being directly tied to VM
> page faults; I don't think it's the ideal interface for notifying filesystems.
> It's also the case that page_mkwrite can trivially sleep, and GUP calls it under
> the PTE lock. So how can we replace that? Would callers need to manually dirty
> folios after GUP, in process context?

GUP doesn't call page_mkwrite() under the PTL.  See my reply to John,
or just look at do_page_mkwrite():

 * We do this without the lock held, so that it can sleep if it needs to.
 */
static vm_fault_t do_page_mkwrite(struct vm_fault *vmf, struct folio *folio)

folio_mark_dirty() is called under the PTE lock.  My point is that (with
the proposed changes) we won't need to call it in zap_present_folio_ptes()
because the filesystem will already know that this page is dirty.

