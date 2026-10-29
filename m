Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95220606A323
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oLZSPrRP
Received: by kanga.kvack.org (Postfix)
	id B02EC6B05EB; Thu, 29 Oct 2026 16:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9726B05EC; Thu, 29 Oct 2026 16:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EFBD6B05ED; Thu, 29 Oct 2026 16:42:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 764AB6B05EB
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:42:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A0FDA0517
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:42:45 +0000 (UTC)
X-FDA: 85376837490.03.3D62903
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id 57DFE40003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:42:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oLZSPrRP;
	spf=pass (imf07.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=w/WnGJOegOoSLg6t17xX/8xCyLj+uCEUKKeXduOsb7c=;
	b=4ufE0B6AIhcI+Pc2lmbACCKvYm3Q1R2vLMJ2GC3M0FdUMD+geCeJKkSz/2cvi3BoMwdwex
	F53sdmtw84PLVjvGpgoRQKO/j2etbZwjh+bhUJUd8wv19tmTuIqSxSHRg1Li9qDkZoO7Q/
	cvIABKqqD4ja83OhnAbLkql73XLk8RE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306563;
	b=Vyop9hdIOILGBgO5LbwhXi1R9/cp/wuR8y/7Tgunp5l55YakjvEDuTaJQOJ+jrZvE/5Fjb
	pnPS1DJkTxuOAHhC4PTL+wauVfjdMWijaF3RT5vWOqaCgxJYQOaryIRP7R1zkKeYfhUzqg
	2eYd8GTJTSHeJMwJrbVt3gt0YiPykz0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oLZSPrRP;
	spf=pass (imf07.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-8ab432273c5so401967b3.3
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793306562; x=1793911362; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w/WnGJOegOoSLg6t17xX/8xCyLj+uCEUKKeXduOsb7c=;
        b=oLZSPrRPg+e5c0WWh7hgbaao0Jf0k41ATcfl8wi5OA9IHng9X1eSqZRE5YzL0WfW8c
         HuSRL7ksVSWpuHiOixgRo47ILYTqjyNXUVnjVfZIgpK+uQ0k6uUKIePWfivtjrqsqCca
         3KGhDpQXIwRxCzqWJF7Ki/t/31i8ODoaEU43KwU5zTZACjYynWNQHDVUJe1lHdAdAI7u
         6YMuq271ftVjcYULa1FNxMZIf260QSV0DYae4KVxQ/063Z6u6TmnAI9GdqLm4od+VkKH
         DH5yAaCOyuPVTiGQc+nPVY2r/BH5i5pJXpA5kzjuFsHvxuDseigiXFk65jOad3b5jNHd
         qgcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793306562; x=1793911362;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w/WnGJOegOoSLg6t17xX/8xCyLj+uCEUKKeXduOsb7c=;
        b=0r6lMyJHPTA2iQz7rV8cKxGqmp4JP9m2BTf4OHogiprsgDHBzJG84IMbQLNRcgEqa8
         eVWQmny+FQOLnnOnS8Xaf/zBvc9IjFad8iDuj2Z8qtZZNWkb1+VK5SfVdw9xHywdFLy0
         jJ2xejGu4GB/aIxCDB7WYO8LURjw0bmcdsleBrOIyPj71Ijl/cT4PRQC5qa+tgTn8Cw9
         d4gKJKdithLO1FCXT0xMXzpUKGjXjKQapnmYi9sAkPJpvelzQ8n7z57R16kTp2h5P/ZP
         9G4oR4yV8f682WHbjxo1EAf2LnUULepz8RJhcS86Jp65Png/K+PA7Uo7cMjHgYeBaTQK
         eiRg==
X-Forwarded-Encrypted: i=1; AKwUvByvo6BHOzqrAvlDyqVwlNbEJUXpQx2r7VjSQlRTnvjSLGGS3j/gpBhA/BGYkOqkZnUQJPoe/647Bg==@kvack.org
X-Gm-Message-State: AFq9FYLwmJVN2Ti6EfvSGHtn8EK4Ren3NsUyGbSDbNasHedoNNi8kO0n
	Zj4i8mfkFnRl+Br9z9V2LFBPFGINEz+bCxv52HcQF9RtzRIVioMCW8/r
X-Gm-Gg: AYBFou0HfN+TBpToUAD29V7gda5Jds1r9H+RTSYcEbViX0yQeb8qzsYMh7W6oxhiV0l
	2Z6aVyWDRn1STYcg9jesG5k2frI72f8ce7iskadA/kGBQ0i3WMW/v0gB1krbyim8TbKfok0jZGC
	sDFKllu4Nk9YEvY+1mVHjDoszgMQoz+FWyjVVZjBMFcK2vVy4MQZfR84jfToQk3hqwRLE0lLLp1
	Dgml4CQ+KEDXLYbRiNkMpC8c34ZXsH0bPWTUXef+gpYdtUk3ZD8hJ1Y6vi0Tk+h3kXITW3/XaUR
	79zZuuOdBLrIp7Rsv81EYYHKi3OfKxlHLtVrQvD65K3+7piOil23nE5R6CtKkJevpGSAD80w1k1
	bVR5+N/vhmAERwsQG9m1pHQa7tXNZlnwkQYth9nFArYbmgEti7hpKdUTmbaxevsBx3XdiP8atq2
	iXjR8mMYh6WUiVYQT8aPdq+5IBx90+zCaW6GvNMlmsc1xNet4gjDP17fMY1MtiHMmCtSQiamckT
	yM7j8NGwBqLbu5Jic7J1RvnY6D/lSMGFqx0ZvPvO7Ot6e++gR8aNO7IeoxDZGSFhAzLiAMcZDh7
	26coP4dfvvu8ZHSUohmyEQLoAAMTKpncb+M3R7S8c4RIEQ8RGYFC3L/7HlcL91r+QPCd9orSQ7A
	gZbDiGKLWVuyKNc9+q2czxWJhTQ==
X-Received: by 2002:a05:690c:f8d:b0:8b1:60a1:cd3b with SMTP id 00721157ae682-8b2b6738972mr619647b3.24.1793306562286;
        Thu, 29 Oct 2026 13:42:42 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:1::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b4b85986sm1522527b3.45.2026.10.29.13.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 13:42:41 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: shakeel.butt@linux.dev,
	yosry@kernel.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2] mm: move LRU size stat updates out of lru_lock in folio batches
Date: Thu, 29 Oct 2026 13:41:57 -0700
Message-ID: <20261029204157.117879-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 57DFE40003
X-Stat-Signature: cz8q1971fjz3dgyxqkycexjtap4cbpbx
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793306563-370136
X-HE-Meta: U2FsdGVkX1+DtwWs+YuKAdGSOFodHK0AHTMUdiyoErQVPN+CVGBcSRirflKZl+9ZKtTHcj9L+ZX0QNe75ZlCJDek4InJgvWoxFjeH5hmCt7nbgnFhZUXmCeZ8pcKiUjBrC+90pI4dopN/z0tmknNrTIIj9Kv/9hVKSsSYC36s/muATNg/dTTZWmvsOvcIqmwNu6hq10z61cMduIxK3VaJf7fOLonpQvd91EOndE4Gx48Sc+l9mknmdNNThiKLEeZHQmzwP4zC+FVul24lk8UGcL6oFsbJC/dhNY7pE/3X2rSJTwlWIADi09sWDEfGL1ZojwN60qXgvVIFId/l1i7DSBFyU7wngXqnNCGSFD5OwUShX7tk0NDL9t9q7aiBOHXsfNkG71mbHVQiVQ6N9qoSeZDBTbarqci28GONjqjnyF4YUioB4gP1+vpwc6Ui8DPBiZPOxn1Cqag9vuO/VACrVwLvehs26HHdt/s3tbPpP6AcN8PK8OlzaoYK8z1Y32h2nmBALsLPbR/Uix16nvR3YWkT/XFw3tK49Uso2wRVXKeNuFsXrl6u+ob/frdz9RH0Jg/ypcCjHmj6B0O3d6CgG4SsDBZV1nd+LQ4RourpayOTRyqnfuWIsj9p4avlWDk24SETC5SbiFAGAy4mbGfVAujC/R/k4QrLaVqr8939uB/af1sBJr7XCluUJuCYyP5e1eIFOkMzsOzrk0hmB4VdkwX0doT1jE/5VAfkGvXTymsF3NoutMlxdc9sNZfaMU10H9DNrq4YqenAJwb5AyVIP30BsWvxtqJAyB9438S77AaOfqp7uaSWCj78LstRgI7xNyL7Zmf/KqTuBg5h2QrPS3j6mAjrDvVOa6EAGf10VkIXpS1nax5DtvdTaL3QUcvOK8LDJCya4EtP+MBo6J5uTpqc/lipDmTk1brwwcrKcaWJD/CvXQ+1jxzF2io/k6ETX6BeHxhB5pq+an0MAF
 lp5aXega
 SKB+d2xCp2xHTfUJMkFCggXknvRl68rcFgnxFmB3rPguq6foSAN5joCVvJyfAsQajue+MZMPNkATXeyQc6/9ga7Ugyy6HDfbpG+T4xNQlQQoioUZZqMkYy18FtaQ+EF1RrYYvIsdx9qlx1TAx6gAhJi7Oyryw3lcKTXywcWTdV2YzEhiO1XpXI38zJDStEhwiM/ZngVCo0X2ED0IPZ1OKGMyWRJXCE4kWuRDKQPk0QDrUiuzYbwKnSgXi6QMFV8g7P7X89ip8f4jelXFz8e5yGM5qzGO15SWj1AiuAxe1YvPerrEf7XUt7kQaEUYTNYYScGn+N6p12ZvMVvTVPhwZUANvv3Ovv1UCJXd9aIOazXrONX5WcoJX88LlClfK9jEauhBEsHqA8v1r39jFjmZQsbjT/NXJUH4GlOAb8CBF56IHu2fxQDBTXqpm+qrlTWympy+QhQQdFZ3bc0XPrX1uWzVezlxbb9qe8M7JnNtiJrxPwjEAbZcLENpwf+SQqen27jQr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

folio_batch_move_lru() and folios_put_refs() take the lruvec's lru_lock
once per batch, but they update the node and memcg lruvec stats for
every folio in the batch while holding the lock. Only the LRU lists and
the memcg lru_zone_size need lru_lock. Updating the stats while holding
the lru_lock is unnecessary, and they make up a large part of the
critical section, as seen in [1] where a change that added just a few
instructions to the memcg stat update path cost about 2% throughput
because the LRU stat updates run under lru_lock, and the overhead went
away once they were moved outside of the lock.

With many threads faulting and freeing memory in a single memcg, about
half of all cycles are spent waiting for lru_lock, and the hold time of
the lru_lock directly limits throughput. A perf profile with 80 threads
faulting in and freeing shmem in a single memcg shows 52.8% of all
cycles spent spinning on lru_lock, split evenly between
folio_batch_move_lru() and folios_put_refs(). About 25% of the time
spent holding lru_lock in those two paths goes to the LRU stat updates,
mostly cache misses loading pn->memcg, pn->lruvec_stats_percpu and the
per-cpu counters. The stat updates are only 0.7% of all cycles, but they
lengthen the critical section that the other threads are waiting on.

Accumulate the stat changes per LRU list while holding the lock instead,
and only apply them after dropping the lock (while still inside
the RCU read section that keeps the lruvec's memcg alive). This moves
the stat updates out of the lru_lock critical section and turns the
per-folio updates into at most one update per LRU list per batch.

The batch is attached to the lruvec while lru_lock is held so that the
LRU add/del helpers don't need to pass it down. To keep struct lruvec
from growing, cost_lock is moved into the hole after lru_lock, which
leaves room for the batch pointer in the same cacheline as lru_lock.

The stats can now lag behind the LRU lists by one batch, which is well
within the per-cpu batching they already have.

On a 2-socket Skylake (80 CPUs, 2 NUMA nodes), with threads pinned to
CPUs repeatedly faulting in and freeing memory in a single memcg,
average pages per second over 7 freshly created memcgs per run, 2 boots
each:

                     before    after
  shmem, 20 threads  4.74M     5.47M   (+15%)
  shmem, 80 threads  7.94M    10.33M   (+30%)
  anon,  20 threads  3.04M     3.35M   (+10%)
  anon,  80 threads  3.23M     3.41M   (+5%)

Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com/ [1]
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
v1: https://lore.kernel.org/linux-mm/20261022200313.2354350-1-joannelkoong@gmail.com/
v1 -> v2:
* Added summary of [1] to the commit message as well as the perf profile
  findings (Shakeel)

 include/linux/mm_inline.h | 12 ++++++-
 include/linux/mmzone.h    | 11 +++++--
 mm/folio.c                | 67 +++++++++++++++++++++++++++++++++------
 3 files changed, 77 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ab69b9930893..b3d85fe91385 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -50,7 +50,17 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
 	lockdep_assert_held(&lruvec->lru_lock);
 	WARN_ON_ONCE(nr_pages != (int)nr_pages);
 
-	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
+	/*
+	 * Batches in mm/folio.c attach an lru_size_batch while holding
+	 * lru_lock, to apply the node and memcg lruvec stats only after the
+	 * lock is dropped. The stats don't need lru_lock and updating them is
+	 * a large part of the critical section when batching. The zone stats
+	 * are still updated right away.
+	 */
+	if (lruvec->lru_size_batch)
+		lruvec->lru_size_batch->nr_pages[lru] += nr_pages;
+	else
+		mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
 	__mod_zone_page_state(&pgdat->node_zones[zid],
 				NR_ZONE_LRU_BASE + lru, nr_pages);
 }
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ecd1ebd49756..8618e9543983 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -739,10 +739,19 @@ struct lru_cost {
 	unsigned long		last_io;
 };
 
+/* LRU size changes made under lru_lock, applied after the lock is dropped */
+struct lru_size_batch {
+	long nr_pages[NR_LRU_LISTS];
+};
+
 struct lruvec {
 	struct list_head		lists[NR_LRU_LISTS];
 	/* per lruvec lru_lock for memcg */
 	spinlock_t			lru_lock;
+	/* Protects cost[]. */
+	spinlock_t			cost_lock;
+	/* If set, defers lruvec stat updates until lru_lock is dropped */
+	struct lru_size_batch		*lru_size_batch;
 	/*
 	 * These track the cost of reclaiming one LRU - file or anon -
 	 * over the other. As the observed cost of reclaiming one LRU
@@ -751,8 +760,6 @@ struct lruvec {
 	 * serialises that update.
 	 */
 	struct lru_cost			cost[ANON_AND_FILE];
-	/* Protects cost[]. */
-	spinlock_t			cost_lock;
 	/* Non-resident age, driven by LRU movement */
 	atomic_long_t			nonresident_age;
 	/* Refaults at the time of last reclaim cycle */
diff --git a/mm/folio.c b/mm/folio.c
index 45c814f3857b..dc2c796a4ea7 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -64,11 +64,54 @@ static DEFINE_PER_CPU(struct cpu_fbatches, cpu_fbatches) = {
 	.lock_irq = INIT_LOCAL_LOCK(lock_irq),
 };
 
+/*
+ * lru_lock helpers for batches that defer LRU size stat updates until the
+ * lock is dropped, see __update_lru_size(). The deferred stats are applied
+ * while still in the RCU read section entered by locking, which keeps the
+ * lruvec's memcg alive.
+ */
+static void lruvec_unlock_irqrestore_batched(struct lruvec *lruvec,
+		unsigned long flags)
+{
+	struct lru_size_batch *batch = lruvec->lru_size_batch;
+	enum lru_list lru;
+
+	lruvec->lru_size_batch = NULL;
+	spin_unlock_irqrestore(&lruvec->lru_lock, flags);
+
+	for_each_lru(lru) {
+		long nr_pages = batch->nr_pages[lru];
+
+		if (nr_pages) {
+			mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
+			batch->nr_pages[lru] = 0;
+		}
+	}
+	rcu_read_unlock();
+}
+
+static void folio_lruvec_relock_irqsave_batched(struct folio *folio,
+		struct lruvec **lruvecp, unsigned long *flagsp,
+		struct lru_size_batch *batch)
+{
+	if (*lruvecp) {
+		if (folio_matches_lruvec(folio, *lruvecp))
+			return;
+
+		lruvec_unlock_irqrestore_batched(*lruvecp, *flagsp);
+	}
+
+	*lruvecp = folio_lruvec_lock_irqsave(folio, flagsp);
+	VM_WARN_ON_ONCE((*lruvecp)->lru_size_batch);
+	(*lruvecp)->lru_size_batch = batch;
+}
+
 static void __page_cache_release(struct folio *folio, struct lruvec **lruvecp,
-		unsigned long *flagsp)
+		unsigned long *flagsp, struct lru_size_batch *batch)
 {
 	if (folio_test_lru(folio)) {
-		folio_lruvec_relock_irqsave(folio, lruvecp, flagsp);
+		folio_lruvec_relock_irqsave_batched(folio, lruvecp, flagsp,
+						    batch);
 		lruvec_del_folio(*lruvecp, folio);
 		__folio_clear_lru_flags(folio);
 	}
@@ -80,12 +123,13 @@ static void __page_cache_release(struct folio *folio, struct lruvec **lruvecp,
  */
 static void page_cache_release(struct folio *folio)
 {
+	struct lru_size_batch batch = {};
 	struct lruvec *lruvec = NULL;
 	unsigned long flags;
 
-	__page_cache_release(folio, &lruvec, &flags);
+	__page_cache_release(folio, &lruvec, &flags, &batch);
 	if (lruvec)
-		lruvec_unlock_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore_batched(lruvec, flags);
 }
 
 void __folio_put(struct folio *folio)
@@ -165,6 +209,7 @@ static void lru_add(struct lruvec *lruvec, struct folio *folio)
 static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 {
 	int i;
+	struct lru_size_batch batch = {};
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
 	struct folio_batch free_fbatch;
@@ -199,14 +244,15 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 			continue;
 		}
 
-		folio_lruvec_relock_irqsave(folio, &lruvec, &flags);
+		folio_lruvec_relock_irqsave_batched(folio, &lruvec, &flags,
+						    &batch);
 		move_fn(lruvec, folio);
 
 		folio_set_lru(folio);
 	}
 
 	if (lruvec)
-		lruvec_unlock_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore_batched(lruvec, flags);
 
 	/* Cleanup filtered dead folios. */
 	if (is_lru_add) {
@@ -998,6 +1044,7 @@ void lru_cache_disable(void)
 void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 {
 	int i, j;
+	struct lru_size_batch batch = {};
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
 
@@ -1014,7 +1061,7 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 
 		if (folio_is_zone_device(folio)) {
 			if (lruvec) {
-				lruvec_unlock_irqrestore(lruvec, flags);
+				lruvec_unlock_irqrestore_batched(lruvec, flags);
 				lruvec = NULL;
 			}
 			if (folio_ref_sub_and_test(folio, nr_refs))
@@ -1028,20 +1075,20 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 		/* hugetlb has its own memcg */
 		if (folio_test_hugetlb(folio)) {
 			if (lruvec) {
-				lruvec_unlock_irqrestore(lruvec, flags);
+				lruvec_unlock_irqrestore_batched(lruvec, flags);
 				lruvec = NULL;
 			}
 			free_huge_folio(folio);
 			continue;
 		}
-		__page_cache_release(folio, &lruvec, &flags);
+		__page_cache_release(folio, &lruvec, &flags, &batch);
 
 		if (j != i)
 			folios->folios[j] = folio;
 		j++;
 	}
 	if (lruvec)
-		lruvec_unlock_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore_batched(lruvec, flags);
 	if (!j) {
 		folio_batch_reinit(folios);
 		return;

base-commit: 9c449f885765cf8d80b2c60b1971e774bba51a3f
-- 
2.52.0


