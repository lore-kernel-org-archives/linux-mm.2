Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EBADFF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4B1D6B00A4; Mon, 27 Apr 2026 07:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23196B00A5; Mon, 27 Apr 2026 07:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11CE6B00A6; Mon, 27 Apr 2026 07:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AECC96B00A4
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:47:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F5AE88344
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:47:07 +0000 (UTC)
X-FDA: 84704159694.10.3926BB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 65D8B4000E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:47:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S2kY4Ifg;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777290425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywPicypYC7HTaVTdrenfdHUqnM2gCO3YTW7LjQSbZPI=;
	b=RgZo8fyXp2e38SvRfxqJ3D8qX0MNsOgRG94Yi775f7+kDm2SNQAIznv4KS1WXeYLR77dHU
	1EoUaTdlg8Tdc8QbYVHFNfqq0QfFzjt3vBoG+/O+FTzIOeVqDrcJnyh2bLLOawSOOfq2Zb
	oZTK71qIDZHmWhg+qisRDCMlADRfcFI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S2kY4Ifg;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777290425; a=rsa-sha256;
	cv=none;
	b=2Y8yp/9vdMWrYV0DcwmVs5giRGbpsEUb9RwFGwOdj343juoBLJg2ML69AoA2C71hWbhl6m
	ddNKlprjIoyQJYZfQRjYRgOaD5qunI5LPj+Pa3ZvflzbkXpXbwUpSiIYVRioNsuTDMtHwN
	PzUa2NpOZeSZeZ1WBJwjaMdfWRlbntU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BE4143688;
	Mon, 27 Apr 2026 11:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC232C4AF09;
	Mon, 27 Apr 2026 11:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777290424;
	bh=YSHxQHof/yP58foLsVD40WYmsz90csyu30ITr5dLlJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2kY4IfgR4Xp5+uRjK0lM2JpCiNYgjUO9R9eYpfdq3XuqZ8k/TQi/bA+362uVnWmd
	 qoi8H8m6Sut6r982BwZb2B2YKwZLoqMqfN7wd3uoNByaVvd9G4LGj9uB8AnidNSG9v
	 P/56nXsn1kbyWbD/IIaVcIQtcIQLg+2PPrbVTy8BMTs5nXKIIpNfT8u8DZQEx12qXq
	 cFAEwdOHDpwrK6nORLqWIxvmObPnNGv3atAvX9BbCjIQQ89jNi6gCwvNFztGjzzxE3
	 2HGY2plcTWVejWfbkkdHKxztaS+JwuJQ2LbKWuEF6rZ/nMKrVDTWwkylmCDNvsR5kR
	 LhdfllEXs4v/Q==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id E7013F40069;
	Mon, 27 Apr 2026 07:47:02 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 27 Apr 2026 07:47:02 -0400
X-ME-Sender: <xms:tkzvaTDUnL7oDfsGzeq254G56rqZLOHzxIP7jhqCS1hFWTRupgq-wA>
    <xme:tkzvade_0xkczA6hIlADKWZFJnk4smIimfU1rly6UuXtGzu-pkA7-Bs9KUJmojGXh
    5OG3ROvo9XfHd_FuSPXhhHHolT76vqXBXNLUlF24wTfdmYjk8gnUG4>
X-ME-Received: <xmr:tkzvaXEYddLZjXQV2P-sCftvx9NdXTL8XfLxUeQiozo8AgePvEtjaGsvbd-JMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejkeeiudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvvefufffkofgjfhgggfestdekredtre
    dttdenucfhrhhomhepfdfmihhrhihlucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceo
    khgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpefhudejfedvgeekff
    efvdekheekkeeuveeftdelheegteelgfefveevueekhfdtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmthhprg
    huthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdekqdhk
    rghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtph
    htthhopedvgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhn
    uhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehrphhptheskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgtphht
    thhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehljhhssehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghp
    thhtohepvhgsrggskhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihgrmhdrhh
    hofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihiesnhhvihguihgr
    rdgtohhm
