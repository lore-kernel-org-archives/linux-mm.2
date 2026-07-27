Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07240C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D08E56B0096; Mon, 27 Jul 2026 10:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB96B6B0098; Mon, 27 Jul 2026 10:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD09A6B0099; Mon, 27 Jul 2026 10:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9118F6B0096
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:05:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1238AA1748
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:05:39 +0000 (UTC)
X-FDA: 85034729598.16.85AA52C
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3B9DB40002
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:05:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jrW6YxKy;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785161137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ma1qSRPhyw9M37mVB/KgMJ1oLVKHiR9txBFXME7mXAY=;
	b=i36i1L+7jWyRaoH9VIi/I5IjvLswHTa4BTe1g935XzdPT2G0lkWZX7rk6UstKURd0fuU33
	41sbWs5SJJbBl8KOck3/kQQpZISf/f5q2o295kyFhhUrV2kB+Rp1C4rNM06jIRQ+yhu0kF
	PhxbtfgKVcW4edv1VXlIReTlQt8RW0Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jrW6YxKy;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785161137;
	b=r/VPcE0SAAFBdlH91g0tOBOUCBlupT/IxYsJbm0QiQjy3bvrFniQdu741z0qrfsbClvt4f
	gD9qKZKUNAid6YxLqI9QCxDKmm3v8meIBylg0NpKfcP60D/86TV6U1Tdo2ppex+kRTFoJ4
	RRwR5+VSE997RBlaZ7duss5q/iZkByc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785161135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ma1qSRPhyw9M37mVB/KgMJ1oLVKHiR9txBFXME7mXAY=;
	b=jrW6YxKyNRullqHytgQP/oIDXFAblVBYMiFnmmWtawb0XZCB96WPMl4KyQWadiPlBUmDj9
	JYcJIkzvuZPQ+aJjmiQasjqErZbAnsq5As/PiJYc1XkPs6Toji6vQ/5zOJN1tzdaWFoSbW
	2G81MbGftGxPG7pIZd4KXuCscEpbxqo=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
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
Subject: [RFC PATCH 04/11] mm, swap: add xswap grow trigger on cluster allocation
Date: Mon, 27 Jul 2026 22:04:55 +0800
Message-ID: <20260727140503.1060918-3-baoquan.he@linux.dev>
In-Reply-To: <20260727140503.1060918-1-baoquan.he@linux.dev>
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
 <20260727140503.1060918-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3B9DB40002
X-Stat-Signature: 5xhxrbhnnceetjhxoc5gop7wr4cudmkh
X-HE-Tag: 1785161137-667223
X-HE-Meta: U2FsdGVkX1/kJ5vsxaXVPffO8StRdzMVw0whuaT750/Z/2/kJWiivxF5QbL3nC3ACdscGJ6BFxjESi+GuOsDJbWxGWI5i+j/GTEDDfQxovxiDi4IeSXgpa4GnyOWY6/IM/ueSIAYTghjwEKO/fxSPnn3l7RI6p+SR1Sqbrxz2sM7zx8rBarHso3q6LX7auXZvqLyoO1/etKrWavprdOj1Neg9UbducuSTaDto3qQ0wDQNrDbIYHmdquFZFy6X+iDKVf2G8r+VctUJjHnDoHD4NnYM8NwZ6kw0sBGthhCxQKWJX6A1kO8Wi4MHU/Tl7YqmCjsGSh6CqYdXejT3sZVdQXghWuKUWpDTyfdgiHGl6/ZFqpAYWnsJ0Eoi8mS4oR2h2tYUpuijT27hSZuSdZW/QL6HI5rOHycrlokO1/Dya2wmbnWK2zklP4s4hGCA8gOS7R18L0o+2vUTZJ3tYBuJzvy283H9VBHGu5zPZjaSrln76kQt3wuwbDvSJ0nAvlEjGSk2W+SX9sHD8alQi5qQBpsQd9J3ZrTwt/lqaAhLn/cW8LjH8uFVTmAhZ+t3QdZEMjPf0gBlko/dHWgRw3nSZAQWJN7yhrsdN5pgdo//ZXhT/GgpV1i5GXDirTL1x0pvXMXXV3YNnkNu9raik9NYHS8XJYb1mcLNOjcs9G8bt5HYzQ3jfT3TvoMwtZmOQG2OUOhdWmCAwqIbpOFjyJCD44CEIrzN4/0TzaveAwvPBcPrERiI3JPAobLP4v5twMsI4BLnYAKaTA51tLS6uiR8J1LFmuS2kzHbMFGX2Wl1bDGZMzjLVSulsSfM1J/05WXodbE+VSuhsks9LucIAlEaF9cPBb7i7T94fBjF2qeCUjSU1HD+sU0NfqUrdgg8t9pd2ACCK4JgFXlTzpMyeEyNUwqakXd1xDkzKoxfJXmh/r7i7GGKnMQrQuq3xPsHD5IJzvvt3flgDMKoT3kZjE
 HgRW4yGu
 baG+hzX4Jfb7w28tAq2UvneZN0EtlMt1R6VrQqxfK90S39eB9sdmvVC8Q++UA2YhnEivjsBn5pN98KGnfT7UoDDpfmGoMCILMLubybW2+NxVLgpsoLtQ4MPFic+S5PAfLO9b990oVa8nWhtdcMrZULAOkpHqkwWtUFJNn3iezbiSemuqoVvRPs5k0Rhl/mcnMiX/dgpLmLlkC7HtwDndUROT2fPVczfPaVbhEQEyV77wJKk7IYWdVZk7/XZiP2O9iqwTWD449MNL/4ttEeSIgHl41n7EnToOFHAAJWNMNmM0EjaA=
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
 mm/swapfile.c | 106 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 103 insertions(+), 3 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6d9c95ed09bd..8a048b2897ce 100644
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
@@ -3652,9 +3695,37 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 			goto fail;
 	}
 
-	if (vm_area_map_pages(si->cluster_vm, vm_start, vm_end, pages)) {
-		i = npages; /* free all pages on failure */
-		goto fail;
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
+	{
+		int err = vm_area_map_pages(si->cluster_vm, vm_start, vm_end, pages);
+
+		if (err) {
+			/*
+			 * -EBUSY means the PTEs are already present:
+			 * another thread raced with us and mapped the
+			 * same pages between our check above and this
+			 * call.  Treat as success — free our unused
+			 * pages and continue.
+			 */
+			if (err == -EBUSY) {
+				i = npages;
+				goto fail_nounmap;
+			}
+			i = npages; /* free all pages on failure */
+			goto fail;
+		}
 	}
 
 	kfree(pages);
@@ -3669,6 +3740,26 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 	WRITE_ONCE(si->nr_clusters_mapped, start_idx + nr);
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
+
+	/* Initialize spinlocks for newly mapped clusters */
+	for (i = start_idx; i < start_idx + nr; i++)
+		spin_lock_init(&si->cluster_info[i].lock);
+
+	WRITE_ONCE(si->nr_clusters_mapped, start_idx + nr);
+	return 0;
+
 fail:
 	while (i > 0) {
 		i--;
@@ -3709,6 +3800,15 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 	out:
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


