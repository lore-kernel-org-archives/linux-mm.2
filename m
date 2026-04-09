Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E486F31E22
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 14:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3876B0005; Thu,  9 Apr 2026 10:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12DAD6B0089; Thu,  9 Apr 2026 10:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01CB46B008A; Thu,  9 Apr 2026 10:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E04C76B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:21:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BBA06BA727
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:21:46 +0000 (UTC)
X-FDA: 84639231012.16.255D11B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id 63C6F18000A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:21:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=oekmWysY;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775744505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AXd7Pgrw236phRDb4BUy2CY5/uYF1kqf7t0zPf4iggE=;
	b=V5tRqKIR7dS+3my24QJ2EHMqKkiI9ODzkwAX/ynpiwd0OobG6x3pH53euXkdSYjImAmJND
	QZJzi7chX8xziLDu9YTAb221OPbscM3t9W5kbCV0EgYfBv/RWPMgtWXz6u6yb1Z5EzkayQ
	LyZa6YZlYDXRb7gtwGdju0PLQG7Cqgk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775744505; a=rsa-sha256;
	cv=none;
	b=WlehQNNtwT5wOG0iObsB/WeHeInT2lvLm75wkkgolqu6mz4s0628JJpBUboSgrYI9q0iV2
	p3Hi6jN/pp+CM8Mr94nrHdZXG+UNl4Sslceu8JuBX/R550h22GXyhv6dqJwuk6KQetd1xR
	hddogwFmn2Hx2WvbtAQ7V2lEmlkbKjE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=oekmWysY;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AXd7Pgrw236phRDb4BUy2CY5/uYF1kqf7t0zPf4iggE=; b=oekmWysY0YtMv6PRwb3tb7EfZ5
	FPdgB9Ion+gg5IECBzJHFaETbhF8z/KXCsS19UFElbUYttxXwl1T+y7bO7fPby4sniGIAVz9uSqg5
	c4mFdGpGQ+tntp+RUbQVhaRCaCxQpQTO+my4kDbEUMVHmTc+v7VSiJWvji0wqfm+s0iMP3HQsdvYZ
	Xo0AXa6nOnf5nUqvpTf9KqQYeFDP7IsYTmfJb9UY3dgxJzdN6FNk7B7g+4aOm+VG4kMcqfSTZzPqU
	/+Cv5Ch7yl1d1LRsdbwsPhZHDnGV2UqjB/9MqBOFQ56ukeTyWu7rAHLv/oTFES9Ni7BPzMC/Ti7bN
	p/jcoRfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAqG2-0000000AgGR-2cnH;
	Thu, 09 Apr 2026 14:21:22 +0000
Date: Thu, 9 Apr 2026 07:21:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Layton <jlayton@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Chuck Lever <chuck.lever@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/3] mm: kick writeback flusher instead of inline
 flush for IOCB_DONTCACHE
Message-ID: <ade14lOI1CDiraar@infradead.org>
References: <20260408-dontcache-v2-0-948dec1e756b@kernel.org>
 <20260408-dontcache-v2-1-948dec1e756b@kernel.org>
 <adc-Q1iDWHD5yxHH@infradead.org>
 <gpcc6t5unsoepakjdffsmnmd5duuvijxwdochd753ttix75h7l@nahwzi4qfdcq>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gpcc6t5unsoepakjdffsmnmd5duuvijxwdochd753ttix75h7l@nahwzi4qfdcq>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 63C6F18000A
