Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E7D9C5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BB1E6B00AC; Thu, 20 Aug 2026 14:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F6FB6B00AF; Thu, 20 Aug 2026 14:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 221746B00AE; Thu, 20 Aug 2026 14:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D553D6B00AA
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F2EA1C0B4F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:34 +0000 (UTC)
X-FDA: 85122551388.14.C59857B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 74C6920006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BO/MEsuR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787252132;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJg2QG+QWc8sEivDkBpAwBnMcv+m7aiPssG+kRrUhXM=;
	b=QdA8y65bn/Qn78E7jFrFiYJiZXy52tloePZ/0jUjY3BSeYCdPF6ZpAWGxiptD2wUnvV/+o
	ZU1dFTQNjlJn/amc81xxdmSVMK6aKQTzd6e3mkj6MdebjDJLoWtGQ+na9hEoEdBBv3fL3/
	Kd/SqIchxS2CjGS45pD/Zm5GZvCUi8E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BO/MEsuR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787252132;
	b=Qoew+DZ/3I2eA+16UDviGZ1iJi8hnQJ7Rz+PV66Ax8xYmBJ4L3itVXUuOHxYEG0mFEZ+N1
	6byplh/4rtuTZIjMbVTBwZEo0YCgiN9jw7YptO6KpAbE/Wkf1tvYpUaJ/Sz/sYzqBLDkqz
	WmNszTN9gfTYU2dPlPRgj+mpH/BALuk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB11344415;
	Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8A1F1C2BCFC;
	Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787252129;
	bh=F/veNG6x4bSM+ZHU80+kOOADneaHOKiDsvyy52Z3utE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=BO/MEsuR+mhu/LBzLZD03DI3O3i6aivmWCCW1BF7O2XgfSVBeQpbNL/mGgu7L0qID
	 cwsvv9bR64J0byIxRecIrHChf1XKadwhsxIwAAyQmcaZpH7UCMAA9jEjkYYBUQ0sQG
	 cwiayzhQNHsvKkj9vbT4dVMm6jlaBDqYUQvQPZ2k7cmDHX4HxDZXbXsonCGT47C4+3
	 rjqq1xVUuFMTMzyf/84rpSxsVeurK1Fmp6mYgORGhBXQqwciscIGarcHl4MH/ozGjZ
	 /8AxujBPgj69K9x3zsKz0cac5jFCBUTpxzLw2btV5V5oWWGLIjDiE7fAMVEQ5o4bAZ
	 +GAO28KIUOrsQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75984C5DF8C;
	Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 21 Aug 2026 02:55:26 +0800
