Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFB7F1088E48
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 156EA6B035C; Wed, 18 Mar 2026 18:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DF266B035E; Wed, 18 Mar 2026 18:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D656B035F; Wed, 18 Mar 2026 18:30:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2E696B035C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:30:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 93C681A01E9
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:15 +0000 (UTC)
X-FDA: 84560628390.11.5051E45
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 99011120012
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TzghN0tB;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773873013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VgrpZFUT+NYt0nTgaod7Kz72BZNd5tZZCtr7FUP5L1c=;
	b=OBc4lM9ff4Q+7TUukNb7VmCdEOxwV3Y9oy07jtXA7aLNGeM2D2zmlPGLcm5JDlQ9wdQBX3
	+LJV6Smm+PyqujXamrccXcaLx6RsMSrp3jQqBSRcCQk9Romv1t5rq/emMkUATJ6UVOFKTt
	me+TN+BQ/+5UzdzH1qN7CFTT3yLWp7A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TzghN0tB;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773873013; a=rsa-sha256;
	cv=none;
	b=2TT+XGNCKhnwPURE7G3z6L2Jk2+ljaOqpExj7MCqDstnSjOnpYSWcoyID7s9TnSoK7dQK+
	4G53YQfxYT7CtZPglU3ttDKTJPl8SitcS4uOht07dRJ1BQtF6Zjwcnreo6NY18y3odL/cy
	OfaQ16KOq+M7VHI/naiBUXjO/IWkyaA=
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d751ef36ccso213598a34.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773873013; x=1774477813; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VgrpZFUT+NYt0nTgaod7Kz72BZNd5tZZCtr7FUP5L1c=;
        b=TzghN0tBqXEznlohCgNRy6ZyWOI6PvjmhkKT8JWEd2Jk8/1wvGZzFpq9HVtAa69Uor
         cQUr4nZ5QLP/eE6p2yyFqGygltNCay17C1S46b2joUFj+bBDAcm/Na+SUGh1oCekAfod
         LMHFSYhh0Zi86BfLWgiEn5bT2LlOohyQ1u5Nquu0p75+CDxbdSY+49mm+bRnpNMy9qwB
         gremij9rHsYubAtvbeRT7jxATicwLQqrAa3VmYQ9acP9jTt1ZKTjGXldEy3fv6G11hKW
         F6rp6qKzKEJXFsigMMzdPsJYbClRHXkH13PTXjHv2bPzVIQpLE025ML19pOZFysQu4z6
         1zaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773873013; x=1774477813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VgrpZFUT+NYt0nTgaod7Kz72BZNd5tZZCtr7FUP5L1c=;
        b=rstvEeFx2jNl2UHe3eov6BHMOLpAOZSk//Wnp/iq7Cs2qaDxHlTgxm/M+en57m+Vuf
         4lfJ+FF1Qj4wxVXDYszCaHKwalzSMTiKf4HPCpRp7dGzqDWmC8a1FxvcX8Fur4ZL99tw
         5RuO9AHtFrF68AptgfEU0KFt8E/atjA/xmx0lcPGXTHxmg53BOqs6X8vckyVVHx2ebRR
         CMmH+2I21t0vsiEXe7PdBB1ANcl6z+H89BC6/Ek4nP6o7PFVXUci8aN/HnOmLikTf3+Q
         TIwNQQj2FdljW2TajV64mJDqbafTyTAfhd+hk4WmhJExzM9y1a8mkmw/05ZT6oUm5nTA
         5w+w==
X-Forwarded-Encrypted: i=1; AJvYcCVleGfwa3bRgly9kZ6ez4s4Std3Q5+NW+EVtCvSC+udzb3FpX3CCokbLzTPvkXPnFB/2irOQ0KnOg==@kvack.org
X-Gm-Message-State: AOJu0YylfJnm6K9MfkbB68zbWkyduxYVyqaYiq4/cJ7BbhDFf4Ms57yI
	uPPCbUWWFraxiPT7lQFK9YZ5kXy6R0+yZzEEhFycpCY/IZMC5HdfcQ0K
