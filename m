Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8B00C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:45:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6950E6B00A3; Fri, 11 Sep 2026 07:45:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF766B00A0; Fri, 11 Sep 2026 07:45:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44B076B00A3; Fri, 11 Sep 2026 07:45:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C3D66B009D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:45:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7DB33140145
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:16 +0000 (UTC)
X-FDA: 85201300632.01.46BCB24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7FF8480009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DtXDy/kR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789127114;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zV7X46hhsJd5Yjfp2ndSpzROiaLliCk9cKSMmjb3/UI=;
	b=VhsETglC5awhg7DZJZYRjZkwkVIsD5xtCz2ezML8V6f0Hi2avJk/MkNrkezg3rs4uUptM1
	137Qy5o5IDiIeRPx/Lsgfqv6InWtl9s0QegzZ3OrBk5trEHlVToW0uZFwko5IZKvJdEjp/
	t8H/jOpohbRh/RmCf15R6gLqGje9TuM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789127114;
	b=7+iOMjY6muUEkts/VMVYmO+MlTZqMESyk9+zaiBpxmXe+wzHYyRqkAM6K8yuSzLfVwlsdU
	nhs5e+lwAeHgQFBaOqcNvgFI0rCsrNZcOujonhpYGvw8ZR97+s8FGWmGUNHclM4jW8nbHL
	EN15MH2+89qg6PCYrMwTi+P7cuxbbE8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DtXDy/kR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ABFF94482F;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B2E4C2BCB8;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789127110;
	bh=tiOocqisQJyVtmOF/Ljy6WtfbcgSVLkxHwITetyJBZ0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=DtXDy/kR8BbNlqyiZWybP5tlaOds8dkA9RX+Q5leY8Q14fv3hSREETWxPreNruaPg
	 Tg/5mkqr0ZG2v8ZmkwWQsmoc1xTNuPkKOXxooh7PY8O2OKqH1WzIiOa6l8M/bgTxpb
	 a1rDOTw2INo2zkGUXOC0BSqtwq2NgCvlzwCaE6wr6gB3z95jOO/qpd4bLbGENclVkM
	 EnZfLF74CN1Lwbj7lEHiJP956YUuANJdFlCOoWEcU9RKVG6KzPRHPH1+CptKKp+3cj
	 2RhbGiXEFzSAuVlc+pVxiZQYRGru7JExIeT+DZ60os/o/gqXRcUJB5mNtv27bepv7K
	 qWN4ybYT5yd1A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C2FC88E50;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 11 Sep 2026 19:45:12 +0800
