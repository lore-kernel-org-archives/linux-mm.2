Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B539CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01FC48E0013; Wed, 12 Nov 2025 10:48:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F39D88E0008; Wed, 12 Nov 2025 10:48:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4F468E0013; Wed, 12 Nov 2025 10:48:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D14948E0008
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:48:04 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C951598F7
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:48:04 +0000 (UTC)
X-FDA: 84102386088.23.A7A9CDF
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9613D1C0006
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:48:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf18.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762962482; a=rsa-sha256;
	cv=none;
	b=gHZpQ/mGZ8dCcf/UUM2uT9roCWXMuUAnj89iukH7Aueaol3njC8/w6VDHEVGbdzbeWbMO7
	si2WPr4YRtI9yPg1E80YG7MFMyXlO8xFvvINO9EyIzNPCS6jsxbUgj2x385eYnEZ+drkHc
	89JWYxFslYdXAzgkmVHGN9uJKO7JG0o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf18.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762962482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NjhXyUNfTJ2LTwD03MVkqGj334wF9rOzBcdteiHIGYU=;
	b=tT6H+GkIvLXNp1lIh29JzZmJnlLjXpy86YuCZmUycGDSbky+BA4M8KHI+7VJmSBpKV5zAk
	N7f4J1ysY5RinhufmI1t0ifx7mluebkqeeCDcC+tftHYZhrLUV/uyOyiz7N3V7UxmqKecB
	+esj7SfdjziBIyb8Xi0iIm5FfiJ7UBg=
Received: by verein.lst.de (Postfix, from userid 2407)
	id B2F0068AFE; Wed, 12 Nov 2025 16:47:55 +0100 (CET)
Date: Wed, 12 Nov 2025 16:47:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Eric Biggers <ebiggers@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] mempool: add mempool_{alloc,free}_bulk
Message-ID: <20251112154754.GB7209@lst.de>
References: <20251111135300.752962-1-hch@lst.de> <20251111135300.752962-8-hch@lst.de> <c691c9c1-a513-4db3-95f6-3d24111680b7@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c691c9c1-a513-4db3-95f6-3d24111680b7@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9613D1C0006
X-Stat-Signature: go1e7e7pirxc43sbnawu6gg3qt5p4rja
X-HE-Tag: 1762962482-314546
X-HE-Meta: U2FsdGVkX190D0/1Pm+AdmZK2N09x2dQVOAGghMwJ/w350VqFGVPaCX3NciKlQYgQ2kWOgEwZFVOCJU2TUqnCoeLMm3z+z0EANwPjG61KwvP+8NqQhqYIj8ZXSx0IEWQw3sULmbmoWIGByABqiuihAjhwk+4svIEkF++fko+35eYGPzds7OHh1lLBJr+GmS5yj+x8PjgIGsb6HrCkxIHIfs+SYkgfhoyEUCD+eYYmwg+N8yUvxDVtSBoTZSGthIKzq7okgUsafOZeT0UaPe1MHw23d1L5fs+KDA39jQKjyvkH9EutCwEeqOqXg/XNpxyHL3EEjlWEk/O5nrnF/tOSsNqP/B7DEXmm0W5ZmGFmVUxKWsqu00iCExc9pWKLKRhtNje27QQLSb7yEkp0yBWKdh593mUOM8BNY3OlJqjDaYdtB3uFyOJhaaAUxE14pTcH0DAAVJoXzyGDhExTVrfg1qiFPTntpfZnM8D4B9xr/B3wAJcKIEWDzSEE446emT9JJyyAu+svc7z/U5hMjLivds4bOpjPvK8TqNKX+tM8r0kTBBlEOmiY4U2VnN/J05LnMazI6l+aGFFNiFF2IBT4C5XeXwvXFKPK23JEdBs0NE0Z6Oad9LSDDQ/iShE6ojaFaoYpX3OFHviNgNQZzcE+qNwL5wYnyvg4WjGKDl8RpC6ufe/Ix8Jh7tqHw7ScMsWtN2uu63TAG1hTdRbU/5RNVAOpsmr+80WlmbwEUDKmq9bhRYI4vRMHoahx4j/AuWVRlddRgqLNsPILD9cat6Gz+dx4qRv963xlyFmaACE2sdSqjMqreLdoRS/VDZFv1rguCXedm3wY96aHOFu7YU7XdqVxM6fCk9rIuWwRAimULV+CxD68irFV33QoIWzfT+2z7qWNoK/FPSbeCQmnFbJDoAYQ1Ta7hVjdTDK4nKpdUVsx4J6hA9eSEg4V1EiAWS+I2QxjcaKcc9yOzrkZlD
 4utr1ZCf
 6cCsramFw7SzmMcTAL2C4z0S/qN2g2rUoDlmk610MsSYs5hgdLJ/RR4y3m3B4xw7m7pvT+KU3KTfJI++6ioK/mo+PUDbduvdRKlEDctOvgGlwPt68jJfG4PSX7Co33T+E2/m9yo7yes19WIU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 01:20:21PM +0100, Vlastimil Babka wrote:
> > +	if (IS_ERR(fault_create_debugfs_attr("fail_mempool_alloc", NULL,
> > +			&fail_mempool_alloc)) ||
> > +	    IS_ERR(fault_create_debugfs_attr("fail_mempool_alloc_bulk", NULL,
> > +			&fail_mempool_alloc_bulk)))
> > +		return -ENOMEM;
> 
> Pedantically speaking the error (from debugfs_create_dir()) might be
> different, probably doesn't matter in practice.

Yeah, this is an initcall, so the exact error really does not matter.
But adding an error variable isn't that annyoing, so I'll switch to
that.

> >  	unsigned long flags;
> > -	void *element;
> > +	unsigned int i;
> >  
> >  	spin_lock_irqsave(&pool->lock, flags);
> > -	if (unlikely(!pool->curr_nr))
> > +	if (unlikely(pool->curr_nr < count - allocated))
> 
> So we might be pessimistic here when some of the elements in the array
> already are not NULL so we need in fact less. Might be an issue if callers
> were relying on this for forward progress? It would be simpler to just tell
> them not to...

Yes.  I think alloc_pages_bulk always allocates from the beginning
and doesn't leave random holes?  That's what a quick look at the code
suggest, unfortunately the documentation for it totally sucks.

> > + * @pool:	pointer to the memory pool
> > + * @elems:	partially or fully populated elements array
> > + * @count:	size (in entries) of @elem
> > + * @gfp_mask:	GFP_* flags.  %__GFP_ZERO is not supported.
> 
> We should say __GFP_DIRECT_RECLAIM is mandatory...

It's not really going to fit in there :)  Maybe I should have ignored
Eric's request to mention __GFP_ZERO here and just keep everything
together.

> > +repeat_alloc:
> > +	/*
> > +	 * Try to allocate the elements using the allocation callback.  If that
> > +	 * succeeds or we were not allowed to sleep, return now.  Don't dip into
> > +	 * the reserved pools for !__GFP_DIRECT_RECLAIM allocations as they
> > +	 * aren't guaranteed to succeed and chances of getting an allocation
> > +	 * from the allocators using GFP_ATOMIC is higher than stealing one of
> > +	 * the few items from our usually small pool.
> > +	 */
> 
> Hm but the code doesn't do what the comment says, AFAICS? It will try
> dipping into the pool and might succeed if there are elements, only will not
> wait for them there?

Yeah, that comment is actually stale from an older version.

> 
> > +	for (; i < count; i++) {
> > +		if (!elems[i]) {
> > +			elems[i] = pool->alloc(gfp_temp, pool->pool_data);
> > +			if (unlikely(!elems[i]))
> > +				goto use_pool;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +
> > +use_pool:
> 
> So should we bail out here with -ENOMEM when !(gfp_mask & __GFP_DIRECT_RECLAIM)?

No, I don't want the !__GFP_DIRECT_RECLAIM handling.  It's a mess,
and while for mempool_alloc having it for compatibility might make some
sense, I'd rather avoid it for this new interface where the semantics
of failing allocations are going to be really annoying.

> > +	if (!mempool_alloc_from_pool(pool, elems, count, i, gfp_temp)) {
> > +		gfp_temp = gfp_mask;
> > +		goto repeat_alloc;
> 
> Because this seems to be an infinite loop otherwise?

You mean if someone passed in !__GFP_DIRECT_RECLAIM and got the warning
above?  Yes, IFF that code makes it to production and then runs into
a low-memory situation it would.  But it's an API abuse.  The other
option would be to just force __GFP_DIRECT_RECLAIM.


