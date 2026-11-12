Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13E67606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iR7XBPOd
Received: by kanga.kvack.org (Postfix)
	id D78C56B05FC; Thu, 12 Nov 2026 17:13:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50376B05FE; Thu, 12 Nov 2026 17:13:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69156B05FF; Thu, 12 Nov 2026 17:13:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C57F6B05FC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:13:16 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A1F31A1DC9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:13:15 +0000 (UTC)
X-FDA: 85427868750.25.309ECB4
Received: from mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id DA76140005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:13:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iR7XBPOd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.47 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794521593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kTdo+kO/ZFnoi8WBOH10hGoTbRODmVYIrrHV4RIL5fA=;
	b=qy9SYISzI6Br4anMy/L83AFE/s8wUGCChL4MoZTbel9TSIXl4to3vFyfl3NgW4GqZqmx5f
	P0I0yFBMc7LQcTJW63IquJ2G6r3VpZl5QG6ZmIQ610EEonKwYSsWYMNu4mBirzvnsHkjbl
	mLCXSvbhnseLRLOgeJTIJhU2aU8X5Mw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iR7XBPOd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.47 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794521593;
	b=wSoupKM2O3/XnrN3mVCU1fshEp/rIhfzrjaBjG1ClbHUWC/jrZ6oXulU45Y/2Das9Jh+uT
	I2iLxuuMSzwMdbvSpMH75KefZD/7BQ/anG87mJhlCob55+YrpJlKvwWUn7rDmUqS15wc6R
	qu+juGjlnJU2Ix1w79bmQFBLbp2KYM4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=SBKlid3rP+qCHPEj+Z0hRqE3CyPPTMKLsXSlj3BJE+c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794521588; v=1; x=1795126388;
 b=iR7XBPOdi3PTUoK8KvDULKvhl1s0yUfDr3wya71qgiyzwKCjIDkDl0ZTPE9cr3hZwBpTxpvR
 JrxqBrBaKEYyJlvv3JvUFcATIr1HWVQ1uwTOSoEhD7KT3HFT3Dn8sarewk15ez6bu9ZAg70JjKa
 es9oipdh1wku6YxiS7Lc9ldo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 140af9af48ba9318;
	Thu, 12 Nov 2026 22:13:08 +0000
X-Mizu-Trace-ID: 140af9af48ba9318
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Chris Mason <mason@kernel.org>
Subject: [PATCH] mm: list_lru: don't use a new memcg's lists for an offline memcg
Date: Thu, 12 Nov 2026 14:12:48 -0800
Message-ID: <20261112221248.3512447-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DA76140005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zo7ri5ku4oiuj9ggmktpmzzi739ote64
X-HE-Tag: 1794521591-616833
X-HE-Meta: U2FsdGVkX18ufQQSoS4L2kS3RgFhn24jqwNa7rLwk+ADBeSJ1dVaugTgDNLN0eyF3PBDLfDHX45jrVtOtKGShNfgKOAI6ZjU68kT1edYROqX7NcHQIh9aoYwcOkvO8b9yndHhyHrLlJrTnJQlyTtbZshc+2YAwnkU4YdXjXoF8BCAcANJxx6wfewJmcWBuat0Om5I2VCC3yJ93e67BheYSyfLG4HKRrcd0+xTm8MKLn1Ki55YCmKL0UZyKjqYFzdbNiestLcxVeV49QFJsoiKpBIt2yGHq0emMsQ58KgfdihWHd5SM3rC+vA4FH8em3IQOppaPZufz7lnvvmsD5hNWCkQniftLjb08MAvV6nW2549c1fzoxVptydRgzI8M8C6YBgbq9LyQXoriBQWRtOhdVeWqgEBW4Z2dCMWG+enE5heKkvr511f3w0LzqwSUQDiH4aUuV4P2VJKWCtsTR+A7mWofIEEHY86TwttQtzd0m6Hl6BMWEE5hl9y+9x9y+S6LnFmNYRAkgmpYRWIZm++fC2xC/b2mStHPiRVGSi7ptbPE4rQA8OjRfhnup3j54XE0EEPl9cW5gasEn/6Op2puytU+fEb+EmJ491uGgi3I1bwEE8nJQPuLBfX8yjV+TBPmJ4ZEwlEP9rY309+LlXOkCDgCDV1Hrkjon3O6cjSCk11jHRjC7ne3q+OS4lLRGGQI7jDQ33jqJzsf0wdsZ7Naj13K2d5nFqj/638DZqG4OxA/8XmVa6dzQZGxofZHZyTLtV6RSOx8AOnO9x1PighOGYB8iJEyOIurrfFNnJCD/kwSldWejqvLt5ffXePZFZ6XchBF0PdexboN+Uo+JQQmRRcWS2dJf921GkXK80htVX9X0FDBiNK92aaC/kQC22p9f9OxaT/ghgSazPx0m3yDLtRo0dagOGsljjA8JoH/UznYnFE/gBP3WoPM/GOscJMawz/y/CXTJb+4pvhLL
 RXzLi3KR
 +KMrUmGFYxSMuqtbUpDB2Ii9zN0PggMPb/iDx2ucmEERKzircPgdl2emzAoI/RYidrQk5jkKM0nuTBmlwhBHRc92ceD3nILw74/fC750/s9xRKWSlzjFTVAKhi/+uHcCfaN1L2B3XBdpmnJ67rhC3dJV7OOENksF3W4Hdel9O2SlfDrdLOZG2uMzyKYqA3s9gesg0B7oLi5bxBDS44KU7IsebmemOZDukT+eIv88pWXzegTjJA6EE9AdN99VuwvRoF9kfkYn0ISkCug6+UeHxs+HIwIMOi24N7aH75ammlJxkIKmq7deRerEhF8upXZq/sgVrU5+xIDiU/bE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A memcg's list_lru lists are found by its kmemcg_id, which is its
