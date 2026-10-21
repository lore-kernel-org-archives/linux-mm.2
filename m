Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B08A606A33B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=RhqVHXEU
Received: by kanga.kvack.org (Postfix)
	id D749F6B079E; Wed, 21 Oct 2026 16:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4C526B079D; Wed, 21 Oct 2026 16:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B03436B07A0; Wed, 21 Oct 2026 16:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 72C0B6B079E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:36:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0397BA06A2
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:36:29 +0000 (UTC)
X-FDA: 85347791340.02.8E7093E
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf11.hostedemail.com (Postfix) with ESMTP id 301FD40006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:36:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=RhqVHXEU;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf11.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792614988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y1RzK/YwA6RDAUfpjsoiTntAin9i553yc8Nq4zLllH0=;
	b=SI3aHweFqiRp/PU1WiS4uk+daJ9GQitxt8NmdtUGCPwLJowpeq+Nfwzn44r0U3qj2jw5sq
	T6AnvykTPANG5WhT4YhXiwNoIoOD1PzRYkhAflb1F1Zzc9kxC8u4C+ryJUh/VczSjPVrmM
	bj0hvn4PSvtjcT+3s+1o81ogtBqGQHw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=RhqVHXEU;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf11.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792614988;
	b=8F8eINau7vqGdlS2nbAoVeIFYo1PGp7qAqFh1OxQpa1ceCxldlASlnDtNfheWi1BEzN5b7
	C30cG5Z1H/7Jc8wQhUGVO8d+HtH+0WSs0MeeUbXchiRMoNlcDR4ZXvgr2WEgJTRdHgnFBb
	Ml2SCnO9Kwc6Q6lOvCUomb6931bR+ew=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=Y1RzK/YwA6RDAUfpjsoiTntAin9i553yc8Nq4zLllH0=; b=RhqVHXEUndGRIBgj47h
	pPTEb3m6RFxj9akFPIe49tfRDAWGu26fjc4+SDC49mdYbeFVhe8zQZkaUaZFK7AjbQL3IGmqVKaCa
	gOS7QcNIMyb6KrjZCFIVIRvhYvww4AV1cssjbcdRr/Q3L82+1sVwQ31SOyzTWtyZ5jQDeBfLsQrpJ
	m6u91/gJhvifPvsIhnE6+5GKwT4TRY3m705hpJo9F8zBUd2XTeL0tOlofB6fwXlyd/0bGmar9P0xU
	tkE1I0WfXSxsDKFEVnTWFOvW6QJ/5uCmZiNTT2iaEfIuUDWH6HHGV3U1ciwYdxbhRZLnmDCBicEKA
	fjiy54bFVpTiO9w==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xJcz5-00D9zC-2L;
	Wed, 21 Oct 2026 22:36:10 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Wed, 21 Oct 2026 22:36:01 +0200
