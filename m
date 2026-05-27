Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11F86CD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73FAE6B008A; Wed, 27 May 2026 07:08:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0E86B008C; Wed, 27 May 2026 07:08:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DED66B0092; Wed, 27 May 2026 07:08:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A1C76B008A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:08:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 040258DCDF
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:02 +0000 (UTC)
X-FDA: 84812925246.27.F90E639
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf11.hostedemail.com (Postfix) with ESMTP id BC77D4000C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779880081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ade2k/uXS8aPOAWBVR8Iz6S4feqdJDz3ojhTFQH8SNk=;
	b=1M5iYMkP22DTqesYeqTA/MbPmDM2cDNhKhE5HwRZ6WKOBX9zchrfJGvayVn+6aePje4FmD
	UET5i2bW8BxYsDVZ4DjwnbIOfwjw4lJUuQU/D3qBXcGgPTpytZU5P7vCNMG2Pgon5Yy+0N
	rMTjvQetdabkTaQr/vuQYJ7gt3ThZXI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779880081; a=rsa-sha256;
	cv=none;
	b=1j4k1Jb6gv6oTofmhXK8dEHFT1wlVd+Zl6kM/f5r8m4OABpB9KYeDB88k1IGBTLIxpqgrY
	MPiTrxIglVFY+8U6OKSw8ZuAzOu8esQr/rojHNCnQJNaG50oHW+t11l9ZxV+duXs6ivHKz
	ekQizvFx3OxkGSzNriR37S/HnB/Mv1I=
