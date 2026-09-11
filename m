Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B445C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3A856B009B; Fri, 11 Sep 2026 07:45:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7B1E6B00A2; Fri, 11 Sep 2026 07:45:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86E1A6B009B; Fri, 11 Sep 2026 07:45:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B4B56B009F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:45:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9803A30F7
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:15 +0000 (UTC)
X-FDA: 85201300590.12.795F436
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B9C8D14000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7U5owHJ;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789127113;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gDni6kh6Iy6PVnWV7fAXj+Sxx9t1NoAlJVLSrFH1nWI=;
	b=5gf66l703NGk516ky8Kt9g6h/h/BD78lVwoi/oEBHiHxgNwhwhvS7ztMoUWQ6pn3nRF7jR
	HaAM65RNHwmbq59pkh0NLAlXrddwmWYcS51AuKyeAZWLnfImSFdqzerUtdpjx2hKpFr3E+
	px4sEElGynie/G3NvCFhTbSi10IQZ3E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7U5owHJ;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789127113;
	b=DZbyXA1bRLN8gitYk8+5I2RQuEU4Ie4IHoVN5NcsFfQ1sCNC07c6wdM9RkCZ5XvcFBbD+c
	hyKJGR7oAVfGAx/6kO0ImJMNiX3XV/iCRi/+T8XKTB+j4L5eaMayCIOJR7Ac90x4RhhXpK
	HQ0ke/cORjhxj7/27MkUbvXiU7B6PLA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 94DB444821;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68DC9C2BCFF;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789127110;
	bh=qAq/J/sYfG6ZkVcfim0Zo7HRre2y54mXkinDXrdmMHQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=R7U5owHJv1EiXrYkvh4qkTXdITwnp8F2b1jM5gFpgcdKz8MBEfZDNZbBpgbc2hR2D
	 5Ib3SDxm4haP4Eviv5Qvk1M82u85pqqZzZi/2kU+2iMu8phiV8tRO/TpsCU3xrO1Cq
	 nq8KHNIbwxysf6D4VdGwpdcNttILC8jL4PRroJG67oOGW1/hdnts47VktmDrCaJnYr
	 4JKE7/banh8q+I6V4pqqKwrECqz1IwLzdAap3cBDw3yP0Ob4ND/w5dfpHReGUbw9dT
	 AiBe70kTraZoFkcuoFZn2hJvGDmvuKSEN9BkAdubUOqnN0zOLxTwU9nMRI773JT0v3
	 kmsphNzFkTD6w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF7AC88E4D;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 11 Sep 2026 19:45:10 +0800
