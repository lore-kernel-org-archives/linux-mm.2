Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1433BCD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49FAE6B0088; Mon,  8 Jun 2026 07:39:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476FB6B009F; Mon,  8 Jun 2026 07:39:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38D116B00A0; Mon,  8 Jun 2026 07:39:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24B476B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:39:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E36E7140AAC
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:39:44 +0000 (UTC)
X-FDA: 84856550688.28.61E429C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 633DBC0012
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:39:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I4U0hGyk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780918783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZGVpNatqeAnKrQKe+tVSHeKyDhAqAjd/ZyB79qiaOjg=;
	b=Zh31SVHg/iv6bfPDhQFcBCj4QMLLfUwig4sQhztXvU1p6sfuN8pUDoKEZCX3kPuGg2PfRA
	juKw4P6ahouRh5pSD+nF1/I02F/9fgMCbGXzYXeUR6EfGouArhXYMI9huEmhgrgKS4eQAN
	DSpAwOjreuw/TpfVro1FIUM6yyBAahI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I4U0hGyk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780918783;
	b=v7slfP7SwE5yKGyA5OJFt6OAoExqmeIy0Sk6Htzuv+6rMEzOBW6olInYiVOYPDHUbd0KpY
	UoFdjuC5pkY4JKmh755H7yT+1KsNWD3nn1weKD/P7RVXkkuv0tq5cgVOkqtDFReZwCfr09
	GfSJ5I6UBVgQfMk8tjLLpAOvwaGqOI8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E7DCD6001D;
	Mon,  8 Jun 2026 11:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEA61F00898;
	Mon,  8 Jun 2026 11:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780918782;
	bh=ZGVpNatqeAnKrQKe+tVSHeKyDhAqAjd/ZyB79qiaOjg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I4U0hGyk+GsJAFicOe2q5eUPxaYhqxAumMWYhao3KXzMNTS9nA3sNxv23AeXksrWd
	 FXKalFf8yQhkj5sh8wg12bZ0SecQtOnXf0ozNeoBO4qTTTzN0c0nx2C0YatsRwmEAb
	 PdidAKdg76E1HGIWFIyYyuH7KQ8GpfNqOppt9b3Hv7jAewH8hKLSdmbYoyZiz4lRvv
	 QQ0xAwY8ym4Yz3EfNKSW7TbYo+hhSNM9ncXC3GIlmBk32mv59bq7CKjntN/OcUf3J0
	 z+GUb8XCScERYztrwnn0So3z59GX/JjrUsl8zuoVT0eHGkVJa7KmYfCb1G6/bE5yaL
	 ZfbynUejkwM4A==
Date: Mon, 8 Jun 2026 12:39:29 +0100
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
Subject: Re: [PATCH v10 18/37] mm: page_alloc: use aliasing checks instead of
 user_alloc_needs_zeroing
