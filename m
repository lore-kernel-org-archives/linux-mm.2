Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76A2BCCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 12:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3538E0008; Wed, 15 Oct 2025 08:35:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7CFC8E0020; Wed, 15 Oct 2025 08:35:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 958378E0008; Wed, 15 Oct 2025 08:35:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 764698E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:35:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 34D08C012C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:35:31 +0000 (UTC)
X-FDA: 84000294462.27.47FA856
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf09.hostedemail.com (Postfix) with ESMTP id AE66E14000B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:35:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=sSPHofTR;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760531729; a=rsa-sha256;
	cv=none;
	b=lEz4q3xjVWk/zHUeKh3j10mrL17ZROr0iVBoX2XrfE9gp18ctTKi3kkX+DlrYm3h7J0uZD
	f8RwFOAGo2o5Atrli1KPBUosRqpbHApFUf7M5UvNSDAZeDKgQ3FiM4IxZCSJI8nXlwUORr
	f9wxyUblOI+wDa0eFKZJvzuv6yk0+0Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=sSPHofTR;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760531729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bZkMHk8vSyjdT9ATUyMsYZvO7Wy4fl8dta7kIVnpE8k=;
	b=g8NGkQru7OBJ6NwbdmIBab9n03ggUEq8tJ6s4vHVXjHD6otB4tnnx7bWiYw3KUhTPMBC0o
	GBxRA7rITL/BnHePkYlNthyfY8bYx23fZZEf90oCYFHB+iutfoGz7/k3aoPI6HUtKpxwt/
	+XjDJPV+3PrUT/tuKR+E+IA/K/DP35c=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bZkMHk8vSyjdT9ATUyMsYZvO7Wy4fl8dta7kIVnpE8k=;
	b=sSPHofTRb3IF/CJ+P6iwc0dW4Aay9K124c63sJ0ut9sqLCOfBRXYhGbV9mfaI/Clb58EtwC0Y
	wjK5l2rHEePLEDHwfDL9zVH67ViNoCh12Bye0lRrdxkVqMuEhapQ3chB93bIhGZOmw8040VJN+Q
	Ni7uIp5kz5uocyJKYM7ooBU=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4cmrBw44R3zmV6g;
	Wed, 15 Oct 2025 20:35:04 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id E2A0A1400CA;
	Wed, 15 Oct 2025 20:35:24 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Oct 2025 20:35:24 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: [PATCH v3 3/3] mm: huge_memory: use folio_needs_prot_numa() for pmd folio
Date: Wed, 15 Oct 2025 20:35:16 +0800
Message-ID: <20251015123516.2703660-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Stat-Signature: h61j7ye3nrwpy7kf8wusnqujhcicku9r
X-Rspamd-Queue-Id: AE66E14000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1760531728-488113
X-HE-Meta: U2FsdGVkX18rSwBooK2Z9ozzhvgPuJVROoX4t7bj+o+A3isDbFAHigOJrdr/IbCe8VfKo53Cnk4ryr0uwtPceti9WVEijTZdzl+B6BQqxXkeM9g43YfkI5M8GONx1s8/XH9LerELm4OE+NcICuUkvJl1YhNcrNGuFV0HH7tn5CuM26EqLlGUwViRTgGivnI2DsV+XYBPwe3NlTAg7w39pCUjA9CmG820hfptVgcsMR6qv/PHRpIkLCsOVvMd6kkKa7fpCkW/cVApvLW/5sTx152f7knooUIlR656sdJXK58GHCLVs7asLGBDgJvByVv5cxdoSlbYdv0cxUpjQ4ro2/ig130qO6NwGdvvHPwwEkcbj96mnP0AB4ehwUbo28pdi0CTgJsWXKAwy4Rf/BDTnXlw5EWq6jPs4hyZ3zJW8i1ZINrdGbcH2uCngXCsfIbaYmGilJHLibX64xSmQ8E5+7ydm2KEPKN+spZ80c1JN8l5zoRiEmH/1iW3y92VxOpRQGsIPG7g6GgMLydVg9m/zJKNdLJqWfJQSs2ueaV8AVIKA5UY7frrRAp4FdYaOImQMJwO+vNWNNWwaazNatKYvUIuV0IomgGFXpZ1fYCxBbJSDKzOeIYaZwvC0M4NzPd3k8grfErlmU6J78uo/W9MjSM/q+xjEUL6D11K5K1In0Q+brUg4825c/kha1lNyeRyGtLXwKhOMDnQc5FBfF221+pHUrl2iaI6tRrXhAaEDLsGf8+eWyDK+ILbVFmhSoj8JqVBNSC5PFOpUMyX8dR2ofagIWQn61aNDmvFBdk3SWO0WJq/X1fE2YDd/r3MOdbTEwkWrpo0lq+YpAtqsYVusc6droi75MNmEV6q1D6Cg4Q7iGBXS7KoRyjSTlJqqox15z8tWWKhRULk20HewHUurvh5E+NNiNgjHrZEaCvYpa/Dl8iQamKW34XQo7jGAD0u1JduQYTEIA2625K/bVg
 KexLOPJ/
 obQahi8A6fiZuRR0oW+RGpaLWacIvTgpZGFpdDrIZOFBSZx2XtILU6R3zkRrAkBBY23MX1hhnFvHzYAVbY7f5Wg1cKZgF1kXtTIrv4K/fJPD/eqsuUCLuLh+ijWftDPyVb8mN50h0kTujdzlDFlWYNLFhKvZpttfnxl1J+BWWsM5rL+b79+u6CAYzwJRJA9csO7N7na1dteHUil/LTZMJXv/7xDsIl4e6xYlozj6aFr8HGQJq7QDK/sHHqDm39e5QBLiKxC33Pn8ZpfM/7lsNUrNC4egtcLAoBKfkbebJ+wE+AXJ0BYljt5PGIViqRtzSljQ0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename prot_numa_skip() to folio_needs_prot_numa(), and remove
