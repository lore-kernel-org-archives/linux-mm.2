Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74A4DFF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE7106B0095; Mon, 27 Apr 2026 07:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBE146B00A4; Mon, 27 Apr 2026 07:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAE0A6B00A5; Mon, 27 Apr 2026 07:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BCB9A6B0095
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:46:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88C39A011F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:46:59 +0000 (UTC)
X-FDA: 84704159358.12.B159FCF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A355540005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:46:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Hff/T0kZ";
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777290417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0krAFgWuO3vxxCbEiz8zc77hTL/ZCtpxhEE+SQW208g=;
	b=ZOule1+GUCuET8V+folasAijko5RpXH+Gob8QJD5SRk5m7VElbz2KcVYTQxKBQiGWo2lIe
	qr0/rCUSQ/tDNt+CKme4nboGHs1SOl/5AznTtdM117P5bhCQ4oVBzMhZAKiDELQugbjvxm
	v3PmjJziQs7Qpc1bJrZ8zT17V8DeiiA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777290417; a=rsa-sha256;
	cv=none;
	b=JOg6cD6II9HYb+6ICBWGRqLCLlDDm1ClLuUXaTygx4DQiNvxQ1Ww6gRqDuBxJWv3MuRtlg
	y7dpzl2Gs7pSpQT6seOrurblqZqFHMSn+iAMDFMId67lxeykBJc0grir2A1tfgUO+4JZUP
	rRby8tsLKMcU7VLtZIQAfWYaTOh/g50=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Hff/T0kZ";
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A6C06014B;
	Mon, 27 Apr 2026 11:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A31C4AF09;
	Mon, 27 Apr 2026 11:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777290416;
	bh=SzqfwSiyUU02tgjSPhqUv8OOpIHzsky3BsDESvPxOA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hff/T0kZXtm8tIlNxpj+UPxLNaBhBFQ+1YnpPez8KduSnS2fAfUlsrKfyyB4XM+2S
	 idT2Z5VVHc84+BW71foGQzzcEa9QKBpOPaFR54iprXgkbNmWukB8ac55Co/T4g7VSd
	 QvBJ4kOMFWWUgXnMPVaA8eCe4LtbdpMUz8vcIombMIzrXwwMWTSwXu1IBmB8jxYtej
	 ODU2vSIMC/xGSuTgRf6YkFX5cVfu4bABfyA6UxfiR+JiEBP80P/wsoQqGj5Sl5PBhK
	 IZ8gbIAPK7xuH0Pa7nHC7p6thRibvAUKGKxomnqt5i9rPhi9wmyO2LXc2NaNxuNnmg
	 a8vyZQbN4lZ6A==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 5C89FF40069;
	Mon, 27 Apr 2026 07:46:55 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 27 Apr 2026 07:46:55 -0400
X-ME-Sender: <xms:r0zvabSZCpS3jtaQDBC55B2tZ3zrqoOwuUVTMBYQKr3oAT6t9jxsHw>
    <xme:r0zvaQtxtSY1PemHdQjGbYbCxH0hRU_3TIQS4p9ljNvgfJFZYOF1vGI4ZjmGeq8I-
    _GiOLRyprMhyvOiOku0UryRaLoSyPANlxWsreRbHF3XsfPXaOuiAg>
