Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6629ACD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 014416B008C; Wed, 27 May 2026 07:08:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE4DE6B0092; Wed, 27 May 2026 07:08:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF58A6B0093; Wed, 27 May 2026 07:08:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE8396B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:08:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 866A78DCDF
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:03 +0000 (UTC)
X-FDA: 84812925246.15.235F4B8
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf23.hostedemail.com (Postfix) with ESMTP id 491D6140005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779880081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y0B2gEBeKYaQC8u/JCwR9ae7cMNjV6hufd+HDBklfsE=;
	b=Su69W9pGWQID5DObSfFFZqvNvN/ChxYXtoTdLHWSgmX9GAIz0vuuzsgFrfumU/w1lo2nnv
	hpvbBfFXygfPIRe9KN+onHIcUM+VKA+ECmLBC/Q91l037fREyM9h4M4DGgclJNRef09lT5
	w7C7T71QcmHF+De5Cgk7O8cIuXdCiTw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779880081; a=rsa-sha256;
	cv=none;
	b=2i6Rj3ODG6OkRHHmD/6zAtiBjeobf7CueuzolrJIOjFKqZL2qJyoYn97A1jZGG0kuz+CC7
	MMx7gkMzph14HkDsAFVJhYc9Lvw4D3bf5YJKiSWVSt/XOhYl7k7T/05nQ+10XNRaQie8wU
	4pvQtFS3rLpd/jlewUA1g7AknxzYt+E=
Received: from TW005.hihonor.com (unknown [10.72.0.123])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gQRdM3RRSzYkyXX;
	Wed, 27 May 2026 19:06:31 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW005.hihonor.com
 (10.72.0.123) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:07:57 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:07:56 +0800
From: tao <tao.wangtao@honor.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<willy@infradead.org>, <sj@kernel.org>, <kees@kernel.org>,
	<luizcap@redhat.com>, <zhangjiao2@cmss.chinamobile.com>,
	<tao.wangtao@honor.com>, <kas@kernel.org>, <ljs@kernel.org>
CC: <hpa@zytor.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <jack@suse.cz>,
	<riel@surriel.com>, <harry@kernel.org>, <jannh@google.com>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <nao.horiguchi@gmail.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <pfalcato@suse.de>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<damon@lists.linux.dev>, <shakeel.butt@linux.dev>, <ryncsn@gmail.com>,
	<21cnbao@gmail.com>, <jparsana@google.com>, <dvander@google.com>,
	<zhangji1@honor.com>, <wangzicheng@honor.com>
Subject: [PATCH 04/15] mm: switch to anon_vma_tree_t APIs in preparation for ANON_VMA_LAZY
Date: Wed, 27 May 2026 19:01:36 +0800
Message-ID: <20260527110147.17815-5-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW006-1.hihonor.com (10.77.215.153) To TA003.hihonor.com
 (10.72.0.43)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 491D6140005
