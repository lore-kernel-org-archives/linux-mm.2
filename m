Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A362C4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FA176B00A9; Tue, 14 Jul 2026 23:19:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2DF6B00AB; Tue, 14 Jul 2026 23:19:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C0FE6B00AC; Tue, 14 Jul 2026 23:19:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8AB76B00A9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:19:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B91F214051B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:01:11 +0000 (UTC)
X-FDA: 84989509542.06.57A2943
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id BE03E40008
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:01:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fANSM0xA;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784084469;
	b=DeJdDUVnouqYbCnURFi6Te8oFy5Txjztnq2Udf07Dm0hpcielP8R1xEdaT0LXtHwphk2Ym
	RX1iTVfRkaQ63OlciFAiXJYPVrga+8mRAu8BrbjTn7OcwscHI9IvBqANi2S6/OW6W43m4z
	uDzcTu/wBoS4EvwqElAHcd3OEisFz2o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fANSM0xA;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784084469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u9NeLOAHalnwve7oIbZyE7s1kBR3uoq+RYEBdfdmZFo=;
	b=NpJefbHeLbencAg1XWRLwgoDO8596wumjxdrnGL89B+UWoaz9IZ1YrjKZt3GeqAUA+2lr0
	STaSEbgfbEiTXcoHzdgGL6D3MJB1WK7aggN+7Lxjjl7/7HraC5Ma7vmcBmwZqckNVFfhTK
	Ou/vVxQIOCZLGE5evKfnMUprRGzbYsA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784084469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u9NeLOAHalnwve7oIbZyE7s1kBR3uoq+RYEBdfdmZFo=;
	b=fANSM0xAvb53qXH+w+/p5Kci//8hRpeI2uvo/DSwdi/bwZakT1GJl5eabFthv/NlaIXcy6
	283p8wAXj/bD6iN7QS1LranrUUdRXPZNJvcqD8nx5WCLnZel393AIU7Pi/8bPdTnaSKisN
	ygzsBRzZXI8THs8jZJ0FX/ZKH95k8Mk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-312-LRRND7mMPyKkeWf9L7zlfA-1; Tue,
 14 Jul 2026 23:01:02 -0400
X-MC-Unique: LRRND7mMPyKkeWf9L7zlfA-1
X-Mimecast-MFC-AGG-ID: LRRND7mMPyKkeWf9L7zlfA_1784084460
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 302EE180034C;
	Wed, 15 Jul 2026 03:01:00 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.76.5])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 36D10180028B;
	Wed, 15 Jul 2026 03:00:50 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Nico Pache <npache@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v2 5/7] mm/khugepaged: Refactor the PTE state checks into a helper
