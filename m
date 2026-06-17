Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B3C9CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 08:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1903B6B008C; Wed, 17 Jun 2026 04:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144966B0092; Wed, 17 Jun 2026 04:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0579D6B0096; Wed, 17 Jun 2026 04:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C7C576B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:27:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4BAAEC1BE5
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:27:47 +0000 (UTC)
X-FDA: 84888726174.24.8BD7481
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf01.hostedemail.com (Postfix) with ESMTP id ECC754000B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:27:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Eq8K15Cq;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781684865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HzTgHwspy8NA1KGgA/Dign8Nqb6I1MbOwWQ1HSr53EU=;
	b=FUKR36R2dIUQxnND3KIkShZKYcLVS1tMmyqFAgbr7byZ1KXXgYpqLQnnnS0z5z90y2nb8e
	i7SmmQdrBsWqh28HHrWKvI39idJhSBqngFiVht9iKIjQRw6+JqXnnFrKo0LJZb3x3Oy8U8
	Xnqnoi8dx+jReZLI6kQC5YCAfkgblIQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Eq8K15Cq;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781684865;
	b=Dz1hClEYaqSId1HQoH0O3p8jHc07EGORezG9Hu0kMafkFogwhJ3ZLi43w2CzQqoFWOuXWG
	nmGlab3hJu+mZYwPs/ui+XsT2zW+0DWisOWSVcoj0ekm+nBDPxfbef7bPj4oLy6oNQ6Jeb
	vTc5Gg6OQgZZr9eWgNiVZH03GmYiQpQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HzTgHwspy8NA1KGgA/Dign8Nqb6I1MbOwWQ1HSr53EU=;
	b=Eq8K15CqqZ3T+JfrGzTlQNL5SYKJChaGmxeMABBy9oOFzMR3YnEODho0G6K3Yoobj/Yz2N7WB
	tFBOwtt68v5MrAh8HYDZMPjTo5un5+30oogkMeMzoOdrBoGHoAETvFfgXGcYuwuwNKkl9ZW05Oh
	Lo7RhYVuJV+xGcwuPUNWMnI=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4ggGx96n32zLm38;
	Wed, 17 Jun 2026 16:19:41 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 19308405D1;
	Wed, 17 Jun 2026 16:27:40 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Jun 2026 16:27:39 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R.
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 1/4] mm: mincore: try per-VMA lock firstly and use walk_page_range_vma()
Date: Wed, 17 Jun 2026 16:26:19 +0800
Message-ID: <20260617082622.3397584-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ECC754000B
X-Stat-Signature: 3urg8r7fnpje7d16wbfwba7z3wni4d9k
X-HE-Tag: 1781684864-305219
X-HE-Meta: U2FsdGVkX1+yQDfdbl4XgBGI3b354zz6i8qLDPaiAMAEhAvF2vZyM2D6koG6MZmyI9iaLjprNivat2rJEq2DlINl8U8jxs9N9mtf1vklcUYMYdAmBD2hrTghtqkmyE5HQ3Gks35xyMgvCfpMqJEyBFMAe1DJD4BlvXU7J99IsiYzi8Az+6tw9B9RL60l2UhzhIozPPD1dwFc+sK6WJ6keANohye9453UNagm5bzFFkGyONOm1UaTS4kwrjtS37s2xvXxoIoNOcHuXoj7w44ouJwa8u1/pGr70j0NmQDsTdwgbvbak9UJD6DMZH1shK+jOuyofJGu95Fj8herp0SRmWVSQWFKNSu9+zmDrMMqpk6tRAUNCDG/UmPgDNOYQUTnrWOmdYSDhJQP0G6W+ljH5ahexADRus/4MaZQmLbH4zlT3ZqbPaXHmZp8rEWF+c6rkHg4bf/TBd85SeNCqlc2a9mq2OJVhq+AGHCycLvgAYraizvpY8YRMsylc0SMVrxKM6/1Cg9n3DtDeGHutO3+eXIDAsU2E6kN0Ri+w8TXyLajWyHns0W7cfhFmkI1IuomfF7zwbrbECQpd6YObms0k6CGguDjl4VTu8dnw9w+GW0xNiQlA2WZvWmzfAHuKLV/h6dTquzPec1CvbxbzfC7yJROPS/+QUc0wZvroDokUGqLdO+4nrtbq1iehzk6iHYgD/pDCZXpuhBsRoArn3kp3AHRf6K9SX3LALeAEyrVBlM8YioK7LXWaNU9WD33Yh3h+0L3ZGKrNeVZRx3Meyzg5deDgI715auYr8Vz4HqdbVHv+4Q0bpf4Lmx2uDOMREE6g1yJrUhw/RgsaVyyLnQOnnOds+taFz+7GhAr0xMKDw2wuRORKELVCO+/y1jIxcAk3m5J2nIT1Q6gxwhRnF01nPmMIF72nYdOeZFritpnfM6o+RaiYviXy6OLlVysUZDkMe0fsNlvfmcStsLJTfj
 +8lekxN1
 d44sQVnORtc81i+jmxGzyjXeN+PxRuslJc6/GWoZPRKJPiQl4Tj2wCt0GQefY14J3Cb/YIpcUicoGrzvbVihrqcSSQyX2HWWdZVx94J/QXbl+w8gGK9Im7s0VeS6t+pcdfa+gcko0Tx/nLJ6xVpjJr1ShypQVu4XzzccW5WErWGTDu4hD5qRzgYHl67Brqzp8Qb+KCfYd8+tCTaw7p3tahSNX04rRiOyd9FD+g50bkq4Eni3ApMju0D2yMD9QXcx00ov0grjMkyPUpU/MJ9vVTFMNe07bsw/mc3+P3XCFEUAdlrx05NzkSf4cfdaC6UwkbFDHdGML/8f5C+JWQHAsRMR0qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mincore syscall currently takes mmap lock for the entire
