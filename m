Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F06CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 232F78E0014; Tue, 19 Aug 2025 09:43:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E3AC8E0007; Tue, 19 Aug 2025 09:43:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AB9B8E0014; Tue, 19 Aug 2025 09:43:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EA1EB8E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:43:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A38231A0716
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:43:22 +0000 (UTC)
X-FDA: 83793623844.16.6443360
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id DFE66140012
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:43:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i1fxAjgb;
	spf=pass (imf26.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755611000; a=rsa-sha256;
	cv=none;
	b=2tbGqY5eIDWPw9rqHtuYjfqR3R6Wy1OakhXvyGuS0dbCHkvGybICEjVBGwWDAZvG2rzOYN
	NLldmpRzoB3V6heLXTISEiVjxr3p1+ytn3oI/cbsRs/DdaTpQ2CGF6LtrIrqaenNgZ9U1k
	Dk0Qd+RxJ1X6aP1y6XjbMafk1Q0fE2I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i1fxAjgb;
	spf=pass (imf26.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755611000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Plh8etSbXdyh8bXmsP8QgAsGXLtsQHnu+WgqFqa+e7M=;
	b=AsmR2QMEJA4kvGSxDHPUwirIgcP1VcAMtx8MlYAzRwiNLYprw2nUGH0Hv/FvmgsIogpNNX
	4lNiWhSlIlQeZDdIYIxTRp+H7vJvPhQaZPzcz//AMxcb7xQT1x+45e3h9OyOjBMx381LOE
	6IDEUjhZoyIX/8f3PYexG02q0y6ITL8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755611000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Plh8etSbXdyh8bXmsP8QgAsGXLtsQHnu+WgqFqa+e7M=;
	b=i1fxAjgbcf8NHqTz8mfpjVxnNeFLctu8tMJC4CnKnGB2uzGW8ohkSnUnLSKk5AnlMGWsrG
	CW2OpUyuadXO51lZ/nynk2fy6ScOCq9YPLmyPtZcxYqiPlv+TM9fzwuLsXFSTlUIme44sG
	tofKU7BI53u07sYFGP4BgnZuet9klv8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-544-pgZaXwinPk21EFasYWSvUQ-1; Tue,
 19 Aug 2025 09:43:17 -0400
X-MC-Unique: pgZaXwinPk21EFasYWSvUQ-1
X-Mimecast-MFC-AGG-ID: pgZaXwinPk21EFasYWSvUQ_1755610993
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B881195608E;
	Tue, 19 Aug 2025 13:43:12 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.137])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 74E2619560B0;
	Tue, 19 Aug 2025 13:42:51 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
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
	kirill.shutemov@linux.intel.com,
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
	hughd@google.com
