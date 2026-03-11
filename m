Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22A57103E2E7
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 21:15:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8459B6B0089; Wed, 11 Mar 2026 17:15:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EF5D6B008A; Wed, 11 Mar 2026 17:15:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DE436B008C; Wed, 11 Mar 2026 17:15:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7EA6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:15:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D17181C1C2
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:15:50 +0000 (UTC)
X-FDA: 84535039260.27.6B95B07
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id D5993A000C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:15:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BL2VVIYy;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773263748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hpEKhYGnuX/C5T9/tEkiZyfioDXkZBHEba0Tb5EmW1s=;
	b=0pO7el4Oh7+COLSZR53ZslTcnZ0xwKjYZjM76EDG1wygEUOmjA01A69ncQTv3MUHSh1yp3
	gA/VEZcsnWu8jf/m+Ta/aQ3b88EA+TutvyMmqy154nt/9oHztENquUdRefFotlzELLIuB1
	UK2Ij++Z8ZQyxvD4e5L2CejZ9guwqAQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BL2VVIYy;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773263748; a=rsa-sha256;
	cv=none;
	b=HGIlNx6yEmo/KparwqeLc49nDp6lcfv1lUkEeOT2ZszGP98CjnHKUEapwBhW9fhi2YIYc2
	15uBAfaprn+GumdK/2nU79BJhrWGVHO0lTvy8Lq51LraLlC0tRHQTZ72sKplRrd0GHGERO
	pVbwQkvQgkdp1xtxAJcW4+sJ6Tv0FM0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773263748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hpEKhYGnuX/C5T9/tEkiZyfioDXkZBHEba0Tb5EmW1s=;
	b=BL2VVIYyRiIgWRpRH0dsSch2IuETCTlDGV990x4jK6U63I/54kSMwVP98ys3Ac3NrpcIvN
	v9XV/2GBhNGZgEQ0lvLprHiwLBK5LwCL+MU/aoBhS6wnUE3SwI9ts3zcbbSbO/jDfArzN9
	fsPcO7SiqEC2nLJTfnV5ir4+hOFSrtU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-171-Oc9stVNBP5qzbDOMIESzlA-1; Wed,
 11 Mar 2026 17:15:45 -0400
X-MC-Unique: Oc9stVNBP5qzbDOMIESzlA-1
X-Mimecast-MFC-AGG-ID: Oc9stVNBP5qzbDOMIESzlA_1773263738
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C730A195609F;
	Wed, 11 Mar 2026 21:15:36 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.89.69])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2D71D3002D0E;
	Wed, 11 Mar 2026 21:15:23 +0000 (UTC)
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
	zokeefe@google.com
Subject: [PATCH mm-unstable v3 1/5] mm: consolidate anonymous folio PTE mapping into helpers
Date: Wed, 11 Mar 2026 15:13:11 -0600
Message-ID: <20260311211315.450947-2-npache@redhat.com>
In-Reply-To: <20260311211315.450947-1-npache@redhat.com>
References: <20260311211315.450947-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5sCbfVpNjRBGcbH0MO09hRGbCuKAEBGxRIUDQn6qilE_1773263738
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: D5993A000C
X-Stat-Signature: 8foqy8f4tkm4cw5a3d33jpa4d5t5f918
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773263748-878802
X-HE-Meta: U2FsdGVkX1/VewA1R9cbKqZrttT04AgIwJ4OX4nf48Oknj4EeGSy5+u/hcaOjQgWnYlvNPKxlnHLYHNAe7ybo0RY0R8e7adPwprIgoTARb89aCaireq4GUsn/C3sTn+i799IYbSiEgWbBVi6UOwuIPDf5A+7L67KAp9Vnk2wXuN05fXXoj5BL1BsQ/nPiQJ3g3SKXsAhcp9AY4ux3qDWhg7vWYDIIy7f9a2docUfbr7RfAKettF/YXNXWP0b8m7N+CN/n67bEgxaq4KOuo9izip9Va3I3cpoBnMHjPZoZBMmpHZt6zyKmAwXKfRzi5bvjU69btfMTpkEWdJhCDXSg3AGVOlIOjCSOUf9ovgVlO24TRH5erKlkpF7HlcdxMaAE31Wm1XWr1ZBKFtIHRt0Fd2a7v4mLRSecXVgDTVIAC4Y2smZ7C7HrvpyFXmdwL50Ns9Fcga1Y1fgiv92OyfWOfwsVZv3H0NR/FkV+/2OzlCmpMTKazLJD4++ILEeMWmZjQx/t7VsRcxaZ8oET6OpxuFFKrz0YSoga9j61K2pZmoY8mrOn8WHX/2SS0GAutO4TmcOdtFlVj+fc13d430NKEThRAkYTssYi/qKpZdlHrrE2rKsn9L2urZ/YMteEVodGRMXja40RG1qFN6D5RZNknKQeJ0mD9C+imk2K6oD/OWAsGxPHg1uszTGu+HvOVybJugQnvXRlFzhC1Y8NEQDOd7qDMLVpnTfdYQBRF2Q4ItZLGbxYbnQFsi2wS8uWmwDjVI3Ystd2MDcSBKWzbfilxWTnxXXVyxSLKcDZ8cLev3WRfGq6ZU+BcHqapWn91CU5JtGCQJJG9N8COw8E5cn3kopaVNDS4H/7SNylYodkUtxazUggP3GZiwok5Vg3+4BlWQV/JicYf1Ts4Gn6FXO9A3qrYLPgBsHT7LU+msTsX3DenhOffit+fXFZPld7XpSvF21P2C9G10K/dqPXFE
 zId+R+lv
 soOECVxoDpo6pJNzJn0JcOxI/u8i3M2j+XtOz96NLIqMHNlj4gg37uHbV9eBTpnROgXeHUunY/+1Afd2udDwMT8jfadaRxWYNDafMPVnXRk+g0PQURU3ruAFI/AR8sbrqYTZzVFi8zD11chtpMVs+g/zUZv9LzOX4EwLm9klAYyGkNgdAP4s4kckbpvTQUYT6JQETy8r25o2gAeqMMzFUy5rzikSARpCy9THrb2qnLdkyrsh3V5kv/liWvrps8tHUu5KGm7AZIXPU9E/zLR2VuCUEvB4Ub0he+RVXZ+ut5xt3tdRpPvNBY8LAAxTRzeNxnJlmaTHvQc5NWABb63/XSyumaT3dtqLnrV5sbytKJFPsCUMbvJKtOAANxRkXg2XUoOvBGl6d3vPt7nqtnPUwG10n2HL++pbfFYh+SaW9XPtsEJVX3WSTQ+YOUBKBd1qOSD2vkbq7SAxM4jD+QV2MyTWQHp6xdXpP/+nGqcrdVo9ecabLHCsv5mM7eQ==
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

