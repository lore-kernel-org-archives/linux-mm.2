Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB3EACD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A0D36B009B; Wed, 27 May 2026 07:08:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8020B6B0098; Wed, 27 May 2026 07:08:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9C36B009D; Wed, 27 May 2026 07:08:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E16A6B0098
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:08:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA0A916198B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:06 +0000 (UTC)
X-FDA: 84812925372.20.F13E404
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf19.hostedemail.com (Postfix) with ESMTP id D166C1A0003
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="VYbIP/wV";
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf19.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779880085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vxRnvipTE+LZ6U2mPwIuR9jTHTQx1xEgCwosOb/RHrs=;
	b=UEBRTXsGK5m4P+xi+mF38npjNuH9U4KT6Cxfr5DmlVvp4GC4o7McSpnItemxF3hiwMciae
	5cbgrCPXcg8ieyObPfrnYmrRuJTThR0HkxHG75N+cg37ECnNNa3bPf45rkWqdY1j2R6lje
	uTm5UhoXHFsA6LYOWK8L9jt/vRM5xv8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="VYbIP/wV";
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf19.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779880085; a=rsa-sha256;
	cv=none;
	b=ALJeWqgZPndV4oOGgVYWXFG5Kx4612fgTejBNw8U9o8vTqV+yViBsdjIVWvR8noLYgVJa1
	kyxyfDRwk/CZspHlXGRzV+FYaPfeUOffKfjvZCZwcqZ7T6fmErKBY4Pz//+qUmnEw1mtEi
	a4rVB9o4W4g9hJM7rewLJuHVjHgF5/8=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=vxRnvipTE+LZ6U2mPwIuR9jTHTQx1xEgCwosOb/RHrs=;
	b=VYbIP/wV5EBteY3Rxja6Xhj0vKZkB1CsZQ8IRrMSRY53u3FJU+6bQcDpDahwaCSpRoZGHC1VM
	d+UvCvJ2uVyNm+Z2cnU4Q9/y4eYVlWYzcowSTealOF213nmpJF+S7iZUpqi3/8YDt0AF/24W0kG
	+NWs1yRRtlHFZLit0ffbPPo=
Received: from TW005.hihonor.com (unknown [10.72.0.123])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4gQRdf3mPFzYl1Gk;
	Wed, 27 May 2026 19:06:46 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW005.hihonor.com
 (10.72.0.123) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:08:01 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:08:00 +0800
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
Subject: [PATCH 10/15] mm: defer anon_vma creation with ANON_VMA_LAZY
Date: Wed, 27 May 2026 19:01:42 +0800
Message-ID: <20260527110147.17815-11-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW006-1.hihonor.com (10.77.215.153) To TA003.hihonor.com
 (10.72.0.43)
