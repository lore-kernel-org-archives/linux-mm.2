Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68737606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZDPD8zXX
Received: by kanga.kvack.org (Postfix)
	id 781C26B0983; Wed, 28 Oct 2026 00:22:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7327E6B0985; Wed, 28 Oct 2026 00:22:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621A26B0986; Wed, 28 Oct 2026 00:22:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5EC6B0983
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:22:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13EC8C0B91
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:22:35 +0000 (UTC)
X-FDA: 85370738670.27.F136B87
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5B5E9C0002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:22:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZDPD8zXX;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793161353;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KJe1DnSL5I+ScvDr3zb529EygXW8khYJB6ts23Z9hAM=;
	b=p8PacyAVjhlnoErtADs6hkv/L6qslosq1J4xMiQYBkBH0COPXYIJfKkYCd2NjQO77xtP3v
	AXZa/V+BtrbOLmI6JHRyPDtuIfNLjTR1vLAPXy8Vp+gaqyMYpIihmzqMoMgJnCE2GUb6Uo
	PFbag42OU4paE58UGx8+zga8UDhARDk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZDPD8zXX;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793161353;
	b=oaWLxznE28Zy/9gkQCfUqx6nqaBoh8aZrotGbyjYsINUti765zyiDW5d6VtAOOn/n6ZkND
	72dOpnDmJTQhzgm0mttrXqO4kC1+UAc/d+s8BOlzsAzTsO9/t1mnLATQV3EN22I2WieZ9w
	OQjhS7XW1PVCKdje6gk1pWHGC1zaxTk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 50C5F43487;
	Wed, 28 Oct 2026 04:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4183C1F01828;
	Wed, 28 Oct 2026 04:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793161352;
	bh=KJe1DnSL5I+ScvDr3zb529EygXW8khYJB6ts23Z9hAM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZDPD8zXXytnUTyzxAqJY/nqLza35XK0CUR2IKGMTYIvpb4Cqs3TSqijASoj0hI1aJ
	 iHpKoxo9y9L1bDwOZhQ3JYNb2WgsJD6Kxu8HKT1znRG9oG1Xpc5r1zJuqx+Stz3txb
	 1F5jnB22/mj0Ld8rFIr0PVpw/NrzzX+/VZMFJaipyJ13pUfuwD8JG97uKpc2B5ba6m
	 ly2CpCqyWkjBAQXTwVSvVeFcIDwQOW/LwZAvZNCbawiiWxnQlcTs8v5yWqzP2BlMOU
	 5qep2HB8GbhceFiF27Kqy855JkRD84NSbHwSjB971cf46d2DzUy6DTiX5nLoRohjpk
	 OjsVlnfds4pbQ==
Message-ID: <sashiko-outbox-187473@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/6] mm/compaction: wait for pfn walkers before
 poisoning offlined memmap
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?R3JlZ29yeSBQcmljZSAoTWV0YSk=?= <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com, david@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org, osalvador@suse.de, muchun.song@linux.dev, iamjoonsoo.kim@lge.com, anshuman.khandual@arm.com
In-Reply-To: <20261027042204.3741307-2-gourry@gourry.net>
References: <20261027042204.3741307-1-gourry@gourry.net>
 <20261027042204.3741307-2-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 04:22:30 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5B5E9C0002
