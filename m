Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78540C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:12:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 473496B0092; Mon,  7 Sep 2026 14:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FFAD6B0099; Mon,  7 Sep 2026 14:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 208B26B0092; Mon,  7 Sep 2026 14:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C92516B0096
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:12:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 598DD40281
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:19 +0000 (UTC)
X-FDA: 85187760798.30.08718D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 50A8340004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s6hVUIqA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788804737;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7Ac9VR7HcvaFd/KtXO4vLgB/vM/5PlcNag2KK0HWrI=;
	b=GBj4H4FJzuNl06UTN+7pLOVG09FQZs8q2yA1hMQ3/wq6j+HivMRkiZkbxQ9BSxnxPGVP+G
	yGNwiFVnzoZ3EogvPO519DPsqGGA2A++GW9JD4lIhutXk4oh5o998NOMZoJo88mfnTv5NK
	3SOhSmb88Kq7Fvl4L06PF0ObiPhVnwM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s6hVUIqA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788804737;
	b=VNMiC1DDNiXD8IExpRClQbvT9ywc6BinttDIcmIkiQ/490B42LudV5lTi10OTZ2I7PCnNo
	xJrQH1z4ZdGNBTFPivWS4FnxslBaChf5oJ44YUUmClO/vsb+GiChLF902u4/vOimZQAP/c
	OxTh4jSYRyVCxisqiBwtklQq5b2P9XY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C74F444ED;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0DC61C2BCFC;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788804736;
	bh=K1e7htnY/isOkcfxTMCbkRGPSSouWnsnU2rQFgEN/qU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=s6hVUIqAPeW2jZVJcnMOvpUUgscI0LQaBVFkzOLulANDu+kSwpjA0cqUi44FjLaV4
	 cUzcsW4rZP1echBI66oKMjNkl3eiXzy/f+jPaLSVpj917wBKWCaZGguUdQuMtFdgjD
	 paKH2bVdtiUiN78yHQHWH4l/8/AMcvEH6v4fBz9uMiaB8+TiYadYdFmB3U+USnjnfN
	 3M0X5CYX66MX5F7r6hSkJ+zoitwD6df2ck+6zUQAHzPG5XdhYRj73P3GgVKssi+aAU
	 A3tNcThq5NeSsbtTBCjkD0uujHy3levCPE0tF+2OFyDPiXU4VTwY5r45aXlbjiK1B7
	 oq8Manm2eDpAg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB01BC79F99;
	Mon,  7 Sep 2026 18:12:15 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 08 Sep 2026 02:12:09 +0800
Subject: [PATCH v4 05/17] mm/huge_memory: rename __split_unmapped_folio()
 to __split_frozen_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-swap-thp-cleanup-v4-5-b532a3f20e71@tencent.com>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
