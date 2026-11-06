Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95C65606A330
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 23:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n2bUN91Q
Received: by kanga.kvack.org (Postfix)
	id A135F6B05B4; Fri,  6 Nov 2026 18:51:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EB1B6B05B5; Fri,  6 Nov 2026 18:51:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909686B05B6; Fri,  6 Nov 2026 18:51:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 622726B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:51:40 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5C01C0128
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:51:39 +0000 (UTC)
X-FDA: 85406343918.14.813F644
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0904F40002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:51:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n2bUN91Q;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794009098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lfHkyy9F0GN/3hlkFeSrQiqR30IMzmcD3m/nAdVEVYo=;
	b=bem8vikHM+kjOYMMI3zYXqxaxpuS4tcGiyBa5IkHi0e0YYV9v+XJviYj+sbxYGdAUWG7nt
	KjoDykMhVtIp5hZfS8xRKeFrIxXeaQl32/bGk/b42SmFJDM7wEwgY+nw+KtW8lnZSNnnuW
	VRLxo7gj/REjcIRhd0I2+/TiSt0Pfvw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794009098;
	b=QV3WVH8fcJOtkzvA2lwy4w2KOv/lrmqJtW97LAFx+yTGl2qS1LUFopCyBxRsl/PoT1OdWy
	MayLlxz5aXmyNun1z+zr5v6P+WEoKLHOKmhfy2Ok6E35rwY3bPa7kZH9n8Ye1W+q2CBo6A
	cK1c9R1Vy4g1GaHvj81CjAGT6CVLM/s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n2bUN91Q;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5152940DE9;
	Fri,  6 Nov 2026 23:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D2C1F008A2;
	Fri,  6 Nov 2026 23:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794009097;
	bh=lfHkyy9F0GN/3hlkFeSrQiqR30IMzmcD3m/nAdVEVYo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=n2bUN91QYL5hhj1DTmnS8jzjWtwSLhUihk3RAJa64EoL5JgttMem1Pj0ZjstoIbbM
	 2Bzby0qdkERcMPcX1r+7egf+b4XQ4DgBARNmV/S/+W1jQ6ki1+01e3qXE13QuTOeKN
	 V1nNA4t0+0ZoPppyqkcb9IKd67ck0pifGttaprR3Nkbh5nkSanQp0s4UGdjL0IEiCh
	 Ml3xz3BBUGUMEnCHK1piAuXfdtMSxy7Omso5MCb7pTUu7p+mJOPgFW2aFZ0zpf2ndP
	 qBYnl71jg4YVL/9B90WfikpLPax7R374AvP+hR6Y5r7JxVpEasmlZaTKZQodLKJOWd
	 EDRdnmhNPFWVQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 07 Nov 2026 00:51:06 +0100
Subject: [PATCH 2/2] mm/khugepaged: check for empty PTE tables before
 retracting
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261107-b4-uffd_marker_loss-v1-2-82926b22704c@kernel.org>
References: <20261107-b4-uffd_marker_loss-v1-0-82926b22704c@kernel.org>
In-Reply-To: <20261107-b4-uffd_marker_loss-v1-0-82926b22704c@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Peter Xu <peterx@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-mm@kvack.org, 
 linux-trace-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7308; i=david@kernel.org;
 h=from:subject:message-id; bh=34SRpvzvO0Nshm7TUytyAhxQ4DZ5vKoV8iMQD9fw14g=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLepb9dk6Fe9D/PbQKT2/pqD++WFb+iS7KSb7He4/jBx
 F2ec+51RykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABMJXcfwv84jztwnKp3/84LA
 1Y/i+JRX3V/9IHRep+emhIbNf1Rm/GD4Z/7w1PKfD7ueP2Li/K3+pfzqpcpUzvUPTloy6e9okX8
 5hwkA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0904F40002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 139t7p435f8wg5a5ypdqtmtxdungw36n
