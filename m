Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DADB606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GKDIZnGP
Received: by kanga.kvack.org (Postfix)
	id 6A3EF6B05C2; Mon, 23 Nov 2026 13:53:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D6D6B05C3; Mon, 23 Nov 2026 13:53:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5431A6B05C4; Mon, 23 Nov 2026 13:53:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 264CE6B05C2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:53:39 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7536160927
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:38 +0000 (UTC)
X-FDA: 85467282516.20.D6514C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7C1AD80011
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GKDIZnGP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795460016;
	b=dO1f2i5P3DLKvNhyZIsHxm+TaYXZhe2OIJSrurtEQxHkSQFVFufUgtJW/junHv9MSrUJki
	9hPJge8Dy9+jAbwWnTSTQmmByF0Dtvk/B8J+xcBdfWn+lGAtClxg5tNKJP2SzCIbKt0DQ9
	wwcP8nrhXHbP/zGUqQ/Iq/phZG4OZeg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795460016;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=horbJ+WRFpXrHIUpt9mddEfhWXyxTruu2VhXlMsfh58=;
	b=pQIaMTneN1CCwKYMr7DZDofSTk1wF4X+UDjmwfNhgV5BTcrwWGFdtVHsIC6hsp6r1GlocJ
	69eqfZxIuclYfFrzDmZJzk9U2j8WvYMIu//D1xTL4w6gpD8wBv9Pen3iBjKXgkuqqo1sPI
	pnec6V7FF5qZKkxYrtm63oHDF7YLqn0=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GKDIZnGP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B82AC459C8;
	Mon, 23 Nov 2026 18:53:35 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460015;
	b=G03C/5HjEjKhUH2+zf5qgZ28CMrZE6ybXryG/Af9QNxMJWzdlYCz/BXB9dkvrVFym1eZ
	 3LE8BKkWHqOMPlW1dp6HO2yPNBnBoIbT9OQrqxTzHB54hbiS8FngQkj272gxUtdI+7SJr
	 9Jw14VnYUvAZkmSKmGgvm1RAANoL4GO7HC7I23hCVOscZ+uHgZFi+Ve7go7IXfYON2hxD
	 B6ksVsdmqOQA6AtElpTPKRauofLBL8tW5y4pdSpltIJTDtuJ6koY7kh6I+L0ASucHYnaV
	 8UySGPvN0tAPv6tMgT1yd9az1FVlu1mqiHByS9VHL0BDcgBsJKcVdMtNLAxdFJEmxlw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460015;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=horbJ+WRFpXrHIUpt9mddEfhWXyxTruu2VhXlMsfh58=;
	b=w1DiTysvg81+bhT8NwrYI84j27sXnnMk7925rcada6dQNRtNHXot7m0deiM31HpqrE6n
	 kxxH5h4AmeaQzHUEMUwOx3E6hUCas3nHbpbJRNeQrGnFiUDLgsv89yDoS6B/AuODZ3euR
	 NrVLSgnR68Fv4PxLpn529c/tebnfZqVO4S/4PsPg+WOL/G4VPPCRYOf4zVbioc7hO7erD
	 Q2x5WJCX9oxNfWHB641pMudkcLuzek1+JWsN9KN27rKK9XvEXDI/qIl62Ig7sWufj2a24
	 1GD4vw4DPR1yrzjHCrHcFdqDQcnCwii7GY8ArLsJyqENpr9DnkpmMKSGqP6MGbHa7ug==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8326D1F0093C;
	Mon, 23 Nov 2026 18:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460015;
	bh=horbJ+WRFpXrHIUpt9mddEfhWXyxTruu2VhXlMsfh58=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=GKDIZnGP1nsLho3StgmJtoB0tWjmF1R/i26GT0x7BDL0ofepHXYEibCqSsQ9JeZh/
	 zSfn22yG3+CDWr63hXkeKIYmB8mGiAZ2JqoBRSPtTqynG4XYked3LbDu4SLoAYdSCU
	 6NHTr2Lqdo9YY2cNgfQu66a5Le/nY62bRFTw2CNyzjMx0rkBBw7FD50ly+SwlwRiud
	 fXAaUmST/hThyCnN/E6MJ5T/q8YDAr8d6U0VV7I6abbDL8JUheUPpbn9nbag60508C
	 eJQcJeRVi6nS43VfSzgO9frGSVag93tNLakzCCmR/NM+C9ZprPcRLPQ+ejEuhbVAE0
	 Z2VgHhHi9QhNg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 630B84C655;
	Mon, 23 Nov 2026 18:53:01 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:53:03 +0800
