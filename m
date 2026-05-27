Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D03FCCD6E43
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 20:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F4306B009D; Wed, 27 May 2026 16:48:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5A46B009E; Wed, 27 May 2026 16:48:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F966B009F; Wed, 27 May 2026 16:48:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9ED06B009D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:48:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5DC51C05A8
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:48:21 +0000 (UTC)
X-FDA: 84814387602.07.ED9AEA9
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id E46C52000C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:48:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="Dd8q/P2w";
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779914899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36NJZcIxb79ojrPGdd3UkzDEUVDRZxNst0ZLZe3TsZo=;
	b=Pa7no3Cj0rDm4TooGgfd5Cf9ufLBtj0rrlwM/fRKXn42HpqGRzlkZvbEfAjnwm8Oc9RxBh
	kvQHlEHPeHOl6itlYli0DGVftDahIqHArfCUn9tM0MqT1G4dEIqSCxwCp2tIgACdNhXpan
	qDBz15b9ea4ZKmypdvIp+31JGna+lX8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779914899; a=rsa-sha256;
	cv=none;
	b=i9/y8TH2i/M5F2Za199lTU6m/byurarNdM6nr1gyLAfOKYG0WFUr6/iUfBLCml5zK6W8vh
	u2fZHsm1tzKqnKQZsY02ykwSHnuQGiN7d9D4Oxc20VmK+T705GY+srlqMp6U3BCcOM2jIc
	vVHOXAlf5w3bCN76V3q7NBTcTRK2jXA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="Dd8q/P2w";
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-913cc4d7c71so1324085985a.2
        for <linux-mm@kvack.org>; Wed, 27 May 2026 13:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779914899; x=1780519699; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=36NJZcIxb79ojrPGdd3UkzDEUVDRZxNst0ZLZe3TsZo=;
        b=Dd8q/P2whjoOovwFWK+58laLVyjOBaTOIyrwLfXB8tQMQr0BTW8E4kzXIdYswemLmD
         qL0zchyfbb6hyBO/o9a1N6kTqk4qdCB0wy53Eqo4PaLesiMnKzpNCjPov//WS2G8US1p
         ppSm72y8teqBcWXgz5oMlkqUXC06MH527nDi7XQj6nOSq35C3VShL+ysil5epCbbltp8
         rAISI+3wLXA1B1EFm8tHbEoiK4YUspNz7uurwEt0XGoxO/IoLs4rJBQM0De/U18BtOR3
         mI9xdBvbg16d72ziYHROnu6DlafYnlGIG5M8ZUXdpSppAbPkF1/uaDhO0Ex/PmxEs4iN
         lwbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779914899; x=1780519699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=36NJZcIxb79ojrPGdd3UkzDEUVDRZxNst0ZLZe3TsZo=;
        b=LUVOeU93UsJ0ux3eLedWSA/lXqt2tmIrN0ROgm/qrRJYTieu471rmTN/aIUzOIc65w
         kXD15jT6Jhae9j1BXxTCtOWfeydjHCghTvLN/949Ub1wJ7i08w+9/c0Y+xoz+4LFh8PX
         6VVT1Zmkajn2phLDWNAI9qidAp8XG2Mfmpk8rGrUdbOEdDvJ/exfqS/l29VpqrSdNfuN
         DEEswf7EIjiiLdmf8v9q99H7W9lSGcfXEglz7HEawZTVS2X/y1kTHVGoD+wzdFJ2ucsC
         uYBYCJHnmbppwQ/O6XNRdcpyRagH9ae3TXxQRJjX1XF1EAxoLQSGdJG+npd5PGN25+CS
         Tghg==
X-Forwarded-Encrypted: i=1; AFNElJ8G/rSXQDm5viT06S2SGJBh4WQiVF6uNDctu9RS0Apr/MbjVjuu0Oisbe6iu77o6iXAqj2VC5gAyg==@kvack.org
X-Gm-Message-State: AOJu0Yw3mrEe/CsJoMD+FBtWHYI85ZZTbvOxdaOE0cIwxBuhUHWx8A35
	ro+lfhUK3tU6NTQkBbgnucEV9yMd37e79xpOHMJ90OqtVAJwOzTxjjrnI6XA74fyxJA=
