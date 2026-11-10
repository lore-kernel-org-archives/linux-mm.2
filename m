Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F22606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=Si6bVFwJ
Received: by kanga.kvack.org (Postfix)
	id 2FA816B05C1; Tue, 10 Nov 2026 17:01:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CEA16B05C2; Tue, 10 Nov 2026 17:01:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E72F6B05C3; Tue, 10 Nov 2026 17:01:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D855B6B05C1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:01:26 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6ACD71A0143
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:01:26 +0000 (UTC)
X-FDA: 85420581372.21.A4E660A
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf09.hostedemail.com (Postfix) with ESMTP id 35DEC140009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:01:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Si6bVFwJ;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf09.hostedemail.com: domain of "prvs=767c605bb=mkbund@amazon.com" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=767c605bb=mkbund@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794348084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fsSeCyyxxTUbCaalKAGDKE0ZpmnzMT58aaVvQO6FbxE=;
	b=Pf71RsFHAAKT/aJ8FfvUKm1QSzL75Km7EUAWS+bfEHPKP3jXjU2nEKp5qFbUqHfhr2bTPE
	Mbt8Bh0XzhNh95xMEgqgB0T5dhCyIcOjpACsWEioiMqdO0+QaU+GP+XMfy4/Asxx/n6Kud
	VXje5ZojIer+goIenUQg8UCuqzX95Ls=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794348084;
	b=7arFjruRjNClR6GnmCc/gwPhul58vyJyifFv6wyuATstIqQ5s8Hya4ShE2kFJDFCw3PZZw
	aJQW/B2tZQ1iUJN5VFjYXpG5XkOB6MMYlveRVzb6y8ldO00zPS+JaAgeuCY/Mi0YFWrMmp
	UfynIq4ul5EbP3eX99zD9gMVgpSIrrw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Si6bVFwJ;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf09.hostedemail.com: domain of "prvs=767c605bb=mkbund@amazon.com" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=767c605bb=mkbund@amazon.com"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794348084; x=1825884084;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fsSeCyyxxTUbCaalKAGDKE0ZpmnzMT58aaVvQO6FbxE=;
  b=Si6bVFwJ8OFsPnC/PKLaalwokMobagWCTVHb3azALcqwm2R8tfx1TZjQ
   LHM7kJBUCPSOSkLmfVjqNyUTS84qt4Sc/alKA51inXHPoRLutgMjJpswd
   nLL8yAPck+M5IFOHx/pbxn0CUOfeZ3m5Y0w55rOT8nbdrCKulGsODP0KL
   d0Fu5oSn1OUzPcz0elcnYfrgLBtMBSEfMYScsWQbSp+r+hSqACWayhbSf
   BUkAvgu8g6gKSHhkF7vp2+IXFgMie0aXmaQCWyZgygzgtWV1g3msIPyie
   398/wnLh3vjFd+om0Js0ppgrKHLqRp8gtgX6/T10hKBMav2UO06RRyV0k
   w==;
X-CSE-ConnectionGUID: qI3YSMVbTvC5qJu2zmJaEw==
X-CSE-MsgGUID: hh/LpjLXTpq9xE5Z8g9DKA==
X-IronPort-AV: E=Sophos;i="6.27,206,1787011200"; 
   d="scan'208";a="33528165"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 22:01:22 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:7503]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.231:2525] with esmtp (Farcaster)
 id 88fd72c9-b740-4869-b582-78f97e99861d; Tue, 10 Nov 2026 22:01:22 +0000 (UTC)
X-Farcaster-Flow-ID: 88fd72c9-b740-4869-b582-78f97e99861d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 10 Nov 2026 22:01:22 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 10 Nov 2026 22:01:22 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <sashal@kernel.org>, <linux-mm@kvack.org>, <david@kernel.org>, yangge
	<yangge1116@126.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song
	<21cnbao@gmail.com>, David Hildenbrand <david@redhat.com>, SeongJae Park
	<sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mark Bundschuh
	<mkbund@amazon.com>
