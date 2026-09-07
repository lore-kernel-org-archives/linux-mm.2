Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB214C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 11:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5CCF6B00AC; Mon,  7 Sep 2026 07:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33AA6B00AD; Mon,  7 Sep 2026 07:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A49D06B00AE; Mon,  7 Sep 2026 07:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B51A6B00AC
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:01:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F222D140111
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:01:22 +0000 (UTC)
X-FDA: 85186674804.26.5495D39
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf30.hostedemail.com (Postfix) with ESMTP id F17EF80003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:01:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="nKY/KfMR";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788778881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eIX+mgn/05GG1BdcM7+jXBv8ObcWey0aeeYAiAqGu6I=;
	b=clWIM9g/FMGJuH7LXO8v8+gZ/bBbp4YPKJFv4W9jBKLiZ6f7TNGYjdhzprqubUay3y/3IZ
	pivarumdkMxl/EyKSugvE2WaU8F0DMgmu5g4Pic9Bp5nEibSTC0Hw6muEmYxpPBXnq7PFx
	IGV3lD0NQ1GzRe0k4N+z0OoSptxazrc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788778881;
	b=t6lfDydRiRFAI/tRwffLwduRLew1Pm8XIAFCLYhHtGZBV/YPDGkAkljs9IQYdcfBKPIp6O
	PMzOM+4OmFq3OOaHlkpRdBHcHK7A4afahdC3iGUpTuAsITGEIXgjAsrkNHRlrSRr2CzOOF
	g44o5jM2PP4VzOYift4BDHCT1eVUN48=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="nKY/KfMR";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788778877; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=eIX+mgn/05GG1BdcM7+jXBv8ObcWey0aeeYAiAqGu6I=;
	b=nKY/KfMRPduLmUs0WYrIef0qgyw056YKkx7fQ2ZGgbiUp70N+fyqtTlYg12YUoLnOkpTza7g8J9ffboEFGVlgLMEL3M1+/If03EPx8Vt0yVLSlgxa2QnjtN7JrdtgW+i3HSue94SXB7hPUp1w2JQi3+eF9TazUgf/YJJEnc9rcw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XATsvzn_1788778875;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XATsvzn_1788778875 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 19:01:16 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Usama Arif <usama.arif@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Xunlei Pang <xlpang@linux.alibaba.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v2 1/4] mm: memcontrol: drop kmemcg_id and use the memcg ID for list_lru indexing
Date: Mon,  7 Sep 2026 19:01:08 +0800
Message-ID: <20260907110111.2286932-2-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F17EF80003
X-Stat-Signature: ce16xmqdu9tfx5npkfgcdr1u8fob6og9
X-Rspam-User: 
X-HE-Tag: 1788778879-158733
X-HE-Meta: U2FsdGVkX1+/UBKiKjwaad8x/y5TKV1v/k9LwZ4Kc6tuxvTBOi7Mw+6bCr6Ga927KtvXOz9oyuk6CRBL9p28mnyamNNX7Gqfa+2056e71NL4khc8MopSWPdye7RfTefjKfZpKdB+r8f+5zDzd+XvILRWJPzofRnH2o3JsFMlQ7Ti3hXomkt2MifX4JcIDeDe/qxT0xs3dTpEPwC+FgJe0w5WHAj2W4De556jgBNHpLZi+ndvk+acPBIOTEb7yoSBwHYbLIL6DTytAY48iVJQbnXAnuyIbxpJiRPYllU7iIVc8cA+mH9TvWTM7wnGEuEBqNc7KydUzww2WKaEWy6VHnhaaKGrb44WGw+m6Htpg462jsjtf4Oynby1arjm4mk1qfvHrxsoItSD/e+DDeMLEppcOP5Ko4Pn/BPnd1cpEMJjd2bZtj7alUldFg4TgyvpIjpRc/dpG2b1W83UMULYKgjCmSoQaWqzVo2FlV9bPG+byIAsgLO8O2+CmujPGpP9QRUZjzVYpjGixcfruszmQvfSRJh1E3ZLm5JZQMPK0cg8g0TCd7yFS5PXW3/2LBHAuW7dnTUpRUMext6qse1Xo4Edud+VBegS2I8G56eQpwdIPewB7cL9L3JOv7aVNfwjKuyW41hIUYxKvL8RecWYzrtURI/REiGna+B/32l4YH/ixdDZ9da23ydcqduL8ONStTw32uavT8qcrUnKV/2z6T4JslqXpJf92QMUU/wQktkwHAlDfLOsBGEctsiB9vi0OoRQsApooAJpaDbW1KzXj4AhCYmEDAvYHIM4v6kacWO3GAI6eDJdjlnI2QmKzgWHc0wLKrZA6fcFtUfyeYKUqx4MAtIK7sCHauiy9+esGMn/jt/yeF3TjT1lil7Em56h67xN4ugTOhNTA734yTxybrvfO68QFMUVsOkeNsEWNYf0rPD1Lqbx8+h67qguT0cM9xCR18NySuuTlJ9DbmT
 PvwxHsKU
 HfaWX/a/DhWqCFnuswjfwfeDtmVBK9GmxHecuI+sXp6NpjEwgSghDA64A+jvMkLf7QyrNBrjfYIa8OVKWbMveQ/XFx8gbm8YpZjr6QYtSUgg7E84ya6kTOSjZRzGK05dstxLkwHuGm3coBw3lL2051E232mzlZMchm7xABQh/Km7guPekKH3Zb6OSGrxEDicNp3aTuca7QvI8ypDFplLZ5lCj93ndX3y1f99Oc6tNl5jghaiiWx7lgE7+bmTUfWdjrJZ08b+b1Qj/KCatcGeJwqw1JyOavJc3xN39yeajeRgeQU4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmemcg_id is a copy of the memcg ID assigned in memcg_online_kmem(),
