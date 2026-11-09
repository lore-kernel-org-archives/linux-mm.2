Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36A87606A331
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sf1q/AMO
Received: by kanga.kvack.org (Postfix)
	id 4A4FF6B05D8; Mon,  9 Nov 2026 00:57:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47C286B05D9; Mon,  9 Nov 2026 00:57:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B626B05DA; Mon,  9 Nov 2026 00:57:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13B086B05D8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:57:25 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9082FA8224
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:57:24 +0000 (UTC)
X-FDA: 85414523208.09.31F267C
Received: from mta0.migadu.com (out-213.mta0.migadu.com [91.218.175.213])
	by imf28.hostedemail.com (Postfix) with ESMTP id AD0BEC0006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:57:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="sf1q/AMO";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.213 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hi4EIS3H0oOuvQqh1pA94yfvsmnVJtg6dWs/l28pJIk=;
	b=ynbfxaIxJlRo2oZNNWqybGID8rjN8R54w0b4WRZGdMmwZnbldDjh1/zc+OuzDId3FxzJfP
	gRmbwDMoUupMMtmXMsdm8DUcpezxBVynW9ZyS9ksuGcd4buLO5vXcQF5naQrrr7KYjZoPB
	urzsiX1+gM3tyZx7zTwge1R8B8OtXYI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203843;
	b=HLYDafTX7IkaP6HEJYD1/nPRyAoxtEZjTwMLJKVwMf6V3J2nMQaB0ZEgAidEXayBDIG3ud
	ivmS+2N38fXvAawWC9GTXwdjiVRy24pM6q3lKK6M4jhQYLyUDo6Tssgf1sMkOEsAI/VFAT
	2b0tNk5Asm5fV/ek1R88vjzdRIjDNtg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="sf1q/AMO";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.213 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yoFPRIeRtwPCWbg+M06U2YQyPT7ejs7j9hdcin6S+Mk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203841; v=1; x=1794808641;
 b=sf1q/AMO8dTP5YGrO+VGouhOQaVJQkJe91tUyVt6HGSZLrjKd+ZvYxWsnR4MQEpznsrPl+Wz
 APwvLx0t4i5L9zFZmFjf9CzsuHSEt1m+zzFjiGoSkTmYnr3rGkjY624J12/OWeABJCDlVXEoNPp
 3ZUqGOtVASLhbQsD+PDbnHOw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 3fae3b4452c9649c;
	Mon, 09 Nov 2026 05:57:21 +0000
X-Mizu-Trace-ID: 3fae3b4452c9649c
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	chengming.zhou@linux.dev,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v5 16/19] mm, swap: prepare xswap_unmap_clusters for range shrinking
Date: Mon,  9 Nov 2026 13:54:52 +0800
Message-ID: <20261109055455.536925-17-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8rm471jqhr4nxkicua8p5xn9jqj6iaf6
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD0BEC0006
X-HE-Tag: 1794203842-171755
X-HE-Meta: U2FsdGVkX181ePnwSiLx4rwqsQ+tEGE7legsWxcySAzNRxNwuncLM9mbjR1RF8ygRRYZXkEB8uy9OX5heLK7/lRlmhbO1cqHUnPPQbVGj5QdOajDuRlI2EtFCn7Z5OP+OpRyUsiyNw8tDV3tj0PO0t+LiYbhpAcLnc+0AWGjxe0A6cp1jGSrHiy61bK267VfPsNeFUXqk2+wpnjpKDWd6PNJ61mBuW+oPfSWF9CFotpGJutk1CzqIpSfJCubIYBAcbCSoIRvdD/t1MG8UvTDc41soAnumbFXNtiljCdEo44Xkr6G/VXjpgKWGpExiNyIuJ0Bw+dCia4qpX7COm1A7xRBrm5wsaF0cWjvCHeGHLYC65G7aB+6h2Ah+Qe5LcGGT16YW7mmYsHWDMOMB5eSj+UYfkrGSEcW3e0LZwpY5fA+AHySc5wT/hmZS4VTa20HWdKZDI1GQeJZQhL3v3iLLKrBjA60IVVhaEwAqet4PVXBo9RuwZOMwoco8yP5+xBK4JJUS4UaTwrQ+XDEpKVU4xu5eGzBLGJbthHiZlx4EglW4GBcfEtjBfAJlgx334YDzYlduQDzDyNd1bJJ8n39ihHESuxfzPDloSfxaIJaI6AlEgPU02EEQNUuahnVn7Z3S5cBTBZw1bLLLWYVzPHlWCNwV/3X6jpokQYkaF0VvF+AzTn96uR3ndrUua/JY1kpRbPgLEI94JpQWH3sClKLawcmqCbAngTN5Xf+/Ida/ncO6cuFpTW9siRD4vTsmhXwm7N+y2Q0BpIB5fyDFa6N1wqKVmCS4odclQIlyxdhJPdzeWm21bKZtKUNQSvxpUz1yNJohcCYeOzR/mmG2/3OGAAB8LMdJHPxShiiXLx/OX6XDQsJUTeVE3VjFDlhbZPgQvyLW49Eruhd5/MteKRrjQaYzQxG4zp+FA5qPqk80G4CNHryjSIIkk9Uzx04RxFeLl2972nlwG55uffq9/x
 miOWFTC9
 Uj2bySZDdd0nwAinu9bIt5aFRFFu68NA8iLAPtb8/6XAWICD2fREMhGAQSwaY7mNu+cBlor60PAtF4QFUP+E2JuL64+YMrn6c7ZRvjxdtwIdrPw46CZkR0WGYlkKZ259+b6wN3j5sPVGdXNyQ/nZoxj3Jf1r1ujy5N0HI5KG0OhzhqJiLdw/TtPs1qKS9EEI5E8dQO2NVrRUzjrRQEK0zmW13mr6Pm+VIsX7cmUTj8hPq/N8K4Zkc6yXdO7hAxOG/Ctu/18tkJ/wIJicPX4vT7qSZI9p3CUt/47dqoVoAi2GTFNgNPz80LwiPHDt58sCzGAYIuOc0fo9IigVCQulY4BVYQ+RXeZ70TSaX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

