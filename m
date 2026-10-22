Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A546606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hBVWmPbo
Received: by kanga.kvack.org (Postfix)
	id 52BB76B0850; Wed, 21 Oct 2026 22:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4D46B0852; Wed, 21 Oct 2026 22:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EBB96B0853; Wed, 21 Oct 2026 22:41:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A7156B0850
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:41:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6DB1C40752
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:41:33 +0000 (UTC)
X-FDA: 85348711266.23.F1588A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id B2A7AC0003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:41:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hBVWmPbo;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792636891;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hwz8KwnzYesAWw+pJbG6JjCf7JDB6j+uq8/Noh3mphw=;
	b=RUdpnXvk79J8BwbSv9qAo+ZJKAfh/lQsTwlrGoL17AcaVo1CJOMHrxn/llZq8wg8ye1yE9
	j0OvBlgAh54s62Pp3ro1+7pkt9s6A8WqWL0wpClNs/0LQL7HC6DfaZ3SatdfOzvO6wRVFE
	JLb8SqExXKrpmBsqCCOgkArttVCCiGI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hBVWmPbo;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792636891;
	b=AnqpGkXkWtHvCN3TL+KxWHo+v8g4vpONMDguSAQovPm+BFtS3y2scRCk1xZLLiVQyUyohw
	9+8wCu0jXe/JgnYPptapvwmitZxyZ101HQnMEB1DluKzlDBfaPxFKFe6BiC7gFhDBVB1Ii
	Wl8p2ZPVCTXf2sHCNQThvDm6BhAnyUg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC5D541685;
	Thu, 22 Oct 2026 02:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECDB1F000C1;
	Thu, 22 Oct 2026 02:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792636890;
	bh=hwz8KwnzYesAWw+pJbG6JjCf7JDB6j+uq8/Noh3mphw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hBVWmPboF2Fa4QC//+1hcRTzeNrYA5258Nkn+gxRl3xbPw4Cg7beSeEDjLiiZk3+B
	 9eDa5NSjOTNYh54X8eCIo49ulHqDZuYbt7tyEpeYEBxczCUIqQ3j2ir/3D+2yBdB0I
	 Uy+QWYiBvqdoWPoTKVMX0arncdTvR01vnq0Kn0Efn+yY/zmKE6S/OshAjiG9pKCB8j
	 R6j0ItS51xJPQjpjUNTc1R2iPep9qSb+3QhACU5Z2FI6qca5Ccs/LE3AmKS4CPqkGD
	 o9qszAKymSzz5YY2E53u8psyrOyX27SD+Zcd6oChCCbuXTGj5BhuTD/5vvWF50DlvW
	 U0sr0RWGW00UQ==
Message-ID: <sashiko-outbox-180880@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 5/8] mm/page_alloc: retry allocations that raced with
 a zonelist rebuild
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?R3JlZ29yeSBQcmljZSAoTWV0YSk=?= <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, kernel-team@meta.com, akpm@linux-foundation.org, mhocko@suse.com, rientjes@google.com, shakeel.butt@linux.dev, rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, bigeasy@linutronix.de, clrkwllms@kernel.org, mgorman@techsingularity.net, anshuman.khandual@arm.com, Bessel.Wang@huawei.com, jiang.liu@huawei.com, linux-kernel@vger.kernel.org
In-Reply-To: <20261021023940.1940971-6-gourry@gourry.net>
References: <20261021023940.1940971-1-gourry@gourry.net>
 <20261021023940.1940971-6-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 02:41:28 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B2A7AC0003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: sugiait8841zec8ogk19rgwn8ekmsj9e
