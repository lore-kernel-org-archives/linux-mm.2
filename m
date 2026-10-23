Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBA51606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 14:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bB4OP6zd
Received: by kanga.kvack.org (Postfix)
	id DCA9F6B0B8A; Fri, 23 Oct 2026 10:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958A76B03A4; Fri, 23 Oct 2026 10:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8400E6B03A1; Fri, 23 Oct 2026 10:57:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 59B966B039C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:57:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA385120118
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:57:48 +0000 (UTC)
X-FDA: 85354195416.16.E89EBFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3652B20003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:57:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bB4OP6zd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792767467;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tFfgNrf3lMEMeDMiOm37qHLjxBzFb4NEIpInpQntUYk=;
	b=ydAnbDY24U9E1mj6BX6ljBcsx2GcYtZz/QIBRA9KTS69yIHPxwX78ar4ODlxKYTULxmHc3
	9CA6Q+k8SE/9hyB3KvyHK4nvdKWfoicjEdlEnZnZ+7sW7DhgXGLYQ1krK8h8BabyPw3dMj
	ozJ/rc0fUz6S/qt/nSsJz2bxly0iBqI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bB4OP6zd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792767467;
	b=PWkS349jN01g/SdvO/R3X7ZbqGcm1sSuLdnPCueevNZ8HWgv5laAou9l4lRmiFlPNKd+ph
	QbSVyUIE03OWGX3/25AzQdeWLkMcRk44tR5Wd/VMpxhKFVEAbckweCom6X3rf8p0eW/i70
	qmtck9ViF4nKCEuBR/CzGpcnZyQX1qY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3222C4136F;
	Fri, 23 Oct 2026 14:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345CA1F01825;
	Fri, 23 Oct 2026 14:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792767466;
	bh=tFfgNrf3lMEMeDMiOm37qHLjxBzFb4NEIpInpQntUYk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bB4OP6zdy0Un7eUuQrtMSNOFRkt+ENuK/q1bpqbK2ymLd83uWFYpfdyIx/osOwsQw
	 oY2I2diUG/3Xrk1vq0yVmFSwMMKrAiyDws7V5WwHqRW2FDPNJ2GMPbdY6cv1gG+d5M
	 Z+8C90YYYf9Q0FTfe8JYTySnlJ/3OR5uX9lk3vsry98d1aaqeoUvwhULFtWdm7zLxy
	 paQgJQY1Lznxj6Ke0UryfixxiFZiSRjrYitkIoW5YwyPyaDw34pFVi8Pb1Y3Yi+3pF
	 QdcyOE5XdqvdssUnBRvtKuTRvpOLerZwmPvC0+YHHzeAC/ELkUZay75BYcnwXGroVb
	 +SxBPK2qgScdg==
Message-ID: <sashiko-outbox-182881@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 1/1] mm/swap: allocate contiguous swap slots for a
 reclaim batch
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Ghiti" <alex@ghiti.fr>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Kairui Song" <kasong@tencent.com>, "Barry Song" <baohua@kernel.org>, "Chris
 Li" <chrisl@kernel.org>, "Kemeng Shi" <shikemeng@huaweicloud.com>, "Nhat
 Pham" <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Youngjun
 Park" <youngjun.park@lge.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Hugh
 Dickins" <hughd@google.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "David
 Hildenbrand" <david@kernel.org>, "Michal Hocko" <mhocko@kernel.org>, "Qi
 Zheng" <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, linux-mm@kvack.org
In-Reply-To: <20261022145615.2184343-2-alex@ghiti.fr>
References: <20261022145615.2184343-1-alex@ghiti.fr>
 <20261022145615.2184343-2-alex@ghiti.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 14:57:44 +0000