X-Stat-Signature: xyehrcqicfkj7wnh4ueruw1qubi9yatg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775744504-645016
X-HE-Meta: U2FsdGVkX1/6n6+dqptBMHnOi5FAKrMIIccf4H4XtRFeiTINc+MULjJTaoYhvUfWfQ1ZoiHnzrpmtAaticOkbUTq2cSG+b+ggkFc7/j9AnVXvVadH6q7oHs3r2PXsxrcd4skQgmw1Xy1tTz44HM1a03+jckwoLY3F9A3/r9CsFmWboyi5TIDz5TV9Y6SZLCdGTV1uLkepHhyp5RikRtH0z8GJzy73bnYUhkgQiu6WLraY+4203+Y0BqcgMC48AiLUI+XuZA/Lf6Gw6DDMaKw9jSGmGOxiTjF2X+lW/qcb6Pr7lRgKU6NMNzPMDcobQPUE1d2KpewzFRpgN5zNA1CwfZZ+yyTDZ44GWf8jVufCctfOAW3IBgBweChUCZ0TpkqttVNMbiR4dcqMNsXbDEwz+0JJYVIiMt6frRZKYatYxlG3iy9fOSqBAqyQ5k/B91Z922qxqZ5qye31L3+aX6IiKuiQXtfdobhrpcsWTrjtR1nkiuEdKWWCLri2YH+kzTsrnfgoNWlOJcuwXEZOd2xsDbE//Qc/53mJENOUEEs8Tc17VJkn1MpeWUc1YKAPxAh2xg61buDY02ncmVKgdMhg1E6ceSNBtHhPr20JnE8IBkT4jMPrH2SdoyI8lbNUW1W9zITdm3rUdu5kIP+5S3isuSVZ8KoxNg+T9IWFkwibFYcsoNpalGmHT/aS3+I2UV7YmsLG3Z5A0pSPOgDVE1gAnDMlRQ1KHjh9VLjdiwFv1MZMjZTk+7WGNaqTwP9Nysd5FHt6GJjDizjcOwK2a+G8Sp7kPFDArM5/1tkpTUiZWvlL5+npy8B1LhF7DayQVOEglO/OVQSZQenHDzO3fc7QwylASPJyq44OHQykZT7i2OHK58XZ3xeyer6jFzQP6d1ZSgKwLkYseQ37wq5486ezUUOEDAjUyeuJB74Yzzcg7ZP4GBb9FQpzE80exnkbHS2JkdAX9/ctJzIHVW1eLd
 fp3+To01
 Kbk0dshOib3j8op8e3q94c6sxepMAV5RnEDnm/K6lPbnm5VghC24aszHSsb4/8zunAfn5JILDnmwbUS1tc0Vj8yNXVc+AI7aQm78XWn1FWkXGThmFHT9y1/SlG6rh2erI3CW483uKk158YnBEvX/H/SDRK4N1g7/HUxMUZOGm/2ALKaxVZLC1H7mFErYxQOtipI7Ih+VDONkmwl/eD58aXORvTK4yTbQErOkudr6Fs5pW3mlfeNK9lt92sCg1N5L89dLCl50aYeDY77snIxxfVZTO+UvLIxiwiaJyTE7CR2iPTb76Og6BOrt+mdyRb5KDNWYd52xtmflJu7lu/ByOndwMJ0t2vPJn3+DgJqUqSO+W2eNkHXb6Sv4CKt0Akhw/8iVSquD93soAH1JsiOz0aricpx+iwdZ1XgR9L+MRyZsb/kPlA9q/sXU3DjYUeOieWsPDH4xiCKtIZPRHTAJ4Zybq8UxteJ/4ulGyyfHRu6WTeQrc6c9qUgYpR/4n+fC97g5uq7ZJiKu2YVaf9xbDJrmprjUK4blqzpyS5I07EuwB0o8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 09:21:36AM +0200, Jan Kara wrote:
> > So I think you'll want a new WB_start_dontcache bit, a new
> > get_nr_dontcache_pages() helper on a new node counter, etc.
> 
> But I'm not sure how you imagine this would work without restricting
> writeback to particular inodes. Maybe we could mark inodes which have
> folios with dropbehind set and make flush worker only write such inodes?

I'd only expedite writing by the number of pending dontcache folios.
It would still write the least recently dirtied inodes.