X-Stat-Signature: sa3jipw3enaeaiq13ywrkej8mfpp5cou
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793161353-464562
X-HE-Meta: U2FsdGVkX18etOPq4ukgu8dElcMsaq8kAQxt5pcLnYUKTIzkSlV4MRmg+h8zBEUC1rk4ftMgSYYQ1vPw1twhIFB0OQ13yiYQ3T4l/rAaEER43NsuEmuDPWBHOhlOT8BmVAVGuCxracWcsPsuo50PVtsb3E+w1YY0uraNIfGf6WU9BmRY0t7UhCx6fbdIyQAD1D1uQA0/srSnu8+kpmPZ03LWCmidRab3I7VzphKPcat2JCvhbhaoJL3Nd/uuBnMShoCVzfSPLBocDb2wR8JKzWO3pz9FPSliVXieNUTXKdygw411nc/IryR6Ur4iCdCb94R6FY/8c0zcnn9njoiSvhUq6cphir8qFlIVAzp/swoZcqbhKS8ZEsKhvW3V+xQvN8LeagW/kd9H0BpfjC5rQZbkHTZjJ7127AJYoXnLYthujvuFKd0uwCs+xpqwO5vzu1q+1HZJwU4NRIoYtQr1NuxBl3n00bYwU0CaDJ9XRsRFOPdKXRuSW/6K518o4DNtEuGyvHTbwDkOc04UfsOj7VTpCf7monlK6Dlbs7Xg9cf7RdIF4FsnyWW5+ZPniCfQo0pbeGPS4hJpOLXS1ORheQjWJL+SWZp7p+SdKPk1W5txyqpmSz2o9guxc9Ue1V5LJM/Cm1dRu0i5or92jLoXbYtyfw3S4bvXflcNHnEb88ndLmSIWWWmyyI+s/SLC/S8DO+9Sk7epHzWAn7OJY18rgF/Ue0WpUtWdlZl/Yk1ARjgtdIbo1n3Aeek3PGqMl5T6T2Gzx1fZ8Zbs0IF4NGwIHB7m5EzzfGKhPDg/SLePH5KZH8xM3eD0tbL+dBb/M9u9gEhMP65AL+qJwb09EMoR24AIEEOpQTWYdS4uCxzYcUY0asPfL3MAfLFo4/R2Bd7hSfMsjGkJFaalyHbfBQk6IRxbqlWInicqpnTX7iXNBS7JqTYLE+fJobKxPAHHXNHE4P5PWcV790ic8a4fLQ
 16uMU1Fm
 RKSZ7pFwuf0YthpaiRaO1spMojMEwVZeEdxPWxIUAX9q24fdUuNIjaLdgAoz52X0R1uPhbJRMUcTFGgFfuohlMFsJKVgo1VaevVypM/kCrxZ/SZNSHqHdwdWLaczTOKgSNiT+0CtUOqrcjnfQ4PvjACSYceJRHeHBYf1wKyY4zCjw4yI7GEMdlxcr8woHDC7/Od+z1DcqzNAL1a0T2Mx7AkYCpwD/CdsFCffXSdvwFqv6HIzrUMd46KEFJ+cTTUYZBb6+VGTYzs6S/hydsVlMS2KIS+onYwdnN6CySVlB9pTZ1kkPNbyQnvp0ibOkNyf2UsY00k3uV2xoHV4vP9Tw7RiZyn0XLA++o7tOzKazwk4FknzLX5peC7On/RxN8lIkMRuJI00eVVLwHMHsZvgmQXZ4r8piP3DoXVUHz6XwjSrCefO2aDVxiUE3cVBLhOzffhHzP0OUTYHcCkBgY6MP6pznBcR+toYZhhGiB2eYeFwz+U5aP0ji46I5eYI83/7+rC5DrKIJwxkUv4wUhT7Yn5f759Qzn1mfFZPj0GL8agy8hW/CNiyQ3zeMJl0YAGnQ7bFVQbYqldPKpqYYLClw2eX9MVNEQ+cJDtJGCxWMa0bjv0+mDm8dsFgtmzlStGcLoHYNSDa7FQvLCeVOy6uMWkZkgo6E8jx++MfUOInD7Iya2sfmwETnC75bmtplj8+/NSbaPAthKv2nhnRxkkYK4vLrfdEi9O3bZhbkTZ/ie8Au478=
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
- [High] mm/compaction: clamping low_pfn in isolate_migratepages() loops fo=
rever
- [High] mm: race in pageblock_pfn_to_page() with move_pfn_range_to_zone() =
onlining
- [Medium] mm: pfn_walk_srcu is disabled when CONFIG_MEMORY_HOTREMOVE=3Dn
--

commit 6ad7c6454b21a8c91c2521a8135b38b5d2766881
Author: Gregory Price (Meta) <gourry@gourry.net>

