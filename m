Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C0BEFC590A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 08:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7996B6B0088; Thu, 26 Feb 2026 03:13:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771226B0089; Thu, 26 Feb 2026 03:13:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67CD86B008A; Thu, 26 Feb 2026 03:13:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57A7E6B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:13:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED0211609F7
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:13:42 +0000 (UTC)
X-FDA: 84485893884.11.777D723
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 19D5C1C0010
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:13:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y+nvrZou;
	spf=pass (imf21.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772093621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/F/t6odtrO1QsYUM+Oc2ZRehZzeRWIs6L56PaAgiZlk=;
	b=FVnikXn6BT8Rr/gOx4tQkReQ0ai7+9OQVYywym+pVEWNTEuibeDSZovQSv8sNvB5S9m1YI
	GKGFHaZsb0txZs32lz3kvQS9bnAzIdh10DloY/vmESueBASCbip0+ck0pGvGWYfyAZKWuh
	vlEwKK5LSQZLpdgsBAkXyqL64hbeKDk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772093621; a=rsa-sha256;
	cv=none;
	b=ykQSO3mzFqGiayYNRdeEcsUgnKeR5ZkPr7Z6V2bToY/1CWGjmGj5C+JdIIdHKx+cYigh8X
	uFONCeuHBnldE6jUOPki0pJlm1iWpodwmzmmBMIuLKkeHnf+QWFzZre+42mbBgyjGn1LUt
	jCxogbOZch3ZMaG9/xYdIJqa7g2LL0U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y+nvrZou;
	spf=pass (imf21.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2adc1d9ec56so3774285ad.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772093620; x=1772698420; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/F/t6odtrO1QsYUM+Oc2ZRehZzeRWIs6L56PaAgiZlk=;
        b=Y+nvrZourOpwucx/26WxJ/83U3ZZDFH1xzNrFi50COwBZhtmXM5J05ZUgRVC5gR9Yr
         OJ7wtv/7NjhIsv8X23aFHzon8gu48PVXVZ02ZrN7sZqh5pDGcd7G1LzPL4reM4uNHl7e
         JDSJYyfsDzTkNAth4wkmaQBEfVOz9MaRYCR0pkBkPzShPO5f5qtbDaNu3srqtSaJJmHt
         aGRwIKCL1TGVvTJAqBWGPdp99W2Zv/GNzM1BE2J4aKtXPF3AbptF/kDtsihFJPt8fzTi
         Ca/3Kqv9UCV+knFHWelqmSEkq2bDpv5QFSSx0CbnQVq7WoL+DINFpazXvfOKz6ab8xc9
         puIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772093620; x=1772698420;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/F/t6odtrO1QsYUM+Oc2ZRehZzeRWIs6L56PaAgiZlk=;
        b=nBBvgfIIpfbi1DWSsNwZRzzy6kqL7MPkoAXOLpox6QUKtnA7KFqY1ctJYr/7aptw3w
         0gf3fOdwY1hP/onAzV95ArgRUbLu7LlBjDYcEOX0P06B/OUlFyJS8oToJS8PJ5kdYWH5
         cD0iJSK9YC8KWpYLsFuhiBCIrUoRXPBQAypI9F/tV8eR5f8N/OWazXRdB/vZAMrxH9eH
         evTOeXHqRu7vPK6lI396l6jkWS8YtResXUgcLiRDRnF8t+9auWp0YrH+X+5PtK7Sa8jL
         TG8XbrGuIDHcGyIEBjN8C38ekq93a/w/rDdQMaOjnKqx/qRBxAsJvCM9ABE+JUdjIcg9
         Ir1A==
X-Forwarded-Encrypted: i=1; AJvYcCX8aHfqV8YOZ8TJhbJSLERK/bXpZ0c5q03xuWOU8UW6pG8jQ994xuAkxCAybOE/Yi2tXOaL9SHv9g==@kvack.org
X-Gm-Message-State: AOJu0YxOVggOLHuvBc4BE/REL5QlDCBGOa5Qa12y41VMzU00dmlJhY7L
	814OijoHBM/5vwjfslHNjQMbWWMg9oyFxY6/Cu2NJJS1J2P6cp9pKfF6
X-Gm-Gg: ATEYQzxMCjS5XyA+/8TikQkD90StvfrA7ug+CzlWQTUGo3CuG1FK0JXEpvsyTm/nwRv
	9kWgJ+kz8EwNC1efNb5+Cfo8N2HK3g3h4xk5851a1BWhf7chLjSurroc2sq1AQzGZaZ+4lzydOF
	GEdO2PrxmkeEs4t0p5rYj5Iy5M6h7a0hNgEUPcJPw1S1/iRsu45TRruEm7bC+Wu7xlm4uqX4yye
	oIKUOLo4n6C8m8q0xPFmCGAod+4rTRPXdnEjQMgeWRsfxQsW6ItIQI27mbV2316sP4JhWsMtWVf
	eOrDgSUNQOdJYGJAkWVZffQUwuTP67m95fBN+aLiFpFrcRo/lEoIvZ1YEIRRwloL2Mku9Rzi6R6
	MbaPJS3gBS4NxwwDyIpyqh5py1D5ulIDDZzPBudF+D7vLJ0muYjNqkWB/y/RUPRbFQaPP1dpNg+
	BSM9pCiui0rTY1AoCIY2HoMCHnO2x87gkUEnAak9bdZBdDgzBGByK62kHOr6m0UdwFNJuM6MKTH
	4B5Rw==
X-Received: by 2002:a17:902:ce0f:b0:2a7:682b:50af with SMTP id d9443c01a7336-2ad7453ae06mr177141285ad.40.1772093619850;
        Thu, 26 Feb 2026 00:13:39 -0800 (PST)
Received: from localhost.localdomain (n058152022206.netvigator.com. [58.152.22.206])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb5b3889sm16375365ad.16.2026.02.26.00.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 00:13:39 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	richard.weiyang@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH] mm: khugepaged: simplify scanning progress in pmd
Date: Thu, 26 Feb 2026 16:13:13 +0800
Message-ID: <20260226081313.53518-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: k68ww6kazpbb7tcierzpfn95muh736t6
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 19D5C1C0010
X-HE-Tag: 1772093620-115605
X-HE-Meta: U2FsdGVkX1+cK+bi8pbaCoy19kTPhb+diTeFC+2CfutUy52yNF3aNbn0FjdpkwbutY1lvMnM7aDNZdrgfeZmvPdaneBat4BeEgnkEIM4ZCJ4Hw2X3VvW81QiELCLxjGROsL5EGjdFn6Vsxf7uEubhS9xiSZeJJFfSoUl0yJVqeMvcYvN+vAK/wdAW+wpbIfN9RxjEwJmMBm14cH7FyTEyuVlf1yppeVhAZEnsIY2qvuTOHqFigIvKmNnVmi1xoSmmXUa9DH4h23qNbyhbyR2qsMAJdeopq46SrcSn9ilV/cEO0nMej/SBKIund8vlfTEexTddvZ9MiFfuiaATOaC5OFVR1JaoTszzpCt73GKJM1LWYvoQ2sKvsYXeieKXvFOeqXTV1nwYK6eMxH1f7ZbidGNszwhmlnJl5hsQ5a+S0UhzE9UxV/I40W1fzAOJ/pQBSoFqs3zcOx0qdyHeat5yEeYWylJ834NhMVhrKfKi6qNbN0Jn5+obEALuGB9u9N3tu8z+JXAoKSKvnmV3nMGRTzlGsDtjxEfytHHLdC5HfKB6eeW+BKXHUkV+qtJnshGrjzjF2iR4eHxQhhELD+q4KfMnrTgvKm3wZLCM3Wsxokt6dFiz/Pt3u+sGO6xgOYXC6JDuAFPmVNIxUD3I1zt1Eo1aDUsPl/62ptbRk0ZWK9IJCxwWWI8WXVA/T8VWRPfxGMaf/vceP+lcy0Wuz7u6PdrWV8WUBByg1UCkR3LUlhZKfE9As/EWdE/axcffiXUWy8Nn7RehPTqfMjr0eWb2EEsNEBijOS56GCe4IuE1nV8ypdNFS+WSLl4f2gd1/LU2mhcyRxYaMKbXI8m0grr41JjZYnbF5KWdGPSULUskTT595NePWBZC+GMm4ewiKv251bEGrhAau7/1vgCXCA46Ky/MGXXCm5dzWZcTNRo3PRt4uNIxnpZ/p/leq6ptqI0i6azy/BP2Fpe5kCKWAA
 JkD+PqYJ
 EQvhEKoxE9nxgpByjw8Q4aMysEniAn0+oZPwleb3FJCewkWmK25EWojOMlboyEsvrv6/cozXYZSzBOA+cT+0AbH+JomGRmv6yKrWpEBEDp1nBwjTdPc1aOEUtIzF3sl8DGzVrKU592DAnovFW+LWqBOqqasv9vyFCVNWiGRXnGurMta9rFjH527X05uj7n42E+BORJzGdBgLPAVZUn7G9GFmDoxWCJZ1fJAxp03dPtUxvNsxJfLviJ2ZCu3cegJECa/qe4MDxMLsIvG1umuvgxdhcqh76XeCX2SYTrwyU7WMrUhctyOTku+V8ZJl5Wv22fNtyWExM5JGNGu/QT6hv9LgC4RKH0VI3VVkLKrwXNz0fZDcVy0jrXHJb9HUhtK1aExH7GWTOIbzM0jT4ZqMhosncgPcji45g7aHQ0ItwOETM9Zx/vHXL5eOTVKbVGb9LpEvawsfUa5NXDkavdtHIyLjR3iLJWdtdunFHJ3Bs7n7z1dMKfUfMMSRjSqCuHLtxdHL+oh/YP+aXJEGrOcOdG4Rj+iJ2zDCs09K5yk64stpmzMI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

Placing "cur_progress" inside "struct collapse_control" makes the
overall code simpler, there also coincidentally has a 4-bytes hole,
as shown below:

struct collapse_control {
        bool                       is_khugepaged;        /*     0     1 */
        /* XXX 3 bytes hole, try to pack */
        u32                        node_load[64];        /*     4   256 */
        /* XXX 4 bytes hole, try to pack */
        /* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
        nodemask_t                 alloc_nmask;          /*   264     8 */

        /* size: 272, cachelines: 5, members: 3 */
        /* sum members: 265, holes: 2, sum holes: 7 */
        /* last cacheline: 16 bytes */
};

Also rename "cur_progress" to "progress_in_pmd", make it clearer.

No function changes.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 mm/khugepaged.c | 51 ++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7c1642fbe394..00e025f16c02 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -70,8 +70,8 @@ static struct task_struct *khugepaged_thread __read_mostly;
 static DEFINE_MUTEX(khugepaged_mutex);
 
 /*
- * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
- * every 10 second.
+ * default scan 8*HPAGE_PMD_NR ptes, pte_mapped_hugepage, pmd_mapped,
+ * no_pte_table or vmas every 10 second.
  */
 static unsigned int khugepaged_pages_to_scan __read_mostly;
 static unsigned int khugepaged_pages_collapsed;
@@ -104,6 +104,12 @@ struct collapse_control {
 	/* Num pages scanned per node */
 	u32 node_load[MAX_NUMNODES];
 
+	/*
+	 * Num pages scanned per pmd, include ptes,
+	 * pte_mapped_hugepage, pmd_mapped or no_pte_table.
+	 */
+	unsigned int progress_in_pmd;
+
 	/* nodemask for allocation fallback */
 	nodemask_t alloc_nmask;
 };
@@ -1246,8 +1252,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 
 static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long start_addr,
-		bool *mmap_locked, unsigned int *cur_progress,
-		struct collapse_control *cc)
+		bool *mmap_locked, struct collapse_control *cc)
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
@@ -1263,25 +1268,23 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 
 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
 	if (result != SCAN_SUCCEED) {
-		if (cur_progress)
-			*cur_progress = 1;
+		cc->progress_in_pmd = 1;
 		goto out;
 	}
 
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
+	cc->progress_in_pmd = 0;
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
-		if (cur_progress)
-			*cur_progress = 1;
+		cc->progress_in_pmd = 1;
 		result = SCAN_NO_PTE_TABLE;
 		goto out;
 	}
 
 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
