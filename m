Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B0E9CCA464
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:16:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC5A66B00AE; Thu, 15 Oct 2026 14:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50E06B00AF; Thu, 15 Oct 2026 14:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93D696B00B0; Thu, 15 Oct 2026 14:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BA8A6B00AE
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:16:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DACEB1A0113
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:02 +0000 (UTC)
X-FDA: 85325664564.14.12CE23E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id DA93A1C0008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JH20tM6q;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088161;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7A3aLzUwtOKaJD6D+6ZXvw0ESDyUOngVzoVcPLCnvA=;
	b=mgN020xYNh8s0qeRgD6bwu7cfRwH7IKXeSxu0VOCnkAdL7wY5mKw1pQi1bmwMiaQp9xwkB
	5LAMcTAQDB/Lm/ykbFR4WAtM6UMX7uQfTzO7lKB6brXbhsAG0+Yov2dchMHUCDKpsNwKuD
	UKYA+88aARnoo1RNPzNIxmbVxg4mV78=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JH20tM6q;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792088161;
	b=Drgy5UvksFcuLtQIZKYcvwtCrw77PVAgYk1ZvzmSNDLuvnKFhG5GI77+yDjWwyGNFI2JXj
	dM3mUWMoVIwbX28fSgG0lKcCwDdJoSNjZG7zz65Z2UVhBz7fxREM8vMgKpzykJVj3IJWuy
	D3XxjcCMfgXI6w0zklPLUVuORoo6RHU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 20FBB447F8;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F36B3C4AF0D;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792088156;
	bh=nd2RmTuSslJnHHTOLfAjN4i3GoAr0BthhFzpuPLIffs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JH20tM6qgsPSZ7MBDmiPlliFqWm52DizmYPhPQ3LiUrb+gAFkp5ca88sSWKZTkWRJ
	 +E0OXwTjaR4DdzlR+YHjyt3xNDwwoAt91voCSILH6JWvDKjOCMLKSgj6Lwhz811vHv
	 +s4YRiI4ZRIAOZLomBkcU9sR6v9iIGi3hd05+wSlE7JpjRFu426Mjj5O8PyyGitrFT
	 PH+gq+piDtxQQ323lIkHOf/iylJp6OR+j4uiyMZOM4lMOxFn4cU7u8hnt51A+1xVZr
	 u1q6kZKKr7JVcEuYQzCQF9x/jE5bVndRDsK+GO1gotarEmgTSK5uavYmbAVSp0KYI5
	 KV4mFkhfWX6Fw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBAA7CC6B38;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 16 Oct 2026 02:16:00 +0800
Subject: [PATCH v4 11/17] mm/madvise: adapt for LRU refs based operations
 for MGLRU
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mglru-fg-v4-11-2106750c0bfa@tencent.com>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
In-Reply-To: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
To: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
 SJ Park <sj@kernel.org>
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
 David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
 Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792088152; l=4236;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=d/kV0oKuWBLCvIIPKjnAO1UkbGprDut4GOEz6Q+ljhg=;
 b=LkpTc3Ht2aEIlGNioGudDwjL0alCNwKFNQQ+EepfbcbV2f/Wrt0p+JBHeBJaNievGrpbTY66k
 EW79JAIXU0oAbIkClChmotD8b6bslzRP941GoERuEspVmt5JiaAIfNd
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DA93A1C0008
X-Rspam-User: 
X-Stat-Signature: 9huxjmek14dre3c9z6f49wq47dnu6ppt
X-HE-Tag: 1792088160-289709
X-HE-Meta: U2FsdGVkX193wbRg5Hqqw0LH2xJBCWtiCbu46SLPRWL6NlsoYWG/HST5+hpfcERczD2Hi5DmEaqrbd32XB9+1/NMfmAbUPAB7LUbL8zzcn9wOd5xx3CW0UcsPaBAc1aWVSoXjyjmkUULTzja1d6+gLY/zK9t43AmMzqzXV5y7Liv0lVDmad+E9wXqQE9DgF6gwRNF2o5FDl1oM0i9uTMHvvWAxlI19hBu/uhYcRHRnxagjdJd45eicjyY0z5R9ruM8InHk/M0QJCaurQwwOzG+w4NKNkfhlLBdqTha5/mqiKIHEeI3m6krt6UsiUlTOTAvu97B7AV1MSG/2LsDnZXC7xdI1hxouiDCUEugZbPOgyNOazxqG4Ykt3U0lfrQZdHd8bfMZVhV0vdOllyX5XpHgnWheiNotMBg64HlZNp9kmSrdspmgOtnampqs5phUe5q3DY6W8ujEgMxQef0GPjAgbLpRPd2JO6zYuBBbe9qLzGAKdJdoFreU7jYLjGflmPfSyXMXa7xkGTWLzLmUpqlt5RiLD4YcRNUc1yZT0rlDuLHd9bm7gIZiuPGcqsD5Tz2GYhoF773S8lPQJLDPKgtCGYtAWr+vwY0rnT2CYuuiIFEO4f0Um3kN1nnm6BoHa2NayhMo7XUYI82ZhMAPRRol2tYT0uokzrb8x73USfSjZRw88on7+M6wvgQbOXgEUCLcPEiy6smHs1fJnx/MqwVfJUXFlu5SwGMvQ+pzGZ6ZPQup8eVjOU0a/9C2fWkrRdg3VQPotmmMImHXJZz4eGx4XX7EWPI72ijKAvRxNAVsoHXqZExoZ+Rwmsdx0Zl6R0hsQDrJPclmM/tAMFfyN/ZBNtp0UMEP7ten+cKkSliPOiGjm11E+bP3L0V678Wiv2CSkZsjOE/lw2XqGh8Z3hZr+hHME2q3Ig8R2aUCGRrkz4MAuZRplj2rM/P3Al2VBsWsgjkOKBNHce4l39LU
 ECBqZCKg
 aYZcnOs90hdmMTJfwkSY7VO+R4YC0SDetnz5Bt7cO0MB+sJUqRhO42PlYMSqeA1Y23m3E7UtlOS3k0hEgOBjz9sPwQ1XMFyusc3ad+u7Swd6Z1zI6bI0vftuoM/HMMZNcaNa0MTOuOD0nv9CHT7FULBjh4a2R+0dzoqG3k6JBaxEM0pnNE1U6O2Z9MkhpsrKkoWfldNKr8hL+3xSB3Ptk7rPMcI9EIJQ9PdfkWwdRo5Flpop6rydbsFpAINfaw9Dy8TLxiUZwIPF5zNgnxwwqt3yScbl2VdDR/UGedLJxxicOUkmmmnyJqzn5Pq9la+zdR3BgLL6liyfpiOOGmkLG0RA5NTf0ngSzxP0jQjowTNqd2fSUQxD9kxiGYWBZCqXc9xUy7meKPb/1X4uwXUZ6jAJNmXUdslr5uLp7NbfdP+hXPRu88jLan7Ug148M9oqYyk+w
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
index 75b409e97dbf..2b4a8b2cb477 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -360,6 +360,44 @@ static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
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
@@ -434,12 +472,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
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
@@ -544,18 +580,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
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
2.56.0