Introduce a two helpers to consolidate this duplicated logic, mirroring the
existing map_anon_folio_pmd_nopf() pattern for PMD-level mappings:

	map_anon_folio_pte_nopf(): constructs the PTE entry, takes folio
	references, adds anon rmap and LRU. This function also handles the
	uffd_wp that can occur in the pf variant.

	map_anon_folio_pte_pf(): extends the nopf variant to handle MM_ANONPAGES
	counter updates, and mTHP fault allocation statistics for the page fault
	path.

The zero-page read path in do_anonymous_page() is also untangled from the
shared setpte label, since it does not allocate a folio and should not
share the same mapping sequence as the write path. Make nr_pages = 1
rather than relying on the variable. This makes it more clear that we
are operating on the zero page only.

This refactoring will also help reduce code duplication between mm/memory.c
and mm/khugepaged.c, and provides a clean API for PTE-level anonymous folio
mapping that can be reused by future callers.

Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 include/linux/mm.h |  4 ++++
 mm/memory.c        | 60 +++++++++++++++++++++++++++++++---------------
 2 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4c4fd55fc823..9fea354bd17f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4903,4 +4903,8 @@ static inline bool snapshot_page_is_faithful(const struct page_snapshot *ps)
 
 void snapshot_page(struct page_snapshot *ps, const struct page *page);
 
+void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
+		struct vm_area_struct *vma, unsigned long addr,
+		bool uffd_wp);
+
 #endif /* _LINUX_MM_H */
diff --git a/mm/memory.c b/mm/memory.c
index 6aa0ea4af1fc..5c8bf1eb55f5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5197,6 +5197,37 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	return folio_prealloc(vma->vm_mm, vma, vmf->address, true);
 }
 
+void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
+		struct vm_area_struct *vma, unsigned long addr,
+		bool uffd_wp)
+{
+	unsigned int nr_pages = folio_nr_pages(folio);
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
+	unsigned int order = folio_order(folio);
+
+	map_anon_folio_pte_nopf(folio, pte, vma, addr, uffd_wp);
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1 << order);
+	count_mthp_stat(order, MTHP_STAT_ANON_FAULT_ALLOC);
+}
+
 /*
  * We enter with non-exclusive mmap_lock (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
@@ -5243,7 +5274,14 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
 			return handle_userfault(vmf, VM_UFFD_MISSING);
 		}
-		goto setpte;
+		if (vmf_orig_pte_uffd_wp(vmf))
+			entry = pte_mkuffd_wp(entry);
+		set_pte_at(vma->vm_mm, addr, vmf->pte, entry);
+
+		/* No need to invalidate - it was non-present before */
+		update_mmu_cache_range(vmf, vma, addr, vmf->pte,
+				       /*nr_pages=*/ 1);
+		goto unlock;
 	}
 
 	/* Allocate our own private page. */
@@ -5267,11 +5305,6 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
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
@@ -5293,19 +5326,8 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
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


