Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B16B606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LvJ5Xkml
Received: by kanga.kvack.org (Postfix)
	id 567EF6B05CB; Tue, 10 Nov 2026 00:58:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546DB6B05CC; Tue, 10 Nov 2026 00:58:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B9D06B05CD; Tue, 10 Nov 2026 00:58:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 137696B05CB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:58:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0B08120489
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:58:07 +0000 (UTC)
X-FDA: 85418153814.25.B9FD05A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id F06B040004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:58:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LvJ5Xkml;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794290286;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7ZUnqnLn9PC9WzqDP7wyt1zkT4pCvDGUVWb0rDTqhc=;
	b=r1B+RSY1zLxSVbcWzLqN81SxCfXoOr3A5e/0PFEMOWkZJybJW7DmFG3mmrnOPBKaVDajtb
	Ls5mhezJzOx5zD6v/T3NZIUEu6Yvtu2Eyim4bjnMo9RicHTLREPrzPnqgFc109SIVKHdh8
	JEtWMxxisssdurNvlMl/qwHbAhBqCeU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LvJ5Xkml;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794290286;
	b=3eedU1Gb9XygHrRUnLjmoK/GJc3ZkwTYEzkXd5dFdWu8T3LmOWLf/6GZz50ydPlhMDpUFw
	PZpA+oWZwNudykvPywH/QmsZNAcfPiQx/4BslKkuC03g/tZ+e5RF14YC0sZtuSiAVN4ptw
	+tK+glx6sRrNfD3si/ZPE2De2wJc3v4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 484AB46960;
	Tue, 10 Nov 2026 05:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A69D1F0089F;
	Tue, 10 Nov 2026 05:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794290285;
	bh=r7ZUnqnLn9PC9WzqDP7wyt1zkT4pCvDGUVWb0rDTqhc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LvJ5XkmlfnMqtkAyBTYkXvoj9iwxrdyzAhBpGoc0965I+pYePZHoGNVAtSTRQMzAP
	 VzZz5SJX5C0relRmjjzSkTgPG6k+upek3udIZUpZX3BDfLDtafl1lvPtEm7bvFPIyM
	 6khG5lDPtywdB89gs01HP6YW56ZqZKj+6RzvHcS77vfTcEToatlf4cXmryyhY+v3Aj
	 QjaMGQtFNgQEjBJB/D9MATBAndOzUqFRdNr2BTg7zHFaqvQmjp3vPJ6uw6MkGlEffB
	 Xi+clDV3hYnu/CWHTohZ+raeBhEKn0xF2H8F9RuLjL3xRF/u1tRQAIupHCZvYGmvLP
	 TfTSkmq0M7rMg==
Message-ID: <sashiko-outbox-206372@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 13/19] mm, swap: add xswap grow trigger on cluster
 allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baoquan He" <baoquan.he@linux.dev>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, david@kernel.org, chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, corbet@lwn.net, hannes@cmpxchg.org, chengming.zhou@linux.dev, kunwu.chan@gmail.com, klarasmodin@gmail.com, "Baoquan
 He" <hebaoquan@kylinos.cn>
In-Reply-To: <20261109055455.536925-14-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
 <20261109055455.536925-14-baoquan.he@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 05:58:04 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F06B040004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 8x1wfb8rydooyhugeob5kitephoqbdua
