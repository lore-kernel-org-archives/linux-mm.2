Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF06ECA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:29:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEA3F8E0007; Thu, 11 Sep 2025 23:29:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C24C88E0001; Thu, 11 Sep 2025 23:29:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F598E0007; Thu, 11 Sep 2025 23:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EE6B8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:29:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2FCA486DE2
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:29:40 +0000 (UTC)
X-FDA: 83879168520.07.D78ABC4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7A05340003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:29:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NVAxFEli;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757647778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WWEgRNk/JfQcUp+5YUiRF1aP5J/soXNdg96qGRiyX+g=;
	b=SnOxTuPDlDNz/IKbncr6u3/PqFtwNaERgu8/r41ltAdifRzADI9DNhHORztXUQjqj/PPAb
	k5kDDne3uL1V4smQu86Soa+uuMcNmpSGqhv872vMDkWKW5U+mCFplfq9ApuaunQ+DGex1W
	KynFn6MWfOrA321gCxsDEq10VaAE2nc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NVAxFEli;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757647778; a=rsa-sha256;
	cv=none;
	b=bigitvfwzVAfP5Mr4nE/x3fqYfyzw1XFP4KWFuafPVr5+VbNgUtNUrnWGwU9gG2SmkvmyW
	hRYLdyCnaxtW3Lh6u7bPI2iJIWahfnK3axQ/2cm/iGrt61agpfKb5EqXD9pHJuN41UoRwl
	Ga1Ygtm/EKRlLZ1YuzpRwuc/v9f4DVs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757647777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WWEgRNk/JfQcUp+5YUiRF1aP5J/soXNdg96qGRiyX+g=;
	b=NVAxFEliGO7In0sowJS2NOEoPLzuVbU++zsek8O6Zm0tBaDezkgQe0ZcgZAmVZTuTepOYG
	Ze7gNPcOBkqpk0ZQ8eem/HBWcwpUkvRK0qYX02I0n4vzKbOXwdJ0Qu1qFJv8/J6CQMRU62
	SHsBEEEZ6dARoIuafQF+r3BCYF5oTIw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-463-1O_T2EnuOTCunxwWCn_PCQ-1; Thu,
 11 Sep 2025 23:29:35 -0400
