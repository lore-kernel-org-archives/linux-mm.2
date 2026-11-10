Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 309B760A263C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.a=rsa-sha256 header.s=default header.b=TWt8AEML
Received: by kanga.kvack.org (Postfix)
	id 7A7656B05B9; Mon,  9 Nov 2026 22:52:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D5C6B05BA; Mon,  9 Nov 2026 22:52:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC186B05BB; Mon,  9 Nov 2026 22:52:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D6FC6B05B9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:52:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9CE181203E5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:52:17 +0000 (UTC)
X-FDA: 85417836714.08.060589D
Received: from out28-149.mail.aliyun.com (out28-149.mail.aliyun.com [115.124.28.149])
	by imf07.hostedemail.com (Postfix) with ESMTP id DFC8640005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:52:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=xiaopeng.com header.s=default header.b=TWt8AEML;
	spf=pass (imf07.hostedemail.com: domain of fangxy@xiaopeng.com designates 115.124.28.149 as permitted sender) smtp.mailfrom=fangxy@xiaopeng.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794282736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KM6I2wapiJMH9zcOxQzL1rltNS2Qw0sgz3FFKrg5y0c=;
	b=q53camgs6EbNvRabdHnxpJ19Rf4qEzBwp//Kbg3nuk/qViq2Rr2KcxF0I+LfPRYjbzMNOc
	dVFdRHDEzunZkNZhsxmoDJvzFjL6JG4qM1E71Jlcu0tG8mvaYssbyJH6TaZR25DPeDf39E
	YG1j2ddn8cAaj8IVd/bdK/lBTapJ2UM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794282736;
	b=fmSIdc7wzt5S9XS3ysYJbhkXejppMmOD4KfGMaI2Lf9aSIZowekmyZO6QfEny5qAfZ7Gh7
	OkNLhNZ8bJGknWAdikaxEh4sde0BpK2QS12eckicGpKk6jhQOrDKckUfCoYwgfDAiVZQmW
	bSz+xsv7Q3U9IkZtG2XipPbZrBZeOk0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=xiaopeng.com header.s=default header.b=TWt8AEML;
	spf=pass (imf07.hostedemail.com: domain of fangxy@xiaopeng.com designates 115.124.28.149 as permitted sender) smtp.mailfrom=fangxy@xiaopeng.com;
	dmarc=none
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1794282732; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=KM6I2wapiJMH9zcOxQzL1rltNS2Qw0sgz3FFKrg5y0c=;
	b=TWt8AEMLcw3ZT1UVejVUGHKw8QYiZRdybg61RywC4442xZm68Oezr7M0uTVZ+zhlhdkmgddjrxfkzUsSvUNsholUHFq7hE6qiPpRalmvzjg04n2rgj2NwNXWGvDpeUJI7V/8PH7FjP6lSCK5TlE+EZ5iVK5S5w/1pCNGFRtJVrk=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.04436259|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00267489-2.96026e-05-0.997296;FP=2070378469248205683|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037026024;MF=fangxy@xiaopeng.com;NM=1;PH=DS;RN=28;RT=28;SR=0;TI=SMTPD_---.k-eCFni_1794282729;
