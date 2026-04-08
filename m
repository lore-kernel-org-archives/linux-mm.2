Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACE3F10F9968
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 20:01:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6E4D6B0005; Wed,  8 Apr 2026 16:01:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C463D6B0088; Wed,  8 Apr 2026 16:01:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B839A6B0089; Wed,  8 Apr 2026 16:01:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A7BDC6B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:01:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A042B741D
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:01:54 +0000 (UTC)
X-FDA: 84636459348.04.160FB0C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7F64040005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:01:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tPdDet7B;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775678512; a=rsa-sha256;
	cv=none;
	b=UnbTwMoUdzAAhBjIqj1VzAAD2/cH392M0+lV0kgbnJ3Ihe/akkVvb9gDGdbOcoIv0f1M2W
	6UMFKWOQ57Gfwn2wCkvkpdhap/jJML987uGci253imVlYTJdWOMiR0hdcd0kCHidg3vMSC
	TZQRFvH37QyorL8O2ORxUi//HcqK5Vk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775678512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Z6y5mzwmAQdrf9oPiv/Zpc3+lv0vlBFnEYQxnmFeos=;
	b=OdxqEUK5DofQXkv2cjONhmcqJy3MtE0aAUJkL6uVBExddZoB1QcGUlVECiO+od8P9ke2xe
	P5H5FUjQuJC7hP8UdcBKMPLdV7R8qyby1NNrQrtcXDhwJtnhc99+4cgH0kvp9WK8I1WlGo
	HfrJI+O5j9tiEVQFCCL40Is3FoXkM8g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tPdDet7B;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8Z6y5mzwmAQdrf9oPiv/Zpc3+lv0vlBFnEYQxnmFeos=; b=tPdDet7BMdnQrWQfPC5mjFDQLl
	QHfwYh9hZk8gMelhgivq7Hiq1g1lESVcRAZnb/qv8pLIumyKzEzeW9anFdH+uOvX5TY1goULJ5sYJ
	J8KJSqCfJK9PX4jHbjgFmCfmocjCFq68BtBlckgK1kXbfJtV882MEhPF8b4g92/26aqz/O6PDkTUy
	4XRCsaF0xl73kGSTKilKC8fhXbVh7lXSVqllFfK5fT0dXCx354VnS7+wTiY18mr9m7kOLwnLqO1ny
	GRdgw0ss3YA0GicL3j1Kc76Gh7e0A43EcAOcvXF9KRRidW1IwMMtukya8oddIUIN53gBiSdVBY9Qw
	nvzXFI3w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAZ5u-00000005sOg-3Nri;
	Wed, 08 Apr 2026 20:01:46 +0000
Date: Wed, 8 Apr 2026 21:01:46 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for
 dropbehind writeback
Message-ID: <ada0KnRjpYnY_QYh@casper.infradead.org>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
 <acRDyJrkJhnHHMSe@casper.infradead.org>
 <9631d652-fd3a-45ac-b8a3-b632b26f6fa5@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9631d652-fd3a-45ac-b8a3-b632b26f6fa5@columbia.edu>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7F64040005