Subject: [PATCH RFC v2 07/15] mm/mglru, gup: mark folios referenced via a
 fast helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-mglru-fg-v2-7-f26e5cb26da7@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789127106; l=2592;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=76hiJ+IqCKnuaQ/7hlfV8Pomepbu2+G2JAyXF+7DflM=;
 b=S+M7djq6ItbHCmZylWQyxNxFu67PRNPY5Uj1bR3LDiXAhZwDr8c+jDwGogPiatHHiJwEqUONs
 u1VPGkYohVeBa/rPImHUErKPffukw6+HzwzE2VJvJS39L8JCoSuGWvL
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B9C8D14000D
X-Stat-Signature: xy4hg9usctgcccuqo1x7ytbmy77iphg1
X-Rspam-User: 
X-HE-Tag: 1789127113-241662
X-HE-Meta: U2FsdGVkX19COGoZRy+WLgHi4PkA34jllVdjzEysW1Lqm4g+/1yMDSp6GUb1cAlWXC41gGXqAYynr7P8Brojrm/XUhH2LMDstGQfbYHr/vTB55vQktTpa5SDc72iR8dam1oJtFxfN8Zdibrn66RYxA7OpZcVUxVLHaToZkRpjt2Xxhs9lSFqFIfCf/o8KIPjn1E6nXgjewnh9mPqXw4sO06U9w9jBsLlg5c2lswJDuy8raeLTMijJGVB+bcrXdROCZ/TGv0z+kO2psZm6nsFgaZYB4B3FRjUy+M44fUQBED+eVA7Y5jPmdBKJ7FSQ6o1JcmTJr12fwFCeIxnG9I0AOpBQJIy9caZXy+1ObRY8me5MFm1UyT/e3OIqmFgPFu/v3dcYJKndv4AYpqjG2TfitDvc3AnLPLSQ5PfsBNAtHNlaJCQBeeww+2awW+VX5Xl06mFPkHQMmcykrvfsMff7qmTbrYvQNNL/UB+ZXlBv2FQYJpgTrdY/eL8CY8z689dHAnl327anUm78mFKRhCAgF0yed7GC3A7kqPD6D98ZD+veRQWXOV8c88u77xADsbxxj1C0+ckc9np9JnY2bLmVddmXULFXk4XhAgmhZqCPEMVBXFn3ewECcy52RwByVRe9ySZBwdaKOOqXmqZy/bIFWyH0+3+kYpfqvfFPMBWj8j9Bc4jrCMVTnLsUXiw7yaCjddkUnK7g9x/C2HxLnVQ6HBuQ7qSc5vL+MDysFoqHHq5VrI9vQo6wGW8BTfQqsKcrmkbqPxPf2yZMFv5TJQd3RXxTqS/PXis3p3Pv822veF15pNm4SqjVdGoLzw1opIhT7rtbPJTsBsAoHv7LEJzcDuhKoAIAvVMCJ5Lj9FC/HLCd/aIXCqip9IHvuvDT4GkXP72XHgGtnl1qTkKcqs/nwpSLKwnn44BGzIkRuSUxsxRqi9vVSeumpTrTc9FkVGS/B1eQ2khAz8k/ByxfdJ
 LpIx1ES+
 zjHM+vk8WLgO/pYxYKNXHNq3XCFX49+dzo3V8w/wi/4nBLFgapafV//YDOMLtT5uzsms0jEaqfG/CkrQZ+uxbzqzbU+CMNyj22Yqg7IRVPbLfX7kXoHWt2y6gexlyid7TOa8iA6RHQJrEkxQZ/Kowrun0P0/S0myiq9ABQ7ZvN0cKqKmeOrHc0qzj5DEFGGBP+qIJA9rGiwEFf/6Yb71Ow/JpK9J0znh6zc+HV30+LUkRRKBPluuqQlVmMUlxO5RGlWYZkxEBcnYaAnvQHHwnXxTMwY5agVO7N14QMuD0hnZcMGXzSRzC8ywzN/2EFPSsDOhch6mGXyHZ74PfQkdTb7rqzS+y5jkp6Z0ii6DIKyME1ogYby2kn8m9i6YjMexhelItI+nflemfFvWdfINPBnUErQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Introduce folio_inc_lru_refs_fast(): raise refs from 0 to
LRU_REFS_REFERENCED via cmpxchg, or just set PG_referenced for the
classical LRU as before. No counter update, promotion, and guarteens
no other complex operations in following commits.

Convert the gup fast-path sites. No behavior change for classical LRU.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 25 +++++++++++++++++++++++++
 mm/gup.c                  |  6 +++---
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 8700563dade8..23ddd5d78571 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -439,6 +439,31 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 }
 #endif /* CONFIG_LRU_GEN */
 
+/**
+ * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
+ * @folio: the folio
+ *
+ * Raise refs from 0 to LRU_REFS_REFERENCED and leave hotter folios
+ * untouched. For the classical LRU, a plain PG_referenced set.
+ */
+static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
+{
+	unsigned long new_flags, old_flags;
+
+	if (!lru_gen_enabled()) {
+		folio_set_referenced(folio);
+		return;
+	}
+
+	old_flags = READ_ONCE(*folio_flags(folio, 0));
+	do {
+		if (lru_get_refs_flags(old_flags))
+			break;
+		new_flags = old_flags;
+		lru_set_refs_flags(&new_flags, LRU_REFS_REFERENCED);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
+}
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
diff --git a/mm/gup.c b/mm/gup.c
index e49f020f721d..cbf609dc8866 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2899,7 +2899,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
-		folio_set_referenced(folio);
+		folio_inc_lru_refs_fast(folio);
 		pages[nr_pages] = page;
 		nr_pages++;
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
@@ -2968,7 +2968,7 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 
 	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_inc_lru_refs_fast(folio);
 	return nr_pages;
 }
 
@@ -3010,7 +3010,7 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 
 	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_inc_lru_refs_fast(folio);
 	return nr_pages;
 }
 

-- 
2.55.0