Subject: [PATCH v4 2/4] mm/huge_memory: copy file THPs at fork like
 copy_present_ptes() does
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-2-66f00b7a564c@virtuozzo.com>
References: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
In-Reply-To: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6227;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=nh00pu51IsT3zM5A1R7uGgA2XAL0sg7pMkX5L0hR5qg=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq2SI40uwjfe9GN/YmjA61tXcSKiQclxtfzMsN2
 Mbs7XLQIiKJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCatkiOAAKCRBRlgpH+WFc
 KrT/D/9BsSDADsSj6G/kkL7TPB7IeoBkX1b2TyhPck22FQPKaM7KpzLFRcfIlpY+i8x0WkPgfBY
 OBi4LgL4xWrkveBTEc9ukzjhBe6h48OLwn2ImfvO9Fz4qKbPu7tK5NdQH/MeE62+bE3uujTmIxk
 TPXMxn0+GDL+7egr1nSfucEIITm1+vBjjSF0BddxU6SdmEXheMXxx7owHZD69xk1pSvp2ME16Jl
 JXdCj47SxNS19CV9mwQMe1p6xni3KnyIOsHhDwfK/c9Gv5fhAtoZAiKXBoIFQheeVFs6W3i2EaE
 BLytz3oIIRe6UOIyoQiQWoTz58090luuI7BLEgWefdW8n105r9mpEPEWdfCzcV4WnAV85LCBJjY
 3GGRaiYqsiwNOOYHOJSDDFuQ6wNU2f7qUQW00F7+ItUW/YNpQkduJPd0oyhkVjZElADi1N1HmED
 L8Yqb7L2nDf5XmAe3bxSMP94FZgLsWj2sc6Eu7a2MBBSIQm/2uTIANeUPY+zPYaCpq4u6gvcdIK
 gQO3Y7YvAVIwgR0Xe9qpaqBAac7KKA4EKcHbyksi4H3gfdfbIOyUoR061Zy/oRCnbeqKhSCK68/
 34DxAgGEfDzRaZ4v3q1LOAQnbQa3gKN6FDRCB/n+uTAD7MA5e3jl5ouJo1FKowyN2ZOOwJFJk1J
 IpAwWMr+4r/tNzQ==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspamd-Queue-Id: 301FD40006
X-Stat-Signature: u3k1nt7a83uoooozqwhtbzhi71kjwyqa
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792614987-719437
X-HE-Meta: U2FsdGVkX18fJidVWOuJiPOhXqrDkLTCdXGaTPNu4j9AKcjn0JNCU7LAhvv0PPiZbgSk8+KWGV3vwZDH6MgUwpjzh3G0Wi/qo8rWSvA7xVqWg43GFNdDTlodgV77dKxECrfkYK/iP9TZZSssGcLZdSLdwMJz/FQiOACtNQYZh8EMZI6lxurg0/ocQz52mQUi5KD7i2xl+MS20HtPo6TDG8C7BViZVYXUsZW+SgL/LB1pi8ZG6fj5CK8/k5n0dhcWKlu8SFzWUuMntBVCyy2/6/0LDKFxC8zuzdPcvDwI67M3Y8CE0xHMaaDTtwlxt46MvX/NJK7Iiaqmb3RAy7YV3rjdnVLMiX6nk/yNDwk+vpWhG4n45+4S7PSa2z6UbI1w68NYDt48AMrVFft+jLYULguwK0MsxfCK0uULAsS1+cRqMhRPyV0EPIJCh1LM4qRi1HloJMSVGeAiYU/KwsaozKXydEbrv/WCgNOHpw6VcON4ccGw1BPYmw6QmXatjfdcfmMX5Ne9ulxAKHqIATrqLHDiO254mS7VCqWidnxdLsBkCQfbPnqWXKs9Ayo7EGmbWAd/4u4w3V6G04ZeLgjeBOxaOn6yk1jqZAD6RKUhgLzmzoz+HVyQTgcL691i6xHJDjfyziPJNpq04FQ5+YMqnQVQYkli4ugL5FGhw/eDU07R5g1pOjWcy1GxQyWAC82zf0SaIYA95mcR52R30GIwR3dvTUEj6dEnzABzJr1fB/qUC21L3b2k54586wyotfbbPJO3a0+JZ131gFoI4UMlxXJqYhxF85XUHthx2S7dUHq/YdboiS26IqsztR4sIi6YH7Np9hfZ9856beZXNG6FCFHxVmeE8s4zpYqVSeRBPq9Wa68WCgkhNXrCYTCa5X4Q6zsP0/uUuJnbcWUxtzYSN5dvb+uneOYdquTQOqq+/mCP4CPY9EnArg1JRLoOEMNT4BAJv5v7iKdt5DA0GxP
 gRPtxzqK
 9v7um2M3sod9/LzEEE8wyS5MB8/qkA5tM0CoiDZj7IOC8r8YVu/AQo8QHbcl2wtVQMdrTYyNcYJkH49lIoZcJq27r1z4LPCh4yauD+wXsYvI0z6sC3Q5Ze2mgr64z9GFxiRtyToMgbSkTSPz4rjEVdNzoT/4ABFcCYhbCg8qA+E1M1QsPAU4cWof6+6WMXix1WDiuFD39PeEePWaig1X3RqyR+M66t3LS2Td+yLagzH7PGG6U4AsRslr8YywuzErSogvq/3GR2yBvtdUAhYCKkjqWoFhZXnC9ANotm1Z6lrKtNaIwwjs26R+aO0P8GL7T+mnnKanD/ymiLN6jvdqQJLtHhhfsW9AacuCQJag2tsNW/emaFhqL+6SwwSdOjb75++1gyGHI5L2YJQiP1SQofnpaahJoWciFixZMNFKjg9Lfe7BbUW/56FawYg==
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
- VM_COPY_ON_FORK ones: uffd-wp and uffd-rwp, VM_MIXEDMAP (fuse DAX),
  and VM_MAYBE_GUARD, which shared shmem, file and DAX mappings get
  from a guard region.

