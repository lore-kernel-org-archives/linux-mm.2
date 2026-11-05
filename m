Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6148D606D818
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=RZzOGIbj
Received: by kanga.kvack.org (Postfix)
	id B5DE76B05B4; Thu,  5 Nov 2026 04:22:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B10156B05B5; Thu,  5 Nov 2026 04:22:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0166B05B6; Thu,  5 Nov 2026 04:22:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70A176B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:22:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C2B75A8535
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:22:46 +0000 (UTC)
X-FDA: 85400525532.05.30FA122
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9D41D40006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:22:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RZzOGIbj;
	spf=pass (imf12.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793870564;
	b=IqS9LQw9A0xrdgvoDwKGliNTCpSJfd2AuG5KWgMPmt15gFy97QwbZ6EltgZRoHi/mEwpAm
	a41Rej1J1Pl56OOmnLoZQxG/7+isLQvKcszC+D7lGN01yq+0XjTHACbx2hoLT38XO4ivcG
	fSq4/aAm0H8kEcsZCyQ2V4bR2A9t450=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RZzOGIbj;
	spf=pass (imf12.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793870564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iLVAW+fTIOsvFqz8AUTyojT4okins1Fy/sb2HWay26A=;
	b=VAD8GWcb1XLJSK/2e3oPn61Hsv4HL+BOrhOdFvTUZvxEpQ/vKwSY+PmuPt1jpQmjQ9w9vk
	SI4JxGIgSi9iqzdR1WhpwwNn8bqTP7zlbf+fsCjXxwsbXr+8pDhrUjVo/bq/CRVJGRy/Bd
	6GuqxwT9OIIxGXfvtobcHkUT2jVV3YI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793870558; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=iLVAW+fTIOsvFqz8AUTyojT4okins1Fy/sb2HWay26A=;
	b=RZzOGIbjlwdwbX7jNUlRMFwS0O8X7+WgFv4Aq5CCin5G4K0kUwnF+sZ8zOtWouRtWIa3pHTrWQ8MtrssPXMEcAdMe2J9tR8SIMp/h0JbGr/+m5okTvMan/cY40swHr/HoElNKx9H5TfMELVIHhNRYz1eArBL+4biG8P2rZJFyy4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XE8K-0._1793870556;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XE8K-0._1793870556 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:22:37 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	mkoutny@suse.com,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	david@fromorbit.com,
	qi.zheng@linux.dev,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	xlpang@linux.alibaba.com,
	ryncsn@gmail.com,
	gourry@gourry.net,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v4 RESEND 1/5] mm: list_lru: pass the memcg index directly to the walker
Date: Thu,  5 Nov 2026 17:22:29 +0800
Message-ID: <20261105092233.3558950-2-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
References: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dbfx3qmbzhj1j8ix5o9m451st1cn8uqu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9D41D40006
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793870563-443430
X-HE-Meta: U2FsdGVkX1+90tBaQxTo8iEa33e71WZNHkDZbkWoPGyv5iLGuB0HlBLIVhukUzkLSveq3+N6Cw2/Zno7FSJ6M1kUApLn1DIlybmLznovmd/f+9CO/Xyh79l1ZpD//cpAOdcy3cAguhaNP3Dj12XkoRnFBXuSXNFdnVXB7FIz/zhO1JzIFJ5yzabWO1u85Gaj9FeGsqRFytM85b5bJsmAafSAcy9HCp1CIQyen2Y4lglr/WJy3tPVTMWHqBSWQv/+OJAvav8P99G7OlIO0e8ASEWNIBPrtRPP1J06lPao8ILTelsEtMj+t6tOkKW1p3DkDNcfqUp7VrI9y7ONGry0rBoXUlhqEnGSXRXWY7LHKEcFQIc/BUVuFh7kVaeFetnGdhzn3Eb2mJ7fz/Rz7vFIXKNyB9y6D5iQiD7ZZ4wYZEaNWdq4fumbQYg+pQ8mn+a1tirFTfyRAokmo18WvqG655KkGmBfC7LjydHIGYmAoLahcJuDkJaAiNjGwKSDHwkXYZRgwbtsxXSvknk4DYvRz1xGgARMys2VUD/EAmd7boFmgqdiX9Upo2iLHAPIROTyGWFy8fiH+aOvBAp8M8ju/iuQkjeQ2AFeirUuJiVnfO4JN8ww8duVVtGCHUWd/6L6CYlNaOIugbBEaI2qBfpRUx2dTuA4sGGErkyH4nFD87orvDCBSJDXEVnCzxq1prCCeIkhx5YxW7zPYsUQYI2wIJg3U16vbDgdsiGuIlpmRCXFZ8DATVqczqYP9HyELMhwO39CXdBly/6QgzOX8gorIYL3Za9AcYBGkCfxI0hlbA+MVYGFjsYfI97BIU8qNQIkhLTJjKg53AwacP3ehBCRSvuyDij/6MeIOr+qrPJYr+OvrchVFU+KOgbYNpNUd731hcg+bHE8lL2NGF7txV01EpkyKylch5U4BThtD5PKbqTGBX4IvJArUKa9TxWbSGkdxlgOIcRUeAsQ4b7wHS/
 SIFgnPYs
 KPj1CNMHWFQg5T90zjMz7b9NtIkAim7Wji9suI7SMnaCuAqtBOpSfiKxY+BAAMILu5aT9rJx2jGJDb3q6Yg/ZW9U7iS0KxPdaGf1LghV9tPO7TlLlLNUMIWkBwL1G2XSVh75AGgTixhRe6cOoNjSKSjACre//sjz+Ri1Aa1KRaQ+gecmMkA+OM3zHRT2uLZZvn5KlTkZpPdqJcYIoqntsQbRB8KuebzCh74yM+p7khbAO5bu/XOqAc8YpI12ywBdpe8IMw+9bT8diH71efTQ+XLGdn2hTqbhv+WvtGpJNhffY5W0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

list_lru_walk_node() looks up the memcg for each xarray index, only to
have __list_lru_walk_one() translate that memcg back to an index to
find the sublist.  The walker has no other use for the memcg.

Pass the index directly and drop the reverse lookup and the temporary
CSS reference.  The sublist is still looked up under RCU, and the
lookup is repeated when a callback drops the lock.

Split the memcg-based locking helper into an index-based primitive and
a parent-traversing wrapper, replacing the skip_empty parameter.

This is a preparation step for switching the xarray keys from the
private memcg ID to the cgroup ID, which has no reverse lookup helper.
The unsigned long index type matches the xarray API and fits the u64
cgroup IDs; zero is reserved for the root per-node list.

Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
---
 mm/list_lru.c | 98 +++++++++++++++++++++++++++++----------------------
 1 file changed, 55 insertions(+), 43 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index d1d256822ccc..61248b88441c 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -37,6 +37,13 @@ static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off,
 		spin_unlock(&l->lock);
 }
 
