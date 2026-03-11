Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C4C5103E2E6
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 21:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B4516B0005; Wed, 11 Mar 2026 17:16:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7750D6B0095; Wed, 11 Mar 2026 17:16:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664DA6B0096; Wed, 11 Mar 2026 17:16:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54F526B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:16:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EE9CAC1BEF
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:16:24 +0000 (UTC)
X-FDA: 84535040688.05.F36F96F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0822220009
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:16:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iuY4rTzW;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773263783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IDYpklEEdsJTSjhUXEKel00zIrCM9eNr+xM7I59DXrI=;
	b=2Gd0Hq+ZFXQJmkM3zCvmS5o4pE35snBlvXa3xIqo0IUNXLxyF6yIXj6UTVsCoFKWfvq9g7
	ztOcwFhJDwe3hTzzaw9m/jOGT9mqOJaFHYW+7lDCO/msnZzw20gpmSaYczBGqZ1yfhL64d
	2wps4EsTilL1eX9XIUnh3gJXROV4yJQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iuY4rTzW;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773263783; a=rsa-sha256;
	cv=none;
	b=Ti/NRuKmT7UBRIe3Cr3boFPlC/HLGj/swA9zlQgVt5qxpOPLdDDsFhXmU1NwleiGOULaSf
	aXrLei7FlDHLwYK0jjtgUIqnshdh62/aq1b2Hdp/XB4CRNLtmlXKKzIcGqZT01r3p5deGz
	4fxWfR9HH6GOXxz43mYFZmqR9cklHsA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773263782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IDYpklEEdsJTSjhUXEKel00zIrCM9eNr+xM7I59DXrI=;
	b=iuY4rTzWYssVzux5TBDZYvnFye60anlUBT9BfO1NpRPdpIYf4P4WrWEs7yP7wHOiqzdlHI
	xXW8yI0Hxi60/1qF6i6bHbNkyc6ez3TqA1jQdgLArGlBNLuIThFRg/G9DUEwltLJqrM6i2
	kjms4rDp3inrXNhpKhno0122Koo9iuE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-689-o0I-SxK3Or69ERniAKxhsA-1; Wed,
 11 Mar 2026 17:16:17 -0400
