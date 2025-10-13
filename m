Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03025CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23C118E003A; Mon, 13 Oct 2025 08:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6548E0037; Mon, 13 Oct 2025 08:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F338F8E003A; Mon, 13 Oct 2025 08:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC85A8E0037
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:21:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A6ABF87487
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:21:30 +0000 (UTC)
X-FDA: 83993001540.08.EC1EF91
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4CE3AC000C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:21:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4IdPha4j;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760358089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1EU4o8NGrRDtHWDSNR3c0djnaDNLf+94hqH247VY/7E=;
	b=ZQmu1gLAWeGARfuzgEeSPM96l6yb1C530y/qCXff6LIWelJBR9JAe8rlkt4CC/UT4IFbDx
	DaK9d32oFFac65M+JVjRXNuKuVjfdQOXaq2g/wmTvRhs1w7pIne2kw960oUTOk/Be85CMv
	kNnHHI9/9kPr5C8Xsc1SUMN2HjcuAbI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4IdPha4j;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760358089; a=rsa-sha256;
	cv=none;
	b=Xg6wi9BH9nYyeA7QADnqI7EcRMU+eGSp9MNdhv2U0MorouuKwRwUC4pvsIXWmksjkIC3H+
	yyvDWDGaocn/sZOW/4JToBj3d9gR6alCAdleLSHkBymvrosgNkn3QI9i49lD3QLvKN4jHg
	MyJ+R+mjBUfXx/gJkMuj2rnN42OFzGU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1EU4o8NGrRDtHWDSNR3c0djnaDNLf+94hqH247VY/7E=;
	b=4IdPha4jA6Twqdzq07CvvplaiiJqRHPdQIsUvMHKJHZ5ilnlunIIA7DOSMrQIXtkSzjhkUF0u
	Rymt6T/1jWvliSJLt50yKzZWFk+ptJwX+woABq4ZyKV88cVv2wBx8OTucsygPWbi4rQKsFhW3cu
	+tPH8diCBuzO0OyrC2zsDU8=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4clbzg2S5kzRhVY;
	Mon, 13 Oct 2025 20:21:03 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 9FAFF180489;
	Mon, 13 Oct 2025 20:21:22 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Oct 2025 20:21:21 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 3/3] mm: huge_memory: use prot_numa_skip() for pmd folio
Date: Mon, 13 Oct 2025 20:15:36 +0800
Message-ID: <20251013121536.2373249-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
References: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 4CE3AC000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9o8akni1pu461ezwzt9wsra8x8pyiakh
X-HE-Tag: 1760358087-542680
X-HE-Meta: U2FsdGVkX197iNYbp2DwGwR/QJnBxQ9cZMtgSjrWNnO96drzL0k4TsrppMb7RtVHucgkD1arWoqaKi/+XQVCJtsF7t5Qi+8liqy9rysPA4fubrE2L9ZK5aZUW2BUi/S1sg3OIm9SZ9t8wpEc81qJYlpnGRbxLH3ISJmLbzyMRPnksJ4ZrJCPpMi6Mc7kuaOHHg71ZqlNp4frsNN/9b3ZjKd56N2OmtHupVIZ7NaEd7r0C5fAZgj+KO+1BC1AjmQSKSJfQHmPlt41mkYStEym70vGLbZt7LRjSK2Z1YgfawH6LkOFkVwNpb9IFP5vLodhONfFsDziu9KQyHece00PT54WFuYujt35XobrVZcT6TjXsGt2PoIH37HMb0ucojPEoS/BLb7KxAqch+rNo21OMMtSMPMBr8UNj4RiCVP7Neul/+ATHYQHchlXMNnbVjB9yns7RalFFyits67v3fCCFYjo2kzcF9egmwlWCu53rqRStw/y9DeffKW+QvnUHQWJe+fEzlpDWsuDQ4+0vb8Gndh+tAulcxDx2DExR2Xua8576vDj2Nvrtk7YWZoUw+oTZzmByVMgbG/mzv/pErC3rz+v1tBUulaoi1s5tUXczNh7j/bcX1fRlkSliA3xQyIc8Ll7a5nx3PI2ogMhSWDxjBZqA9s03/dJvOOUbsnvVvw+cfXlzT/xu7rV3dcD2AnbsfjFz/XLvxhiQWCoW5O22+4vts6Hh4Nua8DXPrNXQWldu80d+lPNnXaIw6rLS3vKWDUXVpPxTopLkx/BsEHg5khotNPRLB+4DZDPcG2DO+eLJmc4LuW0B6Y5VJpfjZBd6wD8pXY6a5Y+HEflOUDdx8709Qmhw891/UEQR+2/SSTbdS7wqlGv6GUKEj55O/n35i3VFNWPFaytbuyDHUs1lAYiJsDMmIgBMe6CrRijlH/INh8XMvm7Y2sdb9D+0aNw1PDdGN0fvQeYbWV0V9d
 ZuLWfrS4
 zIr4Rl7DSYqDTKm3Oq1HKsS/YraJLu7tNupH8UJHkY31laM0DzIoRODYNP3XcNQx9jG50AFmGyHtK3HU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The prot_numa_skip() checks should be suitable for pmd folio too,
which helps to avoid unnecessary pmd change and folio migration
attempts.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/huge_memory.c | 21 +++++++--------------
 mm/internal.h    |  2 ++
 mm/mprotect.c    |  2 +-
 3 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1b81680b4225..feca5a19104a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2395,8 +2395,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 #endif
 
 	if (prot_numa) {
-		struct folio *folio;
-		bool toptier;
+		int target_node = NUMA_NO_NODE;
 		/*
 		 * Avoid trapping faults against the zero page. The read-only
 		 * data is likely to be read-cached on the local CPU and
@@ -2408,19 +2407,13 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (pmd_protnone(*pmd))
 			goto unlock;
 
-		folio = pmd_folio(*pmd);
-		toptier = node_is_toptier(folio_nid(folio));
-		/*
-		 * Skip scanning top tier node if normal numa
-		 * balancing is disabled
-		 */
-		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
-		    toptier)
-			goto unlock;
+		/* Get target node for single threaded private VMAs */
+		if (!(vma->vm_flags & VM_SHARED) &&
+		    atomic_read(&vma->vm_mm->mm_users) == 1)
+			target_node = numa_node_id();
 
-		if (folio_use_access_time(folio))
-			folio_xchg_access_time(folio,
-					       jiffies_to_msecs(jiffies));
+		if (prot_numa_skip(vma, target_node, pmd_folio(*pmd)))
+			goto unlock;
 	}
 	/*
 	 * In case prot_numa, we are under mmap_read_lock(mm). It's critical
diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..65148cb98b9c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1378,6 +1378,8 @@ void vunmap_range_noflush(unsigned long start, unsigned long end);
 
 void __vunmap_range_noflush(unsigned long start, unsigned long end);
 
+bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
+		struct folio *folio);
 int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
 		      unsigned long addr, int *flags, bool writable,
 		      int *last_cpupid);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 0f31c09c1726..026e7c7fa111 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -118,7 +118,7 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
 	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
 }
 
-static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
+bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
 		struct folio *folio)
 {
 	bool ret = true;
-- 
2.43.0


