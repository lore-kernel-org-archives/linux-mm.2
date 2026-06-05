Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BA0BCD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B274D6B0099; Fri,  5 Jun 2026 12:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFE886B009B; Fri,  5 Jun 2026 12:15:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A14C36B009D; Fri,  5 Jun 2026 12:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 929C96B0099
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:15:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4862A401F9
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:15:12 +0000 (UTC)
X-FDA: 84846358464.23.F34ABAB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 27A4F4000C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:15:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gnReXVrt;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780676110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sM2ghSC4v58MaQLggKCtDyraE3Qu9nrQx3/9hZTQe8Y=;
	b=Dr8Ct/j4W+dNkhpNdJzsKppfDCDXFmyBmWIqsqQhPztHkeYqjFZ1gsNKgjorny87TKgIuk
	bIFwA0vP3Daleyzl3QOQdmaI1smwxhbc1y6CbGYfEQ/VjkyCIVG7z/HA/JlHTuIDB/bL4K
	cnmJZ3vB3E1a2GXMbsue/Y+Lw0PlHaU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780676110;
	b=1efJoH6A1u9MKX9XeBaUElvBpVMANVPSAqRF6HXDhRNi67BdIpLC+axHEL/OFTMbimCgdC
	OnX2EhQm0gOEu1WoCpVfFIncW4n8rtd2gpeW691vcPWR6ixGZjwhAjoHA/pQKYEFzjWQLL
	L5BpYV1/KVHtGZ4gwZRb84oDWNo0nKY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gnReXVrt;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780676109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sM2ghSC4v58MaQLggKCtDyraE3Qu9nrQx3/9hZTQe8Y=;
	b=gnReXVrtxIVEv0apkXpZik9sncDOeb6KK93Vr6eDd94j7Szfqxp0DR3yPeQE2ecr+bWeCJ
	69xanegoGp/DDO9dcg+H1NRT4HgSU02h3IgQ64k38GM6pvNG45gIbivExnWsnxT1qJuZXH
	sXJllbY+2a36Qutx9hAQzQm8HtS7pIM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-76-Vvv7I-0LNFe98RYLn0zGVA-1; Fri,
 05 Jun 2026 12:15:07 -0400
X-MC-Unique: Vvv7I-0LNFe98RYLn0zGVA-1
X-Mimecast-MFC-AGG-ID: Vvv7I-0LNFe98RYLn0zGVA_1780676101
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C74471944D1B;
	Fri,  5 Jun 2026 16:15:00 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.9])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9E6F818005B5;
	Fri,  5 Jun 2026 16:14:42 +0000 (UTC)
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
	zokeefe@google.com