X-MC-Unique: 1O_T2EnuOTCunxwWCn_PCQ-1
X-Mimecast-MFC-AGG-ID: 1O_T2EnuOTCunxwWCn_PCQ_1757647770
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B707E180048E;
	Fri, 12 Sep 2025 03:29:28 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2170718004D8;
	Fri, 12 Sep 2025 03:29:17 +0000 (UTC)
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
Subject: [PATCH v11 01/15] khugepaged: rename hpage_collapse_* to collapse_*
Date: Thu, 11 Sep 2025 21:27:56 -0600
Message-ID: <20250912032810.197475-2-npache@redhat.com>
In-Reply-To: <20250912032810.197475-1-npache@redhat.com>
References: <20250912032810.197475-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 7A05340003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 18mirk5y46rxsiudh8y155k86wmetj5y
X-HE-Tag: 1757647778-404056
X-HE-Meta: U2FsdGVkX18TL7/gsAMb1ZmWHu4R9n+1rcly5LpEvwh+59UYy32gXKhvUkV+7ZqrMMt34+3BlVizF5Xo+kRuMEmwoorwOaaZgouaMP68MCC/k9vGtrEHhbe0EZBdH3l3U5v3bEX4y6XKdErCy7o1oiO5e4QKZtsjv+a+TGcP7X0hHFTO+55sGSmqJJDyZXQ8jHxIzO/J5dEoqjpEXwXYXg5xmkUyF9uwGdfXeRTRB2Y7szM9ZJZQP7mKOgoDwd98zXTFwLhT+pod/jFgir/zjzs/Nv+2nObLTZRHJxIftKAqK0MXRX+rmkh9BXwOqu49tF1vn8CDyjUN4j3qlyAGRFjLaEF8Av7N/YVxeatl3sD19fR3A9jVlZ8nU/gdi5U3qT+ALvMqNzTbsEarPmS0+Ru2b67mIgbJOu4+pSleI+ktw2PZHLvAPQIdnU6U95wwt0OeqlTGjf3iQWL6J1d2rtNN9SxdZtoK+tesIVUaccMBZL3QI/g1+OkLXt1NHjkspS+Gwls4HMF2nXrPo3PokadS4YHXSHVbL28sJU7FUvdEGnSN8uh1SYlNhpY942ibaETpWDTIXypGV0dZYZ1rZ/SsuRfjWEShwoXGxveTzxQjxdslZRpLTCGlEPQFaGIChXKshoJHwhUIgRph9O2wCjSUDzqxsipzDCmGM4GYD/dvEAmRks46dRjZ2AVYpguZuChdiDovAfdpCSVEv/mObQ+zidsldUHvv/EQYGR9J+zCa+X5mqu2iDBwvPOyqads3WF36HzM/PMkTMMAk1bZ2nPN7iaTeDo3dMeidw32LTL0bR+Whzs1tYELlgfqkrYBFJxHWfCYGd68Rz72xCUTPnhLYh2vVQkxJonWjpYDL0plB71PGQA9CN21tTx6j2qC0YBu70NJZhjTAtgUIirBRkcn+16moi1tlPgMg7WqvFf/IApc9QDgVjL+7tfU6PfCJXz/7CPEWzQ5tCgYsJT
 5gX1yefX
 ELSCNc9NIRnw08SxiZ4CZsFNOrVDdjNZbSNO/dS5nwxu49cWHnrn090lu4vyqY85mQATEi2Gsjt1tSX8s9RW97DVAGDOjsBr+/dQIGBytnHVjx7cUO/Nxi6Bv6fZgyvDq3dwJG+zW328kJR7L8fb9iHGCc/TOl1a3IXnRydo2XWmUiQASt4hqXBGtN+OyXu5V4EM9MmlEQlA5SP2bxmD4pzrzL+J7/zT9oAu1Yzi4yLc0y2PVZ9rdfyv/gNmb1Nfek5XsBapRJ0D8+PuzcP2o9muAISr8+UQ5Xs90VkSmlfsqBrNwMhssGit2U52oOogm2nyLecgVCnyzlPlyE6ixfHEBZgqYVej4tsY3kZwNt85khmTBSNdZkL+s2v82s5bvNaNs922UnLdw+Wg1RLVYbQp6AqH6AfNjYqhr1geENoZBQKaGuXnsnBJRdV7HPIB8/lOXid7uJ3YwqedTQ93BUzh85+69OZivx2kdTreA14j3OHqtQxi7dAm438i5FW7+k1y3ZwyfJcgQlVc=
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
index af5f5c80fe4e..40fa6e0a6b2d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -401,14 +401,14 @@ void __init khugepaged_destroy(void)
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
 
@@ -443,7 +443,7 @@ void __khugepaged_enter(struct mm_struct *mm)
 	int wakeup;
 
 	/* __khugepaged_exit() must not run from under us */
-	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
+	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
 	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
 		return;
 