X-ME-Proxy: <xmx:tkzvafX-2McoyjfKUU_4VzY44gZKgJEWzyK6KmbPqfK6YsdsqYrf6g>
    <xmx:tkzvafz-GFux-PPb3CJ4R05cIqHywzhUOnG4VjGAWm7mp9YxvDOOgw>
    <xmx:tkzvaSsLVNYqtjDCRwfdECDRRIXTfDoAN1WpJIOaF8tq9jZDGym1mQ>
    <xmx:tkzvaYCJZqn-NgUtEgOYv8VvPV4tFh39xYG34NtB7la81BHEWXBaSg>
    <xmx:tkzvaWq601oHfZhy23-zKtduly8wmoolsg_MVSVPp8VQMeDW8_y_xGIH>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Apr 2026 07:47:01 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 06/14] mm: preserve RWP marker across PTE rewrites
Date: Mon, 27 Apr 2026 12:45:54 +0100
Message-ID: <20260427114607.4068647-7-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260427114607.4068647-1-kas@kernel.org>
References: <20260427114607.4068647-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 65D8B4000E
X-Rspam-User: 
X-Stat-Signature: bdgfi65emtpcnjdym9mkku6aa5cpf4cr
X-HE-Tag: 1777290425-552789
X-HE-Meta: U2FsdGVkX19MaRIDudMf+fRgssX0kxmKGZTgbJUqpnufeNqgq7yLeeNNlVyOWxa5zRPjZfkd8nnFbaQUJbm1I7D+e2teoMpN5rXWAvEWcYGG2sGt2XjSKiIvY2kPFql/eFuMiVjwFR9z1reuBzSFp/V5hpG1j22RL6Lj07EcgWQFinQfdOIoilAgbG4QUwGkXw92dvS1nTuZoxILsGCUi11aTr7RKIiT+S/r/fPMRZCtv4CPO8VIfmF5HLZcgI+zXM7orUUY0m29lT+MTjcxZUyk2t33D9Q94TmKB0Z+C6ZQexBAHGh2lWIWk0zQaBD7E+MMbwgoXDH7jSnyVYejGUakrcvxS748ZqidXPz1dUq6t7khe/N5UCugnSFuX5hfHeJJ4rsTLWMINVH6BBzYFPQaIql+VDosnT1mIT0Qquq4X5WK5FAfVy5R7OXE5Q/WgOReM88DYWf6zlEmHOxW0yf0rjnz0p2aq6YlYT2l0UAkIRIzg11iB+VyeiOTSUSoiWihomqBgrjTAAw9BRdPTTD/9ozqIm7MlHMHy148+NOn92iKQlpKx9ck89c5UWwR+mijrzOrrPiaojMbSk3eflDKGLVd3VCFJnGK6xBjVRP4iq+Ytu1HJOvzwjIC+dBCc1vw712czgMjJPuUnQbN2vGCvNJdij/WtPpi7Jbk3iUik571rrx9Dd8KBL7Zyc/A6Kw3/1IwNl6lhffxv1Gr9d7861MwK+A2BQambf8TrB3BosPXAUl/wYG0s189EzsXOx0Y+bQfvB0pvRmQL+ZmuabULjfwzAfwCHGHY/O2z0ySBbzmoC0sOum6g7qtXdJBOYocjVliTIgORTfH5Sw02ksnXZ5M55dIf1pc1wlhCzysVrcwGPPEuDSOAdKh7O9dN6rG0/SbsqxID/1KqwrwRtOt8vF769h93XJpGC9PKc7SBkJcvWClA02+wPBCLUUJC0MWCCiGaWN5Umi8VrM
 gSIQaI8m
 7VmF1pzYrZrG21leoE7ZpK9CGJWPgUH0SOO9lK5cdQhylqqFTyZfo75e1tiMlQ7oCL/ZoNyeoHqsHwW8n6FpFQhGzHNLzdje8B363fLl1wJptHXDbNfFbUBFljCMbwLXXuxLOEeOCnnIymIg8gC+rGRmRgwiH0Qjzcg9HC3SnH6Ib4sJbjQjFWzJfNA/RAvmEnJmzAXCfYEr4rKW9eep7dmlH9VmmT4FMXUklCKOk/LdgZ+DImpiUJqjtWjsfuuqsVGaE5lSBRryIdAE2+f35TtSVSYGFBVrLO+ILQVdg9gocXos=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The uffd PTE bit must survive any kernel path that rewrites a PTE
