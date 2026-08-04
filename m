Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E2C3C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71DE76B00C3; Tue,  4 Aug 2026 09:42:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F4646B00C6; Tue,  4 Aug 2026 09:42:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 631D56B00C7; Tue,  4 Aug 2026 09:42:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4258C6B00C3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:42:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E7888A016E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:04:21 +0000 (UTC)
X-FDA: 85063605522.06.145F73B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7F8E11C000B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:04:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=K1Rf8ruX;
	spf=none (imf20.hostedemail.com: domain of BATV+d7a51db447a6f215910b+8381+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d7a51db447a6f215910b+8381+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785848659;
	b=sJR53jx9rmuFVq3fpXZgdnRuq0JBOTZTzrzjQiWJH1pB46hQjbs3WUN7PYmrq/jV7t5pq7
	hnG2d+h4MhLlEi1+ioiTRBvOmgG2VbmMVlnAEzlQ7x1QQIPMvK/qiosxmjSmfsZBFbycnS
	4r3v53klCJ59cRlpMeCsGmh8xe2SAEY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=K1Rf8ruX;
	spf=none (imf20.hostedemail.com: domain of BATV+d7a51db447a6f215910b+8381+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d7a51db447a6f215910b+8381+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785848659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LQl1PoD9whXshfiGdiRGN/MouZH83WKAc5uKqtzgf1s=;
	b=ZjcaZh2+oquoqgyxqVzbbermTByDT2dXfFcU/GhhFRaIg14Hy92MJLOTSrjY+9+UKnTEzS
	beP6EBo3tfxzA/hwv2yK9LSxPMmZSsYQxIYwbqmVDnhDoYzuwJdYTYnd2AUzRepYJqFZNp
	MX7vaZjA7RTjvuNKL8mBVQDdDZcjOXg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LQl1PoD9whXshfiGdiRGN/MouZH83WKAc5uKqtzgf1s=; b=K1Rf8ruXaCO0RHwTW3HGNdLxEN
	UehSuFaYjmEaaycnFZiN1zXEnHPIpv5BQe5q+js0SXAxb3TK4Eyyw3IFJBYhM991O+oZBiGLyF4xG
	D/IIu5cl0XYEmgzOftRVRUHYN0XXfbhDwmMRHoW584lsu4K91Vgou+tdv96EGyc46GJRVKMo6RSYf
	LqEIlAUHCod75QZwf7Q/l+n7ZL+VQdaZw4K8MgdXixh79SEAGwHL3U71hMpCYhR0qnT27wkXgDvr3
	3FvJDKRGqJXN5nNn6rOJV/Dhnq0BaFup841dec2g2gf0W9CppXwCz5+owbsrZyrUQcBApb1qjNLMX
	3gt007yg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrEoF-00000001sbx-14Kr;
	Tue, 04 Aug 2026 13:03:55 +0000
Date: Tue, 4 Aug 2026 06:03:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Hillf Danton <hdanton@sina.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 3/5] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
Message-ID: <anHjO1vokMmADsZP@infradead.org>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-3-3e8e6850068d@columbia.edu>
 <amsHrVCJnuXzeGG1@infradead.org>
 <15506dc8-e5b8-4fa8-a85f-912a92edb83f@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15506dc8-e5b8-4fa8-a85f-912a92edb83f@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7F8E11C000B
X-Stat-Signature: pmosu4hhymb89qqn157d1kumbide336g
X-Rspam-User: 
X-HE-Tag: 1785848657-688306
X-HE-Meta: U2FsdGVkX1+33t8TETtDhOWdK0kIgDVQvCdgLA8b3VDYq0NxeeQjdCaRlpUpss0fNqZhczU9fXVHOIsvIxnUHPeE7Kay9gsYMMgsAFPwH98XDdyzl4hQ8hWzu5M7ifByYYfubIBQ7OiuGO3PvDUjSSLVQogC8tdzv6liRkjwJJLLc13ixmaM9iX2a6QZJYUdB4QZNe1N+pgqNitYDDW4Y/JAEn8SaK0U+DjcbK449FEGMdOB4MBTChJIAsF9UFK4mj52mlaI711bw07KpNF4lzedXXqsj7YqVtBd7zBriJfnb3iq9SbK+UxElwrRLbaSu/vyuE6j+tUBBtZQJ5FIIbgzML5Ngvi5ogQsdiBJDzUaQWMN+bUtmAlLoVtYcu9T0PC/jlizYwZkkM2gDtCJFQ0zkf2CEAjhLRLrxOj5r0F2jHWmmt8RSkgjMKOH0ol3RRaLUw1iryx5QGS9l5/grGvghmD1fgp5EXa6s2ybhfKN5UFXOZHbOD8P7LLwt5FYqaGPg9y2nNk5T0xcoMpN7LWSXMGDw1OA+5mtQ9rkgH8y54DQkBAXNPhAGwANvhdpc0mlIRw/Q48tHsRLpXWqwQfgTydZ4AZO34cQQS+eusCY8yWRu/mnm0QGn+3pX5HiJ3s4ZI90fOQsS4NZdAB4sSlwLExABdWXqa7NQgvthshoW5mYyZc6LWiRtPJRmlNO3lmsLS2NiGkjhBt+rCaHeMhWJljiXC3dHG7Eojs6tZ2xTD/3t/ykTKIbk2e80H/j33XVaYcyDB07D4OTmwq0voMSLNLjsk+ZyjcZTmxeGf1Ze+Z5yGepuYe0uhQHkRsR1FMsheL5ffYdwhEP1gQZ/ID2zhT2mpuTOB9r3IKIfKjfxpek8SqFCu7H0H1n8lsw139yTYlw52Sx4ZI/UEImb/LI67vs6MSin66DnaTg9l97oKQaLQXpVAuBOMV8P6OsgjLADxkmsdUoL99dbG8
 F+WLlnOP
 F4AWxPoAnBKLTNuZLFBq8iKO8IgXHNw8+/I8huZa4b87laNmvCn5orTBX9SdULKheEXUpJmW7PpY1sHi4VWWA4hEzXY7DxxUXT3nW9p9kWDMwQXn85GAQ1jEFoebIrJJnQqJ4fEKbvbEhcvR3agJW+a139OnSMAJsRt6Cn5UxsP/CPC2ZFRLV9AWwsDJbAk38jkoBy5VaR52pf3DbHyw0LM9CCMb5w/Vmiw6vl2LYXKiykk9JufR009cKlz2Ho6HnfcQFiLKs+r3ZVkybxfk2IeyGgEq2BxRnxw3SHIfPCPbMS/g9OFrrfwB+SSwjC1JliEgSyIFedRDfISKfyLJzcmRSYHHOS/b0RyGQgnKsQhcuCfLKBkskw3ZfJUCjF6+qtjUYbz2zTlF+BsEgMB3AZGPANjsEuDs+Yg2Garu1g4uYt3HDTrIH88Eje1p1CPQ4uXoOOdUbWyMUKvcai1iZ3/10HUFk9kWtgtOADjITDKvt/mKIrKH+gX32d6a9GOK0U6OBURwZbfBkErEtSwz8eSkk9mYZYFpKnSo7V2hKUhq0GAmzGDAuHlq7wReWsLZoBUgEPP9aTJoELqg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 04:39:03PM -0400, Tal Zussman wrote:
> Sorry, I misunderstood and assumed you'd take care of it in a follow-up.
> I'll adjust it as below and send v8.

My plan was to move from the version you had to something better in a
follow-up.  Anyway, Jens merged it as-is so I'll look into a fixup.
Travelling for two conferences this week might make this a bit slow,
though.

> > And move setting the flag to iomap_ioend_writeback_submit, and only
> > for the case where no io_bio.bi_end_io is already assigned.
> > 
> 
> To confirm, this would only work because XFS provides its own task context
> and is the only consumer of iomap that sets its own io_bio.bi_end_io.
> If another filesystem set it and didn't provide task context, this would
> break, right? I can add a comment about this requirement, but I want to
> confirm the intent, as it feels a little fragile as-is.

Yes.  And I think this might be a good time to actually open code
iomap_ioend_writeback_submit in XFS and remove the "accept an overriden
bi_io_end" thing entirely.  Back in the original code that was required,
but now that the submission happens from a file system methods there is
no good reason for keeping it.


