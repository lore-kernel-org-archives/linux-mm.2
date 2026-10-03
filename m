Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53CBDCA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 12:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E73C6B00A0; Sat,  3 Oct 2026 08:55:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF9B6B00A2; Sat,  3 Oct 2026 08:55:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 686096B00A3; Sat,  3 Oct 2026 08:55:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31AA36B00A0
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 08:55:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2ABDE40219
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:24 +0000 (UTC)
X-FDA: 85281310968.20.8BE3269
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2AEBE140004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c32oFIR9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791032122;
	b=Wb13fTn4EdrVCKZkAoNYwllhbCpeEGUpaFb22Yhc9lUbnmU3sYRsuswpk84Sdq/u6dkGr3
	jREH+mSro2YTUze8JeA0E38W9h9VeT4sjkc9s2vNRiA6EYZYGaf+OvvueUVFda8cwmTRV/
	INpPyknUtvDLNdz4lkzcsv8iplqBdIs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c32oFIR9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791032122;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XnpIBOn1pTQ1Hz85IuqIktAY3MS0cJzcDr8jZXIgmU8=;
	b=DpuqmLmxStybuyBxEZ02gKLrCxVqbuXH4AIIt6/fTArTXYIduXc7YqbmRoTDcGPExivZtH
	agttHHWVMGjezKbp5tyyLbL8HI0pTqlp53OF110zTqxYFbWZh9HMg1MuV3dh4OcmiyHzPr
	WTpAN/c7i/d0fysbkzZ/eBG4eJC/kYU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 872E94486D;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41D15C4AF17;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791032118;
	bh=ULAGVc+auWKiDaGzZiCWkagwQn4LoNUkChi4b60J8n4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=c32oFIR9eoq+I6/t9nbWbGigfva7VrSvkgEgTWSloImx0rxltrwONRWWAZRPGbRY4
	 I1ford0Oo3SE47Iz71eFp7ZNLcmAGL1CgiC38JcomrhHYUaPW8jbhnPIt9j0KeoDl4
	 RQ8rf8PFdTztG5PnDpsRIw7BsEzKKD8Bsfc+9db6xYUtnmgJEjXB4f4Uane3Oliv6w
	 CEblA6UEZ+gCDmTxJLIfEEGK1EUdW2Mv6ZcCqAyRLxbT2NcGmDz+L1SFqBfr8MeBQX
	 pbq387vz5pZckr3GfLTAhrlcGUuOCZ//Y3X6/kmVm56Q65uKK+hGz2+1fsFNVjG/ri
	 CitX2oEz8ranQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F3A7CA5FDD;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 03 Oct 2026 20:55:22 +0800
Subject: [PATCH RFC v3 11/17] mm/huge_memory: mark file folio as accessed
 more accurately on split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-mglru-fg-v3-11-cbd4546a5bd9@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791032114; l=1826;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=4UXjU6u03Uo1PKWHrPk4USI+uaWZ1R9QRe0SPdxFce8=;
 b=2G/u3ALUDUKgpjR96H+vdJNxsrvkTCXvQ2RR9oysMUnmn6nxIBcZnJpkdpLyCNTTN6njbdfrA
 q5iNPuIPyYwChcHvpnpG5hcy5UXUowBDphcu59/qtzId2WnYvrovn/w
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam06
X-Stat-Signature: 6feier3udk6n7xb1s3g938pnb4a943gh
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AEBE140004
X-HE-Tag: 1791032122-465215
X-HE-Meta: U2FsdGVkX1+5hhz5s0zYDcd8hl9WWsJCM+0OUU8VDnSrBpq6LTG7/bmdSB1kvzTkM3x1CXJ6aZyWtN6J79ZhLG1igSYAxm/6IXWl8J3jiok7rvVN3JhmQKoSqpWYd4DciPgLHJ+nRsGm7daD1gYqXIqc+NOpFArlLgaufhIdEbkCbppytHRC6GUG2sX3z/aSawcQe1cZVjZcKLddfnB7QYTf8W7iwC390QlXjOfNC2wo2oVgdX9KSNkZiRrA/vOsNNw2ZUoqm/ByKCaOA4KgAwky1yc+wEw7vJuAS/wgph1HOoLnMxuWwDaApbc5/+8TVdn5nYwY1Dz/aH1n8v9SIB0q5Ed0pebLrskzKwLvwYcSewJzkUaWCDUVyfzWVllr2sa4fnM+h+KZD8STlSU1d6M5UsvzLuIyOxIiCbg6GkMhGq3j+HmSoDhicGn1auB4V7ebeRqDkLkhk4N2V11dIVrYFxhrQC4aoKoYqKEXJJxVeyKxshWtXSPVe6ygRdYgCQ5hD+wM9CTrio747WVclM6AtgeRi66PVIHin/E9YwDZkh/ac/H4ZQLui9X005n26lp1n2E60c5CBnfiXK26SVesl5gBWKJQ/vktsMvd+X8m0cWHUnbAbm6fuD2H7Q8kYaa66onK40Qi1EY711941Gn9NquS/dfR/+QLTSGrRcKkfFnqZgz2EeegQxGkPWWWz9AU+T8eTK+kTxsRhDZMUdC/8E0BInZN4tcrNzWyu0FMVPFBBCR8nEgGUefBwH3R0Nxbq9dZhkB01tywU5X+9kdOSwVeOQCt/ziS7KcmYV7U03Gza3HhfMyV0A5Uj1ufiyOX31qsrylL2lYL/CqGqDEXfVQ/BzfBgWCkfaQqcO9TTvBMPSJBwx0RjI3ERLqkix64sRlQxcJKZO+c2tYZj7QHfEnBjkKGzXBt5oaLJlWvaqA6RDagM1mPkrgK1dJhfZ/5EFx4AKwehcHW3MF
 4lad5tWS
 3/9q5FaQTZCjnD+brkhjThY3Pczxs9VAaQpT6qW8veztDlVleG+iphwHTBNLv0s3V2G3Pb9Qv1z2UjGBrQqgvfTZRLr4UZlfhR0FEKeMphg4h3E58UaFQ/hdsTb0fnNnbCfxfnWdGNSdO/Xz1BUbKsWp0/r0hGUJNJMIacuoZQrAgRTR7HxtG+pu/0uHLOz44CsgkfFUJyQt1h1N1VZb3lJV0VGaQoaWnA1yRolwsR+haZjgnja0+dWnayB+cJ//94oD9REhDygBaNulEIwqu/TTvyC4UR+jz82TbdIYeiAdtukOv8LV2HnpS81me/Hq9kydZiqlDbRY27EmHiNp19r1+n15QCoWWsEQQi+Hus0lPoKc0/b1mMewA13fTBzM8VqM5dJsEmrJaI4EckX6juZQw8HoU7nTn2AYvgNlVU6EytN44oE83ABFKUOvtuqsxT/BQ+Fgd8JZkCYGHwMfpbv6/+Uex1Ye/DuPiL8CnGhge2lpTEGo07SVZvg==
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
index ddc631a388b9..f3fb6b97f3ce 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3094,8 +3094,8 @@ static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
 
 	if (!folio_test_dirty(folio) && pud_dirty(old_pud))
 		folio_mark_dirty(folio);
-	if (!folio_test_referenced(folio) && pud_young(old_pud))
-		folio_set_referenced(folio);
+	if (pud_young(old_pud) && vma_has_recency(vma))
+		folio_mark_accessed(folio);
 	folio_remove_rmap_pud(folio, page, vma);
 	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
 		-HPAGE_PUD_NR);
@@ -3217,8 +3217,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
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



