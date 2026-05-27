Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBC8FCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 20:48:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BEA66B009B; Wed, 27 May 2026 16:48:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F3F56B009E; Wed, 27 May 2026 16:48:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043246B009B; Wed, 27 May 2026 16:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC8856B009B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:48:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93277C21AA
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:48:19 +0000 (UTC)
X-FDA: 84814387518.08.3F6C6CF
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id BA06080004
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:48:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=LIT35cVs;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779914897; a=rsa-sha256;
	cv=none;
	b=1SyCM1maNpmX+Sr/R/aX2QIfWn6pvdElXE7dI6nIGrfEtqHF1IsHbbug8kLGH6j3tWF6vF
	fE2S40BPnV/ku4e/3fd879/uL0i4A04BaAnB/jYbGqdrR1n4UviTNWJqJxspNj5Yx9NVRd
	l4ICFq7V+g5BZiQbrFWXT4dninwoehU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=LIT35cVs;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779914897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3AOQtP7Xnnp/Xq7xApSFU4g8ZA9bsT8U0JJPgTL+uXI=;
	b=Nv/uKyJroufcqZo8m3rYWlZHUzZKj1dY5JEq3hK5IXfgfwgpWveGJWTDNRLmjrS79yWcww
	ijECsDza5kStQJmvoh0wToie+cQh44KH4Xlnlg9tleCsuwyLNhrnm0knbFib0OI5KTRDQc
	It4yoUPdiC9YPJV0yzPbFsEXClKsOUs=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-516cc5471bdso89112301cf.2
        for <linux-mm@kvack.org>; Wed, 27 May 2026 13:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779914897; x=1780519697; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3AOQtP7Xnnp/Xq7xApSFU4g8ZA9bsT8U0JJPgTL+uXI=;
        b=LIT35cVsUtBUC63xoKM4wZUKaRelveWZEcHvFCOra2Oc9AQKiGu++4b4B5D+w6+fH5
         nIpGPZcbirK9AbScNNRKEvKOv/NH3+OMJ1E62zkgOZsB1GYrryCXuPFaXTiBzwdkVTjY
         3BZSW/luI8fut5p7wl4RkPvLsdNBLvd6Qb4GzRmqfVAOJlM0spDvYXi11FY8HC2D6Cf+
         9sU6aEnBFuLj4YZqAesgtk8XLEz5w7EPtLoxz92bJqyhMxxoTrUGqdLImcErxS5cvgc6
         KffabRcQPwFfgq2SVpIFSRULigtTmtq+cs3Lxe9EZun1HSH8TMicGfiqyPNXQ5NSu6Pb
         NCBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779914897; x=1780519697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3AOQtP7Xnnp/Xq7xApSFU4g8ZA9bsT8U0JJPgTL+uXI=;
        b=hGBPQPFCjeCNirsq7ObeEP6sriypfYlCWmksPYQ/6fF6xlWazNfl18poKLBsLVZb1W
         lvv4BagU7QcEtd1e3qqufHxIiXnn+1RQ36LmtcJ2g7RrbUnwa7QWyGgWbKpcDsdP88fw
         pJ7WKTnJ7hoCf9hqi6CmjO3L951FdV3ApYbUbViOw4aNLY7hONdIa8yjs8PElzN5xUid
         fBYfEPF0DuMm3MWRwdiOeM4XbbcxBdHhs1vawh5FEOTtIsTfvFRepVmFPuhl55cQIqg3
         fVhHkzWxj+l/Fi0t8K8qAkm07PXwTswfbE22uJDqTxqRTXt9KIzoYuW85JZ16tUjZi34
         GeFw==
X-Forwarded-Encrypted: i=1; AFNElJ974+L8g17Z2l74yebkLv9ZlZtCb7xbH9qSnVdB4dh15VZzMI+KCNrlF2LvjZKh5pf1DHFI8p3yIw==@kvack.org
X-Gm-Message-State: AOJu0YwRuGXFg10FfI3b7cJdpLUdZWyTmfj4cL9by8Zlq2VIkc6GvniG
	x4bUIDwcOkWjTLQaGYzVS5igayvNS0YZkZfQ3r92hdPtYeXLXgk3lDqBPCHqCrYQ4zo=
X-Gm-Gg: Acq92OE5k+lWdfl4V4IZ2k0cRj4KihYPSpG1cewd7eAg2BsW/SD6PsMKkxPTOeeXaOY
	aeq5ykE+d7Q1Yh179emMbTb/MHx0Xh2tkJMSkhtCPaX/2MmE4652+mIbBhejQsj3JSyXijVeqJp
	J6MqaBaP2+gSSI64DQs8LIXU66JI04z8alrgTS2aEzjfXuhXVd8Lk5X4N5QVldrw5t1VU3KSERf
	WbVRZKbVUVWHsISALLDyf5VHwGoVHVrRkmvUd1yeoymQ7JCpkFH/6mr+DFcp5P0RT7tDFO6g04s
	HYPMn/X7iKWI0VFTOIg7IybixE3RHiN8z5zDcvlmspGYIwBsL+e75KjxscHUwwUT0kQ8JRb07hR
	o3kuHyMOgQW3WKRh+wpM/c3IJ7v4S+g9IWYBf8wbOCWzjKTUozCJ1qMUIP1Zv0xEUlaqLLRzAmR
	aXhfVZ1ZnLBhTguvTXfvt481X9cFprdhsYUVfWXZQNiXg=
