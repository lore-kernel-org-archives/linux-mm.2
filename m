Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A87DCCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 11:42:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59EBB8E0018; Thu, 23 Oct 2025 07:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54EFF8E001A; Thu, 23 Oct 2025 07:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4167A8E0019; Thu, 23 Oct 2025 07:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0871C8E0018
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:42:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B514BBBD1A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:42:37 +0000 (UTC)
X-FDA: 84029191554.30.A465504
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf23.hostedemail.com (Postfix) with ESMTP id 436A3140009
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:42:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761219756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dEh5Bqq3FTF368WNk1hTPIQnNG563K/dnGo4WinwWCY=;
	b=jBKzc8BBU/jwfP9UHFFCZiY+kaMsdAJ1WhTv1pbd59Jdg8sYUW6LSrm+SsPmfYqFbfN/2t
	ljxTWS9EN8+dnV9Yd7OPKlmYSXwo8rVpPWeBrbV0ELjBnnh0Ej3NYD0y/Mq+P0VV6wEdQk
	SR8rMdzBeU+04KdErAi4I20brJYTKUs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761219756; a=rsa-sha256;
	cv=none;
	b=iQApG1kmr3EE3GZkbrjYQPIvLzlHJSi72dQKKmORmb9wxswIaYMHaf34Ay7EycW4PNwA1s
	Twb01F5UswjtMKPIydnhdxk0u5d2XIypTcNTiaZqtS0/29dQUXNn0ElTXlXe16GCysmUAt
	Ml2Kxo+QoRdOdaE5gXggRnppZloLuHY=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cskY73qvgzRkFJ;
	Thu, 23 Oct 2025 19:37:47 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 70635140121;
	Thu, 23 Oct 2025 19:42:30 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Oct 2025 19:42:29 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: [PATCH v5 2/4] mm: mprotect: avoid unnecessary struct page accessing if pte_protnone()
Date: Thu, 23 Oct 2025 19:37:35 +0800
Message-ID: <20251023113737.3572790-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251023113737.3572790-1-wangkefeng.wang@huawei.com>
References: <20251023113737.3572790-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: 436A3140009
X-Rspamd-Server: rspam03
X-Stat-Signature: 8frndqpoe3kw991b99ektarx4c46ppny
X-HE-Tag: 1761219754-628291
X-HE-Meta: U2FsdGVkX18PJlSONvzdLNo6cXSGKCvS07exJo/yT14ks8wD7Y0QlVV8+IoIFcHOBeAhOiI5/UZfpK/lzFuISPzjlsjE7tloSeVyY6lInK7dWSfX5c+i/TAn83OkM7VtI78G9QAlUse2QqqTHYPl46XwNCGRzFaoSEiJd3YNbp8SzJYzjUuJpc7LeI0jhHMtNPXHjWEKkJRzr8jmhE4wUzE9/qsDEnKfDxvNIWs6RF5kOiOY97bFuIVEbpU0mi/SnWokWkiAI8FNkcsSGkYOSBai84I/4IJQmoyFZVqtftxTc3IO6CIYPXz7MIr7kKWaITEk1LvPhVR6xM0mvDJ5W+cIADn/YLyE5k0188ezh5nWF9WWTI1dAQ14vPASdmORM9vbAQMyshMBX/zOtEjJZeLkWr7ok4kVLCtNRQP3CWTxbk7+5gJBKnBunFSJuHqnb5Ac4U0vCjZDhrq6BM+iR+MryXjbEJ6zCBXYIlKbhJPW/fwzfe+ZSzTUVAhPlWDcvflU3YyHMFivtBAFhjBCpc6OQWitc0FRY0hevorMwf+ltLKdwKWacDtOKl4KdBzDwzFwyasqZ9DLYxrxH52o1iG77wXsJqoM5LqnVsaH4uLs07NdiZJJ/i9LoEEo6rgmcRd3ECDGr21UjrpQMWjER+E03/Ipp4eP+CrB49etTv0oeijvP3oDKJ0li8FDeiqBUyNtstSB7V/U6HrA8RXuGEBP5t7xzWNhjISbvkoVHKrl01fxktjVQpwL8WKldYD1uSyvUR6AvWiHgYidYLKTMwLILiPmTSwMZeJHIb8uY1H8aqzrpTCSNuEduP4eIHf07AutwNK+8WKtmwbshXAQU/BUkJbt+vLhympuK5nKmKVW+pRYvQ+KTTvSn3I8psF4ed7+bQ4iP+BBdx/sHgQQ45uoqm7gJEIvwyiSohiMkeXDVhK/jfiSLR8Yu+U+8n6SEAo113/au7LDcS4wOYl
 DHdBjxR4
 ju46DT+mP+h6bjS76OSstZr4RpYBsQB27BgGGABLH94/+BH9saH+L0xp+LeMEci2XGUcmxd9S4WSzF8rDhxSZXww/rwgvfUcUhgcj9xnTXXSO7rKnsaquepYYl0wTgx79gImo/otb6QggfOmnXSWZNA3147r+UU3QKW4TNAuYu9Zg0rcf9G2qvcdUTcZxpN7Bf2EvOxIaCVMVZq/ExWQM3BcjkjBouSKuY1afyBfCkWeZDPSB0Y747iKNZMfvrtt0izEuPT9lQvna1B16BOob5Rk9sxionEm1YUxS8MmPdhoRMtw1n2PxShLXdP/mj91Z/iabE5Zncb5X+IKP/rgY0NHcX/Roza0LOTrVLNqWKBKSsHg25UX/wTRJRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the pte_protnone() is true, we could avoid unnecessary struct page
accessing and reduce cache footprint when scanning page tables for prot
numa, there was a similar change before, see more commit a818f5363a0e
("autonuma: reduce cache footprint when scanning page tables").

Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mprotect.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 056986d9076a..6236d120c8e6 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -118,18 +118,13 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
 	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
 }
 
-static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
-			   pte_t oldpte, pte_t *pte, int target_node,
-			   struct folio *folio)
+static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
+		struct folio *folio)
 {
 	bool ret = true;
 	bool toptier;
 	int nid;
 
-	/* Avoid TLB flush if possible */
-	if (pte_protnone(oldpte))
-		goto skip;
-
 	if (!folio)
 		goto skip;
 
@@ -307,23 +302,25 @@ static long change_pte_range(struct mmu_gather *tlb,
 			struct page *page;
 			pte_t ptent;
 
+			/* Already in the desired state. */
+			if (prot_numa && pte_protnone(oldpte))
+				continue;
+
 			page = vm_normal_page(vma, addr, oldpte);
 			if (page)
 				folio = page_folio(page);
+
 			/*
 			 * Avoid trapping faults against the zero or KSM
 			 * pages. See similar comment in change_huge_pmd.
 			 */
-			if (prot_numa) {
-				int ret = prot_numa_skip(vma, addr, oldpte, pte,
-							 target_node, folio);
-				if (ret) {
+			if (prot_numa &&
+			    prot_numa_skip(vma, target_node, folio)) {
 
-					/* determine batch to skip */
-					nr_ptes = mprotect_folio_pte_batch(folio,
-						  pte, oldpte, max_nr_ptes, /* flags = */ 0);
-					continue;
-				}
+				/* determine batch to skip */
+				nr_ptes = mprotect_folio_pte_batch(folio,
+					  pte, oldpte, max_nr_ptes, /* flags = */ 0);
+				continue;
 			}
 
 			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
-- 
2.27.0


