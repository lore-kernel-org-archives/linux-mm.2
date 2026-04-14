Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ECECED7B91
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:16:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7907B6B0092; Tue, 14 Apr 2026 05:16:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719FA6B0093; Tue, 14 Apr 2026 05:16:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60A466B0096; Tue, 14 Apr 2026 05:16:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B92A6B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:16:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F2FB58B922
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:16:15 +0000 (UTC)
X-FDA: 84656605152.27.E546B9F
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4AF261A0011
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:16:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xKD7OtXc;
	spf=pass (imf19.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776158174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ubfySRhL7H2ALfoVfoAbTG+vWRfRjBu73p+puM1I0vE=;
	b=t4Ga62CNbaw/s0seV+RWjc9Wmu0mBweyRruXB+Hmsk7w95T270s08DWAaFT06Y24+VYPZG
	J2XdzDxJffWX+QUz92XNNGAlBDV5Es02Pnz0EMEoVg1zFTR6kghhtDYSgMe9uYgD9AsNDg
	RQK9P+ICzX+OQYHcso9W3eMnWnXeO+I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xKD7OtXc;
	spf=pass (imf19.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776158174; a=rsa-sha256;
	cv=none;
	b=OYY/OETYJcVe4uAY0EixLzx+emKyKIjEGzfZb19sX8TlO7p65O5LXXPDww2uGyCnzdisfM
	62+bYrdOpXT4gCF0ITL2KHsuoXrXWHgOhSRoeVed/t2qVpd6YTpK7Jjxcb3ClwNCasbI8V
	WaXeG0BST73sPCD9YpvPob0aTr5TtaQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776158172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ubfySRhL7H2ALfoVfoAbTG+vWRfRjBu73p+puM1I0vE=;
	b=xKD7OtXcIsrwj1A0b0Itu601MKl/5NJ+Z0FGvgmv1pfr3euBdkog0LGDvJBe4hIkNDVTku
	mgSwNGLQjVUnIbnhuBdwF9V3qaKkp+SUraT5C3qywZ9fdaiGetCOGQPw5x4h6xn9mE+JFw
	1PF6B8WPGUWQtCNRt1t5U+XM/AdVoLM=
From: Ye Liu <ye.liu@linux.dev>
To: Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Ye Liu <liuye@kylinos.cn>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/4] mm/vmstat: use node_stat_add_folio/sub_folio for folio_nr_pages operations
Date: Tue, 14 Apr 2026 17:15:18 +0800
Message-ID: <20260414091527.2970844-2-ye.liu@linux.dev>
In-Reply-To: <20260414091527.2970844-1-ye.liu@linux.dev>
References: <20260414091527.2970844-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4AF261A0011
X-Stat-Signature: t7y13tha83gnimdstoxpszeydfz7hmx9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776158174-131894
X-HE-Meta: U2FsdGVkX19m6Y3rvwHeAAVaa4TRA9tGezVY0ylg9Xgv9Nu8/ZCuf1bU2S3ZgTdbIukKCgqW1RSmGcO8gNhlnDIz4RiGgPkf5zuPSwho2kYS5DDZEz2oxArnXHqi6RuOL5AvZNe5R2X19/tXY6lLq2+E3OptlbgJUsmGigqdCu4QcOt0/f+CVAx/W7kuF48Py6M6+CfF82X1p/N7MiLdmtV9W0FCTt81jrrbJfPUpkYtzxU93vPGAbPjOHdumXoeHNHePnXcWNfQ7aUHBOVYQ6rHH+y1BTlVOtFx0KEBkcVZG3oDqcI6as8MNunhlleG9vOC/DyF+n2d7ozKuicTHwCbDbotW02QZWKKwXpswjNHuP8upJw/a/2KCiczzTH2suxFoXF09+xO2dyO47az2K/nxRIZ/kM0xoudiJB7xHjulQJaFryftIGFWIP+zx8Tc4MOS+UI7r6Ly9NRDtFB/xwLarWAzT2qP/zcMz9GvBd6LGo0JSqXAwNx6k82iAeYQIvU3FhKcKSznICEVSdC8zbPvyCVF4a3VT7LTRhTy1q/U/q1bbUQBOHhMb7kjhxLwgVqRtgAiFc/qHd8O1b1EKY5gQNEuE3tOSajaKw0ixztrOXS/52ZTioA+baxr0K7kqJKN0efndQJnbTrOyQf+Iozi4wgs0aQtWvhJgc8exKom1a1PcquBY3FEWMwldLriOxipmdFOURsaT+EYrrjoyhOt34bWVR1+NatPY62TfCMrm/JOF2wve5t6BflYPvc+yWcKAtnvAXDWxgEttA7WcvNh0YUGMX2K/r771WxhFNzpSsfN821Ux+AQVwQRMI9fWC3ZnNwz7ad9/TmFjJA6CK6SN7HYrZlh4MKWlmPlgEYkP5qB4mXtL7ErdLsx5MSAOZNn+1ELfzPPli91m7hCw/dhwKTTNPLwFaeSaBgOW7BjwAsmf6dD6eSzRb8FmA+F9lqS2Fep6JBH2EAHCR
 hcE/2uOq
 D3v8UDLfKl5ATJ9oqmCDMOBQlBat2x233o/7lRepbNja/WyYjyfTYfDjEC9yPKq5qTxPcQ0rAK2jJykmOE1m/NvHZ7gJqaWU4QrCU3TBPkt2iplUQVCIoieyz58FthxQRN+fICAVPjtJd25lLn2j5HMRWrUpkul5W+1EK7+JmNzyqK58zh/sL2d4XaH+oB8EKEeaY6P1T8sGnOafhQtksBvZdQAbBFcF7OjPV/J+Q4zg7we9RQMv3g7V1ySFoSnwLic5mSwBcY//eytTB5OtICPPk/sN/uhMl/e98XCJO3Ya10qn0rva+IimFa8mifGJzEYyFia96EbihrkE0Ew7fuivhVRrbjOw56UwD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace node_stat_mod_folio() calls that pass folio_nr_pages(folio) or
-folio_nr_pages(folio) as the third argument with the more concise
node_stat_add_folio() and node_stat_sub_folio() functions respectively.

This makes the code more readable and reduces the number of arguments
passed to these functions.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 fs/nfs/internal.h   |  2 +-
 fs/nfs/write.c      |  2 +-
 mm/compaction.c     |  5 ++---
 mm/gup.c            |  5 ++---
 mm/khugepaged.c     | 10 ++++------
 mm/mempolicy.c      |  5 ++---
 mm/migrate.c        | 12 +++++-------
 mm/page-writeback.c |  4 ++--
 mm/swap_state.c     |  4 ++--
 9 files changed, 21 insertions(+), 28 deletions(-)

diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index fc5456377160..f5c52a2d2a1f 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -858,7 +858,7 @@ static inline void nfs_folio_mark_unstable(struct folio *folio,
 		/* This page is really still in write-back - just that the
 		 * writeback is happening on the server now.
 		 */
-		node_stat_mod_folio(folio, NR_WRITEBACK, nr);
+		node_stat_add_folio(folio, NR_WRITEBACK);
 		bdi_wb_stat_mod(inode, WB_WRITEBACK, nr);
 		__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
 	}
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index cc02b57de3c7..a8700824a61b 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -871,7 +871,7 @@ static void nfs_folio_clear_commit(struct folio *folio)
 	if (folio) {
 		long nr = folio_nr_pages(folio);
 
-		node_stat_mod_folio(folio, NR_WRITEBACK, -nr);
+		node_stat_sub_folio(folio, NR_WRITEBACK);
 		bdi_wb_stat_mod(folio->mapping->host, WB_WRITEBACK, -nr);
 	}
 }