X-Rspam-User: 
X-HE-Tag: 1794009097-262431
X-HE-Meta: U2FsdGVkX1+RmF7TzUFazEntSyeSZEVGsGJBqe3/mW3efnKEmVvflCApH6bW0tG5pSlkiGqcWbhpHFwvQHGnfpICAXmV2e/4eD7d85j3Npo5kp0Gjq1tZrJuh+3PUJ8nIAmFBI5sJi1dTGNJicBihiz+AYg2T7phqEP/nWVotzkQwYAr5JCDL2ddnB4Vpxgu78AHbSnvrfXgkByrd6Pw69WTWOw1QuAnwtQU6to3CbB+R8P/6Z9M/O4ZRR2Pk+5xsKB1uDX/4pWyw2xxrWV7JVPp8mUoPfqurYwwApzsBZURzETzserwFgi2qcqSFcwbiOuw9UqaPc6f7ovTbrGv2kx6adkxxQGEwtbCzy28Mi+tX2bwUZUI7w3xfRvS98p+/q1F/xS1f+XduywhvuJe9W5hpvLkzTwrxX+E5eeYGPsN/VucYVsT7WIeR4l3lMnmBQSd4twGCopDzA2hhtiBf775oRcxL+EFstobXpPmewgjfutP+qYcfq8jI2amWQ5zl/40C7BXEF47lo6CtQP8ZX1k1j5RcbSLGeOkZQwK1ZJDok4ydPAwMHXSxyWh35o4NQ/sZBVBBqbD8eDKqAbxmvqRr8q1VZnpjbHoyH+UAER8O8WhtbymSqRKkETw0Lb0+0J99Zb5B40MQUHVqePBY7uB1CTv7xocD1B6yL4pZ2wWAUC30ZypO+bqaGf9GDYfHq2V1FqAQAi6OC5akDy/rAXj2CEFoyjNuP1GV7XXYkUWWTcReAoagQc0rDQgRxP8uA9nBIIfu2cw67AbwqGU8XM9haw00PoFg8hHQobiO4DxXcAgDxzCAniB/xl9Di9d8MZbxu9mmFaDdpt/161BIEubtX4nOn0VqAN4/wKhS3zu+wlsQ+YhdboAxkAR3I48Q2vkyjMNmKtJMAQbKu9shH26J5dAle+/PGcWTrMDg9WM9qSW2fChMpZCkrQaP04O9X8Ogrkd3dfaqD8ZyL/
 f7u8Elen
 ErQ6lBg/92+G0reIu8wuWroxSF86/Y8MKxNww7tzGSZDMowtTIqD3Pd5WHuYo2jbrDp1rfmoB19xpPiWLEhmx4eEWizdCBQXqgeWxdgaYzHtYMrQ9vihTHjUhY3wwiYUv7cKtXQnsf+/X+n5abRvX3ETPknQs9V/xT2xY2aJZhwwVzLdMu1nZUCNSNFK7dwgtfOkiveXyq3puYe5s6oCx6c3psrEd1N0DgbN450NFGZaW0syiKyl5461kTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

retract_page_tables() uses elaborate (error-prone) logic to avoid scanning
whether a page table is empty.

Let's prevent more future bugs and reduce the complexity by doing it
just like try_collapse_pte_mapped_thp(): scan if the page table is
empty. Keep the check for anon_vma in place.

Scan under the PTE lock only and try to grab the PMD lock afterwards.
If that fails, drop the PTE lock, take both locks in the right order
and check again. This avoids holding the PMD lock during the scan in
the common case.

This will now retract in more cases where the VMA flags were an
over-indication, with the cost of scanning more frequently under lock.

We could scan lockless first, but it doesn't really seem worth it for
now. If this ever becomes a problem, we could do that, or alternatively
refuse again more of the VMA flags early.

The structure of the retraction code is now similar to
try_collapse_pte_mapped_thp(), with some slight differences (e.g.,
initial empty scan) that make this harder to generalize. But likely we
should look in the future into merging more of that code.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/khugepaged.c | 127 ++++++++++++++++++++------------------------------------
 1 file changed, 45 insertions(+), 82 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2a5ee8fc42335..f39ea3d076554 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1884,8 +1884,9 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 		return SCAN_VMA_CHECK;
 
 	/*
-	 * Keep pmd pgtable while the uffd bit is in use; see comment in
-	 * retract_page_tables().
+	 * Keep the PTE table for uffd-wp and RWP registrations: it may
+	 * contain per-PTE protection state that cannot be reconstructed
+	 * from the page cache.
 	 */
 	if (userfaultfd_protected(vma))
 		return SCAN_PTE_UFFD;
@@ -2081,48 +2082,6 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	try_collapse_pte_mapped_thp(mm, addr, install_pmd);
 }
 
