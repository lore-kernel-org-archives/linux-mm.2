Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AB7CC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E570D6B009B; Thu, 10 Sep 2026 10:16:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08006B009D; Thu, 10 Sep 2026 10:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1DEC6B009E; Thu, 10 Sep 2026 10:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE8E76B009B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:16:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B99F4A056C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:16:54 +0000 (UTC)
X-FDA: 85198053948.29.B4BEB51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 00A6F140004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:16:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dKkmADC8;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789049813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pKr5hPbNleVMkg76w58XMKUslPR6fzuboqwZkz3wepg=;
	b=RdfU6E0WErAb9Hon5x79jYJu1c5bep5ayMYdY0h+B8c7ZKFVgTP35OUUlp1ha8/ZNpEALv
	WYCHUywzKKYBEcB2WJ7drWhLwB6ZgBf01z9QdxFM4Au8T3YD/TxCzZzi7EAgMmhJHhZAxu
	LpT8QURCIc/+gqGMze4dUbEPnftoK+0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789049813;
	b=PKKLQxmdkcx0KVJLZg5WZJFV/kwcGCQvjM/rT8VfWRRAsmgqrCIhijI57WWvr+rK6aEzSF
	R18iA4C1gQCzMmZJ3uCQcJG1lf1ziL7+bZxRwpyu9BGEJPsuz6tq66dkTWSswBHh2RVwUJ
	UTNcSZv30hbbd227lJnhHgsVfNmILbY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dKkmADC8;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 85441601F1;
	Thu, 10 Sep 2026 14:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AFB1F000FF;
	Thu, 10 Sep 2026 14:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049812;
	bh=pKr5hPbNleVMkg76w58XMKUslPR6fzuboqwZkz3wepg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dKkmADC8CQOFHY6kWVFLhHmN/5gQRiSVsLiZPB0L8TvjATCyW+1Cb7C8Vy+kFGQcL
	 ruGR6HIbcw9pVnmhxY6/ubSwRuttRWtFi+0CQhHxpNcO7wlTNdnxdRXx5jCqDri41c
	 oduNfZfQDoEE9TXpXwEL78gORwyRdpVrQV9P9seIFBVR8WixbOya2rUNsvN4oGa3cj
	 G8FMuuDvWgv4ByjBxH2LX0KUHaKdt7uXUfdHWLGiEPJXYIPTAXjwujhpEq86th9s9c
	 XmCDVX70y+bfM4ZVfe6J/gglXWlFDI6WZ/z4sLsTYKcZRNuco/NOcuVL3G+T+KYPKI
	 gDhqAkWNhXCvQ==
Date: Thu, 10 Sep 2026 15:16:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 08/12] mm/sparse: move __highest_used_section_nr handling
Message-ID: <aqK2_RpAlMbVYcuN@gremlin>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-8-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-8-008fc8d579fe@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 49nt99scw79xeogne7zpygjr36q6bzry
X-Rspamd-Queue-Id: 00A6F140004
X-HE-Tag: 1789049812-499005
X-HE-Meta: U2FsdGVkX18ZePuDURnysZUljf8YPMdz5gqXhPNNWpwrsrXbo9ulCB7bR8MsNcqUUPiEhxkY7F9xFpS3q8oCvRDMqIeGCbzlq9uRUeHWoEhmKLjv6PMAB9mM2jFtvVXvSa9X97wRGvIFNUaqCGbz0l47k27DySi5IVrTDHS7z1uz8eM1APLRMYldINGvptpaibqEOLBB1ZoVHmhK5OU8WiJMT0weNjacN+oLr0BY5lZ0yK9Ck3kGp9EpBxRLBg1SGD+D+OTVpSppLXu3G3WE2ykJsFQBuNHQjXs786DIIlIGiVH4OlGIXI3t6/kMX1WLv0Vv5n4pl1ly2ZJTrog854yH59EFdBwbBmPWG5K65seTMAi/VHxhgPl7FMjpXR7YL9gqBam54ZCnr99dtlDINqmYbpglUc3Z95eGZnCJARl9YBJgdysiq3beqOjBVHXXSt14T4Ji9/lhaKsAncRyV9PASx0/8DyoHk4fcv9ZQTLv8zUAyXhaJPo7LwwKNPXgAfrO/W41umpPXZ+ct8JdQLZW/DQuXcm3trmfDfBbd5gKTnwLI7Lu2YOaTxLjRSHCBfE9IJlrmePA19BFz7QdYsgQNJRNSCH305pwyWOSJw+/WV9t99SOmuVBpA6siyHGe+sUwU3d4VuZpN4PgGArP3Z90WnK533dajU8Mh4UXHYXn5imoMTQRg9m0p+C6RCzhb6pcn91ykiVsN6KcZcHLL/nXjAcuZwTlewlZQzOJXjjDcdiR/7MhWyPiWf7BQaGSWyMN4YDE4vrrI0907ReByFV0doOr/Cs99JDlDCD43U8//OJ21tMfn0laqzco/VgJBYms814hgmKauUwQM2TUG7ejiASZwyrls4NtG7h2VpiyT8sq+5NxsxRgRAODiEo8D2G5LHvz59DelUdXUGo6AfqvVJJcp8uurjVkkZ9CqhFg105L0gIjG5WHFT7NEawZbmqXq/Wa/Fcve+2Nzg
 aCmXWPkF
 7h/n3qTxxNM7oty4iPmRx54El2SjyyXTBR5HBfSPSNItxoCks0YgCN+oVkOM3P15pwlhKjqrM0PG4gH0vHLVdK/Lrf4aeekRh0TNsPNno/SMAd1CHSMtEDOrGPTlUl2f6fH7vi7PjiLnFAAFDdJrsSju2WUVMAWzMIfWCDrymfM7yOdM812bRO7TX7OAk8cRLtXWgGGW0Bcg7UJ+XcxXNbvCVysnix8dVpSpTcV+kZ2lYbVI206KdLu0fB/+XxyLpjKk4v5+ta86evlXZ2JB1CPubt2X3wq/a9bsnbAtLyxa8NLRoM6dQ6D3608T6XVbJ2OKW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:33:01PM +0200, David Hildenbrand (Arm) wrote:
