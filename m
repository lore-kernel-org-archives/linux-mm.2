Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBA5AC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 12:49:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B91496B0099; Tue, 11 Aug 2026 08:49:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68C66B009B; Tue, 11 Aug 2026 08:49:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57BE6B009D; Tue, 11 Aug 2026 08:49:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 838666B0099
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:49:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 609001403EE
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:49:26 +0000 (UTC)
X-FDA: 85088969532.30.87EFAE5
Received: from out-173.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	by imf07.hostedemail.com (Postfix) with ESMTP id 94B244000B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:49:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Aloh00tp;
	spf=pass (imf07.hostedemail.com: domain of nico.pache@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786452564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gR1+r30Mkqw9blPKY78guCWs8LSsvYgWVex7UAgVmzQ=;
	b=APXv9I3uerqaPVkdiRu4BbvLbdfSvm2S/tO/7pRulh/R6sgTiJj1xGXyD+qJu+Ki+m3FRd
	0TJH5F9svBoTlONf2hYhUEOPa3qhG80mlUIg6tXaSdL7tbHGJthsKzHC9DkeABgQjL0U9j
	Sl3KpqcghrjnzeBV3lhrmwCHcuW4AYo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Aloh00tp;
	spf=pass (imf07.hostedemail.com: domain of nico.pache@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786452564;
	b=sfJNBYFoDgZTjcIrNMfaBYGiyZoddOqI5L/K/rilVm+5ARF1+SYmdlQMgM/nay2qT5+5sU
	8vfD1zPe+47GZlfcem11MP9T/PdhNi3HpH4SF+Vjolp4Q6Czig2hC7LWi40io5QCc2XA5D
	mAJSF0vLpJbNX/swfl3uLCuz9IgBRTI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786452563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gR1+r30Mkqw9blPKY78guCWs8LSsvYgWVex7UAgVmzQ=;
	b=Aloh00tpuWGgHKkcp/GH99nGD2LT50Jl+8Z34Tzod0/+brfcigGbAaRkWYGl8KvqutI1y4
	moHyBzTbCniDicENMLUTvfJzP/fN0RsnDWNcqWc5vRuXYB44BK8gZMRXORbjtiQlvUVGA7
	A3Lk5q9mStCjwFIaag9hhe4UOhG3P/w=
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Date: Tue, 11 Aug 2026 06:48:34 -0600
Subject: [PATCH v4 2/7] mm/khugepaged: extract reference check into
 folio_pte_referenced() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-khugepaged_pte_refactor-v4-2-ddac39d61c4a@linux.dev>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Nico Pache (Red Hat)" <nico.pache@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 94B244000B
X-Stat-Signature: tkr8abr3zo3ngudsmstqxessy7kxdg6q
X-HE-Tag: 1786452564-338364
X-HE-Meta: U2FsdGVkX1/bedtruynKGQ+gCWt8q0MFi4W5O8/TSnNSPOSg6p8r0Th1s7BnZjtRyLSkV1cvd4JsxHyv54TdqeHtdumWH5p1Y2TsnGjjJqXXKOQk7njgbAlSkOL4b10wcExM3yftT8leb/7QibPatVWsQsZ4yKWUWDXKGAhK462GzWEGxDUY+0RjSBmOzYgvBkyTWMtKX+Qr2JG+Luzowe/u7MhY2stCig+SHNQ4TZoJSFPj54oi0WcIRgpCsJmdWHItPSJzt6J90rb/e9LjIuqwefd+J+w7BZX1saLHQcBZ2QsMeDYWGVaim932gb1DxJm8GGMgEmLTBwZT8a7SGYt2ULPhO3aeMzgtuhO6okuxAhcgwLXXs9ew2VeQQlIFJYHZ3GnwOjeFFsCZM4xdKQUprQO+4YTqRyEwB3bD6uFvEADnu5FyfC9MUHQQ2oyfocNaJUFwdtcww0RE3IYz/M30ivB8FDUII4bvrGb6RI1QBM4BIRrOKxvS4Bwxwo8OnzE283EHJ6w8snh2KOZD4P0p1gPD0EkIjM2Is2SmZkINyerIElsWeOJvId/B1u/1OZtdcVvLKvbDAVWmZssGzjulBpc+iHCOCmC621bPQj+P08XCXsDeIducqUF8XIthfcRENyTD/PnXkuPsaePhLll4crTL9SsLCu3P2lcGFKoXMrd1SV3dQSRZ9nQ+46ovL3AiG+rmYeMieBAbREJ6zF8VStjOPqn6bUnAgrhtfBlbe2br4vm2QPm8jss9DcKkKHl5kmieDeR56Oo4YosLdJyXTchn+yq4ORLZ89RRaDX9YMoX2rckGEU7hjWxZuqGFhePsVd8XVnin+p+xlNHxyzt6peEf3tbvPLR8ZRU4nh+IS7DQqd+8jRGH1xy4O4/8b1a53jXmcFDqvLAtMybYOKxOkT8JrMu7SM0OvQ+3lMGSdRAu0yl5Ysf/+83iwV6BON67m5UaY4asY0bldo
 mOIEOETU
 FmXMRDX01QEn9JfZzMgZqyAoaxU7VHKawsrgWCo9cc0o8ioHPjDgOBXNrKedWLoGyKIU5azOCx7EHwIMehEez23OXs3hVyDqznPy8mSFaPhkSQMKUiUQgZicU58vMSJ28mTEQbm3aaTXCM/pDFA2AoUrPr1OVu4teLZp/6hbNyhsOvoqYRBmdXt0OO2qHQRZSnUr1Q32R8stYA+G+HoGqomPKaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change deduplicates the "is this PTE/folio referenced enough to be
considered for a collapse" condition that was repeated in both
__collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
a single inline helper function.

Also move the comment and use it as the function header. While we are at
it, updated the comment to clarify that a young pte is a recently accessed
one.

Acked-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
---
 mm/khugepaged.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1e26ea97381a..8babd4c97db6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -672,6 +672,22 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 	}
 }
 
+/*
+ * folio_pte_referenced() - Check if a folio or its PTE mapping was recently used
+ *
+ * Return: true if recent access was observed through either the folio state
+ * or the current PTE mapping.
+ */
+static inline bool folio_pte_referenced(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
+{
+	/* The folio was referenced previously ... */
+	if (folio_test_young(folio) || folio_test_referenced(folio))
+		return true;
+	/* ... or the PTE mapping was recently used */
+	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);
+}
+
 static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
 		unsigned int order, struct list_head *compound_pagelist)
@@ -810,14 +826,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		if (folio_test_large(folio))
 			list_add_tail(&folio->lru, compound_pagelist);
 next:
-		/*
-		 * If collapse was initiated by khugepaged, check that there is
-		 * enough young pte to justify collapsing the page
-		 */
 		if (cc->is_khugepaged &&
-		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) ||
-		     mmu_notifier_test_young(vma->vm_mm, addr)))
+		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
 
@@ -1766,14 +1776,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			goto out_unmap;
 		}
 
-		/*
-		 * If collapse was initiated by khugepaged, check that there is
-		 * enough young pte to justify collapsing the page
-		 */
 		if (cc->is_khugepaged &&
-		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) ||
-		     mmu_notifier_test_young(vma->vm_mm, addr)))
+		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
 	if (cc->is_khugepaged &&

-- 
2.55.0


