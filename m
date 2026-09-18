Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A41B6C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 239506B0093; Thu, 17 Sep 2026 23:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12F426B0095; Thu, 17 Sep 2026 23:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1D966B0098; Thu, 17 Sep 2026 23:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B54DC6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:58:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 408524059A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:59 +0000 (UTC)
X-FDA: 85225527198.06.C104BB3
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 79D921A0006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mPyApdi2;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789703937;
	b=ok4ZkKZTOl0OJTNofDMbUprT7XJYd70RcqalV/BT8Pp7sg+5tLj+R7F3J5hAG6NDZ5UKHZ
	WA3IpI4jhzAsGawmpawBjzmOYmtSjcQR7LWUAbpSqGzJ7ZhT32DyPt3E/JMhVKf5ifZrlc
	ceV1JPPNAtq4gD9Jwto1Y1km+zNv9Fo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mPyApdi2;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789703936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bFNaStZZHo8Umn9+ZoNiZRjr6gBJxuMv0I9V0qtdSoU=;
	b=pqC34BSS71DT0/3sRy1lYZAF86N7NDLeBNVrJa1mTJlpwMjsBV3x2cZ7V2IBikEIZsnX21
	LgxvYLpmmkyT4vmRZi2MFEDo6rlzpvschqVFtV+otAIoLGfFlOjt4YkJBTRN2BCZ+FdYPN
	l8XCrVK4LzfBw8uwYUBDM2529Qb8tuo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789703934; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=bFNaStZZHo8Umn9+ZoNiZRjr6gBJxuMv0I9V0qtdSoU=;
	b=mPyApdi2SjXJQnrqpiSdkvBttqs4qiDuNNStR9g0lzu/B6TLzymRIl5PsMZO16gPP1h67PoFESDeHs2bFVZqeymTjroRZ3a9wCYL67lTXihyv4GZIgCjziBH2t7As+jRnNSE06Lu3PwDpjBqcA+5gd4o5qfgEodi95aMMXmfD/I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XB9taoW_1789703932;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XB9taoW_1789703932 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 11:58:52 +0800
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
Subject: [PATCH 06/12] mm: khugepaged: generalize collapse_file() for shmem mTHP support
Date: Fri, 18 Sep 2026 11:58:37 +0800
Message-ID: <14cfc6705c6afc487d1b39c2606d13c93bda07f1.1789701677.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
References: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 79D921A0006
X-Stat-Signature: 8b9kzpjassm3cuk89p9wcsx714t1k4y4
X-Rspam-User: 
X-HE-Tag: 1789703936-430188
X-HE-Meta: U2FsdGVkX185vC9vdz4PYdNcaMOG+DE3ABnH7fcgBM3QbGd2uo6j17V7oYwtTzQMN9ovO3/JN8w2NFMWNj9sidf75WwQDfnQjbiXkforQ8Wc1KKkqSW2tkqmiPP3VfE0Exji5i7a2uGLFAEobomEDHUJCTQL2jxbtigjEX4jt4gQG6O+KHq0BC5dfImZZaRxS/xZaYLvN4wXR2CiEH4v9XWdkTREOjUIwb81Gzf4ANYigG4Pms3ey5k99V7+rBiWM4pOwFCYrNAVdcr66s0wMFZf6jssKaGj/QpAHAzgSWFfx4s5VHXQcnOyoJo7PaB7Gj0GE7G6OSfozBiJ8UMEr3gcKkXlrVz1MgSGwZjJAtiztgbtfYAQDRqtWtGGn+p5Cb6UvK4R6qYOZza6G//yOZ/IDb9DC69q+6wUzEYc07MuAg+m2DL11egecQrKIuviYVL5gkd7sQSmMY2ZwRxbQULYf/YeJ1iSIe/PXIlWEkdHldkYmdl5wvk4xOEDKFHdFNVBXN9esO4m1SqRBqYnfkfcUwSrHURXe/wphSNrHjYhAR/vcw/uYkdBSFDJW75d1ElnzZCLRBE4XE8lh+8bPQyHmwRVf3BdV2Njp+kfFzAZ2MBrEnyK1EuBS6r+P5CkhXZGYBSshONzVSgRDzFBH6uCZdiWJj9UU04ajm+gcuUGTK0bEvQs1wAUXoiphHroMeGuwMQd45k19xmxtIX1moZISCBbbHTIQksNEXHnjToZ0BAAfrJ4Zy3+3JfVJJjfcY4JfyuLgExRA3yMK2BoclfGze9EcsgnH8zcrUyx8e7WNuQLQFsaylavkn8M3sggt1mFsdy2kwRE/N3bKhpgCnpenTygEDJ5sAkrDOMUBI1qjl63t0UgssmM1cOuX5HbVsej5uMLO7eAJ5/nzqYD0Lw4B5MLOv6L9jA6zdEKOoDvK0Sur7fpVTsV3JDv7g1oeLHFloSuW0oV9PkdWal
 tIfSovOJ
 t99HPmylodAGs+HSY2lg/6Mtt193+0WA6/pTwdRqbYp9ycSookt4w0BtpuUfqIDw1pguEbgME72CTTSakkaNRIUan0z+6eDA3XYk56tIHG86gMOv6PfLFNmdMnHileNrMpAYFwBg1KglQ2F1uu9BnXgj75jHT5+5afBxSNGP5pVc174aIVtgFktSSVP+/5FvJGeC2MmudmMoND/GxaCqfbrFPc7gzMTrXj859ibLVlKZQ1q99VMXnKlXSc+CFotKJXHWRI1qYes/tyalw6TA2Aqbx5PGg6hFJBT4EPvVp7bWv5io=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Generalize the order of the collapse_file() function to support future
