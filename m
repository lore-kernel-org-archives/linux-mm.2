Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD9E3C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA4506B009D; Wed, 16 Sep 2026 05:32:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7C2D6B00AC; Wed, 16 Sep 2026 05:32:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D91C46B00AD; Wed, 16 Sep 2026 05:32:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC53C6B009D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:32:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B32BA1406A6
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:16 +0000 (UTC)
X-FDA: 85219109472.22.6ED76CC
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf23.hostedemail.com (Postfix) with ESMTP id C401F14000E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="h +nDuZ4";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=DamH363K;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789551134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PRWFDwvM0fZr06tYfSZoOVoDNXjF/NbOi9PwgZXG13s=;
	b=egCVGJk6qUEckOHEL3tiOhDd/0IXXhOHFb2Z5L4r/HvoJwuxtijGhtu/PqaHu6UZNkiPJs
	Kxf16hdlkon/3u98kFhTl+MCqygY6wX9BFZXid/XFX2OWyd5i39qDgdXP0XM7OmQIo8e6S
	GxhOKqBkVfJRQpsJntxD3lu7hSx8+TI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="h +nDuZ4";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=DamH363K;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789551134;
	b=3UTAkaL64upbuxTCr0unqH1bUggWYRlpVzXh3POTmI6lw+Q/ydsacJcn3LAgrnBXCjNouH
	vER/zo94+NyYvZkJTqm9s8Hr4nDxcsK4eivqdbdrhzIHsCT3uc/O5VeZ9IAKyUwn5KEjp0
	leTb4TXGFs5QEYAH2j3Eezt8dYsTJX8=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id C033B7A007B;
	Wed, 16 Sep 2026 05:32:13 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 16 Sep 2026 05:32:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789551133; x=
	1789637533; bh=PRWFDwvM0fZr06tYfSZoOVoDNXjF/NbOi9PwgZXG13s=; b=h
	+nDuZ4L3d7Exo1VnWVHkFTiWmBJ3LgIXQqeNIIwptbCr3rocTTogmeSBRfhparYF
	8kgDFCvJL7mBpQZbetk0u9hmVR6g5yZn50P8MISvcSghAJqOQA0voEnJT4/QgyhA
	GDj831STE2yzmfNUzOohrZzAZZyQzVOEwC7USAAY8Lr6KwgPrJ13zFKFFdQLm8p8
	Yb259Q3GPN8AWvUYzvymY2q1ClRPBjA0sILyAiu0+O8zvqqbwC//b17J8h3m4kIC
	Cr4wjVwJM2U8G//TZoNzgQkHENcWcrEUOxLwrC52SlRwgWsDXJAAn0g8zgyw+dVX
	QMbQYjvg3wJAXw+3Q2M0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789551133; x=1789637533; bh=P
	RWFDwvM0fZr06tYfSZoOVoDNXjF/NbOi9PwgZXG13s=; b=DamH363KmwhSZ5zJu
	fhU6H/Ey+B7XjK9/lw6VNU7q7qLYVoT4I4fUzQBv/orFWgEdqDdXd+KZurLR/3JV
	NxsGojIyz8eGDOxEtArmG85Ut+JFBZPugFv1xJSQGTZmWZVQMyhiUldxb+Hh22pt
	IopaLgTUWX+llHnaqMo1+S7+DAo8YYDHltvyrUOpNQZdViGlTms4zQ5KhalJvaYm
	YKUzYulz+bw+eZ/ovtFDvl5VjCg5/f2j7NM3Pm0eiJ0wwFgkjhCHKoFh1ml8qd5/
	isye1zUR9hdNyHV6WLUSWj2EjEd508yrriVlWflkVEEc06+bZWEhCzx7LmZ43AyL
	PmG7Q==
X-ME-Sender: <xms:HWKqanoWMKRsG-2GyM5CckD_IHEJmoqSerfJDxuPgYz4mshhXxsIqA>
    <xme:HWKqatnsZ-rPBsrT-L1buwH9k24IFDEW4-hf7NFhK8baywH9NZW6rEiOh28an79Mi
    xwcqhpe2CDczFYLJU12bNCNQrckfyxR7xK1289X1HdQk4TCFvP4RCsVVg>
