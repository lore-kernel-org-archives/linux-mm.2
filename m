Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 680C2CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 09:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5B6C8E0018; Tue, 23 Sep 2025 05:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0BDD8E0001; Tue, 23 Sep 2025 05:17:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FAEE8E0018; Tue, 23 Sep 2025 05:17:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B7B78E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 05:17:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 19EE016040D
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:17:07 +0000 (UTC)
X-FDA: 83919960894.10.E461A91
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3A0DF40004
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:17:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DQ5jj5lW;
	spf=pass (imf01.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758619025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u6uNBFGFaJI1+zGTy5DFgjysGcp2+im/rBXpMTQQekQ=;
	b=U1NmJDozotsL0TJHN2RrWNW164tkYKejbe1bNEMZiZX0yjJKHtyIwzvSaFNGgdCeq30f4G
	u8o/tVEWxR64SPWKZRY3kvGb+HYClxQVR86fmeFNcntmZTO5YGK/trbimh1NCHhlAVCveJ
	T4A4hv9dCLE+MKCT3x/b7rjlVFkV0aw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DQ5jj5lW;
	spf=pass (imf01.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758619025; a=rsa-sha256;
	cv=none;
	b=F0xsa7pTgLp3I5S8FnPBJWRHfCbxpPUDkHSJDDgdxRq5ziczU/f/ek7DzqzJFvvNBVscl2
	der/AfNImsw7CRcOuIAav8BbSsgiOxuFiRZAsvMiC6dvG2MNilJ4EVtx8xyEfLREuAgDPV
	AljiRAVVBTFSIC2wFDaxvQiuzEcD22w=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b556284db11so441094a12.0
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758619024; x=1759223824; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u6uNBFGFaJI1+zGTy5DFgjysGcp2+im/rBXpMTQQekQ=;
        b=DQ5jj5lWHbZGncNhegIouv0BoZ5Cre8Rg0unL8CTjiD9pEqrSDFbemw0nJekOTZ/xA
         Uux/piNoXLKlx1dCeaw7ySyj19GFbqbn99mybRhxTQQKmV3qp4OPSYjKGFk3UXfMLE2g
         V7Wf9RNBmvcy9FCF85grpPaugZ/kdkwcBppKFf+rVTk2EYa4eFnRMa138G6t+NvGfXT8
         oyUTBX04KIkijJ2k6t9v48wMQGM4tDrB6Vncpv6CFWjC8wTMlCFtLyslxrLCUOJNa1w4
         lbZloGfJdLROeiDmqxbqbbWiW8is8YyX7Cp9ksoqfQ32yQMMfJ8EkRjYrzbwQQUMsDX9
         zzTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758619024; x=1759223824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u6uNBFGFaJI1+zGTy5DFgjysGcp2+im/rBXpMTQQekQ=;
        b=I2j6Aba7VRAp2qgs6qSe/USXvUuM+dQwSPKHSoXBrf+sbBSVSCj2qX9nl4Mw+P40uf
         nlH764hWhFNTZXriWf8Itk5IBU+lF+NYVm1i9VO91hSzkv2jhh9rzrEEHuKLexisD+jD
         mlAj0e5Js7fqc7MEbLecyA/0YMbEiySH23kr5Vkd+GR+n3Pr8v//e/Ov/3zTSjryGvvv
         uoAxPm1l6AFQcdEOePKGXDfetjjJroN/mz2VNqP7XJ6dOJ1mcEpUoE/PYYO6uezaST2w
         7twYssGg5IH9ventj3RlcvUwhVVB1qZtsrzYsiM3ut7NjovDyjK0y/bYPWUXfzfAAboG
         Ui8Q==
X-Gm-Message-State: AOJu0Yw+aFescZksFI6bw3HHNRru8OGSAI3ZmxFS9bjCf8kk5RgS4L9s
	xCOggAY9GwTdyCJXr/U7wDMdsbRbh/0ozVhW/V7ohF8HUBFqt2/WlmjPYcuLeZ3c0zo=
X-Gm-Gg: ASbGncu+iJKSgmhLNirNYtgfn5SwcSA9f3jd5K0nd1bIxA2GzlaIGcelU/lN/w6a3K7
	8j6svjQdMROVq7cG6u+/2bGCl/+Vj3lR3LYPyqjuDoxEqefyBQci+9HiB0LvyOjPGL1umJNltYG
	mMRba374e5cc02wIfbUiePV868kIufSRZsc56Zy3zXkYkRdrNHA476LRCoqMWYB8y0bpJOXKDGB
	HzpLoijV6Jw8r8VCl4rOk+nnDf0bxJCEUt1fxwKV8uPib9BzTRrnR71QRGKNiR3k+OtanAlWNgM
	G+G81qDF3FqxVf0nIXGiSoAzLgoFx4uCRrAx7ANCb99M54TrCqD6JOzQt+IXiNxfJMTJ7M+kzEg
	t5xpd0z1U8pzRx1VFtscAt4gGo8AoZl9Ntvx9zCBK6roGnSyCuuSyF7T55BD9hwSWdGg650k=
X-Google-Smtp-Source: AGHT+IHXRTi7JrEoo9TlTBjVxxXC7IIaD0IUqv1/nkTJuTCB7uO/+49ZH0/c4MP+wiFn/vhAyFBCKw==
X-Received: by 2002:a17:90b:1b47:b0:32e:e150:8937 with SMTP id 98e67ed59e1d1-332a92df6famr2662936a91.6.1758619023823;
        Tue, 23 Sep 2025 02:17:03 -0700 (PDT)
Received: from G7HT0H2MK4.bytedance.net ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ed26a9993sm18724713a91.11.2025.09.23.02.16.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 23 Sep 2025 02:17:03 -0700 (PDT)
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
Subject: [PATCH v2 2/4] mm: thp: introduce folio_split_queue_lock and its variants
Date: Tue, 23 Sep 2025 17:16:23 +0800
Message-ID: <fd789692341dab6db46ef06cc2e5e597488f825f.1758618527.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1758618527.git.zhengqi.arch@bytedance.com>
References: <cover.1758618527.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3A0DF40004
X-Rspamd-Server: rspam05
X-Stat-Signature: wkm8otsczsw1ukumifngimo654m5jbj6
X-Rspam-User: 
X-HE-Tag: 1758619025-372488
X-HE-Meta: U2FsdGVkX1/pCzY7QkfsgY7n7KiQX0+JCGK/I+9/8UqGwaUAy59e60ug0I4aRINTrmbxv86rWcz4+Ys90KxxvISV7VO5asVKEBQnlzjBHhWRl66U6xB9RT3q3FaCKtfrd2yx4/HuF3wcs+ZiOxjkAHgu7vdB/8RM6x6idxdRqDsBuBBUa/hp5pY82URbxMVDcxiI3KZVKbxSw9jQB0P6frzmLj9dAbc5ZIUHqbc4cWaUn2058MMYwDgg29kxTy0uZ+Q4TAkR9q2ZpCwcmoWDdmDu1wZBl3JvH8SGENWIDPgnuvxx3qAMGwzaM5cy8wsnbYf0n3KOJTjeOto+cfN4ttLkBALaLlkchaHfZCZlxe7mrNkYGhRWOUb1WpWmGpnwjPb7Y4Fg+6HypIhFExskyWDNkf7OOFfi2witENSDdhi/xcIxlIv3OmtqLV3VvmMTvkX+a48abN859mIE6/hw/V3UgJyo7rlQQaYk8LFABBTayLrQGzNg0cLlXh6nT9PPtBBjRCumn4arSjbnrh/TqiHSIhcBzjA2Z+iVaBdSwDDw4o6qHtAfWRxK431wC+OeEs1aVxzk3iIDUDOZS9dpJu+5Mn3N6x2ypitWEVsvQvyWfRCB4ENW7qb9n/bwLS6M8SyCkDeNcg6JqhV9L7YCQLK14J/H0vG7y2gMolHDHlrJ+XRHggQPQGeKZJduOzH3e9VqXaHaz+rMcJixMCivryRcERPrp/kUulq0tfHyLA/YAbVVxD2EvFYHip7O4Vzuk9nuWBFLWDdvRFVX9yaOXri8igN5j67YKwyhkstIzSQzzZsPIlVB4KN9nQBLc03WXq8TN6BIdfhE6w16zlqGYbbG2ATWafM63xL+xXNrwPBtTNLa2Zqg+EzRZj5cWvWikG+7i6aYs6SXoRtcdD0j6GcTkAPO6AnBMdRialImIV7nzMVyO2l8jl6EeNjCUcnP/0L1yXLYuhOkNNZJuE7
 w1/B0Kaj
 UC3e1RxkjfWFWrQIxjP6AkjB8GHvOm609LoLNaNmaPROekLkgUUZN1jI0D9HpH1E/ai9y0IYMnNTYTBFXOd/D99S3FxcgO7Iet2Ajls9Fw2nJ2Ft1i3h4MQQLTn6LKr0zl7v/yz+TGr4QPDy8rJbQ74mT1GeLFdSkaudn7ECen3ExqAOB8kOSnzelEQXudS/bClucWjtyVX8yrY/kCZcvaZ7qRctukYqZtrg675tLI71ccs2ol3MJ1XGXzVSeKXFDRudDpYYaJ+puXIlqyADyWVbBboOQTp4tpYuYMNj2HduWWIc34vaaB7BrxNQso9A3sb9DzdNU6XlkKNH74JdDsRJFdVvDu+gRUISLgBfLaDZyQCDIyslSfq/99b5Rc2vFrt0pULIjmoF9327jkZTnUtD/LBIaFK7Z1GEmlaIbRA3v9eAVkJKQigOdurZ3mOffQymDNPZwcn0zAdQ7hmMQnv1CYr5wyUjaTs7XosIZctkcYq6JndTc3xFyOA==
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
index 582628ddf3f33..2f41b8f0d4871 100644
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


