Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A51DC43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A0B46B00A6; Tue,  7 Jul 2026 02:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B2F6B00AD; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB84B6B00AD; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8BC6B00AD
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE75A1402F7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:26 +0000 (UTC)
X-FDA: 84961031652.24.1F88915
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf01.hostedemail.com (Postfix) with ESMTP id 997414000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf01.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HcK48d4OSHDOyDbxizTk/ARCyVJZYvsIZbWn+964lDw=;
	b=tp86sdJ75DLfLb6Q3jX2ixSuzI0Qu6idqIyDqVkfYYxeelZdV0zu/n+FmAnCxlXHfXukGH
	bJNMMJQAeJkieeB4wQXIYW6W1KwcYi7vkKUufY+E5py4Q/FT9yevf5Cm+6o1/Tw3PhkJC1
	0tbnLtVVVLZw9v7RQvYfI3YWhnX1zXA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf01.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406425;
	b=Y0BC51Y/gAj+UBQ45Sl1x8A+DqlTbYld0UXgCWUG7QxeKVlqXqI6ox7vFsM1Tww5RsWiI1
	+IyGN8JEOmW77Yr4qRW24RzGwPuFN/D39zxac4vVTSLgGxRwZO2seO+wFHDBvnt7pMzc6z
	cNv+c0ilrX73HbWVD7doWPqRP4pvWwM=
