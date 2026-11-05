Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FCF7606A32E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tn9SKtf+
Received: by kanga.kvack.org (Postfix)
	id 2A1D66B05D2; Thu,  5 Nov 2026 13:41:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 277136B05D3; Thu,  5 Nov 2026 13:41:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 166366B05D4; Thu,  5 Nov 2026 13:41:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBF146B05D2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:41:52 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2A13140BA4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:21 +0000 (UTC)
X-FDA: 85401933162.05.EC39BE8
Received: from mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id 14CEF80008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tn9SKtf+;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZAFfAnwseEGYikAGWanBt9opnTjDYu6yWVY0pO5d3Ko=;
	b=ZtFpNGN61Xgmgocc5KFvTQwfKXQZTwBkR4aG28iX9P9itacAzOs7c7/0aj6bQIo1jEWwh3
	pk8397CXADsE7Klkicv+DmbVm/v7mLJaWWXChNaaFLFmdM/nbseiiFUwc/vWku7Hw+sMZm
	kLG9Tl+ChfqZawJ7pWz1mq8o18Fazs4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tn9SKtf+;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904080;
	b=4TutMIHzYGvy0Zqm8OZBs2qKYiwrCa35WSTiDBwDLhNguHRUNA1C+PSe3RSIgcqRhWX/n0
	D/qxDnoryZizeUWtMWu3b+f1cYJcKW6OWh5+HrcXypszqiUlfxY2sH7F0guVplZ0TxFXut
	IKs2nhQFtS/Q6BRpPWcDS/ld4DstXI4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=zffeoJLKO7Tl5hUbNbLp+22MEhUyioYGApHq3/JagZE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904078; v=1; x=1794508878;
 b=tn9SKtf+N+/QW8KKeu71U/sN3J1isoUMd2/v7ixU7tIhu1lNTSTr+DMaRpLbK1SYx3Y2DRXu
 nJ3Hi6m/CtlVrpqTLB+PZMnAZVPTvDPQqJTkh0vKFdqZKihPLPq4gIHHlxxgc6pGOKDwdRh7Cla
 bSsn/1WuK6vKPb8jcSsaj/QA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 86bcf934275d1289;
	Thu, 05 Nov 2026 18:41:18 +0000
X-Mizu-Trace-ID: 86bcf934275d1289
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
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
Subject: [PATCH v9 14/32] mm: handle PMD swap entries in fork path
Date: Thu,  5 Nov 2026 10:38:58 -0800
Message-ID: <20261105183940.2236717-15-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hmsg7b5q3bbkk645k3dpuz4pt8kt935i
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 14CEF80008
X-HE-Tag: 1793904079-489354
X-HE-Meta: U2FsdGVkX186sSHT9olUpOD0Inj8F5ouLqxy8CJzojn0uf2KgE9QxSykMSREZ/COpxXhg//MPyl42drfPzUY63DgaC1zuEttuGOeGYqatkIid9DpWkO9eKsABaX99nnkD1bHy3mE6gK4JNo78jo6ip417FWxs/r3oOOi0CtP9p/nrWz7jr5NxjaO8XYkpd1GfQCE+HU135rmZhYSYzCYlNeksPqz9BgzgyEH9w1gLGCO8GBVJM4AX96G3QCYqbXMokjd8h2oAEppQKZyyYTzc457FCpL75xl/90gybP60M22X4HB6wuXs7gz0d0Fcj7aLU3CtuuhT+LRoBMQ54HeyjawxEcQL6RTmlcT+8SiLF60nFBA6rUMt5KB/tXDlDnYSOxBAvoMqmwmckJG9AVsMs6WxXz1ACQQIBgd0GgsIEeKKDAhNlObTT+s1rFj3xZZ4j/WAY84zPe7xLB4GCCzxwr9AUENJOvYea3+xhTU7WFTCNy84wWpSSWIuBeeYPaMoRfAY7bmzZXVnN1DDDgWvZOUkJIlGTSSQZjSMThKtSXXQKHwVAMvkTfzP3PEGb7+0crLchbmOzT7dlr2m9JUc+ZIHyEu2CawHYBxtnhjaY66CEcOcGmfiteQcFrvbP/WLj42Q21vbbmkUZraPBn5Ei3WyUkJ4XQpgdXtjbuhmCLIvxmypc3Hq0UOEoeeKrj66lvOfdJQtWDBoyMaKMTbF/Z0keMHOTTNpMSeiW4iZGK1pK0AE3c4etOEBg4tVnafnQXtJUXXPDHpcPtqYMOKTQRVpbBs/pnp5VeLRW0FLd5ZfRUyBF1r8gPKqC4z8KmecqScppB8MXj+NgP4sh3OfMMfgQch/A1FH4kGxv3CwfeLai/1IlOeSTIehxaKam9RHW9XAfvKPZSS7OJk6eV6MxIg0mvKhkWAytcN8DQMeUhYTQKPcUY2CeJwAQR9cFlP3+yqIFUbkH7C4rv5Dk6
 Bt/+DmRy
 QPAL7r3oiRR4Ko8e664uVrN3+MtjfvCm2E/xQP9RH6MTwHNdkg5IHentLKxu5Q7+iEIS5L1wmvODInpb0NgGsBdwh/xWh8adILv0OarUVmEeH6N4Z36tOKeYqxNbEj1ncnOYobJboNyJWeUmMUKhkcn2XKwAREjHhe+Y173/4CBgczNxbbPNU7aNmCfV8wOJQUczQSNTkAXT0dYpHFKrlCjo5WCaEHvwLX6CQ/uSZ62DUuGkdy8wbz2FjL8y3qugM+N3g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
Reviewed-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h |  3 +-
 mm/huge_memory.c        | 65 ++++++++++++++++++++++++++++++-----------
 mm/memory.c             | 12 +++++++-
 3 files changed, 61 insertions(+), 19 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 34307bda8071b..8597bc52fdc87 100644
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
index 696813776e45d..acb540235e5a9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1892,7 +1892,7 @@ bool touch_pmd(struct vm_area_struct *vma, unsigned long addr,
 	return false;
 }
 
-static void copy_huge_non_present_pmd(
+static int copy_huge_non_present_pmd(
 		struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 		struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
@@ -1900,18 +1900,44 @@ static void copy_huge_non_present_pmd(
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
+		/*
+		 * Return -EIO on allocation failure so the caller can retry
+		 * with GFP_KERNEL. Fail the fork on any other error.
+		 */
+		if (err)
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
@@ -1938,19 +1964,21 @@ static void copy_huge_non_present_pmd(
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
@@ -1993,11 +2021,14 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
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
index 85bd1b08a1a2a..dedcec3cfca6e 100644
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


