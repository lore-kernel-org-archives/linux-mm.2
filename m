Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8F8A103A9AD
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 11:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A7046B0099; Wed, 25 Mar 2026 07:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07E726B009B; Wed, 25 Mar 2026 07:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED6786B009D; Wed, 25 Mar 2026 07:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DDA616B0099
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:41:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8043EC2BB0
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:41:28 +0000 (UTC)
X-FDA: 84584395056.27.46AF09B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9974B40011
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:41:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N+G7l3cr;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774438886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OMmkah6dqMevaOCN+C4P/7Ow457xOM95fOSi6oZNNEE=;
	b=1qQyTSqw3JTBN06pBKilrbGF3JxKt20jt/Ex5MGa7+Fx25PM0MRo1I7SDEBKdcEG39QxOH
	j/jrhkl4jK89YV7gE1+JXnKziBe/kknNBQUnID0M0HODY1QvOZZGUFAC1OEFLOerMPoVfg
	YN+4W+RsgZnDI4lqQr4pY7N7r9vs8iM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N+G7l3cr;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774438886; a=rsa-sha256;
	cv=none;
	b=00k7umIiDhWnws1PtpprlH2BCHnYdvYc0zlKdwRo2mHwBTH+l/fe3ms+oNu1h2zh7rGyME
	F1gKcdGAB+yClKjB+1XcsJ7Lq1parYccWMz+KQJ6Q4NAh2dHwioY5PgyPR9LGWgwoR8vci
	k4wxuLw42+7GaFOijT21dD/fGw5lE3U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774438886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OMmkah6dqMevaOCN+C4P/7Ow457xOM95fOSi6oZNNEE=;
	b=N+G7l3crkbLiwoDcMuER/3vfR7zEc73iFp7aduSTnxuDik/6HEzNaijRE47Z2OMVWCNl/p
	M3RoIRX59PPvyi2bwQ8oInzXPq4nl5PBViKst49Sr29VQXB1twAAu8IUCOkuKSBYVbSb2u
	BbPSkbVJJLWzvyeqMGNT9jHFbXncvvU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-499-Si0dIp7VOIqvAC4kxq5m6g-1; Wed,
 25 Mar 2026 07:41:21 -0400
X-MC-Unique: Si0dIp7VOIqvAC4kxq5m6g-1
X-Mimecast-MFC-AGG-ID: Si0dIp7VOIqvAC4kxq5m6g_1774438875
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 15C7F195608A;
	Wed, 25 Mar 2026 11:41:14 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.2.14.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AD69118002A6;
	Wed, 25 Mar 2026 11:40:53 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jackmanb@google.com,
	jack@suse.cz,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: [PATCH mm-unstable v4 1/5] mm: consolidate anonymous folio PTE mapping into helpers
