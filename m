Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91C3FC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 09:12:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88BC76B008A; Sat, 11 Jul 2026 05:12:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862F96B008C; Sat, 11 Jul 2026 05:12:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A08F6B0092; Sat, 11 Jul 2026 05:12:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B1C66B008A
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 05:12:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DCC951C3ECB
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 09:12:27 +0000 (UTC)
X-FDA: 84975929934.25.C6E772C
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 56842C0003
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 09:12:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tzY++Vc1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783761146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n/fmkbFM82bplCCU3tUfwRgpNFIhXBSaqcx3fDjOrsA=;
	b=zU+WPH8gRLVTBYvLqIvAZhcHo9oohnxdzBLnx+6oORkGJG8faiU62n9wNdRENsDXGUmRyX
	aKjzQ2UYch2DE52F7ouCGjpIOC/V1F0uWP6vBC0N07o08Lv67RD1EAj1OiZDwitjX53M3a
	AI0SGizjfFkg+h32WsTFRk3oI5jJr4I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tzY++Vc1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783761146;
	b=0NiguZfbanKO8LH0o/qhGpSXvt92tr4PyNTG6Fk7LNplq/QFxv6mXdWIhKJ5Ye3trxnrNy
	Iv7n/P/5814VtDMHYQtC6ZsEXwbWr4Ld0fZMotjsCAos78iZQgV7/1xmP9GE3FGRobSFXm
	1+cm52VsJdxqwSvT2/AnvI85Yb5Kw0c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783761142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n/fmkbFM82bplCCU3tUfwRgpNFIhXBSaqcx3fDjOrsA=;
	b=tzY++Vc1F1viUG6vvFRtxLtjS5oZ1uSR8/uLyMekaroZ51SNwiZhPb96dgQWtb6UizyMX6
	sKQxrJ9aCw+DjKlWLNg+1m5YIaj5GYUGgtPo3uImTLeKgFWmuNFEAVXSJhYgL93yRfpKh6
	PrYELeCcMbq2aLwWAb6bdiEqVAya9GU=
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	David Hildenbrand <david@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ridong.chen@linux.dev,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH 1/2] memcg: move mem_cgroup_swappiness to memcontrol.h
Date: Sat, 11 Jul 2026 17:11:56 +0800
Message-ID: <20260711091157.306070-2-ridong.chen@linux.dev>
In-Reply-To: <20260711091157.306070-1-ridong.chen@linux.dev>
References: <20260711091157.306070-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 56842C0003
X-Stat-Signature: 144xc1irr7ehyzeu3w8rdrfd7twwwnbo
X-Rspam-User: 
X-HE-Tag: 1783761144-544741
X-HE-Meta: U2FsdGVkX18J4KTWxnozjEOOfnDkVHABZOYf98z1uoBbGUhcbYCQ0hz6pW8zxRBTGbTurIdr6YdvCev+TbqSPfHSrw8t/6XfgHlI0gDSiqXuQtzJz1sH/o9GNCEBaxYLG9N+miJnNIofBVGRhAyZ4NP7lf/WX6VBZX9YMvZHMmzAwrTxt7o10owqOwy9s4o8+yx66OcNqOVNGowrIpFYMsJguF3Fcu5uvQAjn4ZyO4NTnXdGHhbhNtycnslZS5JAsYsPiYwSPZG6e2O3yejGPby6EWYonAGnHNpFm9mWHKOKll/tnqlqgwDPdjB5Pv63epDetrmsXLWXLAw8VXBJoJSKkyiGc4MWBw/H64s0xyW19CHn1T0ANn9K84iFUzKuP8FNv2Vdh4G4yi6faEv3UDcdOxnxCNrCOsIiewsHFcxNhEWv40iyWAhwL3VuDRFH9o9UfKxtNaRwe8z2ExolRntZruaknsvhQWrIdhNmlbv9pCh8kaywxFdKB6geB6ayNZtIjnM//ooFt4RCzFwR+mnrIKe1vcHhzpFpNL4FtQ8LTQsEgbFNxTO8nyNOsWke8N2aWMh3jGpYOIMUL+99OdB9JiOHoUzttrlgxjzoGdGbLf5VuG5JzUbKlEzMoQ8HaHH6rT2NzFqA+54oFpO14dQLPm8qa53uO8HImX7ipWivSUyJdWJ1kbl2967fplzY5yB6K2W4kDBIsxtNsCNlEKh71xal/0znSUnpcAkiUQLCjhgKjZTJe6HBbVG2PC9yRwdQRCaDxxhw6qbQ9sYd/qzp1qxdHusEHJxV5UoGY17kVjHKNgq+g0lIHZSPTL+AxNEZeSo1g5B61L9IBUNo7gF/+/K/oOoDr2D5aBCo9+0m51SX8/9lDMwJVEn1dNB4T89XCueqmCQMS1irWZJHtir1z168VurO8pbUthERRZjhiY5NZgpKf1gtohvJRu8govaTd75KOYm5pMh7s3N
 9cHZI83o
 BmWN3WwOuhRaB9MriDFv8vTlo1alitlWBq3ofpLvr6TrVTT1j6Jhtr64CrjIfZbV+e8lJTDBb+pWCvT/L1x8j86rWi/Z+16BaxDjAoNFqP7JtNKAsTJs++aAnqxkBabqiGBA2Bv8f3Es03zryP533FE8oWcSbkv7UwSSG6SaSXOzBuOv07zaW4FWDlcTYJd2h+UtpM8UEHs0kGnFLBaZ2e5u2CCF7nPKA0U3ZK44dPMdsup7MvtSVK/2mrGdjX0fO9sZh2fyJGXnfpHIFzdY/s8Wjkj+S4Fg2fC08wlQt0lxxW3UusbjsJvXgPTkLF5q3Dh2hLlIaZogI4XQ=
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
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
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
index 8f0f68e245ba..2cfe364d66dc 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -372,7 +372,6 @@ extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
 						pg_data_t *pgdat,
 						unsigned long *nr_scanned);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
-extern int vm_swappiness;
 long remove_mapping(struct address_space *mapping, struct folio *folio);
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
@@ -537,25 +536,7 @@ static inline int add_swap_extent(struct swap_info_struct *sis,
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
index 6dc4888a90f3..b61def56c41a 100644
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
2.43.0


