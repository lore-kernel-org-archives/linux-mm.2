Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD2FCCA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 12:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F34F6B00A3; Sat,  3 Oct 2026 08:55:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CBEB6B00A4; Sat,  3 Oct 2026 08:55:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06BED6B00A6; Sat,  3 Oct 2026 08:55:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF9B36B00A3
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 08:55:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1445D1207E2
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:25 +0000 (UTC)
X-FDA: 85281311010.23.AE9424D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1E40BC0007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yxg6pmAB;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791032123;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1IIpACySr11LVVvF8tSpe0FTG+3+rl0DuLoakbUlcEg=;
	b=y8vS10L1+1EYhErKP9hiDE6IifmoSM3HLvT3rf9+1gwOIs8YzhoRWu3CFIF+Bp++JjTiZc
	/JwZg3YoofhiZNHUzaZHptZdRYz/uwIl0WsuNhaamW9cJMJlmf+ovnf+3Xda6/sWsAhLN3
	pcog9+tRIeh9knaZO2C7xvmoqdeWY18=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yxg6pmAB;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791032123;
	b=IlOAAaBs8KN+cxYLcHepwXzeQlPYS1QEl4KO/HPkWRFaTw/CmMRip5/JD3cWd2n0mtVHT/
	GtGGCEXpBhbpv5rcAtbZZTf5RzqhYdo4FDv79+6HrlnxPwoaQcZiEOTFtPzyxUd+8D/6Xg
	dtvc910MWcIxib4T3SldA4mzGdMSjXE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BB6444488C;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 95F16C4AF13;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791032118;
	bh=rHvF9nUiy0njARXgH/Cp/T1z5jM2U29y/ktedodrPE0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Yxg6pmABxZJerVBwzDLhodUC1Hn0wRwiS+kh8skxZIezZ51kHsBh3JZ74O72WCVgF
	 Xf0tV6VHmN1Wnqy0+HR+q8Ori7LD3MG8nM+zltPfr6ILRtwkqBLj1bvYFLGJSb7ExX
	 ODQj/kk1AQylcNkeNbWPCLEaZaJYy7nVL7UCN0Z3jyJrIwmRCjoPw3s47j5xR9QAlf
	 lWTcEv3zs9tUyQYFIGERMe1UPz9x32lvIJL2i3JcTN3rD9BKgBIenzX5kwkbC4XzR2
	 8Mau1dIXGoE4SGG6ag9ZhYjMaQCMn14leyFzxPath5tLSEFz+b0A1uknSKKpvtzEo/
	 PW6owksbR+vXw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F9E5CA5FDD;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 03 Oct 2026 20:55:26 +0800
Subject: [PATCH RFC v3 15/17] mm/khugepaged: check folio referenced state
 via LRU refs under MGLRU
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-mglru-fg-v3-15-cbd4546a5bd9@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791032114; l=1294;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=34PwfKs9OBNdti/LpG7ACAK3kbx7iRvKh8mLMU2xWsQ=;
 b=V+2o5HJsg+eqUnnEKRTFJ8z0QmeRB4cs9huLBv4bXJmW+rvOy4ITmRSAP24ty5RlHuLxsf6rS
 Ixh0ujwFDAsAhI/P/mDhVvz0fCOCZPS9A6O3HAmJmWynqnNdRQEoK6r
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E40BC0007
X-Stat-Signature: ytrduibqgj9sxrwxeomaa8gpgpdgne6y
X-Rspam-User: 
X-HE-Tag: 1791032122-674659
X-HE-Meta: U2FsdGVkX1+ZuZYTAmzslKLl1fioYovAf+4Y98c1jYIfgnRtr3gEfl2HsHT436NlPXxve49ghak2xsUBs7jAYjKdwMRcRRUcIxnHqUSIXSk9+tg9t3HQwRF9h0G03Kk7BHYwVwI8cIjIrnAPB4mjGiBxznEcQ8mBDBFYoDrLjAc1NpPzTQ5kzWYxWH2mGcwnqszwEalAdgoioUxeO/peV5Zse5F5GgIQSy0EtAGLwgKr3cgXb7AUJ0vCybAKLg+buMmA2nvyA4wiLT0233fzgkvkvzMhCyHaeDqz4UL1BoKbg9OI3UzbTiQF+tK4OwG8giSU7YaoUqh6pxWNWQFx6VxqP2V1A8ehbe0NgGBJpx57/HQ5UX9GdLnWuOI5DxHwzr3dpbdrWPEWf4+3Q+c6ht0dB0tvEQ/+yNuoNqZF4mg3Fic4bDUSyi2W8dXFjWKB4oOqHBnBIfAomPypcFzN32/He/sdBB1hlgKnovJvprKQ7jIRbRKHad3Pb/nMPGECNWSoo3tqom5Jvy6hKqfeOj6A1foSD31ZwD7fhXhTVjMApBVxrpT6UYxwy1ziSAjBDHKaqhfExuro9z1zRcWr1R01moiLls54/k54MxCaPx5VnFvIu3/rQSRdMr43eTtffuUHSkP0/Nbmf3UzuWKdEwf9YZmZYSMaoOM0rZhD3gMrFXO8iOgpulKu2SzFn/A25NcjRVoFc2fSLjYZj9Rdv3AYSTMyiEYKMMy4g4Sr9b0zsCUasWJn4SExlm5whS+0dGu+eu7oein6IyRY0V6VvHoJduJ5dPTq9zEuQFuSSRCKecUDvK0xziMC92ouOKS09nKeWhlcTX1IuRf0C0hAYoekKZK9gro8WBgJp+qOxJHNxQt1yzDv9TDeK2Kw78gALvQITngnCvVo5WLzp6gOVLnyr46+ZDKF+gAIgDjXW/QqfkTjcmv7CgvZUio9UW/mcQ+z73YjIm/G83AkizV
 ZRwO+wgP
 3pXyTtdjNi4UYDMByqmT7fzA8B8GLRYrcZyNf/IkhwHQ9Y3sXrPM8O/e90ZlwAH0WuZO0qWxtMD31+VLqnL54JU81JqTRZvoutzeW9RLeGgmFprYZ3iXR8/kJeLwEltZNVRPzOg0BCANRSpqjn1uYg3FUoAP6s61REHZITz2R3mJO891xlhQlZTBSu1PNGbrgxxvlurrZHGGVGNn0SezvLVVBTJbkgfNLZja1eDwIkdRk0wjEzffa14wGJIqOz0L60sT6GWCdjqGjv5JQgoSWLZC/W8pKTSfJQ2u82svRHZ/OytlOYACR0FToEDZaq3WSpEOddhd74sNhETgUqG+KGs5HESYvA9gwtwuN70mBZF738YnkGOJCMeP8KEI+MaigPJbWFMXhY5qQBDljpFNOXAwCL5i/zhtm1RL2OAKU9fk/rHuDW6sP0xbOW5MwTSMa96V7
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
index 913086eaf17b..be18381c6efd 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -586,7 +586,9 @@ static bool folio_pte_referenced(struct folio *folio,
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



