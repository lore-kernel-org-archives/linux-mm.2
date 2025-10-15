Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFE7BCCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 06:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 179C08E000E; Wed, 15 Oct 2025 02:36:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1298F8E0003; Wed, 15 Oct 2025 02:36:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 018C38E000E; Wed, 15 Oct 2025 02:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E15228E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:36:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FD261A0ADD
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:36:33 +0000 (UTC)
X-FDA: 83999389866.25.EE939CC
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id C0E5B14000B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:36:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H7caSZfu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760510192; a=rsa-sha256;
	cv=none;
	b=S5fU5EuD3qc7xdWXDQ/RDSUyqa1l8XNlbVzcYntvg3+g61GvACFjNg/CDWRMMKpbQDvD5+
	NoNfepOyosaLS9PSYjnnadwIKmEBuCrQK+bsCLpLZFMCDrZyfgXrTLRlijB6xPX15a3ohZ
	eqyfYE5mHnetRUGf5PgzOHlayedFoC8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H7caSZfu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760510192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3BICM4/ICXf+zqUc8wiZAUMGTBpg8K3w3bGX3Sv3oBQ=;
	b=hHX8NDD8X5G/qlbF3HIDjPlPwjQgFeavI1KySvro6hAmcU0ku55baL1VoLGsjow8FoS+Jc
	8qx9S7An3ZZLP5lS8j/1Z1SRy4rFtsqvepwjFIBViOIsH9LPjGVr6+0fAVP/coIs9n4LpE
	UdFG0gdQ0I1ZEuWM7s67xZb5hQkgcf0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760510190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3BICM4/ICXf+zqUc8wiZAUMGTBpg8K3w3bGX3Sv3oBQ=;
	b=H7caSZfu4t4c5M7yudMPuBohd2tAVxKye8T6//8DUxt095mlcwWRyGXMiJt1ydX/gSpKO8
	a7a+eH+aLJm+jZhp/l93jFXsW0POPuVhfURihl0jKG3mLJ2p+rJ0DjcPEc6ui2roX0klU6
	tBdp3Bor+ZznaSPJgH8PKT35RyRB4tg=
From: Qi Zheng <qi.zheng@linux.dev>
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
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v5 4/4] mm: thp: reparent the split queue during memcg offline
Date: Wed, 15 Oct 2025 14:35:33 +0800
Message-ID: <645f537dee489faa45e611d303bf482a06f0ece7.1760509767.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1760509767.git.zhengqi.arch@bytedance.com>
References: <cover.1760509767.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C0E5B14000B
X-Stat-Signature: gfr9chkcwzi9huq9at6ehfqkwabue5gn
X-HE-Tag: 1760510191-25207
X-HE-Meta: U2FsdGVkX18MTVRpnsztigm68P76vGLdtSpaUgZ6jqbt6nCaQPLgGAumH47uK6fYkmGfSetkZHm22Pnvks68E+7UNfDvXYGTUw4adwz7Gl4Fqcd7GQPWgj4twnRVi9Rugo70bZYBtkvf6SlW8Bd+b99fvmNMt96ypWG4Ka2lWr0RSzVgAEmSUm+cvlFR6Xo9VxX26JRqnWaCADDsUvW7QoQfCoHG8sg163a6bCxJodhrUY6hzfAEzF7hMefOKgfo+v0j0gLYm9f8KPCmDVZsJ2gC2Sv05fsXhdHPjjgV8Yj7iBfYFVKxhtG1lJkkv+02vLulLMrhDlvFNWk5sRa71niIaiF7ZU41iBOWmSv+/Ye0w58x13V5Og1tVVMa+SoP6LXk8FAcB4le1e1idKFDpFmcVQKyyUvQXOEYzwK+9LN8/JVD9zvteK3/r9aPjhHUM/YEt9ltyKjfGf0AkOC6+eT+i3xSpWfd5+1jkMBTy6SALksuHDH1MUc0K2WDc6+0VEAHhTwR9RkMOcSqUBDgZsyt5BEyEx0b/3JOSUtHqT8U52CFfx9MqFwInitG8aNIQp6MCjVzXZsILmSNk+rk3V+WxGS9+obl8ZVucxc2/Rz6idFAM/CaC6G3bIaSaXywjZff5hCMfkwj68x3OQ1wze6w1PogAN9g4XjSgR/fLIjt8Hm+lYp+KL+IErTkDtaV3TLqZ6qrhtJ+SpBkPY0eHUOw6MpeEWYu8iGYr8475/GUOTAyeof+6DA3BQ8kNMfDLroN600n5QiK6QPm5BowOhlNo5azEprsvbb7rNw0258gtakufD1AeP0Evyyzw6lN4RHcAGq3pQZf4tXceeCmmQ/L3YhvfW2zcKQONWmD+StnCEm5AkwZosuwumHvElAcqPygW8ICBcZFNq84jF8eFLTNxXUCKLoCYawJ6X4DB60lCUfG9AmmczZCaOP1a2xXEHqtE0E8ChasVd6NfvF
 kMlT6SIt
 r95raclB3NnsBECCmY5sR891G4EbNFfZxVLN2uxxAAaQSp2dcyrI8Z9yisIugYuIhwKcVs1jeK/L0bikVtq3URq2MqqrLZUydIqmgnMmbLwECf8mWTPnonFJ/bAnNfYPRCezXjHt2HxMF7CXTT3Qrb5m9LTf0ZWfJM1tccNXZcyxyn3KA9RM0FCokyyvFXqIqxv4Teh3ii8qHwu7cFBlqIqWoqIxqlHQJ1OgYC13Dhoq2yPsNWECVtzWErYAkELarxS712t6xv7ocEcM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Similar to list_lru, the split queue is relatively independent and does
