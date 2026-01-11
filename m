Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24EDFD2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 12:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E6746B0092; Sun, 11 Jan 2026 07:19:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87CFF6B0093; Sun, 11 Jan 2026 07:19:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8D76B0095; Sun, 11 Jan 2026 07:19:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68E5C6B0092
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 07:19:50 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FB471405BF
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 12:19:50 +0000 (UTC)
X-FDA: 84319589340.01.885A68C
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id 495FA20008
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 12:19:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kewTNYHz;
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768133988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXcEVyCz2mdgQ9fw8ki3ifTfwIPNt8/MvwZFlR641cE=;
	b=ivra6Lm9MH96fzDxo2Lpzy/YIQ+gne7vgBaAxZ04M52TJ/tuxjR4AXhsJNZmCA6JBeetfs
	aN0o/ZJl2PDdmhkqtux48/NgzWc39NPPfHnRkYawaBAZ9gvHJA0FXlE6TkAtmtdLqfMEd4
	kr3waRNEW3P4Yes+RR5pgUUuRT7IRtU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768133988; a=rsa-sha256;
	cv=none;
	b=FTfh4HDCytC1Z7n63jNnQR3x0jexVfow6wo9lfsHtey0RFJX9GgISVwIZxELtzNldh/sA1
	IOpCxxBZLYEkbtAT9k0Cbalonnhx2VWM3QHgYqZr2f0juWK3RZoxLSzrKYP+rzRO0U7kTS
	UlrSmZCxhG9eS41SjaJnd48q1Lmb/10=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kewTNYHz;
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-34c71f462d2so4735336a91.0
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 04:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768133987; x=1768738787; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TXcEVyCz2mdgQ9fw8ki3ifTfwIPNt8/MvwZFlR641cE=;
        b=kewTNYHzTvWvAWK8y/CQp8xP2j2AAc116kRwRpBQGzZpOIU6Ogh3mU3aXv4pKjBybT
         ItqoLqwxmeRkyjLpJPVqLEP/dP/nUrVZH8AO4JxVYMV4YrtNYngKEooFGKNzi4Ho74ZF
         8t+qDe59tlhd//xi4SGaTuCPAeQYa8KZN04FvjmoB2k3c9y57OhhWrCFW3IGloh5yItq
         gbO34td01SYTOv/KD/BZQwVj+jckyr5TDTfrZTT5IQpKHERLUmlZzOKDIp/n0NZlmJ7K
         yOhHfH0Zu2vU+Y1BZm+OiRd029O3KOrh8ByRBs8pU7edKmDakPEDYu5IGLYWOBOHikd8
         bDXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768133987; x=1768738787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TXcEVyCz2mdgQ9fw8ki3ifTfwIPNt8/MvwZFlR641cE=;
        b=P0SK3uimyinP8X6wHND0NtPc/ff8gh9skRPucIj2HUG2ajmO6SNM6oKdoiDYzfrmep
         rakd3G5vdnbtEpIinBwziRPsFtrg4KJgMR5l7XpTqqIUPS+V+9dtdlkmjZJvlRcTCgiJ
         ed6VcmqcMd8VUc2BguVjqTPZoYzR39NRJMas92KSfMbyCw9V1uhP8heHAzft6k52JoG4
         Jv0NV3gQLS0h7LDV4Azjna6HZlEaL4jJy+dsAU99OvZZdMHy3IQELS6Bjwzb8UEQIO2a
         HRnchpbg86NLVIXw6ESAnhN4vDAqW7hW/EobODIhjzasPFboF8XpZNHcxdiUbVnV1YrH
         3BBg==
X-Forwarded-Encrypted: i=1; AJvYcCXYNrWRmV8hKOHEP8ifRatpIT6mJ36NSElW2V0HL3NxOutlahDu201wwCL7G/2DZePWUzAOMvRKhQ==@kvack.org
X-Gm-Message-State: AOJu0Yzc7Z+7QOAmvskrzWB6Ld93IBNIXE3YVYKCh6W7xOMyr325BPl4
	rrGQq88BLSU509Ucwj2gEJgUcBNadWIIjnr31eMBVgNm3xadLLge8pZk