Date: Tue, 14 Jul 2026 20:59:34 -0600
Message-ID: <20260715025941.1571316-6-npache@redhat.com>
In-Reply-To: <20260715025941.1571316-1-npache@redhat.com>
References: <20260715025941.1571316-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: KKIOMarKQk2QBE8Bj57Jg_Op-sv9Ge2CkXhBX4RIsT8_1784084460
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BE03E40008
X-Stat-Signature: fbigg5ejk7f634ykc8txtnijphgx4tek
X-HE-Tag: 1784084469-874666
X-HE-Meta: U2FsdGVkX19HsH3VBZV/2thTHQbMLVvZKABGuodm2u+BhBSYfq2GvafG1GZceBdHBqHlMOCBdmy2mCWwqYnqiLUz29Jpeb3TjVytM7CwJKTqI0ZyAyZ5AP8g3tC4Vlbjrxe58LdkNmWemh61puWCuxrDM5tTjz707uLOeesbBqqs+CGKEnHSlUS/A/RIUT8TdZLwBVqF2YaQJJENQTbq5us1TAuSWBpparre8S7fMXzAvHwmaX54v32Q/YDhlANgtP0/eRFjxC31PVoJyg9UCL9MVB3GzXPz4jEySZFpt0usXxIO5ev2jrDcRQwsal2boKabY+WpWHWfiSrFbog2Or0LnNrG7ytRmE2VaMl0dXjIz6LOD2nN/UIaJ0xxeKhNnozZRBydqYg6hMYuGDgVN3U+ZSBxisI+DzSxFxTu9XRvSfs8S1w3qV4ywP7qa+04DX1GSw7aIHCEkelfzMHRRNboWRLuDrLfrBxqCzEhmzp/cJbbDdU0HN85zPGCjFBUhLQMlCUBtNKMtdzUKCbwNTlPe2Y7p0IHppkFQJlezNSOlfdBGwqeep0dWoi1XomSyuVJohD5l9GnaIx50j7pauqpc2Ygeh0X2D/M07jc06EAmcBNv3MSQrlAYU+Z9KcPhpC4jJzRek1ydBWuCb58Xqwjfd3ht85m9Llia8HnbU33EwnCnL2NeY9wBcqofZTnKI+hJQZPQ3gFSQTncHxWmirebtEXjFFmeN/NIoy+vRDxSfFrM+cfA9+V5uwOUmReMmVMlROkqijMKXbQOoe2bbVspVH8Phdj7YDAkkI1snIOEh4SGjxgY6HF/4D2XeTrNfCk5a0xrU7PeMjRyrAfpK8tm6IvJHpPjGv33ytJ2fcNGlejIIJMov9mk9O+kTboOaYt0U2uXA22D1LU5owglqxpqB8Ft3XS+x6QzDjqx/nUZ+Et87UkFwv4I68ZNCk81DEgmeR0tVi4nAamEF0
 AzPUG1qt
 2hBp5KfqpPjtrg9RwOxBIBsENTcMMpz0RNbHjnO4Dko2Ptn0lZyPbcMKZWWeJh6FasG+Pkju6YCoFrL71J/i95EnR7mPbRLqMqZ6ac1dk2TtHR+74FDmHoKcbOp+0E6JzPKfOoHfqSUPvQrdXftGQVCaC4Ze0biOqNR85xRLA2ivwbqx+J7ISFp2dGASAXevm9Tf1YilZAOUDH8f3BtsdPMh83ugycnWpgmNFUdmIEP7PA0tWqV9mwwPWhweAb0rvpdzSQjV+SlJTnE7FODcfs5n5w1zy5CdorgvlUFnBaXSTUJpxM6IdO5R7dw7Ao5ND+RTb87+iS2Ypi6vYX6KlNqqRLAgrgNmMRJ2XZpy1Rn097yg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For anonymous collapse, the collapse_scan_pmd() and
__collapse_huge_page_isolate() functions share a large portion of their
logic. These functions both check the state of the PTEs and verify the
following:
	- max_pte_* values are not exceeded
	- uffd is not active
	- lazyfree properties
	- non-anonymous

Merge these checks into a helper collapse_check_pte() to reduce code
duplication. We also add a helper struct for this function called
pte_check_context which allows us to pass the required parameters in a
clean and elegant manner.

A helper function is also introduced pte_check_fail() to provide a clean
interface to set the pte_check_context failure results and return
PTE_CHECK_FAIL state. This helps reduce code duplications across the new
collapse_check_pte function.

Two slight modifications are done to the original functionality. We now
warn (instead of crash) if the anon test fails, and we leverage the
vm_normal_folio function instead of page->folio, this should be
functionally equivalent.

No other functional changes intended.

This patch is heavily based off work done by Lance Yang, but modified to
deal with conflicts and feedback received during the review cycle [1].

[1] https://lore.kernel.org/linux-mm/20251008043748.45554-1-lance.yang@linux.dev/
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 298 +++++++++++++++++++++++++-----------------------
 1 file changed, 157 insertions(+), 141 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d785468ffb96..655dbc90535a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -64,6 +64,12 @@ enum scan_result {
 	SCAN_PAGE_DIRTY_OR_WRITEBACK,
 };
 
+enum pte_check_result {
+	PTE_CHECK_SUCCEED,
+	PTE_CHECK_FAIL,
+	PTE_CHECK_CONTINUE,
+};
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/huge_memory.h>
 
@@ -118,6 +124,20 @@ struct collapse_control {
 	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
 };
 
