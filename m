Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 130F8CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 12:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3AB36B00A1; Sat,  3 Oct 2026 08:55:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC75F6B009F; Sat,  3 Oct 2026 08:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67636B00A1; Sat,  3 Oct 2026 08:55:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 819186B009F
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 08:55:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E068F1608F2
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:23 +0000 (UTC)
X-FDA: 85281310926.24.1C562CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E2A6BA0002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e7p6ck+I;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791032122;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OT09sAJf6me1p6/sc13ZXxo9ISuSmCsbkOtJLpfG1jA=;
	b=xZx8Vn22nsFNvTzdyVfePzcvV8u14puxNv53I+rH78La/HDUebFxEeBoDnDGmArGHWZ+Yv
	iXCzIPfswyVKoReyqDsSzo4lmcYAQaOTMw9742TzIba8QqQdRse/Qa9EO2miBvkUCT4XVq
	rEZlwjtwHt5UMdole/kazhIApXb9c0U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e7p6ck+I;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791032122;
	b=aJkZ8jxjHQzaIoiu8rP1dW4uqrMFyeOip43iKXG+sl7Tu+n7e07W2FVPy4PexMwR+qcTlL
	7PbWJ9M1I8RVpoIH0oFUYrTCnzM6nfAzTCbpAAR5djlxYboehpIBqKSjqpgpvfDgSFphzi
	LdmZJGnQY0Ds6zl+mlV1367inNHcEPk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 772EF42E86;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1EA70C4DDF7;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791032118;
	bh=fZ9kfTv0pJsuntFogg0gXgySlt6y0dqk3g4xZjKklRY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=e7p6ck+IaTVleml0Ie5kW0c/qxTdXkLL8LOOkrMGEBpstJNsuCeEt+u/XPOAoVqs4
	 O6XiKivUz7pl6GfJzvhQ7uT+C5EtQsUwR2mLNZLuQ2Yhuv5mCgqCmLfKlO0DJPoi1z
	 DPYFw3s0VRYYdToqJGr3jiw05UoiiwxrE7lG+RP1ysQMvMwOF6O1qK8TbmWNvVcrFd
	 ex9KmxMrHZwZQ/2gsv9s4zZIT7kTLw0y8NYwI2q+Mn6r6uBshPdX1t9tnhcJzWX2t3
	 GkUauR3NBrxS4XrIHwcOoFVeZWseSX8GMqZE5DU3d0TKs1yPjjkem0UlFJgLxKy3ZA
	 3PPZf0kbrSftg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C189CA5FE9;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 03 Oct 2026 20:55:20 +0800