X-HE-Tag: 1794290285-926369
X-HE-Meta: U2FsdGVkX19v8t0ml0kRRNjleYx+U/o2sQ6SgZT8L2AHNhvo6n+Rc3fleyFcnl6Nb/vquKLjvBK65KdS7eibxwajRPhUaLPVaUbTAXOX7wme5AfB+nn5xm5I9LervY4hy2KQap4jfvlYitU5D50LVxf74pYn79vokT6v/JFl2ifLr8xAP7UQSU8mRnYHu+7fLyXNC1LYmYrZ1QURB4ZfPmBryIvpo3OYjp3r9urBoTaZNFUSMGB/PJWZhuUUzUkVr38vzKhUKCc08xaWG7lRBQWupj3WsYfOxeLtTKDQGmyZgvZxDpqWVl78zWmlFDSAM4rcuNyHFwmFQL1JfHm9WIYeHafsYPU0g+VaimFbjIDNNsT9cSfxdExjQXoJS4l8CRanBX6tH7NraowPjDuxYyU1KBecmJYAgxYLdwWODE00RrYgm65tesgH41OaPCRFXky6PboxNQ/M6XFl3uB+KWWIMvbWJmuzPYsDigUSoIb2fOx59h1kEbq6AILimAefU5/x+t1l2tpkLj05Hpxs16mkRI8DxRpQUf0Ao+Vv1HfVhAjWqeZtF3iyy7Lad1dutNyQ6vM5egaD0QsVhBQRfwR+PIylB+/kG6WV22CDBSJV6aBiB88JQr8n5d4zOjemK26xhklp8biKYfExxGMviwTPTRfXgRP/4Ef06IVDncvW8XcAwq5ONiCmQ+ttpeZsfmP8XmjdElftNFEnbuBz0m4rq2MdMGzjQxCwkwIQPDMDGeckqSNtVEn0sGSQnwbUmdJXLLx1UXC8DhszLxksUoIG8jtUadUNmFvWi9u6kGdU+NXflg1Ik8U3Wb7kDPuq0tD+ImqKQl8gkdHYXg1C8bRTX3o5AOuFyXJ9iGgEBM4wE8IwXughctPS6RO9uaBxPIUsBqiYocjjye8O2zTb3dwkJLQbMi3pxTyZZNMKb4NV1BZ4DDPI/5VbrQeHV90sXTwhJH+WIXaCE56S4Kh
 qmAWRuBe
 UY4WW/B4prqnmUkrgJuJU0sb1k3sIq0jsU3cYt3n+yg756jx6Y7ISyVHXf+TXxQym4cgD5O0PpVk0tAbe6iY8LZdDY7fYOHly4VtuddY5zuSEFuVcspdcb7FrfEZpqFTljD6f1DDDmayNeAdWfVXYX9e/knaSsjv5I+C739pMXJw3T7KBy7FceA6Jc0HoNXZh8xYhVJ0go2P73b00iKTGgVD8H3IaDy3yL/YYIJfbmAcnEgKUvHGk9kTyMPuDRvM0qJLbAuUokVbj/WQwjuw0nHOSGS2rcsaxnDCStcU5Gk2V2Ehprhg59knwpT8CzA7+BUCo3oxDmHIOl5yyl/bQqsth3dVcdtyABW1vL8BPfnWIynVkwa58ouR4jO5jTeE+yvpyS7aukuGAMPoml5tFnaReA8XUC7vjISHUYA3pUUFLNXCM07ybN7hwOLhhUAs7+Fjk/cSj5BdAUsT30ewxieVmkdlkQMu6tjMJVdsTFzVuwrDqmS18OH0m1FVeckmzk9yeVDiNV/cF7Z0keQ64ejXW85FFAp0FhqJ9DQhw9z74S/tWvKwcikFnsaWdT6Ot+YXE6lmbolyzICNcbkMUxcvHJUgXKWniD9RU62xUSUQ3VrZV7hBnZ9yGnIwZjhQjJ/oVQsiPEHZhcTs=
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
- [Medium] mm, swap: premature nr_clusters_mapped update in
  xswap_map_clusters()
- [Medium] mm, swap: cluster exhaustion below 85% usage in
  xswap_should_grow()
--

commit 691004e6412209ac9359059a41013d8433ee5087
Author: Baoquan He <hebaoquan@kylinos.cn>

mm, swap: add xswap grow trigger on cluster allocation

This commit adds on-demand growth of the mapped xswap cluster_info range
from cluster_alloc_swap_entry() when swap usage reaches 85% of the
currently mapped range, growing it back down to 65% usage.

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 7b1d16226b7bb..ba730fa19194c 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c

[ ... ]

