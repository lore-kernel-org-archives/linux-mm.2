Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 904ECCAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 16:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E809D8E0016; Fri,  3 Oct 2025 12:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E310F8E0005; Fri,  3 Oct 2025 12:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF80F8E0016; Fri,  3 Oct 2025 12:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BBD858E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:54:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80C2911AEBB
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:54:25 +0000 (UTC)
X-FDA: 83957401290.25.17855D2
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf17.hostedemail.com (Postfix) with ESMTP id E1BE840008
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:54:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r0z0oIlk;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759510464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdGXwz8RCfksNzwLXFncQFeyfM2HiWcY9u8nErU1OTQ=;
	b=Bvsa20lgyZ4iltdxqypQ4NqU8X0BgtZLM+x1p9NoBxabBWwfCtmyxpmyDn+5AnzlCtmFt/
	bkfmeLD4ks6zZQ1J2VLuo3cRkcCt4VFam2BXM53JQKK37aG1w8yLSeAtsg43DkBSIEuBq4
	7joslFlqagNnK6D7q5W860jPteA1kIA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759510464; a=rsa-sha256;
	cv=none;
	b=M4DqfkLyNJ2YWB02EYVpb/4Q3NDKwqI7S/X0RMV1KHOf7a2gIGNBpMQn5KuOS77aQMPoR3
	kfOfhrE8sNxcXu3p6aPeF/AeUi6ghciPPfJxAeJTwiiJuVfZuvuQ9qGLrx5+6gCD50Kb/4
	I0PwEN6LwrvUrJrsX931yqlyBjzWBRU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r0z0oIlk;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759510462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mdGXwz8RCfksNzwLXFncQFeyfM2HiWcY9u8nErU1OTQ=;
	b=r0z0oIlk6NWImBasOPaB45bfsCP/wLTIrAznY5ImxqWU+ydf9O7stq0NWg5zUK/FRqv0IT
	fuIPOjhoJYLpCcJNYEWJ73dEWb6jtcUkUNJkdLAATVEtCzcJU32ysHe7GQkZ+Hy2h7UzcZ
	ND2kxJvX3NuIM9ClxdK4PhOYE/4+U6c=
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
Subject: [PATCH v4 4/4] mm: thp: reparent the split queue during memcg offline
Date: Sat,  4 Oct 2025 00:53:18 +0800
Message-ID: <a01588414c9911f2bc912fa87f181aa5620d89d4.1759510072.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1759510072.git.zhengqi.arch@bytedance.com>
References: <cover.1759510072.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: pe4o4icgnjnmsbm9jg8shk9r3pxzi5e4
X-Rspam-User: 
X-Rspamd-Queue-Id: E1BE840008
X-Rspamd-Server: rspam10
X-HE-Tag: 1759510463-857731
X-HE-Meta: U2FsdGVkX1/RVakl0x+5qtSzaPs0b/u0oUKeiBt+Cv3spKI8zsMHwocIR+dy6JJUPNV2Whht++Q3f4SFS2ACZZxy4JA0lQHbaQcKhdCnscOddlOh4VpcRcWmHLz4We+pt4Nfr3dterA6/ywfFx4Eo80kyQEkESTKdiE/2oRN8xXuwc0DCtfA1mncqC8ya4yeIJ4eZBTtU77gPa6A2L811diDUKom4BuChL2Eat221g8mFqXzd54ONBPEccPUO/XXXCtT85W369D9Ro0HXsZ9ATNz2bG9HgsL3TsnewXRtZoczRbBW+13UJQCsiXadKooS9+nriSyy8/w/G+mFMCaqlXHBxI3Zv/xzCv0EVrveoz7qqSrbvb/Y+6HhRltBJh3kiIP86MGI5bLrEirwf+MxT/9ytcefsEGm56NVrF5v72062pkbdBeHbBjyndXUCXbGI+8F7cOs8pHhLixJvBkIAET3G5zH8/pts6mXjzqu4d3iPruMfpOrW+HBjjMueekaz5LfPGrMN/1b7BS2wWYjJ52sbguM4A3tSm43ysHZiQA7qdwud7fFXwqBFxIz3S4IC06DZFKbUEBw/rV3w/5t8t/WN+ydHJ8N0AC1Sg5TIzF+E/wBlXNInpEqNxFR01CCxqWZG3Nj3ZPiuLAeIqOtgQWeOFGQwObnSBC88AoH3egD/s9nEJ2NhpfJdefQM+qZ7aw4QT6tGRb7Rm5uaOItOjCGk32GvJrw/tGSGrOXdeo8h/hzKhKqz9z/VI6ZNyclGB8e0CTxD8VZOGAsfoRFBv6IVNk4EsUOcM1BT470mvKVtdqZ7bSHdpgKSClbw4KHnpNn2zkyXsD8Efqgn2/cUBAOsi77k9ZroQCotK1FBQ2tr9vBuFNl/OMjpxcrcalxEBsqmo5yOHw0IqB0PQjPQ==
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
---
 include/linux/huge_mm.h |  4 +++
 mm/huge_memory.c        | 54 +++++++++++++++++++++++++++++++++++++++++
 mm/memcontrol.c         |  1 +
 3 files changed, 59 insertions(+)

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
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 59ddebc9f3232..b5eea2091cdf6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1099,6 +1099,11 @@ static struct deferred_split *memcg_split_queue(int nid, struct mem_cgroup *memc
 {
 	return memcg ? &memcg->deferred_split_queue : split_queue_node(nid);
 }
+
+static bool memcg_is_dying(struct mem_cgroup *memcg)
+{
+	return memcg ? css_is_dying(&memcg->css) : false;
+}
 #else
 static inline
 struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
@@ -1111,14 +1116,30 @@ static struct deferred_split *memcg_split_queue(int nid, struct mem_cgroup *memc
 {
 	return split_queue_node(nid);
 }
+
+static bool memcg_is_dying(struct mem_cgroup *memcg)
+{
+	return false;
+}
 #endif
 
 static struct deferred_split *split_queue_lock(int nid, struct mem_cgroup *memcg)
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
@@ -1128,8 +1149,14 @@ split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned long *flags
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
@@ -4271,6 +4298,33 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
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


