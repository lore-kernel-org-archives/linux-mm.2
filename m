Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C8B1CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 10:30:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 484DA6B009D; Mon,  8 Jun 2026 06:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45CA76B009F; Mon,  8 Jun 2026 06:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 372756B00A2; Mon,  8 Jun 2026 06:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23EF86B009D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:30:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CDCE040A44
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:30:04 +0000 (UTC)
X-FDA: 84856375128.19.280B92C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 18BB7140016
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:30:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SLwFPFLG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780914603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVTRLRF6w9LEvYfidF9fmm8s09kK9Yw4y/1Wh8KsguI=;
	b=GKA8aM1a9YGheBUg++2hXLWEJ03WDvG9q/UwbGsECeAXVwp7KHoAyjjDL/KClZt56GRsmB
	Pa9BPpg0XHbwfI4221uSfFGcTtYt2aT9QRgmaD8X+r9kI0KTgZMJeSe5awYRFBzGZDtTiD
	E5hU1hKEIH0PJ8T0tTD9VdtHu+UgNd4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SLwFPFLG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780914603;
	b=mCFEER1SN/fHZE2NK/tZkEDLwzzXZxMgtPLwCbkezz5WL9TNfrjeIib0RfjVR/leaO9Yiv
	DEQwNR2cW2YrOgWc2qruypLC55srRJd1Y0pxkaJFtESvb+NGVQXzfiSbYDAiwycYrySlw/
	h6PxxjX/bnZ3z6PMlklWRUqqrvGdrK8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E1A74098B;
	Mon,  8 Jun 2026 10:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D0B1F00893;
	Mon,  8 Jun 2026 10:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780914602;
	bh=YVTRLRF6w9LEvYfidF9fmm8s09kK9Yw4y/1Wh8KsguI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SLwFPFLGfvmJByC6qhtXWy07PdwLkRy01bjk5t1xV7a4YY3Ce3JmDjIe6x7+DacZx
	 qVRIsiguvng+UA/SBR0YBTy2eZyhGF31dfwl9IXxBSe1V+pPJxONvtaOtA0+NIKpKw
	 JnfDsY/QvlWbSqQvMeyhh28RaJsGqRGDgvGVf2/4tZ5SUIjURsAZMrmfN/14I3O4x8
	 Qeer2Uy4FjfnMf1pIoDKAbjx3bloZJ7FwJrV7mRtFr3DCvIurKXpQF+WE/o00CTcVW
	 pMmF3OBsvhdsh6yvO8UXW6bgb99DDi7BUokHYwxAM6VBqBDdBiFYEc8P0ZGWcLzWkY
	 kG0Jm2ucRXsSA==
Date: Mon, 8 Jun 2026 11:29:48 +0100
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
Subject: Re: [PATCH v10 08/37] mm: add alloc_contig_frozen_pages_user for
 cache-friendly zeroing
Message-ID: <aiaYcZonbHSe5NfO@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <f2036f596f17f66fb55b74a5fd85e8b7ab51876d.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2036f596f17f66fb55b74a5fd85e8b7ab51876d.1780906288.git.mst@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 18BB7140016
X-Stat-Signature: uqd3318x5j8xi85b4ugymb6chd5333sn
X-HE-Tag: 1780914602-198134
X-HE-Meta: U2FsdGVkX1+t13NPZP631vmpjgTIGg7e63mEKd5xraRP6mAAUNHvbKx190XRY+vk4bF5ZmT50YPb9vLkqUS5HKeQyXBTc17pnuomGKoSO/7T1ffZXxnlzA1EwWz9ti2l5JsJ614+hMwLKLQ03HQbRZN1yXY/tYcYMwnKBrv29G4IRX9sOx1nOgC2ns/PVVvTx4aXjyEKCsqaFFRc7ERJ83crT3as5NAo6Xn6ioUS1ZKBeA869B2zb8TeFhp8LaTanfVr2upDSZeYba759KmXyu+jTxT5O/nCrP1k4gHiw3Phz0fY3x7AcuwLD7nrdZWslEbi7/OSwW3fLZ7RcP+6/7fIC/zEmRFxIPBI92AuJUp9Ek04B4VQqsYyHvzC9zynL4MdMIplg/5Pkp5NTF79/UGuf5cJfZyVrNjuLyjVO7y+M7zcs2waeaSiHtBHLKoV7wmGeQr2G59gx4eEdyGYTKrrOWgj5B4QyVua4s3OJwKQgFI+PorsKvqkpdld2AG5B3f0FmL+dk9GZgbt0PuAZAM3Io8R2TLE8N/VqvcqG36IXBIcW2sQ6TJ2WHKus7uDrbEbR/EZqTylqdyeOgsJDyZoWn8QJrUz77CMQ7I6YHU7yp63IHPlKZB3G0c9I0o5tzVYygQkBCfVeP1BOhoZUZklFynCAEs3VX4Z+Hg7xXeZ5etNqGXKPmufd46YwMVXOBx9iBShvzMex00KFFbgHc2ooAHudNetpt/u8w5DC9BVZhSZ2sR/JIG/gt2+06eKHZHBOJLJm6XvFco+DsvyNNJv98dlAJzfpMePY8u5Iy2mRP7kB3TJbqHHxpQI40bbXbE4fx/1bwbd5yDn8gvew6+Ems24Wc9n0TmZesYRgVMPlm8IC4nq1p7zTkwNQeEuZyNAj/OkPKRj4xqFEdcpja4gHFU6cRJ9kXl4L+BQlRCcadmD3TQquHjdGL7XGP+kv8XirmXa1/7rEAuhzZ0
 gsP5iH2P
 oyuQvxj9YzSVUvNpb3dC4Fb6XKHSqDnlwzOfOyCkZnN4qPAB394aEi5muQbna39GvHy0SJ/j1eABxnxz3phIpk3+4QAt+qTWVtkXHdyhBE9y9LPUGrOF6DXS23iFhGjBbUk7ILqM4yn+h9H/OxhnyWaiHQqMdTXr8IXigFhnJwTVMRcr3KBBT/J+Yi7M1g5nSOeRbv9uM/tC3XyVHr/p9DOI9/9UvH4C2XG3DhZGkPQlt4V0g5i5Ps50jJJdcsbSeVCH1sdlMBfs84LloACQ1z3+Pzsy1XcyV7m5DGRw2ElVLWv0zykQlYSSJLloJvsjODsf1+SWdJQOK/QQ2ApqqYkCPKsky9okgzaxz8sv0miuvD1uqZEQEik2oYN6It/QAGt1p5MgH8jrdm+Kr/rlVCCXBEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:35:29AM -0400, Michael S. Tsirkin wrote:
