Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A543ACA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:56:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 844BC6B00AD; Fri,  2 Oct 2026 05:56:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 780876B00AF; Fri,  2 Oct 2026 05:56:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66ED16B00B0; Fri,  2 Oct 2026 05:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35E236B00AD
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:56:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BBC8F1A066F
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:44 +0000 (UTC)
X-FDA: 85277231928.05.6FC69AF
Received: from mta0.migadu.com (out-89.mta0.migadu.com [91.218.175.89])
	by imf05.hostedemail.com (Postfix) with ESMTP id BD369100007
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jCXg38uj;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.89 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vvotwsl5nW+4qYrroTrS8SUF5W149xl5gjj3tToh+/c=;
	b=od+y4NY80blRiAKZbeYxzghwNmtWybpPXBZ+5qxqRMxD0Vhd/kgxi4sUnS+anvi4GnR/7o
	jYMXCdi3sg+pLdgOP8P2j6vFP7zjL/D4GwUvtqThIkNKL5n8Znfrq2JTZ3Zl7mtl8k7RDD
	bPqV8+YL/42VPD1yUnQqBILDn8FTrj4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jCXg38uj;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.89 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935003;
	b=eTjj6xB27pBDwwCmFlcp17i4L7IR+YW0zN0cn3yd1NosPXupWxibx6n9SpQ4VzWQ2iYixh
	jRCti/RTYBRhZX0QllsmQkdlF/3WYx9Ef8TITWeh9CtrEOzBQgeK7TsieXr3+OZAg6YN83
	rJ9bV/hfr0kxTUaCLgGR/5HUbr0Gbsk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EMYauajS0/Wg0tgt9O+VKGttuIkXp1Z6Wvo4EvxsiGE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790935001; v=1; x=1791539801;
 b=jCXg38ujApDggsAPnuJVVZbDxBdRxTsF0NI8jUPvaImlNuq0frddFX1S1m8Ahe/ulWQI+FgY
 EaphJik2QrGnYhDzqC2RZSOe2wyNwLey5/zFqw10/wFxWl2tqtX90pvWGdaYURkuTFRJ8UfmtrE
 J4nS3SUf7hPww6eyXtFT5Vns=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 1f41b4e95de95ad8;
	Fri, 02 Oct 2026 09:56:41 +0000
X-Mizu-Trace-ID: 1f41b4e95de95ad8
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v8 13/30] mm: handle PMD swap entries in fork path
Date: Fri,  2 Oct 2026 02:52:27 -0700
Message-ID: <20261002095503.3585565-14-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BD369100007
X-Stat-Signature: pbfurwuywcnxqrmbpftkj7w4s47w1w83
X-Rspam-User: 
X-HE-Tag: 1790935002-96010
X-HE-Meta: U2FsdGVkX19rEYceFE3NZy7lrAQ6hc0OUMIp49PgooVaeC9XUcvDKTTBO+fKNZ6vQUSQQJFOmX2zFC42OfLaRVo4MMH7yOmm0oAeGEx9tAUJbvLpfZc2P1Vm3XiFXLot9MeDbYC6j8BrbAsBB2jzabcqnHhEmI57ceLi6hIegawhA98KdyKiD6kxFlo0HDGbHfoTW73IxCN5oayTSjTKP8+uNm1Qg7TqzsUm5dW+QKennpHVm0fL8RM/NvdYi8OSD3BrincABh2693QMlJ5sGhP42qUNEDVgcd1HVj1evBVpFYJgDYLKm9ksBZyVxQv4fBaQNVjEkVCQGjkb9WZ5JikEX9Kn5KbmUrqsgv5ltK0rqY6SgrGkJFAE0796WV0MSWyTDPEIh5FDZV6wdgyS846d/lycR12EDXmOQF+gRhV/dN1nqt6pCQJAm6DLNMLmipbUCbHq0plHObnRt+kknRvMwabDMGu7ZVdZPorb/ZtXMudKm67aUQodUjJ1/uzxgu070bpKPeOe6bwU/3oN9V7tYeX/Bg7IxIACpyjX0uQMIyCL5bGV4PDZ2Xb0Ej4sz4fnwNXFoxXUEsgvsCMNBugUKGv7jAbDWteZxOx32C2p8Bp8lUvywRngs2JIWFgWkcIomDEU1ATK3SwxxpQUcithX2q0Z0EhnnAWtp/ZIAgUMvdV+L7YASfU6LtjDcnBr22UXR8HgfcUyddvo7uEKzvOkFJBzGuX/ZlA3QKHFmR0AzPbx+DFceUp/mrwRzGMwmIDOBZ75bKz+zuLuxmp5rD9ngVGgJNnn0KkXsqieTieD2xHDl7E9i3WkpA4XJt/sW4k35SiCzcp63wFid2AxuLssQYbMuCdgjzxfwNVnwB/FIv4NViCYsL2lVO6BQ/Oequ8hIHrGnu4cGPX9Tqcj1rkVl2TuSN4odGd3uPFw0O7YJoegSsbdb1fgNkCuJTMeoOzpE1q077WN8xrMi/
 crUAfTIl
 wnV3jEW3gfkKYH6B/oGjaiV5TkOpLVg2SO7PjHCW/wlqZpwRFPpfAhfI9f2S7OoR87UZV+AwT43XIYs21A2z10GBc5XYUQlMdPkqVIGXvP8d4HqxopV6HUT2RTdKtaVgzBaItpvrEzrplG/4hur9Hfp8UDkng4TtR8GU2USp4TyJh57T0FjrBC8a9PXaDxcB3F7d4vbVqX0FNivE4L6CJElOGq9AwJki6pP5rRagPoEg5PDQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

