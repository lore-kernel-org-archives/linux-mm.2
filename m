Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7CB9CAC5B5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 11:17:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302808E0006; Sun, 28 Sep 2025 07:17:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B2AC8E0001; Sun, 28 Sep 2025 07:17:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17B058E0006; Sun, 28 Sep 2025 07:17:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 01A638E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 07:17:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 91FFB87DB8
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 11:17:47 +0000 (UTC)
X-FDA: 83938408974.06.7B9E11B
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id E70781C0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 11:17:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=C9LXYzCE;
	spf=pass (imf21.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759058266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kqIkKVMb0D1T6X1uViaX+LF5tLEzwLH/sPWmDCgIpN4=;
	b=7mHT79ARxOFL3AZTGEjDmnLSJHrpWWLyeyoQWLHlCvy7CQm0awnf6aVNyg01klZvmK4DOU
	fEfjKGN3TL84MW+xsfJ1rUvI/Po7Y+5J6W1mFJGqOcAPFi1iWweOW5GQ/5cMaL/LTjb2vs
	22/UpAa/YBeAYoHM7I/N3rgMjCmwOnE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=C9LXYzCE;
	spf=pass (imf21.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759058266; a=rsa-sha256;
	cv=none;
	b=fQgNbUV49nSD3U0kVMviUj8zpd+yi0KqUYXxN516KpMx6O1QuG0bqcigxRZXRUuBQR/pCC
	/2o7VX2GQ4teItcHOlTCzq+MuRedOqregAltHJ4GffsnnKMPZqN+GjpGkbPMzZlMwLU/LN
	f6GlcQDcUkgeBVkrjszLBa3mGj8UZdM=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-78104c8cbb4so3762303b3a.0
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 04:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1759058265; x=1759663065; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kqIkKVMb0D1T6X1uViaX+LF5tLEzwLH/sPWmDCgIpN4=;
        b=C9LXYzCE/XbtGzgcsHEyydDL8cixKDkTXxLVKYyqT91jlHAg+160oQcmGJPxeNf8N5
         PclBujx+DVHrjPXQrMUNBxmQ/CdlhfEAp/anwk9xwf7ZRhn17sOHHVehl7Nenjud1YzH
         6+lqCsn9eazc/d1XA9teA8ZkduQROniqb6Na5AVVwPFgg0iwDO3S69PMf69EFq+HgB6O
         DOtW9pB6GOdVjVDkO7oCBZHVLBi3FxQg+fBn3bv781kEtM3k13O19jl0b8sPVjmbLAAe
         DhQKs7+or/Sn9BfA5AZXXR6A73IEt6uAqIW8LuEd50SY8Ma4QNQfdpF5Q1ZRw7pC+ldq
         7IVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759058265; x=1759663065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kqIkKVMb0D1T6X1uViaX+LF5tLEzwLH/sPWmDCgIpN4=;
        b=tF1i+30jbvPJjjx6D5CoqAjbkt2TzLpn/smnWRch53nvhHgoKZCvC2YnQ+QcMQSACN
         B1aXCt8ssq81eIUI4WOn2eD4/4LtXh+CDkD7sujt6E6atLEp+ApDAaOwfQzkzto/Gxoe
         wkn5/rvQfeDIIQX4ru/T9Q0FLmw8m0cpNvN3wiClXHJZ9cKUwouYqTett9ejYNhPL/1F
         xXCtKeFT4SelQK3Ok804gejk0tcBqosmbLd2coS07RhHr2KPsy5ZmSrDmaY0Kl2OfFfn
         FGfyh1xYqlfph04cBu/3yu2rzklWq/n5XI7ogDt1KYhiZu5HrUoDJTEPWhAS9OA/0xns
         5Epw==
X-Gm-Message-State: AOJu0YxccoGTjIb0jmVpKV1gfysuznLDO1U00++kCaPYhTVg6pN9YbV9
	ZhHjhTFa/eKwDRlSynwweLpTCudaE9yh4lM0lJ6eQSUBehEHsVDvnjcn8DEf13dHmsM=
X-Gm-Gg: ASbGnctVZEkwzSM5izxNoMfT+hsPHafqiwttn2fNod6BbIgFa96k1oy3wlc3ZTQRWA0
	n4BrmO3rjOvPfQb2kuwsw/Z+aj88D8K1E/W+aknz5wvaJ5eLj2ANSeJtCv3kdt8dFQ/yJCzyrbZ
	Bxt3ZKgZMQO38Y+OfgLze8emcoq/W9u3XvA98MRpqNpSf7eqtnELv25xO5q2umCJaYBs5t/lheA
	gM9LZ9BBty0eJiEVbwXIK2tYQpIAvi2GIy+SoMnr3SgwSBo0+uR+wDk0vb5wyZ3V/yQaz67yyO5
	qgYKdXqEznwleuVEgM7SjR4FnJ9orYny08FTEk0Ja6P97LCFXUo94Aov/aowcTdeZcjxaOk46gO
	5qaOE8ejRgXROhFlbOYRg7VchDBE+CxsCcLRbhCTokD6MBWNS160BFP0HYLHK/9VbAg==
X-Google-Smtp-Source: AGHT+IFpgKlNfJwp+S3wjiWhEQGfyxqtvOuQ9QjT3paL+rGW25mXbvLbUn9yt5U2oEGJqOcasX6FEg==
X-Received: by 2002:a05:6a20:3d83:b0:2df:8271:f095 with SMTP id adf61e73a8af0-2e7c75000e0mr17723876637.24.1759058264714;
        Sun, 28 Sep 2025 04:17:44 -0700 (PDT)
Received: from G7HT0H2MK4.bytedance.net ([139.177.225.231])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b57c55a2c45sm8687451a12.45.2025.09.28.04.17.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 28 Sep 2025 04:17:44 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 2/4] mm: thp: introduce folio_split_queue_lock and its variants
Date: Sun, 28 Sep 2025 19:17:00 +0800
Message-ID: <f1aa2ffdb10fb8069ad2a7827c0707e83da5bcaf.1759056506.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1759056506.git.zhengqi.arch@bytedance.com>
References: <cover.1759056506.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E70781C0006
X-Stat-Signature: whwss1kj3dengc3xnynezonozzxkhkn7
X-HE-Tag: 1759058265-903605
X-HE-Meta: U2FsdGVkX1+lQhEOVLKi0fEtGtTxeTGhdscLXvzc5xCe9o0l98HOUINvmnhiQu2A74taw4nggx56/KG9Oi4Qq7d6lnjlYlvDEWZEohkBFTtn88mCbAGNLQ6jvJKWxAgrIQd5btCrRROWcmg7JUN3JYegnL5gL0NtuRaJmTw4fGWcf+JXMLUZzvTRWyCXqUfvVpHUWxmanZ6Y7flstODKz3fTvxK9gHnVxkw6vqCJQM6ibchY6wduUHWW1DkvEF5nAjwZPhZEQ4L9VCvi79JZmjKCvuJa8ViDVX8lEaj6h5viZDQmqpk3FzG7eVgTE/RVW9jQCmG7Ep4jBUgQF8ojjzuYpwNzsqm1kF9PJG1zd95U9HF4o+QERK6hXppbdPAU84jBRru6vnP7lOBt08SAFZHAWgseVzM09gWlY0/ilDfOJ01s+7tw5opAKRApU5jWV2xgNuR3a3fzYd3l0pwhKTMcUdYek211sSlN+3O+M65R+pG3lpzL9G4Z9Mwv3OnYQtXLp+t0uS0Hxz42R7audFYQST+5sMRw2gMXdiy2qXzv8L0c4KzsbnGCp0kgWL31VH4/K3x9wAsG7feqKfC+57sAc1SC41dbjrSe2mcd9kYeQGcfTHi0Vv44yBnkwq2mqgYnnS/Ku2qgNkLLW1UTXjfjKD7x3r7+FPyFqmQNYwiVgt1SwbB6FQVtpyE1J1eOoLd+a2wGBICP4nSMQx/3Kv1XqGPMGkZ4oedASvIwD4OOuRcndvS9Z4ZIopl9XLZ9XzTrGVGDxZZ9tyYh8Fgpcwkk59+1NV4S/8FTR4V1OEX7l3Exq3ON3OiM2wrim96d2/8Dm/Wy/NADrfHqK0wWl6aNG8stJfbBOxUJia4+/G+sG6RRFXIKdsOsb3OJZSd9HPi54y4AtV3wMPWoN7pZcdsQf2nLZdZCU3SfFJbghbq+BXxRhRCWxbpIsuRH5N/1ckn8hiat+H4gpWdL6hJ
 V6yv4JYl
 iRPwDc5wONlT41Lvf7hd3JZEPHtBLUGF/MyjYTsinaoaaIPyDPkY9+0llWhS/mn50t7tjpzFatCgr54FD16ieTf3NVErqTYrXv1zppI5CzHcDhAOD1GDV+I5YDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In future memcg removal, the binding between a folio and a memcg may
change, making the split lock within the memcg unstable when held.

A new approach is required to reparent the split queue to its parent. This
patch starts introducing a unified way to acquire the split lock for
future work.

It's a code-only refactoring with no functional changes.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
---
 include/linux/memcontrol.h |  10 ++++
 mm/huge_memory.c           | 104 ++++++++++++++++++++++++++++---------
 2 files changed, 89 insertions(+), 25 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 16fe0306e50ea..99876af13c315 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1662,6 +1662,11 @@ int alloc_shrinker_info(struct mem_cgroup *memcg);
 void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
 void reparent_shrinker_deferred(struct mem_cgroup *memcg);
+
+static inline int shrinker_id(struct shrinker *shrinker)
+{
+	return shrinker->id;
+}
 #else
 #define mem_cgroup_sockets_enabled 0
 
@@ -1693,6 +1698,11 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
 				    int nid, int shrinker_id)
 {
 }