Received: from localhost.localdomain(mailfrom:fangxy@xiaopeng.com fp:SMTPD_---.k-eCFni_1794282729 cluster:ay29)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 11:52:11 +0800
From: Fang Xieyan <fangxy@xiaopeng.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Carlos Maiolino <cem@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Liu Chao <liuc63@xiaopeng.com>
Subject: [RFC PATCH 2/3] mm: build file-backed folio splitting with CONFIG_LARGE_FOLIO
Date: Tue, 10 Nov 2026 11:52:04 +0800
Message-ID: <20261110035205.3036-3-fangxy@xiaopeng.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261110035205.3036-1-fangxy@xiaopeng.com>
References: <20261110035205.3036-1-fangxy@xiaopeng.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: zg4ua444r7jjhqzs5ino4cor33qrs38o
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DFC8640005
X-Rspam-User: 
X-HE-Tag: 1794282734-104980
X-HE-Meta: U2FsdGVkX18sdhkuoDl0bgfHj6OGgikz56fNHbqQNrdbIeU3t9w09qh1LhDQdL2WesRlZdNGoKt86CKeyi49NjP3oVXoLxW8+5dQGetm9gyFkbdp55q5R+c1tBpPBZ7HV7HQCUmH4/ENvf4hJH1P/mQ9Li4fHbCV2tr1iVYTlx6s3ozASifVEPpcsx7GgzaSszb9GgrobNoQfP7NhQHh8u9z4B9AW2t5L+RKYc4dSfn+pNQVDctG0nmWVGPaeddKV0pTaBqIwSMKCIr7+2fyfOUa//0nTiI2thigQxVbzvJJ4aiaNNtrG0d4MUzjDQYAMpPqaxT7cGt17PZZjC6RPvKclEx3dR8kodYCn025w3ee7FZ/ECh/C3kuwCY11fcqphvy6rXLdUHKMv6V2YR2jvEOLwpHJXgdh4eOompYY3aIAt295lufa38qIH6+NAa/h/pnf5u+LEr+o1Y0/FmPC1x+HrIhwvo4+895wIbHCay1sLx+2zCY7iphAEjUVTYotCUX+r1iPZ+hkwmrfeU2Pdjfe3d+BNQbb37GLH05rvDwX92HO13XwSDW5np/qhzvjty2IsJ5/35qOHMb+eJRHJ64SbqlTwb08F1kymAqM/2/i4YMYBQ8KK+5H8scItiAT4tYkZADKVg3EWICDjaG4XgRO6ahfWWXXdWSRxV+d2Ja9B56H8MUObSRtR0KfXNPbl92xlU4w26MGxJfexe+JmxRAi2d/kEQq0Zs0fcESTMyTdbW+02OtKfjAB6qvzt+ES3U5vlv7eKkJsLTDoxKiD+uRB5PWV27KP4dUwml951q1iLuuuSXNl8aklWvCRFGLvA7Z2+AZbhiB7jY+f+Pf6ObYxl46jocQFI2Ef4ridnU/jJm6YgSlApNbGz8f0JEsVVP1SQOQc+NP+ZotstGknosxcZszMbdbo7DdpGni75zM9Xie4QPatmbOQoJrD6FOp52qyjZAmeDLYRysiL
 KRwo+ibc
 0kp8JRCNZVcuIf6/CMype1lYRZaZydaZE4f90GOMNE45DlbylNg0xyEMrgUXhXgxx+tT+ytaL+m5vkucJAg+8vyFtye8CCF8yEdFYseQVw9tm4sMpCZNP+oXffFYxwbX0jMdE6sQJ3AnUmzrv77xVarwzz5X25yFr5tYkNGzbokTqFxrq+RQg/MbyHvC4/VnDLvmX0MrRbc0hQ34t+6BwXhtPV6HeyBCZxbt9WhY4jESyCpuP8NeRsdeJVnPL1cxK2E6EI04jZazwNTcJa7H0xaXGrVYiCGvnTC2JHl4gv6/CisqWOAhiJYcY5qgYvBxjKdiHQtNU1v/E4eg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Transparent hugepages gate the folio split implementation, so a
filesystem cannot split a large page-cache folio when THP is disabled.
Add CONFIG_LARGE_FOLIO to build that code on its own.

This only makes splitting possible; it does not enable large folio
allocation.  The page cache still caps folios at order 0 through
mapping_max_folio_order() and friends in pagemap.h, which are left
untouched here.