Subject: [PATCH v10 01/13] khugepaged: rename hpage_collapse_* to collapse_*
Date: Tue, 19 Aug 2025 07:41:53 -0600
Message-ID: <20250819134205.622806-2-npache@redhat.com>
In-Reply-To: <20250819134205.622806-1-npache@redhat.com>
References: <20250819134205.622806-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DFE66140012
X-Stat-Signature: t4ine8gt9cw61dp189joe9rrcbahohmg
X-Rspam-User: 
X-HE-Tag: 1755611000-990486
X-HE-Meta: U2FsdGVkX18mqCO86sbAEgDEPQRKjnxA6N0e5WdpLk0LihhVtd5UnrCv2cqQYwC/TMZCl1NQY8g+ymTND7kmmAogPhUZM4mAAEvG+WTfJ/XL7To0jatrifDAdo61Jm75K8ZTY+bjFZqCG2oIC2bxUa3V0e4vuhpLZ7i79u2Waegcy6GqsOwouSZ1YszgnAK5BFZsnTOK8fL0KaYN0oOb6Qf2jqBBP8JAZUcCKdt2SJaxTZ7Cl9y9+O5NmjfJTzpSKgeL8s1HxNGSWc6NhlcmiYJNC7wTycnrF3kWEYNhen+aeL05AMbV1FKWbAjEC2o1Mx2ryb9P6DhCvrzMVISJ9nftQ7qbr8fSBC6FtCzuyx/Q0wVOIJzZqB03XLT+k2Guk/CXv0oCv+vs8R8+PD1B8d9RtiR0NUgBL1uQ0cIokrG/6Efyt5t2ckXYeY7mw04s0+iersf1edWmSe5pWwstUtR6YKPl73Jj7RniH0Y1dSrAN4vQKdhkfeI1xCdzSwLTZMDR/BCvp+M+tZEAZYGMs71gmNKp7syjAFVVWz/9CXoK2XnGiiSJkfqSlFmt2c4EOE2Hqtlcr3lJ1LFE5l3M/9yKjl9hUiqS3/7VhqLPQeG5o0gFDfXgBw/4m964G3LxxHtLKoQtJVDSgFBK2FKUsSoTXnGShTvWi5wMQSnC9/IFalm4qKGO+WJUb7y+vSdB5vyhzsahGZqmfK0eprteS3x2zeNFaD49HTLLls3e2kax/0HDLnQgxmSlq0XP9bQJatUZK+UQVgy0VIg4uX4Jc5APTm88WmCgH6ldQDPtK4sw7eCT5aocajQd7d3+W169QeyobzEiLUcZmKbRoKSQzM5gullI8lDwM2AwbcY+QUiryZD2usGbpbiBTLlnwWPaJZVziSNPwcCV489S1Xm/X1RZXz2FftAgVcWPpwZGWe5F8KO4iaOWZ9Gx6dSdxQ7Qzu74m0X8Sdm1vmZlSML
 FOIz8S5Q
 E+MdU+lIFhNlzSs2X+tgfGgTHfP2Z5DDj0Tk2+U+EDZ9yVNZGAMSlOR2r2XNtbaIcYOS+AHGuFwMUYd1Wz8cWDwqsBRdPkaCK9t2uRAgiDBGpDw/wSkrRZrh6HP2xpexFlH7JQJzWwePL4a2r7++zOQxbFMx8tzKQAa3VVxI2K+vDiT14jRVBFPW6K1FoVdXGhs53xHiiUsd91qKSnkAFEurwOL6k/ikE7jR3NI/1bVFz2+AeMGRL+TDSBn3tPH2zdtz//a57xoSG8eZ2gBWU4J8GZjesdDog0DQHGNkAY6ckrEd2qCj9ZNSj6uyVdAyqkpppDhXkMTF8o5fp4HelCwIoABpaqt4ANmo3rT8mYzhpLda/jV+OOa1FfCm1itjbiQkoRygprPD/CiQFkCGAFSVbijLl4EGS+/zautUgia+9DlL4pamfSesiGO6IrkFFJ3OxXLK22K3EvOVcNLQ1nToJ6gdVDTXNphwAgrZeJCbXULIXBImVMMEXow0c/MN/BUO2IFCar//rlU0=
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

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 73 ++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 37 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d3d4f116e14b..0e7bbadf03ee 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -402,14 +402,14 @@ void __init khugepaged_destroy(void)
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
 
@@ -444,7 +444,7 @@ void __khugepaged_enter(struct mm_struct *mm)
 	int wakeup;
 
 	/* __khugepaged_exit() must not run from under us */
-	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
+	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
 	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
 		return;
 
