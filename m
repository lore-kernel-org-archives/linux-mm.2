Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C71E7606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 09:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ELv7Ev1D
Received: by kanga.kvack.org (Postfix)
	id B7A9D6B00EF; Sat, 21 Nov 2026 04:58:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADD716B05B0; Sat, 21 Nov 2026 04:58:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97D6A6B05B1; Sat, 21 Nov 2026 04:58:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 607A96B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 04:58:51 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52ED5A7EDD
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 09:58:49 +0000 (UTC)
X-FDA: 85458677178.27.670C84C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id A0BD61C0005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 09:58:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ELv7Ev1D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795255127;
	b=Ap4gKziUQnvfH76leRL584Z7h4wc7y+xuRlHf98PgtIytNHUFlvJDhY8yg1Dj9AG9qmO++
	xEvY0wmUNGKNbSp/U6qc5H85hEu+t7rKE0DIcl+C7Grsyc/5g5GWTGsbwn1fVDamWUH4sD
	jaIKkqSSvHH2Eriz2UGgcuuv+cClOCc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795255127;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9n/9RSoL8a6BaiduJ7G6AVsdcpa/1bimoadI5/sl0g=;
	b=iQWjino/XXe5UcXdKNtb3ryLLDiDmvE3A2l2JiaUycsb0Oi9vAAy+XfKxlZRrYLWozMy5i
	OOtDJFnVm5OU4W46jnfZuBOINyBrkGxD2LVshYccTyW0baj4D1+cboGGevS1AmlSVOhgh/
	E8CcANoGrTMrnw1Z0dlU826X9tqSE7Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ELv7Ev1D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98FF2435FA;
	Sat, 21 Nov 2026 09:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66B51F000C0;
	Sat, 21 Nov 2026 09:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795255126;
	bh=R9n/9RSoL8a6BaiduJ7G6AVsdcpa/1bimoadI5/sl0g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ELv7Ev1DQ6pUdmUv1HXpedPQaDCjWMQI/J/tcsAD/1incJ+fgRcrX5xTWrE8rV9Pb
	 dSjG5gTKZquuPy1+HlS4DiNzhR+OMWlVxjI46OQaGFA/yDbuBslV2VEw84dQw1tp+7
	 INvg4UPrEYVpbuIabGcTalH41NtVQGzEV6lsgq2rJOilmGTkDR7AAz5FFcuvBrM2St
	 ruehNCbsJ93M2t2e1z1kNigwvEsqZuxZmwNOt75/EVJKQDYIVeSSvZ1dVy9Qtq7pqo
	 SKYdslc2d2rCzXPOq0/jcL/gskkZVOrpfd68Q+/+T5UllBe6cfbSblM166ZPBrOlVY
	 05EaGOvJAx2XQ==
Message-ID: <sashiko-outbox-226889@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm: batch per-task lruvec stat updates on the writeback
 path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xavier Xia" <xavier.qyxia@gmail.com>, akpm@linux-foundation.org, hannes@cmpxchg.org, shakeel.butt@linux.dev