The anonymous path stays behind CONFIG_TRANSPARENT_HUGEPAGE.  Large
anonymous folios are supported only by the THP/mTHP implementation, so
with LARGE_FOLIO alone the anonymous split dispatch returns
-EOPNOTSUPP instead of attempting to walk an anon_vma that cannot
exist, while requests that fail the checks ahead of it keep returning
-EINVAL or -EBUSY.  Inside unmap_folio(), the same condition replaces
try_to_migrate() with -EOPNOTSUPP for anon folios;
__folio_freeze_split_anon(), remap_anon_folio() and
folio_swapcache_ref_count() are not compiled at all.

The split API in huge_mm.h that LARGE_FOLIO needs moves out of the THP
block into a gate of its own.  folio_split_unmapped() is anonymous
only, so its declaration stays behind CONFIG_TRANSPARENT_HUGEPAGE,
matching its definition.  The existing !THP stubs stay for the case
where neither option is set.  ClearPageCompound() in page-flags.h needs
the same treatment.

Two THP-specific accounting sites move with the code, and both keep a
CONFIG_TRANSPARENT_HUGEPAGE guard, but for different reasons.

THP_SPLIT_PAGE and THP_SPLIT_PAGE_FAILED only exist in the THP block of
the vm_event enum, so the __folio_split() epilogue that counts them has
to be guarded.

The NR_FILE_THPS/NR_SHMEM_THPS adjustment in
__folio_freeze_split_file() is file-backed code and is guarded for two
other reasons.  folio_test_pmd_mappable() is a false stub without THP,
so the test could never fire, and the comparison is written in terms of
HPAGE_PMD_ORDER, which is HPAGE_PMD_SHIFT - PAGE_SHIFT where
HPAGE_PMD_SHIFT expands to BUILD_BUG() unless
CONFIG_PGTABLE_HAS_HUGE_LEAVES is set.  That option is def_bool
TRANSPARENT_HUGEPAGE || HUGETLB_PAGE, so HUGETLBFS can provide it
without THP: HPAGE_PMD_ORDER and is_pmd_order() are not THP-only
constructs, only this particular accounting test is dropped.

THP builds are unaffected: with both options set the preprocessed
output is unchanged, and mm/huge_memory.o and mm/folio_split.o are
byte-identical to the previous commit.

Reviewed-by: Liu Chao <liuc63@xiaopeng.com>
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
---
 include/linux/huge_mm.h    | 60 +++++++++++++++++++++++---------------
 include/linux/page-flags.h |  5 +++-
 mm/Kconfig                 | 12 ++++++++
 mm/Makefile                |  3 +-
 mm/folio_split.c           | 30 ++++++++++++++++---
 5 files changed, 80 insertions(+), 30 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index b4b91b748..458e44044 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -179,8 +179,37 @@ static inline void count_mthp_stat(int order, enum mthp_stat_item item)
 }
 #endif
 
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_LARGE_FOLIO)
+enum split_type {
+	SPLIT_TYPE_UNIFORM,
+	SPLIT_TYPE_NON_UNIFORM,
+};
+
+int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+		unsigned int new_order);
+unsigned int min_order_for_split(struct folio *folio);
+int split_folio_to_list(struct folio *folio, struct list_head *list);
+int folio_check_splittable(struct folio *folio, unsigned int new_order,
+			   enum split_type split_type);
+int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
+		struct list_head *list);
+
+static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+		unsigned int new_order)
+{
+	return __split_huge_page_to_list_to_order(page, list, new_order);
+}
+static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
+{
+	return split_huge_page_to_list_to_order(page, NULL, new_order);
+}
+#endif
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
+/* Only anon folios can be split while they are unmapped. */
+int folio_split_unmapped(struct folio *folio, unsigned int new_order);
+
 extern unsigned long transparent_hugepage_flags;
 extern unsigned long huge_anon_orders_always;
 extern unsigned long huge_anon_orders_madvise;
@@ -394,30 +423,6 @@ unsigned long thp_get_unmapped_area_vmaflags(struct file *filp, unsigned long ad
 		unsigned long len, unsigned long pgoff, unsigned long flags,
 		vma_flags_t vma_flags);
 
