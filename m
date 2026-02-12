Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FD4EEB270C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 02:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0406B0089; Wed, 11 Feb 2026 21:19:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D9D6B008A; Wed, 11 Feb 2026 21:19:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8800D6B008C; Wed, 11 Feb 2026 21:19:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 747C96B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:19:17 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 217931A0701
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:19:17 +0000 (UTC)
X-FDA: 84434197554.23.DA29C38
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2F3DF40009
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:19:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="W0acd/WK";
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770862755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6U/FrtkRP7LOssZfEv12dprTABfhdV/gGW8Q/dm8jw=;
	b=fN3yAfxCMjaBaZaHlqgXgnO7rom/ZRPDm6xZLCPRS+XseW/qlQIo73ufhDf5BICP3QuJpl
	iHyF6+JtvqfClaji8juPMsd0bfSLa6nsvvwtbKEZb3nNqYk2MwEM8wTgPFQ5+yUMcDxUjB
	1wUuIDC8+1uz9e8CHHllxCpvH7o7gMU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="W0acd/WK";
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770862755; a=rsa-sha256;
	cv=none;
	b=mvlKbrVL/Zot742Y2NtNyCcm1gYKdkpebd5Vv1EVvWm4GydF7COABQ0oHp/m58RD4osxt9
	jKHWd6Rjow90B6fbBRX1TeIYEllumwJHZJ7WrKO6C8FL/uHOuqMt0LFeiqaHqBapQn8dqF
	Zw3Tkqz64pXShVUZysGvB0N4PtEaJcI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770862754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q6U/FrtkRP7LOssZfEv12dprTABfhdV/gGW8Q/dm8jw=;
	b=W0acd/WKnIGPGMpNLL3PitrXuN3ozgkBOVj1OIfVMBTyB7P3EW8FVXIyON3ikV+0U9Zcfu
	RbziszdM+LXkWY0P8c+2/VafJKZ5+VI+MtMMYwvAU+yyZyGgGCHl7hpRO6np9bbp3cpr5g
	v2pRBmbUC2Yl1UKcWRcOu4KiYooQkkA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-157-2s6fCysWNq6KXbxwjnET1Q-1; Wed,
 11 Feb 2026 21:19:10 -0500
X-MC-Unique: 2s6fCysWNq6KXbxwjnET1Q-1
X-Mimecast-MFC-AGG-ID: 2s6fCysWNq6KXbxwjnET1Q_1770862744
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 404551800451;
	Thu, 12 Feb 2026 02:19:02 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.91])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 84D601956056;
	Thu, 12 Feb 2026 02:18:51 +0000 (UTC)
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
Subject: [PATCH mm-unstable v1 1/5] mm: consolidate anonymous folio PTE mapping into helpers
Date: Wed, 11 Feb 2026 19:18:31 -0700
Message-ID: <20260212021835.17755-2-npache@redhat.com>
In-Reply-To: <20260212021835.17755-1-npache@redhat.com>
References: <20260212021835.17755-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4lm8zHf0ZLwVYjIz64OXNT_5DT7yH8JwC2YJCYFdFaY_1770862744
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2F3DF40009
X-Stat-Signature: 3qzp53d5i3awtaz4c65ewhjginufk16j
X-Rspam-User: 
X-HE-Tag: 1770862755-817389
X-HE-Meta: U2FsdGVkX1841XK3sCiZmFyJGXltLWmJ/MT8OZFmz5Dq+hOl3mjqRNseU/eAAHLQpgK+sfmDQ/W6YBO/nXdqbhGF1jYePpd1FzOUh4N2wLQ7RO0/fAU0Kz80aNHatSuUs90NO5ORGGqDf9FNWYVxUqUtwmxI3OxVMsjpMSaFUFzRhdYhHnqTEkGDriroCYBUxQD+DWQFx58HTCRFr7L62R9Fig+ExUjovLC2ehdgUjG9hb3RUClnz0/MaayTI2cI/BkPlkFE01y/2UPlzKTPHI4kgZcmFq/kg0pN0VYE7NJ3+67tdd770NOQ3/zjnAalOE13gQGKHu38oCIxo4oB3UgA4Fof6Zhz8Py70OX6KSkKpDYvgLg/TOilk8pxApQuIqRBvCiFA2L88n/eSC7sMMrOe4hI//hLkY89UhIKUX8pmAPZLbWU5dmBk07Sdwya2/fJBUf6w3NuwKd4vMI4vK8ATQvuW5t0VI9ahII/M6I4F7knNuZoNKpDZvKhRkOGELf1bp4logRtKtDZbZirDihugB+odwcAEq2oN79zPpsQ/aH51580j6R4XZ79EgqpkVKt3wkvstzP0MsyXMZv8bbfC0CV7cG0H4WTYnFFaRD2n3N5RdwIfsv1mYNUFCstLZe7DvF/QuicQU7KiMtSijE127s3gVjzqnDWZFy1DIlLPrIq9nzZfxm/wDUxUyiMa2wjOdk7IBiWf1YoEcVp5RppFRPtmRce0ZA2hT89JjDSZS1GZVWythlT+kEY65/Z0dfrXiEQZcatdA5ExulkiJE0XEXuZC4IyUwi2ByfcQs04Cy1wn6UDiNoiNUfEK+LjyxDlSou16rkgIqfYCn+oIfgi1ulZ9xPelxJmCzddeMOwgfcC5uh6KeJe/XXGM8FM/MDAVl6mbof32nJiazER82XpxZGxU8TOr7lJky+5KmBIhQOVi1nOJXPo6GdXognhNMjy3IKOyq1UzjluFm
 G9QgOo2Y
 SVQYMz23FD59wQoNdyyFYjPgdISDMBZXGbM1LKzjLwfIYc3TCQ10YO4kx4hOcTdc1myEJB8aR0jHQg274MKKQzm+Ws7rKF0qphqIUo9GChnkPCwF4RVnXc/33h+AaoVFBrOzBpmxX5a3GInFfKOhldYejg1YCRrrkyUo6AUmCFV5WQ/ZCDLhFf0Jgp0BeULTQxqP0NaEanOxlY8d7R4CmI/kckvxobBQtY6pSfghI04wqD1gS810VpXxIL//uJtwTTb3hR8w2p3Fa+C7amowSdKxgohqGow4tKk2oesD1xKyJ9xmjBSRZQnvOfct+9woLzetqv6iamijAE4Dfgf7Yq1bdb1Wa4f0977vs415oaUfw9ahh1gzPQsGybsGSH3XWifEcQ43Ihu6oSKvMTQ1ActlTnvXFpY/wrTLW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Signed-off-by: Nico Pache <npache@redhat.com>
