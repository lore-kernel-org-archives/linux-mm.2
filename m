Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C41CC606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=i9hHr7YG
Received: by kanga.kvack.org (Postfix)
	id 8679A6B05B4; Fri,  6 Nov 2026 17:07:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 845D46B05B8; Fri,  6 Nov 2026 17:07:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77C226B05B7; Fri,  6 Nov 2026 17:07:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4C96B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:07:32 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CBC60120237
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:07:31 +0000 (UTC)
X-FDA: 85406081502.20.BAEBD02
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf07.hostedemail.com (Postfix) with ESMTP id 95DE640002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:07:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=i9hHr7YG;
	spf=pass (imf07.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794002849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OeQG5pSkuW0ZEeXokGWyNkXj2vkexyfhhiBRdLJ0eBw=;
	b=SmhLQE57EOKW1Vcv+s//a8YCfOAU4dQ+13YfEvAL96nPBSJ1bNSAOnR/6+ROlJjvGDesxc
	b68ShfJ97WroyUOUgA9nv0m1eTweYSdZMXZMtrprReS9LBqa1di5NsoeegKh0JzfUJJnEe
	kmM7TzbUuu/YP/Ltabbb5a2CzJMU+2M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=i9hHr7YG;
	spf=pass (imf07.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794002849;
	b=TPgiBi3Urpv0FHRO0zDJhRPGr4GA4g/lJoo+CMmP3/IpWhWoD5AKYLCAETOMMdUPeDCpAT
	Ikj8cmUyXpHZg8CmbQzOELUuto9GvHYIL4IRoEkH9X5SqcR7AqZY1QwsqYnaupXMJQnNoF
	5EP+m+HcYEq4SgvU1otViBzk6qqMgik=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794002849; x=1825538849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OeQG5pSkuW0ZEeXokGWyNkXj2vkexyfhhiBRdLJ0eBw=;
  b=i9hHr7YGEZcObRdtn6gKhvf48mFRr3jWC0cHVNmLfeahpn3iCeaH5NMw
   WeKCioNG60DOa00/BE2wPnnn/vffQvENycsivhr1CG0d70/wBwboL8uZZ
   PkzpScBI1+2Mi1t/V5EZ6vujBl+k3U1DE8Cp7s1+kg8ZiTK5zLo397cno
   4J1qMvTSnCrXPE12KpuU6WfieWUC++NoFFibio+opl5XqT0gPaOMpx45C
   +oR7Ue/nAnGhi5XoQhhof9ztH07x1jGukQnoSVuWLFm75uzMdSvBuvaii
   g5UdNsTzZ9Ko8YIdSYBDEv/2/SzDchwWj41Sd293Qq2ga7Lb4TbsL/CTo
   w==;
X-CSE-ConnectionGUID: 4NdU7nahRPmqjrDDI8SGTw==
X-CSE-MsgGUID: V1gix10PRwmzqyO4vSz7rA==
X-IronPort-AV: E=Sophos;i="6.27,199,1787011200"; 
   d="scan'208";a="33352253"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 22:07:28 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:30760]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.22.238:2525] with esmtp (Farcaster)
 id fbdc7cc1-f9cc-4242-bdf2-a4ee55ba2275; Fri, 6 Nov 2026 22:07:28 +0000 (UTC)
X-Farcaster-Flow-ID: fbdc7cc1-f9cc-4242-bdf2-a4ee55ba2275
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:07:27 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:07:27 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <sashal@kernel.org>, <linux-mm@kvack.org>, <david@kernel.org>, yangge
	<yangge1116@126.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song
	<21cnbao@gmail.com>, David Hildenbrand <david@redhat.com>, SeongJae Park
	<sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mark Bundschuh
	<mkbund@amazon.com>
