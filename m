Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5849106ACEC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33FAC6B00AC; Thu, 12 Mar 2026 16:53:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268AB6B00AD; Thu, 12 Mar 2026 16:53:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A4D6B00AE; Thu, 12 Mar 2026 16:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E95D16B00AC
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:53:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9707DC186D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:53:41 +0000 (UTC)
X-FDA: 84538612242.10.CB31F34
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id CCD9940014
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:53:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=UNnWLHik;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773348819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MfCdMvkJxAeZG14cTtGmM/ZN7/Bzr7yHmjt9XpyWCt8=;
	b=GxW/bAKN8odR3ZnrSyAdXkQT/gnGdgNlk6sdftjcPiGJHz5truuz1hJVWOIQDm3ntK/+Tg
	zCA167lpNdJLqpNG0ok/IWbQFSzUtOs1+KpeL9buF+LOzHiVxKQIc1g7yZZw+NFg0fuFdp
	tDGbvTWICQ850/7R+jaB6IVW2dhhD0Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773348819; a=rsa-sha256;
	cv=none;
	b=CD4KJzRND0kMGlAoRspzRR7dI5w/gW6s1JxK7t2+IdSOIzvV824Vp4jBjx1cUMeFyuG++6
	JDWyOi9jXMK4HnCZyoxr4gL9bPHM29ttTXTFMcAJ44ZG2JK0bXmamazcBZW/ABXHUvvvDn
	dYextrzKk6saxSu0XuWFC8ZtIUzTr74=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=UNnWLHik;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cd81963e73so157873885a.2
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773348819; x=1773953619; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MfCdMvkJxAeZG14cTtGmM/ZN7/Bzr7yHmjt9XpyWCt8=;
        b=UNnWLHiknN2hAJ5UfjYElpmxj4U9yPOZPR42eq9QwHDyDI6PWjSjN7gTt76E3im995
         mUwb01mXOiAm1Jkk+L3U0rFzEcdI7YiAlqZeW3oCZcvXmria7Dnv92vPpHgGEyEHvPcc
         XWwhnnAvX8luox066TMgNX8d+eju06zx+Zp41YPdVEt2M9H9simbNPaJKVt6DKr1y33S
         13+wpkfth4Apub91nlx/ZdSv9Er9kkLeJdmyn2qFdeD2d+er3T9w3w4ZRL3YtrBIsBsC
         xhFK/blQ2zSWzmluyYOOFnUZrITHyurADCbIRym26jg2os0Sf4QFY1Rj1GoDBSXkKbPd
         DkIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773348819; x=1773953619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MfCdMvkJxAeZG14cTtGmM/ZN7/Bzr7yHmjt9XpyWCt8=;
        b=I5lQe5K1UDIJzaHrr5DM7i5INDsmthP6W9/GRkvhU53A+KX0TeQ+Ei3IID7BVQZRpF
         2qspIDNzg2i/HUf0WSXAyetKbSrF9uz3i65rMTYl9N0YNiByFCa+WuQULS/GM521Td1L
         3VzKd4xpKRiCsLuEotu+ZfI5LuVCvh4eQqlQH+Ih6r2vbxXwJsgZRDCKxzHFjx/E/IaN
         PVVqlOkML7XxbbR5+MCBCYphaniNQKmITEZIlFHrpx0MI+ZAZ1FISMoikhclmkjzcIV4
         l1D0D8BhWQrkMkFQCFHVn/hw/Ue68Pj9fqb4lFuoKAvKsMokAZUh5ksTsTK+0IvBA2bq
         3jBg==
X-Forwarded-Encrypted: i=1; AJvYcCVVy0yfe9lp4HFOV4pN/97HUqWeS8HpvaVp6ld1ZFrQf9w72WaoAnGgdX2AWpFY+CHbNBW7FfbjfQ==@kvack.org
X-Gm-Message-State: AOJu0YxAkTJLpNe5oGXpeKCrs/6Sces2L6ewlD1+gcqw+7AjI8E627X/
	HSGJd0+Nro3h6hcUb8AruwnGXcckBAKXO4RXL6F9k2ZI2Ll+YZjLnRjGyliwFXHyqok=
