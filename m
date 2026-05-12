Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0221ECD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 15:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 019126B00B7; Tue, 12 May 2026 11:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F33286B00B8; Tue, 12 May 2026 11:15:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E70656B00B9; Tue, 12 May 2026 11:15:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D8BD56B00B7
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:15:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27B67A054A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:15:36 +0000 (UTC)
X-FDA: 84759117072.15.EA2FBEC
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5539610000C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:15:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=WpousURH;
	spf=pass (imf05.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778598934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=U2xsWflxLokFAJktyTCaR8iB2eeILFp1cGamAg2ZdJo=;
	b=ZP1UoDB2687hafFBUacKbkHl1c2k1aA9PisUfG8K/ptwL+5TpG5BdNUiuBbXCJ8/hl9KJx
	fAGwllDkrvMjN5x839n27Qw3uuaZYLdvuKcHUFnWPeezz0G7S5gLemIl3Uba9nEH552sUm
	DXQ55QnbhXIAy+NejJiJnrMKJn4eWqA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=WpousURH;
	spf=pass (imf05.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778598934; a=rsa-sha256;
	cv=none;
	b=WrJY0yBABeuZrYWq04AvmBSa1P+6Bag2lLsEDiV3tmwVYlEBdnnDQeLh7DTp0LxITw9Qeu
	SlvO31HvcQtBVJI0WBK30rXLxOpiE+mn/jYeTyCZ+eePLYv49mSITZ/P+0mtzQbnHvwOHO
	4bfWBCxMPGEWNPY1lw/5druiow8Rleo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=U2xsWflxLokFAJktyTCaR8iB2eeILFp1cGamAg2ZdJo=;
	b=WpousURHqs5YNQK6mXUiWj2yIRrturD8aV/Cm3BphM6a/Mem+OaPGe8ZsgPlDf3tYFz5/6FLc
	4WQxlIk7b3fm2Ucn+JySn+SgwW9oRlCr/Pe85z7nuCtaNWdjoI7xgoB/VZwyiHXqMjW9yh9N/S9
	61pOJ2C1o6xNQD8lsdt30r4=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gFKjH2Y4xz12LFQ;
	Tue, 12 May 2026 23:08:19 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 06F08201E9;
	Tue, 12 May 2026 23:15:25 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 12 May 2026 23:15:24 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: <damon@lists.linux.dev>, <linux-mm@kvack.org>, <sunnanyong@huawei.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v2] mm/damon/vaddr: attempt per-vma lock during page table walk
Date: Tue, 12 May 2026 23:15:23 +0800
Message-ID: <20260512151523.2092638-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5539610000C
X-Stat-Signature: ymhkb9h8d9br5knskd668oi3iou8j14z
X-HE-Tag: 1778598931-158671
X-HE-Meta: U2FsdGVkX1/v9HIWSBAqnjHcnBbHlvc19QwnwgPlPt8oyJjkc1/lxaJ8cWy4tg8D0nD9l+5Jk8n36i6n+LlUhUiu69TNQGzTcriUSFVccG0oPZL7aui4rod6P3UHzRABfba9dBrcMzS0vIc8ztu9oWFqSjw3KP129ThQIEV5mVvaLQYTSebJXX+r6cAkj2HRrkOQG/Sm0HTqctpCaKaCF+oSW7NAASZsR1LLIbQk5RilzGV41GIdSsw+vsDc+rwN7ZrScDmC+oBziL7qOI5udcLREwlqC/FSAwwwy+GeCh5X2BPF3BtcKv99qwmu84KuXliLW2hwp75FI2mYpvGONRwdlY5u0r4B5JpF88MjTEiHl2VeqYSpDhxiIBu8KR8TW7SJszRRmdqWhVel/GCzGcfV/5O591fP1TlSeerBTr3+w/bQbtmlI7Ritb6Fr+viWYWsEpz3MdjoEQvNDAJPOwqOJjkhuizTz/yWYBnm5gK7vUQ/t1lBjcLStP0Dy/3j0odWPFxlm69bOvXKAPCRx/t38TI+RawECiLgIL5B9452hjWRywGrvQOMEbXXE6IxUQyWYBN1LmLJyib/p2KAK8n4prdUDyEHTerZo7oZoTpCXuDvE4mqK+cNLNmgMXq4AGAk1qePzC7tzwg9Q9mrvw0lQRRJq2+QULWueMpTgxo0ZOQgeSFTj5dnNIVpDFqig4C0ZvdQ5jda/C2lfS2UVGP+P/k29KWTugpkPVC1blWabn9bfTFC+3nhyDV7/vKvUN6rdIT8RK5UiWR0+CnV99m99wXoPXC3XWKr/mqHKSVnihtx88prIq38Gw04xYu2DP93lzug9R7VGWrVlytZoKIQB3xMCsswEjckFzOz8gWa+Nf8GwktcVLw9Jmh+4zo8T3Nll66RlmtzsfD3wjogzdQMaa0Va5V0Z2YvOBe8bdskmc79xN5V/oiuXR/EBRltFobIY+b3kl5NvG9AHv
 MwOj2tPR
 OuQxAxhTB7fnFfCEv5Mw5OrVLieBj/B0YlkiHih6Wu6i1l2+RAYiUF0sKmiwyPGo1K2t5jYLutzJ0UkezoKcVCg9cjblT5h3USZHjpiZGPtkQzAfIl3QhW5dF73riNJAg2NGwKLY/JcyoQgdYV8ev6Ranug8Y3pOIW1/xuX0wlyPB0iwYiL9e4/PwBk00tx/puiZ21Z5Grre3qpqEXIHi+RUnF0Nm4DGtyRKY00ndB6o6vQJ3cIKEmDp/bLJ7MLHtpx63r4he5dqhZGF/QZBateYev2KW8O8k/MDcunMc30DKyx0W+Rn8/XAcFeBXUqiyIoXt4ONpBIPSTYpGouhlKyBgBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, DAMON virtual address operations use mmap_read_lock
during page table walks, which can cause unnecessary contention
under high concurrency.

Introduce damon_va_walk_page_range() to first attempt acquiring a
per-vma lock. If the VMA is found and the range is fully contained
within it, the page table walk proceeds with the per-vma lock
instead of mmap_read_lock.

This optimization is particularly effective for damon_va_young()
and damon_va_mkold(), which are frequently called and typically
operate within a single VMA.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
v2: avoid handling VMAs with the VM_PFNMAP for per-vma path, found by
    Sashiko review.
v1: https://lore.kernel.org/linux-mm/20260511132546.1973270-1-wangkefeng.wang@huawei.com/

 mm/damon/vaddr.c | 69 ++++++++++++++++++++++++++++++------------------
 1 file changed, 43 insertions(+), 26 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 1b0ebe3b6951..d27147603564 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -237,6 +237,35 @@ static void damon_va_update(struct damon_ctx *ctx)
 	}
 }
 
