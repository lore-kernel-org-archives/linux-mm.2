Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C5AFCD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 657BB6B00CE; Tue,  5 May 2026 11:39:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E09A6B00CF; Tue,  5 May 2026 11:39:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45A546B00D0; Tue,  5 May 2026 11:39:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9006B00CE
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:39:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E55A9120539
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:48 +0000 (UTC)
X-FDA: 84733776456.23.3BE58BD
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0334640007
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pRWMLKtS;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/yyOr/4pj99tbSJw4a+KNInaif0dFyRreHuOMw4Fwo=;
	b=aDSXBtgRNxomKAt+72cy0tMULpHha7roavoOsNqkwlzWSXovDS79Skqiod6J+MlDsC7+r/
	fAO87ufVAz+qm5j/U1pw77hBJMqSQ6y6bgOMiJteROAYrRmZH/N+yz4Kvpycnmh8zg4xRe
	LcwSIwUTu7m6SAZ3GP09wWPhknrwzvg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pRWMLKtS;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777995587; a=rsa-sha256;
	cv=none;
	b=fSbM/tR/oXuEub+y3NrQ4vS2OxL+ZxkLByRvNDyX0tKqA7sIMfcYhSu1ylp50B8kydEpma
	QOLk+7tQBy84AR1/lCvvrlPbUINQTHKY3KrpXWal7/PgItaWj9JVoA4eB6SEFrm7POW9vL
	ZhZ6WuV9LvI00N/clSymsgCuf9NmK1s=
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-42fc6923f38so3697233fac.1
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777995586; x=1778600386; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5/yyOr/4pj99tbSJw4a+KNInaif0dFyRreHuOMw4Fwo=;
        b=pRWMLKtSML+ZEedysJ1EPkrS3Y5Pho4CRbSrKGHDEyQ5XWTWWNmjX0pCe5wt+DPTXA
         /8nIwSENYAgSlT2uez9iVlKMj+J4pFPJkIdqpu2CCLF4yQztWWtmLMdWRKuwUyA03yXu
         fWP+Ix9A71PKjw3ljz1d+KB2xwoRJxaUNP7VgqPaMUeM+JcNvWLWLfQyNiSN+4TUEQ+H
         xUQ+jEBGnom6SNbp+Yb63R2XUqIseP4vKEfq2NjfhEpB09UD33o7J8T1yajBb7Ve8jyF
         J0pFDNitI2acJkvW2LBZpycja15QsrQWMYndjcdvFgYKyI+/hEoQ65q5a8H0DXsysSpV
         +axg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995586; x=1778600386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5/yyOr/4pj99tbSJw4a+KNInaif0dFyRreHuOMw4Fwo=;
        b=IImF/J8fqyECe4GTHXcpIRI0abnmptoZoUbgozslc1G+Hv28n6ubyD40ffe3p34h3K
         YTetqWvYqbNPxiO2FTn9OxZCDCgntfixxCYEjHVPpDdgagkaS2SmMEvHO1FMQRUhZTzt
         pj8r0znxt5c+fYk97PkXkuxLGZb+DGekS4iqJbZ1ia/6Ut0Iqd9BKJwalXGhPOXmOxPK
         rGCRpovQYUDpwaK3DIAEg4+y3CezzLNnhAcyTH6yKhmCzBUeCU6vzdDiqzNnagWxVXJB
         uur6aLHixS9m6IeWzBjaRH5IgCYtq43bFy20q0U5flhsW50oK+oua0+Y7tSRuOBalv+V
         Zeiw==
X-Forwarded-Encrypted: i=1; AFNElJ8QDA6QnnHZTYsMvXBEsOCADCQ0dvgi0/zCQ36xy2wu1hPyHqq5WL76UkJvx46AnnYDCk/+2Jz4Aw==@kvack.org
X-Gm-Message-State: AOJu0YxnJ94RqDfmG4KXiq85IIIqOhuhShW2mllAOYYUdRp+g0Pk9DbJ
	RBp7GD8GcDcaf/bVc5Kc39jNDiY7Usy0fIuD+UYxV8BS89Z1/WHJk1mI