Cc: mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, willy@infradead.org, jack@suse.cz, david@kernel.org, brauner@kernel.org, linux-mm@kvack.org, tj@kernel.org, mkoutny@suse.com
In-Reply-To: <20261120095559.429515-1-xavier.qyxia@gmail.com>
References: <20261120095559.429515-1-xavier.qyxia@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 09:58:44 +0000
X-Stat-Signature: nfwfenexgzuie8ypx5na7sktg9fk5jjm
X-Rspamd-Queue-Id: A0BD61C0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795255127-802287
X-HE-Meta: U2FsdGVkX19RJ7jI+glarj1KS2Wfj804fwJzdR4aejMmcUw8Dwu87PxySDWbCfIL6NqRkhzlN+OB3a87mTrny8yXWnnNHgf4dFEQWKHHtAllYGnwPbNltcxEFqdK2mVgrgr2Cygb52BV0f7cJlXPKeJM6syhDnBpyn5UsKB9VfzOCDy8ofN8rneOao7NUed0NrLWpMs5KevvXRUXg2xDUyP3elSlWpnUlFl/sbf7aXD9APbqU6F6Uojpe2DSkE61RXeeZNce/bZ5XCozNAXcKE9tpyfzJjS6MGUhwnuvW13pWOgaLudYe03/8qKZ8F0MJqw1/2+lAyQCbFmAxPwUIUFSpHe1f8ZQa5WMAzEZIO3lr0OvInzRm5oMR/g+Sk3y8O2wSB8AbZj4+VwzErpWmNvVrtfoLK5ReXq63hirAsYzVfDV2Fx47VMmOACfmFfCZ4iT2JpNpcGWKkp0gsnSvT5zYxHuuJn95uSCQB29QdywQiKsXxbzUieMKI78pb5S6/rdoYa6cHmN+S9VJfcfdFI7loLwU6hs2ibQjBeS3HFW+rM23JLItJgRztfufszhnwTXajEX7CIMWloPAQKWCX5kW5UnVsY1mN0YfuOk6yoFKjJtGjI5otMr4biPaMxBpCTF8fvtSbx0cNBmHCeWHaPou0ULJHSg27IXRKpHoO87aG3wkM6HP/iRCZDT4LIO1ARC2Ge0MeT460oy7p8UHJoOgCYxgytBljjlp4j019ED/KMpoUtHOB35Jyg58WjcG8fGqmFfD7PTEQvpcjJ7oHMTqcalHcDDEz4QYkjKQnLu5xGU5pYqZ4uR/vKmbXOYz4QoP2KNiDI64PT3pgFnCIOn9SG0bLdRd5+tS85K1uBslRx3PZ/Qa60VrkqdLIBHtWIDaDgNKo9JfUXzhPYPHCeYCpMgVkrUzMQNiFa0b8rfwlARSDJq3O5JkXAVdMhp/c+9uv1E1v7kpRjJJrg
 q5cjfKyG
 ZZF0lPrjP/syIncej48BkqBsVtzlORcwye1G1NQcS217N8/M/yMROuN4zGOr6NxzG9j0GT5SULgQK2daltTmBLBTAPVImIa1LEqZvdR3yw6G5pgsdnUCOIiKKRKas4RGk8XBlEOj4Ja28/Q5lYLzQ+pAf+xicsvQjAe7UbPdLnl1abOPlR0FgzA5gotE/eV1NTk8vsdg4A1ExPphhGmB6ErNaULfFy8R3bkBMhmEWEtQ7uq7/7BYVVqrbn7iti8B8qp+hbPKCItMeGVkh2oal3xebbxYmbbWgQ7XP+Q3PRzoaj6Gkmn5NkqNhdLVhpvH54VlSYsTi1FuXT1Xp3fQMr0jRyPaYXp6+UMUDdtUt60PxWyugu0Flc/4CqykDimBuk0NLAqikz/F5TkbZAPmQI8PY3EZmOn0RuvQp2FExmvvLgV6Yr2lWXJAhwGuqNT5h1qaIsnCrq3iJkSJtey1emAQDYqhPkolXgQwqUVp3xuqcq19ZyHF6IHkOcLk2sAS36aasNiDlNWdavk7v/3sLvHaiHrcOV2PPHFU2kPOhW9gBSg/rLVtsFroVsXBwx4bfuKFJqqICi29raLZ3msSHam9WyEqqI7eNFUGN14JwaTvhyMG6MpUL5TrbR3z30vYMnk6LA4UO4fqLvhkPhJuo9dilNt5fed7/c+GL66Eaa77rH7SwZDfNDpIor5XpknlhK3q0EWOn4nADTKURcYqG8jNyrTSs/OHo97XWm9vN9gRpE0lfb4dCL6neSeBrjFIKdB7lsQ2qNABwmQLA7N/KtAQVPDLhj5HWa9Cj758w1la/CMVGs6R6cVvS0qrucYyoaYJbckKV1HJ1UfWJF001pXpcuLP+MpbsmbVHzi1Ouumw+fh0m7zcRLXfhcpiQ9KTzF7oBFIRb/nZFzk=
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
- [Medium] mm: misplaced dirty_stat_flush_current() in
  file_write_and_wait_range()
- [Medium] mm: unflushed stat_batch_mod() batches pin memcg CSS in idle
  kernel threads
- [Medium] mm: deferred positive stat_batch_mod() deltas cause node
  counter underflow
--

commit 511c77828659ec57163ac423dd938977a7ca7614
Author: Xavier Xia <xavier.qyxia@gmail.com>

mm: batch per-task lruvec stat updates on the writeback path

This commit batches per-task NR_FILE_DIRTY and NR_WRITEBACK lruvec stat
updates in task_struct up to 64 pages, flushing when switching lruvecs,
before dirty throttling, on writeback and task exit.

> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 15260cf2a29b0..46327617a7ad2 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -2491,6 +2491,9 @@ static long wb_do_writeback(struct bdi_writeback *w=
b)
>  	wrote +=3D wb_check_background_flush(wb);
>  	clear_bit(WB_writeback_running, &wb->state);
> =20
> +	/* Don't pin another cgroup's memcg via a pending batch while idle. */
> +	dirty_stat_flush_current();
> +
>  	return wrote;
>  }

[Severity: Medium]
Can kernel threads that start writeback outside wb_do_writeback() pin a
removed cgroup's mem_cgroup css in current->stat_batch_lruvec while idle?

For example, kswapd calls shrink_folio_list() -> pageout() ->
__swap_writeout() -> folio_start_writeback() -> stat_batch_mod(), which
takes a css_tryget(&memcg->css) reference on non-root memcgs, and then
sleeps in kswapd_try_to_sleep() without calling dirty_stat_flush_current().
The same happens in khugepaged via khugepaged_scan_mm_slot() ->
filemap_write_and_wait_range() and in the workqueue rescuer branch of
wb_workfn(), which calls writeback_inodes_wb() directly.

Also, inside wb_do_writeback(), dirty_stat_flush_current() runs after
finish_writeback_work() has already woken completion waiters and after
wb_writeback() and wb_check_background_flush() have checked
wb_over_bg_thresh() with the flusher's own negative NR_FILE_DIRTY batch
still unapplied.

