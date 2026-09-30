Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E773CA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 19:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C6556B0088; Wed, 30 Sep 2026 15:01:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59E0D6B008A; Wed, 30 Sep 2026 15:01:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DB646B008C; Wed, 30 Sep 2026 15:01:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 214E36B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:01:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A276A401A2
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 19:01:15 +0000 (UTC)
X-FDA: 85271346510.06.47C9A27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B4E2E16000E
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 19:01:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AfOugEP9;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790794873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZ9p+0TXsTapVE0fUDcxcrxFDfTJp6cr+bt+UngMYk0=;
	b=Y8GRT/ZVKP6zLk4YrAz692Bj5ixIMhWZiGPdm2OpWIN2OAAcAu6fHTz5FaOko7gvYcvJQ7
	mZ6kaNjjQ8+lt909zTqJDMvRdFsT5jUyjgCXKW8MN+bY+lzU9rGpIFYQzuouYYyQu1Iklk
	BW/eYXWHanvvFquGpv7nhoPjlQrcNJU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AfOugEP9;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790794873;
	b=oD+6H1IYWq3Hj42pxkKU24Sz5/kLBuZYgBV7cHh/utOesLelkXW+Qsm1BucPUh+8Sq/U7k
	+vf0+CBrMTysJV7bFeEwOg+E3IAeMvLEazHgU6/LugoKN29O3U0pL9TV0ZhMzcNFu3xeQx
	8BLW9aEUaX6GgW8KDaf1wr4QJiFxnrI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 16668402BF;
	Wed, 30 Sep 2026 19:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617E41F008A1;
	Wed, 30 Sep 2026 19:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790794872;
	bh=XZ9p+0TXsTapVE0fUDcxcrxFDfTJp6cr+bt+UngMYk0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AfOugEP91NYVCmPmVOD6zXRVsG4tpdYvKHH57PQ0NhP32hoFVSp1mwVpKuJGcbMxk
	 IVSyP/V5SJfJtM+kNKQQES/oP7r4sOtjDeBVT04Y6h8Pa9lfdAvwu2qn4YVNUMYTjK
	 xoz1+LkQVNjPzQr88ZznUqCs7RO5t9ViwPP+3GVQ=
Date: Wed, 30 Sep 2026 12:01:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael
 Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org, Muchun Song
 <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Nicholas Piggin
 <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Ritesh Harjani
 <ritesh.list@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, Randy
 Dunlap <rdunlap@infradead.org>, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v6 00/12] mm: Switch device DAX to section-based vmemmap
 optimization
