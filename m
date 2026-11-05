Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3963606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PxKs95JJ
Received: by kanga.kvack.org (Postfix)
	id 164906B05B7; Thu,  5 Nov 2026 08:03:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 135096B05B8; Thu,  5 Nov 2026 08:03:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0240B6B05B9; Thu,  5 Nov 2026 08:03:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D30576B05B7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:03:42 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B2E2D1A0A1C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:03:41 +0000 (UTC)
X-FDA: 85401082242.19.07D0726
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0C497C000E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:03:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PxKs95JJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793883820;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pn7Qbt08QHu+Q6saVf1pqiMAlX4y5iUMBgnEvqUGMbY=;
	b=SNQ9C+Uqw2JMqD6MHNT7ZBN8pvpVpExBIS++/1r4D6Pga9xbDHj4pKHrFfw/PBrND2D23e
	cA6f28n3XCUImiyVdn1lnTFufKHWyzJ1ruA5sUU5B7B/vOP2ThcoA1rdquv5gQSZ5HXgz6
	gos8yXcUpiN0l6L7pkD9PkkmikNieLU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PxKs95JJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793883820;
	b=1xNZK06e2KWmb7UFV8Mh9rm+5NMCW7gdtmu6ojYOdcg8Rts18tqDW5dCc8vMWlXikIvbxF
	VVKREeqNQ3Weo8sTU76h82qdRAZTb4J3F/uOyC05SmHvZr5v4BpD1euWPpKkLQ0a6VyE0V
	GTABfGZ+x5h1aa0TpaJ30oau75/by2A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 58E96436D9;
	Thu,  5 Nov 2026 13:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DFD1F000C1;
	Thu,  5 Nov 2026 13:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793883819;
	bh=Pn7Qbt08QHu+Q6saVf1pqiMAlX4y5iUMBgnEvqUGMbY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PxKs95JJDngfnJ96nmkvKiWZBvC0+9ebbZdQ/HGYdye4nbhyHveSp9SDzkGyd1GM7
	 wvv7JNNottj63JL/XFUkP2cmC631xDTB+WtV6mGab/NmDy+15R/qp/yuTxscmQ4GkT
	 AGCX3GPVYNbbXPqsBFYxbdg+TyITosGkaF6Juw5Ty4yBXcAfx69hy+j2bJpLAhBP4I
	 Ja8OU8nmcsbU6ehrWXMnujpktL235W4RvuThs1UUjsgmPjZVOUrxwQ9BNEgw0WCNVd
	 Ju8BkfsjZjD3uZcb2Uu2zcXWJqfW3aA7K1CIoQs0xx4835957QzWY8u2D2bJ9HeCfY
	 zU6WAL4xApSJw==
