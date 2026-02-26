Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6FA5FD45FF
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 01:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43EF86B0089; Wed, 25 Feb 2026 20:30:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E9B06B008A; Wed, 25 Feb 2026 20:30:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C17F6B008C; Wed, 25 Feb 2026 20:30:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1852C6B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:30:54 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A012C13AE53
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:30:53 +0000 (UTC)
X-FDA: 84484878786.29.6AA16E4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id AB3A9A0005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:30:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NbNSEyyF;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772069451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6CWKU+s+/ibAb4RGR5iOyoI/KP+ZxoADOlF3DvBlYHY=;
	b=5qXuhulOUzA+VXq12YQau/F8PvkCifUUNYjhT5eyQp+hIRSMz8JTkeyCNGImzFo2mkW/PY
	iDyuKz+1djqfMZ8IwdIfeH2TZi/vQtBE3TqNzYj76TzAxvTUGeupJfYDAxTUJRZuyRmqTs
	FzBg5sucswU1fVqBlXFWsyXaiowZsxE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772069451; a=rsa-sha256;
	cv=none;
	b=6nySU9GUU2z5EYtTL4AzFahtgHfV4i1NXtQVrtZmo32FoXY0lh+yqh5eSTyBTdLrRcwvpk
	ZMqyC4X7PrhJBJoIs7bV5xuPLZ2tR8SuP4gVtIL63hBLypUKGQgb4d6Rwtl1SHp30MSu8l
	bcpLlCbwUEp6QyZZa0n45LrFN7gamEg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NbNSEyyF;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772069451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6CWKU+s+/ibAb4RGR5iOyoI/KP+ZxoADOlF3DvBlYHY=;
	b=NbNSEyyF4JJn6qnAytRRaHtzP1hVP/aQjUf8q5vAV8hDM+TyplumltmGujFxaCmOB3CVtb
	FdpkcV5QgPISgabjO/cHOyJNhJoQ8W1G+CRDmTGvZ5UaG8AqJtzUvvEx+ouIXHR93f3ruv
	riFbnMLYiJODhI3+2YKvL4o2yaTHN3s=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-54-BVZLdWHXPHC8rvvMyBCjmg-1; Wed,
 25 Feb 2026 20:30:46 -0500