+struct pte_check_context {
+	struct collapse_control *cc;
+	struct vm_area_struct *vma;
+	unsigned int order;
+	struct folio *folio;
+	int none_or_zero;
+	int shared;
+	int unmapped;
+	enum scan_result result;
+	unsigned int max_ptes_none;
+	unsigned int max_ptes_swap;
+	unsigned int max_ptes_shared;
+};
+
 /**
  * struct khugepaged_scan - cursor for scanning
  * @mm_head: the head of the mm list to scan
@@ -697,74 +717,131 @@ static void count_collapse_event(unsigned int order, enum vm_event_item vm_event
 	count_mthp_stat(order, mthp_event);
 }
 
+/*
+ * pte_check_fail() - A simple helper to set the pte_check_context result and
+ * return PTE_CHECK_FAIL.
+ */
+static enum pte_check_result pte_check_fail(struct pte_check_context *ctx,
+		enum scan_result result)
+{
+	ctx->result = result;
+	return PTE_CHECK_FAIL;
+}
+
+/*
+ * collapse_check_pte() - Check if a PTE is suitable for collapse
+ *
+ * Check if a PTE is suitable for collapse based on the following criteria:
+ * - max_pte_* values are not exceeded
+ * - uffd is not active
+ * - lazyfree properties are not present
+ * - only anonymous pages are present
+ *
+ * a helper struct pte_check_context is used to pass and store relevant
+ * information between the collapse_check_pte() function and the caller.
+ *
+ * Return: PTE_CHECK_SUCCEED if the PTE is suitable for collapse,
+ *         PTE_CHECK_FAIL if the PTE is not suitable for collapse,
+ *         PTE_CHECK_CONTINUE if the scan should continue to check the next PTE.
+ */
+static enum pte_check_result collapse_check_pte(pte_t pteval,
+		unsigned long addr, struct pte_check_context *ctx)
+{
+	if (pte_none_or_zero(pteval)) {
+		if (++ctx->none_or_zero > ctx->max_ptes_none) {
+			count_collapse_event(ctx->order, THP_SCAN_EXCEED_NONE_PTE,
+					MTHP_STAT_COLLAPSE_EXCEED_NONE);
+			return pte_check_fail(ctx, SCAN_EXCEED_NONE_PTE);
+		}
+		return PTE_CHECK_CONTINUE;
+	}
+	if (!pte_present(pteval)) {
+		if (ctx->unmapped == -1)
+			return pte_check_fail(ctx, SCAN_PTE_NON_PRESENT);
+		if (++ctx->unmapped > ctx->max_ptes_swap) {
+			count_collapse_event(ctx->order, THP_SCAN_EXCEED_SWAP_PTE,
+					MTHP_STAT_COLLAPSE_EXCEED_SWAP);
+			return pte_check_fail(ctx, SCAN_EXCEED_SWAP_PTE);
+		}
+		if (pte_swp_uffd_any(pteval))
+			return pte_check_fail(ctx, SCAN_PTE_UFFD);
+		return PTE_CHECK_CONTINUE;
+	}
+	/*
+	 * Don't collapse if any of the small PTEs are armed with uffd
+	 * write protection. Marking the new huge pmd as write protected
+	 * could bring userfault messages that fall outside of the
+	 * registered range.
+	 */
+	if (pte_uffd(pteval))
+		return pte_check_fail(ctx, SCAN_PTE_UFFD);
+
+	ctx->folio = vm_normal_folio(ctx->vma, addr, pteval);
+	if (unlikely(!ctx->folio) || unlikely(folio_is_zone_device(ctx->folio)))
+		return pte_check_fail(ctx, SCAN_PAGE_NULL);
+
+	/*
+	 * If the vma has the VM_DROPPABLE flag, the collapse will
+	 * preserve the lazyfree property without needing to skip.
+	 */
+	if (ctx->cc->is_khugepaged && !(ctx->vma->vm_flags & VM_DROPPABLE) &&
+	    folio_test_lazyfree(ctx->folio) && !pte_dirty(pteval))
+		return pte_check_fail(ctx, SCAN_PAGE_LAZYFREE);
+
+	if (!folio_test_anon(ctx->folio)) {
+		VM_WARN_ON_FOLIO(!folio_test_anon(ctx->folio), ctx->folio);
+		return pte_check_fail(ctx, SCAN_PAGE_ANON);
+	}
+
+	if (folio_maybe_mapped_shared(ctx->folio)) {
+		/*
+		 * TODO: Support shared pages without leading to further
+		 * mTHP collapses. Currently bringing in new pages via
+		 * shared may cause a future higher order collapse on a
+		 * rescan of the same range.
+		 */
+		if (++ctx->shared > ctx->max_ptes_shared) {
+			count_collapse_event(ctx->order, THP_SCAN_EXCEED_SHARED_PTE,
+					MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+			return pte_check_fail(ctx, SCAN_EXCEED_SHARED_PTE);
+		}
+	}
+
+	return PTE_CHECK_SUCCEED;
+}
+
 static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
 		unsigned int order, struct list_head *compound_pagelist)
 {
-	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, order);
-	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, order);
 	const unsigned long nr_pages = 1UL << order;
