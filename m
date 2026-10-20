Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62164606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 16:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k6CmGZoM
Received: by kanga.kvack.org (Postfix)
	id 6B9806B0514; Tue, 20 Oct 2026 12:06:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6914F6B0515; Tue, 20 Oct 2026 12:06:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CE7A6B0516; Tue, 20 Oct 2026 12:06:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C1116B0514
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:06:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AFE9E16029A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:06:55 +0000 (UTC)
X-FDA: 85343483190.24.92CBE46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6304920005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:06:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k6CmGZoM;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792512414;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mu7QXdRVqlSFq1hXlXuToT3MAZ+NtwtmMyeRyoxvbQo=;
	b=Gmt6rht78GV4PjpMb6Q3umGJPOK/FLIrvTyU59ltaG/9+S+mb9UvDtX6zGAzUWlq3qwusO
	jJaic18S0TaGL0wOtMkMGNOZh+1SCvaqJ1J6P5h24h1Nw6g+93ftFXecyn9WpHwcyvIHv3
	DEdczEjKXQEmMWEnxVAln6XaOJh3CzU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792512414;
	b=ItSfM6vDKqQrNxzUoyM5zFL+SN5KwrUAdikMatlTTdOlf/8hEYc5qATurLT6u6BsR7URcB
	BAQOuBWYcwfXR4e2AeEKltr4raKGkFmio5vn04SHFBhC/86UrlAGHoYAtD35o1roiGPC7z
	sW9j7LkXzxraIDkqW/T1Jbn+5ytQUNI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k6CmGZoM;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A04C960142;
	Tue, 20 Oct 2026 16:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF29F1F000C4;
	Tue, 20 Oct 2026 16:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792512413;
	bh=Mu7QXdRVqlSFq1hXlXuToT3MAZ+NtwtmMyeRyoxvbQo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k6CmGZoMap6B5hWUWdkGBQ4quxgyP0gjA/A+7Luli0uBjUhrqfx8pzHHe7rYORSkG
	 +KOGvXiUYzuMb0uKgI0nDewD0WoRpXeycQcxtQxL6QZDXZOWPfADfBkWVz4txRLoOO
	 +GyLA/CWryn2QtX2uHuABblpdzU0Nx6s/QLUa6BlJGro6XWBo3jnQUXX9+Fot2H4yq
	 qcD/k8TO44Bj5BcQp3kMhB206gIkTubqeDH5MC7ntCQbvqqjEvKbzlh6WBKg9Al5d0
	 M0jyF5V8ZZH1Z3BxeqCtcYFW04pn8LqLk8GAQt5Nznb83TnjQyRQS9dXFdjTMQhmbE
	 6cq9ef7C7EwNw==
Message-ID: <sashiko-outbox-179329@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm, swap: revalidate populated clusters before scanning
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nhat Pham" <nphamcs@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry
 Song" <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, linux-mm@kvack.org
