Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE983C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:45:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E62086B00A9; Fri, 11 Sep 2026 07:45:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBE146B00A5; Fri, 11 Sep 2026 07:45:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12BE6B00A7; Fri, 11 Sep 2026 07:45:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 928196B00A4
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:45:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1BD81A01F1
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:17 +0000 (UTC)
X-FDA: 85201300674.28.9DC2D91
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C860714000F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KgTQH7cN;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789127115;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UCrSvqhbJm8Pt3UN0nqTBLN89dCqCEGi5Go/vrs2SQ0=;
	b=w087MeBtdhXHnYocpUndtDO82eYcJZv/ATObRsrEHaixwzzICh3wzBF7K6DS9M97FyymUU
	qWzIClseMfU/PqkzSldOcFAhhYHTOc10H67PYAAzmGisM8SX4772ZnNzFQQS9djF9q/KI3
	bSevC7/MWVIMy72ks8ljwtFL0M72F4w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KgTQH7cN;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789127115;
	b=Jy07o9I7yPvwDq77XsEFd9ig/qNPV96iembAcEgtKrnW98hUuq0Ltev8G0ARpvJCYVhmWb
	J9COGCDZ1RRySt49IWjVYnuXUlNX72G7SB6MlLTdSckKXTWgzD7GP++TFPuIvUF8R8keRl
	Fa5nE18HvqlG9ltZFMjRtsQxfE2C8vk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2EF8443EB7;
	Fri, 11 Sep 2026 11:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0FB03C2BCFB;
	Fri, 11 Sep 2026 11:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789127111;
	bh=YOdph5nvch12sC6JwUaX69NGEgkBUDjuAafNjhDel6M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KgTQH7cN8iTuJl4u0IA/2lv/w1Z0gXR87UFP+dzuTOXgNTWiLNqyHwJpPbcugJrDF
	 rh7BvMcq3e11WIMweukLNVz82ouJdTZXnKAx2NDief49WT8QBRWVVvI59tUXTyae5E
	 iWI4jW3lNm+J/WIQd500oWbKae6uTAMnXjhqSYzSn43/WB63WbBSMRgo+qJax2ekLG
	 1rVQarn1ZSq5Jg6nJb5ynfEZehFeQCYqJ1sG8YtmyR4p89TZGlN/pqIcLyrYputxMD
	 UPj9y/g0b0Q4HKVYtyV64LcUrtDdJhfJfQBCdAEJUytebrLETwQ/e0L8L6WqzwL4WD
	 RnUKgQA/NiN6A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0CA5C88E50;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 11 Sep 2026 19:45:17 +0800