Received: from TW004-1.hihonor.com (unknown [10.77.232.85])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gQRdL1cH5zYkxhZ;
	Wed, 27 May 2026 19:06:30 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW004-1.hihonor.com
 (10.77.232.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:07:56 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:07:55 +0800
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
Subject: [PATCH 02/15] mm: convert anon_vma rmap APIs to anon_rmap
Date: Wed, 27 May 2026 19:01:34 +0800
Message-ID: <20260527110147.17815-3-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW006-1.hihonor.com (10.77.215.153) To TA003.hihonor.com
 (10.72.0.43)
X-Stat-Signature: arfmu7m1t33bhkczjedrmt4xx7ps3wje
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BC77D4000C
X-HE-Tag: 1779880080-541872
X-HE-Meta: U2FsdGVkX18ZAnRGYH3y1+e0mpHLlqyJmSdLmvGkmaHXBB+F+DfJdS1fWrVRNA2Fi0DPPvxwTtM/5DDjWfSysP2VWNDh0jcy1wrM1nNkJ76+8/ZcuC/24YSD3O8jIlBUDGBgjOEs+dBAi5tYJ4NJJhpUEuON1Kytg3CNhH1sMrcJb0kk2xTX+bfPhatb0Y86m1GJR1de92xLb6XMNKTJaBf4SSnwFPFy4NO1kIcWtMt9FOQWUT7Biay5xRrRp+j6JDkYUQJIo9rgvrVffShLUvBdWqHUb3Paqc8UgGRaSeoDXzDKWvZE4nOMikPSZGnIS6M0yz4O5TxkBxB3TKRNA3MHGCuKIXg+TVY5q6Tfiu9lF79n3Pvwy39f11Z85GvUq+4GINirRy4sADdXikoQL3fIbEN1bkwQfciuLSKFKFbvAsppQeldLAEqFe6204NCwGd1xdyee/weR06G2oa/6fZZHL6CorBlqUEsndTM/MfUYbdD2rPk0hAOnHyjR4MZQ/zgRnYLz+qJ4+aQf85+11z8hzh3ozovgEEwCaUyOsR0IhStDyOx2nkf5CxJNdpEfDdJvHO1dws5GZMYE1+JrnXxr1aNJQidX+lviIgK2qCml6i+L1ywJAGB/QUdW90/hbJfGa/xxTXfDNd21G8MTltqUIO5D0CiqrhS2evg2PXJD7oUii+47K0hq4Cja7DerV1CMJs1tlWq3aHhf9WVGqH+62lPT1+BjtTQ7m90a2zwTIn+6rn1S0a63BEPPZuvR2bRN4SQ4UM6h2RdC+GpYj9yY0GI3akCgXfFk3rWQz/kKKWr4GJvjnhfvvZ9/rwRrYN72104KaBuFgK6l0flMzNFnTGvIbxLYJ3Q2SsUaSyPkOFpp8NgMASeBMI4owI6XAwsrO9pAl00srAnNGOgUhU2S5QVoYVWJ8WDOvJguidGrnt7hhr3+0US3Vb1W/tIvyhJ+JKnh/B3XEgl2Qt
 nOkJ3c20
 fQcwf530gmOxJtMKT6ByN+oyUzcwevjmCWpTlfKrCgCJ8BrwhsHNV7GESAyDnFtXYIgjcrF+tcR8DU6MvhNnObH0cGqi/AR2qL9Vqb9u9kkWxZ/vLoc/r+M+6aaruZNFRdHyzk5WlSoYpjoPDCGvMjQZP84xns5OPuc0HN2UjWmCXOiDpPdu2wuTGaBifAONlybIodyWlT/eZjbf7svOeBuyXbQ/gek+p3j/Hjju9J/KlosK6w5LTqqBQXexawiH38UaeL0PqnSwwWTFKIBWQTZ2+8Zyot5kfpj66
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the rmap anon_vma interfaces to anon_rmap APIs to clarify the
semantics of anonymous rmap operations and prepare for upcoming
ANON_VMA_LAZY support and RCU-based lockless rmap traversal.

Replace folio_anon_vma(), folio_get_anon_vma(), folio_lock_anon_vma_read(),
anon_vma_trylock_read(), anon_vma_lock_read(), anon_vma_unlock_read(),
anon_vma_trylock_write(), anon_vma_lock_write(), anon_vma_unlock_write(),
and vma_interval_tree_foreach() with the anon_rmap APIs.

No functional change intended.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 include/linux/rmap.h  |  6 ++--
 mm/damon/ops-common.c |  4 +--
 mm/huge_memory.c      | 16 +++++------
 mm/ksm.c              | 43 ++++++++++++++---------------
 mm/memory-failure.c   | 11 ++++----
 mm/migrate.c          | 64 +++++++++++++++++++++----------------------
 mm/page_idle.c        |  2 +-
 mm/rmap.c             | 51 ++++++++++++++++++----------------
 8 files changed, 98 insertions(+), 99 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index c42314ea4362..9802bce92695 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -997,15 +997,13 @@ struct rmap_walk_control {
 	bool (*rmap_one)(struct folio *folio, struct vm_area_struct *vma,
 					unsigned long addr, void *arg);
 	int (*done)(struct folio *folio);
-	struct anon_vma *(*anon_lock)(const struct folio *folio,
-				      struct rmap_walk_control *rwc);
+	anon_rmap_t (*anon_lock)(const struct folio *folio,
+				 struct rmap_walk_control *rwc);
 	bool (*invalid_vma)(struct vm_area_struct *vma, void *arg);
 };
 
 void rmap_walk(struct folio *folio, struct rmap_walk_control *rwc);
 void rmap_walk_locked(struct folio *folio, struct rmap_walk_control *rwc);
-struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
-					  struct rmap_walk_control *rwc);
 
 bool folio_maybe_same_anon_vma(const struct folio *folio,
 	const struct vm_area_struct *vma);
diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 8c6d613425c1..5788410965b8 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -172,7 +172,7 @@ void damon_folio_mkold(struct folio *folio)
 {
 	struct rmap_walk_control rwc = {
 		.rmap_one = damon_folio_mkold_one,
-		.anon_lock = folio_lock_anon_vma_read,
+		.anon_lock = folio_lock_anon_rmap_read,
 	};
 
 	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
@@ -236,7 +236,7 @@ bool damon_folio_young(struct folio *folio)
 	struct rmap_walk_control rwc = {
 		.arg = &accessed,
 		.rmap_one = damon_folio_young_one,
-		.anon_lock = folio_lock_anon_vma_read,
+		.anon_lock = folio_lock_anon_rmap_read,
 	};
 
 	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..ab3c2397449a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4051,7 +4051,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
 	struct address_space *mapping = NULL;
-	struct anon_vma *anon_vma = NULL;
+	anon_rmap_t anon_rmap = ANON_RMAP_NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
@@ -4087,12 +4087,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		 * is taken to serialise against parallel split or collapse
 		 * operations.
 		 */
-		anon_vma = folio_get_anon_vma(folio);
-		if (!anon_vma) {
+		anon_rmap = folio_get_anon_rmap(folio);
+		if (!anon_rmap_value(anon_rmap)) {
 			ret = -EBUSY;
 			goto out;
 		}
-		anon_vma_lock_write(anon_vma);
+		anon_rmap_lock_write(anon_rmap);
 		mapping = NULL;
 	} else {
 		unsigned int min_order;
@@ -4122,7 +4122,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			}
 		}
 
