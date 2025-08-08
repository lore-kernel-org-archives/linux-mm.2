Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53A7C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 12:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77BB46B009A; Fri,  8 Aug 2025 08:12:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 753466B009B; Fri,  8 Aug 2025 08:12:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690516B009C; Fri,  8 Aug 2025 08:12:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 598146B009A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:12:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 124A9114C2F
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:12:27 +0000 (UTC)
X-FDA: 83753477934.07.B22CF47
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4387AA0011
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:12:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=UsdtWbA+;
	spf=pass (imf15.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754655145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZkxZ7QW6s5ZKu2i85aJc2GTh+whFy9VHW8uyKtViYI8=;
	b=H5pxyT89bCN5yMSJU+EEQUl8BnCOT4HrD/dXFNRo37ueB+FRthNG4NyLbTl6DYcYmr4j7x
	9+6WLk4BoxBNyT3I4CstK4DKgX8Il5nVf18ZNJxpqNmVMt8L0GI3ObKSzoeGn6FPgBD/wK
	VET6m59Ux+Bh79Xj+NlobRN1xfC5TsA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754655145; a=rsa-sha256;
	cv=none;
	b=SXgm97CyxbMq23Hhzw3JC+5QOWH+lNhzOTbPsqVFLjBzOBqykdbrhxGmzHk/rLFQrckwnz
	2wz3DMRIa4uTlKRgDFr5aaeFcyuktMAncv1NNb8LQGHlbnYhmwXDfm7J70DO7pxsaDu2aX
	e+BbIllu2cQn+npYnb4BgAP91IF3+m4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=UsdtWbA+;
	spf=pass (imf15.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4bz2w551rfz9tSn;
	Fri,  8 Aug 2025 14:12:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754655141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZkxZ7QW6s5ZKu2i85aJc2GTh+whFy9VHW8uyKtViYI8=;
	b=UsdtWbA+ZXAMIqKaUAGrDqGrruRGlMpTLff0D4siWPiVWEgGfdqzwLg28eAuI60yZjOOGg
	24OduPrNN+7S4Mu6G9JsupNuUbYv60MTtOK+x+uaAIK+mb/XhF9tEzHKCIjF2XmjpamkGV
	ZwcVbhcTKbAoQ841LsFQQinDq5LLfCgWRVy+bQkDBWDP46eaAEOMHX3ToR2nwYPbVJf4vS
	ShviFNVpUS/+7zJ8mgNQpEKmDcjGF9zU9St7+snTSC7ZLh+x1zK76Rozb+Rfywi2ic+67A
	QUyseN7xZxQmps66NAVNua09UXn1RP6F7CDmOaY4favxqDmmmraFwGmplkA5BQ==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Michal Hocko <mhocko@suse.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	willy@infradead.org,
	linux-mm@kvack.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v2 3/5] mm: add persistent huge zero folio
Date: Fri,  8 Aug 2025 14:11:39 +0200
Message-ID: <20250808121141.624469-4-kernel@pankajraghav.com>
In-Reply-To: <20250808121141.624469-1-kernel@pankajraghav.com>
References: <20250808121141.624469-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4387AA0011
X-Stat-Signature: siumci3fo5ykyqb6n1zz5xc95can4g41
X-Rspam-User: 
X-HE-Tag: 1754655145-939382
X-HE-Meta: U2FsdGVkX1+2y28bYGRNqtUaLTH0MRAN5vDX/QPjZnNZaN7NQi8MHw03ZN4yN+nbazayO0d0U7mrDCBWuoJiSLB9Zg+diRsjXgada1MDNLEU3MUx8fix+24b5PZerN+lbdNLfjR2Ztc9mJuF+xkbGiTLruZYuVDvLGhYxgdBoWP0BZ1h1/ylntCsCyIp+4jVe3jgGQwOKwIQEDADfD3LSdYM5USDaFynlmTpyAPfyjY2L1H3+TUF0RML3Of8es96gYjCWG59lO9sxNIBp8Ydq43WYoLx0hXxN9j/SJH1EHOJ6zBU52imIEKtvPImsP0od5haEiPfXMs4T9SqBamYE0DeDSQ1wDqtEBmP7pzCCFXXE8oaAGTIhqJT4KQzx2xPpiyN8HVfJ8yUQ+Bj9Z/tY4omoqNkeyG1hqF89aS/AUu5jE/P0ur8nJQNXGu6obOlkGvJnf92EBSBPyXrg8fvNdEnEAi0t6do+2C/YU7XYrGUalYvT2aMxjDRF3V93u6vOweHpJNWCBI4kcOCrwwL+j1Po3jiHAz5xrbJgoxNREYtaRVHlyv5yC6oV1/8FQg/cMk+KMGXCusNy96VTMusum77yTlLzje8xcTd8TAqtxT7p85vPd3dUma536V5jcvAuOMGIesZa5cmr2nCa0LqUM06tk4siO36YFyP3Rlj8kRHYqPJ1ZVMzMPEzz6lyD3eiDxwMASY4zKi3vX+X7hEzTkZKvVvCSzfH1K9G4yqW5eSfzZYbKXrqi2Zhl/w+OANfm4z6j/ys8uPasDkUi7I/pphrY1hixBJ79GAuUfYEoiPin3bDDU6UW99e3yLqstrMMSm+f6Ec8I87NT/ZNg+o8Q41EpA7bZNZkOwhmFsNZF/rpNFOd3lnDwsVUhcgcLShpyJhuyz7Gt/fAIJcO9OPVbrbQLVoPdrX04r+7nM0zUjNtBSVq6noFo6GF4JVvN7eH3XjaTIPm2d+5tC7R6
 lluKEbx4
 A+lsn6UXMnoNxb3PhpI59+/2uqjl2D7sEDpfCeeWGEXJrTVDiET0b4kzDZqrvyzJM1qfyxxaDMjZ8kfMUTFS8pdAAUOLXQqvFaq4aj+3wGRe2h1EKWWeUT3H6I4XNtmFKUTOP3AvXLQo2iaqJRbzXZwNnW87zpWapqEOOVwE42uQ+OYD/k/CcSV1RVOd9BEEQTy2oYD8WqKsKeKwdiyggicbvw4N9sesow8N1Y3zIMgRhKafq+VLghrgjaUueozOEM+ZSVU8DpDVCiuhnsYEjfftwNhg+X8f1xejUaThzoB7rBhn9fJKcPvBiuAIjjXo28gBDmE77OiPnNKdHK1X7XuO4mAMin2bfwiWCYUsISSatIbnYiV+n0WZ+pDfWdVuNF/3R/RAmx0wqkdPDeZF/TfewSUiYNeucXUhMPsUJ17hZi6N054WCAm64aqumnaK+HT3zoJrPSwVj0e6OjpcVav0X6sg/0W2BmzXJGq5R3mUobOelKiyAEvePBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

Many places in the kernel need to zero out larger chunks, but the
maximum segment that can be zeroed out at a time by ZERO_PAGE is limited
by PAGE_SIZE.

This is especially annoying in block devices and filesystems where
multiple ZERO_PAGEs are attached to the bio in different bvecs. With
multipage bvec support in block layer, it is much more efficient to send
out larger zero pages as a part of single bvec.

This concern was raised during the review of adding Large Block Size
support to XFS[1][2].

Usually huge_zero_folio is allocated on demand, and it will be
deallocated by the shrinker if there are no users of it left. At moment,
huge_zero_folio infrastructure refcount is tied to the process lifetime
that created it. This might not work for bio layer as the completions
can be async and the process that created the huge_zero_folio might no
longer be alive. And, one of the main points that came up during
discussion is to have something bigger than zero page as a drop-in
replacement.

Add a config option PERSISTENT_HUGE_ZERO_FOLIO that will result in
allocating the huge zero folio during early init and never free the memory
by disabling the shrinker. This makes using the huge_zero_folio without
having to pass any mm struct and does not tie the lifetime of the zero
folio to anything, making it a drop-in replacement for ZERO_PAGE.

If PERSISTENT_HUGE_ZERO_FOLIO config option is enabled, then
mm_get_huge_zero_folio() will simply return the allocated page instead of
dynamically allocating a new PMD page.

Use this option carefully in resource constrained systems as it uses
one full PMD sized page for zeroing purposes.

[1] https://lore.kernel.org/linux-xfs/20231027051847.GA7885@lst.de/
[2] https://lore.kernel.org/linux-xfs/ZitIK5OnR7ZNY0IG@infradead.org/

Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 include/linux/huge_mm.h | 16 ++++++++++++++++
 mm/Kconfig              | 16 ++++++++++++++++
 mm/huge_memory.c        | 40 ++++++++++++++++++++++++++++++----------
 3 files changed, 62 insertions(+), 10 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 7748489fde1b..bd547857c6c1 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -495,6 +495,17 @@ static inline bool is_huge_zero_pmd(pmd_t pmd)
 struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
 void mm_put_huge_zero_folio(struct mm_struct *mm);
 
+static inline struct folio *get_persistent_huge_zero_folio(void)
+{
+	if (!IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO))
+		return NULL;
+
+	if (unlikely(!huge_zero_folio))
+		return NULL;
+
+	return huge_zero_folio;
+}
+
 static inline bool thp_migration_supported(void)
 {
 	return IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION);