X-Stat-Signature: 4sy7upetquehqdgip8izkhgons6erz8z
X-HE-Tag: 1779880081-941772
X-HE-Meta: U2FsdGVkX18zq7PI85JoVGqqyIXkdm8N5WaiOqwHeILSaghJ0ATKEOoiRc0Ph3DVS+itdvv2uTrUxMcxYS4IIfSHGs8Omg3vI2RIGZO3kSicOhYM4szqtKKBiucrM9n8UFR+OIfx6sGqrG9OzowhqERJyU5wz/bMNdzL72ayPR2yxivwAoaf8YaJnr9q+fcvAPTVsEJBAMxrtL2r/u6UhUH7LXOV4CqApn0bV19qALjLdAJnzhxIbS5SpkOxwShELiG/9PqNND0ge6T7gkTpMapR6uymWAqPc12vWYBYMbcFeE0NmZEdEinpyaR8kxCjggeczUcrusxO+SWJVFePPnyByI9LAJjXONm4gHsM4R97Pp+MU9wQWCezGfgWcFWAgCcM0UvC6oWd/bxmW59G7TRq6drxN2eEpnwqfG/YPZ5OAscUE6Q9mTjpiHbqHgy44x9rOMFg1iVMGQV07GyhtSyUZ0LUbb4cheHL4kQm1AfvU6UDsYEvGeQ70DApg3tp5+td3mBsDq1jQt6TLmbef3vIdu9yjmDdFoIaPqnHOl0dAEmAUmhI/2H0dHhrZy8f5DEjHtEOdFp7jTX6zfyjbYub6IFz1/HGcsQpzB0i1WF+sFaCVZKFZQAwtq1nPU2VntZ4soCI0Z3gRQEb9DwLy/j1tRqL86yn2P+WTJopNlHgfsKBB51VbgS/TW+pNu/mv3emONN/HSH/E1zMniAzDQG0rmrbEJAJ3GOXt55E4qWWSQIygzM99hrjU+9bLLwRtOUj3hVCR6CTbRD/yRaivYA4uEHHVo8hm03ppVGPVfrG1wdiLpWmc9fIPaFxB7l/c195gumnj58qtD0ti4ax/MZamhb8k1cmLDQVzJW+LpkEmi70sKpeLEswwjCPFq4N7+U7b9/QQVr8gzIPO9+Xv2GQ5w4UzqytutsZFmUTELGXAmdBhMvziUqPzfZMv9rQEW2FLTMmioqh/EMCpO9
 PEDSnBRX
 rS4OC57a8AQmWOzcNWBhizt+anJJ4JJCZLg9y5X/Whko58a0ZdDqTNz6yMPEZVcEo7dYm2iiZSabI4ItZz95Vup2BgT6dgkiQIrO8ZvFLk+x7SDOlXb8VmNZ0ZFCvmQOsi80Qzp7pGhYlN2HifmwoL6vGQfTTlFlXGwPdTeT/SRAEOt89RB/v9elrFfbjuDNVC/qcII5LFNHgxBiAAe2A5pjYsSvMFh2+OuBCvPtGGEDbV37tc9P6nB4KJJMHyt9tdafTf8feCIypQDymO+42AF9Ebe5rxdSJm7LsyDh3fhYEuVlv7W9toYLpyR1wHT2IYucnYiBCtROsohQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace direct anon_vma usage with anon_vma_tree_t APIs. This prepares
for ANON_VMA_LAZY and prevents external modules from accessing anon_vma
directly.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 include/linux/mm_types.h |  2 +-
 mm/debug.c               |  2 +-
 mm/internal.h            | 16 +++++++++++
 mm/khugepaged.c          |  8 +++---
 mm/memory.c              |  2 +-
 mm/mmap.c                |  2 +-
 mm/mremap.c              |  4 +--
 mm/rmap.c                | 59 ++++++++++++++++++++++------------------
 mm/vma.c                 | 26 +++++++++---------
 mm/vma.h                 |  4 +--
 10 files changed, 73 insertions(+), 52 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5f4961ea1572..e7f5debac98e 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -987,7 +987,7 @@ struct vm_area_struct {
 	 */
 	struct list_head anon_vma_chain; /* Serialized by mmap_lock &
 					  * page_table_lock */
-	struct anon_vma *anon_vma;	/* Serialized by page_table_lock */
+	anon_vma_tree_t anon_vma;	/* Serialized by page_table_lock */
 
 	/* Function pointers to deal with this struct. */
 	const struct vm_operations_struct *vm_ops;
diff --git a/mm/debug.c b/mm/debug.c
index 77fa8fe1d641..f64cf9c9abbb 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -163,7 +163,7 @@ void dump_vma(const struct vm_area_struct *vma)
 		"flags: %#lx(%pGv)\n",
 		vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_mm,
 		(unsigned long)pgprot_val(vma->vm_page_prot),
-		vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
+		(void *)vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
 		vma->vm_file, vma->vm_private_data,
 #ifdef CONFIG_PER_VMA_LOCK
 		refcount_read(&vma->vm_refcnt),
diff --git a/mm/internal.h b/mm/internal.h
index 76544ad44ff0..3dbbd118a78c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -258,6 +258,22 @@ static inline struct anon_vma *anon_vma_tree_anon_vma(anon_vma_tree_t anon_tree)
 	return (struct anon_vma *)anon_tree;
 }
 
