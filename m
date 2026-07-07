Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF65DC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E52806B00B0; Tue,  7 Jul 2026 02:40:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6396B00B1; Tue,  7 Jul 2026 02:40:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B1D6B00B3; Tue,  7 Jul 2026 02:40:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BEF86B00B0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:40:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19DE71402EE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:32 +0000 (UTC)
X-FDA: 84961031904.19.B2DC5F4
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6BF7980007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf30.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j4UENZB+HWFRDlCg9OmfmmBkmAi/o5PsG5HzoFk47SI=;
	b=MVms+0c+QrL9WaDLJDO9R6BO0PLRUT6hY75ml4ouN16b0whwkXZ9oC8bHr/YLehXaBaSdy
	cfLHuhQ8oZVGafGFAINupda2k6N17AZCKPw9BrorJ1u6RfaLHEvT6ovJlOincEeyC10AyD
	Q3VqqnZxBgx1Ej6ofCr/I3E5vfTI3zk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf30.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406430;
	b=LMJSIaTjI8VJQUlR/iQkIC/6ZcFB3Qz5zCNtezatCp0a8puTnuz9f37Ef1b99mpDGaOZFP
	tJE9E6CLC3aJVxVfjtn5aeiouUANp1jq1zi7G8Z7nmHuQgTqZufzl5uLxDUEZIFaEoeiDj
	CSXdItUII15GnflQm9xXAVAFPJFR2SU=
Received: from TW006-1.hihonor.com (unknown [10.77.215.153])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gvWnK0Dt9zYm8sx;
	Tue,  7 Jul 2026 14:40:21 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW006-1.hihonor.com
 (10.77.215.153) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
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
Subject: [RFC PATCH v2 12/13] mm: shared semaphores for ANON_VMA_FRACTAL
Date: Tue, 7 Jul 2026 14:33:07 +0800
Message-ID: <20260707063308.29176-13-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260707063308.29176-1-tao.wangtao@honor.com>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW002-1.hihonor.com (10.72.0.137) To TA003.hihonor.com
 (10.72.0.43)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6BF7980007
X-Stat-Signature: pgezpamfwnjh6j5bfqjokwsnqr5zq64n
X-Rspam-User: 
X-HE-Tag: 1783406429-371169
X-HE-Meta: U2FsdGVkX18xP/PsVSAvJNBhkIf3x47KJH3X/rJu3ZaOMBjQYfLvJ9Dr1mpnouRWvjPSTX6DCylJALij5dShIzObbppuvV/nNDpHwwvNyOryxyZtuk5lYbclvYMj3vEDnfBGNFB8eCKuYxqfddaFFhKqmfEPkJpZ5KOyRxtuh8wLwnm4I+JjtNXUEK1YLAk8k2lUAwcxGkL+o0X5FiVJVb7ZAOsV8BJd0zVbacgp5ehhGWKXMGdTC7Nm5fp3GIlXFv3tX8/GHGqgL8gn63+epOD6/H91uGqY6ja/ht7huFuy27Z4k/04wiThyATDIttaAVi9yeZb1tG5Id7tyOTy2lAb/fHtRYjjLfxgVQczoubk9r0tWZzlPdwClGPlYvaDd6VuMZRyLic709l9ygdLrC5EuZWLVKfRCZwEA3zp6qNJGFHwUjj/JVIXsR/AQ3JK2gcjiraDXdvMNVPC0m7ypSK9SUz0RThVs4U+1ChuRerUBY0w0lYlgNWFwZLam4whdj3pwx4JeIQcW4DarTjAZ/NyosxEqJee8rMbNWHN4NK13RmTrnouFFETmS9gtUdAnpdToAKoyu2H+nwSs3Bvr4PK5gG9JnB9cGWArH5hEDBsbsxq639qdSQJtfasCRi14FtQmWfyEyt48hC1Yn8mgZzdiJ9foLxP5cUB1yE+U2JDDTuOp6WxcGYLwrGhvUXsQ3jK8ChlYxoSwCggDkqE96XWaa5/exZrnFW5fYiWQdvLBzGgGLA8UjopRNpsHw0AlcbqOgZABk/uylFLjGNn9UNsGbRqijuchtxc0jFWea5+lkdcP3AghQv3oPA9ZzCbjHupA2wZwhfJJY9c3bjl94StdYdKwfoQ/VdMXDKVzWV1yZglh6UevqIWm0CozCPUmVvkV3UKxsl1Kyg0o5X/8lVwMYazEqfVAO2wtxN5EgRjLBG4d8tq1VGGI59Orqsp3mXU3kVLbuMKBNe1Jrq
 8KB30Vrk
 9EVyhrjA7xXWa0B8bBk1CndpTANF0OcnRyZA8Rcm+HXkWRpP9a+Z5aFXlpH5t2y5aqjmWvMsYNgJZ9np7GGYzb5LQaD5hg+LmFk2PoJzEASMxWatfgFxSiCi7gPAJ/w5XRy0YvTtodDC3fuTohC7azwgeBxvUUdZofSZD7JFql0lnySKP45bD+MMGFiFMNspMCOJSXSdCQRTNvuLx/GVIeK2u1BkKUxteUaaTzm0nzaZJlb6TEAAgIwXnt1ieiKLNNcOajNctdQ5Nc/OFzPmMef7arPO5ncJW7CO/8CNw8GOqAfdRV0jMRbEpuSIa/4bcb2GFtfQ43fvLh+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use shared semaphores for anon_node to reduce memory overhead, as rmap
