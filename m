Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C55F606A325
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RjtGTco/
Received: by kanga.kvack.org (Postfix)
	id EB7A06B05B9; Fri, 20 Nov 2026 20:09:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90906B05BA; Fri, 20 Nov 2026 20:09:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7E306B05BB; Fri, 20 Nov 2026 20:09:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE2C86B05B9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:09:26 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3FA6E1602A3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:26 +0000 (UTC)
X-FDA: 85457343132.10.0F884F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 98BFC4000A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RjtGTco/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795223364;
	b=KI7va79I8vc0AuI6oOZB8Ax7esAtTBa6PFsteg/HYAUQEb7qqhrSTu2V3XU8291ZfX4MGl
	J/yYIys7sI8vPgVFdiuAANVdrrKB2G1BlppAG54wXCZyZHrz56tgM88t93o+xzqGGSl2BS
	fG+wxERJ6Cw5M0lGFkKpXDLZ/llFEPM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795223364;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tPfLgI5e8+WcHqrzKo0CxzlPyJ7xfUGHHq4eoVjQBbI=;
	b=CvAs/jBkL7ufp/5NHTuoYlWP57D8sg7s1S/xjTq62WepnQ8JThjbH/FnQtP1YGBAseDOxa
	kSo7W1avnTgYy46LVwLg5ngGERZxuodm+9RBko+dA5xdfvZGhjUUfjWy8GCFZ5bnkpdqnb
	x06ptQfPkb7pX4mr81pqBEfi7Bw6NWY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RjtGTco/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6A0E44020;
	Sat, 21 Nov 2026 01:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4B61F000C0;
	Sat, 21 Nov 2026 01:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795223363;
	bh=tPfLgI5e8+WcHqrzKo0CxzlPyJ7xfUGHHq4eoVjQBbI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RjtGTco/1orT+ZJc8lm5s2HNYsE8pOpby8Az7AhwBK64ZP/lGI4lSZNkRun7scsy3
	 5w2etVRh+93hUbBIWgeu6tPrPLmAgxK4702Oamb8v5k/iOwZiGWNr205+eLMJLSwcx
	 jgppDhfINeMb3Nw3mjtTBoQk0niIZ+u17TEUtmXfds3da270l9lJjJAdEeUODcK0k3
	 AUa9u8C6UFga9mz2wIUZU125roep37xR8j7yTMUL+0HePG+KBiO32KU9behGHZyQ2p
	 igfrMEIKhsul1+2f86azLCx+aIk1kH5ILDiV/usWoJI6FEPE4OU8RMN9e0B8AQKgFz
	 /scDT+++R3aug==
Message-ID: <sashiko-outbox-226468@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 04/25] mm/page_alloc: Extend alloc_pages() to
 __GFP_PISA and PISA block allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luigi Rizzo" <lrizzo@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Joerg Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>, "Jens
 Axboe" <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "Luigi Rizzo" <rizzo.unipi@gmail.com>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Harry Yoo" <harry@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Hao
 Li" <hao.li@linux.dev>, "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Jann
 Horn" <jannh@google.com>, "Catalin Marinas" <catalin.marinas@arm.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Simon
 Horman" <horms@kernel.org>, "Jesper Dangaard Brouer" <hawk@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Willem de Bruijn" <willemb@google.com>, "Kuniyuki
 Iwashima" <kuniyu@google.com>, "Joshua Washington" <joshwash@google.com>, "Harshitha
 Ramamurthy" <hramamurthy@google.com>, "Alexander Lobakin" <aleksander.lobakin@intel.com>, "Christoph
 Hellwig" <hch@lst.de>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Dragos Tatulea" <dtatulea@nvidia.com>, "Naman
 Gulati" <namangulati@google.com>, "Pranjal Shrivastava" <praan@google.com>, "Mostafa
 Saleh" <smostafa@google.com>, "Randy Dunlap" <rdunlap@infradead.org>, linux-mm@kvack.org