Subject: [PATCH RFC v3 09/17] mm/madvise: adapt for LRU refs based
 operations in MGLRU
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-mglru-fg-v3-9-cbd4546a5bd9@tencent.com>
References: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
In-Reply-To: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791032114; l=4236;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=jcqbXlUlGQopwPCGT1rfXLrfpvOPIf07bE3tZxVpK7Q=;
 b=GVN81BjiDmkmkpqOD5UNMIz5qnRK4kO2qlEtONbttik51Nr0+9Q1lUvRT0QbyAOjf20wYw0H7
 jTTQDTWBAY4C8qlMxbWO4chF/sEe2tA20j+nBIFsWaEdZoKuJ95IvDS
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E2A6BA0002
X-Stat-Signature: 7antiq56ek8ozkrkpctx3mao9tjif6ag
X-HE-Tag: 1791032121-876600
X-HE-Meta: U2FsdGVkX1+LB3+jX11SFB7xjiYyNm22vxP/It8vw2xGQA3+WFtl5Ee8ZPMLHLQwFQACSFogT9vK7QRZDpWer7YPGNQQvAmFGiXN4TCEAzxz/PkEVQlDAT/TG1L4kxqTe26UZ98P0/HAHe0gmHTYFXfAyzkFFZAIjAQE7fRt3rATrzEQDPLNRzF4Jtt6sBDv1VYoKJvNMwltqrukcuSjX+/niOuXB3Q+7GmVeVZGaI3H3pCC7eHJhIfev+QVL/04XZHqPUxXyjjSWoxItGxonXuYH8Crs0nDt+c6yhYg8GmWUFvqUfgex6XPe/SbppNFhumyVdIXwLvNzubZMUs2CazpoEdl/YmtzZvNKdusIqVhOY39ZDr0XmuFym7jFhRbj7FEpUvl55nQIyPwnxyTRVTYzvryaFO8rnU0db5IQs/uqbI9bRS95GMsfA53bF3c6orV/3hbsALU57Ks0/KxbjZ17lGIorMr6NFrQBDFZgRgbwt+2y0PNDTQ79bWvfedv4o7/FxUZ6UzbRdCrlWa8aZaUnfzV6nWs8YsE7lcxLdN0Bl5ueYc3UrP6WWjumMsgz8vqzjE9JcA/OIuadaU1x7OM6kopJXFKAcbMKiXIN7QbCHSlNUikhJe6qx2Taf0ieD8hbm5rfvqehIEgHiQ3YPbJsrQV7ivjnv/MbTW4V0hNFJI7PNWX1o/9ZvXPNaFo5WeTx7b8Wt4UwJbi87e3VN9A+OzmhFtHf5kFzvOdyBP4tUySlXufOUxQ6Gy9xV3ug1B3riIaOTB4xkeYr2GRpwNKRgjpKPnSvszyjE4OTcjfGX6xJULEmLSHQkn++4SDl67rzaEKgh5VASpHL3RUmi8bMrJ82EAg/adQ34JTiTWefpyPePrtIGTFgk1dBLD3E8zOoR5LPzKFXY2lwT2gvgv6Yyi+lQgE8UjxsagNFs6IipYuBEOxxyDiPIZA8ZQW4/NlsOFrhWmSGFIigc
 pRYOW+Xn
 nd89a6DpzEbFmP7iFqixtQoig8VkE74cv/X2IAysdl8hy4KLRSEWFiYYfI4F82Lr2NIA37If1aDlgkX5oBMjiZHQMgdFS8Y5qEWkDgvR8XkIGOWV0NltNeMJJGsfEAsu5a4Iaze2Q/Sn3FK6EclByAzwKKKPTN49nwXbPPjb0aMVbYc7fGw+gtZCgBiSSiil7FCKZ3ZTfcTtwxpyO0eOBVtxiggBiDyE1dnUFtTYh84m0zsYZlKp+zZohoHZUJy7QLUR/Yc07wfs4sWUFhcssB1mAzdKfK2vT+2ALVmVrgklQ3BA+BtGZCsjyNWHGV+P/VvhaVFuAlQPCMyFvkGj6QFsyP/nJcfFD4RMF/ILdXGw5gy67lws98kv1V5ecRecEGRsczFdCYJ7Wt/3WltJPsBLNuHw9h+jkC81LY6j0OkAzPGcetZgtbdsGaPAOGdijKjJg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

For the active/inactive LRU, madvise clears PG_referenced so that one more
access is not enough to reactivate a folio, and keeps PG_workingset on a
folio demoted out of the active list so its refault is still accounted as
a workingset refault (PSI).

MGLRU keeps that history in the folio's refs count instead, which now
lives in PG_referenced, PG_workingset and LRU_REFS_MASK, so writing to
those bits directly corrupts the count. The two hints want different
things:

- MADV_COLD resets the count in folio_deactivate(), which also moves the
  folio to the oldest generation.
- MADV_PAGEOUT caps the count at LRU_REFS_WORKINGSET before handing the
  folio to reclaim_pages(). The hint marks the folio as cold, so the
  eviction shadow records the capped count and does not inflate the
  eviction/refault counters of the hot tiers that drive aging, while
  folios at or above the workingset threshold keep their PSI
  classification.

PG_young is cleared for both LRUs as before, so the referenced walk does
not count stale history as a recent access.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/madvise.c | 56 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 14 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index d83ce6abf8c3..c221234fa199 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -361,6 +361,44 @@ static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
 				     FPB_MERGE_YOUNG_DIRTY);
 }
 
+static void madvise_cold_prep_folio(struct folio *folio)
+{
+	/*
+	 * VM couldn't reclaim the folio unless we clear PG_young.
+	 * As a side effect, it makes confuse idle-page tracking
+	 * because they will miss recent referenced history.
+	 */
+	folio_test_clear_young(folio);
+
+	/*
+	 * For the active/inactive LRU, a folio demoted out of the active
+	 * list should have PG_workingset so its refault is still accounted
+	 * as a workingset refault, and the referenced bit always needs to
+	 * be cleared even for inactive folios. Nothing to do for MGLRU as
+	 * folio_deactivate() always calls lru_gen_clear_refs().
+	 */
+	if (!lru_gen_enabled()) {
+		folio_clear_referenced(folio);
+		if (folio_test_active(folio))
+			folio_set_workingset(folio);
+	}
+}
+
+static void madvise_pageout_prep_folio(struct folio *folio)
+{
+	int refs = folio_lru_refs(folio);
+
+	/*
+	 * For MGLRU, drop the count below LRU_REFS_WORKINGSET and cap
+	 * the rest at it: MADV is
+	 * suggesting the folio is actually cold, so the eviction shadow
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
@@ -438,12 +476,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
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
@@ -547,18 +583,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
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
2.55.0



