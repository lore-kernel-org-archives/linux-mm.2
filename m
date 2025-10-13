Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60BC7CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CC478E0038; Mon, 13 Oct 2025 08:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87BC98E0037; Mon, 13 Oct 2025 08:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792058E0038; Mon, 13 Oct 2025 08:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 654138E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:21:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1CEB91DFE71
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:21:29 +0000 (UTC)
X-FDA: 83993001498.10.1667DD3
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3A926180005
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:21:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CLZnob7w;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760358087; a=rsa-sha256;
	cv=none;
	b=Sk78bEcD3ULZbT0vV8p1SbUOS9KmSG3voXLZZ3sYCZyF6aL6c85OkAZxQ+bdxBzfgMfeIA
	SBI7MVZge8s6q+6vJjbI5KADsod04CfF4u6DaCqDdgh+8XJlw1iObxAOKGV8EtEumdGRfK
	tJIGGhsxDEaJuUsfDspZYg61gfS9VKU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CLZnob7w;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760358087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dP1h9eoLEMZroZ7tHpM7EXtxO9KmBfSZYPeci9s2WaA=;
	b=w6E/L2Ti4w6sCJ6oc8ii2BQhjPPEvtRJPMWIoeIglUsRKXbwW0p6wb38XOCOZf0HIidfzj
	n+VaVkcvxr/tos5bsSqd8qkXT/ZvtI086nvkREElYNwAz+GXfgMnjjED6ZKHTeuMi5N74n
	B+cQbgC0HMLJ6SiNyROTNXqA4581E2Y=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=dP1h9eoLEMZroZ7tHpM7EXtxO9KmBfSZYPeci9s2WaA=;
	b=CLZnob7wfkiAWhvv3gSoRIIQTkMuQjrYojpkYggxRZ9n7ITO4kH3DcHTljFGDZ/lYM6HEzOy0
	b3Iltq4jLufqX0iCMheeUsZJYrM2brR7t7eot7sUkDYGdLz7hvTmBgNzSdlWEycXt9XjGUm3Q7R
	aBe6JqD8yMK+lCfkyWNS6JQ=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4clbyy6TqWzcZxv;
	Mon, 13 Oct 2025 20:20:26 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id D10C2180087;
	Mon, 13 Oct 2025 20:21:21 +0800 (CST)
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
Subject: [PATCH 2/3] mm: mprotect: avoid unnecessary struct page accessing if pte_protnone()
Date: Mon, 13 Oct 2025 20:15:35 +0800
Message-ID: <20251013121536.2373249-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
References: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Stat-Signature: c85wqjz3uujhg1rwejhejh1htyt144ha
X-Rspamd-Queue-Id: 3A926180005
X-Rspamd-Server: rspam09
X-HE-Tag: 1760358085-232690
X-HE-Meta: U2FsdGVkX19Uny0gtm4WAzikE3yNvPp9DcRlDa8dhpFjwyUtY1QLC4V7mKxjpLO1HxuzpVCLDx7tWgRiUYTiV7tqY+0j9DY/Q8yTizkLTcaGMYt1UcLv88rw/005sZFC5KS9fP81qdnNMphY6CDqbnDqdwV42pJMmK7faRWumS5/TJQOmGLUk7JO2HodTcoLLVRz3cJdnX3nbr5J7Vu6s2AFTbABbBoK6sB+BJYY617OoshOG3J3R00W2WmWmAk+hitw4Jxp6S8uq2pY9bvybtyWpIRTiLQs3udl1Zd2zeFrxaGg+o5Dq2Geda7GW926rPkkPZA5wk2xY8gf+wsPcduuVuTvvP0DiReqdmAwc5X3fIrlpT/ScP89MQGNDoIiLsdcysCaozg7uFJ4Pg3ss36kIfilLV0v3OKcYfCyT7+914QUgTmuIadFX2AyHDE2083JFV3cLChB2PWtHnG3r9/cwLycgtaSWNUGoC7iBtZmd4Jx08Xt0Hhk2ejy2UjLFccby8PWgKRw7OD40RpDP3XUSZ8eBH/2+6izTk+EbwBCj2cz6HUOLScaivJGrDZNNQb6OYsBMjCu/0XeSjN682Osq68oaOBd66VICIPY6MGeD3PqXMZ/lB7hPQ3EMvLviBLFsWBbVOAMC7XGmc5ulC4BJPYvn89yQpKa5L4aEo9ONURWb23NKsLVPpQHcqTCr2hdVJs7oN1zM2qiLm5HBAaxdpu+a2YPBEM93Au4TRcPp2bqXU01WopqB6Z6p0rM1QYUgAtTNHL3/1Pbqb9P/Q2YrbPje5J18s/xfsQmcov+13MQxMPXAudVH9CGofJ3ah9bKedOcchXgpKVg829+HlFcw8bFWi3wMNsJV5l57rktNaAmfzCySs0jp96zYvV9IW06ncVZ0LPDdJUaALCLUeOmCcB570Y0ZRVIBQbN9hI/qbWmH0bSiULyKazQ6ChNfiw1D6i+fOAmKHjchB
 HL4vL541
 WrmLadE/uZC/f2Mylklp1gvWN+25bNlnIazIQH+biq2FHnqaNmeAN36fSKDKUIAp4w1g6ZxiaJ0ahoHU6QYSdfY1XXz1qsTbC/b7rspmA/uePEuCVbVUQppcf5oRmAtANbW7SiHA413pC+aYt+G/CqTas1gPYh56VRDKfUk1T6o/f+qdrT6YPgdLkZJ0o08IqJo6xjK6fng0CWcTHBkG73p9ONQI0is0CCOw3s4glBeHnVk6s5zgFfrgAZbk1iSlQ4z/w+hYOmg+Jl6oELSYeomyv8gHULlbSJgfAcFirvCYPhpZxO0oxBCGAtvGgGd+zGLCWvr6rpMQdlSmRXqKz+GL9Iw==
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

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mprotect.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 51a28781de9d..0f31c09c1726 100644
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
 
@@ -307,17 +302,23 @@ static long change_pte_range(struct mmu_gather *tlb,
 			struct page *page;
 			pte_t ptent;
 
+			/*
+			 * Avoid TLB flush if possible and unnecessary struct
+			 * page accessing when prot numa.
+			 */
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
 			if (prot_numa) {
-				int ret = prot_numa_skip(vma, addr, oldpte, pte,
-							 target_node, folio);
-				if (ret) {
+				if (prot_numa_skip(vma, target_node, folio)) {
 
 					/* determine batch to skip */
 					nr_ptes = mprotect_folio_pte_batch(folio,
-- 
2.43.0


