Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 351CDCA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 08:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50A4D6B0088; Mon,  5 Oct 2026 04:23:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E26A6B008C; Mon,  5 Oct 2026 04:23:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41E9F6B0093; Mon,  5 Oct 2026 04:23:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 233686B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:23:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2D0FA0179
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:23:39 +0000 (UTC)
X-FDA: 85287883758.16.8776B67
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3CDC0A0007
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:23:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=YqNqHgSG;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of BATV+468a587a01b7da22bf06+8443+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+468a587a01b7da22bf06+8443+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791188618;
	b=a96lHmzi9p0otVtoTmPPyENESSdZlnCM3IdQ8Sxg888zdLba4yRQNMMkM/30b1AwT6Qd3e
	CLWfK/ucJ1uxWPHlk0VwpHOCEy0Mn96CVyQzjobjhQmp3EvnEPyVI06D8qjA25t8tXbEb1
	W27zcb0tBod8gjfi49n4/moF35eKSg0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=YqNqHgSG;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of BATV+468a587a01b7da22bf06+8443+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+468a587a01b7da22bf06+8443+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791188618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z6VraAbnd2mT0BKdlhv+L+o2/2Wa3LZYIp6gFv/bUHI=;
	b=w6g6MdKx1aAFyTxtgZ+uiW8+KRBu/8yOl7XhfXUmP23W/cvlj99q1/obGODlfCMyq8IkfE
	KMdCI+HzMP4rDKtRqYGQPZAA6nCRBsZ9zrETk/7lPqM+qINY4tB4l+FmDfttSBPlLG7pkk
	xXnD3rh1PPk5DpG97zerAkMvMZ/VnSs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z6VraAbnd2mT0BKdlhv+L+o2/2Wa3LZYIp6gFv/bUHI=; b=YqNqHgSGGmvFI3iveGjHa2tQ2L
	/jV3Ue8G5JbgDOIW+Gk4sFHwIF2YOp+16iyTnT9RAjDCE+Yqtx7kTfP0FJcXsNz2o8T05Vm9rVD+G
	1psAI2EuqbDvwbuvfVYIESVhuvVi5w+VRMVb9Lamqgt1kIxqVmFPYRAcWxWE0cH0khMrZlahHqj8/
	EEnFIEoASG2pNz5gA6XfR3c0TlJyU5I8OhDTddikXAVOMQwcysbo+fJvWSO2venfdD18/pjs8wOOl
	q5o7G+o3NxhQbKCXPhbFIZygzSFInSBjkGaRHlVZFrAscdKwbjawO+gzny9tYUcY7koj9JTMvZh+V
	jC0O0gKQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDdyk-0000000FsEH-47BZ;
	Mon, 05 Oct 2026 08:23:23 +0000
Date: Mon, 5 Oct 2026 01:23:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Alexandre Ghiti <alexghiti@meta.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>
Subject: Re: [RFC PATCH 1/4] block: do not issue background swap bios as root
Message-ID: <asNeenTiIme0kzI6@infradead.org>
References: <20260928081900.4187482-1-alex@ghiti.fr>
 <20260928081900.4187482-2-alex@ghiti.fr>
 <aro28ZGuYgmNg_n5@infradead.org>
 <CAEmasaX-6v_EpwAxHtnhA5SXk=jGW8+Lm4m8zAC=+f0yXmiCxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEmasaX-6v_EpwAxHtnhA5SXk=jGW8+Lm4m8zAC=+f0yXmiCxw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam06
