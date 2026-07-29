Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFD7BC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 970C66B012B; Wed, 29 Jul 2026 10:49:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948C76B012D; Wed, 29 Jul 2026 10:49:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 812226B012E; Wed, 29 Jul 2026 10:49:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 362E66B012B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:49:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3051C063D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:12:42 +0000 (UTC)
X-FDA: 85041551364.30.188D306
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id DCEA21C0009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:12:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WBSvK0LQ;
	spf=pass (imf18.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785323561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=CU2s/2Ix5XgOBgId84uXukZLT3PuCIP33pHN4f3NJGM=;
	b=sa0ZSMtXa4rgj37MIKxqkEBKxYfOyMtTCYkk7P5ohenVyuRiStXQaM/2GDDkcvH7Y56ogG
	Sm644I4ILl5khy6zj6kPme5ryuAINwXzFqg0mzN4oK58cPyGPzkMGa98nX5B+/HWwhXAM1
	MWJSpvNbUzyeOACN1TqMfoogxVboySM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785323561;
	b=0aZRzMrMYeretp70y+6LjFLRSsbAvlRLoocV0RWe4xRxm9mhw2klCelC39LlbXn4iJYqAR
	CVEwYrUrXKZRS1qqa2JboViYw5g+/spXKoZnrzGe52ORstOZSqTIxaFWUBsoRh96/1FFjK
	5su/Y6ICt+GoyYJvbr8FeRNwHbJJ9WM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WBSvK0LQ;
	spf=pass (imf18.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=CU2s/2Ix5XgOBgId84uXukZLT3PuCIP33pHN4f3NJGM=; b=WBSvK0LQO1hnt81jRxC3jzx3xF
	fTdR9xymko5IryEGyyLIuhMA09o7hjGGbMh9Ggu2AUwPjqZT1E6wmKfzWq1Ukn2QfvN04Qi5onNYr
	t+pliVh8tVmi4Lcl6XOIzdZWAp/KQX0ZIu3ErdViLjdX/2ZlKO1o50OznKIb46VIAJf9RV/4QS6Pq
	CbZNxAFZTWOqFZlnnuW5hhWUm7mi4KHWO3aoMcgi4PmJCgL3py1tBOVOk8j0QpZaPsxvNM3yfW4/K
	dwbYInszSpVLn/QPx/hr94z92fkSXp3diFPGN8GzWgLv09D6Dn2oJYVodp5gB7arDH4uA19wOwSTE
	Up++3atw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp2CU-00000001xXv-3kmm;
	Wed, 29 Jul 2026 11:11:54 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id BD9733011E4; Wed, 29 Jul 2026 13:11:40 +0200 (CEST)
Message-ID: <20260729111119.604452135@infradead.org>
User-Agent: quilt/0.68
Date: Wed, 29 Jul 2026 13:08:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
 peterz@infradead.org,
 Andy Lutomirski <luto@kernel.org>,
 Borislav Petkov <bp@alien8.de>,
 David Hildenbrand <david@kernel.org>,
 Ingo Molnar <mingo@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Juergen Gross <jgross@suse.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Kiryl Shutsemau <kas@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Lu Baolu <baolu.lu@linux.intel.com>,
 Mike Rapoport <rppt@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@kernel.org>,
 Toshi Kani <toshi.kani@hpe.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>,
 linux-mm@kvack.org,
 x86@kernel.org
Subject: [PATCH 3/3] x86/mm: Fix and document DEBUG_PAGEALLOC
References: <20260729110807.797920433@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DCEA21C0009
X-Stat-Signature: ccr7dosyt7oixip6uckux73xxrkto8au
X-Rspam-User: 
X-HE-Tag: 1785323560-976846
X-HE-Meta: U2FsdGVkX18Zo9GeqWOoCpIC2LS4VYVQyJ/2olF28G7so4bCSXFEMNSEOkBd8Cb4JhrnJ8M27opJ8BhNf4wYYC3IGkJcQ4OGmworTATYo1qSW61Q4PPsGqjZYiecRDppW82dcxoLcYhWNkYR6yyEqUJ8sQk/knls75dEpAW2EQeQhUMiZs83KDrfNpf2oDQX+hl2qBLTD+NAPYDIZH+k8Fz22kua6bXXlWIXztb8zR/QP4C1itG85AiRZzYfwOhHHV6EclFv3tKS/x4tg0dXsUdM+cYSsGgFjzxT8UQIHULyrU0nwK2mxw1q4QVoiyhmkWoHfcjj8ztAOiRgTbGzkhcphYHf29zf5RMGORybQXq0Va1iEJ1FhqXGduhL5En3auxqwo1G6r4eVzFr4pYZKIoywYE/QnPmVAZgeCkI5DvuhfUWuSoZRNz+tw1KFPlmIsl/qJ+6VGttiDQQWjDp40qcv4gsZ1gaW+BfrSNd4qUTrTSc9ntPXBrrl2IJIYuchG9rQx+xr4x/dnmH98q+8VjK7BpCMc9W2peZVwXo091qUz7j23Rg8oHpMtxCQ091YRNC/5+RJ00uaapTpSHfHm+yiMyjZDdilVaOReH1nh2q3ArNZZDIlDIMTjAJFaU4/DY1vkm0jZ/omXVtjDzRdEsoAiQ7ni0Yj+kjZVpuHkgJ/sVwdFiT6dg6/+emR9Ln3XlABYJj+DULp/DJ03+2vqjj6jDW4NbUPZJhXw5LI5C/9wzb8r0JtgEiXYwSiTM5ye5mXg4geb0lcoueIcLsTYr8bmf1fhDaAe3/5igwB6bHQCp/8ACTc9PCjQtayTjgQUApp6qvbETGvjYKxPXCslGzzxYp/flLxK0qqkPPCNDnWM4rjs35eeHyyrltn4AFyINp5tkxXdyuuHSfmUEap98Uy6AyfujOcoWEa9j+qVg2CDNE15U809pWe60DI9P1Ev/VtmGJQ6eVerHptZ/
 zQIL8TWr
 qI1E8O+HEfKF9xO/4X2ABxIYyeruFkd3mHPSvL94/MM5SmrfW7oKUzU9h8a/DlnRewMc1Rh2fGibMPnDQTVahq6dJtWij152jhBR05Oo0s3z8atyh7usMZN7D48ipHANqReEKpCYM2WBZStCHE7HywWQHj2kIfMG9/XBSVJEy0BAzc2JhS9W9I48IkYpZgl3gZ3BIEzkBvFZkMvLNVKLvoeXYfRuWo9U1MEN57KEYhbjycS4R/JYPxT+FZb6+xdob1OU8rJ98b9WFcfgdo07XHw615Jxm/9282mkzH9Zq7Ri13jOYnbbxikM5TbthQ6goxqb983/NZRBkosBNMpqOObXt6D44bRDHLf7HhGsiTVuagMgz4uqPRiHN0LWQ8iWHmjr+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It turns out that commit 5fce67641a3e ("x86/mm/pat: Don't gate
cpa_lock on debug_pagealloc_enabled()") was a little too quick to
remove the debug_pagealloc exception for cpa_lock.

Notably __kernel_map_pages() is used by the page-allocator from any
context the page-allocator itself is used, which violates the cpa_lock
rules.

Re-instate the exception, except make it specific to the
__kernel_map_pages() such that any other cpa() usage is still fully
serialized by cpa_lock. Also note that since cpa() should not be used
on memory that isn't allocated, the page-allocator locking and cpa are
infact mutually exclusive and all cpa usage in fully serialized.

Add a comment explaining this and other 'funnies' surrounding
DEBUG_PAGEALLOC, including how pgd_lock is not affected and the TLB
trickery.

Fixes: 5fce67641a3e ("x86/mm/pat: Don't gate cpa_lock on debug_pagealloc_enabled()")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/mm/pat/set_memory.c |   80 +++++++++++++++++++++++++++++++------------
 1 file changed, 58 insertions(+), 22 deletions(-)

--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -68,11 +68,12 @@ static const int cpa_warn_level = CPA_PR
  */
 static DEFINE_SPINLOCK(cpa_lock);
 
-#define CPA_FLUSHTLB 1
-#define CPA_ARRAY 2
-#define CPA_PAGES_ARRAY 4
-#define CPA_NO_CHECK_ALIAS 8 /* Do not search for aliases */
-#define CPA_COLLAPSE 16 /* try to collapse large pages */
+#define CPA_FLUSHTLB		0x01
+#define CPA_ARRAY		0x02
+#define CPA_PAGES_ARRAY		0x04
+#define CPA_NO_CHECK_ALIAS	0x08 /* Do not search for aliases */
+#define CPA_COLLAPSE		0x10 /* try to collapse large pages */
+#define CPA_DEBUG_PAGEALLOC	0x20
 
 static inline pgprot_t cachemode2pgprot(enum page_cache_mode pcm)
 {
@@ -1989,6 +1990,7 @@ static int __change_page_attr_set_clr(st
 {
 	unsigned long numpages = cpa->numpages;
 	unsigned long rempages = numpages;
+	bool lock = true;
 	int ret = 0;
 
 	/*
@@ -1998,6 +2000,29 @@ static int __change_page_attr_set_clr(st
 	    !cpa->force_split)
 		return ret;
 
+	/*
+	 * DEBUG_PAGEALLOC is special; it is called from any context the
+	 * page-allocator is, which violates the normal cpa_lock locking
+	 * rules.
+	 *
+	 * However, since it is part of the page-allocator, things are still
+	 * properly serialized by the page-allocator locking and the fact that
+	 * when a page is owned by the page-allocator, it isn't owned by
+	 * anybody else. That is, you *SHOULD* not be calling cpa() on memory
+	 * that isn't allocated.
+	 *
+	 * Additionally, DEBUG_PAGEALLOC ensures (per probe_page_size_mask())
+	 * that the kernel mapping is 4k pages, therefore there are no large
+	 * pages to split/collapse.
+	 *
+	 * Furthermore, the page-allocator strictly manages pages that
+	 * *exist*, avoiding pgd_lock.
+	 *
+	 * Therefore, it is safe to not take cpa_lock.
+	 */
+	if (debug_pagealloc_enabled() && (cpa->flags & CPA_DEBUG_PAGEALLOC))
+		lock = false;
+
 	while (rempages) {
 		/*
 		 * Store the remaining nr of pages for the large page
@@ -2008,9 +2033,12 @@ static int __change_page_attr_set_clr(st
 		if (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))
 			cpa->numpages = 1;
 
-		spin_lock(&cpa_lock);
-		ret = __change_page_attr(cpa, primary);
-		spin_unlock(&cpa_lock);
+		if (lock) {
+			guard(spinlock)(&cpa_lock);
+			ret = __change_page_attr(cpa, primary);
+		} else {
+			ret = __change_page_attr(cpa, primary);
+		}
 		if (ret)
 			goto out;
 
@@ -2589,7 +2617,7 @@ int set_pages_rw(struct page *page, int
 	return set_memory_rw(addr, numpages);
 }
 
-static int __set_pages_p(struct page *page, int numpages)
+static int __set_pages_p(struct page *page, int numpages, unsigned int cpa_flags)
 {
 	unsigned long tempaddr = (unsigned long) page_address(page);
 	struct cpa_data cpa = { .vaddr = &tempaddr,
@@ -2597,7 +2625,7 @@ static int __set_pages_p(struct page *pa
 				.numpages = numpages,
 				.mask_set = __pgprot(_PAGE_PRESENT | _PAGE_RW),
 				.mask_clr = __pgprot(0),
-				.flags = CPA_NO_CHECK_ALIAS };
+				.flags = CPA_NO_CHECK_ALIAS | cpa_flags };
 
 	/*
 	 * No alias checking needed for setting present flag. otherwise,
@@ -2608,7 +2636,7 @@ static int __set_pages_p(struct page *pa
 	return __change_page_attr_set_clr(&cpa, 1);
 }
 
-static int __set_pages_np(struct page *page, int numpages)
+static int __set_pages_np(struct page *page, int numpages, unsigned int cpa_flags)
 {
 	unsigned long tempaddr = (unsigned long) page_address(page);
 	struct cpa_data cpa = { .vaddr = &tempaddr,
@@ -2616,7 +2644,7 @@ static int __set_pages_np(struct page *p
 				.numpages = numpages,
 				.mask_set = __pgprot(0),
 				.mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY),
-				.flags = CPA_NO_CHECK_ALIAS };
+				.flags = CPA_NO_CHECK_ALIAS | cpa_flags };
 
 	/*
 	 * No alias checking needed for setting not present flag. otherwise,
@@ -2629,20 +2657,20 @@ static int __set_pages_np(struct page *p
 
 int set_direct_map_invalid_noflush(struct page *page)
 {
-	return __set_pages_np(page, 1);
+	return __set_pages_np(page, 1, 0);
 }
 
 int set_direct_map_default_noflush(struct page *page)
 {
-	return __set_pages_p(page, 1);
+	return __set_pages_p(page, 1, 0);
 }
 
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 {
 	if (valid)
-		return __set_pages_p(page, nr);
+		return __set_pages_p(page, nr, 0);
 
-	return __set_pages_np(page, nr);
+	return __set_pages_np(page, nr, 0);
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
@@ -2661,15 +2689,23 @@ void __kernel_map_pages(struct page *pag
 	 * and hence no memory allocations during large page split.
 	 */
 	if (enable)
-		__set_pages_p(page, numpages);
+		__set_pages_p(page, numpages, CPA_DEBUG_PAGEALLOC);
 	else
-		__set_pages_np(page, numpages);
+		__set_pages_np(page, numpages, CPA_DEBUG_PAGEALLOC);
 
 	/*
-	 * We should perform an IPI and flush all tlbs,
-	 * but that can deadlock->flush only current cpu.
-	 * Preemption needs to be disabled around __flush_tlb_all() due to
-	 * CR3 reload in __native_flush_tlb().
+	 * We should perform an IPI and flush all tlbs, but that can
+	 * deadlock->flush only current cpu.
+	 *
+	 * Not doing a global TLB flush means that remote CPUs will retain
+	 * stale TLB entries. In case of P->NP (on free) this means the remote
+	 * CPUs will not take the faults, making the debug scheme less
+	 * reliable. On the NP->P (on alloc) this means the remote CPUs can
+	 * take a spurious fault. However spurious_kernel_fault() will observe
+	 * *_present() and fix it up.
+	 *
+	 * Preemption needs to be disabled around __flush_tlb_all() due to CR3
+	 * reload in __native_flush_tlb().
 	 */
 	preempt_disable();
 	__flush_tlb_all();



