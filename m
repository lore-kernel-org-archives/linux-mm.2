Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6F70EA71A2
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 18:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7A16B0335; Sun, 19 Apr 2026 14:59:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480246B0339; Sun, 19 Apr 2026 14:59:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E1A6B033B; Sun, 19 Apr 2026 14:59:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 28C126B0335
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 14:59:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB13CC28AF
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 18:59:44 +0000 (UTC)
X-FDA: 84676219488.15.302F802
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id E27804000A
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 18:59:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dZ3c7flO;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776625182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gpiEosJanpfJUaGRhwa4O3aVZ0/wcJYLu3b9XwgPJO4=;
	b=E04i9THygsu7LtlehgSWbZzsu/93z9pe438iNtzK7+8y0IvlxFdhVmaEKE0wtzgXcosQ7c
	t1N5STv0P5nFCQ2yMtAi/0h1gfKJWGAcG5JfnXV2n7Yxyyu9uY4B8Xa09hSj1w+tzqUY/U
	MxNw9JR+xgtm8cBu9dNyt4aQIpQtEnI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dZ3c7flO;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776625182; a=rsa-sha256;
	cv=none;
	b=hrb5GBSOoRVrsmljKO3V4dHvfVInNt0P6K2dA+wPb5He7wTK53O7yO5k9Z8GCA+ppqTlbG
	2WVU5QEqjVuy8iUbFXjEQ6S3EAZR93Fc8FwEGPlD510M59LZZhpq8KYPyl/suBm5ojwCbw
	6X01Nx1MTlY1RYnOfrLffk32Yw8nKmY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776625182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gpiEosJanpfJUaGRhwa4O3aVZ0/wcJYLu3b9XwgPJO4=;
	b=dZ3c7flORNGNKFTMSZa/G98Ht4mlv5tMPj4rNU67xpnh7uZedv5754WloPNzyqzHZ7ndgF
	G9G+K7JuxxAwJ4kzTmyLLRltpPn1Scil72ga2QZ/+x53RU2qgQArrlwZincntPyNeatpRZ
	31L6WSnsT9mU/vXuHmLomHh2gJEj1m8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-1GFAZh2MPuyWxMr9Oe_cQw-1; Sun,
 19 Apr 2026 14:59:40 -0400
X-MC-Unique: 1GFAZh2MPuyWxMr9Oe_cQw-1
X-Mimecast-MFC-AGG-ID: 1GFAZh2MPuyWxMr9Oe_cQw_1776625175
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B84641800345;
	Sun, 19 Apr 2026 18:59:33 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.74.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E18C9195608E;
	Sun, 19 Apr 2026 18:59:15 +0000 (UTC)
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
	Liam.Howlett@oracle.com,
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
Subject: [PATCH 7.2 v16 03/13] mm/khugepaged: rework max_ptes_* handling with helper functions
Date: Sun, 19 Apr 2026 12:57:40 -0600
Message-ID: <20260419185750.260784-4-npache@redhat.com>
In-Reply-To: <20260419185750.260784-1-npache@redhat.com>
References: <20260419185750.260784-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6impoAMgO0IzFj6JtRm_qLPXH7ijk3Ot2ys43dDKe18_1776625175
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: xsz7ygccr9we9y8pocy64ksj87zzbfwm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E27804000A
X-HE-Tag: 1776625182-546780
X-HE-Meta: U2FsdGVkX187qMqqaIdNd3zmJVkRZCqN7kj2xU9OoZaIPQmriuYdwpo/3K53VpXVC6oJdSygDbuK2F1zpQmEjgZDA3JGRc7JlfJG2kLsKM3MNx2V4pxRvDeGTSzWGP/CTRGHaP0f5Y677yPnvqWiVZ46VMp9zaikoVVNhjklH6Lp/+qlM2/vZ+aTZbT+xBKisdwZ8WsIKWhowJ6D3ZmmEu9SQFAsjlSqEs7foExIUXoyRAyilP9dgY78j930cYS9qAJlY6rk+RLhF0YuKtSMrW9UzwcJ/chD1z9sewOC/IcvqUIUqnyn0M8GBwdfMzuQNA64HSImef5eq6ado4DdR7ozZxQsF2F99x8e5ssDMlFlLLAaleKaFpxTVg1BxcOhEnGm1PiCLlJkpDDDAnQe8c5yfGwbPzHr9wRHbbOuQ3jTTLHhKD/A/WRwyyVZoR1wlAFeW3zY3a/EXNFbw078XDVRa12joS34mAJIotMz6CA0y9p5F/+ImAM+57ZVJu6Pb/VkrHh3eTtDsj4CC5mb7+PhFGKiEnluYByL2XYDMB53SZif4yxs4fR9ik/Qh+8hdlFbfmzc2D+TK1lp+lVRQFJoH3gsbyM1PWC0rPpyL58WbBHohtGMUnwNuRRDLtNA9XG3IlBprdHXrR2d2N/c+Fy2n52qlB6lIY8Ii35bm4Tb1KCGYCRK7maqaRhdGfaPvv6N1oC4Szo9nkHNndc2AmUc4Kk6YNiivVkckrFU5CiPeiS3YlIKx26zoOXdQ/qAZWhOEG79EPJfHeCWIV+OS3S0b8bEDXh4p4aDjp4vgFPIyfCKPrbxxofSt0WPRdinw9i3qpiBSk3AwwKKr5vJd9VQSOK1x5GUApIr99TcOZrHPBdBhpc8bgUDCHIrK6PRMy3mN3Gvus305Y+NE6h3Vd+ZUAS/GYF/1VZZRVV+Wzp1HmEwtC8Fqk94nC4KwdCQNtZBENF5xXqMHdjrVcL
 PWGsOyS5
 jDaf2erVR9c/MG/abJfQp7W0Z/wbPmJcTMnpQ4+2+invSuznu/L4J/PflNJQvbyJCdkBAGz90A8R+v3l/C4jzvz5dNh7JuleoZv77oBkjY24AW1EQKB/uHPZSsQxFvEj+mVGJZWqsWuoYe+othpBTYz2brgqofPPoFSppprfxmhMLFKce+Nc5KP4s373vrJAwRQln5Z7YCv5ZVTPLqoxdBMHIZ9g+E92gUobLx5zApk8gq0OomQtQ2kydzI4pLz528zZqeyg0A0ddtrf+YIi4MsI6b3OSPGdJJcd66p+QWRR62OYcrQnIEHOnyrFsnxe+XPfrx97kjx5rtHsitgPInSB9dmD6ni00Xo3QBeXu41WbiB9C3DgJIdQk0Nmcsa5crn3n8QDO+4jlxG87oL75m21SzDl8844YhdxZtRJBKLBcCT/9dmthOOqNK3z7lDIKSDszJHZWGR76z5mvAZnx2BNbubjXtouXiaOz
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
will later in this series to cleanly restrict mTHP collapses behaviors.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 114 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 78 insertions(+), 36 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index afac6bc4e76d..f42b55421191 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -348,6 +348,58 @@ static bool pte_none_or_zero(pte_t pte)
 	return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
 }
 
