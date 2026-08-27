Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C492C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DD796B00AD; Thu, 27 Aug 2026 05:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B53C6B00AE; Thu, 27 Aug 2026 05:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0D6A6B00AF; Thu, 27 Aug 2026 05:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA9716B00AD
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:46:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63223A3B84
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:46:39 +0000 (UTC)
X-FDA: 85146569718.12.3D3DE1A
Received: from mta1.migadu.com (out-169.mta1.migadu.com [95.215.58.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6C43840003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:46:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.169 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787823997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5LxCg+/OUhFgxSSbaBvlw15yJfqKLCVx1toB5Z+67Ws=;
	b=koSBpV6nfAoqhrVzfJ8P6TBtlxkHSwByzU5VHbm/3UeAQ6XeWj9DGnTXH4JqVMxy4io6nZ
	VR0n6sd+YhG/MaE6uHb6xw4bVE//VHaGyaZz8OSjqc9ncNlsd5NfEdfm4yGFCdaPvVxGnc
	XrwQr0jpxwrZjSzR7cu2D5utezZ3n3s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787823997;
	b=caXkZDfC6ywx5fv24ZY4AoMpgY2m5HhdliSP30mF/bF6sQNmGGNDKskvLDe3stZdH6t/5F
	WsgVIiwmfY0qCOuD01wLWIgXhRSjnmdBLuMYV2PVdUW7VDEBwFNTiHlFqrIY6oMVsxfX/w
	/4fUwjhyMM0YYPOGA62taKl/6i1ifOA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.169 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 7d67cfe4c2f446bf;
	Thu, 27 Aug 2026 09:46:36 +0000
X-Mizu-Trace-ID: 7d67cfe4c2f446bf
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 13/16] mm, swap: defer xswap shrink to workqueue to avoid lock recursion
Date: Thu, 27 Aug 2026 17:45:03 +0800
Message-ID: <20260827094509.1016740-14-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6C43840003
X-Stat-Signature: rh4s89msahujrqbu1n78bbikou18poaw
X-HE-Tag: 1787823997-194231
X-HE-Meta: U2FsdGVkX1903AwAiRpNDaaCEVbP8+/vZt7/BpX8EHgTw6XhpDfWvrjSu+gIhruB5dbfsKnw/zvYZtZTCxAwZmSLJgKc/VQWhipZ4PKuHDsWOVPVG9X1X399o9ES8j8f3qJ7yoqvtOEAIX5u6ercF6LhUAjyvusN5xo/9u/72yZP1CAY3uTlWbVGMUuSEJnq0QCf7fzufmOs4sJwIHGVQ1O5y/45Y/Zh7G49L9gBFnY8yUrWa4JdbPg18OPfelMBEzmgOcc3jSfU3FK+8XZphCRDRpE1zz8w6KpZNwKcjXFYNJ3Qh6Calm97WMb7bXNV/mds0GPrE7nBPx4bCJ3TNtMczkiPat5x3AP2mKJllEjNJ4I2R4Ui5jc64HxLHqMbVAN+KST/5vUSxWFn8Db7hy+OuIdu/o5Hbl1IqqFRU8ToYSthVX7WDXLgq3zMfwnxPyFlV1MWxBuysNJ2TU18s6VLtlKl+sU9hVEj8jaNWgEXQvhPubvXcd2NWzllhe3ArCfGlcRoo7w8qV7Qtb+4Yl97tycu5gZlqYMkxXnrC479YpnZ1ufdPDimbah1xlw8oEkitRSLfZfgA41AXltnyK6wgMT0juffheWiOE4erU/ZKDz2IS6uH7X/VdyK+p+y2Tr1oFFbLCZ+7J1RhFXeh48OzZimXwl4c2RB8xwrcFqqId4PpYzhGrwuJPuUh4H5i3Tg+glFiCje5RuflncyNgu48iJHMRXE/f6lQS7eyq066ocUwfE7JoHrHvLuC4GCwsUb4ZLWROWTCx+O7cOVHIe0NGdQYW5Tyjr99bqvAH2+gy3tuf6hG1U8iyYPEfbeKyhINeyXdrMUlvQesMvfRpz1maB5HaKCH86ApyEb/p84jOSwxjAO5ptciNYGkOJeXTFwHNrpiAHO5S4WvgYP8jkVGXI7Of6Bm3SPi0tE95N9rrpg1JgjyfsoRicD5wi/X86hIJdgKceRNIYuWU2
 sb4qTbK7
 u8VUyontnc6inDZpNGYqJ0s8HrBy5jMq8XR8xQ/Av4eBRNb5UxOhK0MFDe8HTDKDKfXTJKf6yC2/9urCao3t2BtnV+EtIaLrzhgeAKrPpqiIBtoYwx2I3NUKxQzXjeKR+BqtarH+DvW4JUtL3vkWjFlvY8hxyPovaBRXMWxUJKQtzHjpebYKkF1GIPoeCtP42oN45hT+CR9BXYsgaN6lYXxe8mnQlTTu3KHvbbfMLEL9ywsM7e99j+ghYKXDi/q8zdKQLW6N89vmrRGI4CqTVYe5/FuFrEkh2QGWDym5ES7qoTBHMjW+Eqqf4I3u5qm2YVdeJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xswap_try_shrink() was called directly from __free_cluster() while
holding ci->lock.  The shrink path calls xswap_unmap_clusters()
which unmaps vmalloc pages backing cluster_info, and on return
swap_cache_del_folio() tries swap_cluster_unlock(ci) on the now-
unmapped address - crashing on a not-present page.

Replace direct calls with schedule_work() so shrink runs in an
independent workqueue context where no cluster locks are held.
Use cancel_work_sync() during swapoff to ensure no pending shrink
work races with the VM area teardown.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |  1 +
 mm/swapfile.c        | 12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 5e50486103b9..998f04c0b767 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -255,6 +255,7 @@ struct swap_info_struct {
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
 	unsigned long		nr_free_tail;	/* contiguous free clusters at tail */
 	struct dentry		*debugfs_entry;	/* debugfs: type<N>_max_clusters */
+	struct work_struct	xswap_shrink_work; /* deferred shrink trigger */
 	struct mutex		xswap_lock;	/* serialize map/unmap operations */
 #endif
 	struct list_head free_clusters; /* free clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6916a8b3f63b..dc112c378489 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -786,7 +786,7 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
 	ci->order = 0;
 #ifdef CONFIG_XSWAP
 	xswap_update_free_tail(si, ci - si->cluster_info);
-	xswap_try_shrink(si);
+	schedule_work(&si->xswap_shrink_work);
 #endif
 }
 
@@ -3312,6 +3312,7 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 #ifdef CONFIG_XSWAP
 	if (si->flags & SWP_XSWAP) {
 		xswap_debugfs_del(si);
+		cancel_work_sync(&si->xswap_shrink_work);
 		/* Unmap all mapped clusters and free the VM_SPARSE area */
 		if (si->nr_clusters_mapped > 0)
 			xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
@@ -4082,6 +4083,13 @@ static void xswap_trim_free_tail(struct swap_info_struct *si, unsigned long idx)
 		WRITE_ONCE(si->nr_free_tail, nr_mapped - idx - 1);
 }
 
+static void xswap_shrink_work_fn(struct work_struct *work)
+{
+	struct swap_info_struct *si = container_of(work,
+			struct swap_info_struct, xswap_shrink_work);
+	xswap_try_shrink(si);
+}
+
 /*
  * Try to shrink the cluster_info tail.  Uses si->nr_free_tail which
  * is maintained incrementally during alloc/free — no scanning needed.
@@ -4200,6 +4208,8 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 
 		/* All mapped clusters except cluster 0 are free at the tail */
 		si->nr_free_tail = si->nr_clusters_mapped - 1;
+
+		INIT_WORK(&si->xswap_shrink_work, xswap_shrink_work_fn);
 		xswap_debugfs_add(si);
 		return 0;
 
-- 
2.54.0


