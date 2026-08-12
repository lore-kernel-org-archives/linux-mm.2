Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D80CC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6D26B011F; Wed, 12 Aug 2026 14:49:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3A0C6B012C; Wed, 12 Aug 2026 14:49:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88C256B012F; Wed, 12 Aug 2026 14:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CC3D6B011F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:49:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 878AF80407
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:17 +0000 (UTC)
X-FDA: 85093505154.25.CB0E11D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8A593C0004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lhdCkf5U;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560555;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xxti/a7ybQKd81UvXcG77CCEOW/Mq83/wYWiAPNdLvE=;
	b=i8RciqYqi9c2ar5XKzRUK9bpMaRP51Y+gk23IkARpZJyEt2iD5+GEIk08Y5QH8FGK1UmnC
	Qznt6r44k8kygftAuXmadzcXvYCdmesMFQJ085/BJfrnPwn8rtfE2x3AMqHSQYxYdBEug8
	K0R2QGAW2EX1gNczOF/4zUt0a7aLH4Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560555;
	b=JaudGLvHwzsZrwMyvemU5IjzfshFhWGvAKj1SMF5n9q1t3pwMTbJTS7aXH9d0ESfR0+TSP
	13R9XVN+KdJpWRrXvytjRSEZyPdieK4MIRZn/81J52hCalbzSaM735YZN9mYSREbXw46DT
	dM+QOBcVoBzE5wBFaJR/pXYUPKyjO+w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lhdCkf5U;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 00C2443FF1;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D66E9C2BCFC;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786560553;
	bh=xDAXyFedhHqx+fkH4wboKUAlsd2gNOQbse2PN3z3vw8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lhdCkf5UZJIewylJAEdVc9UdgindTSn+4hKUJd/GvF3O9HVTfIoTcsYskFR7O4Kyu
	 FozSCimR+RCfQT9AKS0E5sQhqus6Ya36nS5ZhMy9g68FdqqPFW/QEJo1BQ+IwLyS0B
	 oScGhinhbUCbcrY++s20hGiuI6QbfY5+8dBDUH2QOJEkV9gUyJnRL6WjngO2qSy2c1
	 BF2OQ0u30mXNp5dlKo0GFDZlnqEq7gPDFRUklV+w77cao7S7k7JlJ6rStlMXhZmw5s
	 epKQ4SsvpivCgXD1bpjz1hw0qhvcktM7stfBQrLSuUPCLJMMWNb92IR7h5idO70SxE
	 M1n4mHcCWPYPw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C25BDC5CFEB;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 02:48:45 +0800
Subject: [PATCH v2 05/17] mm/huge_memory: rename __split_unmapped_folio()
 to __split_frozen_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-thp-cleanup-v2-5-d2ee48c6aa49@tencent.com>
