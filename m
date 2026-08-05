Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BE7FC56201
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A6356B00AA; Wed,  5 Aug 2026 03:54:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57D556B00AB; Wed,  5 Aug 2026 03:54:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492BA6B00AC; Wed,  5 Aug 2026 03:54:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1506D6B00AA
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:54:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB9FF803BF
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:54:29 +0000 (UTC)
X-FDA: 85066453458.07.CA20198
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id B5DF840006
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:54:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fP8B4IaP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785916467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XpLCIEmlJUyWy6CaqTAtX3ScpMnuNBCh2QJ/2LrzeSU=;
	b=uWgGqBbT5aj1D9+lIt6aED4bXRW16Ibzi57fgV5A3m3F+MKsi3fVU+/pkMJ6SSrQTh9TrR
	PuGkHOb4BhoZWrakltIuZcAi19twOSnOBJz991tPM00QSEZ/qlFgzk7giHVZxOAYXkZf5y
	OOBkdRJiHiY8iBfVYTjUZ5Yd/Ijqqtk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fP8B4IaP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785916467;
	b=K8fCIjR3NkCeM4JNxDxfDho41us3I7X5hsyINnScPKdxsYnNUOxL1K/3p/SSNNxL/0yN/g
	teG8LuC2luJFKjMcJTh8uyY1AMu/3EI0WclXbNJpQXpHad90eKwEOWG2hPKOiz8gLWeCVp
	T+USvVY+PLy78w7zTZR1cfU6I5XzZyE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785916466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XpLCIEmlJUyWy6CaqTAtX3ScpMnuNBCh2QJ/2LrzeSU=;
	b=fP8B4IaPHFP1GjMdG9SHR1R6wSCWK42Uq8FnfQxxybz5rUrSwg6TyTomvz/tmRjvsXGbWp
	AZ+0rZurfV8VxOZs2EI0+H8SAjovddBweoba2G2ZTeF9y6AzYyJb4nO3KcHiUQA0j/nO+s
	Hoy3fXQiZaEADvfHxCHfIKuB9vq4hlc=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	david@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH v2 04/10] mm, swap: add xswap grow trigger on cluster allocation
Date: Wed,  5 Aug 2026 15:53:27 +0800
Message-ID: <20260805075336.3579395-5-baoquan.he@linux.dev>
In-Reply-To: <20260805075336.3579395-1-baoquan.he@linux.dev>
References: <20260805075336.3579395-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: t3cmmufgxd6g9g8tryez3w34ckyc67t4
X-Rspamd-Queue-Id: B5DF840006
X-HE-Tag: 1785916467-758545
X-HE-Meta: U2FsdGVkX1+aLHYjOnYd2sVdmJ/s/xuTOHDFLFekgurZfnPyOfD2QVK6UznKb+wOEtSjgDqVXc0Pnk4HfgitcpQuplG5PwuhsfCE1mfqdbVw0XRntORtAbX34gBvvK3fFT0v5jwxIdK9R6I3BETCVFO0iE4JMgIb1BeCF9xfuvJtCtBcFfdoMXZ9qRSvWCzAqowhABNyLQ055YwgoJgsp9LTWr2cIvtHKksGcpDflsNOA9fUJrbV97zBVoMAXMb7ycaNM5cPYnGGf8habRylPNpM6pR8qBfAKKk7+596QKowYWkWOwZB3CJ39LiGVIVpFmC6r7H2KdQhu3Snq4hhsQqoP6misNBExuZbgOAt/jA4jiN7vaAcsjG0sRGqG0iBr4XX1Oe+H90mMrbkFOepiJBECGvhZeWqRTCGH+0n5XhU+k3Wi8Di/f/Og9kLEy3P1AWRsxqS8F76/qc7B9hWuMmzSVCd3JkCKfJlpWn76kPV5j/iU3Lzzq0tsbv4wvu3CXurIxbjxu7AcSnjmoeg9z1Q9ahmpv1wnVKNp/3SE2UANd6rbXtn/l1rrJMY2WPJeQmQ6K9PjrfypTUInOmSN3Xea8ivpJZL2GnZHg4Vs35CLgs6g6O9WJjzBoJ7XcGgnllD0XIz39sfAZe224IP82b+yzITFhSABdXobhg13OavH6SUT5g8LElE8cUWpDDVi+GD1CnFTx1UGA6xp55Tg7Ao2MPkzyvTp2THetT8khp13abGhox9bhuYoXbF0ozwNmHz+kzpeE6/u8d74vQQKdUzzyIRTUp5oWTI2YyXyXlLW/QtaZR1H3O5efRGewh3ZyPQ+nEDtwdz4eGLBKgSxJVW+OjGs17IxixSL9jh7rNMRMOiEdIXuUt6UacM9I9L0sqZa5goE3LSNzZHYCJbSZRypSklh8e+jj2o9vXv8ltvtnAFv7Lk6vxgTzwW/HMi+3eaM6q8063DXKfgyTH
 gzXIvpJU
 D4wcnlPn+waO3MHW4aLvc5gUQ53IfLJrE4uoGrHiBzAvvgSACY9OjUrl0Dem0BzXov8iG3fs3HDiqtpeoVEMUWDYE9gZJwFtjzLd0pBxecEEJlNgpBJF+F3eqVXBpHlhtdmhGCpqlIDOGzDc8FnJYUBgzv57IW7dPGGXiL6rRXtKbnFstenWTQeKx7MjCr29ZSl/nPQmzi18RBQ49tO1paMZGEDFBM5VOBxYr5BjvELDFq1KZ3AXeZo8425o7iGQjkuH+u2rKPAEV4AqJtvvZjSh0uG3mqTJtda3/l0IN3Qo4tNo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When cluster_alloc_swap_entry() fails to find a free cluster and
