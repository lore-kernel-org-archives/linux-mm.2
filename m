Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD4BEC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 11:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9D176B0095; Fri, 10 Jul 2026 07:12:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E836B009D; Fri, 10 Jul 2026 07:12:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66406B009E; Fri, 10 Jul 2026 07:12:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9336B0095
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:12:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 17D1740426
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:12:50 +0000 (UTC)
X-FDA: 84972604500.05.62E0CD9
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 53098C0004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:12:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IFqLqY3D;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783681968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ngy3pMTw2oJe0xcoHveOCKAvtR5RPrFr2htiJZs9bhY=;
	b=srXHXnMB/5OkBZkpBZwc20eo3wQ6/CFHLe76EFZCzgsYurhslOF40Afmnon/1MHAbomfqj
	vZENOWatlCRx0HetBfJrLGmaCElwsy5h6J86HxPq7PAlWKZB+Y6Kfypcd6l8oVhIoYLCK1
	gbRgADgYjwg+CIdPQwEN4T+K3Alo/Cc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IFqLqY3D;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783681968;
	b=vc9QGLBARxvI9GGUmNfGFrXalc5H+YiMppJ16bEcrnAMSsll9X4jfe4Lni821eX2Eo5XXg
	btgumEmNvYNoTdFpPs/YFMN3Uk31eN5czhS7d8RhaGm0xeKcMi2Sf2SCiFQ+1V02gZl4+0
	YEjBZu2Kkg86vN346Gq9HsuMhJivMCc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783681966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ngy3pMTw2oJe0xcoHveOCKAvtR5RPrFr2htiJZs9bhY=;
	b=IFqLqY3DAom4XvqaOjOErkF9/erqvA8chQ+Lvm+KxY9AN68SP4P+GyN8fmmYCaSu1887qi
	KZpk284BSdJmi+2Wm7GfxTubHbzT+HC4h6mpzd6uxoaNVIVToJSbX/IhiC0GLuaRGx3gPf
	wuONTmcM/XJf5DAxbyn0aAfYDwWyLFU=
From: Ridong <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ridong.chen@linux.dev,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH -next] memcg: move mem_cgroup_swappiness to memcontrol.h
Date: Fri, 10 Jul 2026 19:12:24 +0800
Message-Id: <20260710111224.2355668-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 53098C0004
X-Stat-Signature: mtsw8di6x37gsydwxnzf3d8598wqinfu
X-Rspam-User: 
X-HE-Tag: 1783681968-436776
X-HE-Meta: U2FsdGVkX1/Pzy56QoDiMST7C7Tekjf8LoQfR6ZY3ASR2/7fQlxT8Rlq92E/pvHA63XcGUGBDUtOUqJ1IJof9UoPHR68Rb21v4xFhsS63FSXfmOFpvQKdhB+LS2s+tpDLtkh0/Q1sjCGR/3zx19QciMvtr/3Rhhvftt0kP7lQILI5uJ7x9jZXBSivxZiqHhJbWx/YpzN7QMf4gvK743pCMoESflzXPfDBzvdUty62mKjp6QTqEAM80AXezbRta4qUCtnPJpmoelljDHagAQiDLBzIWhSHgoo2s1WPosQuYc+S8W3GfgAP6qUAKmcOI2YoL3/lxCgqxaF0nco4DbmcRFODCufEkP9yZSROtT/BvgzEO4lbELqrsG/Vo69Sws/vq1jOX2EPCs8eWU+k99AzjZUiStu8pI/Con3VPXCtw9U4gNnl7Ou4gj9ERw4QZcYvWp5zqWVBLHkvBESuPL18FMxjKNLacKs0x2yXh4guD7AUatJZmYDcPHXMb8IW6SjJH4gDDRImcUBeVjGZbWa9fYeV4Cjt1MF+nqmyQC/rCUdjzejrR35w1FGZyI6uesBSMnStUrzd2WEGHnjwpj6pJATTennqzVbKGZiEkxUFn2HhzPDaPKzBwaFQfXwJPe9Qk9kN6fvorv8jLBz/nH/0ms6p29wya9u6Nf3RWDXmYuEO3wup0ME/S4arOIWtcbVSSVf3gXibG+YCTTBkMY+7DSTNEH18vm9Kiqy3U5HOEQ8C3BE5O4RmxBBey79lGD/AOrMMj6ZWR/K9Ph2ttAHxYM5oikc1ZL0D1d9u4pN2rnjXf02v5OKdwd+hNcVQA1jR1PkyX5thInmq3igoE9ckTFfVRCScWLkjCzXnk2dI+UdoM/Tx9htMdvDMDkxTpzgwbV5tl8d0VyDIQK9k2vBdgnuNHcrM9H3puff49QGv94m6V66hYlwdBb7sn48js94cdj0Au2VRegWRGTT+kG
 c6VehKzd
 pe49THSKzanHDEHYAvoIfBXFC4NW0QiM6tEDkDyn7gbmn8LAOIvsbcVwnndHaagglSSD0ErX2lqvZRo6j43eMB2FzaOvHyHgsQQzo/nI909Lcw8Lh39Uw4l9VZQTCQ0a2KNRonOlPwNQymUGV7hkFIpUEnOqyfU9duKwPY/Zz/l8q/FmPXkNvfFIGX2ldGScXeQCrcQ9b5KLm6lNi/1ApZLEZg8ES6b0udm0b1U0I7UOp5FSxxtDwcyQaz/0Y5XKHGqIOMiP6s8ztbW4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

