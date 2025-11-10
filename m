Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D55C9CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 23:21:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 449A88E000E; Mon, 10 Nov 2025 18:21:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F9E98E0003; Mon, 10 Nov 2025 18:21:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 337558E000E; Mon, 10 Nov 2025 18:21:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 242838E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:21:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CFB2A1602D9
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 23:21:26 +0000 (UTC)
X-FDA: 84096270972.09.7DB71BE
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1EA308000B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 23:21:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R4NU6Q8J;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762816885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KeXZlzM9S/cAH2YiJk+aaehPaWC6sAatt90g+33TR9M=;
	b=TLNhfVmQXNp3d/ZOtawPkeLbsAjrXqtIM9RD103ZAp7PJy1KK5tlgU0qAqJftFS1cQ+NNf
	Ik12OW3Xmrfqz5j3OC8KJOqyrmj82aVlmfAqQ5CVop+E3bz9ll6tEqBQsDLtqJLq8RpsSQ
	FiE6czV0BA/Rxv+3W8cLWeXw4Fpjl6g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R4NU6Q8J;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762816885; a=rsa-sha256;
	cv=none;
	b=vqS3L8VlIli5Kzq2zrkC+bXb0o8GmNDrNokf9ZIjzIvITD3cC1QrUy+QPYCofVjeu8SVI5
	heIzPoOKEKTU3NM7LxpumdccRf3aFvAw0DtyGgQVrw1xzRhpqyHA9KmDVqH/tgYIxkRTr/
	y5cYI821qRpiDSV/j45D5QUZaySrXxE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762816883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KeXZlzM9S/cAH2YiJk+aaehPaWC6sAatt90g+33TR9M=;
	b=R4NU6Q8JCz+vv5o5XmD4mFPnZiEkcZEeGblXosVFQw+RFf9leuRmhR0urgV21dHwZQIuL9
	T3w0t0fzyPiOGdBbxvlt0vGbaBSsux7ELLDLlXmNEd0BBaDNtaUNWI0NmH6bvA0RUStsI0
	ANDzkbGwvlFROHEOOQpmnoW1jnNzIAk=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: [PATCH 4/4] memcg: remove __lruvec_stat_mod_folio
Date: Mon, 10 Nov 2025 15:20:08 -0800
Message-ID: <20251110232008.1352063-5-shakeel.butt@linux.dev>
In-Reply-To: <20251110232008.1352063-1-shakeel.butt@linux.dev>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1EA308000B
X-Stat-Signature: jfcogigzzw58k58x89hsfkcw377ghinh
X-Rspam-User: 
X-HE-Tag: 1762816884-731339
X-HE-Meta: U2FsdGVkX19zMunvRLWL8jV7BQekeFfCkqoD3LkODHm3KyOxvMPTgwfeqzfIDLqIYMOpP8nt1A5J7N2OK8WYDIfjDbLHLnrzw/m0lJUNjCIiQ0X9Z/MpYYVTCU4OwatST1vZhYotX9Hke4caqkC5LqLIPqBEaK+Fr2hMoiDTPe3dhBF6fjuvVbZ+4gDtrirQFGBsTKvq22rNHupMbc+/zl7Rt49bGVAJR5egwJ2Yq0XJsQTCksNrAnmYBJNFCvbc//mrecR11vdWRIIKEZAcITa7bh6JT2SQtmIIfHW10gmsX1Hw0fmDjEIzmZkjk2MuTzZyTPr9dtxDBpdqzWz7Gg9wGfrZKRYC1J1B+dQQEoFf9iLubTMSz5A9+/lQHSSaM1qQTCUmKdYl5bHfebB7SbCvWdFLknoeoi840Crr2ZzKgAlzkLWsMdOh1S1pddnUbujlRkCeiBhqHzGG+2ONmH3PuNyB3W1/+BVB5aXgblVwk2WpmI1LQ+PBUUOKw4bA+36w7QPHezxOaH7llpxAigS2LD4+hFcZKhnl7PJe7vTGGDVgXLSU/Tvm39mh1BZWXz6kEr2eihnyC8vH4CBaP2QTCv1xb2Lw8AxFclMLc0K+mLd7DCtMX4nEjicCm+S/UqQbSZ7XxE6v3xqQvkCenrTW4Qdrc4qkhdQDI+dkBIfK3d6VMtHWJ5XAqWt1a/mIqaGAMD3bMO0FlOKNx1KClq+ecaWvv+IHqCglr+rb1F+C+rvcVOQH7QURWLPNKjW2NkbvYORRXl/SeuMcuO7a/pw9vyRwbDljWoMsglS6vYlZsQv/A+0fqWA3dmkjxHmmdKlM5xLBvyPVuagG4bSTW8tCtOcJUHvEuBCFeJ8mDiMj2UpJaRdRJx8dXi9u1EVZa3K0/Aa0F4R5mR2kly2HKvg9W+AU7AbREAGWYTBzuaAnIq8rKH2lGytPZ4RDF/REbfi2IpcJGnI/PO02OzP
 8DKB4vEd
 CRaejsR/ehoKDPZUrDhlZJvWglx685WuUhVQlkkMW82jvy/MUwQKtW+HREEOUw2weNoiHK1ZFgs3OXu4mOAVAa+hNxHX1nEECk9Fs0xbqNOdPoHXCTOF6/5kG0fxr6uagvfpH2ikjXYbMmnd2jhsVAxL8izCf/2weyzKyq1e1q0DwKWmGPhltV+QhlYNHJwU671loiQQ3dmoFnolzUtWbUBV0cileobDWNwLwX/0VC7drHmBgEFrQElZ2OoP16wGNYSVS1eRr7NXT7BfUVsSEfENsfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The __lruvec_stat_mod_folio is already safe against irqs, so there is no