X-MC-Unique: BVZLdWHXPHC8rvvMyBCjmg-1
X-Mimecast-MFC-AGG-ID: BVZLdWHXPHC8rvvMyBCjmg_1772069441
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 64D271956080;
	Thu, 26 Feb 2026 01:30:39 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.173])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1CD923003D8C;
	Thu, 26 Feb 2026 01:30:18 +0000 (UTC)
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
Subject: [PATCH mm-unstable v2 1/5] mm: consolidate anonymous folio PTE mapping into helpers
Date: Wed, 25 Feb 2026 18:29:25 -0700
Message-ID: <20260226012929.169479-2-npache@redhat.com>
In-Reply-To: <20260226012929.169479-1-npache@redhat.com>
References: <20260226012929.169479-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9YbwYi_45OlN3yy6aRIIU4v1sHYWYGI64Rpg-_8imZQ_1772069441
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: AB3A9A0005
X-Stat-Signature: y5rwpji5qi5iorhoqoypzmiscndysbf3
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772069451-944929
X-HE-Meta: U2FsdGVkX19yCMTu5oyfcfkLoWhuJU2wTQMomDg72JORcc8w2XEVaTNttQ80Arq0AWK3KNoOYY06ZzauNQkjFRrgBZ7PRLHkfk7R+uULvSuc8sQriroiNBONndyOJXTvKM4kmNIPuMMjxcv7iNCjgm7SC2ujO3XwoczhhXezD2lE9EMy1FeuXPiWPbbi57JozMNS0U79x4gTPULuevKRGKrm4kqg14ShSSCxBe+nDD2qZZQ1XU+8bwdgKCkkgqlMXgb/bq6I0g9gR3cc+pcj3KME+1nH0p3sPMk/yCjF+byHEzvvPBYiQYJO1mMBBr43vPPw0s5j4xyzGdDkjQXeBF4PrUB0B48VQzeX6jV1okV6TnsG33aYjKru9iNlXJjcer2WaJ6EI/vQRURHIcoRRSB6qlkSNS4Usbi/R/u3F/Aokc1YLUpGWKthnG4hsmDh+EjXEkuiwHEClydqyPwq1VaynZ7ZYMBQ2g+yoKrUV2IItTIk4flESRJFs0xGpUOABtj6qw3pJvwGQVpMJ8AQYN2NXTYCr+J5Wk/c7ehi46SNQKjGaXg6Uit76fY1yA/ONClw5nQrImDd+uEX9lSoIsHwbkl9xd15quXhomTYS9WnySZHJrLlBKICixLF2MdYB/8RI5dBJJ1KX+beINuMeU30gwld2rCIF7O8lse/r+1+WqYRKkPPbdQB8ZHHj02KEJH/9W/WL4YzbAUzNt5vWRN9yYPCJ4kObl0NGAa04ccfNIkBSyUjJEnstKJAXV/izONMJHqVnQ45dOJ4CvsWWYL7mwNt5qmoitEYvq5/Uug4+LreQxhaF4cOjKyrkB6siyFPdGQZGIM2DMVzP70jZeQ4U4dYXmFoQKBLVxj7Xu4UrvjdEsZIdakZT94b3ucLIVT9XoOLzSZpNqMCXoKNT6RcvgWKIFhPYWeN5uYYVonzlDLDN+aKoEREqoYTfV4S1xRjL5QBS54hvAlSXFA
 6kRKQICz
 ahyXmcDuMeCov2yylXJ5+cqQRMdMONhZTCLkn8iu0Lm31wk/1EMevnq+Vp7LfbByVeErXMn2Y8ZcQdL7KHydXtUKlS7UpEltUBzkYJJKxkAeN2NIgr7TweGQ1pNdiCsxiIJDlHOAvGH8g6Cb27lRuiaYtSokxr1ShE4py9IW2lrFr1kBIjcVbDRZx7xiRM6DMjFolHqhvnw8vy7ZgTvBwFzn6iRHwTs0ORBehse+YqHzVFw1uUcnLXfUqhgg5o3oIAU3l4KHn71XlsDCvzcJfDIOqBSF/vyGH2sa1EuLesjRcblcamIgAcplXzGWWOkkKJFPIwxX8D1EF5uKpdydrHy0+aFJ/5cpmZfgCpayo/ujQhc1fVygVUeyvzB3Qn0jc4UNbIUk5WoXzHyeKHe83CXNjdcBQ9ys00u7W
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
 mm/memory.c        | 59 +++++++++++++++++++++++++++++++---------------
 2 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 13336340612e..3ebf143c7502 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4901,4 +4901,8 @@ static inline bool snapshot_page_is_faithful(const struct page_snapshot *ps)
 
 void snapshot_page(struct page_snapshot *ps, const struct page *page);
 
+void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
+		struct vm_area_struct *vma, unsigned long addr,
+		bool uffd_wp);
+
 #endif /* _LINUX_MM_H */
diff --git a/mm/memory.c b/mm/memory.c
index 9385842c3503..a1a364e1fdcd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5189,6 +5189,36 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
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
+		struct vm_area_struct *vma, unsigned long addr,
+		unsigned int nr_pages, bool uffd_wp)
+{
+	map_anon_folio_pte_nopf(folio, pte, vma, addr, uffd_wp);
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
+	count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC);
+}
+
 /*
  * We enter with non-exclusive mmap_lock (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
@@ -5235,7 +5265,14 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
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
@@ -5259,11 +5296,6 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
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
@@ -5285,19 +5317,8 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
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
+	map_anon_folio_pte_pf(folio, vmf->pte, vma, addr, nr_pages,
+			      vmf_orig_pte_uffd_wp(vmf));
 unlock:
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-- 
2.53.0


