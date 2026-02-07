Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49170EE6B7F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 08:12:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADF136B0005; Sat,  7 Feb 2026 03:12:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A93066B0088; Sat,  7 Feb 2026 03:12:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B28E6B0093; Sat,  7 Feb 2026 03:12:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B5816B0005
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 03:12:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3BFA1140428
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:12:38 +0000 (UTC)
X-FDA: 84416943996.09.CC887E5
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8ACB72000A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:12:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Sw/cu3p7";
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770451956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aSufcolqrQVMe5y8EVPFg87ZCQCerJ/wUIqeIeJwkF0=;
	b=Oh9F0sCh6L1G3amceUfPCzX+bM8YXl+nQkuPmTonwpe6HR5RKZZSeUae8lGg19YiaPjfWW
	nd2yHuSo5JTpOn/6ELXIoOwisqTFuxjmrc8zqvcXSP/jiqpf5mqOsmr0av/d8x9sHNjIMQ
	csFWVrfllh8WypRXz7FPWaIZ+1ip7xQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Sw/cu3p7";
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770451956; a=rsa-sha256;
	cv=none;
	b=Gzo9sXD4mnpKYZJzjWyfyDio1YuiagvKivOTxtBqffPyA94NuLatuQqQANmOjo2U5iP/p8
	uEwNDYojg4XBj3dbmH6iXJvPW1Bh1+YV1PYps+YtPlWGe4YF0A80gylBQavObCt8/QzzAu
	F26HVq3OnSo5GJa52UBSESZTfQKd6S4=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a95de4b5cbso8417605ad.1
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 00:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770451955; x=1771056755; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aSufcolqrQVMe5y8EVPFg87ZCQCerJ/wUIqeIeJwkF0=;
        b=Sw/cu3p7KN07ApIeLs6OcHm3l5rw1aF6HJD+7vUKOrynOkoDhBWrxFIbX6zs4Kh27X
         OzKOzkw0w+tPK42PDrt357qN+ZpliT9iW+CkHHgtoBfs4cAUn85bHH654/qcY1ciWaO5
         g6htNpXlzQ98vmJfh2yVZ9Kg1H1tNaw7RaaDQOWEdyr1FUUyTsPlOQPlNGN+1kDRvFT6
         zD9RNvMN6JahpmlBZGEvg+Cy2AVlaK7HQnbSkVghKBxFZvYk6UOwcTxDBtCdnHEE0vIg
         F8xxdih272I+Qr6kzAlAfA0tLWFm0+ANEtdUikbqj+LvQwEO58Fhd/Lg0EbOi7KzXaxc
         UKJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770451955; x=1771056755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aSufcolqrQVMe5y8EVPFg87ZCQCerJ/wUIqeIeJwkF0=;
        b=SWxvyUHNspJemwQm+oiHn6RuixVQq6LS+ZxWCgGPrs2zU0qMgUYYXxNcvII6MDJ/Vs
         E6sLe30Q82zQbPpWkPOHkuAAYwSqZE7QD/ZrjmMvPuaB0BXSGeQFeJuwj1WtBeP1j8Zk
         NDuIHKTqFO6MCa1WSlPK6WLi30Cj6eCHYF6Jl6FQ9i8MIbw4Fig94Lvu3YdrRM9UZhf6
         HgvLzSOeWz/jQbRMuacUViiXcgPUVyNs1W/jYQz4krmCQMthNezw9/UZ6sHI0CDbc7cW
         zHrQI808ChAHbZ16Zu+m15oUI/VKM0P5h1sHogt2ve02vjE0ZVmNrFI8EpqamBbzNuak
         aiEw==
X-Forwarded-Encrypted: i=1; AJvYcCVX9iXwXI25Fi+CBr5OxosBqMWYV5wKBfjUdRlr4zdUL0Kp0xUu4ZHu0LUZNttyoVOca0pi1zZRqw==@kvack.org
X-Gm-Message-State: AOJu0Ywks6PSV/djcSN84fuguCSMwDcCDuU99hSp3QZbIPQYhnSXWcEn
	vvXZQHodAfHcezBOmukRs+hVmUDdRGmfE1xhdujxJodUL5859zgC99ha/J5JpdGG
X-Gm-Gg: AZuq6aKoZWKl1oYByquxbijxyeTrpxsnbOH9WByb1NZLwBRSTP6onYRx/ahJNiU8wwG
	qkEsVK3wbqvd3ewhu8awa0lHC/hTYfOFYRvybDHTRpMbJ1txTIIVYmOcgT974UuQCG0ivZMm9xd
	/gWz3hs9lLTccBDTRbg5lrd91IkPp0i58r78cJkNowSkxPNZHw7EevI6k2/bc6BpYUWwkvjMi2l
	1r4x4uZcFi/P3dWM3s7uFt44a1nvP8bjqleVB3qdU2Rzvv/vKjp14uWMhhWtjDL0FwqKPYnZx32
	onH9QIC0VSkiD4jE3EM65z9yNKDm9yRNmOfTF1rIlkMzfJJy0K/xNF5/c8fi8GyqdLjJmpNQyZT
	9cAtB4+n1PcGv7mUWeVsV2rZpza2s1O8EItHkGyFbtKffvEkgDtyprI6hZlcAfEcZUWmnDAAwKo
	qo5jbu8AaWJj3zSOGCagoy2kU=
