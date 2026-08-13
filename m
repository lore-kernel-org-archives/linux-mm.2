Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49A26C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 15:03:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 113796B0285; Thu, 13 Aug 2026 11:03:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EC186B0514; Thu, 13 Aug 2026 11:03:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002DA6B0515; Thu, 13 Aug 2026 11:03:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B84106B0285
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:03:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F040A1C4E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:03:39 +0000 (UTC)
X-FDA: 85096565358.15.C02AE69
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf29.hostedemail.com (Postfix) with ESMTP id 55963120015
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:03:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=R5QtYXBS;
	spf=pass (imf29.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786633417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yluVcWye/s/7XdOwmqnjfFXhTdJaDPji+Tuj86y5Lk8=;
	b=GpJpBSJsVoAVfyWFmURtWlPU4BDV/ZHmR9lamxGEgGayUCch3YQDZV6WcyOEeP42TC0Cpr
	IPpkLMeg0r7+xdjOehSWrEMrokkdgrWl0gxjMnhBJdAbwqkDdocJzR5+SwVqFhqYAtDtgz
	69JCaOfyZDeqZVWaXR0j7BqzqA30DVg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786633417;
	b=73K8YoZzVbj+YFtmIRo4VJvEcL11J7BG1gwAx+UmqB7kPP120nPNei4H4Kz3+wW38pMOXC
	L7V/B4oEvzrDXSpIwS/e6T7bYdORlwWSGFQQt/cslAeSptIAgf6z5NX6uKkHgRKKlloqUZ
	+2gnhRvhw8a4jGJG7WyaD0HZ7xCR+Z4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=R5QtYXBS;
	spf=pass (imf29.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=yl
	uVcWye/s/7XdOwmqnjfFXhTdJaDPji+Tuj86y5Lk8=; b=R5QtYXBSF32IgsnuOg
	6PZ43Fi8F/jaVCwdxzeDppe40g7UVr2SF4Jn/abGEbhpWYzf+8NXCXFLcXuFbwe9
	4rEKbaPh3do/AKMCODKOh3t2MeZScsSS+K1K9oimbBW/6J7d/Lv3r9YrRieCs0jw
	adSjiXzmXEJONMQH6UzqgvXBU=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDnN2y33H1qz03vOg--.16715S2;
	Thu, 13 Aug 2026 23:03:20 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	linux-mm@kvack.org,
	Longlong Xia <xialonglong@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] mm/swap: publish cluster tables after full initialization
Date: Thu, 13 Aug 2026 23:03:16 +0800
Message-ID: <20260813150316.2793642-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnN2y33H1qz03vOg--.16715S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3GFWfCF18KryftrWxZrW5ZFb_yoW3CF43pF
	4fK3s8Kr4fXrnxWrsxAw4ktFyrCw40gryDGFyxGw1a93ZxXr48Wa97AFyavF97CF1kJwnx
	Kr15Kw17uF48AwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jnhL8UUUUU=
X-Originating-IP: [240e:46d:1800:11e5:571f:2236:29c7:b85f]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC9xhfWGp93LgaqQAA3o
X-Rspam-User: 
X-Stat-Signature: 9so7uum7ktqu75jr3pizugwyfepide7n
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 55963120015
X-HE-Tag: 1786633415-168190
X-HE-Meta: U2FsdGVkX19SfawgLACcBDms1z6r5T4AQG5Y6ZHKrIPq/9Hy1rMi2FsI/dDzga6IqnmvdMzLCPOjB26bfpAXgYNeIGFcGwwSrmAPo7diHyco/9KPH6MXjYCOKqfsi1wmbtBjufiUlHXAGTNi3oEA+XSUoadakJDVzUeLMB5RYS/TAowJCxReMUU1eSbWgTiAe7EyM6DAvU5Hmgm1khLtt03qXprwc4jlrHVfXBhhSP22bjL+CIaW5GBnylhQTacd4S6fFHKc5jyFneYIKHWQwYa3yx9axu6damDehWBrwUVlx9k0bgLKiW7Qn+9HFsdyNv/ZneBxHeTxNmYSQwHDyLvAhMuHG072Plkxu6wqk2Sh/6FhfHoyL2qNI1aiyYAG8vRLFSrYnkyqLFbaWMea+QscuwHFN0vYyFtzeCySTjOoCy/B2iIfxsPb0I93i2UvcZ4oMrgLLt79o4p9g5b9AhrABWPOxtFDueSmdqZmU/Vf/uNFJ9Hnb2a/wLDkWqg9RwyVRDk/sCCxIms2pO36aZtq9awvDIsOu2jkhjUJDD0LbpRllfMIVZAkRiGcLpMNu4osbz2/jNYzhqYjpOZ4eFR78x/NII+Uzb3tb9rPeKCOO5apH8q2X8ix3WqxhimEioKNgu6JfEmY+DyogJ9+SSESm/m3wSFhgGfvIf3KoKcUbIFKfpoozpUcSsT+i24xv7peJglUo9sZUh92R46NXzr4tqN91vsoyYuQWI4JqdqBqaAqhXxXTpkcfu+Xt05QYMOB+TW+SdqvNRdyQlQFSmNIn1zQLoTrfmghnaceOA89xeVAgA1XlPF8cAaaFDq2JqTJ+vaR6C2UIA7Zb7PTOJ0TVH+pxBpBHrNK9PpDu6k/Kx2p3H07ZN8bx3/5iYNjXE68No9KDpMqseBdHhqf7HH2AE8znhjKFTwsXOphyLqEp3yhJjiOAQA0E3AnVs9j6tVrAqyb0sPuqpby0UX
 kqdjOmeJ
 QDjVbUeu+Ons9gD3q++WVjwdw73pkvIq4Niy9wANRQcYeRaZQLoRSvtmMRSg65P85GGW/kAqXQrBzPUbaMXTnm+FNazR0G9HbydZoLTUrbUL1nVX8cdAJg0jRu9mD8aYbHxUyOpOZA7xDFDPB6GGbBT4l5dyWl5K/0ChakhvCddAoYysZh5JNy1luu583XJv7s1PKAEQbo9BLLShSiMYxSF4p1GJ8mgntRY3R31IOOCKlcMosiz6QyHXMGUWgPZb8DxbsEhuyMj9QDth72/oN6LDRLPeXSZ9w3W37GuXAoHHK4L0JSoJ5DRTFbH+hNUUfGdB/ZAQG35cNXINJxkRWuNfJ1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

swap_cluster_populate() drops the local, global, and cluster locks
before its sleeping allocation.  The allocation helper publishes ci->table
before allocating the memcg table and, on some 32-bit configurations, the
zero bitmap.

A stale per-CPU or global cluster cursor can reach the isolated cluster in
that window.  Since CLUSTER_FLAG_NONE and a non-NULL table make the cluster
appear usable, it can allocate a slot without the auxiliary state.  An
auxiliary allocation failure can then tear down a table which is already in
use.

Allocate the complete set of tables into a private carrier.  Install the
auxiliary pointers and publish the main table only while holding ci->lock;
the slow path does this after reacquiring all allocator locks.  Allocation
failures now free only unpublished resources.

Fixes: b197d41462c2 ("mm/memcg, swap: store cgroup id in cluster table directly")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/swapfile.c | 167 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 117 insertions(+), 50 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 78b49b0658ad..2ca947c540e9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -410,6 +410,99 @@ static inline unsigned int cluster_offset(struct swap_info_struct *si,
 	return cluster_index(si, ci) * SWAPFILE_CLUSTER;
 }
 
+struct swap_cluster_tables {
+	struct swap_table *table;
+#ifdef CONFIG_MEMCG
+	struct swap_memcg_table *memcg_table;
+#endif
+#if !SWAP_TABLE_HAS_ZEROFLAG
+	unsigned long *zero_bitmap;
+#endif
+};
+
+static void swap_cluster_tables_free(struct swap_cluster_tables *tables)
+{
+#ifdef CONFIG_MEMCG
+	kfree(tables->memcg_table);
+	tables->memcg_table = NULL;
+#endif
+
+#if !SWAP_TABLE_HAS_ZEROFLAG
+	kfree(tables->zero_bitmap);
+	tables->zero_bitmap = NULL;
+#endif
+
+	if (!tables->table)
+		return;
+
+	if (SWP_TABLE_USE_PAGE)
+		folio_put(virt_to_folio(tables->table));
+	else
+		kmem_cache_free(swap_table_cachep, tables->table);
+	tables->table = NULL;
+}
+
+static int swap_cluster_tables_alloc(struct swap_cluster_tables *tables,
+				     gfp_t gfp)
+{
+	struct folio *folio;
+
+	if (SWP_TABLE_USE_PAGE) {
+		folio = folio_alloc(gfp | __GFP_ZERO, 0);
+		if (folio)
+			tables->table = folio_address(folio);
+	} else {
+		tables->table = kmem_cache_zalloc(swap_table_cachep, gfp);
+	}
+	if (!tables->table)
+		return -ENOMEM;
+
+#ifdef CONFIG_MEMCG
+	if (!mem_cgroup_disabled()) {
+		tables->memcg_table = kzalloc_obj(*tables->memcg_table, gfp);
+		if (!tables->memcg_table)
+			goto free_tables;
+	}
+#endif
+
+#if !SWAP_TABLE_HAS_ZEROFLAG
+	tables->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
+	if (!tables->zero_bitmap)
+		goto free_tables;
+#endif
+
+	return 0;
+
+#if defined(CONFIG_MEMCG) || !SWAP_TABLE_HAS_ZEROFLAG
+free_tables:
+	swap_cluster_tables_free(tables);
+	return -ENOMEM;
+#endif
+}
+
+static void swap_cluster_tables_install(struct swap_cluster_info *ci,
+					struct swap_cluster_tables *tables)
+{
+	lockdep_assert_held(&ci->lock);
+	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
+	VM_WARN_ON_ONCE(rcu_access_pointer(ci->table));
+
+#ifdef CONFIG_MEMCG
+	VM_WARN_ON_ONCE(ci->memcg_table);
+	ci->memcg_table = tables->memcg_table;
+	tables->memcg_table = NULL;
+#endif
+
+#if !SWAP_TABLE_HAS_ZEROFLAG
+	VM_WARN_ON_ONCE(ci->zero_bitmap);
+	ci->zero_bitmap = tables->zero_bitmap;
+	tables->zero_bitmap = NULL;
+#endif
+
+	rcu_assign_pointer(ci->table, tables->table);
+	tables->table = NULL;
+}
+
 static void swap_cluster_free_table_folio_rcu_cb(struct rcu_head *head)
 {
 	struct folio *folio;
@@ -446,50 +539,6 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 		 swap_cluster_free_table_folio_rcu_cb);
 }
 
