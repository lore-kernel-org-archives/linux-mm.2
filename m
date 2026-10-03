Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F39FCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 01:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96DBB6B009D; Fri,  2 Oct 2026 21:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945826B009E; Fri,  2 Oct 2026 21:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85BAF6B009F; Fri,  2 Oct 2026 21:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CE736B009D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:11:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E766F1208CE
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:11:48 +0000 (UTC)
X-FDA: 85279537896.26.F9FE66A
Received: from mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id E94A61C0003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:11:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790989907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=51osT/J4BX8PGUKDzP6umO/QrqQ/ifoUbOD6HLAIvFE=;
	b=uQpx77K5bJDjupvf/1OEp3AwGg+5poL4Se4xrXCNxYMHH9L3yrUe8iSw3phHqMUnXB8ARC
	eW/fiOgTiQQTcm6OWyLI3UgFu0pQ3z0UAwndWiKi2+Gvvyi1yP8uU9ubMDocbnOvBAU+oN
	n86xunOWkW8rilg1PK+ImoeTmWEwDCs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790989907;
	b=gnvp6MRA0MiqH697ynNgjpR2QfWgWmlO7qd+XSqSzTcqlAiFmhg0kKMbxw5s93jaN+jKgn
	8iqK3pbwzyY4PnOmwsWjw81XOAK5YHY3w/af/OUxmuFzrQnSLP3wa8UJoPBvcTEH0LKNq/
	nsz0M1HqQcxT5pwt52wbLues5djpLZE=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id d479558952a2d234;
	Sat, 03 Oct 2026 01:11:45 +0000
X-Mizu-Trace-ID: d479558952a2d234
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	tj@kernel.org,
	mkoutny@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 4/6] mm, swap: don't gate xswap on the physical swap free count
Date: Sat,  3 Oct 2026 09:11:09 +0800
Message-ID: <20261003011111.1003090-5-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003011111.1003090-1-hebaoquan@kylinos.cn>
References: <20261003011111.1003090-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f7djwjbbw7z1gyhb9cixqdphersi1ewq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E94A61C0003
X-HE-Tag: 1790989906-359929
X-HE-Meta: U2FsdGVkX1+yNNNi4GHBClsp9FTioNARLWwLjkwww/RdUldADYyHM18e6rcVih/SuXwTfwdRJu4ijNb1ZAqv2cPHy170a35rpSvZzuyI+f/RawiFoPlYjpLvdJ6ZbJY8qS273CWFdi96WEaYtXg3qH0sNSQ0ZKNBN1+iyp6DfmcRlqpUWBBMpwciR4xCWmZH8PbZMmFZ8DfKk/F9F3SWtdH8FFkRZN89lVGbR3OG0ZI18+7q22NFlbxP1rjxuCvGrylF7XHvcqrHn/UQgaiN4YFwHAwTt3Wf48jxPmn5ZoLGwiBnIgJgjryhklrSY0jALA5Ae+2nw3YNVSlNNQxvc+aBEIVYWTgKTAc26uZPHvIJoZvSdrdubt2T3Kdo3M63lksj/DZ0DS8xzj+h+u+tSwLVlNB1RrdhnGqLiqj2T5l51YwrKOsWvRdH8arYY5kpEb2Y1d3FB/UOKfoUSEoXdwioupxg7l95AhWbIQtcbCHpBapBPuwU+mTfG/CW24SERKLgNOYK0XUKUpUEUUNMO+ZDhefF1rEu9rPzl+VcJTP0w1wmweufSLvQMvXCh98CgRNun2+ZcV4LjIokRxpTmPg3NWLInbjnHdlZwI9uFtXmF1ocZEq57ic7H0vhiyN8xp9jzPdObelFCQiCgkul3BYBfWJOReYIraCqeAmmBbD/iUUvf5rvp0y+zhUPGdrQHgkMYkQwLWE4Uh7DvovSnEyizWu6EdsJcIFBtlOMTWFNVtS5z1/BvYQ5Wi4qa8vV0O7oMqvU/IDFXX/dtqoCXVboChCjaj2nfDOtZMxm8csFewBV1M5jQE/v0K3AUbtvlzBwmSG5LW42VeD6NFrhX53UiG+HUzVZmfS73LRzX5KddO6wLjeV85nGTXtsxIJdHYAEnYMTOHvhxupoEaMPQlk5GTK5GkXJwXJ590vLfsvos0dvfT22I1Zxl7BwwFalfmReU/+O7JTooswTrxb
 yCxPOQGH
 U/qKXxh7Roy1sPW8casbXTB0IUE3RqSNtNsbNx68rfZHReBH1sPKuXj2SWz6M7iTxiHI3125XkzwdQTWMpmv93yPhglkpzc97ePRiChgauSjLODemhiH6eFPySQAjj66XLHmMBnCX/8uSo+NB9bNYAa7M8vxA8uIw8f/xhder34QDqQ2E7DcCwWQvMOc6tSQ4j4HM/1pWKK+z+4Npgtzg4cdpMGxCaCrkBWkwzxHDIofS/JRW9M2SbRFnzU2VC7j3IqRAaxlKjOo443u35mh8m8PNMVgjo0TY0hC+HniCbJHw0AMKkorCTwS32Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nhat Pham <nphamcs@gmail.com>

