Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E175EE7C71B
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 12:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51AF66B008A; Sun,  1 Feb 2026 07:26:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C58C6B008C; Sun,  1 Feb 2026 07:26:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B4406B0092; Sun,  1 Feb 2026 07:26:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2971A6B008A
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 07:26:51 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9133140974
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 12:26:50 +0000 (UTC)
X-FDA: 84395811780.22.9B3A754
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id D461640007
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 12:26:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hgXiz2Lj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769948808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=te4Qk5Zt2UCvHwxxzNavYvXAnoEwtEAAn0AB0X/qh6c=;
	b=z9uUd5rpWpfv4RhHdGnkG9lb5YBRmYW2prmF+ABvCLPwup4HjuitxK2sCRNT5HJIzKMkaI
	z3ghZihqgI3kIYS88Huan7sXk2scYlSa62sU322IkKCxlnMES6591KZ+NvQdgcqJ6BpbJ5
	sWPC7j2WHHIENOQMhJE8dPtqzByl+7Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769948808; a=rsa-sha256;
	cv=none;
	b=nsBGf+MmLQaY+pyHKrMHMo9/H9m7ssOd4lS42BJlkbTgK4tr2WTVTpQtObn9bDixmBBeNm
	mGXzc+crNgem9tu9y+4Ho74C/OcK8fpxwA2cp/vzwerztfeA8XE8P4Z9yeftJigN0MTLBJ
	3IxGkmKxk24T8oGWj4Kv1mGnOFGCi7M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hgXiz2Lj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c63555db09fso1217319a12.1
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 04:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769948808; x=1770553608; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=te4Qk5Zt2UCvHwxxzNavYvXAnoEwtEAAn0AB0X/qh6c=;
        b=hgXiz2LjbSFM4u+FrV7FPv4yVJ85HtLK9WLJiCa++Ulv4EKPacda4+GnmrFdSYs330
         CBbxMkbQ/yENZ/JcEDs6sYSrgkSjp+Xn7wycV8pAaF5PGCBtv1Y9g3pPkER40cJwpXwb
         WakSMyZGneG+lnOsrtHq3BnAegRKD08b7BXmThJ0iu+9cwJsuJejsY6725i54DMicHCp
         wQ+OhQ13Wml6fk+XjUVkdT0+fDdOK4NVYEXXG5nUSN3IGcx+RHXmBeFF98FycWt4BV/4
         gpb/DaTHMJ8DUYvmEmlN6KEVSiGprhcZcyZQAgSFhrJxRh/79mQulpC76/VRZsh6E2/K
         PMSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769948808; x=1770553608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=te4Qk5Zt2UCvHwxxzNavYvXAnoEwtEAAn0AB0X/qh6c=;
        b=WCQrNS3FTKDQyqt03no2hKd4G43bc+sOlmyGtc3ClF+3VaFWhEMcgQyreRSkixUdoG
         fJ3w8haUtzRAWGvuTHdR+A6TmfPuOLWxwSqQpHQlBvzSichbGJBDZoV7RctGnZ1Ojzie
         /HI5z9XbuDkL+nOTdC6BG3JzqCNPKlWLnReNtxg2YUiceSbnv/a9lQML1RCt5P8jN6IQ
         /fgCnfS/yhh57/OglM1CZGmW1zgy41Dhq1LRnWwyiJbbAQQeoilMwmenJnITwPKpPYni
         FP11ath5+tpC43P8AE4wK4NxbsRlQqVI9/+j78BH1TEvLuOJFwCwIGl3rcHGbiqYychk
         h9Xg==
X-Forwarded-Encrypted: i=1; AJvYcCV8ZygsconBhiMCI5VcGMZ1dDSSWvKNFKmdnWlMpzZctzFeOJF8SgJ/v7ZvyNPKSFfGaEZrw2+qBg==@kvack.org
X-Gm-Message-State: AOJu0YwaENB9Plu2u+Ks+t/ugdmGTmMp6+sRM7uhFXgU9sE0xo2mzBSk
	QvUIHlTKxtbe44fDyUqStrbY+bbBpkSnjs3Qanj227Zwr6eLlYdMkWrA
X-Gm-Gg: AZuq6aLzuKSVk6dLIdB6fVtDWeEi7qT6Y3LFkkgzTWIEk26IAakaCXj112uAYpFqOzd
	jmzsb2CtZ8XmOG7WWUajzquyKCyF/gu+n5bOQrfWusU60FoKVkvVk6S0xAyoKOTYK4fC87gILaS
	+/X/aSDsI1E/EeXkGsC5zuIhd2mDDuG54s2TBerzWnHviAp6eR047WXtgu2rUXtr7YC8h5IClyJ
	WcJtiJU8d4NVIXzzvNxphHb41L3o7aY4RMIu5oD5BRKD2oQB4uX3o0PBuX3Wxnm3Bk5zdpkz8DY
	CNQzUgeqmp0BUrYTyZbUmB2dAnAqhtwAwTE69nLeD23++jVZ7FzP9aZVTLbbYXWwgp5iubrDPQy
	9OrXfRE8Y5DuoXwXyM2y846kC9TgbPkqF++zOYR76NnuQvtTGnmSQgcA8DuWeqour5P3sTu69OP
	odOpnxO9A4qCY4FnGfeHvUY3so