-/* Can we retract page tables for this file-backed VMA? */
-static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
-{
-	/*
-	 * Check vma->anon_vma to exclude MAP_PRIVATE mappings that
-	 * got written to. These VMAs are likely not worth removing
-	 * page tables from, as PMD-mapping is likely to be split later.
-	 *
-	 * Can't use vma_has_anon_rmap() here as the VMA may be stabilised
-	 * by the file rmap lock.
-	 */
-	if (READ_ONCE(vma->anon_vma))
-		return false;
-
-	/*
-	 * When a vma is registered with uffd-wp or RWP, we cannot recycle
-	 * the page table because there may be pte markers installed.
-	 * VM_UFFD_RWP ranges similarly rely on per-PTE uffd state
-	 * and cannot be recycled to a shared PMD. Other vmas can still
-	 * have the same file mapped hugely, but skip this one: it will
-	 * always be mapped in small page size for these registrations.
-	 */
-	if (userfaultfd_protected(vma))
-		return false;
-
-	/*
-	 * Preserve guard and poison markers when retracting page tables.
-	 *
-	 * These flags are set atomically on marker installation under mmap/VMA
-	 * read lock, and here we may not hold any VMA or mmap lock at all.
-	 *
-	 * This is therefore serialised on the PTE page table lock, which is
-	 * obtained on marker installation after the flag is set, so this
-	 * check being performed under this lock excludes races.
-	 */
-	if (vma_test_atomic_flag(vma, VMA_MAYBE_GUARD_BIT) ||
-	    vma_test_atomic_flag(vma, VMA_MAYBE_UFFD_POISON_BIT))
-		return false;
-
-	return true;
-}
-
 static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 {
 	struct vm_area_struct *vma;
@@ -2133,10 +2092,18 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		struct mm_struct *mm;
 		unsigned long addr;
 		pmd_t *pmd, pgt_pmd;
-		spinlock_t *pml;
-		spinlock_t *ptl;
+		pte_t *pte;
+		spinlock_t *pml = NULL, *ptl;
 		bool success = false;
 
+		/*
+		 * Skip private mappings that have been written to: we'll likely
+		 * split them as soon as we CoW later. Use READ_ONCE() because
+		 * we are neither holding the VMA lock nor the mmap_lock.
+		 */
+		if (READ_ONCE(vma->anon_vma))
+			continue;
+
 		addr = vma->vm_start +
 			((pgoff - vma_start_pgoff(vma)) << PAGE_SHIFT);
 		if (addr & ~HPAGE_PMD_MASK ||
@@ -2150,52 +2117,48 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		if (collapse_test_exit(mm))
 			continue;
 
-		if (!file_backed_vma_is_retractable(vma))
-			continue;
-
 		/* PTEs were notified when unmapped; but now for the PMD? */
 		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
 					addr, addr + HPAGE_PMD_SIZE);
 		mmu_notifier_invalidate_range_start(&range);
 
-		pml = pmd_lock(mm, pmd);
-		/*
-		 * The lock of new_folio is still held, we will be blocked in
-		 * the page fault path, which prevents the pte entries from
-		 * being set again. So even though the old empty PTE page may be
-		 * concurrently freed and a new PTE page is filled into the pmd
-		 * entry, it is still empty and can be removed.
-		 *
-		 * So here we only need to recheck if the state of pmd entry
-		 * still meets our requirements, rather than checking pmd_same()
-		 * like elsewhere.
-		 */
-		if (check_pmd_state(pmd) != SCAN_SUCCEED)
-			goto drop_pml;
-		ptl = pte_lockptr(mm, pmd);
-		if (ptl != pml)
-			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
+		pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+		if (!pte)
+			goto unlock;
 
 		/*
-		 * Huge page lock is still held, so normally the page table must
-		 * remain empty; and we have already skipped vmas with an anon
-		 * rmap and userfaultfd_wp() vmas.  But since the mmap_lock is not
-		 * held, it is still possible for a racing userfaultfd_ioctl() or
-		 * madvise() to have inserted ptes or markers.  Now that we hold
-		 * ptlock, repeating the retractable checks protects us from
-		 * races against the prior checks.
+		 * The folio lock prevents file faults from modifying the
+		 * page table, but other things (userfaultfd, CoW, guard
+		 * markers) could have modified the page table until we lock it
+		 * and check.
 		 */
-		if (likely(file_backed_vma_is_retractable(vma))) {
-			pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
-			pmdp_get_lockless_sync();
-			success = true;
-		}
+		if (!pte_table_empty(pte))
+			goto unlock;
 
-		if (ptl != pml)
-			spin_unlock(ptl);
-drop_pml:
-		spin_unlock(pml);
+		pml = pmd_lockptr(mm, pmd);
+		if (ptl != pml && !spin_trylock(pml)) {
+			pte_unmap_unlock(pte, ptl);
+			ptl = NULL;
+
+			pml = pmd_lock(mm, pmd);
+			pte = pte_offset_map_rw_nolock(mm, pmd, addr, &pgt_pmd, &ptl);
+			if (!pte)
+				goto unlock;
+			if (ptl != pml)
+				spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
 
+			if (!pte_table_empty(pte))
+				goto unlock;
+		}
+
+		pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
+		pmdp_get_lockless_sync();
+		success = true;
+unlock:
+		if (pte)
+			pte_unmap_unlock(pte, ptl);
+		if (pml && pml != ptl)
+			spin_unlock(pml);
 		mmu_notifier_invalidate_range_end(&range);
 
 		if (success) {

-- 
2.43.0


