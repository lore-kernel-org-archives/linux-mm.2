Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B30BC79FB5
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 02:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E3BE6B0093; Tue,  8 Sep 2026 22:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36DDE6B0095; Tue,  8 Sep 2026 22:58:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 236836B0096; Tue,  8 Sep 2026 22:58:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E92C76B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 22:58:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 86C1DA541D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:58:40 +0000 (UTC)
X-FDA: 85192716000.06.23CB38B
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9ED0E40006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:58:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Z/vbx679";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788922718;
	b=TKpPfuYxrZtgn3vcFAto+/vk6BBfG3TMK1ZgDqK2e1bHHCCA0vFW9ZmUSvLGAUBcq5u0xz
	aqKRS0us4ZO3to8JeGsctjwvPSnxlqjHaPtUcwz6t3G20i/4I4dEmvot7v4iAqFSDCumNz
	mt53eh0IoxokwncJIP9cxEdqFPRSQ9A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Z/vbx679";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788922718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+CrA+cvlGJlbJCNYzltiXcEC/SgR4IipKiqObnP/BdA=;
	b=kwbiCEUtuSRKB52zXRsGQEKJSnxapelYJPE1vSOo0jmHobPIzS78fBf3TPKt7gadv0HECh
	h1PP2dAga31gTFHcb1x5a6085Jm47hcrTmP5eberVIRzNill0T1E8KzhLJPYPWiG4+0h6S
	mjIlVY9AWE3mlwKwFywuC3htjKBh1Jc=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so4428790a91.2
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 19:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788922717; x=1789527517; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+CrA+cvlGJlbJCNYzltiXcEC/SgR4IipKiqObnP/BdA=;
        b=Z/vbx679yIAQB+b0IvdfozeUlMKuR0gQdOwEMIgnYCbjWn371bTEbWXEkvgLXa/BCw
         eaSs1aFfmMm6LM1XsGRLQCwMNJdzVmjTvjMqmpdDDcs2wKNTDSeLUi8o3HkVvpU4yOdV
         5S371pGCwYwD9b8vZf+ZKL3XaZ01EU1Sz7duvUxE7wnUTI8It/4QUNn7IWaasBPGCy4o
         QdaaMKEaCMGMpicaPaiJDkFCY6ucUT26gd88K8hGCrJWs6vev7XWonH/M57reP4NJzur
         Fyp58P03r5Ky/HFVXH2oBHXWxdFm6WbRp3iYOquJgBjreNOWFOwORlS3zqe+WrI5le0i
         cjrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788922717; x=1789527517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+CrA+cvlGJlbJCNYzltiXcEC/SgR4IipKiqObnP/BdA=;
        b=Tun5zGS+hzRAh8kbpK8zdU8KLss9HeVeznok0X+QWzSDAXJqdrL7TiEd8PRf5X59f0
         u+nX5RZwRYES91P9p/mejwCBCUOUjPpZZgQaFvHRA2hHGYefmp1+UqOmPIknRzXKZZPJ
         miOap53Y1iUDytQYQEElrDDhe7tXDjPRFkEpOjChQzpKJTsUNcuFbi6ty/63HzBpPTB2
         B/aIsTvmCY+SIQJHhXw5js9DhSR8JvElL5ytru9Texa6lR8AhMcCIPUuy5tBNFEDGq87
         bGuDUgp2v5wdpSTL/wErv9MnSi/YBfLCU3iF6frX9DxKHQLXwj9fQwNuegQ3oym5yjTw
         Zdqw==
X-Forwarded-Encrypted: i=1; AKwUvBwt35x/OsfDf0e5rXjpjZiLRQeIrhrL16WSrAAkafbo5RTTKVEHrTYRvieM1fazNlCYiywJ/AQm/A==@kvack.org
X-Gm-Message-State: AFuF++lsVdQw1P+JGRJQ2EEcYKu2bGQxOtfE870xx67pdD01vNAJXbNt
	NWR83eteRW/hmasL5bnh+fDVY9B9Trl0FA6uHcQD51cAJv2iyYevdlj6
