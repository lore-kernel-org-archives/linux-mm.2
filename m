Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF93ECD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 12:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E5F36B008C; Mon,  8 Jun 2026 08:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BCA76B0092; Mon,  8 Jun 2026 08:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2A46B0093; Mon,  8 Jun 2026 08:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A38C6B008C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:00:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E3E85164D93
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:00:32 +0000 (UTC)
X-FDA: 84856603104.18.A06B137
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 21B1F40014
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:00:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IjrcLdmH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780920031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IVC5nQqCidoFqRM8LQGkIF69G33RiMQVaV5iGFZGDOM=;
	b=IqyOngmmob0WThtFJjDZvPUvdEIsAoJeGzaNGr6pkc2M/1gmh0V39zM6Mp5b5AxPv1jy4x
	LPXiiJdb8PT0T/+wm/GBQhRSxLYfAHGQJaokkgo+MXwfgtsHH6SMfLNU+Wb1aUNejfb3Py
	wpbbxU2NRND9SZa8SQb9Y6/A4MSYINw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IjrcLdmH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780920031;
	b=1c8gR05Ocnu5AZ9vx31vMmwPOWIlmJaeB9SUbl20nhdMFvU3ob8qGGZlZLtZCNRSEkv/aE
	vBltvFuWzvIOijs/lrHxalsYTTL3PxFbYD2+IrnXJ/u8wusnrh7EjMk9xq/On9KuKcca2B
	Z9uIuv8WBNiHRsRQhPggsIEdxJxamME=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73121600AE;
	Mon,  8 Jun 2026 12:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2511F00893;
	Mon,  8 Jun 2026 12:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780920030;
	bh=IVC5nQqCidoFqRM8LQGkIF69G33RiMQVaV5iGFZGDOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IjrcLdmHCRpQJB1YQKd8hpGkhLJvpFIGaHdLtd1O049g9lv6t4rfKYsjAVgMbmlOC
	 OOdNHDZFzicUq1s9kZ5/cwaYVFI+VpB2LEuKvTMykKnJu2qRkVzRk7y37njm2l/+Cf
	 lksGDhJZe8eLa7UFzfICj/i3AtLqgqb2V6AI4qWPbOp7Ct+OO9QqIkstnXOySTteTP
	 2rJZXlTPC7ta2q5Il56girBzeQ+JMrNIeYQ/EWJmL+Kvv8R2H3bj6f22zYrSpVWJ0M
	 AHV5MUn14GdCHvFF6j2QSi+4BRJUTe8qmaAJVW9u2Un/4+YJ5t7m5BdA/6A9Uio7cU
	 ai89b1OWXXjIg==
