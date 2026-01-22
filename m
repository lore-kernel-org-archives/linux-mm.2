Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D824D6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 374E86B0328; Thu, 22 Jan 2026 14:31:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 332276B032A; Thu, 22 Jan 2026 14:31:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21DCA6B032B; Thu, 22 Jan 2026 14:31:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DD9706B0328
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:31:13 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5CF668CD47
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:31:13 +0000 (UTC)
X-FDA: 84360593226.23.9AD5E18
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5FB6640004
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:31:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HPtpiGDL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769110271; a=rsa-sha256;
	cv=none;
	b=lPYpXcIEkYsQPiLD9lY4qfm5xe/w9NEvnfhWxjtfSeqEUZcOujncIS1PwXco+CjeetNNnc
	P6EPjNgTCSalcuN/WrLnwOK41ekvAFgI+7lElVNQyPpgeMxd3qMOy+zDjzcGFFIjqX4XMi
	GwK3eXcyArFiahI++CXO5s8XgdaTOWI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HPtpiGDL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJlB8Tzos+Nml8/PUSQTSaVA1J1VR5R9WMjBFzTu7zI=;
	b=nJtBJQJFHgfOJ82gbNCoF3DTnxJsD0/oYqUtWFUWWbEoJhWefVrEros6mLelH1s77xsi2A
	z8eGePlsbtCqeCleAShRPQCpBA+8nRdjiUg5nyc0CbbKv0oIOiaYxGS0nE8x6Dc23UDsHM
	V1hMwGAHxVwwmDPKGn7eBAcr44M91K0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769110270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NJlB8Tzos+Nml8/PUSQTSaVA1J1VR5R9WMjBFzTu7zI=;
	b=HPtpiGDLQqtk3WBOPouFj6H2pVqbn1mIWRzbPhmHcWuHIyi+bLYM5mm/5vATPZse7adkgi
	wJGqsdUI3TNhFcjJxYweUnRG0K3RUtwMz3Jm1Z05ULMEpV62pA9aFou6jz+15W3VhV9NGr
	IIHvFi3r0+FCb2Vf5wXau/w+Ramw82Y=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-564-BrmLVG8iNaWOG3vL6AvFkw-1; Thu,
 22 Jan 2026 14:31:09 -0500