X-Stat-Signature: wh7yobsk79d3sxpowm8pkqcssiufprk6
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D166C1A0003
X-Rspam-User: 
X-HE-Tag: 1779880084-457909
X-HE-Meta: U2FsdGVkX1836JPBiRzt3mZzPKyvKqy2H74uLw+5VVoReEM9XRsQyhDueu/1q1C8MK1pISbwGkIaYsUWWcaFkq9V4VayR+IRKB+YVTtSEY8dfOwgNPo6criM6Vmc0ZPe2TxnXm5zlB9bu7BGAvw7sqTzCUIyVUAAkDYIopBPe+/PYuuKxH/fPP6PgWxz6dr5xGyob6M46kdRZ9qRjSJVeObd+fXpmokWNxF2WPSZ16DxbcmK/Qw+expNc1fXhNoAPmzDCh0+OSZFB+ONCIFw0En60TPJ5u+vyAeD1ikXS3F6Xv6I5tDjIC5qy/XPdbf8CH84acwRQ3HwNi7DluyB02jwtKU96AU16M8t9FvddFr7kJ6ds+UGIhUOL+rpJG6SuC0h4Ke6wBrDKVxojeD7LjsMlA0gMm95FDyBxe/jjQ0YPmPMwYxDVV3vd8nqeFyyV3MJhamcLUUW6geihES+QKoLGP/5XhX6ZBru0egR2E8cuw74tLcin3qup1F9LcPr0lyMVOwLI3kzar4ysVlSSa01xPzdiSq9TFusBU330UOn1L20pAgpGKS4cRk2VLQL2otFpkE/ksc7mXc5kYvw4G39UQ0CsV2pV70KYDqO9ZHxdNd0XFC5dNT0sZH9GaRzauAFwLxYL+Clc+/KGPwUe3pCqcak+LOi88fVNB0EoHMMOBW3gDH0uyfOTZKDaUWSOQcxDRlXl3KnJxuxrnuj4YRh5OtAc8Isn0GphjBy+KIJhwxdvzJQ2FClpP6DVYHlGh6jlaw1DPO/FHMTtPsfcI8BxL4n+4fMk1LFjbYKwbUs9/A5zedtiW+uO6I2ARX3p4QkMdNqa6IFlpZ33ix2u1xhYBgo6S7nJuTnS6R/G0GyvxLeVEmUOwNM/Skq5I0AgUHUQALhb1e8zVsJ5uP6E6C7/mlnnzsngMTVjNaKVSf3cQw6LC31kvwMRlgFOGYaJYfTqJJ8joqNDLAeF9E
 UT1b3MU1
 pGKo/NJAeBJN2QDmJQHNZpRR7eiWv1WELJSox3n/ajENfCOBGK4ZQ2o2VR1ntT7SB0Ri5MoTNORYB28XZWFZnA/XAo6snrxKZ9IzgKc/65rp8D8RPemLbGd1RaUf03H8o6/UYDRdrA7hP0/hQ9eFVvY//mOfw5SttDaYeI7gmH8bCZeAPbFAXE1Be7FWpqSUF9nNpw8zpNrZt5TRzSaZc4IDP2l22SNsJZfdJE6uNX9+JHYC8qKus69NWOxWxIskbYMcrAZYfSQr3tIh1TrnNd5wvvxiNtH93Uca97WgeoolRxCBgG+ZLTQNQea2dH2c1iVeLbRTuHz+PotucPZL1UTp0+WD8BxS5j4s+7AhEFE2jxAo8ogZSMHQAMFmIi7T58oBMMMjZcoOU8vqQJnlWkJTMon3J3DQxzY6Z+8HqrTGxS8c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mark VMAs as ANON_VMA_LAZY and defer anon_vma creation until fork,
avoiding early allocation when it may not be needed and reducing
overhead.

During fork(), ANON_VMA_LAZY VMAs are first upgraded to a regular
anon_vma in the parent to establish the sharing topology. Child VMAs
are created as ANON_VMA_TREE_PARENT and do not allocate anon_vma,
avoiding additional fork overhead.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 mm/internal.h |   9 +++
 mm/memory.c   |   4 +
 mm/rmap.c     | 209 ++++++++++++++++++++++++++++++++++++++++++++++++--
 mm/vma.c      |   9 ++-
 4 files changed, 222 insertions(+), 9 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 6b703646f66d..0a36eba3f63c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -417,6 +417,8 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
 	enum vma_operation operation);
 int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma);
 int  __anon_vma_prepare(struct vm_area_struct *vma);
+/* Called on first anon fault or from anon_vma_prepare(). */
+void vma_prepare_anon_vma_lazy(struct vm_area_struct *vma);
 void unlink_anon_vmas(struct vm_area_struct *vma);
 
 static inline int anon_vma_prepare(struct vm_area_struct *vma)
@@ -424,6 +426,13 @@ static inline int anon_vma_prepare(struct vm_area_struct *vma)
 	if (likely(vma->anon_vma))
 		return 0;
 
+#ifdef CONFIG_ANON_VMA_LAZY
+	if (anon_vma_lazy_enabled()) {
+		vma_prepare_anon_vma_lazy(vma);
+		return 0;
+	}
+#endif
+
 	return __anon_vma_prepare(vma);
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index c13b79987b26..8fd3877f69fb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3822,6 +3822,10 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
 
 	if (likely(vma->anon_vma))
 		return 0;
+	if (anon_vma_lazy_enabled()) {
+		vma_prepare_anon_vma_lazy(vma);
+		return 0;
+	}
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
 		if (!mmap_read_trylock(vma->vm_mm))
 			return VM_FAULT_RETRY;
diff --git a/mm/rmap.c b/mm/rmap.c
index f70e3cb9812e..d9424f4eb6d0 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -240,9 +240,118 @@ static void anon_vma_chain_assign(struct vm_area_struct *vma,
 	list_add(&avc->same_vma, &vma->anon_vma_chain);
 }
 