Message-Id: <20260930120110.3ace5f23b7530e179272fac4@linux-foundation.org>
In-Reply-To: <20260930140627.57431-1-songmuchun@bytedance.com>
References: <20260930140627.57431-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: u74iz9guj488ogxsz4f9zbcy8wudusej
X-Rspamd-Queue-Id: B4E2E16000E
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790794873-916230
X-HE-Meta: U2FsdGVkX1/oxk3QlmK89/tbM6A5rwOcJkgB/0f5OT0Vj1Bo2+nutVOFzL3RRo7/xzok9TwzCgW7mpVW2HAsTjx3QzbR0yQavDxpgw4yVO5xdSKYURh4GE5wK0KXN1aax/0skYPsmn44B2mursPOGrB7Hhs5WqFXtAcC4tPwb9V8SjVuTnQ+TMqwaBA/l1tEjcMabxChaQ7+xeyONN4TKMM+gHO5MZj2GRw7d3atfkG3II/cg5XRqie8D9JYn5G0Cbpg9HlKtMGTPmOtFPi5Xifr6qweRxexu1HLLZhXeT2bQf7EPJnvS8ldFEY7eUjZmbrxnAi/huT6NKzqQuREDe+siosoS70lGy0gDUz/Nx2XmaiyjK+l2YpApdHT6H2WJWdL9pun6OEaFkaEzEaxghBQueRzJkn/CeFm2n0lI1bO8e4d3hjo7+RjFiNhHGMqV+KflAzYGS/A0PCHAk5kKhoEusw71rEM1ijSZcBu1R9XcUKegN301Is+r9V/CHnj/usfJwE0skXOSm1Ak+iBVCqDddLSvNNSlr1Z3AwsPjDW9mxieO4IC54cPnWdGmbJtIrErnb8ynh1+U8QwrYgfIphsQ2V/hoY/orwbnMZbf6SUT7A/UTTp9x7KmpOFe8FYHjlSvzmEq9Ojr3zY/WgaabGcbT184v4v7SoK5bMe19Suh84IV+e6uyrx5YsDfsSCVMPrUsqLo+Dsfhgwz/bKrCotEQF6NZQuaHqxpmYcwZbZKTdm4vlLdnZO5DHPO/WXVX5hNzzfhWymlaieNvhSu4wBDEL0m05l8oWXK97jsRHLVjWRgiHpDIJSUzOjgXZXSL/wBAKq3B2bc8RSjsRBgIWU4uB04lfEbEB+3dfMjSy9eNDASmpFqDd/GukTmiOvLH25iCAn042EhGTIYuFptMuiVbPS0rYwmV8XZfTyuHKGepUuPhOr8bWAEYk4pBBZfLvWfMdwyNuWI5cxGE
 Ha9hCPs0
 X9DhRrGfhMIMueTLCDYEL8g+qKheBrCCDoOS4BG7iXDZuPYKBwwIrAM6hwwsuz3aVSN7Y/3JOQXGQF3Z55j9noEtbzsY3QUompTcPIu2na5V4vy470sfYrYi+6CnegDZ5OMNvYZqBksuOHJwek0yK+bUIYpT4ScBturHDuqpFYDHMwoCtEMCmbeP2tVJFLjKWWcx4pPv8gMLllpXCaEzcgtIcj6OXlQoIW1vieleExCSz+zJAWqXVyevFR+qC6kxGvhaEITPxgegxvNemRyzMOfJo0S13fhM8X9j0jXq0EJ0mI0MCfUEF0HISL3qZSpLN8PRFBIALFcWpNVo3yVtDCcXfeewhZZn3QXoU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Sep 2026 22:06:15 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> This version is based on mm-new commit a878c908dc92.
> 
> This series is split out from the earlier, larger series "mm: Generalize
> HVO for HugeTLB and device DAX" [1]. While the parent series generalizes
> vmemmap optimization across HugeTLB and device DAX, this subset addresses
> a single, self-contained step: switching device DAX to the section-based
> sparse-vmemmap optimization infrastructure introduced for HugeTLB.
> 
> After the HugeTLB conversion, optimized vmemmap state is described by
> the memory section and the sparse-vmemmap population path can allocate or
> reuse shared tail vmemmap pages based on that metadata. Device DAX still
> uses the older DAX-specific population model, including a separate tail
> vmemmap page reservation and architecture-specific logic to locate or
> populate reusable tail pages.
> 
> This series makes device DAX use the same section-based model. Device DAX
> records the compound page order from pgmap->vmemmap_shift in section
> metadata before vmemmap population, uses the common per-zone shared tail
> vmemmap page, and drops the extra reserved tail page. The powerpc radix
> path is updated to use the same shared tail-page helper, so the generic
> and powerpc DAX paths follow the same reservation model.
> 

Thanks.  I updated mm-unstable to this version.

> 
> v6:
> - Use try_get_page() to prevent the shared device DAX tail-page
>   reference count from overflowing (suggested by Andrew Morton,
>   reported by Sashiko)
> - Move constant declarations to the top of their functions and fold
>   the shared tail-page array lookup into vmemmap_tails() (suggested by
>   David Hildenbrand)
> - Clarify the DAX population flag description and why optimized tail
>   pages must not be poisoned (suggested by David Hildenbrand)
> - Collect Acked-by tags from David Hildenbrand
> - Rebase onto mm/mm-new


Here's how v6 altered mm.git:


 arch/powerpc/mm/book3s64/radix_pgtable.c |    8 +++--
 mm/sparse-vmemmap.c                      |   32 ++++++++++++---------
 2 files changed, 25 insertions(+), 15 deletions(-)

--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~b
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1042,13 +1042,17 @@ static pte_t * __meminit radix__vmemmap_
 			/*
 			 * When a PTE/PMD entry is freed from the init_mm
 			 * there's a free_pages() call to this page allocated
-			 * above. Thus this get_page() is paired with the
+			 * above. Thus this try_get_page() is paired with the
 			 * put_page_testzero() on the freeing path.
 			 * This can only called by certain ZONE_DEVICE path,
 			 * and through vmemmap_populate_compound_pages() when
 			 * slab is available.
+			 *
+			 * Use try_get_page() to prevent the shared page refcount
+			 * from overflowing.
 			 */