on a VM_UFFD_RWP VMA, otherwise the marker that carries PAGE_NONE
semantics is silently dropped and the next access leaks past RWP
tracking. Wire the preservation through every path that rewrites a
VM_UFFD_RWP PTE.

Swap and device-exclusive: do_swap_page(), restore_exclusive_pte(),
and unuse_pte() (swapoff()) re-apply PAGE_NONE when the swap PTE
carries the uffd bit and the VMA has VM_UFFD_RWP.

Migration: remove_migration_pte() and remove_migration_pmd() do the
same after the migration entry is replaced with a real PTE/PMD.

Fork: __copy_present_ptes(), copy_present_page(), copy_nonpresent_pte(),
copy_huge_pmd(), copy_huge_non_present_pmd(), and
copy_hugetlb_page_range() keep the uffd bit on the child when the
destination VMA has VM_UFFD_RWP, matching the existing VM_UFFD_WP
handling. Add VM_UFFD_RWP to VM_COPY_ON_FORK so the flag itself
propagates.

mprotect(): change_pte_range() and change_huge_pmd() restore PAGE_NONE
after pte_modify()/pmd_modify() have recomputed the base protection
from a (possibly user-changed) vm_page_prot. pte_modify() preserves
_PAGE_UFFD, so the bit stays; we just have to force PAGE_NONE back
on top.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/mm.h |  3 ++-
 mm/huge_memory.c   | 47 ++++++++++++++++++++++++++++++++++++++++++----
 mm/hugetlb.c       | 40 ++++++++++++++++++++++++++++++---------
 mm/memory.c        | 47 +++++++++++++++++++++++++++++++++++++++-------
 mm/migrate.c       |  8 ++++++++
 mm/mprotect.c      | 10 ++++++++++
 mm/mremap.c        | 13 +++++++++++--
 mm/swapfile.c      |  5 +++++
 mm/userfaultfd.c   | 14 ++++++++++++++
 9 files changed, 164 insertions(+), 23 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2b65416bb760..1f2b6c6cc572 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -663,7 +663,8 @@ enum {
  *                           only and thus cannot be reconstructed on page
  *                           fault.
  */
-#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_MAYBE_GUARD)
+#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_UFFD_RWP | \
+			 VM_MAYBE_GUARD)
 
 /*
  * mapping from the currently active vm_flags protection bits (the
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2537dca63c6c..2aecb6d01c44 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1918,7 +1918,7 @@ static void copy_huge_non_present_pmd(
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
-	if (!userfaultfd_wp(dst_vma))
+	if (!userfaultfd_protected(dst_vma))
 		pmd = pmd_swp_clear_uffd(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 }
@@ -2013,9 +2013,15 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 out_zero_page:
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
-	pmdp_set_wrprotect(src_mm, addr, src_pmd);
-	if (!userfaultfd_wp(dst_vma))
+
+	/* See __copy_present_ptes(): restore accessible protection. */
+	if (!userfaultfd_protected(dst_vma)) {
+		if (userfaultfd_rwp(src_vma))
+			pmd = pmd_modify(pmd, dst_vma->vm_page_prot);
 		pmd = pmd_clear_uffd(pmd);
+	}
+
+	pmdp_set_wrprotect(src_mm, addr, src_pmd);
 	pmd = pmd_wrprotect(pmd);
 set_pmd:
 	pmd = pmd_mkold(pmd);
@@ -2601,8 +2607,16 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
 		}
 		pmd = move_soft_dirty_pmd(pmd);
-		if (vma_has_uffd_without_event_remap(vma))
+		if (vma_has_uffd_without_event_remap(vma)) {
+			/*
+			 * See __copy_present_ptes(): normalise RWP PMDs so
+			 * the destination starts accessible instead of taking
+			 * a numa-hinting fault on first access.
+			 */
+			if (pmd_present(pmd) && userfaultfd_rwp(vma))
+				pmd = pmd_modify(pmd, vma->vm_page_prot);
 			pmd = clear_uffd_wp_pmd(pmd);
+		}
 		set_pmd_at(mm, new_addr, new_pmd, pmd);
 		if (force_flush)
 			flush_pmd_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
