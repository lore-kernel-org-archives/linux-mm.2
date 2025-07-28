Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B7DC83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 22:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48FAA6B008A; Mon, 28 Jul 2025 18:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467A86B008C; Mon, 28 Jul 2025 18:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A4446B0092; Mon, 28 Jul 2025 18:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5D46B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 18:03:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A89AD160227
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 22:03:02 +0000 (UTC)
X-FDA: 83715049404.23.09C64A2
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf26.hostedemail.com (Postfix) with ESMTP id C518B14000B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 22:03:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qlU5XJqj;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753740180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FdxS+7kCDXvu8++0CCJfTtdZMISHX5BtUVb0h12Qo8=;
	b=VvHX4k8ruknpBtebT7MIBbmoWpSg1Mh9UISYqqigtyC/w9bYqTfUa+BqYgQUntpFlRgSIh
	TzHBF45DSQZQPNnJ97nA6pSJm6XFpuyfhVvEpQ89qkGhSrWK2+Xr5kMsWT1jQmvnr2NVl+
	+nqDcbfagIgQnlkgA5kF5TeLBpSdeMI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753740180; a=rsa-sha256;
	cv=none;
	b=OrEKFO7SpPySKnIm3iSybF2tqyqWwjCGectYnbpzSePc9V/Vj71yXzlv09vkstXaTIOlrl
	z6dezunLedAa5xw4wxNbBGTMnfWS+DPys9C9fYCmpsqTojnBEm7Fj66KbtbBDGBb6iAMY7
	sY5IYELrzdpoBgkRyrkzPzM6aW23T5U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qlU5XJqj;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 88A6F5C6266;
	Mon, 28 Jul 2025 22:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68EDC4CEE7;
	Mon, 28 Jul 2025 22:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753740179;
	bh=LDH/rs291z2S/SYuUW3fXnmnbWkFpDl2lT7Ntr+CYX0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qlU5XJqjrnuZquS8V78tNiqoYQMz8RZ3mC0qdcaposyqAb+jg9FoyJmAawXtGMCjr
	 ncup94iwTCbXiJv5wNuuUqVQ4tHHimkVsebpVCOK7WW3/YHnyMJssY4t9d2FO5oXRl
	 IQPes7E64cW8ihhuW//KY086C/6WtF0jJYWG/82g=
Date: Mon, 28 Jul 2025 15:02:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kairui Song <kasong@tencent.com>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, Hugh Dickins
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Matthew
 Wilcox <willy@infradead.org>, Kemeng Shi <shikemeng@huaweicloud.com>, Chris
 Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/8] mm/shmem, swap: bugfix and improvement of mTHP
 swap in