Subject: [PATCH v6 11/18] mm/mglru, smaps: convert to LRU refs based
 operations for MGLRU
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261124-mglru-fg-v6-11-8ffea39934a6@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=3877;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=SyGC47j2sShmDrstNnpICQjj8oxfwuGK/s3C+V+Hk1k=;
 b=zDeAcKA97ZXD5+wk30UPTAW0+f1NPxG7RvOr5muhguEVkFZjwS92VJecDA26puiKkUFemGJIY
 FU8Dgte6mVHAd28IbxPk82XmytTsRUsfRtz/LrUROT9BqXOCuZBS2gq
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7C1AD80011
X-Stat-Signature: wucjzryc9oi3eh6dffq8tjnq1pahkwja
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795460016-748404
X-HE-Meta: U2FsdGVkX1+wq9GdXEKyNIY+5UwPunrkBs3TEJHjbwCrliUFvwob6uvyiJmDQnYPWa659OBJLm1Xinf2yVltdVbloQQalKxSNFsLIVdKhkLTdmwAQMeBdqXnqxQ/+O60Oi13aYdKRmkpYm9UhcDLRRB4kbkheG2jOHHhQHCWbQSrD7Kbf7HgXzr4FyUkWPpwnDxL63sIZlGKzaSqPkzLv2t3o9yhNFsggty59L60NqMcqjlZqxNUpEhzfSQ6UqPAkGNlqjY16UdfhUYS4Eo4U4cliR6VSKX+yjHL1kDDNLo52iofs7lSXAlDm+KmkaOsx/0e+ZhHuoMmJuETYPbVnboAvVMUI7JrfDakBDdSXGfDpQGsYJjF2FTOnxRSGUDBoGcPOHihfaODRFcufddzxcF6yK2i4q+OTidqtoFxLkOoJZwAtGmTL0Fhgd86sIAr9Epu4BTXxKcz0q4XuWQJ4qDeyb8yiE4BIjLJNeKKDewWyrpO/Vp0JhQmfOjsUFFOJv5+sWs1eYqm5FUewhopLH1pcDFX8YlUH5ljWs33EPvUvgkmpSLIIFMrcJk6jEV+4Jr4LWD8i1B51eXKtCMoDf1wMVJqxFMeJ5amxZ+rSVfiHTOGaLKBRcgVcS0vxLXD04V3zWBC50/JYIuH2mfvC6m9vA/7AvTErsasZLP8il96vxHgCnWf5CVWod4yJqp2dCQYzi0HZ+lN8mzUjcqcBGaOHEe/CmWak6Vgb/6qBWDuqNcpEn48gw25nqotWXBmvYkcj/JmDetuJqlr1EC8yao5RbyBKr17/B8Rw/wOResj5tTi6JUlGKSv9L/BMLQvXwPMHRs4X50jbo50dKh4UI16BjzCgOHx0/HJCVNvRHqQMT8rcvguK3SJCk5H3K4F66QyhcY9kJ4ivXYHlUgkubMKc6tXmi5GOl4D7A7a99NOKbFet/FVPGlp7vGLxu/TFaE/gYvbggNh2Velbd3
 sGrl7GVT
 ghAEuKYLuEUdGtqrYMBVvVNL3UHyFuNCl6qN1PhKVAi2n/i1LHPCvWHoA+0F9OlvtKWYjaG8WXKRRoHMs8eOXJcz9CZf9JuZNC/SyLJUZ7DjqyDcoSsGtiuKNN+3u6i29eFFZzDW5F7Y9B3hs/KlUJwVcMJPN9gTV5DoTxJsIK7ELbTpXVEIa3iwStrSsPgbuiapmZzyMO140L8gWaJoRtjruUgoMFQCkFzGQ6/H+jfMMzyhqhYswC46PVuskrP0P54L4V8wTimlJvgRXscTDWI1+BIMXFOMk6S4uZZYWmmUBHvj6/dQmjc+FTu/PBZTDsMmSEdVA0pxaZbhIuJ7v9kgnELE/4dBVZwHQGWE56Zy2wJnKOVFz0+kRxgkHI1NDgb0VErUqdQYaXs8pdIY3wVf2tGV8OMMLmSd/FO/pjB1wM7HVUBDquIpyV/2gXQse2Y8I2yABc39QDn2/WYi9Jo/c4Th95kNORTaYsryDrja52RmyO4KiKTJGp7ehsj+aVSL0O2Li3VYsVYXLrzppTkGS5+hnZ5nA2sAik3zPzSy6d2B8+xwqjNR+25fRNZu1IsBk8Rxl/SbrncPpcaelP32/EgUCVP3CE+uM86eBhozdqsmlUFls4vuEZp5Wbv9pcqGGOxl9jshUON+VfIrIYzcUPzKfcn/BTvUbRp2tzaXQ6qBa+CV8a8t0IFZEyPA7JRYnzn6XpsdVtrR6j4Yjb9Ewz7VAzq9+QeGTL3N08wVCsCyTqsSX11gyLB1K3iST7PIxx9HWqKAM6s3ge7b2MXt+hcwhlyAOVB41Pmu68Bt3XTYEcQZ01p70ZPyWCsPjAUFe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