In-Reply-To: <20261120010655.467825-5-lrizzo@google.com>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <20261120010655.467825-5-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 01:09:20 +0000
X-Stat-Signature: cjrchnffpki3389m5eobhujb1yznz1kh
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 98BFC4000A
X-HE-Tag: 1795223364-43197
X-HE-Meta: U2FsdGVkX18xAKJwzdJ5ec6YgdvqBPMzjyX97MSoFqBGOjsCoXlGjZA928kVjrMoyv+618Z1AJKGjOrHIEicsPMJ0EMHW6kkACOorYhE09EclQdYJH7ngAhb8QXqfrDjHE5RmI2Hm/SO0rwkXNlF1XBP6SILnSx6IAQEi/9DTU6kMhHRi42CIGams0hPEVNO0YS+rorGmLdvYH0hzTsyLdqCd9RakAPrcYx+wEdKtQNM944+nFB0IppAd8QFwctNOJDw8CI6l9JiEBvIEeso0dXNcvJo4Rg6eybCAyymVyx9qdmM2eQdLdnvnJtrmwPG4thFMlNXLfw7eTckwmMfODMscKriHxlat2v94KtXaul3NYPqFMDX8jlhC9Dml9iqJf32rcbD/V7QZCCd7EYWs485+CkUp9elef7U+1YWk0bELFlZzlkcmJd2zsq1vVwlYoLCqezwetCErgI15z4G6sRk88mrXw3AbsWGySP5fSt5RnXY2LRUF1az09J3r/Oy25ZC0OoEI5p7F0XiRf4VrFXY7QHmbs1TvowWB3XUMi0s5D7i8H6QbxE04j5kfjIdU0wqH+ssM6pgiNLPtNXxvzA5VPN0vihVtQ6a6wKNKvwqqtKkUPJMneKDQUIU3smZgPZE8PuD8K0MZjQn8lOk81xNdyrjHlgAerC3F8zVW9cfkwjDNihB6pQk34DhU0bDW7+GfIIp3JHvdgDBQmG9X0NdLGwY9otojGrGplw/aASLwTIziz7gTO4+NnyDmHcndhY3Z4W3zi1coolxv7t7BaE/bhGDeW5yE2wd/MRhk9sPo1Dw8FLk4PrOHQJU0W0GG93e0SY/TTaLKYa6NYU/W5cuosoPf/0v0eqamfzaHoS2kxQdJYDIr+BECf4UvHKPNIqFOi1bmFsdYyBSm6r5TUD0Ac0dsBwZNBnbp96J1hnt6i0BQXEZi3xlCFCRKAes+5AWsN7TEiXkzcgGQ5h
 JJusaf/L
 EjpxmhwvZXfaNoIFVPfYf5ixJJerLb0hVYJEECuV/M/pal4dYs2153icqLL7IQOiuONCB6rwORNM4QlK68kEKgh6bRicJtnLFWLyIBx3G9GKqOCE+9kh7uRmetOJGfuNevabAeIVU9oza513KqV20NDH/V0q5bTW1hM5/QYUsOzEOWY2mGRrHRf5Xdc3xCkNIZz7afuiKTzN7riuQRIa+clkJuDzBWO5rOc01LgvPy60zGQpZX1eTb7xfzfJfQY3gdNDXQZOCUyFtfo31/P585JKvXXnk9hoTcyrMcdGjDYb3qA4lqJ4Bps0GIM5hEXfgrJMOYfxOaqhz0rr6ULhGhnznhc2f+0P3XErq5cxUNUeJElXaC1jlA9RoLBdhEefOqu01tzryPD1TDTt6yl96KV1gCgpUSZgx4wVVDBTqbGC6JJKy3VvXCrTo0Ls/S76Z58tag0rnNsjWrgCiBFJ5kqaSZWeiKqK8hrujl6G4bgEJlGLtGCm9kFGUCGFrRr6CjYtT4w8NMJB4OEcEyxSoyzTuYMSTcFXWkOwkctDdJazXE5S8w5nDTbP43cS3MQfGJ/4wts6JE+K14HwXRTUhv3P1voLywrHBkNSeo/15WdHpwGo6sf/bEGrOx1Kb/lbJ7df+UWtWuelO65lJBnMhV9bqB2Kln7j3a1uVeFzN8e+Nw/kpJQ+l9p8HapZqnAdqOTyv0NiTJ7ozMXcoTp3AWVjQzYx2T42OiCZcKvChU8VMqXenenMzzLMuFSyomeH1G7MX8vbPBkDD2eblCC545TWtNRnns472MWFmYpyzfyWXu4w1zZV9lU06FMAw5te2Qc55e7erz5+4gIEC/IqZvrkpdfBnqeUgoxgZNMsJXUsA2S3IN1xThXhiwpkW59oBoh6bH4WNHYIYtnM7oH5uBunuGrHB338h4DPdFN6i5A/mq/JIvrcjxgvBFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/pisa: __pisa_page_alloc() propagates __GFP_NOFAIL and
  __GFP_HIGH to order-9
