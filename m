Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB197CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 11:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1EF88E00EB; Tue, 14 Oct 2025 07:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACFFA8E000D; Tue, 14 Oct 2025 07:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996668E00EB; Tue, 14 Oct 2025 07:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 83F618E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:34:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B8BA16089A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:34:12 +0000 (UTC)
X-FDA: 83996511144.01.A694527
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf11.hostedemail.com (Postfix) with ESMTP id 03EE040002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:34:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ZUPEaBnm;
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760441650; a=rsa-sha256;
	cv=none;
	b=6VSo5NGjRqsebCqM6/quy3V99Kn7iIpy51koe/9F76xHvs4lkjnq2/JuRFU0GYO9OKEUWo
	K8V/TpOhI0mTERLWJBFcFeZPpDH7FL8vTsLt4ngwT5LO1ltmOYF/2BzR/EhOGOdHuVZVPn
	MHUa5GqLrhpM3x1Pct9+QRXSIHWo/Tc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ZUPEaBnm;
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760441650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2Os/vxtxopWe6GvOMqX4Sn7ySwzHDFEiA9y7BHDpw8=;
	b=F4eU2MZfb1XS8iSKPdPT8/hZTRYc40jwspYnjESRGdGFClEQIyNXpe8qu4XPGUHrdsNiyM
	QZw7oMAN+ZLzGl7YIUWGsF8lYcKil0EB/CCt9ZQIMoHId/8A7l4fv7CkZ2aU5t3Qwr/yuc
	d8ny+SCPAChKvPbuHgizikGGH6OjtC0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=J2Os/vxtxopWe6GvOMqX4Sn7ySwzHDFEiA9y7BHDpw8=;
	b=ZUPEaBnmvY8q9/aZDTnUrWi7Xx0KBM7iO8N/8XLRIguLmS3iu1WII0tOCoO2DWqZ9kqXZKzeE
	esPi5T4o96/at4QNpU/RNnHON2KZNU+gGehEGOCkX0XKVHQ/tnyxzgNAOdKwM+yqlvd/FU/8+Nd
	fi3Pjz0xvSnohkJ31zagW2k=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4cmBsw13ZYzcZxv;
	Tue, 14 Oct 2025 19:33:08 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id D18A818006C;
	Tue, 14 Oct 2025 19:34:04 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Oct 2025 19:34:03 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: [PATCH v2 3/3] mm: huge_memory: use folio_skip_prot_numa() for pmd folio
Date: Tue, 14 Oct 2025 19:33:49 +0800
Message-ID: <20251014113349.2618158-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251014113349.2618158-1-wangkefeng.wang@huawei.com>
References: <20251014113349.2618158-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Stat-Signature: 57yi93zup8w3b3h13351dij8g9gnx71y
X-Rspamd-Queue-Id: 03EE040002
X-Rspamd-Server: rspam09
X-HE-Tag: 1760441648-307016
X-HE-Meta: U2FsdGVkX1+wGTgpJj67UWZS3H58UNxOldCnxRtGQIglbP7SBdwPOPtGBlhTQl84snYV0s4TL4xDbpQSmpvushYaLFFa6EzwJugKGmq6MO876eprQjNC6p4u0urqWcTf/VtoCULnaYSZN6HHbAT+bTIYXhLkjf1rUtZgNWH6JQzSno1nRPlnZ7pZ495/c7Y7nCLgNDSIn0PwVMIn7gLIJIXGh0PFZ1IGYqCwTmijItmpdqotrHNTcEOHAovAiMJxUfbIw3G63A8+zJvXrfKFuMtqlHh5tS7BTJx9JxepTokOBZb2xJINPzsVC+Gg3inawxIbX74kx17EgSNqsIUb6F9WqKe0cdK0hlFoKzmQE8ehe7SRikGeDBWvlkQsF3U1NlFKxrUUc7egOVC0uMoJDWesn5TotUL4zTLkWTofEhymfQ15RflNWL32llHAnAGpQsYb/ZLyMdM5hzek/tsDdlj3NMBIFqjWuA392+SUtjQWMXFXdV+9RHercHyWFpDaXR/XTX12YoeppIlw2IQQ0njxDKJlvIDDqil7rhpjAUKiQXaNKXlRTigN0noquKDVLN6/+iOGARmo8+ekzx/X5xnQF9sy6uNnA2qia0R61/vLjdWvavNMqxqG4ajWBQKIIaLirRxAQmZHbgWP3S41Cu0GfWpK93/4LJaSAakfaCjEgbiZVHVENsatYoI4sAH2gU+aRj35az+/moJCJPNT3M/rXvxfcQ1gTsgOhGjQbeKnrdY9Sg2GuIztvOTbNM9OfQBGpGX3raWBnDqjutnRe0fLrZJJ+b22mobmXVMLXEn2GiPb3jHXLfxhbGnTA6+PQbdah9v/8Hh1tNYc2BMAfjl2lz1LTxPrdGBkBXJPvxskkkug2q487JF8oTykvzumFtChD/HYjWA99jf8UP5nd0kuJgpN16hDV+Ztbd+gv+IxMX5jplg+7+KDTC6E/HY24RlQHUT1izXPgN9077j
 6WbaTos1
 a797NYqVoVyOgE1dorLPskoGyimbiXNUQ3n5Mx9VmM+UD9k8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename prot_numa_skip() to folio_skip_prot_numa(), and remove
