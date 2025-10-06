Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAA02CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 14:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47D978E001A; Mon,  6 Oct 2025 10:46:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4550B8E0002; Mon,  6 Oct 2025 10:46:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343818E001A; Mon,  6 Oct 2025 10:46:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2083B8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 10:46:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 083F3140664
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:46:17 +0000 (UTC)
X-FDA: 83967964794.26.F706FE8
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id 17D35100011
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:46:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759761975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wuqcl+A9rzc72Ea/feTXtRnC4gt7duKqUHLzgITS2ys=;
	b=BBzAyLtLgjrEYB1ZnAIoQo4UFa/oJSP/7U8UPcGq1Kc0Isge9tDys4QLvj8SXW2NCvsLan
	DWQjAX1oiF6EjxA/RDtC8uBM6KlN28U6cPs6gCVagWnxTNXLWYyZuJ60gB/Vz6B4QxwWHQ
	EwksLTPNpIe5+xTtBqUY+07h5LLJAZs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759761975; a=rsa-sha256;
	cv=none;
	b=VkjG4bHsmhsseDElXU67PIetqIoM9sEpg6U+z/GOK3h8lRZr8Mn9XhM5+uEuoCIb+itd2x
	UTxVLEG7wkaKcTGuq4nTGYWJ82pMUhYBM+5lKPxtHepelu5Ek9fH3Lx7W1hAUulwJtPLhM
	i9liSmB0Q1rbkPi77uYfVTZW3/hTfbY=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-41174604d88so2726871f8f.2
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 07:46:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759761974; x=1760366774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wuqcl+A9rzc72Ea/feTXtRnC4gt7duKqUHLzgITS2ys=;
        b=g78y5G7j1awF2jVCMDaxR6SGrwYh+RY8Ok2250w0LOUyO16W/RZtvnkv7XE/oseJgb
         riP+qq93rjptS4xr+1YwnsIKerzpIK6Y5SglgJ/ePCwS3jObiikmDM03KkYAeflqUtI3
         Uyoff4F3aBkpid9w9gVLMDKfvN6d1GrHDuKZHSkizqtyc9VWoEKcAkaY5pOWswHPHyqZ
         1omracxXypNG8qAERc9MXL1heG8b2clxGOJCGUF/GZl6OPt3GgFNDORLwF6o1Q5at/5I
         /xU+I9/FQVk+WKU3tVDlM3/nuF3joJwrWCUc84fHXQrw07UKEGLJeijrznTOz0/k5sfk
         AlOA==
X-Forwarded-Encrypted: i=1; AJvYcCUryrXr5mRq+MTzcw2zNo8Le24CmqsJUbn6Nv//N8etSWYwWZwC4npiKNku2QeudUxxhd0oy+v72g==@kvack.org
X-Gm-Message-State: AOJu0YyP457mmJIerDku7rjf3RHvDBf2GTocsQ/k44tQckuVEc0BKVq+
	UFkqDsmYuLlRZ5+khnM3Ylvdt/MSprIIpeufTPVTQaUsVwq7N2ZiOUbE
X-Gm-Gg: ASbGnculYNqQi0lrwFQvN3LsprlIxDHDm7amwQGtIsb4/QfFRfnRvtBDtZIBAEPtDK/
	VXN9uAaQZcGZp5QeHY5JqXrTlxXVjU36cro+Qdpvw/SgrkmfsbSrUEECeuLcG59uYIolxgLkPCx
	hPTU0MUlT/ANY9K3iQsGHSJCdCm2clxhYsPDhC1NpliqN8Gz/s/Mlq0If3iGf36FpauKNl9ri1n
	LxAKUOcyKZL8lw2H1UNMybgAezyBzJOHqiUD1noNGlOYyviWB3SP4YpQeQ7nn/wUEOzlFNfjpJq
	1Xxlx26j4uRiR3rFjarwBlVBbmjNJIzGAnMDovjnaipEWdxNYhMudH/kNGTg/ZHrnxKKA3bAHnH
	a9Uq30fEGiSI/iAwHxq96F0d7o9RJf6Hcgv+yYTg=
X-Google-Smtp-Source: AGHT+IHFHcUdMzS1csXhoGyXZeti7+KMioYMHOfR7zhdo2kycZLG0GjGV8+xFl9piJYAU+8ueDHsMg==
X-Received: by 2002:a05:6000:2f83:b0:3da:e7d7:f1e0 with SMTP id ffacd0b85a97d-42567174959mr8714398f8f.27.1759761973329;
        Mon, 06 Oct 2025 07:46:13 -0700 (PDT)