+#ifdef CONFIG_ANON_VMA_LAZY
+/* Called on first anon fault or from anon_vma_prepare(). */
+void vma_prepare_anon_vma_lazy(struct vm_area_struct *vma)
+{
+	struct mm_struct *mm = vma->vm_mm;
+
+	spin_lock(&mm->page_table_lock);
+	if (!vma->anon_vma) {
+		vma_get(vma);
+		vma->anon_vma = (anon_vma_tree_t)(
+			(unsigned long)vma + ANON_VMA_TREE_VMA);
+	}
+	spin_unlock(&mm->page_table_lock);
+}
+
+/*
+ * Link VMA to its root ANON_VMA_TREE_VMA. Root holds reference to prevent
+ * premature freeing while folios reference it via folio->mapping.
+ */
+static bool vma_link_anon_vma_lazy_root(struct vm_area_struct *vma,
+	struct vm_area_struct *src)
+{
+	struct mm_struct *mm = src->vm_mm;
+	struct vm_area_struct *root_vma;
+	bool ret = false;
+
+	VM_BUG_ON_VMA(vma->vm_mm != src->vm_mm, vma);
+	/* src may be upgraded concurrently */
+	spin_lock(&mm->page_table_lock);
+	root_vma = anon_vma_tree_vma(src->anon_vma);
+	if (root_vma) {
+		vma_get(root_vma);
+		vma->anon_vma = src->anon_vma;
+		ret = true;
+	} else {
+		vma_set_anon_vma(vma, NULL);
+	}
+	spin_unlock(&mm->page_table_lock);
+	return ret;
+}
+
+/* Link VMA to its ANON_VMA_TREE_PARENT .*/
+static void vma_link_anon_vma_lazy_parent(struct vm_area_struct *vma,
+	struct vm_area_struct *src)
+{
+	struct anon_vma *parent_anon_vma = vma_anon_vma(src);
+
+	vma_assert_write_locked(src);
+	VM_BUG_ON_VMA(vma->anon_vma, vma);
+	VM_BUG_ON_VMA(!parent_anon_vma, src);
+
+	get_anon_vma(parent_anon_vma);
+	vma->anon_vma = (anon_vma_tree_t)(
+		(unsigned long)parent_anon_vma + ANON_VMA_TREE_PARENT);
+}
+
+/* Unlink VMA from anon_vma, dropping root/parent reference. */
+static bool vma_unlink_anon_vma_lazy(struct vm_area_struct *vma,
+	anon_vma_tree_t new_anon_vma_tree)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	anon_vma_tree_t anon_tree_mutable = READ_ONCE(vma->anon_vma);
+	anon_vma_tree_t anon_tree;
+	bool is_lazy = true;
+	struct vm_area_struct *root_vma = NULL;
+	struct anon_vma *parent_anon_vma = NULL;
+
+	VM_BUG_ON_VMA(anon_vma_tree_type(new_anon_vma_tree), vma);
+
+	anon_vma_tree_lock_write(anon_tree_mutable);
+	spin_lock(&mm->page_table_lock);
+	anon_tree = vma->anon_vma;
+	if (anon_vma_tree_is_vma(anon_tree)) {
+		root_vma = anon_vma_tree_vma(anon_tree);
+		vma->anon_vma = new_anon_vma_tree;
+	} else if (anon_vma_tree_is_parent(anon_tree)) {
+		parent_anon_vma = anon_vma_tree_anon_vma(anon_tree);
+		vma->anon_vma = new_anon_vma_tree;
+	} else {
+		is_lazy = false;
+	}
+	spin_unlock(&mm->page_table_lock);
+	anon_vma_tree_unlock_write(anon_tree_mutable);
+	if (!is_lazy)
+		return false;
+
+	/* drop reference after unlock */
+	VM_BUG_ON_VMA(!parent_anon_vma && !root_vma, vma);
+	if (parent_anon_vma) {
+		/* There must be nodes; it cannot be the last reference. */
+		VM_BUG_ON(RB_EMPTY_ROOT(&parent_anon_vma->rb_root.rb_root));
+		put_anon_vma(parent_anon_vma);
+	}
+	if (root_vma)
+		vma_put(root_vma);
+	return is_lazy;
+}
+#else
+static inline bool vma_link_anon_vma_lazy_root(struct vm_area_struct *vma,
+	struct vm_area_struct *src) { return false; }
+static void vma_link_anon_vma_lazy_parent(struct vm_area_struct *vma,
+	struct vm_area_struct *src) {}
+static inline bool vma_unlink_anon_vma_lazy(struct vm_area_struct *vma,
+	anon_vma_tree_t new_anon_vma_tree) { return false; }
+#endif
+
 /**
- * __anon_vma_prepare - attach an anon_vma to a memory region
+ * vma_prepare_anon_vma - attach an anon_vma to a memory region
  * @vma: the memory region in question
+ * @upgrade_lazy: true when upgrading a lazy VMA to a regular anon_vma.
+ * @parent_anon_vma: non-NULL if the VMA is inherited from its parent,
+ * otherwise NULL.
  *
  * This makes sure the memory mapping described by 'vma' has
  * an 'anon_vma' attached to it, so that we can associate the
@@ -266,12 +375,14 @@ static void anon_vma_chain_assign(struct vm_area_struct *vma,
  * to do any locking for the common case of already having
  * an anon_vma.
  */