X-Gm-Gg: Acq92OG0hVhyVycbsrmjqSsNAfaXCBBkEH8lUlxGkJG6vD6pCuBrSwnuRKMHtxn8agV
	qRLU9DH6LtMMn3WG24cvjw0xHXL/aD1/QTXMaTtT1XHyxN0I8Nqbh2dAWEGXCXlpMZqidCk1laz
	EU+ETDBgLln+M1j8A94882CTVJIzOnfegxPEjudH4QqKLDIc+8ajHvhiI2NvbyaeZ9LUSRiPOIV
	jjtqA36LmX1oZwlZmLURDh2vgiliRTtjX/WHPLrIxmxTkf4h0e25DYPzRmgrNd15LZMAAdi2aWx
	+4+2P99wFdcgFHB5RA2qOEtGb6BMoCfswR6dEbUIbODE8EGQN5saTMBer5Zw5WLT05o59/93UlN
	MalQEMJGAcVJKrMTrOKfQpIs10iU09CmElQ2jUPgzuiiifVKfwZ6o74Gp+L6wh14NIi8ybPOBLO
	JcfX4294TzS4ZxzZeyXHhAE/d1ylMkXVbt
X-Received: by 2002:a05:620a:2909:b0:8f2:c47b:962e with SMTP id af79cd13be357-914b49f5399mr3644650685a.49.1779914898663;
        Wed, 27 May 2026 13:48:18 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914f87d1a27sm589350185a.28.2026.05.27.13.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 13:48:17 -0700 (PDT)
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
Subject: [PATCH v5 7/9] mm: list_lru: introduce folio_memcg_list_lru_alloc()
Date: Wed, 27 May 2026 16:45:14 -0400
Message-ID: <20260527204757.2544958-8-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260527204757.2544958-1-hannes@cmpxchg.org>
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E46C52000C
X-Stat-Signature: cznf9h8iq8cj4fxy49craognpw7hibdf
X-Rspamd-Server: rspam06
X-HE-Tag: 1779914899-470309
X-HE-Meta: U2FsdGVkX1/XZh+C5XIYCqgX+UVJ4F7CuqxpM2ociya0AR58OyX/VEFwIps17C0fFt1si6/uRmoFULStQgbkt/ctff4OH/ia5AAxmqulZ4gGjEHwJVUWbLCw6p2UgDRi8o01iQSnDPEWuYCJWOyUHg/lT1puF0sU0lTSanD7UHbVWbwCovPXmGj9PvhM82yqLgNIxntwCcO8dHtAZj7F5/F0EIuwlYpkrvCb2PDIkWIJhWdjNpxSISjRiTXU3di42JZAiNiWkpfTjwN/ra7U7gfn0DMJ53FtTi6FLGSUlvqr+Mi4XvNa+XjnHIXUCilBk5vHxjI57m1FLBA5nwCQw5YzUEJR1Tp36UYQV43eDm92suIHJDGgE+rKXEkX2HcmHGfljZtDD9UvJ6vgqgibJsJekyhUDqL7plbM0nSkRiM9cf3vjO3xZvMUVcpuVJQ/QN6/yRj3q/vasczEAUju6yHpzOr0bGXHniyL/ciIbFgF/ykDz2rHqPyTHOz4wFyBSAR3EOT95ADZNQyVnew5NBaqkGmULOZdBKrZPbEQJE6ape6WIbrPqH5qmhf51c9gkwKkPdrUo4pM4DH4wE8lR8Up11XSYR50btY05RYMTnEkn0sIBHl+dSxcgtR8wyPz3/zQITS9kshZ0i8SjK8mY0PzEMjJlYCDC02iou+riqw99wKRUMfmWcUUhiSXed8mgko9VNr7SlM2McjLxrsiy9NIoQ0DEL73NfxvYBmVMvr3JzBMSG12d+TAut0Imd54K4ncM566aujYEsa3zkiBgKqeD1wqamfABIAGCGSF10eKwy+lVkfjh7hHAAH4BSe+A11e4uyNfjzeDdwHyopxJN/F1+hvU90ClZSDU7LDFnpKtoHO6xQob2LhqIa7/NTyn2HQbGHqyR6R9xs/aKdkfdSHb12VQ5HBywo4GEbHBar4budQlwtH8SRDsE8AdgXXscZzbH62OwxeTNCJUYX
 hIDeq3vN
 Jz8xkBat89EPtcioM2FaUyYVSkXxh1fbVz6cXN7bX5l3Zvp1JqoQUJMS4B7+iOODr7A0o3NbWHz/8vBc2mOZ2FQL1ju9kiufsKNx8R0BFUSWOXXpbKLpRFIdVR6Pv/92nBEFc2sPNtGqXSeswZprvc6FKEwMsLYl97uqdcqZw7waVCvT1tHKG/HeorqDTUG9BizLqHJM8jCsmNjd2dpZX8zvkq2Y5OTZL0mxh3sZr4NaEWBkEuSJS4mHagHcpN8uTNQbPhndSD2ahKbcgldnKSAfZ3xIxm93Nh7LV374uMtry0YiQWDIn9F65+sdYHSzTYjNqhEiH+DXzWJiUvE1yg7Vv0XpBijKFuDDKK5GmqoN0iBSy5q0XDBAclXgbf3OYnuxfRxDaMAKSMTUyuKfXNJ/EWpWCWsw6xpmK2gkysIw4Q4A8LseAEQknW77yFOXZISSXbFMOrvKqzUoCo18a9n6vkJpt/sEOV65j8RAp9coO69k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memcg_list_lru_alloc() is called every time an object that may end up
