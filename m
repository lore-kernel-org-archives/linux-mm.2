Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBA93C624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 03:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57EDF6B00FE; Wed,  2 Sep 2026 23:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52F2D6B0101; Wed,  2 Sep 2026 23:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41E936B0102; Wed,  2 Sep 2026 23:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10E5D6B00FE
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:01:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79C534041A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:01:51 +0000 (UTC)
X-FDA: 85170951222.23.54A6A28
Received: from mta1.migadu.com (out-209.mta1.migadu.com [95.215.58.209])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7A2EE18000A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:01:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Khe4o3CY;
	spf=pass (imf06.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.209 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788404509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7OfMYwhlPvZ9/mL/fjbOia+cU/EmcuQqcxXre8Z40Lw=;
	b=w8yyfhNhCCidCzb24glnv6nUN3EEpZx5w2hwBLFJcRoUQf9YgTyZpO5fX6ID27ZufN74pm
	fEJFXZYXvE35u8we9yLLHvw3OYXnb0XrIDZmUIs+u/YD297+7fBvkKFxyQET8iKUvwP5iE
	i4M39AQu/eH+Ive+1fj4tZpR5YgDc38=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788404509;
	b=pKJC8kO1R4uUYer4n2RF89bhinAY2WiE33cexKh9Q0byij7QxHS5/yTyo9O8hQZ7Du12Oq
	FeQ6nOtHsIKBHoPR9oU6DVk0ssx4dG9PKa1uLqHZP9WkKA20RxVDeqjXlgJsbC5utY3UCT
	2rGHVD/Hfbl8iiOOWv9T3V+sVORK+Bg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Khe4o3CY;
	spf=pass (imf06.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.209 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TkSdh57Swo1DoNq0az2nIVsOJeaHu9kVpMvm44mAYIs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788404507; v=1; x=1789009307;
 b=Khe4o3CYUb90K0OfbXxFn/vQFlOszibWcruJX46pjYUGfWKSSr1K5UwSJTVrvoGt7i5KRsfQ
 cvS59/nXV+bZQKFXM7i3lJWYgrkF93DKHzE3+1r12ccLpMwZh6LuMVGRpmMrp7DqpKfeo2SfHaF
 dXpHH/UVIi9xuHNE1QOe56U8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9f817857e9b42d3f;
	Thu, 03 Sep 2026 03:01:47 +0000
X-Mizu-Trace-ID: 9f817857e9b42d3f
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	vivek.kasireddy@intel.com
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v2] mm/memfd: fix hugetlb reservation accounting in error paths
Date: Thu,  3 Sep 2026 11:01:34 +0800
Message-ID: <20260903030134.7407-1-hongfu.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7A2EE18000A
X-Stat-Signature: z8ziyq6fmibwhumx6e771iychahztaxy
X-HE-Tag: 1788404509-410052
X-HE-Meta: U2FsdGVkX19htj7z3jMhGjcbAXfRTqT4RejqP75WygY9mfEFKRsWuRkUI33IQojB6xdIMpRX8rvpn2faQe3fhcZh60PDZ4kAfEC7+ddnRKKHbkmU3aJxuEFbVUsTXEjt2nYr2IR2DwQB88kpoaAxMzo+aRWjvt4fMC9ZE93gtIGU67EMahh2vj/NUlb7fnf9HJ0ZrnTjM1q2xEIWXdRTbe51nHcTZ4ZiWBcvnszAnfUlo8NAhY4u5As2wqhLKJsVNbAXPYsqslv3dGu78f8EYbwZ1dxp7pgYAP4JraCrLURiysmrVviySV9whbGtuEO0VrYhLcHeXckXg68qJTggfXHDoRaFmRCPUDVLGe6lEus7tzJkdXuf7xgjVSnQgDDP6U5ZGV8Qg/nbNqs5gU0l/MpF4frzC1+MYCMQ122qp/7uF6VimEfQr4lkQiQTwV+f7equ9rmoBB2+9jXyFeosxEpPXmE80Fysm1a5WjIEnZJt9IqXNXuR5xWEaBuhHngI0kyYmQl6WHJ7tVmV4YjfRTgbRmz+HEJENOQIuzJukPXEIroocKCIbRwNm6/81hGzHKdSpqcew9XZgQzN72mqCLy7cYixZIUDdaI/Kieo+uCZ3Nro5qC6i9uH7ZYLzP/yONncuJMHhscqtM2vuM307L6y3jKha1nh0NLbJzjBZOLRjFWE/GBRsLspCvapm9OHbgchrJM+xnWSzWhFnFdhuefKQG7L0vW9gFubLQwB+jbIOAy5whD3lrzJwOKINHQoo+AgS33kx4z20nv195ql+fCnMj8jGYlV10uudkqItBfRjXAVWDP3vmNzxkh4n9ZzS8h2lLY5KHCg11322wUvGuo4SaF2rJMMJ2iOpsV7EMZd3sCeIZIweYO4g2OzjlYhWL1o0bqWGusf28b04pVTAjBfNuJquZ4IkVcJtvFEudWSQvXsPUgMc9kBvb7mHNjUlFmyKdoXXzPq4ujoJrl
 RVEMNKmF
 TRpbOJy1MXERV8zV7Rbh2NvjzuHgCBOOhZvMunIFkner3U3nVIZi2RdytdSNwxlCDNWHcVXW4WkmctWGR2+AAMBjq2o01s1PTZbeM6MF55vzP9NiFqMHHKvusVYxZoP60irr3FqQViHzvLJzvErikewMJOSaS1JdCbxI7l6Jq5pyT81E0Nrwqoek0v68jDIlH1blc8lqO8Pnx2pLxsdf7Z9mz27lh2e4v6riTKwGiIshSRfQcTUhPmg5L3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

If hugetlb_add_to_page_cache() in memfd_alloc_folio() fails with
-EEXIST, a concurrent fault has already instantiated the folio in the
page cache, and the reservation now belongs to that folio. Calling
hugetlb_unreserve_pages() in that case incorrectly removes the region
backing the cached folio. A later truncate or inode eviction then passes
a negative (chg - freed) into hugepage_subpool_put_pages(), corrupting
subpool and resv_huge_pages accounting.

Hold the hugetlb fault mutex from hugetlb_reserve_pages() until the
error-path unreserve completes to make the reserve, allocate and
instantiate steps atomic against concurrent faults.  With the mutex held
from the start, a concurrent fault can no longer consume the reservation
between reserve and allocate/instantiate. If a fault completed before the
mutex was taken, it has already added the region for that index, so
hugetlb_reserve_pages() returns 0 and the error path leaves the region
in place.

Fixes: 717cf9357325 ("mm/memfd: reserve hugetlb folios before allocation")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
v2:
- Take the hugetlb fault mutex before hugetlb_reserve_pages() and hold
  it until the error-path unreserve completes.
- Update commit message
- Link to v1: https://lore.kernel.org/all/20260831090631.29227-1-hongfu.li@linux.dev/ 
---
 mm/memfd.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/mm/memfd.c b/mm/memfd.c
index c708d92533f4..0f6fff004f5e 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -82,22 +82,31 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		struct hstate *h = hstate_file(memfd);
 		int err = -ENOMEM;
 		long nr_resv;
+		u32 hash;
 
 		gfp_mask = htlb_alloc_mask(h);
 		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
 		idx >>= huge_page_order(h);
 
+		/*
+		 * Serialize hugepage allocation and instantiation to prevent
+		 * races with concurrent allocations, as required by all other
+		 * callers of hugetlb_add_to_page_cache().
+		 */
+		hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);
+		mutex_lock(&hugetlb_fault_mutex_table[hash]);
+
 		nr_resv = hugetlb_reserve_pages(inode, idx, idx + 1, NULL, EMPTY_VMA_FLAGS);
