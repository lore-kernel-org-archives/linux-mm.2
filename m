Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB64ECD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11AB26B00A4; Fri, 15 May 2026 05:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 006CD6B00A5; Fri, 15 May 2026 05:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62776B00A3; Fri, 15 May 2026 05:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A64266B00A2
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:54:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5EDD81A02DB
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:54:25 +0000 (UTC)
X-FDA: 84769194090.12.48B69BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2DD794000B
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:54:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rKOlMlnn;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778838863;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DizocAnPYSLVxWcNU7KP1hpaTp+dzyT2+Pf/yufTr+8=;
	b=HCozsRE1xhER21NOkAcsGjb5xOA0WbLy9jlP8U7Ml2CqfntCxj2AI+LVeQ1J1vLmJGBi0c
	DHgU+Ql37edUCKcM7PCjDQC0J0eBTkekxOgAvx4ugKiHTR1MRgPsOt9NAKxU6Lq+xyhDU4
	YE/eFqyTfvyCUFAexHJWpzXGC+PH3q4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rKOlMlnn;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778838863; a=rsa-sha256;
	cv=none;
	b=HQOS65M8RRyrmMvIqYEEKXRz3jVdcVHtPVzfq7csRqgCeFXMoVZEdJJgZpVfSzXlckUmxp
	SFi/jwiVUzzfC6xcqpOrQek9kPtfMe/jtfu9OE8dV0/HsCUsRUeG+79Cjnt5h1f6zE7Y+x
	UEjovx38jaChUFiCCB0A5NE8KuQOHNk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 62E054447A;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02F2DC2BCF7;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778838862;
	bh=fxPLjjzwJE4NXFx7tLD197c2NXECqvzlGTxAHCYE6GU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rKOlMlnnqZQRkYZPUVV79tE9UUBH1rbSpN0Pa1Jz6I83qVoszSS5qfdft4f6La68K
	 T9YVoXUHHjXackpssURFQT3s5BNn+rm1Hs+ssClsYWFt38SfGxhKZSl+Lp7NFkn9V3
	 YgBAqifHin4yhskl6ibnjX6sa/IXZMu527c9raKZc2tyt1hwuKZHzDJqkegzggng3H
	 GNMj1wr0aL32cdG+ms2IzIql3dnQ0DG5yu9Ks4seyKqe2nkfjs2vwPdrL9vfx8MR8U
	 6KWjc5qdpHg/S2LW4nXbEvGPu0CpHyzKzDJip+kYCBZEp/iNY6FxxuyxnivYCith2N
	 nApr2nwyz+YPQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED7F0CD4F41;
	Fri, 15 May 2026 09:54:21 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 15 May 2026 17:54:16 +0800
