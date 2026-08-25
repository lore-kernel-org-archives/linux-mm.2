Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B1ECC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 19:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B8C66B0088; Tue, 25 Aug 2026 15:54:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369F66B008A; Tue, 25 Aug 2026 15:54:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 280046B008C; Tue, 25 Aug 2026 15:54:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B23A6B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:54:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 15ECA1601A8
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:54:36 +0000 (UTC)
X-FDA: 85140844152.14.9A1EB37
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4AE5AA000C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:54:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YTvUAr3l;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787687674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=smFQZ2IeQKu0B72lsW5UQQWmYpl1k+vdLVb/izh96cI=;
	b=XFBaJaVLNf0IdHnM/zhQXLxCfzcNt5YhoRqG4aVpOkoSlLo2aIpxYy7v58Bk/nANh+MVtn
	hLJYnFH5qLPxD9Vyq3wGoeFsvsZTGN6OUeTSelHZGffA3fN04GVZW7VbK/QYMmV2Fz9HT+
	THIv664YoRsRvHSPajmNRAqR+PbbKbg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787687674;
	b=XUAHOPk/sfyhKU7pG1dqmkspJBrC88zohA79XQ5BC39To5zPgLnwGHXPi8HjuE9/7ORWzn
	ht5Ktzfc67gg+ThM7REQFIHZ2Ft+iOCelzBpOpRfYDR8XH02VhaaCmr9u6wS9BpgTJWgiD
	9PiHl+hYJ/6587LC1h8oCA1gsvn9lGw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YTvUAr3l;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=smFQZ2IeQKu0B72lsW5UQQWmYpl1k+vdLVb/izh96cI=; b=YTvUAr3lwCk+v4NG+erMHF4nhw
	uSFjwylmYF2u8k3IoHoSxAUwyixjRMkt2tMEKGRgQYPo8zjoklPghvFWLBmVgLyz61jWpI/yVM3p/
	4PXokLDYhj/SKZWhgbenfzKExQZ6dUC/kNvWQRdbjAeqW0I3PdzDCq9DvIz960cCJDPEEdhslq3Wk
	fOuPkUcQ/MFTk47Rjemehr1joS7Uy9w584AHCiaRqPk/fdmBQ+IVSmwAuVzNDXlbruWzeHJ4DHaK0
	VuKdf6TxBxg4lWTzC0IP7nJ2JkzU5910QTXpuFDeerQq5WFDaaqLu+giBUbV8coeS0ycSUfeE9BSJ
	YQv9z9mA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyxE1-00000009dFV-3BJr;
	Tue, 25 Aug 2026 19:54:25 +0000
