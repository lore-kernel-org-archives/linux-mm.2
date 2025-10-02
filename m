Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 049A4CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 07:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 605A68E0011; Thu,  2 Oct 2025 03:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B6168E0002; Thu,  2 Oct 2025 03:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5608E0011; Thu,  2 Oct 2025 03:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3685C8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:35:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE1AD16036F
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:35:19 +0000 (UTC)
X-FDA: 83952363558.10.A2F2A5F
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id E1E494000C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:35:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759390518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2P+QxCKNk8CP42mvLpExWTtDqGlhoKEfhagqG2LkgdE=;
	b=t4OTeZfRYWi8/dpil/VOiSmoRYgHQnup7Rvu7dtrGIPoDtzQcgO9FfApyIid4zqE57b9ZM
	/FBnKjyOmK0a1sl7tzI4tf7w1i6Lz6mCkxT6u/P+NvsBRVOAvAcyGUafILgWUOtFyI+Rsr
	C/3JAQ+KUUYI5AXUlLrxtj0cdSkoJf0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759390518; a=rsa-sha256;
	cv=none;
	b=T19FlGxHKfgqWW7P/zgrOdPsucol+mZ/FhuL7yN82DiYhkKGp2wNY8yQ19cXwWX1mYNAei
	1nkx+yePEaNihlnuIT9/xDCkAw7XhCo/1AR/gqLayp6ClG2dORSIhiE1b0jQx+1cYH61Nr
	SYwNWwOiodXbvGx2y/GVsSppGGU0tuE=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e4473d7f6so4330595e9.1
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 00:35:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759390516; x=1759995316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2P+QxCKNk8CP42mvLpExWTtDqGlhoKEfhagqG2LkgdE=;
        b=MsBgL6+hCZ3SQMoxXauAso5KyDcBYKpQXK0IMGpJjjgH2zmQ1lhopsAO3KCzGMkgfm
         rprCfNUxJFddDlW8SnUxgJxyFINrIiVJDQfLBD+fe/ALmtN//I6cESr85S1bwEjqhbfP
         3aF82BYtcx6Plvtl22Z78A2YOKyCfek7uTPXK6kRfziwkbnJ8pYAGijSPfNgwzwght4t
         AQxuU+wzv8m2oHljG8FI5/dpEw4Ge5XkSRzm6i10pyb7cr4LVOVmiuPWvZ25Bu1jleVm
         SnDH8u6dBr73Llcqd/Fu0uj5981kzET9DTfAj4AFm5OSARVUddnRKQ6L/HXTMGM9HKrE
         muBg==
X-Forwarded-Encrypted: i=1; AJvYcCWvh7+YKdXtm3KGMkHMS41CIcBGeGdnXXyUaI0KeZFcIeEq0FN51v4vQdiKKupj1dpWWh8cCtHLtg==@kvack.org
X-Gm-Message-State: AOJu0YyxXV2SMZr3KQpzvwLQ/l6kG2V3LdBtGJlUXUEhDmuWv9DsDdvP
	VswXIEsYA34xcXUUuSCWQLQuG4g+/Vw7lji3Bsr6CjT1UNHcg4XZPLQd
X-Gm-Gg: ASbGncvsi8ky7sjZ9jL6nCkBwcZyYBA5neDKh63KpWAFT6zJYHQCrtsf+3UNOYymRec
	LQEaG01ZheaFNL48METGPeDaHIYUaBMq71o51iTm73+SdA54ysn98xKds/oaJQjQ8TZc7rPMU6s
	fHq3eb/UJO/VLm7/lvEQBFn1TDRd3/4PBgXTFGPsjkYlI3A5NOFUx+lHI2l1JIaSqIEFILHnWl3
	qy1x3mZfK1UqtWqnjAxCmt4Axf+yHL6DYIcRZpLwVep+1UYZqgAowQhAkjTZ2fbsGhEupO1CvCT
	S2WA4wTXkli8GiwA+WjHK7JbhhYheOY3MqdCc4GXfxq6Ytoar/yKSG6So4T2c3jDQW2IGGtA6HW
	V0j09yhdnMUfKmVbSV05o0xEJBqyRkI/udFZJyNE=