X-Gm-Gg: AYBFou20on4VP64AemM8nh1sy6yxnXVTJegmAZMt5XjMB3LMMrh8IwKcNsXCFbOfC0h
	hVZJYOr3rv24o1K3SE4G0TPrNGhjj4wZQ0j9rdQwwpEUNkoG5AUnpNoGEK0QKBzFJ9i569e/6qu
	iZsvxPy+mh00nBpSZPqSZW5cNZdo6p1eL0/jsF15l5q2Jfrw7OWTrRA7ZovwtLiYoRelLT/KzV/
	vQg1pT+l2bMOFnCdGI1Wr3I7GizJ8Veon7ukMjNhkbOLdss3So3W3aXPSWG3RK5PNmrLnavlEhb
	qXTJ1aQysL9tv+wkY1LSg7PVQs10+na8r1IqqCwgekv/bG4lNSA5Kp4KwXqZJtIfrIhFRdbKrfE
	5ZCRIGyvPYJBxLE0dW3YdT0kqU7z4lErHzx5yGaZz76KjiFRMcYlaO6EN4TfKn6FxtECvsRI4fr
	N//35hNg77NSN3ootk6pF4lk97gfP1MSs/t2XAQXJxg3/jKuwgLwRLsZyEj3wRjkXaUWpBzbxNt
	zcCRj3/llTZPw==
X-Received: by 2002:a17:90b:4d06:b0:366:10f1:3d91 with SMTP id 98e67ed59e1d1-39b2614df74mr46235543a91.1.1788922717300;
        Tue, 08 Sep 2026 19:58:37 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08c39451sm35077172a91.7.2026.09.08.19.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 19:58:36 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	zokeefe@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v5 2/3] mm: khugepaged: fix folio is used after pte_unmap_unlock()
Date: Wed,  9 Sep 2026 10:58:02 +0800
Message-ID: <20260909025804.3233645-3-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260909025804.3233645-1-vernon2gm@gmail.com>
References: <20260909025804.3233645-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9ED0E40006
X-Stat-Signature: sp3h4infdw96khafjrgmorubh6ctnnti
X-HE-Tag: 1788922718-466194
X-HE-Meta: U2FsdGVkX19AfTk/jNgLzcGKR72ea5bjfz4nsPkscs5OP0Bb3Ey6VO09cwHK/nPGn8OVD/9JsQoSRr5YjZKSUk0SG7Nre8GbS19sUyZZoO9ncjpjhgNDv20FB0C0/LZGQFSU1SEH+I3ezAT6VlzPuVKe0+HoVc+/rPWmVXfkgAjkRw2KyRx0loX8yxztX+pOYlZfoYGfZw5zIqIt5PmZmwVRCT+9MITzI0aJgEtLz7XwgJn8iymrWnYIXjkCliEzkMc5H3P4VmdCILSnfOvsdiiNiSw1a/U/YPx6G3c1v0vL68tt34FyCJs2i7xJjUK380xmiEXSawW+6tYjjuLMpDWMidMkMloo6RbKzp9kJqLtxL+iVFyD1OKBvAKPDwzmstX5llXf1XhNFKpi2VCA5uD9STY1TdDlGmKICRpaeWdT2YBDmkdPLOiwHDHC7B321watZM3pglOQKx+srtFpJqet5nh4652TSSUYrf4YXfvxwJlEXYRAHv1LSPgAfoScgqRKPcUSRj4EPLswVBHqRE0Bl4ibfKlct7pxt+8c/fqT3iQvkN3s0XYCJaCvY8J6Nw8g2IvDetxCa40hEOyoKzvAg43ZBZs6f+9liWxDLyrmmErMixvFc1YJ3iSVIdbZ1g5nj/8waRxHBj91XYIdXL4QcPLkP81SWBpOKb1unozQtke8RShSl7/ewibOKaWNPi/fCuVSWSewfEtwv3c1gbQ4iQ481HGg5Cra41SBKU1hZD1163IcIBgl9zzsOCH//bPIlpDtvRo6GorW+kzR4oqL5Aa7Pyp1SSdGC0Md6uPD3Fc43AtR5ZOudvYIihORp4jzDXm98x82asSaN6Sq5cEDoW4dP+qVFXpaybtkmBP93mTJ2mt3TuHhuy8PBGiQb35CidIJveHHr59BxZ7ygW5+FhfYTIg4ep8kl0x3K8ntbbJFng5vbEIgb0aill8pNcDi59SGfnXj3WuoJd7
 TSAfzvju
 UXsPsi469kF0I9YRKdOE23uhYQsX80labmQkUFKfmXE+kR09T73O4rt63a1XktfLzDjyAVZS/5rq76el2j3uu2+0RRb1MBza5aB1DJLjdd0Eethe6usmDAW1H32u9D1xeU59pt8Ti3GHzolFdOZvLfQf4xSHAUw5azps5OHJhMjG97hKXwJngkpyh98WD4cUrgrtWbkB7ntXD+rlrFYUdmLF/foawZRs1TM19w0XSwinBTwtIkl5/0WoEiuqBBxeQSnFWS6odtINijVXZ72I5yailwVU9oZvJ1fv7WxX3EllsceVNk5ngoYtBtUspsibuuP+QKDW9oRpTTZHXGhzO5bQDfX1kOPH+6FUJvJQaswfLs3B6ztnLFHlnpxnnyx35K4E84nC6z18t1j+zQAFQGDqY0vpq+3yIQFuNHCExIYOxpqYkMNR6xq/PkTIvAe5IwX4PLvZ15hSRF2/6ZVaM3iu2KQ18GnwsArm0G2Ud9e0K7miWWyTNTs8CXMmVjNXDZ92p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

