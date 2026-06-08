Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74D7ACD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:23:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B646A6B009B; Mon,  8 Jun 2026 07:23:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3C2E6B009D; Mon,  8 Jun 2026 07:23:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A78D46B009E; Mon,  8 Jun 2026 07:23:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93C7E6B009B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:23:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53ACAA0AD1
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:23:23 +0000 (UTC)
X-FDA: 84856509486.07.CE01B10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B87B61C000D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:23:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W2pvxdEn;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780917801;
	b=LHMrLyy6NAC8i4XyfczRkUgoVE/GZ+opkTEznn1Uh0Hdmoi07JTjX1XMYU7P4MTjR0saOs
	IE5cC+QmotJKB+bQcxWnj3P2LyctYbumnI1yFzo3OkoZhsq93spB0Ej9hWyJwby1hx7oJB
	GL31jG6eRvo7KM6ZEfPvEczJQhHABus=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W2pvxdEn;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780917801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x0WNa35PkAieRM1DUOHaPgcwBJSjLyea6ACWB1AdAx4=;
	b=PEr9HPSAORYk/Nk4Y+3PQUn6uq+YYF5MpmHYWaLOOU9TY9NNtpIo8lUa3zPN2Tq3ElE3tf
	1bfWG/+34Yqw7NjiLEhth0YShSnQneDCGTqTJnT6Pitrtfp8+4kJlRBDZpr2RWh90j9U7W
	aaGQ6RWYVwB1ph8NowswG97kTh65Ksc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 17B9F601D8;
	Mon,  8 Jun 2026 11:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B449F1F00893;
	Mon,  8 Jun 2026 11:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780917800;
	bh=x0WNa35PkAieRM1DUOHaPgcwBJSjLyea6ACWB1AdAx4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W2pvxdEnX5tI57Wohq0lKd2Bw0KQ/2lc2odLZ/D/PYfXgh9m5G3s/Mscjj0hosH9e
	 RYC9mqk9BNr6zEVfKN0sfTzY8ga3xOC/AiYTGAwIaRpBkRwwF/PThgg3VY/Rri4cg5
	 sDGk1ZMjuff+r0bzM878C37tGMb2iXYZ1lOrstFCgl3irbEcdIDFmb9t47/3aZOU9Q
	 aLfqBPSeYhYJVW/luvcXJY8envTbvUqJL8s7O7UuZgbGa9ANcTsXzGwiZRlXK1rRlE
	 kJcAkTiZ7EavrBx5xJze1DCBl0gtOwzEH1kWPBO6ULUUFKmHEpMRpeiuD32SApOhW7
	 YndNpalrnPANw==
Date: Mon, 8 Jun 2026 12:23:07 +0100
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
Subject: Re: [PATCH v10 12/37] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <aiacZ6_7SG3nvVjM@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <f92f6f06e5804b4ea7f68b8664b7e69953b50f4e.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f92f6f06e5804b4ea7f68b8664b7e69953b50f4e.1780906288.git.mst@redhat.com>
X-Rspamd-Queue-Id: B87B61C000D
X-Stat-Signature: sdmm336ahwi1a6nerp73b8sbawmit9tz
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780917801-770274
X-HE-Meta: U2FsdGVkX1/Vr6z/8RsqMhBp4TQMrsfM/Wwo8HImHbAPqL3ykfErnG2iuNepvBTqnXeWJneo9u7bK+P18QtSjZwjhfrYvA+nS0IqTjEJLNC+39u5K68jUAH+PIeSB1jYXtNhqRc7fXYolh+24Wei0iO9U2Oj9NFgEqCVj1hB1kmUepOHLGOFydQKVjCelSZpoCfnPIla0PHnDO4eHJojiPyiM8osZ3f7JoF0iEtzyNrjouCG27jl/V5RQ3w2tJMeieyFtHMTnW2FXCLldn8YTql1d8zhG5MVeprvwEQRguqVatN2QQBHQXk8JFWzDJSUP6EH+bzN0TwpGz7o2b0toyoDU9r9sWWCC5Sq55koiUl3m2FUDULVGtrnkJMcwCUIcaidYsfs7dJQyukgcLCufeCn7bW6pK3QYlaVV7/UjWd8E7z9vKvQXN5M91fpFbKEmrQwNyt21S4+hZ+ThzO/XE8nsrFV0ZRwJNollDA/yOVehBOeRLmy3kEJB+uBT0fIZbn/nBpjhFH4UUEMPo+fwcDrtMwCdcsFXJIPOY84wRhSeKCyQnHWOqnhw3UASXyKJLZtqMf+zVU2rPXAe0WYba7zE7hDan2v75cY5ilC7fmfGnUwYhOZT58OP32UfXDU0opSJpLaPhnfIuHYKsgrn5kjxn01glrtcid983rGvncfc0ptGj+eC9LYhVGdW+zVoDuTVLdJAGPvL1BDLyoK5m28xxlDhABMhW/9yR9VPcfz4WiHTyEUngdqT6WVZDZznwzatH+WBFhoorLGqt9rXR0z0ehZ41JlGILMas17Yk54L2U3d9In7lkkPKqsgUuc2R0Ahmb7fZlZAOUjxCDPoWYc2V066TEyH8+EbO7QPLcPK94YLLr4sXwMnLxmIO5MCnQ3li+ylC2jzCjYC/uYRW+l5PYo/7WKHH7KaaTT63h2M/askj/IQ9SXLSSKgIRpQzw2d28K/lRaamjxDgZ
 za0JmLvG
 PeyWeQ00frawm0yQFMTESTrl3rWhFwbBKyyg1C4qrjGAfe8yyIfCxKlQUigBN/UAHgW5kNqhpdupGTsENBrw0Aav43KbKS5JM0uLaLNOgNhpcq/a2hT18aJZYZ02WNKlN27maggj9ukK+1zCtDU5ux0LL5pEXVv1pHrp5B5GYMBUszzsFpLDswufZI9kXR3aY2pvu6zEb6BTLliMdd5R6vGDEfeOgFwS+dIyWDInO42R/uv0sSnE9aAuh4spR37Io/fEEQaDYEKmqxnxWncAHanblJI7OR0FSPeuTJ0LTvbaT1eUjfXL2OGbUx6Q4EUxs9ewiOupEoQsQAZF98TgsMccSNbn3pKhU5CQaF3PWZZAbLlrfHf/UVQCz12A8MFwfPV/bD8D6CUe0qpltW7ygXbo4JfeQoxOzhLd/SmhhdHOvzOgtgvEHt9mzTocVTx5Cuxj4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:36:38AM -0400, Michael S. Tsirkin wrote:
> When post_alloc_hook() needs to zero a page for an explicit
> __GFP_ZERO allocation for a user page (user_addr is set), use folio_zero_user()
> instead of kernel_init_pages().  This zeros near the faulting
> address last, keeping those cachelines hot for the impending
> user access.
>
> folio_zero_user() is only used for explicit __GFP_ZERO, not for
> init_on_alloc.  On architectures with virtually-indexed caches
> (e.g., ARM), clear_user_highpage() performs per-line cache
> operations; using it for init_on_alloc would add overhead that
> kernel_init_pages() avoids (the page fault path flushes the
> cache at PTE installation time regardless).
>
> No functional change yet: current callers do not pass __GFP_ZERO
> for user pages (they zero at the callsite instead).  Subsequent
> patches will convert them.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> ---
>  mm/page_alloc.c | 35 ++++++++++++++++++++++++++++++++---
>  1 file changed, 32 insertions(+), 3 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 4676fd49819e..d4fbf1861a8a 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1861,9 +1861,38 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
>  		for (i = 0; i != 1 << order; ++i)
>  			page_kasan_tag_reset(page + i);
>  	}
> -	/* If memory is still not initialized, initialize it now. */
> -	if (init)
> -		kernel_init_pages(page, 1 << order);
> +	/*
> +	 * On architectures with cache aliasing, pages zeroed via the
> +	 * kernel direct map (e.g. init_on_free) must be re-zeroed
> +	 * through a user-congruent mapping.  Host-zeroed pages
> +	 * (zeroed flag) don't need this: physical RAM is clean.
> +	 */
> +	if (!init && (gfp_flags & __GFP_ZERO) &&
> +	    user_addr != USER_ADDR_NONE &&
> +	    user_alloc_needs_zeroing())

We check this (gfp_flags & __GFP_ZERO) && user_addr != USER_ADDR_NONE thing
twice, can we just put in a 'init_should_folio_zero' const bool or something?

> +		init = true;

As Vlasta says not sure if we want to add complexity just for these arches.

> +	/*
> +	 * If memory is still not initialized, initialize it now.

I kinda hate that 'init' is unclear as to 'do init' or 'was init somewhere
else'... Anwyay.

> +	 * When __GFP_ZERO was explicitly requested and user_addr is set,
> +	 * use folio_zero_user() which zeros near the faulting address
> +	 * last, keeping those cachelines hot.  For init_on_alloc, use
> +	 * kernel_init_pages() to avoid unnecessary cache flush overhead
> +	 * on architectures with virtually-indexed caches.

This whole paragraph seems pretty useless and just describing the code?

> +	 */
> +	if (init) {
> +		if ((gfp_flags & __GFP_ZERO) && user_addr != USER_ADDR_NONE) {
> +			/*
> +			 * folio_zero_user relies on folio_nr_pages which
> +			 * requires __GFP_COMP for order > 0.  All user folio
> +			 * allocations set __GFP_COMP via __folio_alloc.

This whole paragraph is useless and very like the kind of stuff AI generates for
comments, i.e. overly long + entirely unnecessary stuff.

> +			 * user_addr != USER_ADDR_NONE implies sleepable
> +			 * context (user page fault).

Can you safely assume that? Also inferring which context we are in from this
parameter seems risky.

It seems to me that you're now making it such that kernel developers:

- Have to know when and when not to specify a user address, and under what
  circumstances we might consider that to be mapped.

- Need to know to do this correctly for aliasing architectures or have silent
  correctness issues.

- Need to take context into account when specifying this.

We definitely need to find a simpler way to do this!

> +			 */
> +			VM_WARN_ON_ONCE(order && !(gfp_flags & __GFP_COMP));

Surely by now we can assume this?

> +			folio_zero_user(page_folio(page), user_addr);
> +		} else
> +			kernel_init_pages(page, 1 << order);

I hate this hanging else branch... definitely prefer {} on both branches.

But in any case it seems like we could avoid some indentation with something
like:

	if (init && init_should_folio_zero) {
		...
	} else if (init) {
		...
	}

Or even a:

	if (!init)
		goto out;

And stick an out label below?

> +	}

>
>  	set_page_owner(page, order, gfp_flags);
>  	page_table_check_alloc(page, order);
> --
> MST
>

Oh and in general it seems that this conflicts with [0] which removes
kernel_init_pages().

[0];https://lore.kernel.org/all/20260422102729.166599-1-hsalunke@amd.com/

Thanks, Lorenzo