X-ME-Received: <xmr:HWKqaqVq-HUH-bvu3I_w0Doryo9ijgUKbICqasGROK7vuP--C9AL2y3ObRs>
X-ME-Proxy-Cause: dmFkZTEOpyDQEfQMjLyldXBPAs1OiAaYjuycA/zprc2XA0sZE/gLY53LzRl6wisjmJsNcj
    shXh7L3amtO3W7Dj4gJ1brhV8efHSvbbvvisq8qNCVrU/hVVqWW2fJ8EDoeL9EfJt8J4fa
    r63UA+S0A+UN3c16swmwWrTj5sK0gOy7RYH1CN+xe4D6TTQ1ncSXBFkweWqSBfk0S52Say
    Dntsl8DI3TlZwS0igZd1iO+ltDo9n3qHIbwcYcvcbVUlu6Rxag/XK6s48+7ZTTYlI2aJe4
    hkL/jN/KxntOAh39VLdXeraBW39brB+PkStvfnz0wMlwqVlAhF3nsCCzTv21LQWeSF/iHT
    pyMAuIQkGFQ08rzLATOXG16m6WQQDf0qrhK3S8NG5J8zh2mNM5qcdfG+xe89hRG/m+7INR
    ADrck8zKABvA0aAWvVdCuEeBi2oCpNFHiAk2Khx6KyEamwPIIWWx1aCyjtcXhsnR1VCXvK
    jOfLqdyuZxn83ODbS+0qUPAqOyBYa449EcVKzMv4hGVxgKwrNVR4sBWB7R/NCH/wZHyXB7
    AWwvIeSxHVuN/dy3GL/fBK1LiTnhq1VJmRsV1IMAH0TLses6J0QUD6xT6cFIZlQl8915KE
    pMjHkmd7973FH6bjWFDUCbqDKgjeWhNiAp/maWL8JO1SbJWp0+skjlFQ/FUA
X-ME-Proxy: <xmx:HWKqahR_V_Mr2pbv9rZuDrzdnixOWbbasAV3UcpgO_vJCSFqSbfIVA>
    <xmx:HWKqalDGnMNNs0EZbSLFG6CnQxp3hCAW0GZxG5t4zPStDkxYWDu1gw>
    <xmx:HWKqasTr1PK-WvoozSZb0m1hB3PaZZFpZ3lWAqHJipTbOF226dTtdQ>
    <xmx:HWKqavSZyUtV_RdIyqvnHoFenMnY7NIV_elSC-vmexJc854ynNW_OQ>
    <xmx:HWKqalrHFX8ywV1H3ozUBi9dSdk3VwmVu9Rjmo_mmjPIuVpqOgyQBYk8>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 05:32:12 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v3 10/12] mm/collapse: work out the orders a VMA allows once per VMA
Date: Wed, 16 Sep 2026 10:31:37 +0100
Message-ID: <20260916093145.4022188-11-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916093145.4022188-1-kirill@shutemov.name>
References: <20260916093145.4022188-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C401F14000E
X-Stat-Signature: 84j7yy6wb3w65pawj3qrwrfjte6xgaxx
X-Rspam-User: 
X-HE-Tag: 1789551134-670976
X-HE-Meta: U2FsdGVkX1+3uhaxH6pICQKRiN9TLJv26W7AlHjWRxJEXqXaBvC1SZ0Hue+rVHHgE5bc2kyDinyJFULWNCOrI2TA7R9tHgo7C83UXlq14oLxwCXXgzStVuBtYF5qASG2QKo+M5e4bKadPU8qq0QCMiLCWCw3Sy3LvdFooeUxodwVbLMl4YHX8dlsqr3hN7GBnhO7P3qCrcvjtmql7hAwfJpGlB2VPAhsuwLNasFCWHROkv2iGZxF46LRtjcYU/Cbk/gUllW/6POYBF1JK4MOgB7/nycrkj5ERhmttdSCNfO85G8mFhQ94TxSf36e4M7E1BLXWtAW9yqqs6lFVgYumvpJbfOwekehn+YOGWZnRhXI9Jb4g4k7RNPLMZYHIqrRR+Z9OPS8msy9+tzC8eN9Y6Qejs9Ew9F5elpzGEhRGNBTSBcvEvxsFmpteMux3viOWiP8AYo83swRfDaGZ2INpNM2YK35WNqU5ODwMlVXZ3+WzEXn3OslrRtFv6bxUJ5Ly+C0+Qa3zrkzBanyidONDSFBIw0FGcr0O08X3UKnLTVjuQ1A3EtPx87XJfeIfM6UKP1aOMeFycz7IMs2kj0LJKhcsnfF525rZmvaunSzybf7Qjo346VfK40xH/SL1Dvoda48qDIPRr0ITkTGWDwCV8G85bkOHnfw8oQFwz2TMU8DwHuNrDjlSJ9KufJu6wj0s7XaR8uKHVPSaN+q3agTydQO5CMttWh+YbDe3rE5FRKfo70eZi/hxAbbOqNQiWNiwWaK87/1jNv8UVT2GjNhFATQqHlGLUToZJvlwhj45BzNgGFDUTrhHGaJsxelK2JJswwYwspcvKeghtI2k03OfY4Vc37bndJqf9J9eeeKXfSQHh6468pV0sw4M8d1qg3rkoSOf2sxL9GGV3v6WW1ghJEwiLRMxd6EgWaP/qHQ8xmp/NrYhAuZWFbCQI16x7rbYm0Hfh1pAZ9LcmFfyPP
 AuLcPOEb
 rNp78g9aMdvv3Tx4HVqvMQSx7OF3gN8tVjcurini+Mq2RoSBkfG/WER1U35EmmHPYWOkrUfkRID9iWof7hIlWJeOS2HhBlagMTJ6i8UdB+hsxJdRRnbEKpulD1yw3Gp3Uor2S7bE4K6vegnSED1EYtyHY6gZrdKrV9Tugc6A8+gSSro2QB3Rp/h7SbqLHGAfAAMgErWcfTQbbEA9KRfWZoKqI0jtkS/mlcVi3AtC9DRZ+BWmDcHqGwv05QBptMcMJ6TZavqxFi6FJt3Ui3srlh3PNs4t1ps1JDIX+GaSlaKm49sN6RUkZpLRzZvjoIc+dEleHByvRDDJ1uqHlwQfEvE48egs/D1/EI1EV8+mfES9vipFY0xQjjIBUZf2KYTebi6J3EpaJ1heIYWk6UktyoO5BMX5GCP9edSmKGIP0atxCpbrH3PH+TbJ8kIZpNS7T1bc1Uz07IAdkCUeNIXlNTKDzwGVMgk9xOnwNH2Ui7w906T/sRThOI2JEqb6VvPbJeplA0q/edE5v3pBQVxYimv1WDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The scan asked collapse_possible_orders() for every PTE table, for an
