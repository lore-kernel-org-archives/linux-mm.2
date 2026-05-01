Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 835A1CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9661F6B00A9; Fri,  1 May 2026 17:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93E136B00AB; Fri,  1 May 2026 17:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8551B6B00AA; Fri,  1 May 2026 17:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 673CE6B00AB
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 310DE1402C4
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:21 +0000 (UTC)
X-FDA: 84720079122.23.24F9158
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 04A04140002
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sow84dOV;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669459;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ppyNw9DeoSuWsOD1SjhlcwrMtb3OM1ERtXh95gNOATo=;
	b=47LxNcxulL1bEgRtWJBDks3IOALd0hL1GhBpNW7KCf97AhixLUUVwI8duRYwfTegBp201n
	pjeBGBD1rdG0VZEzDmFjC24A+HD9lcH8qWGVwt6MUlghfFbJ94jfZYQoy84nUUfCRiLUvf
	GdgW8ter4Dhn/qL1vZu/pvM6g5Ggodo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669459; a=rsa-sha256;
	cv=none;
	b=P6FNF2PJKbpZAdnf7E68tQiiWaJYppYd0jJt0Ezk1UUkln+Ug484XuxDrfUhFxySmMqlC1
	Xcdun9xEvMZdwWRS7xqzSLeQjpXXgj4aD3eyW8lZgPwy6LbWII9WoOfTZwUKQQnLj/5dIR
	vSJAxBYIk9wYDzVjYMnRnEHxEN+eIh4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sow84dOV;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E9DB44559;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B885C2BCF7;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669453;
	bh=JbSryOj61KkH2epK9V3PZBxm87AJiD8qW4MrulV6+TQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=sow84dOVIH+CGAEOSD+vgPjVAdkuBcH3OA6XMqPexmwsb7bmFaH6prpyKpEOkWveo
	 p4DsoAkmbhi1NGljLRqyed6ITPYMWoFRWsH0BqExqCgOKC5ln0Yf9JXVbhPvg9XhZy
	 53kJW6wLTkCqG/YaJtkTOLyiJQemSVAnB/QZZqpY0kAN19qQgVD+KuNOEqFnbGEHZn
	 kxFDg7Icoz5kUdtXJJmU8cZnoH0KzxhVtRIk6pu0YdwBhspqV9Fqi5cq+3QS1ruJ6X
	 AkGi2N9eg9iu9qQA4bZqLpsP7AGvOVy+gKXDOhzJ6GQ8LK+sg89Jj8BRbIygKN5+Hv
	 9yhAV5qvrWNSw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F57CD342C;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:04:05 +0800