need to have a separate interface (i.e. lruvec_stat_mod_folio) which
wraps calls to it with irq disabling and reenabling. Let's rename
__lruvec_stat_mod_folio to lruvec_stat_mod_folio.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/vmstat.h | 30 +-----------------------------
 mm/filemap.c           | 20 ++++++++++----------
 mm/huge_memory.c       |  4 ++--
 mm/khugepaged.c        |  8 ++++----
 mm/memcontrol.c        |  4 ++--
 mm/page-writeback.c    |  2 +-
 mm/rmap.c              |  4 ++--
 mm/shmem.c             |  6 +++---
 8 files changed, 25 insertions(+), 53 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 4eb7753e6e5c..3398a345bda8 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -523,19 +523,9 @@ static inline const char *vm_event_name(enum vm_event_item item)
 void mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val);
 
-void __lruvec_stat_mod_folio(struct folio *folio,
+void lruvec_stat_mod_folio(struct folio *folio,
 			     enum node_stat_item idx, int val);
 
-static inline void lruvec_stat_mod_folio(struct folio *folio,
-					 enum node_stat_item idx, int val)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__lruvec_stat_mod_folio(folio, idx, val);
-	local_irq_restore(flags);
-}
-
 static inline void mod_lruvec_page_state(struct page *page,
 					 enum node_stat_item idx, int val)
 {
@@ -550,12 +540,6 @@ static inline void mod_lruvec_state(struct lruvec *lruvec,
 	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
 }
 
-static inline void __lruvec_stat_mod_folio(struct folio *folio,
-					 enum node_stat_item idx, int val)
-{
-	mod_node_page_state(folio_pgdat(folio), idx, val);
-}
-
 static inline void lruvec_stat_mod_folio(struct folio *folio,
 					 enum node_stat_item idx, int val)
 {
@@ -570,18 +554,6 @@ static inline void mod_lruvec_page_state(struct page *page,
 
 #endif /* CONFIG_MEMCG */
 
-static inline void __lruvec_stat_add_folio(struct folio *folio,
-					   enum node_stat_item idx)
-{
-	__lruvec_stat_mod_folio(folio, idx, folio_nr_pages(folio));
-}
-
-static inline void __lruvec_stat_sub_folio(struct folio *folio,
-					   enum node_stat_item idx)
-{
-	__lruvec_stat_mod_folio(folio, idx, -folio_nr_pages(folio));
-}
-
 static inline void lruvec_stat_add_folio(struct folio *folio,
 					 enum node_stat_item idx)
 {
diff --git a/mm/filemap.c b/mm/filemap.c
index 63eb163af99c..9a52fb3ba093 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -182,13 +182,13 @@ static void filemap_unaccount_folio(struct address_space *mapping,
 
 	nr = folio_nr_pages(folio);
 
-	__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, -nr);
+	lruvec_stat_mod_folio(folio, NR_FILE_PAGES, -nr);
 	if (folio_test_swapbacked(folio)) {
-		__lruvec_stat_mod_folio(folio, NR_SHMEM, -nr);
+		lruvec_stat_mod_folio(folio, NR_SHMEM, -nr);
 		if (folio_test_pmd_mappable(folio))
-			__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -nr);
+			lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -nr);
 	} else if (folio_test_pmd_mappable(folio)) {
-		__lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
+		lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
 		filemap_nr_thps_dec(mapping);
 	}
 	if (test_bit(AS_KERNEL_FILE, &folio->mapping->flags))
@@ -831,13 +831,13 @@ void replace_page_cache_folio(struct folio *old, struct folio *new)
 	old->mapping = NULL;
 	/* hugetlb pages do not participate in page cache accounting. */
 	if (!folio_test_hugetlb(old))
-		__lruvec_stat_sub_folio(old, NR_FILE_PAGES);
+		lruvec_stat_sub_folio(old, NR_FILE_PAGES);
 	if (!folio_test_hugetlb(new))
-		__lruvec_stat_add_folio(new, NR_FILE_PAGES);
+		lruvec_stat_add_folio(new, NR_FILE_PAGES);
 	if (folio_test_swapbacked(old))
-		__lruvec_stat_sub_folio(old, NR_SHMEM);
+		lruvec_stat_sub_folio(old, NR_SHMEM);
 	if (folio_test_swapbacked(new))
-		__lruvec_stat_add_folio(new, NR_SHMEM);
+		lruvec_stat_add_folio(new, NR_SHMEM);
 	xas_unlock_irq(&xas);
 	if (free_folio)
 		free_folio(old);
@@ -920,9 +920,9 @@ noinline int __filemap_add_folio(struct address_space *mapping,
 
 		/* hugetlb pages do not participate in page cache accounting */
 		if (!huge) {
-			__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr);
+			lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr);
 			if (folio_test_pmd_mappable(folio))
-				__lruvec_stat_mod_folio(folio,
+				lruvec_stat_mod_folio(folio,
 						NR_FILE_THPS, nr);
 		}
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 949250932bb4..943099eae8d5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3866,10 +3866,10 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			if (folio_test_pmd_mappable(folio) &&
 			    new_order < HPAGE_PMD_ORDER) {
 				if (folio_test_swapbacked(folio)) {
-					__lruvec_stat_mod_folio(folio,
+					lruvec_stat_mod_folio(folio,
 							NR_SHMEM_THPS, -nr);
 				} else {
-					__lruvec_stat_mod_folio(folio,
+					lruvec_stat_mod_folio(folio,
 							NR_FILE_THPS, -nr);
 					filemap_nr_thps_dec(mapping);
 				}
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1a08673b0d8b..2a460664a67d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2174,14 +2174,14 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	}
 
 	if (is_shmem)
-		__lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
+		lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
 	else
-		__lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
+		lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
 
 	if (nr_none) {
-		__lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_none);
+		lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_none);
 		/* nr_none is always 0 for non-shmem. */
-		__lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_none);
+		lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_none);
 	}
 
 	/*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c31074e5852b..7f074d72dabc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -777,7 +777,7 @@ void mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 		mod_memcg_lruvec_state(lruvec, idx, val);
 }
 
-void __lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
+void lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 			     int val)
 {
 	struct mem_cgroup *memcg;
@@ -797,7 +797,7 @@ void __lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 	mod_lruvec_state(lruvec, idx, val);
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL(__lruvec_stat_mod_folio);
+EXPORT_SYMBOL(lruvec_stat_mod_folio);
 
 void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 {
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index a124ab6a205d..ccdeb0e84d39 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2652,7 +2652,7 @@ static void folio_account_dirtied(struct folio *folio,
 		inode_attach_wb(inode, folio);
 		wb = inode_to_wb(inode);
 
-		__lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
+		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
 		__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
 		__node_stat_mod_folio(folio, NR_DIRTIED, nr);
 		wb_stat_mod(wb, WB_RECLAIMABLE, nr);
diff --git a/mm/rmap.c b/mm/rmap.c
index 60c3cd70b6ea..1b3a3c7b0aeb 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1212,12 +1212,12 @@ static void __folio_mod_stat(struct folio *folio, int nr, int nr_pmdmapped)
 
 	if (nr) {
 		idx = folio_test_anon(folio) ? NR_ANON_MAPPED : NR_FILE_MAPPED;
-		__lruvec_stat_mod_folio(folio, idx, nr);
+		lruvec_stat_mod_folio(folio, idx, nr);
 	}
 	if (nr_pmdmapped) {
 		if (folio_test_anon(folio)) {
 			idx = NR_ANON_THPS;
-			__lruvec_stat_mod_folio(folio, idx, nr_pmdmapped);
+			lruvec_stat_mod_folio(folio, idx, nr_pmdmapped);
 		} else {
 			/* NR_*_PMDMAPPED are not maintained per-memcg */
 			idx = folio_test_swapbacked(folio) ?
diff --git a/mm/shmem.c b/mm/shmem.c
index c3ed2dcd17f8..4fba8a597256 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -882,9 +882,9 @@ static unsigned int shmem_huge_global_enabled(struct inode *inode, pgoff_t index
 static void shmem_update_stats(struct folio *folio, int nr_pages)
 {
 	if (folio_test_pmd_mappable(folio))
-		__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, nr_pages);
-	__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
-	__lruvec_stat_mod_folio(folio, NR_SHMEM, nr_pages);
+		lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, nr_pages);
+	lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
+	lruvec_stat_mod_folio(folio, NR_SHMEM, nr_pages);
 }
 
 /*
-- 
2.47.3