Subject: [PATCH v3 6.12 1/2] mm: replace free hugepage folios after migration
Date: Tue, 10 Nov 2026 22:00:05 +0000
Message-ID: <20261110220006.3259056-2-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261110220006.3259056-1-mkbund@amazon.com>
References: <2026-11-08-1-daily-reply-0005-hugetlb-6-12-v3@kernel.org>
 <20261110220006.3259056-1-mkbund@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: 5pznmh3kb5s4h4pqfxtfemke7jefaudd
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 35DEC140009
X-HE-Tag: 1794348083-980788
X-HE-Meta: U2FsdGVkX19A2JFKjsMbCGEW6qrIsddQPoL4IY2nSi+C8KmWMhdvlleE/O4hrstDaXnHq7xE2cXBTlRej4D7JJnaoiJ3TLUAVVzhjHbMNa52NRmXAsUnY/HWUne0oMhdLkQtLz8aCD4tlzGXHAeAqTV5ekpLgjrDjKO/lWomUPk35yxRBh62QyQcMMR6X+/I6eC92Lr3OIb5bK3qwM0l9YDHYpzGTCeZqwHU9ciercsQByXWhW/NcGmUQbhk4HdooxlYYaZQYyOW6Y/UtEF74O6CB3kbyvGYUOb8CMetBoFLHiZUBpDPxuWCVbJWvTsIvuwdNYNlhkoUgNDt4aqYu6A72N+0uYiWrQLJ6m8xmfl04OeUplYMMPfHiPtgLsJtp+MRP0gdLrdHxWpnoF1sNJSJ1DYPhaf3brtlCYoP61UyS9G7tDzwY/5tkEgp1kbe4jI8b10jmmO4Eve7KBfXyolJKrriMEOC9VzIXXNmAwIu/s5VKtJ0zrLFOxFZ5bKgybuW2dirNwONifc8H6xh2F8wIvAiZJEH2i48nemrMVrmOLRtpSoltJ+tS7k58JcJ+b+XcMxAc5x3li7tIijQBgBNmPKiMfn/rfJL3oRsHhGfUyrheDABqCmHyFCF+mZyrTlS7+u4rKKPpZ3J6wC7/FhlStJgUzenQJpTk4iA1o+OOSG9fN11EXQhndAjm+EFJx0a8cE3xlLVj3205dYCKkc1AXMxGvAr8heUwhF/Zle3xlmM5ZPpnNh64PnCyTWYXmBgBXwSSidM2ZwfkEuOtcTuTHELotYAMMDobguJfvpE6So66e8SrtIxMIMaC2o4BikuTzySzq5zuVNb03IAtLkUkBGCRhybL2VFmGZqbbNrCGEhJyi/2moNc+ei6F8hr4xhLvrXvO/SudcFsG7CYro4bvyQYZpZQythOSRNs+ixeskTxeHZ0Xp5qv0UmPv8EQpbiYsXXdWXSbFOye1
 p91U0lYn
 ulH/I0UD7+ewhGXs5jV4t02aUqEvhos8ywW9ITc7x4GnRV+jhG9o/cJL6LKlDiKthz6WYKBkoQLCTplGD9IxGp7QQgUdsopmKsD9w5TvDu0SGOrLHNtspoj2Esga0+wQaf8to/Y9fPOiAQbGpb56VQjFcHlVmDfUR39ae4zohdLqy0DlCuSq269kpaOwpMlqQ4btNuQG5JG/qReOlecdNxqPa1ruINYr+U3/TQtfbIAtaPX4fw8K9lZIc/tRrjS9MIqGfDEtP4/E29t4X8IhZIVMEibWliJZF6Q5CFklVs1e3/L5FIZf35kmVyVcpgY/sgAJKpiDCAsDPg5WW1+wzGWFC2sK+OwwlLLDI1ujLdGjLJ0ld2hCz3h94SMetxJ5l4zWDsB9V2o/szUbMkRegofB5sHMjjo/T3w+EIO610Njzqn4LhGvCYhEDM1OLKs8i9385/7CDzomtLmh5PsRcpdyQYtNP2lSX/XXD30Ix/zAm7Rb5A/5qdSw3u/elNKT24fNwfh8uendwGgjE7b2NVe+UgHYDHEsDQPYc4OQZh5RQqn7E3FJ3EaJcXjJO8f9Fo7huqE/QWpSfPuWh3NkmAeP438QJGEDJ5HfYjQQ8kvdVMAMavwtZh+Ea+kFjN0U6LUfq8lCCCschAT1GN1iq88TGkcFJmv+qDOTrxpiCE3AW4ZaRNgzoaVd+Kesl848uRi6xcHRu9HT4WiAnXi8hpv9sBYZIHnYIdgx/p+KiTaJFyf2vJ4efA3XZcQVAt53I81/kglRQ21Iy1wQjQElI1CPfKLwSHme8Po8pWAfeImX87tbbkrznbzYSRfOU1J1owHhKuKKK8SCVf9CgaufPTk6FW0L9gaYaCGslr9bCWneCwureJQf0xwhZCVo6i8WJIm+JV1gih+Su15jXvj94FQWSFg==
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
index 69bc41be9be9..96a201151a80 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -687,6 +687,7 @@ struct huge_bootmem_page {
 
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
 void wait_for_freed_hugetlb_folios(void);
+int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, bool cow_from_owner);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
@@ -1078,6 +1079,12 @@ static inline void wait_for_freed_hugetlb_folios(void)
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
 					   bool cow_from_owner)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d9443bdebc06..929ea7dbd900 100644
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
 /*
  * NOTE! "cow_from_owner" represents a very hacky usage only used in CoW
  * faults of hugetlb private mappings on top of a non-page-cache folio (in
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 480579d7d59e..063c2a359a1e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6743,7 +6743,17 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
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