@@ -2741,6 +2755,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 */
 		entry = pmd_clear_uffd(entry);
 
+	/* See change_pte_range(): preserve RWP protection across mprotect() */
+	if (userfaultfd_rwp(vma) && pmd_uffd(entry))
+		entry = pmd_modify(entry, PAGE_NONE);
+
 	/* See change_pte_range(). */
 	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) && !pmd_write(entry) &&
 	    can_change_pmd_writable(vma, addr, entry))
@@ -2908,6 +2926,13 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 		_dst_pmd = move_soft_dirty_pmd(src_pmdval);
 		_dst_pmd = clear_uffd_wp_pmd(_dst_pmd);
 	}
+
+	/* Re-arm RWP on the moved PMD if dst_vma is RWP-registered. */
+	if (userfaultfd_rwp(dst_vma)) {
+		_dst_pmd = pmd_modify(_dst_pmd, PAGE_NONE);
+		_dst_pmd = pmd_mkuffd(_dst_pmd);
+	}
+
 	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
 
 	src_pgtable = pgtable_trans_huge_withdraw(mm, src_pmd);
@@ -3084,6 +3109,11 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 		entry = pte_mkspecial(entry);
 		if (pmd_uffd(old_pmd))
 			entry = pte_mkuffd(entry);
+
+		/* Restore PAGE_NONE so an RWP marker keeps trapping */
+		if (userfaultfd_rwp(vma) && pmd_uffd(old_pmd))
+			entry = pte_modify(entry, PAGE_NONE);
+
 		VM_BUG_ON(!pte_none(ptep_get(pte)));
 		set_pte_at(mm, addr, pte, entry);
 		pte++;
@@ -3358,6 +3388,10 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		if (uffd_wp)
 			entry = pte_mkuffd(entry);
 
+		/* Restore PAGE_NONE so an RWP marker keeps trapping */
+		if (userfaultfd_rwp(vma) && uffd_wp)
+			entry = pte_modify(entry, PAGE_NONE);
+
 		for (i = 0; i < HPAGE_PMD_NR; i++)
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 
@@ -5056,6 +5090,11 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 		pmde = pmd_mkwrite(pmde, vma);
 	if (pmd_swp_uffd(*pvmw->pmd))
 		pmde = pmd_mkuffd(pmde);