Message-ID: <sashiko-outbox-199100@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 07/18] mm: free the pages waiting for a grace
 period before isolation fails
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?S2lyeWwgU2h1dHNlbWF1IChNZXRhKQ==?= <kas@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Linus Torvalds" <torvalds@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Jan Kara" <jack@suse.cz>, "Hugh
 Dickins" <hughd@google.com>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Harry Yoo" <harry@kernel.org>
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, "Miaohe Lin" <linmiaohe@huawei.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Oscar Salvador" <osalvador@suse.de>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kairui Song" <kasong@tencent.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Paul
 E. McKenney" <paulmck@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>, "Luis
 Chamberlain" <mcgrof@kernel.org>, "Ilya Gladyshev" <ilya.gladyshev@linux.dev>, "Jaegeuk
 Kim" <jaegeuk@kernel.org>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261104130118.2507513-8-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
 <20261104130118.2507513-8-kas@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 13:03:37 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0C497C000E
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	T_PDS_OTHER_BAD_TLD autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: e1cxcx1gm6kkasi45ec43snkabzga7gr
X-HE-Tag: 1793883819-983116
X-HE-Meta: U2FsdGVkX1+u8SrZXT8VcnYcPllT75fWKj7FCmVQv2O5WeaOk9qZ1L4hHtuWxUWT9fryh1kR/u0Ac2cp2sq1RxZdRKyHMOJqsI9LAimUipZHko76w38b5IlbEAMeJ8Qx5ZDWUF50MA8WRjNZl5kHnJ7oTjx1PzqQPbNh1eP1QyjGnMbx9OmENTa8syvrBMr2g2F+4jd7kAWB1/kdLHOVenXxnxRaa9yuVW2oLhD3YeB7BVPuXgnpADbv8jlFc+s8FEmF+kc+32jxN9AkSXI1bo4OedfDQm5pdNMPBP9ZY5GZIxZ2Gq1NLp/g4VU8YUAU7MOc03JOU2gGftYFNyZPSkWVOgi407Fsbil+oYRi3rJL5Cu0P2XN1k4d0HxqAzwTIS9e+RVVJXMoQ623HIZGJ456EGQ66L1IU61zTT+4xS7CTHtQ+Q4C4c3eMBhBFyYsVLH+F/A7VkiWzw9Qtbli8CLa/IYxC5DXfvGIIM9PqJ2K1QC0rHpS7aluyXe1vK7XYVzuXiEcDnIvrjnep61FMQHo1K9+Lbtleq1uz9Fg1B1YJotPpU3vKUcWVa168LMzUDEsPpbDrrHXu98o2DrWBSSqdnPnF1uLoSfFiWEOFuqjhPNV/gZCllhanfPdbl/8G/NYO5TxvgsKEdxhEf4DoL3NL6xjZ9ursYarVviY7C/sgnq7wOlpjNKKlMbZaFWpGlAJ+kyRFOxyyWG6MAWVOn8WoYMY+Ubb0I6yHwr8NWDsiCQMLKUN6ys1uUC9t9ZMNsDWkzGae5naz2N2YaLFIiuzxUrHhk3liPmUhnloW+YVcR4imURz6r/FB9JMcEE+KSz1WQeyyi1Hpp3TI+qjMBC/yWKymy6mC9U/tMuJiRvZELEkGLATMmTwLYiDqzkcRSQ+rmpFfnYeUqqTax1CJDfEIvXr45eI3DpRwl3wVDMbCazzMWEZfKIUOePMNMXPPgqwS7kLfSpgadATOsk
 G+kSHlDp
 MBiCO0m7G3RjZUK0mV5P2qCFATnV6tIyPA/YwgY7jGoGlq44Xg2NTsRIKxapsvZGZd8w0zbpAIbClSnnGPF10GYHteKSoWKpkUY8F0IjCscv/02y5E+nQLUjL6B/HWMK3LXfxI+a6yykqsEfHHzcdXwFzibE69aKHSGf/hahHs+d3brzCx3g5cnEbS/C44pOfxl2eEQliLhN9shG/ZolataHICFFphrTElcb7N8s7eLXOovmsGPEx8gD9cePIYvJFLe3/ozG/6UEA9d7zfzdyzRlJrd5Sq+GxUVLLCx6c6yifjXnYuQGRfvYLEZHQS//6VHvUtYkJ7fbx3X8QVWADtqw0MEVyrdolji/SlW4bot8ajmE0oEUhZ0n3/aZv8IsXotBpDEunh1rVbMPMNFBfmiWSbv28VlcOjP4v4nvCPUAymyfPrLDFuDITvO6IyYmRyyYuVlJdRBcZvdMvJqD43xRbOjomLFpvWEavdXZnvQwjdopQiPGOF64bQEPZKYTsD+iHdRlwc26BG6R9moIPSJOzHAVCNDXXRrJ44O5e/spabCkchzKI7WjD6cai1IMCyQEdo0bMDe7BrxWa+/lGNsVzDAA6oaRCuduA2c/VP0uvyIgPTXBhco5QPQlLUTelzJVCLanlNIxRWp1AvoHbKJJPygsu2Xl60er8u61qGRgvCNzj+aGT41fMinDns8YZGqhN6MQ/gxfr0h8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] mm: premature NR_FREE_RCU_PAGES decrement in rcu_free_pages() sk=
ips sync
- [Medium] mm: stale outer_start in alloc_contig_frozen_range_noprof() afte=
r RCU free merge
- [Medium] mm: page_is_unmovable() treats freed compound PG_rcu_free folios=
 as unmovable
--

commit 01209427ff9390747e1e7bf6dbe80b5fa2e38b2b
Author: Kiryl Shutsemau (Meta) <kas@kernel.org>

mm: free the pages waiting for a grace period before isolation fails

This commit adds rcu_free_sync() and zone_rcu_free_waiting() so that
alloc_contig_frozen_range_noprof() and offline_pages() can drain and flush
folios waiting for an RCU grace period when test_pages_isolated() fails.

> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 226ab9cb078ad..c23fab6529571 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1967,6 +1967,7 @@ int offline_pages(unsigned long start_pfn, unsigned=
 long nr_pages,
>  		.nid =3D NUMA_NO_NODE,
>  	};
>  	unsigned long flags;
> +	bool migrated;
>  	char *reason;
>  	int ret;
>  	unsigned long normal_pages =3D 0;
> @@ -2050,6 +2051,7 @@ int offline_pages(unsigned long start_pfn, unsigned=
 long nr_pages,
> =20
>  	do {
>  		pfn =3D start_pfn;
> +		migrated =3D false;
>  		do {
>  			/*
>  			 * Historically we always checked for any signal and
> @@ -2071,6 +2073,7 @@ int offline_pages(unsigned long start_pfn, unsigned=
 long nr_pages,
>  				 * out
>  				 */
>  				do_migrate_range(pfn, end_pfn);
> +				migrated =3D true;
>  			}
>  		} while (!ret);
> =20
> @@ -2092,6 +2095,9 @@ int offline_pages(unsigned long start_pfn, unsigned=
 long nr_pages,
> =20
>  		ret =3D test_pages_isolated(start_pfn, end_pfn,
>  					  PB_ISOLATE_MODE_MEM_OFFLINE);
> +		/* What this pass migrated can wait for a grace period */
> +		if (ret && migrated && zone_rcu_free_waiting(zone))
> +			rcu_free_sync();
> =20
>  	} while (ret);
> =20

[Severity: Medium]
What happens if a large compound folio with PG_rcu_free was already freed
before offline_pages() or alloc_contig_frozen_range_noprof() calls
start_isolate_page_range()?

When __free_pages_prepare() intercepts a folio with PG_rcu_free and defers
it via rcu_free_defer(), the folio has a reference count of zero and
PageLRU cleared, while PageCompound remains set until rcu_free_pages()
later completes the free:

mm/page_alloc.c:__free_pages_prepare() {
    ...
	if (unlikely(folio_test_rcu_free(folio)) &&
	    !(PageHWPoison(page) && !order)) {
		VM_WARN_ON_ONCE(fpi_flags & FPI_NOLOCK);
		__folio_clear_rcu_free(folio);
		count_vm_events(PGFREE_RCU, 1 << order);
		rcu_free_defer(folio);
		return false;
	}
    ...
}

Before reaching test_pages_isolated() and rcu_free_sync(), both
offline_pages() and alloc_contig_frozen_range_noprof() (as well as
alloc_contig_frozen_pages() via pfn_range_valid_contig()) check for
unmovable pages through:

  start_isolate_page_range()
    -> set_migratetype_isolate()
      -> has_unmovable_pages()
        -> page_is_unmovable()

In page_is_unmovable() (outside ZONE_MOVABLE), order-0 pages with a zero
reference count fall through to the !page_ref_count(page) check and are
treated as movable, but compound pages are checked first and rejected when
!PageLRU(page) without checking !folio_ref_count(folio):

mm/page_isolation.c:page_is_unmovable() {
    ...
	if (PageCompound(page)) {
		struct folio *folio =3D page_folio(page);
		...
		if (folio_test_hugetlb(folio)) {
			...
		} else if (!PageLRU(page)) {
			return true;
		}
    ...
}

Won't start_isolate_page_range() or pfn_range_valid_contig() treat a freed
compound folio waiting for an RCU grace period as unmovable and fail with
-EBUSY before rcu_free_sync() is ever reached?

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 9caaa57bf51d7..eea287ab2a011 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1479,6 +1479,19 @@ static void rcu_free_drain(void)
>  	mutex_unlock(&lock);
>  }
> =20
> +/* Free every waiting folio, including those a work took off the lists */
> +void rcu_free_sync(void)
> +{
> +	int cpu;
> +
> +	if (!IS_ENABLED(CONFIG_PAGE_RCU_FREE))
> +		return;
> +
> +	rcu_free_drain();
> +	for_each_possible_cpu(cpu)
> +		flush_work(&per_cpu_ptr(&rcu_free_pcpu, cpu)->rwork.work);
> +}
> +
>  static void __init rcu_free_init(void)
>  {
>  	int cpu;
> @@ -7649,7 +7662,16 @@ int alloc_contig_frozen_range_noprof(unsigned long=
 start, unsigned long end,
>  	outer_start =3D find_large_buddy(start);
> =20
>  	/* Make sure the range is really isolated. */
> -	if (test_pages_isolated(outer_start, end, mode)) {
> +	ret =3D test_pages_isolated(outer_start, end, mode);
> +	if (ret && zone_rcu_free_waiting(cc.zone)) {
> +		rcu_free_sync();
> +
> +		/* A freed folio can merge with a free buddy below start */
> +		outer_start =3D find_large_buddy(start);
> +		ret =3D test_pages_isolated(outer_start, end, mode);
> +	}
> +
> +	if (ret) {
>  		ret =3D -EBUSY;
>  		goto done;
>  	}

[Severity: Medium]
Can outer_start in alloc_contig_frozen_range_noprof() still become stale if
a background RCU free completes and merges across start or outer_start?

First, suppose a migrated folio at start had PG_rcu_free and a free buddy
exists immediately below start in the same isolated pageblock. When the
initial find_large_buddy(start) runs, the folio at start is not yet freed,
so find_large_buddy(start) returns start:

mm/page_alloc.c:find_large_buddy() {
    ...
	if (pfn + (1 << buddy_order(page)) > start_pfn)
		return pfn;

	/* Nothing found */
	return start_pfn;
}

If rcu_free_workfn() or rcu_free_expedite_workfn() on another CPU finishes
freeing that folio before zone_rcu_free_waiting(cc.zone) is checked,
__free_one_page() merges the folio with the preceding buddy below start,
clearing PageBuddy on start. Then test_pages_isolated(outer_start, end,
mode) fails because outer_start (still equal to start) is now a tail of the
merged buddy, and zone_rcu_free_waiting(cc.zone) returns false because
NR_FREE_RCU_PAGES was already decremented to 0, so outer_start is never
recomputed and alloc_contig_frozen_range_noprof() returns -EBUSY.

Second, suppose all pages in [start, end) are already free in the buddy
allocator when the initial find_large_buddy(start) and
test_pages_isolated(outer_start, end, mode) run, so test_pages_isolated()
returns 0 and rcu_free_sync() is not called. If a folio below outer_start
within the same isolated pageblock was waiting for an RCU grace period and
is freed by rcu_free_workfn() before isolate_freepages_range(&cc,
outer_start, end) runs:

mm/page_alloc.c:alloc_contig_frozen_range_noprof() {
    ...
	/* Grab isolated pages from freelists. */
	outer_end =3D isolate_freepages_range(&cc, outer_start, end);
	if (!outer_end) {
		ret =3D -EBUSY;
		goto done;
	}
    ...
}

__free_one_page() can merge that newly freed folio with the buddy at
outer_start, moving the buddy head to a lower PFN and causing
isolate_freepages_range() to fail with -EBUSY.

> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> index b9259deddb59d..764e3f43b3b98 100644
> --- a/mm/page_alloc.h
> +++ b/mm/page_alloc.h
> @@ -235,6 +235,14 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, =
unsigned int order, int nid,
>  	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
>  void free_frozen_pages(struct page *page, unsigned int order);
>  void free_unref_folios(struct folio_batch *fbatch);
> +void rcu_free_sync(void);
> +
> +/* Whether @zone has pages waiting for a grace period */
> +static inline bool zone_rcu_free_waiting(struct zone *zone)
> +{
> +	return IS_ENABLED(CONFIG_PAGE_RCU_FREE) &&
> +	       zone_page_state_snapshot(zone, NR_FREE_RCU_PAGES);
> +}

[Severity: Medium]
As reported by Sashiko on RFC [1], doesn't gating rcu_free_sync() on
zone_rcu_free_waiting() miss folios that are actively being freed inside
rcu_free_pages() after NR_FREE_RCU_PAGES has already been decremented?

In rcu_free_pages(), NR_FREE_RCU_PAGES is decremented for each folio before
__free_pages_ok() or free_unref_folios(&fbatch) prepares the pages and
returns them to the buddy freelists under zone->lock:

mm/page_alloc.c:rcu_free_pages() {
    ...
	list_for_each_entry_safe(folio, next, list, lru) {
		nr +=3D folio_nr_pages(folio);
		mod_zone_page_state(folio_zone(folio), NR_FREE_RCU_PAGES,
				    -folio_nr_pages(folio));
		if (direct) {
			__free_pages_ok(&folio->page, folio_order(folio),
					FPI_NONE);
			cond_resched();
		} else if (!folio_batch_add(&fbatch, folio)) {
			free_unref_folios(&fbatch);
			cond_resched_tasks_rcu_qs();
		}
	}
	if (folio_batch_count(&fbatch))
		free_unref_folios(&fbatch);
    ...
}

When rcu_free_workfn(), rcu_free_expedite_workfn(), or a concurrent
rcu_free_drain() decrements NR_FREE_RCU_PAGES to 0 for the last waiting
folios in the zone, there is a window while __free_pages_prepare() (page
zeroing, KASAN poisoning, memcg uncharging, etc.) and free_one_page() are
still running where the pages are not yet PageBuddy in the buddy allocator,
but zone_rcu_free_waiting(zone) already reads 0 and returns false.

Although rcu_free_sync() flushes rwork.work and expedite works to wait for
folios taken off the per-CPU lists, both alloc_contig_frozen_range_noprof()
and offline_pages() skip calling rcu_free_sync() when
zone_rcu_free_waiting() returns false, causing
alloc_contig_frozen_range_noprof() to return -EBUSY and offline_pages() to
skip synchronizing on the pass that migrated folios.

[1] https://lore.kernel.org/r/20261019154913.1765974-8-kas@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104130118.2507=
513-1-kas@kernel.org?part=3D7