private ID. Offlining a memcg moves its lists to the parent and frees
the ID right away, with no RCU grace period. The next new memcg can get
the same ID and allocate its own lists at that index.

A caller that holds only the RCU read lock, such as
__folio_unqueue_deferred_split(), can still hold the offline memcg. If
it is preempted until the ID is reused, it then locks the new memcg's
list and unlinks a folio that now sits on the parent's list, without
holding the parent's lock. A concurrent change to the parent's list can
then leave a pointer to a freed folio on it.

Users see list corruption reports, crashes or silent memory corruption
when memory cgroups are removed and created while THPs are freed, on
kernels with preemptible RCU, which is the default on x86 and arm64.
They can also see a warning from memcg_reparent_list_lru_one() when the
new memcg is removed, because the wrong unlink made its count negative.

Fix it by recording the owning memcg in each list_lru_memcg, and by
treating the index as empty when its lists belong to another memcg. The
lookup then moves up to the parent, whose list holds the folio.

Fixes: 28e98022b31e ("mm/list_lru: simplify reparenting and initial allocation")
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/list_lru.h |  2 ++
 mm/list_lru.c            | 18 +++++++++++-------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index a450fffe1550..6ef5bc539606 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -38,6 +38,8 @@ struct list_lru_one {
 
 struct list_lru_memcg {
 	struct rcu_head		rcu;
+	/* owning memcg, only compared and never dereferenced */
+	const void		*memcg;
 	/* array of per cgroup per node lists, indexed by node id */
 	struct list_lru_one	node[];
 };
diff --git a/mm/list_lru.c b/mm/list_lru.c
index ca8de3793166..560190d5b348 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -72,12 +72,15 @@ static int lru_shrinker_id(struct list_lru *lru)
 }
 
 static inline struct list_lru_one *
-list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
+list_lru_from_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg)
 {
+	int idx = memcg_kmem_id(memcg);
+
 	if (list_lru_memcg_aware(lru) && idx >= 0) {
 		struct list_lru_memcg *mlru = xa_load(&lru->xa, idx);
 
-		return mlru ? &mlru->node[nid] : NULL;
+		/* Lists at a reused index belong to another memcg. */
+		return mlru && mlru->memcg == memcg ? &mlru->node[nid] : NULL;
 	}
 	return &lru->node[nid].lru;
 }
@@ -91,7 +94,7 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid,
 
 	rcu_read_lock();
 again:
-	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(*memcg));
+	l = list_lru_from_memcg(lru, nid, *memcg);
 	if (likely(l)) {
 		lock_list_lru(l, irq, irq_flags);
 		if (likely(READ_ONCE(l->nr_items) != LONG_MIN)) {
@@ -132,7 +135,7 @@ static inline bool list_lru_memcg_aware(struct list_lru *lru)
 }
 
 static inline struct list_lru_one *
-list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
+list_lru_from_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg)
 {
 	return &lru->node[nid].lru;
 }
@@ -313,7 +316,7 @@ unsigned long list_lru_count_one(struct list_lru *lru,
 	long count;
 
 	rcu_read_lock();
-	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
+	l = list_lru_from_memcg(lru, nid, memcg);
 	count = l ? READ_ONCE(l->nr_items) : 0;
 	rcu_read_unlock();
 
@@ -502,11 +505,10 @@ static void memcg_reparent_list_lru_one(struct list_lru *lru, int nid,
 					struct list_lru_one *src,
 					struct mem_cgroup *dst_memcg)
 {
-	int dst_idx = dst_memcg->kmemcg_id;
 	struct list_lru_one *dst;
 
 	spin_lock_irq(&src->lock);
-	dst = list_lru_from_memcg_idx(lru, nid, dst_idx);
+	dst = list_lru_from_memcg(lru, nid, dst_memcg);
 	spin_lock_nested(&dst->lock, SINGLE_DEPTH_NESTING);
 
 	list_splice_init(&src->list, &dst->list);
@@ -602,6 +604,8 @@ static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
 			if (!mlru)
 				return -ENOMEM;
 		}
+		/* Set before the lists are published, and never changed after. */
+		mlru->memcg = pos;
 		xas_set(&xas, pos->kmemcg_id);
 		do {
 			xas_lock_irqsave(&xas, flags);
-- 
2.53.0-Meta


