Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7943BCD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 06:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D13FA6B0096; Wed, 27 May 2026 02:26:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEB376B0099; Wed, 27 May 2026 02:26:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C28F76B009F; Wed, 27 May 2026 02:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B33CE6B0096
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:26:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81925A0513
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:26:50 +0000 (UTC)
X-FDA: 84812216580.05.9E0B0AC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id DF43180004
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:26:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=oOdaSz4J;
	spf=none (imf30.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779863208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+XkHO39t4awUaNWWRttBXc0bFBVogyz9MOEaNzq0Ko=;
	b=QkD9PxrickEwHJxpnMKW3HWxKJ9aq05JkgMYqtnGhaBxOQINvZW+eg0arXGkgUiQqlG0cX
	oBrFe6H6rMSVZRnrQByK62Xo8ymYTX580o6qJjmAwFfM0gv+JJ2Itwhizx2AnskWeIhPA2
	6r0xPVQ2o0nQwciWYkawU2PjikZmhkI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=oOdaSz4J;
	spf=none (imf30.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779863208; a=rsa-sha256;
	cv=none;
	b=Y9uTsP5+Vj6MDH8kQ3O7zZTkb0VwPTJklqctLbb3xFPLu8oCc9Joqk2MUrVxKFrAZ+Rwp7
	Iy6Z8K69jzOkcvSKocc+VxS6XT3verrz7PYPS8hWFnKjS3sxwlzL+/oj/ftC8FLTgOIR2n
	uh9Jd23oNdAoYbLC1MkekIm/p3xWyZw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8+XkHO39t4awUaNWWRttBXc0bFBVogyz9MOEaNzq0Ko=; b=oOdaSz4JzDOg+7gC5jF16HQGsX
	1mI1RwNcWbxdl0dt2+SrNDJko7kj/Xbtcn8RJd4xY8eNH5wiUNuZ5Af5Sn/UyQ5g5nNtD+1fgtXjk
	MrQ8HPP/p3A9eQnX7NzYbj68sfw171zIrY/jvQrXtTnm+ubXHYLLOOGAW/jp7q4RbrRxH0CMB0E4U
	ClthjAiJa7Do7xJpP8q3A2d/KQXxqRw/pbj+Y9kXsseteWmYh2uMIxNpxjjlnXVBgbUkUt6PgSQwK
	MoxMIsyFlNFIuIn2VHeoQJUANSe+aI+kPbznEt/2Hb5iudZSxKnuLFdpZsyQGkuFmadEMHFUO40dz
	PeNAEIxw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS7j3-00000003Opo-11Tj;
	Wed, 27 May 2026 06:26:45 +0000
Date: Tue, 26 May 2026 23:26:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Theodore Tso <tytso@mit.edu>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahaOpdw7NgsWe8J4@infradead.org>
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Stat-Signature: ptiy9p8baf6q5m6myog1o74t14643kwg
X-Rspam-User: 
X-Rspamd-Queue-Id: DF43180004
X-HE-Tag: 1779863208-621570
X-HE-Meta: U2FsdGVkX1+zw3W4ai3sMIf71ojyvmQ5OVKTODyT9mSq5nUkxjTZmYG8qUIOfHa92b/4twJtDWnncgv3vDgT0eFQJtAcxd0KyHh+JzNfDtyqgPF2fLi2GV3PzGDD9S76M6bxecJciFbcVlfA25EVnOo5+FticpodIt7MgDs12hge8uJ9UDDLEM1w0nFTkjxPIIpXU2gWT3lwIBAGkExvmp6Wr0Wdz90cAXgS2/UAV+3BmqiHAHrqIVe1qvfy0xeO4SiT1YDiDvyQRgL30WCV7oBkjIygNCp2PdL0Z8bxjJVjse83HBMsWE4/VD7iF9OjiAFGuL97YUhwHsp9zoK+bdVxkyAbpNYZVZfRErQyfzaoXL0nTt+voa5U5SFgHvCeryFsRXZ2yJPzhqqGnVmFAzC7B9rWcTlEbkhHsmY6Y8h7FO9qACM40367xca8aJrDM80dSN07FEvcyPluqiRrIuZLrFemhPKIIgR5O+2t1jSNI24XlEXnamKcSuDINXmg0P1uwtkeZEvVYJwhfnoB5ACr6bwD58xTwuu8I2yRQRMRfcmrIpqLztuiMKfIhabKeTDOzpSt9ixWgRARuIV+7ezsEDmQhuhXr4L8Nw5rt1AB6XzZR/TNkYFdIad0L4MDJuOFMFQQq7jj+cN1NZNMgU/CDof5ry41vxtY5mzSG+Z+1HYvYP+ixCLf5rJF+/706bQtBPngkzRMgUhF3+CS+vcXXnHMT0jAYHB5spr5C9kjLC4OqxbIq5urYkp9mUUjL0M2PpJAw95BtYUM83PORkH5JaT1tQEhPnYvlgvUbgteoPNo0EFFAIq4ZMT6iqIg2i2F+ZKW5Bf21WE1RJeeQqp9L1tb2gUNQfK2BPmOaCcNtw/4Chu/qQlxd94p6xXFtcIlZuK+bBkBq/nGt6j2QVNU0dgnKMVhXFle2AXQmgFo9zW1VLeZkY1RfSuxSfwXvWdnxDR7rvTviI0p+bd
 wgsKPDXZ
 eCX0ZbGXrisBpAdoi3EpoJlikNQbr2WrOpoCJnJx/7CDLHVy2Kxxz1MW7c5mkZFjX2s+GPrTZTrntgXBfKLg22fQiipevYUaQQpgAv3p7LXV9qnoVq1D7v3cJHVVBjowGKJAr7o4G4AcwtsGGV3ZdvNSvakRtu8rCotHF4kJTXcjOuupBoc12TXb8Lu/+HS/N9Tls48s9UyOB7NuvSonvLZ6js621pdeK9+psZAoFkAg5xDShWJV1dWkDiLPj+BFmfDG/QK8Fk2e3jyR7EYMsE8gFGjkhPTh0sw9xHLKwVCT4rhw4jXhDor1/NZIEcUIb2Z8QQYRort2lb+p/sHiIH4At0pVPtj6LZWKuORRmOehRzi3rqbCGI2CMgDrFCOhCbhrYhqy51uu2L7yUUQzlHUwsH48tO9bPp8VLnj6RGYCbj3o2XTvIF6sHKjkEFFa1yEHVX/5ljui5wPM9aGRqIs/1wGS2i/QKUgzMBG0LhHfcMf+SIruGY7y4Eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 03:31:08AM +0100, Matthew Wilcox wrote:
> > > And what are you trying to say us with that?
> > 
> > This means, high-order pages were used up by EROFS which sets large folio by
> > default. So, I wanted to say the concern was based on actual data which was what
> > Mattew asked.
> 
> This isn't that though.  What you actually need is to show that high order
> allocations are _failing_.

Exactly.

> If what you want is large folios readily available, then what you want
> is large folios used _everywhere_ because then they're easy to get!

Yes.

> If there's small folios in use, you need to reclaim a lot of memory in
> order to reassemble large folios (it's the birthday paradox, similar to
> the hash collision problem).

Yeah.  Although it seems we have an issue with > order costly folios
at the moment, but we should fix this.

And f2fs really needs to up the game and support large folios fully
so that we can run that kind of analysis there as well, without this
all this is just piling hacks on top of other hacks.