[ ... ]

> diff --git a/mm/filemap.c b/mm/filemap.c
> index b04be64a5069f..d837371ae9880 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -781,6 +781,8 @@ int file_write_and_wait_range(struct file *file, loff=
_t lstart, loff_t lend)
>  	if (lend < lstart)
>  		return 0;
> =20
> +	dirty_stat_flush_current();
> +
>  	if (mapping_needs_writeback(mapping)) {
>  		err =3D filemap_fdatawrite_range(mapping, lstart, lend);
>  		/* See comment of filemap_write_and_wait() */

[Severity: Medium]
Should dirty_stat_flush_current() be called after writeback submission
(for example in filemap_writeback() after do_writepages()) rather than at
the entry of file_write_and_wait_range()?

Nothing in mapping_needs_writeback() or filemap_fdatawrite_range() reads
NR_FILE_DIRTY or NR_WRITEBACK, so flushing before
filemap_fdatawrite_range() only prevents a small write's positive
NR_FILE_DIRTY delta from cancelling with folio_clear_dirty_for_io()'s
negative delta.  During filemap_fdatawrite_range(), current runs
do_writepages() and buffers up to 64 pages of -NR_FILE_DIRTY and
+NR_WRITEBACK in current->stat_batch_dirty and
current->stat_batch_writeback while pinning memcg->css in
current->stat_batch_lruvec.  When __filemap_fdatawait_range() completes,
__folio_end_writeback() decrements NR_WRITEBACK directly, and
file_write_and_wait_range() returns with those deltas still unflushed and
the memcg pinned.  Sibling callers of filemap_writeback() such as
filemap_write_and_wait_range() and filemap_flush() do not flush at all.

> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 0694ec4098f6d..516a8bb028f85 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c

[ ... ]

> +static void stat_batch_mod(struct folio *folio, enum node_stat_item item,
> +			   long nr)
> +{
> +	struct task_struct *t =3D current;
> +	struct mem_cgroup *memcg;
> +	struct lruvec *lruvec;
> +	bool pinned;
> +	int *slot;
> +
> +	rcu_read_lock();
> +	memcg =3D folio_memcg(folio);
> +	/* An untracked folio has no lruvec, only a node. */
> +	if (!memcg) {
> +		rcu_read_unlock();
> +		mod_node_page_state(folio_pgdat(folio), item, nr);
> +		return;
> +	}
> +
> +	lruvec =3D mem_cgroup_lruvec(memcg, folio_pgdat(folio));
> +
> +	/* current is not the owner in interrupt context. */
> +	if (unlikely(!in_task() || nr > STAT_BATCH_MAX ||
> +		     nr < -STAT_BATCH_MAX)) {
> +		mod_lruvec_state(lruvec, item, nr);
> +		rcu_read_unlock();
> +		return;
> +	}
> +
> +	slot =3D item =3D=3D NR_FILE_DIRTY ?
> +		&t->stat_batch_dirty : &t->stat_batch_writeback;
> +
> +	if (likely(t->stat_batch_lruvec =3D=3D lruvec &&
> +		   *slot + nr <=3D STAT_BATCH_MAX &&
> +		   *slot + nr >=3D -STAT_BATCH_MAX)) {
> +		*slot +=3D nr;
> +		rcu_read_unlock();
> +		return;
> +	}

[Severity: Medium]
Can buffering positive NR_FILE_DIRTY and NR_WRITEBACK increments in
task_struct drive the node and memcg counters negative when the matching
decrements are applied unbatched?

When a task dirties up to 64 pages and truncates them,
__folio_cancel_dirty() -> folio_account_cleaned() subtracts NR_FILE_DIRTY
directly via lruvec_stat_mod_folio() while the positive increment is still
held in current->stat_batch_dirty; similarly, __folio_end_writeback()
subtracts NR_WRITEBACK directly while current->stat_batch_writeback holds
the positive increment.

On !CONFIG_SMP kernels with CONFIG_MEMCG=3Dy, global_node_page_state_pages(=
),
lruvec_page_state(), and memcg_page_state() compile out their negative-to-
zero clamp:

include/linux/vmstat.h:global_node_page_state_pages() {
	long x =3D atomic_long_read(&vm_node_stat[item]);
#ifdef CONFIG_SMP
	if (x < 0)
		x =3D 0;
#endif
	return x;
}

A negative counter then wraps to ~ULONG_MAX, corrupting dirty throttling
calculations in domain_dirty_avail() and balance_dirty_pages() as well as
reported stats.  Even on CONFIG_SMP, vmstat_refresh() only exempts
NR_WRITEBACK from negative-counter warnings and will warn on negative
vm_node_stat[NR_FILE_DIRTY], and cgroup v1 offline reparenting in
reparent_memcg_lruvec_state_local() clamps a dying child's negative local
counter to 0 while the task's later flush redirects its positive batch to
the parent via get_non_dying_memcg_start(), permanently inflating the
parent's local counter.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120095559.4295=
15-1-xavier.qyxia@gmail.com?part=3D1