X-ME-Received: <xmr:r0zvaZVDsoez-8jonsM4QrXey6IrJVqKt2Hzhqjks52eQ114Cr-y-PmRiKNjZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejkeeiudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvvefufffkofgjfhgggfestdekredtre
    dttdenucfhrhhomhepfdfmihhrhihlucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceo
    khgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpefhudejfedvgeekff
    efvdekheekkeeuveeftdelheegteelgfefveevueekhfdtteenucevlhhushhtvghrufhi
    iigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmthhprg
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
X-ME-Proxy: <xmx:r0zvaUm11uT075GQ8ihnYeIWlfea1oqdabel6BVmsnLJw6QLkpGC5Q>
    <xmx:r0zvacAYX5LCJJTS3y0tk0tBoNT2zdiH-nIXmkGz9Fov_pTqiOsYGg>
    <xmx:r0zvaZ8bAxPy58a1WjjTk9Ur9tBtK4NgUUVmgGuu_zQ2bycuqib3qA>
    <xmx:r0zvaeTCqIt5rxVFwnaAX8rvCbBbNTAKYq2j-5N-Q9KE6eEPBKpGaA>
    <xmx:r0zvaf4BxtAtLUoIKWG0vB9iGHT4rapnnZNs7ILaafq_tEPKLw_vpphb>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Apr 2026 07:46:53 -0400 (EDT)
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
Subject: [PATCH 05/14] mm: add MM_CP_UFFD_RWP change_protection() flag
Date: Mon, 27 Apr 2026 12:45:53 +0100
Message-ID: <20260427114607.4068647-6-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260427114607.4068647-1-kas@kernel.org>
References: <20260427114607.4068647-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A355540005
X-Rspam-User: 
X-Stat-Signature: f43azdw5e8s64idzgj6shyaxsi6o5rym
X-HE-Tag: 1777290417-610019
X-HE-Meta: U2FsdGVkX183eUDcSTFYvt5scI3KTaBWpDFDjGeH6FlBtTeslh9MJb2eoOSKOzm8zcR5KcBGNeVve/MujESUGnGJwAhZTrakWdTYXcnJgCyreAfzMXYC/l4m5LKmMo//xbCa0vHX2V7Cr/RdJTPXGDIQqyZw+5s1XAh9Zl2XwpsHY0Dytaq9+ddFaYcRcyvLK00T73vn0fSi/QWP1EhTAhIAwX4piIxuBY1XsFITYyZ6xLhNUPqavQame3lFC9GiR/CdW+uvRPJnArcX9zIyrob6Yr+TVSa1apstYS2npbJhHy8HX9Bm41SjWR1eLCA+532Jb17/Sqe6Y52ob3PuzaGM5aHq7C58xPPrgdb6inHrjTfPhvtiyNDft3iuJiqR6z3QJrJ2BHQ3KSyjQr4OMv+aviiUSWP8mG8cMgPbtdls8C6gViGhrA/V8ZZupxuwQhppzO6YNnm5yVR/dF1/ulbe1bRUUKxfobY7pyFej4gCHQ0Ryn85T434UI3EA9ZT8ecE1wZ6uyy+f5Oxy68xHhYaouerB/fT2ps8qC09OOkCv/A2L93hdu1yvBtNxqE7MU+x9GyRkXDx6hXsg0UvOuMG1Yf/vclIni2Q75njXoUkSEmaopaOhYse8J53lja3q0OkEzwi3elkKNlSczitXKL8r6qxPRNE4D17LYO2XyGTcLOvg59LlCNTl8v5tRGUD7Sa4jnidzACuWz3ZSEMsu3AL/EZ7fyGSQekvQZYg5llNAPKY/2lu96XfaP+1Phk0GpbwsFJWc3Gbyam/PRDMhhauCYrR8F3LaUH9DOsHRXAEti8jalbctTBoYVTbLzBbSAWOcdZXREn/SNQe3KHtCNub0GfwgqwYRVxS6HQl/PjevBt+A9SwZa+6+4Xx0S8wRm7JUuT9+H54167CtQsMZ484l2RsUWrNB46Uh7fonkZTkdaR24dtk7tbzcydEDlZvnppi+HRxSdhnVomDB
 4SuSL8Oy
 CX0kK2H57KluqBsyc4EjbuuwtDOFyNNwF8xPHdg+r+bEA+tp8fPG+o+036zXO6DuiayeT69+P3i6YWuqnPS54AHHj/YK/3QLkRBTyZlNYuADRcAdZCdj0g51HRsARUv+r5W2QV22XshSsaPNL8SG0eqSFzAEKxC6VkV6y09JiPn4MScnFPPjqPYDctG3wTLn9shF2bXreKRbm5zf/TrJ0ksmOJ43Dp8kh0xpOp8QcwHtRt2D8BDXNBcZb89M8kIVri4AFmhmge2l0IqE2FHCTUKOvldI/UG5kVeokGo80llm2Bf6ypPJQLCyxRvQvxB5LshgqcpxIyWQbLmfmdv5VqD9z7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Preparatory patch. Add the change_protection() primitive that
