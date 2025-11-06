Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F105CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 14:13:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 968318E0003; Thu,  6 Nov 2025 09:13:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93FBB8E0002; Thu,  6 Nov 2025 09:13:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87D0C8E0003; Thu,  6 Nov 2025 09:13:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75D018E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:13:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2DBFB894F6
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:13:16 +0000 (UTC)
X-FDA: 84080374392.01.B09D84D
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf02.hostedemail.com (Postfix) with ESMTP id 520358000F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:13:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762438394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8fAkQBIlD6f7n3hEnlHdfAp5lgAPWMsEoCGf9o50SZ4=;
	b=QXP8HexwSRMvmOIOoj3XM1+P8dUTZKOxL3pFdgbC0Rv0963mKCFtDst14ZUrh9eYDD1Bwo
	473pr19flKM6dHrGZ37bVz0Z7SvEW3rD7lAe7zFcQwT4usQ/6q3kaCZkXstYoIJzduVuPm
	/nm8oEH48ALdk8DgyknjxwkGYw+rwY4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762438394; a=rsa-sha256;
	cv=none;
	b=grQPro+iUhDPQ7e1t9xmCJLp5IHchggDGDag6TtsJZ9mQlCpKPX7q5PLaEjjH0cG6/hRrd
	B5tqtumXl0LESRl2A2sVQ5xGCM1gPYEHBrcQRN5ceZAkyMkUdcdR5NdfbslHGDcVGXsvnv
	zEGzL2hht5TVaLoU5+xVGLe+si9R1qI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 10E97227AAE; Thu,  6 Nov 2025 15:13:07 +0100 (CET)
Date: Thu, 6 Nov 2025 15:13:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/9] mempool: add mempool_{alloc,free}_bulk
Message-ID: <20251106141306.GA12043@lst.de>
References: <20251031093517.1603379-1-hch@lst.de> <20251031093517.1603379-4-hch@lst.de> <1fff522d-1987-4dcc-a6a2-4406a22d3ec2@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fff522d-1987-4dcc-a6a2-4406a22d3ec2@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 520358000F
X-Stat-Signature: szumqgdzhd5wxsn1t6g3igh5ioue8de8
X-Rspam-User: 
X-HE-Tag: 1762438394-440477
X-HE-Meta: U2FsdGVkX18nJiFin1qSCXaoNwgO5jZIVs8WqrR6Tke6HBHSLzUDgKk1NiEn7bxYLEX8Ot7sGu1DHRkqwRdQn9CJKO91llpmUk3EluGNVOZhC0t++zOd5WRh7OnrYd3dv4RJN84YdF67k2lNWzt3sZ52XuLA++L6crPenGxUnogugFkMc9n2q+d2BXLXdaIUmS9jDgB3x7djNonJtaEZbI8qDTW0X2WKF7192VkzEt9CTseLrWkDbid5qhQ+v7++cE+0b8pqs42X1XlwPh3eL4GWk3dOHbHqC65ScaxoqDqc2ABSTtLAwc3Pw0NFzAF3puvLLFiHIPFiIMv3x3WqOUFsLZW4W0BtubXoi8dWT2GL1wOGnYZULNCHhKqJR/jiK6VbcRfUKqiaz8+GNGae5na1RZ5uaqTCsgkbVb/0gBPIWhlicEny176X81EvREcBF/z73L6ppmx6uolQnQxOCoINHXe+MsXp7Jge0Z00bXcdvGAQmddpwN2l1K14wgOj3PxegOsGCAWv/vMV4U/64otBOSWZzEIZacue/EFV8muOM0xJeQkuCnly5vyAlMUV6/KNJTV3CtptW+e5KUp1IBvptCR8+dh2Hg2j8n2rChkvClcFbk7zfGOG2xleqQP/kh0iG4dsEHa/0p90LAUXuFfR87/B8dXLhMZaDkkDAyhE6PyLW61WqYC1bFt9CHW/tuLOiXwqsUPBKXo1caXX6ST5ENw+gSk+1WzIgx4gu055PrqdALMN9txE/BPKxU5c6Oj52O/8tubs8hZg3JgYZgbhsEpgFt9Uj1kZNVZFRztvELhg+z+NKie8NxEjA1v+AnD9Wn1GssWaxaLdj7fE1qviNLLu+EqDzbfW4VXUZJcGetInirHl8fsqhsqo4y+ptec70MdyYLlo7Wv9RqOqpH7n25SpxO5ueatCDAoCYovVl1HEQXedNb2RoyIDtrWI8QpfZtqK9ZL50Unkk3h
 J9de6ADx
 NlruGJd3C14PNxWlsdd0KMwM5XmwlZ8ShiR4k0rtLozsbjjmu78diDayZVGZ2WsgLcR7prbS74p9rWukoWxTnVMsYKcTgN+kIWYLBdbsiqZCTTW5MDhAcpUz4TI8+qXiIGkQJ3EO/I7K3jvA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 04:04:53PM +0100, Vlastimil Babka wrote:
> > +	for (; i < count; i++) {
> > +		if (!elem[i]) {
> > +			if (should_fail_ex(&fail_mempool_alloc, 1,
> > +					FAULT_NOWARN)) {
> > +				pr_info("forcing pool usage for pool %pS\n",
> > +					(void *)caller_ip);
> > +				goto use_pool;
> > +			}
> 
> Would it be enough to do this failure injection attempt once and not in
> every iteration?

Well, that would only test failure handling for the first element. Or
you mean don't call it again if called once?

> >  	/*
> > @@ -445,10 +463,12 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
> >  	/* We must not sleep if !__GFP_DIRECT_RECLAIM */
> >  	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
> >  		spin_unlock_irqrestore(&pool->lock, flags);
> > -		return NULL;
> > +		if (i > 0)
> > +			mempool_free_bulk(pool, elem + i, count - i);
> 
> I don't understand why we are trying to free from i to count and not from 0
> to i? Seems buggy, there will likely be NULLs which might go through
> add_element() which assumes they are not NULL.

Yes, this looks like broken copy and paste.  The again I'm not even
sure who calls into mempool without __GFP_DIRECT_RECLAIM reset, as
that's kinda pointless.

> Assuming this is fixed we might still have confusing API. We might be
> freeing away elements that were already in the array when
> mempool_alloc_bulk() was called. OTOH the pool might be missing less than i
> elements and mempool_free_bulk() will not do anything with the rest.
> Anything beyond i is untouched. The caller has no idea what's in the array
> after getting this -ENOMEM. (alloc_pages_bulk() returns the number of pages
> there).
> Maybe it's acceptable (your usecase I think doesn't even add a caller that
> can't block), but needs documenting clearly.

I'm tempted to just disallow !__GFP_DIRECT_RECLAIM bulk allocations.
That feature seems to being a lot of trouble for no real gain, as
we can't use mempool as a guaranteed allocator there, so it's kinda
pointless.

> So in theory callers waiting for many objects might wait indefinitely to
> find enough objects in the pool, while smaller callers succeed their
> allocations and deplete the pool. Mempools never provided some fair ordering
> of waiters, but this might make it worse deterministically instead of
> randomly. Guess it's not such a problem if all callers are comparable in
> number of objects.

Yeah, which is the use case.

> >   * This function only sleeps if the free_fn callback sleeps.
> 
> This part now only applies to mempool_free() ?

Both mempool_free and mempool_free_bulk.