+
+static inline int shrinker_id(struct shrinker *shrinker)
+{
+	return -1;
+}
 #endif
 
 #ifdef CONFIG_MEMCG
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6db24b3a57005..0ac3b97177b7f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1078,26 +1078,83 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
 
 #ifdef CONFIG_MEMCG
 static inline
-struct deferred_split *get_deferred_split_queue(struct folio *folio)
+struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
+					   struct deferred_split *queue)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
-	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
+	if (mem_cgroup_disabled())
+		return NULL;
+	if (&NODE_DATA(folio_nid(folio))->deferred_split_queue == queue)
+		return NULL;
+	return container_of(queue, struct mem_cgroup, deferred_split_queue);
+}
 
-	if (memcg)
-		return &memcg->deferred_split_queue;
-	else
-		return &pgdat->deferred_split_queue;
+static struct deferred_split *folio_split_queue_lock(struct folio *folio)
+{
+	struct mem_cgroup *memcg;
+	struct deferred_split *queue;
+
+	memcg = folio_memcg(folio);
+	queue = memcg ? &memcg->deferred_split_queue :
+			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
+	spin_lock(&queue->split_queue_lock);
+
+	return queue;
+}
+
+static struct deferred_split *
+folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
+{
+	struct mem_cgroup *memcg;
+	struct deferred_split *queue;
+
+	memcg = folio_memcg(folio);
+	queue = memcg ? &memcg->deferred_split_queue :
+			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
+	spin_lock_irqsave(&queue->split_queue_lock, *flags);
+
+	return queue;
 }
 #else
 static inline