ret by directly return value instead of goto style.

The folio checks for prot numa should be suitable for pmd folio
too, which helps to avoid unnecessary pmd change and folio
migration attempts.

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/huge_memory.c | 21 +++++++--------------
 mm/internal.h    |  2 ++
 mm/mprotect.c    | 45 +++++++++++++++++++++++----------------------
 3 files changed, 32 insertions(+), 36 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1d1b74950332..c7364dcb96c1 100644
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
+		if (!folio_needs_prot_numa(pmd_folio(*pmd), vma, target_node))
+			goto unlock;
 	}
 	/*
 	 * In case prot_numa, we are under mmap_read_lock(mm). It's critical
diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..5f63d5c049b1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1378,6 +1378,8 @@ void vunmap_range_noflush(unsigned long start, unsigned long end);
 
 void __vunmap_range_noflush(unsigned long start, unsigned long end);
 
+bool folio_needs_prot_numa(struct folio *folio, struct vm_area_struct *vma,
+		int target_node);
 int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
 		      unsigned long addr, int *flags, bool writable,
 		      int *last_cpupid);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index ed44aadb7aaa..0ae8f4a277b2 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -118,26 +118,30 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
 	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
 }
 
-static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
-		struct folio *folio)
+/**
+ * folio_needs_prot_numa() - Whether the folio needs prot numa
+ * @folio: The folio.
+ * @vma: The VMA mapping.
+ * @target_node: The numa node being accessed.
+ *
+ * Return: Returns true if folio needs prot numa and the access time of
+ *	   folio is adjusted. Returns false otherwise.
+ */
+bool folio_needs_prot_numa(struct folio *folio, struct vm_area_struct *vma,
+		int target_node)
 {
-	bool ret = true;
-	bool toptier;
 	int nid;
 
-	if (!folio)
-		goto skip;
-
-	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
-		goto skip;
+	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
+		return false;
 
 	/* Also skip shared copy-on-write folios */
 	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
-		goto skip;
+		return false;
 
 	/* Folios are pinned and can't be migrated */
 	if (folio_maybe_dma_pinned(folio))
-		goto skip;
+		return false;
 
 	/*
 	 * While migration can move some dirty pages,
@@ -145,7 +149,7 @@ static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
 	 * context.
 	 */
 	if (folio_is_file_lru(folio) && folio_test_dirty(folio))
-		goto skip;
+		return false;
 
 	/*
 	 * Don't mess with PTEs if page is already on the node
@@ -153,23 +157,20 @@ static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
 	 */
 	nid = folio_nid(folio);
 	if (target_node == nid)
-		goto skip;
-
-	toptier = node_is_toptier(nid);
+		return false;
 
 	/*
 	 * Skip scanning top tier node if normal numa
 	 * balancing is disabled
 	 */
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) && toptier)
-		goto skip;
+	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
+	    node_is_toptier(nid))
+		return false;
 
-	ret = false;
 	if (folio_use_access_time(folio))
 		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
 
-skip:
-	return ret;
+	return true;
 }
 
 /* Set nr_ptes number of ptes, starting from idx */
@@ -314,8 +315,8 @@ static long change_pte_range(struct mmu_gather *tlb,
 			 * Avoid trapping faults against the zero or KSM
 			 * pages. See similar comment in change_huge_pmd.
 			 */
-			if (prot_numa && prot_numa_skip(vma, target_node,
-							folio)) {
+			if (prot_numa && !folio_needs_prot_numa(folio, vma,
+								target_node)) {
 				/* determine batch to skip */
 				nr_ptes = mprotect_folio_pte_batch(folio,
 					  pte, oldpte, max_nr_ptes, /* flags = */ 0);
-- 
2.27.0