X-MC-Unique: o0I-SxK3Or69ERniAKxhsA-1
X-Mimecast-MFC-AGG-ID: o0I-SxK3Or69ERniAKxhsA_1773263772
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EAC2D1800561;
	Wed, 11 Mar 2026 21:16:11 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.89.69])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1BBF530002D2;
	Wed, 11 Mar 2026 21:16:00 +0000 (UTC)
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
Subject: [PATCH mm-unstable v3 4/5] mm/khugepaged: rename hpage_collapse_* to collapse_*
Date: Wed, 11 Mar 2026 15:13:14 -0600
Message-ID: <20260311211315.450947-5-npache@redhat.com>
In-Reply-To: <20260311211315.450947-1-npache@redhat.com>
References: <20260311211315.450947-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FXesi2BO35Ni2y8B5kACUZWhDlph-9w0bs9azp2J7wc_1773263772
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 0822220009
X-Rspamd-Server: rspam07
X-Stat-Signature: bm9bpj7ez9nwzfrmsn8bn5ktzjju7i3b
X-Rspam-User: 
X-HE-Tag: 1773263782-143163
X-HE-Meta: U2FsdGVkX1+Bo9RkjBMEtFSpbI23DThTCmU4J+L/tI1iQDY3/u+qKJRUi1V+9IgCtXAmrZlVwsrM+/zu69cn4FLsKTZJrBMq1Wcr3MdD2qo9IWpNZ3Wvjl1zwsGL7DsLgw3tMduBAK1xCQyuSbfFs+KQX+fizIRhepQ5yEIx6KeVoAQtUSrvwf7vLp+e1oLqd9JaltLLtzilgRyFV8tNY+KAcj2xvkqsBiK7wlvc7h9LA7kp12q7U6IS7ud5iAAq/l7zYSiFKtlVZnBjnSPj1JIyH7j7K/UPbNaHGA1yvTPG+cnrYp3RK3xl4dOS2VUtNL0B3E6O/fXEQYI0sd0XRlhYM9iNtBnss7lmpCsZymXwA5a/wzGn6/TmsND3lqr0OkBBxIYF+IvrCGZ/CizdX72UIPMEzYTMBCNOK+/f/0RvdoH6483Tj5AricxxhIdtnNGEFZuNMov/TJGAAQ259l88DsCqrK2zAYOU+giL5Hrk8qY5izP5fbQDd10TX/9d20P0sH6hrDviBhI3TGNPdR1mAE0lVS0COfpTqwp6Pw9/GbYJPh6X27dUJE8xFaswbGIjjDFecRAXmCInRVGWtv2CJ64Bb2Yr9/YJaGgx7jVdb/v1F0qgXk2Mixz2wv64FBs55O+y3tpyU5mhZD9VV6IQajiDEpT15GAM5s0tvsiKzHoaKYVP5Tj3UZgqP2IpiIOcZl+l2+l0WGRtGFCgpGZOj9P6K87ImKVThySVRVGCHqsFDkH9kdkLMZlDxEbrOwST5HJEEB1lbFaTqN1VfnVRXXbVX34rKTOqpnj+WX7KRUip+GBWhPRQVUMHTfyUvvvWW8VCrsZkOjYiuA63QRlzSRDwv0NibfHh81B59DkhHIojhVTGQbRlp5AoLfpuMRO6eKtWCQPI5RfmFSJz0dgEzZ4B8Nj4vYjyab72VZsClNTaTnJGLit2ass91obNNBGm1sUxCKvaxhCl496
 xFO75qX/
 oYIQXcO35IgN52x7xn/Vw6qZAe3Ear9i7/ihgffpmoDfv8J9E+1sbBjjAAvzme7mHRzQ7UoxD4jqF39rhfPakSy98IbtNsAxfc9lxQJhHie2AEqXgzMYtHdUWeT1rGMB6pBxyiPfi0cVtH1XpWSspORu7FtV8M7gs7uDcvPGL+YaObARZgmf0sV3CbLsm3yBcmSuvvoqmIuyRgZ4zXcyHIQ0u3QuA9FVuD+9m6ZSNE3KIBsabeAYz/37KnyXdUgjuBB1r3dP+60mAUyfiGkRc16TaOiH3DmcNkQH/Ekv0Sflt1sUJs1Qc78nd4AS59Jcmh2WQuB0mpteLarddlY3rg0KgbDrXxKWPBk7U4H9YqA5/PkhNjS0jvjDw1aQcGi/wEXdklBaoTqvUB6rhz03yQSv03jPbH3N3bF1uZ3y+J6Znj++oA+VJrTM82Nr+ZE4OL0oOH0P7CStSRlaAXXqinwdkT8cft7wMXjFo4XuqDZPNMVdKQbV8tSeN1cSnS10u6cr2XLSgZoIKWVRhEIsQO0owV7iG8q2WI1BXw20w7trEJ7wVGEvThEdI9h0RY+ENJn+SXA4674YJWGbpozd0tW6E0IXqBQG/QfmOjk5OXo7eJWmb5/jWfjql13bBytdQJBgv
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
index db77ab5b315e..33ae56e313ed 100644
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
@@ -585,7 +585,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			goto out;
 		}
 
-		/* See hpage_collapse_scan_pmd(). */
+		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
 			++shared;
 			if (cc->is_khugepaged &&
@@ -836,7 +836,7 @@ static struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 };
 
-static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
+static bool collapse_scan_abort(int nid, struct collapse_control *cc)
 {
 	int i;
 
@@ -871,7 +871,7 @@ static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
 }
 
 #ifdef CONFIG_NUMA
-static int hpage_collapse_find_target_node(struct collapse_control *cc)
+static int collapse_find_target_node(struct collapse_control *cc)
 {
 	int nid, target_node = 0, max_value = 0;
 
@@ -890,7 +890,7 @@ static int hpage_collapse_find_target_node(struct collapse_control *cc)
 	return target_node;
 }
 #else
-static int hpage_collapse_find_target_node(struct collapse_control *cc)
+static int collapse_find_target_node(struct collapse_control *cc)
 {
 	return 0;
 }
@@ -909,7 +909,7 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
 				 TVA_FORCED_COLLAPSE;
 
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
 
 	*vmap = vma = find_vma(mm, address);
