Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5CADC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:45:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8912E6B00A6; Fri, 11 Sep 2026 07:45:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A3366B00A0; Fri, 11 Sep 2026 07:45:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6461B6B00A5; Fri, 11 Sep 2026 07:45:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3198C6B00A0
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:45:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA80A160171
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:17 +0000 (UTC)
X-FDA: 85201300674.23.9D3B19D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B480C180009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ux0m74oD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789127115;
	b=ILQMK+mIp3E+ZsdaDyJ89E+aY75u8J48fDf2dQYNz7sK7jYF5wLTZhxzmlf1oX0CBjzqDN
	pe91kAiLy/Cn6dzMI5iCqN//2Ts4g8IyBDpNBG+jD95y4sIR2kN9TVoehsqawpNYX55m5t
	zRrI43PmaQNmYHMo6O1ifPJzA5u9cgU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ux0m74oD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789127115;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZgH5zpbUJDeVIrZYw85Tk1pqJ4t3EufolEt/bMD3oQA=;
	b=Ua+qSK1/oQBZY8hpcHgjLkm7zGxr/yTa/7bI0qpakZZPPtZFS5goukgbyX+Qs8l5MOmQ7Y
	VuERnEoqdPnHMykQvm9GEqJUK74eWsKsWHYlyqxAl/MPYKM8zACy/eNBLgnfd3HgS+oA5G
	Ls01ZGwb7dqeA2Hzd2fnCZdvtHfMrS0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D5BC244841;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B257AC2BD05;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789127110;
	bh=/lY5gEpGTaNwvlEKSxlKmxu6E0txXFkrisGXKy9UIIM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ux0m74oDp+yGQG+hNIorZkv96QsCvcJXKQe8+VUc0VhEPrY3atv1d7NPwrhM73IwI
	 2KujFAkYzr9/JD6HMpytNwmQ4wuyxBWEqRVDcZoFLOMnIQy2Exm+q5jSBXKa5JJ4to
	 AJeapC6LjRTo0muHaX1O8npqN/cu5CcYrb1BZNbZirIZBkN9H3U5s0bNBzuerbtZ25
	 /cTRUVrEOUTA56VaC+nTKM7Wfj0MrRYNrxAembYcnfgyywVlzHUqM+R4sHblouFqzF
	 8lP9nMWSDbxF0Iw2vFVmJiNUiRrPcIphBitAH9iIKNc8cWam6cydrvzFILuYV6FaHk
	 vux0Dn/Cnsk8g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CBF9C88E56;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 11 Sep 2026 19:45:14 +0800
