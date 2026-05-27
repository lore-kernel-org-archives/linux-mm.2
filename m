Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB36BCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:08:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AD576B0098; Wed, 27 May 2026 07:08:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961666B009E; Wed, 27 May 2026 07:08:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D1B6B0099; Wed, 27 May 2026 07:08:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DFB96B009B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:08:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 219AD14055F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:07 +0000 (UTC)
X-FDA: 84812925414.02.B8974CB
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf05.hostedemail.com (Postfix) with ESMTP id EABEA100008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf05.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779880085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u0bG3pDOTBhuVNO3owldn96qE4r+bq+/3frf6k3gMhs=;
	b=gsvdvq22tvSMZEKDI6VPps/KV+53/cjqAAgemD58Ewtr8QrGJ/uXDLPix6fwWmgm6bI/5d
	J6YR+7WqmR/27JNBqGzzAeU8aejiIx0s4/kDwfc0w+9VlD7U4iCnfAV3QINGTkZ9jo9SlI
	gCE1YrT1FW8PeOYXul7rvVn0ZH+pfEU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779880085; a=rsa-sha256;
	cv=none;
	b=ldJU2PHIeKVehACNAQrVKVzbyThLBPF551drJKuCPwwJL2UKo350EYrNif1fQBQM8iundW
	xRiXlfeX2kw+479KwTnLCbyBE0IYFRluAF/YILAzuEw11fNzI+w5PUpa/Tx4FTHkNRP105
	gUE170tuXmSnAc4AxXbrrSLSfKpk//4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf05.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
