Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76EEE606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fuMxN0Nc
Received: by kanga.kvack.org (Postfix)
	id 7D9C96B05C7; Mon, 23 Nov 2026 13:53:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718E46B05C8; Mon, 23 Nov 2026 13:53:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B5676B05C9; Mon, 23 Nov 2026 13:53:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 23DC46B05C7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:53:49 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A308512098A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:48 +0000 (UTC)
X-FDA: 85467282936.27.C733B30
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9ACD918000F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fuMxN0Nc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795460026;
	b=Om5Ci3V1YX4F22KxlJ+U8g8lu2Oein8zVz+0ykqCFEZueIjoU/xh7uZRSFsmt+lF6BPlQT
	HX9/QSediCzMpfCMjh5SzBtqrvNP4X6YxKcJ+zEk+Hx6azfqnX4VVbEFbkW5cpXRt3xt+j
	vC7r11gtV2kxWZWCgYlibimyCsAa60k=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795460026;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1JqhXb31mV0qrsAJQ932SZX/2Yz5Qz0UbPnOXo+N5Vo=;
	b=8PW9wnk3zNTCuUfJL9Ld9/PlxLXHTC1CjTfiWfi349dluPsWPjIhCpoZTsjPLRh1wrZeQJ
	TQvGqJTddJjghsR4eEhMM7aMuNbsOlRLgyElpvPvh8uJYRuvT5vgXTbwD5dbikaB1pdsOi
	wfqG+0xFjzRB8KlMtBn8KRVOlBVfy+s=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fuMxN0Nc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A8476241B;
	Mon, 23 Nov 2026 18:53:46 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460025;
	b=j5uEAAqqtJr0P2AIBRVs/qtYduwt8irNX6y71mZhQBM7SZlEgJdiaBeAMyHWVIc1C528
	 JMIKU9fZjFFJCQ7ppnXn1gXrGFZgd6YbvZ84iD5F4F0rtqn7vFcMyYgj4cnU4CcrtmtOe
	 j74DZ+LR8Vp97gQTI9cofXGNnX/Zmrj3jEftHf7x79CznT3xI4nhp//znsL30J6o6s9BQ
	 /S4BJrH9/g+wc0ZJrP1w1aFHEpd1cmWZBhT2VFeYppi5yYJiiF4E4iILMDw2eNTtxCMxM
	 2aRwUmU6neBmaoSl7vrabBA+Evq2RhjctnLOz1EyAkv6PBRum/4ov8tPhN3iwZLp53w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460025;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1JqhXb31mV0qrsAJQ932SZX/2Yz5Qz0UbPnOXo+N5Vo=;
	b=C2wl9MtmjdOUJOxfwa/+jrlEVbvZ+zH1p0w/kEnFvJb062hWsyy+N3FvgV9xVo6MtewZ
	 DVHTx1gxzzlcbwyjr2xMN2zRuf/esUHZdvx27qpOcl7uJfDt5kwP99rJgI8udhsZy2LPP
	 Hzx1Le/5wNHF2LRfSnWJdD6swr94FKkQPeYmf57Mrh73nSYiEk2tfTtWqwqpLyFvhbOj4
	 ICSksh7UncfnffPHOypvmRgNn04yiWQQdYhKQ0lB2zr1BVkJJED3ENmmH/b4Q5H/6KkKy
	 tQBGcIM0RgzNJOY5hKIijFxTgBTlfLkr187NU3h5QNQNj5l5bVLztQo8xpb6bka3yFw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 14D381F00AD4;
	Mon, 23 Nov 2026 18:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460025;
	bh=1JqhXb31mV0qrsAJQ932SZX/2Yz5Qz0UbPnOXo+N5Vo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=fuMxN0Ncu2Kdljre23hS7DhaUsB/CuBV58EDVjopYlTAxM+kgr46CW5q9C5pU6Lzw
	 8P1b3MrcBdiNQHS5psrZ72DqCvENtiQoMoCCW38wV8rx1BlcFXqhMKX196VetYDjfh
	 YgCBUpfCKuWXchF3NmJIJFMVhfZlhAXJWAEwQAxI/ox/JFLkeC/uHrV2cm//kMHTtB
	 XrLqJ0JP+UbcRsObOoFfV3AldfWva5KpR11HwyoutQup9ytJLQrS28XmsU8DG73uR2
	 3m8ydy9rtjkxJPrXSCiyEiOGpnjOODGpBfEOzDlsozSmu/atTmjx4BbHaOsGcGp6p9
	 QqqJf5JN7wJGw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B9F084C661;
	Mon, 23 Nov 2026 18:53:01 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:53:06 +0800
