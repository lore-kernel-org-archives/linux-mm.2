Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7946CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:14:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B0CF6B0093; Fri,  5 Jun 2026 12:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 187DA6B0096; Fri,  5 Jun 2026 12:14:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09DF16B0098; Fri,  5 Jun 2026 12:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F158F6B0093
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:14:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7D008C6BB
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:14:51 +0000 (UTC)
X-FDA: 84846357582.17.8E2E356
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id B09A2180006
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:14:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T0f80VaJ;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780676089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EvMkx3xZvi80w/qjjymYzAQzqCCVHeJf6pT43rxuucw=;
	b=veaAYkVSdGzxM55/LjdowarDmHgy6ndIVjyFnh7pE+onfr1wZYZyTyc5PV831tL+ItAn9O
	U3m9k16Rg6qhzRNYMwQXT8VvkhKBVGC/VktcJA3lqEw4gr9dF04EYFjeKrgQOXLMo7EZ8x
	JsS39fuK7FaqAyxby13XWQhf31p0xl0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T0f80VaJ;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780676089;
	b=pv11RyeBh0oMTlqUT4evExQ60F9i2WNtfa2izmq9dTIu41sGpbfLNzNITt8/yWNZgKIEPn
	yxa9gpUUEK6ItjtXVPsDyNRr6cMjHaHbzIxpTJOra0teDq5nJVFdipNIR2j10CvzIsRS09
	V3LTZHvJHSKE23cPj0tg9FI8CIDxEbI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780676089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EvMkx3xZvi80w/qjjymYzAQzqCCVHeJf6pT43rxuucw=;
	b=T0f80VaJBcTG18cU7kZsfd6vwAg9K5BAyt3wheBffRE6bAdObSqoBOF6zilGev6IbYQkIS
	NghgCf5+fqF3+B+PWq9oPp1phonNTCMhAU4jiHez+W3ReK1X/fWSvjnBWWv+rSHQWZvQpD
	ljoU5Rj8E6lMskqiBHoKYX0AEhLwu6k=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-676-avf4wy-xOd6ITTKikW6dEA-1; Fri,
 05 Jun 2026 12:14:47 -0400