Received: from TW004-1.hihonor.com (unknown [10.77.232.85])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gQRdQ01LHzYl88Q;
	Wed, 27 May 2026 19:06:34 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW004-1.hihonor.com
 (10.77.232.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:08:00 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:07:59 +0800
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
Subject: [PATCH 08/15] mm: prepare rmap infrastructure for ANON_VMA_LAZY
Date: Wed, 27 May 2026 19:01:40 +0800
Message-ID: <20260527110147.17815-9-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW006-1.hihonor.com (10.77.215.153) To TA003.hihonor.com
 (10.72.0.43)
X-Rspam-User: 
X-Rspamd-Queue-Id: EABEA100008
X-Stat-Signature: css5i5dq6wpkghu8em7ct4rfoce8swy8
X-Rspamd-Server: rspam06
X-HE-Tag: 1779880084-11824
X-HE-Meta: U2FsdGVkX1+/T12giS+xJYs2I1pH/iNUy6KXi4fW3SFO2GxpGi7fWj/PN0CPKEwJOKQh+ylD54dtTiKlvVIelN/XwTEKBj/UvHKn2z+lEjWh/fMuaQBas9JbTdW9Shgf2TI4FDipSPTdmkGpGll/HmtRdMkU3utWCUuL84O6bBdiIaIpRkdKcdMc6CDv7QKxrIlzW3NuhwDDcj+o48ZfTfpeOfcuQPdt3icHgr9AxMnVC1PTRurdr0UNIdCHDj6wY4w99BKmBsPlK37/VpeSjAn2APK7ed7cE5BuBc1xMNDzccdo4umF9yYvuRa79RDViThg/vciO6+aDOFHi3vzetTOA9PoHpS6PMHI78VW1Ai6fZPUdzo2BPala4DWfJrK+gQUsHg+bUjIkxGd0+1Ja9T4l/JQhV8Tl5Y9hzBuYc98h1Iaeo/avRF4o2kjR2A7KIgZkUSkU32hxP8Vqn0y4Y9JmyzeZJWHHZ1iIXBtMG382j4TlOLw3XcZVLs110k2etEBC/Yv2d1/kXEcFM23wdYc/bMzsATb+8ZbtkMRXX5YYVtaFgujhMqh33VYgL3SgTpJDszCFkSR3arS9hIqEKU/4Fu5frqdXOdjaGD/LKdXIchGyt4qgJY3RbWHdvsAvHXOhNBKhJflzvoqUwh0fZAEsKYgtTx5+T+2Q2YZyVXynUErGPnZPMUYv1pV5RKUG2crKkpTWEAAdXnMkXnCwg5MfiSo8TIeV0dxGCtQXYqhtaIJipcpCaPH6+Y/T0GQF+F0V6o021IIMLyGNlr1ZswIYHn8ityyDSNb5en1n6ApYgbwInrbDuHtbyQxhwyPF8DMzkbJq5GXXxnR3hU2V7qik1LxOKtKSbyYyvVGvBkZ8WJ7bZbaqgBsool4Mf581KgMmgtAkG+YNDeKWWuuu0K2zNdnE0QyqzYdmkPyF5SF26vyM261rgywK64BtRdi324SylyyDvkFJAnaczJ
 zb7QPWEj
 kKJmqbW7E2CuzQEJjeQkLAgfm8p61xZc2fzO5Q+Bwsm+/FGtXM1TYuwXmdVmkiQOwk1YIseWePZzN3vACPHFIMvvDY3IQS3rLwbM0RwiTGaQmMb3gC/JTiOV319BDaKhhSjxEL5urNVW6Ro2ITMt0NoEpC8olsNVT98n02VNx5RM0XE8A5SCp4tIhzgjEitIfd7mVgS1tnOnOPz2+Akdo+2HWqh12EwhRlPJ2k4BK+XHMh8U6Ow+YzjqN7cCv88mmiihGptdYwCT3+4751j2LoOE/r4Kj7EL2wz4pUtFBMmBbaNP/CD+W60BS8/XDlPmZt8ejtfsgffqpnHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce ANON_VMA_LAZY helpers and prepare the anon_rmap and
anon_vma_tree infrastructure for the upcoming ANON_VMA_LAZY feature.

Implement the core ANON_VMA_LAZY rmap semantics by updating
anon_rmap_trylock_read(), anon_rmap_lock_read(), anon_rmap_unlock_read(),
and anon_rmap_for_each_vma().

Also update __migrate_folio_record(): instead of storing both
old_page_state and anon_vma in dst->private, store old_page_state in
dst->private and use dst->mapping to hold anon_rmap.

Split folio_lock_anon_rmap_read() and related functions into the next
patch to keep this change small and easier to review.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 include/linux/rmap.h | 53 +++++++++++++++++++++---
 mm/internal.h        | 99 +++++++++++++++++++++++++++++++++++++-------
 mm/migrate.c         | 11 ++++-
 mm/rmap.c            | 42 +++++++++++++++++++
 4 files changed, 183 insertions(+), 22 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 9802bce92695..ebe9f3f61170 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -938,15 +938,23 @@ void remove_migration_ptes(struct folio *src, struct folio *dst,
 		enum ttu_flags flags);
 
 /* Reverse mapping handle for anonymous folio rmap helpers. */
+enum anon_rmap_type {
+	ANON_RMAP_ANON_VMA = 0,
+	ANON_RMAP_ANON_VMA_LAZY = 1,
+};
+#define ANON_RMAP_TYPE_BITS 1
+#define ANON_RMAP_TYPE_MASK ((1UL << ANON_RMAP_TYPE_BITS) - 1)
+
 typedef struct anon_rmap {
 	unsigned long rmap;
 } anon_rmap_t;
 
-#define ANON_RMAP_NULL make_anon_rmap(0)
+#define ANON_RMAP_NULL (make_anon_rmap(0, ANON_RMAP_ANON_VMA))
 
-static inline anon_rmap_t make_anon_rmap(const void *anon_mapping)
+static inline anon_rmap_t make_anon_rmap(const void *anon_mapping,
+	enum anon_rmap_type type)
 {
-	return (anon_rmap_t){ .rmap = (unsigned long)anon_mapping, };
+	return (anon_rmap_t){ .rmap = (unsigned long)anon_mapping + type, };
 }
 
 static inline unsigned long anon_rmap_value(anon_rmap_t anon_rmap)
@@ -956,14 +964,38 @@ static inline unsigned long anon_rmap_value(anon_rmap_t anon_rmap)
 
 static inline anon_rmap_t anon_vma_to_anon_rmap(const struct anon_vma *anon_vma)
 {
-	return make_anon_rmap(anon_vma);
+	return make_anon_rmap(anon_vma, ANON_RMAP_ANON_VMA);
 }
 
 static inline struct anon_vma *anon_rmap_to_anon_vma(anon_rmap_t anon_rmap)
 {
 	unsigned long rmap = anon_rmap_value(anon_rmap);
 
-	return (struct anon_vma *)rmap;
+	return (struct anon_vma *)(rmap - ANON_RMAP_ANON_VMA);
+}
+
+static inline anon_rmap_t vma_to_anon_rmap(const struct vm_area_struct *vma)
+{
+	return make_anon_rmap(vma, ANON_RMAP_ANON_VMA_LAZY);
+}
+
+static inline struct vm_area_struct *anon_rmap_to_vma(anon_rmap_t anon_rmap)
+{
+	unsigned long rmap = anon_rmap_value(anon_rmap);
+
+	VM_BUG_ON((rmap & ANON_RMAP_TYPE_MASK) != ANON_RMAP_ANON_VMA_LAZY);
+	return (struct vm_area_struct *)(rmap - ANON_RMAP_ANON_VMA_LAZY);
+}
+
+static inline bool anon_rmap_is_anon_vma(anon_rmap_t anon_rmap)
+{
+#ifdef CONFIG_ANON_VMA_LAZY
+	unsigned long rmap = anon_rmap_value(anon_rmap);
+
+	return (rmap & ANON_RMAP_TYPE_MASK) == ANON_RMAP_ANON_VMA;
+#else
+	return true;
+#endif
 }
 
 anon_rmap_t vma_get_anon_rmap(struct vm_area_struct *vma);
@@ -1015,8 +1047,17 @@ static inline struct vm_area_struct *anon_rmap_iter_first_vma(
 	anon_rmap_t anon_rmap, unsigned long start, unsigned long last,
 	struct anon_vma_chain **avc)
 {
-	struct anon_vma *anon_vma = anon_rmap_to_anon_vma(anon_rmap);
+	struct anon_vma *anon_vma;
+
+	*avc = NULL;
+	if (!anon_rmap_is_anon_vma(anon_rmap)) {
+		struct vm_area_struct *vma = anon_rmap_to_vma(anon_rmap);
 
+		if (vma->vm_pgoff + vma_pages(vma) < start || vma->vm_pgoff > last)
+			return NULL; /* No overlap in the VMA range. */
+		return vma;
+	} else
+		anon_vma = anon_rmap_to_anon_vma(anon_rmap);
 	*avc = anon_vma_interval_tree_iter_first(&anon_vma->rb_root, start, last);
 	return *avc ? (*avc)->vma : NULL;
 }
diff --git a/mm/internal.h b/mm/internal.h
index 639f9c287f4c..6b703646f66d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -260,76 +260,147 @@ static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
 #ifdef CONFIG_ANON_VMA_LAZY
 extern bool anon_vma_lazy_enable;
 static inline bool anon_vma_lazy_enabled(void) { return anon_vma_lazy_enable; }
-#else
-static inline bool anon_vma_lazy_enabled(void) { return false; }
-#endif
 
-static inline anon_vma_tree_t make_anon_vma_tree(struct anon_vma *anon_vma)
+static inline int anon_vma_tree_type(anon_vma_tree_t anon_tree)
 {
-	return (anon_vma_tree_t)anon_vma;
+	VM_WARN_ON(((unsigned long)anon_tree & ANON_VMA_TREE_MASK) ==
+		ANON_VMA_TREE_INVALID);
+	return (unsigned long)anon_tree & ANON_VMA_TREE_MASK;
+}
+
+static inline bool anon_vma_tree_is_vma(anon_vma_tree_t anon_tree)
+{
+	return anon_vma_tree_type(anon_tree) == ANON_VMA_TREE_VMA;
+}
+
+static inline bool anon_vma_tree_is_parent(anon_vma_tree_t anon_tree)
+{
+	return anon_vma_tree_type(anon_tree) == ANON_VMA_TREE_PARENT;
+}
+
+static inline struct vm_area_struct *anon_vma_tree_vma(anon_vma_tree_t anon_tree)
+{
+	BUILD_BUG_ON(__alignof__(struct vm_area_struct) <= ANON_VMA_TREE_MASK);
+	if (!anon_vma_tree_is_vma(anon_tree))
+		return NULL;
+	return (struct vm_area_struct *)(
+		(unsigned long)anon_tree & ~ANON_VMA_TREE_MASK);
 }
 
 static inline struct anon_vma *anon_vma_tree_anon_vma(anon_vma_tree_t anon_tree)
 {
-	return (struct anon_vma *)anon_tree;
+	BUILD_BUG_ON(__alignof__(struct anon_vma) <= ANON_VMA_TREE_MASK);
+	if (anon_vma_tree_is_vma(anon_tree))
+		return NULL;
+	return (struct anon_vma *)((unsigned long)anon_tree & ~ANON_VMA_TREE_MASK);
+}
+
+#else
+static inline bool anon_vma_lazy_enabled(void) { return false; }
+static inline int anon_vma_tree_type(anon_vma_tree_t anon_tree) { return 0; }
+static inline bool anon_vma_tree_is_vma(anon_vma_tree_t anon_tree) { return false; }
+static inline bool anon_vma_tree_is_parent(
+	anon_vma_tree_t anon_tree) { return false; }
+static inline struct vm_area_struct *anon_vma_tree_vma(
+	anon_vma_tree_t anon_tree) { return NULL; }
+static inline struct anon_vma *anon_vma_tree_anon_vma(
+	anon_vma_tree_t anon_tree) { return (struct anon_vma *)anon_tree; }
+#endif
+
+static inline anon_vma_tree_t make_anon_vma_tree(const struct anon_vma *anon_vma)
+{
+	return (anon_vma_tree_t)anon_vma;
 }
 
 /* Store anon_vma in vma->anon_vma using a tagged pointer. */
 static inline void vma_set_anon_vma(struct vm_area_struct *vma,
-		struct anon_vma *anon_vma)
+	const struct anon_vma *anon_vma)
 {
 	vma->anon_vma = (anon_vma_tree_t)anon_vma;
 }
 
