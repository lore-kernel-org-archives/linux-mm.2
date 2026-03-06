Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B439BF5140A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 06:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99EE56B0089; Fri,  6 Mar 2026 01:44:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 931016B008A; Fri,  6 Mar 2026 01:44:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8339E6B008C; Fri,  6 Mar 2026 01:44:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6A22F6B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:44:09 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C8C9813AADF
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:44:08 +0000 (UTC)
X-FDA: 84514698576.24.521BA18
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf15.hostedemail.com (Postfix) with ESMTP id 72065A0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:44:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OQ2ZLqga;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772779447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8kKRK+KpINJy/hP8loLkF6pCSehJDKosql8DLGWhzAI=;
	b=ViyA9/U3czpOw/bsNF4Rs/hKd5vw81rfsdJHHH2Wm4tR/eUyl3b+RXaQ7ooMueA2LVtIlB
	SMDenbwWcpRkaQFtdLW3cJb1AQ0ftd6cgvnogjw3ixIuVm8htEagh0lajr9UfD1rLyA++3
	RI0NPRuf+de8ZAqky4RftRXP3Nz8yfE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OQ2ZLqga;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772779447; a=rsa-sha256;
	cv=none;
	b=OVPg7iW2z0CzMX6WYpBq6QgWh3rvB9es63w1OU0yAtPR7nPifW22ktxaHiX79JRhRcv6gZ
	9D5atKa9uBYNNdWFKIlGxWfVg+/cT1eGMS6LtixdChD39hae3M3A/tOaFHD3uije2hj+Rb
	Pyu02h8apH67RMz5pC34RlqJcOmfz78=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772779443; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=8kKRK+KpINJy/hP8loLkF6pCSehJDKosql8DLGWhzAI=;
	b=OQ2ZLqgaRo245nGM0sWABYeGVod200qWhXaKmHstUQ5GZQyDlKzw1jJJcV7n3g9BdLf0yT1yiZRxYoUjjHf9aMYNXKxDhaX/NEmXLjj3JnixD+NcWM8vWF81ve4ijQV8pnhOHB0x6G7MLrugefOvZM2zAtK7O2YwJVAfox3royk=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-MKhDB_1772779440 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Mar 2026 14:44:00 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/6] mm: rename ptep/pmdp_clear_young_notify() to ptep/pmdp_test_and_clear_young_notify()
Date: Fri,  6 Mar 2026 14:43:38 +0800
Message-ID: <b3454077ce88745e6f88386b1763721746884565.1772778858.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
References: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pwu13kcsnhtri9jzy7fx7c6rwr7raiyk
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 72065A0005
X-HE-Tag: 1772779446-260195
X-HE-Meta: U2FsdGVkX18tEG5qVPKngaoRboxiGaM1rxc6Jpo4zqtautuqQS+1qRJ2x2Q+CHpfF7wprUvji7KsgA5McHCX5vNGpUt/7GQ/Y4XqQT4dm4StaaxbM+IHlb6log2xMqn94g4u8uvmps7ALD0BMEfniktpXmz17x7ZVnRL4CHEU1j2cmOH6IOIM18mRVkhaDytj1rXKzrImO21h/6JcZROTrkFgqfVD+b4AF8GCdECcabQBcuxxw2kiGjmX+obxhGH0cud1Cc2eSYSe9vkIOY7pJCjbto2OBtcG1I1uooPiFoKmgmroWkHL2FXbn0hy9x1lCN4UwCcKP3l5EMhetoLM2gcn9V0nufm4DOQFBtYMR1wa5em+PVm0z11kdj0TCgY7SdxlQKQc+nK1u67E69/fdsc1cO3vhaUYdkVHlhEWjKTEnppjqrLw+U8mbdfaogEq3PdYnaQ476cufQmoAkPnekEv3I0yM9I8e4qfYj6uIFAIyu6rc/fqkSBOOrCEH1ouDeL2IuqpOb5o+opa3790NqJL5Iq715mJBMPcyqBqHbzRWPlNxPNxV/1EWu51XOJ1r94//WHDwo5IK/z3E8Bwlauv2wdliqj/VBBM+jIxfVXgSfFGDSMOo7yYjNXhFrEoYVDFcH4Ic7H4ahymCY06yVkt/zbtNPtJhOTCJtbmeN1rWztt0y9Xa9Ih1Rz6eCWlLFYS6WX7ZnhgLf+c7v8p6UgPM7Rij/dwJPUKmHArGu3/D9tG9OG9OmxqCP4j+wr+83cw0cEhKajEpwnC/Ln5zE7bd0GrWoeSFqFYI9OKKJeHuV+41sHj2tbkAGJ4VnFt98nxa5VjHp60tp3hWUmn0Ez2C7mVdOo8YcM4broSEz04VQYR8xhv5TIdxUqqM9fNceh23Q7AEQjRteQJoN/FtuVomUjrasG4LGllkuuiAE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename ptep/pmdp_clear_young_notify() to ptep/pmdp_test_and_clear_young_notify()
to make the function names consistent.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/internal.h | 8 ++++----
 mm/vmscan.c   | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 05eb0303f277..f45f97df0d28 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1819,7 +1819,7 @@ static inline int pmdp_clear_flush_young_notify(struct vm_area_struct *vma,
 	return young;
 }
 
-static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
+static inline int ptep_test_and_clear_young_notify(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep)
 {
 	int young;
@@ -1829,7 +1829,7 @@ static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
 	return young;
 }
 
-static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
+static inline int pmdp_test_and_clear_young_notify(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
 	int young;
@@ -1843,8 +1843,8 @@ static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
 
 #define clear_flush_young_ptes_notify	clear_flush_young_ptes
 #define pmdp_clear_flush_young_notify	pmdp_clear_flush_young
-#define ptep_clear_young_notify	ptep_test_and_clear_young
-#define pmdp_clear_young_notify	pmdp_test_and_clear_young
+#define ptep_test_and_clear_young_notify	ptep_test_and_clear_young
+#define pmdp_test_and_clear_young_notify	pmdp_test_and_clear_young
 
 #endif /* CONFIG_MMU_NOTIFIER */
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 52adb37d1b01..e3425b4db755 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3504,7 +3504,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		if (!folio)
 			continue;
 
-		if (!ptep_clear_young_notify(args->vma, addr, pte + i))
+		if (!ptep_test_and_clear_young_notify(args->vma, addr, pte + i))
 			continue;
 
 		if (last != folio) {
@@ -3595,7 +3595,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		if (!folio)
 			goto next;
 
-		if (!pmdp_clear_young_notify(vma, addr, pmd + i))
+		if (!pmdp_test_and_clear_young_notify(vma, addr, pmd + i))
 			goto next;
 
 		if (last != folio) {
@@ -4185,7 +4185,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
 
-	if (!ptep_clear_young_notify(vma, addr, pte))
+	if (!ptep_test_and_clear_young_notify(vma, addr, pte))
 		return false;
 
 	if (spin_is_contended(pvmw->ptl))
@@ -4237,7 +4237,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 		if (!folio)
 			continue;
 
-		if (!ptep_clear_young_notify(vma, addr, pte + i))
+		if (!ptep_test_and_clear_young_notify(vma, addr, pte + i))
 			continue;
 
 		if (last != folio) {
-- 
2.47.3