X-Rspamd-Queue-Id: 3652B20003
X-Rspam-User: 
X-Stat-Signature: xbfkszz5kk8zsukamc8qci8f8t3tpz8u
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792767467-329537
X-HE-Meta: U2FsdGVkX18KkmAaAl+QJViuouFzczByBN2yobgxXefPeUg+NO3q+KMKi0soVH8zZn1my1hvcOHoEYwuWL3LKEnNC2v/zlEshLdggGvydJ08oCDOj40EYa9jYQKwouyQumTyGZGGo9unsmKApPlNS96J48lliLVEqcdh/kZAqwJDkp/IElAvAKwvsNTJ3NzmTwDTjEIOeQCDEYOSL/xj8M/YR9cgJ1WdMw8m17NbiKZ14nuyQkTljwQojGoRTj4BCHcnuZAbmMX/MuwZbcJsEpS7On2MCQ5GjslpPowPa/gl5uBDUMYjO8b/agGcpZ9cE+tmIHRmT18273rO72W5ziJ7PYjc9Pq+fTL4HoWfMqT4ViSjq5jAC59vUkhI/ewY5XfBpWUYY45ajI+n26MYo+SY1cAgiWpG6JWPTvcdb3iTQzIBXdHriigtGrLrgpUGyYvxKGja569r2C0aWPnJGYzOa0zyPEbwyctG+o7wRMSMT/6x46BqSqH3ObV/aYl0+ntI1kLAWaFAiyoTVCFDqDg/ulPYRJvMJcqihcOnpUVdiSX8y3Krn/jcv5GCyBC8i+LTcF0Oyq36Ok+CiWnQ+5S4hAxY0zEQRG4S/VsK8z6VZcRDDQmVz9jexvPEh5Xnua7KqdrgaFdQbJzmAghJnhuY+b1Bmq9h9Vz4vSud4YEbZTW/4Fm161AZQ4WLii7TRSkl/tl2Fn2RHbroG7l9M7a0HTV8MgXipo1F57sb6WQSAABIt//NEEsjzeTractsiwkkBaLg3hLXppdaRcwWXf2FDUpWRMakMQgmYkxWYyggj0ap2ulee8g1ykf+j4WrjBz72RyZv2dK1CJHv3cVlwNqCkGClk8ipsrXgmIJlHowQ2ATaFaGNLyOuaDGVdBfLWDxtlbrzQBLMjydWGbQGGxzO0WUas6xFxHX5hKcRc8e040eRl6b2PPdhkRT0xPedZswBsmuiWcST+EQ+Zg
 YmsjKHPy
 Kx1utH6L+dXXEyEEizpXL0lE8lybgUOpXrkiBhueoIdBngznE1sisHCz/yTqmXGDcrhxRmwgEyEb/ZuoxGGm7STIvWBNuGlG/LBMn34CX4CNqG5mSiT81mKWVolN58YuGBP/tXC9JNtyC6Fr7irg5WLFxkJxKBHY7a+/R88hQkvig1+dJX3NgtYg26OOjSGEzIRPShGaavKxZgDfW70nj91elYzyu1+jDkzwt60xbtXqpTkfYOQhY5enwRa54ChBh+9QLykOBKjcy3HeqRxjj4DWoO4f6t1ePPB3hNixFpcnI33LxO5ehbkfiDefz83hdD5G1+z1GM8MTQ0pcwWQbbHbzw6fUe2YBfvZi2p9jhgptb93xKbFmx0FOb/9W2tL5RmBoGCD5y8PGCEQs1XXTJuWD1SZJ05F82fEMUbpmWmamG2uGVGrf11bt7ygDQ6kACl+E6vR+BStnG0Xl8HBOrOCvi+/fIPmagG7j/NEcilGAJdb0moUQbnAdYoy6891kOZak5qq33PDoOY7cbYgYBfQKfu9K70Y3+in4JiYrsTirxTBiTlTuOOuoVClGPD2D/XRR
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
- [High] mm/swap: stack use-after-return on skipped list in alloc_swap_scan=
_list_contig()
- [Medium] mm/swap: folio_alloc_swap_split() skips cursor check and order a=
ccounting
- [Medium] mm/swap: swap_alloc_prepare() and swap_alloc_fast() strand usabl=
e clusters on frag_clusters
--

commit 0160f7d5d1e92861c5a388fc552e5871f0f57f93
Author: Alexandre Ghiti <alex@ghiti.fr>

mm/swap: allocate contiguous swap slots for a reclaim batch

This commit records the number of pages per small order in a reclaim batch
before swapping them out and updates the swap cluster allocator to seek
contiguous runs of up to SWAP_CLUSTER_MAX free slots in nonfull or free
clusters.

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c3288910b3e35..67161e1849052 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c