-		anon_vma = NULL;
+		anon_rmap = ANON_RMAP_NULL;
 		i_mmap_lock_read(mapping);
 
 		/*
@@ -4200,9 +4200,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	}
 
 out_unlock:
-	if (anon_vma) {
-		anon_vma_unlock_write(anon_vma);
-		put_anon_vma(anon_vma);
+	if (anon_rmap_value(anon_rmap)) {
+		anon_rmap_unlock_write(anon_rmap);
+		put_anon_rmap(anon_rmap);
 	}
 	if (mapping)
 		i_mmap_unlock_read(mapping);
diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..f4c204a8a379 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -187,7 +187,7 @@ struct ksm_stable_node {
 /**
  * struct ksm_rmap_item - reverse mapping item for virtual addresses
  * @rmap_list: next rmap_item in mm_slot's singly-linked rmap_list
- * @anon_vma: pointer to anon_vma for this mm,address, when in stable tree
+ * @anon_rmap: anonymous folio rmap for this mm,address, when in stable tree
  * @nid: NUMA node id of unstable tree in which linked (may not match page)
  * @mm: the memory structure this rmap_item is pointing into
  * @address: the virtual address this rmap_item tracks (+ flags in low bits)
@@ -201,7 +201,7 @@ struct ksm_stable_node {
 struct ksm_rmap_item {
 	struct ksm_rmap_item *rmap_list;
 	union {
-		struct anon_vma *anon_vma;	/* when stable */
+		anon_rmap_t anon_rmap;	/* when stable */
 #ifdef CONFIG_NUMA
 		int nid;		/* when node of unstable tree */
 #endif
@@ -786,7 +786,7 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
 	 * It is not an accident that whenever we want to break COW
 	 * to undo, we also need to drop a reference to the anon_vma.
 	 */
-	put_anon_vma(rmap_item->anon_vma);
+	put_anon_rmap(rmap_item->anon_rmap);
 
 	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
@@ -898,7 +898,7 @@ static void remove_node_from_stable_tree(struct ksm_stable_node *stable_node)
 
 		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
 		stable_node->rmap_hlist_len--;
-		put_anon_vma(rmap_item->anon_vma);
+		put_anon_rmap(rmap_item->anon_rmap);
 		rmap_item->address &= PAGE_MASK;
 		cond_resched();
 	}
@@ -1051,7 +1051,7 @@ static void remove_rmap_item_from_tree(struct ksm_rmap_item *rmap_item)
 		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
 		stable_node->rmap_hlist_len--;
 
-		put_anon_vma(rmap_item->anon_vma);
+		put_anon_rmap(rmap_item->anon_rmap);
 		rmap_item->head = NULL;
 		rmap_item->address &= PAGE_MASK;
 
@@ -1598,9 +1598,8 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
 	/* Unstable nid is in union with stable anon_vma: remove first */
 	remove_rmap_item_from_tree(rmap_item);
 