Date: Mon, 8 Jun 2026 13:00:17 +0100
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
Subject: Re: [PATCH v10 17/37] mm: page_reporting: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <aias_qh3wR-Xkf6T@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <6a2f93e4447e55ada6ccf0f4d5c64e8d41a848d4.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a2f93e4447e55ada6ccf0f4d5c64e8d41a848d4.1780906288.git.mst@redhat.com>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: q856hws5nwpc5baftxggw6rkwp3wcw4z
X-Rspamd-Queue-Id: 21B1F40014
X-HE-Tag: 1780920030-437975
X-HE-Meta: U2FsdGVkX19MxXWiAQR2UkcpjTCZuEcnP9xJGXukRHYUcQEl3P5Zdq3xzXKPgxtBNmrrrA3KrXKY+hMRdxY+z/mqmIaAPwtfe8WpaWr7BUvHdVt+tJ1Afjmr2JrZAAOEfjFH6BtKC1YicihIvqrGszA58nRXtcxH8SC98fB6azMxrUdpHNr5Q80B68cG6Cf8IrCM7fSqfQVerVqT5jNH2BZ3+wzmQBJDZAIHPcpTICqL/IB0mX9Hxz0Woc9BbRrf+ny6HQxIZoqn6PawJmONCiivGO3Ebm7dRU7gwhNid4Yef/oFI0vJtFLKRR0I8FxSHaOPaOsOeoqhS9dozlNDVi//RZos7BVjqDLCl8GCrifN63iutFevkKz/00r5s7CTeSn18nkS2r/NYCBacRwk8IwA64cteZVcp25hqEsNYPWzQLOZ1dfxHiiwVYtcEKLiLcBJTuVEJE0rtBtl8Hk972NCt5J/Iwc60lH022aSDB8d8tAFnI79SbaFJjU2QvDmxc8W3Vzc8C1ja9j6Ty/ATbAQaJavCo8ysWDIWUkHuEsPYGOLwe7quhJLMuvZaDFw2H2dumbrvJxSdXsPD23uOnQWdoguMMGzVM9WFEDkxMKCvsdhtLOVdYvu5W4sZwMOOkRLSnumhI7lmhJCo3oUhGSwjuCzXQgCc+Z8Lahf66dwY/qceevEaLDWrI4B+DOR+MFysHUxl8ebWolKcLyp9NtZMwuZ2Hu8oMJ2cgpvi/pTwGmi6twYep9f/yuCq7BMx+j98x7hl24DDjAUzMbL80UPBd1dL6DNBcrNHARYydr9JRu1HSiEdFuIDRpjM/Pl1RN/sKlZlwklg0HL/d8D2HvBXy0r6IxyTOtLiTwOzRTjJz5vrt28B19igL27Vr2lPrLHVejeaHks8j4NbPoj5xSGroZM906mVUn0hlWuUAO1Oz4ie8KL3Ll41wpX6Y48dum2Snlow87np7D5fCA
 VNIjPXK4
 V+RpMEW5TvJLlqlkWcD40EJTtzm+9X8W6C5392v+o1Y6Cj/nt+7aW/3TXlclcgpZwPU7fIbXft20A8OjM00UpCVNPFIdhj6aaGVNrxF7gPLixU64CdvRxvAZrVyNAqr3nFjTt4nut/mWrTGnlwkbKTdlROfw+mvOIVyOiNNBlmZcCpgN0xbMCqqfyGbvgf5ZKfwrKBC+DCWnPdYCMOpGhl1QZmQVf5lEKRFx9WYYLqfUr+1qXifF4QAg0tnnrcq4Iy+ZqyCeSxL2ux40E1cK34oK98D7A2aiGPWIZvhSZ8wH6KpDU4OIwWl6pJ5xqQ8xvH9bX7L845xZmiix8v4td5++Y1LOinRstiLGuaVaUVm5xbDiFCyVrY4Pmpe9+Cf+U8z+ifVRsCxA0jUrxKXhVlNw40w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:37:48AM -0400, Michael S. Tsirkin wrote:
> When a guest reports free pages to the hypervisor via the page reporting
> framework (used by virtio-balloon and hv_balloon), the host typically
> zeros those pages when reclaiming their backing memory.  However, when
> those pages are later allocated in the guest, post_alloc_hook()
> unconditionally zeros them again if __GFP_ZERO is set.  This
> double-zeroing is wasteful, especially for large pages.
>
> Avoid redundant zeroing:
>
> - Add a host_zeroes_pages flag to page_reporting_dev_info, allowing
>   drivers to declare that their host zeros reported pages on reclaim.
>   A static key (page_reporting_host_zeroes) gates the fast path.
>
> - Add PG_zeroed page flag (sharing PG_private bit) to mark pages
>   that have been zeroed by the host.  Set it in
>   page_reporting_drain() after the host reports them.

I think this flag is really confusingly named, if it's a virtualised host
thing, then can we please encode that in the flag name?

I was looking at a later commit and wondering who was doing the zeroing
exactly.

And could we please propagate that throughout the code, some nebulous 'bool
zeroed = ... ' begs the question of whether it's the kernel who did it and
why we are adding logic