Subject: [PATCH v3 13/18] mm/huge_memory: drop the unused do_lru argument
 of the file split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-swap-thp-cleanup-v3-13-9b43f5163238@tencent.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
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
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787252124; l=3118;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=s7TgEALmkIL/2xL5mg01PDrva5N+mct9TklI6TyUYnE=;
 b=V20sD2oW1vdDGjcEea3QpexdnTRqM1+FRJ1Y9d3JudIe18U9Ozqj32oILE/ceGqodrSPBNr20
 cnQAa9oupwxD3cgcv/ggE5vKkEip3RSbrFhumT7Zv0LHHDmVZiRySlR
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: tmawk74ojhrd39npqpp5zeem5rfenfu9
X-Rspamd-Queue-Id: 74C6920006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787252132-264914
X-HE-Meta: U2FsdGVkX1+RhFFlm+9lulxI+LQUom34TxrD5hvaLCETJcUAEJhfx8kWt/dTHukxO+6d9TDiG3BoF32UR43+rJD0J2UpBtHD1Y9X+QwzCNHnI/qyX9+1gSUDou+HwGmIe1Fmv/Q0r4IFSdJicZVRxhdms91iPgr3JPjLedFo6wh8wsUuxe5emvoaBVUSRxZwuXib2PGge/HHs+XrAddo4lzXjwHkpuY4K6VOyQGJ9fz7PlPMGA+9Cbk4TQb4dsXkU+4GdPZeUyarpWTsidCBv2rbBhQArPMYjEaSBZOB8OAhXdoExIhNBYDk5q7RYq0a4U97htC3EVh6V3jFeNVp/Hdr3XJ3Ui7CHcgZg5kjTx/RjHDOrZ+5jwxMZzNifQw11bbLP1RC/mP2xHdtnrV7oTq+3SKK0UOhi9Vb1kstrbpKTa2QdkuMvtSdHDXvwjOoL9DrsM3qO5fI/DNFImJGrVV7EX833RhVdQ8ZrB9SRfBdV1pkoWNFb4mOCgfwgJG0g4qO61IHhpd8kM9sOgtCTA1VyBQkgCwrbBnnyb4yWEPGfS4hFLmb1twgK1jLDCXzk2jerHs5GP53iJ5HARy+5n/kRVXs+pttCcHQM5BEJJtct73oGuP/SRpVVleaTA6fhQlHyhhb+Zrte8v9WPG/NScy0cWHzpaJy//ssUH2UCuVKf/uxXE7rCEoUoCm/Md4Ua8jvPAe7BZGKkCuFtu3QAmptgMDnT9i02MS7AeetbbopRYbdaKxERZPAUtpuhAjFBHBgO0uRf8LE3wx6JZ515i2BKWE/VfJF9PocVlKxXnvxKPvBkGB9DY8raTgAdXh2GS1veVzCZSrQ9UUX2AwqClJC+pFCV8vpjKi/sX+1DQT+fLkfAcDKvZiqVNOq2U6gAkV7qbQw7fDUJ5egyBJMUFMiQzsUN/y4XfzuYJ9ZQdlfOH53GWtvLRtREP1jHxsGxGHUFnsD3PvH3Dnfw+
 FI2d4QGl
 DA+UZY8g0Cpb14TDGuEReIs3eCrLOEWId6Ns1R2dz7wQaSM4KQ2kVu/MW5mV41uFjlFlfeELBqvzxxSE1/2BI1NYie/nitU9RjcgsVaOvK4UzCdocFKpUWln0hiLN7PUG/syhPRr2sGCHTpy6PA+4RE5unlVO4fS0AbyquibXUy8KYYGs/GMqrHoOhsbWvPPflJTGCkft9crd7QUyEpS0tHI+qM2AJaFr5/QltEjDxpG9l/Vf0bSsmY24oJ4Mxfix3WIbgveuVFaQEmXTHrpMXjy3fkstoT/EdxBDZE/qXiE50ykcMaVLZeeqmla/c3y6r+A3FfEQuMdcLrxhlbiISfCSjCz/VnbIIh8TFrUgtsq30At7XlEXxU5qZEzXrdO9UfL22QJSHlPyFcDm/ebrZ93BeuLEokJwFNUZWfIsVLSj+VnvAWO+LxOd+iXYe+UlpRi4+GE9bHVm8no=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The only caller of __folio_split_unmap_and_freeze_file() always passes
do_lru as true, so the argument and the branches gated on it are dead
code.  Drop it.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 72b364a90062..84c6e4bbaa88 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4087,8 +4087,6 @@ static int __folio_split_unmap_and_freeze(struct folio *folio, unsigned int new_
  *             smallest order of the after-split folios (non-uniform split)
  * @split_at: in non-uniform split, the folio containing @split_at is split
  *            until its order becomes @new_order
- * @do_lru: if true, add after-split folios to @list if non NULL, otherwise to
- *          the LRU list
  * @list: after-split folios will be put on it if non NULL
  * @split_type: perform uniform split or not (non-uniform split)
  *
@@ -4100,8 +4098,8 @@ static int __folio_split_unmap_and_freeze(struct folio *folio, unsigned int new_
  * is returned, @folio might be split but not to @new_order)
  */
 static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int new_order,
-					       struct page *split_at, bool do_lru,
-					       struct list_head *list, enum split_type split_type)
+					       struct page *split_at, struct list_head *list,
+					       enum split_type split_type)
 {
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
@@ -4196,9 +4194,7 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 	}
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
-	if (do_lru)
-		lruvec = folio_lruvec_lock(folio);
-
+	lruvec = folio_lruvec_lock(folio);
 	ret = __split_frozen_folio(folio, new_order, split_at, &xas,
 				   mapping, split_type);
 
@@ -4220,8 +4216,7 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 		folio_ref_unfreeze(new_folio,
 				   folio_cache_ref_count(new_folio) + 1);
 
-		if (do_lru)
-			lru_add_split_folio(folio, new_folio, lruvec, list);
+		lru_add_split_folio(folio, new_folio, lruvec, list);
 
 		/* Add the new folio to the page cache. */
 		if (new_folio->index < end) {
@@ -4247,9 +4242,7 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 	 * and its caller can see stale page cache entries.
 	 */
 	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
-
-	if (do_lru)
-		lruvec_unlock(lruvec);
+	lruvec_unlock(lruvec);
 fail:
 	/*
 	 * If we want to use try_to_migrate() on file in unmap_folio,
@@ -4333,7 +4326,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 						     false, list, split_type);
 	else
 		ret = __folio_split_unmap_and_freeze_file(folio, new_order, split_at,
-							  true, list, split_type);
+							  list, split_type);
 
 	/*
 	 * Unlock all after-split folios except the one containing

-- 
2.55.0



