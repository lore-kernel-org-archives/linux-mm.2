Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B20C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 11:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF1A38E001C; Wed,  6 Aug 2025 07:19:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA24C8E001B; Wed,  6 Aug 2025 07:19:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB87E8E001C; Wed,  6 Aug 2025 07:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C63F28E001B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 07:19:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5E974140396
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:19:37 +0000 (UTC)
X-FDA: 83746087194.07.740A86C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 77D8C1C0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:19:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754479175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JzmW4jIOcULJrsGeWpyvou8MfLG4LSSpGzDlnnjsl5U=;
	b=sOaWcvCKQMnrxPc3CJjql+6t6g0/olnjgJz1Ka0z72UniXfpI6JmhhDvvIFh0pPLd96E9Z
	P4mq6lrHvlXj84HGGG+Jl0oY3Z2DjfGepHOB8QvpgG//ySyi/cyV/86GJE3dnT8a8WdH+D
	RowZz27bwbdPgF3FBW6g0PC60kFwvrc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754479175; a=rsa-sha256;
	cv=none;
	b=SZbfSvL9KV6kW7NkZwuIsK3hmb0ajOAgq+n314ueKwo4FtayJpIE+QTV8EtkYaxmwfyaDA
	jfJbKOebCWA06BjdAqfrL3+LuJ6DKj272gOgmXPZM1itBLEv05H0gIyZF3mzW3Xr+0gG1Z
	fWWY3c39j4YCp+vVj0IhnVhsb+92GuU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6CF0919F0;
	Wed,  6 Aug 2025 04:19:26 -0700 (PDT)
Received: from MacBook-Pro.blr.arm.com (unknown [10.164.18.68])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A029E3F5A1;
	Wed,  6 Aug 2025 04:19:31 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: syzbot+57bcc752f0df8bb1365c@syzkaller.appspotmail.com
Cc: akpm@linux-foundation.org,
	david@redhat.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	peterx@redhat.com,
	syzkaller-bugs@googlegroups.com,
	Dev Jain <dev.jain@arm.com>
Subject: Re: [syzbot] [mm?] WARNING in follow_page_pte
Date: Wed,  6 Aug 2025 16:49:22 +0530
Message-Id: <20250806111922.669-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <68930511.050a0220.7f033.003a.GAE@google.com>
References: <68930511.050a0220.7f033.003a.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 77D8C1C0003
X-Stat-Signature: d6k1zwsjtnxezewnu99cj3g7agghs5aw
X-Rspam-User: 
X-HE-Tag: 1754479175-686669
X-HE-Meta: U2FsdGVkX19xM69Q9uZizzwPTzRUVadvvyU60nk90N9DDutQ4Bc6/u8EIlQiMww0f2mxzltSsEQ+CKgvSOfpxwkVigKfZZNx3bzG1d0sXbNzDmr5OrffUXmldezxGIU4Iyk0fgu7FnLMGmyCKGXLl8V9i9ztOrTFbLmJFcuXZ/UwxL67sFipe3v2emVSeZAXVqYQc8qrSuHcE52wJTdMBLdFJTOL2GAlyfqmtYTXuCKBhc0re4Z/ZNd4khgH1JEVXjO2SZ7+j4OIX8ofwt355jo6LC7z+qFaYS6XyyfoS/kMOxBWIVSPK4Apq8VaW0ClAj786p6rUhhcMTjD1KxmTFnWFpm6RQKwmcH/ZMvT0B6dve4gXv98Z+kD4I+Yv4c/ko4YJDr2QfJspFk4JTxZ2Uw7WqTqQ/8N+br7RksQ8JLoHsDyTIO096uaTmYPSLisLLZIgjz1YyR6KjUtgsdWNI+g6wxS4hn1YuCG/BS+V0kiRdLqrHDTL6o3JlXFWTsHA4Z7sZQht3KBLX/Cz9bbZX4UGXXq1Xmi1hSlXNy3vJKe89L96KeeNKyJBEWvEjCcvut56bzMN7LFIS88shaDZ5v65IEdzCrYZhdW0x5OlHw3ybsjNqNIKnOix6329CDkerlLL17pHlAcI2iyI+8YyQuiMGD/4au12xd7P35xEgNOYA+RbFlHo9xCBMYCsZW4S90ZBjENyd9arz6Z9kE9DVguRHszzgEMn9b9JrPG0cjXcipDvJ0M6MCeFc85xw9S8GWDULArJzZytXHDCTYvzbN8534eNppmp7pxLpaofkleLoYGa8X5OyXsfL4YdNOysiJU2e/AvQps+2yZ7VnFJtWEXs9QfBycu6ivGpC/jNFUAJTe8bVTY0z8m2AOsI75RDU6PZhYPzhp2sBbV4yjBrpf+zuTBeFGaojMiFRno6EkwwknmHtCVCTGGO9OYb10kiTCp5GN+xSngWuQize
 zHvEKj6I
 YcqzyliR4K2DJi9L6lu+najPdYN+RRIjC0jNEhCl0nMxzIf+IT/L2qqUzOEqvFsj2oBqeLcQ59mf123MSvmgi9gdXPQV2VGScruHYv365C7T/QJgRbGo0aZ7jvbvP/uetyt86UmaWam7OFZJR6jsJfqTs/uP7bz8GIpLu0i4+koU+TKP448moD09UzcpxlQYbJZRkZ889SoM96/U0q6uky9kVQi6Am79ls1c9hZz9rKjrTMvaa6ddXqf0UtaTo7oWEBIHP0iEBEUNbKPyTEb1yh2OLvij0WfyzwCorAp67bSU7ypcTA5D5u5JeAYNyU1iP1qrdVYQDsEnXoGWCO0Aw7m/eP5FeWpPdn9hRYfsN0YLuBaJk09O/SReVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