The DAX huge zero PMD is copied too, with a reference taken by
mm_get_huge_zero_folio() as for anonymous VMAs. A migration entry of a
file folio is copied and accounted like copy_nonpresent_pte() does, and
made read-only in both processes only in a CoW mapping.

The copy then gets the same tail as __copy_present_ptes(): write
protect both sides in a CoW mapping, mark the child's copy clean in a
shared one, and drop the uffd-wp bit where the child is not armed. An
anonymous THP is now write protected only when its PMD is writable, as
a PTE is.

A page table is deposited under the copy where the fault paths deposit
one: in anonymous VMAs, and wherever the architecture needs one.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 mm/huge_memory.c | 60 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1e5d68acf62a5..13e3674fb6115 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1898,12 +1898,13 @@ static void copy_huge_non_present_pmd(
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
@@ -1927,7 +1928,6 @@ static void copy_huge_non_present_pmd(
 			set_pmd_at(src_mm, addr, src_pmd, pmd);
 		}
 
-		src_folio = softleaf_to_folio(entry);
 		VM_WARN_ON(!folio_test_large(src_folio));
 
 		folio_get(src_folio);
@@ -1939,9 +1939,11 @@ static void copy_huge_non_present_pmd(
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
@@ -1957,6 +1959,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	pmd_t pmd;
 	pgtable_t pgtable = NULL;
 	int ret = -ENOMEM;
+	bool writable;
 
 	pmd = pmdp_get_lockless(src_pmd);
 	if (unlikely(pmd_present(pmd) && pmd_special(pmd) &&
@@ -1977,13 +1980,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
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
@@ -2001,7 +2002,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	}
 
 	if (unlikely(!pmd_trans_huge(pmd))) {
-		pte_free(dst_mm, pgtable);
+		if (pgtable)
+			pte_free(dst_mm, pgtable);
 		goto out_unlock;
 	}
 	/*
@@ -2016,7 +2018,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		 * copy. It just takes a reference.
 		 */
 		mm_get_huge_zero_folio(dst_mm);
-		goto out_zero_page;
+		goto copy_pmd;
 	}
 
 	src_page = pmd_page(pmd);
@@ -2024,6 +2026,12 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	src_folio = page_folio(src_page);
 
 	folio_get(src_folio);
+	if (!folio_test_anon(src_folio)) {
+		folio_dup_file_rmap_pmd(src_folio, src_page, dst_vma);
+		add_mm_counter(dst_mm, mm_counter_file(src_folio),
+			       HPAGE_PMD_NR);
+		goto copy_pmd;
+	}
 	if (unlikely(folio_try_dup_anon_rmap_pmd(src_folio, src_page, dst_vma, src_vma))) {
 		/* Page maybe pinned: split and retry the fault on PTEs. */
 		folio_put(src_folio);
@@ -2034,19 +2042,25 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
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