@@ -685,6 +696,11 @@ static inline int change_huge_pud(struct mmu_gather *tlb,
 {
 	return 0;
 }
+
+static inline struct folio *get_persistent_huge_zero_folio(void)
+{
+	return NULL;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static inline int split_folio_to_list_to_order(struct folio *folio,
diff --git a/mm/Kconfig b/mm/Kconfig
index e443fe8cd6cf..fbe86ef97fd0 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -823,6 +823,22 @@ config ARCH_WANT_GENERAL_HUGETLB
 config ARCH_WANTS_THP_SWAP
 	def_bool n
 
+config PERSISTENT_HUGE_ZERO_FOLIO
+	bool "Allocate a PMD sized folio for zeroing"
+	depends on TRANSPARENT_HUGEPAGE
+	help
+	  Enable this option to reduce the runtime refcounting overhead
+	  of the huge zero folio and expand the places in the kernel
+	  that can use huge zero folios. This can potentially improve
+	  the performance while performing an I/O.
+
+	  With this option enabled, the huge zero folio is allocated
+	  once and never freed. One full huge page worth of memory shall
+	  be used.
+
+	  Say Y if your system has lots of memory. Say N if you are
+	  memory constrained.
+
 config MM_ID
 	def_bool n
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ff06dee213eb..bedda9640936 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -248,6 +248,9 @@ static void put_huge_zero_folio(void)
 
 struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
 {
+	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO))
+		return huge_zero_folio;
+
 	if (test_bit(MMF_HUGE_ZERO_FOLIO, &mm->flags))
 		return READ_ONCE(huge_zero_folio);
 
@@ -262,6 +265,9 @@ struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
 
 void mm_put_huge_zero_folio(struct mm_struct *mm)
 {
+	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO))
+		return;
+
 	if (test_bit(MMF_HUGE_ZERO_FOLIO, &mm->flags))
 		put_huge_zero_folio();
 }
