Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47EF4FD45FF
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 01:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A34D46B0092; Wed, 25 Feb 2026 20:31:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1AD6B0093; Wed, 25 Feb 2026 20:31:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4936B0095; Wed, 25 Feb 2026 20:31:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7593D6B0092
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:31:33 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F320DC1BAA
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:31:32 +0000 (UTC)
X-FDA: 84484880424.14.2C88939
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id C2A471A0013
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:31:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i+qJsNUG;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772069490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjmlnKZSKDMLLsq1Th3F3GeReir3ptosj+aQfzX72Wk=;
	b=Pa58iB2De8U04T9B30ZHEN+jSCsV/CY77oSLre1R07+KI3po1Ykjc1URbCkK1Fp69e6Hhc
	eixwxPP4q2QWyEATlw3bz4v2oCB1k5d80wMS4s0J8hwgKOpvFtaOwjSs2vtwNmkVb/1Kh6
	BZdMY8QDcWR+Wwo5EGg2A7ObzyCRSNc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772069490; a=rsa-sha256;
	cv=none;
	b=ldS8MsJQZguo0hzI8aCht85igosfijU3ApDrOR+6yYSZqvinw/bXIplwllRjbM5qWORjHY
	jg4FNfXcc91RCLXCspvxQldtWFd6G4jCtvvxonB4Dbvbycs0CbSim4F6FysLBLZEJQVnIX
	sQ8019w8vDv6Llt0gGw71GuxK665xDk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i+qJsNUG;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772069490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TjmlnKZSKDMLLsq1Th3F3GeReir3ptosj+aQfzX72Wk=;
	b=i+qJsNUGNHocr0FgYx4M01AdzeBbrVPq7hfeJll/LoyRqOv9Js3LLh+sA99e2D2z3kHNsR
	t58sqwJc+dfqM2GTBewyIxCokPnoMRN82GbaV8Pn9akAkMKwDQGlJhmFUrw7Ksp+XXXioQ
	D2Vi61URo/rdQBnG7YWZRcXTNIHUYTY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-494-qC4aFXsrOpC77oNg5PKaMg-1; Wed,
 25 Feb 2026 20:31:27 -0500
X-MC-Unique: qC4aFXsrOpC77oNg5PKaMg-1
X-Mimecast-MFC-AGG-ID: qC4aFXsrOpC77oNg5PKaMg_1772069482
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E311E1956089;
	Thu, 26 Feb 2026 01:31:21 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.173])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A826E3003D88;
	Thu, 26 Feb 2026 01:31:10 +0000 (UTC)
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
Subject: [PATCH mm-unstable v2 4/5] mm/khugepaged: rename hpage_collapse_* to collapse_*
Date: Wed, 25 Feb 2026 18:29:28 -0700
Message-ID: <20260226012929.169479-5-npache@redhat.com>
In-Reply-To: <20260226012929.169479-1-npache@redhat.com>
References: <20260226012929.169479-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iBUPd7LH_cE1SLRybzjCrfxxLRFSf7_xnuDIGBcfeN4_1772069482
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam09
X-Stat-Signature: xxkh9xp1jwgjgrm5x1drsn4fnbfsh7k6
X-Rspamd-Queue-Id: C2A471A0013
X-Rspam-User: 
X-HE-Tag: 1772069490-60081
X-HE-Meta: U2FsdGVkX1+QPSijTAq/V7lEodnmMXxgzob4ScqhWRXxfZZ6uh74w8c9BWPdVUSUtUtVK6Uvdvzw74Wsbjnm3eDrKnTEXenlgiICZQeTPLd+dwgKPjBs6FMjzumQtaSC88JYlwAcvy2wHF8MY0liOzvYV8pDVZVnC8Zsgu7f/kBTszTGVKx43QLJtTKZYAvsMrSd41nK00TrHaYoh0P5BNQTigHMBAlqoFj8JjuMjhD61jU7uWwIabDnmUtUhMfqYS77r1UxRlXL4DPVQdajvtnC7GnEBTnSyKhXhLhpfvzUJ+OYtXgmWywLrLHDWJYhS0Iot+x+JjnD7Zv9C4idkdH3qhhDjr4lZ/15rBgNVIASQQjMXspYno8oZL7jNT9kJRd8GglbkMv5yJQckvFsLk5aq3q9JhBNsNjewICOYCAQOn303dmNOIXyrIjIVwsKv3AbWdwSxdWIBVni+N7jNNGZyADiadMw0kQ0AkNNHVHeBj8G7qlh5WqwNevdHh16FTOU/rsF7wgN+5FXO2e4X93YfElZmEaKeniverNvg57asmZtbKk6yQkN1kN7bUd2Fa1m+mMbst75hXUIQ6l+YPNsxscunR8lJyvzljiYWiEIrzDmhIpEH0lX3rmWkuj8cS25WrzK6LpQLrOBQvaPonXx/6SJU/aqS940Fh0qW9tdLG+3BC8+kKtkREI+nZw9URRqzS5hIi0aGLcePdxRN6QnF4ILACHxuqlOGRFsdgFOuF1KMtcQ28wOIZREixooC/N+5zFBEVk88pOqHE7wYfW7J7N7aT60gyFTPIzVSG/x2O3HeZ5/LUcyJxnMTbzMLozhIUNP7hswo+zMl1a7buy4jxgzWJD3yRoLye7ZT/D9StDMj8sOHvBV+uE+P/H3Hv8ZMkIwu+Zee6Ex8LfdjK1aNyMEBAmXvpekA5iFWuEPlkqTfwgYf+L8CQ6m86tNOCTCFrEx5sY/vwsyzaz
 TdC8r7EF
 T18JvOQRkrj9e+e8uNfy2GHLfGMWRuAmMM1NgFIEnoRr/0Fd7myWHCVDFKbfF2WIQcIAwII2lUN2tjTbcw0j8to2xXOg8hMBZNFCY4e3UhPnCXO3D7t4Xa4WbQJ7kIAuAV9tsCnrtY8IcN4ymmk/ijulzkW9gL15MfezaLppCjR8Hz4gFhyDJIGL153RVB82V+TjhrfNSmR7zJMlxTI8m+ma+nXVePBAFlYxTBbnI/bwsHDxd2/2MRfDtcAEimcf16MFeMoCJki+7ufwrUM/IQKVEQyxsURPlCFxwg2ZD3MbjHV/skbgw+rx3POTUelTpEEDfwA04gQZAAC/C0KEOpa+8zTvQp4M+5KWJ31QaxRTz9sdPH1sAtMzNv9+bM6EFlRUh/KZ2boLvNZsfOxuYwThnX4Ju1/uKKsTRwLTwkNOT+AA+RUjJrNTR/sCD0NGN8TlNBazU/gj62yeOvWn700GmBL9baBuR1LLpNBE9jCBfoPXdWpeKJa1d8tyJ2k4IesDRmHri/rC2FlwUcLfgW6NXyl+YmqTLrCOi3OQVkeZ95E4Me7QAPbXgRfoJ3XmsHs2W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hpage_collapse functions describe functions used by madvise_collapse