-int __anon_vma_prepare(struct vm_area_struct *vma)
+static int vma_prepare_anon_vma(struct vm_area_struct *vma, bool upgrade_lazy,
+	struct anon_vma *parent_anon_vma)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct anon_vma *anon_vma, *allocated;
 	anon_vma_tree_t anon_tree;
 	struct anon_vma_chain *avc;
+	bool is_lazy = false;
 
 	mmap_assert_locked(mm);
 	might_sleep();
@@ -282,19 +393,30 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 
 	anon_vma = find_mergeable_anon_vma(vma);
 	allocated = NULL;
-	if (!anon_vma) {
+	/* If parent_anon_vma exists, mergeable anon_vma root must match it. */
+	if (!anon_vma ||
+		(parent_anon_vma && anon_vma->root != parent_anon_vma->root)) {
 		anon_vma = anon_vma_alloc();
 		if (unlikely(!anon_vma))
 			goto out_enomem_free_avc;
-		anon_vma->num_children++; /* self-parent link for new root */
 		allocated = anon_vma;
+		if (parent_anon_vma) {
+			anon_vma->root = parent_anon_vma->root;
+			anon_vma->parent = parent_anon_vma;
+		}
 	}
 
 	anon_tree = make_anon_vma_tree(anon_vma);
+	if (upgrade_lazy)
+		is_lazy = vma_unlink_anon_vma_lazy(vma, anon_tree);
 	anon_vma_tree_lock_write(anon_tree);
 	/* page_table_lock to protect against threads */
 	spin_lock(&mm->page_table_lock);
-	if (likely(!vma->anon_vma)) {
+	if (likely(!vma->anon_vma || is_lazy)) {
+		if (anon_vma->root != anon_vma)
+			get_anon_vma(anon_vma->root);
+		if (allocated)
+			anon_vma->parent->num_children++;
 		vma->anon_vma = anon_tree;
 		anon_vma_chain_assign(vma, avc, anon_vma);
 		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
@@ -318,6 +440,28 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	return -ENOMEM;
 }
 
+/**
+ * __anon_vma_prepare - attach an anon_vma to a memory region
+ * @vma: the memory region in question
+ *
+ * Wrapper around vma_prepare_anon_vma() for the non-lazy case.
+ * Called when ANON_VMA_LAZY is disabled.
+ */
+int __anon_vma_prepare(struct vm_area_struct *vma)
+{
+	return vma_prepare_anon_vma(vma, false, NULL);
+}
+
+static int vma_upgrade_anon_vma_lazy(struct vm_area_struct *vma)
+{
+	anon_vma_tree_t vma_tree = vma->anon_vma;
+	struct anon_vma *parent_anon_vma = NULL;
+
+	if (anon_vma_tree_is_parent(vma_tree))
+		parent_anon_vma = anon_vma_tree_anon_vma(vma_tree);
+	return vma_prepare_anon_vma(vma, true, parent_anon_vma);
+}
+
 static void check_anon_vma_clone(struct vm_area_struct *dst,
 				 struct vm_area_struct *src,
 				 enum vma_operation operation)
@@ -414,6 +558,20 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
 	if (!active_anon_tree)
 		return 0;
 
+	/* Check ANON_VMA_LAZY first. */
+	if (anon_vma_tree_is_vma(active_anon_tree)) {
+		if (vma_link_anon_vma_lazy_root(dst, src))
+			return 0;
+	} else if (anon_vma_tree_is_parent(active_anon_tree)) {
+		/* split from tree_parent is rare; promote to regular. */
+		int err = vma_upgrade_anon_vma_lazy(src);
+
+		if (err)
+			return err;
+		VM_BUG_ON_VMA(vma_is_anon_vma_lazy(src), src);
+		dst->anon_vma = src->anon_vma;
+	}
+
 	/*
 	 * Allocate AVCs. We don't need an anon_vma lock for this as we
 	 * are not updating the anon_vma rbtree nor are we changing
@@ -445,7 +603,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
 			maybe_reuse_anon_vma(dst, anon_vma);
 	}
 
-	if (operation != VMA_OP_FORK)
+	if (operation != VMA_OP_FORK && vma_anon_vma(dst))
 		vma_anon_vma(dst)->num_active_vmas++;
 
 	anon_vma_tree_unlock_write(active_anon_tree);
@@ -456,9 +614,38 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
 	return -ENOMEM;
 }
 
+static int vma_fork_anon_vma_lazy(struct vm_area_struct *vma,
+	struct vm_area_struct *pvma)
+{
+	int error;
+
+	if (vma_is_anon_vma_lazy(pvma)) {
+		error = vma_upgrade_anon_vma_lazy(pvma);
+		if (error)
+			return error;
+		VM_BUG_ON_VMA(vma_is_anon_vma_lazy(pvma), pvma);
+	}
+
+	vma_set_anon_vma(vma, NULL);
+	error = anon_vma_clone(vma, pvma, VMA_OP_FORK);
+	if (error)
+		return error;
+
+	if (vma->anon_vma)
+		return 0;
+	/* Lazily allocate the child anon_vma. */
+	vma_link_anon_vma_lazy_parent(vma, pvma);
+	return 0;
+}
+
 /*
  * Attach vma to its own anon_vma, as well as to the anon_vmas that
  * the corresponding VMA in the parent process is attached to.
+ *
+ * For ANON_VMA_LAZY: if the parent VMA is lazy, upgrade it to a regular
+ * anon_vma before cloning. The child VMA may also be marked lazy when
+ * ANON_VMA_LAZY is enabled, deferring anon_vma allocation.
+ *
  * Returns 0 on success, non-zero on failure.
  */
 int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
@@ -472,6 +659,9 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	if (!pvma->anon_vma)
 		return 0;
 
+	if (anon_vma_lazy_enabled())
+		return vma_fork_anon_vma_lazy(vma, pvma);
+
 	/* Drop inherited anon_vma, we'll reuse existing or allocate new. */
 	vma_set_anon_vma(vma, NULL);
 
@@ -577,6 +767,10 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		return;
 	}
 