X-Gm-Gg: AeBDiesXfPtz83s3u414AVIbQN4zTAgbOFeXUIXVGUvOELtliIYsJ7gKdHPOUakC6bI
	QnledGRyx6PYK1aaDhjOPIJ/egGCwJEQuRM8lwv1MtVwhw8M2w5SgZYJGzIE7YUJyb5r3vYt3Mz
	Y8LTzl07JJzwp48/iqF1k0DkswX/V59py4OjNKhyvuYCytIh4VLHP06ddEAVbTDr/p9qjMYlTTM
	pLusxhGmC0XgWeVZlzkS/e0h0Gub0bCF8wDcgTo5pZ36WXDzgdzXowFTarrqhMKD/wyX67y/QGG
	Wxc5xUhxmR/Cr+HE53rm2lcFhU4fKY6yu9GSqrcG+sLjfd7CKAUkGHGOU6U3Xm8uXsddjlzURQZ
	PWuk2ng7EO3V1gSSlENOHgi594rrhxaAZbwC67WBBdAVmNMLot6UEWWMbGnV3lGHkpEUMXQJM5j
	+qCQOJfvXWbj8xPJdORMvd/U7t9IfoPIg/OQe0sDOJvn+YRCr6JYxQ
X-Received: by 2002:a05:6808:e64b:b0:467:da0d:537e with SMTP id 5614622812f47-47d260dcc6cmr1641681b6e.7.1777995585821;
        Tue, 05 May 2026 08:39:45 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c763b33c1sm8866816b6e.1.2026.05.05.08.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:39:44 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com,
	haowenchao22@gmail.com
Subject: [PATCH v6 21/22] vswap: batch contiguous vswap free calls
Date: Tue,  5 May 2026 08:38:50 -0700
Message-ID: <20260505153854.1612033-22-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260505153854.1612033-1-nphamcs@gmail.com>
References: <20260505153854.1612033-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0334640007
X-Rspamd-Server: rspam06
X-Stat-Signature: tf3fmqbkq4cs4iu1ozcpd8etc4wqyyx9
X-HE-Tag: 1777995586-975075
X-HE-Meta: U2FsdGVkX19HpnfGzv94efpjsSVFEppz9F5Xy/KoyZAoMmpn4xhN55/KpzcTJxF/UbAHMg3oKcaSbrjr/KDYnbcCHBnC0hlI+9q1p/A4Wj1Zbdg9Dy/ToCTMU9svgGZn4R105AkC5l9zRyq/W8V1/jE5QGTCMT3HIkKtOv6WYe0MS5LE0pfk0X8TsBvD45PpIXRvwyuLvEIzTL/n6IpFd1WUMFIDQ0TuC1jYcnih69fypIb01akCiHWUIRI+CwLisLKPXv7bgextL98VboCSg8gUyjaOXEPW1kjJJGqL5xQE7cDorl8U/VDV8EEds7n8Wf+M0lymOl72ZxFFFDjE1I6oGb282ydCSQHlVyHN/fWXy0NRDXvEaqXYkXkhNp7ZbT7rvf2pqsugiMWoTwwRNQqx0Rwm8n5rdHazDFohLV8pPdV7j9c6lxT8dfIwcoJ0hSmAnuJCKKJTstuAjaonZTP+tJTfIfdlrnflGFhQuw6H0yd/Sj2AYaKdNwBuny8wqE+SnNjYXUvnbcFkyNAfRsa9u0xfXsNS+2kF8KQg/PEGzs/Pac0/wq+mCwgGrA8JnDwrNWNdUimLDTTeWfDVH1vgpa3gfb2hNkF4ZcerQ5xYoklMhq9sU99cBQFRYYEwj2TlYqA8klTK+5QgFcSE3hCnNWrKHEbHbI8Uy90x3x0z27sfT9SQTPeB2/ya7bH+8kqWSMLMz4RxJHvDeJ4s9OHdq62rp7thLR8EOjy0+9+ojPmaHGbd/V9PDXYkNk1i9mHapd1h0S/7ymTb7ftmyEuKVR3RtOBvqXzo/2TX+GdduZgQhdCmaH5TST4qezKWvW/jrlkP+By70kfC9+YjfOxbCYJKSHJlzWsV6pwJf+1XiFwUR0Au/7W7A9cZfQiNjPjrJau+oQS17n4MalzTEJjevEtAR8Cs09wPw2M3nN7BNtt9sAZWrTpz4L9NGeQ7Gd1MKQTDufxR5ayMXFV
 Kcy5lFtL
 5ZYmmJCLpUFfELWQKZB2Lc9+O6KXEGrvJxDTotb0Y0JsQaL2hzZ9ELOcXTmOF7ksRv4ooBxg3FllL8ruU+pvhiui0plzAAbvPciWt+A763sLeRfhw71eM4OSpmA3TyEOi0Qa0TnrRD4TbozUnMQnMas/u6lZYMclpRTdJ7GGQnQh1GOps1uUxqeZEOXHTMK6rTHnL1mBn6jn36vmI1NWEHBEt+2exr/NnSLNuyk14HdblXM3yLyCp31TdX35iKV1ddlS9oePR6av65p714MuPSUT1vVMEIrTLCuJSUXz4/eMKT7ux10hwYqMTalnwDYRsaWPFLjoJveYQ0YpYgIju+Ljcq7D/Zab3AyPNTlE/+b4+x1yBs+lXYWxvOklBdbJgbZVfIHdJ6ZzlesXVqbI6EJu4todPLF1ZS/YSTGDuI6QZS8Lyc0y8HIM9xrvvarxQCwqKtjsDQOwBjVWxEANFTh6SUPU52VpGAAcS1qftXK9JHcJr5NAlWEkGkEq64sKoyfg2qYWmhmubfMOYSv9dTkKgAs/Tryb0mM01
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In vswap_free(), we release and reacquire the cluster lock for every
single entry, even for non-disk-swap backends where the lock drop is
unnecessary. Batch consecutive free operations to avoid this overhead.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/vswap.c | 97 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 61 insertions(+), 36 deletions(-)