Date: Tue, 25 Aug 2026 20:54:25 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <ao3y8TtEGjniZ_4f@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4AE5AA000C
X-Stat-Signature: ig3izpj3ei7s1enofeiqiogdy1bq76bp
X-HE-Tag: 1787687674-760976
X-HE-Meta: U2FsdGVkX1/f8FIekHM8WgPz4HCw2izNI6U/PpeRrvrXpEdGY98Xiv5dRKJmWoAleGOnraxus6NVCizujnkM6kdlv+27FrIpVfTKJETOBQLvR3xrJq1KOiJ1sRVxqnJ+cn0hbqBGbw6ovmVQ4mNKMtaENtF61wo5UhAe1D6Dm/XkegJii4X/g/UBtk+/vazI+Zpce36lFSXK5xEYyu/18RDUT65PIt8oJKpC/ojqi1xaumrrkE1K/qVIuQuWT+ua9PmZL9aDSwbcmtYz0hSN3KcLFA+a2OhgfCBKLHEgrbHR+ictjUAm6ugDLdy/04PUCZ1cGC8ffVnudysD4FPN0mMGT4AKmu1KOyJW8Y4QPy71xWhacM+9HLIZN8nl/ySNrX4XO/Kooiocu4rzK8Rz5ivvM7iQyYtL8428hVsO7pv0ZG461MbCHGnfyTOpKo9LS1+ijJcnUTaguenC96ipLVgvjLVMhffYUu+pCahuzCTvvFw1GP9Ud4WtIRi0Pq8qUxwE22dXJz/g5hFZiesd3OULPMkgKKeA1qloXo1z3vc9Sk/Jea0FlkGn5zOT+pb+ANb/6W2I8QAMh6xb2jWVnldqS9+B+6VsoD6x108ITn1DGBQpCvKFCUlbmfxqGPTGFgUoviaVC+5Th5rY8R/iUECbBcaljCdrvdMlLPA+TWdhrvW+8lKSoWr2Zi9obn2umFLYZ5gaG8g6CPo2yjFA3XfHQHG3WNrGkaADdaCL5wXTyPibbvIEGogcUKkE5zMY8LgowZLlAxVZl7FiJcJ5Me0LlsqgVZnyzsSX0/T/QiokOSrzezNGsMl+rasNE7Inb3Gfsf11EpTqfo/ADn/pscNQ+mqI0qcW9aIv+3NEV4loOLfuPIlcJaDnn+LXLF3AcQlxzkttqPQKTSQKmIYUNKrJiftiteeBXxAb16K7/J/2/SlOyA9KLQRga4tKU9j+jyEvH8qhrCSgXSjnRg4
 eYpxnhbq
 SlFfNq7Yv6pyLXr++c6EbJnpepwGbTdLKzz5CaqMpljGmKT8ijn90aU8dfwv/xm0oGZ0MOy5NjlQp+2hAobAohOeZHrnzpvBz91CQ9B7cjp+NnsaezaW2rDa4BbX/cKGGbWUrulrzhP+BJjBd00ZHgIBe5UsyzqTMvclRDmXwXHkdnwh2iMdAD7ztL5WCp9CxExf3luI2m/FCYNNcB1kCs5AFVVDcUiefr43yvNHBc7F3ak3yj3SQ7ISWmdRY0wosRUwpXhZ8dItulTKreTJYG4NMsmb4pG5bRXlP2jfTZ8UPkjU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 09:35:57PM +0200, Jann Horn wrote:
> > The problem is GUP.  We have no way to force the GUP caller to go
> > through page_mkwrite again.  So instead we make the GUP caller call
> > folio_mark_dirty_lock() which many just don't, and generally we get away
> > with it.  But it's a bug, and a bad interface.
> 
> We currently have get_user_pages*() and pin_user_pages*(), where only
> the pin_*() version is properly usable for write access, right? And
> dropping such pins should always go through unpin_*() helpers?

Right.  I'm stuffing cheese into my ears and pretending that people
aren't calling get_user_pages() to do write accesses.  We should be
able to use this work to flush out the last remaining ones -- we
can put in various assertions that folios should still be dirty where
we currently have folio_mark_dirty() calls.

> Could we strictly ban using get_user_pages*() for write access, and
> use the unpin_*() helpers to somehow enforce that folios are always
> dirtied on unpin? I guess the problem with that is that we have no
> state that tracks whether the pin was read-only, and finding free bits
> in struct page to keep track of this is hard?

We'd need a count, not just a bit or two.  A pincount for all folios
is on its way (eventually) but I wans't planning on tracking writable vs
read-only pins.

> > My proposal is this:
> >
> >  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
> >    If it's true, do the writeback, but retain/recreate whatever data
> >    structures you need in order to write the folio again; behave as if
> >    ->page_mkdirty() had been called again for each page in the folio is
> >    marked as dirty.
> 
> I don't understand this part of the MM/VFS machinery well - would this
> mean that a long-term pin of a dirty pagecache folio could cause an
> unbounded number of disk writes in regular intervals, even if nothing
> actually writes into the folio? I'm guessing that could be bad for
> cheap flash storage, but maybe this is in the category of "yes that
> would be bad but it would be userspace's fault".

Yes.  I think the only alternative would be storing a checksum of the
contents of the folio and seeing if it changed since the last write.
As you say, this is userspace doing something incredibly odd (I really
don't think people make a habit of mmap()ing files shared writable and
then giving RDMA longterm write accesses to them.  Not on machines with
poor quality flash storage anyway).

Or we could say "these pages only get written back on requested fsync()
rather than periodically".