copy_huge_pmd() only knows about migration and device-private PMDs, so a
PMD swap entry would fall through to the present-PMD path and fork() would
duplicate it without taking a reference on the slots it points at.

Copy it the way copy_nonpresent_pte() copies a PTE swap entry: duplicate
the swap references, clear the exclusive marker on the source, put the
destination mm on mmlist, and account the child's slots to MM_SWAPENTS.

The GFP_ATOMIC extend-table allocation inside the dup can fail. Report that
as -EIO and let copy_pmd_range() retry with GFP_KERNEL, as
copy_nonpresent_pte() and copy_pte_range() already do for a PTE swap entry.
copy_huge_pmd() hands the entry back so the caller knows which range to
allocate for.

Only -ENOMEM is reported that way. The other failures mean the entry itself
is bad, and swap_retry_table_alloc_nr() returns 0 for those, so collapsing
them into -EIO as the PTE path does would spin in the caller's retry rather
than failing the fork.

While here, move the mm counter update into each entry-type arm, as the PTE
version does, so the swap arm can account MM_SWAPENTS instead of
MM_ANONPAGES.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/huge_mm.h |  3 +-
 mm/huge_memory.c        | 62 ++++++++++++++++++++++++++++++-----------
 mm/memory.c             | 12 +++++++-
 3 files changed, 58 insertions(+), 19 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 8205e83f27771..7aa63d982af07 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -10,7 +10,8 @@
 vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf);
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
-		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
+		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+		  softleaf_t *entryp);
 bool huge_pmd_set_accessed(struct vm_fault *vmf);
 int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 24d116ae1fc30..80d18ca972ecf 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1894,7 +1894,7 @@ bool touch_pmd(struct vm_area_struct *vma, unsigned long addr,
 	return false;
 }
 
