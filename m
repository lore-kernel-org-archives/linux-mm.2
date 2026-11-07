Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B4D8606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 16:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ly4kEVDP
Received: by kanga.kvack.org (Postfix)
	id 9217E6B05B0; Sat,  7 Nov 2026 11:05:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D2596B05B1; Sat,  7 Nov 2026 11:05:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E83C6B05B2; Sat,  7 Nov 2026 11:05:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51C9D6B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 11:05:03 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C3A9E1C3B08
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:05:02 +0000 (UTC)
X-FDA: 85408796844.07.369BBFB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 265074000A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:05:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ly4kEVDP;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794067501;
	b=qxTEzhtX7tNoLl80H0yZlP+sDB/bmBEuy9wcxc+uBYsvdjShPsRlDHVLVt1nv3fCtvwqBc
	8mFVE35n1knJrhIYyEX9KJ43SxB3RWYe1GQFOUw53zHKJgw11kKpKYvgrMQEI25B2zVYv4
	uVxJQ7RCsqe3MrlWVHG89R6DhPlwC0Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ly4kEVDP;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794067501;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Un1gBsObcxnsYn3FCTYyDKwp8qPSNNnbH9/hnIvuRMQ=;
	b=g3rclmEZPlmucwGRAGH9/m5w4HMcqTBPXptP2olRQ9drUqMJDEfjNNZeNzNSjx8YMfVcYt
	cO1mQRCrzZ+QeVaVagtBpzkfBiEpnRc3cOtj0BDvj20JHp8gv7hM5P+hJTGfEttuvRXPtP
	lIgC32l/DuzbjlzsK06wt7VsrlwsOZw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 266646060F;
	Sat,  7 Nov 2026 16:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86E61F0089F;
	Sat,  7 Nov 2026 16:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794067499;
	bh=Un1gBsObcxnsYn3FCTYyDKwp8qPSNNnbH9/hnIvuRMQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ly4kEVDPu67vbfIdhVsVxt+pL7rpxAbpI+4XuCVfZidcwOx3JXdG61abO2vEsB1gp
	 SneBwN9aDKBKBkt+D5NPiQNVRXdKIdINywH7WK6J74ZEpBY0UkmT9Wuqes/VaIDYw+
	 zLPZzc8Mkt8df+uFrND1BXiShg2HiB5p4Rzm5JY6oUIL6b1BBkISx51eaf6ceD0qSv
	 DBnLI0EFRx5eohnPq3OGOsyxdDhVVPs5n1yDu/wdjfu1kfcE5P1fPpif3VoqPd2jJD
	 IJDthwEbt41oVQ7m5x+HC4fS9fplaySkRWAMboOAV7HJeAh0Zm6apvP8T3gmOddxS+
	 mpwCzt2Xlko3Q==
Message-ID: <sashiko-outbox-203018@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] mm/swap: publish cluster tables after reacquiring
 allocator locks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nhat Pham" <nphamcs@gmail.com>, linux-mm@kvack.org, akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, brauner@kernel.org, chrisl@kernel.org, david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com, ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, weixugc@google.com, willy@infradead.org, youngjun.park@lge.com, yuanchu@google.com
Cc: ryncsn@gmail.com
In-Reply-To: <20261106160432.2552507-3-nphamcs@gmail.com>
References: <20261106160432.2552507-1-nphamcs@gmail.com>
 <20261106160432.2552507-3-nphamcs@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 16:04:58 +0000
