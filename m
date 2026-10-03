Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C86E0CA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 12:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FBD96B009D; Sat,  3 Oct 2026 08:55:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BB656B00A2; Sat,  3 Oct 2026 08:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D167E6B009D; Sat,  3 Oct 2026 08:55:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 818C46B009D
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 08:55:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E31D280928
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:23 +0000 (UTC)
X-FDA: 85281310926.22.40BE12E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id DE3BFC0008
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SZAkgYd9;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791032122;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3iIaDynZLDtDtubH/QO1P5MZ27RABHesrXk5zA5tSaI=;
	b=E78tdnSqGKbVMlcv+a2QTpgYSvk//0M1wBPEJ1KpD0z93+7gbR9Gx3lke2H2BlSQw9l4Vw
	wwD4Zjcn4SBLkVmkEBy3NPR0ib98LxkE76kzb6CNxH5Sn+zW678++Y6pBuOEYXxZ3deMl9
	hmDa4zjW/Zg0Kg5Uie9IjLYm+Lr8Ezo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791032122;
	b=iFqOu4KTpm5TpjweV92g4+lkE2DHRJh9tr3e+zUcjCeuUaFRiohk108Kau05fEUavYw8gn
	wWQFtKJ+I9Wf1MEna72Qwe1OMyMxjF8wVofX/LZYHnJVd4LNtdUDkhf6kgCt09a6OSzsfI
	BWK5S2MQCJcmbXcvrjtDAz/S6RxLTaw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SZAkgYd9;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D68C44859;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0EDF7C4AF49;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791032118;
	bh=K30RUNtm7JgZ0IAIyV4BUzwhlm+WKo7/cDEPpJsCsKs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=SZAkgYd9fKJ/0lh7RwndXBT+mcQZJoRhGiEtq5FnZ2CXV5OfIcQY1C+bYg5rTo0EA
	 fe4Z5hoROkTfsKBbDNYEaaPmROFbrpW7UtrRLtgVOeYAGdc6PqNb0WhL/355PeRDiO
	 7k9huOQiM6sz2ENsvkczSFD2ZM66PA0sMkQRxnusAQPo5wQ1qpEgX3bWPL0UL+We1P
	 M8zZEmbuo7mUpnmiIFKXv+IGF8jBjvUnXUPr2+Og8fdiEfJR8NxafQFhrQq8i8YWNJ
	 nMUHw/Vls1nXPltdUmk3vUkXDdEzWwnQDvbwClN16K6D/8BzA/L5P3amCkeWAKipRa
	 6Maor1HM0G0Ng==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE375CA5FE7;
	Sat,  3 Oct 2026 12:55:17 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 03 Oct 2026 20:55:19 +0800