and khugepaged. remove the unnecessary hpage prefix to shorten the
function name.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 71 +++++++++++++++++++++++--------------------------
 mm/mremap.c     |  2 +-
 2 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4615f34911d1..64086488ca01 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -392,14 +392,14 @@ void __init khugepaged_destroy(void)
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
 
@@ -433,7 +433,7 @@ void __khugepaged_enter(struct mm_struct *mm)
 	int wakeup;
 
 	/* __khugepaged_exit() must not run from under us */
-	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
+	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
 	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
 		return;
 
@@ -487,7 +487,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 	} else if (slot) {
 		/*
 		 * This is required to serialize against
-		 * hpage_collapse_test_exit() (which is guaranteed to run
+		 * collapse_test_exit() (which is guaranteed to run
 		 * under mmap sem read mode). Stop here (after we return all
 		 * pagetables will be destroyed) until khugepaged has finished
 		 * working on the pagetables under the mmap_lock.
@@ -582,7 +582,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			goto out;
 		}
 
-		/* See hpage_collapse_scan_pmd(). */
+		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
 			++shared;
 			if (cc->is_khugepaged &&
@@ -833,7 +833,7 @@ static struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 };
 
-static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
+static bool collapse_scan_abort(int nid, struct collapse_control *cc)
 {
 	int i;
 
@@ -868,7 +868,7 @@ static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
 }
 
 #ifdef CONFIG_NUMA
-static int hpage_collapse_find_target_node(struct collapse_control *cc)
+static int collapse_find_target_node(struct collapse_control *cc)
 {
 	int nid, target_node = 0, max_value = 0;
 
@@ -887,7 +887,7 @@ static int hpage_collapse_find_target_node(struct collapse_control *cc)
 	return target_node;
 }
 #else
-static int hpage_collapse_find_target_node(struct collapse_control *cc)
+static int collapse_find_target_node(struct collapse_control *cc)
 {
 	return 0;
 }
@@ -906,7 +906,7 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
 				 TVA_FORCED_COLLAPSE;
 
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
 
 	*vmap = vma = find_vma(mm, address);
@@ -977,7 +977,7 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
 
 /*
  * Bring missing pages in from swap, to complete THP collapse.
- * Only done if hpage_collapse_scan_pmd believes it is worthwhile.
+ * Only done if khugepaged_scan_pmd believes it is worthwhile.
  *
  * Called and returns without pte mapped or spinlocks held.
  * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
@@ -1063,7 +1063,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 {
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE);
-	int node = hpage_collapse_find_target_node(cc);
+	int node = collapse_find_target_node(cc);
 	struct folio *folio;
 
 	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
@@ -1241,10 +1241,9 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	return result;
 }
 
-static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long start_addr,
-		bool *mmap_locked, unsigned int *cur_progress,
-		struct collapse_control *cc)
+static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
+		unsigned int *cur_progress, struct collapse_control *cc)
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
@@ -1366,7 +1365,7 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 		 * hit record.
 		 */
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
+		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			goto out_unmap;
 		}