-enum split_type {
-	SPLIT_TYPE_UNIFORM,
-	SPLIT_TYPE_NON_UNIFORM,
-};
-
-int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-		unsigned int new_order);
-int folio_split_unmapped(struct folio *folio, unsigned int new_order);
-unsigned int min_order_for_split(struct folio *folio);
-int split_folio_to_list(struct folio *folio, struct list_head *list);
-int folio_check_splittable(struct folio *folio, unsigned int new_order,
-			   enum split_type split_type);
-int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
-		struct list_head *list);
-
-static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-		unsigned int new_order)
-{
-	return __split_huge_page_to_list_to_order(page, list, new_order);
-}
-static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
-{
-	return split_huge_page_to_list_to_order(page, NULL, new_order);
-}
 
 static inline int split_huge_page(struct page *page)
 {
@@ -641,6 +646,7 @@ thp_get_unmapped_area_vmaflags(struct file *filp, unsigned long addr,
 	return 0;
 }
 
+#if !IS_ENABLED(CONFIG_LARGE_FOLIO)
 static inline int
 split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order)
@@ -653,12 +659,16 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
 	VM_WARN_ON_ONCE_PAGE(1, page);
 	return -EINVAL;
 }
+#endif
+
 static inline int split_huge_page(struct page *page)
 {
 	VM_WARN_ON_ONCE_PAGE(1, page);
 	return -EINVAL;
 }
 
+#if !IS_ENABLED(CONFIG_LARGE_FOLIO)
+
 static inline unsigned int min_order_for_split(struct folio *folio)
 {
 	VM_WARN_ON_ONCE_FOLIO(1, folio);
@@ -677,6 +687,8 @@ static inline int folio_split(struct folio *folio, unsigned int new_order,
 	VM_WARN_ON_ONCE_FOLIO(1, folio);
 	return -EINVAL;
 }
+#endif
+
 
 static inline int folio_memcg_alloc_deferred(struct folio *folio)
 {
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index b0ddc652e..6561ee02e 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -869,12 +869,15 @@ static inline bool folio_test_large(const struct folio *folio)
 	return folio_test_head(folio);
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_LARGE_FOLIO)
 static inline void ClearPageCompound(struct page *page)
 {
 	BUG_ON(!PageHead(page));
 	ClearPageHead(page);
 }
+#endif
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 FOLIO_FLAG(large_rmappable, FOLIO_SECOND_PAGE)
 FOLIO_FLAG(partially_mapped, FOLIO_SECOND_PAGE)
 #else
diff --git a/mm/Kconfig b/mm/Kconfig
index afff1b25b..9f97ad698 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -827,6 +827,18 @@ config PERSISTENT_HUGE_ZERO_FOLIO
 config MM_ID
 	def_bool n
 
+config LARGE_FOLIO
+	bool "Large folio support for the page cache (without THP)" if !TRANSPARENT_HUGEPAGE
+	depends on MMU
+	select XARRAY_MULTI
+	default y if TRANSPARENT_HUGEPAGE
+	default n
+	help
+	  Build the folio split implementation for page-cache large folios
+	  even when transparent hugepages are disabled.  Transparent
+	  hugepages imply this option; this option alone does not enable
+	  large folio allocation, it only makes splitting them possible.
+
 menuconfig TRANSPARENT_HUGEPAGE
 	bool "Transparent Hugepage Support"
 	depends on HAVE_ARCH_TRANSPARENT_HUGEPAGE && !PREEMPT_RT
diff --git a/mm/Makefile b/mm/Makefile
index 7f7f2c114..a1619ea47 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -100,7 +100,8 @@ obj-$(CONFIG_MEMTEST)		+= memtest.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
-obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += folio_split.o huge_memory.o khugepaged.o
+obj-$(CONFIG_LARGE_FOLIO) += folio_split.o
+obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
 obj-$(CONFIG_LIVEUPDATE_MEMFD) += memfd_luo.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
diff --git a/mm/folio_split.c b/mm/folio_split.c
index 7770d8215..91b3d78ba 100644
--- a/mm/folio_split.c
+++ b/mm/folio_split.c
@@ -49,16 +49,22 @@ static int unmap_folio(struct folio *folio)
 	 * Anon pages need migration entries to preserve them, but file
 	 * pages can simply be left unmapped, then faulted back on demand.
 	 */
-	if (folio_test_anon(folio))
+	if (folio_test_anon(folio)) {
+#if IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)
 		try_to_migrate(folio, ttu_flags);
-	else
+#else
+		return -EOPNOTSUPP;
+#endif
+	} else {
 		try_to_unmap(folio, ttu_flags | TTU_IGNORE_MLOCK);
+	}
 
 	try_to_unmap_flush();
 
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)
 static void remap_anon_folio(struct folio *folio, unsigned long nr, int flags)
 {
 	int i = 0;
@@ -78,6 +84,7 @@ static void remap_anon_folio(struct folio *folio, unsigned long nr, int flags)
 		folio = folio_next(folio);
 	}
 }