Message-Id: <20250728150258.4cba730ba36da5cce659d067@linux-foundation.org>
In-Reply-To: <20250728075306.12704-1-ryncsn@gmail.com>
References: <20250728075306.12704-1-ryncsn@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C518B14000B
X-Stat-Signature: idwssn4657rnjiumt7646oj163p8rju6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753740180-158713
X-HE-Meta: U2FsdGVkX18f7kamSJtbEEqzjJobmugJhTsYhrGVhrAYn0gT0PRtEkT+biJ6SIFRA7vQ31eHJwyi3/ynFmxzDvIzXbopOWtCQ/qE4xpDk8p1PRlAOM1cezgvEk8CtYldFegizsW/BpmHUztYBIf88kmLp34bIK1S6nkA2O+fj5rEcQJOZXMLTFaZtgtfoJzjjWJYy0dq+tdkms2pffoPsTXwpVlGET9nlNIjo4GopQlbTqsZc511rkOnslfpOJ86uNrEiK2FkGT/Mc8PYJa0bBc5osg5l50l9gaCGUnsB5d9v/JldxVKk5kmVmca5xaDLyTiYSMWKDgbYhg0phyJLO9i70A9bAClfO+zasLh19FErXZsPbVKhsbAJjQmTODc7hDq1nPmYZoII+3tabvpRv6hnOBxWOWUD21yCC37WpM3636Wro+qAx4gCR0f1bgPl3ai1R3wp3axx/Y9EzxfiJeFNEA//vxNBBxWOR475b3KsuUc0UGwwS7vu6T3IAy+MrRwTYkaxCx/NTvt0sIbuM/ST+ypG2aTlIJD6WjcE6I0PnFQP58mxk8wj2BmMalE1YODo7wUoz7TqCPKnnHiMaZbiwIR07S4qNDtCh7lsHeKiinlJKzDH8YeYcZKF98iTZPhHhktPW6YYcW7Gp8UD/g59XU8OjI+ziO8XIBP4UraWLY9xObmQqcGcl6NsLnYiNS5c7no/MCtNmC7NgZOW7DiprSCRd2Bxs15+9p3wf+IGqiUNQT1W8rk7P4q/Za0C9cUi/ZqM0JFeffnU+mubbGGfRzIBHa/c9t9e/FOGZ4l+PpKHqRnwt4zmYchqvdMkvbWP//PUGhGphn1QOsd4KzNQH8/xvWOxJ6FAfoVGsAz56OKo38a+IMTgYJ195Q1NNUr1gdhDqVSZJ4Sk1Z0qJ4BZOrW+j/iybar7yvugpdPviP7vB9vc+AgE7kR7S1z71iBwhKcSSuPQsHaaCD
 5eovJ8TB
 p/MNncWM35GSiGkX6d58OWqt0w1LXDcto8fGy/q3Uq+YZJhtjXnO3xc/nMFWCFAO8KlQPx29ovBohDUtxxnh10qZVhCVGe0w9HK7UJBsyBoNtUk9eTRPSQEXT5NO7nCgAYrDTJXjv2a8KZJ7BfoPdrdSJBZnU7I4jGMHQoqp31hknw8hljsc9s7xuRP51DappHMcoCg5c5doRiGA4Xh2p1TThRQ/VErEQgcdV+RF+1X1OzHHa7yhr712CyC64a5BE/di+C9ov1k2E4hDPz9Ljhy3h9SzXdA0yNwfyT4W7gS165eg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Jul 2025 15:52:58 +0800 Kairui Song <ryncsn@gmail.com> wrote:

> From: Kairui Song <kasong@tencent.com>
> 
> The current THP swapin path have several problems. It may potentially
> hang, may cause redundant faults due to false positive swap cache lookup,
> and it issues redundant Xarray walks. !CONFIG_TRANSPARENT_HUGEPAGE
> builds may also contain unnecessary THP checks.
> 
> This series fixes all of the mentioned issues, the code should be more
> robust and prepared for the swap table series. Now 4 walks is reduced
> to 3 (get order & confirm, confirm, insert folio), !CONFIG_TRANSPARENT_HUGEPAGE
> build overhead is also minimized, and comes with a sanity check now.
> 

Below are the changes since v5 of this series.  It's a lot, and we're
now in the merge window.

So I'll merge this into mm.git's mm-new branch.  After -rc1 I'll move
them into mm-unstable, targeting a 6.18-rc1 merge.  However at that
time I'll move the [1/N] patch (which has cc:stable) into mm-hotfixes,
planning to merge that into 6.17-rcX.

Does this sound OK?


 mm/shmem.c |  277 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 153 insertions(+), 124 deletions(-)

--- a/mm/shmem.c~new
+++ a/mm/shmem.c
@@ -512,15 +512,27 @@ static int shmem_replace_entry(struct ad
 
 /*
  * Sometimes, before we decide whether to proceed or to fail, we must check
- * that an entry was not already brought back from swap by a racing thread.
+ * that an entry was not already brought back or split by a racing thread.
  *
  * Checking folio is not enough: by the time a swapcache folio is locked, it
  * might be reused, and again be swapcache, using the same swap as before.
+ * Returns the swap entry's order if it still presents, else returns -1.
  */
-static bool shmem_confirm_swap(struct address_space *mapping,
-			       pgoff_t index, swp_entry_t swap)
+static int shmem_confirm_swap(struct address_space *mapping, pgoff_t index,
+			      swp_entry_t swap)
 {
-	return xa_load(&mapping->i_pages, index) == swp_to_radix_entry(swap);
+	XA_STATE(xas, &mapping->i_pages, index);
+	int ret = -1;
+	void *entry;
+
+	rcu_read_lock();
+	do {
+		entry = xas_load(&xas);
+		if (entry == swp_to_radix_entry(swap))
+			ret = xas_get_order(&xas);
+	} while (xas_retry(&xas, entry));
+	rcu_read_unlock();
+	return ret;
 }
 
 /*
@@ -891,7 +903,9 @@ static int shmem_add_to_page_cache(struc
 				   pgoff_t index, void *expected, gfp_t gfp)
 {
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
-	long nr = folio_nr_pages(folio);
+	unsigned long nr = folio_nr_pages(folio);
+	swp_entry_t iter, swap;
+	void *entry;
 
 	VM_BUG_ON_FOLIO(index != round_down(index, nr), folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -903,14 +917,25 @@ static int shmem_add_to_page_cache(struc
 
 	gfp &= GFP_RECLAIM_MASK;
 	folio_throttle_swaprate(folio, gfp);
+	swap = radix_to_swp_entry(expected);
 
 	do {
+		iter = swap;
 		xas_lock_irq(&xas);
-		if (expected != xas_find_conflict(&xas)) {
-			xas_set_err(&xas, -EEXIST);
-			goto unlock;
+		xas_for_each_conflict(&xas, entry) {
+			/*
+			 * The range must either be empty, or filled with
+			 * expected swap entries. Shmem swap entries are never
+			 * partially freed without split of both entry and
+			 * folio, so there shouldn't be any holes.
+			 */
+			if (!expected || entry != swp_to_radix_entry(iter)) {
+				xas_set_err(&xas, -EEXIST);
+				goto unlock;
+			}
+			iter.val += 1 << xas_get_order(&xas);
 		}