In-Reply-To: <20261019160615.2348500-1-nphamcs@gmail.com>
References: <20261019160615.2348500-1-nphamcs@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 16:06:25 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6304920005
X-Stat-Signature: 3gxenxspngjb4y4a8dq6tt65pyt7bhpd
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792512414-77750
X-HE-Meta: U2FsdGVkX1+ejGKsl1q0qmbyOk1tFNEpmXhYg9bZK8o9b4JDbTIp2YUAMmykOEyoFrn8Mo5hkwJE5ds7ImLWOWRwhbRSFvVv9udvmIFosJPEL8kHVTSSJ5gP92dWw6t68aeoqXfCJiISmCscUwuMWvlVwyGAB6d4YaWAIj3eXvBQUSfYuFRnvtpccm2GodxxiWok+0NwOEAd0L411jKkW/Y9UWYnQWXXAj4LaYrJ7tHjGa5cXWmAuYVgpG7RkiUqi27wtNUxoQ8UnKmMau4AhaAUOujofzHlhTiKYnkVLYSP5wSTdZgyBlmcQ3lyNTLGMQCnKPZlgTPOaJUhEtFnBnyhdGFSzGlO3CUnOkBWyBuGXLaOhEc/LU8/VUXcBn3F1RK/AwJdt6Aa9wRvwW4S8tH7vwZ/8SeHM144OOTWO6mrR9vT1C7783zk3cPrkYQpNM+HDspl7o9l9hOaNB4CPb865nXytjFw3i11O7uwIMZG3DPqxYfNmZ1WnggkfdGIeeNwX3hOiibzDoHkM94T1/LyAz3I5coNRfnHjM1V3LedmxkGGyLBO7XpCplorTYrqkPtFRytxIZWVy4fptF+6+lZ8AiX7DwiMQprsL2Oh18IKsqm4JDIFFfsq5jmIJO6NYZnJrO2/iButDg8JaeHlbkOUUaU/Ch7u4P45h2I+rqNcxfFEGAeqBByrQufMaFsCIhRxt65K/2Pz7mtZbnlNE4VrOOE08tMPCmVXZ3H6/Aq9hxrWGcsojs9mcIPunsMf1yEe0fIMOR+WsbEjbiDev20n0l4RBRQyQCqGWpe4qusAzTAXoK07xCD6jYRtA/0QNn8Q7gQb/Eqw7V/cICos2bKWMiO9aYskoYAXWRVo4hIAuxqnUslYCUNYiafoJne0ZJgUkPHyjGJgw3kyTbHKeufgzX6hM7qVJxjKdAJBfowJ5DZKwXuk4xNGhhN6OLk570imoHKvOF/VEUEcKx
 XmSl7ZLa
 4yiN25DeZEyzWBXQ3EP2zKW5YtW67r0HbQjy+r1wYYBIJInBw5zKu8xCe13RyEecO+bF2CpRMDC2WdSE3p8r69KKFSeYE6427t97rCVj43j9gpgeejqinE+6Y/s0W6wHSC8EV3+Wm6czAIIDABG0jglqOiXfpDCBx9RJv7roqw24HIivQlM1GgHqaU04OFCOUCvnwdcOBUUAfxYHBtexwzAPq5wPL2UDJGc8m2Fyml6PCIJoRr314K3ZgoQRJeSIa/9k2bYWhZQhiLIdRSuoJj/4c9XND8vCnAtnl1CQrUk5+Kwe45OwW3SpgDZ1dMI7AY7VXeVyXAf45GiYh+CYOS3yy1hTi1t1AI/QNKFC2sRI5Q22cF0BCmGhBAQOwpQaC9+6Mngu4xFbX06bP9+zPea/X9OWpy2fOsmTAt4AgkxR0oD2bl+flalmlqbSZY6BTQWW3zAGbCGirvr3PxvYOSLb45AK+CrKyUQ97+U9EthG62/xAHjmptv7Ay7Fi8y2EsyYw+YlYxzvEXDWUcutEnThKPH5EBYAjGRh4msjMPCnVOfgQS3oquVm2/1SiYsFqKJjqsDENO8c5leqv+boReisNog==
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
- [High] mm, swap: alloc_swap_scan_cluster() relocates and scans stolen clu=
sters
- [High] mm, swap: alloc_swap_scan_cluster() relocates unusable cluster aft=
er reclaim
- [Medium] mm, swap: alloc_swap_scan_list() aborts free_clusters scan on st=
olen cluster
--

commit 4e1646405a5a83e283c6f4c0fe1ba0012bdd06c6
Author: Nhat Pham <nphamcs@gmail.com>

mm, swap: revalidate populated clusters before scanning