Received: from TW003.hihonor.com (unknown [10.77.199.161])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gvWnJ3Xg8zYm8sp;
	Tue,  7 Jul 2026 14:40:20 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW003.hihonor.com
 (10.77.199.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Tue, 7 Jul
 2026 14:40:18 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 14:40:19 +0800
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
Subject: [RFC PATCH v2 10/13] mm: replace anon_vma with anon_node for ANON_VMA_FRACTAL
Date: Tue, 7 Jul 2026 14:33:05 +0800
Message-ID: <20260707063308.29176-11-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260707063308.29176-1-tao.wangtao@honor.com>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW002-1.hihonor.com (10.72.0.137) To TA003.hihonor.com
 (10.72.0.43)
X-Stat-Signature: h5cmz4fjk4dp7bgy4ax6reytdfygi3t4
X-Rspamd-Queue-Id: 997414000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783406424-308334
X-HE-Meta: U2FsdGVkX1/I1fz6GpK5pRkwc2+AZi1t1BUxvDpmcTv5v3nQaFH7MHyKxC5I2MMdZvfMIvnNOFYSXH4K/Go715GYxn41/Njk5BlqeVKjd4IhaCide2IoCV4liZdFo99qOHVVAMNaEo3tWF+cB6RQ90J0M778Q+5DBWITczuUDttS8y+wkuINIy2lUL3dqEn52Voo/gSLiEJCej21Cm4GgrXf6QEI86yujuYkwdJFe/F5M3n72uva/9589GN9A0VhYA+eAKNSZCQrjEhCC+EAFlUuMDMY09td1Yewj6T0Zir5IBVVHWpMHTjOn4njSUbS/ZzaLU68Jp+5kU+GchZy850ayMeyYlsdUiUFPGBFex+ITeL9LuQS6SfsdJBOHxUdIPaJlATWE5c0l6PNd1kug9Cezu0Mu1DqVENyG0MYhbtojDTxDo5uGHloR1oLfFjkspZDDw0/WXMUdKhwqVuWTqcEiHq0Ih8UZlyyI0l9NOe7J2TDNiHU5XUYtfLhquuZE2vms71mrQvOv8Zeqdm3AgeNXftykBNNBE+Y4VLEObm9ds/xJyBvqGFoXCAWBPFAnw8NnMZypc3UYdtS8C4cUf9LGcKP/DdXTsulHDO7Bw5BiHUaJHesDX7n3PZrDFnCjfdfs/BUOKaVNAq3J5CeyJv6qhKwi6MbnwrTt/fyJi9cn9js2iPfoem5/l1mVDvfgNEuYh9EDBA61cX8rg3KowDOpmcZyU3UwJ0m+HW+7QU1cn7LyFd8O4qAD35UCiNOtJCM5oDcjjC/jo+SIGrm9CBOufjui4HvqAeTXmAQ+PmHdkbqDQZSq7t6GxSvyA3ZbWoClRmx/2wHdlnD0MJ8ycHMxM+HqwYnazje0bU7o06Vea6c4oDy43tjSfF+Zx3lXJ1gD2MSzBucxIo/1oL8pZMJUGHtSh7dBGpNq6wPUj3ccFIlebJ1M75v5nAaWLNRXv6v4XqlsYJQumZODie
 qa8qL1iS
 PE8GvVH2kgUNTWZ5B5nps212VWZazB3rrcJuuilugTBlvGsNXFUbUzeYpx+4YXH9Tah751Fakn9HN1gtj9POHg4QQiZt7TQ4HmdGHNprOo7Evj96o1FWUH8d8OqjP53PMrSrBZwJJVdlCKqbQK6zvXNuUk9wRus2ASpX8tD8HvfcoTAwRrAtWG3SrVIEBLL08ZCT7DD24yh6cVH0AKVX7ttUAJg1btrqQ+GqqXrGvC+h5rEOEomZ+bqCZnCVB10gfDdZTl6n6gWIs0JVI73PdmIwChOxAgEA12MIqzvFaYgLw0Vhi9/JW1wzJK/3fhTtHcrghKdklxWQqJOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace anon_vma with anon_node while keeping existing APIs to
minimize code changes.

Remove anon_vma_chain from VMA to save 16 bytes on 64-bit.

Use ANON_RMAP_FOREACH_VMA for anonymous reverse mapping walks in
ksm.c, memory-failure.c, and rmap.c.

Keep CONFIG_ANON_VMA_FRACTAL enabling in a separate patch for
easier control.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 include/linux/mm.h       |  2 ++
 include/linux/mm_types.h |  2 ++
 include/linux/rmap.h     |  5 +++-
 mm/internal.h            | 58 +++++++++++++++++++++++++++++++++++-----
 mm/ksm.c                 | 19 ++++---------
 mm/memory-failure.c      |  8 ++----
 mm/mmap.c                |  7 ++---
 mm/rmap.c                | 43 +++++++++++++++--------------
 mm/vma.c                 |  4 +++
 mm/vma_init.c            |  2 ++
 10 files changed, 100 insertions(+), 50 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..3fc2f92040b0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -970,7 +970,9 @@ static inline void vma_init(struct vm_area_struct *vma, struct mm_struct *mm)
 	memset(vma, 0, sizeof(*vma));
 	vma->vm_mm = mm;
 	vma->vm_ops = &vma_dummy_vm_ops;
+#ifndef CONFIG_ANON_VMA_FRACTAL
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
+#endif
 	vma_lock_init(vma, false);
 }
 
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b18c2b2e7d2c..b98090e6cfdd 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -970,8 +970,10 @@ struct vm_area_struct {
 	 * can only be in the i_mmap tree.  An anonymous MAP_PRIVATE, stack
 	 * or brk vma (with NULL file) can only be in an anon_vma list.
 	 */
+#ifndef CONFIG_ANON_VMA_FRACTAL
 	struct list_head anon_vma_chain; /* Serialized by mmap_lock &
 					  * page_table_lock */
+#endif
 	struct anon_vma *anon_vma;	/* Serialized by page_table_lock */
 
 	/* Function pointers to deal with this struct. */
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 75738f4ede1f..81ad29f3c392 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -15,6 +15,7 @@
 #include <linux/memremap.h>
 #include <linux/bit_spinlock.h>
 
+#ifndef CONFIG_ANON_VMA_FRACTAL
 /*
  * The anon_vma heads a list of private "related" vmas, to scan if
  * an anonymous page pointing to this anon_vma needs to be unmapped:
@@ -67,7 +68,9 @@ struct anon_vma {
 	struct rb_root_cached rb_root;
 };
 
-#ifdef CONFIG_ANON_VMA_FRACTAL
+#else
+
+#define anon_node anon_vma
 
 /* struct anon_node - Replace anon_vma for anonymous page reverse mapping. */
 struct anon_node {
diff --git a/mm/internal.h b/mm/internal.h
index 6f0ff492a89c..205f1b5226aa 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -212,6 +212,7 @@ static inline unsigned long vma_rmap_base(const struct vm_area_struct *vma)
 	return rmap_base(vma->vm_start, vma->vm_pgoff);
 }
 
+#ifndef CONFIG_ANON_VMA_FRACTAL
 static inline void get_anon_vma(struct anon_vma *anon_vma)
 {
 	atomic_inc(&anon_vma->refcount);
@@ -255,7 +256,20 @@ static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
 	up_read(&anon_vma->root->rwsem);
 }
 
-#ifdef CONFIG_ANON_VMA_FRACTAL
+/* Provide unified anon_vma VMA iteration interfaces. */
+#define ANON_RMAP_FOREACH_VMA(anon_vma, addr, start, last, rmap_proc_vma) \
+do { \
+	struct vm_area_struct *vma; /* must be named vma */ \
+	struct rb_root_cached *_rb_root = &(anon_vma)->rb_root; \
+	struct anon_vma_chain *_avc; \
+	\
+	anon_vma_interval_tree_foreach(_avc, _rb_root, start, last) { \
+		vma = _avc->vma; \
+		(rmap_proc_vma); \
+	} \
+} while (0)
+
+#else
 
 static inline struct anon_node *anon_node_next_rbc_child(
 		struct anon_node *anon_nod, struct anon_node *node)
@@ -361,6 +375,36 @@ do { \
 	} \
 } while (0)
 