Received: from localhost.localdomain ([2a09:0:1:2::301b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8ab8b0sm21242624f8f.18.2025.10.06.07.46.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Oct 2025 07:46:13 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	richard.weiyang@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH mm-new v2 3/3] mm/khugepaged: merge PTE scanning logic into a new helper
Date: Mon,  6 Oct 2025 22:43:38 +0800
Message-ID: <20251006144338.96519-4-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251006144338.96519-1-lance.yang@linux.dev>
References: <20251006144338.96519-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 17D35100011
X-Stat-Signature: dytup4kzeewx9mn8tx618h69wcf1t3oc
X-Rspam-User: 
X-HE-Tag: 1759761974-371341
X-HE-Meta: U2FsdGVkX1969oG0/eFOhvL30ovJ9MEAmNKhstG4SfJ3DgGOByp1rMIO8h5BkrgRDcswOXTidBnGZdsSedJyM9F88Wjuec1Q5vVZ1erWJMiBDhEg7KuyuJvFo+BmDdf6qXsWfXHksAXuJ9hHjKqeBcWw4JOI2gyWSRcn3Rx2fb9SRxtVLYcKe93DIqCTP7IkHLQmZdi/zIcWkoFMiAsNcdE6ljabJ0MyXZ4YOSJyZi9eoINOJiroLH4tVl4MDqeLjG3Z3Tl7h0Cip+zBz2YErOnOWtekBUjVMJG4u+Ta60NFqDHUo+VbCR+G2MujW4EKBSLImbrpZaNOc8iThqm2KkLnQMhwI28jlMuXdT9Kp/142RlHTVuoVxyqtyIVi9dnaEFyAS44Y1HOyZcBZ3hcOaii0Fj9y3rD0jucLIOwfh1P1S11IFgPPnkGeASLVtgI5cxJMUGG4ks4PbG7akoShdsU4F7ZPp5F05kpkFecDVeUAZXjlXWXL3sQM9Z8rQJ9I/VqW2ZS0zgO+2qKV1rh9LxiW/s7y1+Kml8nqaRdm6SVG4aiVHnLq9LUrBWh5NoYX4ulvydS7eMbQ5CWILoTw2qMKz5199QdAlv7lIebewo59nNzIc4RF7zwK4D0BQeM5ag1vcPXqEXUyh9y7+vaRaYKqgBrS2UbLUskyug+k5NFcbrsBvf4v+CaD7pli0l/UYHt8MnkdYsaD8wm91os5Y3hCTCIk13gXHL0UPorRv1rYhUnyHu08tL9JLCvsueHRRRZJ+Cy3bw4lK8hcU3UuDIxu8dwSMKDvK6c+Aoiob1L3ZdJkYhKm8xIUi9jLS2kxFxYdPve5tDbbLDvXqWt2yq/WoRQj79/6mQrazhLOCB8JEr1VdJuzQx/5uaUExMA6jJSa4otOpYJr7B2V9Ip7Qnu/vKrVEqD5IAZoHBBhU+wfu9YDG9AAdRdJi3Eacjah7vpkg9VlI/CdPuREE6
 B+ALsfSa
 Pc8bUEndtTqVSbh+xqgKeDl3FxKbtHITzY9++qYtH3tPmBjGyBBQZo2A8EZcJ1bfzYBI6VS06BkYIjfZUN43RPipZ1bUTs6GXFKfx9TdFQT+wBl56+4c/SahZeOYjUj+oznFR/er4mAagGEMiTjc+mJVXHuOebpzFsgoiQ08WYJS7RirTWk0d+2EV+8TkIwVn44OJs2iA1wOZO48K4pgmuOta5/Xcu5rGC60Yq78vq2N9bFyDPFra51Yew+0dC/Fha5QRBJCz2VXdrmhykFp8CJdpRBSKXD0pClkfG5qkCANUjk8Zvqn0CXlCWn2TOgQoabCIBIz7dzp4INhFHF++YnoRBLRklhOAgPbJgDLTR1Q3TeVX1KXH8hygO7YZKH8W56WtYMRalnwKUehaRj9keQfeW9qtDJj6XUxRiUKvPMwXgSqSNUp/4tP/fbShnQWT9DXu4mlUPj9Onq4vbTlPe9jS86VmpI5LARcrFnkaSKtT2vHC0k81DcfSLm5ngOU1TeRjYARSFyGdMX9DnJtSU5YvnjHOC5TiX+83ro/cKpuSHh44xRcKAhK8n4xcPeIBHSGYZnua8AwuWQ9FVqx4ud5kJJ+y2EFbu3Oj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
and __collapse_huge_page_isolate() was almost duplicated.

This patch cleans things up by moving all the common PTE checking logic
into a new shared helper, thp_collapse_check_pte().

Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/khugepaged.c | 244 ++++++++++++++++++++++++++----------------------
 1 file changed, 131 insertions(+), 113 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 87a8df90b3a6..96ea8d1b9fed 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -61,6 +61,12 @@ enum scan_result {
 	SCAN_PAGE_FILLED,
 };
 
+enum pte_check_result {
+	PTE_CHECK_SUCCEED,
+	PTE_CHECK_CONTINUE,
+	PTE_CHECK_FAIL,
+};
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/huge_memory.h>
 
@@ -533,62 +539,140 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 	}
 }
 