operations rarely run concurrently and fork/delete updates are
short-lived.

To reduce the fork impact of shared semaphores, reuse the root anon_node's
unused parent pointer to store a dedicated semaphore. Revalidate the lock
when acquiring it in rmap paths, since it may change.

Export rwsem_is_write_locked() in rwsem.h, and use it together with
rwsem_is_locked() to detect whether anon_node is in rmap, which can
reduce lock contention.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 include/linux/rmap.h  |   7 ++-
 include/linux/rwsem.h |  10 ++++
 mm/Kconfig            |   9 +++
 mm/rmap.c             | 134 +++++++++++++++++++++++++++++++++++++++---
 4 files changed, 152 insertions(+), 8 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 81ad29f3c392..50919c66c368 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -75,11 +75,16 @@ struct anon_vma {
 /* struct anon_node - Replace anon_vma for anonymous page reverse mapping. */
 struct anon_node {
 	struct anon_node *root;		/* Root of this anon_node fractal tree */
+#ifndef CONFIG_ANON_VMA_SHARED_SEMS
 	struct rw_semaphore rwsem;
 	atomic_t vm_lock_ref;		/* for vm_lock_anon_vma */
+#endif
 	atomic_t refcount;
 
-	struct anon_node *parent;	/* NULL if created by a page fault */
+	union {
+		struct anon_node *parent;		/* depth > 1 */
+		struct anon_semaphore *root_anon_sema;	/* depth == 1 */
+	};
 
 	/*
 	 * depth is initialized to 0. When a child is added, depth is set to 1.
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 6a1a7bae5f81..bc50a00a2c00 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -75,6 +75,11 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 	return atomic_long_read(&sem->count) != RWSEM_UNLOCKED_VALUE;
 }
 
+static inline int rwsem_is_write_locked(struct rw_semaphore *sem)
+{
+	return atomic_long_read(&sem->count) & RWSEM_WRITER_LOCKED;
+}
+
 static inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
 	__assumes_ctx_lock(sem)
 {
@@ -181,6 +186,11 @@ static __always_inline int rwsem_is_locked(const struct rw_semaphore *sem)
 	return rw_base_is_locked(&sem->rwbase);
 }
 
+static inline int rwsem_is_write_locked(struct rw_semaphore *sem)
+{
+	return rw_base_is_write_locked(&sem->rwbase);
+}
+
 static __always_inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
 	__assumes_ctx_lock(sem)
 {
diff --git a/mm/Kconfig b/mm/Kconfig
index c4c6d3e52d72..1b909819035d 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1479,6 +1479,15 @@ config ANON_VMA_FRACTAL
 	  during rmap walks. Since rmap_one operations may switch tasks,
 	  semaphores are still required instead of spinlock_t protection.
 
+config ANON_VMA_SHARED_SEMS
+	bool "anon_vma shared semaphores"
+	def_bool n
+	depends on ANON_VMA_FRACTAL
+	help
+	  As rmap operations rarely run concurrently, and fork/delete updates
+	  are very short, a group of shared semaphores is used to reduce
+	  memory overhead.
+
 config IOMMU_MM_DATA
 	bool
 
diff --git a/mm/rmap.c b/mm/rmap.c
index d1099a2fef0a..3cb516b80eb2 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -559,6 +559,11 @@ void __init anon_vma_init(void)
 			SLAB_PANIC|SLAB_ACCOUNT);
 }
 
+static inline struct rw_semaphore *anon_root_rmap_sem(struct anon_vma *root)
+{
+	return &root->rwsem;
+}
+
 void __put_anon_vma(struct anon_vma *anon_vma)
 {
 	struct anon_vma *root = anon_vma->root;
@@ -571,25 +576,82 @@ void __put_anon_vma(struct anon_vma *anon_vma)
 #else
 
 static struct kmem_cache *anon_node_cachep;
+static struct kmem_cache *anon_sema_cachep;
+
+/* Since rmap operations rarely run concurrently, use shared anon_root_sems. */
+#define ANON_NODE_RMAP_SEMS_BITS	12
+#define ANON_NODE_RMAP_SEMS_COUNT	(1 << ANON_NODE_RMAP_SEMS_BITS)
+
+struct anon_semaphore {
+	struct rw_semaphore sem;
+	atomic_t vm_lock_ref;	/* for vm_lock_anon_vma */
+};
+
+#ifdef CONFIG_ANON_VMA_SHARED_SEMS
+static struct anon_semaphore anon_node_root_semas[ANON_NODE_RMAP_SEMS_COUNT];
 
+static inline struct anon_semaphore *anon_root_anon_sema(struct anon_node *root)
+{
+	return (root->depth == 1 && root->root_anon_sema) ?
+		root->root_anon_sema :
+		&anon_node_root_semas[hash_ptr(root, ANON_NODE_RMAP_SEMS_BITS)];
+}
+#endif
 
+static inline void anon_sema_init(struct anon_semaphore *anon_sema)
+{
+	init_rwsem(&anon_sema->sem);
+	atomic_set(&anon_sema->vm_lock_ref, 0);
+}
+
+static inline void anon_root_sema_free(struct anon_semaphore *root_sema)
+{
+	VM_BUG_ON(rwsem_is_locked(&root_sema->sem));
+	kmem_cache_free(anon_sema_cachep, root_sema);
+}
+
+static inline struct anon_semaphore *anon_root_sema_alloc(void)
+{
+	struct anon_semaphore *root_sema;
+
+	root_sema = kmem_cache_alloc(anon_sema_cachep, GFP_KERNEL);
+	if (!root_sema)
+		return NULL;
+	anon_sema_init(root_sema);
+	return root_sema;
+}
+
+static inline struct rw_semaphore *anon_root_rmap_sem(struct anon_node *root)
+{
+#ifdef CONFIG_ANON_VMA_SHARED_SEMS
+	return &anon_root_anon_sema(root)->sem;
+#else
+	return &root->rwsem;
+#endif
+}
 
 static inline struct rw_semaphore *anon_node_rmap_sem(struct anon_node *node)
 {
-	return &node->root->rwsem;
+	return anon_root_rmap_sem(node->root);
 }
 
 static inline atomic_t *anon_node_vm_lock_ref(struct anon_node *node)
 {
+#ifdef CONFIG_ANON_VMA_SHARED_SEMS
+	return &anon_root_anon_sema(node->root)->vm_lock_ref;
+#else
 	return &node->root->vm_lock_ref;
+#endif
 }
 
 static void anon_node_ctor(void *data)
 {
 	struct anon_node *anon_nod = data;
 
+#ifndef CONFIG_ANON_VMA_SHARED_SEMS
 	init_rwsem(&anon_nod->rwsem);
 	atomic_set(&anon_nod->vm_lock_ref, 0);
+#endif
 	atomic_set(&anon_nod->refcount, 0);
 }
 
@@ -600,10 +662,16 @@ void __init anon_vma_init(void)
 		.freeptr_offset = offsetof(struct anon_node, fractal_list),
 		.ctor = anon_node_ctor,
 	};
+#ifdef CONFIG_ANON_VMA_SHARED_SEMS
+	int i;
 
+	for (i = 0; i < ANON_NODE_RMAP_SEMS_COUNT; i++)
+		anon_sema_init(&anon_node_root_semas[i]);
+#endif
 	anon_node_cachep = kmem_cache_create("anon_node",
 			sizeof(struct anon_node), &args,
 			SLAB_TYPESAFE_BY_RCU|SLAB_PANIC|SLAB_ACCOUNT);
+	anon_sema_cachep = KMEM_CACHE(anon_semaphore, SLAB_PANIC|SLAB_ACCOUNT);
 }
 
 static inline void anon_node_free(struct anon_node *anon_nod)