Subject: [PATCH v2 6.1 1/2] mm: replace free hugepage folios after migration
Date: Fri, 6 Nov 2026 22:07:14 +0000
Message-ID: <20261106220715.2869940-2-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261106220715.2869940-1-mkbund@amazon.com>
References: <20261105070346.3099207-1-mkbund@amazon.com>
 <20261106220715.2869940-1-mkbund@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: igacg675fdc7woxrft8stw6atb8nmieu
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 95DE640002
X-HE-Tag: 1794002849-484864
X-HE-Meta: U2FsdGVkX19BWRCvHmY2gV2cPoSEhzgMvdi2If2RZF346wAMXxD71AbqnhbAUKoE164Hc5bdfRkxO0vXro+lxgqgtkmYe1UDBpzoJY+EYbyasoh7R2nXNxznLTo9e0256gQn9kK4S+31EA/wTSScrZXAJ470PE8urWSWSzHw8e1/tV9+wxRKQGxGf6u28VJtq78PHk4gtzxXoXtRL4lISNW+6jVYyD74Bd6ADoKhEdkAFIEs/veUS2RdE5y00mMCjICHIismoAIz7ADB1Kxx6eWKq2OGvKXjHXkA/U8ka/T8eqot1FQZ9qyS7nq+7owacDjLGyWzNtQ3erCIRFqpHV06r53D9gTu5pwhkFhc41oqSSw423qCfVR3mEFpoy9crExHlFnTWXAzr4Wucj+1GjCN0FvMarqWzjMkHKLQbxSbVQtbFf5vT36zjDN7fLCa4dSGiOQ1Z9KKrfd/5dnzBrkyfOzsqjnhcClnNEHqC27xPn+xlreBDl+QnHiEWqGXwpePHOY0YuQczhYr3I160DjG5oZ7xoII6WOfvH2qS348ejaQQjHjtrXioFIq8OVIc1CMRiXwsJ4S4OZpF4aw0GS8jT9nXWoC9IVCq7+96+3hvvhZVtca3n9Vr0KO3ixfnUAOVW0PSex4OACMnHegyAo3E/I2xrbytkW7OydBON2KjTwkD/BxHFBNkTVkp1ZAroTRfMWpsaDUD71WV2SaicloShaV8D/ngtk08PKKUcIIeoCef3E1JfarHqFiXol8PngQZMtIRph3Nsxd0yycnXrsk8cyX679FnxKD8g2o4xBWhgdl7c99EtW4bIqefcTdr2KQ+VTdILAzGNTWM3b10FqkIc+VkbxGHayc4lZtX/zJSFIXWOMmcvDv6E5S1R394lEKA0HgaPO1AR9QyJ20L4LgQ9bN6QV2bBqeevt7GZZgVEE/sGKVwrR2aKWHfzV4fSffKBgp/fDiIRInMf
 /k3dAmL8
 d/aE47rLQSnVAmO+RazifhXaIhw4GNqiVOFTQ1w+vYYfagIqDnvC6QWkkBfCS7fWje5aWrD/SK8BwwHqijD174Td8WNF8pK58AyerpAUhTJGz8HCPHONIzFdhKccf1W6WBPfjlJK8cr6BYnVF7GTZp68Ek3lEbJnABTA7T7IpmIZS6jYqXE19OObLXM0Tb0PpTHXXtQI5kp1k8TNzjmscbuLX8je01TETB6LM9kJ39JHSQpB1v+El+XmyIT41XfrFTvUhi55XRkHq6GF/dyZSAdpQySqU5I2TXy164sjNZ3wT4v14DPLGcepl5uX9gic5FXylsW8cYKf/wTT8VHi0hX/+tH6he4WPHBEp93ZQlOBnjYH61Y1v0dDsKZc/aoe0Lr4hOg+CK9K9F7aZvK8j9wQJ4dW5+0umBbiUd9oQ/Et/KUe792G8pJs1ms2bkJcEMKKvDzU0VMCcg9MIWBFT7LtSKxlFtqGMaQ3HXIdPJ/hjLtcw9pR0S83bOBEoloeHEWm6tTUHuyB0WzgW0tnirVEjlsbewa0MzZLpH30yeFPbEgETG2+zLPXS0yyR0bDfndQyssuapeH1+bidFXb2cWbYyEDeJUi65NieXmZmjjKhVONleB4Iniwx+jjTN0qIQ1XaA/ZBJOHLDxKZ1Vg2wVnbPooGmdN5vdYA+2ivPWOEsA6ZnvVELILSzo6fi0WAmcPql2ZApROYVkMfMqMZnbOR4VPxp/A+3NqU6lFEST6wabmBku5psDBMIXQ5Dhf3wQfXrgPwaZz4uOvWzYv/jZPUvFAMcAzDbFzCw/REdU/lM/fFcfMjMDPuiGjIWWH++QWA7QTDZk6xVLA1Bm/76t/NCgwUP14lrmNPm5ygMTc1819PJpOwUnCOfgoFcL1YzamFsZOyFhh+NXJsexDhRtDI0TygrhUyJp4I
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
[ 6.1: dequeue_huge_page_node_exact() and alloc_and_dissolve_huge_page()
  take pages here. ]
Signed-off-by: Mark Bundschuh <mkbund@amazon.com>
---
 include/linux/hugetlb.h |  7 +++++++
 mm/hugetlb.c            | 42 +++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c         | 12 +++++++++++-
 3 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 6b78a0f457d9..13606ab7d0ce 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -728,6 +728,7 @@ struct huge_bootmem_page {
 };
 
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
+int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 struct page *alloc_huge_page(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
 struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
@@ -1044,6 +1045,12 @@ static inline int isolate_or_dissolve_huge_page(struct page *page,
 	return -ENOMEM;
 }
 
+static inline int replace_free_hugepage_folios(unsigned long start_pfn,
+		unsigned long end_pfn)
+{
+	return 0;
+}
+
 static inline struct page *alloc_huge_page(struct vm_area_struct *vma,
 					   unsigned long addr,
 					   int avoid_reserve)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f549adc0b670..46031ca5a7fb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -46,6 +46,7 @@
 #include <linux/page_owner.h>
 #include "internal.h"
 #include "hugetlb_vmemmap.h"
+#include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
@@ -1343,6 +1344,9 @@ static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
 		if (PageHWPoison(page))
 			continue;
 
+		if (is_migrate_isolate_page(page))
+			continue;
+
 		list_move(&page->lru, &h->hugepage_activelist);
 		set_page_refcounted(page);
 		ClearHPageFreed(page);
@@ -3073,6 +3077,44 @@ int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list)
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
+			ret = alloc_and_dissolve_huge_page(h, &folio->page,
+							   &isolate_list);
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
 struct page *alloc_huge_page(struct vm_area_struct *vma,
 				    unsigned long addr, int avoid_reserve)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 85b189bcab7e..0004df47713d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -9329,7 +9329,17 @@ int alloc_contig_range(unsigned long start, unsigned long end,
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


