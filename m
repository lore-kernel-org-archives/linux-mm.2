Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84A2FD3B7E1
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 23:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDECB6B000D; Sat,  6 Dec 2025 18:03:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB5FD6B000E; Sat,  6 Dec 2025 18:03:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCC696B0010; Sat,  6 Dec 2025 18:03:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C94026B000D
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 18:03:35 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 992ED160692
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:03:35 +0000 (UTC)
X-FDA: 84190574790.03.AF8E3B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1591980004
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:03:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e2hpO4bO;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765062214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/W0zQoNOacOk69UP9iFtSpg99/UK2NmVzsBZAwvune8=;
	b=gLzSFhWrsCJ34uMZh9v15usNOmxcDTDwU7ux2fTa48MLeOQ8SaJHRfa224YQLG2ZAHZTMe
	7glSLYYBJTIC+/wU62Ifv9LxTROcGuQpC0aDBigSCAQD/Fyh9r94BV5bphpSGpMiom6igY
	IV/36sc/p/Mcs4+FqciX3PkYDI5V4wo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765062214; a=rsa-sha256;
	cv=none;
	b=4CE503Se2uYhCX0VckHBzVrDXn97sH9c0AI5pilUCTRbX3Tqyeik561d+qPYBsQgK576K7
	3/7u1yCsNg3fhFMRgKVSDh4fINulPwyfO242CkVaADJUUxiO8Lg874LctmErchex7SwwGr
	4OpZKg+nTnN0KYdOKmFp6+vYEKpOh+M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e2hpO4bO;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9715D60147;
	Sat,  6 Dec 2025 23:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E9DC4CEF5;
	Sat,  6 Dec 2025 23:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765062213;
	bh=Ox02xBcc//UKEAF8uiKCw4Rli2lYMNILbHVcsJbEz2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2hpO4bO+wM9UQfsdrf2uqicJ0FhxW6Sm9mZD278uMA/3d+W7v++CxtfI+PDsnr3i
	 uuqVGuNh09q4miQgjKdGoJNcTK29NQuti8nBQgSG6/7qnipDYKeuMd6FkmQjKF8Zsz
	 rjpuKq43X6t5HMWMg7cDp/xDL8Y7Jy5WaFPxm2Oxc6WqBifJ3A1KiTNCMuqXYCcbVv
	 AOTDaP2dy8xNgBDLJhL2fubY1EdA3HJb/0Dr3FAMUcqAoVorb3NR7BPyZ8iBs6ftlt
	 P2Oc3bHYta6eCIoR+ClYxLrAOr5DayoOTb1odeFfyWG+c2YS/C+O0wJd1dVKE8ZaeW
	 +iJZejAXfvvTw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Vipin Sharma <vipinsh@google.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	kexec@lists.infradead.org
