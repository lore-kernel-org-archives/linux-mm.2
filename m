Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B65F0C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15DFC6B00AF; Tue,  7 Jul 2026 02:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E52B36B00A6; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5AC56B00A6; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 482ED6B00AB
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 953A8C18AE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:26 +0000 (UTC)
X-FDA: 84961031652.14.0FF50EE
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2181A40002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P6djboFdB/8b9mBna81/JRx8Twb/StBlC0hzCvE5HBo=;
	b=J40Y18WHJdQfFJLlnTubAlutL1jgH/qvZfty+k8lLlcagp2ArfLsQxVdMr1vCnu80WDYOc
	Jug4ku/xI7jwFN8Tw7OEn8qu7aG6VVKj8AXL0msqnBGf/NQRi0lxfDNksiqekid2dIxRff
	E54cyz/O8WKOR/+SUmuPdHxAYLNGggo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406424;
	b=mNbBBOn6XFYaxVRE0dX2+NxDqsNtF7LdGseKKZTlgZajBXStu2G6u7r5bWpJQwfyptTlER
	vZnhPHjjcDF8iY4N3/chK2Lh7kmjyjKtXPi08YSwEZMV1lyhuw0Sqo4bTpLLEPO4RNih4y
	QJEuUVGHbV7AF96EETqoVVm0BguYvPc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
Received: from TW005.hihonor.com (unknown [10.72.0.123])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gvWnJ0w5HzYm8lZ;
	Tue,  7 Jul 2026 14:40:20 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW005.hihonor.com
 (10.72.0.123) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Tue, 7 Jul
 2026 14:40:19 +0800
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
Subject: [RFC PATCH v2 09/13] mm: prepare anon_node replacement for ANON_VMA_FRACTAL
Date: Tue, 7 Jul 2026 14:33:04 +0800
Message-ID: <20260707063308.29176-10-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260707063308.29176-1-tao.wangtao@honor.com>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW002-1.hihonor.com (10.72.0.137) To TA003.hihonor.com
 (10.72.0.43)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2181A40002
X-Stat-Signature: ec3ohajnsr9ckquq3hdbi5cfpg5eiqgk
X-HE-Tag: 1783406423-115735
X-HE-Meta: U2FsdGVkX18DlT4mUtqi59ppXhHFor4xHd8Q0/BbBRaLpXHUCq9dcYzYnKQTPIo2UQnJ22chABaSAQDaZj+drPH7q54aJ7m00G1JR5Y8rQJge2JcYClgXRwy4zBLxVDlAkLoql+Gz5uWeyieaoO/epHtfp8AUxGhcNp8lB14S7ViYIBtLu9Z8eZGwspVo7uebpaEIECOsthkKrhahNTqu5bXBF2RpC7z1eKNWDYaRys87Gs6Tbe20EarRViMd7YBGjOH1kjGdmPVgpk/hPjWZYukeAsjC40wXeBycFU3vXELORWKlXbKSosRJbW7uHlfSQyb8ikRN7q4n6RoDV/kmbb1GSWeOBPJRyYSmxHwrj7qYNOw9rSv/r9xCLWVdPvQrChpy1I1teicBUzA12K4oBUTP4nTfAmVC7CPHRi6IOERdbH4lU7DIixFe3GDj92MeFUKtOvv1cWogsHvY0m11RWatpAvqkd1rd7yRKDPzkoMtGcmzbBtfnUUTBSlkcOLAT1Uma2wv5M4UJMxLs/iIINmbN95qyWDpm+x2cggObWAjxJytqQK3e+b1yAITJ2k/D8Ic6NZJnNrJGj6Bq2fI+mLPp2DoZvEUFGaPviR8MY1zVe90YZCxgrH6r7+NbqbhE4KeFFW4rKbdHFilftfJVjpxC5W8woiDNBxqrP3TUf2ay0t4YXy+u59my8e0WePXpvxgS8BtdkNuIpIWf82Al7Pj/zOgM8XSg/urBmRIwUmDzcRLJce9QuJJTJ/5AF5fOEOQpkVIkacnoo4NSqVgIYUGGV2QiLLhCZhRZ0G+RstvTCwKlaaJALRwRcVt82tdKRGAQpb8PtsS5i1OStF+AV7gJsxk1R5+dvXQxa6TfITcs3kX4NihcKSQtWjYV4tp8kNJF9nsMbqRenocep4HoX/em3jO3IMTs5jnmP5Imb7JkpRQ86g5r9eNvVs360qE3tA4g/O3dJgEh0FG2H
 uS3dSqmB
 wBMOpnCfP5vSMx9trHtN+YPOYEC7wmyr4OnGs3fzUTi9aaLtf/22KFuka40D5OfIV3yt7iwCOxrZn2IsJRaYJdCoPNqfSLimpeCTtIEdGMERSji4OIkUcHfnpMMFxrKESDBh1l4RamQXu8TQRHfkQQDygffvRhwG7c0w0/5if3hCWgYaTD6mC2jRiuOWd+umNwAdh7eZBm8RgASssZXD9uqA9bbw4gCBaWpc9846xpB9FvrvekLQx+Us+Gp78UXSxNrC5nK1GeB/1OYRSkyp/RXkvmshLSxkWEUNCEdooX3h93m7BgeBPSuMo7ZD1H845P5s3Q7kIqxsmaWQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since this replacement involves large code changes, introduce macros