X-Stat-Signature: n4ruwiajgkgay5sha7xude685bn8qpkg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 265074000A
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794067500-76560
X-HE-Meta: U2FsdGVkX181s3Jx0PyIw81AoVVJcjZGDAmaYXc3/f1A+gc8/Br3/iHH1vTBPhYcltH7bFjk0TVURq5CgzNyIOcyeOC7+wcTebZrZTiK0brZnH6OZ3KYEI381MQuMT/a52HjXc8XYhJNGh1f4lsbvF3L21K87c+GFLFTOjPenjJpKRaEfWne7+T0HRQa9ZJJj6Usal9YvzYZevgsZ38TpbdNt2udVdUJ8TGAg5UQ8EMSz/kzSCyFkN1X/ne22Q06mGSV+8guSp54N8Ks2A1wyMcCy9pHAPqR9xQuv03RvT1gil4l4GP4E/KB3cWcu0GxN1qbJ9JBG+IMCd99n2hsOSRGN6QgnkyWap+BkRmt1NDt34wJS/+eDF8F3Uy8M9abbPMC52O9hVSG5wr8c9xUd00d6H6Q/s+hIuh1SZPYGlBC1tbb58CxyGWGPc+abv4ApVrS7JMckZNbL/vvhD0Yf1ga5VEJardAKV//O2ErNJ+QCuXTjXrMBCZQVED8TY4RgF4sKLt38cTwiojcb/gk6V+kXoWbQmP2OCgS3hZAWhvRKqIb/VZnUVYiuZBaM5QyIBxAU5R3F3qErwTNgWEu+MRY/eWd3J5keEhZ+2SbrlEuXYjaKGtBGxRIb9H+Tvo2QcP7pDY2nw2mb3wnGO3N3/B2H29pkph5K+FlOF/NhNe7RH6yQk7/d/6SIYkMINeSD/ybx0/E53w7R/4OUrxiH9WbI0LzgN/BLixxz+QlNVkKBFmn2SKK4xdZt65jdQptkztPPrl7h/KHs2f1nrFg3pfGwTC2L2tV+beDPZCiyAyJGnnjCe4112oy2zE+ZdzGX20coazxHtGRYt2/aSloLPVYz0mL8oSxWyXvki3Y2q/pfdlZvdfMHB6++3cpjAH+0mPsFSPkEi9mJTghOW1HqR7p3QoCDcygPF3ipCCy0Lkyr6llHsexoClRNtG2plKNR1dtRZGDeeJgzte0WaF
 F21B5iEY
 DHMgB1kSpzM9CN2uDnjQYgowA5+hJugN+5J4MCngXCueweo/F0iu1eSN0pHA9MQKqhJqn5ObbOst2ptujEvgtBdnSIuwSbGFZEWZBdTb29g6axQnfUoGAKXFQo7zHhYI8AKjOLTyTVGKwDbbG86ToslZMWaSjZ4wX/3vvDfRotYYAnQZ5Dwkf0J9W2xyp+XwL6ISqu074BN3A2jakTTyFgfomgx40anhkTgsGNtxMpA7ZvtVUe/Eeo5EC8BgWmUMLB8OzO9S4F3zHUx6IldrV4VkcE4fhtLsiVEdeJzEmHN0IjIqV9bYOwvmpyMZUfVg9Wq572bkD2fJ76GN9mGt+HNPgohKW52ZJ6NFbaJenrAwiEIQzX6oMMr0lvdSNT9bKiCI93rk/KDtZRBUKYMZ53ZrqR71IIkJR3Tm2syEOBk4eewR3ybYK/D35eOuVwOG2E4Iz/MpLYYYCGt4HaBwv/0m4ujL6UPAZzY6m6owGyjFVhJST/DjemKUsL3o1h/l2G6eJEQccFkmB5gSUk//3DLs5uX/JovjoDPKSGE6m4Pl8XUWXVPIsgMK0zPY4EcSpDNGzJu37TTjDNXE3nBINzrjYvyPVWB1axF1dr82b0u0CNdw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] mm/swap: NULL deref in swap_cluster_assert_empty() on stale
  reclaimer race
- [Medium] mm/swap: ABA race on cluster state check in
  swap_cluster_alloc_table()
--

commit 22e220b18bd05df45a828a3170169b92c0c14f76
Author: Nhat Pham <nphamcs@gmail.com>

mm/swap: publish cluster tables after reacquiring allocator locks

This commit keeps newly allocated swap cluster tables private until
swap_cluster_alloc_table() reacquires the allocator and cluster locks, and
abandons installation if a stale reclaimer returned the cluster while the
locks were dropped.

Link: https://lore.kernel.org/all/sashiko-outbox-181084@kernel.org/
Link: https://lore.kernel.org/all/sashiko-outbox-181086@kernel.org/

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 189f04d8838f3..162a73a9e6638 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c

[ ... ]

