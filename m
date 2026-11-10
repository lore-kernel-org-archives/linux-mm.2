Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B9C606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IoE8/4G1
Received: by kanga.kvack.org (Postfix)
	id 875036B05CD; Tue, 10 Nov 2026 00:58:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C286B05CE; Tue, 10 Nov 2026 00:58:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7639F6B05CF; Tue, 10 Nov 2026 00:58:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 474476B05CD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:58:09 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D01CF808C5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:58:08 +0000 (UTC)
X-FDA: 85418153856.19.BBF02C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 27056100002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:58:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IoE8/4G1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794290287;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Mfv6lL9c6W2XR34Izu44gTl4LnL4rYgjG/0Cb55EdM=;
	b=iah/BI4PyvRNEhNTflzPxeWPKCCjtM770foiu/r/3NFPUjej/1a+jibbEgeU5WkdP9y5Bk
	fftrftlU0HgUwbUttDbc+9zrg6pUPVfLpt85ehEdDKHVfS1/w4Jw59wsodzuBjdH7MRln8
	CxSgAC4zqcN/QalVJBmqSbKPIUhNEQg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IoE8/4G1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794290287;
	b=KRWVTq1KG2FJouv6FEHX/j0se1xyKKa5ognP/pWvWc+YrTac5Gxu0vhg+BCwvyHdwIdAX6
	17u/Txp3492dkGon0GzPiOnh8Sw99STI9lrpl0a1Sl2eWdthyPpfEcQJjvoJCAVuOevOJS
	2Ry/xWhYRPOU1BeregbXwg54owJosl0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7620E469AA;
	Tue, 10 Nov 2026 05:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B073E1F0089F;
	Tue, 10 Nov 2026 05:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794290286;
	bh=2Mfv6lL9c6W2XR34Izu44gTl4LnL4rYgjG/0Cb55EdM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IoE8/4G18+6Hp1zoMvGdqUAygWMDYwbBKGVHDoQOfGrZ2iKxAwalFoAx5xKQqWFCr
	 1YPUHwGuqdIARqmVnYBj/STcorzM5TJ5nvx5A/lCorZD/hD7yDXDC/69a7yiSe04eD
	 3P8bGworAJ3Wk5NopK3AgtyI39rR56NpYfM/EcfnfMh++tNhbFb6N/jlW1LPAj2fNK
	 LbhXjkFNKgagVq8Ls5+ToI31azdC6N7h64pEIvwkG2WK/iVQ5rq1uYQgVFrrDrnO2+
	 D0x/Id4fxvOj8GI90u+sok2vhLqiKKGsj3DS5jLtdivvVkVBCV+YnZs4YTClrHeBua
	 KKXOZSafbKFMA==
Message-ID: <sashiko-outbox-206374@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 15/19] mm, swap: make xswap cluster_info accesses
 RCU-safe
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baoquan He" <baoquan.he@linux.dev>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, david@kernel.org, chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, corbet@lwn.net, hannes@cmpxchg.org, chengming.zhou@linux.dev, kunwu.chan@gmail.com, klarasmodin@gmail.com, "Baoquan
 He" <hebaoquan@kylinos.cn>
In-Reply-To: <20261109055455.536925-16-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
 <20261109055455.536925-16-baoquan.he@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 05:58:05 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 27056100002