Subject: [PATCH mm-unstable v19 04/14] mm/khugepaged: generalize __collapse_huge_page_* for mTHP support
Date: Fri,  5 Jun 2026 10:14:11 -0600
Message-ID: <20260605161422.213817-5-npache@redhat.com>
In-Reply-To: <20260605161422.213817-1-npache@redhat.com>
References: <20260605161422.213817-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: x_fRK8Nk2FCUuUEcWMOag16K9z13avkzW8IpxhTYb1g_1780676101
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 27A4F4000C
X-Stat-Signature: e9weotbrbbetdgc1fx4mxp8o46iyix5z
X-HE-Tag: 1780676109-722062
X-HE-Meta: U2FsdGVkX1/8PNNSm+y3VBOmn8+OCuZL0p4gWApTLn3uPwZmq1EzpNyeUAVnT3Hbr5ZPsXU8bvR9r/lE00ZFO/658ixFLBbeWKyk9/BaKbfz7V3Xx9vmZwWcTjqMTEzJkbuvkYjahD8YBlBUQySDdBJcieJbulvIpqWeh2YMjF/aba3jTFJA52ID8yCBGINDKeF7xT80vo8ufyhd78mbawfFN5nA923Uv2nsuL7Frw6XPUKTQKdxeSjxSpEnj81Ygwzh2bKxUffAbUTL5QLenKm7SR9uk88FIj5hLKcYjULSvykyZeKgQggiTf07595s5eOj7PxYvZr5Jr26hdxov+dvSyqebT0yrX9vR6pKD5dYz8ijh6JH+CvGB3rjuEnWKyKNSGYxC+3ZN9YGwRdhd4CAG+ljL9CLVNXTX8B8RvPR3Ls71p9Zrr+4P+M/KqxG9Kg8PsMBLD8s096nG6mx1ITYFQStFopyuSv5gzdLyKa4GKVHwbSpMwCgCzrMgtKOKaymU9ySBbQO+b8SXBHUji5m4FUAmLPT7BY9I0LJ9WotTFLWEwQKxFdwAU+8y6xILhkmfG7JNEmkqWFSFZgMB9c9STqoIMnsSZqrs/H0YfK6G2+pbt4+wNbcPHGZF4Tz2JrJ+SOkSiG7RU34DKNqNy2ELa0tqPbZjFQxaFf2wLftOl+XbUOEUxHCVt3MGWbv2+pJlESWQyIuL83vnmRWtvPrukEY8QlsWLhfaBoktqPdYzoBuFqmcZhY0TYQYff4jLHEe4CDp1DtxWETCymn/5L/benXmiph8v6Pu9fwj9EUbS+BMFS98r5M2wxMOlWOzcUm4Gd0HUxI9q/FHVZvy54FB8rVQQyFKyeY3xG+FCsiFkJb815bDCt7w3MhMMHpuDxG02KC0Hr/2AbJAMkkuwK8NXmaJO8nbXo/sdLxsdIQLZJcrvajS4XjmLtmhDqXdDlXFOAuFnVddbZW8zI
 ZPYXEcu/
 DLqig07XfLkYWBEdYd0aybjsgRmz6MOC5k6jFv9coiWksZpp3C1CuoEEBgruqdB88I7/RYAXsiESdhXAw2pfN4H3ZmOvgKp0tSD97B2nSoBaL2psL/TeFd0cG62u2QVOPA6Cz8DpcPDK13Ex3u2C/1aKzs2N0d9fP3V2ooZNbPPeLOfL4nr5Nil5cdzeC3eKZYwIRx8HKbclcXcHC3wqbYbWQhrTWzGucsqUgHQhVHSavpYUvSwq+H35iuoP70raFO6CNs7v9BX6+I1e2TyrLJ+v+mPBxYwV78uzUc/hB3LeTy4cWWGAwY7geGq40OqlsJyDriBR3NoXoEnm7V6RKEm+xOwm5P6CzgPKvhxRqk3xy6yJmwrIykLaZltl75ox/GkwGeS5QJ9jyPduQpx0BXgkfCXCZkGGLRTpHSCdV5iXD9lG941bjYpL+pXx1E7mSZBjeDfrkqvSm8eR96zfXd9vWY3lbj+t9OgcvUFFiccHgtdQ9v20KK3MkE9SRoD0xYryNJim3DvLTQljmFXi18UNM8iBmfvzj3hWj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

generalize the order of the __collapse_huge_page_* and collapse_max_*
functions to support future mTHP collapse.

The current mechanism for determining collapse with the
khugepaged_max_ptes_none value is not designed with mTHP in mind. This
raises a key design issue: if we support user defined max_pte_none values
(even those scaled by order), a collapse of a lower order can introduces
an feedback loop, or "creep", when max_ptes_none is set to a value greater
than HPAGE_PMD_NR / 2. [1]

With this configuration, a successful collapse to order N will populate
enough pages to satisfy the collapse condition on order N+1 on the next
scan. This leads to unnecessary work and memory churn.

To fix this issue introduce a helper function that will limit mTHP
collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
This effectively supports two modes: [2]