mm/compaction: wait for pfn walkers before poisoning offlined memmap

This patch introduces an SRCU-fast read section around compaction PFN walks
and waits for readers in remove_pfn_range_from_zone() before poisoning
offlined memmap pages. It also updates pageblock_pfn_to_page() and
isolate_migratepages() to handle zone span changes across memory offlining.

> diff --git a/mm/compaction.c b/mm/compaction.c
> index f1b2060eb2016..2aeb18b6d54dd 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c

[ ... ]

> @@ -2116,6 +2121,9 @@ static isolate_migrate_t isolate_migratepages(struc=
t compact_control *cc)
>  	 */
>  	fast_find_block =3D low_pfn !=3D cc->migrate_pfn && !cc->fast_search_fa=
il;
> =20
> +	/* Offline may have shrunk the zone start past an old migrate_pfn */
> +	low_pfn =3D max(low_pfn, block_start_pfn);
> +
>  	/* Only scan within a pageblock boundary */
>  	block_end_pfn =3D pageblock_end_pfn(low_pfn);

[Severity: High]
Can clamping low_pfn to block_start_pfn without updating cc->migrate_pfn
cause compact_zone() to enter an unbounded infinite loop?

If memory offlining shrinks cc->zone->zone_start_pfn upward via
offline_pages() -> remove_pfn_range_from_zone() -> shrink_zone_span() while
compaction is running, cc->migrate_pfn can sit below the new
cc->zone->zone_start_pfn while cc->free_pfn is either also in the offlined
lower range (with cc->migrate_pfn < cc->free_pfn) or in the first pageblock
of the new zone start (where block_end_pfn > cc->free_pfn).