X-Gm-Gg: ATEYQzy63b8knWjXRZQWUZU0e6BJy0dKSOyDcqO0HHgITNUTvFY45VAJkwJ7uZxQqac
	0zeGYvFkzPVK11Es7UOHnIw/NXUp71FK4pKSnnWr0aWLu9fBuKN7xlhO7Ruz9Ipkem14wZg5aR+
	EoZ8jfP1FxKvO2HJa06y48W1l+rvikKbCalJIdXY7mwBIOt+JoI/oztq6IpthLh7vOF+RNDgCGF
	LWi1JdjnQkuiJBl/QPlm2jglwK4etqnNzSagS2WIm9Nr1cCnYLK8+aZ15bEFh+wHXO/0NXIXMUu
	2J0F4bgoVLGV5zOqjD7mCvqOQVPoH7H7UUZloAV5K/A1ly31h6gXocRZOujWWfuGp4UkSFrbNo9
	E/Yf0RcX1xECLlwMf+ni5JgPKfQJ5oXyjC/OyL9rgIlcDa5wyRi7in6XK3pxxQXAiCGz1i99JDt
	EDBNUgyE3s24c80BCNoxdifpNO2j6za6odmLfhSEIZneyC/g==
X-Received: by 2002:a05:6830:210d:b0:7d7:b841:c715 with SMTP id 46e09a7af769-7d7ca6707aemr2909289a34.19.1773873012304;
        Wed, 18 Mar 2026 15:30:12 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:56::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7ddadbc32sm93288a34.0.2026.03.18.15.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:30:11 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com
Subject: [PATCH v4 10/21] swap: move swap cache to virtual swap descriptor
Date: Wed, 18 Mar 2026 15:29:41 -0700
Message-ID: <20260318222953.441758-11-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318222953.441758-1-nphamcs@gmail.com>
References: <20260318222953.441758-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 99011120012
X-Stat-Signature: 8nxr7b79kdc9rbie6gmpdo4cmehm7hqb
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773873013-262079
X-HE-Meta: U2FsdGVkX1+SCQzCE/0Doa72W3Zg6eWT0WKzfu61wRolhfOE0+7QBhcbaYSMxG3PH3ke8rgjtNIcQjXtOoxB766UfP85HXYHZx2eOMusmTSyV81hxffXj13G7ckqUgQ6FuHDgC0RI0CyJZQ67s7NX0xqADg/PTydRV6ejL5ImHrugCmwmDczgwkvj71ImUihzek3DnJK/cW4fjpU7Lgi11yqhvDGpnAC78T0G1ZdVZc1hLD0+akm8QrpPeczrWOKtolrPp5AXtuY2FN607BqR9xaw9cGjNRqYcjbSQUm0qgIgmDOk5bVMugNvlUHZOkBbbQwWJQojYfQ2Xx7wvCFa2aaVgEbFx9i1NJZTqJtjmJ/lgHanjMSyKI74GRYYiEetIQPIEHVUkDP0rY31X2f3N9rpgyJRiQuB6AOKUmUSewDg/6ebZIAPfkC7iwRMsW/hueZYu7vin11qlzkDmh1cthzxWT8oJKYmK8YSOi4a33Ux1osQXD7wx2ugH8t7d/ypzU7HXNBIv0JFiFJCGrJjME8wbcrVMok0XyHylKNu0pRSihRKad/9IWMx2PknPOMfeAZk10/pgJsmvsj7BCG3W+e/riImqO2CwSEun8lJGLj51OwGmIYAYN11FZbfQk6SUmKhF+1VMl6rO301Dlm5lQt6y7PGDBBzWyUReoyKjl+mlS0glfFYDb6IvqMjf/RMZ3OLtjmPw7cfA5DqjEKVjkP8IiiTXesWAKYxyY7bZ8B/ofB81DAXwJAUOdfp7mlvZJ6G4/bV922NvdggU9SGWrO4jP8AEkMTGlZ6mY13CfCiSq5ucA26Rkb4OhdXS0b1LEBzI0XedxTuJWF2sWsR5/qhD5HxMJKkuDqgRlY7jRyn9YIiw3VHM5UUtNp2dmR7HFhmd40m/U+djOpU7xF1/mfuedwlaI9rJMoy5VGtLPfy3izj9nq0Bn8CBKCLRIO8b4dtvF7YiRzbTmRxer
 DXNjF0sO
 6GvUxYMH8Q/5tEyFMXjrIz7+HNb0IlD1c6XuKL7Q/oBx5EMaNQuTEDrSqsCK4YBYLCxE850pIC3TMn9kKryhId/ZS3T7suGmYFZQHsjpQv/CNrxdPyLjGKVZvC7/nj/ELUzHi0lfmIRGHr6eOYXVF09a7VeUwoLxkoswB5+o7NLO5OXO/KfrA/vwciDp4um4jZTxgqRLye5pFH7HkV0UM6Prg5vP6PjFNB3DGjhf6SlLFsjwDK4BKOWNNiJ57JaT1YMwytp9diEDMVuCBZzlebXHJakq6qUn54KR+vt7AjKZQE1TkzuKBzwMeNAiWOXItlE4parPhJmwkzPuSDKFzUzRqEJI8/aWtiMplzPnA0HFe+bdQ5pRTgNTYZDiJqu3YR5oMYi+LRgsIHOVXp5hq6T60+ZrqOlm0vOCGvM6RdPrm2PxYWGU4el10RDHUn76D97nOntqMxCyzYVakJBn8/y8bP9l1yQLbDQggZ3SPC5aN/o3RFXy7pZ/t6BLlM8/wTesV/dd18bOAmCuTvkNPcaHbpOupOrlIgzj29nRBUiSSx/J15KdKU1A0TN9KPB3jBDTC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the swap cache (and workingset shadow for anonymous pages) to the