the xswap device still has room to grow, expand the mapped range
by XSWAP_GROW_CLUSTERS clusters.

Since xswap is always SWP_SOLIDSTATE, no locks need to be dropped
before calling xswap_map_clusters() — global_cluster_lock is never
held on this path.

The grow sequence:
1. Check nr_clusters_mapped < nr_clusters and free list empty
2. Call xswap_map_clusters() to allocate and map more physical pages
3. Add newly mapped clusters to si->free_clusters under si->lock
4. Retry allocation from the fresh free clusters

This makes the xswap cluster space grow transparently as swap usage
increases, without any userspace intervention.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/swapfile.c | 101 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 100 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 37c5dca153bc..5d8e10be0159 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -65,6 +65,7 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 			      unsigned long start_idx, unsigned long nr);
 static void xswap_unmap_clusters(struct swap_info_struct *si,
 				 unsigned long start_idx, unsigned long nr);
+static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data);
 #endif
 
 static void swap_range_alloc(struct swap_info_struct *si,
@@ -1204,6 +1205,48 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		if (found)
 			goto done;
 	}
+
+#ifdef CONFIG_XSWAP
+	/*
+	 * For xswap: if no free cluster was found and more clusters
+	 * can be mapped, grow the cluster_info array and retry.
+	 */
+	if (!found && (si->flags & SWP_XSWAP) &&
+	    READ_ONCE(si->nr_clusters_mapped) < READ_ONCE(si->nr_clusters) &&
+	    list_empty(&si->free_clusters)) {
+		unsigned long nr_new = min(READ_ONCE(si->nr_clusters) -
+					  READ_ONCE(si->nr_clusters_mapped),
+					  XSWAP_GROW_CLUSTERS);
+		unsigned long start = READ_ONCE(si->nr_clusters_mapped);
+		unsigned long i;
+
+		if (!xswap_map_clusters(si, start, nr_new)) {
+			unsigned long added = 0;
+
+			spin_lock(&si->lock);
+			for (i = start; i < start + nr_new; i++) {
+				struct swap_cluster_info *ci = &si->cluster_info[i];
+				spin_lock(&ci->lock);
+				/*
+				 * A concurrent grower may have already added
+				 * these clusters to the free list.  Only add
+				 * clusters that are still off-list (NONE).
+				 */
+				if (ci->flags == CLUSTER_FLAG_NONE) {
+					ci->flags = CLUSTER_FLAG_FREE;
+					list_add_tail(&ci->list, &si->free_clusters);
+					added++;
+				}
+				spin_unlock(&ci->lock);
+			}
+			spin_unlock(&si->lock);
+
+			/* Retry allocation from the free list */
+			found = alloc_swap_scan_list(si, &si->free_clusters,
+						    folio, false);
+		}
+	}
+#endif
 done:
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_unlock(&si->global_cluster_lock);
@@ -3669,7 +3712,32 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 			goto fail;
 	}
 
-	if (vm_area_map_pages(si->cluster_vm, vm_start, vm_end, pages)) {
+	/*
+	 * Check if the target pages are already mapped by a concurrent
+	 * grower.  We must do this after page allocation because
+	 * alloc_page(GFP_KERNEL) can sleep, opening a race window.
+	 * If someone already mapped these pages, free ours and continue.
+	 */
+	if (apply_to_existing_page_range(&init_mm, vm_start,
+					 vm_end - vm_start,
+					 xswap_check_mapped, NULL)) {
+		i = npages;
+		goto fail_nounmap;
+	}
+
+	int err = vm_area_map_pages(si->cluster_vm, vm_start, vm_end, pages);
+	if (err) {
+		/*
+		 * -EBUSY means the PTEs are already present:
+		 * another thread raced with us and mapped the
+		 * same pages between our check above and this
+		 * call.  Treat as success — free our unused
+		 * pages and continue.
+		 */
+		if (err == -EBUSY) {
+			i = npages;
+			goto fail_nounmap;
+		}
 		i = npages; /* free all pages on failure */
 		goto fail;
 	}
@@ -3688,6 +3756,28 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 	mutex_unlock(&si->xswap_lock);
 	return 0;
 
+fail_nounmap:
+	/*
+	 * Pages already mapped by a concurrent grower.  Free our unused
+	 * pages, then fall through to initialize spinlocks.  The vmalloc
+	 * PTEs now point to the concurrent grower's pages.
+	 */
+	while (i > 0) {
+		i--;
+		if (pages[i])
+			__free_page(pages[i]);
+	}
+	kfree(pages);
+	memalloc_noreclaim_restore(noreclaim_flags);
+
+	/* Initialize spinlocks for newly mapped clusters */
+	for (i = start_idx; i < start_idx + nr; i++)
+		spin_lock_init(&si->cluster_info[i].lock);
+
+	WRITE_ONCE(si->nr_clusters_mapped, start_idx + nr);
+	mutex_unlock(&si->xswap_lock);
+	return 0;
+
 fail:
 	while (i > 0) {
 		i--;
@@ -3736,6 +3826,15 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 	 */
 	WRITE_ONCE(si->nr_clusters_mapped, start_idx);
 }
+
+/*
+ * Callback for apply_to_existing_page_range(): return 1 to stop at the
+ * first present PTE, signalling that the range is already mapped.
+ */
+static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data)
+{
+	return 1;
+}
 #endif /* CONFIG_XSWAP */
 
 static int setup_swap_clusters_info(struct swap_info_struct *si,
-- 
2.54.0