-	/* Must get reference to anon_vma while still holding mmap_lock */
-	rmap_item->anon_vma = vma->anon_vma;
-	get_anon_vma(vma->anon_vma);
+	/* Must get reference to anon_rmap while still holding mmap_lock */
+	rmap_item->anon_rmap = vma_get_anon_rmap(vma);
 out:
 	mmap_read_unlock(mm);
 	trace_ksm_merge_with_ksm_page(kpage, page_to_pfn(kpage ? kpage : page),
@@ -3108,7 +3107,6 @@ struct folio *ksm_might_need_to_copy(struct folio *folio,
 			struct vm_area_struct *vma, unsigned long addr)
 {
 	struct page *page = folio_page(folio, 0);
-	struct anon_vma *anon_vma = folio_anon_vma(folio);
 	struct folio *new_folio;
 
 	if (folio_test_large(folio))
@@ -3118,10 +3116,10 @@ struct folio *ksm_might_need_to_copy(struct folio *folio,
 		if (folio_stable_node(folio) &&
 		    !(ksm_run & KSM_RUN_UNMERGE))
 			return folio;	/* no need to copy it */
-	} else if (!anon_vma) {
+	} else if (!folio_test_anon(folio)) {
 		return folio;		/* no need to copy it */
 	} else if (folio->index == linear_page_index(vma, addr) &&
-			anon_vma->root == vma->anon_vma->root) {
+			folio_maybe_same_anon_vma(folio, vma)) {
 		return folio;		/* still no need to copy it */
 	}
 	if (PageHWPoison(page))
@@ -3173,20 +3171,20 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
 		/* Ignore the stable/unstable/sqnr flags */
 		const unsigned long addr = rmap_item->address & PAGE_MASK;
-		struct anon_vma *anon_vma = rmap_item->anon_vma;
+		anon_rmap_t anon_rmap = rmap_item->anon_rmap;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
 		cond_resched();
-		if (!anon_vma_trylock_read(anon_vma)) {
+		if (!anon_rmap_trylock_read(anon_rmap)) {
 			if (rwc->try_lock) {
 				rwc->contended = true;
 				return;
 			}
-			anon_vma_lock_read(anon_vma);
+			anon_rmap_lock_read(anon_rmap);
 		}
 
-		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
+		anon_rmap_foreach_vma(vma, vmac, anon_rmap,
 					       0, ULONG_MAX) {
 
 			cond_resched();
@@ -3207,15 +3205,15 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 				continue;
 
 			if (!rwc->rmap_one(folio, vma, addr, rwc->arg)) {
-				anon_vma_unlock_read(anon_vma);
+				anon_rmap_unlock_read(anon_rmap);
 				return;
 			}
 			if (rwc->done && rwc->done(folio)) {
-				anon_vma_unlock_read(anon_vma);
+				anon_rmap_unlock_read(anon_rmap);
 				return;
 			}
 		}
-		anon_vma_unlock_read(anon_vma);
+		anon_rmap_unlock_read(anon_rmap);
 	}
 	if (!search_new_forks++)
 		goto again;
@@ -3237,9 +3235,9 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 	if (!stable_node)
 		return;
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
-		struct anon_vma *av = rmap_item->anon_vma;
+		anon_rmap_t anon_rmap = rmap_item->anon_rmap;
 
-		anon_vma_lock_read(av);
+		anon_rmap_lock_read(anon_rmap);
 		rcu_read_lock();
 		for_each_process(tsk) {
 			struct anon_vma_chain *vmac;
@@ -3248,10 +3246,9 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 				task_early_kill(tsk, force_early);
 			if (!t)
 				continue;
-			anon_vma_interval_tree_foreach(vmac, &av->rb_root, 0,
+			anon_rmap_foreach_vma(vma, vmac, anon_rmap, 0,
 						       ULONG_MAX)
 			{
-				vma = vmac->vma;
 				if (vma->vm_mm == t->mm) {
 					addr = rmap_item->address & PAGE_MASK;
 					add_to_kill_ksm(t, page, vma, to_kill,
@@ -3260,7 +3257,7 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 			}
 		}
 		rcu_read_unlock();
-		anon_vma_unlock_read(av);
+		anon_rmap_unlock_read(anon_rmap);
 	}
 }
 #endif
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d4361309..bc9abba75b5d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -547,11 +547,11 @@ static void collect_procs_anon(const struct folio *folio,
 		int force_early)
 {
 	struct task_struct *tsk;
-	struct anon_vma *av;
+	anon_rmap_t anon_rmap;
 	pgoff_t pgoff;
 
-	av = folio_lock_anon_vma_read(folio, NULL);
-	if (av == NULL)	/* Not actually mapped anymore */
+	anon_rmap = folio_lock_anon_rmap_read(folio, NULL);
+	if (!anon_rmap_value(anon_rmap))	/* Not actually mapped anymore */
 		return;
 
 	pgoff = page_pgoff(folio, page);
@@ -564,9 +564,8 @@ static void collect_procs_anon(const struct folio *folio,
 
 		if (!t)
 			continue;
-		anon_vma_interval_tree_foreach(vmac, &av->rb_root,
+		anon_rmap_foreach_vma(vma, vmac, anon_rmap,
 					       pgoff, pgoff) {
-			vma = vmac->vma;
 			if (vma->vm_mm != t->mm)
 				continue;
 			addr = page_mapped_in_vma(page, vma);
@@ -574,7 +573,7 @@ static void collect_procs_anon(const struct folio *folio,
 		}
 	}
 	rcu_read_unlock();
-	anon_vma_unlock_read(av);
+	anon_rmap_unlock_read(anon_rmap);
 }
 
 /*
diff --git a/mm/migrate.c b/mm/migrate.c
index 8a64291ab5b4..769983cf14e0 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1142,18 +1142,18 @@ enum {
 
 static void __migrate_folio_record(struct folio *dst,
 				   int old_page_state,
-				   struct anon_vma *anon_vma)
+				   anon_rmap_t anon_rmap)
 {
-	dst->private = (void *)anon_vma + old_page_state;
+	dst->private = (void *)anon_rmap_to_anon_vma(anon_rmap) + old_page_state;
 }
 
 static void __migrate_folio_extract(struct folio *dst,
 				   int *old_page_state,
-				   struct anon_vma **anon_vmap)
+				   anon_rmap_t *anon_rmapp)
 {
 	unsigned long private = (unsigned long)dst->private;
 
-	*anon_vmap = (struct anon_vma *)(private & ~PAGE_OLD_STATES);
+	*anon_rmapp = anon_vma_to_anon_rmap((void *)(private & ~PAGE_OLD_STATES));
 	*old_page_state = private & PAGE_OLD_STATES;
 	dst->private = NULL;
 }
@@ -1161,15 +1161,15 @@ static void __migrate_folio_extract(struct folio *dst,
 /* Restore the source folio to the original state upon failure */
 static void migrate_folio_undo_src(struct folio *src,
 				   int page_was_mapped,
-				   struct anon_vma *anon_vma,
+				   anon_rmap_t anon_rmap,
 				   bool locked,
 				   struct list_head *ret)
 {
 	if (page_was_mapped)
 		remove_migration_ptes(src, src, 0);
-	/* Drop an anon_vma reference if we took one */
-	if (anon_vma)
-		put_anon_vma(anon_vma);
+	/* Drop an anon_rmap reference if we took one */
+	if (anon_rmap_value(anon_rmap))
+		put_anon_rmap(anon_rmap);
 	if (locked)
 		folio_unlock(src);
 	if (ret)
@@ -1210,7 +1210,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	struct folio *dst;
 	int rc = -EAGAIN;
 	int old_page_state = 0;
-	struct anon_vma *anon_vma = NULL;
+	anon_rmap_t anon_rmap = ANON_RMAP_NULL;
 	bool locked = false;
 	bool dst_locked = false;
 
@@ -1275,19 +1275,19 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	/*
 	 * By try_to_migrate(), src->mapcount goes down to 0 here. In this case,
 	 * we cannot notice that anon_vma is freed while we migrate a page.
-	 * This get_anon_vma() delays freeing anon_vma pointer until the end
+	 * This get_anon_rmap() delays freeing anon_rmap pointer until the end
 	 * of migration. File cache pages are no problem because of page_lock()
 	 * File Caches may use write_page() or lock_page() in migration, then,
 	 * just care Anon page here.
 	 *
-	 * Only folio_get_anon_vma() understands the subtleties of
-	 * getting a hold on an anon_vma from outside one of its mms.
-	 * But if we cannot get anon_vma, then we won't need it anyway,
+	 * Only folio_get_anon_rmap() understands the subtleties of
+	 * getting a hold on an anon_rmap from outside one of its mms.
+	 * But if we cannot get anon_rmap, then we won't need it anyway,
 	 * because that implies that the anon page is no longer mapped
 	 * (and cannot be remapped so long as we hold the page lock).
 	 */
 	if (folio_test_anon(src) && !folio_test_ksm(src))
-		anon_vma = folio_get_anon_vma(src);
+		anon_rmap = folio_get_anon_rmap(src);
 
 	/*
 	 * Block others from accessing the new page when we get around to
@@ -1302,7 +1302,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	dst_locked = true;
 
 	if (unlikely(page_has_movable_ops(&src->page))) {
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_page_state, anon_rmap);
 		return 0;
 	}
 
@@ -1326,13 +1326,13 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	} else if (folio_mapped(src)) {
 		/* Establish migration ptes */
 		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
-			       !folio_test_ksm(src) && !anon_vma, src);
+			       !folio_test_ksm(src) && !anon_rmap_value(anon_rmap), src);
 		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
 		old_page_state |= PAGE_WAS_MAPPED;
 	}
 
 	if (!folio_mapped(src)) {
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_page_state, anon_rmap);
 		return 0;
 	}
 
@@ -1345,7 +1345,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		ret = NULL;
 
 	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
-			       anon_vma, locked, ret);
+			       anon_rmap, locked, ret);
 	migrate_folio_undo_dst(dst, dst_locked, put_new_folio, private);
 
 	return rc;
