Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99117CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84F56B00A2; Fri,  2 Oct 2026 20:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A355B6B00A5; Fri,  2 Oct 2026 20:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9243C6B00A7; Fri,  2 Oct 2026 20:33:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68FB46B00A2
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:33:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED73816057E
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:33:07 +0000 (UTC)
X-FDA: 85279440414.13.43C0698
Received: from mta1.migadu.com (out-210.mta1.migadu.com [95.215.58.210])
	by imf25.hostedemail.com (Postfix) with ESMTP id 14E39A000A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:33:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.210 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790987586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bAT5XyYxUJQ+haEqfZ8R6eDacu2zFXjDqf7X3AMVDjk=;
	b=i8kAZn3AV/v89tVLZYc/cIQVX4y8LjKLkndB7zv6PdtscxFJrz3WySyN79wPBQzpo95MFl
	vst7u516pBNyM1Hix1faLVlfSFmLl+neLELc+mvYkuLNErsvaERsKJeMkpxhHuS5bqxTST
	V8ZCH03Ka0mN9ycfStLxZzpi6ZQXTOg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.210 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790987586;
	b=gKUw+3x9imIQN7LeeKDw34Kx2EPuzdD7xN9B1J7gsiwYBy83EI4aJ5YgTG8zcj2O76x4FA
	wAklKVeHv/0Y8vepYfsQmiZM1jMalPCv8nd/sJjWWoPKWKJZG5ephysPy9NPIeafs1qOO3
	PvmN/Nvh2p34IHF6+OgrAiIUXQOazIc=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 9c8d0751a056c750;
	Sat, 03 Oct 2026 00:33:04 +0000
X-Mizu-Trace-ID: 9c8d0751a056c750
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v4 11/14] mm, swap: do not give an xswap slot to a cgroup that cannot zswap
Date: Sat,  3 Oct 2026 08:31:33 +0800
Message-ID: <20261003003136.750633-12-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003003136.750633-1-hebaoquan@kylinos.cn>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 14E39A000A
X-Stat-Signature: qxoz76ab4puy3swk17hr671og4t6msio
X-HE-Tag: 1790987585-37845
X-HE-Meta: U2FsdGVkX1+xM0ChcPqXyXPosY72tfBkEKuHTFdVk1yxvSgFzQ1P7FB+aDD6Up49nNNn5i3YafmPAOp3GF1XExC+6d35BnGHkR8JUFgOWZpMFtNfBd6vLldLUI19C4zWSYd2Lk5EuumNkxrgUH9W/6WhUeE4iFv9e6X8IxRwKfBjCXZMmtrzxH1XXA8rz3VBmSL1pnYv5JSjCvYmh6mDv8XCElN+ajt9LUIYFpO7TrBnyftwkjQ8bPX/ezKPPzPFMlfe3ooeJ+OaY7K6VXsXgRMyT3Bq23MGN63/iZXj1vYXAaceF3sdpxAAvAbXP5SpWJ9eqOEgx+M3ZX/j6Z1F9/TA/41LmvuerY+fdQWCTQRZmYxmX0Pa5h/u60oZi3pGbT0MHGn0RLJpHw2ipiX1uz0ulW1UUrtYm0Ep2rbnK4Ocpq5Yr8kxuFr9YlzqBXwKrgjj2Ps+hWjEjRMysgOmXYSSGyxHfMwfoyvZ5wypQ2kJbC5AoRcJrRyG0MMVDEY6RAnwU7Vy4ACQZwSeEk0a+zq61D5clghYlf/dp6x+gH6+yK6QuKJYiD2NWC84btVADgjSbWeCIZ/OSaP2z966CsXlynBHKY1lXuljKihJ9uv6C436L2SJ5OP0YKoB/M3HrL1B91hRrFJnm6i5I4AnpWtGg9tQas/c8v3Coz35wBQxGVE3VJpdKP3Xlv6DLI1h7GZIEeLKNbdHdi3+piTLZTCp6swKK+8qrEfJmSSrLfybd5kPYHq1T7tP9OJKkBO1vQyByhIxjNnc0ySgvHlqS1eOjTJBLaiD0WdnG9XDdixGn4hFaVg2teKmuxl0l0UnckZahusp6BCSBKQZIPnw00czBXgLXY833Zl3cQWtIQBPcJB36/B0mIpti8l7BEbZW6e8msEmC886G+QBcZo2ZGElErYFkWPlqUWtVGipD/p2GDRdZHDZjYHUtwIYTEYeEJwhEVfqKlD0hcXZJyg
 MOnJKwAo
 3QYtsKxP8AlfYZ/Z1gX3bBxztV8NMbv0f+TCNh7TCq3aQcoXKAGkUtnZrBQyX24bH2BUDl3CWBMIlj6byN2RLaqUZb2ng47sEOtUrtW2dA/13a2HNBOSfb18yPMRtK2NtL9KHG7yOM9s9qvWimRzO5tNoRhw0hb1rRAbQrk11TI2W8VrP6BPqhXKnp6stGOzob+kwP6JuVqGZtOeqJV3sINw3mLO6hM4OjNXZ5nVgGpTvfZQc/HRBAAqFd5VJ291g4ND3Gdpy8pfPbAiMDBhUyfhUhPAxRYiikGnNaIZuCFegRgQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An xswap slot holds only a zswap-backed page: it reserves no storage of
