Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24DD9606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bqob7FZ9
Received: by kanga.kvack.org (Postfix)
	id 47DB16B05CE; Tue, 10 Nov 2026 00:58:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 454D36B05CF; Tue, 10 Nov 2026 00:58:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36C5E6B05D1; Tue, 10 Nov 2026 00:58:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F421E6B05CE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:58:10 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C4BBC0891
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:58:10 +0000 (UTC)
X-FDA: 85418153940.03.49315A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D5C7A20002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:58:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bqob7FZ9;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794290289;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPYJPMP/BH6aE3WYr34n15K2lh6Wwe+ptchX1xfAWSA=;
	b=3jAB1TNTRdbIGjezbbyLItT13Z+NH4L4UJxQMVDUPTRC+G57voDirTDpb9jnJZ26NAakgR
	nggeNN6OrQxApM30mPiPr9ZB6izHwIwOrSgYpakkSghKyy2/dbHS3kOuCbnqMO2c+XRL+e
	4LdFPA+jEblU7J4f+3qx/6t+gqqc+pk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794290289;
	b=gzWruRCx6cN6AQ1/VqVNabCETvkg7vbDSZ6APx019u+QT0Zd230leNwUlfhWDOK2e/4r1f
	ZoHHgF/uVmqi+dnB/2ls+Dv1td5/RjEYpNqcRi4y7rLRheM5AvpfJUGryIxzYVp7UwGkKz
	f5rmi56toacDnLWzaCtYa+KZauG88C0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bqob7FZ9;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3107341278;
	Tue, 10 Nov 2026 05:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD891F0089F;
	Tue, 10 Nov 2026 05:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794290288;
	bh=DPYJPMP/BH6aE3WYr34n15K2lh6Wwe+ptchX1xfAWSA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bqob7FZ9IvoDgHK/KwGpHdROeAAYANmEnwfe5pV36e5UuVT5DVAL5rfXY0WO4zWrq
	 /UNWavKfbgMImLAjeuhhtNSfOq1Y34ATl9+PuparRFVoJ2Bn3LhU6z5wUHZE/wzSOf
	 X18XQfKhFASjX+G9KugUCYtGtgFHvzqEjsP592iIz2+rEg6myEYh2huFGDtDpnLQqc
	 M3z3D6OoGfCe+yU6/UgS5bBmUIokV9xJ75IqC9Ph8Vkc2tqVA91CPJEoZTYuOn7xVi
	 4fRz5cxczUbx98W3Um6aw4wuJfNhCAtV1sm/WEOcnZXH+2CrMMVfUAAmXQBzMZlMW/
	 84H27CXLXXMUA==
Message-ID: <sashiko-outbox-206376@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 17/19] mm, swap: add xswap shrink trigger and defer
 it to a workqueue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baoquan He" <baoquan.he@linux.dev>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, david@kernel.org, chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, corbet@lwn.net, hannes@cmpxchg.org, chengming.zhou@linux.dev, kunwu.chan@gmail.com, klarasmodin@gmail.com, "Baoquan
 He" <hebaoquan@kylinos.cn>
In-Reply-To: <20261109055455.536925-18-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
 <20261109055455.536925-18-baoquan.he@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 05:58:06 +0000
