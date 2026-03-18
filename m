Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F6231077614
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DCE76B0308; Wed, 18 Mar 2026 16:04:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119336B030A; Wed, 18 Mar 2026 16:04:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02DF76B030B; Wed, 18 Mar 2026 16:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0C886B0308
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:04:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B43871601AB
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:04:12 +0000 (UTC)
X-FDA: 84560260344.30.3DCC03B
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id E1D1980006
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:04:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=pzH12g7C;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773864250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=He+/m2HsFJRsEnGnHHCnhLMWVNpYSviCx14DKV7mwYM=;
	b=vqzWr/Vb41bEOByyu/bdXihN+q0pZ8S0NJiQpdORCVuVj3V0znkaz1bf6u8zNfRcskZ6Th
	vzqLvaE0VInFdqHKZMWq54fVbw09YIaelrsWcavSTe61NxAT2xqXCPpC0bBKe2995PyTRt
	59WiChtWJ0C1CiKNl3rNBXpCFDxEnL4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=pzH12g7C;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773864250; a=rsa-sha256;
	cv=none;
	b=5j3yG+oFbbUxi3ZM+jXrsgLYf7oPoLo6HVadbqxDMMNWONqmS44Mgs+GWiuRk4gKGeJjW6
	SVrEKO9xZb+cYFDjCbSaCVTfKG8qh59dbdiKXDzaXTZ6bBQ+9uu2qSZKolg7iMDPhaOmNo
	MceeInz5e2GAYe4FoH9VfK2a4TxtLsE=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-89a0ecbc713so2930696d6.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773864250; x=1774469050; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=He+/m2HsFJRsEnGnHHCnhLMWVNpYSviCx14DKV7mwYM=;
        b=pzH12g7Cd+olt3gw8wrrGnegGg37gYkX/RfE05PaXr+x0ExHbfXDe/Fgk1RWiClgUP
         OiHpb9gQuevSCL+Y8q+mkzFZ4DdGE+ZzcX+NeovnOGoYKhcSDHnOfW0cb1FadjwjXlMj
         gCwVLmDm4ptXZeRVK5c1hWPwfn0vXZQIyPPqotvdLZnjWqAf9ui1sELACJhLC25F4NDv
         6FadK2wssk5nSuE2J2Bgmpmf+pUE8rB9F2pf0P7UjRfTEMYN6/TS+WCtWNMIuaqLxcci
         QImUNN2Os8PXMC5lrmT+dRTujGZGNke59QdavWOdTN402J6TY0fwMOfXhwOp01Yj4mSx
         Sx8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773864250; x=1774469050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=He+/m2HsFJRsEnGnHHCnhLMWVNpYSviCx14DKV7mwYM=;
        b=JtQgaRcM7T9my/X9OuFGDxdDkWRk0Sm4SuyDGgB3QKkTpCaYhwqjyYBDBt3A4kE2Vn
         r1tmhgQCGWvt+ZnfSHPLb3WrQri956FtR955rqSpuGaLaCTLshGHrSi+eGUfGJcTmKRZ
         GDrTiUOEQs+ID1r0G9efStYg7ClaJn+2niF2he1Gr2VeHsesj8iuARL+LsPAfkyfDGSV
         aVRGluuOENTOteBH5CjA/qgCjKfBFf6B0WxwtpiFJTGCH4lpJQckzq5KDFlpCx3A3daF
         hiccoXeINblhoBsixYNCfl0rtNCJ34YSuQ1OAhBYWduSRPl3EA9K5e/+DhQeYcY5D5M7
         tKlQ==
X-Forwarded-Encrypted: i=1; AJvYcCW39Gxv8xJ46gdLIvkVGG3sY8Ou9BatxVVGn2chPMPdq4EWpDGWo3g4GJOS2SzBRxOFp7aHX/k27Q==@kvack.org
X-Gm-Message-State: AOJu0YwAUW0FzP0GaNEgNpFCamacMG9tv55PulrQmVSTsq4tXl9KBwLp
	1mHe8ezMHCGgx57mhq4XVZNk2OpSkL6616y+cNTGpKV0sqqBj6EF3qY0WVLi2VWvXaQ=
X-Gm-Gg: ATEYQzzLTIfbIby2pwV4FPvz6L/+BA8XguAtqAM8Xam+rD57SoiY6FbPZ4t6Hkx6bfr
	gziGzO7/mcoSNz3oLlaqcogqx7MEr7fxsOlg25ehYZ4PwAOeEwZMGKC6BBNcjfWWOngQdjwLdXm
	eUd01BHh0y4LNnoJXiojOKWA6YitBIfUZ51Mc3VHs7VkBbKU/9qdHBzFcPVel4RgaE3R1NlQ01n
	Y0lngpix92SBMvIhphSk3rGWR+P1sIL4rMAwr7s1NXZACLNRAcKuHL1ATu0xZO0DslwyXOm6Ai3
	3cd973h3SkXOQgU7/aFRQvsJK6weJuDRQwviKD1y9x7PlutOWsp6p74ZnJNisogf+Jt1aoancNU
	CC7kxHJ9zk6XVusqRKdNkSp7OOgFNGSpbmnbAhN5Gn/pxFIMGHTDMQ+NEef1V0781pjm5v7MNH7
	oksqGB0/DVQSO8ISJpeGEiMg==