X-Received: by 2002:a17:902:e745:b0:2aa:d333:ce86 with SMTP id d9443c01a7336-2aad333d511mr2207295ad.6.1770451955248;
        Sat, 07 Feb 2026 00:12:35 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824490442cfsm3951466b3a.16.2026.02.07.00.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Feb 2026 00:12:34 -0800 (PST)
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
Subject: [PATCH mm-new v7 2/5] mm: khugepaged: refine scan progress number
Date: Sat,  7 Feb 2026 16:11:41 +0800
Message-ID: <20260207081144.588545-3-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260207081144.588545-1-vernon2gm@gmail.com>
References: <20260207081144.588545-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8ACB72000A
X-Rspamd-Server: rspam07
X-Stat-Signature: ag7wachys94acbe9wyjiah9an9mezyx7
X-HE-Tag: 1770451956-459815
X-HE-Meta: U2FsdGVkX18g+lVLDjEqDRe8m9SRQKgefESuc+Ew5qohnM83G3MedWlzF8p+L27+h3xs1PVqk+24JjiMhKy/DdiR3cMtId/vkR3uxf6djDJibSCecRtHQXYPfxCE80xKePiu30X9EDbF5pFfQn2VsPPOsFVssnjuhsMp5wwP3aHmsMMc+yxAoyUcr5jwYAJyIU0/JS4amgqB3ZQQvLCJ8715YEv4QWcg+AdsqHt4wdJXE2ZMK5jROV70Crzb7rsw0kdqO/mxLBum5Lu2KE+Z+qmjHQCgYwTPVI6oTZ+4p34KFX0Vi3dJtWvO2ZpS7qxpT+L81Wbh8gsDq9SUnKRKwyD2z5uTSAio66dxrBtZN4b0Z7F3fbMokQehHkUwiPUE5fp3prbaa0OyU+xTws+HVwiBFEJ9mnA4xdvzJPItO8r2l39uLV5OkT1XmORGo3JpEMwsORwygOMa7aYKZE3Ako+UDevj924mV/1TIHJ3oy7tctHDJFi4k6znICabwxMHYsYbhjP58AtMh3eviT9IB7ZySIV5dnx3Mh1Y0eQO/AotRQJsXcA7Mp7TDGOrA3rB7BgvzB0fx7AgFuDgGN04GGFChbj13EzvhKEugYXTIpOT6QqwNwOxLfylDsQ9+bFrp7bEDlh5CVMPhmwjFks2v5aY4+4NXZwHiSUvMpMCC4IBZxwZes92VTQm9isIMCW9HdW0s1CBKsoM2iwscIradoj5HIEmsnMlOKbR8+hbSjwBxPbzq1hlOdRfMEv4RvGXMaDsOP8akAPlUHmFMx7cS1u6lt4NMdkatCTjQ2hEXd1LM7ZUlnM5zR8e2K7viskhAYatqH6rdl7NstMoq41/DdK7caAlTKVqGm+9fy2ssttrPWgSXA+v4xOlM5Lfw/mI5N+ULLoFRLQ8dFncOXt3sw8Z2RSb4/G5O2fjsnFNXq4xtVsWNVwHxY4B8ysa4XKq4Appxsf23W0wu9lUpSc
 45R93oEM
 C7+Z5yzKJ4u3jD+maL3mlu8X44ZiwMe3U7tYYMoYCnlxQW+aYw17JpawZigGcFSYqO2wnZU0YLMZHmKoN8Xj8UVsB9gwCvwvjz0/CNsm0lYYKO2cVc7vMqJbr6VHrFEWR8WK58z3GFYbiWbQ+fiT4xbkHWw8xSM1LaHzrBmVUhpf9LDc=
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
 mm/khugepaged.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4049234e1c8b..8b68ae3bc2c5 100644
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
@@ -1256,19 +1260,27 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
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
 
 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
+		if (cur_progress)
+			*cur_progress += 1;
+
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
 			++none_or_zero;
@@ -2288,8 +2300,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
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
@@ -2378,6 +2391,8 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
 			cond_resched_rcu();
 		}
 	}
+	if (cur_progress)
+		*cur_progress = HPAGE_PMD_NR;
 	rcu_read_unlock();
 
 	if (result == SCAN_SUCCEED) {
@@ -2457,6 +2472,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 
 		while (khugepaged_scan.address < hend) {
 			bool mmap_locked = true;
+			unsigned int cur_progress = 0;
 
 			cond_resched();
 			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
@@ -2473,7 +2489,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				mmap_read_unlock(mm);
 				mmap_locked = false;
 				*result = hpage_collapse_scan_file(mm,
-					khugepaged_scan.address, file, pgoff, cc);
+					khugepaged_scan.address, file, pgoff,
+					&cur_progress, cc);
 				fput(file);
 				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
 					mmap_read_lock(mm);
@@ -2487,7 +2504,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				}
 			} else {
 				*result = hpage_collapse_scan_pmd(mm, vma,
-					khugepaged_scan.address, &mmap_locked, cc);
+					khugepaged_scan.address, &mmap_locked,
+					&cur_progress, cc);
 			}
 
 			if (*result == SCAN_SUCCEED)
@@ -2495,7 +2513,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			progress += HPAGE_PMD_NR;
+			progress += cur_progress;
 			if (!mmap_locked)
 				/*
 				 * We released mmap_lock so break loop.  Note
@@ -2818,7 +2836,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_locked = false;
 			*lock_dropped = true;
 			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
-							  cc);
+							  NULL, cc);
 
 			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
 			    mapping_can_writeback(file->f_mapping)) {
@@ -2833,7 +2851,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
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