ret by directly return value instead of goto style.

The folio skip checks for prot numa should be suitable for pmd
folio too, which helps to avoid unnecessary pmd change and folio
migration attempts.

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/huge_memory.c | 21 +++++++--------------
 mm/internal.h    |  2 ++
 mm/mprotect.c    | 35 ++++++++++++++---------------------
 3 files changed, 23 insertions(+), 35 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1d1b74950332..8ae17e0aacb9 100644
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
+		if (folio_skip_prot_numa(pmd_folio(*pmd), vma, target_node))
+			goto unlock;
 	}
 	/*
 	 * In case prot_numa, we are under mmap_read_lock(mm). It's critical
diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..55daceab3682 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1378,6 +1378,8 @@ void vunmap_range_noflush(unsigned long start, unsigned long end);
 
 void __vunmap_range_noflush(unsigned long start, unsigned long end);
 
+bool folio_skip_prot_numa(struct folio *folio, struct vm_area_struct *vma,
+		int target_node);
 int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
 		      unsigned long addr, int *flags, bool writable,
 		      int *last_cpupid);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 7affa88a6de7..cec4c80eb46d 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -118,26 +118,21 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
 	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
 }
 
-static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
-		struct folio *folio)
+bool folio_skip_prot_numa(struct folio *folio, struct vm_area_struct *vma,
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
+		return true;
 
 	/* Also skip shared copy-on-write folios */
 	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
-		goto skip;
+		return true;
 
 	/* Folios are pinned and can't be migrated */
 	if (folio_maybe_dma_pinned(folio))
-		goto skip;
+		return true;
 
 	/*
 	 * While migration can move some dirty pages,
@@ -145,7 +140,7 @@ static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
 	 * context.
 	 */
 	if (folio_is_file_lru(folio) && folio_test_dirty(folio))
-		goto skip;
+		return true;
 
 	/*
 	 * Don't mess with PTEs if page is already on the node
@@ -153,23 +148,20 @@ static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
 	 */
 	nid = folio_nid(folio);
 	if (target_node == nid)
-		goto skip;
-
-	toptier = node_is_toptier(nid);
+		return true;
 
 	/*
 	 * Skip scanning top tier node if normal numa
 	 * balancing is disabled
 	 */
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) && toptier)
-		goto skip;
+	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
+	    node_is_toptier(nid))
+		return true;
 
-	ret = false;
 	if (folio_use_access_time(folio))
 		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
 
-skip:
-	return ret;
+	return false;
 }
 
 /* Set nr_ptes number of ptes, starting from idx */
@@ -314,7 +306,8 @@ static long change_pte_range(struct mmu_gather *tlb,
 			 * Avoid trapping faults against the zero or KSM
 			 * pages. See similar comment in change_huge_pmd.
 			 */
-			if (prot_numa & prot_numa_skip(vma, target_node, folio)) {
+			if (prot_numa & folio_skip_prot_numa(folio, vma,
+							     target_node)) {
 				/* determine batch to skip */
 				nr_ptes = mprotect_folio_pte_batch(folio,
 					  pte, oldpte, max_nr_ptes, /* flags = */ 0);
-- 
2.27.0