not need to be reparented along with objcg and LRU folios (holding
objcg lock and lru lock). So let's apply the similar mechanism as list_lru
to reparent the split queue separately when memcg is offine.

This is also a preparation for reparenting LRU folios.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/huge_mm.h    |  4 ++++
 include/linux/memcontrol.h | 10 +++++++++
 mm/huge_memory.c           | 44 ++++++++++++++++++++++++++++++++++++++
 mm/memcontrol.c            |  1 +
 4 files changed, 59 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index f327d62fc9852..0c211dcbb0ec1 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -417,6 +417,9 @@ static inline int split_huge_page(struct page *page)
 	return split_huge_page_to_list_to_order(page, NULL, ret);
 }
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
+#ifdef CONFIG_MEMCG
+void reparent_deferred_split_queue(struct mem_cgroup *memcg);
+#endif
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze);
@@ -611,6 +614,7 @@ static inline int try_folio_split(struct folio *folio, struct page *page,
 }
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
+static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0b2d4ec79adfe..5ca97fece6907 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1801,6 +1801,11 @@ static inline void count_objcg_events(struct obj_cgroup *objcg,
 
 bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
 
+static inline bool memcg_is_dying(struct mem_cgroup *memcg)
+{
+	return memcg ? css_is_dying(&memcg->css) : false;
+}
+
 #else
 static inline bool mem_cgroup_kmem_disabled(void)
 {
@@ -1867,6 +1872,11 @@ static inline bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
 {
 	return true;
 }
+
+static inline bool memcg_is_dying(struct mem_cgroup *memcg)
+{
+	return false;
+}
 #endif /* CONFIG_MEMCG */
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e850bc10da3e2..9323039418201 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1117,8 +1117,19 @@ static struct deferred_split *split_queue_lock(int nid, struct mem_cgroup *memcg
 {
 	struct deferred_split *queue;
 
+retry:
 	queue = memcg_split_queue(nid, memcg);
 	spin_lock(&queue->split_queue_lock);
+	/*
+	 * There is a period between setting memcg to dying and reparenting
+	 * deferred split queue, and during this period the THPs in the deferred
+	 * split queue will be hidden from the shrinker side.
+	 */
+	if (unlikely(memcg_is_dying(memcg))) {
+		spin_unlock(&queue->split_queue_lock);
+		memcg = parent_mem_cgroup(memcg);
+		goto retry;
+	}
 
 	return queue;
 }
@@ -1128,8 +1139,14 @@ split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned long *flags
 {
 	struct deferred_split *queue;
 
+retry:
 	queue = memcg_split_queue(nid, memcg);
 	spin_lock_irqsave(&queue->split_queue_lock, *flags);
+	if (unlikely(memcg_is_dying(memcg))) {
+		spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
+		memcg = parent_mem_cgroup(memcg);
+		goto retry;
+	}
 
 	return queue;
 }
@@ -4276,6 +4293,33 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 	return split;
 }
 
+#ifdef CONFIG_MEMCG
+void reparent_deferred_split_queue(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+	struct deferred_split *ds_queue = &memcg->deferred_split_queue;
+	struct deferred_split *parent_ds_queue = &parent->deferred_split_queue;
+	int nid;
+
+	spin_lock_irq(&ds_queue->split_queue_lock);
+	spin_lock_nested(&parent_ds_queue->split_queue_lock, SINGLE_DEPTH_NESTING);
+
+	if (!ds_queue->split_queue_len)
+		goto unlock;
+
+	list_splice_tail_init(&ds_queue->split_queue, &parent_ds_queue->split_queue);
+	parent_ds_queue->split_queue_len += ds_queue->split_queue_len;
+	ds_queue->split_queue_len = 0;
+
+	for_each_node(nid)
+		set_shrinker_bit(parent, nid, shrinker_id(deferred_split_shrinker));
+
+unlock:
+	spin_unlock(&parent_ds_queue->split_queue_lock);
+	spin_unlock_irq(&ds_queue->split_queue_lock);
+}
+#endif
+
 #ifdef CONFIG_DEBUG_FS
 static void split_huge_pages_all(void)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4deda33625f41..2acb53fd7f71e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3888,6 +3888,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	zswap_memcg_offline_cleanup(memcg);
 
 	memcg_offline_kmem(memcg);
+	reparent_deferred_split_queue(memcg);
 	reparent_shrinker_deferred(memcg);
 	wb_memcg_offline(memcg);
 	lru_gen_offline_memcg(memcg);
-- 
2.20.1