Split xswap_unmap_clusters() into a locked helper and a wrapper that
takes xswap_lock. The shrink path already holds xswap_lock and must
call the helper directly.

This is a pure refactor. The existing path already falls back to
bounded batches when the range is too large for vm_area_unmap_pages();
the comments are expanded to explain why, and the cross-reference in
swap_alloc_fast() follows the new name.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index bc30ab42203c..097ed288b1ca 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1692,7 +1692,7 @@ static bool swap_alloc_fast(struct folio *folio)
 		 */
 		unsigned long mapped;
 
-		/* Pairs with the release store in xswap_unmap_clusters(). */
+		/* Pairs with the release store in xswap_unmap_clusters_locked(). */
 		mapped = smp_load_acquire(&si->nr_clusters_mapped);
 
 		if (offset / SWAPFILE_CLUSTER >= mapped) {
@@ -4318,8 +4318,8 @@ static unsigned long xswap_grow(struct swap_info_struct *si)
 }
 
 /* Caller must hold si->xswap_lock.  Cannot fail. */
-static void xswap_unmap_clusters(struct swap_info_struct *si,
-				 unsigned long start_idx, unsigned long nr)
+static void xswap_unmap_clusters_locked(struct swap_info_struct *si,
+					unsigned long start_idx, unsigned long nr)
 {
 	unsigned long start_addr = (unsigned long)si->cluster_info +
 				   (size_t)start_idx * sizeof(struct swap_cluster_info);
@@ -4331,8 +4331,6 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 	unsigned int noreclaim_flags;
 	unsigned long npages, idx;
 
-	mutex_lock(&si->xswap_lock);
-
 	/*
 	 * Publish the smaller range before its memory goes away.  Readers
 	 * that use nr_clusters_mapped without xswap_lock pair with this
@@ -4347,7 +4345,6 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 		 * goes away with that cluster; publishing the smaller
 		 * cluster count is still correct.
 		 */
-		mutex_unlock(&si->xswap_lock);
 		return;
 	}
 
@@ -4362,6 +4359,11 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 
 	npages = (vm_end - vm_start) >> PAGE_SHIFT;
 
+	/*
+	 * vm_area_unmap_pages() refuses a range above totalram_pages() and
+	 * returns without clearing the PTEs.  Freeing those pages would
+	 * leave dangling mappings, so use the batch path for that case.
+	 */
 	if (npages <= totalram_pages()) {
 		/* Reclaim here would re-enter xswap_map_clusters() and its lock. */
 		noreclaim_flags = memalloc_noreclaim_save();
@@ -4371,11 +4373,11 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 		if (pages) {
 			xswap_unmap_range(si, vm_start, vm_end, pages, npages);
 			kvfree(pages);
-			goto out_unlock;
+			return;
 		}
 	}
 
-	/* No memory for the array, or too large: unmap in bounded batches. */
+	/* No memory for the array, or too large a range: unmap in batches. */
 	for (idx = start_idx; idx < start_idx + nr; idx += XSWAP_UNMAP_BATCH_CLUSTERS) {
 		unsigned long batch = min(start_idx + nr - idx,
 					  XSWAP_UNMAP_BATCH_CLUSTERS);
@@ -4390,7 +4392,13 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 			xswap_unmap_range(si, bstart, bend, batch_pages,
 					  ARRAY_SIZE(batch_pages));
 	}
-out_unlock:
+}
+
+static void xswap_unmap_clusters(struct swap_info_struct *si,
+				 unsigned long start_idx, unsigned long nr)
+{
+	mutex_lock(&si->xswap_lock);
+	xswap_unmap_clusters_locked(si, start_idx, nr);
 	mutex_unlock(&si->xswap_lock);
 }
 
-- 
2.54.0