@@ -1359,12 +1359,12 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 {
 	int rc;
 	int old_page_state = 0;
-	struct anon_vma *anon_vma = NULL;
+	anon_rmap_t anon_rmap = ANON_RMAP_NULL;
 	bool src_deferred_split = false;
 	bool src_partially_mapped = false;
 	struct list_head *prev;
 
-	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
+	__migrate_folio_extract(dst, &old_page_state, &anon_rmap);
 	prev = dst->lru.prev;
 	list_del(&dst->lru);
 
@@ -1425,9 +1425,9 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	 * and will be freed.
 	 */
 	list_del(&src->lru);
-	/* Drop an anon_vma reference if we took one */
-	if (anon_vma)
-		put_anon_vma(anon_vma);
+	/* Drop an anon_rmap reference if we took one */
+	if (anon_rmap_value(anon_rmap))
+		put_anon_rmap(anon_rmap);
 	folio_unlock(src);
 	migrate_folio_done(src, reason);
 
@@ -1439,12 +1439,12 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	 */
 	if (rc == -EAGAIN) {
 		list_add(&dst->lru, prev);
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_page_state, anon_rmap);
 		return rc;
 	}
 
 	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
-			       anon_vma, true, ret);
+			       anon_rmap, true, ret);
 	migrate_folio_undo_dst(dst, true, put_new_folio, private);
 
 	return rc;
