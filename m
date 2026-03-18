Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47F6910775FE
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 17:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A22B6B02CD; Wed, 18 Mar 2026 13:57:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879E26B02CE; Wed, 18 Mar 2026 13:57:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6F66B02CF; Wed, 18 Mar 2026 13:57:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B9E46B02CD
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:57:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F0E31B8CF1
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:57:05 +0000 (UTC)
X-FDA: 84559940010.05.21098D5
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id D4227180014
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:57:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QJwTNINT;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773856623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GkJmm1x6RQPn/UFRPa7/2straKzSBCtOE1HckM7TXds=;
	b=j0ilboY+IXc1Vooz+6tXFgCtH5Mx7PE0l1TZqYDl/piyD/xYujIR/LnKxem/lMTmK8CkMn
	MM2Tv+WgGUhMkoKyigW19SNL0pJh/G2vMO0oFmVxPAbzo3whSr2ev6+DYuHq4vO0zDB4dp
	SIWyUH+UibMcaN2UE8AmGxsGF4eBDtI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773856623; a=rsa-sha256;
	cv=none;
	b=6iiDYYeW8aNiQjOXul225j9ux239fSIEjkqVL8RT8Jk6BUxOsxy7KW4tMeJgPoj119r2e7
	99KS6iZzaVL+WRUldqwK5tIyPrBD39yCT4lZtnvxYkPtYdoSeiqmMCNKoN3O/zey2f5Z+U
	M43oLy5nAAcVwdYpP8G3hEYVlca5dSE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QJwTNINT;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 18 Mar 2026 10:56:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773856620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GkJmm1x6RQPn/UFRPa7/2straKzSBCtOE1HckM7TXds=;
	b=QJwTNINTQL+jMZFdoubsJO40Gl+9oi6Z6gTZUpMTv94GJR4Uyuy1JqE88syGHOSxP4F6oP
	Bgva392i/tNsGGYmW4zJfhjU5+iarpthTuco3W4RmluY18hUBjZLfXMnd5wsMhfHxn7LmC
	4R9WA7WtCQzbh9dI02FZSBI/4Fhx5uo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] mm: list_lru: lock_list_lru_of_memcg() cannot
 return NULL if !skip_empty
Message-ID: <abrnEU-wHNkqGK2k@linux.dev>
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-2-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312205321.638053-2-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: bdqicp9hd6j7533ard57s7ksm6baa1w8
X-Rspamd-Queue-Id: D4227180014
X-Rspamd-Server: rspam03
X-HE-Tag: 1773856622-984016
X-HE-Meta: U2FsdGVkX18VdAPQz8IHrthvSbMDvGKP3Y8fP8QGq2Exmq7xQ/CO/d2kN16EsS6fqzFM8OTX38HV3GIEofpuh7xmiJeKr8ZGkW5a1VuwdRD0JDmmAzX/7MRplGp28/b34Rasi+5oW8/o92lV+uD6t/TFTLjdljdU2z2EL8ZlZ6I97q9EvBBLpKSAQWqcw8jiFLUK3i8KFGx8MwJ/AwikhgFLH5shm7jD2/veoEmGyKuKJRlvkYjhVfZZXmGozh1WT1sGq3nE6ws4ltyUTjW83yXfkbVq8fS5fFbyKIY9zTZ21YsAE101Xfe0H3wHNv3RRmWIjSUk49SQnumoIA3BKfHyJVUhmzMa4k0LAQc2NQdUoiQZq0qcQhYL3Nrlol7ekmV080hZdmTRFr7az6jd70aZo9jScYNzpKU0Gw4w7U7ylkWj1gBZattNw3PIhKwvrGB4ve8fNC+8Wawe4geTyJz6srrmG3JB7gEQMAx5PSVESCQlsmPWpMqiTxYMClU/GSfALCt854FpF/BCylpacTk5UrkY8270IA3rr6d4mE82lNm7SlpgY34Mm6k2Q1gXRRGcbck0qaVRL8ybOEo5yxhfu+oeuQW7mYHZdpXjU9Gqu5uVk9VqDXHYNmYLwZGAfnf8cW3BiDAu/gVs06RGsOy09Q8Ws4d5LnnqReMUELcm3BmJK7sRalSR2nCbdBJS0oczyR+uklwMF2A6YxqVYVa8fRNKhh0r8r1JKZPWAWu7jCEpQe5A8h38QngooDPVqKWhdpE4QKVVBjfrdXrE+exeyxq6R3QXm5EdpmMaUvfWHK5+Mp+XPPso9x6vCp+Tv4ovShsgxbIKNLSX7CrrlFL62fbdOpsi4ZPfZnGhtEmfX+v29rsZhzuvfg2G13picZCMyHwXLmK5SVmC6VamKmmcsndUOl0yUa7ConPZ5LgWA6A0QkMjf308TE9RxYOZlR8IZvUfNgg3de0M+ZG
 5Yk92Uke
 m2lwHnhd2NDJwT6gWtReMz5PUH6MHArfv3h+joB/DM3pIt9BbeTPzXK86Il+HyL/5JNAFTAPXWPn3zPYOUpg0wj+mc0RcAW/UNBZF8h0RtXZDI1fm+dqn3DwPVjx2hV9Od7bvs21KzauFSDHhjc28FnCVtwFsF517nCRAJHbHApR3ULkYUpV1+j+yfEUsgGpoVRDXVpxNHMHQ9mX+tab6nVvuE2VmC7xgsFNT6ui5EsN5v/h0yjZd83LrT+vywj7TA1dC+TndWIy3dJW8KI6N5qaJmLEPd2szgZkIHd0uqKcJDd5OBi/mM93lm2nZXvwK9VvRdymrMyL/5s/KXFwhS0OUnaLqUjD6Sh18FB5sa+PTxCY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 04:51:49PM -0400, Johannes Weiner wrote:
