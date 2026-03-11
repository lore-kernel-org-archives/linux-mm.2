Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 591DE112584F
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 16:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 358C46B0005; Wed, 11 Mar 2026 12:30:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 306A46B0089; Wed, 11 Mar 2026 12:30:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E8986B008A; Wed, 11 Mar 2026 12:30:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC44D6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:30:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 888E51A02FC
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:30:49 +0000 (UTC)
X-FDA: 84534321018.13.CAB8C6B
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6D76E40014
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:30:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SfU7syW3;
	spf=pass (imf12.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773246647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+462tfttOHg75m2xiVykhsaW8+IAkOZyHSJhxHwmIUs=;
	b=EJcg9bZDcGTR4aLCuRIn678bEWaaiCdUpEFeOWiw46Aq2I/XyBWcw/aaNp/rQU86GojlPi
	0XS2LYcrvnHRpogvGNQ/dGSqIDwdNJKSOgnqioaizUzaQ1rZ1iYMpRWVPvB9E7xhPSzlPk
	wof423XByIoXc3tCitXF9PG5CY7OV6k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SfU7syW3;
	spf=pass (imf12.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773246647; a=rsa-sha256;
	cv=none;
	b=cHFPjFwyx9SK52zVdVhb3tRrDAcA9E6qjAylfutJ/GSlJ+yHgUtpUPL7RbeDtYktWkMHCg
	uV3xjOYaVaCAKksbi3PxTb3FuewikQBku3nCH+X+Wke0BzRn8bfPsJ0doedRibuRVDHdJt
	m/lyaYI01d/9RbNgztCqutelMKm54fE=
Date: Thu, 12 Mar 2026 00:30:24 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773246645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+462tfttOHg75m2xiVykhsaW8+IAkOZyHSJhxHwmIUs=;
	b=SfU7syW3VRl+TpZDWcq3dBmuJjk+K2BuNz3R/iGwxp30tv6jlRLSML5e+Iy7OQv0CBNCOg
	RuzIrI1xDgHY/yz79UPlsKaj9wkOgHxEARE9pVuG6N0oVyYnAG5n5GGpbVpBCvGBjc6+TT
	GWcQBeIEfVgbVdIWPu621qU6oggWvXo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Qing Wang <wangqing7171@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: fix memory leak when refill_sheaf() fails
Message-ID: <tak4kjtw65fk5r4inuvddqt2pooqbfu76i3smzxsfjoiz2p6oz@qwpmlhmpqlwz>
References: <20260311093617.4155965-1-wangqing7171@gmail.com>
 <thhmlnu6phtuucz7jo3xoqeiv64rs4ynkt63qoxvtwgfh3aofw@lo75dus27vyk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <thhmlnu6phtuucz7jo3xoqeiv64rs4ynkt63qoxvtwgfh3aofw@lo75dus27vyk>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6D76E40014
X-Stat-Signature: fd9mmpebnne76mrfbypb1bzfey6z44t1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773246647-393199
X-HE-Meta: U2FsdGVkX1+yWCKdXdiX7z04fWeIU+/KW8v6tBuPU379MKBjGLh6z4jyuUZJzDrXDEtO2Qon27bri7qZbMAQbeIvLKRWuVxPS19N92/6TUfCCvL72fIxmIGxH0bQM5Wi1fFsWCPoCRSOhlMuj+a3UoBNytmwpS/S3IHW1u+SHGVWPgc7+ZiXQCAP+uFUMis/VrtiJ+7mIEGn1B+DurkbeuewalByoHb8J+IpAaKClGf71liYPhSIxhS0gMrc3tE/Emw6N1Oa/bj2LIygfwbicWKAabX5HvnT/6AhFpU8LrnNj/20QxiaJpl+Tb70KzNszvBjrq8pK+PXO9VzyP7OrT/fQxqDVbk6foVDo1y1Lr2MUqD4+g1JmxPmYZD+plNxj7GtkKAz8Jc7JcEWWYlX4qqKku8gdDYH2R8tKDr5ADQ2TUi5G+qMGRJxRe2Z7knhQ/OMY7Ed9/wg4ayqBm7GLM2m06UE+1+vlaXkpWwfJu2tbe2ZsN50x2ylvLtBv1P+WtjfLSBwGyfX+V3FbAqmCcTFABBXwl9YJtdd+8YuwtGKxi90nmae68iGOeZv4Ju+NgF4vZ5cnWIqzV/rAli5i+JZLymUKv8+/678Oo9xNH4jZvUdcP7ylAopWfwpebF5sepxfIUPjDxFLyCAiXURmdB2sPPqb82F586PmAReBfYjN+6aE8nLfsQvOonapN/8XRV517qZSBR/jUYph+ryiQktR8e7ZG1lulbN4Fq7QJZcc1jHTZPgfknteB8rG6nVbSdRApVdUMOn9DA/lXmJShCavj+5CtIPhEe0VSMzSMTK0qH0dNjPOxWHBti1hAW6P+J1prv/EHzOtMq9hs1LG3O6W5mAiZ0a8uZRC21aHwNUv/tEWk0ChTVYSzUhAHti7T18u+XNDi5r9H4nAJdDBaaVU9i48TsIlEQNmElw3T1YF04aianY7z43uoQxFmUndWIUcknhBf4VxIqagms
 KuMaLsLq
 ZQ9AGunaKmVApIanL8t8EwdAAzjTFGlRnMdL9zbnK6JIsEBufgA2Dj0E6w40eYow+5mLbBOwNhDUyowziXrffR7FA2XniPcc1P0a8WzzgUEMk8bYD+teXQsh3KGODDRty6J5PjB2jpEk4wKLpSY9OryENQ912G0XPFvTs0tepxGu1Ejit8zTxUjOwq209aUt0WXuCBN6jbZYrXmHajpf4vUEZ5fBFzdMZ6TBy7x1KWy9sSe0eJJ1tECEAcFwtZbUxFskcExlVY5Ex0IouWsSHj0PZaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 10:46:23PM +0800, Hao Li wrote:
> On Wed, Mar 11, 2026 at 05:36:17PM +0800, Qing Wang wrote:
> > When refill_sheaf() partially fills one sheaf (e.g., fills 5 objects
> > but need to fill 10), it will update sheaf->size and return -ENOMEM.
> > However, the callers (alloc_full_sheaf() and __pcs_replace_empty_main())
> > directly call free_empty_sheaf() on failure, which only does kfree(sheaf),
> > causing the partially allocated objects memory in sheaf->objects[] leaked.
> > 
> > Fix this by calling sheaf_flush_unused() before free_empty_sheaf() to
> > free objects of sheaf->objects[]. And also add a WARN_ON() in
> > free_empty_sheaf() to catch any future cases where a non-empty sheaf is
> > being freed.
> > 
> > Fixes: 2d517aa09bbc ("slab: add opt-in caching layer of percpu sheaves")
> > Signed-off-by: Qing Wang <wangqing7171@gmail.com>
> > ---
> 
> This fix looks good to me.
> So feel free to add:
> 
> Reviewed-by: Hao Li <hao.li@linux.dev>
> 
> I also want to bring up another point here, although it may be outside the
> scope of the current fix.
> 
> When I looked into the refill_sheaf() path, I found a refill failure does not
> guarantee that the sheaf remains intact: refill_sheaf() can partially fill the
> sheaf before failing. This non-intact behavior propagates to its caller,
> __prefill_sheaf_pfmemalloc(), which therefore also cannot assume that the sheaf
> is still intact after a refill failure.
> 
> However, the comment for kmem_cache_refill_sheaf() says that "if the refill
> fails (returning -ENOMEM), the existing sheaf is left intact." That means the
> behavior of __prefill_sheaf_pfmemalloc() - where the sheaf may be left
> partially filled on refill failure - contradicts the API contract of
> kmem_cache_refill_sheaf().
> 
> Maybe we can add rollback logic to __prefill_sheaf_pfmemalloc() so that it
> provides intact semantics, preventing the non-intact behavior of refill_sheaf()
> from propagating up to kmem_cache_refill_sheaf().

Looking at this a bit more, after checking the current callers, it seems that
the existing callers of kmem_cache_refill_sheaf() are not relying on the sheaf
remaining intact on refill failure.

If so, then another possible option might be to update the comment for
kmem_cache_refill_sheaf() to match the current behavior, rather than adding
rollback logic.

So it may just come down to whether we want to preserve the documented
semantics in the implementation, or adjust the comment to reflect what the code
already does.

I may be missing some intended dependency here, though.

-- 
Thanks,
Hao