-struct deferred_split *get_deferred_split_queue(struct folio *folio)
+struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
+					   struct deferred_split *queue)
+{
+	return NULL;
+}
+
+static struct deferred_split *folio_split_queue_lock(struct folio *folio)
 {
 	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
+	struct deferred_split *queue = &pgdat->deferred_split_queue;
+
+	spin_lock(&queue->split_queue_lock);
 
-	return &pgdat->deferred_split_queue;
+	return queue;
+}
+
+static struct deferred_split *
+folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
+{
+	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
+	struct deferred_split *queue = &pgdat->deferred_split_queue;
+
+	spin_lock_irqsave(&queue->split_queue_lock, *flags);
+
+	return queue;
 }
 #endif
 
+static inline void split_queue_unlock(struct deferred_split *queue)
+{
+	spin_unlock(&queue->split_queue_lock);
+}
+
+static inline void split_queue_unlock_irqrestore(struct deferred_split *queue,
+						 unsigned long flags)
+{
+	spin_unlock_irqrestore(&queue->split_queue_lock, flags);
+}
+
 static inline bool is_transparent_hugepage(const struct folio *folio)
 {
 	if (!folio_test_large(folio))
@@ -3579,7 +3636,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
 		struct list_head *list, bool uniform_split)
 {
-	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
+	struct deferred_split *ds_queue;
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
@@ -3718,7 +3775,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	}
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
-	spin_lock(&ds_queue->split_queue_lock);
+	ds_queue = folio_split_queue_lock(folio);
 	if (folio_ref_freeze(folio, 1 + extra_pins)) {
 		struct swap_cluster_info *ci = NULL;
 		struct lruvec *lruvec;
@@ -3740,7 +3797,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			 */
 			list_del_init(&folio->_deferred_list);
 		}