@@ -1476,7 +1476,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 	struct folio *dst;
 	int rc = -EAGAIN;
 	int page_was_mapped = 0;
-	struct anon_vma *anon_vma = NULL;
+	anon_rmap_t anon_rmap = ANON_RMAP_NULL;
 	struct address_space *mapping = NULL;
 	enum ttu_flags ttu = 0;
 
@@ -1513,7 +1513,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 	}
 
 	if (folio_test_anon(src))
-		anon_vma = folio_get_anon_vma(src);
+		anon_rmap = folio_get_anon_rmap(src);
 
 	if (unlikely(!folio_trylock(dst)))
 		goto put_anon;
@@ -1550,8 +1550,8 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 	folio_unlock(dst);
 
 put_anon:
-	if (anon_vma)
-		put_anon_vma(anon_vma);
+	if (anon_rmap_value(anon_rmap))
+		put_anon_rmap(anon_rmap);
 
 	if (!rc) {
 		move_hugetlb_state(src, dst, reason);
@@ -1778,11 +1778,11 @@ static void migrate_folios_undo(struct list_head *src_folios,
 	dst2 = list_next_entry(dst, lru);
 	list_for_each_entry_safe(folio, folio2, src_folios, lru) {
 		int old_page_state = 0;
-		struct anon_vma *anon_vma = NULL;
+		anon_rmap_t anon_rmap = ANON_RMAP_NULL;
 
-		__migrate_folio_extract(dst, &old_page_state, &anon_vma);
+		__migrate_folio_extract(dst, &old_page_state, &anon_rmap);
 		migrate_folio_undo_src(folio, old_page_state & PAGE_WAS_MAPPED,
-				anon_vma, true, ret_folios);
+				anon_rmap, true, ret_folios);
 		list_del(&dst->lru);
 		migrate_folio_undo_dst(dst, true, put_new_folio, private);
 		dst = dst2;
diff --git a/mm/page_idle.c b/mm/page_idle.c
index 9c67cbac2965..d4103f20f526 100644
--- a/mm/page_idle.c
+++ b/mm/page_idle.c
@@ -102,7 +102,7 @@ static void page_idle_clear_pte_refs(struct folio *folio)
 	 */
 	static struct rmap_walk_control rwc = {
 		.rmap_one = page_idle_clear_pte_refs_one,
-		.anon_lock = folio_lock_anon_vma_read,
+		.anon_lock = folio_lock_anon_rmap_read,
 	};
 
 	if (!folio_mapped(folio) || !folio_raw_mapping(folio))
diff --git a/mm/rmap.c b/mm/rmap.c
index 1b2dada71778..41607168e00e 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -630,8 +630,8 @@ struct anon_vma *folio_get_anon_vma(const struct folio *folio)
  * reference like with folio_get_anon_vma() and then block on the mutex
  * on !rwc->try_lock case.
  */
-struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
-					  struct rmap_walk_control *rwc)
+static struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
+						 struct rmap_walk_control *rwc)
 {
 	struct anon_vma *anon_vma = NULL;
 	struct anon_vma *root_anon_vma;
@@ -744,6 +744,14 @@ void anon_rmap_unlock_read(anon_rmap_t anon_rmap)
 	anon_vma_unlock_read(anon_rmap_to_anon_vma(anon_rmap));
 }
 