> @@ -467,27 +475,49 @@ static int swap_cluster_alloc_table(struct swap_clu=
ster_info *ci, gfp_t gfp)
>  		table =3D kmem_cache_zalloc(swap_table_cachep, gfp);
>  	}
>  	if (!table)
> -		return -ENOMEM;
> +		goto lock;
> =20
>  #ifdef CONFIG_MEMCG
>  	if (!mem_cgroup_disabled()) {
> -		VM_WARN_ON_ONCE(ci->memcg_table);
> -		ci->memcg_table =3D kzalloc_obj(*ci->memcg_table, gfp);
> -		if (!ci->memcg_table) {
> -			swap_cluster_free_count_table(table);
> -			return -ENOMEM;
> -		}
> +		memcg_table =3D kzalloc_obj(*ci->memcg_table, gfp);
> +		if (!memcg_table)
> +			goto lock;
>  	}
>  #endif
> =20
>  #if !SWAP_TABLE_HAS_ZEROFLAG
> -	VM_WARN_ON_ONCE(ci->zero_bitmap);
> -	ci->zero_bitmap =3D bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
> -	if (!ci->zero_bitmap) {
> -		swap_cluster_free_table(ci);
> -		swap_cluster_free_count_table(table);
> -		return -ENOMEM;
> +	zero_bitmap =3D bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
> +	if (!zero_bitmap)
> +		goto lock;
> +#endif
> +	ret =3D 0;
> +
> +lock:
> +	if (!locked) {
> +		if (si) {
> +			local_lock(&percpu_swap_cluster.lock);
> +			if (!(si->flags & SWP_SOLIDSTATE))
> +				spin_lock(&si->global_cluster_lock);
> +		}
> +		spin_lock(&ci->lock);
>  	}
> +	lockdep_assert_held(&ci->lock);
> +
> +	/* A stale reclaimer may have returned the cluster to allocation. */
> +	if (ci->flags !=3D CLUSTER_FLAG_NONE || cluster_table_is_alloced(ci))
> +		ret =3D -EAGAIN;

[Severity: Medium]
Can a stale reclaimer trigger a NULL pointer dereference in
swap_cluster_assert_empty() while ci->lock is dropped here?

Because ci->table now remains NULL across the sleeping allocation in
swap_cluster_populate(), a stale reclaimer that dropped ci->lock before the
cluster was freed and re-isolated can reacquire ci->lock while ci->count is=
 0,
ci->flags is CLUSTER_FLAG_NONE, and ci->table is NULL:

CPU0                              CPU1
                                  cluster_reclaim_range()
                                    spin_unlock(&ci->lock)
                                    /* ci is freed and table is freed */
isolate_lock_cluster()
  ci->flags =3D CLUSTER_FLAG_NONE
swap_cluster_populate()
  /* atomic alloc fails */
  spin_unlock(&ci->lock)
  swap_cluster_alloc_table()
                                    spin_lock(&ci->lock)
                                  ...
                                  relocate_cluster()
                                    free_cluster()
                                      __free_cluster()
                                        swap_cluster_assert_empty()
                                          __swap_table_get()
                                            <-- NULL pointer dereference

In relocate_cluster(), !ci->count and ci->flags !=3D CLUSTER_FLAG_FREE are =
both
true, so it calls free_cluster() -> __free_cluster() without checking
cluster_table_is_alloced(ci).  With CONFIG_DEBUG_VM enabled,
swap_cluster_assert_empty() calls __swap_table_get(), which dereferences the
NULL ci->table.  With SWP_PAGE_DISCARD enabled, free_cluster() also schedul=
es
a redundant discard before swap_do_scheduled_discard() calls __free_cluster=
()
on the tableless cluster.

Should relocate_cluster() avoid calling free_cluster() when
!cluster_table_is_alloced(ci)?

[ ... ]

> @@ -571,13 +612,9 @@ swap_cluster_populate(struct swap_info_struct *si,
>  	 * could happen with ignoring the percpu cluster is fragmentation,
>  	 * which is acceptable since this fallback and race is rare.
>  	 */
> -	local_lock(&percpu_swap_cluster.lock);
> -	if (!(si->flags & SWP_SOLIDSTATE))
> -		spin_lock(&si->global_cluster_lock);
> -	spin_lock(&ci->lock);
> -
>  	if (ret) {
> -		move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
> +		if (ret !=3D -EAGAIN)
> +			move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
>  		spin_unlock(&ci->lock);
>  		return NULL;
>  	}

[Severity: Medium]
Can an ABA race on ci->flags and ci->table cause a failed allocator to put a
cluster back onto si->free_clusters while a second allocator still has it
isolated?

When CONFIG_DEBUG_VM and SWP_PAGE_DISCARD are disabled, a stale reclaimer
calling relocate_cluster() -> free_cluster() -> __free_cluster() moves the
tableless cluster back to si->free_clusters.  A second allocator can then
re-isolate it and also drop ci->lock for a sleeping table allocation:

CPU0                       CPU1                       CPU2
swap_cluster_populate()
  spin_unlock(&ci->lock)
  swap_cluster_alloc_table()
    /* alloc fails */
                           relocate_cluster()
                             ...
                             __free_cluster()
                               ci->flags =3D
                                 CLUSTER_FLAG_FREE
                                                      isolate_lock_cluster()
                                                        ci->flags =3D
                                                          CLUSTER_FLAG_NONE
                                                      swap_cluster_populate=
()
                                                        spin_unlock(&ci->lo=
ck)
    spin_lock(&ci->lock)
    /* flags =3D=3D NONE,
     * table =3D=3D NULL */
    return -ENOMEM
  move_cluster(..., FREE)  <-- puts ci on free_clusters while CPU2 owns it

When CPU0 reacquires ci->lock, ci->flags is back to CLUSTER_FLAG_NONE and
cluster_table_is_alloced(ci) is still false, so swap_cluster_alloc_table()
returns -ENOMEM instead of -EAGAIN and CPU0 moves the cluster back onto
si->free_clusters while CPU2 is still sleeping in swap_cluster_alloc_table(=
).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106160432.2552=
507-1-nphamcs@gmail.com?part=3D2