-	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr = start_addr;
-	pte_t *_pte;
-	int none_or_zero = 0, shared = 0, referenced = 0;
+	pte_t *_pte, pteval;
+	int referenced = 0;
 	enum scan_result result = SCAN_FAIL;
+	enum pte_check_result pte_check;
+	struct pte_check_context ctx = {
+		.cc = cc,
+		.vma = vma,
+		.order = order,
+		.unmapped = -1, /* don't check swap PTEs */
+		.max_ptes_none = collapse_max_ptes_none(cc, vma, order),
+		.max_ptes_shared = collapse_max_ptes_shared(cc, order),
+	};
 
 	for (_pte = pte; _pte < pte + nr_pages;
 	     _pte++, addr += PAGE_SIZE) {
-		pte_t pteval = ptep_get(_pte);
-		if (pte_none_or_zero(pteval)) {
-			if (++none_or_zero > max_ptes_none) {
-				result = SCAN_EXCEED_NONE_PTE;
-				count_collapse_event(order, THP_SCAN_EXCEED_NONE_PTE,
-						MTHP_STAT_COLLAPSE_EXCEED_NONE);
-				goto out;
-			}
-			continue;
-		}
-		if (!pte_present(pteval)) {
-			result = SCAN_PTE_NON_PRESENT;
-			goto out;
-		}
-		if (pte_uffd(pteval)) {
-			result = SCAN_PTE_UFFD;
-			goto out;
-		}
-		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
-			result = SCAN_PAGE_NULL;
-			goto out;
-		}
-
-		folio = page_folio(page);
-		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
-
-		/*
-		 * If the vma has the VM_DROPPABLE flag, the collapse will
-		 * preserve the lazyfree property without needing to skip.
-		 */
-		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
-		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
-			result = SCAN_PAGE_LAZYFREE;
+		pteval = ptep_get(_pte);
+		pte_check = collapse_check_pte(pteval, addr, &ctx);
+		folio = ctx.folio;
+		if (pte_check == PTE_CHECK_FAIL) {
+			result = ctx.result;
 			goto out;
 		}
+		if (pte_check == PTE_CHECK_CONTINUE)
+			continue;
 
-		/* See collapse_scan_pmd(). */
-		if (folio_maybe_mapped_shared(folio)) {
-			/*
-			 * TODO: Support shared pages without leading to further
-			 * mTHP collapses. Currently bringing in new pages via
-			 * shared may cause a future higher order collapse on a
-			 * rescan of the same range.
-			 */
-			if (++shared > max_ptes_shared) {
-				result = SCAN_EXCEED_SHARED_PTE;
-				count_collapse_event(order, THP_SCAN_EXCEED_SHARED_PTE,
-						MTHP_STAT_COLLAPSE_EXCEED_SHARED);
-				goto out;
-			}
-		}
 		/*
 		 * TODO: In some cases of partially-mapped folios, we'd actually
 		 * want to collapse.
@@ -841,13 +918,13 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
-		trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
+		trace_mm_collapse_huge_page_isolate(folio, ctx.none_or_zero,
 						    referenced, result, order);
 		return result;
 	}
 out:
 	release_pte_pages(pte, _pte, compound_pagelist);
-	trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
+	trace_mm_collapse_huge_page_isolate(folio, ctx.none_or_zero,
 					    referenced, result, order);
 	return result;
 }
@@ -1459,7 +1536,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 			spin_lock_nested(pte_ptl, SINGLE_DEPTH_NESTING);
 		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
 		map_anon_folio_pte_nopf(folio, pte, vma, start_addr,
-					  /*uffd_wp=*/ false);
+					  /*uffd=*/ false);
 		if (pte_ptl != pmd_ptl)
 			spin_unlock(pte_ptl);
 	}