-		if (expected && xas_find_conflict(&xas)) {
+		if (expected && iter.val - nr != swap.val) {
 			xas_set_err(&xas, -EEXIST);
 			goto unlock;
 		}
@@ -1992,30 +2017,47 @@ static struct folio *shmem_swap_alloc_fo
 		swp_entry_t entry, int order, gfp_t gfp)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	int nr_pages = 1 << order;
 	struct folio *new;
+	gfp_t alloc_gfp;
 	void *shadow;
-	int nr_pages;
 
 	/*
 	 * We have arrived here because our zones are constrained, so don't
 	 * limit chance of success with further cpuset and node constraints.
 	 */
 	gfp &= ~GFP_CONSTRAINT_MASK;
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && order > 0) {
-		gfp_t huge_gfp = vma_thp_gfp_mask(vma);
-
-		gfp = limit_gfp_mask(huge_gfp, gfp);
+	alloc_gfp = gfp;
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		if (WARN_ON_ONCE(order))
+			return ERR_PTR(-EINVAL);
+	} else if (order) {
+		/*
+		 * If uffd is active for the vma, we need per-page fault
+		 * fidelity to maintain the uffd semantics, then fallback
+		 * to swapin order-0 folio, as well as for zswap case.
+		 * Any existing sub folio in the swap cache also blocks
+		 * mTHP swapin.
+		 */
+		if ((vma && unlikely(userfaultfd_armed(vma))) ||
+		     !zswap_never_enabled() ||
+		     non_swapcache_batch(entry, nr_pages) != nr_pages)
+			goto fallback;
+
+		alloc_gfp = limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
+	}
+retry:
+	new = shmem_alloc_folio(alloc_gfp, order, info, index);
+	if (!new) {
+		new = ERR_PTR(-ENOMEM);
+		goto fallback;
 	}
 
-	new = shmem_alloc_folio(gfp, order, info, index);
-	if (!new)
-		return ERR_PTR(-ENOMEM);
-
-	nr_pages = folio_nr_pages(new);
 	if (mem_cgroup_swapin_charge_folio(new, vma ? vma->vm_mm : NULL,
-					   gfp, entry)) {
+					   alloc_gfp, entry)) {
 		folio_put(new);
-		return ERR_PTR(-ENOMEM);
+		new = ERR_PTR(-ENOMEM);
+		goto fallback;
 	}
 
 	/*
@@ -2030,7 +2072,9 @@ static struct folio *shmem_swap_alloc_fo
 	 */
 	if (swapcache_prepare(entry, nr_pages)) {
 		folio_put(new);
-		return ERR_PTR(-EEXIST);
+		new = ERR_PTR(-EEXIST);
+		/* Try smaller folio to avoid cache conflict */
+		goto fallback;
 	}
 
 	__folio_set_locked(new);
@@ -2044,6 +2088,15 @@ static struct folio *shmem_swap_alloc_fo
 	folio_add_lru(new);
 	swap_read_folio(new, NULL);
 	return new;