in vma.c first to isolate code differences and split the changes into
smaller patches.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 mm/internal.h | 16 ++++++++++++++++
 mm/rmap.c     |  2 +-
 mm/vma.c      | 52 +++++++++++++++++++++++++++++++++++++++++----------
 3 files changed, 59 insertions(+), 11 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index b38c7b4c2a8f..6f0ff492a89c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -296,6 +296,22 @@ static inline unsigned long anon_node_rmap_count(struct anon_node *anon_nod)
 	return atomic_long_read(&anon_nod->rbc) & ANON_RMAP_BASE_COUNT_MAX;
 }
 
+static inline bool anon_node_can_share(struct anon_node *anon_nod)
+{
+	return anon_nod->depth == 0 &&
+		anon_node_rmap_count(anon_nod) <= ANON_NODE_SHARE_LIMIT;
+}
+
+static inline void anon_node_verify(struct anon_node *node)
+{
+	struct anon_node *rbc_ch = node;
+
+	WARN_ON_ONCE(anon_node_rmap_count(node) == 0 && node->nr_children == 0);
+	while ((rbc_ch = anon_node_next_rbc_child(node, rbc_ch)) != NULL) {
+		WARN_ON_ONCE(anon_node_rmap_count(rbc_ch) == 0);
+	}
+}
+
 static inline unsigned long anon_node_rmap_address(struct anon_node *anon_nod,
 		unsigned long pgoff)
 {
diff --git a/mm/rmap.c b/mm/rmap.c
index 1551e9d2121d..12c6a1bdff3f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -690,7 +690,7 @@ int __anon_node_prepare(struct vm_area_struct *vma)
 	mmap_assert_locked(mm);
 	might_sleep();
 
-	anon_nod = NULL; /* Fix find_mergeable_anon_vma(vma) later. */
+	anon_nod = (struct anon_node *)find_mergeable_anon_vma(vma);
 	if (anon_nod) {
 		anon_new = (struct anon_vma *)anon_nod;
 		if (try_track_rmap(anon_nod, rmap_base) &&
diff --git a/mm/vma.c b/mm/vma.c
index d2996369e30d..02178112daa0 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -269,19 +269,23 @@ static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 static void
 anon_vma_interval_tree_pre_update_vma(struct vm_area_struct *vma)
 {
+#ifndef CONFIG_ANON_VMA_FRACTAL
 	struct anon_vma_chain *avc;
 
 	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 		anon_vma_interval_tree_remove(avc, &avc->anon_vma->rb_root);
+#endif
 }
 
 static void
 anon_vma_interval_tree_post_update_vma(struct vm_area_struct *vma)
 {
+#ifndef CONFIG_ANON_VMA_FRACTAL
 	struct anon_vma_chain *avc;
 
 	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 		anon_vma_interval_tree_insert(avc, &avc->anon_vma->rb_root);
+#endif
 }
 
 /*
@@ -651,10 +655,6 @@ void validate_mm(struct mm_struct *mm)
 
 	mt_validate(&mm->mm_mt);
 	for_each_vma(vmi, vma) {
-#ifdef CONFIG_DEBUG_VM_RB
-		struct anon_vma *anon_vma = vma->anon_vma;
-		struct anon_vma_chain *avc;
-#endif
 		unsigned long vmi_start, vmi_end;
 		bool warn = 0;
 
@@ -675,12 +675,19 @@ void validate_mm(struct mm_struct *mm)
 			vma_iter_dump_tree(&vmi);
 		}
 
-#ifdef CONFIG_DEBUG_VM_RB
-		if (anon_vma) {
+#if CONFIG_DEBUG_VM_RB
+		if (vma->anon_vma) {
+#ifdef CONFIG_ANON_VMA_FRACTAL
+			anon_node_verify((void *)vma->anon_vma);
+#else
+			struct anon_vma *anon_vma = vma->anon_vma;
+			struct anon_vma_chain *avc;
+
 			anon_vma_lock_read(anon_vma);
 			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 				anon_vma_interval_tree_verify(avc);
 			anon_vma_unlock_read(anon_vma);
+#endif
 		}
 #endif
 		/* Check for a infinite loop */
@@ -2027,8 +2034,13 @@ static struct anon_vma *reusable_anon_vma(struct vm_area_struct *old,
 	if (anon_vma_compatible(a, b)) {
 		struct anon_vma *anon_vma = READ_ONCE(old->anon_vma);
 
+#ifdef CONFIG_ANON_VMA_FRACTAL
+		if (anon_vma && anon_node_can_share((void *)anon_vma))
+			return anon_vma;
+#else
 		if (anon_vma && list_is_singular(&old->anon_vma_chain))
 			return anon_vma;
+#endif
 	}
 	return NULL;
 }
@@ -2157,6 +2169,9 @@ static DEFINE_MUTEX(mm_all_locks_mutex);
 
 static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
 {
+#ifdef CONFIG_ANON_VMA_FRACTAL
+	vm_lock_anon_node(mm, (void *)anon_vma);
+#else
 	if (!test_bit(0, (unsigned long *) &anon_vma->root->rb_root.rb_root.rb_node)) {
 		/*
 		 * The LSB of head.next can't change from under us
@@ -2176,6 +2191,7 @@ static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
 				       &anon_vma->root->rb_root.rb_root.rb_node))
 			BUG();
 	}
+#endif
 }
 
 static void vm_lock_mapping(struct mm_struct *mm, struct address_space *mapping)
@@ -2237,7 +2253,6 @@ static void vm_lock_mapping(struct mm_struct *mm, struct address_space *mapping)
 int mm_take_all_locks(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
-	struct anon_vma_chain *avc;
 	VMA_ITERATOR(vmi, mm, 0);
 
 	mmap_assert_write_locked(mm);
@@ -2278,9 +2293,16 @@ int mm_take_all_locks(struct mm_struct *mm)
 	for_each_vma(vmi, vma) {
 		if (signal_pending(current))
 			goto out_unlock;
-		if (vma->anon_vma)
+		if (vma->anon_vma) {
+#ifdef CONFIG_ANON_VMA_FRACTAL
+			vm_lock_anon_vma(mm, vma->anon_vma);
+#else
+			struct anon_vma_chain *avc;
+
 			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 				vm_lock_anon_vma(mm, avc->anon_vma);
+#endif
+		}
 	}
 
 	return 0;
@@ -2292,6 +2314,9 @@ int mm_take_all_locks(struct mm_struct *mm)
 
 static void vm_unlock_anon_vma(struct anon_vma *anon_vma)
 {
+#ifdef CONFIG_ANON_VMA_FRACTAL
+	vm_unlock_anon_node((void *)anon_vma);
+#else
 	if (test_bit(0, (unsigned long *) &anon_vma->root->rb_root.rb_root.rb_node)) {
 		/*
 		 * The LSB of head.next can't change to 0 from under
@@ -2310,6 +2335,7 @@ static void vm_unlock_anon_vma(struct anon_vma *anon_vma)
 			BUG();
 		anon_vma_unlock_write(anon_vma);
 	}
+#endif
 }
 
 static void vm_unlock_mapping(struct address_space *mapping)
@@ -2333,16 +2359,22 @@ static void vm_unlock_mapping(struct address_space *mapping)
 void mm_drop_all_locks(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
-	struct anon_vma_chain *avc;
 	VMA_ITERATOR(vmi, mm, 0);
 
 	mmap_assert_write_locked(mm);
 	BUG_ON(!mutex_is_locked(&mm_all_locks_mutex));
 
 	for_each_vma(vmi, vma) {
-		if (vma->anon_vma)
+		if (vma->anon_vma) {
+#ifdef CONFIG_ANON_VMA_FRACTAL
+			vm_unlock_anon_vma(vma->anon_vma);
+#else
+			struct anon_vma_chain *avc;
+
 			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 				vm_unlock_anon_vma(avc->anon_vma);
+#endif
+		}
 		if (vma->vm_file && vma->vm_file->f_mapping)
 			vm_unlock_mapping(vma->vm_file->f_mapping);
 	}
-- 
2.17.1