-/* Return the VMA's anon_vma. */
+/* Return the VMA's anon_vma, or NULL if it is marked lazy. */
 static inline struct anon_vma *vma_anon_vma(const struct vm_area_struct *vma)
 {
 	/* Use READ_ONCE() for reusable_anon_vma */
 	anon_vma_tree_t anon_tree = READ_ONCE(vma->anon_vma);
 
+	if (anon_vma_tree_type(anon_tree) != ANON_VMA_TREE_REGULAR)
+		return NULL;
 	return anon_vma_tree_anon_vma(anon_tree);
 }
 
+static inline bool vma_is_anon_vma_lazy(const struct vm_area_struct *vma)
+{
+	return anon_vma_tree_type((anon_vma_tree_t)vma->anon_vma);
+}
+
+static inline const struct vm_area_struct *vma_anon_vma_lazy_root(
+	const struct vm_area_struct *vma)
+{
+	anon_vma_tree_t anon_tree = (anon_vma_tree_t)vma->anon_vma;
+	int lazy_type = anon_vma_tree_type(anon_tree);
+
+	if (!lazy_type)
+		return NULL;
+	if (anon_vma_tree_is_parent(anon_tree))
+		return vma;
+	return anon_vma_tree_vma(anon_tree);
+}
+
+static inline bool vma_is_anon_vma_lazy_root(const struct vm_area_struct *vma)
+{
+	return vma == vma_anon_vma_lazy_root(vma);
+}
+
+/*
+ * ANON_VMA_TREE_VMA is just a VMA, without anon_vma or anon_vma_chain,
+ * so no protection is needed.
+ */
 static inline void anon_vma_tree_lock_write(anon_vma_tree_t anon_tree)
 {
 	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
 
-	anon_vma_lock_write(anon_vma);
+	if (anon_vma)
+		anon_vma_lock_write(anon_vma);
 }
 
 static inline int anon_vma_tree_trylock_write(anon_vma_tree_t anon_tree)
 {
 	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
 
-	return anon_vma_trylock_write(anon_vma);
+	return anon_vma ? anon_vma_trylock_write(anon_vma) : 1;
 }
 
 static inline void anon_vma_tree_unlock_write(anon_vma_tree_t anon_tree)
 {
 	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
 
-	anon_vma_unlock_write(anon_vma);
+	if (anon_vma)
+		anon_vma_unlock_write(anon_vma);
 }
 
 static inline void anon_vma_tree_lock_read(anon_vma_tree_t anon_tree)
 {
 	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
 
-	anon_vma_lock_read(anon_vma);
+	if (anon_vma)
+		anon_vma_lock_read(anon_vma);
 }
 
 static inline int anon_vma_tree_trylock_read(anon_vma_tree_t anon_tree)
 {
 	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
 
-	return anon_vma_trylock_read(anon_vma);
+	return anon_vma ? anon_vma_trylock_read(anon_vma) : 1;
 }
 
 static inline void anon_vma_tree_unlock_read(anon_vma_tree_t anon_tree)
 {
 	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
 
-	anon_vma_unlock_read(anon_vma);
+	if (anon_vma)
+		anon_vma_unlock_read(anon_vma);
 }
 
 struct anon_vma *folio_get_anon_vma(const struct folio *folio);
