Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA859606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=llvvY6XE
Received: by kanga.kvack.org (Postfix)
	id B70FD6B05B3; Fri,  6 Nov 2026 17:05:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B213A6B05B5; Fri,  6 Nov 2026 17:05:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A36A66B05B6; Fri,  6 Nov 2026 17:05:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 623266B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:05:09 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DEC6314022E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:05:08 +0000 (UTC)
X-FDA: 85406075496.08.FEF6875
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id B2A594000D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:05:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=llvvY6XE;
	spf=pass (imf01.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794002707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jLp9AuXjgqxRZhgPwcfDJfELPveLqaNA4IiqWOgkYr4=;
	b=ZFWIcchhji3q47ReMyT4V3VXKF+k0qhI/4UVX6NKurau1ORo+5/2z/DQwL7BT8Fzg44g7+
	kHDVacvqYe8Lh/A19HVo+SXpNBDsEOpfvwfwPl668zuO9WeVvpTnvTXz/pEVOXZ7Z6xb3b
	87zXw57OTNWqGA3pWuOuxa5aEEN0vtM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794002707;
	b=Am3d+K/SPYY/nh2iyzOT44mJBlNdfg+83OcBp71+nVMZWpisbsGBpkjLXDrktOpUP0yShg
	+AkmN6OfuXnGunc4dUwz5kGiuM0R+Jc/uOGZ8qoW2NwJqQlEt6nIvRlX8uG672vh6lnRAm
	ERKawGk66gZ/M64r2mVcuK18pYMQoYg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=llvvY6XE;
	spf=pass (imf01.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794002706; x=1825538706;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jLp9AuXjgqxRZhgPwcfDJfELPveLqaNA4IiqWOgkYr4=;
  b=llvvY6XEXddGrX4Fi5+BeaNLXwjpwf7cOK3zCqlOjcvtb93AxmUcZL+z
   PfeCLzV/TobOjVAqKczVghJTdFXsYWrZtBdonFgF/qGDLgv+sPL+9CmUC
   D3THdU1L640aw+GCX6vXhBn2LWKu0VojCW3xo4//5fT4Pg3kT9NykCavz
   KmB9ISelaPwFnlqyes+98SQ57zm9qXMWzjvc18H7hBNZzIDwGcMrlM4up
   ZhT07h49JLKoJ/A/M5JLhlyBcKOm/U/evRV7z2X3KuVIkEzH+cmd6cR2g
   fpsEgCinoPDceqmdBIHHNOASJ0e8Ok4SOTKAgeXIBZVGWvaybez7KS+xo
   A==;
X-CSE-ConnectionGUID: yuH3+GLySXeuSOcxK43LxQ==
X-CSE-MsgGUID: Ed+EOpX5RpCekQrvmMg//g==
X-IronPort-AV: E=Sophos;i="6.27,199,1787011200"; 
   d="scan'208";a="33123737"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 22:05:05 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:22364]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.18.155:2525] with esmtp (Farcaster)
 id 1d2eed97-f251-491e-b9c2-3b2e2d645c1f; Fri, 6 Nov 2026 22:05:04 +0000 (UTC)
X-Farcaster-Flow-ID: 1d2eed97-f251-491e-b9c2-3b2e2d645c1f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:05:04 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:05:04 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <sashal@kernel.org>, <linux-mm@kvack.org>, <david@kernel.org>, yangge
	<yangge1116@126.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song
	<21cnbao@gmail.com>, David Hildenbrand <david@redhat.com>, SeongJae Park
	<sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mark Bundschuh
	<mkbund@amazon.com>
Subject: [PATCH v2 5.15 1/2] mm: replace free hugepage folios after migration
Date: Fri, 6 Nov 2026 22:04:43 +0000
Message-ID: <20261106220445.2859944-2-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261106220445.2859944-1-mkbund@amazon.com>
References: <20261105070206.3094675-1-mkbund@amazon.com>
 <20261106220445.2859944-1-mkbund@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: ox8x6jk5pcg1b59znqbug8e1bkedz8um
