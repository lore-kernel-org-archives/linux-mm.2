Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ED6FD116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F9E86B007B; Mon,  1 Dec 2025 12:47:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AA3E6B0088; Mon,  1 Dec 2025 12:47:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772916B0089; Mon,  1 Dec 2025 12:47:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FB036B007B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:47:44 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 127578862E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:47:44 +0000 (UTC)
X-FDA: 84171634848.07.F837EE6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4F2B540005
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:47:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="D7/KAcK0";
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764611262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nw8Mla//L18c9/ZJeIUH2cZxs1B2wG5Ok87HI2C8tsE=;
	b=wLcuCA699+4UQTuLtNEfpYTnI8yNXTO88R4O8Idc9F4LW+xIAtxbtsyj0F6uOjbabbtZQt
	Xp3M8vsrURZPKCQR1BX6mEQCHxK2gc2BXNtA1EaBSZWlCP6zz5elMZS6kxstjr+UrmqHWd
	kzCVz2P366qQQGI8fMLygiAkxI5g1W4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="D7/KAcK0";
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764611262; a=rsa-sha256;
	cv=none;
	b=QrqtBxBJFKGKVS/Ne0g2iAjC55F5Oky14mnLL2UDR286HrRBnWC5kEWzUFnVofogF9F1n5
	Jq1pogzpPD3zoOYuDM2/Mb3pT149hiZuS5k/SoBRyY1xM9YjhJTtJmMBZRnhJb8mx9YWIB
	Vq6eyXt9Om7/fBbRxwdWTXKk7Szy180=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764611261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nw8Mla//L18c9/ZJeIUH2cZxs1B2wG5Ok87HI2C8tsE=;
	b=D7/KAcK0ZaGtfVyRKZ5VgtzMFJWSh4xNWveJ2mQBzx6k/ziLDEHAVobKWWMfUmWZ6+Hutc
	0XzsvZJLCw+144LmqnCkNE1WGBPR3Ol41cvld/iki0oHOd8XlR0ooXJULm5AgkYTGQBLWf
	rld1i4CEAmIARJenbh3360nWKGjSjIY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-695-7Rsys7vPPxmuzJPRf0HhSw-1; Mon,
 01 Dec 2025 12:47:39 -0500
X-MC-Unique: 7Rsys7vPPxmuzJPRf0HhSw-1
X-Mimecast-MFC-AGG-ID: 7Rsys7vPPxmuzJPRf0HhSw_1764611254
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58435180034D;
	Mon,  1 Dec 2025 17:47:33 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.66.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4E63C180047F;
	Mon,  1 Dec 2025 17:47:22 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Cc: david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	willy@infradead.org,
	peterx@redhat.com,
	wangkefeng.wang@huawei.com,
	usamaarif642@gmail.com,
	sunnanyong@huawei.com,
	vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com,
	yang@os.amperecomputing.com,
	kas@kernel.org,
	aarcange@redhat.com,
	raquini@redhat.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com,
	tiwai@suse.de,
	will@kernel.org,
	dave.hansen@linux.intel.com,
	jack@suse.cz,
	cl@gentwo.org,
	jglisse@google.com,
	surenb@google.com,
	zokeefe@google.com,
	hannes@cmpxchg.org,
	rientjes@google.com,
	mhocko@suse.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	jannh@google.com,
	pfalcato@suse.de