X-Stat-Signature: wc75sracqfs6qhh43pninj519b16ym4m
X-Rspam-User: 
X-Rspamd-Queue-Id: 3CDC0A0007
X-HE-Tag: 1791188617-476624
X-HE-Meta: U2FsdGVkX1+4JRDcaiIsUNsbl177errpw9GBLykO3hZsb8DvcCN9wPobGnF0ALCQ2PoQiD67gSIYU1wc9YUWamGireVOvFkGKxT3UwuFeiYC0yE1dGJNIrWpnPuh8Y2wV+DK4Gh38k7vPuvM0hl89H4HdwWTxWqfvJoKdfpET+fnuzyDpfb1Wq2LEvViWWQayd4TKW2XbX42m/mNlJnavx0wOI7f+Pcxqd1sErpgEBFjR0NUDvPJ8CtjtNxkTu081XtdtdR1KG/+sCiw9J8ibrqorCHRsuHxzF7cGYTbcCNRyFmpVljJc+/vyzwySDUW/braf3FFt4vTlnRQfD5utzhpocB/nc2J1tyGTVbmDNZc8Z8ChqYJTQs10TU81IXrEmszS87Vz2vbNNgNJqQQeMLi5jMi080q5ZcP1KDXKKC3j2jQtF07dWu7Ie6hAhPw9Qp1loOdxCMg0W8qhmJWK3M9RH9wT0Q51xhbT097nLsE7AhAe8BE2Fi7EBmuiP9QITkK+VJvVbshXo+6ytCwkca9uAy0FPBfm75CEd3AykyfCv6OJM9COMYt6HdmNC98T6jd3xRa68lmeO2G121rOiQbSqiRmQNTxz/w7voen04XCme1Hol0aKZZ90B3O/PZ3GoyHod4cl5vqfLXiEwts8Dei2QF91YxVILAvc/ZtOgfKNv4dIJfYZhbWmqnzCz72bZIRTGIdvebA84tm5TOMAyBMyCMoqCMzlQh9l+Mj3cCo52jQ55wPIOdNMowMcCcWEzQXjq21yLBksPSw4lG9aXjQSUvFyh9sSmOGcCLpEDBOWjKJe6PKGaJuupRn4sZE+VjdfqvSa+WqYPSc4h9/P2GlGYEKvgPW/lYRgSm/M62ifsGYF0zb2QCMjnjuSxMw4GbpjrO447spUU/M+uNi63aG5A2PSfyqouKEjFgt6tH8Zq6gHIN2xdllApFgV01Oom1/UoLXlmWXEDI1JX
 F3jUM0Km
 ZZvFXXmByaLXof7wFSCv5CiWAr95fXH1CYjsFtrL9hJVWhn48cE5mTStTpq8ATNCBI0O+fF6gR3hm/7E60eUP/5yEuV0BGE3PNGQ3uzMkX3qmo+Ei1f+ish+Rkiasax58ETOFrvrREQ/Khnhbo7/crkg5OPKVz5xJm9ihzxeerEgzStfZu/Rpq+tR8M5zFTgWKFv9Olns5D8Wjstykzj4L+Br6Q3E4KHb+wnTP1R3RKGx2+AmVBD6FAsjnTPIJy/7U3yi/WN6LNXwntgTqyEhwlgI9NkSdbNZUyRpaZornYuR/cQC7RPsOsrGjUqhQZoCQtmNvp3S2Nrb7G2SKrmrG/Thuaoa9VgzDxlk9C1/h0G/m5pRXZuiArDqe6+m3RiIHfLDa5oFIyJQhTZZhP240So+rE0T8kyNH5tQzKiimbjM9K0R5FwcLeNv/TgEx4wacj2rzXvZkxnMf4w4POGijwCC0xXQdCYpMqndZICjB+4WAeANaX0GgASKGP/ZYV2Uc1/QgQbuIae1dFBv6Px4BayD/Zg8nH/j3AUngNdaDLcw9AMzK/TBOCB/8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 11:16:03AM +0200, Alexandre Ghiti wrote:
> > >
> > > Such a bio cannot simply drop REQ_SWAP: dm-crypt and dm-thin rely on it
> > > for limit_swap_bios, which caps in-flight swap bios to avoid a memory
> > > deadlock, see commit a666e5c05e7c ("dm: fix deadlock when swapping to
> > > encrypted device").
> >
> > Is that true?  REQ_BACKGROUND very much implies the I/O can the throttled
> > and thus better not be foreground paging, and thus the caller should be
> > able to tolerate a failure.
> >
> 
> Yes, I agree, zswap writebacks are only best effort and in case of
> failure, the compressed entry still lives. I don't see how
> REQ_BACKGROUND could be an issue there?

The issue is that by definition it doesn't need REQ_SWAP then.

Then again the whole concept of REQ_SWAP looks sketchy to me, non-swap
paging can be just as important for forward progress, so if a driver
needs it, it has other issues anyway.

