Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9D7DCD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 15:54:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11CCF6B008C; Wed,  6 May 2026 11:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CE856B0088; Wed,  6 May 2026 11:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDD866B0092; Wed,  6 May 2026 11:54:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA4266B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:54:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7DDC012016E
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:54:50 +0000 (UTC)
X-FDA: 84737443140.04.9FE1D3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6A87240007
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:54:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="heM//5zU";
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778082888;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gkHnOBiSkiQP267opA7fN2711MlJS5rPwB2vMpudxdQ=;
	b=lrHyJhj2zKLQ5AZkAXff5cUI+/Sn1Sd+IaWgZwB9eagQ4aUAKGjESmop6l+0eHtjV0Y9S/
	deCV9HNTFxMIvjl12Seby2Hw8g2nutcS4br8bW1OOxl3tlUsNk3QdDumaGQXdKh8SQEJta
	1nc2qEuk42IfgL1fDLAu3atExj25R6M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="heM//5zU";
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778082888; a=rsa-sha256;
	cv=none;
	b=YSQRB6SEUYNTBDUs9diUsFtjAN7nD4ku+fmb90D8xmWid3D/xvzpQBqn8Mf5A2wfnrIChW
	ZeYjapAH9LddvNoYtUCO+kjzf0SRPbn3we9PjstJ5tyv77UpY3IoyU7MYzlfZniEBL8UMx
	OehxX8N0c/QhaycmYOLwAb8t/bWyh7o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DA5D4406A;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54E61C2BCB8;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778082887;
	bh=aXXAbdhropEO/MvYuH57KnmYvw/h15PGDWvnxkuSvMk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=heM//5zU8WXXyBRnidKaEUVgFJrHBQsWaVz7Ri1cBb20IY0hk9IRWEQEbzQ3qm132
	 kBTV8LbGbmlwck4uvVik1emkYmeTHTtWSuUlSI1KV7i9HntOilcSf7cP+LxyKvR3FE
	 qq1EX/vmoN/xnFGZ9ONdTmUdf5HXyioY8OJNRSt7OvZSqoxtPHqxuP2dqjGEI8NqsI
	 RIS20NWOnefRftD7nVcg9mVby1wvlbJ0PWIDG96Dzpg+04RvPGSMBvy/VTIVKpI2HQ
	 b8n2HH/goWp4vsK5PbaZXAzM3/u9GYef10qU24Yar0IVno8QC1XbkBrcXcqFyUIzWI
	 8ge6HntrRB2WA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4365ACD3442;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 06 May 2026 08:54:37 -0700
Subject: [PATCH v2 1/6] mm: hugetlb: Consolidate interpretation of gbl_chg
 within alloc_hugetlb_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260506-hugetlb-open-up-v2-1-826a0c5f28fc@google.com>
