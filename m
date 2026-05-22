Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41E86CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB2106B00A8; Fri, 22 May 2026 11:01:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A87026B00A9; Fri, 22 May 2026 11:01:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 975F86B00AA; Fri, 22 May 2026 11:01:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 852636B00A8
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:01:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5DC50A0851
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:01:24 +0000 (UTC)
X-FDA: 84795369288.01.D684876
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3AB2440003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:01:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="TaZbv/Yy";
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fa/Gaz+NinmF5bVjQvZOYPcNSZJlWDzxMP88dBY3py8=;
	b=XOm9yCeGi6oE0CMiJuESeebt5JyQohm2Uo6P1LOSI+yLQER33pt2i2/az0qGF1PsCK5Jfn
	jeoeN9WCpd17cfS2osTT4/rUCigHhIRWLUpaFzN5Pgqu2B11aOm+zF+eD6yKw75Bfo2AbN
	oejEOYsfIIngpRuZJq4PcIpoTxqnjOU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="TaZbv/Yy";
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462082; a=rsa-sha256;
	cv=none;
	b=dBkEUHDxuoXJDwoozE4QUabvvIlUZHA6unEEpl8IUycvHNv2owtq6QUvKxJzbEboewniRB
	ZxxXeSWduMsSJZp3+jNEl8+Q3KK8VhHnjKSqBJKzKzerey7Dl+rL+++/fRukMhqOWII8Jh
	JDwN99oB1Ubjxf64141c62fSKIV6i3M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779462081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fa/Gaz+NinmF5bVjQvZOYPcNSZJlWDzxMP88dBY3py8=;
	b=TaZbv/Yy7MvasTDKG86J9auKM3xRORgF39wcDSKfsfF3yH4EgmuQz6FZILPjSbA66DHzzJ
	HnQFd5UkTXHL8aYs7hYFvadkzclwoBuNhGENZZCiUT4pvbRSYNWfT7fiYghwyasrapn1l4
	XXPW5iY1ZEV4iyBOb5QSaCchyVRgHJ8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-302-CJ7bnQVJNcquc82b3819aA-1; Fri,
 22 May 2026 11:01:18 -0400
X-MC-Unique: CJ7bnQVJNcquc82b3819aA-1
X-Mimecast-MFC-AGG-ID: CJ7bnQVJNcquc82b3819aA_1779462070
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 249E81800343;
	Fri, 22 May 2026 15:01:10 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.24.8])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6E535180034E;
	Fri, 22 May 2026 15:00:51 +0000 (UTC)
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
Subject: [PATCH mm-unstable v18 04/14] mm/khugepaged: generalize __collapse_huge_page_* for mTHP support
Date: Fri, 22 May 2026 08:59:59 -0600
Message-ID: <20260522150009.121603-5-npache@redhat.com>
In-Reply-To: <20260522150009.121603-1-npache@redhat.com>
References: <20260522150009.121603-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6kwA6TYsGh6IK7fPgvNbjcXkyORuuIDLWyfFrZSl3Lc_1779462070
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3AB2440003
X-Stat-Signature: e9sd8iyf4mus5fnjde6ieyct6956bt64
X-HE-Tag: 1779462082-601203
X-HE-Meta: U2FsdGVkX1/y8WALGg7M9EAqCozskqhlhtHHpMqHv+PQvhvZdGT1xgFPFsa9u3gfE89k+WLhJvw2o4GNasgahyVZlOMU5dvQGCbrshxgU8bfqCT1LDCm2S+FNm0sBUZnbhsZiX/MTUfQ3eKhmeFb2nUGjAeRJMqQOIc9OMy2gt8iFmCYrpl+w8Z35sHhiholgM25QO7tz46gAWp+J277KuZBA/xMJBLgsQ5NNrLQFF2swpZp5xGH6+NyN052LsN+SEv6ml6UkQ+3HMiBK0ADd6zswIbS88kxjKH62IZlR3iJK25sO1mmp7H1vT2JZwrV6Kkyc7zMaypNRmsB2Qz7JkOz4iZw/edCT+GQWfpLvSv2vLVcaVY85AlU9ifo5tPqcRN+3VJiUGhQCqr8TopcOSODNi2USdyUB05Lut4F4wAdNkj8/F5Ps8b7fBVu/X2g+8p5csf4YqWMA3pRXSx7AIfiYcu8OQo8QhJRbwLrGdcnTTK7QGOzs/p7GJLzRZpUmqpNzHdRKeHOjs8rrgNWgHIQ8TeDAb2V9d4TrY7QBZQNttSATkwx2kIUY9pPM/3j5t7TDbG1T3Ktc80dAYZXtAqrCOdhvywqSrZkukVLxhJAc4059SFmrGmmVO/rAun20lwfOV+O7gGEwnZTg7SODUto/UweoZjsOZjzPvyl8PsXKhgA7cIljUULad59pm+jMj8S9vIefL47QGEKntGGOXbvorHWt9PCxDhNa5d+prWXPivX6DHwJ8L5R9bLBadK8B8eb5tleA3HAIHvIkGx5jIP6cHH/IbwlIjCkcZ2oowy1LkjA/yhdimh+/t+a2a5BYZOO0U19nSiq1A1d9h15T9fWNfFR+h7D3stp4GbqwaGtk9fmAC3IraOXZvGN0h3GgJyYpQd4REQNNBN+lkEJGtEZ14aD/q4yXDYpcKZqzLukR2MwycjyssVhMTEeESOjfPhF2DC80H5X/874p+
 cXdl3bXk
 Kf79M6rEEm+Pe7mZWL1sRFmyVmpmbJkxI+VfaG6i+HzbetdR3ZgqlSycw813n57DAvtxaQRLVzrS5ENwS06O+XMzPn91F5jfuuJUOYqOCltnA4glylUM5dLbeFmqBfymg1QgME3SaTHmz7WwE9mrknsFxzS0nNYeQi/5Sc9dvdsr7b0rXhbz+vmAco6JN/SwSkf946We/pRYILGbBkl04WMqn8TC0vbWvC1x0QFsOc7citUXCFBJSGKjrQ0F0ibQRDIbTo3vhoKzrgq9s+oExDN22TP5gccmMOPgtfu6qC3RbdkC0X4HcVGkQ9fbdAhufdeXQwCkpgYEAw+OG9HWGBgfPonXJFLcPOH7h1cL7EO7pdtcNpczvjjMR6pqcYq885HomZP7S3rfPrW036xZaMs9aLoE/bcH6QYMtwu3e2/zvt8PfDn7JUxQWCjVyd3OTAQ6cvwk+TXdZkp+nH7Ft/EpRmLRffrsOiXTY0ZDsI+asekwI97KtNkxK/g==
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