After the page table lock has dropped, the folio can be freed
concurrently. The trace_mm_khugepaged_scan_pmd() is left with
a dangling folio pointer.

So using the folio_pfn() before dropping the page table lock, closing
use-after-free window.

And other pre-existing bug, When the `for (i = 0; i < HPAGE_PMD_NR; i++)`
iteration to terminate and the folio operation preceding is normal, but
pfn will be incorrect. so we really only trace the PFN if it really was
problematic.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Fixes: 7d2eba0557c1 ("mm: add tracepoint for scanning pages")
Cc: stable@vger.kernel.org
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/trace/events/huge_memory.h |  6 +++---
 mm/khugepaged.c                    | 10 +++++++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 7b526528f85b..fa828967e1fb 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -55,10 +55,10 @@ SCAN_STATUS
 
 TRACE_EVENT(mm_khugepaged_scan_pmd,
 
-	TP_PROTO(struct mm_struct *mm, struct folio *folio,
+	TP_PROTO(struct mm_struct *mm, unsigned long pfn,
 		 int referenced, int none_or_zero, int status, int unmapped),
 
-	TP_ARGS(mm, folio, referenced, none_or_zero, status, unmapped),
+	TP_ARGS(mm, pfn, referenced, none_or_zero, status, unmapped),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
@@ -71,7 +71,7 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->pfn = folio ? folio_pfn(folio) : -1;
+		__entry->pfn = pfn;
 		__entry->referenced = referenced;
 		__entry->none_or_zero = none_or_zero;
 		__entry->status = status;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6ee0ad13a31f..b352c1330f8e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1612,6 +1612,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	enum scan_result result = SCAN_FAIL;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
+	unsigned long failed_pfn = -1;
 	unsigned long addr;
 	unsigned long enabled_orders;
 	spinlock_t *ptl;
@@ -1706,11 +1707,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 
 		if (!folio_test_anon(folio)) {
 			result = SCAN_PAGE_ANON;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 
@@ -1721,6 +1724,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		if (folio_maybe_mapped_shared(folio)) {
 			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
+				failed_pfn = folio_pfn(folio);
 				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SHARED_PTE,
 						     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
 				goto out_unmap;
@@ -1738,15 +1742,18 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		node = folio_nid(folio);
 		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 		cc->node_load[node]++;
 		if (!folio_test_lru(folio)) {
 			result = SCAN_PAGE_LRU;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 		if (folio_test_locked(folio)) {
 			result = SCAN_PAGE_LOCK;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 
@@ -1759,6 +1766,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		 */
 		if (folio_expected_ref_count(folio) != folio_ref_count(folio)) {
 			result = SCAN_PAGE_COUNT;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 
@@ -1784,7 +1792,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		*lock_dropped = true;
 	}
 out:
-	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
+	trace_mm_khugepaged_scan_pmd(mm, failed_pfn, referenced,
 				     none_or_zero, result, unmapped);
 	return result;
 }
-- 
2.53.0


