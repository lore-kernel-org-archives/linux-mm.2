Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFEFB103A9BD
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 11:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340AB6B00A0; Wed, 25 Mar 2026 07:42:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318426B00A1; Wed, 25 Mar 2026 07:42:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22D7A6B00A2; Wed, 25 Mar 2026 07:42:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2F36B00A0
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:42:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C869DC2C48
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:42:25 +0000 (UTC)
X-FDA: 84584397450.23.DE8B32A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id A8AE11A000A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:42:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mm9WctAf;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774438943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z1MDwPOYvrNEQr38Y1Sv348va0swjyz4GDrr6XYek3Q=;
	b=d8Z/c+lulgKHVx/Xi2HRkGuStTBXaN6gXPyu/jIK3nlNy61tra1wUSd5KXD97Uq4EFdb/9
	ts0pJ987HUFguix7Zerpl2UI2qkmy48oiG1jg7A4DcCkRwYG/PmnFqFi4JptfEToR0IV7U
	l5ZtrHLsKSdERFAOfBpu8Q70CzsE0gQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774438943; a=rsa-sha256;
	cv=none;
	b=yEe0Euxpsx2/mAQMJdDHFjf5nhLwM0deFY+AMaNQ1l7g/qsvm29U0DDV1VdC3TBhQmVp2c
	xI3etISk6dzEBgJBD4SUdax2s4wynaHoXOnjxSjPpjK1C7q8Wk/MjydA5wOozPW/rZP5dz
	cqAUOTRyakgxHAhWK58kPVozoJJ4XXA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mm9WctAf;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774438943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z1MDwPOYvrNEQr38Y1Sv348va0swjyz4GDrr6XYek3Q=;
	b=Mm9WctAfSk149E4yM5hLEmKVaWKrVJOI5e1u9AaizTrf2EGp5rOJObmIinjoD6l/+NxVlW
	TGfHqyXwxtN5SH6uaiH19sLF8VlFu7dTMJeOrqzzf7du5wUPw9oLYN+Z5Y86TzOwxsbYIr
	jZizYRXiaElirLehxD/YPMhaBXTM7YA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-444-GA7sjDg7MDGSRm1vZKJKqA-1; Wed,
 25 Mar 2026 07:42:13 -0400
