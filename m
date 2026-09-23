Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E82D2C9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517116B00A4; Wed, 23 Sep 2026 17:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EF016B00A5; Wed, 23 Sep 2026 17:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42BE56B00A6; Wed, 23 Sep 2026 17:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 178E36B00A4
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:32:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C49B12013A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:47 +0000 (UTC)
X-FDA: 85246326774.21.8B8F477
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4F396C0008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YxAeVBrR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199165;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wkHN2XCUPY7WsqAkh8Poa65wwY73gsTtQ9LcqWe/6/o=;
	b=RfSGXoIyysvK7DZH6AW7VeM5fNhRncQ5c1TSlvnWK/J/NifsYTJoATBNrQJOYYE18J52Ds
	op1UeIjYLTUaXBubWL6O0KQKBVNkP/Ghai4z9VSk75IMc75CfbEHcUaoeP0JPyhD8WVndz
	wsw7ydSvvJfj0HC5NXxUl06oxF+laNU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YxAeVBrR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199165;
	b=cki4309CRU1Fhkl/fwOvFmgS8sZJc9kckMVWZJEl52jZVk2KkTVIz0lxNG/xng6xOk/MMG
	hj9gaPpxAS+cxhweBhQu1wSaeA92YD0jqfSNkK2fsBM5isjHyO95ioQ75durOdFU8sXhV3
	43u5pQfnXs5ZFiqXJ6txGgvLXn7BXFI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B6CD46022C;
	Wed, 23 Sep 2026 21:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 686D5C2BCF5;
	Wed, 23 Sep 2026 21:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790199164;
	bh=VCcgX9Zt0Ud9YgxqYFqd3Iy4Vbv14vrCAHPv6HfCCTs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=YxAeVBrRanLAGfXVedme9BHiS2iAavj3ObSVBg6J8RXgs4wOE5zNKgxlGhbYEZNLW
	 j0rfVwXgZGSZlqoFJuKG/YA6nm8wi2Xs95muRvOZ4d3zCH8wFoUZHZhldMCUws5wEX
	 H1jfzNSwYpqYYTiag7kWS9hhUvtIP8t1imTfmxD+Q6tCrHLIWpcrSHUiYGDJtdFHQJ
	 hFbDbYNPxNJAuXgvdiBl73oK/1eeyEg6eT5ZxEVrSOL93VhwbheqUIEVPqjw0g6y7u
	 6YGDOIG88dS9BFbgqMZgVUil1tNE6cg1GZBfYvtmJf1LxmvOJZd50TOHp3uVJBI3GZ
	 m7C71j20OD6Zw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52973C9830D;
	Wed, 23 Sep 2026 21:32:44 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 23 Sep 2026 23:32:48 +0200
Subject: [PATCH v6 17/17] mm/huge_memory: drop the redundant mapping
 argument of __split_frozen_folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-swap-thp-cleanup-v6-17-ba1b4ba72c6f@tencent.com>
