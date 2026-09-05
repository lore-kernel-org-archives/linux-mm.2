Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 999DEC79F89
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 03:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73CA86B0098; Fri,  4 Sep 2026 23:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ED316B0099; Fri,  4 Sep 2026 23:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 604126B009B; Fri,  4 Sep 2026 23:05:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BDD66B0098
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 23:05:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B45AE4025F
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 03:05:51 +0000 (UTC)
X-FDA: 85178218902.17.1DCE996
Received: from mta1.migadu.com (out-137.mta1.migadu.com [95.215.58.137])
	by imf26.hostedemail.com (Postfix) with ESMTP id B88DC14000C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 03:05:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W4umrh0I;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788577550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIv257LnOhPcN/U+nBTiXeeSnsXB7qeGFe9XRjwzLeE=;
	b=N1flfdiBhM2pVqivJaI5E0nPrkeZHthYUalRGtLrftvv3Gf1+CWIngqrcFNLs6jMORt3Ox
	kYL0TuSrgLDBKvDgZRSYr0NFy6y9vsrG5TmwqC+m7+vQi7h1c1gregAhg3ite8gI4EvvVp
	0PkEhEkZEegainAQXO44V5ign8ZUygE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W4umrh0I;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788577550;
	b=3ERN555Gh+T1b4Ja3kbdrk4hcdtLLeStEdfXPzCB0DOTnrOgCRQw3RnLmL8SfiM59yCyHX
	W0gEGfMlnWw3szMFaYUfPzCMY4p4bO9uCA7SsI4aHI0UqM+HIBvstPZGNJfff86r/hQUZ4
	VgQ5Gz3+oJhy1SgT0LD4bKYgY3ju+hQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=F1dMlE3SNbCaduwN58Kn4je6GZ6Gq4FaW4vEejZffVI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788577548; v=1; x=1789182348;
 b=W4umrh0IBWw2xAtN6p/GkEoZsBz4q6SjKzBfB2DcwN7fRn7kt1mQY1OM5kwQiDY0aJv2Cslo
 Mha+oI7LfBQ/iYrxmRdjM1sX8svD2NsmLC8YtT/dLYK+JBD72iYOVv97jucH4b5YpUx0ZdYg5KN
 2Xykk6h1w08ilRUR5LxPhN4Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e1ea12b19bf4cab9;
	Sat, 05 Sep 2026 03:05:48 +0000
X-Mizu-Trace-ID: e1ea12b19bf4cab9
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] memcg: group the fields of struct mem_cgroup_per_node
Date: Fri,  4 Sep 2026 20:05:22 -0700
Message-ID: <20260905030522.1887837-7-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260905030522.1887837-1-shakeel.butt@linux.dev>
References: <20260905030522.1887837-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uwjxf5ykj73t5f15wpc78jqwp99gbrpj
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B88DC14000C
X-Rspam-User: 
X-HE-Tag: 1788577549-988314
X-HE-Meta: U2FsdGVkX1/xPi+J4EDR7d8ZSn1bLFgNybDIIRXC54l6eJFlC3VIm+4RMb+/KyMdD3biqdDjDDwFndTJdlDR+R43umg0vxb91AvEQ/p9nta5wGTPqnwAYloVqPb9djZmCTYnXKA5lzcgR9xjlFi/mfqMmheBLSUwncF4UNlnJbljfYLPWZwpvzsDh+3pP0nVplhiP3kOsB9LlQ6uAt/tZWjLgVMewpHmLjMRIWFW3vegyk+7f1XI0hEUI7kUkPUwVvuIPYkQog0/zk1MTn15fYIifNwrSf0kWg2AEiMpROb6hrUg6jDwcUpnZ9Shb9jxf4RDynP1SdKB6sB7ZhgfgtjVu9LcGSf2iSMmhlC34/9PBZ/vWiDjlg7fsRXX6T037bT5XnknOoyOXJDXOyrzU5FtaTZ5jthEZ7AkG4wmpQbYpuybqlce9lNldyirBfmmp9kIxMh2NS4E/Wl5Jgilo9wtOujkk2wqfT57GmlM8AX590hIpqvgXnoMGmBcqssODrUT9ZvAgCATGkIDTuI+BcswXPRqd4Dxg5XLsFlQ2C9tNyglbygWjKECXHnS0byW4cD+TONRwe74ylTaBJtOIWhNhwqxLi+F+MCu+yw1RVo2y3n1+MxjEvuwfkIxbKz3SORrL2FhM6JwGHkf2bxnZKI4nLsMZjQHEfP/mXRvr8/22f+MTqLdrPhi9N07hRwRCqK20+X8SxJStksqOPblnTfjyrf+IJAObaVEq0y+C1Eh0QUFOyBng6hC3F157ht7zHf/m5sgdC85psQHvkFLcRMTCTzfrzSm81S2qWDrDnk9XU7cWcSq+YSiUBXlABXnsUM3GSj9eAKjwS7hY9rowkIxI3p5v77+2+REEhYAbcpHA8JGtBUFrXifJjy4PJ1QX0B39q+cuTRKH5EHKi3IPUidcpODZrgOIC1z5TD6jKLqvxL+GDa+EubBF1cbDhglj32ZHhrbGjDyznfRDIL
 UPZv4W0b
 uABiO4wrZ5QkaanLpdQLsJsu3USWXD/qE2zJoUigey1ydKEUWZ70vOt9lFQWSiHalzvwfU1X9OR0JKpd5PntqYY2rliMu+KwIBgMkbSaJ4T+YjPpaGnTCbjDxfQ986Fx8UeRjQ/HnpZtte1c9uIXowD37nDAfzuGjW3y1w1USI61kNKSwipC5B4QokdeUY+nRTfHT9ldh5on1qVe01TL663IMaGNxMhO1M/absVWlBg6NG2VbzlZVghwC5DrKZU/0LZTgJ4xPRGzPZwcA+O39LGp8FA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the two ad-hoc CACHELINE_PADDING members with named cache line
