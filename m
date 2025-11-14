Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01680CDE006
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 05:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43A9B8E0007; Fri, 14 Nov 2025 00:56:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411F78E0002; Fri, 14 Nov 2025 00:56:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 377138E0007; Fri, 14 Nov 2025 00:56:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 278958E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:56:25 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A96F45805C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 05:56:24 +0000 (UTC)
X-FDA: 84108152688.18.4F7B2F9
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf11.hostedemail.com (Postfix) with ESMTP id B66F740009
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 05:56:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763099783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BGNNZZ8E8TzgHHvxMhkmKiog8A6jHZck8tvBZ1J42L0=;
	b=tvoKRR+oYnqqwNxvasfQ0bGeMvwDZSpYbmUG/Quh5Pv6RjfHiMZmblP4mZ8UmQ1SAzsM8j
	WLhlmEHMWGubTy0gxhFPdaYn5PYNxl5+VV274E13Hql6q95GSLJFttC4szmqJXknMJIuCt
	3lci8giJpswZNmTK5v4whj7UkrbhKmA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763099783; a=rsa-sha256;
	cv=none;
	b=dhrdhsA/HGqZHMWTiFkHB5Tj5ZO2pxpGMo0plWdrv5w7n+QZJ/CDy0w5rzfTVW8CoEvM+8
	0AFlRSaAd+b3d1kpoRRz7yxu9GCRuSpR63n+8BVCBxHT+he1dmw8Gv3XfFp4bxej2FaEFL
	5xcVtjkjJEX4/vfXT40YOGmVt/YKxJ4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0D3B9227A88; Fri, 14 Nov 2025 06:56:15 +0100 (CET)
Date: Fri, 14 Nov 2025 06:56:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 6/9] blk-crypto: optimize bio splitting in
 blk_crypto_fallback_encrypt_bio
Message-ID: <20251114055615.GA27241@lst.de>
References: <20251031093517.1603379-1-hch@lst.de> <20251031093517.1603379-7-hch@lst.de> <20251114002210.GA30712@quark>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114002210.GA30712@quark>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B66F740009
X-Stat-Signature: nf7jrbojtzt7c1d5u3ysekam3ohu5orp
X-Rspam-User: 
X-HE-Tag: 1763099782-543967
X-HE-Meta: U2FsdGVkX1/wJZ0j/01yu+ZV/bVHGQWAURwUUS96Umgq1InAf53lUqYxhzYf9KbOKVvrxEUwOOt4qst+BdLYLWY+cxQabh1RHxzwpeU4Avt0gD9Cr2Ywc/Xq03WKikcGxUp74ZdATjHckxGlIoEd4Yi8jeRa/3kmTuyYok8+orieaBX6dQo3D3NeqKlpYB1thmXrFOVRSdhlMVTQ/KtUV3SOX1bl/q9B5axR7M64u3oxiHHQQOTRv8N+72e2ggL/XqSpe0gPWV5dw+nS05+BeyOL/jUJL2eZgugweUb5r/+3AtkInrT8uC/YAZd2j+ifBC94ORlFmFHmyP4EDTwgkpIkre0dzeY3n5vxD0+vfqVwTMSFn2/cJ4Ue7eSDyVtuYSoWksL+a041ECORZclWVD5pWIw/MC93LKjOHK40q+qjxLrijBuIXaQpj68/uJf/EIU/abo8YQO6FDJUjwBe1VsNXiW8wZLbQem505hyh4yVr7tO8FpXZnVy/d+/7tosV4A+EXFEUNa9gFu6cjm6EZ2sEd6pIhCzjgNr2ZhpJ5BuwiCeXDSf1cEAnHpBoh1WJTU3EZ7Knf9l7d76w4wT+0gvKWPPdgFUWfw9kn+dBIoan8gZVVCMSPTZvcjh4EM0gFn7F4yfwKS2kVjDkcep/8uFwRBZda462mailXeoJtrWbp5ZZqp1HXcJLi1CGnhom+rJ1AIvm0uq7x4oz3FpRbdRRyqgzYQBaRs/QOwrL48a4cVXbwBrsVn3vC7JUlODRNNpMnKPX+LAL8wOauyO7AJ4fMQ8JBubH7YWUS7uFOMc7w8/5PBYC1858bq+mA5zZ6Il8zMFZ1m8GzPvHFNzwyjtqYZj7wahmPgQ97294RIFZ7AuU3/ZkdPvLbLZhSFPkM0DCTBZpIfJ6/U3ovMhL043bSdqehioo5o0Ws37E6j3Qfldo7OayxQE5ltk9Au7syt1iArFLv0UVrhdqRQ
 WElj+loV
 fWZh9mVQUM2UvPyIshhUmn6cCMrrVditlowQCx1kYDBPwzYfM758MUxIcWbvriyd+ooMzi/1ig8xbpNAI7I4ptqxbCTzK8lOrtWSJ7yPdssTm4Pf1tvpseKAmFYZ6RBB0yiXWshoO0/GHbCg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 04:22:10PM -0800, Eric Biggers wrote:
> > --- a/block/blk-crypto-fallback.c
> > +++ b/block/blk-crypto-fallback.c
> > @@ -152,35 +152,26 @@ static void blk_crypto_fallback_encrypt_endio(struct bio *enc_bio)
> >  
> >  	src_bio->bi_status = enc_bio->bi_status;
> 
> There can now be multiple enc_bios completing for the same src_bio, so
> this needs something like:
> 
> 	if (enc_bio->bi_status)
> 		cmpxchg(&src_bio->bi_status, 0, enc_bio->bi_status);

Yes.

> > -static struct bio *blk_crypto_fallback_clone_bio(struct bio *bio_src)
> > +static struct bio *blk_crypto_alloc_enc_bio(struct bio *bio_src,
> > +		unsigned int nr_segs)
> >  {
> > -	unsigned int nr_segs = bio_segments(bio_src);
> > -	struct bvec_iter iter;
> > -	struct bio_vec bv;
> >  	struct bio *bio;
> >  
> > -	bio = bio_kmalloc(nr_segs, GFP_NOIO);
> > -	if (!bio)
> > -		return NULL;
> > -	bio_init_inline(bio, bio_src->bi_bdev, nr_segs, bio_src->bi_opf);
> > +	bio = bio_alloc_bioset(bio_src->bi_bdev, nr_segs, bio_src->bi_opf,
> > +			GFP_NOIO, &crypto_bio_split);
> 
> Rename crypto_bio_split => enc_bio_set?

Sure.

> >  static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
> >  {
> 
> I don't think this patch makes sense by itself, since it leaves the
> bio_ptr argument that is used to return a single enc_bio.  It does get
> updated later in the series, but it seems that additional change to how
> this function is called should go earlier in the series.

I'll look into it.

> 
> > +	/* Encrypt each page in the origin bio */
> 
> Maybe origin => source, so that consistent terminology is used.

Ok.

> 
> > +		if (++enc_idx == enc_bio->bi_max_vecs) {
> > +			/*
> > +			 * Each encrypted bio will call bio_endio in the
> > +			 * completion handler, so ensure the remaining count
> > +			 * matches the number of submitted bios.
> > +			 */
> > +			bio_inc_remaining(src_bio);
> > +			submit_bio(enc_bio);
> 
> The above comment is a bit confusing and could be made clearer.  When we
> get here for the first time for example, we increment remaining from 1
> to 2.  It doesn't match the number of bios submitted so far, but rather
> is one more than it.  The extra one pairs with the submit_bio() outside
> the loop.  Maybe consider the following:
> 
> 			/*
> 			 * For each additional encrypted bio submitted,
> 			 * increment the source bio's remaining count.  Each
> 			 * encrypted bio's completion handler calls bio_endio on
> 			 * the source bio, so this keeps the source bio from
> 			 * completing until the last encrypted bio does.
> 			 */

Yeah.  The comment is a leftover from a previous version that worked a
little differently.

> > +out_ioerror:
> > +	while (enc_idx > 0)
> > +		mempool_free(enc_bio->bi_io_vec[enc_idx--].bv_page,
> > +			     blk_crypto_bounce_page_pool);
> > +	bio_put(enc_bio);
> > +	src_bio->bi_status = BLK_STS_IOERR;
> 
> This error path doesn't seem correct at all.  It would need to free the
> full set of pages in enc_bio, not just the ones initialized so far.

As of this patch the pages are allocated as we go, so I think this is
correct.

> It
> would also need to use cmpxchg() to correctly set an error on the
> src_bio considering that blk_crypto_fallback_encrypt_endio() be trying
> to do it concurrently too, and then call bio_endio() on it.

Yeah.

> (It's annoying that encryption errors need to be handled at all.  When I
> eventually convert this to use lib/crypto/, the encryption functions are
> just going to return void.  But for now this is using the traditional
> API, which can fail, so technically errors need to be handled...)

I can't wait for the library conversion to happen :)