+static anon_rmap_t folio_anon_rmap(const struct folio *folio)
+{
+	struct anon_vma *anon_vma;
+
+	anon_vma = folio_anon_vma(folio);
+	return anon_vma ? anon_vma_to_anon_rmap(anon_vma) : ANON_RMAP_NULL;
+}
+
 bool folio_maybe_same_anon_vma(const struct folio *folio,
 	const struct vm_area_struct *vma)
 {
@@ -930,13 +938,11 @@ unsigned long page_address_in_vma(const struct folio *folio,
 		const struct page *page, const struct vm_area_struct *vma)
 {
 	if (folio_test_anon(folio)) {
-		struct anon_vma *anon_vma = folio_anon_vma(folio);
 		/*
 		 * Note: swapoff's unuse_vma() is more efficient with this
 		 * check, and needs it to match anon_vma when KSM is active.
 		 */
-		if (!vma->anon_vma || !anon_vma ||
-		    vma->anon_vma->root != anon_vma->root)
+		if (!vma->anon_vma || !folio_maybe_same_anon_vma(folio, vma))
 			return -EFAULT;
 	} else if (!vma->vm_file) {
 		return -EFAULT;
@@ -944,7 +950,7 @@ unsigned long page_address_in_vma(const struct folio *folio,
 		return -EFAULT;
 	}
 
-	/* KSM folios don't reach here because of the !anon_vma check */
+	/* The !folio_maybe_same_anon_vma() above handles KSM folios */
 	return vma_address(vma, page_pgoff(folio, page), 1);
 }
 
@@ -1145,7 +1151,7 @@ int folio_referenced(struct folio *folio, int is_locked,
 	struct rmap_walk_control rwc = {
 		.rmap_one = folio_referenced_one,
 		.arg = (void *)&pra,
-		.anon_lock = folio_lock_anon_vma_read,
+		.anon_lock = folio_lock_anon_rmap_read,
 		.try_lock = true,
 		.invalid_vma = invalid_folio_referenced_vma,
 	};
@@ -1580,8 +1586,7 @@ static void __page_check_anon_rmap(const struct folio *folio,
 	 * are initially only visible via the pagetables, and the pte is locked
 	 * over the call to folio_add_new_anon_rmap.
 	 */
-	VM_BUG_ON_FOLIO(folio_anon_vma(folio)->root != vma->anon_vma->root,
-			folio);
+	VM_BUG_ON_FOLIO(!folio_maybe_same_anon_vma(folio, vma), folio);
 	VM_BUG_ON_PAGE(page_pgoff(folio, page) != linear_page_index(vma, address),
 		       page);
 }
@@ -2468,7 +2473,7 @@ void try_to_unmap(struct folio *folio, enum ttu_flags flags)
 		.rmap_one = try_to_unmap_one,
 		.arg = (void *)flags,
 		.done = folio_not_mapped,
-		.anon_lock = folio_lock_anon_vma_read,
+		.anon_lock = folio_lock_anon_rmap_read,
 	};
 
 	if (flags & TTU_RMAP_LOCKED)
@@ -2813,7 +2818,7 @@ void try_to_migrate(struct folio *folio, enum ttu_flags flags)
 		.rmap_one = try_to_migrate_one,
 		.arg = (void *)flags,
 		.done = folio_not_mapped,
-		.anon_lock = folio_lock_anon_vma_read,
+		.anon_lock = folio_lock_anon_rmap_read,
 	};
 
 	/*
@@ -2990,8 +2995,8 @@ void __put_anon_vma(struct anon_vma *anon_vma)
 		anon_vma_free(root);
 }
 
-static struct anon_vma *rmap_walk_anon_lock(const struct folio *folio,
-					    struct rmap_walk_control *rwc)
+static anon_rmap_t rmap_walk_anon_lock(const struct folio *folio,
+				       struct rmap_walk_control *rwc)
 {
 	struct anon_vma *anon_vma;
 
@@ -3006,7 +3011,7 @@ static struct anon_vma *rmap_walk_anon_lock(const struct folio *folio,
 	 */
 	anon_vma = folio_anon_vma(folio);
 	if (!anon_vma)
-		return NULL;
+		return ANON_RMAP_NULL;
 
 	if (anon_vma_trylock_read(anon_vma))
 		goto out;
@@ -3019,7 +3024,7 @@ static struct anon_vma *rmap_walk_anon_lock(const struct folio *folio,
 
 	anon_vma_lock_read(anon_vma);
 out:
-	return anon_vma;
+	return anon_vma ? anon_vma_to_anon_rmap(anon_vma) : ANON_RMAP_NULL;
 }
 
 /*
@@ -3035,9 +3040,10 @@ static struct anon_vma *rmap_walk_anon_lock(const struct folio *folio,
 static void rmap_walk_anon(struct folio *folio,
 		struct rmap_walk_control *rwc, bool locked)
 {
-	struct anon_vma *anon_vma;
+	anon_rmap_t anon_rmap;
 	pgoff_t pgoff_start, pgoff_end;
 	struct anon_vma_chain *avc;
+	struct vm_area_struct *vma;
 
 	/*
 	 * The folio lock ensures that folio->mapping can't be changed under us
@@ -3046,20 +3052,19 @@ static void rmap_walk_anon(struct folio *folio,
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 
 	if (locked) {
-		anon_vma = folio_anon_vma(folio);
+		anon_rmap = folio_anon_rmap(folio);
 		/* anon_vma disappear under us? */
-		VM_BUG_ON_FOLIO(!anon_vma, folio);
+		VM_BUG_ON_FOLIO(!anon_rmap_value(anon_rmap), folio);
 	} else {
-		anon_vma = rmap_walk_anon_lock(folio, rwc);
+		anon_rmap = rmap_walk_anon_lock(folio, rwc);
 	}
-	if (!anon_vma)
+	if (!anon_rmap_value(anon_rmap))
 		return;
 
 	pgoff_start = folio_pgoff(folio);
 	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
-	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
+	anon_rmap_foreach_vma(vma, avc, anon_rmap,
 			pgoff_start, pgoff_end) {
-		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(vma, pgoff_start,
 				folio_nr_pages(folio));
 
@@ -3076,7 +3081,7 @@ static void rmap_walk_anon(struct folio *folio,
 	}
 
 	if (!locked)
-		anon_vma_unlock_read(anon_vma);
+		anon_rmap_unlock_read(anon_rmap);
 }
 
 /**
-- 
2.17.1