shmem mTHP collapse.

No functional changes in this patch.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/khugepaged.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f741dec3acc2..a987d233ec47 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2138,6 +2138,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
  * @file: file that collapse on
  * @start: collapse start address
  * @cc: collapse context and scratchpad
+ * @order: folio order being collapsed to
  *
  * Basic scheme is simple, details are more complex:
  *  - allocate and lock a new huge page;
@@ -2156,16 +2157,18 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
  *    + unlock and free huge page;
  */
 static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
-		struct file *file, pgoff_t start, struct collapse_control *cc)
+		struct file *file, pgoff_t start, struct collapse_control *cc,
+		int order)
 {
-	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
+	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
 	struct address_space *mapping = file->f_mapping;
+	const unsigned long nr_pages = 1UL << order;
 	struct page *dst;
 	struct folio *folio, *tmp, *new_folio;
 	unsigned long new_pfn = -1;
-	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
+	pgoff_t index = 0, end = start + nr_pages;
 	LIST_HEAD(pagelist);
-	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
+	XA_STATE_ORDER(xas, &mapping->i_pages, start, order);
 	enum scan_result result = SCAN_SUCCEED;
 	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
@@ -2174,9 +2177,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem.
 	 */
 	VM_WARN_ON_ONCE(!mapping_pmd_folio_support(mapping));
-	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
+	VM_WARN_ON_ONCE(start & (nr_pages - 1));
 
-	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
+	result = alloc_charge_folio(&new_folio, mm, cc, order);
 	if (result != SCAN_SUCCEED)
 		goto out;
 	new_pfn = folio_pfn(new_folio);
@@ -2514,12 +2517,12 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	}
 
 	if (is_shmem) {
-		lruvec_stat_mod_folio(new_folio, NR_SHMEM, HPAGE_PMD_NR);
+		lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_pages);
 		lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
 	} else {
 		lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
 	}
-	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, HPAGE_PMD_NR);
+	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_pages);
 
 	/*
 	 * Mark new_folio as uptodate before inserting it into the
@@ -2527,14 +2530,14 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	 * unwritten page.
 	 */
 	folio_mark_uptodate(new_folio);
-	folio_ref_add(new_folio, HPAGE_PMD_NR - 1);
+	folio_ref_add(new_folio, nr_pages - 1);
 
 	if (is_shmem)
 		folio_mark_dirty(new_folio);
 	folio_add_lru(new_folio);
 
 	/* Join all the small entries into a single multi-index entry. */
-	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
+	xas_set_order(&xas, start, order);
 	xas_store(&xas, new_folio);
 	WARN_ON_ONCE(xas_error(&xas));
 	xas_unlock_irq(&xas);
@@ -2589,7 +2592,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	trace_mm_khugepaged_collapse_file(mm, new_pfn, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
+	trace_mm_khugepaged_collapse_file(mm, new_pfn, index, addr, is_shmem, file, nr_pages, result);
 	return result;
 }
 
@@ -2796,7 +2799,7 @@ enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
 	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
 		goto retract;
 retry:
-	result = collapse_file(mm, addr, file, pgoff, cc);
+	result = collapse_file(mm, addr, file, pgoff, cc, HPAGE_PMD_ORDER);
 
 	/* Dirty pages are worth a writeback and one more try, if asked for */
 	if (cc->policy.writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
-- 
2.47.3