Subject: [PATCH RFC v2 14/15] mm/khugepaged: check folio referenced state
 via LRU refs under MGLRU
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-mglru-fg-v2-14-f26e5cb26da7@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789127107; l=1294;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=zchwlwZldDLwVx1Yq2g1QvDGVk9gZBPpwZe0aRzvkdA=;
 b=qjywNahDHCQVaV3S4S7QIY5jyXUEqesc5qZ4g+OelXa62URAQOi7WM0+TdW7u7NEhmJ2RiHIZ
 lWk5a8pAJd4CVHK4G3U5Tqb0FMS0S4a4xTvJceWp7JkrGpHEFP/v5Ou
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C860714000F
X-Stat-Signature: hxn44ghhwpu9dw9tuz7hnmznkhtu5z48
X-Rspam-User: 
X-HE-Tag: 1789127115-554413
X-HE-Meta: U2FsdGVkX19xd81B8fEkCcS4kuFKFuGg8PLe40RQ4Fw+/CbBDhChna0X3NITZJ2uIygSdP4VWfqHAdPxiUJx8uoDBieXfenlmta45RSXTDz1av/Sm0UsjbRqNlcH5ZHIhqLcYI9wVKUe8PLzodU0ULrnIHmvkHghn8GMNzUZO8eM/mQB/gfWmSzvpjHmqA1NO7+LcTi2t7FkOguu+szgK02KbDyP0Rbmj9KaLuYtOArcXfVvz3sLSQSQ8dZi/U/tRCl/+r4tRtu4W8gDjJrAvE+7icElQhwoh4x1B4axVdUycya/eyvrMUVNEqf4NY6WNwbEEkcm2q/pPRFmfNkvm5KTSwHmYUT49dofR9WzWrPBouqvw17yDxOUbEHmo6usTDNCsA+QD3uTJpBXkRG/uw+buJNsR/X88sT7mND0GHyckzYVA6hT9RUERF6YYEfQq2dv5H9uwbcxDhTHLzAFjyJUZyabmkKaIDLBUQ/upJAtdI+Tw7TyZYxYBZG1DIbJey57qn1vi4XqqkXb5nvaCXCn1WOTeEpTIxZDeFA4lNPnch/heLFpX04SdOHeaW1zrTKzr4ZVBqKCE2nzbNKdX4mGTLMVmXvsYbFKjTaT30Pdbe1vwD7aqv9UkLZN2SWsHnIL/hMra/xZTTSvb5kSAO6iNDw50CZUiS0P+Ab6lkqMzKOeSH927ZcfcSGB1DBCTqAQJHOamG6oydvmn15UlcXCWgTv5EvE8+naomremlMIyP8wsbcqrRcSrNUekAXf0TtWUST6OZ+bbhgJAcJ2b3ogHHwrSmmaAu+ffLLrPNf0Mx1SOJkezsicADBdLB3vkEtyhkEzPVBQAU+/JXc2/3MIH+28Y9mn9o8H0QY2IYQpWGbK33lvwCi/LtEV7+wy1FGLg6gSyHFMenqiaL1MIUj0PVmwrfdHC9guJFrlw5N0uT5VPBrF/6U7sbpwxBPjn4Xs0OIA4LFlYW3QYma
 ax08BTUB
 rc4exmgSKaUaKAoGRC+YpMWW+aZGmtGtU6dKIiMijSv1PZwUQ72h/Xtw1VpWoklpmKlf+jJZqMYq6Fgts9B0KybFGO95Uaqa81VsMHEyV/Sa+Ln9NR894EVCHxe+nj/E6ZYUA4b3FjG4V3rXRraMtN9phekvYD16bjiA2KHpqj7FPYKc0570Hr30R519Oxvlth7U5z8LY4Yd5XANzJ5g4g7yKhD2xC8GTXKWPYLmmLGzk/QHfO1imDmG9faAd/Y3raj8NCxDjKkBMwWQ0P0KlABbeXoxJg+k3VYRgLxnvw9gUYT40zsBpG5jyWgJIujJNgppCiSpX9QpYHs0GRI6knoLcCfxYXPg+EQ9lHi5p2LC9I1zt+MIUJd1Bg46cpdHW0BXLusJlisqph5A42ksQQmRSqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

For MGLRU, PG_referenced is only the lowest bit of the folio LRU refs
count, so folios with a higher refs count no longer have the bit set.
folio_pte_referenced() testing the raw bit misses hot folios at
refs >= 2, under-counting the referenced folios of a candidate range
and aborting otherwise good collapses with SCAN_LACK_REFERENCED_PAGE.

Test the refs count directly when MGLRU is enabled, mirroring the
smaps conversion.  The classical LRU keeps the plain bit test.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/khugepaged.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1deb74cf28af..a3ce6735bc32 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -597,7 +597,9 @@ static bool folio_pte_referenced(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
 {
 	/* The folio was referenced previously ... */
-	if (folio_test_young(folio) || folio_test_referenced(folio))
+	if (folio_test_young(folio))
+		return true;
+	if (lru_gen_enabled() ? folio_lru_refs(folio) : folio_test_referenced(folio))
 		return true;
 	/* ... or the PTE mapping was recently used */
 	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);

-- 
2.55.0



