Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04647C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 18:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD5536B008C; Mon, 24 Aug 2026 14:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5F386B0092; Mon, 24 Aug 2026 14:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27256B0095; Mon, 24 Aug 2026 14:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9FB646B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:17:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 304F716021D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 18:17:52 +0000 (UTC)
X-FDA: 85136971584.16.24632F2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id BEFEC180005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 18:17:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dMs5oldf;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787595470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YD1GqD83PyV7F9VPUwj4kbqvO6zzJjBsM9hK49aM5to=;
	b=yuNFFy3bBiNUqD6qBhQvcUqNGbmmISFWgniW9xSJMBWi4DTG/yeJFt1iaL8MKChB/97nXV
	xm1Bo3YqaHES7pIkJy64rsoOKS2kqT9PdgKQxZ4aTUCZ/8QtTmJA6GhfUIvPnruTO2nTY9
	vfbJjCdxJJb4qc722cXX+XwQ9g5RC1k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dMs5oldf;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787595470;
	b=XHAmZSAm4aw0C48EI9+ttZqqZHauaaHVXTIbsqnFRY0jq7VCAP4cPeEw9vyy1KtyTzuqdI
	f0t6VQRSZ+uYOFirYFeEeMHBJa/vMX9J7dS9ryZyHMxh9iGpmtHoLkVXJYwhmwBGw1bwlo
	FjyjL+OKbAYJVOqQKF4PzA9oyb0jVaY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YD1GqD83PyV7F9VPUwj4kbqvO6zzJjBsM9hK49aM5to=; b=dMs5oldf5sHbEk2paBx+Aa2NKq
	82ylPnE2ou4HUkWlhpD10V9ADVyG/bIO7FB5Sq1/Fhc2DQGF75Pb6ZrXK6b3mPl7IRsPuUYmHySNI
	uJMfQYkdjUgPh+34yr5oVvFSoGff/wGmCHgyEj2sIX41qWyhBM4EiS3OprdAmjGN9Laickcfd7eHx
	TXCkA49n4cRIQUJ4iC6U+QSZ+AakS//MT84dLtYeRPAm2oD+vNfuG605EQW02X3s6+HSyCSrDhWjo
	M818Izcz1Tsg2Lvfvo0AxZD8zJaRob2LLnnuAuGEuAOX0kTsRTZTUZjzqwcv5rHLMk1hXHQ+I8inD
	VYqGCIGg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyZEs-00000007d09-1LER;
	Mon, 24 Aug 2026 18:17:42 +0000
Date: Mon, 24 Aug 2026 19:17:42 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-nfs@vger.kernel.org,
	devel@lists.orangefs.org, Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 2/7] fuse: Use filemap_invalidate_pages()
Message-ID: <aoyKxvdQdeJQfPHj@casper.infradead.org>
References: <20260820193343.3852967-1-willy@infradead.org>
 <20260820193343.3852967-3-willy@infradead.org>
 <CAJfpegvP3i8ZJc2T=+f4rAhZ4E1QcT5+jC6mQPLxtB-yoK9Brw@mail.gmail.com>
 <aoxHOSC9kTPbKeNq@casper.infradead.org>
 <CAJfpegv3Ak+qNLb=fTSCSz7-taQ3Ui-Hkmqgn4PaGPe=CR4cbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegv3Ak+qNLb=fTSCSz7-taQ3Ui-Hkmqgn4PaGPe=CR4cbQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: BEFEC180005
