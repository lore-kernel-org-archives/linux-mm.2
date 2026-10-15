Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4662FCC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE4136B00AF; Thu, 15 Oct 2026 14:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94166B00B0; Thu, 15 Oct 2026 14:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34BF6B00B1; Thu, 15 Oct 2026 14:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A6E956B00B0
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:16:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1863A1C036F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:03 +0000 (UTC)
X-FDA: 85325664606.12.98A2D7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 136D540008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LtTPvZb5;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792088161;
	b=SEOyLdSG/hpiyy7wzOE4Vq5h/tJ3N9CvbqaqAme5oRYUBeM6E2NafXN2QKt6ARFAcxn2y0
	/p8O/CUrAj3lfR+INAuS9r1KfSp/yKFReJOKyApX7DMZHU4oKYwgKUnptaVVlQU1c2dXPR
	TqcSmGrGzQOW5yZ+CeSaiyebX07lTWU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LtTPvZb5;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088161;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rC+/Ko8foI4B7frExakx86/DA5drDHOxH+7nsKqmB08=;
	b=Eh8PTv8XP0D8LE0nQ4bB6K9/sDYqkwFGTEWwd0dE9vCqeOg2STruOXbD6Jm0WGs2MDG6EH
	gXFjOqEtZ4w7W8Xkw60gzpN8sanPbCf5aea+qJxDh7E02lesC5aJ8wX34f/piznBaRjRPm
	KPUa39WxIOtSa037STrKxJDgdFj0aTo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 36DB444803;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 139CBC2BCC7;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792088156;
	bh=8gf9AogalgklAj0/E1KhlEb73BycuhAZd+4aVQS/8LM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LtTPvZb5LrYzAssllzS3Ch2E/QhQz420yqJQQM0/Ig1AgLUFSa3chI23kZX56qAAP
	 xPEwiLeQ2QE83C5dCJoX8QPI2ey/Rzh4F/kqhqcNkrX7LIC6vRaCcThX3Z87/I/uRE
	 gP5cm1giv6cHCGVKKou/Q8zp5D8TzUTceyQQW3zoEf8/R/UZzRV4tRv3iAW2wm3lZ0
	 tqfDiuipkbfdetdfs74lNUhUWuWglgoeIBihKuC3zNdxe5p1kcvUL4bWlQFmwPJz48
	 kwEYTmNsg1yHg5HM6mo4yHdv05LEDQWG+lXMcfLNcFTN4tE9grLuqNH2DHuec8sVpm
	 fE6gPDkAPcsMw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2004CCA465;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 16 Oct 2026 02:16:01 +0800
Subject: [PATCH v4 12/17] mm/huge_memory: mark folio as accessed more
 accurately on split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mglru-fg-v4-12-2106750c0bfa@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792088152; l=1882;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=8/kB3jYF2xvs54AjVF+kE6j3TkOpVQe7AYkhnz+HMSw=;
 b=tTKBt4tbGQ0fIDmdylFSAA5Og3kRUgAZK47NTX2iPzoR13ZjAG9OT3t0oZSGVCwoL/JJCEZn8
 zftXgBIT5FsAod03/bFjXDDElj8FzkBq+ectBNqBwZPDK7UQEawF90Y
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: rw8a1ojbtc1we4u9ppnwgt7u5qxwwm7x
X-Rspamd-Queue-Id: 136D540008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792088160-501386
X-HE-Meta: U2FsdGVkX1+EITtbVuJzN0o3gnGRkhYCuQwf1n1/pPM7IqLTyme8ANXv4He2xOttzcp+dnzhFClpATHaSmqrcZ/k59leWD6nemTxOlO9QrB0BGnhP6p04EOFINiGu6v3ZwG+QLPXaNhkWyP9duqGG3Sb8AVplyVOWe/AxW1/sB8wz3u/wQ92x8HeGfXBwodwRpQOJdWJZk6/hf2Yjo5fovOHqUTQae46xrfBkab3QmZpEAIJhW14d46L2F4kPY2NFbw8Kw8U0yzIB2IJ7fsc4BuYxl1EdLMhqHEWuGOysgF6lfOgvZMzU4jl444bIrUR1+3XKVQclG13aJpqAs6fp1jjl7hwBAIme8bPktvtQA6vJQU5/97o7GX8y2BBAJcNGLuAkGA8QH2nfaTkBOtQlqM3Js6BBJ36G+rTapGbcm2HPU6+mSa6uoqDLG2+lFSxjARUEv80791KvOFv0GWubileqTBe+ZK373ysosZumuesW5MQGN3VJZynMmvPruwaE71zY7tLmPDed/4y36h+i6jmdox7sQ9yTlU9VKaR7NzWbZ7krcfMdYN4Y7k5JvLfaVlIHYeu7D23OpM2N9RWp1QcStk9DgoPrrxvRBlzMFn3H8B/Dz0ZKJZiPAiuAICQalb12RBmIxuKt47rsqgfB7uL3+/JtxRvAq+wCiQ3mQFpsx9AM3ga4pnTPDsT3Xpgj99Cda7BkA8kl/qUtBuAdj5ec+/JAug3e+o/v50cCfDWo7SyIP+H3XzyqRFHcKpaYrsOUwrs+bfP/ZRxSStRveuBrGQ3PQb9GlSQgAfG70IkW4FRw1g/UaiIr7b5C9+WYJt4g82utl3SOlyVQLb+uBW2eFsJV7sD/ERidrcxjipho7XNQ4+TOPPBfxBv7WowTdiFFu2g7pXZxnIhp0n8dv22VsVYCl+nEWLzOzeVmBpgP8D37qj2PjeWuwIUNSoiZf42P7+C9B7CqtAhWc1
 Ajq49OJO
 fjbmAekuXdA+609XwHXpzLgfN9xTk5sskgZDuakJcxq5fX6ycENV8CHogcCe7h/u/Glb/vcj0Jo45aUBpP61o8CvlO0GSZfS4oYUzTB5sMzEsm7SXATrIe5T4LQwHKK33ZD5dL+SOR+9DNLTg9fU9x5HTxxvEo4LpmamBAvjjbRAxHQQrkIFCGsw1Nk2U/A73NfEXh/9OCoE5eTVe02z+f/i5cGDclWlcQQdotf0Ue6YZq/CqVTtINa2TaOb13LNT+6zQznd4KFhGN3qyJpg6pX5FlvTGd1ZbtZI1jyJKbPGORj6Y8nBeartUCszdDwCge4jMuxz+4MsKdUnO/6u6cspc3itk+jlpkP6NxuR3BLt6sgfEZ/YYJmS7ddYAc93Ha7CnZAhJ70p3x0DcgZQIGtfgMUSbPBy8KcOJyaB8djxakqYKXlrizTa5fHh+IqpvCB0WElEv94yefOrGkWuLijHdtmG4Is/P2vuaudaJGzlOn68pz9YIxFXcCIqLmsBLxw/ssPl9HfOMQVsmyx3T1PUm51M2S26tnVFZJfcxhaPNyJE=
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

Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bd44d58e8684..1e2b6448c010 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3093,8 +3093,8 @@ static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
 
 	if (!folio_test_dirty(folio) && pud_dirty(old_pud))
 		folio_mark_dirty(folio);
-	if (!folio_test_referenced(folio) && pud_young(old_pud))
-		folio_set_referenced(folio);
+	if (pud_young(old_pud) && vma_has_recency(vma))
+		folio_mark_accessed(folio);
 	folio_remove_rmap_pud(folio, page, vma);
 	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
 		-HPAGE_PUD_NR);
@@ -3216,8 +3216,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
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
2.56.0