An xswap entry is charged only when it gets physical backing, so a
zswap-capable memcg can keep swapping out through xswap even when its
physical swap margin is zero.  mem_cgroup_get_nr_swap_pages() would
otherwise starve anon reclaim with memory.swap.max set to 0.

Return PAGE_COUNTER_MAX when an xswap device is active, zswap is on,
and the memcg allows zswap.  Track active xswap devices in nr_xswap_files,
mirroring nr_real_swapfiles.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/memcontrol.h |  4 ++--
 include/linux/swap.h       |  6 ++++++
 mm/memcontrol.c            | 31 ++++++++++++++++++++++++-------
 mm/swapfile.c              |  2 +-
 4 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b9072a3c9a2a..be335128806f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1944,7 +1944,7 @@ static inline void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
-bool mem_cgroup_may_zswap(struct mem_cgroup *memcg, bool may_flush);
+bool mem_cgroup_may_zswap(const struct mem_cgroup *memcg, bool may_flush);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
 bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg);
@@ -1954,7 +1954,7 @@ static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 	return true;
 }
 
-static inline bool mem_cgroup_may_zswap(struct mem_cgroup *memcg, bool may_flush)
+static inline bool mem_cgroup_may_zswap(const struct mem_cgroup *memcg, bool may_flush)
 {
 	return true;
 }
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 745606f23e62..ebcbb92849b7 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -390,6 +390,12 @@ void free_pages_and_swap_cache(struct encoded_page **, int);
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
 extern atomic_t nr_real_swapfiles;
+extern atomic_t nr_xswap_files;
+
+static inline bool xswap_enabled(void)
+{
+	return atomic_read(&nr_xswap_files) > 0;
+}
 extern long total_swap_pages;
 extern atomic_t nr_rotate_swap;
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ba13d2a1ead5..2ca39f64c4db 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6126,8 +6126,20 @@ void __mem_cgroup_swap_put(unsigned short id, unsigned int nr_pages)
 
 long mem_cgroup_get_nr_swap_pages(const struct mem_cgroup *memcg)
 {
-	long nr_swap_pages = get_nr_swap_pages();
+	long nr_swap_pages;
 
+	/*
+	 * xswap charges physical backing, not allocation, so virtual swap is
+	 * unbounded for a zswap-capable memcg and the swap.max walk below
+	 * would starve anon reclaim.  swap.max is still enforced when the
+	 * backing is charged.
+	 */
+	if (xswap_enabled() && zswap_is_enabled() &&
+	    (mem_cgroup_disabled() || do_memsw_account() ||
+	     mem_cgroup_may_zswap(memcg, false)))
+		return PAGE_COUNTER_MAX;
+
+	nr_swap_pages = get_nr_swap_pages();
 	if (!mem_cgroup_disabled() && !do_memsw_account())
 		nr_swap_pages = min(nr_swap_pages, page_counter_margin(&memcg->swap));
 
@@ -6333,13 +6345,15 @@ static struct cftype swap_files[] = {
  * spending cycles on compression when there is already no room left
  * or zswap is disabled altogether somewhere in the hierarchy.
  */
-bool mem_cgroup_may_zswap(struct mem_cgroup *memcg, bool may_flush)
+bool mem_cgroup_may_zswap(const struct mem_cgroup *memcg, bool may_flush)
 {
+	const struct mem_cgroup *pos;
+
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return true;
 
-	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
-		unsigned long max = READ_ONCE(memcg->zswap_max);
+	for (pos = memcg; !mem_cgroup_is_root(pos); pos = parent_mem_cgroup(pos)) {
+		unsigned long max = READ_ONCE(pos->zswap_max);
 		unsigned long pages;
 
 		if (max == PAGE_COUNTER_MAX)
@@ -6347,10 +6361,13 @@ bool mem_cgroup_may_zswap(struct mem_cgroup *memcg, bool may_flush)
 		if (max == 0)
 			return false;
 
-		/* Force flush to get accurate stats for charging */
+		/*
+		 * Force flush to get accurate stats for charging. The flush
+		 * only reads the counters, but takes the memcg mutable.
+		 */
 		if (may_flush)
-			__mem_cgroup_flush_stats(memcg, true);
-		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
+			__mem_cgroup_flush_stats((struct mem_cgroup *)pos, true);
+		pages = memcg_page_state(pos, MEMCG_ZSWAP_B) / PAGE_SIZE;
 		if (pages >= max)
 			return false;
 	}
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 86ab4a86857a..a3d4561566eb 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -284,7 +284,7 @@ static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
 atomic_t nr_real_swapfiles;
 /* Active xswap devices, as in nr_real_swapfiles. */
-static atomic_t nr_xswap_files;
+atomic_t nr_xswap_files;
 /*
  * Some modules use swappable objects and may try to swap them out under
  * memory pressure (via the shrinker). Before doing so, they may wish to
-- 
2.54.0


