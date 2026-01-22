Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81CB1D6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7FA56B031E; Thu, 22 Jan 2026 14:30:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4D706B0321; Thu, 22 Jan 2026 14:30:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04F06B0323; Thu, 22 Jan 2026 14:30:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C070F6B031E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:30:36 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90E65C3296
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:30:36 +0000 (UTC)
X-FDA: 84360591672.16.41237A5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 77DFD40006
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:30:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JmU+Ir4x;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OnHuyTiwhAfrsg+vnG2TkqM1Acr/ix+gFtO6Gm3pfIo=;
	b=lMcs6IBHPlCyOSkzR1bJnlhltelnx5fdqomPK5ZXSVYWnXkO0FjnIQdxH/ERFxR+OJByra
	iXPgxVUQc2VUtHAVCoitl1Hl3/EJVpsCv8H68leZ/yqpFVoWfQdGAUrRL5vGrnKVBpSREk
	mJEkr+bqSQxNOwsibs4h15BaH3qhgWE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JmU+Ir4x;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769110234; a=rsa-sha256;
	cv=none;
	b=4mArTsPSfzMwC/muQT8PBbSG34BDF6Oq0l8bDfl7RYx8Ir6jAPx1xUnK/1URaejqfBn9Jm
	5GcZRBlk1ltZUK9OMSLXP0kd5Qm1kaj33SkVLev+lZR/GpF31KXmnbzmfjcq377zIUjRbW
	A29ri6AhOsMsIsh201PbG7GoB0RqCis=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769110233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OnHuyTiwhAfrsg+vnG2TkqM1Acr/ix+gFtO6Gm3pfIo=;
	b=JmU+Ir4x5vlhJcOLatvvLN5ET1C/x56m+BcWsk5gPSTdY5EGGw2iMyZg30yGK00nidOSAW
	BACf5rfG41E6OIN4PDkKfU3H2sGPVwum6rS9g4PDfezY76SNrkjyFS9GpWvl/znX8CYgI+
	Kt6Mrci1+zVdiH7EQcKKNh3mt8S9i0w=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-Kdmtze9-PvS-G1yPS1Q3Zg-1; Thu,
 22 Jan 2026 14:30:29 -0500
X-MC-Unique: Kdmtze9-PvS-G1yPS1Q3Zg-1
X-Mimecast-MFC-AGG-ID: Kdmtze9-PvS-G1yPS1Q3Zg_1769110224
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 940B11944B12;
	Thu, 22 Jan 2026 19:30:23 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.88.59])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E5AFD1958DC1;
	Thu, 22 Jan 2026 19:30:12 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: npache@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
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
	zokeefe@google.com,
	rientjes@google.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH mm-unstable v14 02/16] khugepaged: rename hpage_collapse_* to collapse_*
