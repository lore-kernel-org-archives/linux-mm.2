Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 653C5CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 15:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A8D76B00CB; Thu, 21 May 2026 11:03:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8348E6B00CE; Thu, 21 May 2026 11:03:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FCB96B00CF; Thu, 21 May 2026 11:03:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AA696B00CB
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:03:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 306321C1ABC
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:03:55 +0000 (UTC)
X-FDA: 84791746830.26.3737277
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id 218E680002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:03:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VOLrw+PD;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.216.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779375833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=USyWRFDNXHImycXHNr3l4mW9eMlhPd90cPYpqyp43EY=;
	b=FbjDA/y2YbmlDS0C01KJ9JgOKPSJwEl+J6dXQOzXRcMbm6ZzUVtXQeoVePH+q2I1ynAsBG
	8o4ILXYLprsrdAb4BWXWllXzOfh74F9FG6w+IiEusJx4ojuFWqXYiWun9OC/kmi5a4QoCe
	fMa2yicwj6ybqJ48ZRtFtxVdd9IHCC0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VOLrw+PD;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.216.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779375833; a=rsa-sha256;
	cv=none;
	b=PvN+x4fPOskETHZvq4+3QGupVHRcGMHXDPhDHCbhi7BiNyBiJ0EQq4m44++o2HTlhWOdmK
	yAe9hioenFgr4RTRGpsYSnsh5Nk02exhwmS5Ogf1yPgY0CpRamz5z2eDGtv0qOGJbZLjnt
	FFe6/KfJqkhmTLGq8X1qb/UUUh6t+mc=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-368f25ff4c4so3308615a91.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 08:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779375832; x=1779980632; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=USyWRFDNXHImycXHNr3l4mW9eMlhPd90cPYpqyp43EY=;
        b=VOLrw+PDUF/1WJNIuhmYEK28+ZKFfYLdNAUJ+/5xGhyScdQDGiII5FWijjm+Xq2y9b
         IO0Jr/QxEUaMhknB5epSD3cYKC1344LBaqm3TlAeq3sFeqD7piUYmYzQNrpKVsEHVlhB
         tDoU5ub4shEdZs8suLXi/H8iIEYA32bnPgXq7GM6kFDKrvQP9zYbSzutoo9h37T92hZo
         0fFVjW7t4/+FCKRiWq/eGAxtjoiUYXLzVHao4af2ZI9XvtfiiW27uT4ZTABHW1MVMTGE
         uL6FZ7xFUOyDX6iPBeDBF8Gf3RB+/3/rDyfSY/GoHJaFO3wmSQ6PgOryMC2r4tP+epfX
         CH2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779375832; x=1779980632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=USyWRFDNXHImycXHNr3l4mW9eMlhPd90cPYpqyp43EY=;
        b=eDQPT/XyLSXwD6j5P5QiUaSEjrSNlaDiL7oNAEEJTjAiaaoflys9V4BRVQhVgJH9qp
         4/+7zYXU30gonglriOqpihan1jSe7bqwW2nXY/1EPPUEMOutdcZTycQAAqvi/yqTEJns
         BNT4oitZyHHTqXlTnNV2o/dnHoLLAwSlFkTsdq5TdYBjqZis5vXWEauj1bVtVUwHFrf0
         lWVPjeCUdkOqiqc44u+BsdCWqnGfXwrAJkYU2u1hiqMWdtU0JtTna+N04xjC0N2K0mia
         32CxZX5UnGaN3ZpCf84P7rh699HlGNdGGqh2sDHH/iBpdaBpPlsYk8+fcpJh0KiIei3r
         qeQA==
X-Forwarded-Encrypted: i=1; AFNElJ/4vJYELgNcGUBrZHnReYxJYcQRIzysxikYo33sjEFghhF8rLFEOZUL9gpirC/O8kTXluLvtGpJiQ==@kvack.org
X-Gm-Message-State: AOJu0YwSgmUlOMSwgNTKVFJCwJcHdIWAFVknx3Wjt4RqhSRAYprMEKX/
	QyWim+vzXylXKf9zLZo25ViH88xtjqSRJCtlC4fdt32IuZhut7RzXZMPgQeXbFBKvkU=
X-Gm-Gg: Acq92OE3P9pNhNarHtPgOpay8jjm02ujOUizoZ4OC9FFZ94t9HJJhuMUFSyq7+QYXDt
	gCFF/tVxGIQjdcETh9XVJs2nOujb6VIdLOOyJYjvWPXIgds3oqsFAJa3rrEE7Fc9I67HDZ5US25
	2VufupZulYsGO7tMLwWudMlkmrLg0tAQYbxJmxUY3fWtWKm83uDWaNDcoYdy+IJzBfwYU5GKw8h
	XtpVQHzRP6u/E6ReTyXUss5rVRRXom/7Ne0SJtwyEUBDcxwhVZN9RF+sdCXGJwAfJsmWFXP6UP+
	iR151z34j880qZ+THw9MX6WGYy3LebHCm77glaFSJTQThc9l2GdGws5cXDEMlPxGuEseUBUY6LA
	L38e4knUWyhG1RFoV7+U4CaPy2SnBLmgmbnlHm+Of5laRtUsY5bpC4qFAznI31e6ybkYHrKZ5OU
	j5pidbdeAnO3sugYXvs+GToA==
