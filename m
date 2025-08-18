Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57386CA0EEB
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 13:38:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCAA18E0046; Mon, 18 Aug 2025 09:38:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A6B8E0006; Mon, 18 Aug 2025 09:38:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A904E8E0046; Mon, 18 Aug 2025 09:38:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 97EF28E0006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:38:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 105CE83FE7
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:38:55 +0000 (UTC)
X-FDA: 83789983830.19.0E31252
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4DE1F180013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:38:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fW4xOacR;
	spf=pass (imf24.hostedemail.com: domain of will@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755524333; a=rsa-sha256;
	cv=none;
	b=JngIBAeLHtYF/iinPF6B+4yogmhLSmgaHASI3/qe39oV4kMl2S0gIjj/QVd2DS6bUSz492
	phSdleIh/iorf9X7YIQTmrcY0YFmD6s1csu05Uca+c8d695iA7FH6za+Al6bHX3twszFl4
	28A8RkeHbBBLi7XQHLzWk4u/jmg0Ri8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fW4xOacR;
	spf=pass (imf24.hostedemail.com: domain of will@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755524333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+v6YXuAiIZfi9Ohy22Q97yX1dKKvmBfAWzOq0lphX+U=;
	b=dXJgx+eK/ZXZzYt43YCBiELqZ+Kum9VBOKF4GagBiKnXHhWq+gbWgmlieK3PfUIAoMWVly
	BzrCuXvXD/dOVU7zGm3rJWzSS+SPKqvgFxw1XRv3/3jHuIkqgDVC73yqWWraXOe4H+QpW5
	GoyQcqSf8XmddwPwFFoMndnohyBe4k4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 3151E5C43E2;
	Mon, 18 Aug 2025 13:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB254C113D0;
	Mon, 18 Aug 2025 13:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755524331;
	bh=+aNZzQBZ0JlhnJvSIA3wkd/Gq74n4JLtTqgPhcnHKK4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fW4xOacRzXH3IrnYOIVgVa+T2AJK1ao9BMPxptTUbco/VPJngPBp8knPwsg/thDRz
	 1liCwAs8eIyPe1EIAig3FbsP2aWicQDUP8wwCS5h1EWflfgN9L7x2o+HjRT6AewyWM
	 HJB8U5rj9jzIP/0eMXAqWR8pZy94NMWnahPxrANIruc48NhZCxarpFIrsyvru+xbYj
	 wnoIMJeA4T0xDjD2UI/6zJNgdSW6KI1yKXbEzxTlS+pgmWurHvJ47YLQNcWxyhD+mE
	 /UiEN0R65KIOmvMG5Jy4lWlmt6XFIBqM78q7KF2bbWi/9wFohm6EVbiRk1s14u33AL
	 rwoSA5VVT512g==
Date: Mon, 18 Aug 2025 14:38:46 +0100
From: Will Deacon <will@kernel.org>
To: John Hubbard <jhubbard@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Hugh Dickins <hughd@google.com>, Keir Fraser <keirf@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	David Hildenbrand <david@redhat.com>,
	Frederick Mayle <fmayle@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH] mm/gup: Drain batched mlock folio processing before
 attempting migration
Message-ID: <aKMs5t6oT6UxeGfF@willie-the-truck>
References: <20250815101858.24352-1-will@kernel.org>
 <ef85aa74-180c-4fbc-8af6-e6cca45eed43@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef85aa74-180c-4fbc-8af6-e6cca45eed43@nvidia.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4DE1F180013
X-Stat-Signature: q9cm5kzznyxf51g7ugny6c5muxod436s
X-Rspam-User: 
X-HE-Tag: 1755524333-116653
X-HE-Meta: U2FsdGVkX1/p10k+Yfp+I372aN1gvm3LI54akzAu5E7DyLnziJbJJwtLSuAEw1rZA5s+zXprck7I4hjj+BJe7Mf0tGa8jmnyh12Tz3asndz3kqLwYtK5/GHULokWOCIEDc6K3GEysNIctzIkZ9y901Spou8QUlWzgzYmCMWhNdlSUhNJXrdmMJc7m8ZfcMVyaJ0gxHD3J5lK/Q9QE/cF7EegUFYBmwUGyWwb3nOJM9rDwAN7btYISXrTYPIC3Xdho+QElI9MzXmtb5sslCfRJ2SVJAjl9cdaMIqF5aP3KJ6a9U3SDpV5buJIF32G8PMOgp9V6qw/0LVJnPboNX9ZRZCx1U1BUkjHWI5fWIsQFw7pFkfHyteLDzR5kaww+qCAbIGZZsA2+EDE+rVxPJA2xc6k83T096sC4wUH/8uYctJK3T1nLNU07MORypNVqu9G0FKgfAYlUvKp/xXl1tODIASzDs5aHSwp7ylPKCLOcxb5cyrEhNViRoVyAVB48heSLz7Y0aUDoCp4o/ilVmtDcJyhZKNkvSacw+OLrDylHzCAJvOC2wHWx1O/4VVHyPNyp7gu5r+HmIpe3CSvvbX44RpYR6qia8aqpXJb/Giv1lPOIJFu022sqSustgJr3L25Wk4R0TWcvaXaMf+r0KXM5iVHsJqXW6G0R1OUC20GgbhbvugygQi/I8S5TvHFlusE8yQ/OXFUSBkUYEx7YL7ILGAmeuUQLm5G+Vn6QdUix0/OBNitJ8VkIT5u/67qosNgJwGCl+IirEeUSsY05kabcqwi8DZ2hyrNIDVwFjweyA8f7q2O6k4nIIYwdeVjw+a34AEL4nyEDCV7ZEXmND5MdSImvp//e6CBzejzIJIFCIb5TRlFGiFbppuDoKaNw6S5O2Wv5tgFKzMcAow2S/ZF6UnCjGP21jc5cKpq4Pw1x1d9PONOL3h4kug37b6ZfV2NomvgghKYxfLgsU1y+ft
 xPxuwRWH
 kEjbJTzOktccTxUSA5bJgrMPt51boWY2luuvOnX9cTttW8CmVHbesK2N8QQ4NfcDjnJgrwmeqtUZnWF3lWpLpPU7blohoGYveFb92WdIddS4HIkt6+P4qYk7cUrVYzUKLczYrBJfZbTEPlKxlzbttLmUv/PbjQIZshq/4nx5uP3BmvHM2+Me7s3pBzf9RtevdwSBaRLSi5zauT1ZeDRvbKewl8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 06:03:17PM -0700, John Hubbard wrote:
> On 8/15/25 3:18 AM, Will Deacon wrote:
> > When taking a longterm GUP pin via pin_user_pages(),
> > __gup_longterm_locked() tries to migrate target folios that should not
> > be longterm pinned, for example because they reside in a CMA region or
> > movable zone. This is done by first pinning all of the target folios
> > anyway, collecting all of the longterm-unpinnable target folios into a
> > list, dropping the pins that were just taken and finally handing the
> > list off to migrate_pages() for the actual migration.
> > 
> > It is critically important that no unexpected references are held on the
> > folios being migrated, otherwise the migration will fail and
> > pin_user_pages() will return -ENOMEM to its caller. Unfortunately, it is
> > relatively easy to observe migration failures when running pKVM (which
> > uses pin_user_pages() on crosvm's virtual address space to resolve
> > stage-2 page faults from the guest) on a 6.15-based Pixel 6 device and
> > this results in the VM terminating prematurely.
> > 
> > In the failure case, 'crosvm' has called mlock(MLOCK_ONFAULT) on its
> > mapping of guest memory prior to the pinning. Subsequently, when
> > pin_user_pages() walks the page-table, the relevant 'pte' is not
> > present and so the faulting logic allocates a new folio, mlocks it
> > with mlock_folio() and maps it in the page-table.
> > 
> > Since commit 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page()
> > batch by pagevec"), mlock/munlock operations on a folio (formerly page),
> > are deferred. For example, mlock_folio() takes an additional reference
> > on the target folio before placing it into a per-cpu 'folio_batch' for
> > later processing by mlock_folio_batch(), which drops the refcount once
> > the operation is complete. Processing of the batches is coupled with
> > the LRU batch logic and can be forcefully drained with
> > lru_add_drain_all() but as long as a folio remains unprocessed on the
> > batch, its refcount will be elevated.
> > 
> > This deferred batching therefore interacts poorly with the pKVM pinning
> 
> I would go even a little broader (more general), and claim that this
> deferred batching interacts poorly with gup FOLL_LONGTERM when trying
> to pin folios in CMA or ZONE_MOVABLE, in fact. 

That's much better, thanks.

> > diff --git a/mm/gup.c b/mm/gup.c
> > index adffe663594d..656835890f05 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -2307,7 +2307,8 @@ static unsigned long collect_longterm_unpinnable_folios(
> >  			continue;
> >  		}
> >  
> > -		if (!folio_test_lru(folio) && drain_allow) {
> > +		if (drain_allow &&
> > +		   (!folio_test_lru(folio) || folio_test_mlocked(folio))) {
> 
> That should work, yes.
> 
> Alternatively, after thinking about this a bit today, it seems to me that the
> mlock batching is a little too bold, given the presence of gup/pup. And so I'm
> tempted to fix the problem closer to the root cause, like this (below).
> 
> But maybe this is actually *less* wise than what you have proposed...
> 
> I'd like to hear other mm folks' opinion on this approach:
> 
> diff --git a/mm/mlock.c b/mm/mlock.c
> index a1d93ad33c6d..edecdd32996e 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -278,7 +278,15 @@ void mlock_new_folio(struct folio *folio)
>  
>  	folio_get(folio);
>  	if (!folio_batch_add(fbatch, mlock_new(folio)) ||
> -	    folio_test_large(folio) || lru_cache_disabled())
> +	    folio_test_large(folio) || lru_cache_disabled() ||
> +	/*
> +	 * If this is being called as part of a gup FOLL_LONGTERM operation in
> +	 * CMA/MOVABLE zones with MLOCK_ONFAULT active, then the newly faulted
> +	 * in folio will need to immediately migrate to a pinnable zone.
> +	 * Allowing the mlock operation to batch would break the ability to
> +	 * migrate the folio. Instead, force immediate processing.
> +	 */
> +	 (current->flags & PF_MEMALLOC_PIN))
>  		mlock_folio_batch(fbatch);
>  	local_unlock(&mlock_fbatch.lock);
>  }

So after Hugh's eagle eyes spotted mlock_folio() in my description, it
turns out that the mlock happens on the user page fault path rather than
during the pin itself. I think that means that checking for
PF_MEMALLOC_PIN isn't going to work, as the pinning comes later. Hrm.

I posted some stacktraces in my reply to Hugh that might help (and boy
do I have plenty more of those).

Will