+
+	/* See do_swap_page(): restore PAGE_NONE for RWP */
+	if (pmd_swp_uffd(*pvmw->pmd) && userfaultfd_rwp(vma))
+		pmde = pmd_modify(pmde, PAGE_NONE);
+
 	if (!softleaf_is_migration_young(entry))
 		pmde = pmd_mkold(pmde);
 	/* NOTE: this may contain setting soft-dirty on some archs */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 63f6b19418b9..f2f1eb6cf66e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4859,8 +4859,12 @@ hugetlb_install_folio(struct vm_area_struct *vma, pte_t *ptep, unsigned long add
 
 	__folio_mark_uptodate(new_folio);
 	hugetlb_add_new_anon_rmap(new_folio, vma, addr);
-	if (userfaultfd_wp(vma) && huge_pte_uffd(old))
+	if (userfaultfd_protected(vma) && huge_pte_uffd(old)) {
 		newpte = huge_pte_mkuffd(newpte);
+		/* Restore PAGE_NONE so the RWP marker keeps trapping. */
+		if (userfaultfd_rwp(vma))
+			newpte = huge_pte_modify(newpte, PAGE_NONE);
+	}
 	set_huge_pte_at(vma->vm_mm, addr, ptep, newpte, sz);
 	hugetlb_count_add(pages_per_huge_page(hstate_vma(vma)), vma->vm_mm);
 	folio_set_hugetlb_migratable(new_folio);
@@ -4933,7 +4937,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 
 		softleaf = softleaf_from_pte(entry);
 		if (unlikely(softleaf_is_hwpoison(softleaf))) {
-			if (!userfaultfd_wp(dst_vma))
+			if (!userfaultfd_protected(dst_vma))
 				entry = huge_pte_clear_uffd(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 		} else if (unlikely(softleaf_is_migration(softleaf))) {
@@ -4947,11 +4951,11 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				softleaf = make_readable_migration_entry(
 							swp_offset(softleaf));
 				entry = swp_entry_to_pte(softleaf);
-				if (userfaultfd_wp(src_vma) && uffd_wp)
+				if (userfaultfd_protected(src_vma) && uffd_wp)
 					entry = pte_swp_mkuffd(entry);
 				set_huge_pte_at(src, addr, src_pte, entry, sz);
 			}
-			if (!userfaultfd_wp(dst_vma))
+			if (!userfaultfd_protected(dst_vma))
 				entry = huge_pte_clear_uffd(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 		} else if (unlikely(pte_is_marker(entry))) {
@@ -5015,6 +5019,13 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				goto next;
 			}
 
+			/* See __copy_present_ptes(): restore accessible protection. */
+			if (!userfaultfd_protected(dst_vma)) {
+				if (userfaultfd_rwp(src_vma))
+					entry = huge_pte_modify(entry, dst_vma->vm_page_prot);
+				entry = huge_pte_clear_uffd(entry);
+			}
+
 			if (cow) {
 				/*
 				 * No need to notify as we are downgrading page
@@ -5027,9 +5038,6 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				entry = huge_pte_wrprotect(entry);
 			}
 
-			if (!userfaultfd_wp(dst_vma))
-				entry = huge_pte_clear_uffd(entry);
-
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 			hugetlb_count_add(npages, dst);
 		}
@@ -5075,10 +5083,19 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
 		huge_pte_clear(mm, new_addr, dst_pte, sz);
 	} else {
 		if (need_clear_uffd_wp) {
-			if (pte_present(pte))
+			if (pte_present(pte)) {
+				/*
+				 * See __copy_present_ptes(): normalise RWP
+				 * PTEs so the destination starts accessible
+				 * instead of taking a numa-hinting fault on
+				 * first access.
+				 */
+				if (userfaultfd_rwp(vma))
+					pte = huge_pte_modify(pte, vma->vm_page_prot);
 				pte = huge_pte_clear_uffd(pte);
-			else
+			} else {
 				pte = pte_swp_clear_uffd(pte);
+			}
 		}
 		set_huge_pte_at(mm, new_addr, dst_pte, pte, sz);
 	}
@@ -6529,6 +6546,11 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 				pte = huge_pte_mkuffd(pte);
 			else if (uffd_wp_resolve || uffd_rwp_resolve)
 				pte = huge_pte_clear_uffd(pte);
+
+			/* Preserve RWP protection across mprotect() */
+			if (userfaultfd_rwp(vma) && huge_pte_uffd(pte))
+				pte = huge_pte_modify(pte, PAGE_NONE);
+
 			huge_ptep_modify_prot_commit(vma, address, ptep, old_pte, pte);
 			pages++;
 			tlb_remove_huge_tlb_entry(h, &tlb, ptep, address);
diff --git a/mm/memory.c b/mm/memory.c
index f2e7e900b1b8..ea9616e3dbaf 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -880,6 +880,10 @@ static void restore_exclusive_pte(struct vm_area_struct *vma,
 	if (pte_swp_uffd(orig_pte))
 		pte = pte_mkuffd(pte);
 
+	/* See do_swap_page(): restore PAGE_NONE for RWP */
+	if (pte_swp_uffd(orig_pte) && userfaultfd_rwp(vma))
+		pte = pte_modify(pte, PAGE_NONE);
+
 	if ((vma->vm_flags & VM_WRITE) &&
 	    can_change_pte_writable(vma, address, pte)) {
 		if (folio_test_dirty(folio))
@@ -1025,7 +1029,7 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 				   make_pte_marker(marker));
 		return 0;
 	}
-	if (!userfaultfd_wp(dst_vma))
+	if (!userfaultfd_protected(dst_vma))
 		pte = pte_swp_clear_uffd(pte);
 	set_pte_at(dst_mm, addr, dst_pte, pte);
 	return 0;