X-MC-Unique: avf4wy-xOd6ITTKikW6dEA-1
X-Mimecast-MFC-AGG-ID: avf4wy-xOd6ITTKikW6dEA_1780676082
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0DDE8195609D;
	Fri,  5 Jun 2026 16:14:42 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.9])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8200F1800351;
	Fri,  5 Jun 2026 16:14:23 +0000 (UTC)
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
Subject: [PATCH mm-unstable v19 03/14] mm/khugepaged: rework max_ptes_* handling with helper functions
Date: Fri,  5 Jun 2026 10:14:10 -0600
Message-ID: <20260605161422.213817-4-npache@redhat.com>
In-Reply-To: <20260605161422.213817-1-npache@redhat.com>
References: <20260605161422.213817-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: c_aP18xRkMTsNRu-1aEvqlFQ3dt4DvLi2__OMWldq2U_1780676082
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B09A2180006
X-Stat-Signature: oc7trs4fa77mzqhcdxp16ha6frzsquj5
X-Rspam-User: 
X-HE-Tag: 1780676089-145884
X-HE-Meta: U2FsdGVkX1+9nkTmqLnKLVkyTrRBhcVVeAPJu2lqtGpktz4CDeDAxyt9J3DJafPGxDW16H1duyM7zgGBVvrsl39Gla6hAlwIWbtVSBI8jLvTXzxt/AA/11F07SPFGQAZ+qm7+JitqamBOu0UTZooh3H9IomZfuGrmgkC6xWAAWo3/lfLGv2JmzngqRhNYmPuxJFpR29w4pKKDv6rgcPAM2KbVmjvIrCI2NBrqp3GXSFXc6PAKajdjC6VNWk9Xj77H2zJKUbVpEsXowvdrTp0rVskL7Rk5J3YpOlsi07Vw/nmd4LOkjGlPLKt4QrIAVQQNkb4tYW1qf3wqXE7Pky/sSXO1Wx/G5KkC9SzD8Z7qfcN55C/LNtX2gd8UlbszI15nV6TVohUnr1YDNLhT5ktVyLaFzvsJ9Q9+OeZNKvkdccu7It9IzohWX8YUJu6RUx+0AUp/fADzMJiC3JmQm/CcAS7K9mk9fmhajU2alTjixoPltQHnx/tnpL5RQS0MOVt/07vC7O0WmhkTtOaA4CR2/BtZpPNDenrjRhfBABEDCX23iOjP92ZDSK6kFFjdbwlK4/nCZNDSy0nSVjjr+Hn6qUtVWZA+5a6WI8QqDLxilgdPB1SePf2iRsbwX7lPN1iRiuDgtY5yAAjylAcdRtLo95LAuaga0ehlbjH71gFBDp5hI+18Y9iPtyRMJNXl6zvsgbc7BBbfl6F2keugOLXco/hqhHPiI5XcSD6fl37yhqyi4OtuGPE5CLpPqvgJXegoF+PQD5v0TtsO0fncz9gS8qXhHQrMm2a0rVMmFZQqsHr2UXbdZ9BRI52VEsNQi4fVxpwrX1qFR087RWzV6riRVRcrd+78p3FLoCNKhRAuFXHJjIy4aD+vlkG1PZhMStYeovBcACuSSiG74bQm4j+TxmnDFR8ywKS2kJdWlJ9NvF55LYxiJLt4SJp6QKkiErG7FViic0QuUbw7YKEjPA
 MHj40zIk
 /5/UJd1WGJ3WN1sg8CpbLj38QFz5i6ExMDvB3Ttp/5EPutLqMNQry1U8n+jcFsvy0/eWKxBosG94ImkZhStJVs5oSYp23tWZDaqiRPi5khlrSI6GgCwPOIeJ6LgTVISa/tFrFsEnhr6nYpTlJbxc89FIRyq7cpPzF8C+7WNFx8MBjbUniIW8hn+8Vuj7z6k7u7I9o+apPq7E/bU4iG23NtswErhOpkiTjuJv33FkE1Jm3wVvhyNaAx7td0Dwor1r3dMKs3HECgZRpUEc8Z0qWNxzsFoeS7XWnvXQxJleshDGBloBIAsULtjB7BvRG0bOLYm1Tz9leza2fpoFVwHAAj2OmUJhFsf3loE/0yQD9gJuLoqH9uoU8fDZhkXDjBYPTv8JZLlZ3DJpCiWtnSUF2RiEv/v15h1ve5ufUfXUPa5I0/4RBBZLbcJC8kz+ZTk3i5ozBA+ropVQ4tu2x58SyUo0NRY9DufY5dG0vFuJURkZRZpncjb6HTQL2zcFlF97t11N7
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

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 120 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 84 insertions(+), 36 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 44564c179636..f56ab049a6c4 100644
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
@@ -543,6 +601,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
 		struct list_head *compound_pagelist)
 {
+	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
+	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr = start_addr;
@@ -554,16 +614,12 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -594,9 +650,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 
 		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
-			++shared;
-			if (cc->is_khugepaged &&
-			    shared > khugepaged_max_ptes_shared) {
+			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
 				goto out;
@@ -1271,6 +1325,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long start_addr,
 		bool *lock_dropped, struct collapse_control *cc)
 {
+	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
+	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);
+	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc);
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
 	int none_or_zero = 0, shared = 0, referenced = 0;
@@ -1304,36 +1361,29 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 
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
@@ -1376,9 +1426,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
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
@@ -2333,6 +2381,8 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		unsigned long addr, struct file *file, pgoff_t start,
 		struct collapse_control *cc)
 {
+	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL);
+	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc);
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
 	XA_STATE(xas, &mapping->i_pages, start);
@@ -2351,8 +2401,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 
 		if (xa_is_value(folio)) {
 			swap += 1 << xas_get_order(&xas);
-			if (cc->is_khugepaged &&
-			    swap > khugepaged_max_ptes_swap) {
+			if (swap > max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
 				break;
@@ -2423,8 +2472,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
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


