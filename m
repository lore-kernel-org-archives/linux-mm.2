Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2023FE91290
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 880DB6B00C3; Thu,  5 Feb 2026 04:05:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854E56B00C5; Thu,  5 Feb 2026 04:05:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76B756B00C6; Thu,  5 Feb 2026 04:05:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 645646B00C3
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:05:00 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E33613AF80
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:05:00 +0000 (UTC)
X-FDA: 84409818360.09.A1735D7
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 782DD1C0010
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:04:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E0Hikakb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LC4iqPXKX4JqCbY08+MGvYe2b/fpKFtSRqsBEFdYhfw=;
	b=4t1tgtqhap15bS1QnYl77OFsZJvpjlg8x761Sl36S0IiaDPCzFrEDB1pOraYtitPe1HU4W
	FvAz10/HHKygJJcqIUu47mKZEahwZZagJk+krB3U8ucc+b6K7aqoxPx8eBq0c8FOpGGvcO
	oxeKB96invlISpjTTg3Vn8SL2i/FBq4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282298; a=rsa-sha256;
	cv=none;
	b=YI/gELUgQGE1zGiE+hWtA1pQkWDX4jMkozcsx5EJk0PcRhCQnv8HxTYoYcxbHd79dNkxfQ
	9PtQ9PE8t6O9ZDFsCi2syoOnBPmM7ouXpBu8SNtXBo76v+FZQ3uRFb52j72LS7WH9w7ehz
	CtwPkm/kZhp86zinQZJS8S7heiXBLLo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E0Hikakb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LC4iqPXKX4JqCbY08+MGvYe2b/fpKFtSRqsBEFdYhfw=;
	b=E0HikakbEMQARdniSwdCgOZSUknY1RorlHQgEST9mmB2pVxokgNEGXTxeC2beDkOb5kh5R
	b7hruGUDiY2W4eHw2Pb0tCVTCIHnMRTb1u1XfE9cqhxVyOEJKXSd+txA7Q0Ds509Oj9TiB
	9bPZ82gqKLYDbs4DeJguGJadeRpQVUA=
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
	lance.yang@linux.dev,
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 26/31] mm: vmscan: prepare for reparenting MGLRU folios
Date: Thu,  5 Feb 2026 17:01:45 +0800
Message-ID: <2cea0e0cf208e46dc55f2baef8162bedba2db47e.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 782DD1C0010
X-Stat-Signature: f83dy897cq9cf6qf8fqzwq5c5g9yfnad
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770282298-783597
X-HE-Meta: U2FsdGVkX1/FxBm3o42jev5RbVA7ybbueFrTDKWzk5ne0wzkHRYYQ2oI0W7w/HhnRFe6RPJOA6HfrgQolQtK+d6vsU09nkPl+1Hiu5fcfF9ubSFIzYyZKhLInvqABmuZTZvykIkhPVDXWknMxo28cq5vu/VdXKcKvxPYifn43/tUD6DGiUIRtbD1J9L7yDKsdwttCcu7POOLlRWTZQVK3uVMmEJuzfX9T0KyRqeKGp+bZOgPBJyjbgFLN8AyVcijuTYRQUuvDMQhGq04y7wqDUFoFoeNAdszSpWCYDL7ADnEdkmNKPW/uL9PzmpVf0q9dTjliFQsRnzLdkqr6An4YIHhrSxZqADRhW8TlBTbKx1mzJkyzf8zAlwCIQgl8TriIQebSXYqkrlWcospfvUTfpPygJlqHNBybdPppl+QtgEafuZko6GK07eOBCBoKRcsfZWESyE6IdLdgtr0lFdmEQe2p9UZ8ctTTgcVCKvDKvrlhJPZd5JBBLhYtwDNYsCcsuMav2TylIYwDEhQeuvyFPhvseCKt9VJMpd6iYiHcFAHiWZ1kCGnvU7FlJYsJfAzZKJv2QbUDzEUea0EuBzReYYKC5xK2xT5ZCR+4SlQ8amIisBebw3MBO9RVD+P3qe+XLxRiqoa0jZtjslnTBlknXP3+5vPSG0NtkCdSL9rf/oKb56Ok4e8bfT329nCfl8N4UCeWZ6qNMEXGNiTcWnT5hAl7V4SNeNrwmvWFVf5sHIXnzqQ+G2LYScoBVr9VF7PDpCVXFarM5bk1u6QW0K7bmwPGqJoUKopAsFCbq+5EOCYomsEEdQT3AWTSuTjubYEt3sKVUK0UdUV5yoZcHYkRKa7OFS/c0Fq4Oc9quHBEIgHVYHPWmS/b4OGL8aJE+/EdGkVXeN7zqiKIhNrYlOwGQ5SvQ12frJOeIKLhRqPUuESEJO3N3ijO1YnOOMquRxBO4b895QOQjaI9NAtyOv
 ekv4DOLU
 E6OEEtVeKvuNILWeIkyLorDZ/PWT1PRUWMEqSmjCNhKEaLNL35NszMfYCvV3AvO/nRa/rQLoYsJlvAJ1Uf2oEInycd1yEIzM3JRNQL7g8ov6jJ0drfyshEYLlhvMIHJ1BDW1fobDaEtToy6NAlDkXENL1/yUEcUGdRPV/cypiiwLS+Qg=
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
 mm/vmscan.c            | 154 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 170 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3e51190a55e4c..0c18b17f0fe2e 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -624,6 +624,9 @@ void lru_gen_online_memcg(struct mem_cgroup *memcg);
 void lru_gen_offline_memcg(struct mem_cgroup *memcg);
 void lru_gen_release_memcg(struct mem_cgroup *memcg);
 void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid);
+void max_lru_gen_memcg(struct mem_cgroup *memcg);
+bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg);
+void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent);
 
 #else /* !CONFIG_LRU_GEN */
 
@@ -664,6 +667,19 @@ static inline void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
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
index e2d9ef9a5dedc..8c6f8f0df24b1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4414,6 +4414,160 @@ void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
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
+		int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
+		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
+
+		/* Assuming that child pages are colder than parent pages */
+		list_splice_init(&child_lrugen->folios[gen][type][zone],
+				 &parent_lrugen->folios[gen][type][zone]);
+
+		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
+		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
+			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
+
+		if (lru_gen_is_active(child_lruvec, gen) != lru_gen_is_active(parent_lruvec, gen)) {
+			__update_lru_size(child_lruvec, lru + child_lru_active, zone, -nr_pages);
+			__update_lru_size(parent_lruvec, lru + parent_lru_active, zone, nr_pages);
+		}
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
+		enum lru_list lru;
+
+		child_lruvec = get_lruvec(memcg, nid);
+		parent_lruvec = get_lruvec(parent, nid);
+
+		for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1)
+			for (type = 0; type < ANON_AND_FILE; type++)
+				__lru_gen_reparent_memcg(child_lruvec, parent_lruvec, zid, type);
+
+		for_each_lru(lru) {
+			for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
+				unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
+
+				mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
+			}
+		}
+	}
+}
+
 #endif /* CONFIG_MEMCG */
 
 /******************************************************************************
-- 
2.20.1