virtual swap descriptor. This effectively range-partitions the swap
cache by virtual swap clusters (of PMD sized), eliminate swap cache lock
contention.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/huge_memory.c |   4 +-
 mm/migrate.c     |   6 +-
 mm/shmem.c       |   4 +-
 mm/swap.h        |  28 ++--
 mm/swap_state.c  | 251 +--------------------------------
 mm/vmscan.c      |   6 +-
 mm/vswap.c       | 352 ++++++++++++++++++++++++++++++++++++++++++++++-
 7 files changed, 370 insertions(+), 281 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 21215ac870144..dcbd3821d6178 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3825,7 +3825,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 				return -EINVAL;
 			}
 
-			swap_cache_lock();
+			swap_cache_lock(folio->swap);
 		}
 
 		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
@@ -3901,7 +3901,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 			unlock_page_lruvec(lruvec);
 
 		if (folio_test_swapcache(folio))
-			swap_cache_unlock();
+			swap_cache_unlock(folio->swap);
 	} else {
 		split_queue_unlock(ds_queue);
 		return -EAGAIN;
diff --git a/mm/migrate.c b/mm/migrate.c
index 11d9b43dff5d8..e850b05a232de 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -600,13 +600,13 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 	newzone = folio_zone(newfolio);
 
 	if (folio_test_swapcache(folio))
-		swap_cache_lock_irq();
+		swap_cache_lock_irq(folio->swap);
 	else
 		xas_lock_irq(&xas);
 
 	if (!folio_ref_freeze(folio, expected_count)) {
 		if (folio_test_swapcache(folio))
-			swap_cache_unlock_irq();
+			swap_cache_unlock_irq(folio->swap);
 		else
 			xas_unlock_irq(&xas);
 		return -EAGAIN;
@@ -652,7 +652,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 
 	/* Leave irq disabled to prevent preemption while updating stats */
 	if (folio_test_swapcache(folio))
-		swap_cache_unlock();
+		swap_cache_unlock(folio->swap);
 	else
 		xas_unlock(&xas);
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 13f7469a04c8a..66cf8af6779ca 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2168,12 +2168,12 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 	new->swap = entry;
 	folio_set_swapcache(new);
 
-	swap_cache_lock_irq();
+	swap_cache_lock_irq(entry);
 	__swap_cache_replace_folio(old, new);
 	mem_cgroup_replace_folio(old, new);
 	shmem_update_stats(new, nr_pages);
 	shmem_update_stats(old, -nr_pages);
-	swap_cache_unlock_irq();
+	swap_cache_unlock_irq(entry);
 
 	folio_add_lru(new);
 	*foliop = new;
diff --git a/mm/swap.h b/mm/swap.h
index 99b84fc6d2fa5..7618b77bbb85f 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -205,10 +205,12 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
-void swap_cache_lock_irq(void);
-void swap_cache_unlock_irq(void);
-void swap_cache_lock(void);
-void swap_cache_unlock(void);
+
+/* linux/mm/vswap.c */
+void swap_cache_lock_irq(swp_entry_t entry);
+void swap_cache_unlock_irq(swp_entry_t entry);
+void swap_cache_lock(swp_entry_t entry);
+void swap_cache_unlock(swp_entry_t entry);
 
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
@@ -256,13 +258,12 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
-int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
-			 gfp_t gfp, void **shadow);
+void swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
+			  void **shadow);
 void swap_cache_del_folio(struct folio *folio);
 /* Below helpers require the caller to lock the swap cache. */
 void __swap_cache_del_folio(struct folio *folio, swp_entry_t entry, void *shadow);
 void __swap_cache_replace_folio(struct folio *old, struct folio *new);
-void swap_cache_clear_shadow(swp_entry_t entry, int nr_ents);
 
 void show_swap_cache_info(void);
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
@@ -423,10 +424,9 @@ static inline void *swap_cache_get_shadow(swp_entry_t entry)
 	return NULL;
 }
 