X-Stat-Signature: ouk9b7o1mnjzunuwf3bqqr7o5981848d
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794290286-770968
X-HE-Meta: U2FsdGVkX1+PhHDkaYqPiFxD5m3CamT3lx/QCfsOaSYqbtOr5oCjhqHEooyz943lfDOFBJlKrelvU5mYmMtz2ghjMZRI3u/we+rITC5f2IN9FjSZJBtUzuggxJmx6gL5xnseof1/bMSEsZIlV+qmdXJECoqjyDhan0trp/fmLGTiN555OfyrH/HaSgu/ZLnxXM+Q2otGOOzPwO3witSlfxOpcJUltleM+mrwDOi+jYF5tPrul3oEo1qHYa1KTJiwpxwri8HxbQBaC0r/0SiPZwruHzLPKfl/Pr91c7O8oFs2bLcVoa78zaz5I9KYUd35j5fWU8P3PgXnY2oKRxpg0hMh43oS/AK/wHSbG80nM3wzgfQrS+pUKymqiiraunH2H3OAoUg6ZRvB1viFvTwG3nJNrRnXt+LrqfxmS1LlH68WWLfC55w5IJJj/w3APmjT4+2771tDmYWPwJpg09y2mER9Kuhc/4uMp/UuwHS5OQAHMfjPeJT4HgiWPHs2GyGbAwbFruG2KKTbA7UB0nXZBzh5t4FfGiGFxdGuyDsfKjuOIR+senCi9X2YNGvvxLCSTmoxoI/OSnY6uQdmMOMp8WScpT0iwMjKhO+HsKK/AF1OvaWwbgcYrHLG0t0XVxSjuUvrkF8abO3B1pOvOAdpujPN1JlVICO/1xJPJTY2VK2rpF9vyysZq33SmVI3wmp3tW17on+pK0k/iQqWiM/FKelNiI5Q7LWqwVQVfcpZpryDUhXqg5aD6WepF9OB+vCaOyZ1gnxhmzcJv8i+Q9ZWO/tMJwy+gjOJfIXRcCcEjz22sIA+NDKle7T2B/xgk4/zTji26+0CUxV2eQD1M1g7z1KanDiP5ggZ0bAD3bLfCTalflDgnIQnGGAazDZ67J8DvYEEu7zoH0qK+2NINEKUVIbXhXsWOqWM1baRgu31OmIm9THU18Aj0w0F3iBvlYpmueeou51AsyPRe8IvyYb
 KWjQ2oBJ
 KyXx1PbhpXaf+koFEaIXiwyfzBERpbDdyxDP4E+MIjvhzJwf4HflB02wQB4AEqhAQd55DlZjjdhbOtETAs2zoGp0mJKs4jdnFnwNDBAbMcdPqJIqF1uMg5IXyZK/AhzhmapJ9sYfq+vWdzDv1DaWCJbmHm1zBHImZzfFsuAUFfTBEy5XjM4+AkQ51VhOL01O9+lLFLLfuvjSr9hGwzG2K5N/Gf5ECxNvg0X2Vli0Wsp6wV7gl+ESY2bThNKBXPf0BW6lyumH2vTN0vodaUbqhsSosSttrYZ6wJ4xI1+rURrR707ByoenAUNFOFb29CwKUmFBnkJ8edNvrJh3cw+0KD9dfrC7rtTa1zekKiaD5h/Px3JP5MQVX3k2joH+jaTnh1ttdIZPzGS4bOMcKA+EC1uOw4ns77BG+p/m8n6wTb1gbbqoyWbrmqvLsAd8CSi8kPsKNnaEKsI0EcJ8MXtHRytAOcwqSiKiIwzNzY5Slwje7v/+2ZuMTGR2QMJtBhM8kMABDsvIfbIG5R0WMmNSZ707IbMI+pjYwqx0SgX2MHVNdZTqvLxIDVxwVZ41XhRpi0g0W0ZpEtfnDw08CGB3KA/bMMZhJH5IwJkjU3yGdSeAwDtZXeiIhKXmWvqsCs3MaGaF1+Y5/+X6kvZHA6U575rJo9yv1dBIrOZk612EMB9Ez/OZLglncs5EhvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] mm, swap: missing RCU protection in swap_put_entries_cluster()
  reclaim
- [High] mm, swap: xswap_unmap_clusters() skips RCU sync when vm_start
  >=3D vm_end
- [High] mm, swap: relocate_cluster() after lock drop re-adds freed
  cluster
- [High] mm, swap: unmapped xswap cluster_info access in swapin and
  table alloc paths
--

commit 167e6417672879cf6894286f3431ad8960ae663b
Author: Baoquan He <hebaoquan@kylinos.cn>

mm, swap: make xswap cluster_info accesses RCU-safe