+static inline unsigned long list_lru_memcg_idx(const struct mem_cgroup *memcg)
+{
+	int idx = memcg_kmem_id(memcg);
+
+	return idx < 0 ? 0 : idx;
+}
+
 #ifdef CONFIG_MEMCG
 static LIST_HEAD(memcg_list_lrus);
 static DEFINE_MUTEX(list_lrus_mutex);
@@ -72,9 +79,9 @@ static int lru_shrinker_id(struct list_lru *lru)
 }
 
 static inline struct list_lru_one *
-list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
+list_lru_from_memcg_idx(struct list_lru *lru, int nid, unsigned long idx)
 {
-	if (list_lru_memcg_aware(lru) && idx >= 0) {
+	if (list_lru_memcg_aware(lru) && idx) {
 		struct list_lru_memcg *mlru = xa_load(&lru->xa, idx);
 
 		return mlru ? &mlru->node[nid] : NULL;
@@ -83,15 +90,13 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 }
 
 static inline struct list_lru_one *
-lock_list_lru_of_memcg(struct list_lru *lru, int nid,
-		       struct mem_cgroup **memcg, bool irq,
-		       unsigned long *irq_flags, bool skip_empty)
+lock_list_lru_of_memcg_idx(struct list_lru *lru, int nid, unsigned long idx,
+			   bool irq, unsigned long *irq_flags)
 {
 	struct list_lru_one *l;
 
 	rcu_read_lock();
-again:
-	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(*memcg));
+	l = list_lru_from_memcg_idx(lru, nid, idx);
 	if (likely(l)) {
 		lock_list_lru(l, irq, irq_flags);
 		if (likely(READ_ONCE(l->nr_items) != LONG_MIN)) {
@@ -100,17 +105,26 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid,
 		}
 		unlock_list_lru(l, irq, irq_flags);
 	}
-	/*
-	 * Caller may simply bail out if raced with reparenting or
-	 * may iterate through the list_lru and expect empty slots.
-	 */
-	if (skip_empty) {
-		rcu_read_unlock();
-		return NULL;
+	rcu_read_unlock();
+	return NULL;
+}
+
+static inline struct list_lru_one *
+lock_list_lru_of_memcg(struct list_lru *lru, int nid,
+		       struct mem_cgroup **memcg, bool irq,
+		       unsigned long *irq_flags)
+{
+	struct list_lru_one *l;
+
+	for (;;) {
+		l = lock_list_lru_of_memcg_idx(lru, nid,
+					       list_lru_memcg_idx(*memcg),
+					       irq, irq_flags);
+		if (likely(l))
+			return l;
+		VM_WARN_ON(!css_is_dying(&(*memcg)->css));
+		*memcg = parent_mem_cgroup(*memcg);
 	}
-	VM_WARN_ON(!css_is_dying(&(*memcg)->css));
-	*memcg = parent_mem_cgroup(*memcg);
-	goto again;
 }
 #else
 static void list_lru_register(struct list_lru *lru)
@@ -132,15 +146,14 @@ static inline bool list_lru_memcg_aware(struct list_lru *lru)
 }
 
 static inline struct list_lru_one *
-list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
+list_lru_from_memcg_idx(struct list_lru *lru, int nid, unsigned long idx)
 {
 	return &lru->node[nid].lru;
 }
 
 static inline struct list_lru_one *
-lock_list_lru_of_memcg(struct list_lru *lru, int nid,
-		       struct mem_cgroup **memcg, bool irq,
-		       unsigned long *irq_flags, bool skip_empty)
+lock_list_lru_of_memcg_idx(struct list_lru *lru, int nid, unsigned long idx,
+			   bool irq, unsigned long *irq_flags)
 {
 	struct list_lru_one *l = &lru->node[nid].lru;
 
@@ -148,13 +161,21 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid,
 
 	return l;
 }
+
+static inline struct list_lru_one *
+lock_list_lru_of_memcg(struct list_lru *lru, int nid,
+		       struct mem_cgroup **memcg, bool irq,
+		       unsigned long *irq_flags)
+{
+	return lock_list_lru_of_memcg_idx(lru, nid, 0, irq, irq_flags);
+}
 #endif /* CONFIG_MEMCG */
 
 struct list_lru_one *list_lru_lock(struct list_lru *lru, int nid,
 				   struct mem_cgroup **memcg)
 {
 	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/false,
-				      /*irq_flags=*/NULL, /*skip_empty=*/false);
+				      /*irq_flags=*/NULL);
 }
 
 void list_lru_unlock(struct list_lru_one *l)