Subject: [PATCH RFC v2 11/15] mm/huge_memory: mark file folio as accessed
 more accurately on split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-mglru-fg-v2-11-f26e5cb26da7@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789127106; l=1826;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=zoau8tZvqlE+jd7BkKrQZbu0T6b9R97TMFLg8Qf1U1I=;
 b=Q9MKka4b+M1P9Y/HTzprHKNwsHFN5f3Rg6ebAfiHu7JNKa5bNTSpVuoVn19vKxQfNXnH0hG6T
 PgqMtiabM7mDyD0RBXIhSPsvQRj1NX6FvphJEYpX3bQSPKZtnEOfAzj
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B480C180009
X-Stat-Signature: munbq4odpt8fs3rfg1dp1kibm3wfhxod
X-HE-Tag: 1789127115-696303
X-HE-Meta: U2FsdGVkX19551axa9UXnnKEygC0P7NVAzU5HYJmDuj3YCq0SbeYWKauSf4lbSs5Dm4wT+kJUetweGVIF2KybFVULXKdjAhkpeCcHDw3Hz+HRe/aBUgbpLxa3Omq7FcD7KI8ICVwfyJ5GD53rXWSAmJpLbdgtaDMOt+wyvWoOAw9N6qNeAoHaW/qKy2tW6qhd71f79qLl4F1mOuOgmLMTfJNNldJCNOr8qs5aqKR5Q/V4CNk0j2dft4kuWhUGacviidFKgzPKj49ZDMjrSbgwg+JTlTY85T3lFBmsnBlW2TWpR1Pktdo39061ESeBcjCdlZ2Xpv3tbPkkcuERJCpeC09Ch9nj6hwLw4OSCLi3dEjtxQQ4uJd23aUQdEsjBb+Dqr7JSK+W+nW5HrcesaEuoW0bxWfWoMH64Ac5Orq14QIjPjZc0yu0lMdJskSN6u00GvtYUlxIbGlIHreGovNDkB6pOvOSKsgjUhyp7IAZKDjC/l+kn6l+3aXVU8wMXW3SsmAWv+qcQNvhiTVqY47QtMZqhPKllZifW8UvQJmxmSr+OYwWPYXZ/r/3OIsWZD7uqBgg6riexW/Mmo4T/uw7XHN2ehD7WiZNSneqdYc6oxRyGqxDJUiKKNzuCvjKuVyi2VpC88SCEsBi7zUKmJ1SQa9lYwCf4hhIow81hheXG/MIB3tM/g0s+g9iR48PkPmbC3KxGd1eY6t1FCZxNC4v1iOxDNRG8Il11XfHzUKS1gme+nX2qlsoe16RcrMLxACvLYI9z6MJwxGV0417irZRraltp1tR3zpBAlH2WEbJCcdSjpnq9eDX6E5HhnPzAbfeR+nMm6Lq9nVRuwVHLmTCPCzNFskoqcTlTo3PxB9TqRXfQ+VS8dWokw7y23vlolqtdgH+uq+Ba8UGVRtCNXH7p+69QIGHUoX0yFWl83VTJrOVeQ61Ijn25d8WVdhUdbUAIoKE2dKXZnwyvLLpaS
 s4aS7q75
 KyBwkQYM9xbHoWCGbUlzq3j9nIGui65AFTXheo+22L5DLtyE/coYY3JjWDFYDtaMcky4uHfkUo6wECSze0Wfnx//uHZXUT92p6X0JIS2q7WHy5DSRycZ/qbGzaLVdC+vR/InMLvWUYTO+ex6pARUfQrfsm055gJaiarmAFpztzYfMDSEQJZdS1DFuUXz23EacXbKcoavo5jwEICRNgJhWQV9wO1ZKHiAQCyK+0mI4KBSWTuqAM4/kXcCxgRAw6gz5qFacC2WiaqWCkJfj2x+W8T5p2T6fA01GX1+o0wIAi2dh8lSytYN7WRP7Io9M9UA9828I8blzcPqIXCK/Sp8FQyg65rsXsoPMw06uW5lpVcgl8z8v8JdfaqJZbd00reRpHMSEGBMa0aZTuTgsNYtHds9h6CfFbTdgOFtfcVoCCFNHVN7Ctf08s/Ah22dUGrkT8AHeYrh5zL9p5QA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The behavior of updating the folio's access info isn't consistent for
huge mapping splitting or ordinary unmapping. The page table's young
flag has to be translated into folio's access info.

Right now it only check and set folio's referenced flag, which isn't
enough since folio flags update on access have its rules. Ordinary
unmapping (zapping) calls folio_mark_accessed(), and it also checks
if the VMA has recency to avoid false updates.

So first just use the right helper here to be more consistent.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 30b7c63b0e35..28a9aa4c8b20 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3109,8 +3109,8 @@ static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
 
 	if (!folio_test_dirty(folio) && pud_dirty(old_pud))
 		folio_mark_dirty(folio);
-	if (!folio_test_referenced(folio) && pud_young(old_pud))
-		folio_set_referenced(folio);
+	if (pud_young(old_pud) && vma_has_recency(vma))
+		folio_mark_accessed(folio);
 	folio_remove_rmap_pud(folio, page, vma);
 	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
 		-HPAGE_PUD_NR);
@@ -3232,8 +3232,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			folio = page_folio(page);
 			if (!folio_test_dirty(folio) && pmd_dirty(old_pmd))
 				folio_mark_dirty(folio);
-			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
-				folio_set_referenced(folio);
+			if (pmd_young(old_pmd) && vma_has_recency(vma))
+				folio_mark_accessed(folio);
 			folio_remove_rmap_pmd(folio, page, vma);
 			add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
 			folio_put(folio);

-- 
2.55.0



