Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B2AC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 17:53:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FF4D6B0095; Tue, 25 Aug 2026 13:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0C46B0096; Tue, 25 Aug 2026 13:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E43FA6B0099; Tue, 25 Aug 2026 13:53:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B00296B0095
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:53:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47E6FA0185
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:53:42 +0000 (UTC)
X-FDA: 85140539484.12.5EE7BCA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 44522140006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:53:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OMF+TPUE;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787680420;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F5LoM1/6uDbGG6icPsWgWa0j1w62FCUNuLGZjvGTOIg=;
	b=LU8kFCfYPK4ozwXagNUr5IZ65hWZFIq1W32w/+czxvayQO14wfIQ9ognVQy3yCUul1NgA6
	wA6jzHgj2CO6ZKVIm4nkZR8SpHSQDFqHA0tnIPathEV7nXdqSw8Q4tytRk7YCBNZDI/1wx
	1XDgkmIJc6gjn0eisIOX9z61MBzQLIg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787680420;
	b=oXo7bsX+Y8nVwnf0GxeqdFcnr+fiZuLgMsUI0Rj4FlkcDy/4wDUVNnqBCPKFXAz1MKCYIN
	E+3QDLSqIU7ZmM4LVj6lWkLdrLiv06T+MPKYE76zJR7mjZ7apbzVGDN4R5dOmeQBZVl25j
	UbecePfY67JtyLHZS6oc89UlyYISXiI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OMF+TPUE;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EBA8740BBC;
	Tue, 25 Aug 2026 17:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BFEF3C2BCFB;
	Tue, 25 Aug 2026 17:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787680418;
	bh=x91NYTB0icDkDpw7RJAyeqsTrQzHrISb8JAZjmZwxVY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OMF+TPUEy3YiTGEzrKiu05kMX6kystsQysRf6q3UaVmZRYgh7Qkqego2ZWZJOWxOU
	 grhMK6amGvLKfkFWhP8VpxVoNucPh22LpmwPLXYk6rVD8cK9XKU/ab0DX65HnMQLxn
	 vN0JzlHGEElPCqTFZ2+3A/O1EAACIQc06lB9k7CQQUVgalLoaRqlQJPd2TQgzo/siL
	 xpDqB5zFJTfY6+HuH9+GNEVZSGI4+2WWQ5mWogO6tVyh5dXARKKswbkgM0spqIhtIN
	 10S5W6ypKZE0IA2xWXbEJp0uIHPNAN5PhofkLtbXE8R15ACSdfPMqG/5Hs1VL477yX
	 10+iTQIgm3QSA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5904C61DBD;
	Tue, 25 Aug 2026 17:53:38 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 26 Aug 2026 01:53:36 +0800