X-HE-Tag: 1792636891-192127
X-HE-Meta: U2FsdGVkX19rW3iCzNOZmb9gFwa2mNiCsqfwYL4AY9XXzlTdHc7s+EL6OMnVUtMazU3i9JaKi9ubp+OCBIhJrG/No2s8SDhOONsv6MKtET94xT9L2/v0iTDUIpWSFFo2xwp1UoAxe15YGyDcw1yjLEfvVgOUDlwbz5+RVTfj7uQxoYDoQVDu2k5C3AoZxZJ1bcfpw9A8eOpXOjblm3dqv/YYzuj3dqTANBaoLIN+Zk9xhDH3SUwBzbu+IC6s/SHxUfkXvrWQpioXfn37j5xz0YE9ySjy7//wMFOKfhuwoTT20nM4KY59oogLTcn+C3mMg8+fImbSRfaXEsRg8GWqHLpQtBYebOfeymn48aJRxoacGuwBcsmfMgDxEPaLP6XInPV6MuyFsx+jLll5lj7gTvvfS7XUcwmxnP5IdvYh1OOTjDaEg5ehFtZhDFxPs9BBUxiW3ffGhrVAD3yFLgA+1QYX9AFheu4Q/NUJPMhwpoqb95Oq/shAranBKrqF0GnRx96lgKLCxQq/uS0KJDbvUDx4ZxMxw5fPo2W23lqcFOnpWmKcGxcD/JAYvbsf5v2HSFW6FcxAvYqlePgbO5LwZTtjNUPJg9KLfhTmljbACilzeWJMCn5a6j0PGZt/JAhblhmA6tRgp49Rl8RVzRcqMotHZTDv0NAsL8eUYZYGm2E8QYMsTGaBdg7u5RDliwopIGay4DZd6kttEjp9bDVbuQIC1PRrmpTxnW4c2hz7kP54OnaCdHg6+qIllnthLBARb8MiUQTV9jOqB5o6F4xAxmOpA77ljcAC5VSkaRWjN4X61qMuHcUG3FzNFUvnGnamYSUK9r/1m4Hk5UzF+jIyX9QsAAY5dj2nH4eA1tvPU5IekNvMd4EDpbOXzvBeLtePT7vHPJNaUTIA/N4zhnxtjZ0080mbwno/e6CjX929WVu7EWTJods5YxbLY7LswU9ePGNq+Auf+5hK/tfZraR
 IICw0za2
 5YCPkgINdDJyN5bL4wAD9A9h1ZYKLnswrU2xKsVKHucpjKwZGT3cS4jbRUpsjKkw+n7AMCekid7qOan7tbvu65ty5QNrVT0s8+UvzW0OKb4kYBUDalIsEVCYjOW80OrXRUGXr9dbWGD/N+pcyIbStE70M0f4tl3HJk4Qq6niYYNwMZ6rCb4GDqzlCHrtmQ/OA0jTHSXeBkTWnGQuX5gUahunP3p8WePRInR8vU/UPiHVet4uunDFkput2iwuA8x+/d2s8DSquT9KhADYcgYIaP/g88Cs1FUibpLcz7j/W5VWP2fTMCu/7dQzx5x3R4KdsouhOVb6i46o99BrZXsi+OUv+DkmqMGFuzFeXTkC/VyVt4ob/LVywOlLL4neskpyQzxZYEDFbIAt7nF7IaWPQ3TVuuucVRsXZOAkoaDAnjrYKIqszFGWUeDWL3zZ2VKR5d4XDukx8rHKoVRdfS8l2DAAAJWYx+ONmQHEEi+fJ6g53ANo2zYMxxUajDzlCTMYaWiTL24UVIbU9Iu1mVas3RzFzWggdXd8Cmt7HYaD5Xk6jth8+N1Q0XpaI8TAa16TyPMDb9Aq5Qu+50szHEpMQHyuqVUOGLrYFxtvDMvkDclgOwqh9NLtJ+IG8EfDDZgv7x7TkON0l74gRppbShYnY2tYFW8s1R6joCN6/dZncGDooJ9cBQCoiK6OaG4UY0FP0JNwTvo3F3KnrG9uMZqlyaHLU2IseYAcDrOlKq6US/da5yBkQpCZi4H/gSBm+hvqLSA60LP0HTg/qGXhoOxOaL7xcNnedFrfYU+07
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] mm/page_alloc: __alloc_pages_slowpath() restart loses reserve re=
try
- [Medium] mm/page_alloc: post-rmqueue() zonelist retry leaves ZONE_MOVABLE=
 blocks unmovable
--

commit 3b023f87050323ef9781701d5864437d2b2b4b5e
Author: Gregory Price (Meta) <gourry@gourry.net>

mm/page_alloc: retry allocations that raced with a zonelist rebuild

This commit checks zonelist_update_seq after page allocation succeeds in the
fast path, slowpath, and bulk allocator, freeing the allocated page and
retrying if a concurrent zonelist rebuild occurred during the zonelist walk.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 1bb308296fcdc..dd8c9046f9a06 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
[ ... ]
> @@ -5114,6 +5127,12 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned in=
t order,
>  	warn_alloc(gfp_mask, ac->nodemask,
>  			"page allocation failure: order:%u", order);
>  got_pg:
> +	/* A rebuild during the walk may have handed out an ineligible zone. */
> +	if (page && check_retry_zonelist(zonelist_iter_cookie)) {
> +		__free_frozen_pages(page, order, FPI_NONE);
> +		page =3D NULL;
> +		goto restart;
> +	}
>  	return page;
>  }

[Severity: Medium]
In __alloc_pages_slowpath() in mm/page_alloc.c, can_retry_reserves is
initialized to true only once before the restart: label:

	bool compact_first =3D false;
	bool can_retry_reserves =3D true;
	unsigned long alloc_start_time =3D jiffies;