diff --git a/mm/compaction.c b/mm/compaction.c
index 3648ce22c807..d7ce622aeed1 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1215,9 +1215,8 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 
 		/* Successfully isolated */
 		lruvec_del_folio(lruvec, folio);
-		node_stat_mod_folio(folio,
-				NR_ISOLATED_ANON + folio_is_file_lru(folio),
-				folio_nr_pages(folio));
+		node_stat_add_folio(folio,
+				NR_ISOLATED_ANON + folio_is_file_lru(folio));
 
 isolate_success:
 		list_add(&folio->lru, &cc->migratepages);
diff --git a/mm/gup.c b/mm/gup.c
index ad9ded39609c..2cb2efa20bff 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2304,9 +2304,8 @@ static unsigned long collect_longterm_unpinnable_folios(
 			continue;
 
 		list_add_tail(&folio->lru, movable_folio_list);
-		node_stat_mod_folio(folio,
-				    NR_ISOLATED_ANON + folio_is_file_lru(folio),
-				    folio_nr_pages(folio));
+		node_stat_add_folio(folio,
+				    NR_ISOLATED_ANON + folio_is_file_lru(folio));
 	}
 
 	return collected;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b8452dbdb043..f662de753305 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -502,9 +502,8 @@ void __khugepaged_exit(struct mm_struct *mm)
 
 static void release_pte_folio(struct folio *folio)
 {
-	node_stat_mod_folio(folio,
-			NR_ISOLATED_ANON + folio_is_file_lru(folio),
-			-folio_nr_pages(folio));
+	node_stat_sub_folio(folio,
+			NR_ISOLATED_ANON + folio_is_file_lru(folio));
 	folio_unlock(folio);
 	folio_putback_lru(folio);
 }
