Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F262CD43369
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 04:27:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57B506B0006; Thu, 11 Dec 2025 23:27:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5520B6B0007; Thu, 11 Dec 2025 23:27:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4681E6B0008; Thu, 11 Dec 2025 23:27:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 376BD6B0006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 23:27:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B5E6858D76
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:27:24 +0000 (UTC)
X-FDA: 84209534808.28.23027A1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 366CF20002
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:27:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765513643; a=rsa-sha256;
	cv=none;
	b=m3X4U5IY02kIDwWjUDHAC1t656rf4zuzGpqNICYZ3JXxldjqrrVFfj9q0qBfVFXZFPAH1j
	+bSV/9a9CWecrhmpwn0CTNcCiht2c9DQZEvYhIAeG0IblUTK1ltYdep4VMIrjxTpKIK48Q
	DpDGYJx3wA9izSVHZFDRCwkKWBVQA84=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765513643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YsTI/gKXS1+wHS9HMvLrVaa5BkCT1pT09kcU0UXd/zI=;
	b=CcaRjI0xPH9Xir7ujvsmyt2gTUtIs0tSxydG8s6FCVcepmIagxN2W2v7dkKC3ldeq5UnoE
	FGLF/eEl8Z1V8D1vtZuNst+vy1AGUMKM8XGVD6rEefIghuQHN+s14mUtVA3VntFCEQAFhZ
	Hs7V7G20HInvxaKeEH1uX+evgDzigPs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCF091063;
	Thu, 11 Dec 2025 20:27:14 -0800 (PST)