Subject: [RFC PATCH 05/10] mm: hugetlb: export some functions to hugetlb-internal header
Date: Sun,  7 Dec 2025 00:02:15 +0100
Message-ID: <20251206230222.853493-6-pratyush@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251206230222.853493-1-pratyush@kernel.org>
References: <20251206230222.853493-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1591980004
X-Stat-Signature: 514ohzq5dpezx3okekzpf8k9xrfdsdp6
X-Rspam-User: 
X-HE-Tag: 1765062213-929698
X-HE-Meta: U2FsdGVkX18EHayKS9PeESleSiEashfpkot8tT7tXdXLt8Tb4ujYysX8DOLIBLlu4afSCN+24kQPS9X0dqMTy2JPqgVs0qPJTWjLzD6pcKH1rKe2pD2g7FFxemHW465pYbtNe8L/HoQHg+gv/uppVyvJza8xc+Z09rHzOWhEjMlbpVXsIXr2czckvppzT7DarHfJayfTyROAwLlmbGhVvpGlFzlNN7L2d4NtJTupF40QswfoDxGI53Vb5wos5vmB4AxZSJluagPrP1+tSYBkwAv+S7pI3I5AsXOFGrfYMWqunAgfDOYqw2Mxeqw833MAz00kyD+uioLjZQgAxNEihvc236r/9g9F85UAp0SrNWGKRPUHq45F66OIx/kEcJeNcwBsKMS5nV3VzpuTLhk02G5HKBpgtxaRPTV5/WQpjRtXziTrjZw5vwzyvzVh3fyfe+qd9uqagbf7S1svEiqLt5AYexAj2y8XLw81zjPDwGdQrghLpM7YKt+y5nK52ovxcmznVOQFCxN2ckYudXx0BgVxHMNM1OuoJAJqehc/pWOcWzM/9QTzA45H7zNCxnmdczIJo+wTp2PyGYvDSW5JXwjF41p/qfR10kQhC4AJTSG+1xd+7b4tncgkU+9fvAdLMG1hQyIjzXC+sTGMMJN4ejXhSR7nlqBDiHE2W261U5Cu3uGnyxBZrOybahOfbZt6z3w4o7VgYk/PCVRvScdcGjERkgYhTLY/vUAkSTD7ni257sIyKgCi9TbYEB9VKNAqTHw2EI0XNsFv77+BDzja7rQDbu9Tr4sayDTwU0fLyA/IgOrcaNtVK+2qi3K/46/p9kNSYMpYsOYdoknEuKnDDiwNTWLp1Lvp2x2y1nM1ZG4bz7WMMUHIrL4rzB5GXpFaft/DoMqcW1uxrVGWTu0hrSRsOWlzPv9PkIxcoauYEN1dww75wgEvEDB8kFU6PiMgbVJbucgdUjcfXdtfOe+
 G66xmV6Y
 mIsA36GwOGd7M1w0ccs+7qiuh7GhbxexlERr2v02XGH73Yy3/gH5r+qUAwMmuSWymKMU60fzEZzxXMzcVBcSU3Xg2moFXE1km39O5Hx6XYbdSNnkNPvShbcSSHro/FfNT4fxL3VgvWwF8znfon60Ghy1zvI3i/hKzuQ3yDIv3z4nqV2AX6MpvgcaerIX70DvlynBRvxyLRMKzwLETRcgj0loxQWwSpzQGEqGg9gnkYAGTrRI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A later commit will add support for live updating a memfd backed by
HugeTLB. It needs access to these internal functions to prepare the
folios and properly queue them to the hstate and the file. Move them out
to a separate hugetlb-internal header.

There does exist include/linux/hugetlb.h, but that contains higher level
routines. It also prefixes the function names to make it clear they
belong to hugetlb. These are low-level routines that do not need to be
exposed to the public API, and renaming them to prefix with hugetlb is
going to cause a lot of code churn. So create mm/hugetlb_internal.h that
contains these definitions.

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---
 MAINTAINERS           |  1 +
 mm/hugetlb.c          | 33 +++++++++------------------------
 mm/hugetlb_internal.h | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 24 deletions(-)
 create mode 100644 mm/hugetlb_internal.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 2722f98d0ed7..fc23a0381e19 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11540,6 +11540,7 @@ F:	mm/hugetlb.c
 F:	mm/hugetlb_cgroup.c
 F:	mm/hugetlb_cma.c
 F:	mm/hugetlb_cma.h
+F:	mm/hugetlb_internal.h
 F:	mm/hugetlb_vmemmap.c
 F:	mm/hugetlb_vmemmap.h
 F:	tools/testing/selftests/cgroup/test_hugetlb_memcg.c
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0455119716ec..0f818086bf4f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -55,6 +55,8 @@
 #include "hugetlb_cma.h"
 #include <linux/page-isolation.h>
 