diff --git a/mm/vswap.c b/mm/vswap.c
index 3f86bbb3a5ea..f07e6d9ec1df 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -529,18 +529,18 @@ static void vswap_cluster_free(struct vswap_cluster *cluster)
 	call_rcu(&cluster->rcu, vswap_cluster_free_rcu);
 }
 
-static inline void release_vswap_slot(struct vswap_cluster *cluster,
-		unsigned long index)
+static inline void release_vswap_slot_nr(struct vswap_cluster *cluster,
+		unsigned long index, int nr)
 {
 	unsigned long slot_index = VSWAP_IDX_WITHIN_CLUSTER_VAL(index);
 
 	lockdep_assert_held(&cluster->lock);
-	cluster->count--;
+	cluster->count -= nr;
 
-	bitmap_clear(cluster->bitmap, slot_index, 1);
+	bitmap_clear(cluster->bitmap, slot_index, nr);
 
 	/* we only free uncached empty clusters */
-	if (refcount_dec_and_test(&cluster->refcnt))
+	if (refcount_sub_and_test(nr, &cluster->refcnt))
 		vswap_cluster_free(cluster);
 	else if (cluster->full && cluster_is_alloc_candidate(cluster)) {
 		cluster->full = false;
@@ -553,7 +553,7 @@ static inline void release_vswap_slot(struct vswap_cluster *cluster,
 		}
 	}
 
-	atomic_dec(&vswap_used);
+	atomic_sub(nr, &vswap_used);
 }
 
 /*
@@ -585,7 +585,7 @@ static unsigned short swp_desc_memcgid(struct swp_desc *desc);
  *
  * 1. Callers ensure no concurrent modification of the swap entry's internal
  *    state can occur. This is guaranteed by one of the following:
- *    - For vswap_free() callers: the swap entry's refcnt (swap count and
+ *    - For vswap_free_nr() callers: the swap entry's refcnt (swap count and
  *      swapcache pin) is down to 0.
  *    - For vswap_store_folio(), swap_zeromap_folio_set(), and zswap_entry_store()
  *      callers: the folio is locked and in the swap cache.
@@ -706,26 +706,17 @@ static void __vswap_swap_cgroup_clear(struct vswap_cluster *cluster,
 
 /*
  * Entered with the cluster locked. The cluster lock is held throughout.
- *
- * This is safe, because:
- *
- * 1. The swap entry to be freed has refcnt (swap count and swapcache pin)
- *    down to 0, so no one can change its internal state.
- *
- * 2. The swap entry to be freed still holds a refcnt to the cluster, keeping
- *    the cluster itself valid.
- *
- * 3. swap_slot_free_nr() takes the physical swap cluster lock (ci->lock),
- *    but the only vswap function called under ci->lock is vswap_rmap_set(),
- *    which uses atomic ops and does not take cluster->lock. So there is no
- *    ABBA deadlock risk.
  */
-static void vswap_free(struct vswap_cluster *cluster, struct swp_desc *desc,
-	swp_entry_t entry)
+static void vswap_free_nr(struct vswap_cluster *cluster, swp_entry_t entry,
+		int nr)
 {
-	unsigned short id = swp_desc_memcgid(desc);
+	struct swp_desc *desc = __vswap_iter(cluster, entry.val);
+	unsigned short id;
 	struct mem_cgroup *memcg;
 
+	VM_WARN_ON(!desc);
+	id = swp_desc_memcgid(desc);
+
 	/*
 	 * The swap_cgroup id reference taken at swapout time pins this
 	 * memcg until swap_cgroup_clear() runs below, so we can resolve
@@ -733,11 +724,11 @@ static void vswap_free(struct vswap_cluster *cluster, struct swp_desc *desc,
 	 */
 	memcg = id ? mem_cgroup_from_id(id) : NULL;
 
-	release_backing(cluster, entry, 1, memcg);
-	__vswap_swap_cgroup_clear(cluster, entry, 1, memcg);
+	release_backing(cluster, entry, nr, memcg);
+	__vswap_swap_cgroup_clear(cluster, entry, nr, memcg);
 
-	/* erase forward mapping and release the virtual slot for reallocation */
-	release_vswap_slot(cluster, entry.val);
+	/* erase forward mapping and release the virtual slots for reallocation */
+	release_vswap_slot_nr(cluster, entry.val, nr);
 }
 
 