its own. A cgroup that cannot take another zswap page still gets an
xswap slot on swapout, but zswap refuses the page, so the slot cannot
hold it.

Skip xswap devices during allocation when the folio's cgroup cannot
zswap, and allocate from a physical swap device instead. That routes the
folio to a device that can store it, and avoids taking an xswap slot
that zswap will not fill.

The test is obj_cgroup_may_zswap(), which is false both when
memory.zswap.max is 0 in the hierarchy and when the hierarchy is already
at that limit. So the routing follows how full the pool is, and not only
how the cgroup is configured; it is stricter than zswap_store(), which
stores anyway if its shrink found nothing to free.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 47 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 7 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8c8e99ea403e..818b5a147b73 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -204,6 +204,8 @@ static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
 atomic_t nr_real_swapfiles;
+/* Active xswap devices, as in nr_real_swapfiles. */
+static atomic_t nr_xswap_files;
 /*
  * Some modules use swappable objects and may try to swap them out under
  * memory pressure (via the shrinker). Before doing so, they may wish to
@@ -1385,7 +1387,9 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 		lockdep_assert_held(&si->lock);
 		si->flags &= ~SWP_WRITEOK;
 		/* Count active devices, not merely those on the avail list. */
-		if (!(si->flags & SWP_XSWAP))
+		if (si->flags & SWP_XSWAP)
+			atomic_sub(1, &nr_xswap_files);
+		else
 			atomic_sub(1, &nr_real_swapfiles);
 		atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
 	} else {
@@ -1444,8 +1448,12 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 	}
 
 	plist_add(&si->avail_list, &swap_avail_head);
-	if (swapon && !(si->flags & SWP_XSWAP))
-		atomic_add(1, &nr_real_swapfiles);
+	if (swapon) {
+		if (si->flags & SWP_XSWAP)
+			atomic_add(1, &nr_xswap_files);
+		else
+			atomic_add(1, &nr_real_swapfiles);
+	}
 
 skip:
 	spin_unlock(&swap_avail_lock);
@@ -1543,7 +1551,7 @@ static bool get_swap_device_info(struct swap_info_struct *si)
  * Fast path try to get swap entries with specified order from current
  * CPU's swap entry pool (a cluster).
  */
-static bool swap_alloc_fast(struct folio *folio)
+static bool swap_alloc_fast(struct folio *folio, bool may_zswap)
 {
 	unsigned int order = folio_order(folio);
 	struct swap_cluster_info *ci;
@@ -1564,6 +1572,11 @@ static bool swap_alloc_fast(struct folio *folio)
 		rcu_read_unlock();
 		return false;
 	}
+	if (!may_zswap && (si->flags & SWP_XSWAP)) {
+		put_swap_device(si);
+		rcu_read_unlock();
+		return false;
+	}
 
 	ci = swap_cluster_lock(si, offset);
 	if (cluster_is_usable(ci, order)) {
@@ -1580,13 +1593,19 @@ static bool swap_alloc_fast(struct folio *folio)
 }
 
 /* Rotate the device and switch to a new cluster */
-static void swap_alloc_slow(struct folio *folio)
+static void swap_alloc_slow(struct folio *folio, bool may_zswap)
 {
 	struct swap_info_struct *si, *next;
 
 	spin_lock(&swap_avail_lock);
 start_over:
 	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
+		/*
+		 * Do not rotate a skipped device: the walk follows the
+		 * rotation and would spin forever.
+		 */
+		if (!may_zswap && (si->flags & SWP_XSWAP))
+			continue;
 		/* Rotate the device and switch to a new cluster */
 		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
@@ -1925,10 +1944,24 @@ int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
+	struct obj_cgroup *objcg;
+	/* True unless the gate below finds an xswap device to route away from. */
+	bool may_zswap = true;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
 
+	/*
+	 * A folio that zswap will not take must not get an xswap slot. With
+	 * no xswap device to route away from, skip the lookup.
+	 */
+	if (atomic_read(&nr_xswap_files)) {
+		objcg = get_obj_cgroup_from_folio(folio);
+		may_zswap = !objcg || obj_cgroup_may_zswap(objcg);
+		if (objcg)
+			obj_cgroup_put(objcg);
+	}
+
 	if (order) {
 		/*
 		 * Reject large allocation when THP_SWAP is disabled. Check below
@@ -1949,8 +1982,8 @@ int folio_alloc_swap(struct folio *folio)
 
 again:
 	local_lock(&percpu_swap_cluster.lock);
-	if (!swap_alloc_fast(folio))
-		swap_alloc_slow(folio);
+	if (!swap_alloc_fast(folio, may_zswap))
+		swap_alloc_slow(folio, may_zswap);
 	local_unlock(&percpu_swap_cluster.lock);
 
 	if (!order && unlikely(!folio_test_swapcache(folio))) {
-- 
2.54.0


