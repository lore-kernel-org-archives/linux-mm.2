Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF7CDC624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 14:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B92506B008C; Sat,  5 Sep 2026 10:02:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6B026B0092; Sat,  5 Sep 2026 10:02:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A58B96B0095; Sat,  5 Sep 2026 10:02:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8493A6B008C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:02:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0665014034F
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:02:12 +0000 (UTC)
X-FDA: 85179872904.22.53E1C6A
Received: from mail-wm2-f8.google.com (mail-wm2-f8.google.com [74.125.225.136])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3FD3F1A000D
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:02:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q23VecM5;
	spf=pass (imf19.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 74.125.225.136 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788616930;
	b=N5v9SJcseaC4tj2PPQHqtIr6ZfioFh09KF/vfU65ECky8oJ73yCbTZQd1rnckKx8VUHLEH
	I4F4gDriwD0cgxYWsSwgtX2ob1EnKD489hZ1FBeBRfHK1QGfOdlfvyXwq7erVZD7sOqdpT
	1n/bnmbE5YdhhC5wjXAAPvGCRCkTX7E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q23VecM5;
	spf=pass (imf19.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 74.125.225.136 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788616930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=icDFr+1kJOyXzKJSmWL1jSVXiQ38MI3ua/+Z5tbVNKM=;
	b=G6qwifcL1cGyL65KFUc9WjevbqLrUSixXCgSa5QntCl4wO/ZUlf6ufVLfF8LBx7obgqPkJ
	zyTZqpha3rSlWCYpdxuGxt6LXa9e4Zj2tOG++upaL8QDABrH1W0EYrin7L2ivCjiWOMbQV
	zJtQdxERGfbRZN8aVMjhxw39hchtEko=
Received: by mail-wm2-f8.google.com with SMTP id 5b1f17b1804b1-4956bc73c0eso7428875e9.1
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 07:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788616929; x=1789221729; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=icDFr+1kJOyXzKJSmWL1jSVXiQ38MI3ua/+Z5tbVNKM=;
        b=q23VecM5UVF8w/zjGiW6TTQ2h8k4aWJRd8E0G2LQUzr1d10VR2KOiIl43AcotWUGfC
         utHb8EqwgdrW2Aok/0V3FYIiLhSzD2R/D0i4nZ4iT8baZ8wMMX4bExkCNuAfWqDmCzaK
         aYn9qcsy13qb8tKCVGAa9sU39GS/MPjVDvv/IGamBnMHsqGd59WldCFO6QIVLBtrSFk5
         mTDk7jPOu9GVQZjHQfW14DoYE6Tf/0nVCoHBasqKMrOY5cw8k0vLTL86sFfUzaszVbzd
         KzvTgMr4T5CDQexf2c0SBhhjo2iVWhIw0lL3/oAnACV9Hcaz5QoyWUif8YUDqqHiFze5
         kyMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788616929; x=1789221729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=icDFr+1kJOyXzKJSmWL1jSVXiQ38MI3ua/+Z5tbVNKM=;
        b=i2WSHgz/PG0rrt2BgH7EDjYUNJDS0aQpIpLzcyR60mSB53bq7Vu/6qIAH7KA4lgSCr
         7sYcRFO57p4C0LAeb9IaYR/mUJw3XL7yWdBkSWumYljFbzeh8amjMABwRiO6yVItowBQ
         YOJclQYE0jrmtLjXH3u9yglRvrFwlvyDMQPSDVwhRSZgOal9FVrOCNd5WQojaJKT0TAc
         aLk/CQG+KSdr586/xuXCrOkPhoYoxyWoJXDpD6tsKUc6Mdk15t1LwXedNCoWqnhzH2E8
         23EAkfXTicfEJEbwE3hG2D8Kac7o44+KH7g5bX2Vgkap1I8+39TaO8cDmC0UwpN32ph2
         q2rw==
X-Forwarded-Encrypted: i=1; AKwUvBxLqdl61wHLTB1k6xnmGc3PQnN+DYZuzV+QBfydp+r8r9qH5fNHK2XudEYT6Fo9UCLmH1lsU8Oz6A==@kvack.org
X-Gm-Message-State: AFuF++miHbv+aZjL2YMWoa8RQ2oMuStMcv2bok8OqZzZ6MatlsL3SI8V
	rj/9CWG4z5DJS8gP4dG8QZ/+sUCw4c2MwlpllHts9lOwIpKd7JOA6Zls
X-Gm-Gg: AYBFou2TXm3btVPqGqmk1+tEfvwAvloURsjxd0qITKF7oQhfOPnIBC2OR4zj4YCjIXO
	eTJSp7kfoGVzR8ciOSaxJT0ucDP90zPut+/t/34R7fPrav7+t9/qViG3aVK4Y56tlgivYWaI7AE
	69QxNlWLKCkdaVs5HMks3GFXP3jbeA7xoh7HlGBQ5Sl1d5op7u2x4YNKUf+nXn80C5vCTO8NSZd
	0pecxes4iZPvq+Vl/KbAOuiUipte2mdxRIOLnOP+RQnIZNIIUljx/q9JbY/wgfBsPs8nWwwRf73
	ocOobRIFzd4ALu4IXzMupDzKiy4rhqhBC98dATKu5bBmFyouTbdVMJGBcUdhVS4Hy0RlxYkqUct
	J68f03nlUPYV+33hlz6yt3VSpeM6+OpZJ7Qc1XXEetBSX/2Ijlflhf5c1UeztBzOQklT/InWxYB
	Z/F/CVg9CPXgYJznV2FVOosNIOfdJ8iiYyk8M9M/1uFujS/LhtGIGr0kmd2y6jTk8zrdNIJXQkM
	PLOUhmAwYamcwk=
X-Received: by 2002:a05:600c:1da8:b0:49c:cf18:494e with SMTP id 5b1f17b1804b1-49cf825a530mr148106805e9.12.1788616928651;
        Sat, 05 Sep 2026 07:02:08 -0700 (PDT)
Received: from outlook.com ([2a02:587:6022:4b00:84ac:4417:9f37:a496])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf755c22esm149866765e9.0.2026.09.05.07.02.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 05 Sep 2026 07:02:08 -0700 (PDT)
From: Christos Skarlos <christosskarlos.kernel@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	ljs@kernel.org,
	hannes@cmpxchg.org
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	mhocko@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Christos Skarlos <christosskarlos.kernel@gmail.com>
Subject: [PATCH 1/3] mm/mmap: fix various coding style warnings
Date: Sat,  5 Sep 2026 17:01:38 +0300
Message-ID: <20260905140140.60792-3-christosskarlos.kernel@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905140140.60792-1-christosskarlos.kernel@gmail.com>
References: <20260905140140.60792-1-christosskarlos.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3FD3F1A000D
X-Stat-Signature: 8chk9u4eehkkjseof17nxy8184n4hucj
X-HE-Tag: 1788616930-692571
X-HE-Meta: U2FsdGVkX19zYf6fSbEiP0q/RyyuPq5LGJgBIRegTvdEI7rTyDlxCUbPzQ65WMt97OXaIs3owGhfI5KtGm9R2RB8UEtj57pR+Mf3iYN7I9DDUHwUXbDtY4IAZkjcSL9ZkJfws2jkCNF05fqH2InSmPBW0EzMdqQEOe44k4P8dxBVcaz/gAwyKKvO575YDj+ibCu32jjb733CmheRdbKAF2pv8QCHChgVV15raSskLsVtgrK2weeKd0ioSHBChVJNp/PYsS8kAMNAgp8zLA6nCuevtAF+WCN2KH9LNAgeIV3HRF86hU2Td1aKeadVN/5mAGXZo66XfrCmfLwrcTlNk2EG0xarGtcsno/1QZyxDA/cdwv9YwDZoAoJ3EwehCEApW5Jl4z8vDPGhRbh4Gwb+f6aVPUxhBQuozcygmptN2v+A9M2tnxKYYsJjgb/xtvg4ivY+LQ+E2e2UrKXvhsDIDnuIAh+eqHjkAiEy3luyAJ++WJ36kt5bw+3cz5x8XE2YG2xQXUl81Hvajm7KLBB9ALBXJjE1IUwS/12YuM2mkUgh/KvzJOlRjhxhNuBcDT0LQsBvblsXTR11ZVlHtumbd2TefdN/0boVKOwI2RFiiY3QWCaXpLBypv5p6OED/Thz0IhsIJL4yg/C4lr2h1AIrRTXZK9szvLoMA18r214cH+d4R2z3JWpygHYCvZz6a3s3ev2RA8qva3jpDFd/cyj/sCJtDK4s4DQeI8+0Y7O9i9Ox0z5c6xZE7j6LV3NE7dvk8wIRAJup1V5Q5n6ro5jsDVXFRtMrP1N+JIxpQxcyQ6YRdWW6HLkzU5hRXyJ1YA4YcGIYutSMaAZexDUbapXiWT3lItltyDp8uMdSQ4DE2cKYGIO/zbNv/sU9uHf83PLPIvikQme2VZRzk3Ah8abqxCgFvy0GmYNqoXkxG/9ABNQwk9BFNrJZPpGzDcBNgabw8RWkJaJX6Zh+ndncs
 mMFszTkc
 MkY90UHgNxalbAy6fFfRByVsZqY4oY8pL+q9JleN6saRjgJmXBdKuDAsWd6hc2pGUzwxBHmz/ei0CqfzCd/H5TEK0UfyDbIpg2D3TPIX2fZHxUJSsNhTaPDtnn2YHv7ARRpCRHRz/Uwczkl2HiGecUWTe1pow74X0t34makUExC/SyTbKyOjs8uvyghI+mmDCznSi+hEt/Jx8sEOUK4qZqG8s2K1EBcRvCSnJiez5a8lByX1T79daLTgasJ1KzGVG1lxH1q2ym8iJ7yLq6QuPxeAa3onczlgx+B2DSQrTWfo9KoYRZGgiY155OprMdCdi4rOeatTg1hcEUYuRCzV1A/XOKqQwiJF5wI7OcTeKPXtDyTVU5YZlwce+QWAxxp0KPHEc4/ImaMFnfvL2V2+g/I1ZG0+zP6zd2rvOo9ydHOoil2oWjzbs4lMqe+QfUYyOt6dCnuCKyx3dact3s/4/EKllUupQDOdfF08Gf/5Ufo3eVugwo9jxrlSDHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Resolve coding style warnings and errors flagged by checkpatch.pl script. Specifically:
- Remove the obsolete filename reference in the top comment.
- Replace <asm/cacheflush.h> and <asm/mmu_context.h> with <linux/...>.
- Add missing blank lines after variable declarations and replace spaces with tabs where needed.

No functional changes are introduced.

Signed-off-by: Christos Skarlos <christosskarlos.kernel@gmail.com>
---
 mm/mmap.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 4bf26b0f1e6e..626d3d2493ae 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * mm/mmap.c
  *
  * Written by obz.
  *
@@ -50,9 +49,9 @@
 #include <linux/memfd.h>
 
 #include <linux/uaccess.h>
-#include <asm/cacheflush.h>
+#include <linux/cacheflush.h>
 #include <asm/tlb.h>
-#include <asm/mmu_context.h>
+#include <linux/mmu_context.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/mmap.h>
@@ -526,9 +525,9 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 			 * And don't attempt to combine with hugetlb for now.
 			 */
 			if (flags & (MAP_LOCKED | MAP_HUGETLB))
-			        return -EINVAL;
+				return -EINVAL;
 			if (vma_flags_can_grow(&vma_flags))
-			        return -EINVAL;
+				return -EINVAL;
 
 			/*
 			 * If the pages can be dropped, then it doesn't make
@@ -832,6 +831,7 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 				  = NULL;
 
 	unsigned long error = arch_mmap_check(addr, len, flags);
+
 	if (error)
 		return error;
 
@@ -942,6 +942,7 @@ find_vma_prev(struct mm_struct *mm, unsigned long addr,
 			struct vm_area_struct **pprev)
 {
 	struct vm_area_struct *vma;
+
 	VMA_ITERATOR(vmi, mm, addr);
 
 	vma = vma_iter_load(&vmi);
@@ -1017,12 +1018,12 @@ struct vm_area_struct *find_extend_vma_locked(struct mm_struct *mm, unsigned lon
 
 #if defined(CONFIG_STACK_GROWSUP)
 
-#define vma_expand_up(vma,addr) expand_upwards(vma, addr)
+#define vma_expand_up(vma, addr) expand_upwards(vma, addr)
 #define vma_expand_down(vma, addr) (-EFAULT)
 
 #else
 
-#define vma_expand_up(vma,addr) (-EFAULT)
+#define vma_expand_up(vma, addr) (-EFAULT)
 #define vma_expand_down(vma, addr) expand_downwards(vma, addr)
 
 #endif
@@ -1227,6 +1228,7 @@ int vm_brk_flags(unsigned long addr, unsigned long request, bool is_exec)
 	int ret;
 	bool populate;
 	LIST_HEAD(uf);
+
 	VMA_ITERATOR(vmi, mm, addr);
 
 	len = PAGE_ALIGN(request);
@@ -1290,6 +1292,7 @@ void exit_mmap(struct mm_struct *mm)
 	struct mmu_gather tlb;
 	struct vm_area_struct *vma;
 	unsigned long nr_accounted = 0;
+
 	VMA_ITERATOR(vmi, mm, 0);
 	struct unmap_desc unmap;
 
@@ -1454,6 +1457,7 @@ static vm_fault_t special_mapping_fault(struct vm_fault *vmf)
 
 	if (*pages) {
 		struct page *page = *pages;
+
 		get_page(page);
 		vmf->page = page;
 		return 0;
@@ -1711,6 +1715,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	int retval;
 	unsigned long charge = 0;
 	LIST_HEAD(uf);
+
 	VMA_ITERATOR(vmi, mm, 0);
 
 	if (mmap_write_lock_killable(oldmm))
-- 
2.55.0