+#include "hugetlb_internal.h"
+
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
@@ -733,9 +735,8 @@ static int allocate_file_region_entries(struct resv_map *resv,
  * fail; region_chg will always allocate at least 1 entry and a region_add for
  * 1 page will only require at most 1 entry.
  */
-static long region_add(struct resv_map *resv, long f, long t,
-		       long in_regions_needed, struct hstate *h,
-		       struct hugetlb_cgroup *h_cg)
+long region_add(struct resv_map *resv, long f, long t, long in_regions_needed,
+		struct hstate *h, struct hugetlb_cgroup *h_cg)
 {
 	long add = 0, actual_regions_needed = 0;
 
@@ -800,8 +801,7 @@ static long region_add(struct resv_map *resv, long f, long t,
  * zero.  -ENOMEM is returned if a new file_region structure or cache entry
  * is needed and can not be allocated.
  */
-static long region_chg(struct resv_map *resv, long f, long t,
-		       long *out_regions_needed)
+long region_chg(struct resv_map *resv, long f, long t, long *out_regions_needed)
 {
 	long chg = 0;
 
@@ -836,8 +836,7 @@ static long region_chg(struct resv_map *resv, long f, long t,
  * routine.  They are kept to make reading the calling code easier as
  * arguments will match the associated region_chg call.
  */
-static void region_abort(struct resv_map *resv, long f, long t,
-			 long regions_needed)
+void region_abort(struct resv_map *resv, long f, long t, long regions_needed)
 {
 	spin_lock(&resv->lock);
 	VM_BUG_ON(!resv->region_cache_count);
@@ -1162,19 +1161,6 @@ void resv_map_release(struct kref *ref)
 	kfree(resv_map);
 }
 
-static inline struct resv_map *inode_resv_map(struct inode *inode)
-{
-	/*
-	 * At inode evict time, i_mapping may not point to the original
-	 * address space within the inode.  This original address space
-	 * contains the pointer to the resv_map.  So, always use the
-	 * address space embedded within the inode.
-	 * The VERY common case is inode->mapping == &inode->i_data but,
-	 * this may not be true for device special inodes.
-	 */
-	return (struct resv_map *)(&inode->i_data)->i_private_data;
-}
-
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma)
 {
 	VM_BUG_ON_VMA(!is_vm_hugetlb_page(vma), vma);
@@ -1887,14 +1873,14 @@ void free_huge_folio(struct folio *folio)
 /*
  * Must be called with the hugetlb lock held
  */
-static void account_new_hugetlb_folio(struct hstate *h, struct folio *folio)
+void account_new_hugetlb_folio(struct hstate *h, struct folio *folio)
 {
 	lockdep_assert_held(&hugetlb_lock);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[folio_nid(folio)]++;
 }
 
-static void init_new_hugetlb_folio(struct folio *folio)
+void init_new_hugetlb_folio(struct folio *folio)
 {
 	__folio_set_hugetlb(folio);
 	INIT_LIST_HEAD(&folio->lru);
@@ -2006,8 +1992,7 @@ static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
 	return folio;
 }
 
-static void prep_and_add_allocated_folios(struct hstate *h,
-					struct list_head *folio_list)
+void prep_and_add_allocated_folios(struct hstate *h, struct list_head *folio_list)
 {
 	unsigned long flags;
 	struct folio *folio, *tmp_f;
diff --git a/mm/hugetlb_internal.h b/mm/hugetlb_internal.h
new file mode 100644
index 000000000000..edfb4eb75828
--- /dev/null
+++ b/mm/hugetlb_internal.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2025 Pratyush Yadav <pratyush@kernel.org>
+ */
+#ifndef __HUGETLB_INTERNAL_H
+#define __HUGETLB_INTERNAL_H
+
+#include <linux/mm.h>
+#include <linux/hugetlb.h>
+#include <linux/hugetlb_cgroup.h>
+#include <linux/list.h>
+
+void init_new_hugetlb_folio(struct folio *folio);
+void account_new_hugetlb_folio(struct hstate *h, struct folio *folio);
+
+long region_chg(struct resv_map *resv, long f, long t, long *out_regions_needed);
+long region_add(struct resv_map *resv, long f, long t, long in_regions_needed,
+		struct hstate *h, struct hugetlb_cgroup *h_cg);
+void region_abort(struct resv_map *resv, long f, long t, long regions_needed);
+void prep_and_add_allocated_folios(struct hstate *h, struct list_head *folio_list);
+
+static inline struct resv_map *inode_resv_map(struct inode *inode)
+{
+	/*
+	 * At inode evict time, i_mapping may not point to the original
+	 * address space within the inode.  This original address space
+	 * contains the pointer to the resv_map.  So, always use the
+	 * address space embedded within the inode.
+	 * The VERY common case is inode->mapping == &inode->i_data but,
+	 * this may not be true for device special inodes.
+	 */
+	return (struct resv_map *)(&inode->i_data)->i_private_data;
+}
+
+#endif /* __HUGETLB_INTERNAL_H */
-- 
2.43.0