@@ -166,7 +187,7 @@ struct list_lru_one *list_lru_lock_irq(struct list_lru *lru, int nid,
 				       struct mem_cgroup **memcg)
 {
 	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/true,
-				      /*irq_flags=*/NULL, /*skip_empty=*/false);
+				      /*irq_flags=*/NULL);
 }
 
 void list_lru_unlock_irq(struct list_lru_one *l)
@@ -179,7 +200,7 @@ struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
 					   unsigned long *flags)
 {
 	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/true,
-				      /*irq_flags=*/flags, /*skip_empty=*/false);
+				      /*irq_flags=*/flags);
 }
 
 void list_lru_unlock_irqrestore(struct list_lru_one *l, unsigned long *flags)
@@ -313,7 +334,7 @@ unsigned long list_lru_count_one(struct list_lru *lru,
 	long count;
 
 	rcu_read_lock();
-	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
+	l = list_lru_from_memcg_idx(lru, nid, list_lru_memcg_idx(memcg));
 	count = l ? READ_ONCE(l->nr_items) : 0;
 	rcu_read_unlock();
 
@@ -334,7 +355,7 @@ unsigned long list_lru_count_node(struct list_lru *lru, int nid)
 EXPORT_SYMBOL_GPL(list_lru_count_node);
 
 static unsigned long
-__list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
+__list_lru_walk_one(struct list_lru *lru, int nid, unsigned long idx,
 		    list_lru_walk_cb isolate, void *cb_arg,
 		    unsigned long *nr_to_walk, bool irq_off)
 {
@@ -344,8 +365,8 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 	unsigned long isolated = 0;
 
 restart:
-	l = lock_list_lru_of_memcg(lru, nid, &memcg, /*irq=*/irq_off,
-				   /*irq_flags=*/NULL, /*skip_empty=*/true);
+	l = lock_list_lru_of_memcg_idx(lru, nid, idx, /*irq=*/irq_off,
+				       /*irq_flags=*/NULL);
 	if (!l)
 		return isolated;
 	list_for_each_safe(item, n, &l->list) {
@@ -396,8 +417,8 @@ list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 		  list_lru_walk_cb isolate, void *cb_arg,
 		  unsigned long *nr_to_walk)
 {
-	return __list_lru_walk_one(lru, nid, memcg, isolate,
-				   cb_arg, nr_to_walk, false);
+	return __list_lru_walk_one(lru, nid, list_lru_memcg_idx(memcg),
+				   isolate, cb_arg, nr_to_walk, false);
 }
 EXPORT_SYMBOL_GPL(list_lru_walk_one);
 
@@ -406,8 +427,8 @@ list_lru_walk_one_irq(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 		      list_lru_walk_cb isolate, void *cb_arg,
 		      unsigned long *nr_to_walk)
 {
-	return __list_lru_walk_one(lru, nid, memcg, isolate,
-				   cb_arg, nr_to_walk, true);
+	return __list_lru_walk_one(lru, nid, list_lru_memcg_idx(memcg),
+				   isolate, cb_arg, nr_to_walk, true);
 }
 
 unsigned long list_lru_walk_node(struct list_lru *lru, int nid,
@@ -422,21 +443,12 @@ unsigned long list_lru_walk_node(struct list_lru *lru, int nid,
 #ifdef CONFIG_MEMCG
 	if (*nr_to_walk > 0 && list_lru_memcg_aware(lru)) {
 		struct list_lru_memcg *mlru;
-		struct mem_cgroup *memcg;
 		unsigned long index;
 
 		xa_for_each(&lru->xa, index, mlru) {
-			rcu_read_lock();
-			memcg = mem_cgroup_from_private_id(index);
-			if (!memcg || !mem_cgroup_tryget(memcg)) {
-				rcu_read_unlock();
-				continue;
-			}
-			rcu_read_unlock();
-			isolated += __list_lru_walk_one(lru, nid, memcg,
+			isolated += __list_lru_walk_one(lru, nid, index,
 							isolate, cb_arg,
 							nr_to_walk, false);
-			mem_cgroup_put(memcg);
 
 			if (*nr_to_walk <= 0)
 				break;
@@ -502,7 +514,7 @@ static void memcg_reparent_list_lru_one(struct list_lru *lru, int nid,
 					struct list_lru_one *src,
 					struct mem_cgroup *dst_memcg)
 {
-	int dst_idx = dst_memcg->kmemcg_id;
+	unsigned long dst_idx = list_lru_memcg_idx(dst_memcg);
 	struct list_lru_one *dst;
 
 	spin_lock_irq(&src->lock);
-- 
2.43.7


