Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FFB6C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 910EC6B0093; Tue, 11 Aug 2026 16:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C27C6B0095; Tue, 11 Aug 2026 16:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D7ED6B0096; Tue, 11 Aug 2026 16:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7C26B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:13:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 608FE1201FF
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:13:42 +0000 (UTC)
X-FDA: 85090089084.30.0A75F99
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id E403E80010
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:13:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=a066R9N2;
	spf=none (imf30.hostedemail.com: domain of BATV+83a8f2163782db0f52ba+8388+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+83a8f2163782db0f52ba+8388+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786479220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YbFpOmvNf504sQf2QihriBMoey+d8zmHbwInFB/oZQ=;
	b=HSQnLZVPoE57nAt0HQdBToZo+lkGu0IG7f0zie/aPAX6j4CaCdQ65f/fe2C0HfTQe5xX6T
	rwT14tjVS3B8nuTZBUZ1/Nhvx5T/RqH/fyzcbqLRjCNsjn4EA04KgQ0M/PeDmdOnAsMEwv
	Uw++qIQHTyjP3NX4RFQbgkoxlpwvc8M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=a066R9N2;
	spf=none (imf30.hostedemail.com: domain of BATV+83a8f2163782db0f52ba+8388+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+83a8f2163782db0f52ba+8388+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786479220;
	b=0JASgpULKx3PkDuoMkfayiAMom1O/jg4gXh81mbV6H2QbnZYqBZwc92lx3b0VghhAiIIZa
	+EKpfsw2P7Aq03dPesVBcHKHhQZ0XuoFIcvzs419IvGwNWv93m1e833bs/IzpGNnzDzrpF
	BaRtlMG5reVirEJvD1STKlEUXc2UfGY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6YbFpOmvNf504sQf2QihriBMoey+d8zmHbwInFB/oZQ=; b=a066R9N27OIM70SnmDCVlfwHs2
	rp6/CjIfME+lq/Ia17LZWz0DPG2aQd4osZzsfh7lVX8KAHTxuZmNpwJN22+GUNTvvmLyG33knvKbM
	MMO7XW0ko3H0+JYBjpl7KiSy8lfZrYft/YosON0EcQDPhbhnYDmHgieQdiOVTJWgjVLY2NFYCcYu2
	0d1AU4mwSZ7yM3nXMw9LBiBE1nPDWH0nfOZXEr6O3BRa4l08i0yi2mNsxyls97QNGzqpJNoQNDiLv
	Y5nANGdXeP9R68PIbwE3/TkrA0r9rqzQEHT83oU3RVE2W/IgcdOPEuE0unTx/lET+1Ht/eYEECl00
	MUPAtPXQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtsqv-0000000Etzg-1riU;
	Tue, 11 Aug 2026 20:13:37 +0000
Date: Tue, 11 Aug 2026 13:13:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH 2/3] mm: support fallible mempool_alloc_bulk()
Message-ID: <anuCcb-Cma6JOAb0@infradead.org>
References: <20260806221031.79050-1-ebiggers@kernel.org>
 <20260806221031.79050-3-ebiggers@kernel.org>
 <ann1i5VjTmgChjs7@infradead.org>
 <20260810161404.GA1930@sol>
 <anoIiy0V-m-05yZc@infradead.org>
 <20260810182215.GA270444@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810182215.GA270444@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E403E80010
X-Stat-Signature: 9idi1o9hwgha9swts8bsofhzx7g5j7g7
X-Rspam-User: 
X-HE-Tag: 1786479219-195922
X-HE-Meta: U2FsdGVkX1/R7KxJfP/4Eo/O8d6iwJgRBnhr6A08hcNFJrPnzCaf89p/UFBQxxYR8eAyKSlO7wFLBOXXH2ypJPuU6ReQhVQbFPYSl0AGzKEzf8wKv3yeUnb93bXba9aZpv5J+R5T5ZYOnW+VtX0m0ftLPT4w5K/f9HX4VVxkBCQ5EiND6YSfo5wZkIrG9IL8rf4Iz40NXag/FiE4mLD0pyyoh67jLHQzBoA/odSPWS/xRqWH3WqyVK6HCfVHhMS7vy11Rz7ZvKA1E9SouRlYWxvHNUqu8c2rKwFGqXi5fC+/E9SYPbryqmYcSK5FlkdCaFOXOWOQ+mvydwQ3KLVSY0CXHrY4h4Y02KkXZ/ojgaSZXu4d/3Z9BBzulLhSGNHjFann/ia9fdHNOEQDR2RSiYNOJnTzyDW6F/vAmettMlNVXBfezTzpa/GPiddhuKSEcZ2AN0nmX+vPY8VEwOsF6HfGbl8zgCufdD22t7AfWXA30MIG4TY+fZhyMP2arKbdT0eYhdD5UoTNZg/kEqd+sGGDbn1m220XGvkalXwnQKenV3ZZZzKgpFaTS+Z0ujJFzWwxxK4WAUKMYjZA4dqY28M2W/xobRT4wuyyYqpgCNadvW4nt+HbTxcm0BDQtha2gvejnIW6IdHFf2LqYgaGNq6j/7oVSSVF765i24GwasQi0WDEO2d3N7oO4Cy8IgBm+IEMcOGWwsa4EhntDlEssWet8BFZx68UN1xasJT436IuL0iAIH9Cwirzu6+VR0mlxNHzfCY3ybqCxYeKxTMmt7Ap3q1ssGRfQBkaBvUZC4FR2BmIT9y+xzgKhZmw1uRAheEJZ7UoGS5VzQlAU/FAd6Ze2ZhfVvjcRhOslVl3y+lzROTd1yaVJETS0/agXtWoCtVwPws2FqFjAdTkut6FePUR6wzQesBBu8auSC8f0eikwU6wq9Xb4/9hX8gYQ/w8Pdr85QH/Us0h5z/NLre
 jJs8yt3O
 6e0tquATOXrUXXsrf0n6+So0vXb0LkEosD3FSh2aK1pu+KO218hElabiDjb5Jd40g/xTBjzoSexfIqvyBCpqJ3ulpuqbXJUH8G43KvZCef2i7FBSgY7tIW7NcvWCR8NF4GkFzZe5vgy11iI31Qss75N1ZvkmIAXWbe283YxT/p7W1eaPvIqc0rzNG3fUzknR6CSLUgV8UvDshHtaK8seef2Jv9Gj3tOfCB2b/0vBP+4j+87kEnqcQHNP7wXMlHWRziUKAAy7dMByEnYcN2FiQEcxFRzdh640+d+43VpAcTvpOG6qGpfpXzcR9mjrXkevcoiKCXY31LPF7L00X6StZ2MS+vo0+BxVNMFKosvaYHIr1A0TmfiaWOEVHYupLsoLeniW7xuklmZbymwLGXo6ptY0xYpLuqdRQILcZGcGx+UMkYbRzl/6PCLG6BhCX2ZRxDZ556fk0l0shfzUedhtcf71eHHVbgrpjh+tCuFrxHyawn7El9H7Y9q/Qxl62T8Q5wx8boT9waIMfpKu1KzaH9/p+WEopIyYRociA/tpC8rd/aq3LWbfkAx63uN7EIxaXcq76w+rVNvBhYtY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 06:22:15PM +0000, Eric Biggers wrote:
> On Mon, Aug 10, 2026 at 10:21:15AM -0700, Christoph Hellwig wrote:
> > On Mon, Aug 10, 2026 at 09:14:04AM -0700, Eric Biggers wrote:
> > > On Mon, Aug 10, 2026 at 09:00:11AM -0700, Christoph Hellwig wrote:
> > > > On Thu, Aug 06, 2026 at 03:10:30PM -0700, Eric Biggers wrote:
> > > > > To fix a deadlock, blk-crypto-fallback needs to be able to make fallible
> > > > > mempool_alloc_bulk() allocations.
> > > > 
> > > > It doesn't.  fallible mempool allocations are a concept that doesn't
> > > > make much sense.  Please just go straight to the backing page allocator
> > > > instead for callers that do not need the mempool guarantees.
> > > 
> > > It does make sense.  When alloc_pages_bulk() doesn't completely succeed,
> > > there still might be pages available in the mempool.
> > 
> > But they should not go to a caller that does not need the mempool.
> 
> The caller does need the mempool.

If it does not specify a blocking GFP_* mask, it by definition does not.

> Now, as I explained in this patchset, whether this code can wait forever
> for the mempool actually depends on whether it's a recursive bio
> submission or not.  If it is, then it cannot wait, but ultimately it
> does still need to use the mempool to get a guaranteed allocation.
> 
> Falling back to the rescuer kthread (which can wait on the mempool)
> solves that.  But before taking that slow fallback, it's much more
> efficient to check the mempool directly first, since pages may be
> available there (and in fact it's fairly likely that they will be, since
> regular allocations are always used first).  The whole point of the
> mempool is that it can be used when the regular allocation fails.

What is actually efficient is do skip the mempool entirely from the
original submission context and do a non-mempool GFP_NOIO allocation,
and only in the extremely unlikely case that this fails fall back to
the rescruer thread.

> This is also the only caller of mempool_alloc_bulk().  So I'm kind of
> confused why it would not be allowed to implement the behavior that is
> desired here, especially when the non-bulk API offers it already.

Because passing GFP_ flags with all their warts is a bad idea where
we can avoid, as is using up mempool resources where not needed, and as
is having a possible failure path from a function that can only happen
for non-standard flags.  (having a return value at all is also stupid,
but that is forced on us by the braindead alloc_hooks).


