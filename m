Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 391A0CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 10:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09726B00A4; Mon,  8 Jun 2026 06:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E0856B00A6; Mon,  8 Jun 2026 06:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91DCB6B00A7; Mon,  8 Jun 2026 06:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 812426B00A4
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:34:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 418341C2B6D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:34:08 +0000 (UTC)
X-FDA: 84856385376.03.03F4E71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 96E4A180003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:34:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZHnYKrz9;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780914846;
	b=DgYLkA6tn/QOeb4psC1zwNe7ziUnohDkHWWudv2EwpdRiMmguhsSYkcMGTmC86AGW7GxB6
	7iopBOIRXB7LT0kmr4VTHOXPMnH3se8/ijKMPy4czRd39G2TLt6q8dXBa98nVZZJZaWFjY
	vZw1V5R7aMDd3A8X/w/Wk2XceIPeZnk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZHnYKrz9;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780914846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MSISkVncYbol5NQ8VxRTT0axoLQuPhRhAriBgGYAZXg=;
	b=jRcjqgZ6RuVVHHlwILetTdAgfG+EYRwvggGDxocSTdJL+/Q1/J7bvofJerQWkLt89YcWph
	YuznUHoFk4qkW18OlfSqhtqsMlcERtChGCgvQGZcKVo1Iwf4iDhrNGAJLKodCzc9KtSKMS
	Z5LBqz3TGW+cGbawEXAcsYDMrE6KZoM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB5C043CB2;
	Mon,  8 Jun 2026 10:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74F91F00893;
	Mon,  8 Jun 2026 10:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780914845;
	bh=MSISkVncYbol5NQ8VxRTT0axoLQuPhRhAriBgGYAZXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZHnYKrz9Qs8aK4+fkFURCjmiiXG1BeMHMEMJ/ZAHTREqJhvUqZrAr7YOLGmfvQ+Ox
	 jVWnmIEpAcv8t5QzkYv5pJGNnGbgq0+Z8YL+zegc7IcwlcZJf4g7FfDplW6wfnYkuf
	 tzr2pEdthhZpjZ2czMDoYlsDicBUOFkXZKeQ6NiMyq9vFkx/kV373PeDHerO0CTTbO
	 sC+n3O7gGJ5Htn2skdyf60ZDotpFXXgU6+nWynLOxt1NNbTw4BY9xzZlxW0Flsih1p
	 jcqXhksxWYI+4Bni/EgC2t9htE27d6iGTlsjvkkC14cy7bBI17c7sTxFUWixl4GOhC
	 0bDP77Dp2wBpw==
Date: Mon, 8 Jun 2026 11:33:52 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, virtualization@lists.linux.dev, 
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 11/37] mm: page_alloc: move prep_compound_page before
 post_alloc_hook