Subject: [PATCH v4 03/12] mm/huge_memory: move THP gfp limit helper into
 header
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260515-swap-table-p4-v4-3-f1b49e845a8d@tencent.com>
References: <20260515-swap-table-p4-v4-0-f1b49e845a8d@tencent.com>
In-Reply-To: <20260515-swap-table-p4-v4-0-f1b49e845a8d@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 Yosry Ahmed <yosry@kernel.org>, Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778838859; l=4383;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=MR1heGhcrCQDpIR+H9UupQ+NXKwJ5c9dggOiT/gkYv0=;
 b=cWFw412xS3sDKJ+PhtpWUSwVeblVGe3BtMC6dcax400yqikBppSYNd7HgsJEP85P2pCiCyzal
 x3cvSLOlQ2lB7lPnwNlQJ7Xmy5DItUdBfaUY2c4wzNeuKzBMtuC9EKw
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DD794000B
X-Rspamd-Server: rspam06
X-Stat-Signature: 3sq474zhfdatac5zwf4nyc3m618onhee
X-HE-Tag: 1778838862-379149
X-HE-Meta: U2FsdGVkX18MG195X25dP4rB0liGy7lThBoLXmjfz/9arc1EYA0+ASMkUSe0BQNF9T1WNrberdRj91eE8NcJ8RkEs3N9JACiLtQtqukFzKUDaF+18gqpesvMlektMf4P9CZ7uuVCyIgnrHyTrvsa1mkxAR3cT0vOlFV//lECXYdUxItskr8EDe/zbQ2Zu7GDjFKujEqPsAZ0g3uU8+uDDgr7BqjkHfYPUHYWFpe0OZKEW7MBJtsnqjMXe8HTjbgQ59UPppOEqHnh21zSNX/Kdvnv5Dh0VWX0QsS6i6sbs9n+foSFJeH39Q+HLW8ezJ8cvAe2VaswdaLfbLe8y9IT6m/s32A1WYB59VELzm61fa32Xfbj2TmVeN1iMPrUAjEYHaUKVgR5ZP30Ey8sx5fWqbhQKF/tPw5IPU7B3hJAHhsUiIlBZ8N3Db1tpvTD057CSpD/H5aWT4fNCgLCV8tHfjhkJbALMrav6U5dX6/QHuty7Us8fG/V7PPFDVvYSjlr9UsIyyZTgJQHSB3XmmkqZnWYBvZGbO300LHg4sOp+4vUQbiNkZUXcLeZ/t794BSEUj2I+jUkY68liIVgipXVAxRWE9i7PER/ZimwV1V1QnoeyKByqFDmlFxZXZa+U7a2kdhSPpgSq9jwvoturYn2e6qFLZEKy1SKwFUQsavGUy8BqPISKlxpOiQTUj9gB/figQyCn0DeEsHLs8P2PX/xWSdEdctJjAA3DrZANPTQUXE1kZoTRpGmaX+kA2eC/uu0IrrwpynsH2hE8eYHLE2BHhgg8EuDS8M8c/Wf83iqjBVNUZNvYttwghE2U98oqTYLmeTCRvn13IUbWwQFFsDD0dd7tclBKvjH2w/UCLLxeEaEO4Yv2AEptXKJTFF/LO1hhbXWQ1cYUDXzTDrEEO7sX8Nj6U2U9i6vU677iLyBrBGuIdGr/dqpeh2z3mYL8nwJL/tY3686DmiY6+U9ilF
 JUwxFXtP
 WyY1At28qA0nCLAy+ksUijyDjNNK6OOvJ/Op95+CQf+KPeXhonH/UBuA/u2s/TE08mkCMMcbbUpn/GIOJaHT8gt3ahmoKurZENO7YnCLioMLi7tkht25vwgFLVaVZcWp7uyzBM8lNQ4khtV719e4m6psfY6gz2+eCfcgEbFIN42OIe8ZUUhibhQJeNQfw1bfQGynd2wjmH4Esi4PDn2UiRrWY9tU00z6u2fsSmDYm2K9EuEPMEXhZqe8dDv4Z8NgREXZE91fJ0PfIJbqbV9/pOL63WxDvsu9ruJdN/ZGiAXip8lWuni8dOiI5ifdvlQbQMwKN3ryRX6An353pGGx2VI7YZr7/ECad0q30liMVAUyvxI/FrEZpGqLvsjp62IUFbiqIWStVSVWr9sQOIsdE3xy+HOKRmHGO8b9gM5AnHt8GhhHwibFNzkdC44W0Opn8TAhdx6gBb9DhMGfYWRXMFP8cBX3KS2RQRsGNvuf8pNqXFZgyMrDurltWyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Shmem has some special requirements for THP GFP and has to limit it in
certain zones or provide a more lenient fallback.

We'll use this helper for generic swap THP allocation, which needs to
support shmem. For a typical GFP_HIGHUSER_MOVABLE swap-in, this helper
is basically a no-op. But it's necessary for certain shmem users, mostly
drivers.