X-Gm-Gg: ATEYQzym+tdtPXhP02PqwRdHm8vN7u59+fQlHEWBzI66Y2ncim5XaqkbiH2SptrIy4H
	g9bpffkUYnAyMAONj0xke921vjWd6m8Vv1ZQDsZ4x7BMXVzlhA/Nu+5Sa5ZT5qtLsl++8TXXn+b
	RURLTO6/K4+6nXYCCsylD5vhACH+gtZcbIIQxCRMej6kgGEFWXCExUNYHtVLUwLuO80G2Di48K5
	wlrZtUTE7PH7uSbhmITJqnirUhvXZs98FazsIhJO+PGJew240Fo0vmMy42vDtzI/rxYbSIaL6a4
	2B8c2FY/WW3F+u4c7ZrVn7NNQerV7huUr+B9uZnVj4CVNCwNadGvL9bZiiXjHw0X8669R8Z5Znk
	sPK9Fob5U8U9RYzyGBe3JVv0AOw531e2qujV00RrQUGgM37DlctRkxDWIlFTx/7YdRx+Pt+V3wo
	UR4LMQjLbxDcPMH27JMwsAQQ==
X-Received: by 2002:a05:620a:1724:b0:8cd:7f7d:b091 with SMTP id af79cd13be357-8cdb5bce7bcmr154603785a.71.1773348818838;
        Thu, 12 Mar 2026 13:53:38 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda1fbd120sm412873485a.7.2026.03.12.13.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 13:53:37 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/7] mm: list_lru: introduce caller locking for additions and deletions
