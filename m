Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51EA6CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 11:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2F858E00EA; Tue, 14 Oct 2025 07:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE0FC8E000D; Tue, 14 Oct 2025 07:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E4318E00EA; Tue, 14 Oct 2025 07:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 805F48E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:34:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 527311A0876
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:34:11 +0000 (UTC)
X-FDA: 83996511102.17.A145569
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf02.hostedemail.com (Postfix) with ESMTP id CB4E08000A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:34:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="gCYGI/Ma";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760441649; a=rsa-sha256;
	cv=none;
	b=BLhR5GdJbp6YKcW5fUW7ytQuGj9HqQ4rkNfzpje4Lq048ggcfQQSM+XCOR3k1eLY3K34/3
	rkkIY0QNyKhbM6arsBwvpX3rZjd8KBWgs1Wi/JaFGhGS5C+XU0spYV1W5sPknrAMGUT+VU
	yxTqbl4EXufZt5kImHYKsE9+gH15Gdg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="gCYGI/Ma";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760441649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ZOHf47U6VNzOwON/yvSQ2ww72A5OuInnPhZDcA4bG4=;
	b=BXJvtPS+rpYEz3G6C1l6RB9dc6buRo47MJR1szAL+fPrP9+zo9mmycLzQ7g1MY+ns5/0gT
	/mNE8rdr04h1sHWARoq8v6OeglDTdhEH6wyYorJT2VPOxCIKQsuY+mz7SH4DsZ1S1rS2uu
	2dOK8TRQ7S/dwEqgFvY4SpkxymBUDOM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9ZOHf47U6VNzOwON/yvSQ2ww72A5OuInnPhZDcA4bG4=;
	b=gCYGI/MaNtGGDGVrB5cwW62+unmIlslldwiHsqYpxv2nm29TpD8bh85LE1TTHCBTwncx9rTR8
	Em2nWolPctFEbX25+uCzKLrakHgbS0TAfwizMXRI/Vr11QXDrhnPglnqfMNEex/+QU6Jkje9gVw
	ju10oPSHwS38Sp/xmIiL6Gw=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4cmBtc1gQHzLlY7;
	Tue, 14 Oct 2025 19:33:44 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 0240F1400CA;
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
Subject: [PATCH v2 2/3] mm: mprotect: avoid unnecessary struct page accessing if pte_protnone()
Date: Tue, 14 Oct 2025 19:33:48 +0800
Message-ID: <20251014113349.2618158-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251014113349.2618158-1-wangkefeng.wang@huawei.com>
References: <20251014113349.2618158-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: ru3n4xb6w8rkxbtcen9g8u63jhocfc54
X-Rspamd-Queue-Id: CB4E08000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760441648-755412
X-HE-Meta: U2FsdGVkX1/jU3L5jLg25PaomwGp587+sNyfTeLCKPftudgAkE2kJMBC02+hduCvkzmGZLS8LCzV9fNL12Y7yjfYLfDVTuxtWftuKhZAupWnoCSLY7qtoM/3Sg3oUKFVUuFBfakQAKlkAt1TF1E8DxrmMfjugE/hrBWIHfAzjAYTqZOCtsVcdZBiNRV9PPRvlY1EILsLqhuAdbMwOas+q3k0/ar9de0/ozdMSrvhmqr5xX2fQ0ol9RIQpB2kYCQvnU5lbUsaBk/0tm8OAjeaP/18qHSVjMS4vpMjqKQL1XzCT07Wwbbnb27xoI3LWEOj/xVW7NvaaCscQnIDHLJBM3Vw1opPaEzDkJG4pKJXlBHEFeq3XMnmHsCR26QbztPP0ZbsDN0kUCXLcoLi9Gj2lgQQFXFQN4yH/qAzB0ry6UqW2ciaC27GpBXpJlL1aRAYxFzqdN+IrohFPv8KNDNhvG4VEpboz4VZUfmyXyC7GAClEvL9akjed64PXkTVCTOTrdGIUgo3XqavjNDS2+JJQW4Z7c6UNgXg10v6bbBJAUA7LJpJB09yySbNTuphTY/vHO4KXRnA1jCE5g10OeCeZXS9K7hQ+yWu1n+rszG4eAFrfPiNEty4II+DyQwjW9RXjzKjJiASUj28xkhNu+7KNbEEenh4JmHapIRy5ZcamBNfAjbotIQzVmcM8NBtz+OoMNp3fvTgGvaAXCIOxwfKk+4kpww6+bxGldV7xrIx45qQMqJ+6BlWKxBHD1sYr8hpbnJuJXqfzPY5wsgZVkgbQxB4d/LPi4HHa1fb7W0A7tSbi6rJ2s7NGZXjk3W48UrHbKOtS9U9mPw289GCrEhh+hnHiFbbeSNXt9vuGJxYJdAp/0RjHZFfNo/qO3Dly0TGrQMrkE1yyHgS2Pt0moUcCp9298WXWG9q/Ph13YoWo6nh+IO1f8hzJcACRr0kRSo9fixNvWYkRxtSFdzWgOP
 rANeKgCD
 srxi7H0Q74/FgqxufYSALlmbnoa7ewRC/XR+Gf4mD9BAtUVzxa1jN53Ta5vJsR+KxPkS/dATJBb/wSV9Qn85eDxVGYbfg4jAWJak9CgVUqeWf7IUNcfkiPXQVV3tFOD5p2i63+WBL6UC4qUaU95hCoQ5WyUyMwRP4cmrw/pQPmzUsiFV60NAEODuqKKr1G3nvCo9vk0rQS9jTl3W+UtIwb+0F2wp/km8PjCY5Af9Y90k/cehBDqMjaJgRroc1SxNrKOWyBKhmpUOrEnr5yEZUh9EggzoeUe10ufd2n7u4XrDNIG2ayvyuzVR0IkoFXVRtz59MeZlRg11ACX9cXCbl6t1/9PfDd9F6SjyqPcv1uKXgbjc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the pte_protnone() is true, we could avoid unnecessary struct page
accessing and reduce cache footprint when scanning page tables for prot
numa, the performance test of pmbench memory accessing benchmark
should be benifit, see more commit a818f5363a0e ("autonuma: reduce cache
footprint when scanning page tables").

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mprotect.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index bb59a42809b8..7affa88a6de7 100644
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
 
@@ -307,23 +302,23 @@ static long change_pte_range(struct mmu_gather *tlb,
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
-
-					/* determine batch to skip */
-					nr_ptes = mprotect_folio_pte_batch(folio,
-						  pte, oldpte, max_nr_ptes, /* flags = */ 0);
-					continue;
-				}
+			if (prot_numa & prot_numa_skip(vma, target_node, folio)) {
+				/* determine batch to skip */
+				nr_ptes = mprotect_folio_pte_batch(folio,
+					  pte, oldpte, max_nr_ptes, /* flags = */ 0);
+				continue;
 			}
 
 			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
-- 
2.27.0