X-Stat-Signature: she3twugsfa4gwqt4ue4cj8yn4di75nj
X-Rspamd-Queue-Id: D5C7A20002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794290288-173014
X-HE-Meta: U2FsdGVkX1/FgsZveLmH7A+JBr9YESMOuOb1n8UnJUN7gjc2TewmEpoA8Q4MFmwXR3SpsVK2Gc7BKRX0J5ARpK1qJpIT190/fY3xFmRdrzoT5RIaf4M4RG18rvWTaFt+BKDBNjYXrzkns0ytl1CsAL0BZkCkUaJTl3+RRJ2u7tqxvc3NlQWOzbDfvX1FSxcWm/lqmnwrYvQrMJq7eZ4be8vOZdyV+wdv4iWhjLqpqy88MZW7RPK1oVnexEYV6fko+NqNQihziCtNXHh0RzHubmWiGVOhCz5+BwNdkTNm685mrOYSwxAc1MhOZWR8Q+dJIEAczekw4F3q2w4QLsLQvbFQF+9jZQjCH4p9TDtdN66B2Qpl6Zc3uXYYn+XAPygsz2oJ/j2cBGmS9JQ7GbJ9smzQ4N3RHDoTCLMkYSnpQIWCFc6CKGO0wb3FQTrZS5vHysCYYU3ANa5FVIAlTyCrxBj9Nl9DGxzA0jd8f/1onXK621hLavaBjAKauGnDANzqi+ib2W7VbCtMv3iOczUXztX4n9EIjFGERxcpe9Ea79H7TE1ApRroRokdfTfLls8ImGsJ9melmtIlu3ncww3/EDS7uXZE2C4aOr94Dc9yVYmQ/OPSQ62NgaUh3JATDiDpIi1Okr6ToNACwWcZRXpAk6axWr/tsY7dHY6LB//1aomHJTSkkqF8blmjmxRVAo7gRItBdMa/xQW4huWATaxa4lrXSaU/PiMAuC9EbXSfk+ycM8GYHarkqUPi2Qz0IFaD8XCCgBw1iAp3mqAOacCTcjTXBvzd+Z7aMYbrT/AHlGLbkCaWcn2RJqdl14l8jO9CF8492kF4cKBE5vlu6F/GbzoXfXED+CFQFxVTPepF4b0K47tUbWc8zvhe2QAqe8zJHtyZnQmJ32wj4+nBqlbTdYzgJKWwZjGIhjd6VAQFlZscrRqlu/nGKuDEXVsq9aY48pnh8GxPUNlZAHLEmZT
 /J3Ofrxf
 Xye5xZJ0Z7QNh/QR3i2NgJuoUrDoo++tmsVPVzZ+A9VbZKPd6iFQdb0pafjNSJOyFC/53e711aC/DhU7s8/es6gglIvfVwKi2a/Gct/HLNHAFmZ8gGM/5VNZoz3JHrwh2Pgbl8wHFx7yEgyfkzPpJPU5cNI6ckkZr1ckQVcN3zPrOVFd+sjo2SnnFxAFlw43TwKaXgtPa/YV//gndSFXx+sibsPdVQPu8YKEOC7UKr+dtvW7Oc2h3OkN49aKYQVWgDsVoiFdpJ/M5/g6vzIFJvbMh9nRVVj7ZxT5tw/KO6K870p9xAb9hAbA5Pg6wndoaZ+UPrn879+8wj/c0Pu6x4cM6OI82Hi0mn+AFzf9yXumqLq8QzNoaqwKePpSFJS5P0wiLFvmLXVqprc9bBM+ZdS1Hii7+BMqVl2+yzoebKB9AVi/TcNg7rn6ZcoxOR83+H6wM2kiIqYvFixPGmOLbDJPurAHs62uckdFz+/7+7yvZySV1ZxvefsD+SbYQMD7buaVVe+Mzo037R5t3jRdW52jf3eDiFKB08TLfaax9vZnKo58lrcIKTOWGupWsSTwVVaix8VfMugK4Zb4V79Q8oHICmnxA4Y59lHMJedDIPkaU1eFr4YXZlx+qok7zeL4GGvJfooi24RWdNDs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] mm: use-after-unmap of cluster_info in swap paths when
  xswap_try_shrink() runs
- [High] mm: race in xswap_try_shrink() setting CLUSTER_FLAG_NONE
  re-adds unmapped cluster
- [Low] mm: redundant xswap_lock acquire in __swapoff() for non-existent
  sysfs shrink
--

commit ff41ecd0448adc3f4a51da2b8b59751cd899add3
Author: Baoquan He <hebaoquan@kylinos.cn>

mm, swap: add xswap shrink trigger and defer it to a workqueue

This commit adds deferred shrinking of the xswap cluster_info VM_SPARSE
mapping via a workqueue scheduled from __free_cluster().

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 097ed288b1ca1..2e5383036fdcb 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
[ ... ]
> @@ -3681,6 +3701,15 @@ static int __swapoff(struct swap_info_struct *p)
>  	struct file *swap_file =3D NULL;
>  	int err;
> =20
> +#ifdef CONFIG_XSWAP
> +	if (p->flags & SWP_XSWAP) {
> +		cancel_work_sync(&p->xswap_shrink_work);
> +		/* Wait out a shrink racing us from the sysfs write path. */
> +		mutex_lock(&p->xswap_lock);
> +		mutex_unlock(&p->xswap_lock);
> +	}
> +#endif

[Severity: Low]
This isn't a bug, but is the p->xswap_lock acquisition here needed?  There
is no sysfs write path that triggers a shrink, and cancel_work_sync() has
already waited for xswap_shrink_work after SWP_WRITEOK was cleared.

[ ... ]
> @@ -4413,6 +4452,153 @@ static int xswap_mapped_end(pte_t *pte, unsigned =
long addr, void *data)
[ ... ]
> +	spin_lock(&si->lock);
> +	for (i =3D start_idx; i < nr_mapped; i++) {
> +		ci =3D &si->cluster_info[i];
> +		if (READ_ONCE(ci->flags) !=3D CLUSTER_FLAG_FREE)
> +			break;
> +		if (!spin_trylock(&ci->lock)) {
> +			spin_unlock(&si->lock);
> +			goto out_unlock;
> +		}
> +		spin_unlock(&ci->lock);
> +	}
> +	if (i !=3D nr_mapped) {
> +		spin_unlock(&si->lock);
> +		goto out_unlock;
> +	}
> +
> +	for (i =3D start_idx; i < nr_mapped; i++) {
> +		ci =3D &si->cluster_info[i];
> +		list_del_init(&ci->list);
> +		WRITE_ONCE(ci->flags, CLUSTER_FLAG_NONE);
> +	}
> +	spin_unlock(&si->lock);

