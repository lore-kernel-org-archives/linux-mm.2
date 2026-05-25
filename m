Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7433FCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 13:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95CA06B0005; Mon, 25 May 2026 09:29:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90D9A6B0088; Mon, 25 May 2026 09:29:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823506B008A; Mon, 25 May 2026 09:29:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70F296B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:29:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 165331A00E8
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:29:32 +0000 (UTC)
X-FDA: 84806024184.10.9A61E90
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 93A05180004
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:29:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VIftsuP1;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779715770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bLsJutUZxDEIl/uXq2CeXvS0Y6SzcdSFKEmmUvrQt/Q=;
	b=kICEFLRYjLljCsCsRpb4xnvVEEumTGi1aZJCpSOrD5rqjAqx2NRgQNH2s+8MRbrT0LvgNQ
	Zg21ow16XwLJtRbxBrECc1bKgYx86CS/bYlpsyth7efglTV3Jph/+17i0OpcfDHvYktnT7
	A8Y+R+nkBWzu395CdkAtJ5RSnlxRVdk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VIftsuP1;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779715770; a=rsa-sha256;
	cv=none;
	b=ND0ViUJTrmK87zx+3t+siIrVkSjvcarWqpvvyFxXF9umPecUEHOW1lg80DAboI+63FrrzV
	TtWzkbYjD8cHwCfKkVsASI1YrDW/0Nmg0VT/w5vcZIn4QVVRKL+2z3MzPTX4xhrDEUYSzP
	k4RF5kCva2WgYmWJ66LuJvU3c0B84GI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bLsJutUZxDEIl/uXq2CeXvS0Y6SzcdSFKEmmUvrQt/Q=; b=VIftsuP1+Tx/xZtsLM00lHaZHC
	VLR9Y6UK2Ei8ZyiUbDPvORAXabqK8uVbkCVBdtUuNR9FOkGcnIYWwQiTBTQWdt7R0P2L8wmaEaaNh
	doUvPHMi6GiAaPtQSY8oZ6uzqlZqE1yN/SZn8hQWt1+Q3gbMuv833AXmlAbxbtriAjyBO/SF6NyA5
	3LsieRuwYBXlS1VNnyz4vONfRz4U4pifO5UrlkYKmZiI+IoD4Ds57OHvrUv/B1j1U8f7DHBk15TFz
	yv8xzM2xPZ6VLSiPBvDy1c3LXO8rpW2CP3DkrnzdEM4mNphGrOtY/Mh4o3jPSq9ek6cswYaZ35XE9
	14SToxMw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRVN1-0000000H9UB-2Rne;
	Mon, 25 May 2026 13:29:27 +0000
Date: Mon, 25 May 2026 14:29:27 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-mm@kvack.org, Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] block: Add bvec_folio()
Message-ID: <ahROtyLcr567wM8l@casper.infradead.org>
References: <20260522182122.2489391-1-willy@infradead.org>
 <ahPm4h2gKgyEEuvV@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahPm4h2gKgyEEuvV@infradead.org>
X-Stat-Signature: 1uctrb3dmn14fwt1ng61be4hd9s3dk9s
X-Rspamd-Queue-Id: 93A05180004
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779715769-596956
X-HE-Meta: U2FsdGVkX19aCOUxtuRpH0XWIeCt2eMrNbyPhSkmHLvTkZ+5hsgEEOjPhB7jxrW/DxeKbo31ejrPaaH1MNagJRkldMqmBwtNmFrIMvv6oG93FTEHgSi3muWceCF7Omm2tlP7Wdx4cfRdfYEgpYeFgfYWK7vZ5wBwIKAQbd6sWf6y0ps5hNLflhVm5liYkaC0sNmQmFdQObe/QBP0fT8aK4VS34eMag29LQn0NL7jKe76cQ/sDXNo9xZzH7saGcx1uhtjVZp9/KW5lPTvV71USRuIwTOWiUw/GNw07Rf04ua1GoaXU/SWc5xCWW5qWy1nrZb3s0UIxuKpyNx20TctV8Sw6vnjSm84E4lwKJzbK9zcxIaFfhhbldikBI3B70Tso7ZyqkL8J60xYzGH9dm4KSwh7K/6gewQHVha/Wd3IQxl31cprPtphmInw+kAXw/nrgsEX93o6EE6XLtMPs6Wm5hWfZ1KEakk91ZOYkvl9AkFujt7/mOlyYXN3D/HyyjWN1k0IrgAWbFevCAeP6NM8fUQ2JsrkSAxt54VJEZgQQuytlr7RJW/5ClXHCGA5Waej9aQVMS6bu7nscodgDc6HukB4Z78/AuweZsd+Bbuu7ZkssHAbCNLixbdrCluYdbSg1Z+NsPdFXaFGyUDuFN7HSnNnnOCHt1OvupteIXSo5GTAgQDqxwBcwEuzywTyJfxxTHVKgygbU7JUDEuQDgyPjObO9e83Gq//3X+QYF+MIcrgaB2gN3wZ2DRXdmJ+TVYAJHFEb9LEFvKUmrjAZLXvTgRS3MubpgfDcAqpo+0ieRG7hdPaKGjoO4P3xAz4toWFW1fr0QikxT5ECtq72pF1TZlqy6XzzJNqOBcZ0YILrIJ0ueLTle1D7q8/kMuF4vE47lKpG4TpEcojGxgh0gS45pO5CC5H43RTo1v1l+264ZQrVKSc2TsXMSGWqlOnX1xuw5mKbRpYkD6SVaV/KJ
 LmH9WrTQ
 sV/yA/MoQt+ZDyeIuRyLtnkhZmKJBR9H0kUExzmyLbLYd9Kws9GYl6v33gm6kzDZaO1XfY3L7J383PO7Nq5h5uU+EeSk8GL9qU5ov1thvfB9lBBuy47G4yJpLirNDftf/tvO5UXUzLKNVetQyym9Codh1ILa9gvRwoPxlJcz5a4rWTro5BswuQlPIpXtP8CQYZGyoONz1UBFG2qnJqzv6hj0Mj2XM8HwSVdDMx/lNUQ5I9eiEB4773vxKfso+1g0k4xuSaFpGN7g03G1b2L3jQMqZdqKC8hTRWirH72GCyh1BmXg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 24, 2026 at 11:06:26PM -0700, Christoph Hellwig wrote:
> > +/**
> > + * bvec_folio - Return the first folio referenced by this bvec
> > + * @bv: bvec to access
> > + *
> > + * bvecs can span multiple folios.  Unless you know that this
> > + * bvec does not, you may be better off using something like
> > + * bio_for_each_folio_all() which iterates over all folios.
> > + */
> > +static inline struct folio *bvec_folio(const struct bio_vec *bv)
> > +{
> > +	return page_folio(bv->bv_page);
> > +}
> 
> The comment here is confusing.  bio_for_each_folio_all is a helper that
> only works in the submitter side, and not for anything using the
> bvec_iter required for drivers or anything else sitting below a
> potential bio clone/split or using bvecs from an upper layer (like
> ITER_BVEC direct I/O).  Additionally bv_page can be a different
> page than the fist page due to large bv_offset on split bios.
> 
> So I'm not against the function per se, but the documentation must
> explain the minefields it is stepping into a bit better.

Lower level drivers shouldn't be concerning themselves with folios.
For a start, we can put non-folios (eg slab memory) into bvecs.
I'm happy to clarify this comment further, but I don't understand
who's going to look at this function and need to have more explanation.