Subject: [PATCH v13 mm-new 01/16] khugepaged: rename hpage_collapse_* to collapse_*
Date: Mon,  1 Dec 2025 10:46:12 -0700
Message-ID: <20251201174627.23295-2-npache@redhat.com>
In-Reply-To: <20251201174627.23295-1-npache@redhat.com>
References: <20251201174627.23295-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 4F2B540005
X-Rspamd-Server: rspam02
X-Stat-Signature: td87u7tuoutgyzixx74r18f5qdi184kd
X-Rspam-User: 
X-HE-Tag: 1764611262-908349
X-HE-Meta: U2FsdGVkX18I0zCQjgeUv9o4xuqGqBD4cJZZg0zhFRwLj2wFU1CQ/EhVc9yiPmNwPjySsoJlN5L1EtJaG31ubSngMxS7wHusOoft1B5UJZTbFuwxTiMNLhpjezK0GJb0ICiE/fydgZWrVMzplqkA4P6w/rny9+EiHIAyxm2G7zsPlGZ0gNyB4v4WeyCIJ9Rr3hL0meACUWeQOTfdX4sSCH9kFAlxsQWWRGmGHwqu06939mPRqx5+eIhjXuRi4c6KQWoOPRP6vkRZnaBHeMbD2ijp8FdtcUfeLrMbnvEmyBFXK+mbn+XeF3Hh5eOfQfdDkSK9xveoKa/HH6BWM3UhA+dpXcV3lrQkA69JOTL18JcC0MSXvQ6SxXld2De6OiU+airqWV6ltT3qKhcqLXCgk+vCaqGYtgidnv8G8A0BAsyPdwqlNT0u6IwM6p5EDbT2/NcXztYUIy8xYX9cO6bVAYqFaGl6Io9XfedDAaN36HSLBnkWqpUbiAjSBnOuirbUvt7yedjkdyTTaLmsAmropmOcFXhfAj4BtPX/z4J2fWdkdaHLVXZHmwY0OBZjU4K7cqQ97bxkDOv/xMqAF1PU+IUclqfo9tsa9SPtuwklfxreS4GIFK+4CP1Uy6ZLvubEWv04hqEj7AtniptwJSf2YtEMvh5vxcgSPyJ7hMZ+vDOd3y8DIO2oRlu02KZOaG7kUAuKOIFR40KHonYIu4JKL2KFTpqCD9S40OXNTstE18r3qQcAszAj+YE/DBTb7SL8qeNrgMfGzDStwa8C9SX2/WwiUa0LHpd9h2dSEZGp2jj14Ii7rj3rGFe/poodSfjqCsaals8KPtMavGVSOI5PeWXgt/Mco7qnYymQwLU/cUC9OKjBX0o9cNqQs9hAMr3GO1x9N0jNG7L/9Xocx+UID+A6cs4xDE0cFqVWmS6nQADEfhSyLvnDhOUIUQasD0NWkah05G18mOxRburXhEu
 vkcqb9MG
 04TNkFJ27pRG1xCOfRsdn8MneNJmiFXDfcucXt83WyOQ7JjI7AeW6GxCfIQKd+cXOqvptZJQkOCIXvgG6EaLsuX6roUfLofmyAn6qagmVYRbqYAcg+rSBp2ECeAXBJUa1U3gJKBeT6JVFVxJ0PpgrGUGRpoRLFHrmeekR4jPLCBr6iX+moPxwLuDdA58Xw8WnpouS/g6AOofvQfC9hgJKLovlAttmOrtjGzEZfLkdfCOE7g7nOiZL6zx+Pn0ukNoimruva6H1C/U3l9/ucc+/3cygDm8u3I2JDTzkzGXfZdK0EJ6fQb6aHRbPj1K2EAXYkkoSOVQzIsf6YErLig227dZZy9gDp/SPuGwbUzuiEr1a5wkUcAs7Nx9/UCF5tdEt/psPbbm2z/cqZ9svIJB04rpS5MIXwcorS9+IzkPlEsdfwpSIUUNt+oD5am4pKqwrVcVGegbEdZV2JbxaCqfEzg+z5o7qmU4Og+BHEePpHIi+4YywVmHx8dHAzuvQGPUXdZG8CUpcVUDbDShAug9j5Lg67zQq9zytFvj3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 73 ++++++++++++++++++++++++-------------------------
 mm/mremap.c     |  2 +-
 2 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 97d1b2824386..959be77f2e65 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -394,14 +394,14 @@ void __init khugepaged_destroy(void)
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
 
@@ -435,7 +435,7 @@ void __khugepaged_enter(struct mm_struct *mm)
 	int wakeup;
 
 	/* __khugepaged_exit() must not run from under us */
-	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
+	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
 	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
 		return;
 
