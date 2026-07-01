Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BBB5C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:41:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0CD46B00AB; Wed,  1 Jul 2026 10:41:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE4666B00AC; Wed,  1 Jul 2026 10:41:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20AE6B00AD; Wed,  1 Jul 2026 10:41:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B16BF6B00AC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:41:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 231B8140280
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:41:52 +0000 (UTC)
X-FDA: 84940472064.11.E970087
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5100620012
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:41:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xkmjwm3n;
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782916910;
	b=lX0jdvmXBU8IIPShE+11trp/ErQG7/sMAdBUDSjrbx0JZOpNFq2z0nSm8grppPMez00KdS
	hyVdTuku6PRP2WTh2huGQ12KO7ipHc/GRR5p95dXeOsq+QZE7cvbLTLljTB1ed7FkkWWk6
	b6NHFudH6gLjBYa16MjKa8Xj8akw09g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782916910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MlO5SJ/rY+wSzCCYx1m3Axw6WLAsRebKU9Ln/VKts/E=;
	b=sP4tsDMjzHoR3hTrJiXFzPXEypWrzfvWpqyhISPifZwGiiad9fVAzB+G3Qk0t4xwBpF/Qp
	WMPzBTyWl1wbDa+Cg1tJlaKkgepABNou1yLhOpg0gdxY42qwqfPAwZsOh/iuSQWwHu+AZE
	PxSTKCj7G+Cw9U+w50TiA3rQsk5FwQA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xkmjwm3n;
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=MlO5SJ/rY+wSzCCYx1m3Axw6WLAsRebKU9Ln/VKts/E=;
	b=xkmjwm3nZ9PCYQoP4NLEVEa52RIwj0pGGcOvXpA6OhBGku/Dkdckv1j9DfOJ5lFP1uJIDbiUc
	HhsH2MhjgPLc8dMq4cXBP4mWm01xhcy4CxwQ5RK+RrXUuBbhFLeocY8xJM87M/ZW8Z0PbGbSZTk
	FFndmB6+YeqRy964jzuuZfA=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gr2YG3KK5zcb05;
	Wed,  1 Jul 2026 22:32:50 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 41BAC40595;
	Wed,  1 Jul 2026 22:41:41 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 1 Jul 2026 22:41:40 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, Zi Yan
	<ziy@nvidia.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH mm-new 1/5] mm: mincore: attempt per-vma lock during page table walk
Date: Wed, 1 Jul 2026 22:40:43 +0800
Message-ID: <20260701144047.3786939-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260701144047.3786939-1-wangkefeng.wang@huawei.com>
References: <20260701144047.3786939-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5100620012
X-Stat-Signature: xsnk7164ytak8rkodck6s51uke39hkw1
X-HE-Tag: 1782916907-861585
X-HE-Meta: U2FsdGVkX1+mUmVWTBqGHggrGKxU2RdjVNbRUNO3ceBTmIryLSMmbVafUlUXRsd+k7tJTgRsxDigUDCoSO+S+vmZbgEzB57EAY8iXsTmtFRI98690WI8Y9C2r/o7mA3GOMk5amlfeclYqbhPb015Q/8OhyMpFJfr7JeZdPefEMlFoFQvnOcbiea3+u4nsSHh517dKYVa1UsPF0gXUCZizYUssCe0TAjw3qMht0W8/8Nz1GNzWUXrAS0wNN9FxrzkM0vHHR4t84BUE5IH+hCW8mnSSvINy/9Ppmlfu9FYtV/EQ0nuNFg1p4acDPLBIzVigXguDcfXZBw3y7WbwBmkZza0nmlSfb3VzJ//3RoYgQDX5P3k231bVo1T/Jmu3MWz5btyL6VpwsyHhed2uf3GLmtb3FqoBz73wcxBTPfTQkUsNpCtys5tZKTfBm1YzUesbj0+rGd5hSSfKQGedNeA+T9GhQGKgtg7kdJjvz7ClIxo+48foM/6hv54ZsrOiTmGsbrBV/DnQLxaYbRd+EUGfxUvKNwOBxS64Rll/t3aWXArilfrsKLAkw00f8cDyd8bw5NoU5+Ug4D9123vUqedbGFmKP1dnbg4JpKbeE16RKZlF1qIutOjoXySJeqrI7REpq7DbUkshbClIbIGwyy7832aS0atszl3wDmh06ewrzygKT05azH03sDK3n3rRa0boH9v/PBBZGyAmy7C5mWr8R+WbJTYJ5fJaszQc39wtFKrZiEQAW0QHTCYSvDElYPXZ+LSMpE/CVOevKAmGbZWLoyAdthSo8RJ7cf7HyhgoWnYfq0k0UZuIjNAJ+GZGg+YTyFfI4QXnlPNvPmNcC6YaRolsfMtDKR9QLZaYUV1XkH/wnFvgv9kPjkdh8/sFwGRsL1N1o+NXFLp3EwCPLGeQHoyZB5rX6jzVDFlZH/r2Z77BK1AljxzaxuE5LkUvC82YhS/t+rfFNehmOwt5b+
 8SAsee3W
 MJU8N0ffnf+kyh7k3G/QJmi6zPKAqKVi7HD8zSAkEPP+FER4tJTPikL3w1DXfHh51BqDA6m/lYevxMyWA0r6z0cRcvsp/H1uW6fmG1yQAkxepGF4blPfifbFUbEPxGXjMV1zRoop3Rsp9/BoqTOR4E9QG6gPj8U9UT89tD9aeXZQ2phosBb885YDBAEt5qcFSJsFdKCl3OjctGitRobnLu2mNWY6LqA3HKYlWsNBn54+wZ9NuAKH728KaLY5qp/ysTQZAzPdgNrjMDh6xm520DD1fNL4EvnLWbUZc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The do_mincore() is a read-only query of page residency from a single
