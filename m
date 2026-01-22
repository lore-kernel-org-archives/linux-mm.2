Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1664AC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 03:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68B046B00C6; Wed, 21 Jan 2026 22:50:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6629C6B00C7; Wed, 21 Jan 2026 22:50:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561AB6B00C8; Wed, 21 Jan 2026 22:50:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 422186B00C6
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 22:50:45 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD36013CD72
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:50:44 +0000 (UTC)
X-FDA: 84358223208.29.ABAAB0D
Received: from sg-1-104.ptr.blmpb.com (sg-1-104.ptr.blmpb.com [118.26.132.104])
	by imf17.hostedemail.com (Postfix) with ESMTP id CCD4D40006
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:50:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="HD0nDxR/";
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.104 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769053843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tUa5co6on1U0IzQ0RKE/MLpqVY6+mYgKaahledzzgqw=;
	b=JdySB7cLs00+bBcLY1lAuxAgdd3Ex2+SlkdpkGLxATUsaUnANi6nWZ6dkqHFwV/VZP4MDk
	CisJwix4S3hkWLaIX5dBUwzu/ELqzJc7aJxlOQKWHtZXCBT/nMOAL7Cn4/34/XF68w6rXj
	AgJpb/+01QzBt/5llQGp6lbTm6fk8p4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769053843; a=rsa-sha256;
	cv=none;
	b=LpUYDkD7FdbLj6U2H5aMc5FcgvLonAW8v6tkOsqVZ20aPxoGQpZebpcy+RCpnD5vydWAOw
	I2A7UL/9C2jx5ftVDCcj7qW8tNbDjdntkUcWpjw9QuulU2J14JKTdNjJcbxGbSN9peVzR2
	yv+TyJieh9Mx9GXsU8BEtTOp1wIu7ec=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="HD0nDxR/";
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.104 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1769053827; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=tUa5co6on1U0IzQ0RKE/MLpqVY6+mYgKaahledzzgqw=;
 b=HD0nDxR/guTekd2FFt47WR+VKbCTevshGyMTlSkuZkrEa4ezBSNZy/zMVWr2ledEV1ZNg6
 xVSKEYhI3GgwieP0bF67e+caJsjUS54KiodMs7C9g4A6I8NIREh4jStTsWoomA8tBy8jvw
 1kQKj30RcPL9aoHpyC3u7JAsizMPe5GslbjDTeyVJRct+OCqc9SS0sFAB138cSsaBuCG+J
 m8BTgogiFm6KWz10qoZRUyEPZd4Z6ca8e5dpj6UtnOo5XcanqilPHUFD7jc7cFWunS8gq/
 W15GAsKWc9oGjAi/9ijf5n4YCyKHrRBjBNUS66axjzStz1a5K+Ar5gq4mP8oww==
Date: Thu, 22 Jan 2026 11:50:02 +0800
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH] hugetlb: increase hugepage reservations when using node-specific "hugepages=" cmdline
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+269719e81+abb9c4+kvack.org+lizhe.67@bytedance.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>
Message-Id: <20260122035002.79958-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: CCD4D40006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: bgtbr1mpucfe8px5cfqe35q9jn5t6pk7
X-HE-Tag: 1769053841-314931
X-HE-Meta: U2FsdGVkX1/FZlAQQ/Fw6P9ZfnAOajur2QFjp5+VB4u7uIswFjIA6Zm1kShFsocXCbkslfU4J3GztmJMCoZZo5PWutWj8Zv7Kf49DwqOLpOwUjihQebyk0Ok1Dh3j5wkCR5DkdSmtDbr+KNkmPDQQNSTSS9Vfk6TNJabAUk73zcRpeq0kIJ5O6ez4fqN8uGB6U844epyED/zDNCy/vcD0N2nn/Na2KCLeWby8d11FNA9ls+qfZOanaW4VsxezYPTYvGfsMdclVCfvS6OV1ihUqpUrq4mnFc7HxL9EqAXjhGiYXk8fL7aRmTgM0QkfjLZXwxBrwI7UqXja04vK6EH4UfKHz5rR5WStLxiL/iSs/7HkBgqkm5Dmzhyjtby8Q8Yz1hRimvvpflGWTex+MAlSO/9R832nCbbJQx+x/5X3uSVIaGP1PfQSUpc+5NCv95WJYhgG0x1UZgVwCs04lxDlyLxootTi2A8vYdeBOMVtV31i6nDFHsyfuyVbsOl9mXKap4JC8X3Q0995BWSNmWXOaUuQiiB5izQ29b5aumhAhBHzi4cMBvJoWfPamKlwjzLTefBfzezjp/W6AlNafAIWYLWLZyeRpgzADwVCfhgoJWTEbor+uEJhYegOFqjfMMsgA9XaeMKvB7bmJoZSsZlzV8hxDR6G4cxiBIwRpzCZOI7kdnp2swpsFdQ/uW+/CPpnmfdQCJXEScjS8uNWZCYEHS0lKiVgpOFkKq0q0F1roopylrPkOrIft9zNoF1FTDt+GHyGvfHNizPj60MAXo4ZUvSZZwZBhrl/tzC2scPU+fW9JWJlX5XIzXVE5SJej4Ep5d/88EbQnISDSscuemfx1L1M0BvvyaoIGO/EFk6+jiOs7M5k2UhafClzloukTLJGnrCKr9Hk+aE7kNQa16VU/pb/W82Ld9+/hiHXL+pyzu3RyJ0q4zDPWAxX2ruutYZbDjI0grcaDMbfPrIwXG
 fqYgC+kM
 fyke31MKaLNtKT00nLGGOr5kz1KlWXtuynGt7KExvWqjegRywmPzHfh9v4Uy98w6W9Ziz4BAD0gN5CMMNV6rPhLoprAzzISMMABedhohqMaiR/KiyDgRNqfNfePbXv+Jnl0P/e250z2fNHZQVbOi4GOxhMubuzbezC06tvDLOHCM5ko2njQ4iRRhBENTrPecJB2r2hxHn0W7I1cLrJXA+2GgE/YX0vr/j5wjDHwcxMEU2avHV5tnW0xxmgNsr96DleX0v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 3dfd02c90037 ("hugetlb: increase number of reserving hugepages
via cmdline") raised the number of hugepages that can be reserved
through the boot-time "hugepages=" parameter for the non-node-specific
case, but left the node-specific form of the same parameter unchanged.

This patch extends the same optimization to node-specific reservations.
When HugeTLB vmemmap optimization (HVO) is enabled and a node cannot
satisfy the requested hugepages, the code first releases ordinary
struct-page memory of hugepages obtained from the buddy allocator,
allowing their struct-page memory to be reclaimed and reused for
additional hugepage reservations on that node.

This is particularly beneficial for configurations that require
identical, large per-node hugepage reservations. On a four-node, 384 GB
x86 VM, the patch raises the attainable 2 MiB hugepage reservation from
under 374 GB to more than 379 GB.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a1832da0f623..008315616c3b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3425,6 +3425,13 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 
 			folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
 					&node_states[N_MEMORY], NULL);
+			if (!folio && !list_empty(&folio_list) &&
+			    hugetlb_vmemmap_optimizable_size(h)) {
+				prep_and_add_allocated_folios(h, &folio_list);
+				INIT_LIST_HEAD(&folio_list);
+				folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
+						&node_states[N_MEMORY], NULL);
+			}
 			if (!folio)
 				break;
 			list_add(&folio->lru, &folio_list);
-- 
2.20.1