+/* Store anon_vma in vma->anon_vma using a tagged pointer. */
+static inline void vma_set_anon_vma(struct vm_area_struct *vma,
+		struct anon_vma *anon_vma)
+{
+	vma->anon_vma = (anon_vma_tree_t)anon_vma;
+}
+
+/* Return the VMA's anon_vma. */
+static inline struct anon_vma *vma_anon_vma(const struct vm_area_struct *vma)
+{
+	/* Use READ_ONCE() for reusable_anon_vma */
+	anon_vma_tree_t anon_tree = READ_ONCE(vma->anon_vma);
+
+	return anon_vma_tree_anon_vma(anon_tree);
+}
+
 static inline void anon_vma_tree_lock_write(anon_vma_tree_t anon_tree)
 {
 	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b8452dbdb043..747748eace91 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -761,7 +761,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
 	 * Re-establish the PMD to point to the original page table
 	 * entry. Restoring PMD needs to be done prior to releasing
 	 * pages. Since pages are still isolated and locked here,
-	 * acquiring anon_vma_lock_write is unnecessary.
+	 * acquiring anon_vma_tree_lock_write is unnecessary.
 	 */
 	pmd_ptl = pmd_lock(vma->vm_mm, pmd);
 	pmd_populate(vma->vm_mm, pmd, pmd_pgtable(orig_pmd));
@@ -1164,7 +1164,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 
-	anon_vma_lock_write(vma->anon_vma);
+	anon_vma_tree_lock_write(vma->anon_vma);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
 				address + HPAGE_PMD_SIZE);
@@ -1205,7 +1205,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 		 */
 		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
 		spin_unlock(pmd_ptl);
-		anon_vma_unlock_write(vma->anon_vma);
+		anon_vma_tree_unlock_write(vma->anon_vma);
 		goto out_up_write;
 	}
 
@@ -1213,7 +1213,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 * All pages are isolated and locked so anon_vma rmap
 	 * can't run anymore.
 	 */
-	anon_vma_unlock_write(vma->anon_vma);
+	anon_vma_tree_unlock_write(vma->anon_vma);
 
 	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
 					   vma, address, pte_ptl,
diff --git a/mm/memory.c b/mm/memory.c
index 86a973119bd4..c13b79987b26 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -602,7 +602,7 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 	if (page)
 		dump_page(page, "bad page map");
 	pr_alert("addr:%px vm_flags:%08lx anon_vma:%px mapping:%px index:%lx\n",
-		 (void *)addr, vma->vm_flags, vma->anon_vma, mapping, index);
+		 (void *)addr, vma->vm_flags, (void *)vma->anon_vma, mapping, index);
 	pr_alert("file:%pD fault:%ps mmap:%ps mmap_prepare: %ps read_folio:%ps\n",
 		 vma->vm_file,
 		 vma->vm_ops ? vma->vm_ops->fault : NULL,
diff --git a/mm/mmap.c b/mm/mmap.c
index 5754d1c36462..eac1fb3823eb 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1799,7 +1799,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			 * Don't prepare anon_vma until fault since we don't
 			 * copy page for current vma.
 			 */
-			tmp->anon_vma = NULL;
+			vma_set_anon_vma(tmp, NULL);
 		} else if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
 		vm_flags_clear(tmp, VM_LOCKED_MASK);
diff --git a/mm/mremap.c b/mm/mremap.c
index e9c8b1d05832..6af41e58f79f 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -145,13 +145,13 @@ static void take_rmap_locks(struct vm_area_struct *vma)
 	if (vma->vm_file)
 		i_mmap_lock_write(vma->vm_file->f_mapping);
 	if (vma->anon_vma)
-		anon_vma_lock_write(vma->anon_vma);
+		anon_vma_tree_lock_write(vma->anon_vma);
 }
 
 static void drop_rmap_locks(struct vm_area_struct *vma)
 {
 	if (vma->anon_vma)
-		anon_vma_unlock_write(vma->anon_vma);
+		anon_vma_tree_unlock_write(vma->anon_vma);
 	if (vma->vm_file)
 		i_mmap_unlock_write(vma->vm_file->f_mapping);
 }
diff --git a/mm/rmap.c b/mm/rmap.c
index 41607168e00e..5c4eb090c801 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -186,6 +186,7 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct anon_vma *anon_vma, *allocated;
+	anon_vma_tree_t anon_tree;
 	struct anon_vma_chain *avc;
 
 	mmap_assert_locked(mm);
@@ -205,11 +206,12 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 		allocated = anon_vma;
 	}
 
