Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90FD0C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F223A6B0099; Mon, 14 Sep 2026 13:15:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E85D86B0098; Mon, 14 Sep 2026 13:15:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3ED6B009B; Mon, 14 Sep 2026 13:15:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A9D56B009D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:15:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 12ED31A01D5
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:58 +0000 (UTC)
X-FDA: 85213020396.29.2D3E0D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id F352080003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hsA44xQ7;
	spf=pass (imf02.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789406156;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sfUZiWwJ8aHwUdTktbrmq5NNEj+eJ8NtePyC5az9r6s=;
	b=Xmo/3HKvdMpi1CVrK7jPr3SM/gtn/YcJ4ckQkVonM2E9AUCgw+yn6I7ha8PGvi46EzWcLf
	LI4NNbCebNO9FAJ1ML/9zuj449C4x6rQxFEjUZxHZfaIFRKOxFverXEQErhome7UqcBKBZ
	T9J64rWX1Zr7g2MjiWhIHJw2hX8UsQY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hsA44xQ7;
	spf=pass (imf02.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789406156;
	b=LRY9mxLj/EF13t57oP/7l8FIHNpPTZ/DjmQLkwQY/vK9VyUXQSCcOlqAOVFdH91d3JAl48
	YEXy/oWU372pUgx437/CgBKAkk8TGgjI8FfAnqU43EjLXI5wVyWNd/EYRTnGahODQRWlnY
	emI8lNC4B0BgEdbyl2+z5dggtwlvzjw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 89CCE60261;
	Mon, 14 Sep 2026 17:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A564C2BCF6;
	Mon, 14 Sep 2026 17:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789406155;
	bh=v6q5S1NDfNMBL4jkxSd42kQLlbsw/fbWn+/VmCawMY8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hsA44xQ7wNk5+K3d1oMlI6S62Qub6gTZ7W9I6rrn1wBow2dYD2YE2USRG1W4DegOd
	 64YrM9Xn/vzZNC43vNYHc+Wfh2BmKKGcrEVh+ZLsM/t7gHjqwMy+qSmw8VV+HY09IV
	 dkgHkmmxGYbyyVIyRUBeffCBNY2H4Kw+V3ggSWi9KydYtKpLlf6gwcVLI/jHyZOIyJ
	 vTfcmcaHWlkM7WHFth6tRDcc1b67sDNHr8uidB3iOGZAR4lDGqJ6r+cMcJq6i0bbhc
	 AenWFcdkn0XsTBq6etjG5fK97/zzJxEqsjhq6wH4FNS2jHEa57rcw74CfOc/G6Semg
	 DpZoPS1JkNsNQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 036D7C88E73;
	Mon, 14 Sep 2026 17:15:55 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 15 Sep 2026 01:14:58 +0800
Subject: [PATCH v5 17/17] mm/huge_memory: drop the redundant mapping
 argument of __split_frozen_folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-swap-thp-cleanup-v5-17-39878b37dfb0@tencent.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
In-Reply-To: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789406149; l=2788;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=+E6N2oy8FpNafU2Z3huhtJo7IvohC2gL0cpJrQRmd9E=;
 b=Vkn1vtgDfrbSxsGtxl9d7mfIBkJBRGTQUulktuyh7kBaaz+DZJcm4fsJx7vrh7K0SS0EB70ZJ
 UaRBqz3W1eJBPBnkos8yFgH1tXFyjrFISteDatoWYdmp9bPGOsWhasZ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F352080003
X-Stat-Signature: n8pgiqotsq7wtzx153k39ko3rxn4mx7n
X-Rspam-User: 
X-HE-Tag: 1789406155-638659
X-HE-Meta: U2FsdGVkX18EXYT7IgHEhHkBJkA9Jn+XL0AuJ3NOYuR7qT6h+ea2LER0e0ulUgqEmdB0awvgr8JaFqiXe8RA6/f7yaew5DRA8eTknk21tIOeHw7K+qPGr9TSxNc4HY5/AlHd28XF+SAeS1O2XSsJ1hv5No3tVA3ZiHGopziU2AtfaWE4u/v5yk+FH1dbYdsaWs4Tn3TvV/parfWOkV2uTn9m/gMocFHHb2Cx2kBjYvXcynH+Wne8VPesEgbIDHElf2nwPntIpR/0OyNCAyIHeKm3PGfZNuu7K+YMbp5NyMv+VAxCGYUgPTaPQCL8L5sO7PASoADZpIbGUuHO8JHOrE717+Sx2xGKCExCIPSXB14mdsJAoadRbAh0MtcT7yHm/o1uPyioMrbM2AfQQ+vMOXASg7l0IabZFniE2sXkLRQsZj7tpYI59oP2CgyZmVFV9fm6KwEGwpaKraXoi54RYTPrUTu7UqAYLUUWuGW0EEqBsPLbA/+lk8J9HD8LKZJiZu/hKwQqVp80OI2NnDiK4yCAbgmRJFI1Exd00BH7+EH/iH5XhUW8vV0CaFDdTqhdNPgSvZI31mGJHmGzoOC+x0x028PgKOyiKZxIBiq3P2jpljOfSApvQKjE+XqS/VlhYt0In0ozOTeVcNBzEH5vEmSkdVXOq4zcfdhUvyp7OzQO5HmiILeLgSdU5GJTIuJNp3BSDcY6sIMfxG28/RfWRpIhB/0enBQL8tdVY4ZLfIhD4Vpl8nDiDVBIt+NZzOdzoOpOVrNuD1tdMf0jmlX2a9KDK3JrZf8KZCWk6Kd6CZ5gDjJrlo05xiNXtSzqKDJkBtNKUEscOhPF+OdxOq2qerOG6/ZhkRrokUrTf/iMnW91v1fioZhXGu4nK6ZKrX17a02zBE8iFuxYy24XwhDcIDdW+pVdJ9hbKJMjQfD9zlJJm+ZvYMAt8/iP12naLMwil97xJxLGiUBHXDYMEuc
 EzL2SrDk
 Yq0/4ZKaJTRNTUxe1FvMoE4j2xg9ZWjC4YEL37JaPZ1evLrDq7q3urRS0+qkIqYWZigbz8JUxVUzGIUfBUz9HO8FW3cwFynYU0kGp3IElPn0dSGsP2cd60C2LqtnZovXPawEx5/RiysFDTklqW01rBPLAzPARhg1AJUQ6pmWnVhCqVd16qsJuhlUmWNnfsGDatTkbT9JuIdqj4e65FfF/xQfl0uG3L5R5XcAko+j16QUrtDVm3rA5/XRDw0M3WTjsPEUyBrSWeQJNZyWHmWoIBhaWWKGANTlU1Zgs5jPe0Hymc8bbgEVL4Hpoy07QxeVyP2r0RBKmNZgaQYQLzhJajMg3vgWwdDf5bsC47dwYR4iIvaJTS4p2n0ngV0EJdcXxkQidqzSsGU/b0aiBZJQ7WRX1o+xXAvi488U7dkefOnxE8OxIr2Nw97PAEtqy+Amt8CTj+vwPt0I7qNq4yjf3G8b0IkSWQoQ56n2A8LtixjRbmn8ux/byDzbDqmloTfOfWK2bnnZkCcn5iQm8KspIzeSiM9a0cxLKZvUy9+sLo2w2n0lB5HfK8jolOw==
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
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index fc4dc3f9b563..df84a47447c8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3830,7 +3830,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
  * @split_at: in buddy allocator like split, the folio containing @split_at
  *            will be split until its order becomes @new_order.
  * @xas: xa_state pointing to folio->mapping->i_pages and locked by caller
- * @mapping: @folio->mapping
  * @split_type: if the split is uniform or not (buddy allocator like split)
  *
  *
@@ -3863,7 +3862,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
  */
 static int __split_frozen_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
-		struct address_space *mapping, enum split_type split_type)
+		enum split_type split_type)
 {
 	const bool is_anon = folio_test_anon(folio);
 	int old_order = folio_order(folio);
@@ -3887,7 +3886,7 @@ static int __split_frozen_folio(struct folio *folio, int new_order,
 		if (is_anon && split_order == 1)
 			continue;
 
-		if (mapping) {
+		if (xas) {
 			/*
 			 * uniform split has xas_split_alloc() called before
 			 * irq is disabled to allocate enough memory, whereas
@@ -4087,8 +4086,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_frozen_folio(folio, new_order, split_at, NULL,
-				   NULL, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, NULL, split_type);
 
 	/*
 	 * Unfreeze the after-split folios and put them back to the right
@@ -4224,8 +4222,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 	lruvec = folio_lruvec_lock(folio);
-	ret = __split_frozen_folio(folio, new_order, split_at, &xas,
-				   mapping, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, &xas, split_type);
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right

-- 
2.55.0



