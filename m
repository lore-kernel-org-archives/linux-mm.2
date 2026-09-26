Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A73BC98332
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 18:39:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D9666B0098; Sat, 26 Sep 2026 14:39:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B1156B0099; Sat, 26 Sep 2026 14:39:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE21D6B009B; Sat, 26 Sep 2026 14:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C117B6B0098
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 14:39:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A937A4126
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 18:39:41 +0000 (UTC)
X-FDA: 85256776962.04.1A6237E
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5951320006
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 18:39:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VqnknOC4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790447979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l6Ei7iaMC8FezBDOc40UN+3dnzVcKepmpa+3tte5LhY=;
	b=pu9JiKU/svC0blcn9/PEWO5kXT8Yr004IqYgVn8DE8bOo+UNgauxVCJ199hOjIz2+vGfwh
	xV1i/byw9YFuGXamvd/IyXN8QXgpvFCFzpoVVqGDloRlJEh2PFtpcFIYdnBuDOYh/qy4yb
	mkEg1KQtTm3B51YkTXwdMxFpOZSakdc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VqnknOC4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790447979;
	b=wYi+3YjtZIOFZw3NH9wYrR+cx/ddfqph1NPN6RMO2IV1ndBQ8Yh9rqfAJlrGNBkZ0NDMCO
	LTJdBgPhvqZpiVJ2/P5ipgYqkLAc5+wYAGFhZXET2j/FVxh2Qi4FX4pSHifMTw7f46/ISv
	CbUEbUnucRbm2sh+6MF49NXruoM3DPk=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-486e1a044c5so1529036f8f.3
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 11:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790447978; x=1791052778; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l6Ei7iaMC8FezBDOc40UN+3dnzVcKepmpa+3tte5LhY=;
        b=VqnknOC4yWrlrFQotz6icfXRScjixeYrXTW0XdJVu+nNzpVbI101VYojFUGZz5phrh
         GMK1MrmN3i6XCiZuuRVv7l1ubKqLpPQ9ea9ah65RvmUPfP4P+D0u1pl5QX7yzZeBszbx
         zgq9ldITtcMggFdsPTxB6DtDijfNmu1LTtn7XZw0ph67dYE68739lwtabOj8ODYYe6oP
         tiqcCmxBW7qnMs+HobDh1X3wCdMe5+GgFqePI6lbQRXL30uGuzZazRsQIW3chVuoZ7Qa
         MEdTTP8Li+ENeB1zgOuTaoqIixJXs7crOnKMvhlxrDf/PvtOZcqOy0UO6lU5hzHalk6N
         tjeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790447978; x=1791052778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l6Ei7iaMC8FezBDOc40UN+3dnzVcKepmpa+3tte5LhY=;
        b=nsNKc5jUXZCRQDBqndm+Xtv3mijI/FNQBIq8n2ITydDiJSPe0hkWQFW/4rTkLk4YP1
         DRTgWNcWQ2hOxPNh4mVc3JRROMJASL5rexxnUgoUPKOFfLRxR45vckBK9FPTa1uCt6Kg
         pcG2kEYTlhCWBRp7Si610PQZ9YRwoSkBu4g+9F3rMaHEmcYpCDmzM/iq85JSNghKmIrT
         2LQgMTaYZo97Z/l9R4p73mh6GyHnbbJ0VURn73cu043EfAL5r5LzGPq7GexiqsBo5Eq+
         pfsWV9gXXCFA4tVHhTm8hkhUg+2x2OAwRVMsBFK7harjaoSoWuOZw1zMjleOtEZR1hnr
         kVTQ==
X-Forwarded-Encrypted: i=1; AKwUvBy585Qv8zoWHFVP83gnono0WE7RcdgC6NUgAv9H3a65GuSMeZOz+Eaqqq1Yk36IRBCLO62JXTJyog==@kvack.org
X-Gm-Message-State: AFq9FYKZ/MH2G5kNBXl6ZxWHFu9MnyqjTR5MtgOzbWkXxqJmwXd7Sml6
	KpUpOs2aFgbPHIdSKKb+yyupuVawpchifsBXozCl9qgK2vfdwN3Gp9qg