X-Received: by 2002:a05:622a:2d5:b0:516:4fc0:27ac with SMTP id d75a77b69052e-516d43e4561mr353992391cf.50.1779914896842;
        Wed, 27 May 2026 13:48:16 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51706a28ddcsm58877121cf.13.2026.05.27.13.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 13:48:15 -0700 (PDT)
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
Subject: [PATCH v5 6/9] mm: list_lru: introduce caller locking for additions and deletions
Date: Wed, 27 May 2026 16:45:13 -0400
Message-ID: <20260527204757.2544958-7-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260527204757.2544958-1-hannes@cmpxchg.org>
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BA06080004
X-Stat-Signature: whisysbsons4gra74fqysqx144pua5b5
X-HE-Tag: 1779914897-909761
X-HE-Meta: U2FsdGVkX19pgDoFEJM5zfU79T9zJ9szJN/337R9CwGIQ06Ky1b0ZtYk9fZQi+7AJop+DqJ385jUro0ZrG5iEon3p/yn+g9Rt+C0/IARRq8Aat+cjHYYigwLf8/XT4uVnLjWgbGMUBry4h6jCvGlKRwAU4+GikFTqu51AibLcGWa9s03z9nKm+U4x/jXtFQjTZpHfqRoAaQw/b2Kg3+pW6gVwiBb0/HM1SLCtB22MInRSypQdsVy4AmaF1ObyKZiI1kyrWK2thNbjOdRd+rgYILVzvnu89BcaR6LKp3yimieyrHrWBbd53ieA84utnlNjt6+EkluUV8VKUjRaOJKCssPiKivXdc13YkhTTfKs4TrIS5sI5PmX60YsGwgSiu8584u1yOkayD3yz0bqrFSpmLYg5wdKYxl3+bbWkjd8sF3iXzwUht7SRmC5DL0noWulN6qsbD5EpGYrtHUmTWCqmp3TlZX1VtgbRPCM/RFi0XOZb3RgyXcLUZy84zHj/ABF2hH0+zxVvFZMPm5Kkml8OJkfY2AGGS5qyXllE5lWEF/8mVUA1WkJgOmpuKkqIDFthdbvdkkoNp7s3AKM1zp3UTzNcEsPhRI3zo4zckuZojTDAUpN4pSGatXHYqDM5mTiJAG8j2G4haNesQlvy75F7fz0rNDKBxBMVFO3C16b/0nKHMpnjKnhdsMYk3jdznzIdZkuBKDkRdRtlJ+j5RQcMD3wiQoDHgHcBUFerA9FK+S/e0daijEGhZdIjOjpuK0WOgGZmwNO6SCjEJsfUj3i6wO8WDFocmnolrjINwB+b8ubOS4CPS8f+mS4wP2nVZowLAD+n2Qk4vfMhVtldDCDjw+3dNZ3T9DTP3PUF2+vFBABPFS7n98aWTAH2lXb6Fwhhpe5X71Xd1uby1CuQVQdAVixTS+98vNZhel5qRQqrKfn8/HzOKKpw627K+bTUYMjViHjpy1tz/6JNihAUF
 1nZTHJdl
 cWAnTIGvItL0BWXcmnoeqlBQBirBXQl3bep3ekogD+AxU0bxKVVyBqOJSzZMeAau0mui37gu9YD5fZkLDORrOkioX44Ty+9L2dgUN96JXRBR8WFrbtj9QW+3pSzqTkrgcaXxUASgZG+pilEu93DFq4MXddsSPOQzav/ZXq1e7ZoaSIRMHbLgCNHd265qJDpW5HoB4LuVZpsZFrGnprbIS+75+Vv15XkfChUrj6YFNpI+363cmPMgas9V+EA0nfdUFeytSLeSDZNFBnEUl1cWabk7sj5u4wig/PXFzhOE40OrvsVVHGE4M0rZp0Tbe6RVC5QjffdUVeQNjTidIZdxemcg7HHhI/7+DsPtPs9gabwhZGZSuXazBuT5FfMRHqqpjUiYc5i8NUGOmt3pxUIKI3R4unji+W37oTyE2qEyFl7dKHegu/1ZAy6BjsSZ+HpEQ4gokG7iUFwhktNHVEBzBcGC9Gef5Kf8VbLR3CeDbGj7BBup4+yWl+M3/uc+z4AjiW9R1jbCT17MeHD7xN2n5XjfM0DMo/lTfZTN0Xc4LTjlx2HomSTosXv+tFuxU0YaunYEgTBUrnmyX5IaxgKzS62j641qZjeVbBZoX
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
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 include/linux/list_lru.h |  43 +++++++++++++
 mm/list_lru.c            | 133 ++++++++++++++++++++++++++++++---------
 2 files changed, 145 insertions(+), 31 deletions(-)

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index fe739d35a864..134cb3e5652a 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -83,6 +83,46 @@ int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
 			 gfp_t gfp);
 void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent);
 