@@ -621,6 +689,12 @@ static inline void anon_node_free(struct anon_node *anon_nod)
 		up_write(rmap_sem);
 	}
 
+#ifdef CONFIG_ANON_VMA_SHARED_SEMS
+	if (anon_nod->depth == 1 && anon_nod->root_anon_sema) {
+		anon_root_sema_free(anon_nod->root_anon_sema);
+		anon_nod->root_anon_sema = NULL;
+	}
+#endif
 	kmem_cache_free(anon_node_cachep, anon_nod);
 }
 
@@ -736,12 +810,17 @@ static inline struct anon_node *vma_anon_node(struct vm_area_struct *vma)
 	return vma ? (struct anon_node *)vma->anon_vma : NULL;
 }
 
+static inline bool no_rmap_reader(struct rw_semaphore *rmap_sem)
+{
+	return !rwsem_is_locked(rmap_sem) || rwsem_is_write_locked(rmap_sem);
+}
+
 static inline void vma_set_anon_node(struct vm_area_struct *vma,
 		struct anon_node *anon_nod, bool is_locked)
 {
 	struct rw_semaphore *rmap_sem = anon_node_rmap_sem(anon_nod);
 
-	if (is_locked) {
+	if (is_locked || no_rmap_reader(rmap_sem)) {
 		vma->anon_vma = (struct anon_vma *)anon_nod;
 		return;
 	}
@@ -758,8 +837,22 @@ static int anon_node_add_child(struct anon_node *anon_nod,
 	struct rw_semaphore *rmap_sem = anon_node_rmap_sem(root);
 	struct anon_node *rbc_ch = anon_nod, *next;
 
-	if (root->depth == 0)
+	if (root->depth == 0) {
+#ifdef CONFIG_ANON_VMA_SHARED_SEMS
+		struct anon_semaphore *root_sema = anon_root_sema_alloc();
+
+		if (!root_sema)
+			return -ENOMEM;
+		down_write(rmap_sem);
+		if (cmpxchg(&root->root_anon_sema, NULL, root_sema) != NULL)
+			anon_root_sema_free(root_sema);
+		root->depth = 1;
+		up_write(rmap_sem);
+#else
 		root->depth = 1;
+#endif
+	}
+
 	child = anon_node_alloc(vma, anon_nod, rmap_base, is_fork);
 	if (!child)
 		return -ENOMEM;
@@ -1025,14 +1118,34 @@ void vm_unlock_anon_node(struct anon_node *anon_nod)
 	}
 }
 
+static struct rw_semaphore *anon_node_lock_rmap_and_verify(
+		struct anon_node *anon_nod, bool trylock)
+{
+	struct anon_node *root = anon_nod->root;
+	struct rw_semaphore *rmap_sem = anon_node_rmap_sem(root);
+
+	while (true) {
+		if (trylock) {
+			if (!down_read_trylock(rmap_sem))
+				return NULL;
+		} else {
+			down_read(rmap_sem);
+		}
+		if (rmap_sem == anon_node_rmap_sem(root))
+			return rmap_sem;
+		up_read(rmap_sem);
+		rmap_sem = anon_node_rmap_sem(root);
+	}
+}
+
 int anon_node_trylock_rmap(struct anon_node *anon_nod)
 {
-	return down_read_trylock(anon_node_rmap_sem(anon_nod));
+	return (bool)anon_node_lock_rmap_and_verify(anon_nod, true);
 }
 
 void anon_node_lock_rmap(struct anon_node *anon_nod)
 {
-	down_read(anon_node_rmap_sem(anon_nod));
+	anon_node_lock_rmap_and_verify(anon_nod, false);
 }
 
 void anon_node_unlock_rmap(struct anon_node *anon_nod)
@@ -1158,6 +1271,7 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 {
 	struct anon_vma *anon_vma = NULL;
 	struct anon_vma *root_anon_vma;
+	struct rw_semaphore *root_rwsem;
 	struct vm_area_struct *leaf_vma = NULL;
 	struct mm_struct *other_mm = NULL;
 	unsigned long anon_mapping;
@@ -1182,14 +1296,20 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 	if (unlikely(other_mm))
 		mmgrab(other_mm); /* put vma after unlock. */
 #endif
-	if (down_read_trylock(&root_anon_vma->rwsem)) {
+trylock_agian:
+	root_rwsem = anon_root_rmap_sem(root_anon_vma);
+	if (down_read_trylock(root_rwsem)) {
+		if (root_rwsem != anon_root_rmap_sem(root_anon_vma)) {
+			up_read(root_rwsem);
+			goto trylock_agian;
+		}
 		/*
 		 * If the folio is still mapped, then this anon_vma is still
 		 * its anon_vma, and holding the mutex ensures that it will
 		 * not go away, see anon_vma_free().
 		 */
 		if (!folio_mapped(folio)) {
-			up_read(&root_anon_vma->rwsem);
+			up_read(root_rwsem);
 			anon_vma = NULL;
 		}
 		goto out;
-- 
2.17.1