[Severity: High]
Can setting ci->flags to CLUSTER_FLAG_NONE cause a concurrent reclaimer to
re-add an unmapped cluster back onto si->free_clusters?

Both swap_reclaim_full_clusters() and cluster_reclaim_range() (called from
alloc_swap_scan_cluster()) isolate a cluster with ci->flags =3D=3D
CLUSTER_FLAG_NONE under rcu_read_lock(), temporarily drop ci->lock around
__try_to_reclaim_swap(), and then re-acquire ci->lock and call
relocate_cluster():

CPU0 (kworker)                    CPU1
xswap_try_shrink()
  flush_percpu_swap_cluster(si)
  synchronize_rcu()
                                  swap_reclaim_full_clusters()
                                    rcu_read_lock()
                                    isolate_lock_cluster()
                                      /* ci->flags =3D CLUSTER_FLAG_NONE */
                                    spin_unlock(&ci->lock)
                                    __try_to_reclaim_swap()
                                      /* frees last slot in ci: */
                                      __free_cluster(si, ci)
                                        /* ci->table =3D NULL */
                                        /* ci->flags =3D CLUSTER_FLAG_FREE =
*/
  spin_lock(&si->lock)
  /* sees CLUSTER_FLAG_FREE,
   * trylocks ci->lock */
  list_del_init(&ci->list)
  ci->flags =3D CLUSTER_FLAG_NONE
  spin_unlock(&si->lock)
  xswap_unmap_clusters_locked()
    synchronize_rcu()
                                    spin_lock(&ci->lock)
                                    if (ci->flags =3D=3D CLUSTER_FLAG_NONE)
                                      relocate_cluster(si, ci)
                                        if (!ci->count &&
                                            ci->flags !=3D CLUSTER_FLAG_FRE=
E)
                                          free_cluster(si, ci)
                                            __free_cluster(si, ci)
                                    spin_unlock(&ci->lock)
                                    rcu_read_unlock()
    /* unmaps and frees ci pages
     * while ci is on free_clusters */  <-- use-after-free

Because xswap_try_shrink() overwrote CLUSTER_FLAG_FREE with
CLUSTER_FLAG_NONE before waiting out the RCU grace period in
xswap_unmap_clusters_locked(), relocate_cluster() sees !ci->count and
ci->flags !=3D CLUSTER_FLAG_FREE and calls __free_cluster() a second time.
With CONFIG_DEBUG_VM=3Dy, swap_cluster_assert_empty() immediately
dereferences the NULL ci->table; otherwise move_cluster() links ci back
onto si->free_clusters just before its backing pages are unmapped and
freed.

> +
> +	/*
> +	 * A cluster can be taken and freed between the recheck above and the
> +	 * unmap, putting it back in the per-cpu cache.  Drain and wait again.
> +	 */
> +	xswap_unmap_clusters_locked(si, start_idx, nr_unmap, true);
> +	atomic_long_inc(&si->xswap_shrinks);

[Severity: High]
Can unmapping cluster_info pages at runtime while si->users is live cause
a kernel page fault in swap paths that access si->cluster_info outside
rcu_read_lock()?

Several swap paths rely on get_swap_device() pinning si->users to keep
si->cluster_info mapped across preemptible or sleepable sections where
neither ci->lock nor rcu_read_lock() is held.  For example, in
do_swap_page() -> folio_alloc_swap() -> __swap_cache_alloc(), or in
swap_put_entries_cluster():

mm/swapfile.c:swap_put_entries_cluster() {
    ...
	swap_cluster_unlock(ci);

	if (!need_reclaim || !reclaim_cache)
		return;

	do {
		nr_reclaimed =3D __try_to_reclaim_swap(si, offset,
						     TTRS_UNMAPPED | TTRS_FULL);
    ...
}

Once swap_put_entries_cluster() drops ci->lock in task context outside
rcu_read_lock() after decrementing a cached slot's swap count to 0,
another CPU can reclaim the swapcache folio and free the tail cluster:

CPU0                              CPU1 (kworker)
swap_put_entries_cluster()
  /* decrements swap count to 0 */
  swap_cluster_unlock(ci)
                                  /* folio_free_swap() frees last slot
                                   * in tail cluster -> __free_cluster() */
                                  xswap_try_shrink()
                                    flush_percpu_swap_cluster(si)
                                    synchronize_rcu()
                                    /* unlinks FREE tail clusters */
                                    xswap_unmap_clusters_locked()
                                      synchronize_rcu()
                                      xswap_unmap_range()
  __try_to_reclaim_swap()
    swap_cache_get_folio()
      __swap_entry_to_cluster()
        swap_table_get(ci, ...)   <-- page fault on unmapped cluster_info

The same window exists when __swap_cache_alloc() drops ci->lock to sleep
in folio allocation and then calls spin_lock(&ci->lock), or when
swap_extend_table_alloc() sleeps in kzalloc() before locking ci->lock, if
the swap entry and its tail cluster are freed concurrently.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109055455.5369=
25-1-baoquan.he@linux.dev?part=3D17