This commit adds RCU read-side protection, per-CPU cluster cache flushing,
and acquire/release ordering on nr_clusters_mapped so that runtime xswap
shrinking can safely unmap cluster_info pages.

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 2624233b4fc28..bc30ab42203cc 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1239,6 +1239,9 @@ static unsigned long alloc_swap_scan_cluster(struct=
 swap_info_struct *si,
>  	lockdep_assert_held(&ci->lock);
>  	VM_WARN_ON(!cluster_is_usable(ci, order));
> =20
> +	/* ci is used without ci->lock; an xswap unmap waits for this. */
> +	rcu_read_lock();
> +
>  	if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER)
>  		goto out;
> =20
> @@ -1267,6 +1270,7 @@ static unsigned long alloc_swap_scan_cluster(struct=
 swap_info_struct *si,
>  out:
>  	relocate_cluster(si, ci);
>  	swap_cluster_unlock(ci);
> +	rcu_read_unlock();

[Severity: High]
Can relocate_cluster() re-add a cluster to si->free_clusters after it was
freed and isolated while ci->lock was dropped?

CPU0                                  CPU1
alloc_swap_scan_cluster()
  rcu_read_lock()
  cluster_reclaim_range()
    spin_unlock(&ci->lock)
    __try_to_reclaim_swap()
                                      /* last slot freed */
                                      __free_cluster()
                                        ci->table =3D NULL
                                        ci->flags =3D CLUSTER_FLAG_FREE
                                      /* shrink or swap_cluster_populate()
                                       * isolates ci from free_clusters */
                                      ci->flags =3D CLUSTER_FLAG_NONE
                                      xswap_unmap_clusters()
                                        synchronize_rcu()
    spin_lock(&ci->lock)
    /* !cluster_is_usable(ci) ->
     * *usable =3D false, goto out */
  relocate_cluster(si, ci)
    /* !ci->count &&
     * ci->flags !=3D CLUSTER_FLAG_FREE */
    free_cluster(si, ci)
      __free_cluster(si, ci)          <-- NULL deref or list corruption
  swap_cluster_unlock(ci)
  rcu_read_unlock()
                                        vm_area_unmap_pages()

When __free_cluster() runs a second time on a cluster whose table is already
NULL, swap_cluster_assert_empty() dereferences NULL under CONFIG_DEBUG_VM,
and move_cluster() links the isolated cluster back onto si->free_clusters
just before its backing page is unmapped.  swap_reclaim_full_clusters() has
the same issue at the end of its loop when checking ci->flags =3D=3D
CLUSTER_FLAG_NONE without verifying cluster_table_is_alloced(ci).

[ ... ]

> @@ -1310,6 +1314,9 @@ static void swap_reclaim_full_clusters(struct swap_=
info_struct *si, bool force)
>  		to_scan =3D swap_usage_in_pages(si) / SWAPFILE_CLUSTER;
> =20
>  	while ((ci =3D isolate_lock_cluster(si, &si->full_clusters))) {
> +		/* As in alloc_swap_scan_cluster(). */
> +		rcu_read_lock();
> +
>  		offset =3D cluster_offset(si, ci);
>  		end =3D min(si->max, offset + SWAPFILE_CLUSTER);
>  		to_scan--;
> @@ -1334,6 +1341,7 @@ static void swap_reclaim_full_clusters(struct swap_=
info_struct *si, bool force)
>  			relocate_cluster(si, ci);
> =20
>  		swap_cluster_unlock(ci);
> +		rcu_read_unlock();

[Severity: High]
Does swap_put_entries_cluster() need the same RCU protection around its
__try_to_reclaim_swap() loop?

mm/swapfile.c:swap_put_entries_cluster() {
    ...
	if (ci_batch !=3D -1)
		__swap_cluster_free_entries(si, ci, ci_batch, ci_off - ci_batch);
	swap_cluster_unlock(ci);

	if (!need_reclaim || !reclaim_cache)
		return;

	do {
		nr_reclaimed =3D __try_to_reclaim_swap(si, offset,
						     TTRS_UNMAPPED | TTRS_FULL);
		offset++;
		if (nr_reclaimed)
			offset =3D round_up(offset, abs(nr_reclaimed));
	} while (offset < end);
}

Callers such as shmem_free_swap() -> swap_put_entries_direct() invoke
swap_put_entries_cluster() in preemptible context outside RCU.  Once
__swap_cluster_put_entry() drops the swap count of cached slots to 0 and
swap_cluster_unlock(ci) releases ci->lock, concurrent reclaim can free the
swapcache folios and empty the cluster, allowing xswap to finish
synchronize_rcu() and unmap the cluster_info page before
__try_to_reclaim_swap() indexes si->cluster_info.

[ ... ]

> @@ -4289,12 +4333,33 @@ static void xswap_unmap_clusters(struct swap_info=
_struct *si,
> =20
>  	mutex_lock(&si->xswap_lock);
> =20
> +	/*
> +	 * Publish the smaller range before its memory goes away.  Readers
> +	 * that use nr_clusters_mapped without xswap_lock pair with this
> +	 * store using smp_load_acquire().
> +	 */
> +	smp_store_release(&si->nr_clusters_mapped, start_idx);
> +
>  	if (vm_start >=3D vm_end) {
> -		WRITE_ONCE(si->nr_clusters_mapped, start_idx);
> +		/*
> +		 * The clusters sit inside one page that the preceding
> +		 * cluster shares, so there is nothing to unmap.  The page
> +		 * goes away with that cluster; publishing the smaller
> +		 * cluster count is still correct.
> +		 */
>  		mutex_unlock(&si->xswap_lock);
>  		return;
>  	}

[Severity: High]
Can returning early when vm_start >=3D vm_end allow a subsequent xswap_grow=
()
to reinitialize ci->lock while an earlier RCU reader is still using it?

CPU0                                  CPU1
swap_alloc_fast()
  rcu_read_lock()
  mapped =3D smp_load_acquire(
             &si->nr_clusters_mapped)
                                      xswap_unmap_clusters(si, start_idx, n=
r)
                                        smp_store_release(
                                          &si->nr_clusters_mapped, start_id=
x)
                                        /* vm_start >=3D vm_end: skips
                                         * flush_percpu_swap_cluster() and
                                         * synchronize_rcu() */
                                      xswap_grow()
                                        xswap_map_clusters(si, start_idx, .=
..)
                                          /* page already mapped */
                                          spin_lock_init(&ci->lock)
  ci =3D swap_cluster_lock(si, offset)  <-- races with spin_lock_init()

Because struct swap_cluster_info (40 or 48 bytes) does not evenly divide
PAGE_SIZE, shrinking a range that shares its page with start_idx - 1 takes
the vm_start >=3D vm_end return without flushing percpu_swap_cluster or
waiting for RCU readers.  If xswap_grow() maps those clusters again while a
reader from before the shrink is still in flight (or using an unflushed
per-CPU cache entry), the mapped: path in xswap_map_clusters() runs
spin_lock_init(&ci->lock) concurrently with that reader.

> =20
> +	/*
> +	 * A per-cpu cluster cache can still hold an offset in this range.
> +	 * Invalidate those references, then wait out the readers that have
> +	 * already loaded one, so that nobody can dereference cluster_info
> +	 * past this point.  swapoff() needs the same before it releases.
> +	 */
> +	flush_percpu_swap_cluster(si);
> +	synchronize_rcu();

[Severity: High]
Can swapin and extend-table allocation paths still dereference an unmapped
cluster_info page across sleeping allocations where RCU is not held?

CPU0                                  CPU1
do_swap_page()
  pte_unmap_same() /* drops PTL */
  get_swap_device(entry)
  ...
  __swap_cache_alloc()
    spin_lock(&ci->lock)
    __swap_cache_add_check()
    spin_unlock(&ci->lock)
    folio_alloc_mpol() /* sleeps */
                                      /* entry freed (e.g. MADV_DONTNEED) */
                                      __free_cluster()
                                      xswap_unmap_clusters()
                                        synchronize_rcu()
                                        vm_area_unmap_pages()
    spin_lock(&ci->lock)              <-- page fault on unmapped ci

get_swap_device() only pins si->users, which does not block runtime xswap
shrinking.  Once the PTL is dropped in do_swap_page() (or the xarray lock in
shmem_swapin_folio()), a racing thread can free the swap entry and allow
xswap_unmap_clusters() to unmap the cluster_info page while CPU0 is
preempted before swap_cache_get_folio() or sleeping in __swap_cache_alloc().
The same race affects copy_pte_range() -> swap_retry_table_alloc() ->
swap_extend_table_alloc(), which drops the PTL, performs a GFP_KERNEL
kzalloc(), and then takes spin_lock(&ci->lock).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109055455.5369=
25-1-baoquan.he@linux.dev?part=3D15