@@ -1072,9 +1076,13 @@ copy_present_page(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
 	/* All done, just insert the new page copy in the child */
 	pte = folio_mk_pte(new_folio, dst_vma->vm_page_prot);
 	pte = maybe_mkwrite(pte_mkdirty(pte), dst_vma);
-	if (userfaultfd_pte_wp(dst_vma, ptep_get(src_pte)))
-		/* Uffd-wp needs to be delivered to dest pte as well */
+	if (userfaultfd_protected(dst_vma) && pte_uffd(ptep_get(src_pte))) {
+		/* The uffd bit needs to be delivered to the dest pte as well */
 		pte = pte_mkuffd(pte);
+		/* Restore PAGE_NONE so the RWP marker keeps trapping */
+		if (userfaultfd_rwp(dst_vma))
+			pte = pte_modify(pte, PAGE_NONE);
+	}
 	set_pte_at(dst_vma->vm_mm, addr, dst_pte, pte);
 	return 0;
 }
@@ -1084,9 +1092,29 @@ static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
 		pte_t pte, unsigned long addr, int nr)
 {
 	struct mm_struct *src_mm = src_vma->vm_mm;
+	bool writable;
+
+	/*
+	 * Snapshot writability before the RWP-disarm rewrite below: when the
+	 * child is not RWP-armed, pte_modify(pte, dst_vma->vm_page_prot) can
+	 * silently drop _PAGE_RW from a resolved (no-marker) writable PTE,
+	 * so a later pte_write(pte) check would skip the COW wrprotect and
+	 * leave the parent writable over a folio shared with the child.
+	 */
+	writable = pte_write(pte);
+
+	/*
+	 * Child is not RWP-armed: restore accessible protection so the
+	 * inherited PAGE_NONE does not cost a fault on first read.
+	 */
+	if (!userfaultfd_protected(dst_vma)) {
+		if (userfaultfd_rwp(src_vma))
+			pte = pte_modify(pte, dst_vma->vm_page_prot);
+		pte = pte_clear_uffd(pte);
+	}
 
 	/* If it's a COW mapping, write protect it both processes. */
-	if (is_cow_mapping(src_vma->vm_flags) && pte_write(pte)) {
+	if (is_cow_mapping(src_vma->vm_flags) && writable) {
 		wrprotect_ptes(src_mm, addr, src_pte, nr);
 		pte = pte_wrprotect(pte);
 	}
@@ -1096,9 +1124,6 @@ static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
 		pte = pte_mkclean(pte);
 	pte = pte_mkold(pte);
 
-	if (!userfaultfd_wp(dst_vma))
-		pte = pte_clear_uffd(pte);
-
 	set_ptes(dst_vma->vm_mm, addr, dst_pte, pte, nr);
 }
 
@@ -5080,6 +5105,14 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (pte_swp_uffd(vmf->orig_pte))
 		pte = pte_mkuffd(pte);
 
+	/*
+	 * A page reclaimed while RWP-protected carries the uffd bit on
+	 * its swap entry. Re-apply PAGE_NONE on swap-in so the first access
+	 * still traps as an RWP fault. pte_modify() preserves _PAGE_UFFD.
+	 */
+	if (pte_swp_uffd(vmf->orig_pte) && userfaultfd_rwp(vma))
+		pte = pte_modify(pte, PAGE_NONE);
+
 	/*
 	 * Same logic as in do_wp_page(); however, optimize for pages that are
 	 * certainly not shared either because we just allocated them without
diff --git a/mm/migrate.c b/mm/migrate.c
index 9d81b7b881ec..633085130b7c 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -329,6 +329,10 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 	if (pte_swp_uffd(old_pte))
 		newpte = pte_mkuffd(newpte);
 
+	/* See remove_migration_pte(): restore PAGE_NONE for RWP */
+	if (pte_swp_uffd(old_pte) && userfaultfd_rwp(pvmw->vma))
+		newpte = pte_modify(newpte, PAGE_NONE);
+
 	set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
 
 	dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
@@ -394,6 +398,10 @@ static bool remove_migration_pte(struct folio *folio,
 		else if (pte_swp_uffd(old_pte))
 			pte = pte_mkuffd(pte);
 
+		/* See do_swap_page(): restore PAGE_NONE for RWP */
+		if (pte_swp_uffd(old_pte) && userfaultfd_rwp(vma))
+			pte = pte_modify(pte, PAGE_NONE);
+
 		if (folio_test_anon(folio) && !softleaf_is_migration_read(entry))
 			rmap_flags |= RMAP_EXCLUSIVE;
 
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 23e71f68cf7a..1e8679179aa2 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -298,6 +298,16 @@ static __always_inline void change_present_ptes(struct mmu_gather *tlb,
 	else if (uffd_wp_resolve || uffd_rwp_resolve)
 		ptent = pte_clear_uffd(ptent);
 
+	/*
+	 * The uffd bit on a VM_UFFD_RWP VMA carries PROT_NONE
+	 * semantics. If mprotect() or NUMA hinting changed the
+	 * base protection, restore PAGE_NONE so the PTE still
+	 * traps on any access. pte_modify() preserves
+	 * _PAGE_UFFD.
+	 */
+	if (userfaultfd_rwp(vma) && pte_uffd(ptent))
+		ptent = pte_modify(ptent, PAGE_NONE);
+
 	/*
 	 * In some writable, shared mappings, we might want
 	 * to catch actual write access -- see
diff --git a/mm/mremap.c b/mm/mremap.c
index 12732a5c547e..14e5df316f83 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -296,10 +296,19 @@ static int move_ptes(struct pagetable_move_control *pmc,
 			pte_clear(mm, new_addr, new_ptep);
 		else {
 			if (need_clear_uffd_wp) {
-				if (pte_present(pte))
+				if (pte_present(pte)) {
+					/*
+					 * See __copy_present_ptes(): normalise
+					 * RWP PTEs so the destination starts
+					 * accessible instead of taking a
+					 * numa-hinting fault on first access.
+					 */
+					if (userfaultfd_rwp(vma))
+						pte = pte_modify(pte, vma->vm_page_prot);
 					pte = pte_clear_uffd(pte);
-				else
+				} else {
 					pte = pte_swp_clear_uffd(pte);
+				}
 			}
 			set_ptes(mm, new_addr, new_ptep, pte, nr_ptes);
 		}
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9119efef7fe6..260239b260d5 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2338,6 +2338,11 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		new_pte = pte_mksoft_dirty(new_pte);
 	if (pte_swp_uffd(old_pte))
 		new_pte = pte_mkuffd(new_pte);
