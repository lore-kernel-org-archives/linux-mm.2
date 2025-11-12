Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7AE7CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 11:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AAAF8E0021; Wed, 12 Nov 2025 06:08:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45B088E001A; Wed, 12 Nov 2025 06:08:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 349BD8E0021; Wed, 12 Nov 2025 06:08:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 20DBA8E001A
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:08:26 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF399140463
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:08:25 +0000 (UTC)
X-FDA: 84101681370.15.DFC1C2E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 378DC4000D
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:08:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762945704; a=rsa-sha256;
	cv=none;
	b=xZv+uQddwOzKoxbF02JCJrXyrttrgjMXh1lYb/KGZ815gEFiv1aXlQMeTvlVCxZA8sFr79
	mNQaVusnvrhXe/Azbo9w9aCTl8VyqB8VMqmxBufuwBMTPKPj70rjdcQQUdrHJjBdYXurha
	DgLwkaGhowUk50s7fo5UkY5QaDZb0Jg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762945704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eaY9qzSEuHwDMfDqM2mSbh8XyoCRrbKT1zEVawsT8+w=;
	b=6wrchNygA7R5f7/Rb0UzfzyTlKa0cuyhbaEEi09nNuwaO611kKk0w8h7rAujs2MMvZfo5n
	L5tFm6WOdfAq7MX6FeFRQdSaAm4CaB8mLl+/zfXvQVcTG+n6vRiH18cUlRM2JnUXYPTqMz
	k8N7DzwL5pMFT58NXgJVl5O9VzBhjA8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B70531595;
	Wed, 12 Nov 2025 03:08:15 -0800 (PST)
Received: from MacBook-Pro.blr.arm.com.com (unknown [10.164.18.56])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 58F5D3F66E;
	Wed, 12 Nov 2025 03:08:18 -0800 (PST)
From: Dev Jain <dev.jain@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	urezki@gmail.com,
	akpm@linux-foundation.org
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
Subject: [RFC PATCH 1/2] mm/vmalloc: Do not align size to huge size
Date: Wed, 12 Nov 2025 16:38:06 +0530
Message-Id: <20251112110807.69958-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20251112110807.69958-1-dev.jain@arm.com>
References: <20251112110807.69958-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 378DC4000D
X-Rspamd-Server: rspam07
X-Stat-Signature: uxwkscs9pd8mzi67g98bgfk375h9gwk8
X-Rspam-User: 
X-HE-Tag: 1762945703-576715
X-HE-Meta: U2FsdGVkX18amt9YKVPzopRVMLuCaE5wSJTEmltx09VOuRJ2oGKMY8YAERXzyDyXfHWm+NQiBAFQ2l8T8DJYZfM1q9oepCGTUvg8o0sWryTb8zr/90+nBlFALa5ptmGqi/DWSojV7t0Gvtc40HQadEvbVT1bWWrlQveEbqiVjFy4fw1Q4wuBPIGSl367V+1oRXM4BFnse/5UnEAz9yp02kmBFNuE0pYohiQFJ36A1V7Wk9KheiJCKiQPc+j4GLZiP0xq4hJiHs9SiAkT7frALZoRaqiZCMo+G8GTKcPzaRVAe0ZWn5FsmU75nxmQgGX8DFlz+gfYzX6eplU1FgZcKwB1lK/XK1kuRT7oLJPJaopv/XrHkU1LyHq6YDcvR135eWmfVxynVqUgmPxYcbVHBxvsefc/u7vPX4+AAHtdChzds2lnJwIhWJQevrpOifJBEt8fdFhXKIgvM62Vu263O8xNzjfsJxIsbPh30fpA8lAWc2wfvjJw5RswcauyUMQ6lUq/rmQ53AcMc6jEZ8u+AyPxYrkwuw05MgyjjikQ7cSVFls4iqoaLDNPoKsBY59B8JxKdMEO53vebX5VRCB19yszjhwlNz7H9yfPXlUK9wE6xgH9lB0Sa0iHOQ75XRHGJt/NHsaRGm95ROXrjgEAU67qkslgvjFBwmCE8LDATR89NjC43f2h+c7sfdZM9M0DfauMbLGWjLcURY9QDggYXP/PlIKf9f/eIhdTRr/MrtW/HafQP0UAQtIMa2Id3/8DXvpDby2w6+FiDC94FWfFaW+EKYE3qdDUW1M6TgW9nZ7KGyj9arASQiX/2a0yl54uo4lPLxZtAMs3GQCoZzx/twfTiTngIvtcKrev1oteCmClAPdZu8/ct3P9ZilOopt0oGfpw4Iqrpxp+gFR/DvGCeKYllpMTj4kfuwPAygg4c23Gzr/4zSNTz9dIRkxut1j9Y6hnCVBVBgJWDNSHbd
 hLn4HQc7
 T56MlpJh6AHs8tPeu4I+aL73/yoFCQC1XaSb7xd5eJjjzd6dgsF6kN4wkvGRCCOUvqdLx3/4D2fLLifXw9eV6UARw/aKfkka6cBPBr25FJf2JEUdN3GwUSV7lcTA1WKy7UExuxuHDdXJUtWyT1bRAIq/NLQ==
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
index 798b2ed21e46..ddd9294a4634 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -647,7 +647,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
-	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
+	unsigned int i, step, nr = (end - addr) >> PAGE_SHIFT;
 
 	WARN_ON(page_shift < PAGE_SHIFT);
 
@@ -655,7 +655,8 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 			page_shift == PAGE_SHIFT)
 		return vmap_small_pages_range_noflush(addr, end, prot, pages);
 
-	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
+	step = 1U << (page_shift - PAGE_SHIFT);
+	for (i = 0; i < ALIGN_DOWN(nr, step); i += step) {
 		int err;
 
 		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
@@ -666,8 +667,9 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 
 		addr += 1UL << page_shift;
 	}
-
-	return 0;
+	if (IS_ALIGNED(nr, step))
+		return 0;
+	return vmap_small_pages_range_noflush(addr, end, prot, pages + i);
 }
 
 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
@@ -3171,7 +3173,7 @@ struct vm_struct *__get_vm_area_node(unsigned long size,
 	unsigned long requested_size = size;
 
 	BUG_ON(in_interrupt());
-	size = ALIGN(size, 1ul << shift);
+	size = PAGE_ALIGN(size);
 	if (unlikely(!size))
 		return NULL;
 
@@ -3327,7 +3329,7 @@ static void vm_reset_perms(struct vm_struct *area)
 	 * Find the start and end range of the direct mappings to make sure that
 	 * the vm_unmap_aliases() flush includes the direct map.
 	 */
-	for (i = 0; i < area->nr_pages; i += 1U << page_order) {
+	for (i = 0; i < ALIGN_DOWN(area->nr_pages, 1U << page_order); i += (1U << page_order)) {
 		unsigned long addr = (unsigned long)page_address(area->pages[i]);
 
 		if (addr) {
@@ -3339,6 +3341,18 @@ static void vm_reset_perms(struct vm_struct *area)
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
@@ -3602,6 +3616,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	 * more permissive.
 	 */
 	if (!order) {
+page_map:
 		while (nr_allocated < nr_pages) {
 			unsigned int nr, nr_pages_request;
 
@@ -3633,13 +3648,18 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
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
+		if (nr_pages - nr_allocated < (1UL << order))
+			goto page_map;
+
 		if (!(gfp & __GFP_NOFAIL) && fatal_signal_pending(current))
 			break;
 
@@ -5024,7 +5044,9 @@ static void show_numa_info(struct seq_file *m, struct vm_struct *v,
 
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


