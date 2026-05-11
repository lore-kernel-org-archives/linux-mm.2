Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C4F4CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 18:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E57C6B00D8; Mon, 11 May 2026 14:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BDF46B00DB; Mon, 11 May 2026 14:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEF796B00DC; Mon, 11 May 2026 14:59:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCA996B00D8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:59:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7115A1401F2
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:59:21 +0000 (UTC)
X-FDA: 84756052122.09.AE1FB65
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5FF7820007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:59:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WN7ghQuJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778525959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hfz8jgL6sf96zHwi0lniorigieWh/Agrf3Lw8asMMQY=;
	b=49TdlDAhiw3EvOtt1Dh9HaVc0vutg9rDscf20hYscZqO++zH7WOzQkdSnBAdWHnG5Z/SoD
	sAFcK17w5pW53pLXkukr9GrlJd667+F9IvTM0rS617nlBwHXXLdIRP77YwdaLn9rdrQBaD
	qAjep67Cq2ekPoaUkj9GnWnUbSwGgfY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778525959; a=rsa-sha256;
	cv=none;
	b=v5I9tkBXzPpewBXBASFoA/UsGO2ObziHS+A/KJinrZHGjRQAElB9kySg9Z/Q6R6LaCaeEl
	sgywbWzXgTRuIt0r+3sVyHqMNZsXyKbgmCLwy43gbn6lcZCWqR0vv3QDiSLyx3L7OAej+b
	NgFOd2IsM8bCOmhY17XRv/vKD9ChUXE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WN7ghQuJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778525958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hfz8jgL6sf96zHwi0lniorigieWh/Agrf3Lw8asMMQY=;
	b=WN7ghQuJkfLSkPmd+V+xMN6wcMV9QZIgy/IqmfLPPUfMAAQTkvfICnT9YM1Bfajqu/S5g7
	D70RGS6TzItsOA6Pa/rlUC0vpXkb/5yaRHdUuimMwRY21KSu2XoCkDr+kEowRxVmIA89RP
	QAdy96gL6ton5dDguZzZLzGZy45kQII=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-250-VQO0104XP42xERNqAF2dMA-1; Mon,
 11 May 2026 14:59:15 -0400
X-MC-Unique: VQO0104XP42xERNqAF2dMA-1
X-Mimecast-MFC-AGG-ID: VQO0104XP42xERNqAF2dMA_1778525950
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4978C195606F;
	Mon, 11 May 2026 18:59:09 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.3])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AC1E23002D30;
	Mon, 11 May 2026 18:58:49 +0000 (UTC)
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
Subject: [PATCH mm-unstable v17 03/14] mm/khugepaged: rework max_ptes_* handling with helper functions
Date: Mon, 11 May 2026 12:58:03 -0600
Message-ID: <20260511185817.686831-4-npache@redhat.com>
In-Reply-To: <20260511185817.686831-1-npache@redhat.com>
References: <20260511185817.686831-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YmeLKOn8dgYo4ObRDa-2am5fXL171mVMTv5IxkjSwGM_1778525950
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5FF7820007
X-Stat-Signature: iphnqwi7uesyugqwjkw7bdni6kawsdg5
X-Rspam-User: 
X-HE-Tag: 1778525959-64093
X-HE-Meta: U2FsdGVkX1/fsZBGwB1HyOR3hr3OLUH8Iw6k5EqqQwd9wicnF33o8WRTF0gm8ruRsbIv/KhkcLRMe3+h4NVxSzpnMfFxoL7yDpr89DcfzE6gGKJRj3rGXuqerPC0ylqKu5cqvMBxMg7gj+gfgErbX/imxTwKPiVEvCy1ygLdrTzGZkrR3DPrVxQN6kvGSYMMkcDPwtcYT11x1DnobIJNP9ktnEDq5VEd3Uy+G7tgZfeMQFQc6qY7H/GITQmtaamSd30Jm4uBtp5moUUPQ8f1rtj9SEbHEFn1dURNTQm16DLRLydvBlG9xxRG34tabpibnw/b4SF5YC9xSc8IqhtvkeE9R50OZl3a6PFTBVe0qBq9UKlcVy7GhA4Juj5pkRZAbSLFSiN+7iRj+WESh9ftISULK7YFwV6xbvlgyErQZpi7Bbc9p//KAd2m+igrsBL9QPlSJLoeN2EtakSVnaQY73jQvfXP4lQcBmx0gTflORKozIS3mebtyJ0BPgTiQmxhs1gP3Xn8+oU3ssBOdrQa3opASLH4dYSgEgsBuv155rfFZAghn9eBZFd7i3eUYUeyXd0rV64Sgh7DMugaIjk0BosbqrnbYITxBUwx0RlplJbO8xW2FqtKDscyuyJQVZ6XYz47S89BxjWCVizuLkXfenqAJZaR2lDfw+GmozaFQPNQEevTojZNX/4QwIsWo9E4Nklc5SeAXMMg/GT28hUvBnxv96YjNfHW4zXnUyERb0zxwQ/MRZpFerlfg8IU2G9WQ53566ms41bylLuUn6xZ4cjcCEMtpeqD5vJIacfSscIEacsO/Y5Dbt/0e6DTH0et3JFTUmXWY+6HO74CrKdTAV2R5ylNz7uR4WmOOZdwVc4kUBM7yMXpmlwop4B2pPkGBbHp58M09L0MyWBp1dnv63teia8TMiu6yd3He4SZYzvuK+2AanSSB6ImV6UvRexDlKxSD7WAt9dyMOqP3z2
 YS1ajG6k
 48+5TNatIKLB+5+gq/FRDPf74RuwYWER45dLOGQrtT6LQkTFuAD0OUlDtJqUtuKfxD2wR17ckw/uFxrdLEzXdkXnmtgq50+0kbtxNHEtCaWnAsbMg1rZGXawnBqItJT7SbGIbFZwEXCRamIMQgMMPwoWmAZxBCpuIbK3ENqUWelbhD2JwWpo6lIe8SEZS67ZX9xUxRri3++KlUHshM6TzpX0HFaWITABwk4q8s6zs5qS6gHe75sSPLHq1IfRpED8UyHAjVWGC+5umg1kKCOOkT4BuZuFp8DZvpbQmhTFRJTJzRUTHRJ3G6udwb1qsJolF/XyFjR6KhZ52oVGBYsVBkQ+8N3K1STC/9EO05v9byL4vfpvEygNoUDwuxoOIhuTkYrHsYXhzLh9Xc6QV+hsxEwYv4ilhWluE6zgaY7AchypNj5tdkIDDzLGiBti1MQZm92orBn11UJRHdipD8NnxqTSm8wVq+Y8FrT8Z
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
(dont respect the sysctls) away from the functions that utilize them. And
will be used later in this series to cleanly restrict the mTHP collapse
behavior.