In isolate_migratepages() in mm/compaction.c, clamping low_pfn to
block_start_pfn advances block_end_pfn =3D pageblock_end_pfn(low_pfn) past
cc->free_pfn, so the pageblock loop is skipped completely:

	for (; block_end_pfn <=3D cc->free_pfn;
			fast_find_block =3D false,
			cc->migrate_pfn =3D low_pfn =3D block_end_pfn,
			block_start_pfn =3D block_end_pfn,
			block_end_pfn +=3D pageblock_nr_pages) {

Because the loop does not execute, isolate_migratepages() returns
ISOLATE_NONE without advancing cc->migrate_pfn or calling cond_resched().

Back in compact_zone(), compact_finished() -> __compact_finished() checks
compact_scanners_met(cc):

static inline bool compact_scanners_met(struct compact_control *cc)
{
	return (cc->free_pfn >> pageblock_order)
		<=3D (cc->migrate_pfn >> pageblock_order);
}

Since cc->migrate_pfn was never updated to low_pfn, compact_scanners_met(cc)
remains false and __compact_finished() returns COMPACT_CONTINUE (even
before checking fatal_signal_pending(current) when is_via_compact_memory()
or !pageblock_aligned(cc->migrate_pfn) holds), causing compact_zone() to
spin forever on ISOLATE_NONE without rescheduling.

Should cc->migrate_pfn also be updated when low_pfn is clamped to
block_start_pfn?

> diff --git a/mm/internal.h b/mm/internal.h
> index 3a402e735dbe2..fdc83a7aafb51 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -18,6 +18,7 @@
>  #include <linux/rmap.h>
>  #include <linux/swap.h>
>  #include <linux/leafops.h>
> +#include <linux/srcu.h>
>  #include <linux/tracepoint-defs.h>
> =20
>  /* Internal core VMA manipulation functions. */
> @@ -1208,6 +1209,46 @@ struct tlbflush_unmap_batch;
>   */
>  extern struct workqueue_struct *mm_percpu_wq;
> =20
> +/*
> + * Compaction checks that a pageblock is online and then uses its pages,
> + * possibly across sleeps.  remove_pfn_range_from_zone() waits for these
> + * readers before it poisons the memmap of a range taken offline.
> + */
> +#ifdef CONFIG_MEMORY_HOTREMOVE
> +extern struct srcu_struct pfn_walk_srcu;

[Severity: Medium]
Should pfn_walk_srcu be guarded by CONFIG_MEMORY_HOTPLUG rather than
CONFIG_MEMORY_HOTREMOVE?

When CONFIG_MEMORY_HOTPLUG=3Dy, CONFIG_MHP_MEMMAP_ON_MEMORY=3Dy, and
CONFIG_MEMORY_HOTREMOVE=3Dn, pfn_walk_lock(), pfn_walk_unlock(), and
pfn_walk_synchronize() compile to no-ops.

However, during memory_block_online() in drivers/base/memory.c:

	if (nr_vmemmap_pages) {
		ret =3D mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
		if (ret)
			goto out;
	}

	ret =3D online_pages(start_pfn + nr_vmemmap_pages,
			   nr_pages - nr_vmemmap_pages, zone, mem->group);
	if (ret) {
		if (nr_vmemmap_pages)
			mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
		goto out;
	}

If nr_vmemmap_pages >=3D PAGES_PER_SECTION, mhp_init_memmap_on_memory() in
mm/memory_hotplug.c marks full vmemmap sections online via
online_mem_sections() before online_pages() runs. If online_pages() then
fails, mhp_deinit_memmap_on_memory() calls offline_mem_sections() and
remove_pfn_range_from_zone(), which poisons the struct pages without waiting
for concurrent compaction pfn_walk readers when CONFIG_MEMORY_HOTREMOVE=3Dn.

[ ... ]

> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> index 2b1017a91928c..3446a2ebdd0f2 100644
> --- a/mm/page_alloc.h
> +++ b/mm/page_alloc.h
> @@ -216,7 +216,12 @@ extern struct page *__pageblock_pfn_to_page(unsigned=
 long start_pfn,
>  static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
>  				unsigned long end_pfn, struct zone *zone)
>  {
> -	if (zone->contiguous)
> +	/*
> +	 * Offline can shrink the zone under a caller's old pfns and then set
> +	 * zone->contiguous again, so only trust it inside the current span.
> +	 */
> +	if (smp_load_acquire(&zone->contiguous) &&
> +	    zone_spans_pfn(zone, start_pfn) && zone_spans_pfn(zone, end_pfn - 1=
))
>  		return pfn_to_page(start_pfn);
> =20
>  	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);

[Severity: High]
Can pageblock_pfn_to_page() race with move_pfn_range_to_zone() during memory
onlining and return poisoned struct pages through the zone->contiguous fast
path?

When a boundary range is offlined by remove_pfn_range_from_zone(), its
struct pages are poisoned, the zone span shrinks, and set_zone_contiguous()
sets zone->contiguous =3D true for the remaining span.

When that range (or a newly hot-added range) is later onlined via
online_pages() -> move_pfn_range_to_zone() in mm/memory_hotplug.c:

	clear_zone_contiguous(zone);

	if (zone_is_empty(zone))
		init_currently_empty_zone(zone, start_pfn, nr_pages);
	resize_zone_range(zone, start_pfn, nr_pages);
	resize_pgdat_range(pgdat, start_pfn, nr_pages);
	...
	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
			 MEMINIT_HOTPLUG, altmap, migratetype,
			 isolate_pageblock);

move_pfn_range_to_zone() clears zone->contiguous first (with a plain store
and no barrier or grace period) and then expands zone->zone_start_pfn and
zone->spanned_pages in resize_zone_range() before memmap_init_range()
reinitializes the poisoned struct pages and before the sections are marked
online.

Because pageblock_pfn_to_page() also loads zone->contiguous first and checks
zone_spans_pfn() second, a concurrent reader in pageblock_pfn_to_page() can
load zone->contiguous =3D=3D true right before clear_zone_contiguous(zone),=
 and
then observe the newly expanded zone_start_pfn / spanned_pages from
resize_zone_range() while memmap_init_range() is still running (or observe
the stores out of order on weakly ordered architectures), bypassing
__pageblock_pfn_to_page() on offline poisoned pages.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027042204.3741=
307-1-gourry@gourry.net?part=3D1