Reviewed-by: Lance Yang <lance.yang@linux.dev>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 121 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 88 insertions(+), 33 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 116f39518948..e98ba5b15163 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -353,30 +353,52 @@ static bool pte_none_or_zero(pte_t pte)
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
+	unsigned int max_ptes_none = khugepaged_max_ptes_none;
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
+	if (!max_ptes_none)
+		return 0;
+	/*
+	 * For mTHP collapse of values other than 0 or KHUGEPAGED_MAX_PTES_LIMIT,
+	 * emit a warning and return 0.
+	 */
+	pr_warn_once("mTHP collapse does not support max_ptes_none values"
+		     " other than 0 or %u, defaulting to 0.\n",
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
@@ -384,6 +406,13 @@ static unsigned int collapse_max_ptes_shared(struct collapse_control *cc)
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
 
@@ -391,11 +420,13 @@ static unsigned int collapse_max_ptes_shared(struct collapse_control *cc)
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
@@ -403,6 +434,10 @@ static unsigned int collapse_max_ptes_swap(struct collapse_control *cc)
 	 */
 	if (!cc->is_khugepaged)
 		return HPAGE_PMD_NR;
+	/* for mTHP collapse do not allow any non-present PTEs or pagecache entries */
+	if (!is_pmd_order(order))
+		return 0;
+	/* for PMD collapse, respect the user defined maximum */
 	return khugepaged_max_ptes_swap;
 }
 
@@ -596,10 +631,11 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 
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
@@ -607,7 +643,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	int none_or_zero = 0, shared = 0, referenced = 0;
 	enum scan_result result = SCAN_FAIL;
 
-	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
+	for (_pte = pte; _pte < pte + nr_pages;
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
@@ -740,18 +776,18 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
+	unsigned long end = address + (PAGE_SIZE << order);
 	struct folio *src, *tmp;
 	pte_t pteval;
 	pte_t *_pte;
 	unsigned int nr_ptes;
 
-	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
+	for (_pte = pte; _pte < pte + nr_pages; _pte += nr_ptes,
 	     address += nr_ptes * PAGE_SIZE) {
 		nr_ptes = 1;
 		pteval = ptep_get(_pte);
@@ -804,11 +840,10 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
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
@@ -824,7 +859,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
 	 * Release both raw and compound pages isolated
 	 * in __collapse_huge_page_isolate.
 	 */
-	release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
+	release_pte_pages(pte, pte + nr_pages, compound_pagelist);
 }
 
 /*
@@ -844,16 +879,17 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
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
@@ -872,10 +908,10 @@ static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *foli
 
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
@@ -1042,16 +1078,20 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
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
@@ -1083,6 +1123,19 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
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
@@ -1203,7 +1256,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
 		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
-						     referenced);
+						     referenced, HPAGE_PMD_ORDER);
 		if (result != SCAN_SUCCEED)
 			goto out_nolock;
 	}
@@ -1251,6 +1304,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
 	if (pte) {
 		result = __collapse_huge_page_isolate(vma, address, pte, cc,
+						      HPAGE_PMD_ORDER,
 						      &compound_pagelist);
 		spin_unlock(pte_ptl);
 	} else {
@@ -1281,6 +1335,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 
 	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
 					   vma, address, pte_ptl,
+					   HPAGE_PMD_ORDER,
 					   &compound_pagelist);
 	pte_unmap(pte);
 	if (unlikely(result != SCAN_SUCCEED))
@@ -1316,9 +1371,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
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
@@ -2372,8 +2427,8 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
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