+static void damon_va_walk_page_range(struct mm_struct *mm, unsigned long start,
+		unsigned long end, struct mm_walk_ops *ops, void *private)
+{
+	struct vm_area_struct *vma;
+
+	vma = lock_vma_under_rcu(mm, start);
+	if (!vma)
+		goto lock_mmap;
+
+	if (end > vma->vm_end) {
+		vma_end_read(vma);
+		goto lock_mmap;
+	}
+
+	if (!(vma->vm_flags & VM_PFNMAP)) {
+		ops->walk_lock = PGWALK_VMA_RDLOCK_VERIFY;
+		walk_page_range_vma(vma, start, end, ops, private);
+	}
+
+	vma_end_read(vma);
+	return;
+
+lock_mmap:
+	mmap_read_lock(mm);
+	ops->walk_lock = PGWALK_RDLOCK;
+	walk_page_range(mm, start, end, ops, private);
+	mmap_read_unlock(mm);
+}
+
 static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long next, struct mm_walk *walk)
 {
@@ -315,17 +344,14 @@ static int damon_mkold_hugetlb_entry(pte_t *pte, unsigned long hmask,
 #define damon_mkold_hugetlb_entry NULL
 #endif /* CONFIG_HUGETLB_PAGE */
 
-static const struct mm_walk_ops damon_mkold_ops = {
-	.pmd_entry = damon_mkold_pmd_entry,
-	.hugetlb_entry = damon_mkold_hugetlb_entry,
-	.walk_lock = PGWALK_RDLOCK,
-};
-
 static void damon_va_mkold(struct mm_struct *mm, unsigned long addr)
 {
-	mmap_read_lock(mm);
-	walk_page_range(mm, addr, addr + 1, &damon_mkold_ops, NULL);
-	mmap_read_unlock(mm);
+	struct mm_walk_ops damon_mkold_ops = {
+		.pmd_entry = damon_mkold_pmd_entry,
+		.hugetlb_entry = damon_mkold_hugetlb_entry,
+	};
+
+	damon_va_walk_page_range(mm, addr, addr + 1, &damon_mkold_ops, NULL);
 }
 
 /*
@@ -445,12 +471,6 @@ static int damon_young_hugetlb_entry(pte_t *pte, unsigned long hmask,
 #define damon_young_hugetlb_entry NULL
 #endif /* CONFIG_HUGETLB_PAGE */
 
-static const struct mm_walk_ops damon_young_ops = {
-	.pmd_entry = damon_young_pmd_entry,
-	.hugetlb_entry = damon_young_hugetlb_entry,
-	.walk_lock = PGWALK_RDLOCK,
-};
-
 static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
 		unsigned long *folio_sz)
 {
@@ -459,9 +479,12 @@ static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
 		.young = false,
 	};
 
-	mmap_read_lock(mm);
-	walk_page_range(mm, addr, addr + 1, &damon_young_ops, &arg);
-	mmap_read_unlock(mm);
+	struct mm_walk_ops damon_young_ops = {
+		.pmd_entry = damon_young_pmd_entry,
+		.hugetlb_entry = damon_young_hugetlb_entry,
+	};
+
+	damon_va_walk_page_range(mm, addr, addr + 1, &damon_young_ops, &arg);
 	return arg.young;
 }
 