@@ -908,10 +899,18 @@ static bool vswap_free_nr_any_cache_only(swp_entry_t entry, int nr)
 	struct vswap_cluster *cluster = NULL;
 	struct swp_desc *desc;
 	bool ret = false;
-	int i;
+	swp_entry_t free_start;
+	unsigned short batch_memcgid = 0;
+	int i, free_nr = 0;
 
+	free_start.val = 0;
 	rcu_read_lock();
 	for (i = 0; i < nr; i++) {
+		/* flush pending free batch at cluster boundary */
+		if (free_nr && !VSWAP_IDX_WITHIN_CLUSTER_VAL(entry.val)) {
+			vswap_free_nr(cluster, free_start, free_nr);
+			free_nr = 0;
+		}
 		desc = vswap_iter(&cluster, entry.val);
 		VM_WARN_ON(!desc);
 		ret |= (desc->swap_count == 1 && desc->in_swapcache);
@@ -919,18 +918,34 @@ static bool vswap_free_nr_any_cache_only(swp_entry_t entry, int nr)
 		if (!desc->swap_count && !desc->in_swapcache) {
 			if (xa_is_value(desc->shadow))
 				desc->shadow = NULL;
-			vswap_free(cluster, desc, entry);
-		} else if (!desc->swap_count && desc->in_swapcache &&
-			   desc->type == VSWAP_SWAPFILE) {
+			/* flush at cgroup boundary */
+			if (free_nr &&
+			    swp_desc_memcgid(desc) != batch_memcgid) {
+				vswap_free_nr(cluster, free_start, free_nr);
+				free_nr = 0;
+			}
+			if (!free_nr)
+				batch_memcgid = swp_desc_memcgid(desc);
+			if (!free_nr++)
+				free_start = entry;
+		} else {
+			if (free_nr) {
+				vswap_free_nr(cluster, free_start, free_nr);
+				free_nr = 0;
+			}
 			/*
 			 * swap_count just dropped to 0, but still in swap
 			 * cache. If backed by a physical swap slot, mark it
 			 * so the physical swap allocator can check cheaply.
 			 */
-			swap_rmap_mark_cache_only(desc->slot);
+			if (!desc->swap_count && desc->in_swapcache &&
+			    desc->type == VSWAP_SWAPFILE)
+				swap_rmap_mark_cache_only(desc->slot);
 		}
 		entry.val++;
 	}
+	if (free_nr)
+		vswap_free_nr(cluster, free_start, free_nr);
 	if (cluster)
 		spin_unlock(&cluster->lock);
 	rcu_read_unlock();
@@ -1032,8 +1047,9 @@ bool folio_free_swap(struct folio *folio)
 		VM_WARN_ON_FOLIO(!desc || desc->swap_cache != folio, folio);
 		desc->swap_cache = NULL;
 		desc->in_swapcache = false;
-		vswap_free(cluster, desc, (swp_entry_t){ entry.val + i });
 	}
+
+	vswap_free_nr(cluster, entry, nr);
 	spin_unlock_irq(&cluster->lock);
 	rcu_read_unlock();
 
@@ -1095,14 +1111,23 @@ static void __swapcache_clear(struct vswap_cluster *cluster,
 			      swp_entry_t entry, int nr)
 {
 	struct swp_desc *desc;
-	int i;
+	swp_entry_t free_start;
+	int i, free_nr = 0;
 
+	free_start = entry;
 	for (i = 0; i < nr; i++) {
 		desc = __vswap_iter(cluster, entry.val + i);
 		desc->in_swapcache = false;
-		if (!desc->swap_count)
-			vswap_free(cluster, desc, (swp_entry_t){ entry.val + i });
+		if (!desc->swap_count) {
+			if (!free_nr++)
+				free_start.val = entry.val + i;
+		} else if (free_nr) {
+			vswap_free_nr(cluster, free_start, free_nr);
+			free_nr = 0;
+		}
 	}
+	if (free_nr)
+		vswap_free_nr(cluster, free_start, free_nr);
 }
 
 void swapcache_clear(swp_entry_t entry, int nr)
-- 
2.52.0