> Let's move it to sparse_init_one_section(). However, to keep early
> boot processing working, we also have to initialize it in
> sparse_sections_init().

A why might be nice :)

I guess preparing for removal of __section_mark_present()?

Also good to have arguments as to why this is equivalent of previous
behaviour.

E.g. higher pfn = higher section nr so naturally the highest is the one you
end up wtih at the end of sparse_sections_init()?

>
> Should we use READ_ONCE/WRITE_ONCE with __highest_used_section_nr?
> Probably, something for another day.

It might be worth expanding this a bit. Do multiple threads read/write this
concurrently?

No functional change intended here or is one intended? :)

Before it was:

mm_core_init_early() -> sparse_sections_init() -> __section_mark_present()
                          sparse_add_section() -> __section_mark_present()

Now:

                                                 mm_core_init_early() -> sparse_sections_init() [early]
                                                 sparse_add_section() -> sparse_init_one_section()

But also called from mm_core_init_early():

sparse_init() -> sparse_metadata_init() -> sparse_metadata_init_nid() -> sparse_init_one_section()

Are both required?

Might be worth digging into why a bit here.


>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/sparse.c | 5 +++--
>  mm/sparse.h | 6 +++---
>  2 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 2b41ae36f20b8..2d0f2db34f4cf 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -177,7 +177,7 @@ static inline unsigned long first_present_section_nr(void)
>
>  void __init sparse_sections_init(void)
>  {
> -	unsigned long pfn, start_pfn, end_pfn;
> +	unsigned long pfn, start_pfn, end_pfn, section_nr;
>  	int i, nid;
>
>  	sparse_extreme_init();
> @@ -187,9 +187,9 @@ void __init sparse_sections_init(void)
>  		mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
>
>  		for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
> -			unsigned long section_nr = pfn_to_section_nr(pfn);
>  			struct mem_section *ms;
>
> +			section_nr = pfn_to_section_nr(pfn);
>  			sparse_index_init(section_nr, nid);
>  			ms = __nr_to_section(section_nr);
>  			if (ms->section_mem_map)
> @@ -201,6 +201,7 @@ void __init sparse_sections_init(void)
>  			__section_mark_present(ms, section_nr);
>  		}
>  	}
> +	__highest_used_section_nr = section_nr;
>  }
>
>  #ifndef CONFIG_SPARSEMEM_VMEMMAP
> diff --git a/mm/sparse.h b/mm/sparse.h
> index 7c5d82ceb7142..a3af4967fd5c5 100644
> --- a/mm/sparse.h
> +++ b/mm/sparse.h
> @@ -97,6 +97,9 @@ static inline void sparse_init_one_section(struct mem_section *ms,
>
>  	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
>
> +	if (section_nr > __highest_used_section_nr)
> +		__highest_used_section_nr = section_nr;
> +

Could also be:

	section_nr = max(section_nr, __highest_used_section_nr);

But not a big deal.


>  	/*
>  	 * We encode the start PFN of the section into the mem_map such that
>  	 * page_to_pfn() on !CONFIG_SPARSEMEM_VMEMMAP can simply subtract it
> @@ -114,9 +117,6 @@ static inline void sparse_init_one_section(struct mem_section *ms,
>  static inline void __section_mark_present(struct mem_section *ms,
>  		unsigned long section_nr)
>  {
> -	if (section_nr > __highest_used_section_nr)
> -		__highest_used_section_nr = section_nr;
> -
>  	ms->section_mem_map |= SECTION_MARKED_PRESENT;
>  }
>
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