> Add a _user variant of alloc_contig_frozen_pages that accepts a user_addr
> parameter for cache-friendly zeroing of contiguous allocations.
>
> No functional change; all existing callers continue to pass
> USER_ADDR_NONE.

Well, except that you're adding a new function...

>
> Note for reviewers: non-compound contiguous allocations are

Please don't put notes for reviewers in commit messages.

> zeroed via kernel_init_pages, same as before this patch.
> There is no fault address because these allocations are not
> from the page fault path. For compound allocations, user_addr
> reaches post_alloc_hook() which calls folio_zero_user() with
> the dcache flush on cache-aliasing architectures.

Yeah it's exactly this kind of 'just have to know' stuff that makes this
user_addr approach unacceptable.

We mustn't add more cognitive overhead for already confusing code. Now
everybody using these has to figure out what 'user_addr' means and will
inevitably get it wrong.

This whole approach needs to be rethought.

>
> Note about Sashiko (sashiko.dev) false positives: sashiko
> flags two issues here: (1) user_addr silently ignored for
> non-compound allocations, and (2) post_alloc_hook ignores
> user_addr. Both are false positives: (1) non-compound
> contiguous allocations have no fault address to pass, and
> (2) post_alloc_hook does use user_addr when it is not
> USER_ADDR_NONE.

Please don't put AI hallucinations in commit messages.

If you want something to not appear in a commit message, but want reviewers
to see it, put it below the '---' in the patch.


>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

This patch is unacceptable for the same reasons given for 7/37.