Date: Thu, 22 Jan 2026 12:28:27 -0700
Message-ID: <20260122192841.128719-3-npache@redhat.com>
In-Reply-To: <20260122192841.128719-1-npache@redhat.com>
References: <20260122192841.128719-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BoNlbaWM2Ef80v2wJTpNgGZMdBq8bc6UMYEAWI4vs84_1769110224
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: wptbb9ub5ob7cwgh3cy93zkbzo4hofk9
X-Rspamd-Queue-Id: 77DFD40006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769110234-84990
X-HE-Meta: U2FsdGVkX19CR+yyTwpjOPM7f/cnEUtROLYgifEZ4lXJL+lJP3rNVjVq7CAHb6UV63pqmCYUVWHgh3mj9gJN3u1edWZStg8XhiaRifXDgISNK9gB4uhhVQFB7mld5rKZr/hhXqs9JUcjyUhVRexFcD0LtUKQH04aVv2uPy06Rag/9ab6nNMrZY0JpA9bfROTsDo7J6bUJ14cR0swaihIHSBhnXsO86WmzhwReZ8rP89ptpUckQyB88lA5ceRSNyV1Z1ydnKhkZISNpn2X8w2gt+IOIzM7SVBxrlB9Fz+bRufYuaOY4FWrBpeP6XSSrswrnS/dTlUgMSKtymdKqWScmyZLk/m8PVa8keZvzIb8OuZtIWv+MWPLclDpa7kEUzkIFe6T5RslErG57hmtytSdl514Iu/E2hOPoIEzcfKa2N9nLaUsfu44wharXf+jSieRXqDJcDSADC5TyEX21Cgsq7p6nw9MdJErcwCMCrerSF3LlCxZBpEQxlub+U7GYb4lecxwDayNbKZM8qywPcN+5hzXtBlPixB+l7xw60Ks2WC99ohwAMk8fybh5eWN/cfhUBFcE3PU7TGMdLJWV20UI5m74KOs2Ov1b9YlDRoN1fnY7n5wHz4tJvRHGcVllsb4nRK6O0I7UBfNBkwnIdsLauTD4LyYDInWqffqWppaF8ypa/ndbKsMzufOHoC5yFhNlk7zpjDdgY3JL0KALOOtC974GBF8jjS2pC/Zf9jQVAU4rRPTsxc/M6IoecTXNDvGDckeJFIDnVDDMJrhSTiKuE9DkkoBu/nJ0r53psWKWqA4yupca8TqPVrUYCG5iscEkAyi93cMmPgaGUyKvt/kYuHrWkmZ6BnS6tMLSEA8Mdd4QzvCX6CLAnLFbGo7AA2YbVqM9wH3Sg8Y+kpBMwyYPbN/Tovrchsf4/luqlZH4ft6OQc2XvzccoUtbQK/8XGBbi6Zz6pUyMEtduiNK7
 KbWl4Hgc
 83jkbaH5Vw+DpuRfiAc+O+VmfqHETb0SvQNx08JeLI/8ZAx8kfR2PVIo6XyoHtGNES1e/IH8c4MrEio14Yb2hykJx/981VV+76Txub87C5JEfSAMY9pOA62uKrSkLFaobXqwtpcrRnjZW0IpfJXwHJeaqGVAQYjQDvvzzx//XhRbp86VxNHzT/3sJyYmt0yamPdd+qlq8TUpEUCAHqc95JsqYG8zHgqzTAlTUWOyMRUsvDq2ZscMo49JBxNlD5+NhSHa3GXCI8kaKEPbu8fDq+fvnT4p+DTQ9CjnCRdxoLMnVH/7fZzyCnvimdg1pFu6OQSV4JE9cBvhuTyycl8UQ53YIHQUzcijEbAecozO95h8f5CnjPNytTDS8DnDVnohviFgRE5ANhsmU7vJISA+XND179q3km2m5DxQmycEXlBRHRt0iai9V8OI6ip0oJfkz82gL6FyFYlhT0U1B5TnzAXqusjyVQFrmuUPCfjy1tyIgg5FdvhAZuA3515t9KrSGn4BF22IjXQNznSlZCy/JYbnTw6XXy1/oCKqA8CJgxscahLs=
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
 mm/khugepaged.c | 70 ++++++++++++++++++++++++-------------------------
 mm/mremap.c     |  2 +-
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b85d00670d14..fefcbdca4510 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -396,14 +396,14 @@ void __init khugepaged_destroy(void)
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
 
@@ -437,7 +437,7 @@ void __khugepaged_enter(struct mm_struct *mm)
 	int wakeup;
 
 	/* __khugepaged_exit() must not run from under us */
-	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
+	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
 	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
 		return;
 