No feature change.

Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/huge_mm.h | 30 ++++++++++++++++++++++++++++++
 mm/shmem.c              | 30 +++---------------------------
 2 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 127f9e1e7604..edece3e26985 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -242,6 +242,31 @@ static inline bool thp_vma_suitable_order(struct vm_area_struct *vma,
 	return true;
 }
 
+/*
+ * Make sure huge_gfp is always more limited than limit_gfp.
+ * Some shmem users want THP allocation to be done less aggressively
+ * and only in certain zone.
+ */
+static inline gfp_t thp_shmem_limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
+{
+	gfp_t allowflags = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
+	gfp_t denyflags = __GFP_NOWARN | __GFP_NORETRY;
+	gfp_t zoneflags = limit_gfp & GFP_ZONEMASK;
+	gfp_t result = huge_gfp & ~(allowflags | GFP_ZONEMASK);
+
+	/* Allow allocations only from the originally specified zones. */
+	result |= zoneflags;
+
+	/*
+	 * Minimize the result gfp by taking the union with the deny flags,
+	 * and the intersection of the allow flags.
+	 */
+	result |= (limit_gfp & denyflags);
+	result |= (huge_gfp & limit_gfp) & allowflags;
+
+	return result;
+}
+
 /*
  * Filter the bitfield of input orders to the ones suitable for use in the vma.
  * See thp_vma_suitable_order().
@@ -565,6 +590,11 @@ static inline bool thp_vma_suitable_order(struct vm_area_struct *vma,
 	return false;
 }
 
+static inline gfp_t thp_shmem_limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
+{
+	return huge_gfp;
+}
+
 static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long orders)
 {
diff --git a/mm/shmem.c b/mm/shmem.c
index bab3529af23c..6edb23b41bac 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1791,30 +1791,6 @@ static struct folio *shmem_swapin_cluster(swp_entry_t swap, gfp_t gfp,
 	return folio;
 }
 
-/*
- * Make sure huge_gfp is always more limited than limit_gfp.
- * Some of the flags set permissions, while others set limitations.
- */
-static gfp_t limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
-{
-	gfp_t allowflags = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
-	gfp_t denyflags = __GFP_NOWARN | __GFP_NORETRY;
-	gfp_t zoneflags = limit_gfp & GFP_ZONEMASK;
-	gfp_t result = huge_gfp & ~(allowflags | GFP_ZONEMASK);
-
-	/* Allow allocations only from the originally specified zones. */
-	result |= zoneflags;
-
-	/*
-	 * Minimize the result gfp by taking the union with the deny flags,
-	 * and the intersection of the allow flags.
-	 */
-	result |= (limit_gfp & denyflags);
-	result |= (huge_gfp & limit_gfp) & allowflags;
-
-	return result;
-}
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 bool shmem_hpage_pmd_enabled(void)
 {
@@ -2065,7 +2041,7 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 		     non_swapcache_batch(entry, nr_pages) != nr_pages)
 			goto fallback;
 
-		alloc_gfp = limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
+		alloc_gfp = thp_shmem_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
 	}
 retry:
 	new = shmem_alloc_folio(alloc_gfp, order, info, index);
@@ -2141,7 +2117,7 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 	if (nr_pages > 1) {
 		gfp_t huge_gfp = vma_thp_gfp_mask(vma);
 
-		gfp = limit_gfp_mask(huge_gfp, gfp);
+		gfp = thp_shmem_limit_gfp_mask(huge_gfp, gfp);
 	}
 #endif
 
@@ -2548,7 +2524,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 		gfp_t huge_gfp;
 
 		huge_gfp = vma_thp_gfp_mask(vma);
-		huge_gfp = limit_gfp_mask(huge_gfp, gfp);
+		huge_gfp = thp_shmem_limit_gfp_mask(huge_gfp, gfp);
 		folio = shmem_alloc_and_add_folio(vmf, huge_gfp,
 				inode, index, fault_mm, orders);
 		if (!IS_ERR(folio)) {

-- 
2.54.0