+/*
+ * thp_collapse_check_pte - Check if a PTE is suitable for THP collapse
+ * @pte:           The PTE to check
+ * @vma:           The VMA the PTE belongs to
+ * @addr:          The virtual address corresponding to this PTE
+ * @cc:            Collapse control settings
+ * @foliop:        On success, used to return a pointer to the folio
+ *                 Must be non-NULL
+ * @none_or_zero:  Counter for none/zero PTEs. Must be non-NULL
+ * @unmapped:      Counter for swap PTEs. Can be NULL if not scanning swaps
+ * @shared:        Counter for shared pages. Must be non-NULL
+ * @scan_result:   Used to return the failure reason (SCAN_*) on a
+ *                 PTE_CHECK_FAIL return. Must be non-NULL
+ *
+ * Returns:
+ *   PTE_CHECK_SUCCEED  - PTE is suitable, proceed with further checks
+ *   PTE_CHECK_CONTINUE - Skip this PTE and continue scanning
+ *   PTE_CHECK_FAIL     - Abort collapse scan
+ */
+static inline int thp_collapse_check_pte(pte_t pte, struct vm_area_struct *vma,
+		unsigned long addr, struct collapse_control *cc,
+		struct folio **foliop, int *none_or_zero, int *unmapped,
+		int *shared, int *scan_result)
+{
+	struct folio *folio = NULL;
+	struct page *page = NULL;
+
+	if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {
+		(*none_or_zero)++;
+		if (!userfaultfd_armed(vma) &&
+		    (!cc->is_khugepaged ||
+		     *none_or_zero <= khugepaged_max_ptes_none)) {
+			return PTE_CHECK_CONTINUE;
+		} else {
+			*scan_result = SCAN_EXCEED_NONE_PTE;
+			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+			return PTE_CHECK_FAIL;
+		}
+	} else if (!pte_present(pte)) {
+		if (!unmapped) {
+			*scan_result = SCAN_PTE_NON_PRESENT;
+			return PTE_CHECK_FAIL;
+		}
+
+		if (non_swap_entry(pte_to_swp_entry(pte))) {
+			*scan_result = SCAN_PTE_NON_PRESENT;
+			return PTE_CHECK_FAIL;
+		}
+
+		(*unmapped)++;
+		if (!cc->is_khugepaged ||
+		    *unmapped <= khugepaged_max_ptes_swap) {
+			/*
+			 * Always be strict with uffd-wp enabled swap
+			 * entries. Please see comment below for
+			 * pte_uffd_wp().
+			 */
+			if (pte_swp_uffd_wp(pte)) {
+				*scan_result = SCAN_PTE_UFFD_WP;
+				return PTE_CHECK_FAIL;
+			}
+			return PTE_CHECK_CONTINUE;
+		} else {
+			*scan_result = SCAN_EXCEED_SWAP_PTE;
+			count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
+			return PTE_CHECK_FAIL;
+		}
+	} else if (pte_uffd_wp(pte)) {
+		/*
+		 * Don't collapse the page if any of the small PTEs are
+		 * armed with uffd write protection. Here we can also mark
+		 * the new huge pmd as write protected if any of the small
+		 * ones is marked but that could bring unknown userfault
+		 * messages that falls outside of the registered range.
+		 * So, just be simple.
+		 */
+		*scan_result = SCAN_PTE_UFFD_WP;
+		return PTE_CHECK_FAIL;
+	}
+
+	page = vm_normal_page(vma, addr, pte);
+	if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
+		*scan_result = SCAN_PAGE_NULL;
+		return PTE_CHECK_FAIL;
+	}
+
+	folio = page_folio(page);
+	if (!folio_test_anon(folio)) {
+		VM_WARN_ON_FOLIO(true, folio);
+		*scan_result = SCAN_PAGE_ANON;
+		return PTE_CHECK_FAIL;
+	}
+
+	/*
+	 * We treat a single page as shared if any part of the THP
+	 * is shared.
+	 */
+	if (folio_maybe_mapped_shared(folio)) {
+		(*shared)++;
+		if (cc->is_khugepaged && *shared > khugepaged_max_ptes_shared) {
+			*scan_result = SCAN_EXCEED_SHARED_PTE;
+			count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+			return PTE_CHECK_FAIL;
+		}
+	}
+
+	*foliop = folio;
+
+	return PTE_CHECK_SUCCEED;
+}
+
 static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 					unsigned long start_addr,
 					pte_t *pte,
 					struct collapse_control *cc,
 					struct list_head *compound_pagelist)
 {
-	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr = start_addr;
 	pte_t *_pte;
 	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
+	int pte_check_res;
 
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
-			++none_or_zero;
-			if (!userfaultfd_armed(vma) &&
-			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
-				continue;
-			} else {
-				result = SCAN_EXCEED_NONE_PTE;
-				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-				goto out;
-			}
-		} else if (!pte_present(pteval)) {
-			result = SCAN_PTE_NON_PRESENT;
-			goto out;
-		} else if (pte_uffd_wp(pteval)) {
-			result = SCAN_PTE_UFFD_WP;
-			goto out;
-		}
-		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
-			result = SCAN_PAGE_NULL;
-			goto out;
-		}
 