+#endif
 
 static void lru_add_split_folio(struct folio *folio, struct folio *new_folio,
 		struct lruvec *lruvec, struct list_head *list)
@@ -409,6 +416,7 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)
 /* Number of folio references from the swapcache. */
 static unsigned int folio_swapcache_ref_count(const struct folio *folio)
 {
@@ -416,6 +424,7 @@ static unsigned int folio_swapcache_ref_count(const struct folio *folio)
 		return 0;
 	return folio_nr_pages(folio);
 }
+#endif
 
 void folio_reset_partially_mapped(struct folio *folio)
 {
@@ -436,6 +445,7 @@ void folio_reset_partially_mapped(struct folio *folio)
 		      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 }
 
+#if IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)
 static int __folio_freeze_split_anon(struct folio *folio,
 		unsigned int new_order, struct page *split_at, bool do_lru,
 		struct list_head *list, enum split_type split_type)
@@ -544,6 +554,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 
 	return ret;
 }
+#endif
 
 static int __folio_freeze_split_file(struct folio *folio,
 		unsigned int new_order, struct page *split_at,
@@ -628,12 +639,14 @@ static int __folio_freeze_split_file(struct folio *folio,
 		goto fail;
 	}
 
+#if IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)
 	if (folio_test_pmd_mappable(folio) && new_order < HPAGE_PMD_ORDER) {
 		if (folio_test_swapbacked(folio))
 			lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -old_nr_pages);
 		else
 			lruvec_stat_mod_folio(folio, NR_FILE_THPS, -old_nr_pages);
 	}
+#endif
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 	lruvec = folio_lruvec_lock(folio);
@@ -755,12 +768,17 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		goto out;
 	}
 
-	if (is_anon)
+	if (is_anon) {
+#if IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
-	else
+#else
+		ret = -EOPNOTSUPP;
+#endif
+	} else {
 		ret = __folio_freeze_split_file(folio, new_order, split_at,
 						list, split_type);
+	}
 
 	/*
 	 * Unlock all after-split folios except the one containing
@@ -784,12 +802,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	}
 
 out:
+#if IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)
 	if (is_pmd_order(old_order))
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
+#endif
 	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
 	return ret;
 }
 
+#if IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)
 /**
  * folio_split_unmapped() - split a large anon folio that is already unmapped
  * @folio: folio to split
@@ -822,6 +843,7 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	return __folio_freeze_split_anon(folio, new_order, &folio->page,
 					 false, NULL, SPLIT_TYPE_UNIFORM);
 }
+#endif
 
 /*
  * This function splits a large folio into smaller folios of order @new_order.
-- 
2.50.1