-		if (nr_resv < 0)
-			return ERR_PTR(nr_resv);
+		if (nr_resv < 0) {
+			err = nr_resv;
+			goto out_unlock;
+		}
 
 		folio = alloc_hugetlb_folio_reserve(h,
 						    numa_node_id(),
 						    NULL,
 						    gfp_mask);
 		if (folio) {
-			u32 hash;
-
 			/*
 			 * Zero the folio to prevent information leaks to userspace.
 			 * Use folio_zero_user() which is optimized for huge/gigantic
@@ -112,20 +121,9 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 			 */
 			__folio_mark_uptodate(folio);
 
-			/*
-			 * Serialize hugepage allocation and instantiation to prevent
-			 * races with concurrent allocations, as required by all other
-			 * callers of hugetlb_add_to_page_cache().
-			 */
-			hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);
-			mutex_lock(&hugetlb_fault_mutex_table[hash]);
-
 			err = hugetlb_add_to_page_cache(folio,
 							memfd->f_mapping,
 							idx);
-
-			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-
 			if (err) {
 				folio_put(folio);
 				goto err_unresv;
@@ -133,11 +131,14 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 
 			hugetlb_set_folio_subpool(folio, subpool_inode(inode));
 			folio_unlock(folio);
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			return folio;
 		}
 err_unresv:
 		if (nr_resv > 0)
 			hugetlb_unreserve_pages(inode, idx, idx + 1, 0);
+out_unlock:
+		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		return ERR_PTR(err);
 	}
 #endif
-- 
2.54.0