> Assisted-by: Claude:claude-opus-4-6
> ---
>  include/linux/gfp.h |  6 ++++++
>  mm/page_alloc.c     | 42 ++++++++++++++++++++++++++++++++----------
>  2 files changed, 38 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index ee35c5367abc..73109d4e31a4 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -453,6 +453,12 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
>  #define alloc_contig_frozen_pages(...) \
>  	alloc_hooks(alloc_contig_frozen_pages_noprof(__VA_ARGS__))
>
> +struct page *alloc_contig_frozen_pages_user_noprof(unsigned long nr_pages,
> +		gfp_t gfp_mask, int nid, nodemask_t *nodemask,
> +		unsigned long user_addr);
> +#define alloc_contig_frozen_pages_user(...) \
> +	alloc_hooks(alloc_contig_frozen_pages_user_noprof(__VA_ARGS__))
> +
>  struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
>  		int nid, nodemask_t *nodemask);
>  #define alloc_contig_pages(...)	\
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 21b52c879751..6d3f284c607d 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6975,13 +6975,15 @@ static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages
>  }
>
>  /**
> - * alloc_contig_frozen_range() -- tries to allocate given range of frozen pages
> + * __alloc_contig_frozen_range() -- tries to allocate given range of frozen pages
>   * @start:	start PFN to allocate
>   * @end:	one-past-the-last PFN to allocate
>   * @alloc_flags:	allocation information
>   * @gfp_mask:	GFP mask. Node/zone/placement hints are ignored; only some
>   *		action and reclaim modifiers are supported. Reclaim modifiers
>   *		control allocation behavior during compaction/migration/reclaim.
> + * @user_addr:	user virtual address for cache-friendly zeroing, or
> + *		USER_ADDR_NONE for kernel allocations.

Yeah, I really do not want us passing USER_ADDR_NONE for kernel allocations
thanks. This is hugely confusing already pretty confusing logic.

>   *
>   * The PFN range does not have to be pageblock aligned. The PFN range must
>   * belong to a single zone.
> @@ -6997,8 +6999,9 @@ static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages
>   *
>   * Return: zero on success or negative error code.
>   */
> -int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
> -		acr_flags_t alloc_flags, gfp_t gfp_mask)
> +static int __alloc_contig_frozen_range(unsigned long start, unsigned long end,
> +		acr_flags_t alloc_flags, gfp_t gfp_mask,
> +		unsigned long user_addr)
>  {
>  	const unsigned int order = ilog2(end - start);
>  	unsigned long outer_start, outer_end;
> @@ -7125,7 +7128,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
>  		struct page *head = pfn_to_page(start);
>
>  		check_new_pages(head, order);
> -		prep_new_page(head, order, gfp_mask, 0, USER_ADDR_NONE);
> +		prep_new_page(head, order, gfp_mask, 0, user_addr);
>  	} else {
>  		ret = -EINVAL;
>  		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
> @@ -7135,6 +7138,13 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
>  	undo_isolate_page_range(start, end);
>  	return ret;
>  }
> +
> +int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
> +		acr_flags_t alloc_flags, gfp_t gfp_mask)
> +{
> +	return __alloc_contig_frozen_range(start, end, alloc_flags, gfp_mask,
> +					   USER_ADDR_NONE);
> +}
>  EXPORT_SYMBOL(alloc_contig_frozen_range_noprof);
>
>  /**
> @@ -7227,14 +7237,16 @@ static bool zone_spans_last_pfn(const struct zone *zone,
>  	return zone_spans_pfn(zone, last_pfn);
>  }
>
> -/**
> - * alloc_contig_frozen_pages() -- tries to find and allocate contiguous range of frozen pages
> +/*
> + * alloc_contig_frozen_pages_user_noprof() -- allocate contiguous frozen pages with user address
>   * @nr_pages:	Number of contiguous pages to allocate
>   * @gfp_mask:	GFP mask. Node/zone/placement hints limit the search; only some
>   *		action and reclaim modifiers are supported. Reclaim modifiers
>   *		control allocation behavior during compaction/migration/reclaim.
>   * @nid:	Target node
>   * @nodemask:	Mask for other possible nodes
> + * @user_addr:	user virtual address for cache-friendly zeroing, or
> + *		USER_ADDR_NONE for kernel allocations.
>   *
>   * This routine is a wrapper around alloc_contig_frozen_range(). It scans over
>   * zones on an applicable zonelist to find a contiguous pfn range which can then
> @@ -7253,8 +7265,9 @@ static bool zone_spans_last_pfn(const struct zone *zone,
>   *
>   * Return: pointer to contiguous frozen pages on success, or NULL if not successful.
>   */
> -struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
> -		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
> +struct page *alloc_contig_frozen_pages_user_noprof(unsigned long nr_pages,
> +		gfp_t gfp_mask, int nid, nodemask_t *nodemask,
> +		unsigned long user_addr)
>  {
>  	unsigned long ret, pfn, flags;
>  	struct zonelist *zonelist;
> @@ -7282,10 +7295,11 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
>  				 * win the race and cause allocation to fail.
>  				 */
>  				spin_unlock_irqrestore(&zone->lock, flags);
> -				ret = alloc_contig_frozen_range_noprof(pfn,
> +				ret = __alloc_contig_frozen_range(pfn,
>  							pfn + nr_pages,
>  							ACR_FLAGS_NONE,
> -							gfp_mask);
> +							gfp_mask,
> +							user_addr);
>  				if (!ret)
>  					return pfn_to_page(pfn);
>  				spin_lock_irqsave(&zone->lock, flags);
> @@ -7307,6 +7321,14 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
>  	}
>  	return NULL;
>  }
> +EXPORT_SYMBOL(alloc_contig_frozen_pages_user_noprof);

Generally we don't add EXPORT_SYMBOL() for new stuff unless
unavoidable. EXPORT_SYMBOL_GPL() is preferred.

> +
> +struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
> +		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
> +{
> +	return alloc_contig_frozen_pages_user_noprof(nr_pages, gfp_mask, nid,
> +						     nodemask, USER_ADDR_NONE);
> +}
>  EXPORT_SYMBOL(alloc_contig_frozen_pages_noprof);
>
>  /**
> --
> MST
>

Thanks, Lorenzo

