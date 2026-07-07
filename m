Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D87EC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:40:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7016E6B00AE; Tue,  7 Jul 2026 02:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640FB6B00B0; Tue,  7 Jul 2026 02:40:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CD326B00B1; Tue,  7 Jul 2026 02:40:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D17C86B00A7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46A0EC1BC9
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:27 +0000 (UTC)
X-FDA: 84961031694.03.5238966
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf10.hostedemail.com (Postfix) with ESMTP id EE42FC0003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406425;
	b=0/0UgQIX6xcn1xl4pBK4dX5t9YmOfexmxByJtUX0jMqTz6Ti7WfFNoe2Z/g/3emhC1yxi1
	O4EYONJWdlTJgeEK7ziePx3u9CCwLl+0Fsaxop2DPVdmY4Q73G0f8y7JvXGoB5DMvcIlxZ
	fRikWEC2IwsOusm6mMEQxR7v/WS28cg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2D7mqkZxIOeGaaTYJ5CSGULjLDMUCKtc62yniiPFJqU=;
	b=X7BeA0jEXa5ZJZYgi6EPDx8EGkmUOa4k4h6ldYejjlWrThAt8jaXd3gA7iF+B85bJFnePv
	C+4i2bORxrUeZMVoUYAQx9BSzPtKTspMPHHAaqnoXeQujET5jBOuDKC+sspF1Sf549ZRVh
	+ZOsKJb2Uh0ZYVo7QlaY8y09jJOek24=
Received: from TW005.hihonor.com (unknown [10.72.0.123])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4gvWnG1QSVzYkyb0;
	Tue,  7 Jul 2026 14:40:18 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW005.hihonor.com
 (10.72.0.123) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Tue, 7 Jul
 2026 14:40:17 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 14:40:17 +0800
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
Subject: [RFC PATCH v2 02/13] mm: implement helpers for ANON_VMA_FRACTAL
Date: Tue, 7 Jul 2026 14:32:57 +0800
Message-ID: <20260707063308.29176-3-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260707063308.29176-1-tao.wangtao@honor.com>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW002-1.hihonor.com (10.72.0.137) To TA003.hihonor.com
 (10.72.0.43)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EE42FC0003
X-Stat-Signature: j767p5p9q71wach7z8yt37afpi3417jy
X-HE-Tag: 1783406424-772116
X-HE-Meta: U2FsdGVkX1/b7FTiggMnufalqaxyUi2Wtl8WvF0afKSm6yiNiVOpIOWubIsq7k2lEpqCXj8/hyY0xWCq1qOrR3MsB1WjOm+ZTWl+bp+xoNnIRGAVwOJ7Izybfio3xOFnQAUSKQ5NTznuwFQXC3ZWFrmpEqICxFbHNozDGJ3ibEwCXURBYqc1Fi/67HUf0zMWJLCmBhd+ozZ/HrnekOq8fqJVizX6BntYk/VC8FV/MZE7JQw/PZ6LzeQEdVHP+f2JrvGa6e/72FmNiDRU80CvNu8zm+j6ibvfyVB8B1dyDJwkU5BUWswmHKx3R7bC3M8TiJHWbANTS3FOcLajjP9LKBYAPnXDW4a6bAq+qZfmFAq3QeMYo0rrD/oRrnj6bCPBKAUjECZYDrAjO7FbPwxrBph/kTcQZgo+fTA+yS/WDwZKBVFeIi+aLV7qHJzcM1xClzo/qp5ISHVLDX2M5kCyroXRLusXAwLKd9fWBLkaRHnSnS6oA5SrQxy1qlZWEDBnRF215EqlJ0u73rbSuLQQGZFeGzY6xNNV8BrAltVC1zE+jIDLbN1+iYy9+suYSVC2E4611aturK9DgiSzOGbNDgQqmALVRysnzd+H5ss9gpC9CgIvyE8Lc183uwEMwFTkc6e+JCo1h0/I6WkLp4Q0wJS5JI4MvmZqNg9s7VOXB5KRD/t+kn6TZ3zcGhLw86pIJ82WG4KMzAHaAagXndOAjfxQOXCxEEzODWGj9t2TKl/TDmdk1peg0uZD0LEmUPrFEabowD/9mW9zIqm/wuVKBAJcSimtTjBknthz+V50plHz/3SWKD5ODEW5DG7kBq9MYMtt3cOEGfcniBc4mHiwj2us9HOcv9KP30ft2nBZAGaCYOLYcI8f0OWntYkI9EI+NyuxCIb4/dozjwmRwJY3PonyAUDp2o+q8RbAapjciHDGcDAuSJm+jC2sSr/I0TIDcXGCxe4AFr0bRQmUzoG
 RKUqXd53
 J5hozdC1FfdIsDDCI4h0XCNf2oaczWrJBcsNC4AoN0HBVsfTRjndpjr9Fb1Jc1oSyu8qm+lrxgflXn0bG1KnalYqBz3dd28sx/hlE6w0kWaYuNz6HJve3ksZTpTT4auIMfT9wCPWGkB6OCdU+BTzKn2JvUQP5AfSoyPfMjVtfW8TuvzYI2aprfB1bcuksOeDX/1kZO8Q/hgtHLGqLOJFvR7U10lhuWGEx+b/CCv0DV2DdVsF8QTQlHJrVZCl6y6oLjODRZHusHvogelJte9UYL+a+miMUvWzf4YPxNVpWHzvvkda5CEUfd2Fxq3vzR39TUmsc2yIpIvfdvLw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement basic helpers.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 mm/internal.h | 25 +++++++++++++++
 mm/rmap.c     | 89 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index a33ed1a30f09..c1b3961b9d3e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -271,6 +271,31 @@ static inline struct anon_node *anon_node_next_descendant(
 	return node->depth > anon_nod->depth ? node : NULL;
 }
 
