Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A1ED606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=J/wr5rhW
Received: by kanga.kvack.org (Postfix)
	id 7F4686B05C0; Fri,  6 Nov 2026 17:08:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CBFF6B05C1; Fri,  6 Nov 2026 17:08:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70A1F6B05C2; Fri,  6 Nov 2026 17:08:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A1FF6B05C0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:08:51 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D43571C2843
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:08:50 +0000 (UTC)
X-FDA: 85406084820.10.28359A8
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9D5CB40008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:08:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="J/wr5rhW";
	spf=pass (imf07.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794002928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7V2F+zDGhfbCGkDv7uMmAHQm9x2OVvO4ypTRhhXUa9c=;
	b=uHI9qBSt6gZF0OKa2cVtE67VhMF5mlDhr91cTltIcpN5Nfsy/kgGctwTtRytV5m8ok3TlV
	OMcJIaWTJXSFhWkz7jEGdjnH+03chn/oQFHQaGTn+omrjWegdO6F/2dZCAjEYz1eLdngWJ
	kf7mVg9c1Ja6GPmwH1tcORNk9qe19GY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794002928;
	b=ofG4X/tcKoFq7hgMnnoTLhHPhoL7L9YyiGiNYFgt0prxdSYwaXXwm9MVJqI3L9Yp9flg4Q
	1yA9vHoACZjgVqQ52iRny+000wr1FEtMI1fsmaQ5W3/wMx58ZIwuI27VQOr4SvrXFEaSV1
	cqSPrZLsop1geB2rpQazp5NKsLA8b+k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="J/wr5rhW";
	spf=pass (imf07.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794002928; x=1825538928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7V2F+zDGhfbCGkDv7uMmAHQm9x2OVvO4ypTRhhXUa9c=;
  b=J/wr5rhWbEC9iuWUqZFz/06OaIoD8We8y7dHEQqPp+H7UxqIXS20ZnWZ
   0bsfisTEr/v1rtCI2yDX95GO3sTmwnVzEnw7hWyAyV6VSu+6rozpsrOCD
   FzAMcZ58ehLA8vLFPUQnw/xL0b9qdmDv9Zp61RgQ7UyAZJoEYKMmvB00t
   O+jbral+OlV49pfjKHedWmV6JVVDoR6upZGNMQ4CKE0s6aqL95CLeSYE8
   2aMxXiP1fAa0DOK6xLuzWSYgpr66YsO8xIi0euBiPK6NNMvsGMH/WMUPS
   FWHy/DZcqQU/r3Vy8ARoN+KZMMdmUt9vxiY3Ef+90cHAutllVxdT8+W2y
   Q==;
X-CSE-ConnectionGUID: qZleS3m3TZOM1UN4jSXFrQ==
X-CSE-MsgGUID: cLK0wNGgQzKEGWpG7b/HLw==
X-IronPort-AV: E=Sophos;i="6.27,199,1787011200"; 
   d="scan'208";a="33124031"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 22:08:47 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:23643]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.22.238:2525] with esmtp (Farcaster)
 id eaedad91-858b-4098-95c4-88367f80b45f; Fri, 6 Nov 2026 22:08:47 +0000 (UTC)
X-Farcaster-Flow-ID: eaedad91-858b-4098-95c4-88367f80b45f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:08:46 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:08:46 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <sashal@kernel.org>, <linux-mm@kvack.org>, <david@kernel.org>, yangge
	<yangge1116@126.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song
	<21cnbao@gmail.com>, David Hildenbrand <david@redhat.com>, SeongJae Park
	<sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mark Bundschuh
	<mkbund@amazon.com>
Subject: [PATCH v2 6.12 1/2] mm: replace free hugepage folios after migration
Date: Fri, 6 Nov 2026 22:08:34 +0000
Message-ID: <20261106220835.2878368-2-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261106220835.2878368-1-mkbund@amazon.com>
References: <20261105070442.3101877-1-mkbund@amazon.com>
 <20261106220835.2878368-1-mkbund@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam06