@@ -650,9 +649,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			result = SCAN_DEL_PAGE_LRU;
 			goto out;
 		}
-		node_stat_mod_folio(folio,
-				NR_ISOLATED_ANON + folio_is_file_lru(folio),
-				folio_nr_pages(folio));
+		node_stat_add_folio(folio,
+				NR_ISOLATED_ANON + folio_is_file_lru(folio));
 		VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 		VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4e4421b22b59..1c413f66b35f 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1259,9 +1259,8 @@ static bool migrate_folio_add(struct folio *folio, struct list_head *foliolist,
 	if ((flags & MPOL_MF_MOVE_ALL) || !folio_maybe_mapped_shared(folio)) {
 		if (folio_isolate_lru(folio)) {
 			list_add_tail(&folio->lru, foliolist);
-			node_stat_mod_folio(folio,
-				NR_ISOLATED_ANON + folio_is_file_lru(folio),
-				folio_nr_pages(folio));
+			node_stat_add_folio(folio,
+				NR_ISOLATED_ANON + folio_is_file_lru(folio));
 		} else {
 			/*
 			 * Non-movable folio may reach here.  And, there may be
diff --git a/mm/migrate.c b/mm/migrate.c
index 8a64291ab5b4..dc8cfee37a70 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -268,8 +268,8 @@ void putback_movable_pages(struct list_head *l)
 		if (unlikely(page_has_movable_ops(&folio->page))) {
 			putback_movable_ops_page(&folio->page);
 		} else {
-			node_stat_mod_folio(folio, NR_ISOLATED_ANON +
-					folio_is_file_lru(folio), -folio_nr_pages(folio));
+			node_stat_sub_folio(folio, NR_ISOLATED_ANON +
+					folio_is_file_lru(folio));
 			folio_putback_lru(folio);
 		}
 	}
@@ -2272,9 +2272,8 @@ static int __add_folio_for_migration(struct folio *folio, int node,
 			return 1;
 	} else if (folio_isolate_lru(folio)) {
 		list_add_tail(&folio->lru, pagelist);
-		node_stat_mod_folio(folio,
-			NR_ISOLATED_ANON + folio_is_file_lru(folio),
-			folio_nr_pages(folio));
+		node_stat_add_folio(folio,
+			NR_ISOLATED_ANON + folio_is_file_lru(folio));
 		return 1;
 	}
 	return -EBUSY;
@@ -2726,8 +2725,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 	if (!folio_isolate_lru(folio))
 		return -EAGAIN;
 
-	node_stat_mod_folio(folio, NR_ISOLATED_ANON + folio_is_file_lru(folio),
-			    nr_pages);
+	node_stat_add_folio(folio, NR_ISOLATED_ANON + folio_is_file_lru(folio));
 	return 0;
 }
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 833f743f309f..87e9ea41313a 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2750,7 +2750,7 @@ bool folio_redirty_for_writepage(struct writeback_control *wbc,
 
 		wb = unlocked_inode_to_wb_begin(inode, &cookie);
 		current->nr_dirtied -= nr;
-		node_stat_mod_folio(folio, NR_DIRTIED, -nr);
+		node_stat_sub_folio(folio, NR_DIRTIED);
 		wb_stat_mod(wb, WB_DIRTIED, -nr);
 		unlocked_inode_to_wb_end(inode, &cookie);
 	}
@@ -2981,7 +2981,7 @@ bool __folio_end_writeback(struct folio *folio)
 
 	lruvec_stat_mod_folio(folio, NR_WRITEBACK, -nr);
 	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
-	node_stat_mod_folio(folio, NR_WRITTEN, nr);
+	node_stat_add_folio(folio, NR_WRITTEN);
 
 	return ret;
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 1415a5c54a43..d08e923c9979 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -160,7 +160,7 @@ void __swap_cache_add_folio(struct swap_cluster_info *ci,
 	folio_set_swapcache(folio);
 	folio->swap = entry;
 
-	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
+	node_stat_add_folio(folio, NR_FILE_PAGES);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
 }
 
@@ -265,7 +265,7 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 
 	folio->swap.val = 0;
 	folio_clear_swapcache(folio);
-	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
+	node_stat_sub_folio(folio, NR_FILE_PAGES);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
 
 	if (!folio_swapped) {
-- 
2.43.0