This commit checks cluster_is_usable() at the start of
alloc_swap_scan_cluster() to avoid dereferencing a NULL cluster table when a
cached allocator uses and frees a newly populated cluster while
swap_cluster_populate() has dropped the cluster lock.

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c3288910b3e35..988b7316e0a18 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -981,7 +981,11 @@ static unsigned int alloc_swap_scan_cluster(struct s=
wap_info_struct *si,
>  	bool need_reclaim, ret, usable;
> =20
>  	lockdep_assert_held(&ci->lock);
> -	VM_WARN_ON(!cluster_is_usable(ci, order));
> +	if (!cluster_is_usable(ci, order)) {
> +		if (cluster_table_is_alloced(ci))
> +			relocate_cluster(si, ci);
> +		goto out_unlock;
> +	}

[Severity: High]
Can this relocate a cluster that another CPU has already relocated or
isolated, and still scan a cluster that was stolen while
swap_cluster_populate() dropped ci->lock?

All callers of alloc_swap_scan_cluster() other than
isolate_lock_cluster(si, &si->free_clusters) either check
cluster_is_usable(ci, order) under ci->lock immediately prior or isolate ci
without dropping ci->lock. When swap_cluster_populate() publishes ci->table
in swap_cluster_alloc_table() while ci->lock is dropped, ci initially has
ci->flags =3D=3D CLUSTER_FLAG_NONE and ci->count =3D=3D 0, which satisfies
cluster_is_usable(ci, order) for all orders.

Consequently, !cluster_is_usable(ci, order) at entry to
alloc_swap_scan_cluster() can only happen if a racing CPU (CPU1) locked ci =
via
a cached offset (such as in swap_alloc_fast()) and ran
alloc_swap_scan_cluster() before the populating CPU (CPU0) reacquired
ci->lock. When CPU1 finished alloc_swap_scan_cluster(), CPU1 already called
relocate_cluster(si, ci) at the out label, placing ci onto frag_clusters,
full_clusters, discard_clusters, or free_clusters.

If CPU0 then calls relocate_cluster(si, ci) when cluster_table_is_alloced(c=
i)
is true:

1. If a third CPU (CPU2) subsequently isolated ci from frag_clusters or
full_clusters via isolate_lock_cluster() (setting ci->flags to
CLUSTER_FLAG_NONE) and dropped ci->lock inside cluster_reclaim_range() or
swap_reclaim_full_clusters(), CPU0's relocate_cluster(si, ci) sees
ci->flags =3D=3D CLUSTER_FLAG_NONE:

mm/swapfile.c:relocate_cluster() {
	...
	} else if (ci->count !=3D SWAPFILE_CLUSTER) {
		if (ci->flags !=3D CLUSTER_FLAG_FRAG)
			move_cluster(si, ci, &si->frag_clusters[ci->order],
				     CLUSTER_FLAG_FRAG);
	} else {
		if (ci->flags !=3D CLUSTER_FLAG_FULL)
			move_cluster(si, ci, &si->full_clusters,
				     CLUSTER_FLAG_FULL);
	}
}

This moves ci back onto si->frag_clusters[ci->order] or si->full_clusters
while CPU2 still holds it isolated, allowing another CPU to isolate the same
cluster concurrently.

2. If an entry in ci was freed after CPU1 allocated from it,
partial_free_cluster() moved ci to si->nonfull_clusters[ci->order] with
ci->flags =3D=3D CLUSTER_FLAG_NONFULL. CPU0's relocate_cluster(si, ci) sees
ci->flags !=3D CLUSTER_FLAG_FRAG and demotes ci from nonfull_clusters to
frag_clusters.

Conversely, because swap_cluster_populate() publishes ci->table before
reacquiring percpu_swap_cluster.lock, si->global_cluster_lock, and ci->lock,
what happens if CPU1 allocates from ci while ci->lock is dropped, but
cluster_is_usable(ci, order) remains true for CPU0's order?

mm/swapfile.c:cluster_is_usable() {
	if (unlikely(ci->flags > CLUSTER_FLAG_USABLE))
		return false;
	if (!cluster_table_is_alloced(ci))
		return false;
	if (!order)
		return true;
	return cluster_is_empty(ci) || order =3D=3D ci->order;
}

For example, if CPU0 has order =3D=3D 0 while CPU1 claimed ci for a higher =
order
and placed it on si->frag_clusters[ci->order], or if CPU1 allocated the same
order and placed ci on frag_clusters (or CPU2 isolated it from frag_clusters
and dropped ci->lock in cluster_reclaim_range()), cluster_is_usable(ci, ord=
er)
still returns true on CPU0. Wouldn't CPU0 then scan, allocate from, and
relocate a cluster that is already on frag_clusters or isolated by CPU2,
fragmenting high-order clusters and caching the same cluster on multiple CP=
Us?

[Severity: Medium]
Also, when alloc_swap_scan_cluster() takes the goto out_unlock path for a
stolen cluster, it returns SWAP_ENTRY_INVALID to alloc_swap_scan_list():