References: <20260506-hugetlb-open-up-v2-0-826a0c5f28fc@google.com>
In-Reply-To: <20260506-hugetlb-open-up-v2-0-826a0c5f28fc@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com, 
 jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com, 
 mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com, 
 pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org, 
 rick.p.edgecombe@intel.com, rientjes@google.com, roman.gushchin@linux.dev, 
 seanjc@google.com, shakeel.butt@linux.dev, shivankg@amd.com, 
 vannapurve@google.com, yan.y.zhao@intel.com, Dan Williams <djbw@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778082886; l=2756;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=d07xjMz226JjEc/S2RGQulaBk1NX7KLyZoqjiwrAxHY=;
 b=+/SUHAmWoMFGdn/H4OjwEcyODzKvoeTyEnJ4IzRXpHEDn9Nb3OZ7OR2lii3cgkG937pidxwl/
 emDZjH9Y099DWpGjfBTGt96dGIVzbBczTi8J9uhVKuMPxthX4fi1lSL
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6A87240007
X-Stat-Signature: 4kx11kbh1g8wog3e599w18jhn5gqhkso
X-HE-Tag: 1778082888-674223
X-HE-Meta: U2FsdGVkX1+824tOSKOzT1dIVX6m2fAPZSiYKYkVbPMmK3YjsDQr/CmEkqo1QrGa5br+XeGVOjCZnkcVzFaJhH4vAiQSFxJnqLesIty4BL06Cu+TDkl4o+9TQGqkjcfouvdd3nOYZ2JF+6a3+vyWX91i4zJ88o6rRL1eAZG3WMBSx4mScNttDfmt5DNCLOagpL0GP9QOlqiLt/641GTVO75ny/J7K8FDKEeoLIhmxf84V7V0VDgD5Wgy5F0KxEkBTe/n9hpHNSs+pGozjj0O5OnKUduaZEkzMbk//CgnoKRfay5Uqp2Pv2vHq0FZfixO0URuQCewYoKCNA/l6k1yZo7ehL+NkD3V+s3l2J1ZiX1lM95azQ4nSMB+vyfxC1MDlCz5pVwSuDH+ymm8AbO2JkuDKxxMBobOjvamOMf5nvfCM3rPgp84jK1yEzzOmemoZ0sgxd5X5f9l4Bm1njugBGsOgvue+q6C+xqm9khFkuTFQJej2PtPmYZfRkC2EUu78/Z+X1g+PvaLIAtOkqtk4LnT6SWSN0pASBoihWX91nITOz8eVkk/ObaDycDQUYoRmJlN5F5CC6mnqn7jNS5AOmi9nebKYx5EWr4uadCunq7kckLNkfq37Ny/VnIrII01d+x1cuMjEts8j9bWyIkCMex8cL9DbB9mwZt9MUs5ulKMtPP4yRVtK7DpzyXp4ruqm7bKToH7HZnW7xJkCEMGn2zql08MXInFi9HVDAS/E9BYNAce5kg/JunhXV62DOF26qAw4/JCOLbLI88HM+jyhzC0LSnX4MjvQquQYQsT0sz0A8bOPqYQWl2YbHsU2oA7WW2vPKih3FyKHSRPR/Wu2JXtbcXXcQPdDY6Wvntf+FdwCpvsHeAEDK2KcHhHYLcbW5WrJvaQTEHCJc6AhA1FYhZ3rux7WXpHMp/AtA+qCYG5Z3iUOQW/v/+yKnasXRML8d53w77X2ShHGzPK5YK
 B2HF1vbG
 q01WFtX7cOFn/iALnCWheSEF46QyjsY1gQIAae+H2SifKuoNuBvAr5Twr8bYJnRp4Zbt5tDfIW2jTV/tmmrg3yqSEhMn/Gh73P4y0kqChmbAKvP2CAmfvbJYMC/Ed1yRPO3hT3DTaU9SQR8yiXAxnsUj3phkWOPn2lTlvjkDA/AGQW03RZzOHxPV/uS5znmgdpjIo6tznWVV407Kj/z89cohAW0oBqDoxRGlmA2dkRySzKjHBATB1mf7UOd5ltgke1qnIwx1Ee1Q6blL8npjzvINHKkp1lBDEfmF0uLQ0F1xw62/M6v9qzcA6UmRaqLDTk2TZaCTpkju9IhQOuidlzfSUT4Nc6LNpSwZw8HByEKNKH3kLoM/+9PvGBOXyekSGowQXEZ7AzI00R7xDDIusruqTPWVHw7rXnDDkhX0KW0ey9l/2ip7bwGV4WUPSMX2A/qvwim1+UXDnfj6vm58nmEhNys64bthU5jDdeJBacTSJENNY+8MqH99JBKtifL/qdJCpKNjKAHgBvHgszL/ZVn2Gxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

The dequeue_hugetlb_folio_vma() function currently handles the gbl_chg
parameter to determine if a folio can be dequeued based on global page
availability. This leaks reservation-specific logic into the dequeueing
path.

Relocate this logic to alloc_hugetlb_folio() so that
dequeue_hugetlb_folio_vma() focuses solely on selecting and dequeuing a
folio. In alloc_hugetlb_folio(), only attempt to dequeue a folio if a
reservation exists (gbl_chg == 0) or if there are available huge pages in
the global pool.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: James Houghton <jthoughton@google.com>
---
 mm/hugetlb.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f24bf49be047e..8be246b4e6134 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1336,7 +1336,7 @@ static unsigned long available_huge_pages(struct hstate *h)
 
 static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 				struct vm_area_struct *vma,
-				unsigned long address, long gbl_chg)
+				unsigned long address)
 {
 	struct folio *folio = NULL;
 	struct mempolicy *mpol;
@@ -1344,13 +1344,6 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 	nodemask_t *nodemask;
 	int nid;
 
-	/*
-	 * gbl_chg==1 means the allocation requires a new page that was not
-	 * reserved before.  Making sure there's at least one free page.
-	 */
-	if (gbl_chg && !available_huge_pages(h))
-		goto err;
-
 	gfp_mask = htlb_alloc_mask(h);
 	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
 
@@ -1368,9 +1361,6 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 
 	mpol_cond_put(mpol);
 	return folio;
-
-err:
-	return NULL;
 }
 
 #if defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE) && defined(CONFIG_CONTIG_ALLOC)
@@ -2939,12 +2929,16 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		goto out_uncharge_cgroup_reservation;
 
 	spin_lock_irq(&hugetlb_lock);
+
 	/*
-	 * glb_chg is passed to indicate whether or not a page must be taken
-	 * from the global free pool (global change).  gbl_chg == 0 indicates
-	 * a reservation exists for the allocation.
+	 * gbl_chg == 0 indicates a reservation exists for the allocation - so
+	 * try dequeuing a page. If there are available_huge_pages(), try using
+	 * them!
 	 */
-	folio = dequeue_hugetlb_folio_vma(h, vma, addr, gbl_chg);
+	folio = NULL;
+	if (!gbl_chg || available_huge_pages(h))
+		folio = dequeue_hugetlb_folio_vma(h, vma, addr);
+
 	if (!folio) {
 		spin_unlock_irq(&hugetlb_lock);
 		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);

-- 
2.54.0.545.g6539524ca2-goog



