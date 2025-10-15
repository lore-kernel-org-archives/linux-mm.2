Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05540CCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 12:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D2D58E0002; Wed, 15 Oct 2025 08:35:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B9DD8E0020; Wed, 15 Oct 2025 08:35:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D6B8E0002; Wed, 15 Oct 2025 08:35:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C8F0D8E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:35:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 536E2847A7
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:35:30 +0000 (UTC)
X-FDA: 84000294420.24.CF8EA7B
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf12.hostedemail.com (Postfix) with ESMTP id C01EE40008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:35:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cNzDKYzm;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760531728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Auj1i6KtUszo4sKq4k3n2EGEWRBij8p9XCjgm9Ovv9M=;
	b=8HpE8fhp4XyI044V/56dcFDCqZzsZZhAxqbquWPdBlcEZfX2amlaWr/OMlDs7psABm/Y8s
	Eu+y5bKQdD/OtKesepCEjvkyHNPsc+Dgj8x7CTC7LONZ/6W8z9kGh3qKA3IPYsWIme3QR0
	ncUNuQioJhhlAv/f89vYy8oRH+VMHbg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cNzDKYzm;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760531728; a=rsa-sha256;
	cv=none;
	b=NTzqzkfxFBSegSEy6dHdsC7mVuGvkTJGGx5QzvE0szn4kgZs2eGLIWfJfKxCAcxyOSJXeI
	v5R6BGUBn9IwH/w4qFV8wLjM5IxbN4t1fk46e7Ff4fGBWrP9eOH9jNEQMN9rWQ+yXv0u5g
	ZOvnu6Dch/5PzpADA3QNfzgI81lYe6g=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Auj1i6KtUszo4sKq4k3n2EGEWRBij8p9XCjgm9Ovv9M=;
	b=cNzDKYzm3z2AMfkHolhZFiUTR9EbHi6+wXAOKkMoh3EnCSfmz/jsH8kZifZ+CKfY/8dQRyS7d
	3MDVUazSTpb1oDUTx3IbLjx2Lg0f9woORAZNoFoJQ0jp9oRpZk1hDLXnZNW1MtVUOhnEB2ru96/
	E2970PjoVIwKW6m2po8ACaU=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4cmrB94T4GzcZyT;
	Wed, 15 Oct 2025 20:34:25 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 3AA9F180B6B;
	Wed, 15 Oct 2025 20:35:24 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Oct 2025 20:35:23 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: [PATCH v3 2/3] mm: mprotect: avoid unnecessary struct page accessing if pte_protnone()
Date: Wed, 15 Oct 2025 20:35:15 +0800
Message-ID: <20251015123516.2703660-3-wangkefeng.wang@huawei.com>
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
X-Rspamd-Queue-Id: C01EE40008
X-Rspamd-Server: rspam03
X-Stat-Signature: 3acqi9xmmc9pxosxseg3uwfez76qm9by
X-HE-Tag: 1760531727-230628
X-HE-Meta: U2FsdGVkX1/kq8qK9+aLJcSGMgL+qjf5UcPhnNd+83lkrNMv8hHtNAvsCcBzWbpwAK2Q7BzlpuEbgD4GK1Fi67wW+mb9DdMRLZjRULs7qlZ4DaU09jgPC5DcqR8dX1SRwQ1yW1p61O4rIJTbNCJIto6obanjhk40Uktsmh2vr4vfxlwjqUqO+vYLAOrZquZOAp6lb3pb6KyW2cycdSs66EHxa8w0WdTNf/w/H5Qr3d1OzIJ4kw+6hrMh3rF9h8TnJ6jcBMwDczuwtTXpuAfSjTUZknIHZ/3F+MEiMX3tqT03OuuOSYXxQHVO8I+qXCrVVr2wPYuwZRFd2iL7yeO56PGXNw9jc3RmscfbymHkxYnUjUFQOVty++3MURtwg+GgNL0bQBE4wkcO7VOZNwk5NxXf45jshtJXjwOujhSNCLWHzSCqsCQkDhdhsxZCwdrSrTat7JZ0ObImGC5W9cd/wxq0AQXQ80Tkfs1LzBA/BedeijZd5BxTJy12WsP4FC/CXHtT5Q4rozt4oz6YCZF3tyleKNxsLAOoVdaHgDPz1V/+bLfc3nptL+xJn9TtRZ2lh2fJX4Ja0GuapvOZDNEJD4ACpu5HfCKBW1Iej1j4Zd+pYC8uYLkoz8bnrVAYc2WPnKdhDMyy8z2EtQ/5Ni1zbQPUFAy7W6HFw9nGOQvKLHzhp3nQixXltHHgDug0H9obgNeJd2MfAgJbvckdkLQrqBLD+VBZcpfUMonIKUF72PwsxEtoD1Rk65//xQS1Tr/AK6IeIxq+pILvDxYD2eVhjjaJudbtD50aYX4qlKttXFeU/aIOvAc2XnDDYlYJQ4sKtTvAEqazkNMzDit3cw++EcIV/lWqsy5hJF6OIwoPv5oWDPmmeGe6cGXJVtWCqLId4wymNm/5NTIPM/5dY4zfM2SXxL4xujJqrmK4KHEkJK3KkPLSbFdAkcG4Jc+3F8khl/2Y73KPcKHQt1TSavm
 VYSfoDCD
 f+pZVuJfoESRh2SPqeHu9jcl+7jfH/NF/pFjktJEE6yIQxlZ3USY2zTo+VnPTByqjQzwCcNW+90A+MUZYR5Tx+V5OG/a1smadCEIeL/4VuIM5H8LYvL1DWiPZy7KRtTP9WEiKbrEK5eUUQE2AhZRjOBvwTLchrCHuZuszkNACtfSSKDMakQs2//5mViMiqV0xGa/Al05CPZCFhogYalkjHFYZ3oK03wOGlDQlkU+nOC/VdCNiPl2aYNvM+QFyckeg2kfHUt89fOr/V7ytguryKGkgtcN7h+1s//wFH9C82J+D92Whg8mXBjttNN2q+KxGaZNTRgQZGd74H66LPfe8Sd30v60eWYvXATIBJP2S6+DLcss=
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
 mm/mprotect.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index bb59a42809b8..ed44aadb7aaa 100644
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
 
@@ -307,23 +302,24 @@ static long change_pte_range(struct mmu_gather *tlb,
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
+			if (prot_numa && prot_numa_skip(vma, target_node,
+							folio)) {
+				/* determine batch to skip */
+				nr_ptes = mprotect_folio_pte_batch(folio,
+					  pte, oldpte, max_nr_ptes, /* flags = */ 0);
+				continue;
 			}
 
 			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
-- 
2.27.0