-	anon_vma_lock_write(anon_vma);
+	anon_tree = make_anon_vma_tree(anon_vma);
+	anon_vma_tree_lock_write(anon_tree);
 	/* page_table_lock to protect against threads */
 	spin_lock(&mm->page_table_lock);
 	if (likely(!vma->anon_vma)) {
-		vma->anon_vma = anon_vma;
+		vma->anon_vma = anon_tree;
 		anon_vma_chain_assign(vma, avc, anon_vma);
 		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 		anon_vma->num_active_vmas++;
@@ -217,7 +219,7 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 		avc = NULL;
 	}
 	spin_unlock(&mm->page_table_lock);
-	anon_vma_unlock_write(anon_vma);
+	anon_vma_tree_unlock_write(anon_tree);
 
 	if (unlikely(allocated))
 		put_anon_vma(allocated);
@@ -283,7 +285,7 @@ static void maybe_reuse_anon_vma(struct vm_area_struct *dst,
 	if (anon_vma->num_children > 1)
 		return;
 
-	dst->anon_vma = anon_vma;
+	vma_set_anon_vma(dst, anon_vma);
 	anon_vma->num_active_vmas++;
 }
 
@@ -321,11 +323,11 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
 		   enum vma_operation operation)
 {
 	struct anon_vma_chain *avc, *pavc;
-	struct anon_vma *active_anon_vma = src->anon_vma;
+	anon_vma_tree_t active_anon_tree = src->anon_vma;
 
 	check_anon_vma_clone(dst, src, operation);
 
-	if (!active_anon_vma)
+	if (!active_anon_tree)
 		return 0;
 
 	/*
@@ -350,7 +352,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
 	 * Now link the anon_vma's back to the newly inserted AVCs.
 	 * Note that all anon_vma's share the same root.
 	 */
-	anon_vma_lock_write(src->anon_vma);
+	anon_vma_tree_lock_write(active_anon_tree);
 	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
@@ -360,9 +362,9 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
 	}
 
 	if (operation != VMA_OP_FORK)
-		dst->anon_vma->num_active_vmas++;
+		vma_anon_vma(dst)->num_active_vmas++;
 
-	anon_vma_unlock_write(active_anon_vma);
+	anon_vma_tree_unlock_write(active_anon_tree);
 	return 0;
 
  enomem_failure:
@@ -379,6 +381,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 {
 	struct anon_vma_chain *avc;
 	struct anon_vma *anon_vma;
+	anon_vma_tree_t anon_tree;
 	int rc;
 
 	/* Don't bother if the parent process has no anon_vma here. */
@@ -386,7 +389,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 		return 0;
 
 	/* Drop inherited anon_vma, we'll reuse existing or allocate new. */
-	vma->anon_vma = NULL;
+	vma_set_anon_vma(vma, NULL);
 
 	anon_vma = anon_vma_alloc();
 	if (!anon_vma)
@@ -421,8 +424,8 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	 * The root anon_vma's rwsem is the lock actually used when we
 	 * lock any of the anon_vmas in this anon_vma tree.
 	 */
-	anon_vma->root = pvma->anon_vma->root;
-	anon_vma->parent = pvma->anon_vma;
+	anon_vma->parent = vma_anon_vma(pvma);
+	anon_vma->root = anon_vma->parent->root;
 	/*
 	 * With refcounts, an anon_vma can stay around longer than the
 	 * process it belongs to. The root anon_vma needs to be pinned until
@@ -430,13 +433,13 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	 */
 	get_anon_vma(anon_vma->root);
 	/* Mark this anon_vma as the one where our new (COWed) pages go. */
-	vma->anon_vma = anon_vma;
+	vma->anon_vma = anon_tree = make_anon_vma_tree(anon_vma);
 	anon_vma_chain_assign(vma, avc, anon_vma);
 	/* Now let rmap see it. */
-	anon_vma_lock_write(anon_vma);
+	anon_vma_tree_lock_write(anon_tree);
 	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 	anon_vma->parent->num_children++;
-	anon_vma_unlock_write(anon_vma);
+	anon_vma_tree_unlock_write(anon_tree);
 
 	return 0;
 }
@@ -463,7 +466,7 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
 	 * able to correctly clone AVC state. Avoid inconsistent anon_vma tree
 	 * state by resetting.
 	 */