+fallback:
+	/* Order 0 swapin failed, nothing to fallback to, abort */
+	if (!order)
+		return new;
+	entry.val += index - round_down(index, nr_pages);
+	alloc_gfp = gfp;
+	nr_pages = 1;
+	order = 0;
+	goto retry;
 }
 
 /*
@@ -2249,7 +2302,7 @@ unlock:
 	if (xas_error(&xas))
 		return xas_error(&xas);
 
-	return entry_order;
+	return 0;
 }
 
 /*
@@ -2266,133 +2319,109 @@ static int shmem_swapin_folio(struct ino
 	struct address_space *mapping = inode->i_mapping;
 	struct mm_struct *fault_mm = vma ? vma->vm_mm : NULL;
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	swp_entry_t swap, index_entry;
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
 	bool skip_swapcache = false;
-	swp_entry_t swap;
-	int error, nr_pages, order, split_order;
+	int error, nr_pages, order;
+	pgoff_t offset;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
-	swap = radix_to_swp_entry(*foliop);
+	index_entry = radix_to_swp_entry(*foliop);
+	swap = index_entry;
 	*foliop = NULL;
 
-	if (is_poisoned_swp_entry(swap))
+	if (is_poisoned_swp_entry(index_entry))
 		return -EIO;
 
-	si = get_swap_device(swap);
-	if (!si) {
-		if (!shmem_confirm_swap(mapping, index, swap))
+	si = get_swap_device(index_entry);
+	order = shmem_confirm_swap(mapping, index, index_entry);
+	if (unlikely(!si)) {
+		if (order < 0)
 			return -EEXIST;
 		else
 			return -EINVAL;
 	}
+	if (unlikely(order < 0)) {
+		put_swap_device(si);
+		return -EEXIST;
+	}
+
+	/* index may point to the middle of a large entry, get the sub entry */
+	if (order) {
+		offset = index - round_down(index, 1 << order);
+		swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
+	}
 
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
-	order = xa_get_order(&mapping->i_pages, index);
 	if (!folio) {
-		int nr_pages = 1 << order;
-		bool fallback_order0 = false;
-
-		/* Or update major stats only when swapin succeeds?? */
+		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
+			/* Direct swapin skipping swap cache & readahead */
+			folio = shmem_swap_alloc_folio(inode, vma, index,
+						       index_entry, order, gfp);
+			if (IS_ERR(folio)) {
+				error = PTR_ERR(folio);
+				folio = NULL;
+				goto failed;
+			}
+			skip_swapcache = true;
+		} else {
+			/* Cached swapin only supports order 0 folio */
+			folio = shmem_swapin_cluster(swap, gfp, info, index);
+			if (!folio) {
+				error = -ENOMEM;
+				goto failed;
+			}
+		}
 		if (fault_type) {
 			*fault_type |= VM_FAULT_MAJOR;
 			count_vm_event(PGMAJFAULT);
 			count_memcg_event_mm(fault_mm, PGMAJFAULT);
 		}
+	}
 
