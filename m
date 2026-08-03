Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0758DC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6D26B0096; Mon,  3 Aug 2026 11:07:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67E406B009D; Mon,  3 Aug 2026 11:07:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BAE56B00A0; Mon,  3 Aug 2026 11:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2EA596B0096
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:07:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A91F31A0765
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:07:55 +0000 (UTC)
X-FDA: 85060288110.17.35F11A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 19BC6100017
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:07:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kTE+/Up8";
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785769674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2T8dsYQ/yokvFm5Hvo97P6jloDB9Jam9qmoCjWPa3ao=;
	b=UkIJ1FETY6/dVRnESuKMZRODxVaev3j61JVsil7PwOHydTQ6cG1M2wwU//CFvdR5inDb8t
	ODkkIyK6zB+K6zjzn+rD1OUjPkTq6J6M7mEmtHYkihqNHDa6qg4L5qVPEsmFkRvH7Ga04A
	W1JpUS+DPlz0coepQLX9JP/pLC6azoo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785769674;
	b=SrZZE+QA0vtdFy2ldcB4oKU/VnAHXt1/Yo7mdCALLw0nYWF8Nx12S2qNBc0HRxuk/WQezA
	6osr+nRuU40wnEdCAjC6QTlUqQA3RfiSJ8ePr0In866XDHqtiBcCfdLG1v8Vt5SATsqOwP
	GP8mtNdh/EyaXdbz1I6pX6WDklXJTms=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kTE+/Up8";
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 88C6060A89;
	Mon,  3 Aug 2026 15:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3F21F000E9;
	Mon,  3 Aug 2026 15:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785769673;
	bh=2T8dsYQ/yokvFm5Hvo97P6jloDB9Jam9qmoCjWPa3ao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kTE+/Up8JVH3KqYp0V99R6t55UtaaF4Bc7Inu3jh3UFi/Y737TMAiYKJa88xngrEr
	 polOoaiwAbcv7tFVfJtN8xEPRkHNpQYwlXrhfaax/OjsrG7HnDN+PAgNfq4/DsO7MB
	 v953LXE8aEOhE2leCcJ5xkWy+eVEYGfNdUAyCyR14meMP+ZowKyYK0GWVvzmaRD66X
	 ArtIvBTLULpTgLUKJSE0SdAq5OTIzSy6K+HDGwlz+13KpDMZmSZV/6IqpO4zRJ2wEg
	 dExgwc6htXkMVcd9FN19bKEKTuZi0QBTqM9Qf7b2H/WD6Ts3jSOelXSAxREYW2TYd9
	 Noz9H8psSpAeQ==
Date: Mon, 3 Aug 2026 16:07:35 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	William Kucharski <william.kucharski@oracle.com>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] mm/huge_memory: use folio's memcg inside
 __folio_split()
Message-ID: <anCtxQE5hDUH5N6a@lucifer>
References: <20260730-add-gfp_account-to-xas_split_alloc-v2-0-5a56c2361d85@nvidia.com>
 <20260730-add-gfp_account-to-xas_split_alloc-v2-1-5a56c2361d85@nvidia.com>
 <am28pV2PEfHsi4p-@lucifer>
 <DKFEEI2EDS4F.1AHGKB1EL6XRG@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKFEEI2EDS4F.1AHGKB1EL6XRG@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 19BC6100017