X-Received: by 2002:a17:90b:548b:b0:369:996d:282c with SMTP id 98e67ed59e1d1-36a4518224amr3266558a91.9.1779375831567;
        Thu, 21 May 2026 08:03:51 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914abb9935bsm114647585a.31.2026.05.21.08.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 08:03:50 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Kairui Song <ryncsn@gmail.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/8] mm: list_lru: introduce caller locking for additions and deletions
Date: Thu, 21 May 2026 11:02:11 -0400
Message-ID: <20260521150330.1955924-6-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260521150330.1955924-1-hannes@cmpxchg.org>
References: <20260521150330.1955924-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eputobnhbxgb6gg6pxisw4ifz38fawtw
X-Rspamd-Queue-Id: 218E680002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779375832-402577
X-HE-Meta: U2FsdGVkX19j6GO6mHmMhukQ9CqP9xky3v5J8lyIuK0RHwW5cXDjpax9/bBdX9WlBbRQ+fk38SXL2sEvgFK7ZfG31Id+t7ylsETh28SdtGDx4rObIH+9HpAWjLE/CiAQq05oh5f8BNGCWbjk0c94PFa0c+0rCzdrhRcWOFahzSItJFPPBcBmTQXiXoAJDXru9LLjhv038U17wzeXUFi3Y86XyTlWyiLah2HJ//F6046jBPbXK9b5FEyHhdx9So5i1JHmo6Q0IWrPbSrrmEog9eW7HwuRkwX1GaTkOZqmWQdXcS6MgYHvmlKCdo7Z3XF/RX3kQPml0z/bXCUD/kOZA9KjWjhoOrvlGg5wVHDd/VfY5UYUEJnNdVui/1utaoo/CBxXdJ+CPVs64onxS9BbuAMBPod2PjhRBggEN6vFwBC1VqwrUL8RiprWuRgCJBU6BPJAMk5EyF/DYVnSjCu+nRBD6i1Cx67VPBu2oCD7tGV1SvXyECt9gM9wZwt5YcSHQRlSqZV1itmHvCerd8SornwLPpoxGN5oqaIVeTWOBhNa2HFMygTN2euiOYbN6ZE7uIVr9DInv3yCpQKG6AVF99Hy/pM1f9mUrLlLDV2593wCdWtPm9bVvlw259WhPMKlESmHeuZPfXmfOLf7OZ0Jy5Xql36hPXbJjxmD3nDURAUA//aa0x374LfDvjYRvLHK0NHqxgzPf9hCzMOxSzK0mLVhvq3tY4HXrfU0QJM0Dz+jkCSfWbrIyapEfKCmdgUUSuphmq7juZXuNOFc7h9Gr5jUTRLgre29FkYNL+ZxCxkECpTFiXy/o2GQKbjUV+WmFXhhbi7LoAcsQdOfhGRu2bKkf9HfgJ5y0IIHkOLG16YIS/Y+rjc1j4XbZyvsH+tTuOEwBnShVp1qAl/RjSImlLPxZ2XzuIv0WvwfxvUlz7PEpGF12H9oJcyLrw5eS9/pBVRoQ3S93ofLYD9vRUd
 WVEfSBKx
 pCpEqbGSAf7ddm+MTPoFahIBTV7Ja40I8DAtqQ28hlV2eJb8h+tsZckwxSQqCaAFH5q8XZy7UZsfD1HIacXGL4NcGp8XmbsLAbUUdpsevlQLZez3qLURU7RKnw1+gLxuLc41Re+IMG6JcLY1Ni9BkJ5FYr2RBxPpdOUqJBvL9nLFsn3GQNHkas+ymlKwFJ26Wkz1cPTmM2ynItSbhDtnFKGGrONGyRxAp3mjCYCdJWb+T5MhEq2F3NRnMuXsw2EjQ7cCqJAWqeFQqAWb4ZZ4+ZPkHEDlQ6Glgbr5NE7vvSI9AJAWKC3/0rL2oNyB+iyulTNV2qEPiHB9kSGcFiaYjCPPbVvaaI8c5XwApcz4w0M1ayUkpKHBqwuWFQzTVv/vht8YkJZkElMJMRB1b8ip3lHaymYssTl0fW40YOpHSpzp0vBWFBUTFt4FhZONblSc9gPeVxV2tIk8DPC0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Locking is currently internal to the list_lru API. However, a caller