+static inline void get_anon_vma(struct anon_vma *anon_vma)
+{
+	get_anon_node((void *)anon_vma);
+}
+
+static inline void put_anon_vma(struct anon_vma *anon_vma)
+{
+	put_anon_node((void *)anon_vma);
+}
+
+/* Huge pages are protected by folio_lock(), these APIs no longer needed. */
+static inline void anon_vma_lock_write(struct anon_vma *anon_vma) {}
+static inline int anon_vma_trylock_write(struct anon_vma *anon_vma) { return 1; }
+static inline void anon_vma_unlock_write(struct anon_vma *anon_vma) {}
+
+/* These are still used as rmap lock APIs. */
+static inline void anon_vma_lock_read(struct anon_vma *anon_vma)
+{
+	anon_node_lock_rmap((void *)anon_vma);
+}
+
+static inline int anon_vma_trylock_read(struct anon_vma *anon_vma)
+{
+	return anon_node_trylock_rmap((void *)anon_vma);
+}
+
+static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
+{
+	anon_node_unlock_rmap((void *)anon_vma);
+}
 #endif
 
 struct anon_vma *folio_get_anon_vma(const struct folio *folio);
@@ -380,18 +424,20 @@ int  __anon_vma_prepare(struct vm_area_struct *vma);
 void unlink_anon_vmas(struct vm_area_struct *vma);
 
 #ifndef CONFIG_ANON_VMA_FRACTAL
+static inline int anon_vma_fork_with_prev(struct vm_area_struct *vma,
+	struct vm_area_struct *pvma, struct vm_area_struct *vma_prev,
+	struct vm_area_struct *pvma_prev)
+{
+	return anon_vma_fork(vma, pvma);
+}
 static inline int vma_pre_update_rmap_base(struct vm_area_struct *vma,
 	unsigned long diff) { return 0; }
 static inline void vma_post_update_rmap_base(struct vm_area_struct *vma,
 	unsigned long diff) {}
 #else
