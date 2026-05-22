Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79669CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC1356B00A5; Fri, 22 May 2026 11:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98656B00A6; Fri, 22 May 2026 11:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87696B00A7; Fri, 22 May 2026 11:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 987DF6B00A5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:01:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 495F5A0AA3
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:01:02 +0000 (UTC)
X-FDA: 84795368364.10.B0972F5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2237718001B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:00:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ejGQ093v;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=583QWv+CIJH74moADkrrabF3RHXWCNpxBfiQC5Xw50Y=;
	b=mP0NOXPjy/KRuirxv3f2DA+I5mHuCHcbPTIMKUR1hB6SCkGZ4xST9yKTteQX6xHqsyn9r1
	vIK1R5+uQR85/4pjKKa37DVExGjbqc+GYUqhUCJi2NXV1XSVHDQ/cws2Kuwe08oZe07bZM
	LhAPvS00HGpEwTN1Rv14925GKC7Xrwc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ejGQ093v;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462060; a=rsa-sha256;
	cv=none;
	b=8XbWqq0e2f5M44v6y/19jHJOvi4ktkYwlBJrqj3XuuZZK7uwCP6VSHY31O/zFmAw75Rfdq
	KJRK6NK1r7c8hV85RA/DyYO30gkuVladi+ylgRyiMEC1uGsvZtaqpI+ERq5VcUAUUx6J1R
	UasGhhEEgNs1g1V/U+VUieeE3yN0sSw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779462059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=583QWv+CIJH74moADkrrabF3RHXWCNpxBfiQC5Xw50Y=;
	b=ejGQ093v5YUjPxex7AEtGBVyCdpvM3FiQbSH3xpp9x52iuzQCIvnR+iR+vhJsyNmOZJE9N
	DfT4Yic1rN52YMQdWFiSM5WPIys/zUfzTVq8HSZ4TCG8BCkObNkRQx3S7lEEbKjqlmwzrh
	gjXB6GTi4waV33EFjwEOwuYJNXYQCk8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-556-aZRkFrhTPwKoZVov3d_7Dg-1; Fri,
 22 May 2026 11:00:57 -0400
X-MC-Unique: aZRkFrhTPwKoZVov3d_7Dg-1
X-Mimecast-MFC-AGG-ID: aZRkFrhTPwKoZVov3d_7Dg_1779462051
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC5551956095;
	Fri, 22 May 2026 15:00:50 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.24.8])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D82151800576;
	Fri, 22 May 2026 15:00:31 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH mm-unstable v18 03/14] mm/khugepaged: rework max_ptes_* handling with helper functions