@@ -750,7 +773,6 @@ static unsigned long damos_va_migrate(struct damon_target *target,
 	struct mm_walk_ops walk_ops = {
 		.pmd_entry = damos_va_migrate_pmd_entry,
 		.pte_entry = NULL,
-		.walk_lock = PGWALK_RDLOCK,
 	};
 
 	use_target_nid = dests->nr_dests == 0;
@@ -768,9 +790,7 @@ static unsigned long damos_va_migrate(struct damon_target *target,
 	if (!mm)
 		goto free_lists;
 
-	mmap_read_lock(mm);
-	walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
-	mmap_read_unlock(mm);
+	damon_va_walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
 	mmput(mm);
 
 	for (int i = 0; i < nr_dests; i++) {
@@ -862,7 +882,6 @@ static unsigned long damos_va_stat(struct damon_target *target,
 	struct mm_struct *mm;
 	struct mm_walk_ops walk_ops = {
 		.pmd_entry = damos_va_stat_pmd_entry,
-		.walk_lock = PGWALK_RDLOCK,
 	};
 
 	priv.scheme = s;
@@ -875,9 +894,7 @@ static unsigned long damos_va_stat(struct damon_target *target,
 	if (!mm)
 		return 0;
 
-	mmap_read_lock(mm);
-	walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
-	mmap_read_unlock(mm);
+	damon_va_walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
 	mmput(mm);
 	return 0;
 }
-- 
2.27.0


