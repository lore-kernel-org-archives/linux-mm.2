Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 427D9C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 19:47:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C15D6B0088; Tue, 25 Aug 2026 15:47:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 272206B008A; Tue, 25 Aug 2026 15:47:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188AB6B008C; Tue, 25 Aug 2026 15:47:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7C886B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:47:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 65BFC401E1
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:47:17 +0000 (UTC)
X-FDA: 85140825714.03.00B29C0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8E7E080006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:47:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=p4q5ZW0l;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787687235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQQ/ppgg7VzEnzjhM9PBplFwJ2D9OdML5WexPKMbFq8=;
	b=hoMDlXs3CtGn6yWiN9J8lIybdMdWeNqOD+mNgDiOrf10D7567ocMYvjwgDstIg3AaVveth
	TabnJQUXx8sd8OLmgUW6MNVMlpc4QH14g8OrbOMPJ5KlSaFU6KEekDzE4EnLXME/LBy5iX
	jYOyWWMD40gS6aWew84jx5OEmPJAFrg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787687235;
	b=a77Doz8xYI+T7jQAxCP6JPun2E8Upna88/uIS4SU/4ATUwQuwVP01YnCvLjOFewYznnED9
	slwlWXNEwyhXVfQgkSe7WKPKoSEKa6eZf3afM2UjF9wyz0NP+zWIFlaLw0l+eU9LwNP0iB
	O2tUCS8YLgvu1D6hX+MlnuQVd5l+weI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=p4q5ZW0l;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZQQ/ppgg7VzEnzjhM9PBplFwJ2D9OdML5WexPKMbFq8=; b=p4q5ZW0lzpuJU0ltYF8/6QuqUh
	W7G5TQfNDjRDGvVJKFLAppYgk5yIO5Ud2LZN2Zhk2SDbBzVt2yTr35jc3Zn4B6KZbpYRoVOpw2Nld
	B3/bEvM+dko7aif4w5kWkiSri0z+WY+3V2zoWXuGrfeu7ofiFResDR31RetXK1VzNYZEbsiPvF6zc
	HlzhXrNYZi16UBo7FxxT5JCd2OLgFb3DfOXhuLfWoyo391yrvBZzLrQDVwR4FciwuZn7XWD6nFuIW
	yk6QNkW4+mv+A6rgrTo8xWC43gvUxiTtn8s83BJ/lkdSu9TPBfDsrVb7DfWbV343Hg9aIrr/xx7yD
	kxbXFLPA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyx6u-00000009cpV-0CbN;
	Tue, 25 Aug 2026 19:47:04 +0000