> @@ -1359,6 +1370,18 @@ static unsigned long cluster_alloc_swap_entry(stru=
ct swap_info_struct *si,
>  	if (order && !(si->flags & SWP_BLKDEV))
>  		return 0;
> =20
> +#ifdef CONFIG_XSWAP
> +	/*
> +	 * Top the range up early.  Every path below leaves through `done`,
> +	 * so this has to come first; mapping pages can sleep, and doing it
> +	 * from the allocation that would otherwise fail leaves nothing to
> +	 * fall back on.
> +	 */
> +	if ((si->flags & SWP_XSWAP) && (si->flags & SWP_WRITEOK) &&
> +	    xswap_should_grow(si))
> +		xswap_grow(si);
> +#endif

[ ... ]

> @@ -1435,6 +1458,12 @@ static unsigned long cluster_alloc_swap_entry(stru=
ct swap_info_struct *si,
>  		if (found)
>  			goto done;
>  	}
> +
> +#ifdef CONFIG_XSWAP
> +	/* A concurrent free or grow may have added clusters; retry once. */
> +	if (!found && (si->flags & SWP_XSWAP))
> +		found =3D alloc_swap_scan_list(si, &si->free_clusters, folio, false);
> +#endif
>  done:
>  	if (!(si->flags & SWP_SOLIDSTATE))
>  		spin_unlock(&si->global_cluster_lock);
> @@ -4168,6 +4197,77 @@ static void xswap_unmap_range(struct swap_info_str=
uct *si,
>  		__free_page(pages[i]);
>  }
> =20
> +static bool xswap_should_grow(struct swap_info_struct *si)
> +{
> +	unsigned long mapped =3D READ_ONCE(si->nr_clusters_mapped);
> +
> +	if (mapped >=3D READ_ONCE(si->nr_clusters_max))
> +		return false;
> +
> +	return swap_usage_in_pages(si) * 100 >=3D
> +	       mapped * SWAPFILE_CLUSTER * XSWAP_GROW_WHEN;
> +}

[Severity: Medium]
Can cluster_alloc_swap_entry() run out of usable clusters and fail with
SWAP_ENTRY_INVALID while swap_usage_in_pages(si) is still below 85% of the
mapped range?

Each CPU that misses in swap_alloc_fast() isolates a whole 512-page cluster
from si->free_clusters or si->nonfull_clusters, allocates a single slot,
moves the cluster to si->frag_clusters, and caches it in percpu_swap_cluste=
r.
When the number of concurrently allocating CPUs reaches nr_clusters_mapped
(initially at most XSWAP_GROW_CLUSTERS, i.e. 16 to 85 clusters), or when mo=
re
than 15% of mapped clusters are held in per-CPU caches, si->free_clusters a=
nd
si->nonfull_clusters are drained while every cluster in si->frag_clusters is
isolated or locked by its owning CPU.

Because total page usage can still be well below 85% (and below the 65%
XSWAP_GROW_UNTIL check in xswap_grow()), xswap_should_grow() returns false
and the fallback at the end of cluster_alloc_swap_entry() only retries
si->free_clusters without growing the mapped range, causing folio_alloc_swa=
p()
to fail prematurely even though unmapped clusters remain available.

> +
> +/*
> + * Map more of the cluster_info array, up to GROW_UNTIL in use.  The cal=
ler
> + * holds percpu_swap_cluster.lock, which this drops while it sleeps.
> + */
> +static unsigned long xswap_grow(struct swap_info_struct *si)
> +{
> +	unsigned long mapped =3D READ_ONCE(si->nr_clusters_mapped);
> +	unsigned long nr_new, want, i;
> +	int ret;
> +
> +	/* The unmap below is paired with the caller's lock. */
> +	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
> +
> +	want =3D DIV_ROUND_UP(swap_usage_in_pages(si) * 100,
> +			    XSWAP_GROW_UNTIL * SWAPFILE_CLUSTER);
> +	if (want <=3D mapped)
> +		return 0;
> +
> +	nr_new =3D rounddown(want - mapped, XSWAP_GROW_CLUSTERS);
> +	if (!nr_new)
> +		nr_new =3D XSWAP_GROW_CLUSTERS;
> +	if (nr_new > XSWAP_GROW_CHUNKS * XSWAP_GROW_CLUSTERS)
> +		nr_new =3D XSWAP_GROW_CHUNKS * XSWAP_GROW_CLUSTERS;
> +	nr_new =3D min(nr_new, READ_ONCE(si->nr_clusters_max) - mapped);
> +	if (!nr_new)
> +		return 0;
> +
> +	/*
> +	 * Mapping pages can sleep.  The lock only guards the per-cpu
> +	 * cluster cache, which this path does not touch.
> +	 */
> +	local_unlock(&percpu_swap_cluster.lock);
> +	ret =3D xswap_map_clusters(si, mapped, nr_new);
> +	local_lock(&percpu_swap_cluster.lock);
> +	if (ret)
> +		return 0;
> +
> +	/*
> +	 * Link the clusters even if swapoff cleared SWP_WRITEOK while we
> +	 * mapped. The caller keeps the device alive, and nothing takes a
> +	 * cluster while WRITEOK is clear. If try_to_unuse() fails, the
> +	 * reinserted device needs them.
> +	 */
> +	for (i =3D mapped; i < mapped + nr_new; i++) {
> +		struct swap_cluster_info *ci =3D &si->cluster_info[i];
> +
> +		/*
> +		 * A concurrent grower may have taken these already;
> +		 * only add the off-list ones.
> +		 */
> +		spin_lock(&ci->lock);
> +		if (ci->flags =3D=3D CLUSTER_FLAG_NONE)
> +			move_cluster(si, ci, &si->free_clusters,
> +				     CLUSTER_FLAG_FREE);
> +		spin_unlock(&ci->lock);
> +	}
> +
> +	return nr_new;
> +}

[Severity: Medium]
Can concurrent swap allocations fail in cluster_alloc_swap_entry() between
xswap_map_clusters() updating si->nr_clusters_mapped and xswap_grow() linki=
ng
the new clusters onto si->free_clusters?

xswap_map_clusters() publishes the new si->nr_clusters_mapped and drops
si->xswap_lock before returning to xswap_grow():

mm/swapfile.c:xswap_map_clusters() {
    ...
	smp_store_release(&si->nr_clusters_mapped, start_idx + nr);
	mutex_unlock(&si->xswap_lock);
	return 0;
    ...
}

Until the winning grower re-acquires percpu_swap_cluster.lock and runs the
move_cluster() loop, the newly mapped clusters remain off-list with
CLUSTER_FLAG_NONE:

CPU0                              CPU1
cluster_alloc_swap_entry()        cluster_alloc_swap_entry()
  xswap_grow()
    xswap_map_clusters()
      mutex_lock(&si->xswap_lock)
      ...
      smp_store_release(
        &si->nr_clusters_mapped, ...)
      mutex_unlock(&si->xswap_lock)
                                    xswap_should_grow() -> false
                                    /* scans cluster lists: empty */
                                    alloc_swap_scan_list(
                                      &si->free_clusters) -> 0
                                      <-- returns SWAP_ENTRY_INVALID
    local_lock(...)
    move_cluster(...,
      &si->free_clusters, ...)

Similarly, a concurrent caller that already entered xswap_grow() and waited
on si->xswap_lock wakes up, sees start_idx !=3D si->nr_clusters_mapped, gets
-EAGAIN from xswap_map_clusters(), and returns 0 from xswap_grow() before C=
PU0
links the clusters.  When existing clusters are exhausted during the grow,
these concurrent allocations return SWAP_ENTRY_INVALID despite the newly
mapped capacity.  Linking the new clusters onto si->free_clusters (or
updating si->nr_clusters_mapped after linking) while still serialized by
si->xswap_lock would avoid this window.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109055455.5369=
25-1-baoquan.he@linux.dev?part=3D13