X-MC-Unique: GA7sjDg7MDGSRm1vZKJKqA-1
X-Mimecast-MFC-AGG-ID: GA7sjDg7MDGSRm1vZKJKqA_1774438928
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A9D6195609F;
	Wed, 25 Mar 2026 11:42:08 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.2.14.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 193B21800576;
	Wed, 25 Mar 2026 11:41:50 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
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
	jackmanb@google.com,
	jack@suse.cz,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
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
Subject: [PATCH mm-unstable v4 4/5] mm/khugepaged: rename hpage_collapse_* to collapse_*
Date: Wed, 25 Mar 2026 05:40:21 -0600
Message-ID: <20260325114022.444081-5-npache@redhat.com>
In-Reply-To: <20260325114022.444081-1-npache@redhat.com>
References: <20260325114022.444081-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fTXmy_Xa_K9rucw2nJ2X0f_FJ9r6F6VX_RDOoiZl9ek_1774438928
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Stat-Signature: kfsagnsawrrj6qqscni3mbjz4t4d9qs9
X-Rspamd-Queue-Id: A8AE11A000A
X-Rspam-User: 
X-HE-Tag: 1774438943-174958
X-HE-Meta: U2FsdGVkX19xMv+QA75AyS7+vdOtUhxXbT0WHXtL9BE1Q/cQ/eZuI7Yxl93QYIQ/p0wDLQfOH2XoYu/GCbNO2pRHmLbsmLojmJIB//SD9ir+/LxAy72lHLSFpOXe7eQY+q0OC/gTga5m9+JT9ahjrX74XT6fR7bawOq/mOmX8CpgZZSNwA77v5KtVwkmc4ILOMDOzSSBfWenvieirE9IzdelKLeABpdljQ/RGJs0TsSek/Z4gbXJibr7U74sWoAVIGTayijG9aY4Synx4yD1D+1yAICGpEHmzEBpitq7BjHyg22npAG20vivGgknSScLc4Xi5mVuux9dw3iM/oVSplp1wMDppbDtu+wLRL53dtnDVX23vE2eK+bAjyOPoAuQHCT628of88XSJezOaTvJdaWwu3QWYfzXChDZQYxVvbyuRSF0wghFqcRnhCOFaWQJWoTVrLWdE8IPKQyxNk/H2CdWC1xtdSgXdnrIfDoeuWlJHxBsOF0fsajn9nIjzd3VpMpwmDdgcioij6scieO3eJVZa24kTUnoaqjC0HVkvzLFhEOeCQX9QdENbuFkfQDFbx52a9lkK9ilgzauFUiuuwW7ey9G9RbIA84S9etV0jGYr9wW8yEnx23pZupiMoy5lPJcw6CI6hFgWPafV5MpR45iUT5fdaV43qjPI/iGCsBx/atGEd5iXtd3F60MsR+A06OEsWPF95frcDI48N0DTWPkpF9LoV3jJ1MMVgNlBk5Swv6ve4lVgzlr+mQHGX4C7wCVRWD5GSXnu1oCai/8X+084NGTqOoM5a2Qim3AvkBo6+muL+662Eeo5PjFrB4AAD0Kgfp2/zxf3RGWZAttBCJMHZZlzsxKN/jTTdrh6pFj5tjIALY4nKILh09XWr/Qst6TZ4Jcmq7IBUZPWtox74mqpknx99Vj7JSsZXed0UAIb1/0UvR5W9qHdVnIRF0EjcZ+ch16878wfR7L9jJ
 Q+ZMDwVm
 exc0KN0GU2uZ4VF1CJ9/6mzqygDnlwX1iWDlWGnBm7vJ5q285quu3kmaUc0KpSvn8ce8GvDEGw9cwFPb5IRXGJjxCjPpjZ5da6G4M9XnU3kY6e9Hv9/ia2/RwPJnykLKS4Nga2u9zzkh00eq9B7BY462gP80HX1zRmRBPHd63PFNfRsUcZBaQfNXJC9GsXYeZ7fZBH8JLMNT4oFRkytKtqUm+9tCCl4bABA1RqFpiQfiz9bwOqrKTbamy8uxGGX9rzrwuamP37SKGb9NTqadaXJ1ih6ZmXgj1v4aYzkz8kq/brP7JB4m4psbIauQ2quPfEsZBncMGhnTu38UfXkvBeeOf7AYOkckLOurn8vwkFXt7BFmLuwKMyxmSVtzdA7BVu9EQwj91er6Rh+8WzU2574IfwPnhpwKvRkQswfwVLCT+B9HWZtGls0u/d5nDNUUN9Hs0AXHgSzbgldMsDiSJcwVbyq3C4vnBAetHGCgZKtUQFhaI3vxzyuQ9lgvm9JJZ6sSEerLNU+W1NYe6YjHLPe4j0E0OwU/eI59zIJD4FIG7abC5WtYkTiVJuOhqAyM+3m9LkOfDJp31aHIttZjgwpWnRzcYxwK1eYJkp1Y3XtoM7oHcYqBMoR22ApC0xY2mSRVi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hpage_collapse functions describe functions used by madvise_collapse
and khugepaged. remove the unnecessary hpage prefix to shorten the
function name.

Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 60 ++++++++++++++++++++++++-------------------------
 mm/mremap.c     |  2 +-
 2 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index c9c17bfccf0d..3728a2cf133c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -395,14 +395,14 @@ void __init khugepaged_destroy(void)
 	kmem_cache_destroy(mm_slot_cache);
 }
 