-static inline int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
-				       gfp_t gfp, void **shadow)
+static inline void swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
+					void **shadow)
 {
-	return 0;
 }
 
 static inline void swap_cache_del_folio(struct folio *folio)
@@ -441,19 +441,19 @@ static inline void __swap_cache_replace_folio(struct folio *old, struct folio *n
 {
 }
 
-static inline void swap_cache_lock_irq(void)
+static inline void swap_cache_lock_irq(swp_entry_t entry)
 {
 }
 
-static inline void swap_cache_unlock_irq(void)
+static inline void swap_cache_unlock_irq(swp_entry_t entry)
 {
 }
 
-static inline void swap_cache_lock(void)
+static inline void swap_cache_lock(swp_entry_t entry)
 {
 }
 
-static inline void swap_cache_unlock(void)
+static inline void swap_cache_unlock(swp_entry_t entry)
 {
 }
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index c5ceccd756699..00fa3e76a5c19 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -41,28 +41,6 @@ struct address_space swap_space __read_mostly = {
 	.a_ops = &swap_aops,
 };
 
-static DEFINE_XARRAY(swap_cache);
-
-void swap_cache_lock_irq(void)
-{
-	xa_lock_irq(&swap_cache);
-}
-
-void swap_cache_unlock_irq(void)
-{
-	xa_unlock_irq(&swap_cache);
-}
-
-void swap_cache_lock(void)
-{
-	xa_lock(&swap_cache);
-}
-
-void swap_cache_unlock(void)
-{
-	xa_unlock(&swap_cache);
-}
-
 static bool enable_vma_readahead __read_mostly = true;
 
 #define SWAP_RA_ORDER_CEILING	5
@@ -94,231 +72,6 @@ void show_swap_cache_info(void)
 	printk("Total swap = %lukB\n", K(total_swap_pages));
 }
 