Received: from MacBook-Pro.blr.arm.com (MacBook-Pro.blr.arm.com [10.164.18.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 23C983F762;
	Thu, 11 Dec 2025 20:27:15 -0800 (PST)
From: Dev Jain <dev.jain@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	urezki@gmail.com,
	akpm@linux-foundation.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	cem@kernel.org
Cc: ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	shijie@os.amperecomputing.com,
	yang@os.amperecomputing.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	npiggin@gmail.com,
	willy@infradead.org,
	david@kernel.org,
	ziy@nvidia.com,
	Dev Jain <dev.jain@arm.com>
Subject: [RESEND RFC PATCH 1/2] mm/vmalloc: Do not align size to huge size
Date: Fri, 12 Dec 2025 09:57:00 +0530
Message-Id: <20251212042701.71993-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20251212042701.71993-1-dev.jain@arm.com>
References: <20251212042701.71993-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 366CF20002
X-Stat-Signature: 8iuwwo1e7sb5mxodjn8oe7jt5nifnnw5
X-Rspam-User: 
X-HE-Tag: 1765513642-726971
X-HE-Meta: U2FsdGVkX1+ICmci5rEarXiLRbbZg7gKN5WjQkWuGR76qvkAGIGyWhrfPyz6b53rYFRx3KfnvTC5Bz1kDBLr3Hovxr6vFsI/Z0WDEiBM8r8gpUMuTllwPi8oELUqmEDprU8OgImcjOscAhmfGIK8s5+q8uqiGqCw4ey1IZ5tfgETZa3GKu1QNflrWiDQ4Rc8rMu+nRIemUFO9XggHQ9Oeooas58o2Tq0mEUwdaiAPnjYOg1j7XN4/oq0A65DBf+HrvD4HIugPvjyic1wSYEawK63pgvkE2+jxmHXRQoGKISHmbQVaFXIdRAsS0I3qgIj2F1Dhx5FBiZAyslEgaszRiSi5ppw73M45N+Z/zA+eQZlRvmK4Bz7h++nB0GI4sm6VBk/w4TcPugmVKmLpRrv7qcRqVd0uPNDI3AEY/C6lEs8sccK8/iZ1ROfO5Y9tqY49V6auP+QB4ec9GWWU7jLjcsHlaat+L6nfTYqMIT94+Wra+vZ42oHx3+lcph2R7WD7XL+6B35w7xexeAwhk8g9YuzvsnXUrbe60ATpAe+Soaty2VHcmvEX/MM6docCa/wIru/u5gencwA7zNWa85BUPfgj/pbHFpEI5i9kYUr1xnRBkZxGudXvhYAPsF334rTk0nxlM+TIxzcvL/v1EkPG9Fc5QInLpRjJfd92T2OtKRHY0e3tJna9exbdJdk3pNd6RqRAbQ7and7nGUlhrHxY7Ud8vu7xpbmn8wlZHQkuJ8RnT6xydy75Z0dTDBL80lkOSaI4wE1EhRCCpBcXRzPMhD8X6zc7Yb6LBEsbxU4845ZSaEblQuCrMOLdHMgFEN6STLCQFiRg+NCbLculPGdig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmalloc() consists of the following:

(1) find empty space in the vmalloc space -> (2) get physical pages from
the buddy system -> (3) map the pages into the pagetable.

It turns out that the cost of (1) and (3) is pretty insignificant. Hence,
the cost of vmalloc becomes highly sensitive to physical memory allocation
time.

Currently, if we decide to use huge mappings, apart from aligning the start
of the target vm_struct region to the huge-alignment, we also align the
size. This does not seem to produce any benefit (apart from simplification
of the code), and there is a clear disadvantage - as mentioned above, the
main cost of vmalloc comes from its interaction with the buddy system, and
thus requesting more memory than was requested by the caller is suboptimal
and unnecessary.

This change is also motivated due to the next patch ("arm64/mm: Enable
vmalloc-huge by default"). Suppose that some user of vmalloc maps 17 pages,
uses that mapping for an extremely short time, and vfree's it. That patch,
without this patch, on arm64 will ultimately map 16 * 2 = 32 pages in a
contiguous way. Since the mapping is used for a very short time, it is
likely that the extra cost of mapping 15 pages defeats any benefit from
reduced TLB pressure, and regresses that code path. 

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/vmalloc.c | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ecbac900c35f..389225a6f7ef 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -654,7 +654,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
-	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
+	unsigned int i, step, nr = (end - addr) >> PAGE_SHIFT;
 
 	WARN_ON(page_shift < PAGE_SHIFT);
 
@@ -662,7 +662,8 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 			page_shift == PAGE_SHIFT)
 		return vmap_small_pages_range_noflush(addr, end, prot, pages);
 
-	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
+	step = 1U << (page_shift - PAGE_SHIFT);
+	for (i = 0; i < ALIGN_DOWN(nr, step); i += step) {
 		int err;
 
 		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
@@ -673,8 +674,9 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 
 		addr += 1UL << page_shift;
 	}
-
-	return 0;
+	if (IS_ALIGNED(nr, step))
+		return 0;
+	return vmap_small_pages_range_noflush(addr, end, prot, pages + i);
 }
 
 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
@@ -3197,7 +3199,7 @@ struct vm_struct *__get_vm_area_node(unsigned long size,
 	unsigned long requested_size = size;
 
 	BUG_ON(in_interrupt());
-	size = ALIGN(size, 1ul << shift);
+	size = PAGE_ALIGN(size);
 	if (unlikely(!size))
 		return NULL;
 
@@ -3353,7 +3355,7 @@ static void vm_reset_perms(struct vm_struct *area)
 	 * Find the start and end range of the direct mappings to make sure that
 	 * the vm_unmap_aliases() flush includes the direct map.
 	 */
-	for (i = 0; i < area->nr_pages; i += 1U << page_order) {
+	for (i = 0; i < ALIGN_DOWN(area->nr_pages, 1U << page_order); i += (1U << page_order)) {
 		unsigned long addr = (unsigned long)page_address(area->pages[i]);
 
 		if (addr) {
@@ -3365,6 +3367,18 @@ static void vm_reset_perms(struct vm_struct *area)
 			flush_dmap = 1;
 		}
 	}
+	for (; i < area->nr_pages; ++i) {
+		unsigned long addr = (unsigned long)page_address(area->pages[i]);
+
+		if (addr) {
+			unsigned long page_size;
+
+			page_size = PAGE_SIZE;
+			start = min(addr, start);
+			end = max(addr + page_size, end);
+			flush_dmap = 1;
+		}
+	}
 
 	/*
 	 * Set direct map to something invalid so that it won't be cached if
@@ -3673,6 +3687,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	 * more permissive.
 	 */
 	if (!order) {
+single_page:
 		while (nr_allocated < nr_pages) {
 			unsigned int nr, nr_pages_request;
 
@@ -3704,13 +3719,18 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			 * If zero or pages were obtained partly,
 			 * fallback to a single page allocator.
 			 */
-			if (nr != nr_pages_request)
+			if (nr != nr_pages_request) {
+				order = 0;
 				break;
+			}
 		}
 	}
 
 	/* High-order pages or fallback path if "bulk" fails. */
 	while (nr_allocated < nr_pages) {
+		if (nr_pages - nr_allocated < (1UL << order)) {
+			goto single_page;
+		}
 		if (!(gfp & __GFP_NOFAIL) && fatal_signal_pending(current))
 			break;
 
@@ -5179,7 +5199,9 @@ static void show_numa_info(struct seq_file *m, struct vm_struct *v,
 
 	memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
-	for (nr = 0; nr < v->nr_pages; nr += step)
+	for (nr = 0; nr < ALIGN_DOWN(v->nr_pages, step); nr += step)
+		counters[page_to_nid(v->pages[nr])] += step;
+	for (; nr < v->nr_pages; ++nr)
 		counters[page_to_nid(v->pages[nr])] += step;
 	for_each_node_state(nr, N_HIGH_MEMORY)
 		if (counters[nr])
-- 
2.30.2


