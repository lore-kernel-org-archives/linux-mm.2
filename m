Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21875CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF6AD80163; Tue, 28 Oct 2025 10:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3F498013F; Tue, 28 Oct 2025 10:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2E5E80163; Tue, 28 Oct 2025 10:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 839248013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:04:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48DC012A858
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:04:54 +0000 (UTC)
X-FDA: 84047694108.15.10F2794
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf25.hostedemail.com (Postfix) with ESMTP id 96EF1A000F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:04:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rVxvyEdK;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/NlFh6JZBSK01bz7xFAPu6gc4AMfcAw/edRnb/5hy/w=;
	b=0+uelyl6jCrAbHf7++alGVbw5uEbUgVr5+Hs6NFBxKmN7f8ZdMaYXS9p0g/Hi/53casbHo
	RZcsIV+PZqcUTz4aKqJhfp0Jx0nAt5P+lQhMo2+jA2yRmmEs+9kJVpY/gEdUaymtlHGmyx
	W9XR3TURe2hl4TDQ2+lfDQzdO+4gZgk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rVxvyEdK;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660292; a=rsa-sha256;
	cv=none;
	b=jfwBL0ejcLm0ZWcLx7XuJmh0vC5VBMEeXxsisD9T5oGZOYXXLNTZoWtDZ7ILINYYbnfXPd
	rXqPV1DxpjutCyE814WWUrGqTwYiJW1XaSH0p/PfxoPbZtfLBsB993L4ncUjpr8B3biqft
	tHD/Pwdva0UtI30yKWfB83Ufabzgdjo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/NlFh6JZBSK01bz7xFAPu6gc4AMfcAw/edRnb/5hy/w=;
	b=rVxvyEdKqZsKYbizlGoj5w1+xNdO0odOM+rCoiyzALnMIy7ike96ihWGIzWYiy4tbbGDIM
	MFwF4TLRfWcQFpmKN7ZvRLWlEEuHXF3FEA3g8mCAQJ9g4p+yLKsbKZDNT459dRFG2IZcSB
	B8MqCIlQiBRG+tgkrW4RswTqYCqY1Y8=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 23/26] mm: vmscan: prepare for reparenting MGLRU folios
Date: Tue, 28 Oct 2025 21:58:36 +0800
Message-ID: <cdcedd284f5706c557bb6f53858b8c2ac2815ecb.1761658311.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: r6935f3gd3drdwk749wr5y4qm4agfeg6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 96EF1A000F
X-HE-Tag: 1761660292-283443
X-HE-Meta: U2FsdGVkX19KTzqvJ6LB5vFZzP30qlolCQcm/zKNZAj0LjkpxQ2ip4XT2w5bSD/toEDpy56BeEbBo5pEX+q6KJbY162sxPgeV8iaPkhmyzINJrQae+SQ7zeMfoVyR+Sk78ttGz9UC9Qw0B7VK28FgHEORAjdP+9YNenDJHxj2Z4eVEVz61RM7HdlrqLdVDQcOFPMP+C3mbnn6+xZVdDaGSIXkc1psCW7xor11OAYEs+gpkkQKhhcGYw20HvbEDUdNukv3o5I8dmb2nB9kB37Dz5qexoPNEB4toDE9Y/PhFEFqbgw/GBLEAuGBfsNkz9c1tp4to9oMmWlI5tM47hIXSDoaov559MVoyB+zzsLxQGoaXlasrAmv70F4s8FOVxEdGqcrkJDngJifcMX6Me8lIVXb1Ijc2Vqms1WYIKYdF76OQnQYgJc0IjCx5QdcbrCsUdq3KWu3IpnXgn8z1YmXN7IV7IiL1rl0yBNiKiHuhvmautLufDy8+6t9KRvOGaKvD7Ok1z4SWuiR6gLqmXCtj6dqAMlnNtGsdQ1/efxRbNQtTyXOxPvPUY8mSpicYT6449m6hytcLd0e0aoIxKA23CBq+0NDYq3AXxXzSqXUeLxt7hM1mG46uR1RHTWDmoGaZs7Yb/9Ikju0xE0aRTz07UF1ct0DZK1tSnbHu9SHBq4R+fEldrA6Xg5cwBNnkkdpNQI1GCvatI08/X1LkwV0LjjD9oaaWyTiZSfpaFLL6s0C4N+vvp64tUKrdSxrRLeTqb9S6lw4T6Jjss5PffvYw/8ugop5FBE0orayvd3ZU/eRmaT/j7mau19J0nF/FTcIZSXk2UXrdw44CnI7+2aaaA/27xEgmdK2v+3zeoKQLbug0VEtcXreLiOaF4BkHHt46+eAUeT+fjoJ7zSrQ4aCK1JbnoyhmCGNfn+WV0rH/LJiMZIwSgWw6ZEtQcEuhSG4VucmzFIv3B6sTlWwZH
 Q3+asY3d
 ahAHGbzYArUEAoslOsCHhAzFIrG97BbtmnYfbXP5alMy279gqoXxrXJ416TEO3Kbmq9s0AbHOisQ6mvFBtA8bHhh+EJgkIkNTqp77sdeJ9XevV9JTdRnsUfyiG8eZmqG4zRNCuS69jSZ1FG/Cje2SyS02QbAnhiNeo1UErYut8s1l93QAXqprU/XTvuFBmLdLRlWTLobCjWTsADtHLI5GvjE+aXlYuqK/5ITCAeFbksNpukUJ9RMSLLPOxA==
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
 include/linux/mmzone.h | 16 ++++++++
 mm/vmscan.c            | 86 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 0d8776e5b6747..0a71bf015d12b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -628,6 +628,9 @@ void lru_gen_online_memcg(struct mem_cgroup *memcg);
 void lru_gen_offline_memcg(struct mem_cgroup *memcg);
 void lru_gen_release_memcg(struct mem_cgroup *memcg);
 void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid);