userfaultfd RWP will use.

An RWP-protected PTE is PAGE_NONE with the uffd PTE bit set. The
PROT_NONE half makes the CPU fault on any access; the uffd bit
distinguishes an RWP fault from a plain mprotect(PROT_NONE) or NUMA
hinting fault. MM_CP_UFFD_WP and MM_CP_UFFD_RWP share the same PTE
bit, so the two cannot be used together on the same range.

Two new change_protection() flags:

  MM_CP_UFFD_RWP            install PAGE_NONE and set the uffd bit
  MM_CP_UFFD_RWP_RESOLVE    restore vma->vm_page_prot, clear the uffd bit

Both are wired through change_pte_range(), change_huge_pmd(), and
hugetlb_change_protection() so anon, shmem, THP, and hugetlb all
share the same semantics.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/mm.h            |  5 +++++
 include/linux/userfaultfd_k.h |  1 -
 mm/huge_memory.c              | 20 ++++++++++++------
 mm/hugetlb.c                  | 25 ++++++++++++++++------
 mm/mprotect.c                 | 40 +++++++++++++++++++++++++++++------
 5 files changed, 71 insertions(+), 20 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3f53d1e978c0..2b65416bb760 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3291,6 +3291,11 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
 #define  MM_CP_UFFD_WP_RESOLVE             (1UL << 3) /* Resolve wp */
 #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
 					    MM_CP_UFFD_WP_RESOLVE)
+/* Whether this change is for uffd RWP */
+#define  MM_CP_UFFD_RWP                    (1UL << 4) /* do rwp */
+#define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* Resolve rwp */
+#define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
+					    MM_CP_UFFD_RWP_RESOLVE)
 
 bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index fcf308dba311..3725e61a7041 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -397,7 +397,6 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
 	return false;
 }
 
-
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
 	return false;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d88fcccd386d..2537dca63c6c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2665,6 +2665,8 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	spinlock_t *ptl;
 	pmd_t oldpmd, entry;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
+	bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
+	bool uffd_rwp_resolve = cp_flags & MM_CP_UFFD_RWP_RESOLVE;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
 	int ret = 1;
@@ -2679,11 +2681,18 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		return 0;
 
 	if (thp_migration_supported() && pmd_is_valid_softleaf(*pmd)) {
-		change_non_present_huge_pmd(mm, addr, pmd, uffd_wp,
-					    uffd_wp_resolve);
+		change_non_present_huge_pmd(mm, addr, pmd,
+					    uffd_wp || uffd_rwp,
+					    uffd_wp_resolve || uffd_rwp_resolve);
 		goto unlock;
 	}
 