@@ -1613,24 +1690,30 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long start_addr,
 		bool *lock_dropped, struct collapse_control *cc)
 {
-	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
-	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
-	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
 	enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
 	pmd_t *pmd;
 	pte_t *pte, *_pte, pteval;
 	int i;
-	int none_or_zero = 0, shared = 0, referenced = 0;
-	enum scan_result result = SCAN_FAIL;
-	struct page *page = NULL;
 	struct folio *folio = NULL;
+	int referenced = 0;
+	enum scan_result result = SCAN_FAIL;
 	unsigned long addr;
 	unsigned long enabled_orders;
 	spinlock_t *ptl;
-	int node = NUMA_NO_NODE, unmapped = 0;
+	int node = NUMA_NO_NODE;
+	enum pte_check_result pte_check;
 
 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
 
+	struct pte_check_context ctx = {
+		.cc = cc,
+		.vma = vma,
+		.order = HPAGE_PMD_ORDER,
+		.max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER),
+		.max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER),
+		.max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER),
+	};
+
 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
 	if (result != SCAN_SUCCEED) {
 		cc->progress++;
@@ -1647,7 +1730,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	 * is then checked again in mthp_collapse() for each attempted order.
 	 */
 	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
-		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
+		ctx.max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
 
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
@@ -1663,81 +1746,14 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 
 		cc->progress++;
 
-		if (pte_none_or_zero(pteval)) {
-			if (++none_or_zero > max_ptes_none) {
-				result = SCAN_EXCEED_NONE_PTE;
-				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_NONE_PTE,
-						MTHP_STAT_COLLAPSE_EXCEED_NONE);
-				goto out_unmap;
-			}
-			continue;
-		}
-		if (!pte_present(pteval)) {
-			if (++unmapped > max_ptes_swap) {
-				result = SCAN_EXCEED_SWAP_PTE;
-				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SWAP_PTE,
-						MTHP_STAT_COLLAPSE_EXCEED_SWAP);
-				goto out_unmap;
-			}
-			/*
-			 * Always be strict with uffd-wp
-			 * enabled swap entries.  Please see
-			 * comment below for pte_uffd().
-			 */
-			if (pte_swp_uffd_any(pteval)) {
-				result = SCAN_PTE_UFFD;
-				goto out_unmap;
-			}
-			continue;
-		}
-		if (pte_uffd(pteval)) {
-			/*
-			 * Don't collapse the page if any of the small
-			 * PTEs are armed with uffd write protection.
-			 * Here we can also mark the new huge pmd as
-			 * write protected if any of the small ones is
-			 * marked but that could bring unknown
-			 * userfault messages that falls outside of
-			 * the registered range.  So, just be simple.
-			 */
-			result = SCAN_PTE_UFFD;
-			goto out_unmap;
-		}
-
-		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
-			result = SCAN_PAGE_NULL;
-			goto out_unmap;
-		}
-		folio = page_folio(page);
-
-		/*
-		 * If the vma has the VM_DROPPABLE flag, the collapse will
-		 * preserve the lazyfree property without needing to skip.
-		 */
-		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
-		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
-			result = SCAN_PAGE_LAZYFREE;
-			goto out_unmap;
-		}
-
-		if (!folio_test_anon(folio)) {
-			result = SCAN_PAGE_ANON;
+		pte_check = collapse_check_pte(pteval, addr, &ctx);
+		if (pte_check == PTE_CHECK_FAIL) {
+			result = ctx.result;
 			goto out_unmap;
 		}
-
-		/*
-		 * We treat a single page as shared if any part of the THP
-		 * is shared.
-		 */
-		if (folio_maybe_mapped_shared(folio)) {
-			if (++shared > max_ptes_shared) {
-				result = SCAN_EXCEED_SHARED_PTE;
-				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SHARED_PTE,
-						MTHP_STAT_COLLAPSE_EXCEED_SHARED);
-				goto out_unmap;
-			}
-		}
+		if (pte_check == PTE_CHECK_CONTINUE)
+			continue;
+		folio = ctx.folio;
 
 		/* Set bit for occupied pages */
 		__set_bit(i, cc->mthp_present_ptes);
@@ -1779,7 +1795,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	}
 	if (cc->is_khugepaged &&
 		   (!referenced ||
-		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
+		    (ctx.unmapped && referenced < HPAGE_PMD_NR / 2))) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -1790,13 +1806,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		/* collapse_huge_page expects the lock to be dropped before calling */
 		mmap_read_unlock(mm);
 		result = mthp_collapse(mm, start_addr, referenced,
-				       unmapped, cc, enabled_orders);
+				       ctx.unmapped, cc, enabled_orders);
 		/* mmap_lock was released above, set lock_dropped */
 		*lock_dropped = true;
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
-				     none_or_zero, result, unmapped);
+				     ctx.none_or_zero, result, ctx.unmapped);
 	return result;
 }
 
-- 
2.54.0


