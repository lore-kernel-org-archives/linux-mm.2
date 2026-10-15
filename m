Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA757CCA464
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0904E6B00A9; Thu, 15 Oct 2026 14:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE1F46B00B0; Thu, 15 Oct 2026 14:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAE886B00A9; Thu, 15 Oct 2026 14:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DFF16B00AD
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:16:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC04D14010A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:01 +0000 (UTC)
X-FDA: 85325664522.24.DA63EAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id BA60420008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:15:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YT7UwdZ2;
	spf=pass (imf31.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088159;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iRR+Lm8FpkpiLoXZd7EqmnIeWeCtQwxmVkRJiGF0W6U=;
	b=U77qSHA5Xwa9on2mXa8ov+3bZoGvUq9gPF127acfKFsdTUuH1d1b0zk2Vpy02HjVs/bJBC
	71wz+BuviKgKU8ah4c9DiX5hT7ldTEp4L090XdfGqmApYQKkgerJuLGlS8HMR+y918Deja
	DkEbJ0RsBdPVTGW8bcTNc+rQvAw2+7M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792088159;
	b=7uJUuORBXjJkhuvSLH/me19TsUYochN7ZSfAthtZXvSXQSjUIZmveea6YQ1hou+iT+uBg/
	493h40RODLzx8YD1z87rPzeU6wqb6SKPHkBJXVR578znAU5rzyKWHRqToNXHhISQz08Dv2
	rKI2VH0yTG40o2Zb8RCmOGiY8IvfMa0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YT7UwdZ2;
	spf=pass (imf31.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E7967447E2;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B833BC4AF0B;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792088155;
	bh=ZzlqwZdbbSmlpiAV59dl01bIvah2RXTPlK1Ztf6kC9w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=YT7UwdZ25W42wsgsFlkTJmaSSoOhzC8oGgl5P7Ac+jDupj+GoMJ5fceCdxdQNxoSc
	 ncNxxDyyeFbyQTTi6+zi4OHQodqhysvHGFWtMpPqzGE+LQMOdCWHvuSZlxbNR9oW5A
	 5zY6gy7ue6W1e78Cod15DMMDqm43a8GRyX4Zv9H5ZRM2G4JwwAVyzCsymXiuTaMkl2
	 99tV0PL+0Wg6cG1w4SfqBZnW1L0t0aoOyJ64rIyRsthrF99oozVBpbK/DiJmTvpnbq
	 gXaG2hLBTKcf6Y1iUBcRwshERDuNnnrODTI85xGwMSGxlgu3FHDLZ3YYt/Zu/oOV2S
	 itPNzqwJ1pxRw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4049CCA466;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 16 Oct 2026 02:15:57 +0800
Subject: [PATCH v4 08/17] mm/mglru, smaps: convert to LRU refs based
 operations for MGLRU
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mglru-fg-v4-8-2106750c0bfa@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792088152; l=3775;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=1v4LOI4JHk+vBXr1A8j77mCVzkc1JT179HQJTN1nz/8=;
 b=nJf/e5uxq7wxKBLvgMhdEEpMSQy5vLPa9CaLfszqpF4Jni0dW53W0S1f38toJQy1B0iMhmzeH
 mMSVOTnvvWeAA1/1zaUtw/+ofRhQp3FH37zeT/yem6PsGVi/QPFzahQ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: BA60420008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: r8b1qdestnk1fqcs65rkd4j7rbqdt9b6
X-HE-Tag: 1792088159-725668
X-HE-Meta: U2FsdGVkX1/ov+OljwXahBa/YQ358jfQg2QQZqQzFrQ0B5aWe44SNPKBxQNNyVzhMMtInsSUJDI8EvuiwPNihuJDXsdPOy+9xJwNZSiLefKzsbSNRExh5dFm94rPcWa7ITk9dZCSUOpubcFs1PgpYAhoWoG9EGZdTRtRg5LwxZKq/OKJcpn/FYf8PHvwyI6ukGo/4wxShxwYME0B0KuSvBme9xCyKWYnVHK1hhSYYkRTjTAhFIKhj5v31PpVuExh24zjUCpJhCO9KJmxgosUFOluCrWbCnZJ2mE8wFIjhp/65tw5OCEwv6U051K8KbVcJjqEawPwpm36T4bFIeHeunfEePBU5Xcwv29DbWNTCmcGtIgRruewMrkjx2JTUUMcNNko1qmzoMp1WOe0mVHe4pHQtiNx8PeNqLdTTix3ch9i2hq7IuyJ5N6/L9mjJ+XNPoVKeOvcxP6dLoEmWZnLxCf3iMvjfB0td2IYnCFiDDS5YRBCwaTy81rm+tmk0nBye7t2SOV0kEp9t0jJwQ+/aS1lxqmTjM1dkKkFH2c2o64Wf4H1ZdfxSruL666jo3fiy9h67x0RkIXsV4axg3GaeKvLxyhCnt3SAgrg1IvxK5TBq0Qgve2J4ZDF0Bt/R/nzI0rtn2RhXKTocdh/jRFEq+F9OxuRQ8isHwQXpMpG0ANvtgA6jNKEUvbdxKI9f/BI5XyS//p5GRpsGshm2dlX0VkllKC1IWSSwxL6Ikf5w2VeQdWeJpTQmgPKtdUxXtxRn6rzBdGDRP+T029/+AELKiOXsWqv1nF+Hzzzm4EMJkW+BM/zBF4pkuLEd43EZddS/AmAb91fJx4YPcee982owDj8LVaXgU55AcwQ2kKkp+/Y0Egfzgj5YnlzXajPzjRlBJH246/OU4tl2W40OuhCpQ0Z/E0GzVZZevQS78U0V9dXRgn54a/APpJ/v+/j9AwWcWkEzsEptQxBwxoUXLd
 1XFbVHJm
 W0XwRDlJgjQcMkDKQjX5Xw7voEtPBMkVns9kDQLlKxu/6JLAJsTQBWU/l3jKPiUfR8+a4NEhKL8Y+cwiogNXqVKjNLaQIPbaB59GhIEsV/xUTO30Ik915QHyxCTF6coZdoGYhi1Pd8GxlZCNTfm8L0q0gsfDc2WVBxDJaO/TMt9eH0baBQXf/yu5lyFeUt00vsl6JC7AfdBN9Xv7jOnPRkbdm+Bkbe+7SKHHDC7dpR9tO3niNAmeOpqgGhNAaT94ecak8nBhbOlBeczzmoecwm1umsRjQvP6TvLOgAe/Fk9MKboc+88SH4GXZnMPQGBDPV76JNJjfslOuaftV55LH4n60CUKdaR0O75/ZvGDdZ9AP8bh9oF02TJFa6npAy2PpFHVIfnK6e2MZlQ7aX/LkL211rnMRYujMBzVTvDWrpdCP3n72+Vt3I2u8vcM4u0vQuBMN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 fs/proc/task_mmu.c        |  6 +++---
 include/linux/mm_inline.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 81c464139f8f..55f3a35fd3af 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -888,7 +888,7 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
-	if (young || folio_test_young(folio) || folio_test_referenced(folio))
+	if (young || folio_test_young(folio) || folio_check_lru_refs(folio))
 		mss->referenced += size;
 
 	/*
@@ -1685,7 +1685,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		/* Clear accessed and referenced bits. */
 		pmdp_test_and_clear_young(vma, addr, pmd);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		folio_clear_lru_refs(folio);
 out:
 		spin_unlock(ptl);
 		return 0;
@@ -1714,7 +1714,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		/* Clear accessed and referenced bits. */
 		ptep_test_and_clear_young(vma, addr, pte);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		folio_clear_lru_refs(folio);
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index effa13c63632..6c9510002754 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -479,6 +479,37 @@ static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
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
2.56.0



