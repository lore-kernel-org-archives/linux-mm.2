Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 574C2606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=CFJPehV1
Received: by kanga.kvack.org (Postfix)
	id 66F166B05BB; Fri,  6 Nov 2026 17:08:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644EA6B05BC; Fri,  6 Nov 2026 17:08:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5839B6B05BD; Fri,  6 Nov 2026 17:08:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1CB6B05BB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:08:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE44040251
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:08:28 +0000 (UTC)
X-FDA: 85406083896.06.91784EC
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id 79A2DA0003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:08:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=CFJPehV1;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf25.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794002906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbAyuPi9NzogI7nzwmpN6mlrG30lt5BbfxmYWVdevPw=;
	b=oG2PoMUEPb3yYXayl/fCDS5UWWxzU3egMGtswHTHhJ9gkhv6xNGc6YoqLjlmTyZMgjyC06
	p1pIqgL4BXp6wA4uBc6a+eKlpHRU48x513l1RokTmHX+FoWuEc4zNBYYBvovtoo2Ij4+Ce
	5gM2r6StZ/zH5iJ7irkWDu58eIneo80=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=CFJPehV1;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf25.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794002906;
	b=yMilcFUEhc+Ux5qVnrdmIbUHPmtpCqRTiPPAzZp3QX2R5YXZ6HW/XoH92JXubKDhOLU4TV
	0Flp0Q40PEADJWOiFfwFTU7FDcW/lr43YOP1VTalKoUiGFa9EOjpEAojFKpkSelckIx/pu
	sSrIBXY+Aph7776AZ8J19Ki8OJJA6w0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794002906; x=1825538906;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zbAyuPi9NzogI7nzwmpN6mlrG30lt5BbfxmYWVdevPw=;
  b=CFJPehV10I17YAMprsuxyDBXS54sJ7MSkTwCSHlPczdNcrSW821AGOM7
   ALQAKpmyBuezB4QVrZ0x+7OhHvdBETmM5IBEVm1U+YL2fAwTFcH01haCr
   LQBVIRK9oOonhS3WIleCJNRHMgAmT4UjaibBFxw49BpvugpWQ7Q7yPMCv
   KXcT6Bnzytipy37tJ84x0nq7TFnFpEOTUWwdXCPp0ZsPbA6iQjTstgU5G
   pzGIofQAYtZIuGgjHRbdOLkH4CP+UUz3LIdurO/VX2rp4YgF6ZyST22mo
   kvbpSapbOB4HQ0FX3/Co+pop1Z8Ym/mFiNPwm6dxLLhtLLN9SzPOGe0zQ
   g==;
X-CSE-ConnectionGUID: 3ENr6ptMQUSK2l/xUV/pPQ==
X-CSE-MsgGUID: Yi2gD4WHRgil/XVulWwqyw==
X-IronPort-AV: E=Sophos;i="6.27,199,1787011200"; 
   d="scan'208";a="33359550"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 22:08:25 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:22828]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.22.238:2525] with esmtp (Farcaster)
 id 28dd1e93-96a6-4fda-9cdb-1e308285329d; Fri, 6 Nov 2026 22:08:25 +0000 (UTC)
X-Farcaster-Flow-ID: 28dd1e93-96a6-4fda-9cdb-1e308285329d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:08:24 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:08:24 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <sashal@kernel.org>, <linux-mm@kvack.org>, <david@kernel.org>, yangge
	<yangge1116@126.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song
	<21cnbao@gmail.com>, David Hildenbrand <david@redhat.com>, SeongJae Park
	<sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mark Bundschuh
	<mkbund@amazon.com>
Subject: [PATCH v2 6.6 1/2] mm: replace free hugepage folios after migration
Date: Fri, 6 Nov 2026 22:08:11 +0000
Message-ID: <20261106220812.2874571-2-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261106220812.2874571-1-mkbund@amazon.com>
References: <20261105070431.3100950-1-mkbund@amazon.com>
 <20261106220812.2874571-1-mkbund@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 79A2DA0003