+	/* Already in the desired state */
+	if (prot_numa && pmd_protnone(*pmd))
+		goto unlock;
+	if (uffd_rwp && pmd_protnone(*pmd) && pmd_uffd(*pmd))
+		goto unlock;
+
 	if (prot_numa) {
 
 		/*
@@ -2694,9 +2703,6 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (is_huge_zero_pmd(*pmd))
 			goto unlock;
 
-		if (pmd_protnone(*pmd))
-			goto unlock;
-
 		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma,
 					     vma_is_single_threaded_private(vma)))
 			goto unlock;
@@ -2725,9 +2731,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	oldpmd = pmdp_invalidate_ad(vma, addr, pmd);
 
 	entry = pmd_modify(oldpmd, newprot);
-	if (uffd_wp)
+	if (uffd_wp || uffd_rwp)
 		entry = pmd_mkuffd(entry);
-	else if (uffd_wp_resolve)
+	else if (uffd_wp_resolve || uffd_rwp_resolve)
 		/*
 		 * Leave the write bit to be handled by PF interrupt
 		 * handler, then things like COW could be properly
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 61cda9992043..63f6b19418b9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6409,6 +6409,8 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 	unsigned long last_addr_mask;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
+	bool uffd_rwp_resolve = cp_flags & MM_CP_UFFD_RWP_RESOLVE;
 	struct mmu_gather tlb;
 
 	/*
@@ -6434,6 +6436,11 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 
 		ptep = hugetlb_walk(vma, address, psize);
 		if (!ptep) {
+			/*
+			 * uffd_wp installs a pte marker on the unpopulated
+			 * entry; RWP does not install markers so the
+			 * allocation is unnecessary for it.
+			 */
 			if (!uffd_wp) {
 				address |= last_addr_mask;
 				continue;
@@ -6455,7 +6462,8 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 			 * shouldn't happen at all.  Warn about it if it
 			 * happened due to some reason.
 			 */
-			WARN_ON_ONCE(uffd_wp || uffd_wp_resolve);
+			WARN_ON_ONCE(uffd_wp || uffd_wp_resolve ||
+				     uffd_rwp || uffd_rwp_resolve);
 			pages++;
 			spin_unlock(ptl);
 			address |= last_addr_mask;
@@ -6489,9 +6497,9 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 				pages++;
 			}
 
-			if (uffd_wp)
+			if (uffd_wp || uffd_rwp)
 				newpte = pte_swp_mkuffd(newpte);
-			else if (uffd_wp_resolve)
+			else if (uffd_wp_resolve || uffd_rwp_resolve)
 				newpte = pte_swp_clear_uffd(newpte);
 			if (!pte_same(pte, newpte))
 				set_huge_pte_at(mm, address, ptep, newpte, psize);
@@ -6502,19 +6510,24 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 			 * pte_marker_uffd_wp()==true implies !poison
 			 * because they're mutual exclusive.
 			 */
-			if (pte_is_uffd_wp_marker(pte) && uffd_wp_resolve)
+			if (pte_is_uffd_wp_marker(pte) &&
+			    (uffd_wp_resolve || uffd_rwp_resolve))
 				/* Safe to modify directly (non-present->none). */
 				huge_pte_clear(mm, address, ptep, psize);
 		} else {
 			pte_t old_pte;
 			unsigned int shift = huge_page_shift(hstate_vma(vma));
 
+			/* Already protnone with uffd bit set? Nothing to do. */
+			if (uffd_rwp && pte_protnone(pte) && huge_pte_uffd(pte))
+				goto next;
+
 			old_pte = huge_ptep_modify_prot_start(vma, address, ptep);
 			pte = huge_pte_modify(old_pte, newprot);
 			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
-			if (uffd_wp)
+			if (uffd_wp || uffd_rwp)
 				pte = huge_pte_mkuffd(pte);
-			else if (uffd_wp_resolve)
+			else if (uffd_wp_resolve || uffd_rwp_resolve)
 				pte = huge_pte_clear_uffd(pte);
 			huge_ptep_modify_prot_commit(vma, address, ptep, old_pte, pte);
 			pages++;
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 8340c8b228c6..23e71f68cf7a 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -216,6 +216,8 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
 {
 	const bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	const bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	const bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
+	const bool uffd_rwp_resolve = cp_flags & MM_CP_UFFD_RWP_RESOLVE;
 	softleaf_t entry = softleaf_from_pte(oldpte);
 	pte_t newpte;
 
@@ -256,7 +258,7 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
 		 * to unprotect it, drop it; the next page
 		 * fault will trigger without uffd trapping.
 		 */
-		if (uffd_wp_resolve) {
+		if (uffd_wp_resolve || uffd_rwp_resolve) {
 			pte_clear(vma->vm_mm, addr, pte);
 			return 1;
 		}
@@ -265,9 +267,9 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
 		newpte = oldpte;
 	}
 
-	if (uffd_wp)
+	if (uffd_wp || uffd_rwp)
 		newpte = pte_swp_mkuffd(newpte);
-	else if (uffd_wp_resolve)
+	else if (uffd_wp_resolve || uffd_rwp_resolve)
 		newpte = pte_swp_clear_uffd(newpte);
 
 	if (!pte_same(oldpte, newpte)) {
@@ -284,14 +286,16 @@ static __always_inline void change_present_ptes(struct mmu_gather *tlb,
 {
 	const bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
 	const bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
+	const bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
+	const bool uffd_rwp_resolve = cp_flags & MM_CP_UFFD_RWP_RESOLVE;
 	pte_t ptent, oldpte;
 
 	oldpte = modify_prot_start_ptes(vma, addr, ptep, nr_ptes);
 	ptent = pte_modify(oldpte, newprot);
 
-	if (uffd_wp)
+	if (uffd_wp || uffd_rwp)
 		ptent = pte_mkuffd(ptent);
-	else if (uffd_wp_resolve)
+	else if (uffd_wp_resolve || uffd_rwp_resolve)
 		ptent = pte_clear_uffd(ptent);
 
 	/*
@@ -325,6 +329,7 @@ static long change_pte_range(struct mmu_gather *tlb,
 	long pages = 0;
 	bool is_private_single_threaded;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
+	bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	int nr_ptes;
 
@@ -350,6 +355,14 @@ static long change_pte_range(struct mmu_gather *tlb,
 			/* Already in the desired state. */
 			if (prot_numa && pte_protnone(oldpte))
 				continue;
+			/*
+			 * RWP-protected PTEs carry _PAGE_UFFD as a marker on
+			 * top of PROT_NONE. Skip only entries already in that
+			 * exact state; plain PROT_NONE from mprotect() still needs
+			 * to be promoted so future faults can be distinguished.
+			 */
+			if (uffd_rwp && pte_protnone(oldpte) && pte_uffd(oldpte))
+				continue;
 
 			page = vm_normal_page(vma, addr, oldpte);
 			if (page)
@@ -358,6 +371,8 @@ static long change_pte_range(struct mmu_gather *tlb,
 			/*
 			 * Avoid trapping faults against the zero or KSM
 			 * pages. See similar comment in change_huge_pmd.
+			 * Skip this filter for uffd RWP which
+			 * must set protnone regardless of NUMA placement.
 			 */
 			if (prot_numa &&
 			    !folio_can_map_prot_numa(folio, vma,
@@ -667,7 +682,16 @@ long change_protection(struct mmu_gather *tlb,
 	pgprot_t newprot = vma->vm_page_prot;
 	long pages;
 
-	BUG_ON((cp_flags & MM_CP_UFFD_WP_ALL) == MM_CP_UFFD_WP_ALL);
+	/*
+	 * MM_CP_UFFD_{WP,RWP} and _RESOLVE are mutually exclusive within one
+	 * change, and WP and RWP cannot mix. Miswired callers get a warn and
+	 * a no-op; userspace cannot reach this state.
+	 */
+	if (WARN_ON_ONCE((cp_flags & MM_CP_UFFD_WP_ALL) == MM_CP_UFFD_WP_ALL ||
+			 (cp_flags & MM_CP_UFFD_RWP_ALL) == MM_CP_UFFD_RWP_ALL ||
+			 ((cp_flags & MM_CP_UFFD_WP_ALL) &&
+			  (cp_flags & MM_CP_UFFD_RWP_ALL))))
+		return 0;
 
 #ifdef CONFIG_NUMA_BALANCING
 	/*
@@ -681,6 +705,10 @@ long change_protection(struct mmu_gather *tlb,
 	WARN_ON_ONCE(cp_flags & MM_CP_PROT_NUMA);
 #endif
 
+	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE) &&
+	    (cp_flags & MM_CP_UFFD_RWP))
+		newprot = PAGE_NONE;
+
 	if (is_vm_hugetlb_page(vma))
 		pages = hugetlb_change_protection(vma, start, end, newprot,
 						  cp_flags);
-- 
2.51.2