X-Received: by 2002:a17:903:fa3:b0:2a7:a9b8:eb9f with SMTP id d9443c01a7336-2a8d9d7a101mr91618605ad.30.1769948807602;
        Sun, 01 Feb 2026 04:26:47 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b6e5ac4sm116941185ad.86.2026.02.01.04.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 04:26:47 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH mm-new v6 2/5] mm: khugepaged: refine scan progress number
Date: Sun,  1 Feb 2026 20:25:51 +0800
Message-ID: <20260201122554.1470071-3-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260201122554.1470071-1-vernon2gm@gmail.com>
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D461640007
X-Stat-Signature: isq8cpf8p9zy54r8u7sh7hjwpou3okjc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769948808-958099
X-HE-Meta: U2FsdGVkX1/G2EGileSszUvDqoPVbbiTnoU4jSksUy6Acuwj5vkqM+ju2v2tfY66radp1LBfs6Z5rixr4YNBNN6iNmq/1/2R/DmW7aCU2s+Ap69n3W+hupg89sByr6MWOch3Y4B4TBS7MNhztB53QJBTUuCsV4a9936eKebtK2oZt9zqnI4VtC0Ipw/whCZJ3F+fqdL3Cn7eOnNUDhxzFE70yYHRGgrYtesKF9qB1SCWuB/zipawJASbKlv0DSpI5SyxLVzXG/paTKf0CNz09DEq6H+LT8cYOl7m6oTX0unQHQhhqHyGCkwgjc6lvqJkq5ltPOAWhkSHn639DcbyitxSevpKt8FL9lMJnw5a0Q//k2FotuEe1l3XdxlsBWca3QAGlsSLfpwxEXWAP6EtgyyotJCDVgAgA7n4Y46s8RCy5KOFhhYB2FLEjWt2h8IAM8MnSfQhBLZoZVDCrRBU5/s7qyJu0KSlAbF1V1pSVdPTVxOb/DZoP6MCb7is/NDK2HTTOrsUxiDIb6dYkQTY5q2TdMM8Cml0OrkrlElaBHt4V3sYXmTdnYSgKwpVdGmOZRR5pe4QUhB0NB/Ufhy9eCu+kgdbF6/Lot8xdf+hUv0Pqel4YfwsteFcqKow6Fl80b2mk5zA74gKx2MUXCopkpGjGYK3W0fSzmQDVJfv7W7AxLtzUH+elgXybrGuL/+SRQi3jZTFm23u3SB7R7q7rgTw9f0MYVwXBMjH+hM5hbamGBGIqYDHjdOqfUjo8MljwV0jjArcYgRq1n8YCkjx6YOzPAZJnqmii7hnpvpC3rbl/C/e7TrOmDbaSYtv3zERbYbZg5N57/rA6LqOdFfqGPHyxUjLnINIKy5FpG81s7kyCoRusWihUo66FFUMSf1mQ/AAM1+DtfaCXQTxonNHTRihNqAZaNjWeGFD1v4Trada0zb8KTn7lhn8i0V5ghLCbEjxm8Zs8RfuySABw81
 kdE+FkKV
 GVICT6Z18IvHDfMnTFwZmb1m/DpNKS4bSwctRQEazGW5sH951PAbXo/654OUlOUPbkCnw+ABJNT570jU70hGZDWJVfPoj8ISCOZPWVlmPnb3Xl6Ro/U+UsA0UGwGXeniQh5nVOehMlDQol0ldXKR5Qc0ZSHhDuzGQCSkSRGxnziPuIMNAcoJgXfWzOCt7ar9eNu91ccGMfpVCXWiwfZiUD6jyUPe7OS1TcL13WTn9GY3PB2YZ/SNJ/eHzpbW1g6Y1SxNY+Kuh+UAb1JCKu6wmUZCCoqwMkdHVfLeKz5iFc76Al74B91Zgol/7C8xHytvaEbsmmk7s52Pwvks2AvxkmfRTbe4R6mDqXpTDyqRGwaojg1n5pkbc3nk5kYx6l6VYUcCaCV9C5XpmFTrbHpkpvDalIS2FXJH/oWI5s2zb4Cnk79etcgNy6YjtVq/lVNsqkIRm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

Currently, each scan always increases "progress" by HPAGE_PMD_NR,
even if only scanning a single PTE/PMD entry.

- When only scanning a sigle PTE entry, let me provide a detailed
  example:

static int hpage_collapse_scan_pmd()
{
	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
	     _pte++, addr += PAGE_SIZE) {
		pte_t pteval = ptep_get(_pte);
		...
		if (pte_uffd_wp(pteval)) { <-- first scan hit
			result = SCAN_PTE_UFFD_WP;
			goto out_unmap;
		}
	}
}

During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
directly. In practice, only one PTE is scanned before termination.
Here, "progress += 1" reflects the actual number of PTEs scanned, but
previously "progress += HPAGE_PMD_NR" always.