X-MC-Unique: BrmLVG8iNaWOG3vL6AvFkw-1
X-Mimecast-MFC-AGG-ID: BrmLVG8iNaWOG3vL6AvFkw_1769110263
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7CEEC18005B8;
	Thu, 22 Jan 2026 19:31:03 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.88.59])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D1ED81958DC1;
	Thu, 22 Jan 2026 19:30:53 +0000 (UTC)
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
Subject: [PATCH mm-unstable v14 06/16] khugepaged: generalize __collapse_huge_page_* for mTHP support
Date: Thu, 22 Jan 2026 12:28:31 -0700
Message-ID: <20260122192841.128719-7-npache@redhat.com>
In-Reply-To: <20260122192841.128719-1-npache@redhat.com>
References: <20260122192841.128719-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MLkdiQ_kIaI-bhlRitvwv08C8e4altqtPvo1lGW8MjY_1769110263
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5FB6640004
X-Stat-Signature: d4emmczyiaxctr5p1s3uk7btzxhgp7mk
X-HE-Tag: 1769110271-731324
X-HE-Meta: U2FsdGVkX1/HgOecVaG1pk7ij1FrWB5YltaI8evG/NKxl43L2tkJPUYRBG/Lbhspv2pdGfkkupCO4DSLF+/6iOaEKntW0EUyUDhcxUYIShwXO3KuKEgmZYo9pGuc9PgBwO1ESK4xXhCpTjCQdLYrSUfzXYnAUbgAlu2L8FkYX/IGo/G/wKFwiTsZZuVQyX0u4/riOdZvnvDfrfFEvunoZ8xDdOwzN5CUFjCCVxS9puCuCZFGDGeTk8w3nJof/b2LS+lc+flJQCc7JgcMqsj6mzIoLFZgEyT52znxIZ2Q3pHg1ZrlktAsPsjy+DJnhxJ2tjA48WsWRqo7+FRzkpPCWVmipsOYEu7iS1sn3PQpGr9VhtAiOuor/158jpJvgjs+e8IO+QZ5n/ve6GrPyZKdI/G+00hdPtNU/NxN5UTRKP1CyOISfMI0HCBCnVHMoEyyHveJAHFLSZN6FPwxMzpvv7a1J6kd3J9s5PazqCEcXX8isVPFMBIb7RvnTWiXzKTL4cWebvnMP+izWkGTYEh0fNWXm7gpG/niPwsP8D78nz22kUEuch1eEBNFPa9py3pkRw/KZn9HB6wQPSdSDyCkHO1yX6Sw2kkxUr5c9sIiv7TQ5wMnt2eM7hNU9mdGDA+8psS+NOgrdetBDlP1QIZPXzUbssfS5QWAcNkSXZJ/RGP7tySTdHBl0KOZr6NYMym6XkdnVV6/4azPzG8SouVk/a0nhJAzl3P8ABuDxFz05zCVGp7dtKccuwCkapDSG3usIiY5g2jPrLgihPTtfJROq+CUHs5G+2j7teLnTRnfd127VUUlrIofXRxBRcoHVbYP0CyTCaV185gHu/OTpEaXJQ85R7qRbAqZJ9mwEhBc+OrSo5tnypxWaxvvXpx2woQYAEnWaQZY33WK3tqACF4o527pQX2/PpIjlVGNT9VSzIMy41H5mmCKcIGpnLpmlso6Y/ZJV4bWu10WoV3wVwJ
 URqq4Jm5
 MHE8Zzn36/ye4So5r2fWwggFQ7cC19icfeNy04qgls0zZroRp3rqR5zNyAReVivJ1jn9yx5n6/FaaPddO3jxraAG45x+tTRTeo75EvrW6CX5BRY8M7xW47cl2hmI9BcwwqhFQzRviubQnsQZgn1vYBc/c3nOyoI/5RT8NpoKWSNMfdfyeKCBfy5afwiwERpa6VMFopUBsvZNckp3xWwEHeb1gdTA4wRdLedFQeQ6UXHHait+hcWUt62oRJ1epTEgh3RRu3iBgrySoXKmYE2hjwP4Gvy3LyMkBe5yYKSA2x9OaQ5uLtEqMo0CA3jSv4aZxkm/g0BDj0UJxreV2HUp1qOHlURKieuKg7rDE+OfJrHGj4YOPFjQGqV0/T1njeS++xJBaCCy49/HGUuJcv6vjiudB5dEVFpRvil6hbunqKewGYm7SkPCgGV2pde3E7wPcMTeRgog4kbalTNqN8dIPw/+WkEnbT8lI7H9Kg1S5CQvxsutFk+K5W2bU1hijQbEFHqiHWaden3wHOfEvP2KgZ7iF4ZT6iw+8nUbBIybNeVhAQ18=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

generalize the order of the __collapse_huge_page_* functions
to support future mTHP collapse.

mTHP collapse will not honor the khugepaged_max_ptes_shared or
khugepaged_max_ptes_swap parameters, and will fail if it encounters a
shared or swapped entry.

No functional changes in this patch.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 73 +++++++++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 26 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 384d30b6bdd3..0f68902edd9a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -539,7 +539,7 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 
 static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