duration of the VMA lookup and page table walk. This creates
a global contention point with page faults and other mmap_lock
holders in multi-threaded applications.

The mincore is a read-only operation that only queries page
residency from a single VMA, making it an ideal candidate for
per-VMA locking, so try per-vma lock firstly and use the
walk_page_range_vma() in do_mincore() to eliminates an unnecessary
find_vma() lookup.

Unlike walk_page_range(), walk_page_range_vma() does not call
walk_page_test(), which handles VM_PFNMAP by invoking ->pte_hole()
to skip the page table walk. Without this check, PFNMAP PTEs
would be treated as present by mincore_pte_range(), changing
the returned residency status. Handle VM_PFNMAP explicitly in
do_mincore() to preserve the original behavior.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mincore.c | 71 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 18 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 296f2e3922b5..a786a073feab 100644
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
@@ -232,34 +233,47 @@ static inline bool can_do_mincore(struct vm_area_struct *vma)
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
+ * info we're asked for. The vma is already looked up and
+ * locked; vma_locked indicates whether the per-VMA lock
+ * or mmap_read_lock is held.
  */
-static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *vec)
+static long do_mincore(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pages, unsigned char *vec, bool vma_locked)
 {
-	struct vm_area_struct *vma;
 	unsigned long end;
 	int err;
+	struct mm_walk_ops mincore_walk_ops = {
+		.pmd_entry		= mincore_pte_range,
+		.pte_hole		= mincore_unmapped_range,
+		.hugetlb_entry		= mincore_hugetlb,
+		.walk_lock		= vma_locked ?
+				  PGWALK_VMA_RDLOCK_VERIFY : PGWALK_RDLOCK,
+	};
 
-	vma = vma_lookup(current->mm, addr);
-	if (!vma)
-		return -ENOMEM;
 	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
 	if (!can_do_mincore(vma)) {
 		unsigned long pages = DIV_ROUND_UP(end - addr, PAGE_SIZE);
 		memset(vec, 1, pages);
 		return pages;
 	}
-	err = walk_page_range(vma->vm_mm, addr, end, &mincore_walk_ops, vec);
+
+	/*
+	 * walk_page_range_vma() does not call walk_page_test(), which
+	 * handles VM_PFNMAP VMA by invoking ->pte_hole() to skip the
+	 * page table walk. Without this check, PFNMAP PTEs would be
+	 * treated as present by mincore_pte_range(), changing the returned
+	 * residency status from the historical "not resident" to "resident".
+	 * Handle VM_PFNMAP explicitly to preserve the original behavior.
+	 */
+	if (vma->vm_flags & VM_PFNMAP) {
+		__mincore_unmapped_range(addr, end, vma, vec);
+		return (end - addr) >> PAGE_SHIFT;
+	}
+
+	err = walk_page_range_vma(vma, addr, end, &mincore_walk_ops, vec);
 	if (err < 0)
 		return err;
 	return (end - addr) >> PAGE_SHIFT;
@@ -319,13 +333,34 @@ SYSCALL_DEFINE3(mincore, unsigned long, start, size_t, len,
 
 	retval = 0;
 	while (pages) {
+		struct mm_struct *mm = current->mm;
+		struct vm_area_struct *vma;
+		bool vma_locked = false;
+
 		/*
+		 * Try per-VMA lock first, fall back to mmap_read_lock.
 		 * Do at most PAGE_SIZE entries per iteration, due to
 		 * the temporary buffer size.
 		 */
-		mmap_read_lock(current->mm);
-		retval = do_mincore(start, min(pages, PAGE_SIZE), tmp);
-		mmap_read_unlock(current->mm);
+		vma = lock_vma_under_rcu(mm, start);
+		if (vma) {
+			vma_locked = true;
+		} else {
+			mmap_read_lock(mm);
+			vma = vma_lookup(mm, start);
+			if (!vma) {
+				mmap_read_unlock(mm);
+				retval = -ENOMEM;
+				break;
+			}
+		}
+
+		retval = do_mincore(vma, start, min(pages, PAGE_SIZE), tmp, vma_locked);
+
+		if (vma_locked)
+			vma_end_read(vma);
+		else
+			mmap_read_unlock(mm);
 
 		if (retval <= 0)
 			break;
-- 
2.27.0