- max_ptes_none=0: never collapses if it encounters an empty PTE or a PTE
  that maps the shared zeropage. Consequently, no memory bloat.
- max_ptes_none=511 (on 4k pagesz): Always collapse to the highest
  available mTHP order.

This removes the possibility of "creep", and a warning will be emitted if
any non-supported max_ptes_none value is configured with mTHP enabled.
Any intermediate value will default mTHP collapse to max_ptes_none=0.

mTHP collapse will not honor the khugepaged_max_ptes_shared or
khugepaged_max_ptes_swap parameters, and will fail if it encounters a
shared or swapped entry.

No functional changes in this patch; however it defines future behavior
for mTHP collapse.

[1] - https://lore.kernel.org/all/e46ab3ab-a3d7-4fb7-9970-d0704bd5d05a@arm.com
[2] - https://lore.kernel.org/all/37375ace-5601-4d6c-9dac-d1c8268698e9@redhat.com

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 126 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 93 insertions(+), 33 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f56ab049a6c4..474ee97c54ba 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -353,30 +353,51 @@ static bool pte_none_or_zero(pte_t pte)
  * the shared zeropage for the given collapse operation.
  * @cc: The collapse control struct
  * @vma: The vma to check for userfaultfd
+ * @order: The folio order being collapsed to
  *
  * Return: Maximum number of empty/shared zeropage PTEs for the collapse operation
  */
 static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
-		struct vm_area_struct *vma)
+		struct vm_area_struct *vma, unsigned int order)
 {
+	const unsigned int max_ptes_none = khugepaged_max_ptes_none;
+
 	if (vma && userfaultfd_armed(vma))
 		return 0;
 	/* for MADV_COLLAPSE, allow any empty/shared zeropage PTEs */
 	if (!cc->is_khugepaged)
 		return HPAGE_PMD_NR;
-	/* For all other cases respect the user defined maximum */
-	return khugepaged_max_ptes_none;
+	/* for PMD collapse, respect the user defined maximum */
+	if (is_pmd_order(order))
+		return max_ptes_none;
+	/*
+	 * for mTHP collapse with the sysctl value set to KHUGEPAGED_MAX_PTES_LIMIT,
+	 * scale the maximum number of PTEs to the order of the collapse.
+	 */
+	if (max_ptes_none == KHUGEPAGED_MAX_PTES_LIMIT)
+		return (1 << order) - 1;
+	/*
+	 * For mTHP collapse of values other than 0 or KHUGEPAGED_MAX_PTES_LIMIT,
+	 * emit a warning and return 0.
+	 */
+	if (max_ptes_none)
+		pr_warn_once("mTHP collapse does not support max_ptes_none"
+		     " values other than 0 or %u, defaulting to 0.\n",
+		     KHUGEPAGED_MAX_PTES_LIMIT);
+	return 0;
 }
 
 /**
  * collapse_max_ptes_shared - Calculate maximum allowed PTEs that map shared
  * anonymous pages for the given collapse operation.
  * @cc: The collapse control struct
+ * @order: The folio order being collapsed to
  *
  * Return: Maximum number of PTEs that map shared anonymous pages for the
  * collapse operation
  */
-static unsigned int collapse_max_ptes_shared(struct collapse_control *cc)
+static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
+		unsigned int order)
 {
 	/*
 	 * For MADV_COLLAPSE, do not restrict the number of PTEs that map shared
@@ -384,6 +405,13 @@ static unsigned int collapse_max_ptes_shared(struct collapse_control *cc)
 	 */
 	if (!cc->is_khugepaged)
 		return HPAGE_PMD_NR;
+	/*
+	 * for mTHP collapse do not allow collapsing anonymous memory pages that
+	 * are shared between processes.
+	 */
+	if (!is_pmd_order(order))
+		return 0;
+	/* for PMD collapse, respect the user defined maximum */
 	return khugepaged_max_ptes_shared;
 }
 