diff --git a/mm/migrate.c b/mm/migrate.c
index 769983cf14e0..b397cdeab09a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1144,7 +1144,10 @@ static void __migrate_folio_record(struct folio *dst,
 				   int old_page_state,
 				   anon_rmap_t anon_rmap)
 {
-	dst->private = (void *)anon_rmap_to_anon_vma(anon_rmap) + old_page_state;
+	unsigned long rmap = anon_rmap_value(anon_rmap);
+
+	dst->private = (void *)(rmap & ~PAGE_OLD_STATES) + old_page_state;
+	dst->mapping = (struct address_space *)rmap;
 }
 
 static void __migrate_folio_extract(struct folio *dst,
@@ -1152,8 +1155,12 @@ static void __migrate_folio_extract(struct folio *dst,
 				   anon_rmap_t *anon_rmapp)
 {
 	unsigned long private = (unsigned long)dst->private;
+	unsigned long mapping = (unsigned long)dst->mapping;
 
-	*anon_rmapp = anon_vma_to_anon_rmap((void *)(private & ~PAGE_OLD_STATES));
+	VM_BUG_ON((private & ~PAGE_OLD_STATES) != (mapping & ~ANON_RMAP_TYPE_MASK));
+	*anon_rmapp = make_anon_rmap((void *)(mapping & ~ANON_RMAP_TYPE_MASK),
+		mapping & ANON_RMAP_TYPE_MASK);
+	dst->mapping = NULL;
 	*old_page_state = private & PAGE_OLD_STATES;
 	dst->private = NULL;
 }
diff --git a/mm/rmap.c b/mm/rmap.c
index 48c4463d8b2c..001c44570df8 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -794,42 +794,84 @@ anon_rmap_t vma_get_anon_rmap(struct vm_area_struct *vma)
 
 	mmap_assert_locked(vma->vm_mm);
 	VM_BUG_ON(!vma->anon_vma);
+	if (!anon_vma) {
+		vma_get(vma);
+		return vma_to_anon_rmap(vma);
+	}
 	get_anon_vma(anon_vma);
 	return anon_vma_to_anon_rmap(anon_vma);
 }
 
 void put_anon_rmap(anon_rmap_t anon_rmap)
 {
+	if (!anon_rmap_is_anon_vma(anon_rmap)) {
+		vma_put(anon_rmap_to_vma(anon_rmap));
+		return;
+	}
 	put_anon_vma(anon_rmap_to_anon_vma(anon_rmap));
 }
 