@@ -502,7 +502,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 	} else if (mm_slot) {
 		/*
 		 * This is required to serialize against
-		 * hpage_collapse_test_exit() (which is guaranteed to run
+		 * collapse_test_exit() (which is guaranteed to run
 		 * under mmap sem read mode). Stop here (after we return all
 		 * pagetables will be destroyed) until khugepaged has finished
 		 * working on the pagetables under the mmap_lock.
@@ -592,7 +592,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		folio = page_folio(page);
 		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
 
-		/* See hpage_collapse_scan_pmd(). */
+		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
 			++shared;
 			if (cc->is_khugepaged &&
@@ -848,7 +848,7 @@ struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 };
 
-static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
+static bool collapse_scan_abort(int nid, struct collapse_control *cc)
 {
 	int i;
 
@@ -883,7 +883,7 @@ static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
 }
 
 #ifdef CONFIG_NUMA
-static int hpage_collapse_find_target_node(struct collapse_control *cc)
+static int collapse_find_target_node(struct collapse_control *cc)
 {
 	int nid, target_node = 0, max_value = 0;
 
@@ -902,7 +902,7 @@ static int hpage_collapse_find_target_node(struct collapse_control *cc)
 	return target_node;
 }
 #else
-static int hpage_collapse_find_target_node(struct collapse_control *cc)
+static int collapse_find_target_node(struct collapse_control *cc)
 {
 	return 0;
 }
@@ -923,7 +923,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
 				 TVA_FORCED_COLLAPSE;
 
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
 
 	*vmap = vma = find_vma(mm, address);
@@ -996,7 +996,7 @@ static int check_pmd_still_valid(struct mm_struct *mm,
 
 /*
  * Bring missing pages in from swap, to complete THP collapse.
- * Only done if hpage_collapse_scan_pmd believes it is worthwhile.
+ * Only done if khugepaged_scan_pmd believes it is worthwhile.
  *
  * Called and returns without pte mapped or spinlocks held.
  * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
@@ -1082,7 +1082,7 @@ static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
 {
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE);
-	int node = hpage_collapse_find_target_node(cc);
+	int node = collapse_find_target_node(cc);
 	struct folio *folio;
 
 	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
@@ -1268,10 +1268,10 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	return result;
 }
 
-static int hpage_collapse_scan_pmd(struct mm_struct *mm,
-				   struct vm_area_struct *vma,
-				   unsigned long address, bool *mmap_locked,
-				   struct collapse_control *cc)
+static int collapse_scan_pmd(struct mm_struct *mm,
+			     struct vm_area_struct *vma,
+			     unsigned long address, bool *mmap_locked,
+			     struct collapse_control *cc)
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
@@ -1382,7 +1382,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		 * hit record.
 		 */
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
+		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			goto out_unmap;
 		}
@@ -1451,7 +1451,7 @@ static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 
-	if (hpage_collapse_test_exit(mm)) {
+	if (collapse_test_exit(mm)) {
 		/* free mm_slot */
 		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
@@ -1753,7 +1753,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		if (find_pmd_or_thp_or_none(mm, addr, &pmd) != SCAN_SUCCEED)
 			continue;
 
-		if (hpage_collapse_test_exit(mm))
+		if (collapse_test_exit(mm))
 			continue;
 		/*
 		 * When a vma is registered with uffd-wp, we cannot recycle
@@ -2275,9 +2275,9 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
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
@@ -2332,7 +2332,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 		}
 
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
+		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			folio_put(folio);
 			break;
@@ -2382,7 +2382,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
-static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
+static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
 					    struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
 	__acquires(&khugepaged_mm_lock)
@@ -2420,7 +2420,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 		goto breakouterloop_mmap_lock;
 
 	progress++;
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(collapse_test_exit_or_disable(mm)))
 		goto breakouterloop;
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
@@ -2428,7 +2428,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 		unsigned long hstart, hend;
 
 		cond_resched();
-		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
+		if (unlikely(collapse_test_exit_or_disable(mm))) {
 			progress++;
 			break;
 		}
@@ -2449,7 +2449,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			bool mmap_locked = true;
 
 			cond_resched();
-			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+			if (unlikely(collapse_test_exit_or_disable(mm)))
 				goto breakouterloop;
 
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
@@ -2462,12 +2462,12 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 
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
@@ -2476,7 +2476,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 					mmap_read_unlock(mm);
 				}
 			} else {
-				*result = hpage_collapse_scan_pmd(mm, vma,
+				*result = collapse_scan_pmd(mm, vma,
 					khugepaged_scan.address, &mmap_locked, cc);
 			}
 
@@ -2509,7 +2509,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm.
 	 */
-	if (hpage_collapse_test_exit(mm) || !vma) {
+	if (collapse_test_exit(mm) || !vma) {
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
@@ -2563,8 +2563,8 @@ static void khugepaged_do_scan(struct collapse_control *cc)
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
@@ -2805,12 +2805,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 
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
-- 
2.50.1