-static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
-{
-	struct swap_table *table = NULL;
-	struct folio *folio;
-
-	/* The cluster must be empty and not on any list during allocation. */
-	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
-	if (rcu_access_pointer(ci->table))
-		return 0;
-
-	if (SWP_TABLE_USE_PAGE) {
-		folio = folio_alloc(gfp | __GFP_ZERO, 0);
-		if (folio)
-			table = folio_address(folio);
-	} else {
-		table = kmem_cache_zalloc(swap_table_cachep, gfp);
-	}
-	if (!table)
-		return -ENOMEM;
-
-	rcu_assign_pointer(ci->table, table);
-
-#ifdef CONFIG_MEMCG
-	if (!mem_cgroup_disabled()) {
-		VM_WARN_ON_ONCE(ci->memcg_table);
-		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
-		if (!ci->memcg_table) {
-			swap_cluster_free_table(ci);
-			return -ENOMEM;
-		}
-	}
-#endif
-
-#if !SWAP_TABLE_HAS_ZEROFLAG
-	VM_WARN_ON_ONCE(ci->zero_bitmap);
-	ci->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
-	if (!ci->zero_bitmap) {
-		swap_cluster_free_table(ci);
-		return -ENOMEM;
-	}
-#endif
-	return 0;
-}
-
 /*
  * Sanity check to ensure nothing leaked, and the specified range is empty.
  * One special case is that bad slots can't be freed, so check the number of
@@ -527,6 +576,7 @@ static struct swap_cluster_info *
 swap_cluster_populate(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci)
 {
+	struct swap_cluster_tables tables = {};
 	int ret;
 
 	/*
@@ -538,9 +588,12 @@ swap_cluster_populate(struct swap_info_struct *si,
 		lockdep_assert_held(&si->global_cluster_lock);
 	lockdep_assert_held(&ci->lock);
 
-	if (!swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					  __GFP_NOWARN))
+	ret = swap_cluster_tables_alloc(&tables, __GFP_HIGH | __GFP_NOMEMALLOC |
+					       __GFP_NOWARN);
+	if (!ret) {
+		swap_cluster_tables_install(ci, &tables);
 		return ci;
+	}
 
 	/*
 	 * Try a sleep allocation. Each isolated free cluster may cause
@@ -552,8 +605,8 @@ swap_cluster_populate(struct swap_info_struct *si,
 		spin_unlock(&si->global_cluster_lock);
 	local_unlock(&percpu_swap_cluster.lock);
 
-	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					   GFP_KERNEL);
+	ret = swap_cluster_tables_alloc(&tables, __GFP_HIGH | __GFP_NOMEMALLOC |
+						GFP_KERNEL);
 
 	/*
 	 * Back to atomic context. We might have migrated to a new CPU with a
@@ -568,11 +621,19 @@ swap_cluster_populate(struct swap_info_struct *si,
 		spin_lock(&si->global_cluster_lock);
 	spin_lock(&ci->lock);
 
+	/* Nothing except this helper should populate an isolated cluster. */
+	if (WARN_ON_ONCE(cluster_table_is_alloced(ci))) {
+		swap_cluster_tables_free(&tables);
+		return ci;
+	}
+
 	if (ret) {
 		move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 		spin_unlock(&ci->lock);
 		return NULL;
 	}
+
+	swap_cluster_tables_install(ci, &tables);
 	return ci;
 }
 
@@ -788,6 +849,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 				       struct swap_cluster_info *cluster_info,
 				       unsigned int offset, bool mask)
 {
+	struct swap_cluster_tables tables = {};
 	unsigned int ci_off = offset % SWAPFILE_CLUSTER;
 	unsigned long idx = offset / SWAPFILE_CLUSTER;
 	struct swap_cluster_info *ci;
@@ -812,9 +874,14 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 
 	ci = cluster_info + idx;
 	/* Need to allocate swap table first for initial bad slot marking. */
-	if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL))
-		return -ENOMEM;
+	if (!ci->count) {
+		ret = swap_cluster_tables_alloc(&tables, GFP_KERNEL);
+		if (ret)
+			return ret;
+	}
 	spin_lock(&ci->lock);
+	if (tables.table)
+		swap_cluster_tables_install(ci, &tables);
 	/* Check for duplicated bad swap slots. */
 	if (__swap_table_xchg(ci, ci_off, SWP_TB_BAD) != SWP_TB_NULL) {
 		pr_warn("Duplicated bad slot offset %d\n", offset);
-- 
2.43.0


