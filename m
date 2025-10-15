Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE781CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 12:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 267978E002A; Wed, 15 Oct 2025 08:42:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23EF08E0020; Wed, 15 Oct 2025 08:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154D38E002A; Wed, 15 Oct 2025 08:42:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 047E98E0020
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:42:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ACC51C011F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:42:50 +0000 (UTC)
X-FDA: 84000312900.24.B6DA61E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id BFE4620019
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:42:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="fI/btDQ+"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760532169; a=rsa-sha256;
	cv=none;
	b=4Vnd9cB3mp6jnQzblvrlOmlaBUxBGcMxgoN6arF/FifulSWF7EcJTVeXWzjH/yT46OI70l
	2epfUBSLgHahXYDAbyiUHs3axKWWKYuDS+98Ypfx0Zj2cfBiZbz2Yk9FNC9wdoAKrEs9xr
	6RKZcG8zbBIre14Ffb9S2F1yD6/gJVw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="fI/btDQ+";
	dmarc=none;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760532169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YpvuTPdKEnG8kh0LAxrV4kemX2pr+zKEL9tcOV5VL8I=;
	b=ZQjnaoTvOn8sa3PCkabJ8IxFmjgoAf9UC/GSu/yZnRGWDsIfT1CnD2tOe9tOOttNQyGm3u
	LWYlKMCAOn1q+lwgiHzi4IYdE2gfhDsDHeErEZfFTa7r6A+E+4TljI2o5TeN9K58bsllUU
	zZQRYaL2yIBoHrF06Gu7sQfkoconAL4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YpvuTPdKEnG8kh0LAxrV4kemX2pr+zKEL9tcOV5VL8I=; b=fI/btDQ+F9gEXnHWCjEAcad140
	urwS1uun98p1hrl8iEQruMZQDp/zBFQmQBXo4R7HSpcZhdzduMnyZliYgxf6irVaT8nlXM4iLJIzp
	iLYcp7lv4oI5G37fONOIxl83ONG5babsrJ72ldiswk2uHDCoR9tkHaFl8IQ3k+3vk5YqEdnKKtmD3
	HGZHqEy8IX22QrnZHwzdyL7pdAfllhIavAgcgSWaL5oGZOSSoL20Qi1UDwYBN4UXlEzrA7TJSUD+h
	uu/dzmXvMuT50FUYCM+vXb13hamajcBDrWY56/uxMJbUCfmrUwVffupW2p9zaTkfSJCdig8ElmCC9
	UH14x4Rw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v90q6-0000000FRPV-0xq4;
	Wed, 15 Oct 2025 12:42:46 +0000
Date: Wed, 15 Oct 2025 13:42:46 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Message-ID: <aO-Wxj7al7I-IadV@casper.infradead.org>
References: <20251014182754.4329-1-vishal.moola@gmail.com>
 <aO9Z90vphRcyFv2n@milan>
 <aO97BjvNZNh0UV3u@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aO97BjvNZNh0UV3u@fedora>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BFE4620019