Date: Thu, 12 Mar 2026 16:51:53 -0400
Message-ID: <20260312205321.638053-6-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312205321.638053-1-hannes@cmpxchg.org>
References: <20260312205321.638053-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CCD9940014
X-Stat-Signature: cgpfo1ksxggdd5kmbbpq1uwn3ejnpfof
X-HE-Tag: 1773348819-998075
X-HE-Meta: U2FsdGVkX18ZIyg7wrauL5zICsXmSAjrtC32G2+4dKpCSI5F6lyiUyMpBi/zrk4utFYNsRgckvonFFVOlHw4BtGA7elQ9kdaECKuN+fGmJaB1ctTPz3HsznelcT0Npl6Vjuzno10IsaqCj+Qy9PLNNXoRIo7FUFYySCZLag5npYKKdyraKtz7EwzQKMqi18Y3aBa0qP9mLwC8zgFuGVxM8Q2Ux0v4r7RhB4yWd5Fqzr2IMwUbGHuIkHt/bK+BME4jVHE0I4d9RDQhdZGjl94xnwlQMYakUOmUMP6QZ0uuWdCSpuqdzscMyFbl/qalukMjLz0smcE28QsaKoR/X4JyAW3apFZV1YypbN0oNuY2mJMqDsE9HhHfuNGumurcNcSnOvNWLOdkX1TKQVXmCl5fAbYRJDcDwmTKnNqD8kcDn3k87HmV+dkWffHslH34JLoBFl/mybELDDL1vPz04bfk0SuslsmGzQ4UnWucijZxmIwJsJOmB7r7AJk+GUSjG9MQblq3TguvLlRHPmAM6VNJ7qlMKdhtYsMDsIoWZdGOHGXBcox0oMPFChxU8QG+st5F4VF2BDP4M5k/adyFOs5ahCgHAcrcLGDUKfvUAh2mrRuay73W970uRQXX6eTwA4t+UNcAp+v6CIpkEyF0jYuMOu5mSnGhX+id0wWvy3q/W+5itZa8eyV/wJsZWZ6fX7PIf1HeQnhSPuCL5ZXYCKiZIpYpu42BjrXpOfR8mWrcYBMDr/gxqjK0iQlKn+t4PJkcM8cLWNR8l0KIT9764gxwlNbmhv3b+Ez8SVFKpt/qhk/xlQoma6FPNZb91NaQVwB/UX7bGDdAilQtiJZjHaxlClGGikoLrajLdL6r8OxgheVevqL1aV4Vp0UxkVnrwXHTd6NgKCegt4vXtAeawudAkwUYiG6fRHvmrAsqzR2hfdvWOmqK5LOwCbQSNHRNYUG0v68QlU4ohJrHjwZgWh
 KE8K9vTG
 rIkyX/y5OFOE8oRfB5XlJGGirw5h6Fdg1V4L2SowgCm2FukX2Jp0jKqrqwc8Gvo0KdZITADeJZcAdDVVd/SLcom/zT5FzdPnR2dhLy8BYfus65efDd/A74poAN1WV6DZDTdD3xKuy3N6BhSrB5I0oGBzQu8cPIpBaSGkJ6mlSk/BG2FOElAW1tOqZ8secBlXiUWIzmbjVM4DJwXEOSgda2BzuccqCJUVAaCNDZcC321LYe/X1wRzm7KYX0dHpiKuP+t80PtnSC2hyejnUTG7mcC4v+ifnkphfIGtaBBSXS1mUOmtwO1DIVYbEz8D5lkTjraMle+1HqzdqFPibUYoe67OUhx4lqjlIiLcWa+NoYRK2Ln+4Z68XKLNThnjxxDigbGPonDFdAPT0GULi/YPY0aU5PWb8UJnteRf4gkqvb53pro0oRM7nEpuXgw==
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

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/list_lru.h |  34 +++++++++++++
 mm/list_lru.c            | 104 +++++++++++++++++++++++++++------------
 2 files changed, 107 insertions(+), 31 deletions(-)

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index fe739d35a864..4afc02deb44d 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -83,6 +83,40 @@ int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
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
diff --git a/mm/list_lru.c b/mm/list_lru.c
index 4d74c2e9c2a5..779cb26cec84 100644
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
@@ -132,37 +138,79 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 
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
+	return lock_list_lru_of_memcg(lru, nid, memcg, false, NULL, false);
+}
+
+void list_lru_unlock(struct list_lru_one *l)
+{
+	unlock_list_lru(l, false, NULL);
+}
+
+struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
+					   struct mem_cgroup *memcg,
+					   unsigned long *flags)
+{
+	return lock_list_lru_of_memcg(lru, nid, memcg, true, flags, false);
+}
+
+void list_lru_unlock_irqrestore(struct list_lru_one *l, unsigned long *flags)
+{
+	unlock_list_lru(l, true, flags);
+}
 
-	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
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
+		return true;
+	}
+	return false;
+}
+
+bool __list_lru_del(struct list_lru *lru, struct list_lru_one *l,
+		    struct list_head *item, int nid)
+{
+	if (!list_empty(item)) {
+		list_del_init(item);
+		l->nr_items--;
+		atomic_long_dec(&lru->node[nid].nr_items);
 		return true;
 	}
-	unlock_list_lru(l, false);
 	return false;
 }
 
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
 bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
 {
 	bool ret;
@@ -184,19 +232,13 @@ EXPORT_SYMBOL_GPL(list_lru_add_obj);
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
@@ -269,7 +311,7 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 	unsigned long isolated = 0;
 
 restart:
-	l = lock_list_lru_of_memcg(lru, nid, memcg, irq_off, true);
+	l = lock_list_lru_of_memcg(lru, nid, memcg, irq_off, NULL, true);
 	if (!l)
 		return isolated;
 	list_for_each_safe(item, n, &l->list) {
@@ -310,7 +352,7 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 			BUG();
 		}
 	}
-	unlock_list_lru(l, irq_off);
+	unlock_list_lru(l, irq_off, NULL);
 out:
 	return isolated;
 }
-- 
2.53.0


