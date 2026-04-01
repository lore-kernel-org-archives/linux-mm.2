Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A4E610F6FB5
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28486B008A; Wed,  1 Apr 2026 10:43:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8D66B008C; Wed,  1 Apr 2026 10:43:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E163E6B0096; Wed,  1 Apr 2026 10:43:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D104F6B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:43:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7819CC4731
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:43:16 +0000 (UTC)
X-FDA: 84610254792.29.22773E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D9E9420003
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:43:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QRWI7TCY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775054594; a=rsa-sha256;
	cv=none;
	b=YJdaOve6eB8nLE4wop8f2Cmd7NVaeZoYUP750MkAx7n9mhSFUScDS16iM21KVVX06qp0si
	R9KZryb+4+jx3pcVhm0vQnJje1ffuQwHJpZ1no50Z4RmqlJpOjM7mLK+VC5PDpRDi6mCPy
	GXyb7XECtgIQJEmyrnx89CsY+RfoIHs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QRWI7TCY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775054594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5QkcdOmHwjiXH6hnsGgSqdxrVK8fuBRrg0O/JOb3qzQ=;
	b=FgI8iswa+QoeXiVpUGI5awnl0+CQk7LJ6IuP+KXda50sJiRBIQXQHsKqxRx3zjGsyFxVnc
	4STqoehDiYHBoqwnHkXe5uwvLZMYtIgv/S9u4dJKY1BUxKAZ8LX8GVzRfx2OlSl3FgFSb0
	Lvyi7WJeIy/qoXo11C+pAnjYYRb54BM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6437F60123;
	Wed,  1 Apr 2026 14:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6624C4CEF7;
	Wed,  1 Apr 2026 14:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775054594;
	bh=Ryrbj2IiZ4oRSg/YxtGqfJDYuXiLqJFKUZfZB+svoLE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QRWI7TCY2OEibcAM+J9UNMnBQJseoKKaYdIG2FL84fqqQRus5j4dSxuNq9MLClz+j
	 y402AZmpGPvw5gjZgu9NMATWREV3TnDFAOaIqU7YgW6uI3VZBE0HrnPUp0V4V4ERen
	 REAj/V/owhJzJuVhcxXVqryWBB1W/4Hi+diLvc5E3jIcbYBVRlEeA0PxOEDGstklW3
	 j7P3dxGO1VRQu52R3i42R2086LRfC/Kb5atGPJqA9T0StbvKcOFI75PO46qepHtPx3
	 2lMyWRavoiL6/aFp2MHbEkfzIxMApmYZKoSB/KHoLznt9Rs5tC+z7GK2tO1NP4/QR5
	 45OwMtGWNwWhQ==
Date: Wed, 1 Apr 2026 15:43:12 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/7] mm: list_lru: introduce
 folio_memcg_list_lru_alloc()
Message-ID: <b358289e-2138-4ffd-84ac-ceedbba77b5d@lucifer.local>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-7-hannes@cmpxchg.org>
 <58ea360a-54e1-468e-99b5-57b716026088@lucifer.local>
 <acqqxEDgfNOIqBIL@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acqqxEDgfNOIqBIL@cmpxchg.org>