-int anon_node_clone(struct vm_area_struct *vma, struct vm_area_struct *src,
-	enum vma_operation operation);
-int anon_node_fork_with_prev(struct vm_area_struct *vma,
+int anon_vma_fork_with_prev(struct vm_area_struct *vma,
 	struct vm_area_struct *pvma, struct vm_area_struct *vma_prev,
 	struct vm_area_struct *pvma_prev);
-int __anon_node_prepare(struct vm_area_struct *vma);
-void unlink_anon_nodes(struct vm_area_struct *vma);
 /* relocate_vma_down() changes vma_rmap_base. */
 int vma_pre_update_rmap_base(struct vm_area_struct *vma, unsigned long diff);
 void vma_post_update_rmap_base(struct vm_area_struct *vma, unsigned long diff);
diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..176b4da494ea 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3174,8 +3174,6 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 		/* Ignore the stable/unstable/sqnr flags */
 		const unsigned long addr = rmap_item->address & PAGE_MASK;
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
-		struct anon_vma_chain *vmac;
-		struct vm_area_struct *vma;
 
 		cond_resched();
 		if (!anon_vma_trylock_read(anon_vma)) {
@@ -3186,11 +3184,8 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 			anon_vma_lock_read(anon_vma);
 		}
 
-		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
-					       0, ULONG_MAX) {
-
+		ANON_RMAP_FOREACH_VMA(anon_vma, addr, 0, ULONG_MAX, ({
 			cond_resched();
-			vma = vmac->vma;
 
 			if (addr < vma->vm_start || addr >= vma->vm_end)
 				continue;
@@ -3214,7 +3209,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 				anon_vma_unlock_read(anon_vma);
 				return;
 			}
-		}
+		}));
 		anon_vma_unlock_read(anon_vma);
 	}
 	if (!search_new_forks++)