@@ -501,7 +501,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 	} else if (mm_slot) {
 		/*
 		 * This is required to serialize against
-		 * hpage_collapse_test_exit() (which is guaranteed to run
+		 * collapse_test_exit() (which is guaranteed to run
 		 * under mmap sem read mode). Stop here (after we return all
 		 * pagetables will be destroyed) until khugepaged has finished
 		 * working on the pagetables under the mmap_lock.
@@ -590,7 +590,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		folio = page_folio(page);
 		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
 
-		/* See hpage_collapse_scan_pmd(). */
+		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
 			++shared;
 			if (cc->is_khugepaged &&
@@ -841,7 +841,7 @@ struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 };
 
-static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
+static bool collapse_scan_abort(int nid, struct collapse_control *cc)
 {
 	int i;
 
@@ -876,7 +876,7 @@ static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
 }
 
 #ifdef CONFIG_NUMA
-static int hpage_collapse_find_target_node(struct collapse_control *cc)
+static int collapse_find_target_node(struct collapse_control *cc)
 {
 	int nid, target_node = 0, max_value = 0;
 
@@ -895,7 +895,7 @@ static int hpage_collapse_find_target_node(struct collapse_control *cc)
 	return target_node;
 }
 #else
-static int hpage_collapse_find_target_node(struct collapse_control *cc)
+static int collapse_find_target_node(struct collapse_control *cc)
 {
 	return 0;
 }
@@ -916,7 +916,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
 				 TVA_FORCED_COLLAPSE;
 
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
 
 	*vmap = vma = find_vma(mm, address);
@@ -989,7 +989,7 @@ static int check_pmd_still_valid(struct mm_struct *mm,
 
 /*
  * Bring missing pages in from swap, to complete THP collapse.
- * Only done if hpage_collapse_scan_pmd believes it is worthwhile.
+ * Only done if khugepaged_scan_pmd believes it is worthwhile.
  *
  * Called and returns without pte mapped or spinlocks held.
  * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
@@ -1075,7 +1075,7 @@ static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
 {
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE);
-	int node = hpage_collapse_find_target_node(cc);
+	int node = collapse_find_target_node(cc);
 	struct folio *folio;
 
 	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
@@ -1261,10 +1261,10 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
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
@@ -1372,7 +1372,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		 * hit record.
 		 */
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
+		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			goto out_unmap;
 		}
@@ -1439,7 +1439,7 @@ static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 
-	if (hpage_collapse_test_exit(mm)) {
+	if (collapse_test_exit(mm)) {
 		/* free mm_slot */
 		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
@@ -1741,7 +1741,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		if (find_pmd_or_thp_or_none(mm, addr, &pmd) != SCAN_SUCCEED)
 			continue;
 
-		if (hpage_collapse_test_exit(mm))
+		if (collapse_test_exit(mm))
 			continue;
 		/*
 		 * When a vma is registered with uffd-wp, we cannot recycle
@@ -2263,9 +2263,9 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
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
@@ -2320,7 +2320,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 		}
 
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
+		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			folio_put(folio);
 			break;
@@ -2370,7 +2370,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
-static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
+static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
 					    struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
 	__acquires(&khugepaged_mm_lock)
@@ -2408,7 +2408,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 		goto breakouterloop_mmap_lock;
 
 	progress++;
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(collapse_test_exit_or_disable(mm)))
 		goto breakouterloop;
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
@@ -2416,7 +2416,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 		unsigned long hstart, hend;
 
 		cond_resched();
-		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
+		if (unlikely(collapse_test_exit_or_disable(mm))) {
 			progress++;
 			break;
 		}
@@ -2437,7 +2437,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			bool mmap_locked = true;
 
 			cond_resched();
-			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+			if (unlikely(collapse_test_exit_or_disable(mm)))
 				goto breakouterloop;
 
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
@@ -2450,12 +2450,12 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 
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
@@ -2464,7 +2464,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 					mmap_read_unlock(mm);
 				}
 			} else {
-				*result = hpage_collapse_scan_pmd(mm, vma,
+				*result = collapse_scan_pmd(mm, vma,
 					khugepaged_scan.address, &mmap_locked, cc);
 			}
 
@@ -2497,7 +2497,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm.
 	 */
-	if (hpage_collapse_test_exit(mm) || !vma) {
+	if (collapse_test_exit(mm) || !vma) {
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
@@ -2550,8 +2550,8 @@ static void khugepaged_do_scan(struct collapse_control *cc)
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
@@ -2792,12 +2792,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 
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
index a562d8cf1eee..c461758c47f5 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -241,7 +241,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
 		goto out;
 	}
 	/*
-	 * Now new_pte is none, so hpage_collapse_scan_file() path can not find
+	 * Now new_pte is none, so collapse_scan_file() path can not find
 	 * this by traversing file->f_mapping, so there is no concurrency with
 	 * retract_page_tables(). In addition, we already hold the exclusive
 	 * mmap_lock, so this new_pte page is stable, so there is no need to get
-- 
2.51.0