X-Gm-Gg: AYBFou19joLlh+qiULk+JG29wWpCAenyn4NJytKmRkG4mVeN9HlMi3nbmOwrtrx6F8v
	YkKBiLG22G9FRVEJXQ8ajWGqmVOBB3QzPkrTzPkv2lX8/zbz7b3nOmefEmdfZnnCrZ+qenRTe5K
	DKpV4HyeXCsQWM+Brky3DPfWMn86U4ThQPQl5767GAMM0oPgDHEa8okN6Ca6jc4UkLJsi/8uWt3
	b7etdbvPPB9G9aUSbmtO8wfDToTMF0RCY7h4u/9lLj/f9QuABxz31BfUYTzyiX812COrexQj0aq
	6+q4rURiXAaPAnAVqjC6Y+vbOh06E28lPzTEiM8VCFW9RKI34doR/RzMVMFn4cK2Xi/aZjh1L9u
	D7HGxDOPNJaIY2QoOcQwujDmd6Yc11oFolBQPya4/95b+DtTr6F0JfuKR+TACxSMA8nFyllmoNV
	HuS9vuo3aE/C5T2HkCrcz4ETUIVuh1DVdVXcv5pxzmCatq4i/53hRF4plocd12eppmdQidS++Ls
	kxNVGhxl+o9pq0dZGpRBIEWZwVU2HF02KMBNSaojE+VJVtLTYj41X4dyr5wCqqVRaRbeCUuD4Xg
	rbrFhVCPbdy+Vsm2sw3Dv23C1bcb5edo5avCrxHdJLeV26LsyR1aGZPaBbRq2ZiuQ/6TjiAHo7H
	+5+s=
