Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C7ABD29FF1
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D013A6B00C1; Wed, 14 Jan 2026 06:36:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCF9D6B00C3; Wed, 14 Jan 2026 06:36:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02D56B00C4; Wed, 14 Jan 2026 06:36:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC9606B00C1
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:36:09 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 796D9B99C4
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:36:09 +0000 (UTC)
X-FDA: 84330365658.08.CDE7A97
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id C04D34000B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:36:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="l/feb+QI";
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V5F7weIJyVWOfAymBhEuvJdsz1rWCiKztrti0doCXvs=;
	b=nQX+cPZPvL0HzG0+SX8Kuj06nFwvOpFUgpjxBdSfQoc3/r96T/uIbJS6M+wNygoyY1sgNf
	/gA9Cswht+EXdeM8VhWBg6ay3+3RSnTG/ZCUzBF06DKWHMcEpZ2CxFkPaL9lQ6oirRNmLA
	w/c2YoGK8LlTrQpN1LFCNHiMNfzXlus=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390567; a=rsa-sha256;
	cv=none;
	b=w+IeE2ab8S6aSQDLLPCKa7z8F9BVGdqcHqCuD5JZg/8Ni8rgM7R9972pasTROlT9gO616l
	KHmoWD64K2SLElDnC1Tldz9L4eYGqXIOTSLrHZhaLcNKOZ68FpGYW3YX1yWq3nUiHsD/4v
	FNonlsbqyBRiAd9EPan7ri5/iNsVNrs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="l/feb+QI";
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V5F7weIJyVWOfAymBhEuvJdsz1rWCiKztrti0doCXvs=;
	b=l/feb+QIbnQdM2saFNcUdHzsCCJp8f3CeH4MzKCDo+k73oxunsGWd2V5xM8U3NUbkXDQ7o
	2DSPnAE00J8c0sPnzrLo9oUP1V88SabVZkJb9gNM0ooVn9fjd4/pyqPWuhSeq5bfV3spgE
	EDTfN14Et2OO0wPccp9+Xfv0YMSxq0Q=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 26/30] mm: vmscan: prepare for reparenting MGLRU folios
Date: Wed, 14 Jan 2026 19:32:53 +0800
Message-ID: <92e0728fed3d68855173352416cf8077670610f0.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C04D34000B
X-Rspam-User: 
X-Stat-Signature: bcds9dhwq138m5463gq6o457hhwsxfty
X-HE-Tag: 1768390567-526069
X-HE-Meta: U2FsdGVkX1/+AVUhpQsrl4GVB8LjwCIGmscJdxFGOLUdNTwsJ7/P6xD4KclqBojZuVu3rVkbATPz9HStv0PMdDrYSTi1tZ7u9d9O6ZRcCEQgK4eZZdZTlUBB44gINQyBkq3yMjmGnVooswUJw7BZlXROOt5kDDUCtLqFR25L7FzT7YdR/xlH/ZrNeIyYyMqjmzI0LOsBKO0jrliKq+9P8dlb6mQXXrpzTeLJg5Mum0dzS++AL+3zg2zHXs+XDldz3HNOGjOIS4tMcOjRUty5kNKJH95DLtC2qz4nmq+p/WdKkjc3Hm899pUa+BaVaRKXl92Nqs9vQbEpxs0Vj5v4T5fQsKoXIVK/0wH24/YAnsy/M/wrbr9nAOqyzHm3S7Wi9XOOVXcYwGfGiqTMB06QclFR3j0E5bm472d893ts6+XrK6KaK7qGRk9hI75tS2mkC+0w5MJ22ioTknNMVARbdp7oRw7UAxRBSa0E7YsPzWSxaiW13+TpSp6/k34Fi5rH/9Hx0dOtbjWPfS+z2IZPic3DMsFwzxupvvDEg0alZ3Ir1qDXpISaaZbKBRKA7zfG4eYfoDtTTv/RUKF3jgh/QkHusWkzm6xwBgp/Da+XFGljn98DOsczxSGBzxP2qt6h8sAkcdSMgIVfgeEKOPiek1ZD/e7uxoSqIZ57BKzaocjJkGgkVkJaGa4YVBTZFI8q2sxUTy3GcDxUxouR3kwVagBvKB5KY6mnL6lRi/N4rh6rV2l+uNUrW1TL/JpMHx7usqj3/OCwya60CNBWQ+l/vodsii0GMDWlkz+nz7bCxuh3GMMXRVmKS+qbN88JTkxopwpRm2vWkalUAdwfq7GzP0v4E01V0PEISmIpbwa+5jbniQLMIZTtO6MsShH6ZxgZvjAR/zvgnHeMFCE6p94Dsv1s/TNy0uy3cx5tTB+Wa6D1VKY+hjcjsXsM7Wj95cwWvteWyupfNI3corfX8fX
 3Ik3xYP8
 LV9B+Nj9SC49LYeMs1POO/Hf+dOjTL4mk72Rn2ZNh/bee3O6Fp62uSEhIE092vXT3xf3SCRfgHq9H5hiyAzP0650JqgHWe1a4tINmNBgMUbNpl4GuFOWmUQBrwzVRhomCSZc4SqA6pUkhEpnno8fuejPBKEya1N4i9LKTWoxQOghoxzU/z6gXVXGoSjjZEUlloA56h9eWHdltHJP/Lf5P+PZvAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Similar to traditional LRU folios, in order to solve the dying memcg