answer that is a property of the VMA.  Both callers walk a VMA a table at
a time, so let them work it out once and pass the mask in.  It is only
good while the lock that produced it is held, so madvise_collapse() takes
it again after every collapse.

The mask is then sampled once per VMA rather than once per table.  A thp
enabled knob written during a walk takes effect one VMA later, and cannot
widen a collapse: hugepage_vma_revalidate() tests the order again under
the lock the collapse retakes.

Assisted-by: LLM
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9e6b2af6519e..12cb67d8df32 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1549,12 +1549,12 @@ static enum scan_result mthp_collapse(struct mm_struct *mm, unsigned long addres
 }
 
 static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
-		unsigned long start_addr, struct collapse_control *cc)
+		unsigned long start_addr, struct collapse_control *cc,
+		unsigned long enabled_orders)
 {
 	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
-	enum tva_type tva_flags = cc->policy.tva_type;
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t *pmd;
 	pte_t *pte, *_pte, pteval;
@@ -1565,7 +1565,6 @@ static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
 	struct folio *folio = NULL;
 	unsigned long failed_pfn = -1;
 	unsigned long addr;
-	unsigned long enabled_orders;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
 
@@ -1579,8 +1578,6 @@ static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
 
 	collapse_scan_reset(cc);
 
-	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
-
 	/*
 	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
 	 * scan all pages to populate the bitmap for mTHP collapse. The bitmap
@@ -2765,7 +2762,8 @@ static void collapse_control_release(struct collapse_control *cc)
 }
 
 static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
-		unsigned long addr, struct collapse_control *cc)
+		unsigned long addr, struct collapse_control *cc,
+		unsigned long orders)
 {
 	enum scan_result result;
 	pgoff_t pgoff;
@@ -2775,7 +2773,7 @@ static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 	collapse_put_scan_file(cc);
 
 	if (vma_is_anonymous(vma))
-		return collapse_scan_anon_pmd(vma, addr, cc);
+		return collapse_scan_anon_pmd(vma, addr, cc, orders);
 
 	pgoff = linear_page_index(vma, addr);
 	result = collapse_scan_file(vma->vm_mm, addr, vma->vm_file, pgoff, cc);
@@ -2885,15 +2883,17 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
 	for_each_vma(vmi, vma) {
-		unsigned long hstart, hend;
+		unsigned long hstart, hend, orders;
 
 		cond_resched();
 		if (unlikely(collapse_test_exit_or_disable(mm))) {
 			cc->progress++;
 			break;
 		}
-		if (!collapse_possible_orders(vma, vma->vm_flags,
-					      TVA_KHUGEPAGED)) {
+		/* One mask for the whole VMA */
+		orders = collapse_possible_orders(vma, vma->vm_flags,
+						  cc->policy.tva_type);
+		if (!orders) {
 			cc->progress++;
 			continue;
 		}
@@ -2922,7 +2922,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 
-			*result = collapse_scan_pmd(vma, addr, cc);
+			*result = collapse_scan_pmd(vma, addr, cc, orders);
 			/* Nothing to do here, and the lock is still ours */
 			if (*result != SCAN_SUCCEED &&
 			    *result != SCAN_PTE_MAPPED_HUGEPAGE) {
@@ -3207,14 +3207,16 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 {
 	struct collapse_control *cc;
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long hstart, hend, addr;
+	unsigned long hstart, hend, addr, orders;
 	enum scan_result last_fail = SCAN_FAIL;
 	int thps = 0;
 
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!collapse_possible_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
+	orders = collapse_possible_orders(vma, vma->vm_flags,
+					  TVA_FORCED_COLLAPSE);
+	if (!orders)
 		return -EINVAL;
 
 	hstart = ALIGN(start, HPAGE_PMD_SIZE);
@@ -3252,9 +3254,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			}
 			vma = found;
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
+			orders = collapse_possible_orders(vma, vma->vm_flags,
+							  cc->policy.tva_type);
 		}
 
-		result = collapse_scan_pmd(vma, addr, cc);
+		result = collapse_scan_pmd(vma, addr, cc, orders);
 		/* Nothing to do here, and the lock is still ours */
 		if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
 			goto tally;
-- 
2.54.0