X-Google-Smtp-Source: AGHT+IHwYErkeuuJqmW0yYHHSaG/VO1vFpQ/Hjjaa4y+3AfuoUXztvBinSjkxvpo2QRl7b9xEIGvKw==
X-Received: by 2002:a05:600c:1382:b0:45d:f83b:96aa with SMTP id 5b1f17b1804b1-46e6863e130mr18122025e9.7.1759390516191;
        Thu, 02 Oct 2025 00:35:16 -0700 (PDT)
Received: from localhost.localdomain ([2a09:0:1:2::301b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e6a692af6sm17856135e9.21.2025.10.02.00.35.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 00:35:15 -0700 (PDT)
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
Subject: [PATCH mm-new 2/2] mm/khugepaged: merge PTE scanning logic into a new helper
Date: Thu,  2 Oct 2025 15:32:55 +0800
Message-ID: <20251002073255.14867-3-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251002073255.14867-1-lance.yang@linux.dev>
References: <20251002073255.14867-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E1E494000C
X-Stat-Signature: neo4u5zerpt4sxzb5di9nieux945trg5
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759390517-627617
X-HE-Meta: U2FsdGVkX18K1PrdPQ/iuPOwowgu2cCkGahjkops2EJS+iMehIIowsr4iz27TXCZqyi02/IkJ8vrX4ZQANbQ8fO9pfHVtZB01JGQmZ6Moij5e4NtGzFEaWJfC46sQh/gOdWKCk9bGh34ZOB/5elfzjlwptksce9kV4vzSeqXKScK2XL5mtrhI/xmjGpqkr1XYp8MbV7AxbVfMJgcmAANAfQNJhWQ+IyFc6y70mtOKD2uuUtzQURXizp4reLb3yCIpEPXkdgJQwEtXTa453L6YN2SNhUaHyV/jbIQi9iFDufZ+ijLfNwWQR2LHA396UAL1rpsHPPkvgDWcWIIBFS9DL4RB1W83cbMVlJ1Je2UhW9G83LNFF9hWl5QxNDDwSA4gg0UWxA+RnkyHaa/iOqf7CpV8yhgK6jgMivOfTeBQE4blBCJvi2YNZpsEQOUV4aYyJj3oQQzHffWlSod5dOErwNcy4KMr6hSuagEPwu2s5jr8BtSseMM8T7NGOA1hvxiFQhkSQ2X5E0NbHCeFQjeVBrDGsv44Q2pQ7DKcBgrtnZYEx9z2GYvqDpFxvxUaDzoJxKkPBs0dd8HOEVY8jGP+zj5b93e9lT9hJ/K2kxZ+kO+yXgyO0I0RtqCZ5rSavYouSyBHbJAgrZsXpAjc5suKzKg+LamzmFQSit1ij1E3Q4CRwRsDCI9pnl9kDRNE6IPiIup58jRPXnxJ/1+HoCWG7pc3w4sk9c4Nm+8xhaP6+A/W0UE+Ew7cviBidgH576QLqnqBBXOcxrzhBOrOdFS9pOlkGjQjR+vN2qZQ5WIXXm0Z/6B3E3couw7k8xrBrQyOnH1EbPvQJv7BQkFAQTJlqIK5A3boWG8Q9ytIrV5ET3hgpF1M6MHCDt88K4wVU7h/htXf0T+lZFALECcp88gGN6XO2k8UMcB8ueCCUAZu/gCE1ArIG+WAjQN4J8z1/Nj6afVBxusUGNtkSq+qAK
 /hrrSGYj
 7mo9YTv1YkAJJx8zpm812RcGcnV8P47nXLFLkc+TSNrZefEhrBD9wfuOafxapw+/1M0wIKGIcJje5fWWMPbhUZPB/7VTnorWerTLWexFNroSb6v8wpBXSArHT89mhII4lz2Cd9eMbfxRZn5mEHfm5Aw8VxOTs9T60Z9OFvwMvs32b/D/V81Ps577ZtzinKXEyk4Kpg48NbYTawYn2qxVu0bkzEZleObn2I7xyFES44kswxorMB7oVUad2WXQJMNRFfQqbQpH1WStcQ0xn/uZ+IeYjwYu1WO9osuxVp3VT0+QtHzZJVpi5NgNkbBjFIV92e6THTLA78RH2gZdB9c9IU3SC4GoqYrnwFBYjzAgQ/gnymyIIBKk1+g46KryQHBgbE31MGPjkDKc/tanOjgYro1rQIFkwaH83iqiffQ+PVlu+HlKKkGrDYC9xjh6ElGQonuWS3hJ4U1lw9F66h88nST9gwWDPN401KQjD/80IiK2qFPFZ33/Dq7D2P1HBjhm0264wSIJ6LEob2NZxAcrsW+m2y/2a0lUxTcoe
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
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/khugepaged.c | 167 ++++++++++++++++++++++++++++++------------------
 1 file changed, 104 insertions(+), 63 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 808523f92c7b..2a897cfb1d03 100644
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
 
@@ -533,6 +539,87 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 	}
 }
 