@@ -1432,7 +1431,7 @@ static void collect_mm_slot(struct mm_slot *slot)
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 
-	if (hpage_collapse_test_exit(mm)) {
+	if (collapse_test_exit(mm)) {
 		/* free mm_slot */
 		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
@@ -1787,7 +1786,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		if (find_pmd_or_thp_or_none(mm, addr, &pmd) != SCAN_SUCCEED)
 			continue;
 
-		if (hpage_collapse_test_exit(mm))
+		if (collapse_test_exit(mm))
 			continue;
 
 		if (!file_backed_vma_is_retractable(vma))
@@ -2305,9 +2304,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
-static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
-		unsigned long addr, struct file *file, pgoff_t start,
-		unsigned int *cur_progress, struct collapse_control *cc)
+static enum scan_result collapse_scan_file(struct mm_struct *mm, unsigned long addr,
+		struct file *file, pgoff_t start, unsigned int *cur_progress,
+		struct collapse_control *cc)
 {
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
@@ -2362,7 +2361,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 		}
 
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
+		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			folio_put(folio);
 			break;
@@ -2418,7 +2417,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 	return result;
 }
 
-static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result *result,
+static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *result,
 					    struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
 	__acquires(&khugepaged_mm_lock)
@@ -2453,7 +2452,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 		goto breakouterloop_mmap_lock;
 
 	progress++;
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(collapse_test_exit_or_disable(mm)))
 		goto breakouterloop;
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
@@ -2461,7 +2460,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 		unsigned long hstart, hend;
 
 		cond_resched();
-		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
+		if (unlikely(collapse_test_exit_or_disable(mm))) {
 			progress++;
 			break;
 		}
@@ -2484,7 +2483,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 			unsigned int cur_progress = 0;
 
 			cond_resched();
-			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+			if (unlikely(collapse_test_exit_or_disable(mm)))
 				goto breakouterloop;
 
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
@@ -2497,13 +2496,13 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 
 				mmap_read_unlock(mm);
 				mmap_locked = false;
-				*result = hpage_collapse_scan_file(mm,
+				*result = collapse_scan_file(mm,
 					khugepaged_scan.address, file, pgoff,
 					&cur_progress, cc);
 				fput(file);
 				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
 					mmap_read_lock(mm);
-					if (hpage_collapse_test_exit_or_disable(mm))
+					if (collapse_test_exit_or_disable(mm))
 						goto breakouterloop;
 					*result = try_collapse_pte_mapped_thp(mm,
 						khugepaged_scan.address, false);
@@ -2512,7 +2511,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 					mmap_read_unlock(mm);
 				}
 			} else {
-				*result = hpage_collapse_scan_pmd(mm, vma,
+				*result = collapse_scan_pmd(mm, vma,
 					khugepaged_scan.address, &mmap_locked,
 					&cur_progress, cc);
 			}
@@ -2546,7 +2545,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm, or THP got disabled.
 	 */
-	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
+	if (collapse_test_exit_or_disable(mm) || !vma) {
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
@@ -2599,8 +2598,8 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 			pass_through_head++;
 		if (khugepaged_has_work() &&
 		    pass_through_head < 2)
-			progress += khugepaged_scan_mm_slot(pages - progress,
-							    &result, cc);
+			progress += collapse_scan_mm_slot(pages - progress,
+							  &result, cc);
 		else
 			progress = pages;
 		spin_unlock(&khugepaged_mm_lock);
@@ -2844,8 +2843,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_read_unlock(mm);
 			mmap_locked = false;
 			*lock_dropped = true;
-			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
-							  NULL, cc);
+			result = collapse_scan_file(mm, addr, file, pgoff, NULL, cc);
 
 			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
 			    mapping_can_writeback(file->f_mapping)) {
@@ -2859,8 +2857,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			}
 			fput(file);
 		} else {
-			result = hpage_collapse_scan_pmd(mm, vma, addr,
-							 &mmap_locked, NULL, cc);
+			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, NULL, cc);
 		}
 		if (!mmap_locked)
 			*lock_dropped = true;
diff --git a/mm/mremap.c b/mm/mremap.c
index 2be876a70cc0..eb222af91c2d 100644
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