Subject: [PATCH v3 3/6] mm/migrate: copy all referenced state via
 folio_migrate_lru_refs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-mglru-flags-cleanup-v3-3-d9f1c75549c8@tencent.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
 Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Kairui Song <ryncsn@gmail.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787680416; l=3430;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=F5+WyoMRKAo52xC+EbaLJqEaBkiRHvtsGp9Dpo2ZkjU=;
 b=noV7iQlZnx63oX5tZYMbh1wEEbGwnyLEUkL5DLG+Qp5A6Hol3WaFfxZIcmRM5pnZoqUrvp6gz
 S7iSbTn6kAAC5uisfYwCOVtzRHU05byJ+EpbRh3INC3AFQN7NaegO1G
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: mxckr7btk19rsidqa8q58m6sg4156muj
X-Rspamd-Queue-Id: 44522140006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787680420-495285
X-HE-Meta: U2FsdGVkX1/hnwL0/03Yz9xExt2qPONKMorDeRvb/vZzY8Tu/6HEcfX3ro3S4BVQHQbVDI3ObmH7TVrprGsNC675NtFCF1G8kAs6agrlXx+2nZJ+CnfX31voTkD/s84r/4wYPZy+WTP1MK8viyqpI9ipMDDGjrJquFMbi0/cO52ZOlCNPENcJBGmYywJXSTg6SmKNyWsjgq7ZgV0jWJOv7l9co9KBGe/D7W0JDKBZIfG5PWMIbSJSRcsnR+q1xRJrcmAhxg3BF3Tel8vKDPuTpSlommLVsHZNn4RAYF+bUi7qhFLZjLHwUtK4VO229LCDCDWgcAKWefipMCRonkMetzzdDvbC3RWV3fiF/M0D8bNtl4Xqf9l4ufELnuhBMxoiEp/6njzkJRyBzb7lHi9k5nmv4dZpTblHzUUWyDbPbFzn1fkRvsN96DvJamV4Zz7y6svbLfonsOdrrKTmdMSCZIyPliiwg3TWfVGPh8EJzP82Lh+oH7IB1GG6OGbwHOpx1VtpRgWnYbzmGAx48o6k8enSubiDiBn6A4rnFAz5oFeEzBhCEj1wqZoLByW1YdOygMrzCq7Zv2XlsJpTVWxB66LBUboSp1Ov6O1qeRqawJbPOEIAcC78p0aOJDMT09Y6nZ9px3G0+o+Q7gpYlmEZhsxsotFARe4+HKfOIO3DUD8SSt8dIaWG22bhG12fD77yEopFbuY4lOMIUbcIRSEAHtfJ+b48bF7j5nw5BDhU+ehsbET9NXQ/pruQZvZukPDdCwznpG11EC6MGcM5e9GAK+tNs/Ci4E9hi7249SYkr6zF5NJmxO7+C+ryrfavGkxXus6IO3staQrT39riUHht2bN0Gw+9FSl6Imjlxk8zintHNhHWnBSq9s52+pmj5AxIJGb4KJOYd55hq9TSZoD5kjwCb5qUjyPU8ALMoTVd1zQev97CPA/BnfD/olvwBt+i7/amIz5Rk2dtzvnVyb
 phRIYjr4
 pqpA38gE5psMOl+/wSlj3E8mSRBAvWugsnjgIbxR7Bx05I1Wn2js6DKU7cIAla0lmmfw3Ef1F2fQmEAN1mi5ET7wSvSTT/CpWTvHLr+8ZuZJIx/XPSymmfOyl7p0NSqya+ajczHhU/bZ89g1a2lBadvY5HrEun2Ajxt2zTRdheyumEmRwrtlqlU04j4xi1U0viQ335wFQO3wlo3iZp197nMynUKSh15wBVbr9XIRblsHr9R9tCD3Tunfih17uv1dqIJ1SHyH6tCd9gNeSFF0fWL5C63tRF51zPmMZ/98uA9idNTcqejMEwakKIWJSz/cV+d+lEI2k3Ee2NWD/YNfQTFVADZuUxJOpbiQP/8mDYbZwXFM3ntE+qg/JMSpi1z+fQfyvRAaMAATBPriBedf06hAjI3I2+eTh92aR9rd+lc4qq4OPOXGSB+Jo/ahODW8srJ/KAZk7OytV6yM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

folio_migrate_flags() copies PG_referenced separately from the MGLRU
refs counter, which folio_migrate_refs() transfers. Yet under MGLRU,
PG_referenced and the refs counter bits together describe the
referenced status of a folio.

Consolidate the two: rename folio_migrate_refs() to
folio_migrate_lru_refs() and let it copy the complete referenced
status, i.e., the MGLRU refs count including PG_referenced, or just
PG_referenced for the active/inactive LRU. Drop the open-coded
PG_referenced copy so the referenced status is transferred in one
place. No behavior change is intended: under the active/inactive LRU
the extra bits are unused, so operating on them is a noop.

Transfer the reference state first, before the destination folio is
marked uptodate, so a concurrent lockless reader cannot have its
reference update overwritten by the copy.

Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 20 +++++++++++++++-----
 mm/migrate.c              |  6 +++---
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index edfaf2661812..7f91a89b5ba3 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -365,11 +365,19 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return true;
 }
 
-static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
+/**
+ * folio_migrate_lru_refs - copy the reference state to a new folio
+ * @new: the destination folio
+ * @old: the source folio
+ *
+ * Transfer the reference state to @new during migration: the MGLRU
+ * refs count, including PG_referenced, or just PG_referenced for the
+ * active/inactive LRU.
+ */
+static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
 {
-	unsigned long refs = READ_ONCE(old->flags.f) & LRU_REFS_MASK;
-
-	set_mask_bits(&new->flags.f, LRU_REFS_MASK, refs);
+	BUILD_BUG_ON(LRU_REFS_MASK & BIT(PG_referenced));
+	folio_set_lru_refs(new, folio_lru_refs(old));
 }
 #else /* !CONFIG_LRU_GEN */
 
@@ -398,8 +406,10 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return false;
 }
 
-static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
+static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
 {
+	if (folio_test_referenced(old))
+		folio_set_referenced(new);
 }
 #endif /* CONFIG_LRU_GEN */
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..a369d0c95c38 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -776,8 +776,9 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 {
 	int cpupid;
 
-	if (folio_test_referenced(folio))
-		folio_set_referenced(newfolio);
+	/* Copy the reference state, including PG_referenced */
+	folio_migrate_lru_refs(newfolio, folio);
+
 	if (folio_test_uptodate(folio))
 		folio_mark_uptodate(newfolio);
 	if (folio_test_clear_active(folio)) {
@@ -807,7 +808,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 	if (folio_test_idle(folio))
 		folio_set_idle(newfolio);
 
-	folio_migrate_refs(newfolio, folio);
 	/*
 	 * Copy NUMA information to the new page, to prevent over-eager
 	 * future migrations of this same page.

-- 
2.55.0



