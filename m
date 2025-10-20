Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BD47CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 06:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AC978E0002; Mon, 20 Oct 2025 02:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40A588E0005; Mon, 20 Oct 2025 02:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D1E48E0003; Mon, 20 Oct 2025 02:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17CFB8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:20:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 965EC160725
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:20:09 +0000 (UTC)
X-FDA: 84017492538.27.37BAABA
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf03.hostedemail.com (Postfix) with ESMTP id 725CD20008
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:20:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="sa17P/66";
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760941208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rC0U2WaQCsKbfP/n1ywtWAKT6+zOU+YhhJGODgZAC9M=;
	b=1yWTjxeLfy9LJLKgB8hSziKFBFo3zjQfslInk3yHCZmjuMhr+1IiFA/nJ8fyeUtqVhiKi7
	ogXE38+FJkrdz4oQGrb0nh8QYBhdI0P/mgD7tHCOq6FaEQx5aQsxL+90M21aEYSk4yHq/u
	2QONQbFAKqqkXPqZEtzafbYix2LzkO8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="sa17P/66";
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760941208; a=rsa-sha256;
	cv=none;
	b=LQYQ5c5E8xpsV7iPohWgrwaLEMDBFYTXGsyUb2giL90xWtTQHPkGT8nDi17NeSwpAN7jqP
	ddPfc4GL5k+IJ0QVEkOW62Tu2eHlDWEePXRsb/k6XKniOFdxtBeZBJ1HV/6jInQexVdtlV
	jZdQSPhIhaIRLLbAuqZIDh9hcQ3TV2M=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=rC0U2WaQCsKbfP/n1ywtWAKT6+zOU+YhhJGODgZAC9M=;
	b=sa17P/66dDkM9Fhntp1LxfEPza/i8dLy86QdDKt1/yTmEMynCHiy9NDGijyLIhQBGJy0jC/5g
	1VOqVaozAxffe9iQi3oPWZzb6zt253UCahR0GMBXnHsjgpg5pCNDHJthdxwhRFdofrxoFTgOv02
	uuTvwvcde7MYJ6/DMN4KONk=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4cqlcv2Kd5z1T4FV;
	Mon, 20 Oct 2025 14:19:11 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 8D6D9180488;
	Mon, 20 Oct 2025 14:20:02 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Oct 2025 14:20:01 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: [PATCH v4 2/4] mm: mprotect: avoid unnecessary struct page accessing if pte_protnone()
Date: Mon, 20 Oct 2025 14:18:43 +0800
Message-ID: <20251020061845.3347258-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: d5hsoa8wugrjjn6r6asg68qi5mscto3z
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 725CD20008
X-HE-Tag: 1760941206-158974
X-HE-Meta: U2FsdGVkX195mkhZ5+6i+HOxMPthwaLh4l8QebvFN9h6Fs1GDAyakPkBaXgLMBlCbomli7Gl80G+8xWKLnnyQjbtY6l6xw8OPS6x9BNSywvcVzBW88344SfkDe+GA+CNI35LExC6KGOaUAGw9bzPkpWVAEicKQ+nrsxFP3ni/EdHp5NIwk1/9ZdkwNYg7547TJ2YJzzyzfEI1euqzF++AWZaCB9wfnTKd1dtG/4T1+ItZ9vtunpc/6QfwH8lXspKRrhgVFJOJ/JIzwN1NB2QgxZ66l61VY6/dd51ZQyJO2ij8g45ThG3l/6VQj5xfdHB+ec35I7zHDjzLQkEymby1cFoqY4k6Bad5Mj3vy+C8tr1ul6xb21sjkUip89Xb8BSiKD7sney4mlPALz1rMfMApubWexBIW4BahUmTEGJOKzkIf4HbddR+AN+0z9AzDZJ6/jmR66nc6hd19Qc3ky02GqfRcBFNMr/GoLUDKeM4rrUjiPl+IR3TGaQENte5yON3zAXWpQKrD82eNf99virSCShWRamHjybQ6UcVko0qhfXqlzNJiO7JEGU78DMmHc1qyrpJ76ZMCqzZ56068ge8l8MQ44Q4IRWBLheu5YP/HhtUpIg1PdDVqOvjUCRloRZhxIEHy6N9Lc9zS4zLHAGZPgvv2eyg3fH94ZmH7F4b/IFR7Y4T8JtyXypeYP2AtHx9I8ZRaFnCOnVhW4R4qn/wkaQ2NPgWuMAv8Uou9SIhpYp0bUjADsX2ffWnJx16INtUcqocWIGdzoc7fVvpxCsIlkJNRpq2FpS2Afa4VOkbfBITJ215jZhvMDNiAx+Hfp4CfpeATOXYqGknF9pXWEaUh9WuMDTyOGRarG1Y090ZkeMeqNjVbT+OO+ttknwi94F7RsGB8vfAnahPDUe2HU+NpK4NpPksRNT7HNp+1hpOCyDDpXNc0PkJ6DrJUMw0OXz7kwmTA9yXRGV58jAN5r
 BsrD5sUR
 JSLPQo1ZtueA0XKu5Fngb+sg4UQlGUB6JypIkZ6XnPxt7TDw=
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
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
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