@@ -849,16 +855,34 @@ static inline void hugepage_exit_sysfs(struct kobject *hugepage_kobj)
 
 static int __init thp_shrinker_init(void)
 {
-	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
-	if (!huge_zero_folio_shrinker)
-		return -ENOMEM;
-
 	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
 						 SHRINKER_MEMCG_AWARE |
 						 SHRINKER_NONSLAB,
 						 "thp-deferred_split");
-	if (!deferred_split_shrinker) {
-		shrinker_free(huge_zero_folio_shrinker);
+	if (!deferred_split_shrinker)
+		return -ENOMEM;
+
+	deferred_split_shrinker->count_objects = deferred_split_count;
+	deferred_split_shrinker->scan_objects = deferred_split_scan;
+	shrinker_register(deferred_split_shrinker);
+
+	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO)) {
+		/*
+		 * Bump the reference of the huge_zero_folio and do not
+		 * initialize the shrinker.
+		 *
+		 * huge_zero_folio will always be NULL on failure. We assume
+		 * that get_huge_zero_folio() will most likely not fail as
+		 * thp_shrinker_init() is invoked early on during boot.
+		 */
+		if (!get_huge_zero_folio())
+			pr_warn("Allocating static huge zero folio failed\n");
+		return 0;
+	}
+
+	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
+	if (!huge_zero_folio_shrinker) {
+		shrinker_free(deferred_split_shrinker);
 		return -ENOMEM;
 	}
 
@@ -866,10 +890,6 @@ static int __init thp_shrinker_init(void)
 	huge_zero_folio_shrinker->scan_objects = shrink_huge_zero_folio_scan;
 	shrinker_register(huge_zero_folio_shrinker);
 
-	deferred_split_shrinker->count_objects = deferred_split_count;
-	deferred_split_shrinker->scan_objects = deferred_split_scan;
-	shrinker_register(deferred_split_shrinker);
-
 	return 0;
 }
 
-- 
2.49.0