X-Rspamd-Queue-Id: B2A594000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794002706-220864
X-HE-Meta: U2FsdGVkX1/1FMOKDCaZWD7zAG2yKx5voUsup9ZlNrwYGqic1gcVJChjTKeFY7cfSo/JhI3VJ8nczUkxnbfB5agWcbG3fJCut4dRa5gZybLICsyALj7jHtXVApb/zPaa1yicL5KpCFho2+/pVb5ESyB3jTCVm0HXXhHEKPo17CM91FBOJ8ur3iB3pReBVjVHIqizJ0PY9QYtjZfzVVpZ11aBTnzoTkmXj1xfouB1zrv4SB9u/qQGZU56cDpwb1QFQrPSL3F7DGMtpnh2vtRJJHkGzJP3b1zdPfpTEqIW75Ta0MpjrGYWdsHUq69eeke6BFpF/1nRjxFvSbPRVZH9RrhrDyL1VMKdbz0ZDZpQLfuYF5YoLGBOhMAqe2YUr8R/frYlJdkSHw42kmfaEXsn2hofGV3mFVCp7T2Iu3PksLBhp7RBytZQrsr8feJSozcMWatiOKDdZTWIUHSSjsnG3n9uSO2Jhs591FrqYXcCfepyYtgrM/Kk6zdLLNh6s+pz8wbzoPyGRctGdLnfIBzUFaHb+OYIMdsKelbt8z2HLFGsAXXmXTCBs/0BUjiv/56q55oGyb5UoZV4w7PiatmI7J90RpRj+ZR+/9BgSr9y0JqJWHumg5KR5l+YDp584n+7wbJZ+Yi8fZSrB6qTW3JJS/ED9Jb4kWcdIprCeSJxEsUwPq7L5guW8z0sUWftThjHoH+hWEmD1hNx8kz0RVQQZCkZxsC/8DZ/mrxIL4mwy6mOh/nyhHrAIkFG34NEkCUqm0lGCiQ6OlwJQFNZrq3RGFl6bxk/RwFWiqtHETtJBp0WHpJcD6jH4dIqXpeuhTc9YQErkWi4v3qRhmzF2qgINPLtHP7YXKUqDXzkp1fy8WukRyQQ+WblYDKRC6e9YZouO6/7BBEb3zi4cEBuS5LVPhPloG9ecXGUynG9pt9Za2SDeXcjNyXdeaNBc1yOqNeAh9+gLUz/iN2vU7+TTKJ
 FJh+gEQx
 UgWRinTtXDSX79dUeYxdt+mCx1esb8SkDKyR+Yvdq3AHcUbFeqEQ8RlLireKVZuGuCeST/r/mAudi4yENRsSCrPN6Svwd7q19XZj1iFHuWY7f3qaJDdHM9/m5904nTegRnBWypryQcNXHZTftmQEkH0AKCRej1wXcal8L2XPlZBeuWIsrPzQeIu2nLx6SIH+on6qc8Y8N/9yZeuVHCf8CXdFdKMfIJgD5AHjcvegGHTh470WP3cDRTwJxMdgw63KrH3mjO/SJ1+0C2VI+VHjVglfTidFYyd6CZtk7KuBQO7EmRMNeBn6CtsDYSLBGLPmZxM73AfdGVJ0dZiTzk3aOMQRdt8ksvEshRoxbcqE6BFhtvbyEuDdZ5puePfV44ECjVngaaHjqO03pMnhfgH6io/nOe8fA10lJNxHDy3aC+aTXa7uOhe6GZMEo2gBS5aRpxY3QfQbtDCrTCsKwx2OKQHWHin0fcSYrLqHPINF0Ui6hnIx8DF+1p1D5qWBQOf7REROiYGnhkWQDh4t5YCXO3FLHtR6gPgO9JtvCJY0kZiRhbQJCdsvqSoQCcw/MzXvNhAFdjhTH4LJWtjUNHTuVwZ1h+vbjsgrRlnAffLxIWXOG/3SosUYLfOEzQRdAiCiu+kvkUIKFSTi3NR1l1zJ7gDOhhOPyCtngNnxzZeE7W7lb6kBKXUq2I6xpMWMLkTk2u+y0iwAZNgHCNbD1HkKIl3L08P2evDFME1t2RWB7JOKY6IZ0xwRqj/BK55CLaa0Ec2RHexBS1Y/OX6oIXXsEh0L3x4U/wmlSQfgD5ujRGNVoKDseLQ4TPTdjYh6HoxGOkHXzSp9Hpl0NAWJR7KEXq2ejiIlQ7Q3wF+BXW3gEldWIAUdMFxyyRmq9Ly/bZYxkEknuMlr9Fd8YS15KDSkOxD3ZvH5o8uDzeN3e
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
[ 5.15: Use pages instead of folios. ]
Signed-off-by: Mark Bundschuh <mkbund@amazon.com>
---
 include/linux/hugetlb.h |  7 +++++++
 mm/hugetlb.c            | 41 +++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c         | 12 +++++++++++-
 3 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 254fcd6f9604..e4b6aa016d30 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -641,6 +641,7 @@ struct huge_bootmem_page {
 };
 
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
+int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 struct page *alloc_huge_page(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
 struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
@@ -933,6 +934,12 @@ static inline int isolate_or_dissolve_huge_page(struct page *page,
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
index 947610e37a33..4fb98320f9df 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -43,6 +43,7 @@
 #include <linux/page_owner.h>
 #include "internal.h"
 #include "hugetlb_vmemmap.h"
+#include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
@@ -1095,6 +1096,9 @@ static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
 		if (PageHWPoison(page))
 			continue;
 
+		if (is_migrate_isolate_page(page))
+			continue;
+
 		list_move(&page->lru, &h->hugepage_activelist);
 		set_page_refcounted(page);
 		ClearHPageFreed(page);
@@ -2735,6 +2739,43 @@ int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list)
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
+	struct page *page;
+	int ret = 0;
+
+	LIST_HEAD(isolate_list);
+
+	while (start_pfn < end_pfn) {
+		page = compound_head(pfn_to_page(start_pfn));
+		if (PageHuge(page)) {
+			h = page_hstate(page);
+		} else {
+			start_pfn++;
+			continue;
+		}
+
+		if (!page_count(page)) {
+			ret = alloc_and_dissolve_huge_page(h, page, &isolate_list);
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
index cfbfd6309c25..b813570d2b39 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -9250,7 +9250,17 @@ int alloc_contig_range(unsigned long start, unsigned long end,
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
 	 * Pages from [start, end) are within a MAX_ORDER_NR_PAGES
-- 
2.50.1