+void max_lru_gen_memcg(struct mem_cgroup *memcg);
+bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg);
+void lru_gen_reparent_memcg(struct mem_cgroup *src, struct mem_cgroup *dst);
 
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
+static inline void lru_gen_reparent_memcg(struct mem_cgroup *src, struct mem_cgroup *dst)
+{
+}
+
 #endif /* CONFIG_LRU_GEN */
 
 struct lruvec {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7aa8e1472d10d..3ee7fb96b8aeb 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4468,6 +4468,92 @@ void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
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
+				DEFINE_MAX_SEQ(lruvec);
+
+				inc_max_seq(lruvec, max_seq, mem_cgroup_swappiness(memcg));
+				cond_resched();
+			}
+		}
+	}
+}
+
+static void __lru_gen_reparent_memcg(struct lruvec *src_lruvec, struct lruvec *dst_lruvec,
+				     int zone, int type)
+{
+	struct lru_gen_folio *src_lrugen, *dst_lrugen;
+	enum lru_list lru = type * LRU_INACTIVE_FILE;
+	int i;
+
+	src_lrugen = &src_lruvec->lrugen;
+	dst_lrugen = &dst_lruvec->lrugen;
+
+	for (i = 0; i < get_nr_gens(src_lruvec, type); i++) {
+		int gen = lru_gen_from_seq(src_lrugen->max_seq - i);
+		int nr_pages = src_lrugen->nr_pages[gen][type][zone];
+		int src_lru_active = lru_gen_is_active(src_lruvec, gen) ? LRU_ACTIVE : 0;
+		int dst_lru_active = lru_gen_is_active(dst_lruvec, gen) ? LRU_ACTIVE : 0;
+
+		list_splice_tail_init(&src_lrugen->folios[gen][type][zone],
+				      &dst_lrugen->folios[gen][type][zone]);
+
+		WRITE_ONCE(src_lrugen->nr_pages[gen][type][zone], 0);
+		WRITE_ONCE(dst_lrugen->nr_pages[gen][type][zone],
+			   dst_lrugen->nr_pages[gen][type][zone] + nr_pages);
+
+		__update_lru_size(src_lruvec, lru + src_lru_active, zone, -nr_pages);
+		__update_lru_size(dst_lruvec, lru + dst_lru_active, zone, nr_pages);
+	}
+}
+
+void lru_gen_reparent_memcg(struct mem_cgroup *src, struct mem_cgroup *dst)
+{
+	int nid;
+
+	for_each_node(nid) {
+		struct lruvec *src_lruvec, *dst_lruvec;
+		int type, zone;
+
+		src_lruvec = get_lruvec(src, nid);
+		dst_lruvec = get_lruvec(dst, nid);
+
+		for (zone = 0; zone < MAX_NR_ZONES; zone++)
+			for (type = 0; type < ANON_AND_FILE; type++)
+				__lru_gen_reparent_memcg(src_lruvec, dst_lruvec, zone, type);
+	}
+}
+
 #endif /* CONFIG_MEMCG */
 
 /******************************************************************************
-- 
2.20.1