-			get_page(reuse);
+			if (!try_get_page(reuse))
+				return NULL;
 			p = page_to_virt(reuse);
 			pr_debug("Tail page reuse vmemmap mapping\n");
 		}
--- a/mm/sparse-vmemmap.c~b
+++ a/mm/sparse-vmemmap.c
@@ -170,10 +170,14 @@ static void * __meminit vmemmap_alloc_bl
 #ifdef CONFIG_VMEMMAP_OPTIMIZATION
 #define VMEMMAP_OPTIMIZATION_NR_ORDERS	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
 
-static __ref struct page **vmemmap_tails_alloc(struct zone *zone)
+static __ref struct page **vmemmap_tails(struct zone *zone)
 {
-	struct page **pages;
-	const size_t size = array_size(VMEMMAP_OPTIMIZATION_NR_ORDERS, sizeof(*pages));
+	const size_t size = array_size(VMEMMAP_OPTIMIZATION_NR_ORDERS,
+				       sizeof(*zone->vmemmap_tails));
+	struct page **pages = READ_ONCE(zone->vmemmap_tails);
+
+	if (pages)
+		return pages;
 
 	pages = slab_is_available() ? kzalloc_objs(*pages, VMEMMAP_OPTIMIZATION_NR_ORDERS) :
 		memblock_alloc(size, __alignof__(*pages));
@@ -193,19 +197,19 @@ static __ref struct page **vmemmap_tails
 
 struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zone)
 {
-	void *addr;
-	struct page *page, **pages;
 	const unsigned int idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
+	struct page *page, **pages;
+	void *addr;
 
 	if (WARN_ON_ONCE(idx >= VMEMMAP_OPTIMIZATION_NR_ORDERS))
 		return NULL;
 
-	pages = READ_ONCE(zone->vmemmap_tails) ? : vmemmap_tails_alloc(zone);
+	pages = vmemmap_tails(zone);
 	if (!pages)
 		return NULL;
 
 	page = READ_ONCE(pages[idx]);
-	if (likely(page))
+	if (page)
 		return page;
 
 	addr = vmemmap_alloc_block(PAGE_SIZE, zone_to_nid(zone));
@@ -218,9 +222,9 @@ struct page __ref *vmemmap_shared_tail_p
 		atomic_set(&page->_mapcount, -1);
 		set_page_node(page, zone_to_nid(zone));
 		set_page_zone(page, zone_idx(zone));
-		prep_compound_tail(page, NULL, order);
 		if (zone_is_zone_device(zone))
 			__SetPageReserved(page);
+		prep_compound_tail(page, NULL, order);
 	}
 
 	page = virt_to_page(addr);
@@ -528,12 +532,12 @@ static int __meminit vmemmap_populate_co
 						     unsigned long end, int node,
 						     struct dev_pagemap *pgmap)
 {
+	const unsigned long flags = VMEMMAP_POPULATE_DAX;
+	const unsigned int order = pfn_to_section_compound_order(start_pfn);
 	unsigned long size, addr;
 	pte_t *pte;
-	int rc;
-	unsigned long flags = VMEMMAP_POPULATE_DAX;
 	struct page *page;
-	unsigned int order = pfn_to_section_compound_order(start_pfn);
+	int rc;
 
 	page = vmemmap_shared_tail_page(order, device_zone(node));
 	if (!page)
@@ -891,8 +895,10 @@ int __meminit sparse_add_section(int nid
 
 	ms = __nr_to_section(section_nr);
 	/*
-	 * Poison uninitialized struct pages in order to catch invalid flags
-	 * combinations.
+	 * Poison uninitialized struct pages to catch invalid flag combinations.
+	 *
+	 * Tail struct pages in a vmemmap-optimized section are initialized and
+	 * shared during vmemmap population, so they must not be overwritten here.
 	 */
 	if (!section_vmemmap_optimizable(ms))
 		page_init_poison(memmap, sizeof(struct page) * nr_pages);
_