Message-ID: <aiaZ4vhWq6vl-Yts@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <de0433334a7763b81ce8ca8f8a332c800cfe64ed.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de0433334a7763b81ce8ca8f8a332c800cfe64ed.1780906288.git.mst@redhat.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 96E4A180003
X-Rspam-User: 
X-Stat-Signature: dbcj45hznu67wgoswwmcyaaq6yr6z545
X-HE-Tag: 1780914846-407674
X-HE-Meta: U2FsdGVkX1+htskea3Mg6eC8klK0kqS0w63HbFFMgHF4jY45fj02inm1KA70rADrIEPQW6iFgIv29HCmrCKbnmfKy9Zm92eGT1bVHcz7AWBiGX6a1k6SUixrkqMSwss5kFEyMdTuE90c1CzhNtUHb8FoVsLQSxHS1pJKsUNnco/lfUUG9R2ucuxA4emvyOEb/6B3cTD70C4b7m1jTl+Fdyat//jE7ojVg7aFTv1m9xhyg49fNHvfVl854IC/ziODqlRCneMoxHJqqpFNSt7z+2RcEZgik2sJg1UoTRCBJbLphxo71T2gYRI1qzwdko2mUO6/ZFD5Y3XDuHfEwYz4kPGKuAbRh5CxlaAAwNkBKU8v1Kt6YuWw0V8mxQhEBHWncss4wvCRq1Yy/s7NAjXc0QW14wsox2SJGSOaonXIaFWwVBZTb4TL2lhWTN2r7zAnAlDfvHJ/y8MXRgnagZhPj8iuBRFewtm7PLwc3tl7MgN6eK36vekMH/4zeCiXnXwqTCp9A4L4Go1fdIXY9vRti/UYuWE3rtgm/pbl3VhNojSCdK2brvYxWSWMhoyrOEI9Ixm7TZMpJGxVjD4Q6PRziD2q03WSK77IghQJRAV92+rND8UqklZzEZF6xXiR8Zs/nNJuTBkp8+kkASfhpDhfNlFVpQuW9h7CO3dZGCVZYRgOPAl3qe6lZzdphTDyhi3ZPF2bH7hQTfmNM++b9LWfoGhcoxrmQrHzL/Yh4NjOBmRJfL6ceAubel3BXsbYHfqKprx6pv+m8JSLru8d0ey2dsO11BDnzMoEuTxFY5oohA3e1tkbEoNSVIa8S5PSXOXXd3CKtQqO8OzlqCNacb/ugVZEfviZwP7k/X4ho71cqbgB++bzqVkr7Kd2qcpXRzG3ypyyxENE8uLe1UfSX2h3r0WeSh139smzL7+CvNiAnr05+pI/cRrWxtEJ/ZRm6vXEsAv50s1wsrh2tE0D9jJ
 p6sfF47Z
 wyLv6eJIIGWRfszf8f44G9wSNdnQe1Wa8xvQR6EZ5n1dg15CaqzkMkKchv34CBKYiMxAN6Nspxw9d6agAwJLskkXuJWlxzT8wwu0k2t+OTMgEbc0p5x25qaHgn76+bxx9EfeLVdT9d5BPRyfj4s097QIM3ozAfcIpPelXKXoX4Eav8PQsXIaYSMwq4L7/Yp+4r3en9T9fU5xQdnohtz1umUUWIHJJ4xazbCKKP4rAYZgj24o0azs44wsyYyNg6rbPctG6qNTCF5KzYeGMHs619iYFK9ZCQaYfvFzMLL+RrIOcypPj/L97fGwPJb8Yn7WKDKq21Klm0ZSccijnN+qLXhnFeXSb1adKPI4O9OcZw0lQRr71ySognBAIlWfmbMi/GAagqctnNvCfJcWL9Gts4h9T+X3yoBiccjT1bCFFJh0kwV8vnpYIxD+RhqLK862faoYM9wFYf6a6IlA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:36:20AM -0400, Michael S. Tsirkin wrote:
> Move prep_compound_page() before post_alloc_hook() in prep_new_page().
>
> The next patch adds a folio_zero_user() call to post_alloc_hook(),
> which uses folio_nr_pages() to determine how many pages to zero.
> Without compound metadata set up first, folio_nr_pages() returns 1
> for higher-order allocations, so only the first page would be zeroed.
>
> All other operations in post_alloc_hook() (arch_alloc_page, KASAN,
> debug, page owner, etc.) use raw page pointers with explicit order
> counts and are unaffected by this reordering.

I'd put this justification for why this is safe above the 'next patch' stuff.

>
> Also reorder compaction_alloc_noprof() for consistency. Compaction
> currently passes USER_ADDR_NONE so folio_zero_user() is not called

Yeah again, this 'just so' stuff of when or when not an address is passed is
concerning.

> there, but keeping the same ordering avoids a future tripping hazard.

No functional changes or functional changes? If none then say so.

>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> Assisted-by: cursor-agent:GPT-5.4-xhigh
> ---
>  mm/compaction.c | 4 ++--
>  mm/page_alloc.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 72684fe81e83..4336e433c99b 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1849,10 +1849,10 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
>  		set_page_private(&freepage[size], start_order);
>  	}
>  	dst = (struct folio *)freepage;
> -	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, USER_ADDR_NONE);
> -	set_page_refcounted(&dst->page);
>  	if (order)
>  		prep_compound_page(&dst->page, order);
> +	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, USER_ADDR_NONE);
> +	set_page_refcounted(&dst->page);
>  	cc->nr_freepages -= 1 << order;
>  	cc->nr_migratepages -= 1 << order;
>  	return page_rmappable_folio(&dst->page);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0943ab724032..4676fd49819e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1874,11 +1874,11 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
>  							unsigned int alloc_flags,
>  							unsigned long user_addr)
>  {
> -	post_alloc_hook(page, order, gfp_flags, user_addr);
> -
>  	if (order && (gfp_flags & __GFP_COMP))
>  		prep_compound_page(page, order);
>
> +	post_alloc_hook(page, order, gfp_flags, user_addr);
> +
>  	/*
>  	 * page is set pfmemalloc when ALLOC_NO_WATERMARKS was necessary to
>  	 * allocate the page. The expectation is that the caller is taking
> --
> MST
>

Thanks, Lorenzo