@@ -491,7 +491,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 	} else if (slot) {
 		/*
 		 * This is required to serialize against
-		 * hpage_collapse_test_exit() (which is guaranteed to run
+		 * collapse_test_exit() (which is guaranteed to run
 		 * under mmap sem read mode). Stop here (after we return all
 		 * pagetables will be destroyed) until khugepaged has finished
 		 * working on the pagetables under the mmap_lock.
@@ -580,7 +580,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		folio = page_folio(page);
 		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
 
-		/* See hpage_collapse_scan_pmd(). */
+		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
 			++shared;
 			if (cc->is_khugepaged &&
@@ -831,7 +831,7 @@ static struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 };
 
-static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
+static bool collapse_scan_abort(int nid, struct collapse_control *cc)
 {
 	int i;
 
@@ -866,7 +866,7 @@ static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
 }
 
 #ifdef CONFIG_NUMA
-static int hpage_collapse_find_target_node(struct collapse_control *cc)
+static int collapse_find_target_node(struct collapse_control *cc)
 {
 	int nid, target_node = 0, max_value = 0;
 
@@ -885,7 +885,7 @@ static int hpage_collapse_find_target_node(struct collapse_control *cc)
 	return target_node;
 }
 #else
-static int hpage_collapse_find_target_node(struct collapse_control *cc)
+static int collapse_find_target_node(struct collapse_control *cc)
 {
 	return 0;
 }
@@ -904,7 +904,7 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
 				 TVA_FORCED_COLLAPSE;
 
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
 
 	*vmap = vma = find_vma(mm, address);
@@ -975,7 +975,7 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
 
 /*
  * Bring missing pages in from swap, to complete THP collapse.
- * Only done if hpage_collapse_scan_pmd believes it is worthwhile.
+ * Only done if khugepaged_scan_pmd believes it is worthwhile.
  *
  * Called and returns without pte mapped or spinlocks held.
  * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
@@ -1061,7 +1061,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 {
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE);
-	int node = hpage_collapse_find_target_node(cc);
+	int node = collapse_find_target_node(cc);
 	struct folio *folio;
 
 	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
@@ -1239,9 +1239,10 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	return result;
 }
 
-static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
-		struct collapse_control *cc)
+static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
+			     struct vm_area_struct *vma,
+			     unsigned long start_addr, bool *mmap_locked,
+			     struct collapse_control *cc)
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
@@ -1349,7 +1350,7 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 		 * hit record.
 		 */
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
+		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			goto out_unmap;
 		}
@@ -1415,7 +1416,7 @@ static void collect_mm_slot(struct mm_slot *slot)
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 
-	if (hpage_collapse_test_exit(mm)) {
+	if (collapse_test_exit(mm)) {
 		/* free mm_slot */
 		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
@@ -1770,7 +1771,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		if (find_pmd_or_thp_or_none(mm, addr, &pmd) != SCAN_SUCCEED)
 			continue;
 
-		if (hpage_collapse_test_exit(mm))
+		if (collapse_test_exit(mm))
 			continue;
 
 		if (!file_backed_vma_is_retractable(vma))
@@ -2286,8 +2287,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
-static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
-		struct file *file, pgoff_t start, struct collapse_control *cc)
+static enum scan_result collapse_scan_file(struct mm_struct *mm, unsigned long addr,
+			      struct file *file, pgoff_t start,
+			      struct collapse_control *cc)
 {
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
@@ -2342,7 +2344,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
 		}
 
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
+		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			folio_put(folio);
 			break;
@@ -2392,7 +2394,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
 	return result;
 }
 
-static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result *result,
+static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *result,
 					    struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
 	__acquires(&khugepaged_mm_lock)
@@ -2427,7 +2429,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 		goto breakouterloop_mmap_lock;
 
 	progress++;
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(collapse_test_exit_or_disable(mm)))
 		goto breakouterloop;
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
@@ -2435,7 +2437,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 		unsigned long hstart, hend;
 
 		cond_resched();
-		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
+		if (unlikely(collapse_test_exit_or_disable(mm))) {
 			progress++;
 			break;
 		}
@@ -2458,7 +2460,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 			bool mmap_locked = true;
 
 			cond_resched();
-			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+			if (unlikely(collapse_test_exit_or_disable(mm)))
 				goto breakouterloop;
 
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
@@ -2471,12 +2473,12 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 
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
@@ -2485,7 +2487,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 					mmap_read_unlock(mm);
 				}
 			} else {
-				*result = hpage_collapse_scan_pmd(mm, vma,
+				*result = collapse_scan_pmd(mm, vma,
 					khugepaged_scan.address, &mmap_locked, cc);
 			}
 
@@ -2518,7 +2520,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm.
 	 */
-	if (hpage_collapse_test_exit(mm) || !vma) {
+	if (collapse_test_exit(mm) || !vma) {
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
@@ -2569,8 +2571,8 @@ static void khugepaged_do_scan(struct collapse_control *cc)
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
@@ -2814,8 +2816,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_read_unlock(mm);
 			mmap_locked = false;
 			*lock_dropped = true;
-			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
-							  cc);
+			result = collapse_scan_file(mm, addr, file, pgoff, cc);
 
 			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
 			    mapping_can_writeback(file->f_mapping)) {
@@ -2829,8 +2830,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
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
index 8391ae17de64..bd24ead6fde4 100644
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
2.52.0