X-Stat-Signature: dzi6ek5enw1r567qm6disddh1n7cbcuq
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9D5CB40008
X-Rspam-User: 
X-HE-Tag: 1794002928-452141
X-HE-Meta: U2FsdGVkX1+c6JqjD66EA6illZBZ+80I97BI+A3l3qvzf6OH/paVh8ZlnOKD123jedZoor99JpSZ3iVXzAxzuKZBOvlJojlRXyDTuofNS0oAgtaiykUME1AI2YhAz3B3J+kcfo3E5cJQXthWEdLam1ZpElWukuOtCYTUqtTueqWvtJbLJ53OYV03Paib8opIikwo83QQzzJbqo/phVgj7iw8kEsjV08iVcXoiKwqko6Z00YFKc48D8rI3t0HGLHdHhDAyIeZebqK8sDY9Mq2v3NjxZwt32ppzd4JRWSHGVeHwBlrz9aqKu9vzXKEKY88DrBBavQ87PJ1Adt+O7NHM5tk4KkXytMfiolKLHs4SLd/5aEpMaWvDAxNaaLpsSeGd8X5GkWmi0/mp9KfEpV1em1QBjM0KvwuREs/mfxjsaCOEQmDFhbhR+l1YdwKkoxeeNR+twFpLUD2ikoJbUhxZU3845eCF6K2Y3HEyRwvg+IhsPpEecpxyCvOpCkdeStw5OTSDXHCnlBnlGagXADnve6RBvPFqG6atJD/HqjEhJZ3CHPkQQ7VqhuDTwC1m315gvbHs97pVaDxAv8hQmPlIOPHhI87dppIpBqy49AYD8tGh68IqRM/yejWc/5vsmW3bqAfN4JaiSa3RspWl1syDNJ0rbb5I7D+OB8rZ4rAvdaFNTlgDtGGa62WJsPs3zg/MZqiAkWjjcdfuwYq7q0N0L/zIa9aKNBkXFeEzZi9sbCRyu6WeMT6sthKFdUPDHU7x0kulMcNX1BQPaWePNF5JcEMEN0cwy26RzalML3v5NHuJliYzK/eiN0LHnElDAO1FrHoVcpUVLXtv3NHzNI49rthEvCXxrb8Nr39LlOo69rUZmtuiqNUzDAGtCuMWivoM7R07fXG9FBVu+JbexAjobJeNXj7mOl9mEqNzLBLCScXMnolT3FAY5w6RH82fnMcmurD3cwgWhTYpvWY37a
 I9RhQM0U
 wrJ9mwDWw8DioKtv8cqNg3Cmf7xmEQH2HtV3Eyn0jGZgB8TmRex9te0x9oRDpVBR3kmZZpxvAniJ4VEnLfDXOFC41hk6Rr20DDFGSV9xETqLC8qgGDLkAv1SVZsQeoqnXbKgLnBj+Ju10KQElZNVVlknl7/vJ2A6mluJA3NJKvuy/nqPDf152AkTd3B14Cb1yR4OquY83WOn56NOa0KCeFIHobcRKxPPxwBAMROGQJV0F5FT5NeLPUoe+cqNd340yqwnZtYMsjc09ho8LArP/9UotSm2N4wh6Te0s1WjRzRH30UyoYbwhGpqH/ZtaJ3YydnUeex9eT0/PmdOLPfqnbVFM+ZGrnlcpCWeK6J3bk6GSrhBI5UVtm/uTRTpRlq7qKF/W6ID+1+dwYwWKDQSalMRfjw/wXr9UqWEFNEzmDaSvliFLSDidjJz4FQd1YbwxR+2juLg2BvYx7Okq29SaT6MCm3IXWT2RE9SAW9HR8Qr6qtUgMqNLrym58GZndKipKHR07EvSJU2OjIALIwmcWMxJ57cxlIU1Co8ggK+CPCXBCkQ3gUfeG6fKoT2qt6oAztsOA2h7ro6rwkqst/KVIU/iQ0RMauC33dW4SyM5tJ0sF3AgcNfoNXq7wRgNSa3bso9WO0EZ2VgmQNmJeJsgqBpRZXf84z4h6qRcYmmGkJTSwjRlmtdYP2gue7v7y2wM4nlDpzExg0FBsNy81YTb7HQkY9W141UFvyE89maCBxGW0wL30iMDRcEUMyFn3nlaFJSyDLAe079AFo+c+kE+mxLXtfV7PCkkVCrO9jnhYsYi8Bu+ZLmJEpcqvZ0Jgencnp851qwtyrywndioiNeaFji3u/QVIONsbhyh/KLi1o9tdgJWxGj5yKiEzN0H41ku/rm/TCRpLouvrleL65t4xzKzvguc0ynw0162
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: yangge <yangge1116@126.com>

[ Upstream commit 04f13d241b8b146b23038bffd907cb8278391d07 ]

My machine has 4 NUMA nodes, each equipped with 32GB of memory.  I have
configured each NUMA node with 16GB of CMA and 16GB of in-use hugetlb
pages.  The allocation of contiguous memory via cma_alloc() can fail
probabilistically.

When there are free hugetlb folios in the hugetlb pool, during the
migration of in-use hugetlb folios, new folios are allocated from the free
hugetlb pool.  After the migration is completed, the old folios are
released back to the free hugetlb pool instead of being returned to the
buddy system.  This can cause test_pages_isolated() check to fail,
ultimately leading to the failure of cma_alloc().

Call trace:

cma_alloc()
    __alloc_contig_migrate_range() // migrate in-use hugepage
    test_pages_isolated()
        __test_page_isolated_in_pageblock()
             PageBuddy(page) // check if the page is in buddy

To address this issue, we introduce a function named
replace_free_hugepage_folios().  This function will replace the hugepage
in the free hugepage pool with a new one and release the old one to the
buddy system.  After the migration of in-use hugetlb pages is completed,
we will invoke replace_free_hugepage_folios() to ensure that these
hugepages are properly released to the buddy system.  Following this step,
when test_pages_isolated() is executed for inspection, it will
successfully pass.

Additionally, when alloc_contig_range() is used to migrate multiple in-use
hugetlb pages, it can result in some in-use hugetlb pages being released
back to the free hugetlb pool and subsequently being reallocated and used
again.  For example:

[huge 0] [huge 1]

To migrate huge 0, we obtain huge x from the pool.  After the migration is
completed, we return the now-freed huge 0 back to the pool.  When it's
time to migrate huge 1, we can simply reuse the now-freed huge 0 from the
pool.  As a result, when replace_free_hugepage_folios() is executed, it
cannot release huge 0 back to the buddy system.  To address this issue, we
should prevent the reuse of isolated free hugepages during the migration
process.

Link: https://lkml.kernel.org/r/1734503588-16254-1-git-send-email-yangge1116@126.com
Link: https://lkml.kernel.org/r/1736582300-11364-1-git-send-email-yangge1116@126.com
Signed-off-by: yangge <yangge1116@126.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mark Bundschuh <mkbund@amazon.com>
---
 include/linux/hugetlb.h |  7 +++++++
 mm/hugetlb.c            | 42 +++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c         | 12 +++++++++++-
 3 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 7eaabacdf110..7b5395e361d5 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -690,6 +690,7 @@ struct huge_bootmem_page {
 
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
 void wait_for_freed_hugetlb_folios(void);
+int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
@@ -1081,6 +1082,12 @@ static inline void wait_for_freed_hugetlb_folios(void)
 {
 }
 
+static inline int replace_free_hugepage_folios(unsigned long start_pfn,
+		unsigned long end_pfn)
+{
+	return 0;
+}
+
 static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 					   unsigned long addr,
 					   int avoid_reserve)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 68e0cc0748ca..a3d3fb1de3ec 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -48,6 +48,7 @@
 #include <linux/page_owner.h>
 #include "internal.h"
 #include "hugetlb_vmemmap.h"
+#include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
@@ -1350,6 +1351,9 @@ static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h,
 		if (folio_test_hwpoison(folio))
 			continue;
 
+		if (is_migrate_isolate_page(&folio->page))
+			continue;
+
 		list_move(&folio->lru, &h->hugepage_activelist);
 		folio_ref_unfreeze(folio, 1);
 		folio_clear_hugetlb_freed(folio);
@@ -2991,6 +2995,44 @@ void wait_for_freed_hugetlb_folios(void)
 	flush_work(&free_hpage_work);
 }
 
+/*
+ *  replace_free_hugepage_folios - Replace free hugepage folios in a given pfn
+ *  range with new folios.
+ *  @start_pfn: start pfn of the given pfn range
+ *  @end_pfn: end pfn of the given pfn range
+ *  Returns 0 on success, otherwise negated error.
+ */
+int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
+{
+	struct hstate *h;
+	struct folio *folio;
+	int ret = 0;
+
+	LIST_HEAD(isolate_list);
+
+	while (start_pfn < end_pfn) {
+		folio = pfn_folio(start_pfn);
+		if (folio_test_hugetlb(folio)) {
+			h = folio_hstate(folio);
+		} else {
+			start_pfn++;
+			continue;
+		}
+
+		if (!folio_ref_count(folio)) {
+			ret = alloc_and_dissolve_hugetlb_folio(h, folio,
+							       &isolate_list);
+			if (ret)
+				break;
+
+			putback_movable_pages(&isolate_list);
+		}
+		start_pfn++;
+	}
+
+	return ret;
+}
+
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				    unsigned long addr, int avoid_reserve)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d8209a512019..3686b787c14e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6730,7 +6730,17 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 	ret = __alloc_contig_migrate_range(&cc, start, end, migratetype);
 	if (ret && ret != -EBUSY)
 		goto done;
-	ret = 0;
+
+	/*
+	 * When in-use hugetlb pages are migrated, they may simply be released
+	 * back into the free hugepage pool instead of being returned to the
+	 * buddy system.  After the migration of in-use huge pages is completed,
+	 * we will invoke replace_free_hugepage_folios() to ensure that these
+	 * hugepages are properly released to the buddy system.
+	 */
+	ret = replace_free_hugepage_folios(start, end);
+	if (ret)
+		goto done;
 
 	/*
 	 * Pages from [start, end) are within a pageblock_nr_pages
-- 
2.50.1