Date: Fri, 22 May 2026 08:59:58 -0600
Message-ID: <20260522150009.121603-4-npache@redhat.com>
In-Reply-To: <20260522150009.121603-1-npache@redhat.com>
References: <20260522150009.121603-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GOX6RxkPSWz_mxKtNvee4tZRZPKpY2cNySIJM2UDKU4_1779462051
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: wzc5m9x4erb4axdnm9repndgtzc9xwki
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2237718001B
X-Rspam-User: 
X-HE-Tag: 1779462059-320370
X-HE-Meta: U2FsdGVkX18e2UlLzioKaDkplXi/RqZDii4EgqvXr8DpNZXxfoccLXCyjh83vy9nIB91JIHq034bwETkvZjJ6la5aS2CpA2dMLoroWlc1XBwmnpCDCCvD4lfdDdaaBgdeoHP6F0MXj9FUQnjkFJEU+njphLfSCV7CkL3ANU9YbM6oBSOyksEhqxsM4Wbtra8tFZu+3+oELSCC1D0q43BtPLPG8unj2pBDqwqp+SSif1oiVQslTdVUs1C6+BKUPZVVCBynmr/5JYhlKbm4lJzxuIjttk89QV5FJ/ZwEaZ1HQPjIFfqBTLSUMR43F+J5wCgDyBp8JUc1uWAXevaASqKQ7OTy0R8ij7I0LZAyFg2YzYJgMDm1yFc+vHz4XdqIE3fS7SulDbBUJ/bdRLuNVWLgWXQTatcbCKHyJEmyN9HIE2TPxNtYh+tDDW61ZForIH3GKQ5cvraOVqyaCqcPSY62ncda26AO7nRM7GJKnhzVnphSEUNF7xHQaD9X6bqdViCUFJRDmEjn3XAHmSCRQ/b20nKSkjY9ZappeL6thiTqCGYzvo1xQRxmXhf5YtLEcd1My7tpiQPefM8UEKTvC4hUdtD9Wmm8zUQXFymL5JrSD9RWnfBSH1y3Tau204DLDtbNZoYcPgaKWBV5XwWwvarXt+UazbA+wR15ZnjYu1nL4tfqdFJL3coTh6hcV9KdYwMFwR9uz2VeeLwUU59DsAbiC8nkWURgRXGKEGAzoDtQMr3hR02gpr/K401IKFa2DccuWdDj5UiCvB6azB+z1Aoy5xF+2desJ1Z9r4Zxp0EJWDETS6797hmW+kDYwTbrhVIV3CBmPpHDONSYOf+lb3rmp6A5XiHF68Sq9OwG0COarfBMeujKGe8GAq/eU3VfCu/VNlPB2TAtHooWqZ5nWFO0KOWBmgodwDXhneZNNiU7BTirbxPUJeM1JL3T4lKXRQ+spxXRGoA1ClJ+1kDb8
 NTdp/pn4
 E83tcVWJG9BcvWPxslWMrzxQFJCDGnXDLscLQ1IdiZsmFk6uJiIaYj3KbzRro1OrQ2zOaXrP6XbBOilwp1OTJdgivwXjORy0Dn5xSfNcswYCjDG82jkAkc/sX0loaSf4kpTygxhMYU1iq5lHdmyZyLc6Ee7ncbRquVQpqvJVqkQc99lw1pQfe3igNxufkaJuwqFDI5p3ebzIRxrEWm3pLThTwlhmqlTEuP9dP3/TRlyl1k8Bkj+CO9QLOtGmwuCVgydv3udDV0KsUAKc/46JbZ3uXQBM9nLeJaT6s7Xxyc+++Ygsnogfg2Dzm5ZEB3mKjhIsfkxTurySdPl+IliFJYqcp2PrvJ0wu9JDCsiPzO5GqYLwHy9Mi5MpXAwvDKz3dJR9f423cUALLovakFYQGyXq+0Mtn0e3+nji7ApLPfn1YVUH1W8Gu+rKmpB2ptOazlmOf+IlbJ+yp+c3EVbuK+vNuDNFLhCp1Y6E8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following cleanup reworks all the max_ptes_* handling into helper
functions. This increases the code readability and will later be used to
implement the mTHP handling of these variables.

With these changes we abstract all the madvise_collapse() special casing
(do not respect the sysctls) away from the functions that utilize them.
And will be used later in this series to cleanly restrict the mTHP
collapse behavior.

No functional change is intended; however, we are now only reading the
sysfs variables once per scan, whereas before these variables were being
read on each loop iteration.

Reviewed-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 120 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 84 insertions(+), 36 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 13d82993755f..116f39518948 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -348,6 +348,64 @@ static bool pte_none_or_zero(pte_t pte)
 	return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
 }
 