Subject: [PATCH RFC v2 09/15] mm/madvise: adapt for LRU refs based
 operations in MGLRU
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-mglru-fg-v2-9-f26e5cb26da7@tencent.com>
References: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
In-Reply-To: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
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
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789127106; l=3579;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=pmj3P/HChz1ZRyXZspIgJRWwIbXzfxFrfJsIOvXtfWs=;
 b=OqQF+CHj07t5BGpiOKt6owYBMczI7DdeygcSZALiFcAbH7fMx79vuC0X8jtXv74o3Fg4K2wwv
 Hxmig2GiAyIBMdICKTsfcw6NAhJCqCpBrTMNaTy0Dg7bbRGZy/kUj4Z
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7FF8480009
X-Stat-Signature: ky1kekq91xhnursqm6fwxnfa35rdwieg
X-HE-Tag: 1789127114-733351
X-HE-Meta: U2FsdGVkX1+m40bGtr7O+rAgvSEvzpig8zoPHEZP5Huv3i2Iw3xpxAAp9KGqfaK0aWdMyrlN91l3lxqQrIX+gwckh9mD/LaTMrTOj/ubDf4Vg4Tup1JdUh3oUV/kbENoZEs+jwBRWW0cYoQJZAx8K/wbVb1sw52xQaqWmUD2t3dAkz0xrqyS7+NHh+DqYKnUmVqtfOqBo/fi1wZJC7jozIfRr+SqzxGlNOLV/moBy0S2N2uOmm2O4eu32Z1+AM9Xk/gmeFFdvMXpQYU3A8KwNpXiT1BJFIKq5NU3SN9id3ZFt/mwsVorYNxO9YnaBNDxAwTdk2QR8lEVG2B8FFZgd7Ypbwkv7kWevbEYBghH1tZJHMykuZwXCOJou91frOvOjukUQD6XB4zDlZBUPg1qa21M2yOdU/RjQMGSlX91+49WHgxNqcx0uG2J7cIsUXhHx/hiXVpNW9yfG0mDXT6PDn3N6mOzOK1wppGknznxtpp7o+P2vHr+g5qCtcW8GphiJTsL207TqtdJ20WjMZl4vshF4E0MPAu/y1eK0LgTJ6W6KhBrMpiDyDCqE2navsZUzOodbMKpx2PEKq7wtVyv0FNQ6zVthVyoC9ZdMbkwCCCuYZprQRjSw7K+rfplkBSOiRDGRzu+NB6R4sWETepNaRni6Nbst79p2HLOYf3P7S2jSfgAQZCWnH5h709lbJiqQhBmk/g4XUy4etXofULZV8Tr2NfRFanF8YVQDAQywqzfzbLqLf9jS8vM69g2oAvLavLI2CxfeYk+N6XCK2JzaK1ElR6sRhhMJxaURBd8JQaqeIkifMxMNtoYBoGmMsawRtKDn9s73E95fZ08z3lp0XFeHCKBIck1SjN53HCp1gvmT1JjU740AIr+IWecXCz1ptI9xaXeF0cPtIFfWwARIHeFpZmnQurly33N6t6GSAZnfSIHYG8J4jLWN97KCL0C/fqOMI/tTwxCtN7At/j
 eFYR5Hrk
 wyC9Dr+QN1IwlIfyKPtnczrh3/t3V+8nApofIT4eS3KItSwLvpNnshPXCCL8Ye7j/UutDJC32MDeWkdzgwECczjZlysiFT88NGWoXhEKjm0OoZVuk2MDEqT3ccEXITxIKzNhZmxdFDS8/+cXrJANiBtKUXWaUZydF6dPSKACB4TKtjFqTKoUbq3l/ysjksrltoSUaUrbLnXs4uboGIRpMi5KWQQ/Zw0zBHe4auGj6+qJs9Wv8JioHni1arU/4K+zwMoXB40XmWkDZgPAU570HoHp6lAmrsS6jQwwcGZGABxsACbccly710/heoKb76IlxyJUuGj/d7kNSW97351mSUUPy3FIyjlTm0vvRkgE+P/SVZDRvSuW1mNaQe7U0Tk2GHNWuDX0Qx4TTsqcmnQey0yEdHQ==
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
- MADV_PAGEOUT isolates the folio and hands it to reclaim_pages(), which
  ignores the count, so keep it and let the eviction shadow record the
  folio's real hotness.

PG_young is idle-page-tracking state, not a reclaim input, so it is still
cleared for both LRUs.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/madvise.c | 48 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index f75a9d139980..cdd1bebf2485 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -361,6 +361,38 @@ static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
 				     FPB_MERGE_YOUNG_DIRTY);
 }
 
+/*
+ * Drop the recency information madvise() is expected to drop before
+ * deactivating or reclaiming a folio.
+ */
+static void madvise_cold_or_pageout_prep_folio(struct folio *folio)
+{
+	/*
+	 * VM couldn't reclaim the folio unless we clear PG_young.
+	 * As a side effect, it makes confuse idle-page tracking
+	 * because they will miss recent referenced history.
+	 */
+	folio_test_clear_young(folio);
+
+	/*
+	 * MGLRU keeps this history in the refs count. MADV_COLD resets
+	 * it in folio_deactivate(), MADV_PAGEOUT hands the folio to
+	 * reclaim_pages(), which ignores the count, so keep it, and let
+	 * the eviction shadow record the folio's real hotness.
+	 */
+	if (lru_gen_enabled())
+		return;
+
+	/*
+	 * For the active/inactive LRU, a folio demoted out of the active
+	 * list should have PG_workingset so its refault is still accounted
+	 * as a workingset refault.
+	 */
+	folio_clear_referenced(folio);
+	if (folio_test_active(folio))
+		folio_set_workingset(folio);
+}
+
 static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 				unsigned long addr, unsigned long end,
 				struct mm_walk *walk)
@@ -438,10 +470,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		}
 
-		folio_clear_referenced(folio);
-		folio_test_clear_young(folio);
-		if (folio_test_active(folio))
-			folio_set_workingset(folio);
+		madvise_cold_or_pageout_prep_folio(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
 				if (folio_test_unevictable(folio))
@@ -547,16 +576,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
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
+		madvise_cold_or_pageout_prep_folio(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
 				if (folio_test_unevictable(folio))

-- 
2.55.0