[ ... ]

> @@ -1042,6 +1079,59 @@ static unsigned int alloc_swap_scan_list(struct sw=
ap_info_struct *si,
>  	return found;
>  }
> =20
> +/* Larger folios already make large enough write requests on their own */
> +#define SWAP_BATCH_MAX_ORDER	(ilog2(SWAP_CLUSTER_MAX) - 1)
> +
> +static inline unsigned int swap_batch_contig(unsigned int left)
> +{
> +	return min_t(unsigned int, left, SWAP_CLUSTER_MAX);
> +}
> +
> +/*
> + * Like alloc_swap_scan_list(), but only allocate at the start of @nr_co=
ntig
> + * free slots. Order 0 clusters without them move to the frag list until=
 a
> + * slot is freed, larger orders stay nonfull as the folio may still fit.
> + */
> +static unsigned int alloc_swap_scan_list_contig(struct swap_info_struct =
*si,
> +						struct list_head *list,
> +						struct folio *folio,
> +						unsigned int nr_contig)
> +{
> +	unsigned int found =3D SWAP_ENTRY_INVALID, order =3D folio_order(folio);
> +	struct swap_cluster_info *ci;
> +	unsigned long start, offset;
> +	LIST_HEAD(skipped);
> +
> +	while ((ci =3D isolate_lock_cluster(si, list))) {
> +		start =3D cluster_offset(si, ci);
> +		offset =3D SWAP_ENTRY_INVALID;
> +		if (SWAPFILE_CLUSTER - ci->count >=3D nr_contig)
> +			offset =3D cluster_find_free_contig(ci, start,
> +							  start + SWAPFILE_CLUSTER,
> +							  1 << order, nr_contig);
> +		if (offset =3D=3D SWAP_ENTRY_INVALID) {
> +			if (order)
> +				move_cluster(si, ci, &skipped,
> +					     CLUSTER_FLAG_NONFULL);
> +			else
> +				relocate_cluster(si, ci);
> +			swap_cluster_unlock(ci);
> +			continue;
> +		}
> +		found =3D alloc_swap_scan_cluster(si, ci, folio, offset);
> +		if (found)
> +			break;
> +	}
> +
> +	if (!list_empty(&skipped)) {
> +		spin_lock(&si->lock);
> +		list_splice_tail(&skipped, list);
> +		spin_unlock(&si->lock);
> +	}
> +
> +	return found;
> +}

[Severity: High]
Can moving an order > 0 cluster onto the stack-local skipped list with
CLUSTER_FLAG_NONFULL and then dropping ci->lock cause a stack
use-after-return on skipped?

When shrink_folio_list() reclaims a batch of mTHP folios (order > 0, up to
SWAP_BATCH_MAX_ORDER), folio_alloc_swap() -> swap_alloc_slow() ->
cluster_alloc_swap_entry() -> alloc_swap_scan_list_contig() places any
cluster from si->nonfull_clusters[order] lacking nr_contig contiguous free
slots onto skipped with ci->flags set to CLUSTER_FLAG_NONFULL, and then
unlocks ci->lock.

While ci is unlocked on skipped, another CPU can lock ci by offset (for
example, when freeing its remaining entries via
__swap_cluster_free_entries() -> free_cluster(), or through a cached
percpu_swap_cluster / global_cluster cursor in swap_alloc_fast() /
cluster_alloc_swap_entry() -> alloc_swap_scan_cluster() ->
relocate_cluster()). Because ci->flags !=3D CLUSTER_FLAG_NONE, move_cluster=
()
removes ci from skipped under si->lock:

mm/swapfile.c:move_cluster() {
	spin_lock(&si->lock);
	if (ci->flags =3D=3D CLUSTER_FLAG_NONE)
		list_add_tail(&ci->list, list);
	else
		list_move_tail(&ci->list, list);
	spin_unlock(&si->lock);
	ci->flags =3D new_flags;
}

When ci is the last entry on skipped, __list_del(&skipped, &skipped) in
include/linux/list.h updates skipped.prev and skipped.next without a
memory barrier:

static inline void __list_del(struct list_head * prev, struct list_head * n=
ext)
{
	next->prev =3D prev;
	WRITE_ONCE(prev->next, next);
}

Because alloc_swap_scan_list_contig() tests !list_empty(&skipped)
(READ_ONCE(skipped.next) =3D=3D &skipped) outside si->lock before returning,
can it observe skipped.next =3D=3D &skipped, skip spin_lock(&si->lock), and
return while the other CPU is still writing skipped.prev on the popped
stack frame?

Also, while those order > 0 clusters sit on the local skipped list, they
are hidden from concurrent alloc_swap_scan_list() callers scanning
si->nonfull_clusters[order], which could cause premature -E2BIG splits.

[ ... ]

> @@ -1390,7 +1503,15 @@ static bool swap_alloc_fast(struct folio *folio)
>  	if (cluster_is_usable(ci, order)) {
>  		if (cluster_is_empty(ci))
>  			offset =3D cluster_offset(si, ci);
> -		alloc_swap_scan_cluster(si, ci, folio, offset);
> +		/* The batch's contiguous slots are used up */
> +		if (this_cpu_read(percpu_swap_cluster.batch_left[order]) &&
> +		    !cluster_slots_free(ci, offset, 1 << order)) {
> +			swap_cluster_unlock(ci);
> +			this_cpu_write(percpu_swap_cluster.offset[order],
> +				       SWAP_ENTRY_INVALID);
> +		} else {
> +			alloc_swap_scan_cluster(si, ci, folio, offset);
> +		}
>  	} else {
>  		swap_cluster_unlock(ci);
>  	}
> @@ -1729,6 +1850,86 @@ static int swap_dup_entries_cluster(struct swap_in=
fo_struct *si,
>  	return err;
>  }
> =20
> +static void swap_alloc_prepare(unsigned int order, unsigned int nr)
> +{
> +	unsigned int nr_contig =3D swap_batch_contig(nr);
> +	struct swap_cluster_info *ci;
> +	struct swap_info_struct *si;
> +	unsigned long offset;
> +	bool keep =3D false;
> +
> +	local_lock(&percpu_swap_cluster.lock);
> +	if (nr <=3D (1 << order)) {
> +		this_cpu_write(percpu_swap_cluster.batch_left[order], 0);
> +		goto out;
> +	}
> +	this_cpu_write(percpu_swap_cluster.batch_left[order], nr);
> +
> +	/* Keep the cursor if enough free slots follow it */
> +	si =3D this_cpu_read(percpu_swap_cluster.si[order]);
> +	offset =3D this_cpu_read(percpu_swap_cluster.offset[order]);
> +	if (si && offset && get_swap_device_info(si)) {
> +		ci =3D swap_cluster_lock(si, offset);
> +		if (cluster_is_usable(ci, order)) {
> +			if (cluster_is_empty(ci))
> +				offset =3D cluster_offset(si, ci);
> +			keep =3D offset % SWAPFILE_CLUSTER + nr_contig <=3D
> +			       SWAPFILE_CLUSTER &&
> +			       cluster_find_free_contig(ci, offset,
> +							offset + nr_contig,
> +							1 << order,
> +							nr_contig) =3D=3D offset;
> +		}
> +		swap_cluster_unlock(ci);
> +		put_swap_device(si);
> +	}
> +	if (!keep)
> +		this_cpu_write(percpu_swap_cluster.offset[order],
> +			       SWAP_ENTRY_INVALID);
> +out:
> +	local_unlock(&percpu_swap_cluster.lock);
> +}

[Severity: Medium]
When swap_alloc_prepare() or swap_alloc_fast() clears
percpu_swap_cluster.offset[order] to SWAP_ENTRY_INVALID without calling
alloc_swap_scan_cluster(), does that strand usable clusters on
si->frag_clusters[order]?

On the first allocation from a cluster, alloc_swap_scan_cluster() calls
relocate_cluster(), which moves any partially populated cluster
(0 < ci->count < SWAPFILE_CLUSTER) to si->frag_clusters[ci->order]:

mm/swapfile.c:relocate_cluster() {
	...
	} else if (ci->count !=3D SWAPFILE_CLUSTER) {
		if (ci->flags !=3D CLUSTER_FLAG_FRAG)
			move_cluster(si, ci, &si->frag_clusters[ci->order],
				     CLUSTER_FLAG_FRAG);
	}
}

Previously, the per-CPU cursor kept allocating from that cluster until the
end of the cluster was reached. With this change, if swap_alloc_prepare()
finds fewer than nr_contig free slots immediately at offset, or if
swap_alloc_fast() (or cluster_alloc_swap_entry() for rotating storage)
encounters an occupied slot at offset while batch_left[order] is non-zero,
the cursor is abandoned while ci remains on si->frag_clusters[order], even
if large contiguous free regions remain later in the same cluster.

Since si->frag_clusters[order] is only scanned after si->nonfull_clusters
and si->free_clusters are exhausted (and only one cluster at a time), could
abandoning the cursor without returning ci to si->nonfull_clusters[order]
or scanning the rest of ci cause premature cluster exhaustion and -E2BIG
mTHP swapout fallbacks?

> +
> +/**
> + * folio_alloc_swap_prepare - prepare swap allocation for a reclaim batch
> + * @folios: list of folios reclaim is about to swap out
> + *
> + * Record how many pages of each small order the batch will swap out, so
> + * that their slots are allocated contiguously. Nothing is reserved.
> + */
> +void folio_alloc_swap_prepare(struct list_head *folios)
> +{
> +	unsigned int max_order =3D min(SWAP_BATCH_MAX_ORDER, SWAP_NR_ORDERS - 1=
);
> +	unsigned int nr[SWAP_BATCH_MAX_ORDER + 1] =3D {};
> +	struct folio *folio;
> +	unsigned int order;
> +
> +	if (!total_swap_pages)
> +		return;
> +
> +	list_for_each_entry(folio, folios, lru) {
> +		if (!folio_test_swapbacked(folio) || folio_test_swapcache(folio))
> +			continue;
> +		order =3D folio_order(folio);
> +		if (order <=3D max_order)
> +			nr[order] +=3D 1 << order;
> +	}
> +
> +	for (order =3D 0; order <=3D max_order; order++)
> +		swap_alloc_prepare(order, nr[order]);
> +}
> +
> +/**
> + * folio_alloc_swap_split - account for a large folio split by reclaim
> + * @nr_pages: number of order-0 folios the split produced
> + */
> +void folio_alloc_swap_split(unsigned int nr_pages)
> +{
> +	local_lock(&percpu_swap_cluster.lock);
> +	this_cpu_add(percpu_swap_cluster.batch_left[0], nr_pages);
> +	local_unlock(&percpu_swap_cluster.lock);
> +}

[Severity: Medium]
Should folio_alloc_swap_split() also validate percpu_swap_cluster.offset[0]
for contiguous free slots and decrement batch_left[order] for the split
folio's original order?

When folio_alloc_swap_prepare() sees 0 or 1 order-0 folios in the batch,
swap_alloc_prepare(0, nr[0]) sets batch_left[0] to 0 and leaves the
existing percpu_swap_cluster.offset[0] cursor untouched. If a large folio
is subsequently split in shrink_folio_list() or shmem_writeout(),
folio_alloc_swap_split() adds nr_pages to batch_left[0] without checking
whether percpu_swap_cluster.offset[0] has swap_batch_contig(batch_left[0])
contiguous free slots following it.

Because swap_alloc_fast() only checks cluster_slots_free(ci, offset, 1) for
order-0 allocations, if percpu_swap_cluster.offset[0] points into a small
free hole, the first subpages of the split folio will be allocated into
that hole until an occupied slot is reached.

In addition, if the split folio had order <=3D max_order,
folio_alloc_swap_prepare() already added 1 << order to batch_left[order].
When that folio is split before folio_alloc_swap() (such as a partially
mapped folio in shrink_folio_list() or a folio in shmem_writeout()) or
after folio_alloc_swap() fails without clearing batch_left[order],
batch_left[order] is not decremented, leaving it inflated for subsequent
folios of that order.

=D1=82=D0=B8=D1=82=D1=8C=D1=81=D1=8F

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022145615.2184=
343-1-alex@ghiti.fr?part=3D1