+/**
+ * collapse_max_ptes_none - Calculate maximum allowed empty PTEs or PTEs mapping
+ * the shared zeropage for the given collapse operation.
+ * @cc: The collapse control struct
+ * @vma: The vma to check for userfaultfd
+ *
+ * Return: Maximum number of empty/shared zeropage PTEs for the collapse operation
+ */
+static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
+		struct vm_area_struct *vma)
+{
+	if (vma && userfaultfd_armed(vma))
+		return 0;
+	/* for MADV_COLLAPSE, allow any empty/shared zeropage PTEs */
+	if (!cc->is_khugepaged)
+		return HPAGE_PMD_NR;
+	/* For all other cases respect the user defined maximum */
+	return khugepaged_max_ptes_none;
+}
+
+/**
+ * collapse_max_ptes_shared - Calculate maximum allowed PTEs that map shared
+ * anonymous pages for the given collapse operation.
+ * @cc: The collapse control struct
+ *
+ * Return: Maximum number of PTEs that map shared anonymous pages for the
+ * collapse operation
+ */
+static unsigned int collapse_max_ptes_shared(struct collapse_control *cc)
+{
+	/*
+	 * For MADV_COLLAPSE, do not restrict the number of PTEs that map shared
+	 * anonymous pages.
+	 */
+	if (!cc->is_khugepaged)
+		return HPAGE_PMD_NR;
+	return khugepaged_max_ptes_shared;
+}
+
+/**
+ * collapse_max_ptes_swap - Calculate the maximum allowed non-present PTEs or the
+ * maximum allowed non-present pagecache entries for the given collapse operation.
+ * @cc: The collapse control struct
+ *
+ * Return: Maximum number of non-present PTEs or the maximum allowed non-present
+ * pagecache entries for the collapse operation.
+ */
+static unsigned int collapse_max_ptes_swap(struct collapse_control *cc)
+{
+	/*
+	 * For MADV_COLLAPSE, do not restrict the number PTEs entries or
+	 * pagecache entries that are non-present.
+	 */
+	if (!cc->is_khugepaged)
+		return HPAGE_PMD_NR;
+	return khugepaged_max_ptes_swap;
+}
+
 int hugepage_madvise(struct vm_area_struct *vma,
 		     vm_flags_t *vm_flags, int advice)
 {
@@ -540,6 +598,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
 		struct list_head *compound_pagelist)
 {
+	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
+	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr = start_addr;
@@ -551,16 +611,12 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
-			++none_or_zero;
-			if (!userfaultfd_armed(vma) &&
-			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
-				continue;
-			} else {
+			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
 				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 				goto out;
 			}
+			continue;
 		}
 		if (!pte_present(pteval)) {
 			result = SCAN_PTE_NON_PRESENT;
@@ -591,9 +647,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 
 		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
-			++shared;
-			if (cc->is_khugepaged &&
-			    shared > khugepaged_max_ptes_shared) {
+			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
 				goto out;
@@ -1262,6 +1316,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long start_addr,
 		bool *lock_dropped, struct collapse_control *cc)
 {
+	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
+	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);
+	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc);
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
 	int none_or_zero = 0, shared = 0, referenced = 0;
@@ -1295,36 +1352,29 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
-			++none_or_zero;
-			if (!userfaultfd_armed(vma) &&
-			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
-				continue;
-			} else {
+			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
 				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 				goto out_unmap;
 			}
+			continue;
 		}
 		if (!pte_present(pteval)) {
-			++unmapped;
-			if (!cc->is_khugepaged ||
-			    unmapped <= khugepaged_max_ptes_swap) {
-				/*
-				 * Always be strict with uffd-wp
-				 * enabled swap entries.  Please see
-				 * comment below for pte_uffd_wp().
-				 */
-				if (pte_swp_uffd_wp_any(pteval)) {
-					result = SCAN_PTE_UFFD_WP;
-					goto out_unmap;
-				}
-				continue;
-			} else {
+			if (++unmapped > max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
 				goto out_unmap;
 			}
+			/*
+			 * Always be strict with uffd-wp
+			 * enabled swap entries.  Please see
+			 * comment below for pte_uffd_wp().
+			 */
+			if (pte_swp_uffd_wp_any(pteval)) {
+				result = SCAN_PTE_UFFD_WP;
+				goto out_unmap;
+			}
+			continue;
 		}
 		if (pte_uffd_wp(pteval)) {
 			/*
@@ -1367,9 +1417,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		 * is shared.
 		 */
 		if (folio_maybe_mapped_shared(folio)) {
-			++shared;
-			if (cc->is_khugepaged &&
-			    shared > khugepaged_max_ptes_shared) {
+			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
 				goto out_unmap;
@@ -2324,6 +2372,8 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		unsigned long addr, struct file *file, pgoff_t start,
 		struct collapse_control *cc)
 {
+	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL);
+	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc);
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
 	XA_STATE(xas, &mapping->i_pages, start);
@@ -2342,8 +2392,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 
 		if (xa_is_value(folio)) {
 			swap += 1 << xas_get_order(&xas);
-			if (cc->is_khugepaged &&
-			    swap > khugepaged_max_ptes_swap) {
+			if (swap > max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
 				break;
@@ -2414,8 +2463,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		cc->progress += HPAGE_PMD_NR;
 
 	if (result == SCAN_SUCCEED) {
-		if (cc->is_khugepaged &&
-		    present < HPAGE_PMD_NR - khugepaged_max_ptes_none) {
+		if (present < HPAGE_PMD_NR - max_ptes_none) {
 			result = SCAN_EXCEED_NONE_PTE;
 			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 		} else {
-- 
2.54.0