Message-ID: <aiapqEiASrriQqnA@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <d9b5fc983725665749024312f9ff5ede4f05e405.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9b5fc983725665749024312f9ff5ede4f05e405.1780906288.git.mst@redhat.com>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: gnq5qniayrpzpehxnhwimrggr93hygur
X-Rspamd-Queue-Id: 633DBC0012
X-HE-Tag: 1780918783-289030
X-HE-Meta: U2FsdGVkX1/G+HaqGKCOXhYfU864vFQ33lQh+Ezj8KiMMiHpXTlbiTtmWLXznxegLO8vc49kNtVAtuI/ZiRsu2s8yd9l+VP7Py9BZir0tIWm/JftYkI6rtlRAV4tbUeHqoqok0V2ClgKSAiVtKrVZgBsjUg5P4nWUKWN7WquizJyxxpo0+h+BD+F/CdRNX8hULsOfgQd4WPfbblRKjNjkPIzyiuKWYtrWMMEsLcoNWsdtbnn+tYQz4iuzTu0eD7HUp8rra/TIslvpkafmxOJ97GzsrGaO1IbiTYsZfPslDI30UlPGGAUerQZ9oEBir10YrtJr4rIJlH8LGtnFWalHI3AvWRRlDU1bLQnEf3Rx85zOLRyTLcU2cQ4mt109RAR0pKZ4fcNlXcHOnerjXxUHKRnyOscOIMz5IWpmvZG/VFLlSGMKLbx9BZc6jS6A8ZsIx3+zssN1EZ7FCMwu6oRlmdwpTTpxU66yacDUXo+fZEbU9r0FddTR2/NZvQTTtHVyY7vEOTCy8DW2P0miu3KPc668gW39UYSYlk45NrL45u2x5w2AdZEuJqhwP+Eg+V4jbGVzxT6ck7b/B5Ra7jMIHyAT7IpGE7SuSvZtV0ZZt89MXkpWwY9bg23vKyYQzVnrd0HOrkZ9ju1R0uATUf0xOn2VyFNUzyeFkLbV6M8JcMtNFoOtvVUWOhT9fhGXYquzb0pAT7/IyCHlY9iyPVZZ1hpb4uT2kr9Rep9RBIPp23xB0176Vg97Hhsa33JXLp6x1Xg2DK4z/v0UOLwYagGKj6wFP/5jYTgAJUPzDoYumWFBAYdnTY75QEC1S2QSqxZnnfKkrjSdB4x0M6Pfj/HQVL+eog7ijeyyjE48Ybz2a0+MArefbaWBdfdyOO+2M9+M+yBzTPk7sDiL+N2HqoqGtI32L+wHeDYLNEGnG0w07g8fXfbdWgaKQ3o+3ivYWROcA5C3rTnoQ0iU4r8nb+
 B15cv7sW
 nZP71ot2XN2Py1pynJ708lkm/L9y0L/kbVz79DwCBV76/pGnzq+0KR3dPj+B0D+izxBX9liZeYvZvS9ESeCjnN6SVO0JOoJZVx3f8SCuoFEWtk546thNnVepmQ7tEuuAgFak1KJbEq3WKG0gDGLawnraoJMmlOar7G3Xeq14O1mfimrkJceQiyi3Ug418GgllaI6rvUQvWDrskisIcLodN5irk1198/qLVcBYT0s9MYAfGLA+UOjjzUh0KTYBuZe0eEAstOXYRVgpZktPCoUDD7ziTRySK9XY7rMY23cTvt7vA5raedSCPI51s73/oAIO4vRkePeOWhFEWWYm6NolEmJq0BmOj5WWXwvofQ85AaNkc10GLwrdBLB8oZsm9Ru8Qfb5RXG5soBKQzg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:38:00AM -0400, Michael S. Tsirkin wrote:
> Replace user_alloc_needs_zeroing() with the direct aliasing checks
> (cpu_dcache_is_aliasing() || cpu_icache_is_aliasing()) in the
> post_alloc_hook aliasing guard.
>
> user_alloc_needs_zeroing() includes a !init_on_alloc term that
> means "allocator didn't zero this page."  But in this guard's
> context (!zeroed && !init && __GFP_ZERO), we already know the page
> is zero; init incorporates init_on_alloc via want_init_on_alloc().
> The only question left is whether the cache architecture needs
> the data re-zeroed through a congruent mapping, which is purely
> cpu_dcache_is_aliasing() || cpu_icache_is_aliasing().
>
> On non-aliasing architectures with init_on_free=true and
> init_on_alloc=false, this avoids a redundant re-zero of an
> already-zero page.
>
> Note on PowerPC: PowerPC overrides clear_user_page to call
> flush_dcache_page after clear_page, but on freshly allocated
> pages PG_dcache_clean is already clear (cleared by
> __free_pages_prepare), so flush_dcache_page is a no-op.
> Skipping this here thus has no effect.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6

This seems like an odd ordering of patches, can we group like changes
together?

> ---
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 45e824b1ec75..edfc83571985 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1880,7 +1880,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
>  	 */
>  	if (!zeroed && !init && (gfp_flags & __GFP_ZERO) &&
>  	    user_addr != USER_ADDR_NONE &&
> -	    user_alloc_needs_zeroing())
> +	    (cpu_dcache_is_aliasing() || cpu_icache_is_aliasing()))

Let's try and simplify things rather than adding endlessly huge if conditionals?

It's now incredibly hard to track exactly what's going on here, and that is
bug-bait.

>  		init = true;
>  	/*
>  	 * If memory is still not initialized, initialize it now.
> --
> MST
>

Thanks, Lorenzo

