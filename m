Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12017C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A9A36B00A5; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10D166B00A7; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEF3F6B00A6; Tue,  7 Jul 2026 02:40:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A45836B00A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:40:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1EED01402DF
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:26 +0000 (UTC)
X-FDA: 84961031652.20.103AE77
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf11.hostedemail.com (Postfix) with ESMTP id B6A1640006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u0y+Ho83lWhjY7imeTQ8Q4fyMnkTkspsw+CHMLSZIHc=;
	b=RuXuy+lG4pV8MMKaUk3mQKJvn4P+bHT7nSl10xJYbZgVZyN2Q3XO8uNF6ZUF1Rvl9eqD+7
	UlASBoeo87oDJpG1OdfS0FA97C612uaD4fQhFV+aW6nKYgA4tBMsivmuv0O3OYHXBWtM7u
	nNa9YTjIcQGLk1cSwvgzK2TfnBCesxo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406424;
	b=Bv1PD15aiPmwUb+EjaxvgqoANcDyHCorbPFUuG4O1WNZ4CVDVzyMND9v8k6iiYLrdfwsW0
	/8CjKI9Q+HWyzbGYCTc3yebr/mP6SCROsr6jJgKHYFvv80vB+9R9IQ7eome4ypBq4fIuXq
	oMbot3gP4wRysD74wxIIj2rxL0HaNTE=