@@ -391,11 +419,13 @@ static unsigned int collapse_max_ptes_shared(struct collapse_control *cc)
  * collapse_max_ptes_swap - Calculate the maximum allowed non-present PTEs or the
  * maximum allowed non-present pagecache entries for the given collapse operation.
  * @cc: The collapse control struct
+ * @order: The folio order being collapsed to
  *
  * Return: Maximum number of non-present PTEs or the maximum allowed non-present
  * pagecache entries for the collapse operation.
  */
-static unsigned int collapse_max_ptes_swap(struct collapse_control *cc)
+static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
+		unsigned int order)
 {
 	/*
 	 * For MADV_COLLAPSE, do not restrict the number PTEs entries or
@@ -403,6 +433,10 @@ static unsigned int collapse_max_ptes_swap(struct collapse_control *cc)
 	 */
 	if (!cc->is_khugepaged)
 		return HPAGE_PMD_NR;
+	/* for mTHP collapse do not allow any non-present PTEs or pagecache entries */
+	if (!is_pmd_order(order))
+		return 0;
+	/* for PMD collapse, respect the user defined maximum */
 	return khugepaged_max_ptes_swap;
 }
 
@@ -599,10 +633,11 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 
 static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
-		struct list_head *compound_pagelist)
+		unsigned int order, struct list_head *compound_pagelist)
 {
-	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
-	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);
+	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, order);
+	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, order);
+	const unsigned long nr_pages = 1UL << order;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr = start_addr;
@@ -610,7 +645,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	int none_or_zero = 0, shared = 0, referenced = 0;
 	enum scan_result result = SCAN_FAIL;
 
-	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
+	for (_pte = pte; _pte < pte + nr_pages;
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
@@ -650,6 +685,12 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 
 		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
+			/*
+			 * TODO: Support shared pages without leading to further
+			 * mTHP collapses. Currently bringing in new pages via
+			 * shared may cause a future higher order collapse on a
+			 * rescan of the same range.
+			 */
 			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
@@ -743,18 +784,18 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 }
 
 static void __collapse_huge_page_copy_succeeded(pte_t *pte,
-						struct vm_area_struct *vma,
-						unsigned long address,
-						spinlock_t *ptl,
-						struct list_head *compound_pagelist)
+		struct vm_area_struct *vma, unsigned long address,
+		spinlock_t *ptl, unsigned int order,
+		struct list_head *compound_pagelist)
 {
-	unsigned long end = address + HPAGE_PMD_SIZE;
+	const unsigned long nr_pages = 1UL << order;
+	unsigned long end = address + (PAGE_SIZE * nr_pages);
 	struct folio *src, *tmp;
 	pte_t pteval;
 	pte_t *_pte;
 	unsigned int nr_ptes;
 
-	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
+	for (_pte = pte; _pte < pte + nr_pages; _pte += nr_ptes,
 	     address += nr_ptes * PAGE_SIZE) {
 		nr_ptes = 1;
 		pteval = ptep_get(_pte);
@@ -807,11 +848,10 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
 }
 
 static void __collapse_huge_page_copy_failed(pte_t *pte,
-					     pmd_t *pmd,
-					     pmd_t orig_pmd,
-					     struct vm_area_struct *vma,
-					     struct list_head *compound_pagelist)
+		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
+		unsigned int order, struct list_head *compound_pagelist)
 {
+	const unsigned long nr_pages = 1UL << order;
 	spinlock_t *pmd_ptl;
 
 	/*
@@ -827,7 +867,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
 	 * Release both raw and compound pages isolated
 	 * in __collapse_huge_page_isolate.
 	 */
-	release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
+	release_pte_pages(pte, pte + nr_pages, compound_pagelist);
 }
 
 /*
@@ -847,16 +887,17 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
  */
 static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
 		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