X-Rspamd-Queue-Id: D9E9420003
X-Stat-Signature: zi1667kwpggyoonjus1iryr65cgfxmtp
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775054594-248561
X-HE-Meta: U2FsdGVkX1/YucUYQG+khm15KVMsoKFPGAlcs24WkEsaGEPVFSWzqrdQJjUfnYbsBfpGePcwV4fjteKfBB9YMi1HZ3zdz2udBIoT4x7fzh7hlFmTRWd061f9cDeZOIQ/yAbGg4bqIvGuc5r+iejIGUbxRPYTZk4km51iUD8wER/+b9k2/6KOM7K/i1CoBVX1B0g3U8Fyv47ecWYWt68MP52JU4WPXOj3WKIvNO01yds06/YZltfJlAZgR3PARCENuq/hUr3hkixPPaaZGm6XuKDCZ63+HNKCp2sBR0USE+VepDtdFB5HuWzXfsIMx1npTJhNN3JpQTD15Nc/+iGeYpfWviQfIks1xkwZmNPt/j8T99WprbySHpiDNLa3qWPvL3ikOVJzA5XlYSKOZHLvt6q0wXsPGaxV9LdPO5aMLIfYIqaQtGaVIN9N0nmJGm8PqikKb0OAV9HXgHYEnzn/uJ9Q3exM1O5KwGTDFP5jFqohVeb7Xe6vWGBuHlCoYa6T6hsO+U0aYc5i1vqM1+IG/DfniGgQwmyVTxkrGMh6W1vX7VArbuy6MSn6qFowf/ZOaidcDx5CryVeFvHlZSIarIBz/nBy+fk5vSWuafLlMyaMSBL+CP9H1HD9bJR4WdfoyCYbeJ6TUotzGdxbpCMFdmBL+QYHKTrBy1qKtzH4OdppZImomr5OXwfig+fN9nFGTDx6Ih53wHOsCxXc8+G2qkUOLBR2iz6iM2+x0oJnvsTSWSM20cEIl8+vCq44WDtN7ymOAQdFYTyT1X7D5AFiKJiaAItu69X+eeQgiIidLkRRIWZXwwMSDo5R3eB9BOaPr55J0QhvDe5tqqJF4pfv0oB83hRe3mTXAmX6ohKj1ZHdwl7uJruJZcf8xQ+ap9bteEpw3vOs83yvu69188ZNWBUvvO5DClB0poRqLCBSwTPE1jOEpj+FFO0efYmZGJQ7TzjpxVJ7aLmZKVcfeDQ
 YsSSAxp/
 b+ngXgGdikNJaPFwZhuM3zaPrZA+HYs2F03rat0o1EdB1J+KD71j2qM22uVsypAnITjEjWQAhgD3S1Ip/xmZc52/cbfPJgIjvuAG5BKiAVNf0JhpER/sdzvU7I+oeZm6IbhbE6KQChoM4rLtzCmYg6uZNjIsmZF1Cas/96M8j1KZ3FPgla/fNA+8g5n9sA2gD8T2DIHS0/G9qFBUpM4rz1LSca3Chq9wOATeokdoBQoHut6PWAQIE7gDp49WOaAp+90gLHzRIwSlXhc3r1esptJF3p/jUEgZz/ft4P5oiEGGLaXMXjGbrQFg4PSCQzK8DW9suJyIykwQsQjEscsq3eCZD8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 12:54:28PM -0400, Johannes Weiner wrote:
> On Tue, Mar 24, 2026 at 12:01:55PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > On Wed, Mar 18, 2026 at 03:53:24PM -0400, Johannes Weiner wrote:
> > > memcg_list_lru_alloc() is called every time an object that may end up
> > > on the list_lru is created. It needs to quickly check if the list_lru
> > > heads for the memcg already exist, and allocate them when they don't.
> > >
> > > Doing this with folio objects is tricky: folio_memcg() is not stable
> > > and requires either RCU protection or pinning the cgroup. But it's
> > > desirable to make the existence check lightweight under RCU, and only
> > > pin the memcg when we need to allocate list_lru heads and may block.
> > >
> > > In preparation for switching the THP shrinker to list_lru, add a
> > > helper function for allocating list_lru heads coming from a folio.
> > >
> > > Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> >
> > Logic LGTM, but would be nice to have some kdoc. With that addressed, feel free
> > to add:
> >
> > Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Thanks!
>
> > >  include/linux/list_lru.h | 12 ++++++++++++
> > >  mm/list_lru.c            | 39 ++++++++++++++++++++++++++++++++++-----
> > >  2 files changed, 46 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
> > > index 4afc02deb44d..4bd29b61c59a 100644
> > > --- a/include/linux/list_lru.h
> > > +++ b/include/linux/list_lru.h
> > > @@ -81,6 +81,18 @@ static inline int list_lru_init_memcg_key(struct list_lru *lru, struct shrinker
> > >
> > >  int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
> > >  			 gfp_t gfp);
> > > +
> > > +#ifdef CONFIG_MEMCG
> > > +int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
> > > +			       gfp_t gfp);
> >
> > Could we have a kdoc comment for this? Thanks!
>
> And one kdoc comment.
>
> Your total will be 8.75, you can pull up to the next window, sir.

:>) Thanks!