might want to keep auxiliary state synchronized with the LRU state.

For example, the THP shrinker uses the lock of its custom LRU to keep
PG_partially_mapped and vmstats consistent.

To allow the THP shrinker to switch to list_lru, provide normal and
irqsafe locking primitives as well as caller-locked variants of the
addition and deletion functions.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/list_lru.h |  41 ++++++++++++
 mm/list_lru.c            | 131 ++++++++++++++++++++++++++++++---------
 2 files changed, 141 insertions(+), 31 deletions(-)

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index fe739d35a864..c79ed378311f 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -83,6 +83,44 @@ int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
 			 gfp_t gfp);
 void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent);
 
+/**
+ * list_lru_lock: lock the sublist for the given node and memcg
+ * @lru: the lru pointer
+ * @nid: the node id of the sublist to lock.
+ * @memcg: the cgroup of the sublist to lock.
+ *
+ * Returns the locked list_lru_one sublist. The caller must call
+ * list_lru_unlock() when done.
+ *
+ * You must ensure that the memcg is not freed during this call (e.g., with
+ * rcu or by taking a css refcnt).
+ *
+ * Return: the locked list_lru_one, or NULL on failure
+ */
+struct list_lru_one *list_lru_lock(struct list_lru *lru, int nid,
+		struct mem_cgroup *memcg);
+
+/**
+ * list_lru_unlock: unlock a sublist locked by list_lru_lock()
+ * @l: the list_lru_one to unlock
+ */
+void list_lru_unlock(struct list_lru_one *l);
+
+struct list_lru_one *list_lru_lock_irq(struct list_lru *lru, int nid,
+		struct mem_cgroup *memcg);
+void list_lru_unlock_irq(struct list_lru_one *l);
+
+struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
+		struct mem_cgroup *memcg, unsigned long *irq_flags);
+void list_lru_unlock_irqrestore(struct list_lru_one *l,
+		unsigned long *irq_flags);
+
+/* Caller-locked variants, see list_lru_add() etc for documentation */
+bool __list_lru_add(struct list_lru *lru, struct list_lru_one *l,
+		struct list_head *item, int nid, struct mem_cgroup *memcg);
+bool __list_lru_del(struct list_lru *lru, struct list_lru_one *l,
+		struct list_head *item, int nid);
+
 /**
  * list_lru_add: add an element to the lru list's tail
  * @lru: the lru pointer
@@ -115,6 +153,9 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
 		    struct mem_cgroup *memcg);
 
+bool list_lru_add_irq(struct list_lru *lru, struct list_head *item, int nid,
+		      struct mem_cgroup *memcg);
+
 /**
  * list_lru_add_obj: add an element to the lru list's tail
  * @lru: the lru pointer
diff --git a/mm/list_lru.c b/mm/list_lru.c
index 65962dbf6dda..df58226eea8c 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -15,17 +15,23 @@
 #include "slab.h"
 #include "internal.h"
 
-static inline void lock_list_lru(struct list_lru_one *l, bool irq)
+static inline void lock_list_lru(struct list_lru_one *l, bool irq,
+				 unsigned long *irq_flags)
 {
-	if (irq)
+	if (irq_flags)
+		spin_lock_irqsave(&l->lock, *irq_flags);
+	else if (irq)
 		spin_lock_irq(&l->lock);
 	else
 		spin_lock(&l->lock);
 }
 
-static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
+static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off,
+				   unsigned long *irq_flags)
 {
-	if (irq_off)
+	if (irq_flags)
+		spin_unlock_irqrestore(&l->lock, *irq_flags);
+	else if (irq_off)
 		spin_unlock_irq(&l->lock);
 	else
 		spin_unlock(&l->lock);
@@ -78,7 +84,7 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 
 static inline struct list_lru_one *
 lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
-		       bool irq, bool skip_empty)
+		       bool irq, unsigned long *irq_flags, bool skip_empty)
 {
 	struct list_lru_one *l;
 
@@ -86,12 +92,12 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 again:
 	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
 	if (likely(l)) {
-		lock_list_lru(l, irq);
+		lock_list_lru(l, irq, irq_flags);
 		if (likely(READ_ONCE(l->nr_items) != LONG_MIN)) {
 			rcu_read_unlock();
 			return l;
 		}
-		unlock_list_lru(l, irq);
+		unlock_list_lru(l, irq, irq_flags);
 	}
 	/*
 	 * Caller may simply bail out if raced with reparenting or
@@ -132,38 +138,106 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 
 static inline struct list_lru_one *
 lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
-		       bool irq, bool skip_empty)
+		       bool irq, unsigned long *irq_flags, bool skip_empty)
 {
 	struct list_lru_one *l = &lru->node[nid].lru;
 
-	lock_list_lru(l, irq);
+	lock_list_lru(l, irq, irq_flags);
 
 	return l;
 }
 #endif /* CONFIG_MEMCG */
 
