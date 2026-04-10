Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB80AF36BAE
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 06:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5A636B0005; Fri, 10 Apr 2026 02:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D32026B0089; Fri, 10 Apr 2026 02:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6E6F6B008A; Fri, 10 Apr 2026 02:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3B4F6B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 02:17:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3AECF58D56
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:17:35 +0000 (UTC)
X-FDA: 84641639670.15.708AD54
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0977F1C0008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:17:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775801853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SjKh+brI32ySYZbJ1vhlk44p4l9BOw3b4KkH7+gsf+w=;
	b=ylzcJjAB0ZdODgZoSSvt6hE1IAp5sGslIG6T8RH8DOWA+2mNVsJrMmUVX/V0bkHvWp0JJt
	aKXwC7NqF82Sm2SH2lrpoOHXva6cXMDBI3S+bLM8WJeYWIm3Xhvv6jRlj7/rJkbCLqCca1
	fl/uTiC8pil+pLZh0Am/exn1WD0F3Fs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775801853; a=rsa-sha256;
	cv=none;
	b=TgUG5LvNkltmiFgGVog5C4DDdSg1WLykU8aZ/duwRTPiQEmQaRV94MzdsXcHGDzCtMtSxL
	H234/M7JH7m5eF1AMUyhg+t8nxWYDGKtYrna1ih0Zp7DjRKxadtpQ9a1k+oW4Qu0ancarl
	6pzPE9zOh5+TfwVECMHORov1bR4nnY0=
Received: by verein.lst.de (Postfix, from userid 2407)
	id E27AC68CFE; Fri, 10 Apr 2026 08:17:25 +0200 (CEST)
Date: Fri, 10 Apr 2026 08:17:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/8] FOLD: block: change the defer in task context
 interface to be procedural
Message-ID: <20260410061725.GA24667@lst.de>
References: <20260409160243.1008358-1-hch@lst.de> <20260409160243.1008358-5-hch@lst.de> <adgJqiA0vivaW7NA@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adgJqiA0vivaW7NA@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Stat-Signature: igccy6s5tww7fb3con6y4iqxs71u38pa
X-Rspamd-Queue-Id: 0977F1C0008
X-Rspamd-Server: rspam09
X-HE-Tag: 1775801852-308389
X-HE-Meta: U2FsdGVkX19nOQi33N22UYS5gUaAmUtiigZlt0oagBwtyEArXB9LmyHTE2Aen5rr2TUNBB81UBkvVI/GRzLp6q1eD7L5NEdZD46KMWSOZkQxLCpgP27GZ/c0WHrPHI/E8cIn+LS2efNOoCkYS2yLTTng82So25+mkcwGxG2PuJJs8BXNzhch8mzwkOJbwHt809H5qnAg/EB5sdBHne2QwZzbtIAseg0SNlM0K82BsfcjndbKGsvWhgQG4LFI7CP3ZdubUWv738Gui58HcJ4m2h8VRpmJUAD2JZvYAwrbfMrj/vFY4bwdwZq203JgIJQikNVgRh41rmgVOMAcU50ToxvYMwWLR8KNcFBSjQ2kgz5vticiDLBc4XPUTcwE80bDwcEzwnxco/1ZZc8UHI4ImJijYeCseSFteP5O6nSB+JsJDFPzwikOitq9060ZK70L+QVuUBoOfn827CExlfEnOjGc/qgDsCsp1MGoHHd+rETfckggWIl33pJkSsorG/gv5FGH7wAq4bLE3eKSL8vhJQ84QrwDhCnik2yzi3dwn/6QvPAtUp3jR+BVhCVUUtJVPpF5ie2dluBRAEePj7PNondyJKAQE3mgdvsKlVAaG70hA0Cxfr5vcA+5auI1W7GygnsnB05JWFZHz7WAlbnoW2AgcACKw8/cfWTU0wznPV6JUVepTI1jYhWuFdDaKS5EqthLgVRh0g6gSR/VMQC0Ag7drCvRkJ1sRw55k0PXSBNdQP1cmTRfBPrAUpiSbS8SD0G1/UkWi2tn5IFXli0g5QK+bA/yyyEljDmbJSqz7uohJ8RfPwIKyb5GONJwFtuMHKEypuQAzjstlKIVALVmGq0OuY8a3TFk50c0+vFfHQhPL8pMmPdBalbFU/MMvQtFvteXKN9jqBLOFi/RKx4H5muppf0wITJXY1/g3bOZdPaxdyevmnz9/I1/PgihHRVjZx5LeIR4aWhmSri7JOz
 f4+nIQQz
 YeHGGSFCQ7I82ZXC+BcYwdWqdeShzB3AQnFQEz63em2NCOK73oYBxXMLm1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 09:18:50PM +0100, Matthew Wilcox wrote:
> On Thu, Apr 09, 2026 at 06:02:17PM +0200, Christoph Hellwig wrote:
> > @@ -1836,9 +1837,7 @@ void bio_endio(struct bio *bio)
> >  	}
> >  #endif
> >  
> > -	if (!in_task() && bio_flagged(bio, BIO_COMPLETE_IN_TASK))
> > -		bio_queue_completion(bio);
> > -	else if (bio->bi_end_io)
> > +	if (bio->bi_end_io)
> >  		bio->bi_end_io(bio);
> 
> What I liked about this before is that we had one central place that
> needed to be changed.  This change means that every bi_end_io now needs
> to check whether the BIO can be completed in its context.

Yes.  On the other hand we can actually use it when we don't know if
we need to offload beforehand, which enabls the two later conversions
and probably more.

> 
> > +++ b/fs/buffer.c
> > @@ -2673,6 +2673,9 @@ static void end_bio_bh_io_sync(struct bio *bio)
> >  {
> >  	struct buffer_head *bh = bio->bi_private;
> >  
> > +	if (buffer_dropbehind(bh) && bio_complete_in_task(bio))
> > +		return;
> 
> I really don't like this.  It assumes there's only one reason to
> complete in task context -- whether the buffer belongs to a dropbehind
> folio.  I want there to be other reasons.  Why would you introduce the
> new BH_dropbehind flag instead of checking BIO_COMPLETE_IN_TASK?

Because there's no BIO_COMPLETE_IN_TASK? left.

> >  	struct iomap_ioend *ioend = iomap_ioend_from_bio(bio);
> >  
> > +	/* Page cache invalidation cannot be done in irq context. */
> > +	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE) {
> > +		if (bio_complete_in_task(bio))
> > +			return;
> > +	}
> 
> I thought we agreed to kill off IOMAP_IOEND_DONTCACHE?

Only IFF we don't need it.  With this version there is no way to just
remove it.

