Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F142C44500
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8156D6B00A3; Tue,  7 Jul 2026 02:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C4146B00A4; Tue,  7 Jul 2026 02:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1216B00A5; Tue,  7 Jul 2026 02:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 320376B00A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:40:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A9BC21C3414
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:24 +0000 (UTC)
X-FDA: 84961031568.28.82A08B6
Received: from mta22.hihonor.com (mta22.honor.com [81.70.192.198])
	by imf12.hostedemail.com (Postfix) with ESMTP id 426F440007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="b3/YRk8O";
	spf=pass (imf12.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGNtwVHfuVDy5GapbH+T8NwebC+tLhi7ZU1R2y5r9g8=;
	b=AzR/+3zO6XVTCvap70CAeSR1n2UVuhAFfDKTw/MU+s1Q1OJf+S3j8CXPgf11gp4k+DnyDv
	fhe/oFgwlguuM69SkMC4ajoedWH0pOjYcrsxhPceGzTDBRXsTj/ogn7FuSgdkTGCiJz9i1
	ZQmiMDCido6Uad1od/xJ0VwgnxTVA+I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="b3/YRk8O";
	spf=pass (imf12.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406423;
	b=pZbZj3WioQ0zU5fnQGitgMdONqXUOYLOG64fCbmw3Q1+nP7ssmIXVRRfukITSkhDY+qcP7
	lv6G50SjExzRGJ84Xb48Z/B6vFrnM4LciO1ZUaYC3lwpFLKTb04Ik7SOXjOX1yv7UMFcTK
	QBi/Ur0cHijt4LNY9EnLgotV32qNnqw=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=eGNtwVHfuVDy5GapbH+T8NwebC+tLhi7ZU1R2y5r9g8=;
	b=b3/YRk8OSyTll1bOdDjujqG3zEAoOB5TlFw9TniTtk0pgBWmZ2bmPswoyvedB1qA7LvzKEKcL
	iel5VYOceoV5h2u5MhuUu7/TjcpnpA3+YJPmDe668ma/zqzwfHadNEoLVsHx1yrCrGMyQ05Eiar
	IyBbFXI5GJKe4KY46n4C7qs=
Received: from TW002-1.hihonor.com (unknown [10.72.0.137])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4gvWnH4XhTzYlxNj;
	Tue,  7 Jul 2026 14:40:19 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW002-1.hihonor.com
 (10.72.0.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 14:40:19 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 14:40:18 +0800
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
Subject: [RFC PATCH v2 07/13] mm: handle rmap_base changes for ANON_VMA_FRACTAL
Date: Tue, 7 Jul 2026 14:33:02 +0800
Message-ID: <20260707063308.29176-8-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260707063308.29176-1-tao.wangtao@honor.com>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW002-1.hihonor.com (10.72.0.137) To TA003.hihonor.com
 (10.72.0.43)
X-Stat-Signature: geim8dw3q8stt1mfzphx8jqosjgbgq7d
X-Rspamd-Queue-Id: 426F440007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783406422-503226
X-HE-Meta: U2FsdGVkX18poW7xWemwNfthJySQLW1D8BcuOWilph9BMg+CO1yF2nnjGDLGbPaD6kVI/tUimWvVTq5UQVV6BQQc1Dnjsp6WGWGKWpKN+4PGOhCcC1X4GQFIZ6ydHPCKaOlvocK3CDG7qQYKdZw9BozTY6J7VURTYic+dFboWeUyeyc7kGZZDu39RqOZgfaEVHyALwnxTzAzifio47M0JsOXS84U0VmOIe8G/3Q2zst/+e3LJEUjSAa35X+5YdAc1+Xtt4r+txPjrxu9i60aoIK+eFv3YHeLpEdaQ15HDwsCfEF5dAmGsnJsJDNQRDnDE7kHn2ErweTCvKnqPvtlfLXdzxpb2KAxXivLCRPtcS1oDPUi1QZSgfIUYue2yvGsd7m1R17sAkTzQj59YtszcDob8KjYLPkietijmG1MQIKLfCTMbY5PytSw7CForVB7xAlZV2tcw5kz7/CtTNizFo9CzzI0GxaqyVmdeY75yck7ousj/qfSAoPpjhlyrjSi5NYoONBngkphxVWHbm8gPTWaY+qDT1YQbnX7oYT+eEwbXyfiGR8YqUW0r5YnCA1vdp1cKwDdFUEMPhlR6IhV27abXx886FQZADHmTOZY6nSWYOsSkgZOrQMUClae1zNCtd/JXSyLw5vXK1dpNy0jRfm5BcYB8+nLm9l1aL7ueQVumGYQ0DNWOE1MGM08vQwAQrE38kjXor0zSa8Dd0RaQ3Ib6TelMWFR9omOtfFqVluiZ26l7FcEz+/FAbSDrTKOmmPf5W+wwnTO4NPbpt34wJ1NOqJeu3/+gMylQZcP0Mmz1Ljf8HTeOhV4+qJ+OBD72LewtZ4ZupOn13nEQYgC80WC5jmyBDYbr3m7gwRnURfEdvv/vFXwIoQrCuRcWhB+TJ+0xeZtPNhSVz6uuVOSWw7bWOJ9AuYirx+rLWjpJHLc1qI9pk8uthylP9B36fC+3CzmMu9G64qQoRUB2Li
 ga2NVaXH
 5obFohcmZLFZUdNclpoKIgWLbTajhSlJ5Q2CKw1p0EmKukiABS7eg8vUP1WWjCBarkccOIiNM5UU+pcBSCNm3bYT52PxQWaPvhPvjihyScpHLuu5aCFgVMMDpTTIX9cKAzWzTbW4pefEn7pz9k9i1ICscLuiY7qBLQSbTO6le4yyTGbt7k4I0Cw5zmVopQNHl6g99//ad0fkGFWFqWerGJCKsjoLJUtExoLqZOp4qB7iYXOQjWgbIt+Lg9gwrZrLgxtn9KmmRm8CmlgqbzusQJ16M+Wh3VakzOtZKGW12saMH7MqUtpo6ED7jM+x973MTLlG1kSBD9Nifwdzr6ISm5Ovr7GarzN5N3Xf4K76LrzTbTh5gWS3UmS0i1/Q+8So2LaPH68WgCLQsljiSZjbYrSkxjwY4CEio9HRe2YuK6bI1/gA4TP5SXC6IJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

relocate_vma_down() updates vm_start without changing vm_pgoff, which
causes the VMA rmap_base to change.

track_rmap may need memory allocation and requires both old and new
rmap_base, so this cannot be handled inside
anon_vma_interval_tree_pre_update_vma() and
anon_vma_interval_tree_post_update_vma().

Introduce vma_pre_update_rmap_base() and
vma_post_update_rmap_base(), and call them before vma_prepare()
and after vma_complete() in vma_expand(), commit_merge(), and
vma_shrink(), where rmap_base may change.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 mm/internal.h | 10 ++++++++-
 mm/rmap.c     | 60 ++++++++++++++++++++++++++++++++++++++++-----------
 mm/vma.c      | 20 +++++++++++++++--
 3 files changed, 74 insertions(+), 16 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 710baf02575b..970f11b1af50 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -314,7 +314,12 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma);
 int  __anon_vma_prepare(struct vm_area_struct *vma);
 void unlink_anon_vmas(struct vm_area_struct *vma);
 
-#ifdef CONFIG_ANON_VMA_FRACTAL
+#ifndef CONFIG_ANON_VMA_FRACTAL
+static inline int vma_pre_update_rmap_base(struct vm_area_struct *vma,
+	unsigned long diff) { return 0; }
+static inline void vma_post_update_rmap_base(struct vm_area_struct *vma,
+	unsigned long diff) {}
+#else
 int anon_node_clone(struct vm_area_struct *vma, struct vm_area_struct *src,
 	enum vma_operation operation);
 int anon_node_fork_with_prev(struct vm_area_struct *vma,
@@ -322,6 +327,9 @@ int anon_node_fork_with_prev(struct vm_area_struct *vma,
 	struct vm_area_struct *pvma_prev);
 int __anon_node_prepare(struct vm_area_struct *vma);
 void unlink_anon_nodes(struct vm_area_struct *vma);
+/* relocate_vma_down() changes vma_rmap_base. */
+int vma_pre_update_rmap_base(struct vm_area_struct *vma, unsigned long diff);
+void vma_post_update_rmap_base(struct vm_area_struct *vma, unsigned long diff);
 
 #endif
 
diff --git a/mm/rmap.c b/mm/rmap.c
index ea3557d3b56c..fd22576b0f58 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -622,7 +622,7 @@ void __put_anon_node(struct anon_node *anon_nod)
 }
 
 static inline struct anon_node *anon_node_alloc(struct vm_area_struct *vma,
-		struct anon_node *parent, bool is_fork)
+		struct anon_node *parent, unsigned long rmap_base, bool is_fork)
 {
 	struct anon_node *anon_nod;
 
@@ -641,7 +641,7 @@ static inline struct anon_node *anon_node_alloc(struct vm_area_struct *vma,
 	anon_nod->nr_children = 0;
 	INIT_LIST_HEAD(&anon_nod->fractal_list);
 	anon_nod->mm = vma->vm_mm;
-	atomic_long_set(&anon_nod->rbc, vma_rmap_base(vma) + 1);
+	atomic_long_set(&anon_nod->rbc, rmap_base + 1);
 	return anon_nod;
 }
 
@@ -700,7 +700,7 @@ int __anon_node_prepare(struct vm_area_struct *vma)
 			return 0;
 	}
 
-	anon_nod = anon_node_alloc(vma, NULL, false);
+	anon_nod = anon_node_alloc(vma, NULL, rmap_base, false);
 	if (unlikely(!anon_nod))
 		return -ENOMEM;
 
@@ -734,7 +734,7 @@ static inline void vma_set_anon_node(struct vm_area_struct *vma,
 }
 
 static int anon_node_add_child(struct anon_node *anon_nod,
-	struct vm_area_struct *vma, bool is_fork)
+	struct vm_area_struct *vma, unsigned long rmap_base, bool is_fork)
 {
 	struct anon_node *child;
 	struct anon_node *root = anon_nod->root;
@@ -743,7 +743,7 @@ static int anon_node_add_child(struct anon_node *anon_nod,
 
 	if (root->depth == 0)
 		root->depth = 1;
-	child = anon_node_alloc(vma, anon_nod, is_fork);
+	child = anon_node_alloc(vma, anon_nod, rmap_base, is_fork);
 	if (!child)
 		return -ENOMEM;
 
@@ -764,10 +764,9 @@ static int anon_node_add_child(struct anon_node *anon_nod,
 
 /* Returns 0 on success, non-zero on failure. */
 static int anon_node_track_rmap(struct anon_node *anon_nod,
-		struct vm_area_struct *vma)
+		struct vm_area_struct *vma, unsigned long rmap_base)
 {
 	struct rw_semaphore *rmap_sem = anon_node_rmap_sem(anon_nod);
-	unsigned long rmap_base = vma_rmap_base(vma);
 	struct anon_node *rbc_ch = anon_nod;
 
 	if (try_track_rmap(anon_nod, rmap_base))
@@ -782,7 +781,7 @@ static int anon_node_track_rmap(struct anon_node *anon_nod,
 	if (rbc_ch)
 		return 0;
 
-	return anon_node_add_child(anon_nod, vma, false);
+	return anon_node_add_child(anon_nod, vma, rmap_base, false);
 }
 
 /* vma clones src anon_node and increments the count. */
@@ -796,7 +795,7 @@ int anon_node_clone(struct vm_area_struct *vma,  struct vm_area_struct *src,
 		return 0;
 
 	VM_BUG_ON_VMA(vma->anon_vma != (void *)anon_nod, vma);
-	return anon_node_track_rmap(anon_nod, vma);
+	return anon_node_track_rmap(anon_nod, vma, vma_rmap_base(vma));
 }
 
 static struct anon_node *fork_reuse_ancestor(struct anon_node *parent,
@@ -856,12 +855,13 @@ int anon_node_fork_with_prev(struct vm_area_struct *vma,
 		return 0;
 
 	/* 3) Fork a new anon_node. */
-	return anon_node_add_child(parent, vma, true);
+	return anon_node_add_child(parent, vma, rmap_base, true);
 }
 
 /* Returns true if untrack succeeds. */
 static bool anon_node_untrack_rmap_locked(struct anon_node *anon_nod,
-		struct vm_area_struct *vma, struct anon_node **release_node)
+		struct vm_area_struct *vma, unsigned long rmap_base,
+		struct anon_node **release_node)
 {
 	struct anon_node *root = anon_nod->root;
 	struct anon_node *node = anon_nod;
@@ -869,7 +869,7 @@ static bool anon_node_untrack_rmap_locked(struct anon_node *anon_nod,
 	bool test_empty = false;
 
 	do {
-		if (try_untrack_rmap(node, vma_rmap_base(vma), &test_empty))
+		if (try_untrack_rmap(node, rmap_base, &test_empty))
 			break;
 		node = anon_node_next_rbc_child(anon_nod, node);
 	} while (node);
@@ -938,7 +938,8 @@ void unlink_anon_nodes(struct vm_area_struct *vma)
 	down_write(rmap_sem);
 	anon_nod = vma_anon_node(vma); /* Recheck after locking. */
 	if (anon_nod) {
-		anon_node_untrack_rmap_locked(anon_nod, vma, &release_node);
+		anon_node_untrack_rmap_locked(anon_nod, vma,
+			vma_rmap_base(vma), &release_node);
 		vma->anon_vma = NULL;
 	}
 	up_write(rmap_sem);
@@ -947,6 +948,39 @@ void unlink_anon_nodes(struct vm_area_struct *vma)
 		release_anon_nodes(release_node);
 }
 
+int vma_pre_update_rmap_base(struct vm_area_struct *vma, unsigned long diff)
+{
+	struct anon_node *anon_nod = vma_anon_node(vma);
+	int err;
+
+	vma_assert_write_locked(vma);
+	if (!anon_nod || !diff)
+		return 0;
+
+	err = anon_node_track_rmap(anon_nod, vma, vma_rmap_base(vma) + diff);
+	if (!err)
+		down_write(anon_node_rmap_sem(anon_nod));
+	return err;
+}
+
+void vma_post_update_rmap_base(struct vm_area_struct *vma, unsigned long diff)
+{
+	struct anon_node *anon_nod = vma_anon_node(vma);
+	struct rw_semaphore *rmap_sem;
+	struct anon_node *release_node = NULL;
+
+	vma_assert_write_locked(vma);
+	if (!anon_nod || !diff)
+		return;
+
+	rmap_sem = anon_node_rmap_sem(anon_nod);
+	rwsem_assert_held_write(rmap_sem);
+	anon_node_untrack_rmap_locked(anon_nod, vma,
+		vma_rmap_base(vma) - diff, &release_node);
+	up_write(rmap_sem);
+	if (release_node)
+		release_anon_nodes(release_node);
+}
 
 #endif
 
diff --git a/mm/vma.c b/mm/vma.c
index 9eea2850818a..d2996369e30d 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -732,6 +732,7 @@ static int commit_merge(struct vma_merge_struct *vmg)
 {
 	struct vm_area_struct *vma;
 	struct vma_prepare vp;
+	unsigned long rbase_diff;
 
 	if (vmg->__adjust_next_start) {
 		/* We manipulate middle and adjust next, which is the target. */
@@ -748,12 +749,16 @@ static int commit_merge(struct vma_merge_struct *vmg)
 	/*
 	 * If vmg->give_up_on_oom is set, we're safe, because we don't actually
 	 * manipulate any VMAs until we succeed at preallocation.
-	 *
-	 * Past this point, we will not return an error.
 	 */
 	if (vma_iter_prealloc(vmg->vmi, vma))
 		return -ENOMEM;
 
+	rbase_diff = rmap_base(vmg->start, vmg->pgoff) - vma_rmap_base(vma);
+	if (rbase_diff && vma_pre_update_rmap_base(vma, rbase_diff)) {
+		vma_iter_free(vmg->vmi);
+		return -ENOMEM;
+	}
+
 	vma_prepare(&vp);
 	/*
 	 * THP pages may need to do additional splits if we increase
@@ -766,6 +771,8 @@ static int commit_merge(struct vma_merge_struct *vmg)
 	vma_iter_store_overwrite(vmg->vmi, vmg->target);
 
 	vma_complete(&vp, vmg->vmi, vma->vm_mm);
+	if (rbase_diff)
+		vma_post_update_rmap_base(vma, rbase_diff);
 
 	return 0;
 }
@@ -1248,6 +1255,7 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	       unsigned long start, unsigned long end, pgoff_t pgoff)
 {
 	struct vma_prepare vp;
+	unsigned long rbase_diff;
 
 	WARN_ON((vma->vm_start != start) && (vma->vm_end != end));
 
@@ -1261,6 +1269,12 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 	vma_start_write(vma);
 
+	rbase_diff = rmap_base(start, pgoff) - vma_rmap_base(vma);
+	if (rbase_diff && vma_pre_update_rmap_base(vma, rbase_diff)) {
+		vma_iter_free(vmi);
+		return -ENOMEM;
+	}
+
 	init_vma_prep(&vp, vma);
 	vma_prepare(&vp);
 	vma_adjust_trans_huge(vma, start, end, NULL);
@@ -1268,6 +1282,8 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	vma_iter_clear(vmi);
 	vma_set_range(vma, start, end, pgoff);
 	vma_complete(&vp, vmi, vma->vm_mm);
+	if (rbase_diff)
+		vma_post_update_rmap_base(vma, rbase_diff);
 	validate_mm(vma->vm_mm);
 	return 0;
 }
-- 
2.17.1