-		folio = page_folio(page);
-		if (!folio_test_anon(folio)) {
-			VM_WARN_ON_FOLIO(true, folio);
-			result = SCAN_PAGE_ANON;
-			goto out;
-		}
+		pte_check_res = thp_collapse_check_pte(pteval, vma, addr, cc,
+					&folio, &none_or_zero, NULL, &shared, &result);
 
-		/* See hpage_collapse_scan_pmd(). */
-		if (folio_maybe_mapped_shared(folio)) {
-			++shared;
-			if (cc->is_khugepaged &&
-			    shared > khugepaged_max_ptes_shared) {
-				result = SCAN_EXCEED_SHARED_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
-				goto out;
-			}
-		}
+		if (pte_check_res == PTE_CHECK_CONTINUE)
+			continue;
+		else if (pte_check_res == PTE_CHECK_FAIL)
+			goto out;
 
 		if (folio_test_large(folio)) {
 			struct folio *f;
@@ -1259,11 +1343,11 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	pte_t *pte, *_pte;
 	int result = SCAN_FAIL, referenced = 0;
 	int none_or_zero = 0, shared = 0;
-	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
+	int pte_check_res;
 
 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
 
@@ -1282,81 +1366,15 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
-			++none_or_zero;
-			if (!userfaultfd_armed(vma) &&
-			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
-				continue;
-			} else {
-				result = SCAN_EXCEED_NONE_PTE;
-				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-				goto out_unmap;
-			}
-		} else if (!pte_present(pteval)) {
-			if (non_swap_entry(pte_to_swp_entry(pteval))) {
-				result = SCAN_PTE_NON_PRESENT;
-				goto out_unmap;
-			}
-
-			++unmapped;
-			if (!cc->is_khugepaged ||
-			    unmapped <= khugepaged_max_ptes_swap) {
-				/*
-				 * Always be strict with uffd-wp
-				 * enabled swap entries.  Please see
-				 * comment below for pte_uffd_wp().
-				 */
-				if (pte_swp_uffd_wp(pteval)) {
-					result = SCAN_PTE_UFFD_WP;
-					goto out_unmap;
-				}
-				continue;
-			} else {
-				result = SCAN_EXCEED_SWAP_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
-				goto out_unmap;
-			}
-		} else if (pte_uffd_wp(pteval)) {
-			/*
-			 * Don't collapse the page if any of the small
-			 * PTEs are armed with uffd write protection.
-			 * Here we can also mark the new huge pmd as
-			 * write protected if any of the small ones is
-			 * marked but that could bring unknown
-			 * userfault messages that falls outside of
-			 * the registered range.  So, just be simple.
-			 */
-			result = SCAN_PTE_UFFD_WP;
-			goto out_unmap;
-		}
 
-		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
-			result = SCAN_PAGE_NULL;
-			goto out_unmap;
-		}
-		folio = page_folio(page);
+		pte_check_res = thp_collapse_check_pte(pteval, vma, addr, cc,
+					&folio, &none_or_zero, &unmapped,
+					&shared, &result);
 
-		if (!folio_test_anon(folio)) {
-			VM_WARN_ON_FOLIO(true, folio);
-			result = SCAN_PAGE_ANON;
+		if (pte_check_res == PTE_CHECK_CONTINUE)
+			continue;
+		else if (pte_check_res == PTE_CHECK_FAIL)
 			goto out_unmap;
-		}
-
-		/*
-		 * We treat a single page as shared if any part of the THP
-		 * is shared.
-		 */
-		if (folio_maybe_mapped_shared(folio)) {
-			++shared;
-			if (cc->is_khugepaged &&
-			    shared > khugepaged_max_ptes_shared) {
-				result = SCAN_EXCEED_SHARED_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
-				goto out_unmap;
-			}
-		}
 
 		/*
 		 * Record which node the original page is from and save this
-- 
2.49.0