-		if (cur_progress)
-			*cur_progress += 1;
+		cc->progress_in_pmd++;
 
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
@@ -2314,7 +2317,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 
 static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 		unsigned long addr, struct file *file, pgoff_t start,
-		unsigned int *cur_progress, struct collapse_control *cc)
+		struct collapse_control *cc)
 {
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
@@ -2327,6 +2330,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 	swap = 0;
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
+	cc->progress_in_pmd = 0;
 	rcu_read_lock();
 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
 		if (xas_retry(&xas, folio))
@@ -2404,12 +2408,10 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 		}
 	}
 	rcu_read_unlock();
-	if (cur_progress) {
-		if (result == SCAN_PTE_MAPPED_HUGEPAGE)
-			*cur_progress = 1;
-		else
-			*cur_progress = HPAGE_PMD_NR;
-	}
+	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
+		cc->progress_in_pmd = 1;
+	else
+		cc->progress_in_pmd = HPAGE_PMD_NR;
 
 	if (result == SCAN_SUCCEED) {
 		if (cc->is_khugepaged &&
@@ -2434,7 +2436,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 	struct mm_slot *slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	int progress = 0;
+	unsigned int progress = 0;
 
 	VM_BUG_ON(!pages);
 	lockdep_assert_held(&khugepaged_mm_lock);
@@ -2488,7 +2490,6 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 
 		while (khugepaged_scan.address < hend) {
 			bool mmap_locked = true;
-			unsigned int cur_progress = 0;
 
 			cond_resched();
 			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
@@ -2505,8 +2506,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				mmap_read_unlock(mm);
 				mmap_locked = false;
 				*result = hpage_collapse_scan_file(mm,
-					khugepaged_scan.address, file, pgoff,
-					&cur_progress, cc);
+					khugepaged_scan.address, file, pgoff, cc);
 				fput(file);
 				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
 					mmap_read_lock(mm);
@@ -2520,8 +2520,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				}
 			} else {
 				*result = hpage_collapse_scan_pmd(mm, vma,
-					khugepaged_scan.address, &mmap_locked,
-					&cur_progress, cc);
+					khugepaged_scan.address, &mmap_locked, cc);
 			}
 
 			if (*result == SCAN_SUCCEED)
@@ -2529,7 +2528,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			progress += cur_progress;
+			progress += cc->progress_in_pmd;
 			if (!mmap_locked)
 				/*
 				 * We released mmap_lock so break loop.  Note
@@ -2852,7 +2851,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_locked = false;
 			*lock_dropped = true;
 			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
-							  NULL, cc);
+							  cc);
 
 			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
 			    mapping_can_writeback(file->f_mapping)) {
@@ -2867,7 +2866,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			fput(file);
 		} else {
 			result = hpage_collapse_scan_pmd(mm, vma, addr,
-							 &mmap_locked, NULL, cc);
+							 &mmap_locked, cc);
 		}
 		if (!mmap_locked)
 			*lock_dropped = true;
-- 
2.51.0