-static inline int hpage_collapse_test_exit(struct mm_struct *mm)
+static inline int collapse_test_exit(struct mm_struct *mm)
 {
 	return atomic_read(&mm->mm_users) == 0;
 }
 
-static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
+static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
 {
-	return hpage_collapse_test_exit(mm) ||
+	return collapse_test_exit(mm) ||
 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }
 
@@ -436,7 +436,7 @@ void __khugepaged_enter(struct mm_struct *mm)
 	int wakeup;
 
 	/* __khugepaged_exit() must not run from under us */
-	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
+	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
 	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
 		return;
 
@@ -490,7 +490,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 	} else if (slot) {
 		/*
 		 * This is required to serialize against
-		 * hpage_collapse_test_exit() (which is guaranteed to run
+		 * collapse_test_exit() (which is guaranteed to run
 		 * under mmap sem read mode). Stop here (after we return all
 		 * pagetables will be destroyed) until khugepaged has finished
 		 * working on the pagetables under the mmap_lock.
@@ -589,7 +589,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			goto out;
 		}
 
-		/* See hpage_collapse_scan_pmd(). */
+		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
 			++shared;
 			if (cc->is_khugepaged &&
@@ -840,7 +840,7 @@ static struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 };
 
-static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
+static bool collapse_scan_abort(int nid, struct collapse_control *cc)
 {
 	int i;
 
@@ -875,7 +875,7 @@ static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
 }
 
 #ifdef CONFIG_NUMA
-static int hpage_collapse_find_target_node(struct collapse_control *cc)
+static int collapse_find_target_node(struct collapse_control *cc)
 {
 	int nid, target_node = 0, max_value = 0;
 
@@ -894,7 +894,7 @@ static int hpage_collapse_find_target_node(struct collapse_control *cc)
 	return target_node;
 }
 #else
-static int hpage_collapse_find_target_node(struct collapse_control *cc)
+static int collapse_find_target_node(struct collapse_control *cc)
 {
 	return 0;
 }
@@ -913,7 +913,7 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
 				 TVA_FORCED_COLLAPSE;
 
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
 
 	*vmap = vma = find_vma(mm, address);
@@ -984,7 +984,7 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
 
 /*
  * Bring missing pages in from swap, to complete THP collapse.
- * Only done if hpage_collapse_scan_pmd believes it is worthwhile.
+ * Only done if khugepaged_scan_pmd believes it is worthwhile.
  *
  * Called and returns without pte mapped or spinlocks held.
  * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
@@ -1070,7 +1070,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 {
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE);
-	int node = hpage_collapse_find_target_node(cc);
+	int node = collapse_find_target_node(cc);
 	struct folio *folio;
 
 	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
@@ -1255,7 +1255,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	return result;
 }
 
-static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
+static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long start_addr,
 		bool *mmap_locked, struct collapse_control *cc)
 {
@@ -1380,7 +1380,7 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 		 * hit record.
 		 */
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
+		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			goto out_unmap;
 		}
@@ -1446,7 +1446,7 @@ static void collect_mm_slot(struct mm_slot *slot)
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 
-	if (hpage_collapse_test_exit(mm)) {
+	if (collapse_test_exit(mm)) {
 		/* free mm_slot */
 		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
@@ -1801,7 +1801,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		if (find_pmd_or_thp_or_none(mm, addr, &pmd) != SCAN_SUCCEED)
 			continue;
 
-		if (hpage_collapse_test_exit(mm))
+		if (collapse_test_exit(mm))
 			continue;
 
 		if (!file_backed_vma_is_retractable(vma))
@@ -2317,7 +2317,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
-static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
+static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		unsigned long addr, struct file *file, pgoff_t start,
 		struct collapse_control *cc)
 {
@@ -2370,7 +2370,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 		}
 
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
+		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			folio_put(folio);
 			break;
@@ -2424,7 +2424,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 	return result;
 }
 