on the list_lru is created. It needs to quickly check if the list_lru
heads for the memcg already exist, and allocate them when they don't.

Doing this with folio objects is tricky: folio_memcg() is not stable
and requires either RCU protection or pinning the cgroup. But it's
desirable to make the existence check lightweight under RCU, and only
pin the memcg when we need to allocate list_lru heads and may block.

In preparation for switching the THP shrinker to list_lru, add a
helper function for allocating list_lru heads coming from a folio.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/list_lru.h | 27 +++++++++++++++++++++++++++
 mm/list_lru.c            | 39 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index 134cb3e5652a..a450fffe1550 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -81,6 +81,33 @@ static inline int list_lru_init_memcg_key(struct list_lru *lru, struct shrinker
 
 int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
 			 gfp_t gfp);
+
+#ifdef CONFIG_MEMCG
+/**
+ * folio_memcg_list_lru_alloc - allocate list_lru heads for shrinkable folio
+ * @folio: the newly allocated & charged folio
+ * @lru: the list_lru this might be queued on
+ * @gfp: gfp mask
+ *
+ * Allocate list_lru heads (per-memcg, per-node) needed to queue this
+ * particular folio down the line.
+ *
+ * This does memcg_list_lru_alloc(), but on the memcg that @folio is
+ * associated with. Handles folio_memcg() access rules in the fast
+ * path (list_lru heads allocated) and the allocation slowpath.
+ *
+ * Returns 0 on success, a negative error value otherwise.
+ */
+int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
+			       gfp_t gfp);
+#else
+static inline int folio_memcg_list_lru_alloc(struct folio *folio,
+					     struct list_lru *lru, gfp_t gfp)
+{
+	return 0;
+}
+#endif
+
 void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent);
 
 /**
diff --git a/mm/list_lru.c b/mm/list_lru.c
index 402bb028114d..41a811966063 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -568,17 +568,14 @@ static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
 	return idx < 0 || xa_load(&lru->xa, idx);
 }
 
-int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
-			 gfp_t gfp)
+static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
+				  struct list_lru *lru, gfp_t gfp)
 {
 	unsigned long flags;
 	struct list_lru_memcg *mlru = NULL;
 	struct mem_cgroup *pos, *parent;
 	XA_STATE(xas, &lru->xa, 0);
 
-	if (!list_lru_memcg_aware(lru) || memcg_list_lru_allocated(memcg, lru))
-		return 0;
-
 	gfp &= GFP_RECLAIM_MASK;
 	/*
 	 * Because the list_lru can be reparented to the parent cgroup's
@@ -619,6 +616,38 @@ int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
 
 	return xas_error(&xas);
 }
+
+int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
+			 gfp_t gfp)
+{
+	if (!list_lru_memcg_aware(lru) || memcg_list_lru_allocated(memcg, lru))
+		return 0;
+	return __memcg_list_lru_alloc(memcg, lru, gfp);
+}
+
+int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
+			       gfp_t gfp)
+{
+	struct mem_cgroup *memcg;
+	int res;
+
+	if (!list_lru_memcg_aware(lru))
+		return 0;
+
+	/* Fast path when list_lru heads already exist */
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	res = memcg_list_lru_allocated(memcg, lru);
+	rcu_read_unlock();
+	if (likely(res))
+		return 0;
+
+	/* Allocation may block, pin the memcg */
+	memcg = get_mem_cgroup_from_folio(folio);
+	res = __memcg_list_lru_alloc(memcg, lru, gfp);
+	mem_cgroup_put(memcg);
+	return res;
+}
 #else
 static inline void memcg_init_list_lru(struct list_lru *lru, bool memcg_aware)
 {
-- 
2.54.0