Subject: [PATCH RFC v3 08/17] mm/smap: convert to LRU refs based operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-mglru-fg-v3-8-cbd4546a5bd9@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791032114; l=2654;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=nuK8uOQmpPnofoe0v9EyWL4yCrnyg1Rjaf3cQdxe1xc=;
 b=NS5bTh6n8B+W+SrXrzpsBrr1CXUWVgcXbd2TSkM3KL0JHjP//ZWh70MKjjzSPgrUIfEQiidXe
 oyCu8QZ1vCSAcbURY4g36r8PsN1wfCYPPtAYyH5NctSvDafU24/QZJe
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DE3BFC0008
X-Stat-Signature: zufieis8rd73yuo5s4itt9meqaoan81n
X-HE-Tag: 1791032121-371653
X-HE-Meta: U2FsdGVkX1+fVefgWKhqRQ8nw/sw+q4EIteMzyHIgUdbgBcMDWciiOn485JR8ak64SxtBp7JU+vCpEm2BvY9RSqaioEfvFkCUEsl9of4mgkh71eeL28KQga1q0gTTHXd+MZR1zQYVuPVbqA8DygaN7I+H1voGvc/1AUMaT2zxa/IeSBNJwa18BtQM5JTnapRh7h0qOzV+cU4qTWg+Dzjv//qJ2+FWU3aR4YB4bKRg/sicTFbUuXifn6wxzf6FYiNOu0JtleDjSwapLvkNkCtaqzgTWp0Ohxt0O5TEkKzACyrSZnB0UbO/im+FZNt2vJB2cfWd+JvKVNY6Q+lmFPSg35xifLY2ml6BxYGZMHT/FMRTnvo3XkigJKSXp9a/vsUWMizYIUfsuDRpv3FcUlpHkauZRIdA/FBiWV3JgRodSyvpQ7j87tMwh6wKfrh2lF2Mjjo3m4jqgp2nztRVHzqO1CJAFKKR8xr0I6LA0SawLTRT+VJ81NXr/im4OaNY2GgBl+i3svTf41JUyR05x1S8UbS0tJFvswDAPzDSYsj563fpwg0ro5ydoL4HvLL+8dp+PFbpczl3yzHZvFoqwOfQXOqTT4Ank3s2DAFpPhw1Mw12DxhEoyamsolFXPsCh1jZSi9nGr9YuONGoZw8SxGMB7XA6xkUyYq8RsIQZ6E/xVVkNwNzIWoG7Df3meIWMEYA4BGHslw1VtVsMndgVLw5uQnC/TeBWOC9x1n9rxqNpOIMLpa+Ga5X3byGHbbt0N4bHs2fKqbIsORaJNbmMTV4zS+ep5OeUezvS61eRkgdx4tBZfgrbGWhZ9Me0X5PtGaA53gQt0UUTe6s5X/NaR3UNo8l7+rd4IBbX2nag0gCY3gPMN3mlITg2h66FSVRui1s01sqfYEAj3mGHU+s6KapPFUJhEFYtNoqYvlUJaKU2BCJ4chGlwt7iee/gGnRIoct0DHhW1onVfpuO668sv
 3k9Z83WA
 iSypDcuVPxRyMFqkrdOTdLKJOlyGq7AuSIXb0in4v2hEEUQC/ZUmNR7XCXynVo+sttM92z7Qn5aPBoyACLtkGtDKooJh3Mt9Kkqt5FJyAdnacFCwrCWPWa9UEXMWjKWmvNlQFPYHwGIhRA8lOeUqwGiETEdQykW51BP5omT8pa1lBq50fEecWDKlwp3xNvPMkXHTPPsp8JHN9xDJWJcr5NlgEXHA0zw3JIMjdfOBaVUu8W5pi3wwLDm8R84BCSteKU1YCpvUCL4/D5GwKWJtDGP8TxWHoShMt3dHNI2XYw2BTyVfbHfHTHf3e1KIFENZWd4fUwCTZdjirJEM8VpBuss12SxBddYUsXs40uzvsMYmxm0xikVzaQ63JnTL8ku+2JO+7uA80neit+Hbjz7/I2TT2gQparONjErfqbbKnlqfCUffu2HPfpZx/+/hiL/coyQ6J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

For MGLRU, switch smap to use the folio refs count API so smap will
report all folio with referenced count >= 1 as "Referenced". Current
smap checking PG_referenced is causing folios to flick between
referenced and not-reference status, because for both MGLRU and
active/inactive LRU, PG_referenced may got cleared on second access.
(Increase of LRU referenced times count for MGLRU, and movig to active
list active/inactive all clears that bit).

After this, we will have a more reliable and useful reading for MGLRU
after the FG change. The behavior is basically identical to what we had
before the series. And there is no behavior change for classical LRU.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 fs/proc/task_mmu.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 44147ba0b899..79daaf757412 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -857,6 +857,22 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
 	}
 }
 
+static bool smap_check_folio_referenced(struct folio *folio)
+{
+	if (lru_gen_enabled())
+		return folio_lru_refs(folio);
+	else
+		return folio_test_referenced(folio);
+}
+
+static void smap_clear_folio_referenced(struct folio *folio)
+{
+	if (lru_gen_enabled())
+		folio_set_lru_refs(folio, 0);
+	else
+		folio_clear_referenced(folio);
+}
+
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
 		bool compound, bool young, bool dirty, bool locked,
 		bool present)
@@ -883,7 +899,7 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
-	if (young || folio_test_young(folio) || folio_test_referenced(folio))
+	if (young || folio_test_young(folio) || smap_check_folio_referenced(folio))
 		mss->referenced += size;
 
 	/*
@@ -1680,7 +1696,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		/* Clear accessed and referenced bits. */
 		pmdp_test_and_clear_young(vma, addr, pmd);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		smap_clear_folio_referenced(folio);
 out:
 		spin_unlock(ptl);
 		return 0;
@@ -1709,7 +1725,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		/* Clear accessed and referenced bits. */
 		ptep_test_and_clear_young(vma, addr, pte);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		smap_clear_folio_referenced(folio);
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();

-- 
2.55.0