problem, we also need to reparenting MGLRU folios to the parent memcg when
memcg offline.

However, there are the following challenges:

1. Each lruvec has between MIN_NR_GENS and MAX_NR_GENS generations, the
   number of generations of the parent and child memcg may be different,
   so we cannot simply transfer MGLRU folios in the child memcg to the
   parent memcg as we did for traditional LRU folios.
2. The generation information is stored in folio->flags, but we cannot
   traverse these folios while holding the lru lock, otherwise it may
   cause softlockup.
3. In walk_update_folio(), the gen of folio and corresponding lru size
   may be updated, but the folio is not immediately moved to the
   corresponding lru list. Therefore, there may be folios of different
   generations on an LRU list.
4. In lru_gen_del_folio(), the generation to which the folio belongs is
   found based on the generation information in folio->flags, and the
   corresponding LRU size will be updated. Therefore, we need to update
   the lru size correctly during reparenting, otherwise the lru size may
   be updated incorrectly in lru_gen_del_folio().

Finally, this patch chose a compromise method, which is to splice the lru
list in the child memcg to the lru list of the same generation in the
parent memcg during reparenting. And in order to ensure that the parent
memcg has the same generation, we need to increase the generations in the
parent memcg to the MAX_NR_GENS before reparenting.

Of course, the same generation has different meanings in the parent and
child memcg, this will cause confusion in the hot and cold information of
folios. But other than that, this method is simple enough, the lru size
is correct, and there is no need to consider some concurrency issues (such
as lru_gen_del_folio()).

To prepare for the above work, this commit implements the specific
functions, which will be used during reparenting.

Suggested-by: Harry Yoo <harry.yoo@oracle.com>
Suggested-by: Imran Khan <imran.f.khan@oracle.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/mmzone.h |  16 +++++
 mm/vmscan.c            | 144 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 160 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 1014b5a93c09c..a41f4f0ae5eb7 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -628,6 +628,9 @@ void lru_gen_online_memcg(struct mem_cgroup *memcg);
 void lru_gen_offline_memcg(struct mem_cgroup *memcg);
 void lru_gen_release_memcg(struct mem_cgroup *memcg);
 void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid);
+void max_lru_gen_memcg(struct mem_cgroup *memcg);
+bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg);
+void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent);
 
 #else /* !CONFIG_LRU_GEN */
 
@@ -668,6 +671,19 @@ static inline void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
 {
 }
 
+static inline void max_lru_gen_memcg(struct mem_cgroup *memcg)
+{
+}
+
+static inline bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg)
+{
+	return true;
+}
+
+static inline void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
+}
+
 #endif /* CONFIG_LRU_GEN */
 
 struct lruvec {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e738082874878..6bc8047b7aec5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4445,6 +4445,150 @@ void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
 		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_HEAD);
 }
 
+bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg)
+{
+	int nid;
+
+	for_each_node(nid) {
+		struct lruvec *lruvec = get_lruvec(memcg, nid);
+		int type;
+
+		for (type = 0; type < ANON_AND_FILE; type++) {
+			if (get_nr_gens(lruvec, type) != MAX_NR_GENS)
+				return false;
+		}
+	}
+
+	return true;
+}
+
+static void try_to_inc_max_seq_nowalk(struct mem_cgroup *memcg,
+				      struct lruvec *lruvec)
+{
+	struct lru_gen_mm_list *mm_list = get_mm_list(memcg);
+	struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
+	int swappiness = mem_cgroup_swappiness(memcg);
+	DEFINE_MAX_SEQ(lruvec);
+	bool success = false;
+
+	/*
+	 * We are not iterating the mm_list here, updating mm_state->seq is just
+	 * to make mm walkers work properly.
+	 */
+	if (mm_state) {
+		spin_lock(&mm_list->lock);
+		VM_WARN_ON_ONCE(mm_state->seq + 1 < max_seq);
+		if (max_seq > mm_state->seq) {
+			WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
+			success = true;
+		}
+		spin_unlock(&mm_list->lock);
+	} else {
+		success = true;
+	}
+
+	if (success)
+		inc_max_seq(lruvec, max_seq, swappiness);
+}
+
+/*
+ * We need to ensure that the folios of child memcg can be reparented to the
+ * same gen of the parent memcg, so the gens of the parent memcg needed be
+ * incremented to the MAX_NR_GENS before reparenting.
+ */
+void max_lru_gen_memcg(struct mem_cgroup *memcg)
+{
+	int nid;
+
+	for_each_node(nid) {
+		struct lruvec *lruvec = get_lruvec(memcg, nid);
+		int type;
+
+		for (type = 0; type < ANON_AND_FILE; type++) {
+			while (get_nr_gens(lruvec, type) < MAX_NR_GENS) {
+				try_to_inc_max_seq_nowalk(memcg, lruvec);
+				cond_resched();
+			}
+		}
+	}
+}
+
+/*
+ * Compared to traditional LRU, MGLRU faces the following challenges:
+ *
+ * 1. Each lruvec has between MIN_NR_GENS and MAX_NR_GENS generations, the
+ *    number of generations of the parent and child memcg may be different,
+ *    so we cannot simply transfer MGLRU folios in the child memcg to the
+ *    parent memcg as we did for traditional LRU folios.
+ * 2. The generation information is stored in folio->flags, but we cannot
+ *    traverse these folios while holding the lru lock, otherwise it may
+ *    cause softlockup.
+ * 3. In walk_update_folio(), the gen of folio and corresponding lru size
+ *    may be updated, but the folio is not immediately moved to the
+ *    corresponding lru list. Therefore, there may be folios of different
+ *    generations on an LRU list.
+ * 4. In lru_gen_del_folio(), the generation to which the folio belongs is
+ *    found based on the generation information in folio->flags, and the
+ *    corresponding LRU size will be updated. Therefore, we need to update
+ *    the lru size correctly during reparenting, otherwise the lru size may
+ *    be updated incorrectly in lru_gen_del_folio().
+ *
+ * Finally, we choose a compromise method, which is to splice the lru list in
+ * the child memcg to the lru list of the same generation in the parent memcg
+ * during reparenting.
+ *
+ * The same generation has different meanings in the parent and child memcg,
+ * so this compromise method will cause the LRU inversion problem. But as the
+ * system runs, this problem will be fixed automatically.
+ */
+static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec *parent_lruvec,
+				     int zone, int type)
+{
+	struct lru_gen_folio *child_lrugen, *parent_lrugen;
+	enum lru_list lru = type * LRU_INACTIVE_FILE;
+	int i;
+
+	child_lrugen = &child_lruvec->lrugen;
+	parent_lrugen = &parent_lruvec->lrugen;
+
+	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
+		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
+		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
+		int dst_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
+
+		/* Assuming that child pages are colder than parent pages */
+		list_splice_init(&child_lrugen->folios[gen][type][zone],
+				 &parent_lrugen->folios[gen][type][zone]);
+
+		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
+		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
+			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
+
+		update_lru_size(parent_lruvec, lru + dst_lru_active, zone, nr_pages);
+	}
+}
+
+void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
+	int nid;
+
+	for_each_node(nid) {
+		struct lruvec *child_lruvec, *parent_lruvec;
+		int type, zid;
+		struct zone *zone;
+
+		child_lruvec = get_lruvec(memcg, nid);
+		parent_lruvec = get_lruvec(parent, nid);
+
+		for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
+			for (type = 0; type < ANON_AND_FILE; type++)
+				__lru_gen_reparent_memcg(child_lruvec, parent_lruvec, zid, type);
+			mem_cgroup_update_lru_size(parent_lruvec, LRU_UNEVICTABLE, zid,
+				mem_cgroup_get_zone_lru_size(child_lruvec, LRU_UNEVICTABLE, zid));
+		}
+	}
+}
+
 #endif /* CONFIG_MEMCG */
 
 /******************************************************************************
-- 
2.20.1