X-Gm-Gg: AY/fxX7ldX5P0PSWPCN8qoW22B/kD91Pps9fhX1ElKKiVCBfkwHIOoRGhibjhkkdSMI
	+E12U5SrDRIi+vpDP8ea5Mi7mvMT2emutiRCmWKx2rAymi7s4C88HMjOSGLoNGydbpFfi31BtJy
	NC9xbziSTlhUycZQz1S/rSqcdpal7SfvumlaBxMFEPazBlGRNG86dM8IPTUSxsGwnG8pvFc6JDd
	BY1u4d7JIU8zL1u19B+Cc+2+E7e34a2pg4MVFn2uq+NGakPMpwBBPHKntyLq0sak3vUvCjYeev7
	e3lfwpsrQCLjnpaR4IXYpoCuxVjT8MPbE0dbLCjICI/yB+9HnCdZwMKnCQUjyQRzS8j0TODffuF
	sCki3N90TJ3XmUmb0Z0+j5KWpdy4Y9sycxFy2eAIXU1Yo2fXtcE1n5NbrCoGaIq7iscxC0K2Kj8
	rriNzT37aFf7rcPeuyW4E2kCRyBglB1g==
X-Google-Smtp-Source: AGHT+IGPJhW2ZDBzHgiDmQNFPVyqEA2J/ZIwwfVz+XH/ksrWs4Qx3T634999igMQa6zqSxteeK/3Ug==
X-Received: by 2002:a17:90b:2711:b0:349:8184:af8b with SMTP id 98e67ed59e1d1-34f68c7a652mr15922912a91.7.1768133987030;
        Sun, 11 Jan 2026 04:19:47 -0800 (PST)