Subject: [PATCH v6 14/18] mm/madvise: adapt for LRU refs based operations
 for MGLRU
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261124-mglru-fg-v6-14-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Tianyi Chen <hi@tychen.cc>, Kairui Song <kasong@tencent.com>, 
 Ridong Chen <ridong.chen@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=4328;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=1pDxzB68yPhUBkq/LYDWcJlzcSVuKtrX815nQg6xt3E=;
 b=DOr3YEmRaaDrax55p05BK/Ym73sex2jTTSZET1t+yFv2QVn5WM0QXp/bEkQ6KU//bQ+Wisxn1
 Qig9+X5yGcZBYXczo/YcZy4ddA5fdisR5SnE+N+dG0f464/kaCt983n
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9ACD918000F
X-Stat-Signature: ms8y8h17papo1otfsany69uwgjsabyn6
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795460026-942967
X-HE-Meta: U2FsdGVkX1+qkxftVFHZPsAc0zbnZJi0/Ff+CRyH0lgxKyehliRG1bPk07Qf5wHYU3kJ2VzNpzoiV18VfxA6djzAYs01fJQaGzvKFtVUmacllGBtet0ZGa+WL+SP865Htl+gMyfBWpKVctQzsXJFX//VQFDapVhDb15bPMCqbQvA75bS3mrCDxDL0/yS8rUVWeTv46EwOHDn/MhUV1iMreQDrE0nFkeneP9Rq3aOnpbx5ZI0zGicIEx8cOXb27V+EkOa55OOZY7omv9WhO42Bhw8LcRgUqj6zvKMTSYvjygiQdbiN8NVJYSW7+P8dmuirojvXXpfmkyWNYzbP/PEMAKQQ5Mxz6qLScqNJNI4TgOTUJTzU5B0/sQG4llQJY3/alVcd99ay34M55m9xMpvQh4QWy+W7oJ79yB54yRwvq6b81ljOb1ddBJg0n14CWcxbv1gy74WNz8GuBjmbrYyWZOes0pZS3QtozkLVs8cQ9uETaGnoZ2IGmGnokUWkAei0y6QcuRlpVBeDCV2tDDMYe2uRqSPMywiHRfK8MVsLiEBUvd2/ucbjQIKmvR8UGoC3CxyB8wGK4lNt4xzfWdZhaWATMZMdLr38AZ9U6kn6uueQczwsMRWvp2yoqkpCdUef1XANcGlRvMnL4zIcvAAGvWCPJqA8sRVE6AIZ0ZjDu8fMAxylJBTGjE55KMFGtVsaGNJQHDY7rLr6jBuebBloWS1U0bB1yP3ofqezVwTI0lu//qLPeXXY06kCt+aOYgHDq6FxuO1vaI4gu9BzOgo7duzY5GDfkqSDVS6psntrpuIJrff6n85bCJ5qxS83cZ0832qn3db3tAFEHNhRonIOSzllbJLeVpWYWf6G1QIw4QrjjExq44d1IYq08P2bxZtM275fvLiCbHriCMeYnPD/JzdQSXS8ia/ZZOeBwUnJWPg1X+acvkSkUN2n0raPyWAjSDwECWYGg3Tz0ZPI61
 gTJs7+Kb
 UWSs6/J3ZKfY1Tk4HsMbXSkPGpqA2hyh3qL/lVSWWhTgC7P4XZ3xQO5Br8vk6Pn06pHKFVnRAQfFs/69LaffliWLSQrYsnTmc7DQ1MtHvTaRNsvcCfM0flGks+aHyG4o79jxxSRW5MQWglrrn7nSbpBjZ1p+63obe2a8xjvkooCvKxvacULOaMBODUeI+PSm8018hs/K7coKcev7Tx4ZjmirYzQ4r60HGjXw9BLTIjybPBLrDIKMxhVx5h2s8ZvI5EiFLg07Qbxbv4k9gtk/ULhhbmHzEYnPTByyp55rCx450TBlwAhcSMUz1aUoTHpMFmr86FBfAt9jaoWFevVer9AbIiyhVdruABwetGMH60LgUk7dX5iLQH7du7QVGflvedrW9zk3lFo9WHEcj4kFYP/RDIysKlhD83g1wKFPvB75/HLV6wDOWdsAcB7kDkuhAjaRg+UyuSVGoP9O2d9YBPhGMBhwatU58LzFNq3nBHeYTWcPJqo5fWEG8i7V2mRrEYDhkqUvgGU7AChUUCrTR01AkmgVTh3PIHosp0qCilos8FAgdNc7R1WcuodPtVSHE03115PHdyCGamjph83SGoDBfvNeeOXQc0uwecXmm6DYfjKeQyeKzPlnFLZj7h0WVCDReiqX9YmVCM7w6/ugqFB1awYrk90Aqsm8N9G3q4SoeUzYJ5RO/8V6N8cXfI0a847ySAN+ftR08SrG013OWOapTvaYMlsW+aj5K+bGBiwN1HHHJD/ig5GPyhZ08UUeBZEkHvpy1duS5g3kQtCtZrQlyXpMPNpfBJHO8jAXfchFaIWRwxcfqmW4gnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