mm/swapfile.c:alloc_swap_scan_list() {
	do {
		struct swap_cluster_info *ci =3D isolate_lock_cluster(si, list);
		unsigned long offset;

		if (!ci)
			break;
		offset =3D cluster_offset(si, ci);
		found =3D alloc_swap_scan_cluster(si, ci, folio, offset);
		if (found)
			break;
	} while (scan_all);
}

In cluster_alloc_swap_entry(), both calls scanning &si->free_clusters pass
scan_all =3D false:

mm/swapfile.c:cluster_alloc_swap_entry() {
	if (si->flags & SWP_PAGE_DISCARD) {
		found =3D alloc_swap_scan_list(si, &si->free_clusters, folio, false);
		if (found)
			goto done;
	}
	...
	if (!(si->flags & SWP_PAGE_DISCARD)) {
		found =3D alloc_swap_scan_list(si, &si->free_clusters, folio, false);
		if (found)
			goto done;
	}
}

Because scan_all is false, won't alloc_swap_scan_list() exit the loop after=
 a
single stolen cluster without trying to isolate another cluster from
si->free_clusters (causing PMD_ORDER allocations, or allocations when
nonfull_clusters and frag_clusters are empty, to fail even when free cluste=
rs
remain on si->free_clusters)?

> =20
>  	if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER)
>  		goto out;
> @@ -1010,6 +1014,7 @@ static unsigned int alloc_swap_scan_cluster(struct =
swap_info_struct *si,
>  	}
>  out:
>  	relocate_cluster(si, ci);
> +out_unlock:
>  	swap_cluster_unlock(ci);
>  	if (si->flags & SWP_SOLIDSTATE) {
>  		this_cpu_write(percpu_swap_cluster.offset[order], next);

[Severity: High]
Does the !usable path after cluster_reclaim_range() in
alloc_swap_scan_cluster() have a similar issue when jumping to out instead =
of
out_unlock?

In the scan loop just above:

mm/swapfile.c:alloc_swap_scan_cluster() {
		if (need_reclaim) {
			ret =3D cluster_reclaim_range(si, ci, offset, order, &usable);
			if (!usable)
				goto out;
}

cluster_reclaim_range() drops ci->lock to call __try_to_reclaim_swap() and
then rechecks cluster_is_usable(ci, order) after reacquiring ci->lock:

mm/swapfile.c:cluster_reclaim_range() {
	spin_unlock(&ci->lock);
	...
	spin_lock(&ci->lock);
	...
	if (!cluster_is_usable(ci, order)) {
		*usable =3D false;
		return false;
	}
}

While ci->lock is dropped in cluster_reclaim_range(), __try_to_reclaim_swap=
()
or a concurrent free on another CPU can free the last entry in ci, causing
__swap_cluster_free_entries() -> free_cluster() -> __free_cluster() to free
ci->table (setting ci->table to NULL) and move ci to si->free_clusters with
ci->flags =3D CLUSTER_FLAG_FREE.

Before cluster_reclaim_range() reacquires ci->lock, another CPU (CPU2) can
call isolate_lock_cluster(si, &si->free_clusters), which removes ci from
si->free_clusters, sets ci->flags =3D CLUSTER_FLAG_NONE, and drops ci->lock=
 in
swap_cluster_populate() when atomic table allocation fails.

When cluster_reclaim_range() reacquires ci->lock, ci->count is 0, ci->flags=
 is
CLUSTER_FLAG_NONE, and ci->table is NULL, so cluster_reclaim_range() sets
*usable =3D false. Back in alloc_swap_scan_cluster(), 'if (!usable) goto ou=
t;'
calls relocate_cluster(si, ci), which sees !ci->count and
ci->flags !=3D CLUSTER_FLAG_FREE and calls free_cluster(si, ci) ->
__free_cluster(si, ci) while ci->table is NULL and CPU2 is running
swap_cluster_alloc_table() unlocked.

Won't that dereference a NULL ci->table in swap_cluster_assert_empty() (und=
er
CONFIG_DEBUG_VM), race swap_cluster_free_table() against CPU2's unlocked
swap_cluster_alloc_table() on ci->memcg_table and ci->zero_bitmap, and place
ci back onto si->free_clusters while CPU2 holds it isolated?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019160615.2348=
500-1-nphamcs@gmail.com?part=3D1