Received: from localhost.localdomain ([221.227.246.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f6b07029fsm4877954a91.2.2026.01.11.04.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 04:19:46 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
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
Subject: [PATCH mm-new v4 2/6] mm: khugepaged: refine scan progress number
Date: Sun, 11 Jan 2026 20:19:05 +0800
Message-ID: <20260111121909.8410-3-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111121909.8410-1-yanglincheng@kylinos.cn>
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 495FA20008
X-Rspam-User: 
X-Stat-Signature: gi3yak774ugu4btmdw6bufkxhxtdzxfe
X-HE-Tag: 1768133988-648748
X-HE-Meta: U2FsdGVkX1+ocnLGv+oJyKqSRNAh7s69t+J5TlL7wCMBr8+PSPHo9hH1Bns4MgkFM/bPiZ1T6B5HD6tDSOMWY0M0t4zYxotEcfdFebBnw8gUSvOgWH14nkxH8LMjBh7DJg236T9oJcAffiYA5/Qu1hHlpRULnue5Twms5d8V71P1WUjyO7vK+R3SXhiHQ8xwfedybEdPBo5pFjSShM8WiyCMsQlYcXqygmyeabOhTJxniZGJHfnzFa805xw6Kz2wJ+aXQA9210lewV97wz6Je+tFAGkZrsqJl6oQajmLn8Z/rmQmc27k5Gc4mraSHtGDrIybqOQkFSf4Bmk6Jarrkh5qCurqmTVA50JqUYMNP5xukv8A+F8A1hk2hvqQvdicBVvtzocU/ks6tDnfcTcil0IQaO1wzwIrQXsVgSti6S/BlTymD16hfjNNymIx2lZjX5JOxJRerJ4SSa61Kef9iOGe7vrn3ITyWVQ/bU1t5rpWd/7a189dlGI7T5TftnbpYpZUnTGWvT7r50kpYsKIi5cyliFpWerjVplhKoZWkaYZekr5aIoLk97vHi4J3QETcqVNZOqFDjafrFgn8hORavtqc31Hcn7Eh02itIOXwKtOV9Zg/GUWeFmQYrX1tfGuKjAin1IAt9n5a3A7MnrQwFebweGR1R4Gn9RW+wFdKTJ7a3FB35PIEMP4j8H+kSuDH4hd/dQtIaDPoSOJuX0pK4OvFO/zexh08vJOsJ9J1fMYsWJeJgKr4mNBnu1vFxmJajNOsocaD2Tl6sq9ohABKNQI47UeA2FYuUE/EJMq1QgGHgfIuuitjOOlYIwrY2lameQwKaPRc5Uo0YjYP4FjO9PlGFfDdHs//JaRfgtff3UlbEZK9S9LBjz1B5m1bGv13fyCyDSGJongg9ycym0AUx/NdfXzU1RPc5nFDkunDQ/5X3qp8fdjEgUvVqaHUYNYOPEvOSEXSCO2ili5bph
 e3//dy7O
 qv2+ek21jG/kqlE6WRi8XgBCrT81BJgsVynxn+BxLqk5pmCrdxLR3+dnzHBSWeGqTWtUFARxXmJGI0HID/zh7NxDnYr+g9fPYuld8qP/9uJbhASRoCivbs/ZubhXU1QKL92cExApc19YHUe39bFUsZ0cLmD+sg9XcA1ldyt3G+0dxy+VGE6TUlIuVyCkBhN8cScEq9Pe7mSSiYujo/7nrgWm0seSiNjbrTK3/qvk4hDImAT1Lw9yZ0eF/vJW8Uk/U+jPeQ7CH8bUPbcuBqiEdf8zPS6koG/csWmKCC5BIjGeZkEmBQDW7EJNC7PP+N/uzgWMEMS92KYJSQ6cR6+fb94xwiHrzLw/4FRrY7FEhDFsd5TrhGhWFyfksCH7uZakXzsEzClFsmVLN1eDtapCUMse1R896Z1MFpmxuir2RGrylvRjtc6HxRcuW/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, each scan always increases "progress" by HPAGE_PMD_NR,
even if only scanning a single pte.

This patch does not change the original semantics of "progress", it
simply uses the exact number of PTEs counted to replace HPAGE_PMD_NR.

Let me provide a detailed example:

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

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 mm/khugepaged.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2e570f83778c..5c6015ac7b5e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1249,6 +1249,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 						struct vm_area_struct *vma,
 						unsigned long start_addr, bool *mmap_locked,
+						int *cur_progress,
 						struct collapse_control *cc)
 {
 	pmd_t *pmd;
@@ -1264,19 +1265,27 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
 
 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
-	if (result != SCAN_SUCCEED)
+	if (result != SCAN_SUCCEED) {
+		if (cur_progress)
+			*cur_progress = HPAGE_PMD_NR;
 		goto out;
+	}
 
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
+		if (cur_progress)
+			*cur_progress = HPAGE_PMD_NR;
 		result = SCAN_NO_PTE_TABLE;
 		goto out;
 	}
 
 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
+		if (cur_progress)
+			*cur_progress += 1;
+
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
 			++none_or_zero;
@@ -2297,6 +2306,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 
 static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 						 struct file *file, pgoff_t start,
+						 int *cur_progress,
 						 struct collapse_control *cc)
 {
 	struct folio *folio = NULL;
@@ -2337,6 +2347,9 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
 			continue;
 		}
 
+		if (cur_progress)
+			*cur_progress += folio_nr_pages(folio);
+
 		if (folio_order(folio) == HPAGE_PMD_ORDER &&
 		    folio->index == start) {
 			/* Maybe PMD-mapped */
@@ -2466,6 +2479,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 
 		while (khugepaged_scan.address < hend) {
 			bool mmap_locked = true;
+			int cur_progress = 0;
 
 			cond_resched();
 			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
@@ -2482,7 +2496,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				mmap_read_unlock(mm);
 				mmap_locked = false;
 				*result = hpage_collapse_scan_file(mm,
-					khugepaged_scan.address, file, pgoff, cc);
+					khugepaged_scan.address, file, pgoff,
+					&cur_progress, cc);
 				fput(file);
 				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
 					mmap_read_lock(mm);
@@ -2496,7 +2511,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				}
 			} else {
 				*result = hpage_collapse_scan_pmd(mm, vma,
-					khugepaged_scan.address, &mmap_locked, cc);
+					khugepaged_scan.address, &mmap_locked,
+					&cur_progress, cc);
 			}
 
 			if (*result == SCAN_SUCCEED)
@@ -2504,7 +2520,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			progress += HPAGE_PMD_NR;
+			progress += cur_progress;
 			if (!mmap_locked)
 				/*
 				 * We released mmap_lock so break loop.  Note
@@ -2826,11 +2842,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_read_unlock(mm);
 			mmap_locked = false;
 			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
-							  cc);
+							  NULL, cc);
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