References: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
In-Reply-To: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
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
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786560550; l=3653;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=4JjolaupwqTSBLBL65mRa9wmeq9w6In5IrkOzFf5Yfo=;
 b=PHakkmQPHqY39DyzfM8bL3N0JcH49hAnhiemotbeD4OEWgIRduaoR19O8xiqfC1GegF8t58WA
 V373ObQRPxvC2AazrS50uoRBCj2zFpBrAYxFJeJRNzvTQ0Rm2jNeR7S
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: yaexe7ar86s6hbrij43uheuk5wxfpkpz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8A593C0004
X-HE-Tag: 1786560555-646660
X-HE-Meta: U2FsdGVkX18zL1es23ay1tWd+kzgUWi9XlyNfDm0kwwgnY+zl8uXNVpf3BKvjcpfTQlm3sGfRQUIXzQAMPP0MeOTZ2CToKJnSxZnZFluGjoZxQMkupcw35N7YDyo0MrnDvAj5PSgJG1qeEF5U4Plu0MLP9iYq5OQffh9yRJfEd2eEzm3EV4+uZOnHJrwX9SDYXRoJldUI+KCRhxU7oTG3jk91gDgjWrVrcylugs5Q13stCKA7kmuAer5evwY4L1btYcjDl6R1lkkWaeWCvzeCJogZva/6eo+gKAMgNPuQgYQGCEP/6sTO/cb+66Rmdws80bQBjSxFyBBxUpLD/Ii85WsHvkVoOE8H80UlXFvRWZEYnZkHw1Ld1QjAg6k6zEq5/1TiAdoQmFPz40gYrak1iPRrYBylaJt4WKUthwa7qCJATaKwrMFuSoVm4Wco6VpB5YaGBM6s/INPOvqsQGqo8IMK5oqEb1FUeI5sUm4AMtdFhMmFxZdfLNA8vqa9xRPRMr42CxcToXzj7rg5Wo0imYkkChM/3RKsFJ7EbYF3He8JanfOCd9QR/nXg+BbXxzlxEFncZlkVPkkk9HID8GYh1qufUSHvUxPcgSxOAJ9t+fy8m2LOYCszYGJsbT3M/JEkCIawqanTMGu7ZlUaPH8sbGECH3TgOqdLFzKJy/yYcyTRtFED3Kpk5dyjMplaDDmn4dQ/IQDJGV2nOZneEPwmJG0fFeq37pTnOBlu/oXghBgrDHZPNFv4QO13SGHWZQQwmx71aiGUKBHFbKUIVNfTCdCkdhBSOxYoyiJyJ07/smXs0vh4UG8N3yTa8DJAIOnccJK+PDRrJMaVZoiHo0cZMdkEtXF88NPUZj6Pkl55naVSmGixP2tvbKE4mvDvNem9jEznSEbSb4z3niKlO6ChUKOMmBuZR7rw+ESFefNZvMPgxeeQ+ABUVnAV/jMEeP0rTJ+NA0jxmb2Sp4tZT
 0/4RKOXV
 b2M9+kZPPb8DeNRbCaaqq8HlTROP7h6HNlOquanMmwQALjiPPzUWvEvvkatwxTR3ZKxpmbDdsovjjOakKq7z9ObguZiTOn4+ZfG2aXh3RrO1n3ur0h7LhSDynir4pjZwufHNVduCl06WlQr7urIGKBsoLtRcbsZ2HitwwOVBFvicwNjQ82xdfqHKI42Op8Po8AoGyuAydbWAjiQoJmniRsDTX4bWozaGL5rboOSKyywWbY03xMpSycyEUZLfysy6aUu7y9sr3z//5mUOSrZe2A5nisdyCyn+sb9SrhmGdSrgzS5csW9LxAuHJH/9Cj3ZWaRldkibtGZApN7XGf3drxDlViTbV22+BUbwPBYExVzdNH+e2zK5lxG0DyMORruX7BACqrxPOlj+bsNhN6t1hn9MizoFwg+XR+VZMsgFEDM6PmVK14WuZDGWnrDKCD4IH2CrJFlmKGALpYOqMnZCU7I2mrCJQTui+fpRQ
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

Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7587eeb09e4a..dfecb93dd64f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3767,8 +3767,8 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 }
 
 /**
- * __split_unmapped_folio() - splits an unmapped @folio to lower order folios in
- * two ways: uniform split or non-uniform split.
+ * __split_frozen_folio() - splits a frozen @folio to lower order folios
+ * in two ways: uniform split or non-uniform split.
  * @folio: the to-be-split folio
  * @new_order: the smallest order of the after split folios (since buddy
  *             allocator like split generates folios with orders from @folio's
@@ -3807,7 +3807,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
  * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
  * split but not to @new_order, the caller needs to check)
  */
-static int __split_unmapped_folio(struct folio *folio, int new_order,
+static int __split_frozen_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
 		struct address_space *mapping, enum split_type split_type)
 {
@@ -4001,8 +4001,8 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_unmapped_folio(folio, new_order, split_at, NULL,
-				     NULL, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, NULL,
+				   NULL, split_type);
 
 	/*
 	 * Unfreeze the post-split folios and put them back to the right
@@ -4063,8 +4063,8 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_unmapped_folio(folio, new_order, split_at, xas,
-				     mapping, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, xas,
+				   mapping, split_type);
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right
@@ -4124,9 +4124,9 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
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
@@ -4229,7 +4229,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		i_mmap_lock_read(mapping);
 
 		/*
-		 *__split_unmapped_folio() may need to trim off pages beyond
+		 * __split_frozen_folio() may need to trim off pages beyond
 		 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
 		 * seqlock, which cannot be nested inside the page tree lock.
 		 * So note end now: i_size itself may be changed at any moment,

-- 
2.55.0



