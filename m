Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3C7BCC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 05:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E81086B0088; Thu,  2 Apr 2026 01:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31B16B0089; Thu,  2 Apr 2026 01:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D47376B008A; Thu,  2 Apr 2026 01:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C67D16B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:21:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BB14C1B5E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:21:48 +0000 (UTC)
X-FDA: 84612468696.10.5536055
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0FE87C0002
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:21:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=yr11Fpu6;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of BATV+a0aa6d55f7c9b151d503+8257+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a0aa6d55f7c9b151d503+8257+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775107306; a=rsa-sha256;
	cv=none;
	b=Ionw3hKCz6q19GcaN2wDntS1vaVyUq+InvUk+4iFivYB4GT4abBehyTHnimp0woAY10vcy
	Oz2Sql9766GANPfTnZQk/phBtG1V6eKjyF212bCOXKSqmFFkDlbEilpNrGgifJTQvdNYKb
	1aFHHmkHmlih1r+HP00Jmo8A+M7ru54=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=yr11Fpu6;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of BATV+a0aa6d55f7c9b151d503+8257+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a0aa6d55f7c9b151d503+8257+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775107306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCTASolh/HHAKZfZX4Vdxe/7xfbsKFH4aqSmS0b3nPo=;
	b=NBnGSQHzn/qW4QrgzE9t2ZZoS643HDsUp2N4xSzmWL0MTfKPmd5k4/DF3/VK/oPWpr9dTH
	sv95+zIp7s0D7/uUfqOV9yQ70ArvDrHXoKoPQGDdTVF42bMlzeUHP7wowDkVs+FFxtJi1e
	R/95OsALkndmL8btXjzD7VRj8zpdGxA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kCTASolh/HHAKZfZX4Vdxe/7xfbsKFH4aqSmS0b3nPo=; b=yr11Fpu6FYIB0gkBujQ/3cI/ow
	yusMImjUDC/ox8LjAXPIaKbbc1Pvw+z/Pn77dW7GJdmFeJgXa+SwNmJcU06iqbjRwmt/XoL+IasqC
	fx3BpLLBamutD2gd16LTG3yitc0ythc2C+ei9CDMOaWoWlkU7Iq7dSR62PRgTQqizQ73jifgEYaz4
	JjlNUhETfHQM77crjIGx2pQtdEHTgNyXsW2PbJIHrQsnVDKSjsPaV8dUdadEZ0K3jIQphcMNXW2DB
	vaxRh/UD0TgnOUgxRpXh1g4pjka94XYL00h/JMC32NjTzEMWxWpcJcJSe1bxnkVeVCC07fxIGqcK5
	pl0lV7Kg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w8AUu-0000000GnzB-0dij;
	Thu, 02 Apr 2026 05:21:40 +0000
Date: Wed, 1 Apr 2026 22:21:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Mike Snitzer <msnitzer@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/4] mm: fix IOCB_DONTCACHE write performance with
 rate-limited writeback
Message-ID: <ac385Il8l-krKEOQ@infradead.org>
References: <20260401-dontcache-v1-0-1f5746fab47a@kernel.org>
 <20260401-dontcache-v1-1-1f5746fab47a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401-dontcache-v1-1-1f5746fab47a@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 0FE87C0002