+	/* Unlink ANON_VMA_LAZY first, then ancestor anon_vma. */
+	if (vma_is_anon_vma_lazy(vma))
+		vma_unlink_anon_vma_lazy(vma, (anon_vma_tree_t)NULL);
+
 	anon_vma_tree_lock_write(active_anon_tree);
 
 	/*
@@ -601,7 +795,8 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		anon_vma_chain_free(avc);
 	}
 
-	vma_anon_vma(vma)->num_active_vmas--;
+	if (vma_anon_vma(vma))
+		vma_anon_vma(vma)->num_active_vmas--;
 	/*
 	 * vma would still be needed after unlink, and anon_vma will be prepared
 	 * when handle fault.
diff --git a/mm/vma.c b/mm/vma.c
index ed15968a5891..0a31ef82a90c 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1995,6 +1995,8 @@ static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *
  * acceptable for merging, so we can do all of this optimistically. But
  * we do that READ_ONCE() to make sure that we never re-load the pointer.
  *
+ * For upgrading ANON_VMA_LAZY VMAs, follow the same reuse rules as splitting.
+ *
  * IOW: that the "list_is_singular()" test on the anon_vma_chain only
  * matters for the 'stable anon_vma' case (ie the thing we want to avoid
  * is to return an anon_vma that is "complex" due to having gone through
@@ -2005,12 +2007,15 @@ static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *
  * a read lock on the mmap_lock.
  */
 static struct anon_vma *reusable_anon_vma(struct vm_area_struct *old,
+					  struct vm_area_struct *vma,
 					  struct vm_area_struct *a,
 					  struct vm_area_struct *b)
 {
 	if (anon_vma_compatible(a, b)) {
 		struct anon_vma *anon_vma = vma_anon_vma(old);
 
+		if (anon_vma && vma_is_anon_vma_lazy(vma))
+			return anon_vma;
 		if (anon_vma && list_is_singular(&old->anon_vma_chain))
 			return anon_vma;
 	}
@@ -2034,7 +2039,7 @@ struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *vma)
 	/* Try next first. */
 	next = vma_iter_load(&vmi);
 	if (next) {
-		anon_vma = reusable_anon_vma(next, vma, next);
+		anon_vma = reusable_anon_vma(next, vma, vma, next);
 		if (anon_vma)
 			return anon_vma;
 	}
@@ -2044,7 +2049,7 @@ struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *vma)
 	prev = vma_prev(&vmi);
 	/* Try prev next. */
 	if (prev)
-		anon_vma = reusable_anon_vma(prev, prev, vma);
+		anon_vma = reusable_anon_vma(prev, vma, prev, vma);
 
 	/*
 	 * We might reach here with anon_vma == NULL if we can't find
-- 
2.17.1