+/*
+ * thp_collapse_check_pte - Check if a PTE is suitable for THP collapse
+ * @pte:           PTE to check
+ * @vma:           VMA the PTE belongs to
+ * @cc:            Collapse control settings
+ * @scan_swap_pte: Allow scanning of swap PTEs if true
+ * @none_or_zero:  Counter for none/zero PTEs (must be non-NULL)
+ * @unmapped:      Counter for swap PTEs (must be non-NULL if scan_swap_pte
+ *                 is true)
+ * @scan_result:   Used to return the failure reason (SCAN_*) on a
+ *                 PTE_CHECK_FAIL return. Must be non-NULL
+ *
+ * Returns:
+ *   PTE_CHECK_SUCCEED  - Valid PTE, proceed with collapse
+ *   PTE_CHECK_CONTINUE - Skip this none/zero PTE but continue scanning
+ *   PTE_CHECK_FAIL     - Abort collapse scan
+ */
+static inline int thp_collapse_check_pte(pte_t pte, struct vm_area_struct *vma,
+		struct collapse_control *cc, bool scan_swap_pte,
+		int *none_or_zero, int *unmapped, int *scan_result)
+{
+	VM_BUG_ON(!none_or_zero || !scan_result);
+	VM_BUG_ON(scan_swap_pte && !unmapped);
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
+		if (!scan_swap_pte) {
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
+			 * Always be strict with uffd-wp
+			 * enabled swap entries. Please see
+			 * comment below for pte_uffd_wp().
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
+		 * Don't collapse the page if any of the small
+		 * PTEs are armed with uffd write protection.
+		 * Here we can also mark the new huge pmd as
+		 * write protected if any of the small ones is
+		 * marked but that could bring unknown
+		 * userfault messages that falls outside of
+		 * the registered range.  So, just be simple.
+		 */
+		*scan_result = SCAN_PTE_UFFD_WP;
+		return PTE_CHECK_FAIL;
+	}
+
+	return PTE_CHECK_SUCCEED;
+}
+
 static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 					unsigned long start_addr,
 					pte_t *pte,
@@ -544,28 +631,20 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
+		pte_check_res = thp_collapse_check_pte(
+			pteval, vma, cc, false, /* scan_swap_pte = false */
+			&none_or_zero, NULL, &result);
+
+		if (pte_check_res == PTE_CHECK_CONTINUE)
+			continue;
+		else if (pte_check_res == PTE_CHECK_FAIL)
 			goto out;
-		}
+
 		page = vm_normal_page(vma, addr, pteval);
 		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
 			result = SCAN_PAGE_NULL;
@@ -1260,6 +1339,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	unsigned long addr;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
+	int pte_check_res;
 
 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
 
@@ -1278,54 +1358,15 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
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
+		pte_check_res = thp_collapse_check_pte(
+			pteval, vma, cc, true, /* scan_swap_pte = true */
+			&none_or_zero, &unmapped, &result);
+
+		if (pte_check_res == PTE_CHECK_CONTINUE)
+			continue;
+		else if (pte_check_res == PTE_CHECK_FAIL)
 			goto out_unmap;
-		}
 
 		page = vm_normal_page(vma, addr, pteval);
 		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
-- 
2.49.0