When a reserve-eligible allocation (such as PF_MEMALLOC, __GFP_MEMALLOC, or
an OOM victim) fails its initial get_page_from_freelist() attempt at retry:,
it sets reserve_flags in alloc_flags, clears ac->nodemask, sets
can_retry_reserves =3D false, and jumps to retry:

	reserve_flags =3D __gfp_pfmemalloc_flags(gfp_mask);
	if (reserve_flags)
		alloc_flags =3D alloc_flags_cma(gfp_mask) | reserve_flags |
				ac->alloc_flags | (alloc_flags & ALLOC_KSWAPD);

	if (!(alloc_flags & ALLOC_CPUSET) || reserve_flags) {
		ac->nodemask =3D NULL;
		ac->preferred_zoneref =3D first_zones_zonelist(ac->zonelist,
					ac->highest_zoneidx, ac->nodemask);

		if (can_retry_reserves) {
			can_retry_reserves =3D false;
			goto retry;
		}
	}

If that reserve pass allocates a page and reaches got_pg: while
check_retry_zonelist(zonelist_iter_cookie) is true, the new check frees the
page and jumps to restart:.

At restart:, alloc_flags is reinitialized without reserve_flags:

	alloc_flags =3D ac->alloc_flags | alloc_flags_slowpath(gfp_mask, order);

Because can_retry_reserves is still false (and ac->nodemask remains NULL), =
if
the first get_page_from_freelist() after restart: fails without
reserve_flags, the can_retry_reserves retry is skipped. Callers with
!can_direct_reclaim (for example GFP_NOWAIT | __GFP_MEMALLOC or
GFP_ATOMIC | __GFP_MEMALLOC) or current->flags & PF_MEMALLOC then jump
directly to nopage: and fail without ever retrying get_page_from_freelist()
with reserve_flags on the rebuilt zonelist.

Could jumping to restart: from got_pg: without resetting can_retry_reserves
(and restoring ac->nodemask) cause reserve-eligible allocations to lose the=
ir
reserve retry and fail spuriously?

[ ... ]
> @@ -5472,6 +5499,11 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp=
, unsigned int order,
> =20
>  	/* First allocation attempt (or, for nolock, only attempt) */
>  	page =3D get_page_from_freelist(alloc_gfp, order, fastpath_alloc_flags,=
 &ac);
> +	if (likely(page) && unlikely(check_retry_zonelist(zonelist_iter_cookie)=
)) {
> +		__free_frozen_pages(page, order,
> +				    alloc_flags & ALLOC_NOLOCK ? FPI_NOLOCK : 0);
> +		page =3D NULL;
> +	}
>  	if (likely(page) || (alloc_flags & ALLOC_NOLOCK))
>  		goto out;
> =20

[Severity: Medium]
When a non-movable request (such as GFP_KERNEL with MIGRATE_UNMOVABLE or
MIGRATE_RECLAIMABLE) races with online_pages() -> build_all_zonelists() and
get_page_from_freelist() selects ZONE_MOVABLE, rmqueue() runs on ZONE_MOVAB=
LE
before check_retry_zonelist() is checked in __alloc_frozen_pages_noprof() or
at got_pg: in __alloc_pages_slowpath().

Because ZONE_MOVABLE has no free pages in MIGRATE_UNMOVABLE,
rmqueue() -> rmqueue_pcplist() -> __rmqueue_pcplist() -> rmqueue_bulk() ->
__rmqueue() -> __rmqueue_claim() -> try_to_claim_block() claims a
MIGRATE_MOVABLE block in ZONE_MOVABLE, converts its pageblock migratetype to
start_type, and expands the remaining pages into ZONE_MOVABLE's non-movable
freelists and PCP list:

	/* Take ownership for orders >=3D pageblock_order */
	if (current_order >=3D pageblock_order) {
		unsigned int nr_added;

		del_page_from_free_list(page, zone, current_order, block_type);
		change_pageblock_range(page, current_order, start_type);
		nr_added =3D expand(zone, page, order, current_order, start_type);
		account_freepages(zone, nr_added, start_type);
		return page;
	}

When check_retry_zonelist() then detects the race and calls
__free_frozen_pages(), __free_frozen_pages() reads the mutated pageblock
migratetype:

	zone =3D page_zone(page);
	migratetype =3D get_pfnblock_migratetype(page, pfn);

and frees only that single page back to ZONE_MOVABLE's MIGRATE_UNMOVABLE PCP
list or buddy freelist.

Can checking check_retry_zonelist() only after rmqueue() has already mutated
the zone leave converted MIGRATE_UNMOVABLE, MIGRATE_RECLAIMABLE, or
MIGRATE_HIGHATOMIC pageblocks and populated non-movable PCP/free lists insi=
de
ZONE_MOVABLE, where normal movable allocations will not consume the PCP list
and compaction will skip the non-movable pageblocks?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021023940.1940=
971-1-gourry@gourry.net?part=3D5