+static inline void get_anon_node(struct anon_node *anon_nod)
+{
+	VM_BUG_ON(atomic_read(&anon_nod->refcount) == 0);
+	atomic_inc(&anon_nod->refcount);
+}
+
+void __put_anon_node(struct anon_node *anon_nod);
+
+static inline void put_anon_node(struct anon_node *anon_nod)
+{
+	VM_BUG_ON(atomic_read(&anon_nod->refcount) == 0);
+	if (atomic_dec_and_test(&anon_nod->refcount))
+		__put_anon_node(anon_nod);
+}
+
+static inline unsigned long anon_node_rmap_base(struct anon_node *anon_nod)
+{
+	return atomic_long_read(&anon_nod->rbc) & ~ANON_RMAP_BASE_COUNT_MASK;
+}
+
+static inline unsigned long anon_node_rmap_count(struct anon_node *anon_nod)
+{
+	return atomic_long_read(&anon_nod->rbc) & ANON_RMAP_BASE_COUNT_MAX;
+}
+
 #endif
 
 struct anon_vma *folio_get_anon_vma(const struct folio *folio);
diff --git a/mm/rmap.c b/mm/rmap.c
index 1c77d5dc06e9..fa9d82271005 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -558,6 +558,95 @@ void __init anon_vma_init(void)
 			SLAB_PANIC|SLAB_ACCOUNT);
 }
 
+#ifdef CONFIG_ANON_VMA_FRACTAL
+
+static struct kmem_cache *anon_node_cachep;
+
+static inline struct rw_semaphore *anon_node_rmap_sem(struct anon_node *node)
+{
+	return &node->root->rwsem;
+}
+
+static inline atomic_t *anon_node_vm_lock_ref(struct anon_node *node)
+{
+	return &node->root->vm_lock_ref;
+}
+
+static void anon_node_ctor(void *data)
+{
+	struct anon_node *anon_nod = data;
+
+	init_rwsem(&anon_nod->rwsem);
+	atomic_set(&anon_nod->vm_lock_ref, 0);
+	atomic_set(&anon_nod->refcount, 0);
+}
+
+static inline void anon_vma_fractal_init(void)
+{
+	struct kmem_cache_args args = {
+		.use_freeptr_offset = true,
+		.freeptr_offset = offsetof(struct anon_node, fractal_list),
+		.ctor = anon_node_ctor,
+	};
+
+	anon_node_cachep = kmem_cache_create("anon_node",
+			sizeof(struct anon_node), &args,
+			SLAB_TYPESAFE_BY_RCU|SLAB_PANIC|SLAB_ACCOUNT);
+}
+
+static inline void anon_node_free(struct anon_node *anon_nod)
+{
+	struct rw_semaphore *rmap_sem = anon_node_rmap_sem(anon_nod);
+
+	VM_BUG_ON(atomic_read(&anon_nod->refcount));
+	VM_BUG_ON(!list_empty(&anon_nod->fractal_list));
+	VM_BUG_ON(anon_nod->nr_children);
+	VM_BUG_ON(anon_node_rmap_count(anon_nod));
+
+	might_sleep();
+	if (rwsem_is_locked(rmap_sem)) {
+		down_write(rmap_sem);
+		up_write(rmap_sem);
+	}
+
+	kmem_cache_free(anon_node_cachep, anon_nod);
+}
+
+void __put_anon_node(struct anon_node *anon_nod)
+{
+	struct anon_node *root = anon_nod->root;
+
+	anon_node_free(anon_nod);
+	if (root != anon_nod && atomic_dec_and_test(&root->refcount))
+		anon_node_free(root);
+}
+
+static inline struct anon_node *anon_node_alloc(struct vm_area_struct *vma,
+		struct anon_node *parent, bool is_fork)
+{
+	struct anon_node *anon_nod;
+
+	anon_nod = kmem_cache_alloc(anon_node_cachep, GFP_KERNEL);
+	if (!anon_nod)
+		return NULL;
+
+	anon_nod->root = parent ? parent->root : anon_nod;
+	anon_nod->parent = parent;
+	atomic_set(&anon_nod->refcount, 1);
+	anon_nod->depth = 0;
+	if (parent) {
+		get_anon_node(parent->root);
+		anon_nod->depth = parent->depth + (1 << is_fork);
+	}
+	anon_nod->nr_children = 0;
+	INIT_LIST_HEAD(&anon_nod->fractal_list);
+	anon_nod->mm = vma->vm_mm;
+	atomic_long_set(&anon_nod->rbc, vma_rmap_base(vma) + 1);
+	return anon_nod;
+}
+
+#endif
+
 /*
  * Getting a lock on a stable anon_vma from a page off the LRU is tricky!
  *
-- 
2.17.1