-/* The caller must ensure the memcg lifetime. */
-bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
-		  struct mem_cgroup *memcg)
+struct list_lru_one *list_lru_lock(struct list_lru *lru, int nid,
+				   struct mem_cgroup *memcg)
 {
-	struct list_lru_node *nlru = &lru->node[nid];
-	struct list_lru_one *l;
+	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/false,
+				      /*irq_flags=*/NULL, /*skip_empty=*/false);
+}
+
+void list_lru_unlock(struct list_lru_one *l)
+{
+	unlock_list_lru(l, /*irq_off=*/false, /*irq_flags=*/NULL);
+}
+
+struct list_lru_one *list_lru_lock_irq(struct list_lru *lru, int nid,
+				       struct mem_cgroup *memcg)
+{
+	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/true,
+				      /*irq_flags=*/NULL, /*skip_empty=*/false);
+}
+
+void list_lru_unlock_irq(struct list_lru_one *l)
+{
+	unlock_list_lru(l, /*irq_off=*/true, /*irq_flags=*/NULL);
+}
 
-	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
+struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
+					   struct mem_cgroup *memcg,
+					   unsigned long *flags)
+{
+	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/true,
+				      /*irq_flags=*/flags, /*skip_empty=*/false);
+}
+
+void list_lru_unlock_irqrestore(struct list_lru_one *l, unsigned long *flags)
+{
+	unlock_list_lru(l, /*irq_off=*/true, /*irq_flags=*/flags);
+}
+
+bool __list_lru_add(struct list_lru *lru, struct list_lru_one *l,
+		    struct list_head *item, int nid,
+		    struct mem_cgroup *memcg)
+{
 	if (list_empty(item)) {
 		list_add_tail(item, &l->list);
 		/* Set shrinker bit if the first element was added */
 		if (!l->nr_items++)
 			set_shrinker_bit(memcg, nid, lru_shrinker_id(lru));
-		unlock_list_lru(l, false);
-		atomic_long_inc(&nlru->nr_items);
+		atomic_long_inc(&lru->node[nid].nr_items);
 		return true;
 	}
-	unlock_list_lru(l, false);
 	return false;
 }
 EXPORT_SYMBOL_GPL(list_lru_add);
 
+bool __list_lru_del(struct list_lru *lru, struct list_lru_one *l,
+		    struct list_head *item, int nid)
+{
+	if (!list_empty(item)) {
+		list_del_init(item);
+		l->nr_items--;
+		atomic_long_dec(&lru->node[nid].nr_items);
+		return true;
+	}
+	return false;
+}
+
+/* The caller must ensure the memcg lifetime. */
+bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
+		  struct mem_cgroup *memcg)
+{
+	struct list_lru_one *l;
+	bool ret;
+
+	l = list_lru_lock(lru, nid, memcg);
+	ret = __list_lru_add(lru, l, item, nid, memcg);
+	list_lru_unlock(l);
+	return ret;
+}
+
+bool list_lru_add_irq(struct list_lru *lru, struct list_head *item,
+		      int nid, struct mem_cgroup *memcg)
+{
+	struct list_lru_one *l;
+	bool ret;
+
+	l = list_lru_lock_irq(lru, nid, memcg);
+	ret = __list_lru_add(lru, l, item, nid, memcg);
+	list_lru_unlock_irq(l);
+	return ret;
+}
+
 bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
 {
 	bool ret;
@@ -185,19 +259,13 @@ EXPORT_SYMBOL_GPL(list_lru_add_obj);
 bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
 		  struct mem_cgroup *memcg)
 {
-	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
+	bool ret;
 
-	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
-	if (!list_empty(item)) {
-		list_del_init(item);
-		l->nr_items--;
-		unlock_list_lru(l, false);
-		atomic_long_dec(&nlru->nr_items);
-		return true;
-	}
-	unlock_list_lru(l, false);
-	return false;
+	l = list_lru_lock(lru, nid, memcg);
+	ret = __list_lru_del(lru, l, item, nid);
+	list_lru_unlock(l);
+	return ret;
 }
 
 bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
@@ -270,7 +338,8 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 	unsigned long isolated = 0;
 
 restart:
-	l = lock_list_lru_of_memcg(lru, nid, memcg, irq_off, true);
+	l = lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/irq_off,
+				   /*irq_flags=*/NULL, /*skip_empty=*/true);
 	if (!l)
 		return isolated;
 	list_for_each_safe(item, n, &l->list) {
@@ -311,7 +380,7 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 			BUG();
 		}
 	}
-	unlock_list_lru(l, irq_off);
+	unlock_list_lru(l, irq_off, NULL);
 out:
 	return isolated;
 }
-- 
2.54.0