X-Stat-Signature: i16t38njz4togcjtsqeigbgsmqd8dnrh
X-HE-Tag: 1760532168-123617
X-HE-Meta: U2FsdGVkX1/iZ7yfpyfgKMMMElDIwCJJFK6YqDyCCpdvybEYBpctUE0Lt0+PjLyvwOsyGmuITk5GutVHRntHTz3RCjYUiWCMc0NYihGkLVmE2xdtjQgMC6LiB2vFeO/nKbLCdUq6ye46Yg9uCHK7Pp3Ha/P9fBEGMsPy9CH53tUZezLy0yHWxWgR9ASd/lP/oL5AVP8+NyTdSKctQHKYevJFzsOZKTaaL3YAUBW9L+XcUDqCq6c0x6hFAmt/LxtHoNrFQrHvZ2Na1KhRIOUT+HVBFgffhd5DyKkovfyWSxQ9AyEd7pmeki/CDfx/Cd0g7FQDqlQFyELQJcJLNd7bRrmNV71ol1G01jyTKNNUZs53VL6xcwF5iO1p8VIWFw/jwjOFIcN2a+HhM+yiW0qb4BAEprXdBhThKanH5OaER3Vv5RQvpLD+WiuTZjnLWFSvHOcK8940ukHHGDlIWU+E+pAE7TbO3mSXJf2hK3MV8kwcfsCFhfGimCy8hsOJOL0D1jZVW+y9SRAJCQvrb+oS4ZBXyZkiSbFmL/Pp4slJPKdQL+fMn8TMvO7m6jr0glJ544n9GWp6T/+1zDDxML5m71VjWxI1Rr9jkNT9gOzuOk1ZOip+jfqFndv69H6yRXCxWf2ixFT0f2YB3STeLeHlJmCMDlH2bnckCYHwFCnv3iodoXDMJ4oTNe3gSFarBaQpqmlgJXJHb2yTXVPSdxsMsJ83nnu17v7ugdpjrTHBED/Mq/HFcJ9hahRjumvtMqkMmr5Ty1ZfIMOOj4WtcYyNLXj5R6P3zRBM7jINLrJPHMGi6IaB+0r1klWTk0Ht9+PSd5ZH/HL3zpSZfh8V1Q21su3z1fXe2sfYhHr09ZN7W7st0Mkt7065T/Rzg3JavduyuOVzaungQKcMXuEJ0VaoZM4GBforF7+30YgnGc2pUNHgdQnjd2+QQDTkw8RsaG2dMndw/Mfb83nlP5Np0vb
 3hVu1CSv
 aknWwMCtUIigY+kTI9LSdQXEB3AtDS8i+vL1WTY2DjB4BEzzl2Z++dcINjlEeL7J2UPDtlfPy3645cirjibhnBHmzF9nG/cyLejhyNQA9KkUeD4P+jvj6n0onX2kck6m7CeOCqFxXibg7jLzok97ph7i97JwbZkRctVQHdxn+fQgwUWB65oK2tPTLz1tGdhdz60nzYOP065EuHNR9PicAz4em2ZII9YMW5Sn8Uh/GGyQPW1jabt0CWpEfkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 03:44:22AM -0700, Vishal Moola (Oracle) wrote:
> On Wed, Oct 15, 2025 at 10:23:19AM +0200, Uladzislau Rezki wrote:
> > >  	int i;
> > > +	gfp_t large_gfp = (gfp & ~__GFP_DIRECT_RECLAIM) | __GFP_NOWARN;
> > > +	unsigned int large_order = ilog2(nr_pages - nr_allocated);
> > >
> > If large_order is > MAX_ORDER - 1 then there is no need even try
> > larger_order attempt.

Oh, I meant to mention that too.  Yes, this should be min(MAX_ORDER, ilog2()).

> > Maybe it is worth to drop/warn if __GFP_COMP is set also?
> 
> split_page() has a BUG_ON(PageCompound) within, so we don't need one out
> here for now.

I don't think people actually call vmalloc() with __GFP_COMP set, but
clearing it would do no harm here.

> > The concern is then if it is a waste of high-order pages. Because we can
> > easily go with a single page allocator. Whereas someone in a system can not.
> 
> I feel like if we have high order pages available we'd rather allocate
> those. Since the buddy allocator just coalesces the pages when they're
> freed again, as soon as these allocations free up we are much more
> likely to have large order pages ready to go again.

My PoV is different from either of you -- that we actually want
to allocate the high-order pages when we can because it reduces
fragmentation.  If we allocate five separate pages to satisfy a 20kB
allocation, those may come from five different 2MB pages (since they're
probably coming from the pcp lists which after a sufficiently long period
of running will be a jumble).  Whereas if we allocate an order-2 page
and an order-0 page, those can come from at most two 2MB pages.

I understand the "allocating order-0 pages helps by using up the remnants
of previous allocations" argument.  But I think on the whole we need to
be doing larger allocations where possible, not smaller ones.