---
 include/linux/mm.h |  4 ++++
 mm/memory.c        | 56 ++++++++++++++++++++++++++++++----------------
 2 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f8a8fd47399c..c3aa1f51e020 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4916,4 +4916,8 @@ static inline bool snapshot_page_is_faithful(const struct page_snapshot *ps)
 
 void snapshot_page(struct page_snapshot *ps, const struct page *page);
 
+void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
+		struct vm_area_struct *vma, unsigned long addr,
+		bool uffd_wp);
+
 #endif /* _LINUX_MM_H */
diff --git a/mm/memory.c b/mm/memory.c
index 8c19af97f0a0..61c2277c9d9f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5211,6 +5211,35 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	return folio_prealloc(vma->vm_mm, vma, vmf->address, true);
 }
 
+
+void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
+		struct vm_area_struct *vma, unsigned long addr,
+		bool uffd_wp)
+{
+	pte_t entry = folio_mk_pte(folio, vma->vm_page_prot);
+	unsigned int nr_pages = folio_nr_pages(folio);
+
+	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
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
+		struct vm_area_struct *vma, unsigned long addr,
+		unsigned int nr_pages, bool uffd_wp)
+{
+	map_anon_folio_pte_nopf(folio, pte, vma, addr, uffd_wp);
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
+	count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC);
+}
+
+
 /*
  * We enter with non-exclusive mmap_lock (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
@@ -5257,7 +5286,13 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
 			return handle_userfault(vmf, VM_UFFD_MISSING);
 		}
-		goto setpte;
+		if (vmf_orig_pte_uffd_wp(vmf))
+			entry = pte_mkuffd_wp(entry);
+		set_pte_at(vma->vm_mm, addr, vmf->pte, entry);
+
+		/* No need to invalidate - it was non-present before */
+		update_mmu_cache_range(vmf, vma, addr, vmf->pte, /*nr_pages=*/ 1);
+		goto unlock;
 	}
 
 	/* Allocate our own private page. */
@@ -5281,11 +5316,6 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
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
@@ -5307,19 +5337,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
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
+	map_anon_folio_pte_pf(folio, vmf->pte, vma, addr, nr_pages, vmf_orig_pte_uffd_wp(vmf));
 unlock:
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-- 
2.53.0


