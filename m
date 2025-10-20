Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EF61CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 06:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C49BB8E0006; Mon, 20 Oct 2025 02:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF96F8E0003; Mon, 20 Oct 2025 02:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4C258E0006; Mon, 20 Oct 2025 02:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9B88E0003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:20:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67D0B11AC6B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:20:11 +0000 (UTC)
X-FDA: 84017492622.03.0591266
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf03.hostedemail.com (Postfix) with ESMTP id E468520006
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:20:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JrjFXF6a;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760941209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1NIGWBKX2VgBsYJzaokE5dlkXNqFDYQmatKawZcq2ak=;
	b=Fo9U0UNODIJmQ9NY/HZtBHLPOOqglfMRzSyeDjHucdAuWN2b9TP2QdbalKsK6Ar9v/guD9
	zD0hjEoHzzC1Nvkx0WsepKBRsCEZr9LiD65jzF36+mank4SFwVxsWIB2Fegs3sEKwdb6UP
	w0C/dz3QSJRZcPM4XW5deKMR0ndxuDI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760941209; a=rsa-sha256;
	cv=none;
	b=33YD9ixk4z+/C/dY05LdYtoiaQZC50lNM2ATMHaoYBvk6vCPSiGm8l2b5fH1zwCs8M2g//
	BA9q/udpxld2tnKdA5JuHy6mFRzn43meMhdtF1AxF01U3M+AQ5UcP5uM5bpc2qxGSc8LM6
	cJXSjHY+k29enAKkMGTFsUfbGtfG2YY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JrjFXF6a;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1NIGWBKX2VgBsYJzaokE5dlkXNqFDYQmatKawZcq2ak=;
	b=JrjFXF6aG2sO2aZhHa5ArHONQ5ZC7zAQOP9NLDc5SirH+NsgLcp1N10MLiFANzRG6VWrx+pgm
	swc9q81ylg0JaHp0yDuXIvCyGC1irSciAijBxalQZ97239iCe67+k4jvuoDNpP8kG0oBM2xQLTd
	1yav79xgdtetvAW2ey8lkrs=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4cqldR65QxzRhrt;
	Mon, 20 Oct 2025 14:19:39 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 5F5DE1402DA;
	Mon, 20 Oct 2025 14:20:03 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Oct 2025 14:20:02 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v4 3/4] mm: mprotect: convert to folio_needs_prot_numa()
Date: Mon, 20 Oct 2025 14:18:44 +0800
Message-ID: <20251020061845.3347258-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: E468520006
X-Rspamd-Server: rspam02
X-Stat-Signature: jx68r55yh6y7wutx8konegnm9ewszu74
X-HE-Tag: 1760941208-516887
X-HE-Meta: U2FsdGVkX1+fgEUE4sRXiuLT0TUhvNiezfZU7K3BU78zzznwytgeJDQ7UJ1t2NQZPrByd+ZBu48vJbFo0zuXT2nB2gxzuZsYtss48iDDo2NMvP+ZcVaL0UD/7BXaUnjykwEQ/7BD/MguPfFPypOUaKVavEFZkte0a/Sn7Rs+WGDu8zwzKtS9lh62SXxeT5dSbhWAW5//fUhHd8ICiiJox+PxsbTUQxBga+rL5KPgXn3owGC8Uc5LBYfmyC7v8S20IojXXViRln7mPhGuIJ0r2NemkaTTsihCaLaTuIJMEvE7mhPkKLqyxvWE0nL2PlNeTASayliUTUFsaoGrmlpVAtrDeyFtCTxz9eZYFCmC017x9PH8sX8luDiluc9RRGdmVdAWTu6e2H2jOJr82RcSBWJdk69oFdTEOhRWpBtgnuNUNzrQewH7zaN8iGnU879qWFdDL0Owlz9G2kHLS9nxYuLFr5x9U9uMCJ9f+6U/jYdMKReVkoH+KbZ7XU+V3Q2CovhB6URFYvSwKzHl8ejWAtzlQmiS/JhbkhQmfyO+FlT3dYlJLmAQ2ATibDHWe5xbgZr0htpRhZuCxvyL9J6yTIJepFovhFOslYqFG34SaIDWSICzw0H2GTrS6BQ5dwV7Zz3fsdSYhDypLDCGzwUjUMQW6EfKQvaSZL9eq4fsbDSeajAPcQ1s4I1t6SKRjYVyNwui6dqH+3Z54rMW1nd5B24XvmYfSmp4AdAmcccyBkP+dFUcSYJZvJbp5rFJ6JCVzaRLQiAQWU0WRs5nlG0vKt1BMmHBw+WmU6Zs2IW//tsWFvhzJaB/VXzgk+JiphvGyRmuccYQ493RfLHTbWCJkyY86U2huweOYTaru/3icLDxYkvny1XiM+fQ+5m8BC4PNe/3o634jNsoWIWB1apqH6ES0i5qDeF/cDOKpxNZzaAGzriAwd8WO77SFOD9Jxp4S38Qq9HyYjjgvbyt485
 LrqYH0j5
 CRlqwS/D4lsdyukxcVh3FLxAQXG8cxjfKLreE8A8uiHhXwaq/Vrho7iNIJnxfwpJPqDt+NanulMSvwVBltH2zzhy98QU9MSJNHVTI/XEdwJHEkbKTKXphmOw+QZ8AdtMhf0sxaDoHZ74grK5zwVr/o5vs9qLExcdbhJ909LDoi6/kx084Zmt28ogSQ05MG66y+xXA7N6S2RaMJ30MYytgQ2D4Ro5Kq+jNEj6n9JIUKHnTMuVRpVqfchtch4+0TWHBEoNVt2F8IpJiVL5ENO406XqdRlPqp4KELxfSAqK2SZZPNGqmbpiWl4ZQBAZSyp0rhTAd2coHApLKD9cOhTDNcDJTzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The prot_numa_skip() naming is not good since it updates the folio
access time except checking whether to skip prot NUMA, so rename it
to folio_needs_prot_numa(), and cleanup it a bit, remove ret by
directly return value instead of goto style, also make it non-static
function so that it can be reused.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/internal.h |  3 +++
 mm/mprotect.c | 43 ++++++++++++++++++++++---------------------
 2 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 6691d3ea55af..b521b5177d3c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1403,6 +1403,9 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
 		      unsigned long addr, int *flags, bool writable,
 		      int *last_cpupid);
 
+bool folio_needs_prot_numa(struct folio *folio, struct vm_area_struct *vma,
+		int target_node);
+
 void free_zone_device_folio(struct folio *folio);
 int migrate_device_coherent_folio(struct folio *folio);
 
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 6236d120c8e6..1369ba6f6294 100644
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
+ * Return: True if folio needs prot numa and the access time of
+ *	   folio is adjusted. False otherwise.
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
@@ -315,7 +316,7 @@ static long change_pte_range(struct mmu_gather *tlb,
 			 * pages. See similar comment in change_huge_pmd.
 			 */
 			if (prot_numa &&
-			    prot_numa_skip(vma, target_node, folio)) {
+			    !folio_needs_prot_numa(folio, vma, target_node)) {
 
 				/* determine batch to skip */
 				nr_ptes = mprotect_folio_pte_batch(folio,
-- 
2.27.0