References: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
In-Reply-To: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790199160; l=2842;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=oJuA6piE3d7PEesJP/+7GrdrNMc/XlosPlQGEaGrc3Y=;
 b=qsTJuWfxYYH4Yerg2qYGzB6xSXXLGUpTM1l3XsXyLjIutCI2Os1FniHyi8KQqPuloo8hkH7zF
 4bHfDxkVElLCEJtHufe36HFJzFEk2gsuIO21CqpgJmP7yRZRyk7wCmT
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 4origq7xq4m4xzurapgb7c1x1aztjksq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4F396C0008
X-HE-Tag: 1790199165-820323
X-HE-Meta: U2FsdGVkX1/QHRS0e+dP+bLAYJWaGv+IFaA+LIji2qN1BE8nb/nZ3HkIve2OhLOrBa2Thtu+V3MqGj0OBTNDQ59zp5FDoTotWdCmllAcdhoeDiJHMLcDSqMMSBx8hh+5V0Tecl9WdChEGVbJRQ1Lq5Fpy1+QFcQIZSpU51srHs3TVCKaVvfoashKz6iQ3m/+QhXxQuqaAcWIaAk16lg1QIl3ZXQGvu4LGMsyvNCnJ8TN70xHbkqz/vkCAXbzt/x+S9j7/niB4a3wa1Xji42lxIRR77C9k/hzGNq7qPvqjZnrPulmSU3BoBEiGhWsiaa+hzuMCmjCg3HR36Sm0yvE5DtMOeHQm3iZTdC2Ay87f6y17CW/j2C8eSNz3GKYM80DG6nOCU1d2ejeZs2+sxHbJrsi5oWcJtWKA1GSrtSMqGZKfp2/YoczA1CEv5BGcXLlS1tOyM+g7iENLFGIMteqZrlBRG7MBM2Qr1S3O7MIROdXgNT1qVJN1fZfYG1YuFo5y2ZqHNN3ndDySb7CxtWMBhaVCe0dvkgokZE99PgCmLd9I5dYsXj/S5/OSmA+ABpj2lHpFryaXNUagufFXy7oB24rTy5keVHGjvh2JB+fZjeFC90qUJN+2PGoS1yXTnkjoJZ7BVIYesr/ZuKRp6lCzGwMATOSbXKb2aB7selvMkQM45SYIMZfnlvaWShC8afL4K29AUnBSnJjWKpmmWcQqOirJaAjv//T1V+/+UXtRCyS7N6jNceeZAFsUX0Cn0op0iQfqVuP7QAS+/t20DkoInqf6oj/mYgUneFpGqn0N4i8gQ7aqYvOViOvXyfc7Ct1JY2pbj2RGw9iEc4fzNpyzqZGZdMwtxK3mj9zVgi1ilXarcdZaGzdX5pL8Tlr/dPS/kTk70aO5/Az1dk89hirqUWON7odY/pel5Eo6Y6+CC3y2SB9bsETNk77VrSO5iSAQGRnAk072exX+cyM3mi
 eHAA0oa4
 8RecbuRH1DHAMjnhvVYS0OHhQy5F/u7xtPCmrAg9wEuT14GrSCgthhFrcD0v667016+U8y6nPiw9A5TKjAi2jfUB03dG/u38lksPybbq8uvk+5nTSvg6BR5CeSYqPyx93vFb4lf9ioTLJ3nyPI0ojx3nmlKwo8w4GcUOaqfFv/vtvmknb2xLbto5AjXlKKSQYOPzvaSYKLtB1i9yJ5DQEJB7TAVgZyg3UcXsUNd/4mIj25n2TBHAFEC+D8QOI2PLLnxQ3pzBwcq7LXKvPH9Rs6YyC7Nx/8q7rHnq2KcIltRoizUCSo0h78fk+l9HWqQSWTBPS54/gnUzy1xgENYvC/7hfbAl9pWDowxEEIVZXrvwznUciRK1fNC8xz8c+Eu9MmUpPlu038nbwrVcIZl8YdtQs54q93/O/93vWX4VWQ8krc9YtuUXispjHP/1mVh03OHPZA5J5LGzw6ph1aol4hPYTw9Pp4+JZT7JD7gY983PoOFAGf5juRqkHw2tbLIiMQ7Gln+IGac92wHX/arSB46fM3O8cj6fnomNx1nIn529MDwqiHKU6l559RA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The mapping parameter only served as a non-NULL check to detect
whether page cache entries need updating.  The xa_state pointer
conveys exactly the same information: the anon split helper passes
NULL and the file split helper passes &xas, which is non-NULL iff
the folio is in the page cache.

Use the xas pointer instead and drop the parameter, along with its
kerneldoc entry.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d31c1d3d1f8e..16b142de5008 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3833,7 +3833,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
  * @split_at: in buddy allocator like split, the folio containing @split_at
  *            will be split until its order becomes @new_order.
  * @xas: xa_state pointing to folio->mapping->i_pages and locked by caller
- * @mapping: @folio->mapping
  * @split_type: if the split is uniform or not (buddy allocator like split)
  *
  *
@@ -3866,7 +3865,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
  */
 static int __split_frozen_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
-		struct address_space *mapping, enum split_type split_type)
+		enum split_type split_type)
 {
 	const bool is_anon = folio_test_anon(folio);
 	int old_order = folio_order(folio);
@@ -3890,7 +3889,7 @@ static int __split_frozen_folio(struct folio *folio, int new_order,
 		if (is_anon && split_order == 1)
 			continue;
 
-		if (mapping) {
+		if (xas) {
 			/*
 			 * uniform split has xas_split_alloc() called before
 			 * irq is disabled to allocate enough memory, whereas
@@ -4089,8 +4088,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_frozen_folio(folio, new_order, split_at, NULL,
-				   NULL, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, NULL, split_type);
 
 	/*
 	 * Unfreeze the after-split folios and put them back to the right
@@ -4226,8 +4224,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 	lruvec = folio_lruvec_lock(folio);
-	ret = __split_frozen_folio(folio, new_order, split_at, &xas,
-				   mapping, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, &xas, split_type);
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right

-- 
2.55.0



