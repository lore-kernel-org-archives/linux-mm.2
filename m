Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F375A60A2618
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=VOSH71Cw
Received: by kanga.kvack.org (Postfix)
	id 9AE876B0655; Thu, 19 Nov 2026 08:44:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9125A6B0658; Thu, 19 Nov 2026 08:44:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5056B0657; Thu, 19 Nov 2026 08:44:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 42B106B0656
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:44:43 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE87B120A9F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:44:42 +0000 (UTC)
X-FDA: 85451988804.18.BC60578
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf19.hostedemail.com (Postfix) with ESMTP id E3EAC1A0005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:44:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=VOSH71Cw;
	spf=pass (imf19.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795095881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxMySNVvPjLucVppfHytyY+kX3x4T6lEtLV81QZyco4=;
	b=DfZRSmA1Jn31ysLs+TDQialExK3feTUu99vmyqKXAXboahI69HlkmMItK8Kk9dY/KIdnlr
	cshreA8gQ6kNSllkXdAixYJcBIfTUwIy6+UWYPPpeuJbUjbOS6MeBGVdo0QrlH/thUXwyG
	tF1cl5wCgzHRjfN4sjfvglalE/+lyLY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=VOSH71Cw;
	spf=pass (imf19.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795095881;
	b=zxRRX6ltGd4dlR68/uPpl0004FDLPagjO7O8uPMNpLVsN7SIVZ8o/Sim7ycyG4i97rpvy5
	lEUHL4RJJc2Lr+hmkO7BjRGC506W6qRGTkxQTu4LxxyIqQYkx8x4yz+eQ5M54dok41BXlp
	0Iqg7SXVjcVwRIYb74ZnHdWGEhb8Sgc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=AxMySNVvPjLucVppfHytyY+kX3x4T6lEtLV81QZyco4=; b=VOSH71CwjVoEFr6SOAO
	8v3CqiPqjopc3hX6iCTDL4NRauh3kG0xHnXkKCHlrjAA8HVhxDC1LBky4KT4m6XZdsBh8mfhM5BmO
	5cqz39X85md+IhaionpfkALD9n0Obupl5ILdCuxr3ySgwMYD0g2FZmQN0Pt1KmOSMisNJszpmLXjm
	tX59CZMiVBhp+EAhC6CF/RYD6qkCpY4AaCe6bV7P5Xp9s7w3jcDQibB4Ju3S9SmohtyG+Xf4t+1k1
	9mdiWogiz9RIL/VUlgBJAB0+n1du3N+n2U2IXs5f+vHmrJ1t+Fi3RP0a4/fZ9oSRxU7l+NZjb02BI
	AV/ll/TvEBPEgOw==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xU2R6-00FBqZ-1S;
	Thu, 19 Nov 2026 14:44:24 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Thu, 19 Nov 2026 14:44:03 +0100
Subject: [PATCH v6 2/4] mm/huge_memory: copy file THPs at fork like
 copy_present_ptes() does
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v6-2-efa7817a2bb3@virtuozzo.com>
References: <20261119-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v6-0-efa7817a2bb3@virtuozzo.com>
In-Reply-To: <20261119-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v6-0-efa7817a2bb3@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, 
 =?utf-8?q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, stable@vger.kernel.org, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7540;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=IgE9uAEv/c+7yRxMtgqsFi6vMtEjdXegJpH8fpn8rS4=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq/v02ql8g3EcW9pPf4laG3jC53qlxFzRdsvB1A
 yrQpj8ZU62JAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCav79NgAKCRBRlgpH+WFc
 KuDLD/0WNK6BP+muT6uGJO6/TBtfM3lc/++r4ez/AxsXmcFbyaTeUKJYuV7iodMrqeSHzXKPFAu
 Peff7ZXoDLBCiK6OTguPLQq+FRh43y36PtNF04AkbpAkAqz81/Z9S7Z7sR6rAvi0erU27ugQaEU
 OQrwMzat5vHwy/Zce8pKvxNPhs5N8cWBAdXOOI7Q/mTg4YSfFnfuDIrFiYkZBBAbUI85xM3M13z
 54RxY4DQjjevy0tB9GeVyKtgDf5sZsp0Y63thT/a2yYZ+lSXC9hBVIPiGHmHnzI0nOXzKqh3bo6
 36iTYxBT5/aIoNuDTJ4Kbe2LPQKhOWHvHFqbzcFSDDxydQzPoNmuc2nBpsjJSSF5jg42tBVJaIR
 s+JZgQYe5OGxnP4fKlPitSR6uUk7X/g35C50vyX15buA1ToxmzU9WcWzg4b1j09v1HTC5G3qj2j
 ctWxJjqoSweDpbUtGENb34qfTXIH2wFGEl9pdJsX7o0IZpnVX7MUWTVb7jVOyjZtVN8pchrwdGy
 1+Qxwg8S9wzwqbbL5zW4DKibuQjYV5znPUgWTPb4MlobrR3g5lmyvBx+H3N4jY3Ehxv4CIzQFaQ
 sr/afIhFfjEjiDqgK1NW4OiCzitg535LxOPRw6djD5kgsMReBpj8EM8VQvZRJx1FqwM1SxxFL1K
 no6usWnboYgnAog==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Stat-Signature: 3sr44ri54k1kpizwmw1e8yt39cpt8qhc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E3EAC1A0005
X-HE-Tag: 1795095880-372356
X-HE-Meta: U2FsdGVkX1+X/KhkIJU6//04oT25BotkU1dLk+6B8WdZ3plRDZUS+N55jPjG4rb4eGlJI4jXNrwUrBhq2KI6w3dGJN6TooC0SQ5q/5LhfrZQG7JFEUgE0uvMBiqQO7d5hx7j1NAdatQneCpae4JrUYjDOHxk7awLxvCBo3MuD0fE/FRHARZNpsHdhhjC2UTq6lWJqexFkDYln8rZbw5meyk3V9jw3+IEdHOtHrQweVtyaKcZMME3JA0zFPXIMRf8etqwmJWY6EunPRqXhT6xcwDDWqjF/LhZwhR2aNoM1MsSI+AmjsoQQb7qx7uNnLKRa8THozIKgsfvA0gjSk/wHk9DwF7VY0zg4p4N+a/Q7m+ykDh4UsZiLUZ90qvmI2ZRArwAvbAxAQ0KoFfCnzvINjURfDVn1f9oa3cgIGuLIRd3g7jzyd2DhF4E7JdHMpWygPfTv4tTZMLIdIT7VxXHwy/1I+MsBZA1wwDt2rsQCnJCquXDoFNPK6vJa84g8rVe6hceDq8M8XiEjM6AjQi70sbB/RkidHvP5q3gzH/luSSqP7a60Ck7PgeUr3PmsMEtexcb/GEQhGpU/5EQFA+afzG3cdZRCml8wQjr/ZVvVL75NZH0A9SvdxWFU6zCHy/nzFVIP9SJwnJq8htiWdUyVRKi9suKrLSNoQpzK9KUb/y+ZLv5nMHm0/FOB0mvfORAnPC9SQ/y760pgjHf/wKmbfA06m9SaIXzZa3VHugQWvZejZk1va2MG6yQPu+cRUYX+4/NA0y81KStj2dJa8U4eyybI0lrjRmYOjR0T1cWynzPJQ08hvMWduwRHiejm2v+8MHj1lsOv+PaZa3F5CkFnmj9O96LBb5dJAQJGUfJTgzCOCtQ8WkhsJoAILxx39K54Huch3USuStE2KrA4raCGaOVselF7P+ouKf/UyQOUPd3SjLDdtN16vTdkUh0cEvvNjQjhnqjUfv8+pTS4Hz
 xK1Kw8mi
 GzyB08aeD4Xrx+tVaSPYbrJHFdZct8XNDBEl+yBw2Ay5YWn2GeUWamyPBTpVeKXFzyTzk3uAdfgI3nflWjL4I1bXbkfqX2eqkrBjLfUuhibu7/0vxNBntMuG9aqtCoGsAmj9zWVT2W/9fInRQUXcOFUIV9jzhVzvyn4UI7r7iXi15/ngBolpQt0K+iyArEdN3jqCjwMls6zQqmR7HMEd7sG0wPi7GsQRm+YQhh7cuIrWyDDmWqeOHK5dtk6UPw2sEnqQhlEqP+IwL7byO3G8iJ3j7DKDPLFzeqDEWlIYN70zWIf/azva/HRaXKxcrCuqELM0hjEgZbcz5raOHcTqhLmwxfFBW9kpEQX7drLXhEM+nYO3/8yR3LptR39PXDdRHt9CQaMjC2YEwQ/xPmeZdbuVKUGFqr2+JX7jQtIb51+zqbbRRcHjQnI8x3bLKwJV1bsPCAYDc3KXZwzqyvVzegfnFt3JGHWIoxh9z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This fixes no bug: it makes fork copy a PMD the way copy_present_ptes()
copies a PTE. Until now copy_huge_pmd() skipped every folio PMD of a
non-anonymous VMA and left the child to fault them in again, while the
PTEs of the same VMA are copied.

Treat file folios as the PTE path does: take a reference, duplicate the
rmap and account them. fork then pays a reference and an rmap update
per PMD, and saves the child a fault per PMD it touches. The next patch
sends PFN mappings through the same tail.

That covers the VMAs vma_needs_copy() sends here:

- private file mappings with an anon_vma;
- VM_COPY_ON_FORK ones: uffd-wp and uffd-rwp, VM_MIXEDMAP, and
  VM_MAYBE_GUARD, which shared shmem, file and DAX mappings get from a
  guard region.

A folio over the page cache refcount limit is not copied, as in
copy_present_ptes(): the child faults it in, and fork() fails with
-ENOMEM only in a VM_MIXEDMAP VMA, which may have no fault handler.
Unlike a skipped PTE, the PMD needs no uffd marker: a file PMD never
carries the uffd bit, as protecting it splits it.

The DAX huge zero PMD is copied too, with a reference taken by
mm_get_huge_zero_folio() as for anonymous VMAs. A migration entry of a
file folio is copied and accounted like copy_nonpresent_pte() does, and
made read-only in both processes only in a CoW mapping. A device
private entry gets the same CoW check, as in copy_nonpresent_pte().

The copy then gets the same tail as __copy_present_ptes(): write
protect both sides in a CoW mapping, mark the child's copy clean in a
shared one, and drop the uffd-wp bit where the child is not armed. An
anonymous THP is now write protected only when its PMD is writable, as
a PTE is.

A page table is deposited under the copy where the fault paths deposit
one: in anonymous VMAs, and wherever the architecture needs one.

Cc: stable@vger.kernel.org # needed by the next patch
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 mm/huge_memory.c | 74 ++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 24 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 641e5a3822e3a..277d27a8a4364 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1913,12 +1913,13 @@ static void copy_huge_non_present_pmd(
 		pmd_t pmd, pgtable_t pgtable)
 {
 	softleaf_t entry = softleaf_from_pmd(pmd);
-	struct folio *src_folio;
+	struct folio *src_folio = softleaf_to_folio(entry);
 
 	VM_WARN_ON_ONCE(!pmd_is_valid_softleaf(pmd));
 
-	if (softleaf_is_migration_write(entry) ||
-	    softleaf_is_migration_read_exclusive(entry)) {
+	if ((softleaf_is_migration_write(entry) ||
+	     softleaf_is_migration_read_exclusive(entry)) &&
+	    vma_is_cow_mapping(src_vma)) {
 		entry = make_readable_migration_entry(swp_offset(entry));
 		pmd = softleaf_to_pmd(entry);
 		if (pmd_swp_soft_dirty(*src_pmd))
@@ -1931,7 +1932,8 @@ static void copy_huge_non_present_pmd(
 		 * For device private entries, since there are no
 		 * read exclusive entries, writable = !readable
 		 */
-		if (softleaf_is_device_private_write(entry)) {
+		if (softleaf_is_device_private_write(entry) &&
+		    vma_is_cow_mapping(src_vma)) {
 			entry = make_readable_device_private_entry(swp_offset(entry));
 			pmd = softleaf_to_pmd(entry);
 
@@ -1942,7 +1944,6 @@ static void copy_huge_non_present_pmd(
 			set_pmd_at(src_mm, addr, src_pmd, pmd);
 		}
 
-		src_folio = softleaf_to_folio(entry);
 		VM_WARN_ON(!folio_test_large(src_folio));
 
 		folio_get(src_folio);
@@ -1954,9 +1955,11 @@ static void copy_huge_non_present_pmd(
 					    dst_vma, src_vma);
 	}
 
-	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
-	mm_inc_nr_ptes(dst_mm);
-	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+	add_mm_counter(dst_mm, mm_counter(src_folio), HPAGE_PMD_NR);
+	if (pgtable) {
+		mm_inc_nr_ptes(dst_mm);
+		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+	}
 	if (!userfaultfd_protected(dst_vma))
 		pmd = pmd_swp_clear_uffd(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
@@ -1972,6 +1975,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	pmd_t pmd;
 	pgtable_t pgtable = NULL;
 	int ret = -ENOMEM;
+	bool writable;
 
 	pmd = pmdp_get_lockless(src_pmd);
 	if (unlikely(pmd_present(pmd) && pmd_special(pmd) &&
@@ -1992,13 +1996,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		goto set_pmd;
 	}
 
-	/* Skip if can be re-fill on fault */
-	if (!vma_is_anonymous(dst_vma))
-		return 0;
-
-	pgtable = pte_alloc_one(dst_mm);
-	if (unlikely(!pgtable))
-		goto out;
+	if (vma_is_anonymous(dst_vma) || arch_needs_pgtable_deposit()) {
+		pgtable = pte_alloc_one(dst_mm);
+		if (unlikely(!pgtable))
+			goto out;
+	}
 
 	dst_ptl = pmd_lock(dst_mm, dst_pmd);
 	src_ptl = pmd_lockptr(src_mm, src_pmd);
@@ -2016,7 +2018,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	}
 
 	if (unlikely(!pmd_trans_huge(pmd))) {
-		pte_free(dst_mm, pgtable);
+		if (pgtable)
+			pte_free(dst_mm, pgtable);
 		goto out_unlock;
 	}
 	/*
@@ -2031,13 +2034,30 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		 * copy. It just takes a reference.
 		 */
 		mm_get_huge_zero_folio(dst_mm);
-		goto out_zero_page;
+		goto copy_pmd;
 	}
 
 	src_page = pmd_page(pmd);
 	VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
 	src_folio = page_folio(src_page);
 
+	if (!folio_test_anon(src_folio)) {
+		if (unlikely(folio_ref_count_over_limit(src_folio))) {
+			/*
+			 * VM_MIXEDMAP may contain driver-inserted pages with no
+			 * fault handler to reconstruct the mapping.
+			 */
+			ret = (dst_vma->vm_flags & VM_MIXEDMAP) ? -ENOMEM : 0;
+			if (pgtable)
+				pte_free(dst_mm, pgtable);
+			goto out_unlock;
+		}
+		folio_get(src_folio);
+		folio_dup_file_rmap_pmd(src_folio, src_page, dst_vma);
+		add_mm_counter(dst_mm, mm_counter_file(src_folio),
+			       HPAGE_PMD_NR);
+		goto copy_pmd;
+	}
 	folio_get(src_folio);
 	if (unlikely(folio_try_dup_anon_rmap_pmd(src_folio, src_page, dst_vma, src_vma))) {
 		/* Page maybe pinned: split and retry the fault on PTEs. */
@@ -2049,19 +2069,25 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		return -EAGAIN;
 	}
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
-out_zero_page:
-	mm_inc_nr_ptes(dst_mm);
-	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+copy_pmd:
+	if (pgtable) {
+		mm_inc_nr_ptes(dst_mm);
+		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+	}
 
-	/* See __copy_present_ptes(): restore accessible protection. */
+	/* See __copy_present_ptes(). */
+	writable = pmd_write(pmd);
 	if (!userfaultfd_protected(dst_vma)) {
 		if (userfaultfd_rwp(src_vma) && pmd_uffd(pmd))
 			pmd = pmd_modify(pmd, dst_vma->vm_page_prot);
 		pmd = pmd_clear_uffd(pmd);
 	}
-
-	pmdp_set_wrprotect(src_mm, addr, src_pmd);
-	pmd = pmd_wrprotect(pmd);
+	if (vma_is_cow_mapping(src_vma) && writable) {
+		pmdp_set_wrprotect(src_mm, addr, src_pmd);
+		pmd = pmd_wrprotect(pmd);
+	}
+	if (src_vma->vm_flags & VM_SHARED)
+		pmd = pmd_mkclean(pmd);
 set_pmd:
 	pmd = pmd_mkold(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);

-- 
2.43.0