--

commit a900e3d8d2cb1db57e93b7cd711921f0fe72bca4
Author: Luigi Rizzo <lrizzo@google.com>

mm/page_alloc: Extend alloc_pages() to __GFP_PISA and PISA block allocation

This commit adds PISA block allocation helpers (pisa_alloc_bulk() and
pisa_alloc()), introduces the __GFP_PISA and __GFP_PISA_RW flags, and hooks
__alloc_frozen_pages_noprof() and alloc_pages_bulk_noprof() to allocate from
per-node PISA allocators.

> diff --git a/mm/pisa-alloc.c b/mm/pisa-alloc.c
> index 7ba93746f6a89..e7f7ed5dca067 100644
> --- a/mm/pisa-alloc.c
> +++ b/mm/pisa-alloc.c

[ ... ]

> +/* Obtain and split a new PISA page on @nid into blocks of @order. */
> +static struct pisa_meta *pisa_alloc_split_page(unsigned int order, gfp_t=
 gfp, int nid)
> +{
> +	bool can_block =3D gfpflags_allow_blocking(gfp), clean;
> +	unsigned int bpp =3D PISA_BLOCKS(order);
> +	struct pisa_meta *meta;
> +	struct page *page;
> +	int err;
> +
> +	/* __GFP_DMA/__GFP_DMA32 were already declined by pisa_alloc_bulk(). */
> +	meta =3D pisa_reservoir_pop(nid, gfp & ~__GFP_ZERO, &clean);
> +	if (IS_ERR(meta))
> +		return meta;

[ ... ]

> +unsigned long pisa_alloc_bulk(struct pisa_alloc *pa, gfp_t gfp,
> +			      unsigned long nr_pages, struct page **page_array, bool frozen)
> +{
> +	unsigned long i =3D 0, n, got;
> +
> +	/* Skip any already populated prefix, as alloc_pages_bulk_node() does. =
*/
> +	while (i < nr_pages && page_array[i])
> +		i++;
> +	if (unlikely(!pa || i =3D=3D nr_pages ||
> +		     (gfp & (__GFP_DMA | __GFP_DMA32 | __GFP_THISNODE | __GFP_ACCOUNT)=
)))
> +		return i;
> +	gfp =3D current_gfp_context(gfp);

[Severity: High]
Can pisa_alloc_bulk() forward __GFP_NOFAIL and __GFP_HIGH into the order-9
PISA page allocation when the allocator and per-node reservoir are empty?

When pisa_alloc_split_page() calls pisa_reservoir_pop(nid, gfp & ~__GFP_ZER=
O,
&clean) and the reservoir misses, __pisa_page_alloc() strips only __GFP_COM=
P,
__GFP_HIGHMEM, and __GFP_MOVABLE before requesting an order-9 (PISA_ORDER)
page:

mm/pisa-node.c:__pisa_page_alloc() {
    ...
	/*
	 * Long-lived active pages must be unmovable, lowmem, non-compound, and
	 * must not dip into emergency reserves or trigger OOM/warnings.
	 */
	gfp &=3D ~(__GFP_COMP | __GFP_HIGHMEM | __GFP_MOVABLE);
	gfp |=3D __GFP_NOWARN | __GFP_NOMEMALLOC | (can_block ? __GFP_RETRY_MAYFAI=
L : __GFP_NORETRY);

	if (can_block)
		memflags =3D pisa_memalloc_save(gfp);
	page =3D alloc_pages_node(nid, gfp, PISA_ORDER);
    ...
}

If an order-0 caller passes __GFP_NOFAIL, __alloc_pages_slowpath() will loop
indefinitely trying to compact a 2MB unmovable block instead of failing so =
the
caller can fall back to an order-0 buddy page.  Similarly, if a caller pass=
es
GFP_ATOMIC (__GFP_HIGH), alloc_flags_slowpath() grants ALLOC_MIN_RESERVE ev=
en
with __GFP_NOMEMALLOC set, allowing an opportunistic 2MB PISA allocation to
deplete emergency reserves.

Stripping __GFP_NOFAIL and __GFP_HIGH in __pisa_page_alloc() (or declining
__GFP_NOFAIL in pisa_alloc_bulk()) would avoid both issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120010655.4678=
25-1-lrizzo@google.com?part=3D4