X-Stat-Signature: 86zhtkh77htr85k7cqo8qkfcey7g3931
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794002906-82558
X-HE-Meta: U2FsdGVkX19/ZYG5gKrZ6wTwov5HZo7P57YQQdTEtPvEQLBG92FYLqs3BMuk0dxWBakCW+tgKf+ziznNZL1D0Y35PFSLs5c/OB8fgUfT7qrP9C2t7m2x1bQVUr59Og7jJCQW2W7fyH4W9iKRsIq5f0X2/o+nyeZjm9aJeKvXrtwD4l4mgfPn7+B3XYKMvaWp2TmaZ1fbkOO+xPLLMVKvArQfmYyGfEVORHWJsjKIIurEB/3UudJCJel1za9TZrUpxBEq7Gmv71NptPUik7WkDM4L5YrCIztSwH5hnI4VIDx3CcZEELZmDL2EN6QHdj9RWqc9puhzBX9h7NMLOuZyPhHxKrGGvOWd0kmzM6Dk5mVAAbkb4r9kwSv8dXqLu73RXeeLi/at6ADtQ/ycRyt49NdIKMaf9QZ+IBDgXzd0jvaZwsGPD6HLR27mfjdoDcgBMpHViYarLJZrjzrVcWUyV+7XkTqRyHBY26nvN1nHa4/Z7zjFW7ku+1vkXwZg2ZPZ8SwOZ4JkkynAcvyxnWpgC3v59B+Gc+/PxKkkK5XpvhYk5N/cvDFGw/y3fckZv5M2r+IrUzbBPpBJZEHPXiMBskLdFiCj6UUS07IPFHUermkaZw1o9nBUYZ/7Xu9xYtHj8UULbx9lem6Em3BLVKrAT4rqvXF/+LE6egDMNDlQ9CROE7OXZcx3g/oonYiKQGe6mGsEyANWHds681hvv03TBEjkGrH84i0sjYh3O/l8GBn60A0FUIUM9U6yA/ZY37/7weIrGtvPjcO3Z90j+xzBcZGeFEMWhzWiyo9TFWz2zbVZRYELCIqP5IVbIyTXJ4viP5Py+egLdc+6hFddG2ttoCYYdFGrsRH7Pxo2nZ5g8HYb0DslA7lOa86rdk7eFt/j7q5Q4Hui3oRQSTYa3vNBVhbDx46zFhLEVbJi3GYC1S6utIx7QATyrVw7NZNpuHccrCQGb0DGbWDqCJ2rBkK
 YeEmt4kn
 jej/Yp5YFqG6VSjH5WBGFRtoPGvD5m2Z+zQHQpQhiz8vAnXim9hEMHfHp3k/3KsVNzuH+77YWjneFiJlyi8CFW8dW3mpLDUO7mVblMlLplYrnWXF2roLaffCMr5SEYMxTl0pFWM5TY8KdJuHFKW3a/gYgzf/39wZwJiLidLqUwv7Yu3GLFcHoziMLMsRyOURyf5Rc23OF347Ht2NM1mboJjhy3xaB4Ki2lbQgbyzNn08RCXObO6SG67y8AMccPNU7aG2qJwH1txk4WVXmSCxTx5RxuQtF0ELez9HD3PHzrW0EN4R2veT2vptKlxT+GRP0tyP7oIEOgp3toFxYlDId1SMXiNBRee80w12s/xdugSbnuTjANG4Y8o8FI61/6dIirXqJpgvAO4yyVR55zm3LP3uQl6RRXsDN8z+KLCAnrnOINDX25KmLBPawNZo6eEqjzLgAQ8I0xaWab+79jrsHs+qJbKtM6cenTWdfR7kXQPG28wEynLZOUnGfTba1mD4GE0cb68PK7dsDM/6RQJS46u3krK2FY8HD2668AOYdL2pLH2A9cPRGihwp8BveBrEFolQcY4T+sZA0UP3nfrVHkWjOGsJ3nxo5M+IXBogg+1ShfZl3IebxZOU3gopF6R2F3JxP+gv7HLaZa/wMSwrvNjStMkktPk6bgZxH7jcgojpBqpLRvuPVTSTxZkM+EKPtM8SaeIXAP2cx2gAO6jZZjVfiOTU7/R6cwV/uQGSIwTaEZ4kSZCM85G2X/epF1c2T0au8YtEov1vKklQxxVChGCTL+Zp2+SRzLkZVLMoo/GtvYEfJzXtWaQPMchh/y+AYJ/2CPxb2TVz58SMVWBO+P4i4GkMfh51P+8eBxz8iERQ9iIFJQoV3tVCnvnmG2xkKMKiBtP92B2JsQpCx0w0CxOom9vZ0DqyhcF72
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
index 6ecf2907172b..996fee996517 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -745,6 +745,7 @@ struct huge_bootmem_page {
 };
 
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
+int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
@@ -1049,6 +1050,12 @@ static inline int isolate_or_dissolve_huge_page(struct page *page,
 	return -ENOMEM;
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
index 8bfaaa84bb3f..2ef28c49b9d0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -47,6 +47,7 @@
 #include <linux/page_owner.h>
 #include "internal.h"
 #include "hugetlb_vmemmap.h"
+#include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
@@ -1344,6 +1345,9 @@ static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h,
 		if (folio_test_hwpoison(folio))
 			continue;
 
+		if (is_migrate_isolate_page(&folio->page))
+			continue;
+
 		list_move(&folio->lru, &h->hugepage_activelist);
 		folio_ref_unfreeze(folio, 1);
 		folio_clear_hugetlb_freed(folio);
@@ -3048,6 +3052,44 @@ int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list)
 	return ret;
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
index 06c493b908ed..7c8dffb7f05f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6254,7 +6254,17 @@ int alloc_contig_range(unsigned long start, unsigned long end,
 	ret = __alloc_contig_migrate_range(&cc, start, end);
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