-		spin_unlock(&ds_queue->split_queue_lock);
+		split_queue_unlock(ds_queue);
 		if (mapping) {
 			int nr = folio_nr_pages(folio);
 
@@ -3835,7 +3892,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		if (ci)
 			swap_cluster_unlock(ci);
 	} else {
-		spin_unlock(&ds_queue->split_queue_lock);
+		split_queue_unlock(ds_queue);
 		ret = -EAGAIN;
 	}
 fail:
@@ -4016,8 +4073,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 	WARN_ON_ONCE(folio_ref_count(folio));
 	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
 
-	ds_queue = get_deferred_split_queue(folio);
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
 	if (!list_empty(&folio->_deferred_list)) {
 		ds_queue->split_queue_len--;
 		if (folio_test_partially_mapped(folio)) {
@@ -4028,7 +4084,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 		list_del_init(&folio->_deferred_list);
 		unqueued = true;
 	}
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+	split_queue_unlock_irqrestore(ds_queue, flags);
 
 	return unqueued;	/* useful for debug warnings */
 }
@@ -4036,10 +4092,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 /* partially_mapped=false won't clear PG_partially_mapped folio flag */
 void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
-	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
-#ifdef CONFIG_MEMCG
-	struct mem_cgroup *memcg = folio_memcg(folio);
-#endif
+	struct deferred_split *ds_queue;
 	unsigned long flags;
 
 	/*
@@ -4062,7 +4115,7 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 	if (folio_test_swapcache(folio))
 		return;
 
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
 	if (partially_mapped) {
 		if (!folio_test_partially_mapped(folio)) {
 			folio_set_partially_mapped(folio);
@@ -4077,15 +4130,16 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
 	}
 	if (list_empty(&folio->_deferred_list)) {
+		struct mem_cgroup *memcg;
+
+		memcg = folio_split_queue_memcg(folio, ds_queue);
 		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
 		ds_queue->split_queue_len++;
-#ifdef CONFIG_MEMCG
 		if (memcg)
 			set_shrinker_bit(memcg, folio_nid(folio),
-					 deferred_split_shrinker->id);
-#endif
+					 shrinker_id(deferred_split_shrinker));
 	}
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+	split_queue_unlock_irqrestore(ds_queue, flags);
 }
 
 static unsigned long deferred_split_count(struct shrinker *shrink,
-- 
2.20.1