+/**
+ * list_lru_lock: lock the sublist for the given node and memcg
+ * @lru: the lru pointer
+ * @nid: the node id of the sublist to lock.
+ * @memcg: pointer to the cgroup of the sublist to lock. On return,
+ *         updated to the cgroup whose sublist was actually locked,
+ *         which may be an ancestor if the original memcg was dying.
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
+		struct mem_cgroup **memcg);
+
+/**
+ * list_lru_unlock: unlock a sublist locked by list_lru_lock()
+ * @l: the list_lru_one to unlock
+ */
+void list_lru_unlock(struct list_lru_one *l);
+
+struct list_lru_one *list_lru_lock_irq(struct list_lru *lru, int nid,
+		struct mem_cgroup **memcg);
+void list_lru_unlock_irq(struct list_lru_one *l);
+
+struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
+		struct mem_cgroup **memcg, unsigned long *irq_flags);
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
@@ -115,6 +155,9 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
 		    struct mem_cgroup *memcg);
 
+bool list_lru_add_irq(struct list_lru *lru, struct list_head *item, int nid,
+		      struct mem_cgroup *memcg);
+
 /**
  * list_lru_add_obj: add an element to the lru list's tail
  * @lru: the lru pointer
diff --git a/mm/list_lru.c b/mm/list_lru.c
index fdb3fe2ea64f..402bb028114d 100644
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
@@ -78,7 +84,8 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 
 static inline struct list_lru_one *
 lock_list_lru_of_memcg(struct list_lru *lru, int nid,
-		       struct mem_cgroup **memcg, bool irq, bool skip_empty)
+		       struct mem_cgroup **memcg, bool irq,
+		       unsigned long *irq_flags, bool skip_empty)
 {
 	struct list_lru_one *l;
 
@@ -86,12 +93,12 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid,
 again:
 	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(*memcg));
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
@@ -132,24 +139,58 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 
 static inline struct list_lru_one *
 lock_list_lru_of_memcg(struct list_lru *lru, int nid,
-		       struct mem_cgroup **memcg, bool irq, bool skip_empty)
+		       struct mem_cgroup **memcg, bool irq,
+		       unsigned long *irq_flags, bool skip_empty)
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
+				   struct mem_cgroup **memcg)
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
+				       struct mem_cgroup **memcg)
+{
+	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/true,
+				      /*irq_flags=*/NULL, /*skip_empty=*/false);
+}
+
+void list_lru_unlock_irq(struct list_lru_one *l)
+{
+	unlock_list_lru(l, /*irq_off=*/true, /*irq_flags=*/NULL);
+}
 
-	l = lock_list_lru_of_memcg(lru, nid, &memcg, false, false);
+struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
+					   struct mem_cgroup **memcg,
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
 		/*
@@ -159,15 +200,50 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
 		 */
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
+	l = list_lru_lock(lru, nid, &memcg);
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
+	l = list_lru_lock_irq(lru, nid, &memcg);
+	ret = __list_lru_add(lru, l, item, nid, memcg);
+	list_lru_unlock_irq(l);
+	return ret;
+}
+
 bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
 {
 	bool ret;
@@ -189,19 +265,13 @@ EXPORT_SYMBOL_GPL(list_lru_add_obj);
 bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
 		  struct mem_cgroup *memcg)
 {
-	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
+	bool ret;
 
-	l = lock_list_lru_of_memcg(lru, nid, &memcg, false, false);
-	if (!list_empty(item)) {
-		list_del_init(item);
-		l->nr_items--;
-		unlock_list_lru(l, false);
-		atomic_long_dec(&nlru->nr_items);
-		return true;
-	}
-	unlock_list_lru(l, false);
-	return false;
+	l = list_lru_lock(lru, nid, &memcg);
+	ret = __list_lru_del(lru, l, item, nid);
+	list_lru_unlock(l);
+	return ret;
 }
 
 bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
@@ -274,7 +344,8 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 	unsigned long isolated = 0;
 
 restart:
-	l = lock_list_lru_of_memcg(lru, nid, &memcg, irq_off, true);
+	l = lock_list_lru_of_memcg(lru, nid, &memcg, /*irq=*/irq_off,
+				   /*irq_flags=*/NULL, /*skip_empty=*/true);
 	if (!l)
 		return isolated;
 	list_for_each_safe(item, n, &l->list) {
@@ -315,7 +386,7 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
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