#syz test

In commit_anon_folio_batch(), we iterate over all pages pointed to by the
PTE batch. Therefore we need to know the first page of the batch;
currently we derive that via folio_page(folio, 0), but, that takes us
to the first (head) page of the folio instead - our PTE batch may lie
in the middle of the folio, leading to incorrectness.

Bite the bullet and throw away the micro-optimization of reusing the
folio in favour of code simplicity. Derive the page and the folio in
change_pte_range, and pass the page too to commit_anon_folio_batch to
fix the aforementioned issue.

Also, instead of directly adding to the stuct page *page pointer, use
the nth_page() macro for safety.

Fixes: cac1db8c3aad ("mm: optimize mprotect() by PTE batching") 
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/mprotect.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 78bded7acf79..96cd36ed3489 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -120,9 +120,8 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
 
 static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
 			   pte_t oldpte, pte_t *pte, int target_node,
-			   struct folio **foliop)
+			   struct folio *folio)
 {
-	struct folio *folio = NULL;
 	bool ret = true;
 	bool toptier;
 	int nid;
@@ -131,7 +130,6 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
 	if (pte_protnone(oldpte))
 		goto skip;
 
-	folio = vm_normal_folio(vma, addr, oldpte);
 	if (!folio)
 		goto skip;
 
@@ -173,7 +171,6 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
 		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
 
 skip:
-	*foliop = folio;
 	return ret;
 }
 
@@ -231,16 +228,15 @@ static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
  * retrieve sub-batches.
  */
 static void commit_anon_folio_batch(struct vm_area_struct *vma,
-		struct folio *folio, unsigned long addr, pte_t *ptep,
+		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
-	struct page *first_page = folio_page(folio, 0);
 	bool expected_anon_exclusive;
 	int sub_batch_idx = 0;
 	int len;
 
 	while (nr_ptes) {
-		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
+		expected_anon_exclusive = PageAnonExclusive(nth_page(first_page, sub_batch_idx));
 		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
 					first_page, expected_anon_exclusive);
 		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, len,
@@ -251,7 +247,7 @@ static void commit_anon_folio_batch(struct vm_area_struct *vma,
 }
 
 static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
-		struct folio *folio, unsigned long addr, pte_t *ptep,
+		struct folio *folio, struct page *page, unsigned long addr, pte_t *ptep,
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
 	bool set_write;
@@ -270,7 +266,7 @@ static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
 				       /* idx = */ 0, set_write, tlb);
 		return;
 	}
-	commit_anon_folio_batch(vma, folio, addr, ptep, oldpte, ptent, nr_ptes, tlb);
+	commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);
 }
 
 static long change_pte_range(struct mmu_gather *tlb,
@@ -305,15 +301,19 @@ static long change_pte_range(struct mmu_gather *tlb,
 			const fpb_t flags = FPB_RESPECT_SOFT_DIRTY | FPB_RESPECT_WRITE;
 			int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
 			struct folio *folio = NULL;
+			struct page *page;
 			pte_t ptent;
 
+			page = vm_normal_page(vma, addr, oldpte);
+			if (page)
+				folio = page_folio(page);
 			/*
 			 * Avoid trapping faults against the zero or KSM
 			 * pages. See similar comment in change_huge_pmd.
 			 */
 			if (prot_numa) {
 				int ret = prot_numa_skip(vma, addr, oldpte, pte,
-							 target_node, &folio);
+							 target_node, folio);
 				if (ret) {
 
 					/* determine batch to skip */
@@ -323,9 +323,6 @@ static long change_pte_range(struct mmu_gather *tlb,
 				}
 			}
 
-			if (!folio)
-				folio = vm_normal_folio(vma, addr, oldpte);
-
 			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
 
 			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
@@ -351,7 +348,7 @@ static long change_pte_range(struct mmu_gather *tlb,
 			 */
 			if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
 			     !pte_write(ptent))
-				set_write_prot_commit_flush_ptes(vma, folio,
+				set_write_prot_commit_flush_ptes(vma, folio, page,
 				addr, pte, oldpte, ptent, nr_ptes, tlb);
 			else
 				prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
-- 
2.30.2