-static void copy_huge_non_present_pmd(
+static int copy_huge_non_present_pmd(
 		struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 		struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
@@ -1902,18 +1902,41 @@ static void copy_huge_non_present_pmd(
 {
 	softleaf_t entry = softleaf_from_pmd(pmd);
 	struct folio *src_folio;
+	int err;
 
 	VM_WARN_ON_ONCE(!pmd_is_valid_softleaf(pmd));
 
-	if (softleaf_is_migration_write(entry) ||
-	    softleaf_is_migration_read_exclusive(entry)) {
-		entry = make_readable_migration_entry(swp_offset(entry));
-		pmd = softleaf_to_pmd(entry);
-		if (pmd_swp_soft_dirty(*src_pmd))
-			pmd = pmd_swp_mksoft_dirty(pmd);
-		if (pmd_swp_uffd(*src_pmd))
-			pmd = pmd_swp_mkuffd(pmd);
-		set_pmd_at(src_mm, addr, src_pmd, pmd);
+	if (softleaf_is_swap(entry)) {
+		/*
+		 * A PMD swap entry only exists under CONFIG_THP_SWAP, where
+		 * SWAPFILE_CLUSTER == HPAGE_PMD_NR, and it is cluster aligned,
+		 * so these HPAGE_PMD_NR slots are exactly one cluster - which
+		 * is what swap_dup_entries_direct() requires.
+		 */
+		err = swap_dup_entries_direct(entry, HPAGE_PMD_NR);
+		if (err)
+			/* Only -ENOMEM is worth a GFP_KERNEL retry. */
+			return err == -ENOMEM ? -EIO : -ENOMEM;
+
+		mm_prepare_for_swap_entries(dst_mm);
+		/* Mark the swap entry as shared. */
+		if (pmd_swp_exclusive(pmd)) {
+			pmd = pmd_swp_clear_exclusive(pmd);
+			set_pmd_at(src_mm, addr, src_pmd, pmd);
+		}
+		add_mm_counter(dst_mm, MM_SWAPENTS, HPAGE_PMD_NR);
+	} else if (softleaf_is_migration(entry)) {
+		if (softleaf_is_migration_write(entry) ||
+		    softleaf_is_migration_read_exclusive(entry)) {
+			entry = make_readable_migration_entry(swp_offset(entry));
+			pmd = softleaf_to_pmd(entry);
+			if (pmd_swp_soft_dirty(*src_pmd))
+				pmd = pmd_swp_mksoft_dirty(pmd);
+			if (pmd_swp_uffd(*src_pmd))
+				pmd = pmd_swp_mkuffd(pmd);
+			set_pmd_at(src_mm, addr, src_pmd, pmd);
+		}
+		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	} else if (softleaf_is_device_private(entry)) {
 		/*
 		 * For device private entries, since there are no
@@ -1940,19 +1963,21 @@ static void copy_huge_non_present_pmd(
 		 */
 		folio_try_dup_anon_rmap_pmd(src_folio, &src_folio->page,
 					    dst_vma, src_vma);
+		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	}
 
-	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
 	if (!userfaultfd_protected(dst_vma))
 		pmd = pmd_swp_clear_uffd(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
+	return 0;
 }
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
-		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
+		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+		  softleaf_t *entryp)
 {
 	spinlock_t *dst_ptl, *src_ptl;
 	struct page *src_page;
@@ -1995,11 +2020,14 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	ret = -EAGAIN;
 	pmd = *src_pmd;
 
-	if (unlikely(thp_migration_supported() &&
-		     pmd_is_valid_softleaf(pmd))) {
-		copy_huge_non_present_pmd(dst_mm, src_mm, dst_pmd, src_pmd, addr,
-					  dst_vma, src_vma, pmd, pgtable);
-		ret = 0;
+	if (unlikely(pmd_is_valid_softleaf(pmd))) {
+		ret = copy_huge_non_present_pmd(dst_mm, src_mm, dst_pmd, src_pmd,
+						addr, dst_vma, src_vma, pmd,
+						pgtable);
+		if (ret) {
+			*entryp = softleaf_from_pmd(pmd);
+			pte_free(dst_mm, pgtable);
+		}
 		goto out_unlock;
 	}
 
diff --git a/mm/memory.c b/mm/memory.c
index 477d7e359b447..c0ad446d0cea4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1437,11 +1437,21 @@ copy_pmd_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 	do {
 		next = pmd_addr_end(addr, end);
 		if (pmd_is_huge(*src_pmd)) {
+			softleaf_t entry = softleaf_mk_none();
 			int err;
 
 			VM_BUG_ON_VMA(next-addr != HPAGE_PMD_SIZE, src_vma);
+again:
 			err = copy_huge_pmd(dst_mm, src_mm, dst_pmd, src_pmd,
-					    addr, dst_vma, src_vma);
+					    addr, dst_vma, src_vma, &entry);
+			if (err == -EIO) {
+				VM_WARN_ON_ONCE(!entry.val);
+				if (swap_retry_table_alloc_nr(entry,
+							      HPAGE_PMD_NR,
+							      GFP_KERNEL) < 0)
+					return -ENOMEM;
+				goto again;
+			}
 			if (err == -ENOMEM)
 				return -ENOMEM;
 			if (!err)
-- 
2.53.0-Meta