Date: Tue, 25 Aug 2026 20:47:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Boris Burkov <boris@bur.io>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <ao3xN89JJoAqwt52@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <20260824212727.GA3664690@zen.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824212727.GA3664690@zen.localdomain>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8E7E080006
X-Stat-Signature: 9iziis4fdy5sc7uw4pkkdzmr99s6kcaz
X-HE-Tag: 1787687235-210009
X-HE-Meta: U2FsdGVkX1+RVX23qYPzSPXurmtEeNeYSfdaREBA00cYu4SlVf/T/gD6mp8tF5MKUChQq3y9RlgmhHtBdsrrCFzkeX3nDiX1XZ232sl/m8CVU37dpgbCl8QT5rDmE425JLR9f1axKFOMJM5Z6GHwyYiQ7AxT1Cjse+bXaY/8mf4yZg6APCX/VNMr3gRcXtqxv6Cvc9CQjKoW2P5JLnRSBw1YJlFKVt/IQplNLaNkJVhgwmCH7gDwF5x/WddQCaFKoqY4VDO+1ywFLqH1+lc8uGZmENofM2Wh1BL76BVeVF55AwF7BM7Uxm2QobFYrvpqehOKPN32E3Lh5vtusNtSrXK1GNf+8HtaV6qZ2riuWsTbewVe+cgQhVzKBOIqSvN3AughQ40ko/3GmGgAdVsayKDpG/qrylIfVXX3yA9uZlkoHIHCD4O+pm4R7Y9IUjkP04N29I2X8AhK+9v1Ga4PJUG4Dk0waFfYRPLpBKoG0eZgdygWgtrEZopes2a2IXMWT7w85UbiIH9YQXqZEOMiPIwnSULGH5X5L7EcXGCntQtDnIeurMEVyoqW4mP9/RAYIKJYMl4PXpoTNjf+d5tvaRR6CInbzRNG5zFlnb4mE73v7v6gldh3rpi6fVbtJOfBrPi2btLSqm8hivwJWVlTL1Fp6VjUGO7hHTGIZtRMQtj9eCxy7nuCiVluTi5e1Fjt+kOPoVSlyls79v2b5l3t9Q2pBdZUmnaB3hcSMXFLoimbc8JVgpRgIBhThAN61r1m8rYPaIvyEKo5fMqY/Hm75Y8oLsWOOenPu5CxxMkSuAqM43hHNNKoCPaZfE4UAxfKYbgaWb+/GbSCzemQN+5TgynOVrpTfU4GURctSdLHTi8W2eYCF4RCBt8FLnE/m+6DQgr0eNM9VD/SXFDV7AjvgFxCrbGnGbVZI+uN5duJ1y+lkEzaZ+tkoV4lLO0V8bKLs7zIx44difWuDHlRAAz
 e7riveTX
 g8mEnAcTA49iKcHFlLsJgkAcV6N10Vrj3k43MtbBnrhzL/Gf2/IW2HO23MwKO/ptcGe6OKgo3FbfO8gImWZ8FdJXgFItSOf6SnPq0f3Q9SmA+vPO0KLPXmONyydxt1JlzCRcYMgB8ZB4ThISjpFy+mvo9/yW6ftnDOxgKKB3GXLdWvg3CDPfs2fG33/N+gGW4v2UPOvUifvm1XWkDONiqrCkqBNjG1vaKJjXaWbdQQlwu0O0tqnpSPj6yyhqR4kn8O5k5pnubvf1+t5krauEzUdgSZT/ZDj8NyCIeUgFPJzZ4h41yK6o8kdTtfeLiD0rt3fIi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 02:27:27PM -0700, Boris Burkov wrote:
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
> 
> Can you elaborate on this part a bit more? I can't tell if you are
> proposing a change or saying the existing behavior is fine if we drop
> ->dirty_folio(). I am also confused about exactly what sort of folio
> dirtying you are referring to. Sorry if I am being obtuse.

Sorry for not being clearer.  This is what happens today.  We first
tell the FS that we're going to write to the page through
page_mkwrite(), then we transfer the dirty bit from the PTE to
the folio through ->dirty_folio() ... but it's already there, thanks
to the call to page_mkwrite()!

> When I was recently adding ->dirty_folio() to btrfs, one of the main
> cases was the call to folio_mark_dirty() that came via
> __iomap_dio_bio_end_io() calling bio_check_pages_dirty() which schedules
> bio_dirty_fn(). (i.e., completion of a dio read into a shared mmap)
> 
> Is that the case you are referring to here, or are you referring to
> someone just modifying a byte they faulted in from a shared mmap? The
> latter I would expect to have called page_mkwrite in the fault and done
> fs-specific work, so I assume it's the former that you are referring to?

Right.  The former, I _believe_ already calls page_mkwrite() today, and so
the call to dirty_folio() is redundant.  Except if writeback came in
while the I/O was in progress.  So if we preserve the dirty bit for
pinned pages in the writeback code, the caall to dirty_folio() will
always be redundant and can be removed.

> Either way, I do believe that for the dio read endio case pinning is not
> involved and btrfs relies on the ->dirty_folio() call, so I think
> something would need to be done about that case too.

I traced that code path down into iov_iter_extract_user_pages() which
calls pin_user_pages_fast(), so I do think the pages you're talking
about are pinned and would be handled through page_mkwrite() already.

iomap_dio_rw
__iomap_dio_rw
iomap_dio_iter
iomap_dio_bio_iter
iomap_dio_bio_iter_one
bio_iov_iter_get_pages
iov_iter_extract_bvecs
iov_iter_extract_pages
iov_iter_extract_user_pages

> I believe you saw this patch since it was your idea for us to use
> ->dirty_folio(), but just for reference for anyone else who didn't see
> it, the btrfs patch adding ->dirty_folio():
> https://lore.kernel.org/linux-btrfs/69d0043e0f6a3d17048dfde857127ab0bf331154.1785190866.git.boris@bur.io/

Yes, I want you to be able to revert that patch ;-)
> 