- When the memory has been collapsed to PMD, let me provide a detailed
  example:

The following data is traced by bpftrace on a desktop system. After
the system has been left idle for 10 minutes upon booting, a lot of
SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
by khugepaged.

From trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file, the
following statuses were observed, with frequency mentioned next to them:

SCAN_SUCCEED          : 1
SCAN_EXCEED_SHARED_PTE: 2
SCAN_PMD_MAPPED       : 142
SCAN_NO_PTE_TABLE     : 178
total progress size   : 674 MB
Total time            : 419 seconds, include khugepaged_scan_sleep_millisecs

The khugepaged_scan list save all task that support collapse into hugepage,
as long as the task is not destroyed, khugepaged will not remove it from
the khugepaged_scan list. This exist a phenomenon where task has already
collapsed all memory regions into hugepage, but khugepaged continues to
scan it, which wastes CPU time and invalid, and due to
khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
scanning a large number of invalid task, so scanning really valid task
is later.

After applying this patch, when the memory is either SCAN_PMD_MAPPED or
SCAN_NO_PTE_TABLE, just skip it, as follow:

SCAN_EXCEED_SHARED_PTE: 2
SCAN_PMD_MAPPED       : 147
SCAN_NO_PTE_TABLE     : 173
total progress size   : 45 MB
Total time            : 20 seconds

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 mm/khugepaged.c | 41 +++++++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d94b34e10bdf..df22b2274d92 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -68,7 +68,10 @@ enum scan_result {
 static struct task_struct *khugepaged_thread __read_mostly;
 static DEFINE_MUTEX(khugepaged_mutex);
 
-/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
+/*
+ * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
+ * every 10 second.
+ */
 static unsigned int khugepaged_pages_to_scan __read_mostly;
 static unsigned int khugepaged_pages_collapsed;
 static unsigned int khugepaged_full_scans;
@@ -1240,7 +1243,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 }
 
 static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
+		struct vm_area_struct *vma, unsigned long start_addr,
+		bool *mmap_locked, unsigned int *cur_progress,
 		struct collapse_control *cc)
 {
 	pmd_t *pmd;
@@ -1256,13 +1260,18 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
 
 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
-	if (result != SCAN_SUCCEED)
+	if (result != SCAN_SUCCEED) {
+		if (cur_progress)
+			*cur_progress = 1;
 		goto out;
+	}
 
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
+		if (cur_progress)
+			*cur_progress = 1;
 		result = SCAN_NO_PTE_TABLE;
 		goto out;
 	}
@@ -1396,6 +1405,12 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 		result = SCAN_SUCCEED;
 	}
 out_unmap:
+	if (cur_progress) {
+		if (_pte >= pte + HPAGE_PMD_NR)
+			*cur_progress = HPAGE_PMD_NR;
+		else
+			*cur_progress = _pte - pte + 1;
+	}
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
 		result = collapse_huge_page(mm, start_addr, referenced,
@@ -2286,8 +2301,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
-static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
-		struct file *file, pgoff_t start, struct collapse_control *cc)
+static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
+		unsigned long addr, struct file *file, pgoff_t start,
+		unsigned int *cur_progress, struct collapse_control *cc)
 {
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
@@ -2376,6 +2392,8 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
 			cond_resched_rcu();
 		}
 	}
+	if (cur_progress)
+		*cur_progress = max(xas.xa_index - start, 1UL);
 	rcu_read_unlock();
 
 	if (result == SCAN_SUCCEED) {
@@ -2455,6 +2473,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 
 		while (khugepaged_scan.address < hend) {
 			bool mmap_locked = true;
+			unsigned int cur_progress = 0;
 
 			cond_resched();
 			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
@@ -2471,7 +2490,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				mmap_read_unlock(mm);
 				mmap_locked = false;
 				*result = hpage_collapse_scan_file(mm,
-					khugepaged_scan.address, file, pgoff, cc);
+					khugepaged_scan.address, file, pgoff,
+					&cur_progress, cc);
 				fput(file);
 				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
 					mmap_read_lock(mm);
@@ -2485,7 +2505,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				}
 			} else {
 				*result = hpage_collapse_scan_pmd(mm, vma,
-					khugepaged_scan.address, &mmap_locked, cc);
+					khugepaged_scan.address, &mmap_locked,
+					&cur_progress, cc);
 			}
 
 			if (*result == SCAN_SUCCEED)
@@ -2493,7 +2514,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			progress += HPAGE_PMD_NR;
+			progress += cur_progress;
 			if (!mmap_locked)
 				/*
 				 * We released mmap_lock so break loop.  Note
@@ -2816,7 +2837,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_locked = false;
 			*lock_dropped = true;
 			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
-							  cc);
+							  NULL, cc);
 
 			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
 			    mapping_can_writeback(file->f_mapping)) {
@@ -2831,7 +2852,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			fput(file);
 		} else {
 			result = hpage_collapse_scan_pmd(mm, vma, addr,
-							 &mmap_locked, cc);
+							 &mmap_locked, NULL, cc);
 		}
 		if (!mmap_locked)
 			*lock_dropped = true;
-- 
2.51.0