For the active/inactive LRU, madvise clears PG_referenced so that one more
access is not enough to reactivate a folio, and keeps PG_workingset on a
folio demoted out of the active list so its refault is still accounted as
a workingset refault (PSI).

MGLRU keeps that history in the folio's refs count instead, which now
lives in PG_referenced, PG_workingset and LRU_REFS_MASK, so writing to
those bits directly corrupts the count. The two hints want different
things:

- MADV_COLD resets the count in folio_deactivate(), which also requests
  deactivation.
- MADV_PAGEOUT clears non-workingset refs and caps the rest at
  LRU_REFS_WORKINGSET after isolation, before handing the folio to
  reclaim_pages(). The hint marks the folio as cold, so the
  eviction shadow records the capped count and does not inflate the
  eviction/refault counters of the hot tiers that drive aging, while
  folios at or above the workingset threshold keep their PSI
  classification.

PG_young is cleared for both LRUs as before, so the referenced walk does
not count stale history as a recent access.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/madvise.c | 54 ++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 14 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index a36cfe98dd81..7e562e78d52a 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -360,6 +360,42 @@ static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
 				     FPB_MERGE_YOUNG_DIRTY);
 }
 
+static void madvise_cold_prep_folio(struct folio *folio)
+{
+	/*
+	 * VM couldn't reclaim the folio unless we clear PG_young.
+	 * As a side effect, idle-page tracking loses recent referenced history.
+	 */
+	folio_test_clear_young(folio);
+
+	/*
+	 * For the active/inactive LRU, a folio demoted out of the active
+	 * list should have PG_workingset so its refault is still accounted
+	 * as a workingset refault, and the referenced bit always needs to
+	 * be cleared even for inactive folios. For MGLRU, MADV_COLD clears
+	 * refs in folio_deactivate(); MADV_PAGEOUT handles refs after isolation.
+	 */
+	if (!lru_gen_enabled()) {
+		folio_clear_lru_refs(folio);
+		if (folio_test_active(folio))
+			folio_set_workingset(folio);
+	}
+}
+
+static void madvise_pageout_prep_folio(struct folio *folio)
+{
+	unsigned int refs = folio_lru_refs(folio);
+
+	/*
+	 * For MGLRU, clear refs below LRU_REFS_WORKINGSET and cap
+	 * the rest at it: MADV suggests the folio is cold, so the eviction shadow
+	 * should not record its hotness in the high tier counters, but
+	 * the workingset classification is preserved for PSI.
+	 */
+	if (lru_gen_enabled())
+		folio_set_lru_refs(folio, refs >= LRU_REFS_WORKINGSET ? LRU_REFS_WORKINGSET : 0);
+}
+
 static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 				unsigned long addr, unsigned long end,
 				struct mm_walk *walk)
@@ -434,12 +470,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		}
 
-		folio_clear_referenced(folio);
-		folio_test_clear_young(folio);
-		if (folio_test_active(folio))
-			folio_set_workingset(folio);
+		madvise_cold_prep_folio(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
+				madvise_pageout_prep_folio(folio);
 				if (folio_test_unevictable(folio))
 					folio_putback_lru(folio);
 				else
@@ -544,18 +578,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			tlb_remove_tlb_entries(tlb, pte, nr, addr);
 		}
 
-		/*
-		 * We are deactivating a folio for accelerating reclaiming.
-		 * VM couldn't reclaim the folio unless we clear PG_young.
-		 * As a side effect, it makes confuse idle-page tracking
-		 * because they will miss recent referenced history.
-		 */
-		folio_clear_referenced(folio);
-		folio_test_clear_young(folio);
-		if (folio_test_active(folio))
-			folio_set_workingset(folio);
+		madvise_cold_prep_folio(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
+				madvise_pageout_prep_folio(folio);
 				if (folio_test_unevictable(folio))
 					folio_putback_lru(folio);
 				else

-- 
2.56.1