+
+	/* See do_swap_page(): restore PAGE_NONE for RWP */
+	if (pte_swp_uffd(old_pte) && userfaultfd_rwp(vma))
+		new_pte = pte_modify(new_pte, PAGE_NONE);
+
 setpte:
 	set_pte_at(vma->vm_mm, addr, pte, new_pte);
 	folio_put_swap(swapcache, folio_file_page(swapcache, swp_offset(entry)));
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index d546ffd2f165..d4a1d340dab3 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1200,6 +1200,13 @@ static long move_present_ptes(struct mm_struct *mm,
 		if (pte_dirty(orig_src_pte))
 			orig_dst_pte = pte_mkdirty(orig_dst_pte);
 		orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
+
+		/* Re-arm RWP on the moved PTE if dst_vma is RWP-registered. */
+		if (userfaultfd_rwp(dst_vma)) {
+			orig_dst_pte = pte_modify(orig_dst_pte, PAGE_NONE);
+			orig_dst_pte = pte_mkuffd(orig_dst_pte);
+		}
+
 		set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
 
 		src_addr += PAGE_SIZE;
@@ -1307,6 +1314,13 @@ static int move_zeropage_pte(struct mm_struct *mm,
 
 	zero_pte = pte_mkspecial(pfn_pte(zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
+
+	/* Re-arm RWP on the moved PTE if dst_vma is RWP-registered. */
+	if (userfaultfd_rwp(dst_vma)) {
+		zero_pte = pte_modify(zero_pte, PAGE_NONE);
+		zero_pte = pte_mkuffd(zero_pte);
+	}
+
 	ptep_clear_flush(src_vma, src_addr, src_pte);
 	set_pte_at(mm, dst_addr, dst_pte, zero_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
-- 
2.51.2