Received: from TW001.hihonor.com (unknown [10.77.229.151])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4gvWnJ5jTJzYmWKW;
	Tue,  7 Jul 2026 14:40:20 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW001.hihonor.com
 (10.77.229.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Tue, 7 Jul
 2026 14:40:20 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 14:40:20 +0800
From: tao <tao.wangtao@honor.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <willy@infradead.org>, <sj@kernel.org>, <kees@kernel.org>,
	<luizcap@redhat.com>, <zhangjiao2@cmss.chinamobile.com>, <kas@kernel.org>,
	<ljs@kernel.org>
CC: <hpa@zytor.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <jack@suse.cz>,
	<riel@surriel.com>, <harry@kernel.org>, <jannh@google.com>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <muchun.song@linux.dev>,
	<baoquan.he@linux.dev>, <nao.horiguchi@gmail.com>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<pfalcato@suse.de>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, <damon@lists.linux.dev>, <shakeel.butt@linux.dev>,
	<ryncsn@gmail.com>, <jparsana@google.com>, <dvander@google.com>,
	<zhangji1@honor.com>, <wangzicheng@honor.com>, tao <tao.wangtao@honor.com>
Subject: [RFC PATCH v2 11/13] mm: optimize rmap for ANON_VMA_FRACTAL with PVL
Date: Tue, 7 Jul 2026 14:33:06 +0800
Message-ID: <20260707063308.29176-12-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260707063308.29176-1-tao.wangtao@honor.com>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW002-1.hihonor.com (10.72.0.137) To TA003.hihonor.com
 (10.72.0.43)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B6A1640006
X-Stat-Signature: zsmm7yzk1wpdij146jbe3qhc6q6tnxit
X-HE-Tag: 1783406423-671290
X-HE-Meta: U2FsdGVkX1+Q5z86EW9JgJUd/DIlrPrnhR25P5lLbmIDx9SKapIEyMECWpu2aLRmkpDXAie9eysv1+k7PT66aFYT9H+26OTIrBxq5o91lgrQ1Z0BlqskURRp34GyJS4rwQpP0c8/w2f07ALQS5OVNWhYpIObKIngn+5AczujVQaiDdS8ZLllHijiphjEbgiiF4L2Y0XlYv2cBjUeco3pIYavLl78Z29Ay7mjtzy7XA3HZTF1UB2F0N2mXOlvhDIlkkzV4LqfCTAPx6gpfuKK+/XQYFXFmJVrbheOfU3+wsZ9uzhuzmMks/T8T/W6q45fuFoNoJgWV5Fl1A90H6ENkBbaaASYi0eekXNyEHWf2EFoF+nztsgiiJUD7DRwUZMFZnPz5+DWfuOnlOqpTaDf/5qPBEOa6+0IsZDQ/0ivadjORVK+XxTOX1opCn2PUeRPfMrTkrpPWtzMppddmpYHP5PyCTDGR+NlbdsUr/4e/kIV5SCaz4lnoLBgMjz7Mm7o8Qd0vDsDLcxLey7dT8Ktv2cQJrP/v3WZaWXWkgexWfi20iNp+41N7xNH4SAExiM4ZVRT7jLlABA/G26Rim2MQKL4/88Y21EePuHz/qbsKi/7FlYDw53cJ5dRhqhC7va9EgYxpSu0pGwr5Ui0kIoxObcl2JE2rZi3v/06pFLa2ggRWT+2EohR4yt4rfoOQyCWKUyWBQaQy+03FuNV6f3ctbjJcefCbsr7m9QhQ6Rej/tbt/xmitfJEitXRDiPcaC0yW18CJvYG+dORrzZ6iiz1/djSr2C9U0deldIqROrQVJmu3hG7uW0NOaND1O3FJp3QQHjEC1O+GdageMbk0ZRCxJeqGhlCcfkSzAWBZ08Qwn1Qb7YJPa4T3mvLALEbT58GVrLnoTtJSvU6Qzm4E9Rqs+5ofJdUOo+UrgZlcAyWiFfV2M+UenALEAIZhHQ84n8/h0Z36+fN6/3+ON/OPc
 os0TaCyn
 pJ8mxfywZylc6jscHB4fZdX+0hX+jLEwF3BdyOrgr3X17//TGxd86Pe8ypvZGMwaT3mk1F9YAWCYgA5ThvB93qsqTYmDnUU9teZTuIvrmEJ0KCWGWorZjBg31s8Lu1sRoIARX6A/ujyKyCO9vi5hnPalEjWlEa7IhWKD9jQbkVp4ukSY9vcyhx7eKNnXO2/fUEjIavTeMp+W3w8OpFjROf4zYbeevPC4okQxWMZebnAJ6n5TQR35C5tJl6oIR4e0Mpo/NDtB5x6AXcbl1k1AxW1sisU+1hDtxjxM9hM73bKyiO71W7QcEn8KGdFnkN4zMyUgTHSY3JymamqfLzotGPZVza9+RUFw7gBuwQk0rJvfhJGmUe9mZZQUu8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Leaf anon_nodes have no children, and a given address can belong to at
most one VMA. In this case, PVL can protect the rmap.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 mm/internal.h | 22 ++++++++++++++++++
 mm/rmap.c     | 64 ++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 83 insertions(+), 3 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 205f1b5226aa..f8dd2120b780 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -354,6 +354,23 @@ int anon_node_trylock_rmap(struct anon_node *anon_nod);
 void anon_node_lock_rmap(struct anon_node *anon_nod);
 void anon_node_unlock_rmap(struct anon_node *anon_nod);
 
+#define ANON_RMAP_LEAF_VMA	1
+#define ANON_RMAP_FLAGS 	(ANON_RMAP_LEAF_VMA)
+
+static inline bool anon_rmap_is_leaf_vma(void *anon_rmap)
+{
+#ifdef CONFIG_PER_VMA_LOCK
+	return ((unsigned long)anon_rmap & ANON_RMAP_FLAGS) == ANON_RMAP_LEAF_VMA;
+#else
+	return false;
+#endif
+}
+
+static inline struct vm_area_struct *anon_rmap_to_leaf_vma(void *anon_rmap)
+{
+	return (void *)((unsigned long)anon_rmap & ~ANON_RMAP_FLAGS);
+}
+
 #define ANON_RMAP_FOREACH_VMA(anon_vma, addr, start, last, rmap_proc_vma) \
 do { \
 	struct vm_area_struct *vma = NULL; /* must be named vma */ \
@@ -362,6 +379,11 @@ do { \
 	unsigned long _pgoff = (start); \
 	unsigned long _nr = 0, _total = 1; \
 	\
+	if (anon_rmap_is_leaf_vma(_anon_nod)) { \
+		vma = anon_rmap_to_leaf_vma(_anon_nod); \
+		(rmap_proc_vma); \
+		break; \
+	} \
 	while (_nod) { \
 		vma = anon_node_lookup_vma(_nod, (addr), _pgoff); \
 		if (vma) \
diff --git a/mm/rmap.c b/mm/rmap.c
index 11239838b722..d1099a2fef0a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -572,6 +572,8 @@ void __put_anon_vma(struct anon_vma *anon_vma)
 
 static struct kmem_cache *anon_node_cachep;
 
+
+
 static inline struct rw_semaphore *anon_node_rmap_sem(struct anon_node *node)
 {
 	return &node->root->rwsem;
@@ -1035,9 +1037,48 @@ void anon_node_lock_rmap(struct anon_node *anon_nod)
 
 void anon_node_unlock_rmap(struct anon_node *anon_nod)
 {
+#ifdef CONFIG_PER_VMA_LOCK
+	/* Corresponds to folio_lock_anon_vma_read(). */
+	if (anon_rmap_is_leaf_vma(anon_nod)) {
+		vma_refcount_put(anon_rmap_to_leaf_vma(anon_nod));
+		return;
+	}
+#endif
+
 	up_read(anon_node_rmap_sem(anon_nod));
 }
 
+static struct vm_area_struct *trylock_leaf_vma_rmap(
+		struct anon_node *anon_nod, const struct folio *folio,
+		struct mm_struct **other_mm)
+{
+	unsigned long pgoff_start = folio_pgoff(folio);
+	unsigned long pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
+	unsigned long addr = anon_node_rmap_address(anon_nod, pgoff_start);
+	struct mm_struct *mm = anon_nod->mm;
+	struct vm_area_struct *vma;
+	int oldcnt;
+
+	if (anon_nod->nr_children)
+		return NULL;
+
+	if (!addr || !mm || !mmget_not_zero(mm))
+		return NULL;
+
+	vma = vma_lookup(mm, addr);
+	mmput_async(mm);
+	if (!vma || vma_last_pgoff(vma) < pgoff_end)
+		return NULL;
+
+	if (!__refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, &oldcnt,
+						     VM_REFCNT_LIMIT)) {
+		return NULL;
+	}
+
+	*other_mm = (vma->vm_mm == mm) ? NULL : vma->vm_mm;
+	return vma;
+}
+
 #endif
 
 /*
@@ -1117,6 +1158,8 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 {
 	struct anon_vma *anon_vma = NULL;
 	struct anon_vma *root_anon_vma;
+	struct vm_area_struct *leaf_vma = NULL;
+	struct mm_struct *other_mm = NULL;
 	unsigned long anon_mapping;
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -1130,6 +1173,15 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 
 	anon_vma = (struct anon_vma *) (anon_mapping - FOLIO_MAPPING_ANON);
 	root_anon_vma = READ_ONCE(anon_vma->root);
+#if defined(CONFIG_PER_VMA_LOCK) && defined(CONFIG_ANON_VMA_FRACTAL)
+	leaf_vma = trylock_leaf_vma_rmap(anon_vma, folio, &other_mm);
+	if (leaf_vma && !other_mm && folio_mapped(folio)) {
+		rcu_read_unlock();
+		return (void *)leaf_vma + ANON_RMAP_LEAF_VMA;
+	}
+	if (unlikely(other_mm))
+		mmgrab(other_mm); /* put vma after unlock. */
+#endif
 	if (down_read_trylock(&root_anon_vma->rwsem)) {
 		/*
 		 * If the folio is still mapped, then this anon_vma is still
@@ -1156,9 +1208,8 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 	}
 
 	if (!folio_mapped(folio)) {
-		rcu_read_unlock();
 		put_anon_vma(anon_vma);
-		return NULL;
+		goto out;
 	}
 
 	/* we pinned the anon_vma, its safe to sleep */
@@ -1176,10 +1227,17 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 		anon_vma = NULL;
 	}
 
-	return anon_vma;
+	goto out_unlocked;
 
 out:
 	rcu_read_unlock();
+out_unlocked:
+#ifdef CONFIG_PER_VMA_LOCK
+	if (leaf_vma)
+		vma_refcount_put(leaf_vma);
+#endif
+	if (other_mm)
+		mmdrop(other_mm);
 	return anon_vma;
 }
 
-- 
2.17.1


