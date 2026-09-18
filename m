Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C58CBC88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136C36B0098; Thu, 17 Sep 2026 23:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBC296B009D; Thu, 17 Sep 2026 23:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5B426B0099; Thu, 17 Sep 2026 23:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 938256B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:58:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A1BD80585
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:59 +0000 (UTC)
X-FDA: 85225527198.26.F2AE2F6
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3198CA0004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Wu2wlHG1;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789703935;
	b=19+2xfrTU76huwbHf62CD+4biWYGmiX+TV05BIzc8Tj5Dpyhbf/KgVY8HOBMW40ZIcDjGY
	/eJrtI/3VJCuCIyaSH48X+pjKPrvkQOmdzrborBFyqWUbN48B+XSJJf2iQlGtK8XjCKiu1
	iGzkcdMuUKCoFME7WiLWc0f2ULFo744=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Wu2wlHG1;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789703935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uublj1o5v+asXNyk+Uqq0+npYGJId5+xW/omcnk5atg=;
	b=4yhkhJI4i0z/F6h33cgqMhfzBhTcmQDdqj5zb7xnLlEdoKD7+7WiPuHhlqUJnwRDRts9n+
	+7cdFtqd0gmclc+2HnLTmKw+fT+RuA3K3F5VQsekIsi0TOZ7l9yvi0BJefJ/eDDTf6Gwh6
	Qk50YlicC12Bu35xYxp5TrrZNwKXYAI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789703931; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Uublj1o5v+asXNyk+Uqq0+npYGJId5+xW/omcnk5atg=;
	b=Wu2wlHG1pjm3PuuhtoRfiBMBkknnALUyiANiy1j/AMwxlSlCCOKcaNaoFmTsW70xBXIxA2dx2XmoZHTpgeWQoSBjlUj6niWqt7gfssFHJOQsS9txREuEuuvJPOWdiIShMXx18xNMgwIfkHZrReZLmtkSbgmMCSys54yzx4N0WKc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XB9o3b4_1789703930;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XB9o3b4_1789703930 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 11:58:50 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@kernel.org
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] mm: khugepaged: move cc->scan_file and cc->scan_pgoff assignment into collapse_scan_file()
Date: Fri, 18 Sep 2026 11:58:35 +0800
Message-ID: <6c444420195c6a46072fd02553fe468715041753.1789701677.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
References: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3198CA0004
X-Stat-Signature: pag1zm4q1mq6jdpot3feouh3uc1c6jfd
X-HE-Tag: 1789703933-879
X-HE-Meta: U2FsdGVkX18uFSnu7C4BynDsX1tdb5gSYwZ9d+CrRlQWN2CgKCrl7978T9k255eCQJ/DPMhHjir/ZWn+mOLy2ufmOUhh1zKdoqgU+MYmSopSqIzo7cLRwlZA0p8UH1BlJIbdbTR+jZIUzEX7EPzlbJF0XpgM3VwTlCeDkNhoGkfQsq0Wl4w4xLauw6pq5ZWW4ws3DAtcBbC79TVWNW0CrS4pUGFDcjKDwWO8qkB1UPFGY5V4zOG7Nhi1prosnoPi8vGAgqVabkyms0m2hOZbF2nvEGWLLnYJb4UE8Gy5kI1H9ivh1kTnhwYPFbtPFH3A9eR0FEOviK13TQq/m4uB+dRM5oxJSsOt8bW5nOfsNGCzJHTKtdTUD3VBtCu0PrDdqEp6sbSQQLvd/m2PRW5u5S4Iorrp6Zs1dT442gqevWe176Qbd3CDAA0zm0Q5Jizjz9MEj9bbySzZqsOfHzuyUx/68xAv6S6VO01EOH76xvv3MFSAO5ryz2WFEWuIO3NqcBk/WTbiy9sVE4io/sp6veI4XOktJ2m6FZ/IIhllyxpdkOaidhMbEupTyx4DlT9g5Mqd0t+aLQhvUqOVyhScuFGZQAnNPnz+EZABq+aO3I7f9X4NC7iwG+evDH9lab7Grtq51noTUE5lgW5PljF1iTP5tNpxqp7GkUD++DRiGMT7apFb8cD2pYojXvgr3Y6rJnnja8slT9w8AR5cvra4DAkO2aLZKrbVnfVuUKw+KjI7x9sp+s8zXXC/kiFGdRCbGaYcEAJ4VAsR2sjgnMF4JQyXH0TATMlX+rOOHePrxM1FQ03g4iCv7VM8OpYxnYpmGmM601o/tzLavjo9GJuS8uiWfY8Du2SPd/NKH3XG2/NbYLn6DLIaGqAWGZGeBLwf88O3Cmd9/myfAVPy2BSZ7/+7760GqEEIpGgE7gtJjwYVPQXNJyGWB76snmOhHrUIAw5WszrrgDC3L8+OgVZ
 i0a/M2CO
 SDSJB0FmNuapdYS/DhTpwXUpaFSjSb6OgDr+fQmvDdBLaNcx7rxzoT37aM59jSnxgPCnac6eUaBN+v4NyBgbNfypeR3jknqKR6GdPP9o7GV1trK6UBvvL5jEdgNDnDYOlo6q+4BOPc6I1zJGGrL1P3W0TJibT9cHrH8NpRvXdgBIIfRbzNL00zR/nN6jElfiWI33lRcpnLCa5/D81YmCWYlb1D0g/sRhwwepHp6OWPtfibWzyEmGTrvU56z46x9YP0+D0JfOE8e61pRwetI9/ivGBYeU22ivlHpEBkqkyUVOXQjg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the assignment of cc->scan_file and cc->scan_pgoff into collapse_scan_file().