+/*
+ * Rmap for anonymous pages normally only needs read protection.
+ * However, huge page splitting in huge_memory requires the rmap
+ * write lock to prevent concurrency, achieved by upgrading to a
+ * regular anon_vma.
+ */
 void anon_rmap_lock_write(anon_rmap_t anon_rmap)
 {
+	VM_BUG_ON(!anon_rmap_is_anon_vma(anon_rmap));
 	anon_vma_lock_write(anon_rmap_to_anon_vma(anon_rmap));
 }
 
 int anon_rmap_trylock_write(anon_rmap_t anon_rmap)
 {
+	VM_BUG_ON(!anon_rmap_is_anon_vma(anon_rmap));
 	return anon_vma_trylock_write(anon_rmap_to_anon_vma(anon_rmap));
 }
 
 void anon_rmap_unlock_write(anon_rmap_t anon_rmap)
 {
+	VM_BUG_ON(!anon_rmap_is_anon_vma(anon_rmap));
 	anon_vma_unlock_write(anon_rmap_to_anon_vma(anon_rmap));
 }
 
+static void anon_vma_lazy_lock_read(struct vm_area_struct *vma)
+{
+	vma_get(vma);
+}
+
+static bool anon_vma_lazy_trylock_read(struct vm_area_struct *vma)
+{
+	return (bool)vma_get(vma);
+}
+
+static void anon_vma_lazy_unlock_read(struct vm_area_struct *vma)
+{
+	vma_put(vma);
+}
+
 void anon_rmap_lock_read(anon_rmap_t anon_rmap)
 {
+	if (!anon_rmap_is_anon_vma(anon_rmap)) {
+		anon_vma_lazy_lock_read(anon_rmap_to_vma(anon_rmap));
+		return;
+	}
 	anon_vma_lock_read(anon_rmap_to_anon_vma(anon_rmap));
 }
 
 int anon_rmap_trylock_read(anon_rmap_t anon_rmap)
 {
+	if (!anon_rmap_is_anon_vma(anon_rmap))
+		return anon_vma_lazy_trylock_read(anon_rmap_to_vma(anon_rmap));
 	return anon_vma_trylock_read(anon_rmap_to_anon_vma(anon_rmap));
 }
 
 void anon_rmap_unlock_read(anon_rmap_t anon_rmap)
 {
+	if (!anon_rmap_is_anon_vma(anon_rmap)) {
+		anon_vma_lazy_unlock_read(anon_rmap_to_vma(anon_rmap));
+		return;
+	}
 	anon_vma_unlock_read(anon_rmap_to_anon_vma(anon_rmap));
 }
 
-- 
2.17.1