No functional change is intended; however, we are now only reading the
sysfs variables once per scan, whereas before these variables were being
read on each loop iteration.

Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 118 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 82 insertions(+), 36 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f0e29d5c7b1f..f68853b3caa7 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -348,6 +348,62 @@ static bool pte_none_or_zero(pte_t pte)
 	return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
 }
 
+/**
+ * collapse_max_ptes_none - Calculate maximum allowed none-page or zero-page
+ * PTEs for the given collapse operation.
+ * @cc: The collapse control struct
+ * @vma: The vma to check for userfaultfd
+ *
+ * Return: Maximum number of none-page or zero-page PTEs allowed for the
+ * collapse operation.
+ */
+static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
+		struct vm_area_struct *vma)
+{
+	// If the vma is userfaultfd-armed, allow no none-page or zero-page PTEs.
+	if (vma && userfaultfd_armed(vma))
+		return 0;
+	// for MADV_COLLAPSE, allow any none-page or zero-page PTEs.
+	if (!cc->is_khugepaged)
+		return HPAGE_PMD_NR;
+	// For all other cases repect the user defined maximum.
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
+	// for MADV_COLLAPSE, do not restrict the number of PTEs that map shared
+	// anonymous pages.
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
+	// for MADV_COLLAPSE, do not restrict the number PTEs entries or
+	// pagecache entries that are non-present.
+	if (!cc->is_khugepaged)
+		return HPAGE_PMD_NR;
+	return khugepaged_max_ptes_swap;
+}
+
 int hugepage_madvise(struct vm_area_struct *vma,
 		     vm_flags_t *vm_flags, int advice)
 {
@@ -546,21 +602,19 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	pte_t *_pte;
 	int none_or_zero = 0, shared = 0, referenced = 0;
 	enum scan_result result = SCAN_FAIL;
+	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
+	unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);
 
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
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
@@ -591,9 +645,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 
 		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
-			++shared;
-			if (cc->is_khugepaged &&
-			    shared > khugepaged_max_ptes_shared) {
+			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
 				goto out;
@@ -1261,6 +1313,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long start_addr,
 		bool *lock_dropped, struct collapse_control *cc)
 {
+	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
+	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);
+	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc);
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
 	int none_or_zero = 0, shared = 0, referenced = 0;
@@ -1294,36 +1349,29 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 
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
@@ -1366,9 +1414,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
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
@@ -2323,6 +2369,8 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		unsigned long addr, struct file *file, pgoff_t start,
 		struct collapse_control *cc)
 {
+	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL);
+	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc);
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
 	XA_STATE(xas, &mapping->i_pages, start);
@@ -2341,8 +2389,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 
 		if (xa_is_value(folio)) {
 			swap += 1 << xas_get_order(&xas);
-			if (cc->is_khugepaged &&
-			    swap > khugepaged_max_ptes_swap) {
+			if (swap > max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
 				break;
@@ -2413,8 +2460,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
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