This simplifies the parameter passing to collapse_scan_file() and cleans up
the code in preparation for the upcoming shmem mTHP collapse support.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/khugepaged.c | 43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f81ecaaa4890..249ee91a66f2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2586,14 +2586,15 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
-static enum scan_result collapse_scan_file(struct mm_struct *mm,
-		unsigned long addr, struct file *file, pgoff_t start,
-		struct collapse_control *cc)
+static enum scan_result collapse_scan_file(struct vm_area_struct *vma,
+		unsigned long addr, struct collapse_control *cc)
 {
 	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
+	struct file *file = vma->vm_file;
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
+	pgoff_t start = linear_page_index(vma, addr);
 	XA_STATE(xas, &mapping->i_pages, start);
 	int present, swap;
 	int node = NUMA_NO_NODE;
@@ -2689,7 +2690,21 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 	}
 
-	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap,
+	/*
+	 * SCAN_PTE_MAPPED_HUGEPAGE is work too: the page cache already holds
+	 * the PMD folio, and retracting the PTE table is the run's job.
+	 */
+	if (result == SCAN_SUCCEED || result == SCAN_PTE_MAPPED_HUGEPAGE) {
+		/*
+		 * A file collapse works on the page cache and never sees a
+		 * VMA, so take what it needs from this one while it is still
+		 * here.
+		 */
+		cc->scan_file = get_file(file);
+		cc->scan_pgoff = start;
+	}
+
+	trace_mm_khugepaged_scan_file(vma->vm_mm, failed_pfn, file, present, swap,
 				      result);
 	return result;
 }
@@ -2737,9 +2752,6 @@ enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 		unsigned long addr, struct collapse_control *cc,
 		unsigned long orders)
 {
-	enum scan_result result;
-	pgoff_t pgoff;
-
 	mmap_assert_locked(vma->vm_mm);
 	/* Whatever the last scan found has to have been run by now */
 	collapse_put_scan_file(cc);
@@ -2747,22 +2759,7 @@ enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 	if (vma_is_anonymous(vma))
 		return collapse_scan_anon_pmd(vma, addr, cc, orders);
 
-	pgoff = linear_page_index(vma, addr);
-	result = collapse_scan_file(vma->vm_mm, addr, vma->vm_file, pgoff, cc);
-	/*
-	 * SCAN_PTE_MAPPED_HUGEPAGE is work too: the page cache already holds
-	 * the PMD folio, and retracting the PTE table is the run's job.
-	 */
-	if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
-		return result;
-
-	/*
-	 * A file collapse works on the page cache and never sees a VMA, so take
-	 * what it needs from this one while it is still here.
-	 */
-	cc->scan_file = get_file(vma->vm_file);
-	cc->scan_pgoff = pgoff;
-	return result;
+	return collapse_scan_file(vma, addr, cc);
 }
 
 /*
-- 
2.47.3