+	if (order > folio_order(folio)) {
 		/*
-		 * If uffd is active for the vma, we need per-page fault
-		 * fidelity to maintain the uffd semantics, then fallback
-		 * to swapin order-0 folio, as well as for zswap case.
-		 * Any existing sub folio in the swap cache also blocks
-		 * mTHP swapin.
-		 */
-		if (order > 0 && ((vma && unlikely(userfaultfd_armed(vma))) ||
-				  !zswap_never_enabled() ||
-				  non_swapcache_batch(swap, nr_pages) != nr_pages))
-			fallback_order0 = true;
-
-		/* Skip swapcache for synchronous device. */
-		if (!fallback_order0 && data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
-			folio = shmem_swap_alloc_folio(inode, vma, index, swap, order, gfp);
-			if (!IS_ERR(folio)) {
-				skip_swapcache = true;
-				goto alloced;
-			}
-
-			/*
-			 * Fallback to swapin order-0 folio unless the swap entry
-			 * already exists.
-			 */
-			error = PTR_ERR(folio);
-			folio = NULL;
-			if (error == -EEXIST)
-				goto failed;
-		}
-
-		/*
-		 * Now swap device can only swap in order 0 folio, then we
-		 * should split the large swap entry stored in the pagecache
-		 * if necessary.
-		 */
-		split_order = shmem_split_large_entry(inode, index, swap, gfp);
-		if (split_order < 0) {
-			error = split_order;
-			goto failed;
-		}
-
-		/*
-		 * If the large swap entry has already been split, it is
-		 * necessary to recalculate the new swap entry based on
-		 * the old order alignment.
-		 */
-		if (split_order > 0) {
-			pgoff_t offset = index - round_down(index, 1 << split_order);
-
-			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
-		}
-
-		/* Here we actually start the io */
-		folio = shmem_swapin_cluster(swap, gfp, info, index);
-		if (!folio) {
-			error = -ENOMEM;
-			goto failed;
-		}
-	} else if (order != folio_order(folio)) {
-		/*
-		 * Swap readahead may swap in order 0 folios into swapcache
+		 * Swapin may get smaller folios due to various reasons:
+		 * It may fallback to order 0 due to memory pressure or race,
+		 * swap readahead may swap in order 0 folios into swapcache
 		 * asynchronously, while the shmem mapping can still stores
 		 * large swap entries. In such cases, we should split the
 		 * large swap entry to prevent possible data corruption.
 		 */
-		split_order = shmem_split_large_entry(inode, index, swap, gfp);
-		if (split_order < 0) {
-			folio_put(folio);
-			folio = NULL;
-			error = split_order;
-			goto failed;
-		}
-
-		/*
-		 * If the large swap entry has already been split, it is
-		 * necessary to recalculate the new swap entry based on
-		 * the old order alignment.
-		 */
-		if (split_order > 0) {
-			pgoff_t offset = index - round_down(index, 1 << split_order);
+		error = shmem_split_large_entry(inode, index, index_entry, gfp);
+		if (error)
+			goto failed_nolock;
+	}
 
-			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
-		}
+	/*
+	 * If the folio is large, round down swap and index by folio size.
+	 * No matter what race occurs, the swap layer ensures we either get
+	 * a valid folio that has its swap entry aligned by size, or a
+	 * temporarily invalid one which we'll abort very soon and retry.
+	 *
+	 * shmem_add_to_page_cache ensures the whole range contains expected
+	 * entries and prevents any corruption, so any race split is fine
+	 * too, it will succeed as long as the entries are still there.
+	 */
+	nr_pages = folio_nr_pages(folio);
+	if (nr_pages > 1) {
+		swap.val = round_down(swap.val, nr_pages);
+		index = round_down(index, nr_pages);
 	}
 
-alloced:
-	/* We have to do this with folio locked to prevent races */
+	/*
+	 * We have to do this with the folio locked to prevent races.
+	 * The shmem_confirm_swap below only checks if the first swap
+	 * entry matches the folio, that's enough to ensure the folio
+	 * is not used outside of shmem, as shmem swap entries
+	 * and swap cache folios are never partially freed.
+	 */
 	folio_lock(folio);
 	if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
-	    folio->swap.val != swap.val ||
-	    !shmem_confirm_swap(mapping, index, swap) ||
-	    xa_get_order(&mapping->i_pages, index) != folio_order(folio)) {
+	    shmem_confirm_swap(mapping, index, swap) < 0 ||
+	    folio->swap.val != swap.val) {
 		error = -EEXIST;
 		goto unlock;
 	}
@@ -2415,8 +2444,7 @@ alloced:
 			goto failed;
 	}
 
-	error = shmem_add_to_page_cache(folio, mapping,
-					round_down(index, nr_pages),
+	error = shmem_add_to_page_cache(folio, mapping, index,
 					swp_to_radix_entry(swap), gfp);
 	if (error)
 		goto failed;
@@ -2439,18 +2467,19 @@ alloced:
 	*foliop = folio;
 	return 0;
 failed:
-	if (!shmem_confirm_swap(mapping, index, swap))
+	if (shmem_confirm_swap(mapping, index, swap) < 0)
 		error = -EEXIST;
 	if (error == -EIO)
 		shmem_set_folio_swapin_error(inode, index, folio, swap,
 					     skip_swapcache);
 unlock:
-	if (skip_swapcache)
-		swapcache_clear(si, swap, folio_nr_pages(folio));
-	if (folio) {
+	if (folio)
 		folio_unlock(folio);
+failed_nolock:
+	if (skip_swapcache)
+		swapcache_clear(si, folio->swap, folio_nr_pages(folio));
+	if (folio)
 		folio_put(folio);
-	}
 	put_swap_device(si);
 
 	return error;
_