X-Received: by 2002:a05:6214:21e2:b0:899:ee6a:50ad with SMTP id 6a1803df08f44-89c773dcb69mr15009936d6.9.1773864249800;
        Wed, 18 Mar 2026 13:04:09 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c6b9ec0fdsm27009326d6.40.2026.03.18.13.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 13:04:08 -0700 (PDT)
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
Subject: [PATCH v3 5/7] mm: list_lru: introduce caller locking for additions and deletions
Date: Wed, 18 Mar 2026 15:53:23 -0400
Message-ID: <20260318200352.1039011-6-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260318200352.1039011-1-hannes@cmpxchg.org>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E1D1980006
X-Stat-Signature: p3az1fsche3ur46d1iuhnjks14wbjhdd
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773864250-829742
X-HE-Meta: U2FsdGVkX18mdHlNPsKTjotwNI9Rg3sEISm6SA80/29xq1ao9yJV9LTVzvPoN2JLXE/0LjK4YEYsAafocutrrJAld84z8IAETXzK2EizMlJff2eQcv3AKygec2GZKYuPNknDtMZqY53kZdX/V0jqNfo8jW6nNufRjxAqxRL6zQAuy2uFAtEEVTogRKqUDe5L+gWP5Mq0xkzltImcvJ4EQgNcH8Qm9b+Ip8GDbtC5os8/4ppIXPC7z4n+WjHrDWJsB+5p3a9A9XnJGhn6ZJq+c7fCDgzArnQJauNj1Mafq7ZcpY7B2Vo27mLw28ed+npFHdQFf975mUxc5a9aTfFDmm2WwKE5bnCvcMJbR6b7hUsRg/t8yQX6BqjfeUzfvrQUacHfvrHCLDbKNGHCKVX3UEAiz/36GmGzUpHHpsfeQFrSSydze+OycMk/O0ziHpGLns/9wo9ah4Jq9GU9flWNlu8lBL3OTS5GqW47C2Hye5kTTVLR4F9cMdjL2k0hBy6E3DnH4MLhzmbGeamgqS/yQ5pAc7Cd2eKMvzAaeF/eHlxcsuUO53UWZi+KOT4nw+NRs0QkIpBZr4RR72b+nAGKWW7cK9ROjIM3jqWAkEYT+x3/HosATfwnd/zMjdw09izwR0SKE/lF4fBuu/mIh975EsHBEOgsUZ8nKQLNKLn3wmDBvJOaZPNdQA4zUDOSdBHx3dQM4LNESTERQhcxNCQ0lK2bp7aawsHkEkJQ6hGXIJlyVdvFXz7f+axd8swXqGmE2glPmdQHbXcrQwnYXqzbNhacJowzAZfnNAw4ndPF7Cf8NnCzVq0DSipJSaasg56akJRyFuBghNSi0Uu5qUmF4MDtH7y1D0AER8vBh2RI1mn8fN74PPqWMg3HYnDyV/rSErpGNFfq90n4txJThu5a5m48GpEwIyctq4OeddIpQpoC7Y27UENXAeRahfLSmFGEFNK7Yd7WCUYt2nU/se/
 QcJ6BFyS
 izq/ZSHxhm32NV+lwG0s8osPw5uTNSnYqNhjO/akMcI9wCJH0SaK3koNPQmT06Sd1isBl4OCdw7szo5x35YvLmzPVe+wij4Dubvs3qL5vI2rm6Gem9/JjBJOK9vuAO2xbVL+d5jian5iLsr9MFbjZUQOl6iPLCtlGWks6HGoofcW/PCO7CAgf0o2+dh03Pnhs3L/KnncrxVOegfQbyxr5FdKj7sRfFb07PRwjuVag8hV2PY/e6btMtzIlZCLqiEVDRXWmatqLawuUIqmHQ/BFLWP7mlE71EgrKMDFzIr/AwaYIPJscvvAC4qxAOft2vRT2PO9Mx2OMhKn/YzZb8LRNpVy0zs0xpPrQC+XRvK2FtxFeN0W18QEYQGrMZm8KsThkz+3fi+5A640Oo+Wbj/a2eE1+AvJXGQMz6QBT3I6Pu5J4x4abdtaQgBqnMrodWOzBz9T5dgxXCJYXno=
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
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/list_lru.h |  34 +++++++++++++
 mm/list_lru.c            | 107 +++++++++++++++++++++++++++------------
 2 files changed, 110 insertions(+), 31 deletions(-)

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
index 4d74c2e9c2a5..b817c0f48f73 100644
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
@@ -132,37 +138,81 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 
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
@@ -184,19 +234,13 @@ EXPORT_SYMBOL_GPL(list_lru_add_obj);
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
@@ -269,7 +313,8 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 	unsigned long isolated = 0;
 
 restart:
-	l = lock_list_lru_of_memcg(lru, nid, memcg, irq_off, true);
+	l = lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/irq_off,
+				   /*irq_flags=*/NULL, /*skip_empty=*/true);
 	if (!l)
 		return isolated;
 	list_for_each_safe(item, n, &l->list) {
@@ -310,7 +355,7 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
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