>
> - Thread the zeroed bool through rmqueue -> prep_new_page ->
>   post_alloc_hook, where it skips redundant zeroing for __GFP_ZERO
>   allocations.
>
> Currently the PG_zeroed hint can be lost when pages are
> split (expand) or merged in the buddy allocator.  This is
> harmless: losing the hint just means the page gets re-zeroed,
> which is correct but suboptimal.  Follow-up patches propagate
> PG_zeroed across splits and merges to preserve the hint on
> common paths.
>
> No driver sets host_zeroes_pages yet; a follow-up patch to
> virtio_balloon is needed to opt in.
>
> PG_zeroed pages may pass through PCP lists before being freed.
> This is safe: __free_pages_prepare clears all
> PAGE_FLAGS_CHECK_AT_PREP flags (including PG_zeroed/PG_private)
> before the page re-enters the buddy allocator.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> Assisted-by: cursor-agent:GPT-5.4-xhigh
> ---
>  include/linux/page-flags.h     |  9 +++++
>  include/linux/page_reporting.h |  3 ++
>  mm/compaction.c                |  6 ++-
>  mm/internal.h                  |  2 +-
>  mm/page_alloc.c                | 68 +++++++++++++++++++++++-----------
>  mm/page_reporting.c            | 14 ++++++-
>  mm/page_reporting.h            | 12 ++++++
>  7 files changed, 88 insertions(+), 26 deletions(-)
>
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 7223f6f4e2b4..91f8ddb1d512 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -135,6 +135,8 @@ enum pageflags {
>  	PG_swapcache = PG_owner_priv_1, /* Swap page: swp_entry_t in private */
>  	/* Some filesystems */
>  	PG_checked = PG_owner_priv_1,
> +	/* Page contents are known to be zero */
> +	PG_zeroed = PG_private,
>
>  	/*
>  	 * Depending on the way an anonymous folio can be mapped into a page
> @@ -673,6 +675,13 @@ FOLIO_TEST_CLEAR_FLAG_FALSE(young)
>  FOLIO_FLAG_FALSE(idle)
>  #endif
>
> +/*
> + * PageZeroed() tracks pages known to be zero.  The allocator
> + * uses this to skip redundant zeroing in post_alloc_hook().
> + */
> +__PAGEFLAG(Zeroed, zeroed, PF_NO_COMPOUND)
> +#define __PG_ZEROED (1UL << PG_zeroed)
> +
>  /*
>   * PageReported() is used to track reported free pages within the Buddy
>   * allocator. We can use the non-atomic version of the test and set
> diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
> index 5ab5be02fa15..c331c6b36687 100644
> --- a/include/linux/page_reporting.h
> +++ b/include/linux/page_reporting.h
> @@ -14,6 +14,9 @@ struct page_reporting_dev_info {
>  	int (*report)(struct page_reporting_dev_info *prdev,
>  		      struct scatterlist *sg, unsigned int nents);
>
> +	/* If true, host zeros reported pages on reclaim */
> +	bool host_zeroes_pages;
> +
>  	/* work struct for processing reports */
>  	struct delayed_work work;
>
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 4336e433c99b..8000fc5e0a2e 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -82,7 +82,8 @@ static inline bool is_via_compact_memory(int order) { return false; }
>
>  static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
>  {
> -	post_alloc_hook(page, order, __GFP_MOVABLE, USER_ADDR_NONE);
> +	__ClearPageZeroed(page);
> +	post_alloc_hook(page, order, __GFP_MOVABLE, false, USER_ADDR_NONE);
>  	set_page_refcounted(page);
>  	return page;
>  }
> @@ -1849,9 +1850,10 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
>  		set_page_private(&freepage[size], start_order);
>  	}
>  	dst = (struct folio *)freepage;
> +	__ClearPageZeroed(&dst->page);
>  	if (order)
>  		prep_compound_page(&dst->page, order);
> -	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, USER_ADDR_NONE);
> +	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, false, USER_ADDR_NONE);
>  	set_page_refcounted(&dst->page);
>  	cc->nr_freepages -= 1 << order;
>  	cc->nr_migratepages -= 1 << order;
> diff --git a/mm/internal.h b/mm/internal.h
> index 9d2198114510..4af5e72742ba 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -928,7 +928,7 @@ static inline void init_compound_tail(struct page *tail,
>  }
>
>  void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
> -		     unsigned long user_addr);
> +		     bool zeroed, unsigned long user_addr);

host_zeroed or something would be more appropriate no?

But in general do we need to propagate this around, can't we derive it from
the page zeroed flag?

It's really confusing as to _which_ zeroing this refers to, it seems the
only one relevant here is the VM host zeroing but that's completely
non-obvious and now everybody using these functions with the extra param
will simply have to happen to know this.

If we could find a way to avoid this propagation that'd be ideal.

Failing that, making it clear this is _only_ for vm host zeroing would be
better, but then maybe we need to think about how we could encode this in
some other way, e.g. passing alloc_context perhaps?