X-Rspamd-Server: rspam07
X-Stat-Signature: mqo6cftmpztj6ouhwugqs36xpj61wthk
X-HE-Tag: 1787595469-886759
X-HE-Meta: U2FsdGVkX1+Fx93S/JWI5MXw0DUCyHAGLd8KzOtncKuXzEkway+NACkOoPEdZxFfTuPUqmXLl/ALOtFZgkaMNu1AfJHd0lAC0mm4YWRwN56ni+6pp7L+iIce7x3JxAuQ4TMEI3gEfnmYUy7oxZF95MlTGlk+WmyoiFKLy9LDjDw/yvnE2HG+xTdHtLodfndtv3h2O/2RBMNHkwXBarh6/HDPpmX1Wea0eSjheCFmFh4DvvBcnLzWW+BckH0+C2ZMEEybYEOD6yGZMFQCTRGeShnUxfBHUz5vjtVfEpWfFY6h5J+ogAyWYjl+bgur3b6G5qJE0M/2DqVVbJk1vg5Nu4LKsdAZ1qWQTtRInaVU+dAHlBL6PwfH5clIH3oiuXTl3ZDMltwNA1oXxzwuHjKQF88hOYMvCcGuJYpjkEIPy4Dxt1xrTxNJbhen9J+OLmk4LuU3dhA2NFJ54bSl/+QFfdrvTLqV/OhIGUWs7CpZ3/teByQ5tbrwX0360GvBGMUePR8pGTVxXlNRtZ8roNyfynIym0HntpMXCh7rNS4WEVeiTjCxdcj3Zl2+/XVj5saZGyANGg+lMNG8XbYrmhXq9YiZFDJ0D0y6qIEDhaZWsEdNSOHXGcYyk4a/dsdBmuDXWBQOJ8eyPGO37qbG0uWvzYGdTjeUlESNrIfxaGGY+KEeNd079EyU/qY7DxNKIpbWatqUgmJlGyhVSSPnUqg8ZtnRuwSfyJL6Ten3rxLF8x3Lg19GrpbtZHM+bO5nv2CV6boeE+eRiK+LY6p8ZRNvY39K+Bin+H/6rScnqOHDOjoRrt4unbf6FU3+5IX6uXVtSNxpyyDwOvkhC0iAi8LaHdzzpMwOEy9X269hZgpUnUSCB9z8+4vCkL2Al8kFUSN/t7w3auX2bIoDLkre/KLsEZwPlu6s78Gs+7Z/30cH8Ayyxfz89OUYHHGr9vzOKXYTIDhJXFuSHM93SalCbFi
 8OFq+fj2
 JLGVcVjH2Qs5iuJL3NQhHqUp1WZWYg9/Wd0O2aZ5aA5wOR/xc5CguGBI24e1UyrckTHfgUjxUWhtYD29ZQKQ1uOwJnvsPz2bPePswE3H/vokF/wlVepO+zq/lkk7XNP8bnix0ZZxV9ypN9Vs7zPsv92sBMwyhTplnfaqxUqgqqdRr/A2q88jNz2fVAGGkXMdbyNFeVI5FUpFNwDWqvdUXVzp0IWKaUlaKeY//16iTdjJFWBZ5jFThgNplunURfHcIj16Tl+93IO3BqPILW50lob9r7w8NqDCTvNQ8yqkF9qNNoWMEeeyMfot1BB6Gkdom8FhQcWeVPKa7Vi22Y/wR0/OFXeBDRqhpbM5HJeSNo6NlWQw+cEPjC7bTI9x8Y2xqfKKtj1EYZBN+yEqfq2xvS6MiHYYxzsOxJacjeusQqq3H3j50VFp6qEl5nN4yp9NnR09ew21HG5eMLfQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 03:49:37PM +0200, Miklos Szeredi wrote:
> On Mon, 24 Aug 2026 at 15:29, Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Mon, Aug 24, 2026 at 11:05:46AM +0200, Miklos Szeredi wrote:
> 
> > > Maybe add a variant that takes that lock?
> >
> > I don't understand what use that would be.  As soon as that function
> > drops the lock, the pages could be reinstated.  If the caller needs the
> > pages to not come back, it must need to hold the invalidate_lock across
> > the whole operation.
> 
> invalidate_inode_pages2_range() together with launder_page guaranteed
> that no dirty data remained in the cache after that call.   Yes, the
> pages can be reinstated after that but those need faults and the
> server can then serialize those against the invalidation.
> 
> I don't see that guarantee with the filemap_write_and_wait_range()
> (with or without invalidate_lock actually) since the mapping can be
> dirtied again without the filesystem's knowledge.
> 
> Am I missing something?

Well, one of us is!

Before:

fuse_open()
	invalidate_inode_pages2()
		folio_lock()
		folio_unmap_invalidate()
			folio_launder()
		folio_unlock()

After:

fuse_open()
	filemap_invalidate_pages()
		filemap_write_and_wait_range()
		invalidate_inode_pages2_range()
			folio_lock()
			folio_unmap_invalidate()
				folio_test_dirty()
			folio_unlock()

so what's the serialisation that the filesystem can perform in the first
case that it can't perform in the second case?

or alternatively, what's the serialisation that would be useful by
adding a lock/unlock of the invalidate_lock inside
filemap_invalidate_pages()?