In-Reply-To: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788804732; l=4226;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=8jugUiqqC1QVhhoobTnFHgSZS/cT933y7hBRNZpc0W4=;
 b=0nvoYfPHFfpr/NPg/dullsm9XbVnEHETJwtfP8R+e+MswKQP8zAnkn2TrQI0n+/7jcXbHPQMp
 0dDjzQOTJc2D1iwFUfRXZfYsm5X47NorICKmmeWDkl/vu9jVT/3el2C
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 50A8340004
X-Stat-Signature: aki9orncue3zjdkamk86pqh14nmjtcf4
X-Rspam-User: 
X-HE-Tag: 1788804737-403584
X-HE-Meta: U2FsdGVkX191/IAPpAHVFVIXHNqcFS+WnD7v2kvHsfD+YwzUGln8f4P+rFbJX9/JwRdLteR8+CyiI6xhSms0icIXmq7qNhyI42R2VX57sPIPoYqL6fn2m/qaEjTWO/UQ6XYhWgHHp9/qt56B2CqRzzo5jvd4IuTInu1b2Ukg4TaYTnfCAEc0Hg1IP77rLGo55qhFh9rP0xSBvPfwKESz11ej01M0zaSze9INlsQRyGHrwP1rh3F9s8LBkXLTwOTvkplncBMtU9HGHKbjEwLPyYlVZ5dpU2hi2QjZlwq0W66teOjr2CW7QVKFSAPV+Oh61sgSvO86P7GlCoX7TXJ7Fk8wYTioFvaLuNDXLmCHlhveOubl6jhzMMhCeom/SEqbyWONQcLPY9kwRVmG57fp1njjyFGTEkVnH8m9yZDUBmoeG9bMRB3BphHSMoMeOChtjdV9/x53rWTLKb45tXiQFrOOxB4sXp8dOjzAqpLNdf11W60p1hy57QnZfZhFl6b93bT3GS8zIfAtMM512428m26Z5Cp4ImGs6/qABMDd+3GHw4RxSpRa61CIN3Ukgbx+pRUbFwcq/w34mCGPrNeWqYx229WIylJTknU7istquBzrWU4pycHP7fCr2q3VgQlV7+eDDWDL3D4iS8zG2dfwJV49pmq+q+Wr0pvWARqC06KucCc68spw2NHgKi/py2+P/cxREmbWVuqD3WzJDmlZLB4PaFwFWRtD4hQSwcGwSzwIZG7Nh8I4/jW+2+y2BVTeX3oIYqisKPKIvUAPb4oLzL2cCbQkEn4Iv9eyLapBdE5CPR4cvGfMCz59jSKJhBIQ1LvBxDQwbxEafUysyH3Ebs6POAA6IcMM4gVtUSGtFqVW0my8s4PxrXBYB8uea6QVDAfF0Jn5SLASVNwSnnCXNQHO0S8gap/rrRll+AJ5OoC/jf8x86l3k45PJymMhHbCt+vUVOvK+xn4JmvNb08
 nvfdtz3b
 49PpvP127rUoopwVddt2FDFXtqN+T8mw/2k6erN7Y5ImYt+rnlwWja3Qaa8bAz0GjSW416Pi8LGlaKn6/sY7oXV9kXHZUTmrT6NjlvIydJ+6IQ5X4qr/UrSD8nyyWaUJNpZwJ40Apn4b9lacTmH1kZ5IQiCJXU0hEoyMirlpzjCOsajBsbKqj8/7aUhI3c5sa+D4V9qu1XSRt894DVmWEnmmxnznLgl7IlDqkdPZ0upVQaRdaSqgbd6M5xCMIxbq1pLY7BMwMtpjg34SK/JOnjtgMjnpsu28xnx8CHMllIn4DJWx8ptPueTxzsfeMa4htbVEEQoCZ4KcpABCl2JZuyGr3uVGX7N1bMp3qglo41xWB9OzA32Qf61Q/96lze+9NPSkh43516w0dPNnpx9EeC+SIu7lTYl4iWAIn8aRR2bJI7bSQk2frcaR3Efui+AI5C4iC6lJPs3BpR+8ZL6emTxoUGu09Hj90o3oCyPFRoMCRBp4D6Vs8TzCradVk7DjhNcmiqCejdAXP4BCygWgp53N88V0YOwErc+H3CckumTEOE1UIcCKTmym7mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The helper splits a folio whose refcount is frozen: the frozen refcount
is the state it relies on, while unmapping is arranged by the caller
beforehand. The old name caused confusion and people may try to call the
helper on non-frozen folios.

Also add a VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio)) to self document
that frozen implies unmapped.

Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0e28a3e66b67..80291fac78e2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3806,8 +3806,8 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 }
 
 /**
- * __split_unmapped_folio() - splits an unmapped @folio to lower order folios in
- * two ways: uniform split or non-uniform split.
+ * __split_frozen_folio() - splits a frozen @folio to lower order folios
+ * in two ways: uniform split or non-uniform split.
  * @folio: the to-be-split folio
  * @new_order: the smallest order of the after split folios (since buddy
  *             allocator like split generates folios with orders from @folio's
@@ -3846,7 +3846,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
  * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
  * split but not to @new_order, the caller needs to check)
  */
-static int __split_unmapped_folio(struct folio *folio, int new_order,
+static int __split_frozen_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
 		struct address_space *mapping, enum split_type split_type)
 {
@@ -3856,6 +3856,9 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	struct folio *old_folio = folio;
 	int split_order;
 
+	/* Frozen implies unmapped, callers unmap before splitting. */
+	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
+
 	/*
 	 * split to new_order one order at a time. For uniform split,
 	 * folio is split to new_order directly.
@@ -4019,8 +4022,8 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_unmapped_folio(folio, new_order, split_at, NULL,
-				     NULL, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, NULL,
+				   NULL, split_type);
 
 	/*
 	 * Unfreeze the after-split folios and put them back to the right
@@ -4086,8 +4089,8 @@ static int __folio_freeze_split_file(struct folio *folio,
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_unmapped_folio(folio, new_order, split_at, xas,
-				     mapping, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, xas,
+				   mapping, split_type);
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right
@@ -4151,9 +4154,9 @@ static int __folio_freeze_split_file(struct folio *folio,
  * @list: after-split folios will be put on it if non NULL
  * @split_type: perform uniform split or not (non-uniform split)
  *
- * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
+ * It calls __split_frozen_folio() to perform uniform and non-uniform split.
  * It is in charge of checking whether the split is supported or not and
- * preparing @folio for __split_unmapped_folio().
+ * preparing @folio for __split_frozen_folio().
  *
  * After splitting, the after-split folio containing @lock_at remains locked
  * and others are unlocked:
@@ -4256,7 +4259,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		i_mmap_lock_read(mapping);
 
 		/*
-		 *__split_unmapped_folio() may need to trim off pages beyond
+		 * __split_frozen_folio() may need to trim off pages beyond
 		 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
 		 * seqlock, which cannot be nested inside the page tree lock.
 		 * So note end now: i_size itself may be changed at any moment,

-- 
2.55.0