@@ -3230,7 +3225,6 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 {
 	struct ksm_stable_node *stable_node;
 	struct ksm_rmap_item *rmap_item;
-	struct vm_area_struct *vma;
 	struct task_struct *tsk;
 
 	stable_node = folio_stable_node(folio);
@@ -3242,22 +3236,19 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 		anon_vma_lock_read(av);
 		rcu_read_lock();
 		for_each_process(tsk) {
-			struct anon_vma_chain *vmac;
 			unsigned long addr;
 			struct task_struct *t =
 				task_early_kill(tsk, force_early);
 			if (!t)
 				continue;
-			anon_vma_interval_tree_foreach(vmac, &av->rb_root, 0,
-						       ULONG_MAX)
-			{
-				vma = vmac->vma;
+			ANON_RMAP_FOREACH_VMA(av, rmap_item->address,
+					0, ULONG_MAX, ({
 				if (vma->vm_mm == t->mm) {
 					addr = rmap_item->address & PAGE_MASK;
 					add_to_kill_ksm(t, page, vma, to_kill,
 							addr);
 				}
-			}
+			}));
 		}
 		rcu_read_unlock();
 		anon_vma_unlock_read(av);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 51508a55c405..1f44e5f76a42 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -545,21 +545,17 @@ static void collect_procs_anon(const struct folio *folio,
 	pgoff = page_pgoff(folio, page);
 	rcu_read_lock();
 	for_each_process(tsk) {
-		struct vm_area_struct *vma;
-		struct anon_vma_chain *vmac;
 		struct task_struct *t = task_early_kill(tsk, force_early);
 		unsigned long addr;
 
 		if (!t)
 			continue;
-		anon_vma_interval_tree_foreach(vmac, &av->rb_root,
-					       pgoff, pgoff) {
-			vma = vmac->vma;
+		ANON_RMAP_FOREACH_VMA(av, 0, pgoff, pgoff, ({
 			if (vma->vm_mm != t->mm)
 				continue;
 			addr = page_mapped_in_vma(page, vma);
 			add_to_kill_anon_file(t, page, vma, to_kill, addr);
-		}
+		}));
 	}
 	rcu_read_unlock();
 	anon_vma_unlock_read(av);
diff --git a/mm/mmap.c b/mm/mmap.c
index 2311ae7c2ff4..c283e0de819a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1730,7 +1730,8 @@ bool mmap_read_lock_maybe_expand(struct mm_struct *mm,
 
 __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 {
-	struct vm_area_struct *mpnt, *tmp;
+	struct vm_area_struct *mpnt = NULL, *tmp = NULL;
+	struct vm_area_struct *prev = NULL, *tmp_prev = NULL;
 	int retval;
 	unsigned long charge = 0;
 	LIST_HEAD(uf);
@@ -1759,7 +1760,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		goto out;
 
 	mt_clear_in_rcu(vmi.mas.tree);
-	for_each_vma(vmi, mpnt) {
+	for ( ; (mpnt = vma_next(&vmi)) != NULL; prev = mpnt, tmp_prev = tmp) {
 		struct file *file;
 
 		retval = vma_start_write_killable(mpnt);
@@ -1800,7 +1801,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			 * copy page for current vma.
 			 */
 			tmp->anon_vma = NULL;
-		} else if (anon_vma_fork(tmp, mpnt))
+		} else if (anon_vma_fork_with_prev(tmp, mpnt, tmp_prev, prev))
 			goto fail_nomem_anon_vma_fork;
 		vm_flags_clear(tmp, VM_LOCKED_MASK);
 		/*
diff --git a/mm/rmap.c b/mm/rmap.c
index 12c6a1bdff3f..11239838b722 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -84,6 +84,7 @@
 #include "internal.h"
 #include "swap.h"
 
+#ifndef CONFIG_ANON_VMA_FRACTAL
 static struct kmem_cache *anon_vma_cachep;
 static struct kmem_cache *anon_vma_chain_cachep;
 
@@ -558,7 +559,16 @@ void __init anon_vma_init(void)
 			SLAB_PANIC|SLAB_ACCOUNT);
 }
 
-#ifdef CONFIG_ANON_VMA_FRACTAL
+void __put_anon_vma(struct anon_vma *anon_vma)
+{
+	struct anon_vma *root = anon_vma->root;
+
+	anon_vma_free(anon_vma);
+	if (root != anon_vma && atomic_dec_and_test(&root->refcount))
+		anon_vma_free(root);
+}
+
+#else
 
 static struct kmem_cache *anon_node_cachep;
 
@@ -581,7 +591,7 @@ static void anon_node_ctor(void *data)
 	atomic_set(&anon_nod->refcount, 0);
 }
 
-static inline void anon_vma_fractal_init(void)
+void __init anon_vma_init(void)
 {
 	struct kmem_cache_args args = {
 		.use_freeptr_offset = true,
@@ -621,6 +631,11 @@ void __put_anon_node(struct anon_node *anon_nod)
 		anon_node_free(root);
 }
 
+static inline void __put_anon_vma(struct anon_vma *anon_vma)
+{
+	__put_anon_node((struct anon_node *)(anon_vma));
+}
+
 static inline struct anon_node *anon_node_alloc(struct vm_area_struct *vma,
 		struct anon_node *parent, unsigned long rmap_base, bool is_fork)
 {
@@ -679,7 +694,7 @@ static bool try_reuse_anon_node(struct anon_node *anon_nod,
 }
 
 /* attach an anon_node to the VMA. */
-int __anon_node_prepare(struct vm_area_struct *vma)
+int __anon_vma_prepare(struct vm_area_struct *vma)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long rmap_base = vma_rmap_base(vma);
@@ -785,7 +800,7 @@ static int anon_node_track_rmap(struct anon_node *anon_nod,
 }
 
 /* vma clones src anon_node and increments the count. */
-int anon_node_clone(struct vm_area_struct *vma,  struct vm_area_struct *src,
+int anon_vma_clone(struct vm_area_struct *vma,  struct vm_area_struct *src,
 	enum vma_operation operation)
 {
 	struct anon_node *anon_nod = vma_anon_node(src);
@@ -827,7 +842,7 @@ static struct anon_node *fork_reuse_ancestor(struct anon_node *parent,
 }
 
 /* Clone an anon_node from prev or fork one from the parent pvma. */
-int anon_node_fork_with_prev(struct vm_area_struct *vma,
+int anon_vma_fork_with_prev(struct vm_area_struct *vma,
 	struct vm_area_struct *pvma, struct vm_area_struct *prev,
 	struct vm_area_struct *pvma_prev)
 {
@@ -921,7 +936,7 @@ static void release_anon_nodes(struct anon_node *anon_nod)
 }
 
 /* Remove link between this VMA and its anon_node. */
-void unlink_anon_nodes(struct vm_area_struct *vma)
+void unlink_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_node *anon_nod = vma_anon_node(vma);
 	struct rw_semaphore *rmap_sem;
@@ -3377,15 +3392,6 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
 EXPORT_SYMBOL_GPL(make_device_exclusive);
 #endif
 
-void __put_anon_vma(struct anon_vma *anon_vma)
-{
-	struct anon_vma *root = anon_vma->root;
-
-	anon_vma_free(anon_vma);
-	if (root != anon_vma && atomic_dec_and_test(&root->refcount))
-		anon_vma_free(root);
-}
-
 static struct anon_vma *rmap_walk_anon_lock(const struct folio *folio,
 					    struct rmap_walk_control *rwc)
 {
@@ -3433,7 +3439,6 @@ static void rmap_walk_anon(struct folio *folio,
 {
 	struct anon_vma *anon_vma;
 	pgoff_t pgoff_start, pgoff_end;
-	struct anon_vma_chain *avc;
 
 	/*
 	 * The folio lock ensures that folio->mapping can't be changed under us
@@ -3453,9 +3458,7 @@ static void rmap_walk_anon(struct folio *folio,
 
 	pgoff_start = folio_pgoff(folio);
 	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
-	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
-			pgoff_start, pgoff_end) {
-		struct vm_area_struct *vma = avc->vma;
+	ANON_RMAP_FOREACH_VMA(anon_vma, 0, pgoff_start, pgoff_end, ({
 		unsigned long address = vma_address(vma, pgoff_start,
 				folio_nr_pages(folio));
 
@@ -3469,7 +3472,7 @@ static void rmap_walk_anon(struct folio *folio,
 			break;
 		if (rwc->done && rwc->done(folio))
 			break;
-	}
+	}));
 
 	if (!locked)
 		anon_vma_unlock_read(anon_vma);
diff --git a/mm/vma.c b/mm/vma.c
index 02178112daa0..76294a7201ca 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -78,7 +78,11 @@ static bool vma_is_fork_child(struct vm_area_struct *vma)
 	 * parents. This can improve scalability caused by the anon_vma root
 	 * lock.
 	 */
+#ifndef CONFIG_ANON_VMA_FRACTAL
 	return vma && vma->anon_vma && !list_is_singular(&vma->anon_vma_chain);
+#else
+	return vma && vma->anon_vma && vma->anon_vma->depth > 1;
+#endif
 }
 
 static inline bool is_mergeable_vma(struct vma_merge_struct *vmg, bool merge_next)
diff --git a/mm/vma_init.c b/mm/vma_init.c
index 3c0b65950510..ffb7359ea47f 100644
--- a/mm/vma_init.c
+++ b/mm/vma_init.c
@@ -134,7 +134,9 @@ struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig)
 		return NULL;
 	}
 	vma_lock_init(new, true);
+#ifndef CONFIG_ANON_VMA_FRACTAL
 	INIT_LIST_HEAD(&new->anon_vma_chain);
+#endif
 	vma_numab_state_init(new);
 	dup_anon_vma_name(orig, new);
 
-- 
2.17.1