Subject: [PATCH RFC 19/32] mm/madvise: convert to new lru refs API and
 better support for MGLRU
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-19-913619b014d9@tencent.com>
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=2598;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=nsdGkqQnIhHZ9iD9iPaPkGtCBxehUPo1DWGXdON6M/Y=;
 b=GSF6KP7HamzrOX9fc6KaEbpwG7F0Vpq9uEZhUQSmAd6gKmp3/uajUtaj2M8du2Qu6ADDYhGQB
 k20Lra60ZzLCHE+D9B7reUUbU0PFsXCZpaolFWS7eQ2d+CUIx2JH4Pz
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 04A04140002
X-Rspam-User: 
X-Stat-Signature: fbqeyfz68dfw4wqz6yu4mcofkhakh6hz
X-HE-Tag: 1777669458-908512
X-HE-Meta: U2FsdGVkX1/pMrvU/Om2z9EED/H6xiyfsW8USb8KJsaudw1RFY6ApQCNlu/wUHcdx1nkjp8saVicSi210hwPKm7kjk/ug8FSrt9DaGfjaq+ZXxB5St4TQhjFY6q1jFkWCb3J1PeVNofRhiv27QfMpsMCLTPI3r7Mn4HUZuaY5QME3p8wi+Mfr/jiER4K83fbxhvH8Vf9bxTRHnDIcgw5iax0KRGF9Hy4l8y91GaVKQP0tmiUjYqa2Q2t3t7iTdU64B4fEeI4BlQ0qddpykciIIWKeGqpEv7DnmhkAeE0jen4eMCCJl7lm1gTzJ523E5oUmKnJeCLed0YmtiCKxldcTJtVyJoM4tcxo4YCy5lkZP6Q2M0tobOEwKmmMAgxK88JgIhG2n5L5rDY9wJmimMfkH8IrmyrquX7g52s9nhngPPvldBUIWvo2iHZxPvSRbfMvXpz/vod1wREtr3DGap0AmBnePCJt6TIDKtYRNrg4Ef2znLvEYomv4y4DlTCBfWcQan0UGurdDF4IkeHBZRpZZGUUz0aklcQmM3yXBn4wmtHok4OZqnXaAddTNZ1xVCXOrwXIyaRqehjFPm8j4FUdWDDjhfapmgc1ktNdPwnjvFU2WAYylHVdgLMmYuV8Y06a/qn6NQfA3G/6tojK91HmLKB67xhTWf6H/JtW4Jwfjz/IZCdgcyzy/ZS6SQP+/FP5B1s0izeIgm14E+udILUsM8my5jbCUKABO7cHGgDM9hFkSgy2sCHwkY3pblPacgcJjXyAr8HqshC1YibGUqeW1aDU3/WeVqf3++8DRZR95IKWIgOA0s4kXOVutTMmSbloxvzw2HGTZ+ELYXts2C2Mgqoy+NRGrdjZqTUed4ZVrVLsnrGSB3vp1uygPcNALbsnhk4uAkx+SWXcZ6/D3On120W1FqaGXx6pE/v8bR3jUcIffD3ka2X88B9Z1eczsjapenbmuMURN6Fz/YySb
 tKGsqLHQ
 jckBK22Jsy3KPtcBjhsKNrpCOb7/ZYWKUugwxw9pf+ggqWdFvhKwg1fy0maJ1Ti6s/OtK+hVtqTiNM2e2dXwayhF0BhGVY5Mi4/I2IVfbfe+0fOBBhs2Ml91k1WQcESCS0rLUMWdBFdw8Y4A/aso151q6M9hNsYpd3UMFAGv/MXHNUkxNQtHaJLtDnP4odLXEVQYNgT+f/2zuaQ/r/98zdMIDRTxgHTbsXl1XinvIzzOEezZrMbYLoyH1TVq/XwCBGbEplY1BSEjtoNOSAHHmkGYi4IAT+PcXvYcREBWjX1d6E0Rb4J8s5F3cFI8t/WkDDFdl+3xXgb1REOignHuB2kK1BhS6fZ3a9kki9eLG4GFvH2mqs4YdaJG1HRFE4HAM1lTUQt2UPHcXSVG/Jzas7iA76Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

For active/inactive LRU, madvise wants evicted folios from active LRU to
be considered for PSI too, so some special handling are added. But MGLRU
doesn't really need this, as it has a different activation logic.

Switch to new helpers and improve the support for MGLRU here.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/madvise.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 930939c55cd5..e42266a03fe9 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -351,6 +351,27 @@ static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
 				     FPB_MERGE_YOUNG_DIRTY);
 }
 
+/*
+ * We are deactivating a folio for accelerating reclaiming.
+ * VM couldn't reclaim the folio unless we clear PG_young.
+ * As a side effect, it makes confuse idle-page tracking
+ * because they will miss recent referenced history.
+ */
+static void madvise_cold_or_pageout_prep_folio(struct folio *folio)
+{
+	folio_test_clear_young(folio);
+
+	/*
+	 * MGLRU clears all reference flags in folio_deactivate,
+	 * no need to touch it here.
+	 */
+	if (!lru_gen_enabled()) {
+		folio_clear_referenced_by_bit(folio);
+		if (folio_test_active(folio))
+			folio_mark_workingset_by_bit(folio);
+	}
+}
+
 static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 				unsigned long addr, unsigned long end,
 				struct mm_walk *walk)
@@ -425,10 +446,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		}
 
-		folio_clear_referenced(folio);
-		folio_test_clear_young(folio);
-		if (folio_test_active(folio))
-			folio_mark_workingset_by_bit(folio);
+		madvise_cold_or_pageout_prep_folio(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
 				if (folio_test_unevictable(folio))
@@ -534,16 +552,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
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
-			folio_mark_workingset_by_bit(folio);
+		madvise_cold_or_pageout_prep_folio(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
 				if (folio_test_unevictable(folio))

-- 
2.54.0