Date: Wed, 25 Mar 2026 05:40:18 -0600
Message-ID: <20260325114022.444081-2-npache@redhat.com>
In-Reply-To: <20260325114022.444081-1-npache@redhat.com>
References: <20260325114022.444081-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BGDZaPCtsZqwYshk7imZDWtZ8rGD4qCPravyYTmBgbg_1774438875
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Stat-Signature: w7ogmkw5p15i5d4gg1f8sbytpxpkzaj6
X-Rspamd-Queue-Id: 9974B40011
X-Rspamd-Server: rspam09
X-HE-Tag: 1774438886-645564
X-HE-Meta: U2FsdGVkX1/Wp5ZvAzgAI340f8gxbgVpbueAiMxgC2q5Kx/sSJzkYHVruc1FLLpNeuiDG49AJvaB8bVT0fLzcSI7aaQ9pHxmG/7v4uq5qthDkd0opTxp+TMWHleXyWrIM2titfWPpLulHcmlGYOsEvoCHcZ6HiJVXHD5dG7ido91x0aJbgIyLoMqbm0t3mSyYO9gWYGIlChBVYX9I3DlN4ZDca/A/nwhGoTRPVa2Z9q8SmeGAaiv0aho0qRSNgZIDTnlk9V+t+w5wxMOuYrvxgk1+t8acgHTpVebofXreYndUF+Bk6pOWm7D1AG7Tihd7kAq5l9zqz1vMDTAgHQ79heex2iQgrJHuUecFzQhFzxcMpwsr33P95QB35kyYbQM+dwqhFE6QHJwIjW66uhaZvM2sio0+l3ioCANA4ESyw0qKETYS6aH8FN5wTmRDqfizd4BhEJLnQuuem4gNteRPldefcjYJI0zrRJz8NX1SOcXY6mdHmHKTXjbD8KANKCdULuFOov0i5t1Fekj3yrViBbLxaCnKwET7f4HaG+JdD4tGu4Y9X3sM9zhWYD5LZZ06aisRCenG8ACJl+HDqsHtoXUMuxfyAhBJHFbQaiRLgEs16sJunaL5cXC7H7cnDlJL3a9A/J/eXI5vUf2GFAE5jPKGT/hT5CjC9sSSxYDTOKDbREz/u1X0eOAweUw/Zh4gP1JLtgCeoNfpWpmscAZBZhT+vvN5Sbix86tIFvP9n9yq7ClZ3kk2NaRQ9Hwqxc/95Ze7m8tEWmjf6VREZsO179cwFPQtKEii2HtnByVx3dWTk13hzBjL0i8Rz7mi2B5wICM0pVB32rjcz2ECyjRvs72FLo5japmHklZHv4cLJpYNduX/D3vVSA5kZIyuhYfeFX3ZWwypoe0V+/UTFJ0PO9KQIbFprCevh2MzgpELgK2p+SdEyNUwoBiBK9Yvx/n++Ut6zgQOGT2f/znslC
 vBT1nErv
 8JvCRUFJLYbDggDsXapcAUo2e8a5BmaV1kFGMgGqWtoggJaoeI2CK6Nr49GGqKXFJZvEyP1Q+RjCKCpkvqp8U8Uy+MRmQ+L/G5Tm4qr0LTZgFPvXT8x6klyKeANmSd+4tVK+Sn9XYxYU+IYleuJsDHZ0hEast4GcG7XLpP02/iLZSzMkmFWNoDa6s1pd3CNe8XUcJLz5cjJ7o08b+HcW31MH0iQFMZjALcZQwYyS7YqfMhvwk7HCbizoGGeRCZ7YzfPBBJJ0jRsLWRJK4Si2FWfUo4QGAzasN0N9s4nOD3cQrKeiGegIXtpvQIoTkkyBnrGLMJxNt6gqGVMMZfnxgyw0mgOY7kOCGYVjrJa3/6CXZ4XVeh4nLuw5QjbPjffATyzcOkLz+OQ67uWQrOLE3qTY+LAwOxayECt4ZqS0v71Uw9OKjohVMPEioP1DEZhP0rjwR6gYm+AbRnfKEQRfX3ISUr1fIEu8vPPnIawl+KN5AuLuLDAP/ZhaT4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The anonymous page fault handler in do_anonymous_page() open-codes the
sequence to map a newly allocated anonymous folio at the PTE level:
	- construct the PTE entry
	- add rmap
	- add to LRU
	- set the PTEs
	- update the MMU cache.

Introduce two helpers to consolidate this duplicated logic, mirroring the
existing map_anon_folio_pmd_nopf() pattern for PMD-level mappings:

map_anon_folio_pte_nopf(): constructs the PTE entry, takes folio
references, adds anon rmap and LRU. This function also handles the
uffd_wp that can occur in the pf variant. The future khugepaged mTHP code
calls this to handle mapping the new collapsed mTHP to its folio.

map_anon_folio_pte_pf(): extends the nopf variant to handle MM_ANONPAGES
counter updates, and mTHP fault allocation statistics for the page fault
path.

The zero-page read path in do_anonymous_page() is also untangled from the
shared setpte label, since it does not allocate a folio and should not
share the same mapping sequence as the write path. We can now leave nr_pages
undeclared at the function intialization, and use the single page
update_mmu_cache function to handle the zero page update.