VMA, making it an ideal candidate for per-vma locking. Try per-vma lock
first and fallback to mmap_lock, reducing global contention with page
faults and other mmap_lock holders in multi-threaded applications.                                        

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mincore.c | 53 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 17 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 866b26cec540..f561d6e01052 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -12,6 +12,7 @@
 #include <linux/gfp.h>
 #include <linux/pagewalk.h>
 #include <linux/mman.h>
+#include <linux/mmap_lock.h>
 #include <linux/syscalls.h>
 #include <linux/swap.h>
 #include <linux/leafops.h>
@@ -232,27 +233,24 @@ static inline bool can_do_mincore(struct vm_area_struct *vma)
 	       file_permission(vma->vm_file, MAY_WRITE) == 0;
 }
 
-static const struct mm_walk_ops mincore_walk_ops = {
-	.pmd_entry		= mincore_pte_range,
-	.pte_hole		= mincore_unmapped_range,
-	.hugetlb_entry		= mincore_hugetlb,
-	.walk_lock		= PGWALK_RDLOCK,
-};
-
 /*
  * Do a chunk of "sys_mincore()". We've already checked
- * all the arguments, we hold the mmap semaphore: we should
- * just return the amount of info we're asked for.
+ * all the arguments, we should just return the amount of
+ * info we're asked for.
  */
-static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *vec)
+static long do_mincore(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pages, unsigned char *vec,
+		enum page_walk_lock walk_lock)
 {
-	struct vm_area_struct *vma;
 	unsigned long end;
 	int err;
+	struct mm_walk_ops mincore_walk_ops = {
+		.pmd_entry		= mincore_pte_range,
+		.pte_hole		= mincore_unmapped_range,
+		.hugetlb_entry		= mincore_hugetlb,
+		.walk_lock		= walk_lock,
+	};
 
-	vma = vma_lookup(current->mm, addr);
-	if (!vma)
-		return -ENOMEM;
 	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
 	if (!can_do_mincore(vma)) {
 		unsigned long pages = DIV_ROUND_UP(end - addr, PAGE_SIZE);
@@ -328,13 +326,34 @@ SYSCALL_DEFINE3(mincore, unsigned long, start, size_t, len,
 
 	retval = 0;
 	while (pages) {
+		struct mm_struct *mm = current->mm;
+		enum page_walk_lock walk_lock;
+		struct vm_area_struct *vma;
+
+		vma = lock_vma_under_rcu(mm, start);
+		if (vma) {
+			walk_lock = PGWALK_VMA_RDLOCK_VERIFY;
+		} else {
+			mmap_read_lock(mm);
+			vma = vma_lookup(mm, start);
+			if (!vma) {
+				mmap_read_unlock(mm);
+				retval = -ENOMEM;
+				break;
+			}
+			walk_lock = PGWALK_RDLOCK;
+		}
+
 		/*
 		 * Do at most PAGE_SIZE entries per iteration, due to
 		 * the temporary buffer size.
 		 */
-		mmap_read_lock(current->mm);
-		retval = do_mincore(start, min(pages, PAGE_SIZE), tmp);
-		mmap_read_unlock(current->mm);
+		retval = do_mincore(vma, start, min(pages, PAGE_SIZE), tmp, walk_lock);
+
+		if (walk_lock == PGWALK_VMA_RDLOCK_VERIFY)
+			vma_end_read(vma);
+		else
+			mmap_read_unlock(mm);
 
 		if (retval <= 0)
 			break;
-- 
2.27.0