+/**
+ * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
+ * @cc: The collapse control struct
+ * @vma: The vma to check for userfaultfd
+ *
+ * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
+ * empty page.
+ *
+ * Return: Maximum number of empty PTEs allowed for the collapse operation
+ */
+static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
+		struct vm_area_struct *vma)
+{
+	if (vma && userfaultfd_armed(vma))
+		return 0;
+	if (!cc->is_khugepaged)
+		return HPAGE_PMD_NR;
+	return khugepaged_max_ptes_none;
+}
+
+/**
+ * collapse_max_ptes_shared - Calculate maximum allowed shared PTEs for collapse
+ * @cc: The collapse control struct
+ *
+ * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
+ * shared page.
+ *
+ * Return: Maximum number of shared PTEs allowed for the collapse operation
+ */
+static unsigned int collapse_max_ptes_shared(struct collapse_control *cc)
+{
+	if (!cc->is_khugepaged)
+		return HPAGE_PMD_NR;
+	return khugepaged_max_ptes_shared;
+}
+
+/**
+ * collapse_max_ptes_swap - Calculate maximum allowed swap PTEs for collapse
+ * @cc: The collapse control struct
+ *
+ * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
+ * swap page.
+ *
+ * Return: Maximum number of swap PTEs allowed for the collapse operation
+ */
+static unsigned int collapse_max_ptes_swap(struct collapse_control *cc)
+{
+	if (!cc->is_khugepaged)
+		return HPAGE_PMD_NR;
+	return khugepaged_max_ptes_swap;
+}
+
 int hugepage_madvise(struct vm_area_struct *vma,
 		     vm_flags_t *vm_flags, int advice)
 {
@@ -546,21 +598,19 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -591,9 +641,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 
 		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
-			++shared;
-			if (cc->is_khugepaged &&
-			    shared > khugepaged_max_ptes_shared) {
+			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
 				goto out;
@@ -1270,6 +1318,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	unsigned long addr;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
+	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
+	unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);
+	unsigned int max_ptes_swap = collapse_max_ptes_swap(cc);
 
 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
 
@@ -1294,36 +1345,29 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 
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
@@ -1366,9 +1410,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
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
@@ -2329,6 +2371,8 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	int present, swap;
 	int node = NUMA_NO_NODE;
 	enum scan_result result = SCAN_SUCCEED;
+	unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL);
+	unsigned int max_ptes_swap = collapse_max_ptes_swap(cc);
 
 	present = 0;
 	swap = 0;
@@ -2341,8 +2385,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 
 		if (xa_is_value(folio)) {
 			swap += 1 << xas_get_order(&xas);
-			if (cc->is_khugepaged &&
-			    swap > khugepaged_max_ptes_swap) {
+			if (swap > max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
 				break;
@@ -2413,8 +2456,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		cc->progress += HPAGE_PMD_NR;
 
 	if (result == SCAN_SUCCEED) {
-		if (cc->is_khugepaged &&
-		    present < HPAGE_PMD_NR - khugepaged_max_ptes_none) {
+		if (present < HPAGE_PMD_NR - max_ptes_none) {
 			result = SCAN_EXCEED_NONE_PTE;
 			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 		} else {
-- 
2.53.0