> skip_empty is only for the shrinker to abort and skip a list that's
> empty or whose cgroup is being deleted.
> 
> For list additions and deletions, the cgroup hierarchy is walked
> upwards until a valid list_lru head is found, or it will fall back to
> the node list. Acquiring the lock won't fail. Remove the NULL checks
> in those callers.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---

What do you think about squashing the following into this patch?

From bd56ea4505f792e00079b1a8dd98cb6f7a5e7215 Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeel.butt@linux.dev>
Date: Wed, 18 Mar 2026 10:43:53 -0700
Subject: [PATCH] list_lru: cleanup

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/list_lru.c | 53 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 26463ae29c64..062394c598d4 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -77,27 +77,30 @@ static inline bool lock_list_lru(struct list_lru_one *l, bool irq)
 }
 
 static inline struct list_lru_one *
-lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
-		       bool irq, bool skip_empty)
+__lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
+		       bool irq)
 {
 	struct list_lru_one *l;
 
 	rcu_read_lock();
-again:
 	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
-	if (likely(l) && lock_list_lru(l, irq)) {
-		rcu_read_unlock();
+	if (likely(l) && !lock_list_lru(l, irq))
+		l = NULL;
+	rcu_read_unlock();
+
+	return l;
+}
+
+static inline struct list_lru_one *
+lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg)
+{
+	struct list_lru_one *l;
+again:
+	l = __lock_list_lru_of_memcg(lru, nid, memcg, false);
+	if (likely(l))
 		return l;
-	}
-	/*
-	 * Caller may simply bail out if raced with reparenting or
-	 * may iterate through the list_lru and expect empty slots.
-	 */
-	if (skip_empty) {
-		rcu_read_unlock();
-		return NULL;
-	}
-	VM_WARN_ON(!css_is_dying(&memcg->css));
+
+	VM_WARN_ON_ONCE(!css_is_dying(&memcg->css));
 	memcg = parent_mem_cgroup(memcg);
 	goto again;
 }
@@ -135,8 +138,8 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 }
 
 static inline struct list_lru_one *
-lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
-		       bool irq, bool skip_empty)
+__lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
+		       bool irq)
 {
 	struct list_lru_one *l = &lru->node[nid].lru;
 
@@ -148,6 +151,12 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 	return l;
 }
 
+static inline struct list_lru_one *
+lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg)
+{
+	return __lock_list_lru_of_memcg(lru, nid, memcg, false);
+}
+
 static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
 {
 	if (irq_off)
@@ -164,9 +173,7 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
 	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
 
-	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
-	if (!l)
-		return false;
+	l = lock_list_lru_of_memcg(lru, nid, memcg);
 	if (list_empty(item)) {
 		list_add_tail(item, &l->list);
 		/* Set shrinker bit if the first element was added */
@@ -203,9 +210,7 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
 {
 	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
-	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
-	if (!l)
-		return false;
+	l = lock_list_lru_of_memcg(lru, nid, memcg);
 	if (!list_empty(item)) {
 		list_del_init(item);
 		l->nr_items--;
@@ -287,7 +292,7 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 	unsigned long isolated = 0;
 
 restart:
-	l = lock_list_lru_of_memcg(lru, nid, memcg, irq_off, true);
+	l = __lock_list_lru_of_memcg(lru, nid, memcg, irq_off);
 	if (!l)
 		return isolated;
 	list_for_each_safe(item, n, &l->list) {
-- 
2.52.0