This refactoring will also help reduce code duplication between mm/memory.c
and mm/khugepaged.c, and provides a clean API for PTE-level anonymous folio
mapping that can be reused by future callers (like khugpeaged mTHP support)

Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 include/linux/mm.h |  4 +++
 mm/memory.c        | 61 +++++++++++++++++++++++++++++++---------------
 2 files changed, 45 insertions(+), 20 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index eebf940058da..7edebadb2cb2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5226,4 +5226,8 @@ static inline bool snapshot_page_is_faithful(const struct page_snapshot *ps)
 
 void snapshot_page(struct page_snapshot *ps, const struct page *page);
 
+void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
+		struct vm_area_struct *vma, unsigned long addr,
+		bool uffd_wp);
+
 #endif /* _LINUX_MM_H */
diff --git a/mm/memory.c b/mm/memory.c
index bd93f34b6120..6396d32c348a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5292,6 +5292,37 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	return folio_prealloc(vma->vm_mm, vma, vmf->address, true);
 }
 
+void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
+		struct vm_area_struct *vma, unsigned long addr,
+		bool uffd_wp)
+{
+	const unsigned int nr_pages = folio_nr_pages(folio);
+	pte_t entry = folio_mk_pte(folio, vma->vm_page_prot);
+
+	entry = pte_sw_mkyoung(entry);
+
+	if (vma->vm_flags & VM_WRITE)
+		entry = pte_mkwrite(pte_mkdirty(entry), vma);
+	if (uffd_wp)
+		entry = pte_mkuffd_wp(entry);
+
+	folio_ref_add(folio, nr_pages - 1);
+	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
+	folio_add_lru_vma(folio, vma);
+	set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
+	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
+}
+
+static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
+		struct vm_area_struct *vma, unsigned long addr, bool uffd_wp)
+{
+	const unsigned int order = folio_order(folio);
+
+	map_anon_folio_pte_nopf(folio, pte, vma, addr, uffd_wp);
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1L << order);
+	count_mthp_stat(order, MTHP_STAT_ANON_FAULT_ALLOC);
+}
+
 /*
  * We enter with non-exclusive mmap_lock (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
@@ -5303,7 +5334,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	unsigned long addr = vmf->address;
 	struct folio *folio;
 	vm_fault_t ret = 0;
-	int nr_pages = 1;
+	int nr_pages;
 	pte_t entry;
 
 	/* File mapping without ->vm_ops ? */
@@ -5338,7 +5369,13 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
 			return handle_userfault(vmf, VM_UFFD_MISSING);
 		}
-		goto setpte;
+		if (vmf_orig_pte_uffd_wp(vmf))
+			entry = pte_mkuffd_wp(entry);
+		set_pte_at(vma->vm_mm, addr, vmf->pte, entry);
+
+		/* No need to invalidate - it was non-present before */
+		update_mmu_cache(vma, addr, vmf->pte);
+		goto unlock;
 	}
 
 	/* Allocate our own private page. */
@@ -5362,11 +5399,6 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	 */
 	__folio_mark_uptodate(folio);
 
-	entry = folio_mk_pte(folio, vma->vm_page_prot);
-	entry = pte_sw_mkyoung(entry);
-	if (vma->vm_flags & VM_WRITE)
-		entry = pte_mkwrite(pte_mkdirty(entry), vma);
-
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, addr, &vmf->ptl);
 	if (!vmf->pte)
 		goto release;
@@ -5388,19 +5420,8 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 		folio_put(folio);
 		return handle_userfault(vmf, VM_UFFD_MISSING);
 	}
-
-	folio_ref_add(folio, nr_pages - 1);
-	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
-	count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC);
-	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
-	folio_add_lru_vma(folio, vma);
-setpte:
-	if (vmf_orig_pte_uffd_wp(vmf))
-		entry = pte_mkuffd_wp(entry);
-	set_ptes(vma->vm_mm, addr, vmf->pte, entry, nr_pages);
-
-	/* No need to invalidate - it was non-present before */
-	update_mmu_cache_range(vmf, vma, addr, vmf->pte, nr_pages);
+	map_anon_folio_pte_pf(folio, vmf->pte, vma, addr,
+			      vmf_orig_pte_uffd_wp(vmf));
 unlock:
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-- 
2.53.0