PG_referenced is only the lowest bit of the folio LRU refs count
(LRU_REFS_FLAGS) now, and MGLRU never kept it stable: promotion used to
clear it, and now it toggles as the count grows. But with the LRU
referenced count as a stable API now, we can use two helpers to provide
in-kernel users a stable and sane reading of the referenced status of
an LRU managed folio.

Add folio_check_lru_refs() and folio_clear_lru_refs(), which use the refs
count when MGLRU is enabled and PG_referenced otherwise, and switch the
smaps paths over to them. The lru_gen_enabled() test stays inside the
helpers, so its static key is not splattered over the few call sites.

Convert smaps as the first user of them. MGLRU now reports every folio
with a nonzero count, so the reading no longer flickers and clearing no
longer results in an ambiguous status.

The classical LRU case is unchanged.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 fs/proc/task_mmu.c        |  6 +++---
 include/linux/mm_inline.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 540c936aad47..d2a524c6ad4b 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -890,7 +890,7 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
-	if (young || folio_test_young(folio) || folio_test_referenced(folio))
+	if (young || folio_test_young(folio) || folio_check_lru_refs(folio))
 		mss->referenced += size;
 
 	/*
@@ -1690,7 +1690,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		/* Clear accessed and referenced bits. */
 		pmdp_test_and_clear_young(vma, addr, pmd);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		folio_clear_lru_refs(folio);
 out:
 		spin_unlock(ptl);
 		return 0;
@@ -1719,7 +1719,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		/* Clear accessed and referenced bits. */
 		ptep_test_and_clear_young(vma, addr, pte);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		folio_clear_lru_refs(folio);
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 13c8b6bce349..0f470ddf5c48 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -513,6 +513,37 @@ static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 }
 
+/**
+ * folio_check_lru_refs - Test if an LRU managed folio has been referenced.
+ * @folio: The folio to test.
+ *
+ * Returns true if the MGLRU refs count is nonzero, or PG_referenced is set,
+ * which is also correct for the non-MGLRU case. Kept as a separate helper,
+ * to avoid splattering the lru_gen_enabled() static key.
+ */
+static inline bool folio_check_lru_refs(const struct folio *folio)
+{
+	if (lru_gen_enabled())
+		return folio_lru_refs(folio) > 0;
+	return folio_test_referenced(folio);
+}
+
+/**
+ * folio_clear_lru_refs - Clear the referenced state of an LRU managed folio.
+ * @folio: The folio to clear.
+ *
+ * Reset the MGLRU refs count to zero, or clear PG_referenced, leaving
+ * PG_workingset alone for the non-MGLRU case. Kept as a separate helper
+ * just like folio_check_lru_refs().
+ */
+static inline void folio_clear_lru_refs(struct folio *folio)
+{
+	if (lru_gen_enabled())
+		folio_set_lru_refs(folio, 0);
+	else
+		folio_clear_referenced(folio);
+}
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {

-- 
2.56.1



