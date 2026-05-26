Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDBADCD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 03:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390036B0005; Mon, 25 May 2026 23:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341AE6B0088; Mon, 25 May 2026 23:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2566C6B0093; Mon, 25 May 2026 23:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 13DA46B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:47:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AACD9120275
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:47:50 +0000 (UTC)
X-FDA: 84808187100.07.B4B50D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1ADBF20003
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:47:48 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nmtVWfiM;
	spf=pass (imf31.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779767269; a=rsa-sha256;
	cv=none;
	b=d0Bks/SZspe7ZfvHBtocykJpSLS+sAqbs9fB9Gofvvvu7ecEJ3Sw9xyenIhX+HLPg6GOoc
	OHaxRY5ctnzHLSYYeqnewCZkcVnlmSRF9boCkT+2vAMkocwfFnTYBwZj56vFiHUhlYs2YO
	kaHxoOE9ItNOnqAbtXQlShQXgWRgP8k=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nmtVWfiM;
	spf=pass (imf31.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779767269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DxyY+bYQ0Eo648ljGRU7X1Wi24vXYHPFWC0Fu00rbQo=;
	b=VIP+0m0jovmspk5g+CCG3bEeDoIXbt3n6+kHK9FvzqPtklzbOBcUf7+HvNceOlNtf1TmVw
	lEGKZjY5LbWi5g7bC6ip8L/UF5OOWO2Ty0eIxpRGJC7h9vajjGdDXux33+1kjmglaZfgZB
	yIo7J++ZTRic8h1GxNFukjd+GpCUTIY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36CBF43615;
	Tue, 26 May 2026 03:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B481F000E9;
	Tue, 26 May 2026 03:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779767268;
	bh=DxyY+bYQ0Eo648ljGRU7X1Wi24vXYHPFWC0Fu00rbQo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nmtVWfiMTmNf6D+IX+7K3ePXqNYLegK8TT6JQ1uNfPCg1/lZNl1hdy2I9ZyVlBdqc
	 XUGbbL3VR3ElWJPiiOgM97mnVnP0BqU2QD0SV2hFa2Eib8ci6/5rLW9rls6OtN4nk3
	 uIGXqzOAXE8tKcd13d5ANdSxe7aDhjCbF1akk4opPo99gdBrvU8MtwuU7j2b1g+TXX
	 fqYRTf5visUjVSFpVAG9EwuqGwtJkX1CPP6lnk6zNbZpnGVVigaaOGODi3dYe5/kPY
	 t5yaYxKVlUmVmfPF7Mr+6NnK8zrgsv5stXOUaO6dCmRV40JC5G6bXFk3A4WQ5NnPEz
	 s9pYjIfB/RoEQ==
Date: Tue, 26 May 2026 03:47:46 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahUX4tBeLykdQNxY@google.com>
References: <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag9D6_7dttbDGHZ6@casper.infradead.org>
 <ag_UsW_OrlXD9dWX@google.com>
 <ahBSXyOi9b1jxNkX@casper.infradead.org>
 <ahBii6bk0KbK_NHV@google.com>
 <ahPffhaOi2CBtWof@infradead.org>
 <ahT1nT3xsMGkyJab@google.com>
 <ahUF7HqSKFJ422bU@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahUF7HqSKFJ422bU@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1ADBF20003
X-Rspamd-Server: rspam03
X-Stat-Signature: zyd5o5p4immrfso3xxxoxc7aq8z58gmz
X-HE-Tag: 1779767268-58825
X-HE-Meta: U2FsdGVkX1+ppKucTyUAPo2CMhUOjh0idktQH7KBdl+S/BTwtD7kD9DlnItCuLWtuckhc6jgw2d9pN3TjVLOejxmQ2eKWrzgWdKifFxAECGIOmXSaCo01XgxjKhwgdqxWeC78o7UqHPGS9HB0nDR0CIGOqK4TjWbm7riFwdX1QDRrxhSH7p6kErTTKz7r8gGlrB8ZYzOPUYFILjtK+uGTrpOEVsGIf4+a+tGfzIFVqNdbiDAOF0jbffJIczwVS3NdaLImo/a4Cxu1MEH7wfIESFGh7U/D/1JM2x27vPtZn80NEeh5+/lUF+MpJQoWly0s6lcVwTf2HuEQEdsqYwKzngKnE9rlYo78WxRnlYmJrAxGwmdaoaB2wdUjLC9Y6Z9lon0o9x8Le9ixCA78yYvCDZAQaAYIN9s6Sk/tuurKtfdW8TWs64ctGEiTleaGIFozmHU1TMno4ywrGSOQKWj8oXL2e0McWDOQPsjCDkML4LsJp6W+7cNCrKWUynW+Fh8UGmp/SiWox3J8dJm3mR1l2GsVkzi+aVPQagh2NLGW+8NPZK6UEh8RRnu+OTpQMZnMgxW6JCOFE26xYT8apWQRGBYMDh6mtAFa8ZwYyAXQjGRZocSpSj4bxz5viqH4K7ooyVvJc2Np/skVj3M/5L764mhmZ/12yfdVAVYc6j7+mY70BzKu5W1/P6V7aOhMbEwMleXHr/nNvoZ9tHpGEW7fPYa5z36HEDn4PNfKZaP75puqtQ4RuENinrLz3e864qWVi7iI+T23OtdOJ1y7ZkqP8XACT8Th042+B+jyd+25kK1wTm1DUKkY36Ck3102Z5b4GzMo89g9+3kmSyHJo39xWTIQFsTNeaX2i3BI+u2IMen7XmbSOqKeYjWbCd014Ka6yGvF+sI0pzSN6MP/SLkXU3iHyb1Bu1y3JDeAtomozfW+Aq3hM2G3sYOIxx0OPhtsci1pI+V7LZT5Y2RvrA
 NdlZfPAd
 467eSfaqKKpmoNMz975h/idj9v87X/jPVNlzR0yb5IEko41oOiVJoOc9ZRPT2MGQ1Xo17w20KFyYY/Uzz4uh+rqJ6daN2qosSeHlNEg53gzA4Qjp+SgyDhnoVjGkbr0Pv5D8QBCGvrnCEkQXKgTxI8BR6Xw/qHCptJ+1SaB5Qt7WgjoPd1LlhUTIjv12T6d9LJoFi4UaeCA5jziFjSmdEncA1z+LaaDfq6BHpmpCVPlPbl8QGwH38hfO4m7POrI0ptmPwzZHKEslv7J5oMoWahqxWRnvCeJ3AVHvY/gjDkT88zIU34GJna82/Hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/26, Matthew Wilcox wrote:
> On Tue, May 26, 2026 at 01:21:33AM +0000, Jaegeuk Kim wrote:
> > On 05/24, Christoph Hellwig wrote:
> > > On Fri, May 22, 2026 at 02:04:59PM +0000, Jaegeuk Kim wrote:
> > > > This was a quick buddyinfo right after booting the device.
> > > > 
> > > > Before:
> > > > Node 0, zone   Normal  22684  42284  28704  16901   9515   4566   1854    673    181     36    758
> > > > 
> > > > After disabling EROFS large folio:
> > > > Node 0, zone   Normal   8486   4732   2175   1161    697    272     82     19      3      1    856
> > > 
> > > And what are you trying to say us with that?
> > 
> > This means, high-order pages were used up by EROFS which sets large folio by
> > default. So, I wanted to say the concern was based on actual data which was what
> > Mattew asked.
> 
> This isn't that though.  What you actually need is to show that high order
> allocations are _failing_.  The MM is far more complicated than you seem
> to understand.  There isn't a fixed number of large folios available;
> when we try to allocate memory, we do reclaim.  And if there's large
> folios on the LRU list, you'll get them.
> 
> If what you want is large folios readily available, then what you want
> is large folios used _everywhere_ because then they're easy to get!
> If there's small folios in use, you need to reclaim a lot of memory in
> order to reassemble large folios (it's the birthday paradox, similar to
> the hash collision problem).

Thanks for the feedback. Actually, I tried to do compact_memory before doing
read() for AI loading, but I got complaints where it took hundreds milliseconds
to run that compact_memory. Is there a good way to secure high-order pages before
that read()? It was quite hard to project when it will happen.

> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