X-Stat-Signature: rcckjfbrk9o5debh7k7cz3uzbm5n3jx8
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775107305-542215
X-HE-Meta: U2FsdGVkX19vedZhvewtYSKAGotoco0Xgt9pbtZOuCVXDsAUdXwMFe6de01TAd8LwRqTgRRlDkSRgBV+Bre0nCHeYzrM2jYT0lJ8Lcrw5Axr8hr7GseI528ui/DrryBtKjrfthqe3yRjc5mr5p3FejqrSP19px83O/PsV+n+qju10eMGP7Yk1nd0ewklZbIMFZX/0cHMzAmgSIYYXr8UtLFewAvuZCTVUo3I8VL9BxTvvpyY+NyAd9mkwMNWZvh2B63SZeNwUiRL4Q/JjrKtJ1JzAkNcJ/r9ZH+DsIlBbXe1cBgZLuaTPMibZlk0XI+h+rfhEqDw7F17TXzlKMYfWh8W+SO+LrTOCe8Xj2FbdypwdGV3HFRsQ02G10Iv236+EdxorMqATR6EjbBCfc8hc9cTt80IHaq2HiI7itiA8VheYiA46h5GTF1i/CXMEHnyCTwysva4sI3k4D1aDy7MrfRtSmRLGAWUbpTCb4R3K1tgIsD6Axc918bs/8bNlpnwL0W2sEYN1hWFAlfi6xUu1whOTi5z3t+3wnbwK+E76a4YTjErE8xOHw6jOFB7mY78IVwhEH/ptSXRWyU1nLVrRf2Ntn8b4Nv3LP3StYMPwd8jOD/S5aZtcAWk2aTmBTYKpcVPOGSYX3b/7sSWMJwsXErJzWO3ckh+9Pk2ibUeLZACz9J4oJ0mxDRkicx7omaGU3BJuypGu0eXrla/5oINaj6WFl2E1BQxmVHrEFltSgN29jl0vvy2j18I+U4AUFRozFLhElZE+zYoZ/te/fvYxmZH6qWyCCwkFR//ug5mXmMgp8vBLKlP879CaGIUGMNSIx0WiJOOY9wEL61G1TRJdQ31zKYO3wseqnk6GR647kYgq15BuSGvFK9pJ3OcHK7/QPtA1GPYwCT43umSgH78tpndSKmwDJ90zlNc0SMv6dROJE5PYcaUoWOecaQYQcJXfqQIM8CoSbggXqZ8rOS
 ojf/ZUfd
 L1oOxqI5J09uUQY0CO1dVZqzcRdX1DI/8vkTKQe5V/iFPIGshgP8zz4xbxlsh/9NYzVbFgbo4lYvWxlkFWVQtf0fpUmfJkZitTimvUwldonBFk0vtwTz70qpnWRzJfvPX8adorfoLFjvFLgCFGytAolqGgh6JTQHCrAIyfeXyqjAekhS7j2SB12R3eYql1CAGtZi8nzZ74C2CpOV3vvYYrUZ55oZuz2ks+AYwm0KrHUfVYGSJphjjF/W4DjDIzLzYg1NPR2Dv0gEwaSb+DowhAMUt0gJYULuC5v0rg7V6jyWN7k2H9C2biv5dO1K8xyTpDJwpGjpLrMwq/WEqK5VEBDQXspU1MWIR0Vy082yJCT4XIz6Pk5AB2NTc/WSLASVQPakLuiXH1Tn5yBRTxnH1iU5d/9M+bwpSbhZk1h2Zcm58J4JwjTS5iKpN3d5NyatwjSR5du8bP9OeZQSvBWRQABr5Qm7GPxX7wl6NCsII8Mpzr4FTt7hF37T9p09wAc1unhqH6UVmK+vmDbyTjPnTu187CQnP3gSSEqEpn6BCpGwka0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 03:10:58PM -0400, Jeff Layton wrote:
> IOCB_DONTCACHE calls filemap_flush_range() with nr_to_write=LONG_MAX
> on every write, which flushes all dirty pages in the written range.
>
> Under concurrent writers this creates severe serialization on the
> writeback submission path, causing throughput to collapse to ~47% of
> buffered I/O with multi-second tail latency.  Even single-client
> sequential writes suffer: on a 512GB file with 256GB RAM, the
> aggressive flushing triggers dirty throttling that limits throughput
> to 575 MB/s vs 1442 MB/s with rate-limited writeback.

I'm not sure the first how you think the first paragraph relate to
the second.

> Replace the filemap_flush_range() call in generic_write_sync() with a
> new filemap_dontcache_writeback_range() that uses two rate-limiting
> mechanisms:
> 
>   1. Skip-if-busy: check mapping_tagged(PAGECACHE_TAG_WRITEBACK)
>      before flushing.  If writeback is already in progress on the
>      mapping, skip the flush entirely.  This eliminates writeback
>      submission contention between concurrent writers.

Makes sense.

>   2. Proportional cap: when flushing does occur, cap nr_to_write to
>      the number of pages just written.  This prevents any single
>      write from triggering a large flush that would starve concurrent
>      readers.

This doesn't make any sense at all.
filemap_flush_range/filemap_writeback always caps the number of written
pages to the range passed in.  What do you think is the change here?

> +	return filemap_writeback(mapping, start, end, WB_SYNC_NONE, &nr,
> +			WB_REASON_BACKGROUND);

filemap_writeback only has 5 arguments in any tree I've looked at
including linux-next.