The per-memcg swappiness knob is v1-only; v2 always uses global
vm_swappiness and ignores the per-cgroup field.

Guard memcg->swappiness with CONFIG_MEMCG_V1, and move the helper
to memcontrol.h where it belongs.

No functional change for v1; v2-only kernels drop the unused field.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/linux/memcontrol.h | 25 +++++++++++++++++++++++--
 include/linux/swap.h       | 19 -------------------
 mm/memcontrol.c            |  3 +--
 3 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fc..f59614956f96 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -239,8 +239,6 @@ struct mem_cgroup {
 	 */
 	bool oom_group;
 
-	int swappiness;
-
 	/* memory.events and memory.events.local */
 	struct cgroup_file events_file;
 	struct cgroup_file events_local_file;
@@ -318,6 +316,9 @@ struct mem_cgroup {
 	/* List of events which userspace want to receive */
 	struct list_head event_list;
 	spinlock_t event_list_lock;
+
+	int swappiness;
+
 #endif /* CONFIG_MEMCG_V1 */
 
 	struct mem_cgroup_per_node *nodeinfo[];
@@ -365,6 +366,9 @@ enum objext_flags {
 
 #define OBJEXTS_FLAGS_MASK (__NR_OBJEXTS_FLAGS - 1)
 
+/* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
+extern int vm_swappiness;
+
 #ifdef CONFIG_MEMCG
 /*
  * After the initialization objcg->memcg is always pointing at
@@ -1440,6 +1444,23 @@ static inline void mem_cgroup_flush_workqueue(void) { }
 static inline int mem_cgroup_init(void) { return 0; }
 #endif /* CONFIG_MEMCG */
 
+static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
+{
+#ifdef CONFIG_MEMCG_V1
+	/* Cgroup2 doesn't have per-cgroup swappiness */
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return READ_ONCE(vm_swappiness);
+
+	/* root ? */
+	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
+		return READ_ONCE(vm_swappiness);
+
+	return READ_ONCE(memcg->swappiness);
+#else
+	return READ_ONCE(vm_swappiness);
+#endif
+}
+
 /*
  * Extended information for slab objects stored as an array in page->memcg_data
  * if MEMCG_DATA_OBJEXTS is set.
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 3f31b6a56788..f27e73f29195 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -366,7 +366,6 @@ extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
 						pg_data_t *pgdat,
 						unsigned long *nr_scanned);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
-extern int vm_swappiness;
 long remove_mapping(struct address_space *mapping, struct folio *folio);
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
@@ -530,25 +529,7 @@ static inline int add_swap_extent(struct swap_info_struct *sis,
 }
 #endif /* CONFIG_SWAP */
 #ifdef CONFIG_MEMCG
-static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
-{
-	/* Cgroup2 doesn't have per-cgroup swappiness */
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return READ_ONCE(vm_swappiness);
-
-	/* root ? */
-	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
-		return READ_ONCE(vm_swappiness);
-
-	return READ_ONCE(memcg->swappiness);
-}
-
 void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
-#else
-static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
-{
-	return READ_ONCE(vm_swappiness);
-}
 #endif
 
 #if defined(CONFIG_SWAP) && defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 938f190a98fe..2d659b76cd77 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4174,11 +4174,10 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 #endif
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
-		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
-
 		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
+		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 		memcg->memory.track_failcnt = !memcg_on_dfl;
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 		page_counter_init(&memcg->kmem, &parent->kmem, false);
-- 
2.34.1