-		unsigned long address, spinlock_t *ptl,
+		unsigned long address, spinlock_t *ptl, unsigned int order,
 		struct list_head *compound_pagelist)
 {
+	const unsigned long nr_pages = 1UL << order;
 	unsigned int i;
 	enum scan_result result = SCAN_SUCCEED;
 
 	/*
 	 * Copying pages' contents is subject to memory poison at any iteration.
 	 */
-	for (i = 0; i < HPAGE_PMD_NR; i++) {
+	for (i = 0; i < nr_pages; i++) {
 		pte_t pteval = ptep_get(pte + i);
 		struct page *page = folio_page(folio, i);
 		unsigned long src_addr = address + i * PAGE_SIZE;
@@ -875,10 +916,10 @@ static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *foli
 
 	if (likely(result == SCAN_SUCCEED))
 		__collapse_huge_page_copy_succeeded(pte, vma, address, ptl,
-						    compound_pagelist);
+						    order, compound_pagelist);
 	else
 		__collapse_huge_page_copy_failed(pte, pmd, orig_pmd, vma,
-						 compound_pagelist);
+						 order, compound_pagelist);
 
 	return result;
 }
@@ -1051,16 +1092,20 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
  * Bring missing pages in from swap, to complete THP collapse.
  * Only done if khugepaged_scan_pmd believes it is worthwhile.
  *
+ * For mTHP orders the function bails on the first swap entry, because
+ * faulting pages back in during collapse could re-populate PTEs that
+ * push a later scan over the threshold for a higher-order collapse.
+ *
  * Called and returns without pte mapped or spinlocks held.
  * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
  */
 static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long start_addr, pmd_t *pmd,
-		int referenced)
+		struct vm_area_struct *vma, unsigned long start_addr,
+		pmd_t *pmd, int referenced, unsigned int order)
 {
 	int swapped_in = 0;
 	vm_fault_t ret = 0;
-	unsigned long addr, end = start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
+	unsigned long addr, end = start_addr + (PAGE_SIZE << order);
 	enum scan_result result;
 	pte_t *pte = NULL;
 	spinlock_t *ptl;
@@ -1092,6 +1137,19 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 		    pte_present(vmf.orig_pte))
 			continue;
 
+		/*
+		 * TODO: Support swapin without leading to further mTHP
+		 * collapses. Currently bringing in new pages via swapin may
+		 * cause a future higher order collapse on a rescan of the same
+		 * range.
+		 */
+		if (!is_pmd_order(order)) {
+			pte_unmap(pte);
+			mmap_read_unlock(mm);
+			result = SCAN_EXCEED_SWAP_PTE;
+			goto out;
+		}
+
 		vmf.pte = pte;
 		vmf.ptl = ptl;
 		ret = do_swap_page(&vmf);
@@ -1212,7 +1270,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
 		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
-						     referenced);
+						     referenced, HPAGE_PMD_ORDER);
 		if (result != SCAN_SUCCEED)
 			goto out_nolock;
 	}
@@ -1260,6 +1318,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
 	if (pte) {
 		result = __collapse_huge_page_isolate(vma, address, pte, cc,
+						      HPAGE_PMD_ORDER,
 						      &compound_pagelist);
 		spin_unlock(pte_ptl);
 	} else {
@@ -1290,6 +1349,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 
 	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
 					   vma, address, pte_ptl,
+					   HPAGE_PMD_ORDER,
 					   &compound_pagelist);
 	pte_unmap(pte);
 	if (unlikely(result != SCAN_SUCCEED))
@@ -1325,9 +1385,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long start_addr,
 		bool *lock_dropped, struct collapse_control *cc)
 {
-	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
-	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);
-	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc);
+	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
+	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
+	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
 	int none_or_zero = 0, shared = 0, referenced = 0;
@@ -2381,8 +2441,8 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		unsigned long addr, struct file *file, pgoff_t start,
 		struct collapse_control *cc)
 {
-	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL);
-	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc);
+	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
+	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
 	XA_STATE(xas, &mapping->i_pages, start);
-- 
2.54.0