>  extern bool free_pages_prepare(struct page *page, unsigned int order);
>
>  extern int user_min_free_kbytes;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d4fbf1861a8a..45e824b1ec75 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1743,6 +1743,7 @@ static __always_inline void page_del_and_expand(struct zone *zone,
>  	bool was_reported = page_reported(page);
>
>  	__del_page_from_free_list(page, zone, high, migratetype);
> +

Stray whitespace?

>  	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
>  	account_freepages(zone, -nr_pages, migratetype);
>  }
> @@ -1815,8 +1816,10 @@ static inline bool should_skip_init(gfp_t flags)
>  	return (flags & __GFP_SKIP_ZERO);
>  }
>
> +

Stray whitespace?

>  inline void post_alloc_hook(struct page *page, unsigned int order,
> -				gfp_t gfp_flags, unsigned long user_addr)
> +				gfp_t gfp_flags, bool zeroed,
> +				unsigned long user_addr)
>  {
>  	const bool zero_tags = gfp_flags & __GFP_ZEROTAGS;
>  	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
> @@ -1825,6 +1828,14 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
>
>  	set_page_private(page, 0);
>
> +	/*
> +	 * If the page is zeroed, skip memory initialization.
> +	 * We still need to handle tag zeroing separately since the host
> +	 * does not know about memory tags.
> +	 */
> +	if (zeroed && init && !zero_tags)
> +		init = false;
> +
>  	arch_alloc_page(page, order);
>  	debug_pagealloc_map_pages(page, 1 << order);
>
> @@ -1867,7 +1878,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
>  	 * through a user-congruent mapping.  Host-zeroed pages
>  	 * (zeroed flag) don't need this: physical RAM is clean.
>  	 */
> -	if (!init && (gfp_flags & __GFP_ZERO) &&
> +	if (!zeroed && !init && (gfp_flags & __GFP_ZERO) &&
>  	    user_addr != USER_ADDR_NONE &&
>  	    user_alloc_needs_zeroing())
>  		init = true;
> @@ -1900,13 +1911,13 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
>  }
>
>  static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
> -							unsigned int alloc_flags,
> -							unsigned long user_addr)
> +			  unsigned int alloc_flags, bool zeroed,
> +			  unsigned long user_addr)
>  {
>  	if (order && (gfp_flags & __GFP_COMP))
>  		prep_compound_page(page, order);
>
> -	post_alloc_hook(page, order, gfp_flags, user_addr);
> +	post_alloc_hook(page, order, gfp_flags, zeroed, user_addr);
>
>  	/*
>  	 * page is set pfmemalloc when ALLOC_NO_WATERMARKS was necessary to
> @@ -3174,6 +3185,7 @@ int __isolate_free_page(struct page *page, unsigned int order)
>  	}
>
>  	del_page_from_free_list(page, zone, order, mt);
> +	__ClearPageZeroed(page);
>
>  	/*
>  	 * Set the pageblock if the isolated page is at least half of a
> @@ -3246,7 +3258,7 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
>  static __always_inline
>  struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>  			   unsigned int order, unsigned int alloc_flags,
> -			   int migratetype)
> +			   int migratetype, bool *zeroed)
>  {
>  	struct page *page;
>  	unsigned long flags;
> @@ -3281,6 +3293,8 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>  			}
>  		}
>  		spin_unlock_irqrestore(&zone->lock, flags);
> +		*zeroed = PageZeroed(page);
> +		__ClearPageZeroed(page);
>  	} while (check_new_pages(page, order));
>
>  	/*
> @@ -3349,10 +3363,9 @@ static int nr_pcp_alloc(struct per_cpu_pages *pcp, struct zone *zone, int order)
>  /* Remove page from the per-cpu list, caller must protect the list */
>  static inline
>  struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
> -			int migratetype,
> -			unsigned int alloc_flags,
> +			int migratetype, unsigned int alloc_flags,
>  			struct per_cpu_pages *pcp,
> -			struct list_head *list)
> +			struct list_head *list, bool *zeroed)
>  {
>  	struct page *page;
>
> @@ -3387,6 +3400,8 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
>  		page = list_first_entry(list, struct page, pcp_list);
>  		list_del(&page->pcp_list);
>  		pcp->count -= 1 << order;
> +		*zeroed = PageZeroed(page);
> +		__ClearPageZeroed(page);
>  	} while (check_new_pages(page, order));
>
>  	return page;
> @@ -3395,7 +3410,8 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
>  /* Lock and remove page from the per-cpu list */
>  static struct page *rmqueue_pcplist(struct zone *preferred_zone,
>  			struct zone *zone, unsigned int order,
> -			int migratetype, unsigned int alloc_flags)
> +			int migratetype, unsigned int alloc_flags,
> +			bool *zeroed)
>  {
>  	struct per_cpu_pages *pcp;
>  	struct list_head *list;
> @@ -3413,7 +3429,8 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
>  	 */
>  	pcp->free_count >>= 1;
>  	list = &pcp->lists[order_to_pindex(migratetype, order)];
> -	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
> +	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags,
> +				 pcp, list, zeroed);
>  	pcp_spin_unlock(pcp);
>  	if (page) {
>  		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
> @@ -3438,19 +3455,19 @@ static inline
>  struct page *rmqueue(struct zone *preferred_zone,
>  			struct zone *zone, unsigned int order,
>  			gfp_t gfp_flags, unsigned int alloc_flags,
> -			int migratetype)
> +			int migratetype, bool *zeroed)
>  {
>  	struct page *page;
>
>  	if (likely(pcp_allowed_order(order))) {
>  		page = rmqueue_pcplist(preferred_zone, zone, order,
> -				       migratetype, alloc_flags);
> +				       migratetype, alloc_flags, zeroed);
>  		if (likely(page))
>  			goto out;
>  	}
>
>  	page = rmqueue_buddy(preferred_zone, zone, order, alloc_flags,
> -							migratetype);
> +			     migratetype, zeroed);
>
>  out:
>  	/* Separate test+clear to avoid unnecessary atomics */
> @@ -3841,6 +3858,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  	struct pglist_data *last_pgdat = NULL;
>  	bool last_pgdat_dirty_ok = false;
>  	bool no_fallback;
> +	bool zeroed;
>  	bool skip_kswapd_nodes = nr_online_nodes > 1;
>  	bool skipped_kswapd_nodes = false;
>
> @@ -3985,10 +4003,11 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>
>  try_this_zone:
>  		page = rmqueue(zonelist_zone(ac->preferred_zoneref), zone, order,
> -				gfp_mask, alloc_flags, ac->migratetype);
> +					gfp_mask, alloc_flags, ac->migratetype,
> +					&zeroed);
>  		if (page) {
>  			prep_new_page(page, order, gfp_mask, alloc_flags,
> -				      ac->user_addr);
> +				      zeroed, ac->user_addr);
>
>  			return page;
>  		} else {
> @@ -4215,9 +4234,11 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  	count_vm_event(COMPACTSTALL);
>
>  	/* Prep a captured page if available */
> -	if (page)
> -		prep_new_page(page, order, gfp_mask, alloc_flags,
> +	if (page) {
> +		__ClearPageZeroed(page);
> +		prep_new_page(page, order, gfp_mask, alloc_flags, false,
>  			      ac->user_addr);
> +	}
>
>  	/* Try get a page from the freelist if available */
>  	if (!page)
> @@ -5190,6 +5211,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  	/* Attempt the batch allocation */
>  	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
>  	while (nr_populated < nr_pages) {
> +		bool zeroed = false;
>
>  		/* Skip existing pages */
>  		if (page_array[nr_populated]) {
> @@ -5198,7 +5220,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  		}
>
>  		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
> -								pcp, pcp_list);
> +					 pcp, pcp_list, &zeroed);
>  		if (unlikely(!page)) {
>  			/* Try and allocate at least one page */
>  			if (!nr_account) {
> @@ -5209,7 +5231,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  		}
>  		nr_account++;
>
> -		prep_new_page(page, 0, gfp, 0, USER_ADDR_NONE);
> +		prep_new_page(page, 0, gfp, 0, zeroed, USER_ADDR_NONE);
>  		set_page_refcounted(page);
>  		page_array[nr_populated++] = page;
>  	}
> @@ -6949,7 +6971,8 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
>  		list_for_each_entry_safe(page, next, &list[order], lru) {
>  			int i;
>
> -			post_alloc_hook(page, order, gfp_mask, USER_ADDR_NONE);
> +			__ClearPageZeroed(page);
> +			post_alloc_hook(page, order, gfp_mask, false, USER_ADDR_NONE);
>  			if (!order)
>  				continue;
>
> @@ -7157,8 +7180,9 @@ static int __alloc_contig_frozen_range(unsigned long start, unsigned long end,
>  	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
>  		struct page *head = pfn_to_page(start);
>
> +		__ClearPageZeroed(head);
>  		check_new_pages(head, order);
> -		prep_new_page(head, order, gfp_mask, 0, user_addr);
> +		prep_new_page(head, order, gfp_mask, 0, false, user_addr);

A nit but I really hate these kinds of mystery meat booleans, which mean
you have to now go look up what this is.

One thing we use in mm quite a bit now is e.g. '/*zeroed=*/ false'. Though
some might say even having a boolean like this is a code smell in itself.

>  	} else {
>  		ret = -EINVAL;
>  		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
> diff --git a/mm/page_reporting.c b/mm/page_reporting.c
> index 5b6b17f67131..84ebc4547119 100644
> --- a/mm/page_reporting.c
> +++ b/mm/page_reporting.c
> @@ -50,6 +50,8 @@ EXPORT_SYMBOL_GPL(page_reporting_order);
>  #define PAGE_REPORTING_DELAY	(2 * HZ)
>  static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
>
> +DEFINE_STATIC_KEY_FALSE(page_reporting_host_zeroes);
> +
>  enum {
>  	PAGE_REPORTING_IDLE = 0,
>  	PAGE_REPORTING_REQUESTED,
> @@ -129,8 +131,11 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
>  		 * report on the new larger page when we make our way
>  		 * up to that higher order.
>  		 */
> -		if (PageBuddy(page) && buddy_order(page) == order)
> +		if (PageBuddy(page) && buddy_order(page) == order) {
>  			__SetPageReported(page);
> +			if (page_reporting_host_zeroes_pages())
> +				__SetPageZeroed(page);
> +		}
>  	} while ((sg = sg_next(sg)));
>
>  	/* reinitialize scatterlist now that it is empty */
> @@ -390,6 +395,10 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
>  	/* Assign device to allow notifications */
>  	rcu_assign_pointer(pr_dev_info, prdev);
>
> +	/* enable zeroed page optimization if host zeroes reported pages */
> +	if (prdev->host_zeroes_pages)
> +		static_branch_enable(&page_reporting_host_zeroes);
> +
>  	/* enable page reporting notification */
>  	if (!static_key_enabled(&page_reporting_enabled)) {
>  		static_branch_enable(&page_reporting_enabled);
> @@ -414,6 +423,9 @@ void page_reporting_unregister(struct page_reporting_dev_info *prdev)
>
>  		/* Flush any existing work, and lock it out */
>  		cancel_delayed_work_sync(&prdev->work);
> +
> +		if (prdev->host_zeroes_pages)
> +			static_branch_disable(&page_reporting_host_zeroes);
>  	}
>
>  	mutex_unlock(&page_reporting_mutex);
> diff --git a/mm/page_reporting.h b/mm/page_reporting.h
> index c51dbc228b94..736ea7b37e9e 100644
> --- a/mm/page_reporting.h
> +++ b/mm/page_reporting.h
> @@ -15,6 +15,13 @@ DECLARE_STATIC_KEY_FALSE(page_reporting_enabled);
>  extern unsigned int page_reporting_order;
>  void __page_reporting_notify(void);
>
> +DECLARE_STATIC_KEY_FALSE(page_reporting_host_zeroes);
> +
> +static inline bool page_reporting_host_zeroes_pages(void)
> +{
> +	return static_branch_unlikely(&page_reporting_host_zeroes);
> +}
> +
>  static inline bool page_reported(struct page *page)
>  {
>  	return static_branch_unlikely(&page_reporting_enabled) &&
> @@ -46,6 +53,11 @@ static inline void page_reporting_notify_free(unsigned int order)
>  #else /* CONFIG_PAGE_REPORTING */
>  #define page_reported(_page)	false
>
> +static inline bool page_reporting_host_zeroes_pages(void)
> +{
> +	return false;
> +}
> +
>  static inline void page_reporting_notify_free(unsigned int order)
>  {
>  }
> --
> MST
>

Thanks, Lorenzo