and is only used as the list_lru xarray index.  With
cgroup.memory=nokmem the assignment never happens, so every memcg
resolves to the per-node lists.  The next patch needs the index to
work under nokmem as well, so drop the copy and use the memcg ID.

The ID works just as well as the copy did: root and NULL still
return -1 and use the per-node lists, and the ID is only released
after the list_lru reparenting, so a stale or recycled ID can never
reach a live list_lru entry.

The early return of memcg_offline_kmem() under nokmem is dropped as
well, so the reparenting also covers lrus that stay memcg aware
without kmem accounting.

Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
---
 include/linux/memcontrol.h |  8 +++++---
 mm/list_lru.c              | 10 +++++-----
 mm/memcontrol.c            |  6 ------
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index fdf4812e1d818..edeb287978934 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -254,7 +254,6 @@ struct mem_cgroup {
 #if BITS_PER_LONG < 64
 	seqlock_t		socket_pressure_seqlock;
 #endif
-	int kmemcg_id;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head cgwb_list;
@@ -1775,12 +1774,15 @@ static inline void memcg_kmem_uncharge_page(struct page *page, int order)
 }
 
 /*
- * A helper for accessing memcg's kmem_id, used for getting
+ * A helper for accessing the memcg ID, used for getting
  * corresponding LRU lists.
  */
 static inline int memcg_kmem_id(struct mem_cgroup *memcg)
 {
-	return memcg ? memcg->kmemcg_id : -1;
+	if (!memcg || mem_cgroup_is_root(memcg))
+		return -1;
+
+	return memcg->id.id;
 }
 
 struct mem_cgroup *mem_cgroup_from_virt(void *p);
diff --git a/mm/list_lru.c b/mm/list_lru.c
index a4522ca93ebcb..6fd4e9af84396 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -502,7 +502,7 @@ static void memcg_reparent_list_lru_one(struct list_lru *lru, int nid,
 					struct list_lru_one *src,
 					struct mem_cgroup *dst_memcg)
 {
-	int dst_idx = dst_memcg->kmemcg_id;
+	int dst_idx = memcg_kmem_id(dst_memcg);
 	struct list_lru_one *dst;
 
 	spin_lock_irq(&src->lock);
@@ -536,7 +536,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 		 * allocating a new mlru since CSS_DYING is already set for this
 		 * memcg a rcu grace period ago.
 		 */
-		mlru = xa_load(&lru->xa, memcg->kmemcg_id);
+		mlru = xa_load(&lru->xa, memcg_kmem_id(memcg));
 		if (!mlru)
 			continue;
 
@@ -551,7 +551,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 		for_each_node(i)
 			memcg_reparent_list_lru_one(lru, i, &mlru->node[i], parent);
 
-		xa_erase_irq(&lru->xa, memcg->kmemcg_id);
+		xa_erase_irq(&lru->xa, memcg_kmem_id(memcg));
 
 		/*
 		 * Here all list_lrus corresponding to the cgroup are guaranteed
@@ -566,7 +566,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
 					    struct list_lru *lru)
 {
-	int idx = memcg->kmemcg_id;
+	int idx = memcg_kmem_id(memcg);
 
 	return idx < 0 || xa_load(&lru->xa, idx);
 }
@@ -602,7 +602,7 @@ static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
 			if (!mlru)
 				return -ENOMEM;
 		}
-		xas_set(&xas, pos->kmemcg_id);
+		xas_set(&xas, memcg_kmem_id(pos));
 		do {
 			xas_lock_irqsave(&xas, flags);
 			if (!xas_load(&xas) && !css_is_dying(&pos->css)) {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7ce50bccf1264..619d4c1f2e8f2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3780,17 +3780,12 @@ static void memcg_online_kmem(struct mem_cgroup *memcg)
 		return;
 
 	static_branch_enable(&memcg_kmem_online_key);
-
-	memcg->kmemcg_id = memcg->id.id;
 }
 
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *parent;
 
-	if (mem_cgroup_kmem_disabled())
-		return;
-
 	if (unlikely(mem_cgroup_is_root(memcg)))
 		return;
 
@@ -4225,7 +4220,6 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	seqlock_init(&memcg->socket_pressure_seqlock);
 #endif
 	memcg1_memcg_init(memcg);
-	memcg->kmemcg_id = -1;
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
-- 
2.43.7