-	vma->anon_vma = NULL;
+	vma_set_anon_vma(vma, NULL);
 }
 
 /**
@@ -479,18 +482,18 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
 void unlink_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
-	struct anon_vma *active_anon_vma = vma->anon_vma;
+	anon_vma_tree_t active_anon_tree = vma->anon_vma;
 
 	/* Always hold mmap lock, read-lock on unmap possibly. */
 	mmap_assert_locked(vma->vm_mm);
 
 	/* Unfaulted is a no-op. */
-	if (!active_anon_vma) {
+	if (!active_anon_tree) {
 		VM_WARN_ON_ONCE(!list_empty(&vma->anon_vma_chain));
 		return;
 	}
 
-	anon_vma_lock_write(active_anon_vma);
+	anon_vma_tree_lock_write(active_anon_tree);
 
 	/*
 	 * Unlink each anon_vma chained to the VMA.  This list is ordered
@@ -514,13 +517,13 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		anon_vma_chain_free(avc);
 	}
 
-	active_anon_vma->num_active_vmas--;
+	vma_anon_vma(vma)->num_active_vmas--;
 	/*
 	 * vma would still be needed after unlink, and anon_vma will be prepared
 	 * when handle fault.
 	 */
-	vma->anon_vma = NULL;
-	anon_vma_unlock_write(active_anon_vma);
+	vma_set_anon_vma(vma, NULL);
+	anon_vma_tree_unlock_write(active_anon_tree);
 
 
 	/*
@@ -703,10 +706,12 @@ static struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 
 anon_rmap_t vma_get_anon_rmap(struct vm_area_struct *vma)
 {
+	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(vma->anon_vma);
+
 	mmap_assert_locked(vma->vm_mm);
 	VM_BUG_ON(!vma->anon_vma);
-	get_anon_vma(vma->anon_vma);
-	return anon_vma_to_anon_rmap(vma->anon_vma);
+	get_anon_vma(anon_vma);
+	return anon_vma_to_anon_rmap(anon_vma);
 }
 
 void put_anon_rmap(anon_rmap_t anon_rmap)
@@ -756,7 +761,7 @@ bool folio_maybe_same_anon_vma(const struct folio *folio,
 	const struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma;
-	struct anon_vma *tgt_anon_vma = vma->anon_vma;
+	struct anon_vma *tgt_anon_vma = vma_anon_vma(vma);
 	bool same = false;
 
 	rcu_read_lock();
@@ -1518,7 +1523,7 @@ static __always_inline void __folio_add_rmap(struct folio *folio,
  */
 void folio_move_anon_rmap(struct folio *folio, struct vm_area_struct *vma)
 {
-	void *anon_vma = vma->anon_vma;
+	void *anon_vma = vma_anon_vma(vma);
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_VMA(!anon_vma, vma);
@@ -1542,7 +1547,7 @@ void folio_move_anon_rmap(struct folio *folio, struct vm_area_struct *vma)
 static void __folio_set_anon(struct folio *folio, struct vm_area_struct *vma,
 			     unsigned long address, bool exclusive)
 {
-	struct anon_vma *anon_vma = vma->anon_vma;
+	struct anon_vma *anon_vma = vma_anon_vma(vma);
 
 	BUG_ON(!anon_vma);
 
diff --git a/mm/vma.c b/mm/vma.c
index d90791b00a7b..3501617085b0 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -107,8 +107,8 @@ static bool is_mergeable_anon_vma(struct vma_merge_struct *vmg, bool merge_next)
 {
 	struct vm_area_struct *tgt = merge_next ? vmg->next : vmg->prev;
 	struct vm_area_struct *src = vmg->middle; /* existing merge case. */
-	struct anon_vma *tgt_anon = tgt->anon_vma;
-	struct anon_vma *src_anon = vmg->anon_vma;
+	anon_vma_tree_t tgt_anon = tgt->anon_vma;
+	anon_vma_tree_t src_anon = vmg->anon_vma;
 
 	/*
 	 * We _can_ have !src, vmg->anon_vma via copy_vma(). In this instance we
@@ -311,7 +311,7 @@ static void vma_prepare(struct vma_prepare *vp)
 	}
 
 	if (vp->anon_vma) {
-		anon_vma_lock_write(vp->anon_vma);
+		anon_vma_tree_lock_write(vp->anon_vma);
 		anon_vma_interval_tree_pre_update_vma(vp->vma);
 		if (vp->adj_next)
 			anon_vma_interval_tree_pre_update_vma(vp->adj_next);
@@ -364,7 +364,7 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 		anon_vma_interval_tree_post_update_vma(vp->vma);
 		if (vp->adj_next)
 			anon_vma_interval_tree_post_update_vma(vp->adj_next);
-		anon_vma_unlock_write(vp->anon_vma);
+		anon_vma_tree_unlock_write(vp->anon_vma);
 	}
 
 	if (vp->file) {
@@ -652,7 +652,7 @@ void validate_mm(struct mm_struct *mm)
 	mt_validate(&mm->mm_mt);
 	for_each_vma(vmi, vma) {
 #ifdef CONFIG_DEBUG_VM_RB
-		struct anon_vma *anon_vma = vma->anon_vma;
+		anon_vma_tree_t anon_tree = vma->anon_vma;
 		struct anon_vma_chain *avc;
 #endif
 		unsigned long vmi_start, vmi_end;
@@ -676,11 +676,11 @@ void validate_mm(struct mm_struct *mm)
 		}
 
 #ifdef CONFIG_DEBUG_VM_RB
-		if (anon_vma) {
-			anon_vma_lock_read(anon_vma);
+		if (anon_tree) {
+			anon_vma_tree_lock_read(anon_tree);
 			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 				anon_vma_interval_tree_verify(avc);
-			anon_vma_unlock_read(anon_vma);
+			anon_vma_tree_unlock_read(anon_tree);
 		}
 #endif
 		/* Check for a infinite loop */
@@ -2009,7 +2009,7 @@ static struct anon_vma *reusable_anon_vma(struct vm_area_struct *old,
 					  struct vm_area_struct *b)
 {
 	if (anon_vma_compatible(a, b)) {
-		struct anon_vma *anon_vma = READ_ONCE(old->anon_vma);
+		struct anon_vma *anon_vma = vma_anon_vma(old);
 
 		if (anon_vma && list_is_singular(&old->anon_vma_chain))
 			return anon_vma;
@@ -3160,7 +3160,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 	/* Lock the VMA before expanding to prevent concurrent page faults */
 	vma_start_write(vma);
 	/* We update the anon VMA tree. */
-	anon_vma_lock_write(vma->anon_vma);
+	anon_vma_tree_lock_write(vma->anon_vma);
 
 	/* Somebody else might have raced and expanded it already */
 	if (address > vma->vm_end) {
@@ -3186,7 +3186,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 			}
 		}
 	}
-	anon_vma_unlock_write(vma->anon_vma);
+	anon_vma_tree_unlock_write(vma->anon_vma);
 	vma_iter_free(&vmi);
 	validate_mm(mm);
 	return error;
@@ -3239,7 +3239,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 	/* Lock the VMA before expanding to prevent concurrent page faults */
 	vma_start_write(vma);
 	/* We update the anon VMA tree. */
-	anon_vma_lock_write(vma->anon_vma);
+	anon_vma_tree_lock_write(vma->anon_vma);
 
 	/* Somebody else might have raced and expanded it already */
 	if (address < vma->vm_start) {
@@ -3266,7 +3266,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 			}
 		}
 	}
-	anon_vma_unlock_write(vma->anon_vma);
+	anon_vma_tree_unlock_write(vma->anon_vma);
 	vma_iter_free(&vmi);
 	validate_mm(mm);
 	return error;
diff --git a/mm/vma.h b/mm/vma.h
index 8e4b61a7304c..d3bd83299219 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -15,7 +15,7 @@ struct vma_prepare {
 	struct vm_area_struct *adj_next;
 	struct file *file;
 	struct address_space *mapping;
-	struct anon_vma *anon_vma;
+	anon_vma_tree_t anon_vma;
 	struct vm_area_struct *insert;
 	struct vm_area_struct *remove;
 	struct vm_area_struct *remove2;
@@ -104,7 +104,7 @@ struct vma_merge_struct {
 		vma_flags_t vma_flags;
 	};
 	struct file *file;
-	struct anon_vma *anon_vma;
+	anon_vma_tree_t anon_vma;
 	struct mempolicy *policy;
 	struct vm_userfaultfd_ctx uffd_ctx;
 	struct anon_vma_name *anon_name;
-- 
2.17.1