-/**
- * swap_cache_get_folio - Looks up a folio in the swap cache.
- * @entry: swap entry used for the lookup.
- *
- * A found folio will be returned unlocked and with its refcount increased.
- *
- * Context: Caller must ensure @entry is valid and protect the swap device
- * with reference count or locks.
- * Return: Returns the found folio on success, NULL otherwise. The caller
- * must lock nd check if the folio still matches the swap entry before
- * use (e.g., folio_matches_swap_entry).
- */
-struct folio *swap_cache_get_folio(swp_entry_t entry)
-{
-	void *entry_val;
-	struct folio *folio;
-
-	for (;;) {
-		rcu_read_lock();
-		entry_val = xa_load(&swap_cache, entry.val);
-		if (!entry_val || xa_is_value(entry_val)) {
-			rcu_read_unlock();
-			return NULL;
-		}
-		folio = entry_val;
-		if (likely(folio_try_get(folio))) {
-			rcu_read_unlock();
-			return folio;
-		}
-		rcu_read_unlock();
-	}
-
-	return NULL;
-}
-
-/**
- * swap_cache_get_shadow - Looks up a shadow in the swap cache.
- * @entry: swap entry used for the lookup.
- *
- * Context: Caller must ensure @entry is valid and protect the swap device
- * with reference count or locks.
- * Return: Returns either NULL or an XA_VALUE (shadow).
- */
-void *swap_cache_get_shadow(swp_entry_t entry)
-{
-	void *entry_val;
-
-	rcu_read_lock();
-	entry_val = xa_load(&swap_cache, entry.val);
-	rcu_read_unlock();
-
-	if (xa_is_value(entry_val))
-		return entry_val;
-	return NULL;
-}
-
-/**
- * swap_cache_add_folio - Add a folio into the swap cache.
- * @folio: The folio to be added.
- * @entry: The swap entry corresponding to the folio.
- * @gfp: gfp_mask for XArray node allocation.
- * @shadowp: If a shadow is found, return the shadow.
- *
- * Context: Caller must ensure @entry is valid and protect the swap device
- * with reference count or locks.
- * The caller also needs to update the corresponding swap_map slots with
- * SWAP_HAS_CACHE bit to avoid race or conflict.
- *
- * Return: 0 on success, negative error code on failure.
- */
-int swap_cache_add_folio(struct folio *folio, swp_entry_t entry, gfp_t gfp, void **shadowp)
-{
-	XA_STATE_ORDER(xas, &swap_cache, entry.val, folio_order(folio));
-	unsigned long nr_pages = folio_nr_pages(folio);
-	unsigned long i;
-	void *old;
-
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
-
-	folio_ref_add(folio, nr_pages);
-	folio_set_swapcache(folio);
-	folio->swap = entry;
-
-	do {
-		xas_lock_irq(&xas);
-		xas_create_range(&xas);
-		if (xas_error(&xas))
-			goto unlock;
-		for (i = 0; i < nr_pages; i++) {
-			VM_BUG_ON_FOLIO(xas.xa_index != entry.val + i, folio);
-			old = xas_load(&xas);
-			if (old && !xa_is_value(old)) {
-				VM_WARN_ON_ONCE_FOLIO(1, folio);
-				xas_set_err(&xas, -EEXIST);
-				goto unlock;
-			}
-			if (shadowp && xa_is_value(old) && !*shadowp)
-				*shadowp = old;
-			xas_store(&xas, folio);
-			xas_next(&xas);
-		}
-		node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
-		lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
-unlock:
-		xas_unlock_irq(&xas);
-	} while (xas_nomem(&xas, gfp));
-
-	if (!xas_error(&xas))
-		return 0;
-
-	folio_clear_swapcache(folio);
-	folio_ref_sub(folio, nr_pages);
-	return xas_error(&xas);
-}
-
-/**
- * __swap_cache_del_folio - Removes a folio from the swap cache.
- * @folio: The folio.
- * @entry: The first swap entry that the folio corresponds to.
- * @shadow: shadow value to be filled in the swap cache.
- *
- * Removes a folio from the swap cache and fills a shadow in place.
- * This won't put the folio's refcount. The caller has to do that.
- *
- * Context: Caller must ensure the folio is locked and in the swap cache
- * using the index of @entry, and lock the swap cache xarray.
- */
-void __swap_cache_del_folio(struct folio *folio, swp_entry_t entry, void *shadow)
-{
-	long nr_pages = folio_nr_pages(folio);
-	XA_STATE(xas, &swap_cache, entry.val);
-	int i;
-
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
-
-	for (i = 0; i < nr_pages; i++) {
-		void *old = xas_store(&xas, shadow);
-		VM_WARN_ON_FOLIO(old != folio, folio);
-		xas_next(&xas);
-	}
-
-	folio->swap.val = 0;
-	folio_clear_swapcache(folio);
-	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
-	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
-}
-
-/**
- * swap_cache_del_folio - Removes a folio from the swap cache.
- * @folio: The folio.
- *
- * Same as __swap_cache_del_folio, but handles lock and refcount. The
- * caller must ensure the folio is either clean or has a swap count
- * equal to zero, or it may cause data loss.
- *
- * Context: Caller must ensure the folio is locked and in the swap cache.
- */
-void swap_cache_del_folio(struct folio *folio)
-{
-	swp_entry_t entry = folio->swap;
-
-	xa_lock_irq(&swap_cache);
-	__swap_cache_del_folio(folio, entry, NULL);
-	xa_unlock_irq(&swap_cache);
-
-	put_swap_folio(folio, entry);
-	folio_ref_sub(folio, folio_nr_pages(folio));
-}
-
-/**
- * __swap_cache_replace_folio - Replace a folio in the swap cache.
- * @old: The old folio to be replaced.
- * @new: The new folio.
- *
- * Replace an existing folio in the swap cache with a new folio. The
- * caller is responsible for setting up the new folio's flag and swap
- * entries. Replacement will take the new folio's swap entry value as
- * the starting offset to override all slots covered by the new folio.
- *
- * Context: Caller must ensure both folios are locked, and lock the
- * swap cache xarray.
- */
-void __swap_cache_replace_folio(struct folio *old, struct folio *new)
-{
-	swp_entry_t entry = new->swap;
-	unsigned long nr_pages = folio_nr_pages(new);
-	XA_STATE(xas, &swap_cache, entry.val);
-	int i;
-
-	VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_swapcache(new));
-	VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_locked(new));
-	VM_WARN_ON_ONCE(!entry.val);
-
-	for (i = 0; i < nr_pages; i++) {
-		void *old_entry = xas_store(&xas, new);
-		WARN_ON_ONCE(!old_entry || xa_is_value(old_entry) || old_entry != old);
-		xas_next(&xas);
-	}
-}
-
-/**
- * swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
- * @entry: The starting index entry.
- * @nr_ents: How many slots need to be cleared.
- *
- * Context: Caller must ensure the range is valid and all in one single cluster,
- * not occupied by any folio.
- */
-void swap_cache_clear_shadow(swp_entry_t entry, int nr_ents)
-{
-	XA_STATE(xas, &swap_cache, entry.val);
-	int i;
-
-	xas_lock(&xas);
-	for (i = 0; i < nr_ents; i++) {
-		xas_store(&xas, NULL);
-		xas_next(&xas);
-	}
-	xas_unlock(&xas);
-}
-
 /*
  * If we are the only user, then try to free up the swap cache.
  *
@@ -497,9 +250,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 	if (mem_cgroup_swapin_charge_folio(new_folio, NULL, gfp_mask, entry))
 		goto fail_unlock;
 
-	/* May fail (-ENOMEM) if XArray node allocation failed. */
-	if (swap_cache_add_folio(new_folio, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
-		goto fail_unlock;
+	swap_cache_add_folio(new_folio, entry, &shadow);
 
 	memcg1_swapin(entry, 1);
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 558ff7f413786..c9ec1a1458b4e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -712,7 +712,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 	BUG_ON(mapping != folio_mapping(folio));
 
 	if (folio_test_swapcache(folio)) {
-		swap_cache_lock_irq();
+		swap_cache_lock_irq(folio->swap);
 	} else {
 		spin_lock(&mapping->host->i_lock);
 		xa_lock_irq(&mapping->i_pages);
@@ -759,7 +759,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 			shadow = workingset_eviction(folio, target_memcg);
 		__swap_cache_del_folio(folio, swap, shadow);
 		memcg1_swapout(folio, swap);
-		swap_cache_unlock_irq();
+		swap_cache_unlock_irq(swap);
 		put_swap_folio(folio, swap);
 	} else {
 		void (*free_folio)(struct folio *);
@@ -798,7 +798,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 
 cannot_free:
 	if (folio_test_swapcache(folio)) {
-		swap_cache_unlock_irq();
+		swap_cache_unlock_irq(folio->swap);
 	} else {
 		xa_unlock_irq(&mapping->i_pages);
 		spin_unlock(&mapping->host->i_lock);
diff --git a/mm/vswap.c b/mm/vswap.c
index 9ed042a5357a1..371dd147bf70d 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -37,9 +37,15 @@
  * Swap descriptor - metadata of a swapped out page.
  *
  * @slot: The handle to the physical swap slot backing this page.
+ * @swap_cache: The folio in swap cache.
+ * @shadow: The shadow entry.
  */
 struct swp_desc {
 	swp_slot_t slot;
+	union {
+		struct folio *swap_cache;
+		void *shadow;
+	};
 };
 
 #define VSWAP_CLUSTER_SHIFT HPAGE_PMD_ORDER
@@ -170,6 +176,24 @@ static int vswap_debug_fs_init(void)
 }
 #endif
 
+/*
+ * Lockless version of vswap_iter - assumes caller holds cluster lock.
+ * Used when iterating within the same cluster with the lock already held.
+ */
+static struct swp_desc *__vswap_iter(struct vswap_cluster *cluster, unsigned long i)
+{
+	unsigned long slot_index;
+
+	lockdep_assert_held(&cluster->lock);
+	VM_WARN_ON(cluster->id != VSWAP_VAL_CLUSTER_IDX(i));
+
+	slot_index = VSWAP_IDX_WITHIN_CLUSTER_VAL(i);
+	if (test_bit(slot_index, cluster->bitmap))
+		return &cluster->descriptors[slot_index];
+
+	return NULL;
+}
+
 static struct swp_desc *vswap_iter(struct vswap_cluster **clusterp, unsigned long i)
 {
 	unsigned long cluster_id = VSWAP_VAL_CLUSTER_IDX(i);
@@ -449,7 +473,6 @@ void vswap_free(swp_entry_t entry, struct swap_cluster_info *ci)
 	if (!entry.val)
 		return;
 
-	swap_cache_clear_shadow(entry, 1);
 	zswap_invalidate(entry);
 	mem_cgroup_uncharge_swap(entry, 1);
 
@@ -461,6 +484,10 @@ void vswap_free(swp_entry_t entry, struct swap_cluster_info *ci)
 		return;
 	}
 
+	/* Clear shadow if present */
+	if (xa_is_value(desc->shadow))
+		desc->shadow = NULL;
+
 	if (desc->slot.val)
 		vswap_rmap_set(ci, desc->slot, 0, 1);
 
@@ -481,7 +508,7 @@ int folio_alloc_swap(struct folio *folio)
 	struct vswap_cluster *cluster = NULL;
 	struct swap_info_struct *si;
 	struct swap_cluster_info *ci;
-	int i, err, ret, nr = folio_nr_pages(folio), order = folio_order(folio);
+	int i, ret, nr = folio_nr_pages(folio), order = folio_order(folio);
 	struct swp_desc *desc;
 	swp_entry_t entry;
 	swp_slot_t slot = { 0 };
@@ -538,11 +565,7 @@ int folio_alloc_swap(struct folio *folio)
 	if (mem_cgroup_try_charge_swap(folio, entry))
 		goto out_free;
 
-	err = swap_cache_add_folio(folio, entry,
-				   __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN,
-				   NULL);
-	if (err)
-		goto out_free;
+	swap_cache_add_folio(folio, entry, NULL);
 
 	return 0;
 
@@ -670,6 +693,321 @@ static int vswap_cpu_dead(unsigned int cpu)
 	return 0;
 }
 
+/**
+ * swap_cache_lock - lock the swap cache for a swap entry
+ * @entry: the swap entry
+ *
+ * Locks the vswap cluster spinlock for the given swap entry.
+ */
+void swap_cache_lock(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster;
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+	spin_lock(&cluster->lock);
+	rcu_read_unlock();
+}
+
+/**
+ * swap_cache_unlock - unlock the swap cache for a swap entry
+ * @entry: the swap entry
+ *
+ * Unlocks the vswap cluster spinlock for the given swap entry.
+ */
+void swap_cache_unlock(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster;
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+}
+
+/**
+ * swap_cache_lock_irq - lock the swap cache with interrupts disabled
+ * @entry: the swap entry
+ *
+ * Locks the vswap cluster spinlock and disables interrupts for the given swap entry.
+ */
+void swap_cache_lock_irq(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster;
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+	spin_lock_irq(&cluster->lock);
+	rcu_read_unlock();
+}
+
+/**
+ * swap_cache_unlock_irq - unlock the swap cache with interrupts enabled
+ * @entry: the swap entry
+ *
+ * Unlocks the vswap cluster spinlock and enables interrupts for the given swap entry.
+ */
+void swap_cache_unlock_irq(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster;
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+	spin_unlock_irq(&cluster->lock);
+	rcu_read_unlock();
+}
+
+/**
+ * swap_cache_get_folio - Looks up a folio in the swap cache.
+ * @entry: swap entry used for the lookup.
+ *
+ * A found folio will be returned unlocked and with its refcount increased.
+ *
+ * Context: Caller must ensure @entry is valid and protect the cluster with
+ * reference count or locks.
+ *
+ * Return: Returns the found folio on success, NULL otherwise. The caller
+ * must lock and check if the folio still matches the swap entry before
+ * use (e.g., folio_matches_swap_entry).
+ */
+struct folio *swap_cache_get_folio(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	struct folio *folio;
+
+	for (;;) {
+		rcu_read_lock();
+		desc = vswap_iter(&cluster, entry.val);
+		if (!desc) {
+			rcu_read_unlock();
+			return NULL;
+		}
+
+		/* Check if this is a shadow value (xa_is_value equivalent) */
+		if (xa_is_value(desc->shadow)) {
+			spin_unlock(&cluster->lock);
+			rcu_read_unlock();
+			return NULL;
+		}
+
+		folio = desc->swap_cache;
+		if (!folio) {
+			spin_unlock(&cluster->lock);
+			rcu_read_unlock();
+			return NULL;
+		}
+
+		if (likely(folio_try_get(folio))) {
+			spin_unlock(&cluster->lock);
+			rcu_read_unlock();
+			return folio;
+		}
+		spin_unlock(&cluster->lock);
+		rcu_read_unlock();
+	}
+
+	return NULL;
+}
+
+/**
+ * swap_cache_get_shadow - Looks up a shadow in the swap cache.
+ * @entry: swap entry used for the lookup.
+ *
+ * Context: Caller must ensure @entry is valid and protect the cluster with
+ * reference count or locks.
+ *
+ * Return: Returns either NULL or an XA_VALUE (shadow).
+ */
+void *swap_cache_get_shadow(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	void *shadow;
+
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, entry.val);
+	if (!desc) {
+		rcu_read_unlock();
+		return NULL;
+	}
+
+	shadow = desc->shadow;
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+
+	if (xa_is_value(shadow))
+		return shadow;
+	return NULL;
+}
+
+/**
+ * swap_cache_add_folio - Add a folio into the swap cache.
+ * @folio: The folio to be added.
+ * @entry: The swap entry corresponding to the folio.
+ * @shadowp: If a shadow is found, return the shadow.
+ *
+ * Context: Caller must ensure @entry is valid and protect the cluster with
+ * reference count or locks.
+ *
+ * The caller also needs to update the corresponding swap_map slots with
+ * SWAP_HAS_CACHE bit to avoid race or conflict.
+ */
+void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadowp)
+{
+	struct vswap_cluster *cluster;
+	unsigned long nr_pages = folio_nr_pages(folio);
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+	unsigned long i;
+	struct swp_desc *desc;
+	void *old;
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
+
+	folio_ref_add(folio, nr_pages);
+	folio_set_swapcache(folio);
+	folio->swap = entry;
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+	spin_lock_irq(&cluster->lock);
+
+	for (i = 0; i < nr_pages; i++) {
+		desc = __vswap_iter(cluster, entry.val + i);
+		VM_WARN_ON(!desc);
+		old = desc->shadow;
+
+		/* Warn if slot is already occupied by a folio */
+		VM_WARN_ON_FOLIO(old && !xa_is_value(old), folio);
+
+		/* Save shadow if found and not yet saved */
+		if (shadowp && xa_is_value(old) && !*shadowp)
+			*shadowp = old;
+
+		desc->swap_cache = folio;
+	}
+
+	spin_unlock_irq(&cluster->lock);
+	rcu_read_unlock();
+
+	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
+	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
+}
+
+/**
+ * __swap_cache_del_folio - Removes a folio from the swap cache.
+ * @folio: The folio.
+ * @entry: The first swap entry that the folio corresponds to.
+ * @shadow: shadow value to be filled in the swap cache.
+ *
+ * Removes a folio from the swap cache and fills a shadow in place.
+ * This won't put the folio's refcount. The caller has to do that.
+ *
+ * Context: Caller must ensure the folio is locked and in the swap cache
+ * using the index of @entry, and lock the swap cache.
+ */
+void __swap_cache_del_folio(struct folio *folio, swp_entry_t entry, void *shadow)
+{
+	long nr_pages = folio_nr_pages(folio);
+	struct vswap_cluster *cluster;
+	struct swp_desc *desc;
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+	int i;
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+
+	for (i = 0; i < nr_pages; i++) {
+		desc = __vswap_iter(cluster, entry.val + i);
+		VM_WARN_ON_FOLIO(!desc || desc->swap_cache != folio, folio);
+		desc->shadow = shadow;
+	}
+	rcu_read_unlock();
+
+	folio->swap.val = 0;
+	folio_clear_swapcache(folio);
+	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
+	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
+}
+
+/**
+ * swap_cache_del_folio - Removes a folio from the swap cache.
+ * @folio: The folio.
+ *
+ * Same as __swap_cache_del_folio, but handles lock and refcount. The
+ * caller must ensure the folio is either clean or has a swap count
+ * equal to zero, or it may cause data loss.
+ *
+ * Context: Caller must ensure the folio is locked and in the swap cache.
+ */
+void swap_cache_del_folio(struct folio *folio)
+{
+	swp_entry_t entry = folio->swap;
+
+	swap_cache_lock_irq(entry);
+	__swap_cache_del_folio(folio, entry, NULL);
+	swap_cache_unlock_irq(entry);
+
+	put_swap_folio(folio, entry);
+	folio_ref_sub(folio, folio_nr_pages(folio));
+}
+
+/**
+ * __swap_cache_replace_folio - Replace a folio in the swap cache.
+ * @old: The old folio to be replaced.
+ * @new: The new folio.
+ *
+ * Replace an existing folio in the swap cache with a new folio. The
+ * caller is responsible for setting up the new folio's flag and swap
+ * entries. Replacement will take the new folio's swap entry value as
+ * the starting offset to override all slots covered by the new folio.
+ *
+ * Context: Caller must ensure both folios are locked, and lock the
+ * swap cache.
+ */
+void __swap_cache_replace_folio(struct folio *old, struct folio *new)
+{
+	swp_entry_t entry = new->swap;
+	unsigned long nr_pages = folio_nr_pages(new);
+	struct vswap_cluster *cluster;
+	struct swp_desc *desc;
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+	void *old_entry;
+	int i;
+
+	VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_swapcache(new));
+	VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_locked(new));
+	VM_WARN_ON_ONCE(!entry.val);
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+
+	for (i = 0; i < nr_pages; i++) {
+		desc = __vswap_iter(cluster, entry.val + i);
+		VM_WARN_ON(!desc);
+		old_entry = desc->swap_cache;
+		VM_WARN_ON(!old_entry || xa_is_value(old_entry) || old_entry != old);
+		desc->swap_cache = new;
+	}
+	rcu_read_unlock();
+}
 
 int vswap_init(void)
 {
-- 
2.52.0