-static void khugepaged_scan_mm_slot(unsigned int progress_max,
+static void collapse_scan_mm_slot(unsigned int progress_max,
 		enum scan_result *result, struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
 	__acquires(&khugepaged_mm_lock)
@@ -2458,7 +2458,7 @@ static void khugepaged_scan_mm_slot(unsigned int progress_max,
 		goto breakouterloop_mmap_lock;
 
 	cc->progress++;
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(collapse_test_exit_or_disable(mm)))
 		goto breakouterloop;
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
@@ -2466,7 +2466,7 @@ static void khugepaged_scan_mm_slot(unsigned int progress_max,
 		unsigned long hstart, hend;
 
 		cond_resched();
-		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
+		if (unlikely(collapse_test_exit_or_disable(mm))) {
 			cc->progress++;
 			break;
 		}
@@ -2488,7 +2488,7 @@ static void khugepaged_scan_mm_slot(unsigned int progress_max,
 			bool mmap_locked = true;
 
 			cond_resched();
-			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+			if (unlikely(collapse_test_exit_or_disable(mm)))
 				goto breakouterloop;
 
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
@@ -2501,12 +2501,12 @@ static void khugepaged_scan_mm_slot(unsigned int progress_max,
 
 				mmap_read_unlock(mm);
 				mmap_locked = false;
-				*result = hpage_collapse_scan_file(mm,
+				*result = collapse_scan_file(mm,
 					khugepaged_scan.address, file, pgoff, cc);
 				fput(file);
 				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
 					mmap_read_lock(mm);
-					if (hpage_collapse_test_exit_or_disable(mm))
+					if (collapse_test_exit_or_disable(mm))
 						goto breakouterloop;
 					*result = try_collapse_pte_mapped_thp(mm,
 						khugepaged_scan.address, false);
@@ -2515,7 +2515,7 @@ static void khugepaged_scan_mm_slot(unsigned int progress_max,
 					mmap_read_unlock(mm);
 				}
 			} else {
-				*result = hpage_collapse_scan_pmd(mm, vma,
+				*result = collapse_scan_pmd(mm, vma,
 					khugepaged_scan.address, &mmap_locked, cc);
 			}
 
@@ -2547,7 +2547,7 @@ static void khugepaged_scan_mm_slot(unsigned int progress_max,
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm, or THP got disabled.
 	 */
-	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
+	if (collapse_test_exit_or_disable(mm) || !vma) {
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
@@ -2600,7 +2600,7 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 			pass_through_head++;
 		if (khugepaged_has_work() &&
 		    pass_through_head < 2)
-			khugepaged_scan_mm_slot(progress_max, &result, cc);
+			collapse_scan_mm_slot(progress_max, &result, cc);
 		else
 			cc->progress = progress_max;
 		spin_unlock(&khugepaged_mm_lock);
@@ -2845,8 +2845,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_read_unlock(mm);
 			mmap_locked = false;
 			*lock_dropped = true;
-			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
-							  cc);
+			result = collapse_scan_file(mm, addr, file, pgoff, cc);
 
 			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
 			    mapping_can_writeback(file->f_mapping)) {
@@ -2860,8 +2859,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			}
 			fput(file);
 		} else {
-			result = hpage_collapse_scan_pmd(mm, vma, addr,
-							 &mmap_locked, cc);
+			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, cc);
 		}
 		if (!mmap_locked)
 			*lock_dropped = true;
diff --git a/mm/mremap.c b/mm/mremap.c
index 8566e32d58d9..e9c8b1d05832 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -244,7 +244,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
 		goto out;
 	}
 	/*
-	 * Now new_pte is none, so hpage_collapse_scan_file() path can not find
+	 * Now new_pte is none, so collapse_scan_file() path can not find
 	 * this by traversing file->f_mapping, so there is no concurrency with
 	 * retract_page_tables(). In addition, we already hold the exclusive
 	 * mmap_lock, so this new_pte page is stable, so there is no need to get
-- 
2.53.0