X-Stat-Signature: 7c4x1j4p6ni1786b1dy89sstuc3axkh1
X-HE-Tag: 1785769673-291492
X-HE-Meta: U2FsdGVkX18KiDrF5C5l+5rraz4ZIyj3K28i3DXXNUBoxz5yC+zxZGLpMhw305SIT6aimQfk/uuShCXmex/FhJSUQJFKu60zqH22j8Jyubwl3vTc+YBAwtXvTFJQWTEU/bJpcrC9gZWb4L9M0k1l3pqzK22I5eCeMmcxo6TejhK12Ni8JjSDmvgsD3iIE/nY4gclLNvoRt7c/Ky+bLmJOQKUro6jkAKANNFwoMMyx74snU+1BYvqtnmZzhS0LAA/KHV94O3AtIZqABPHVmzQGIOciNsE3TmFII5+vRI2zoezgLtc2yoX9jD5lfC7rpVSPt6ZHMX2paFqQ2p4ECJ18TntxoHbDN6tqayD0rb7Vx7wiAsC5zbw8rAQpQ0jUb/QUK+o4qGr8YQ7wtqv420SEkQoJcl3TkYARY8FVhgTyJW+wXI/KjTYdjVxw7UBrQGeB6NZHnXIvBTUMOGvdIEmM4F/3cfuKjWYFfaXOYMAhhCvpdktBZBNJl3wndg2X4mQ4DD2ZuUp2JEmYHK5ZoaARDJasiEWOaSSoASCrua3qaNvq5l8IqrX0k31Uhc7Jg5igsuA+V9+qzubzXQX2q2Li2S7ijiW6oVB+u6tRI+XB2DcntDYIiSzDN1Jk9IZD8jfi1Sruo+p65ka5/OWk+cRd+zRe3WSD7HSuAv0k3Tm+Gj2egWxGejJW/Vti8lrehPmgt7AH7JKzKUnKyd3rvfpOA2nshHwkY47x2Iigzk/d9EpxZgDsBc125+IfwTzSXTkCNRT40SQiXs0QhPVwU2U2kpmuto8nuDkyjS5c4pCo8qN2jysTvmBIOQJ6ezypKYpaVsxAjlBjslRtxhp6k2zKw9574AdwJhfNcyMIgTkfzxIE5cbuwBvb4ExnBQes1vozHNIBBHcvQGLiyzsIXAztZ4ii9h2MxPedlCtjKunyeiAFbgg/3tKBKGvWn+Bla5vsfPKy7PtVdZL4iqS6aH
 vK+6EkGO
 k62Dz6Gu5MtotG7+6b5OU7ExXv9Yf7hYST8UKTXe/RKz8r/hikrVGRhind/Gi08nkZyrj6RwuQcZcG0nYlN6fZA0PkexL8Q8VoRhJ0Ier1smUIDhErD6L5pIviiRqDXGDIwupiI1TzxgVxE1E3bvFXx4juWqciLU6C1BcEbRsQrRlJzRM2CbMc3bDDSkoboSkkkAqRMsvheCLpYgXZJ/hJnJd60CcskwfTscYOyMH+z1qOiYYiBl4ZDT/Vm/L93i682o19kQP4HGSo24el8CG6KCA1Gf/6uOm/S+OkCwre3EYnB/vL5hATYmPq6/p/uhX0GcO7umV9iZtmOnox3ojITO/pLBqaHZJc3lDqUQYNNhxitsANA9JLfeTujCVAhh5ZV+LKqQeslR/htWuMZxsCFMurQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 11:02:30AM -0400, Zi Yan wrote:
> On Sat Aug 1, 2026 at 5:36 AM EDT, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Jul 30, 2026 at 10:18:00PM -0400, Zi Yan wrote:
> >> During a pagecache folio split, an xarray node allocation can happen and
> >> needs to charge at folio's memcg instead of folio split invoker's memcg,
> >> because for example folio split can happen during reclaim and reclaim's
> >> active memcg might not be folio's memcg. Switch to folio's memcg at the
> >> beginning and switch back afterwards.
> >
> > I assume this is the only allocation? I guess in general it makes sense to have
> > the folio's memcg be active here regardless.
> >
> >>
> >> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> >> Fixes: 6b24ca4a1a8d4 ("mm: Use multi-index entries in the page cache")
> >
> > Cc: stable?
>
> Like you said above, only xas_split_alloc() is affected. And we have not
> seen related workingset regression report (like what Johannes reported
> in commit 7b785645e8f13 ("mm: fix page cache convergence regression")).
> It might be OK to not backport.
>
> Johannes, what is your take on this?
>
> >
> >> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >
> > Change seems reasonable overall.
> >
> > Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> >> ---
> >>  mm/huge_memory.c | 20 ++++++++++++++++----
> >>  1 file changed, 16 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >> index 04e8a6b553435..b9c2d8908e564 100644
> >> --- a/mm/huge_memory.c
> >> +++ b/mm/huge_memory.c
> >> @@ -4063,34 +4063,42 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> >>  	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
> >>  	struct folio *end_folio = folio_next(folio);
> >>  	bool is_anon = folio_test_anon(folio);
> >> +	struct mem_cgroup *memcg, *old_memcg;
> >>  	struct address_space *mapping = NULL;
> >>  	struct anon_vma *anon_vma = NULL;
> >>  	int old_order = folio_order(folio);
> >>  	struct folio *new_folio, *next;
> >>  	int nr_shmem_dropped = 0;
> >>  	enum ttu_flags ttu_flags = 0;
> >> -	int ret;
> >>  	pgoff_t end = 0;
> >> +	int ret;
> >>
> >>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> >>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
> >>
> >>  	if (folio != page_folio(split_at) || folio != page_folio(lock_at)) {
> >>  		ret = -EINVAL;
> >> -		goto out;
> >> +		goto out_no_memcg;
> >>  	}
> >>
> >>  	if (new_order >= old_order) {
> >>  		ret = -EINVAL;
> >> -		goto out;
> >> +		goto out_no_memcg;
> >>  	}
> >>
> >>  	ret = folio_check_splittable(folio, new_order, split_type);
> >>  	if (ret) {
> >>  		VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");
> >> -		goto out;
> >> +		goto out_no_memcg;
> >
> > This function really badly needs splitting up and probably some cleanup.h work :)
>
> You mean folio_check_splittable()? You want to move -EINVAL checks a
> separate one?

No __folio_split().

Comment about cleanup.h really was the whole pattern of goto xxx for various
levels of unwinding things.

But really I mean the folio splitting code in general, there's a lot of
massive-complicated-functions with a million things going on at once,
__folio_freeze_and_split_unmapped() is another.

Feels like we should really have this stuff in something like mm/folio.c anyway
too now that's renamed :)

>
> --
> Best Regards,
> Yan, Zi
>

--
Cheers, Lorenzo