X-Received: by 2002:a05:6000:420d:b0:487:14b6:b1be with SMTP id ffacd0b85a97d-4887172e3ffmr17724486f8f.25.1790447977972;
        Sat, 26 Sep 2026 11:39:37 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b162-c701-4960-a998-3de8-2fce.310.pool.telefonica.de. [2a02:3100:b162:c701:4960:a998:3de8:2fce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a648895sm15430376f8f.28.2026.09.26.11.39.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 26 Sep 2026 11:39:36 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-sh@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: [PATCH 2/2] sh: mm: align hugetlb mappings to the huge page size
Date: Sat, 26 Sep 2026 20:39:04 +0200
Message-Id: <20260926183904.76186-3-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260926183904.76186-1-kmehltretter@gmail.com>
References: <20260926183904.76186-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5951320006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 6it9y6zeyen85wkn7aj5nceypfwhmru3
X-HE-Tag: 1790447979-706070
X-HE-Meta: U2FsdGVkX1+0p108fswUDS07WiW+jePeLIPBJ0o/6j74zuLVr521Mt40Fv4xrb2S3VxfOF3CT/ThWVHBgUQE6usIGUqCzU5qogqTnJ+k8+YYxaJ4LMLcbAz3xM+BYTImrg4U+OMC6++zj2LLX7N0MwcYVvomiwpWZKzns2ZKzeUQmEolBLUI9omLb9VPogGSXX9mnXiItmW6tUnOdjNzaq0NyQizF19KCREGmNkefGcmVdjeBzL8t5vDiQvxgvZo6BcHw6rbueFRhUxA2alZlmvWASUZPpS73ynatmEvPskgUYTZuYF/qgzSUM0kJjC/BWph6YiQVRXfmh3DNjBFv3CN5E1PVfEkBsac1vIz78piB0zXlVtT1yrMkEAZlj5ZdAu5ZkKNHJC65Ettyo51sJPsPeBesmliWoYAgdHW6nmaa5lEpLvLKGJ/SEN7xvlo4JJl73cdMJG1FANDRZ+QMcel5Suffl42kt02asTj1o9qp02szG8xfx+xZt5dOnmwDHtNEIlYymOdQWZ2+NFxtHlAbrRyq3iQF2tG9LuF+Oa5yn2WMWouMiaWj9+Nn4J3wgajDy6uqhxuY1akTP1gEwTvefd7okD+oMLo9lpJhiFaMV/9UR8Zj/oa0cvA+bgRmCebw96SFcGCMujrrk4z/betreesTmXmmqJGf9PGI6unPdJW9Cegx/yRlki0RUz/GNT/IB+8m5MbszCTtd3MMXbI0LiP1XxLuCJxEe4FLKWX18aCD2LPEWO/Of+rpIe5U4/J2I9L/bPP4At8jC4zs0AwJmwFyMOwp8uDC6MNm3f3hwNLl163A0zLGECaxGC6dNa/enlb6r/uijPXU0mhWLFYKTtwAaPNQJdyYHET/f7RYRmEFcVrokGyWpxMDVB1Lrv6YkLsu10+dZ3i1dit54HtMK7XwRmeVLQA7p80IXjGdLeZCVL4DZCSPsml4CMfC1Skgmi10g8ZKnO5XH6
 7e+5Na+9
 ZZCAlivjF85CQ+mh7Slit606ryNW+YlAYQ3XupvXVNOiOkKi5mtj3SQOfnrVRapdRf8OSqfi7NxJIdaqauClOlNH88C/cjuBs8B+MppFbHLGUlcA9c6aYFvNVKYpfHQnMzB8vLPEF7PWc98VUwEHny2VfxWD0sRri8nBFYKtSxI//5H2QUug7jDdLnaREHur9JSFXJv/g1+HRnl3hCnYVElWFdISxFD5uW4QUB0hkFCip4RWY8Lx38DWY7Z6D2/EuWN6AweYt6yprjZaakTkmaONp5hAhbDkS4fCz5/Cg/lse/xVZv6mDOY21hkFpUzM4aPfcNEONHGuOCSRjrUmL+59zr+24bpWdBMJONmbiRk++ACsJAYf4MWrBQrP5UIFfInJ3UIiB5eW27yB6eCM6OfaRh4XsM8FGNxETWTkI1f3zoj7Bbj1sqvdtIL6tQy0Cqka7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mmap(MAP_HUGETLB) on SH4 can return an address which is not aligned to
the huge page size. In a QEMU r2d guest with 64 KiB huge pages, a
two-page mapping placed after a single 4 KiB mapping lands at
0x29558000, and process exit then hits the alignment check in
__unmap_hugepage_range():

  kernel BUG at mm/hugetlb.c:5215!
  Kernel BUG: 003e [#1]
  PC is at __unmap_hugepage_range+0x3a4/0x424
  PR is at __zap_vma_range+0xa28/0xa80

Commit 7bd3f1e1a9ae ("mm: make hugetlb mappings go through
mm_get_unmapped_area_vmflags") made hugetlb mappings use the
architecture's arch_get_unmapped_area(). The generic implementations
handle hugetlb alignment, but the SH implementations only account for
the cache-colouring constraint in shm_align_mask, so the mapping ends
up aligned to at most the D-cache alias size.

Set the alignment mask from the file's hstate for hugetlb mappings in
both SH implementations, as LoongArch did in commit 3109d5ff484b
("LoongArch: Set hugetlb mmap base address aligned with pmd size").
Huge-page alignment also satisfies the colouring constraint. SH only
uses the bottom-up layout today, but the top-down variant gets the same
change so the two stay in sync.

Fixes: 7bd3f1e1a9ae ("mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 arch/sh/mm/mmap.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/sh/mm/mmap.c b/arch/sh/mm/mmap.c
index c442734d9b0c..4df807e0df36 100644
--- a/arch/sh/mm/mmap.c
+++ b/arch/sh/mm/mmap.c
@@ -7,6 +7,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  */
+#include <linux/hugetlb.h>
 #include <linux/io.h>
 #include <linux/mm.h>
 #include <linux/sched/mm.h>
@@ -92,7 +93,10 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	info.length = len;
 	info.low_limit = TASK_UNMAPPED_BASE;
 	info.high_limit = TASK_SIZE;
-	info.align_mask = do_colour_align ? (PAGE_MASK & shm_align_mask) : 0;
+	if (filp && is_file_hugepages(filp))
+		info.align_mask = huge_page_mask_align(filp);
+	else
+		info.align_mask = do_colour_align ? (PAGE_MASK & shm_align_mask) : 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
 	return vm_unmapped_area(&info);
 }
@@ -142,7 +146,10 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	info.length = len;
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = mm->mmap_base;
-	info.align_mask = do_colour_align ? (PAGE_MASK & shm_align_mask) : 0;
+	if (filp && is_file_hugepages(filp))
+		info.align_mask = huge_page_mask_align(filp);
+	else
+		info.align_mask = do_colour_align ? (PAGE_MASK & shm_align_mask) : 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
 	addr = vm_unmapped_area(&info);
 
-- 
2.39.5 (Apple Git-154)