X-Stat-Signature: wkfztaczpatu117eyzye61rquuxykm53
X-HE-Tag: 1775678512-4087
X-HE-Meta: U2FsdGVkX1/pt5duhhFSOhFk6O8XE0w8MPJn1eGzj/j29i3o8lckI/HjE2tGywaNRa1+p1NFBevogy+3QpYgeFPGAgrJ/pbfJXUkccB1/RU+dab/wOgMgB58P24HHfCzRZya0aPXescicbz7BHkFgrYyv0taATEsq1Z6wvN+r5cefDi6KbKkpLPCSfO+rdHuAmzq4xoCWnfnrWbC+SLexEeMQ+J5KUEYDuS/sTieYpsghUc1JriLVgG3Br0HkXHpAvaRmi+Wjtn0tmiAY/5dvthEHKp1SWeSt6/bPR61rCvQ8S5AJ0CQ8bYnJTlm26JQtYEbcPhi616M20SFsEJqYd0cJZ15G7/JfmcH/63pmFGVe05yKiogeSxJcTwV9eO1nhfyBZRX5MLyNArEie+7MtuJ6WG1h50DYHTvvUEP9TI9GnGvyb4pLsZ5q23NvtqNBGNCmAG3+HZkBRCEj5jcilOfrM51NwTXvY4CAZoxDHuM/TswOMiIxt/pSJZSjHnFBa7Q9vFXOVJHr58j9wBqej9xa3K5bqfoKGPQWnjedLFIq2DtgntBFs+bh/AHYHUvIJefNF1++EIHxpvlYWnq+qmBlKB48M9jL+gAS4GXpsigqnI+9ft4BYeA7OY6sWx3BZBobdI/XWWtJ/uRoy+Bx1+dFRVzBeTI0vZKZS+w+aJme47bL3iKYQLTTl3VsScFaqBjKQ7o3fumzCPjElZmp6mpkgTpdehTYw0MmLtkdMtoej5ibZ8UfmL+r5Atm2dBbdOhpiPeDbfvn7NUrQ0ElOCWO8B35ygsPtxDxTsvfKHWHnuS5sgTeks0KzoxeqFXz/vBWn8yfKdK+/98BmxchkNo0ebItxIkG3ubRF+XtX6D4/U11HH7RCVvz0lM+8UTYPxtVfUXoS3Nyt1vbSGTJkP02mBUbvO9l0IWuyV+7v0e5khy0/A2gQ5NCimUT+re2wcJCquV+3SAAsWD6w7
 eZrfHGRQ
 LH1K7VyQxdzmZmIbepQzgyk9OgiVSi2E0bublpzLQuvj2lDHbdvUfgaScQ5kMgD/R1kJfx+Qtl4TMGtZUgChUFVObUTb/GS8nlsndLqO1WzjZyrM/D4WwORGxgjZ9EvPie/bTqtCKr1WMWNR3zhiUweT8xt0BAy3jXKIHhQhEpoVnXQtWO5EgldKjlk+hC9iw3jOhBMIKdhvcC8kKv5XmAk245V2kjzaCEyO9BZRWTjzTk6Qaa0bAv0uFx1qpXb7pAadVTDBFkf/DIN7dbxfk1MrP3lspiJI99famQR92NvF82sk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 03:44:37PM -0400, Tal Zussman wrote:
> On 3/25/26 4:21 PM, Matthew Wilcox wrote:
> > On Wed, Mar 25, 2026 at 02:43:01PM -0400, Tal Zussman wrote:
> >> Set BIO_COMPLETE_IN_TASK on iomap writeback bios when
> >> IOMAP_IOEND_DONTCACHE is set. This ensures that bi_end_io runs in task
> >> context, where folio_end_dropbehind() can safely invalidate folios.
> >> 
> >> With the bio layer now handling task-context deferral generically, XFS
> >> no longer needs to route DONTCACHE ioends through its completion
> >> workqueue for page cache invalidation. Remove the DONTCACHE check from
> >> xfs_ioend_needs_wq_completion().
> >> 
> >> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> >> ---
> >>  fs/iomap/ioend.c  | 2 ++
> >>  fs/xfs/xfs_aops.c | 4 ----
> >>  2 files changed, 2 insertions(+), 4 deletions(-)
> >> 
> >> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> >> index e4d57cb969f1..6b8375d11cc0 100644
> >> --- a/fs/iomap/ioend.c
> >> +++ b/fs/iomap/ioend.c
> >> @@ -113,6 +113,8 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
> >>  			       GFP_NOFS, &iomap_ioend_bioset);
> >>  	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
> >>  	bio->bi_write_hint = wpc->inode->i_write_hint;
> >> +	if (ioend_flags & IOMAP_IOEND_DONTCACHE)
> >> +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
> >>  	wbc_init_bio(wpc->wbc, bio);
> >>  	wpc->nr_folios = 0;
> >>  	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);
> > 
> > Can't we delete IOMAP_IOEND_DONTCACHE, and just do:
> > 
> > 	if (folio_test_dropbehind(folio))
> > 		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
> > 
> > It'd need to move down a few lines in iomap_add_to_ioend() to after
> > bio_add_folio() succeeds.
> > 
> 
> Actually, looking into it more, IOMAP_IOEND_DONTCACHE is used as part of
> IOMAP_IOEND_NOMERGE_FLAGS. I think deleting it while maintaining the
> no-merge behavior would be uglier than leaving it in.

But why was it added to NOMERGE in the first place?  I don't think it's
harmful to merge writeback I/Os which are COMPLETE_IN_TASK and I/Os
which are not, as long as the final I/O is completed in a task.