@@ -980,7 +980,7 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
 
 /*
  * Bring missing pages in from swap, to complete THP collapse.
- * Only done if hpage_collapse_scan_pmd believes it is worthwhile.
+ * Only done if khugepaged_scan_pmd believes it is worthwhile.
  *
  * Called and returns without pte mapped or spinlocks held.
  * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
@@ -1066,7 +1066,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 {
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE);
-	int node = hpage_collapse_find_target_node(cc);
+	int node = collapse_find_target_node(cc);
 	struct folio *folio;
 
 	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
@@ -1244,7 +1244,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	return result;
 }
 
-static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
+static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long start_addr,
 		bool *mmap_locked, struct collapse_control *cc)
 {
@@ -1365,7 +1365,7 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 		 * hit record.
 		 */
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
+		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			goto out_unmap;
 		}
@@ -1431,7 +1431,7 @@ static void collect_mm_slot(struct mm_slot *slot)
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 
-	if (hpage_collapse_test_exit(mm)) {
+	if (collapse_test_exit(mm)) {
 		/* free mm_slot */
 		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
@@ -1786,7 +1786,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		if (find_pmd_or_thp_or_none(mm, addr, &pmd) != SCAN_SUCCEED)
 			continue;
 
-		if (hpage_collapse_test_exit(mm))
+		if (collapse_test_exit(mm))
 			continue;
 
 		if (!file_backed_vma_is_retractable(vma))
@@ -2302,7 +2302,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
-static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
+static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		unsigned long addr, struct file *file, pgoff_t start,
 		struct collapse_control *cc)
 {
@@ -2355,7 +2355,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 		}
 
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
+		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			folio_put(folio);
 			break;
@@ -2409,7 +2409,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 	return result;
 }
 
-static void khugepaged_scan_mm_slot(unsigned int progress_max,
+static void collapse_scan_mm_slot(unsigned int progress_max,
 		enum scan_result *result, struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
 	__acquires(&khugepaged_mm_lock)
@@ -2443,7 +2443,7 @@ static void khugepaged_scan_mm_slot(unsigned int progress_max,
 		goto breakouterloop_mmap_lock;
 
 	cc->progress++;
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(collapse_test_exit_or_disable(mm)))
 		goto breakouterloop;
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
@@ -2451,7 +2451,7 @@ static void khugepaged_scan_mm_slot(unsigned int progress_max,
 		unsigned long hstart, hend;
 
 		cond_resched();
-		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
+		if (unlikely(collapse_test_exit_or_disable(mm))) {
 			cc->progress++;
 			break;
 		}
@@ -2473,7 +2473,7 @@ static void khugepaged_scan_mm_slot(unsigned int progress_max,
 			bool mmap_locked = true;
 
 			cond_resched();
-			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+			if (unlikely(collapse_test_exit_or_disable(mm)))
 				goto breakouterloop;
 
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
@@ -2486,12 +2486,12 @@ static void khugepaged_scan_mm_slot(unsigned int progress_max,
 
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
@@ -2500,7 +2500,7 @@ static void khugepaged_scan_mm_slot(unsigned int progress_max,
 					mmap_read_unlock(mm);
 				}
 			} else {
-				*result = hpage_collapse_scan_pmd(mm, vma,
+				*result = collapse_scan_pmd(mm, vma,
 					khugepaged_scan.address, &mmap_locked, cc);
 			}
 
@@ -2532,7 +2532,7 @@ static void khugepaged_scan_mm_slot(unsigned int progress_max,
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm, or THP got disabled.
 	 */
-	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
+	if (collapse_test_exit_or_disable(mm) || !vma) {
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
@@ -2585,7 +2585,7 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 			pass_through_head++;
 		if (khugepaged_has_work() &&
 		    pass_through_head < 2)
-			khugepaged_scan_mm_slot(progress_max, &result, cc);
+			collapse_scan_mm_slot(progress_max, &result, cc);
 		else
 			cc->progress = progress_max;
 		spin_unlock(&khugepaged_mm_lock);
@@ -2830,8 +2830,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_read_unlock(mm);
 			mmap_locked = false;
 			*lock_dropped = true;
-			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
-							  cc);
+			result = collapse_scan_file(mm, addr, file, pgoff, cc);
 
 			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
 			    mapping_can_writeback(file->f_mapping)) {
@@ -2845,8 +2844,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
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