-		struct list_head *compound_pagelist)
+		unsigned int order, struct list_head *compound_pagelist)
 {
 	struct page *page = NULL;
 	struct folio *folio = NULL;
@@ -547,15 +547,17 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	pte_t *_pte;
 	int none_or_zero = 0, shared = 0, referenced = 0;
 	enum scan_result result = SCAN_FAIL;
+	const unsigned long nr_pages = 1UL << order;
+	int max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
 
-	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
+	for (_pte = pte; _pte < pte + nr_pages;
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
 			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
+			     none_or_zero <= max_ptes_none)) {
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
@@ -583,8 +585,14 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
 			++shared;
-			if (cc->is_khugepaged &&
-			    shared > khugepaged_max_ptes_shared) {
+			/*
+			 * TODO: Support shared pages without leading to further
+			 * mTHP collapses. Currently bringing in new pages via
+			 * shared may cause a future higher order collapse on a
+			 * rescan of the same range.
+			 */
+			if (!is_pmd_order(order) || (cc->is_khugepaged &&
+			    shared > khugepaged_max_ptes_shared)) {
 				result = SCAN_EXCEED_SHARED_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
 				goto out;
@@ -677,18 +685,18 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 }
 
 static void __collapse_huge_page_copy_succeeded(pte_t *pte,
-						struct vm_area_struct *vma,
-						unsigned long address,
-						spinlock_t *ptl,
-						struct list_head *compound_pagelist)
+		struct vm_area_struct *vma, unsigned long address,
+		spinlock_t *ptl, unsigned int order,
+		struct list_head *compound_pagelist)
 {
-	unsigned long end = address + HPAGE_PMD_SIZE;
+	unsigned long end = address + (PAGE_SIZE << order);
 	struct folio *src, *tmp;
 	pte_t pteval;
 	pte_t *_pte;
 	unsigned int nr_ptes;
+	const unsigned long nr_pages = 1UL << order;
 
-	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
+	for (_pte = pte; _pte < pte + nr_pages; _pte += nr_ptes,
 	     address += nr_ptes * PAGE_SIZE) {
 		nr_ptes = 1;
 		pteval = ptep_get(_pte);
@@ -741,13 +749,11 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
 }
 
 static void __collapse_huge_page_copy_failed(pte_t *pte,
-					     pmd_t *pmd,
-					     pmd_t orig_pmd,
-					     struct vm_area_struct *vma,
-					     struct list_head *compound_pagelist)
+		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
+		unsigned int order, struct list_head *compound_pagelist)
 {
 	spinlock_t *pmd_ptl;
-
+	const unsigned long nr_pages = 1UL << order;
 	/*
 	 * Re-establish the PMD to point to the original page table
 	 * entry. Restoring PMD needs to be done prior to releasing
@@ -761,7 +767,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
 	 * Release both raw and compound pages isolated
 	 * in __collapse_huge_page_isolate.
 	 */
-	release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
+	release_pte_pages(pte, pte + nr_pages, compound_pagelist);
 }
 
 /*
@@ -781,16 +787,16 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
  */
 static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
 		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
-		unsigned long address, spinlock_t *ptl,
+		unsigned long address, spinlock_t *ptl, unsigned int order,
 		struct list_head *compound_pagelist)
 {
 	unsigned int i;
 	enum scan_result result = SCAN_SUCCEED;
-
+	const unsigned long nr_pages = 1UL << order;
 	/*
 	 * Copying pages' contents is subject to memory poison at any iteration.
 	 */
-	for (i = 0; i < HPAGE_PMD_NR; i++) {
+	for (i = 0; i < nr_pages; i++) {
 		pte_t pteval = ptep_get(pte + i);
 		struct page *page = folio_page(folio, i);
 		unsigned long src_addr = address + i * PAGE_SIZE;
@@ -809,10 +815,10 @@ static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *foli
 
 	if (likely(result == SCAN_SUCCEED))
 		__collapse_huge_page_copy_succeeded(pte, vma, address, ptl,
-						    compound_pagelist);
+						    order, compound_pagelist);
 	else
 		__collapse_huge_page_copy_failed(pte, pmd, orig_pmd, vma,
-						 compound_pagelist);
+						 order, compound_pagelist);
 
 	return result;
 }
@@ -983,12 +989,12 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
  * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
  */
 static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long start_addr, pmd_t *pmd,
-		int referenced)
+		struct vm_area_struct *vma, unsigned long start_addr,
+		pmd_t *pmd, int referenced, unsigned int order)
 {
 	int swapped_in = 0;
 	vm_fault_t ret = 0;
-	unsigned long addr, end = start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
+	unsigned long addr, end = start_addr + (PAGE_SIZE << order);
 	enum scan_result result;
 	pte_t *pte = NULL;
 	spinlock_t *ptl;
@@ -1020,6 +1026,19 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 		    pte_present(vmf.orig_pte))
 			continue;
 
+		/*
+		 * TODO: Support swapin without leading to further mTHP
+		 * collapses. Currently bringing in new pages via swapin may
+		 * cause a future higher order collapse on a rescan of the same
+		 * range.
+		 */
+		if (!is_pmd_order(order)) {
+			pte_unmap(pte);
+			mmap_read_unlock(mm);
+			result = SCAN_EXCEED_SWAP_PTE;
+			goto out;
+		}
+
 		vmf.pte = pte;
 		vmf.ptl = ptl;
 		ret = do_swap_page(&vmf);
@@ -1139,7 +1158,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
 		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
-						     referenced);
+						     referenced, HPAGE_PMD_ORDER);
 		if (result != SCAN_SUCCEED)
 			goto out_nolock;
 	}
@@ -1187,6 +1206,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
 	if (pte) {
 		result = __collapse_huge_page_isolate(vma, address, pte, cc,
+						      HPAGE_PMD_ORDER,
 						      &compound_pagelist);
 		spin_unlock(pte_ptl);
 	} else {
@@ -1217,6 +1237,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 
 	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
 					   vma, address, pte_ptl,
+					   HPAGE_PMD_ORDER,
 					   &compound_pagelist);
 	pte_unmap(pte);
 	if (unlikely(result != SCAN_SUCCEED))
-- 
2.52.0