@@ -489,7 +489,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 	} else if (slot) {
 		/*
 		 * This is required to serialize against
-		 * hpage_collapse_test_exit() (which is guaranteed to run
+		 * collapse_test_exit() (which is guaranteed to run
 		 * under mmap sem read mode). Stop here (after we return all
 		 * pagetables will be destroyed) until khugepaged has finished
 		 * working on the pagetables under the mmap_lock.
@@ -579,7 +579,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		folio = page_folio(page);
 		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
 
-		/* See hpage_collapse_scan_pmd(). */
+		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
 			++shared;
 			if (cc->is_khugepaged &&
@@ -830,7 +830,7 @@ struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 };
 
-static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
+static bool collapse_scan_abort(int nid, struct collapse_control *cc)
 {
 	int i;
 
@@ -865,7 +865,7 @@ static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
 }
 
 #ifdef CONFIG_NUMA
-static int hpage_collapse_find_target_node(struct collapse_control *cc)
+static int collapse_find_target_node(struct collapse_control *cc)
 {
 	int nid, target_node = 0, max_value = 0;
 
@@ -884,7 +884,7 @@ static int hpage_collapse_find_target_node(struct collapse_control *cc)
 	return target_node;
 }
 #else
-static int hpage_collapse_find_target_node(struct collapse_control *cc)
+static int collapse_find_target_node(struct collapse_control *cc)
 {
 	return 0;
 }
@@ -905,7 +905,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
 				 TVA_FORCED_COLLAPSE;
 
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
 
 	*vmap = vma = find_vma(mm, address);
@@ -978,7 +978,7 @@ static int check_pmd_still_valid(struct mm_struct *mm,
 
 /*
  * Bring missing pages in from swap, to complete THP collapse.
- * Only done if hpage_collapse_scan_pmd believes it is worthwhile.
+ * Only done if khugepaged_scan_pmd believes it is worthwhile.
  *
  * Called and returns without pte mapped or spinlocks held.
  * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
@@ -1065,7 +1065,7 @@ static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
 {
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE);
-	int node = hpage_collapse_find_target_node(cc);
+	int node = collapse_find_target_node(cc);
 	struct folio *folio;
 
 	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
@@ -1244,10 +1244,10 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	return result;
 }
 
-static int hpage_collapse_scan_pmd(struct mm_struct *mm,
-				   struct vm_area_struct *vma,
-				   unsigned long start_addr, bool *mmap_locked,
-				   struct collapse_control *cc)
+static int collapse_scan_pmd(struct mm_struct *mm,
+			     struct vm_area_struct *vma,
+			     unsigned long start_addr, bool *mmap_locked,
+			     struct collapse_control *cc)
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
@@ -1355,7 +1355,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		 * hit record.
 		 */
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
+		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			goto out_unmap;
 		}
@@ -1421,7 +1421,7 @@ static void collect_mm_slot(struct mm_slot *slot)
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 
-	if (hpage_collapse_test_exit(mm)) {
+	if (collapse_test_exit(mm)) {
 		/* free mm_slot */
 		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
@@ -1769,7 +1769,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		if (find_pmd_or_thp_or_none(mm, addr, &pmd) != SCAN_SUCCEED)
 			continue;
 
-		if (hpage_collapse_test_exit(mm))
+		if (collapse_test_exit(mm))
 			continue;
 
 		if (!file_backed_vma_is_retractable(vma))
@@ -2285,9 +2285,9 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
-static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
-				    struct file *file, pgoff_t start,
-				    struct collapse_control *cc)
+static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
+			      struct file *file, pgoff_t start,
+			      struct collapse_control *cc)
 {
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
@@ -2342,7 +2342,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 		}
 
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
+		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			folio_put(folio);
 			break;
@@ -2392,7 +2392,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
-static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
+static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
 					    struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
 	__acquires(&khugepaged_mm_lock)
@@ -2427,7 +2427,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 		goto breakouterloop_mmap_lock;
 
 	progress++;
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(collapse_test_exit_or_disable(mm)))
 		goto breakouterloop;
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
@@ -2435,7 +2435,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 		unsigned long hstart, hend;
 
 		cond_resched();
-		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
+		if (unlikely(collapse_test_exit_or_disable(mm))) {
 			progress++;
 			break;
 		}
@@ -2456,7 +2456,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			bool mmap_locked = true;
 
 			cond_resched();
-			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+			if (unlikely(collapse_test_exit_or_disable(mm)))
 				goto breakouterloop;
 
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
@@ -2469,12 +2469,12 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 
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
 					*result = collapse_pte_mapped_thp(mm,
 						khugepaged_scan.address, false);
@@ -2483,7 +2483,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 					mmap_read_unlock(mm);
 				}
 			} else {
-				*result = hpage_collapse_scan_pmd(mm, vma,
+				*result = collapse_scan_pmd(mm, vma,
 					khugepaged_scan.address, &mmap_locked, cc);
 			}
 
@@ -2516,7 +2516,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm.
 	 */
-	if (hpage_collapse_test_exit(mm) || !vma) {
+	if (collapse_test_exit(mm) || !vma) {
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
@@ -2567,8 +2567,8 @@ static void khugepaged_do_scan(struct collapse_control *cc)
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
@@ -2807,12 +2807,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 
 			mmap_read_unlock(mm);
 			mmap_locked = false;
-			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
-							  cc);
+			result = collapse_scan_file(mm, addr, file, pgoff, cc);
 			fput(file);
 		} else {
-			result = hpage_collapse_scan_pmd(mm, vma, addr,
-							 &mmap_locked, cc);
+			result = collapse_scan_pmd(mm, vma, addr,
+						   &mmap_locked, cc);
 		}
 		if (!mmap_locked)
 			*lock_dropped = true;
diff --git a/mm/mremap.c b/mm/mremap.c
index 672264807db6..db31d0231e05 100644
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
2.51.1