groups:

  memcg_pn_read_mostly   memcg, lruvec_stats_percpu, lruvec_stats,
                         shrinker_info, objcg
  memcg_pn_lruvec        lruvec
  memcg_pn_write_hot     lru_zone_size, iter, nmi slab stats
  memcg_pn_cold          orig_objcg, objcg_list

The group markers give the same isolation the padding did, but they
are named and the build now checks them.

lruvec still gets its own lines. Commit f59adcf59332 ("mm: memcg: add
cacheline padding after lruvec in mem_cgroup_per_node") showed why
that matters: lru_zone_size[] is written under lru_lock but read
without it by lruvec_lru_size(), so it must not share a line with
lruvec.

Splitting the cold fields out costs one extra cache line per node per
memcg.

No functional change.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 32 ++++++++++++++++++++++----------
 mm/memcontrol.c            | 30 ++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d0f3458f9250..e10a3eaae890 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -82,7 +82,8 @@ struct mem_cgroup_reclaim_iter {
  * per-node information in memory controller.
  */
 struct mem_cgroup_per_node {
-	/* Keep the read-only fields at the start */
+	/* Set when the memcg is created, then only read. */
+	__cacheline_group_begin_aligned(memcg_pn_read_mostly);
 	struct mem_cgroup	*memcg;		/* Back pointer, we cannot */
 						/* use container_of	   */
 
@@ -91,14 +92,30 @@ struct mem_cgroup_per_node {
 	struct shrinker_info __rcu	*shrinker_info;
 	struct obj_cgroup __rcu		*objcg;
 
-	CACHELINE_PADDING(_pad1_);
+	__cacheline_group_end_aligned(memcg_pn_read_mostly);
 
-	/* Fields which get updated often at the end. */
+	/*
+	 * Keep lruvec on its own lines. Sharing them with lru_zone_size[]
+	 * regressed, see commit f59adcf59332 ("mm: memcg: add cacheline
+	 * padding after lruvec in mem_cgroup_per_node").
+	 */
+	__cacheline_group_begin_aligned(memcg_pn_lruvec);
 	struct lruvec		lruvec;
-	CACHELINE_PADDING(_pad2_);
+	__cacheline_group_end_aligned(memcg_pn_lruvec);
+
+	/* Written on every LRU update and on every reclaim iteration. */
+	__cacheline_group_begin_aligned(memcg_pn_write_hot);
 	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
+#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
+	/* slab stats for nmi context */
+	atomic_t		slab_reclaimable;
+	atomic_t		slab_unreclaimable;
+#endif
+	__cacheline_group_end_aligned(memcg_pn_write_hot);
 
+	/* Touched only when the memcg is reparented or freed. */
+	__cacheline_group_begin_aligned(memcg_pn_cold);
 	/*
 	 * orig_objcg preserves a pointer (and a reference) to the original
 	 * objcg until the end of life of memcg.
@@ -106,12 +123,7 @@ struct mem_cgroup_per_node {
 	struct obj_cgroup	*orig_objcg;
 	/* list of inherited objcgs, protected by objcg_lock */
 	struct list_head objcg_list;
-
-#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
-	/* slab stats for nmi context */
-	atomic_t		slab_reclaimable;
-	atomic_t		slab_unreclaimable;
-#endif
+	__cacheline_group_end_aligned(memcg_pn_cold);
 };
 
 struct mem_cgroup_threshold {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4a5a30439a03..6976a60c911f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5796,6 +5796,36 @@ static void __init memcg_struct_check(void)
 				      kmemcg_id);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      oom_group);
+
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_read_mostly, memcg);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_read_mostly, lruvec_stats_percpu);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_read_mostly, lruvec_stats);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_read_mostly, shrinker_info);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_read_mostly, objcg);
+
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_lruvec, lruvec);
+
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_write_hot, lru_zone_size);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_write_hot, iter);
+#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_write_hot, slab_reclaimable);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_write_hot, slab_unreclaimable);
+#endif
+
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_cold, orig_objcg);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_cold, objcg_list);
 }
 
 int __init mem_cgroup_init(void)
-- 
2.53.0-Meta


