Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFC55C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 19:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D671F6B0095; Thu, 17 Sep 2026 15:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3F056B0096; Thu, 17 Sep 2026 15:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C553F6B0098; Thu, 17 Sep 2026 15:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9844A6B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:48:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA487160483
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:48:28 +0000 (UTC)
X-FDA: 85224291096.21.4FC4ECB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id D6F61120004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:48:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ejFyrMJL;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789674507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPi9DD7C6hxVr8gbca/I8Y0rhVrAGO+dhrnUS7AFw2s=;
	b=ZC2tyHTcqQ8NebN0R7L+3DHnLPbLt582lDHzNLh2s7utH3Lv3/aVZw5CiShOx99VAacCzK
	/P7/NaJZRgfJ/dxIFUlgpEtc+eXVzFouQlg9jg6grc9hqoSA/BryIA5+4vkYYLqZyavy8t
	DtzEanK/zz8Kw0Oe9hrSnjj9gFcZgRw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ejFyrMJL;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789674507;
	b=vzNakPS5/kmIKjDYgUxBZgK5irLvHWt2oWEI6o425Yeaqllu8QGu5D5nETrp4c5JoDkNiJ
	cSHgpNTxp3W9rS5IfadLDDcDmWioz8Rvs20GvNvMWAhd1Sxb1yq/1dFCEm6g/PhxptwRJ8
	ykQ/7OwuSDbsrY/TPOvBEHJj9z/z8LA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A073D4177E;
	Thu, 17 Sep 2026 19:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5165D1F000FF;
	Thu, 17 Sep 2026 19:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789674505;
	bh=JPi9DD7C6hxVr8gbca/I8Y0rhVrAGO+dhrnUS7AFw2s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ejFyrMJLaZrGRJMsMd46/Y+noflx3307eTZUOED2Aq7QGWBo0fVeHd65WkC0UMxCG
	 FJaeAtfgxrarp+R8oPZfuXVjyjBLEbeB5prbEEsVcOS1kUaAdWfMeV776rj4H4GOXS
	 5vBsPXKgcPaP2W7lMt0E226B556d45AapwoPTctc16Lsz4TWTS0kDGOhWxWArOt3J6
	 wHqUx6fgoQfnrI2UvArLLTWevC6WRB+Tu5TyOk1h3UEFEYsjPFSYX5JwWbcqH/Salj
	 xh5WimyM598eJgjJiRBdAwb3BjDCpTH+vR0Wq81iA778iuf0rinbsOGQsG3J1XtFN2
	 hMw6JisWIyuaA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 20:47:42 +0100
Subject: [PATCH v3 2/3] mm: implement and use vma_has_anon_rmap(), silence
 KCSAN
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-vma-is-faulted-v3-2-5c22314a72e7@kernel.org>
References: <20260917-vma-is-faulted-v3-0-5c22314a72e7@kernel.org>
In-Reply-To: <20260917-vma-is-faulted-v3-0-5c22314a72e7@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=21039; i=ljs@kernel.org;
 h=from:subject:message-id; bh=iKXl5naFxLH/RDiEKepuv6kXG0PssprgCoCIH2pbHOY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWOL9kMt9x403DUvakpqyS+2WftzQ6XZt9x9XmuPuDL
 8ZfRU1iOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRiHWMDKdzH8wvSlQ6HcR8
 7aho2NGFDPc9Z77giTHOv37InYlPyZXhf/yz8nU54cbsW9J9pzQ3cW+Q2u+d9/5w5Q2x1qYK60c
 PGQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D6F61120004
X-Stat-Signature: 49jaizcygrrtw3eft9az1pwn8fgkr6hj
X-Rspam-User: 
X-HE-Tag: 1789674506-483853
X-HE-Meta: U2FsdGVkX19TQQcSQLiApShTu4LV2sAixSVRSAre59nfLteEY5m6Iz+V8JQ8v9L01s9JLhgc++XbDpdtgOxOwIMIcyOXxsKRxN9C5bGumgv1heRqERvOZuggS2V1UeQ9gepofhRyIM5rijUlsHSrdL3EXiN3DdoTOKBQPDX8mTwwKxTzHm+chi/JW4yy4OP9gI4McO8Ts5ZNHw9dQyaw4+8TgIPr1kdm6tRP6WdA9YmkflUEgNxuB92TMmAK0c7DZN6v/mFA5HoXYCrkzhbWY4rqcs/oG280ksLPMTlWMwIZDwmY3saBgTcMDll1AJoe+rk0Sr/2lktiFvvpZl3MRsJD2zSe0LZJjqT9/R0Wy6m/TSFUNiJ3Q3HvnYfn8JQ+CM5g5tD9riMimRrwFkN36xxINMjkRseBSwjVmTeg56ADauRE1N0phN/XDQHzqXsK8Dmn9AcfCeJRO/2e0DJN9IETfGBMoFf7zdxLA6xjZmDxhSbuRUsy6x1iJrYIj3A2vowkmmevvwHuSJj5iSggaEWFOUbNEDFk6hg01OYYPipMt19GzvPE5c+nFo7SvwoWxvbTMXF8k91FXQXZr+1m/ZzN9DySdLInwM+Dt9nbJfXKCHvRbLOjTlRzEU8u4PR+S3rwBCukzfez0on74qYBv2IPXtZXpcQf04JLItl8fWV1LDvzjy8qcuc0ecal2ogiKDWmYfX58LFjR+PhBJ+UPa8IonR2x6jmLZfeDmWlPMAnSgEbAJGA1NI4sX6jZIVVCBBrCd/RLI8q09PZAQkC6PDCqm18L/mMt1r29OViJYs6ayOicCQAaCSonRRCUyc1wqRCDSbqBuZ7Y19gY/45btbV6nXJLQLwyculKMLyqNe3nO92dcJXqVTwWGhtoynPSL76pLG/Tqx7tBc+h1Z7PvYwPk6TxAp77v5sxwTTquG1RzMLgjumODSGcfUG/GujLhn67+7wo0/SfYBWT4f
 0ykqEStG
 ZGuxK7G9kjw5/1oRppZ3hjteUYoqzc93j8IQ5PBwEaOrpk+locGpaXmFxuYvM7zEAPzK3/AUuJHX87MHezs3B1RlbNW3TdTRHwH06uZu6UFFLw0ABEXehlUS7d2wWXVlX/6oUstL4F6yVSPnl2aAGFU2Gft45zrFxJlaCFIWaLwmCpNKogAvoe/+PIMVZ4v2cBCMu6j1nJIivf0RyS4TWC+KKj4dKT0ugmFjs8k8TmERRXNupMR56Z0MxcHgK6LcojwwvuH6xLq1NseVU+5AkSW4KhlVUCcqrxjFCqHHwTgEt4FSBaYnCKfEAvm39+nhhkBqwoAamBfiKis2bvkDgJX0CYE6YH2dv5yMNYVu//RW5Lsmst5WgM2cakJmhWYQEk/uBXOkSCU+k7pk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide a function to abstract the common task of checking whether
a VMA has an anonymous reverse mapping associated with it.

If the VMA is attached, a VMA or mmap lock must be held when calling this
function.

For an attached, anonymous, VMA:

          Transition          |              VMA/mmap Lock state
 -----------------------------|-------------------------------------------
   No anon rmap to anon rmap  | Write lock/read lock + mm->page_table_lock
   Anon rmap to no anon rmap  | Write lock

vma_has_anon_rmap() never provides a false positive (the lock precludes
it), but if only a read lock is held, a negative result must be re-checked
with mm->page_table_lock held.

A VMA obtains an anonymous reverse mapping when first faulted or forked
and it is removed when it is freed.

Detached VMAs cannot be concurrently manipulated as they are removed from
the maple tree so require no guarantees.

Use data_race() to silence KCSAN about non-existent data races between
concurrent vma->anon_vma read/write on optimistic fault tests.

Update the core VMA merge/split, rmap, mremap, KSM, fork,
khugepaged and fault preparation callers which test vma->anon_vma directly
to use vma_has_anon_rmap() instead.

Finally, update comments that reference anon_vma to reference the anon rmap
instead.

Since the lockless read in reusable_anon_vma() is doing more than checking
whether the VMA has anon rmap - it is returning the anon_vma to be used on
fault - do not alter it.

There is one odd one out - file_backed_vma_is_retractable() - which holds
neither a VMA nor mmap lock and is stabilised by the file rmap lock only,
so simply add a comment to explain why it's necessary.

Reported-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Closes: https://lore.kernel.org/all/20260829100034.423064-1-trintaeoitogc@gmail.com/
Closes: https://lore.kernel.org/all/20260909115723.528501-1-trintaeoitogc@gmail.com/
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c                  |  4 ++--
 mm/internal.h                     |  2 +-
 mm/khugepaged.c                   |  5 ++++-
 mm/ksm.c                          | 10 +++++-----
 mm/madvise.c                      |  4 ++--
 mm/memory.c                       |  4 ++--
 mm/mprotect.c                     |  2 +-
 mm/mremap.c                       |  4 ++--
 mm/rmap.c                         | 22 +++++++++++-----------
 mm/swapfile.c                     |  2 +-
 mm/userfaultfd.c                  |  2 +-
 mm/vma.c                          | 29 +++++++++++++++--------------
 mm/vma.h                          | 29 ++++++++++++++++++++++++++++-
 tools/testing/vma/include/stubs.h |  4 ++++
 14 files changed, 79 insertions(+), 44 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index dd66c6ad5af1..8974aaa17f22 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -264,7 +264,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	 * Allow page fault since anon_vma may be not initialized until
 	 * the first page fault.
 	 */
-	if (!vma->anon_vma)
+	if (!vma_has_anon_rmap(vma))
 		return (smaps || in_pf) ? orders : 0;
 
 	return orders;
@@ -2176,7 +2176,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf)
 	pmd_t orig_pmd = vmf->orig_pmd;
 
 	vmf->ptl = pmd_lockptr(vma->vm_mm, vmf->pmd);
-	VM_BUG_ON_VMA(!vma->anon_vma, vma);
+	VM_BUG_ON_VMA(!vma_has_anon_rmap(vma), vma);
 
 	if (is_huge_zero_pmd(orig_pmd)) {
 		vm_fault_t ret = do_huge_zero_wp_pmd(vmf);
diff --git a/mm/internal.h b/mm/internal.h
index da14c56fb24e..06eae4f9ec35 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -325,7 +325,7 @@ void unlink_anon_vmas(struct vm_area_struct *vma);
 
 static inline int anon_vma_prepare(struct vm_area_struct *vma)
 {
-	if (likely(vma->anon_vma))
+	if (likely(vma_has_anon_rmap(vma)))
 		return 0;
 
 	return __anon_vma_prepare(vma);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f49a6710933b..6aaa66cea518 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1094,7 +1094,7 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
 	 * thp_vma_allowable_orders() may return true for qualified file
 	 * vmas.
 	 */
-	if (expect_anon && (!(*vmap)->anon_vma || !vma_is_anonymous(*vmap)))
+	if (expect_anon && (!vma_has_anon_rmap(vma) || !vma_is_anonymous(vma)))
 		return SCAN_PAGE_ANON;
 	return SCAN_SUCCEED;
 }
@@ -2117,6 +2117,9 @@ static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
 	 * Check vma->anon_vma to exclude MAP_PRIVATE mappings that
 	 * got written to. These VMAs are likely not worth removing
 	 * page tables from, as PMD-mapping is likely to be split later.
+	 *
+	 * Can't use vma_has_anon_rmap() here as the VMA may be stabilised
+	 * by the file rmap lock.
 	 */
 	if (READ_ONCE(vma->anon_vma))
 		return false;
diff --git a/mm/ksm.c b/mm/ksm.c
index 624f37975e12..338cd95cd2e5 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -777,7 +777,7 @@ static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
 	if (ksm_test_exit(mm))
 		return NULL;
 	vma = vma_lookup(mm, addr);
-	if (!vma || !(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
+	if (!vma || !(vma->vm_flags & VM_MERGEABLE) || !vma_has_anon_rmap(vma))
 		return NULL;
 	return vma;
 }
@@ -1241,7 +1241,7 @@ static int unmerge_and_remove_all_rmap_items(void)
 			goto mm_exiting;
 
 		for_each_vma(vmi, vma) {
-			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
+			if (!(vma->vm_flags & VM_MERGEABLE) || !vma_has_anon_rmap(vma))
 				continue;
 			err = break_ksm(vma, vma->vm_start, vma->vm_end, false);
 			if (err)
@@ -2691,7 +2691,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 			continue;
 		if (ksm_scan.address < vma->vm_start)
 			ksm_scan.address = vma->vm_start;
-		if (!vma->anon_vma)
+		if (!vma_has_anon_rmap(vma))
 			ksm_scan.address = vma->vm_end;
 
 		while (ksm_scan.address < vma->vm_end) {
@@ -2882,7 +2882,7 @@ static int __ksm_del_vma(struct vm_area_struct *vma)
 	if (!(vma->vm_flags & VM_MERGEABLE))
 		return 0;
 
-	if (vma->anon_vma) {
+	if (vma_has_anon_rmap(vma)) {
 		err = break_ksm(vma, vma->vm_start, vma->vm_end, true);
 		if (err)
 			return err;
@@ -3034,7 +3034,7 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		if (!(*vm_flags & VM_MERGEABLE))
 			return 0;		/* just ignore the advice */
 
-		if (vma->anon_vma) {
+		if (vma_has_anon_rmap(vma)) {
 			err = break_ksm(vma, start, end, true);
 			if (err)
 				return err;
diff --git a/mm/madvise.c b/mm/madvise.c
index 73c2901b9adb..f335a47e6e02 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1156,7 +1156,7 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 	 * as part of the VMA lock logic.
 	 */
 	if (vma_is_anonymous(vma)) {
-		VM_WARN_ON_ONCE(!vma->anon_vma &&
+		VM_WARN_ON_ONCE(!vma_has_anon_rmap(vma) &&
 				madv_behavior->lock_mode != MADVISE_MMAP_READ_LOCK);
 
 		err = anon_vma_prepare(vma);
@@ -1619,7 +1619,7 @@ static bool is_vma_lock_sufficient(struct vm_area_struct *vma,
 	 * check overly paranoid which is safe.
 	 */
 	if (vma_is_anonymous(vma) &&
-	    prepares_anon_vma(madv_behavior->behavior) && !vma->anon_vma)
+	    prepares_anon_vma(madv_behavior->behavior) && !vma_has_anon_rmap(vma))
 		return false;
 
 	return true;
diff --git a/mm/memory.c b/mm/memory.c
index a2a63ae0967c..84182971f242 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1536,7 +1536,7 @@ vma_needs_copy(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 	 * The presence of an anon_vma indicates an anonymous VMA has page
 	 * tables which naturally cannot be reconstituted on page fault.
 	 */
-	if (src_vma->anon_vma)
+	if (vma_has_anon_rmap(src_vma))
 		return true;
 
 	/*
@@ -3915,7 +3915,7 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
 	struct vm_area_struct *vma = vmf->vma;
 	vm_fault_t ret = 0;
 
-	if (likely(vma->anon_vma))
+	if (likely(vma_has_anon_rmap(vma)))
 		return 0;
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
 		if (!mmap_read_trylock(vma->vm_mm))
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2888ee638d87..94a1830738de 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -817,7 +817,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 			vma_flags_set(&new_vma_flags, VMA_ACCOUNT_BIT);
 		}
 	} else if (vma_flags_test(&old_vma_flags, VMA_ACCOUNT_BIT) &&
-		   vma_is_anonymous(vma) && !vma->anon_vma) {
+		   vma_is_anonymous(vma) && !vma_has_anon_rmap(vma)) {
 		vma_flags_clear(&new_vma_flags, VMA_ACCOUNT_BIT);
 	}
 
diff --git a/mm/mremap.c b/mm/mremap.c
index 7c368440fafe..5afc3968d22b 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -144,13 +144,13 @@ static void take_rmap_locks(struct vm_area_struct *vma)
 {
 	if (vma->vm_file)
 		i_mmap_lock_write(vma->vm_file->f_mapping);
-	if (vma->anon_vma)
+	if (vma_has_anon_rmap(vma))
 		anon_vma_lock_write(vma->anon_vma);
 }
 
 static void drop_rmap_locks(struct vm_area_struct *vma)
 {
-	if (vma->anon_vma)
+	if (vma_has_anon_rmap(vma))
 		anon_vma_unlock_write(vma->anon_vma);
 	if (vma->vm_file)
 		i_mmap_unlock_write(vma->vm_file->f_mapping);
diff --git a/mm/rmap.c b/mm/rmap.c
index 0a3952706faf..ecc096d4875b 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -208,7 +208,7 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	anon_vma_lock_write(anon_vma);
 	/* page_table_lock to protect against threads */
 	spin_lock(&mm->page_table_lock);
-	if (likely(!vma->anon_vma)) {
+	if (likely(!vma_has_anon_rmap(vma))) {
 		/*
 		 * Make anon_vma fields visible before anon_vma is published.
 		 * Paired with an address dependency in reusable_anon_vma().
@@ -246,21 +246,21 @@ static void check_anon_vma_clone(struct vm_area_struct *dst,
 	VM_WARN_ON_ONCE(operation != VMA_OP_FORK && dst->vm_mm != src->vm_mm);
 
 	/* If we have anything to do src->anon_vma must be provided. */
-	VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_chain));
-	VM_WARN_ON_ONCE(!src->anon_vma && dst->anon_vma);
+	VM_WARN_ON_ONCE(!vma_has_anon_rmap(src) && !list_empty(&src->anon_vma_chain));
+	VM_WARN_ON_ONCE(!vma_has_anon_rmap(src) && vma_has_anon_rmap(dst));
 	/* We are establishing a new anon_vma_chain. */
 	VM_WARN_ON_ONCE(!list_empty(&dst->anon_vma_chain));
 	/*
 	 * On fork, dst->anon_vma is set NULL (temporarily). Otherwise, anon_vma
 	 * must be the same across dst and src.
 	 */
-	VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma != src->anon_vma);
+	VM_WARN_ON_ONCE(vma_has_anon_rmap(dst) && dst->anon_vma != src->anon_vma);
 	/*
 	 * Essentially equivalent to above - if not a no-op, we should expect
 	 * dst->anon_vma to be set for everything except a fork.
 	 */
-	VM_WARN_ON_ONCE(operation != VMA_OP_FORK && src->anon_vma &&
-			!dst->anon_vma);
+	VM_WARN_ON_ONCE(operation != VMA_OP_FORK && vma_has_anon_rmap(src) &&
+			!vma_has_anon_rmap(dst));
 	/* For the anon_vma to be compatible, it can only be singular. */
 	VM_WARN_ON_ONCE(operation == VMA_OP_MERGE_UNFAULTED &&
 			!list_is_singular(&src->anon_vma_chain));
@@ -273,7 +273,7 @@ static void maybe_reuse_anon_vma(struct vm_area_struct *dst,
 		struct anon_vma *anon_vma)
 {
 	/* If already populated, nothing to do.*/
-	if (dst->anon_vma)
+	if (vma_has_anon_rmap(dst))
 		return;
 
 	/*
@@ -327,7 +327,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
 
 	check_anon_vma_clone(dst, src, operation);
 
-	if (!active_anon_vma)
+	if (!vma_has_anon_rmap(src))
 		return 0;
 
 	/*
@@ -384,7 +384,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	int rc;
 
 	/* Don't bother if the parent process has no anon_vma here. */
-	if (!pvma->anon_vma)
+	if (!vma_has_anon_rmap(pvma))
 		return 0;
 
 	/* Drop inherited anon_vma, we'll reuse existing or allocate new. */
@@ -405,7 +405,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	 */
 	rc = anon_vma_clone(vma, pvma, VMA_OP_FORK);
 	/* An error arose or an existing anon_vma was reused, all done then. */
-	if (rc || vma->anon_vma) {
+	if (rc || vma_has_anon_rmap(vma)) {
 		put_anon_vma(anon_vma);
 		anon_vma_chain_free(avc);
 		return rc;
@@ -864,7 +864,7 @@ unsigned long page_address_in_vma(const struct folio *folio,
 		 * Note: swapoff's unuse_vma() is more efficient with this
 		 * check, and needs it to match anon_vma when KSM is active.
 		 */
-		if (!vma->anon_vma || !anon_vma ||
+		if (!vma_has_anon_rmap(vma) || !anon_vma ||
 		    vma->anon_vma->root != anon_vma->root)
 			return -EFAULT;
 		/* KSM folios don't reach here because of the !anon_vma check */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 01e7b6b046b6..8e5d5a164d10 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2705,7 +2705,7 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
 	if (check_stable_address_space(mm))
 		goto unlock;
 	for_each_vma(vmi, vma) {
-		if (vma->anon_vma && !is_vm_hugetlb_page(vma)) {
+		if (vma_has_anon_rmap(vma) && !is_vm_hugetlb_page(vma)) {
 			ret = unuse_vma(vma, type);
 			if (ret)
 				break;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 79cc7b546f13..b5698cce5314 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -145,7 +145,7 @@ static struct vm_area_struct *uffd_lock_vma(struct mm_struct *mm,
 		 * We know we're going to need to use anon_vma, so check
 		 * that early.
 		 */
-		if (!(vma->vm_flags & VM_SHARED) && unlikely(!vma->anon_vma))
+		if (!(vma->vm_flags & VM_SHARED) && unlikely(!vma_has_anon_rmap(vma)))
 			vma_end_read(vma);
 		else
 			return vma;
diff --git a/mm/vma.c b/mm/vma.c
index 55917d097933..f9386f9f2353 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -100,7 +100,8 @@ static bool vma_is_fork_child(struct vm_area_struct *vma)
 	 * parents. This can improve scalability caused by the anon_vma root
 	 * lock.
 	 */
-	return vma && vma->anon_vma && !list_is_singular(&vma->anon_vma_chain);
+	return vma && vma_has_anon_rmap(vma) &&
+		!list_is_singular(&vma->anon_vma_chain);
 }
 
 static inline bool is_mergeable_vma(struct vma_merge_struct *vmg, bool merge_next)
@@ -140,7 +141,7 @@ static bool is_mergeable_anon_vma(struct vma_merge_struct *vmg, bool merge_next)
 	VM_WARN_ON(src && src_anon != src->anon_vma);
 
 	/* Case 1 - we will dup_anon_vma() from src into tgt. */
-	if (!tgt_anon && src_anon) {
+	if (!vma_has_anon_rmap(tgt) && src_anon) {
 		struct vm_area_struct *copied_from = vmg->copied_from;
 
 		if (vma_is_fork_child(src))
@@ -151,7 +152,7 @@ static bool is_mergeable_anon_vma(struct vma_merge_struct *vmg, bool merge_next)
 		return true;
 	}
 	/* Case 2 - we will simply use tgt's anon_vma. */
-	if (tgt_anon && !src_anon)
+	if (vma_has_anon_rmap(tgt) && !src_anon)
 		return !vma_is_fork_child(tgt);
 	/* Case 3 - the anon_vma's are already shared. */
 	return src_anon == tgt_anon;
@@ -190,10 +191,10 @@ static void init_multi_vma_prep(struct vma_prepare *vp,
 		adjust = NULL;
 
 	vp->adj_next = adjust;
-	if (!vp->anon_vma && adjust)
+	if (!vma_has_anon_rmap(vma) && adjust)
 		vp->anon_vma = adjust->anon_vma;
 
-	VM_WARN_ON(vp->anon_vma && adjust && adjust->anon_vma &&
+	VM_WARN_ON(vma_has_anon_rmap(vma) && adjust && vma_has_anon_rmap(adjust) &&
 		   vp->anon_vma != adjust->anon_vma);
 
 	vp->file = vma->vm_file;
@@ -430,7 +431,7 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 				      vp->remove->vm_end);
 			fput(vp->file);
 		}
-		if (vp->remove->anon_vma)
+		if (vma_has_anon_rmap(vp->remove))
 			unlink_anon_vmas(vp->remove);
 		mm->map_count--;
 		mpol_put(vma_policy(vp->remove));
@@ -500,7 +501,7 @@ static bool can_vma_merge_right(struct vma_merge_struct *vmg,
 	 * We therefore check this in addition to mergeability to either side.
 	 */
 	prev = vmg->prev;
-	return !prev->anon_vma || !next->anon_vma ||
+	return !vma_has_anon_rmap(prev) || !vma_has_anon_rmap(next) ||
 		prev->anon_vma == next->anon_vma;
 }
 
@@ -670,7 +671,7 @@ static int dup_anon_vma(struct vm_area_struct *dst,
 	 * that is it is unfaulted, we need to ensure that the newly merged
 	 * range is referenced by the anon_vma's of the source.
 	 */
-	if (src->anon_vma && !dst->anon_vma) {
+	if (vma_has_anon_rmap(src) && !vma_has_anon_rmap(dst)) {
 		int ret;
 
 		vma_assert_write_locked(dst);
@@ -720,7 +721,7 @@ void validate_mm(struct mm_struct *mm)
 		}
 
 #ifdef CONFIG_DEBUG_VM_RB
-		if (anon_vma) {
+		if (vma_has_anon_rmap(vma)) {
 			anon_vma_lock_read(anon_vma);
 			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 				anon_rmap_tree_verify(avc);
@@ -1019,7 +1020,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 		 * simply a case of, if prev has no anon_vma object, which of
 		 * next or middle contains the anon_vma we must duplicate.
 		 */
-		err = dup_anon_vma(prev, next->anon_vma ? next : middle,
+		err = dup_anon_vma(prev, vma_has_anon_rmap(next) ? next : middle,
 				   &anon_dup);
 	} else if (merge_left) {
 		/*
@@ -1957,7 +1958,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	 * If a vma has not yet been faulted, update its anonymous pgoff to
 	 * match the new location to increase its chance of merging.
 	 */
-	if (!vma->anon_vma) {
+	if (!vma_has_anon_rmap(vma)) {
 		anon_pgoff = addr >> PAGE_SHIFT;
 
 		if (vma_is_anonymous(vma)) {
@@ -2369,7 +2370,7 @@ int mm_take_all_locks(struct mm_struct *mm)
 	for_each_vma(vmi, vma) {
 		if (signal_pending(current))
 			goto out_unlock;
-		if (vma->anon_vma)
+		if (vma_has_anon_rmap(vma))
 			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 				vm_lock_anon_vma(mm, avc->anon_vma);
 	}
@@ -2431,7 +2432,7 @@ void mm_drop_all_locks(struct mm_struct *mm)
 	BUG_ON(!mutex_is_locked(&mm_all_locks_mutex));
 
 	for_each_vma(vmi, vma) {
-		if (vma->anon_vma)
+		if (vma_has_anon_rmap(vma))
 			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 				vm_unlock_anon_vma(avc->anon_vma);
 		if (vma->vm_file && vma->vm_file->f_mapping)
@@ -3458,7 +3459,7 @@ int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 	 * Similarly in do_mmap and in do_brk_flags.
 	 */
 	if (vma_is_anonymous(vma)) {
-		WARN_ON_ONCE(vma->anon_vma);
+		WARN_ON_ONCE(vma_has_anon_rmap(vma));
 		vma_set_pgoff(vma, vma->vm_start >> PAGE_SHIFT);
 	}
 	vma_set_anon_pgoff(vma, vma->vm_start >> PAGE_SHIFT);
diff --git a/mm/vma.h b/mm/vma.h
index e97bd2dfa786..e77f1c1bab3f 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -255,6 +255,33 @@ static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
 	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
 }
 
+/**
+ * vma_has_anon_rmap() - does @vma possess an anonymous reverse mapping?
+ * @vma: The VMA to be checked.
+ *
+ * If the VMA is attached, a VMA or mmap lock must be held.
+ *
+ * This state is only possible for CoW mappings, see the comment for
+ * vma_flags_is_cow_mapping() for details.
+ *
+ * Importantly, a VMA which possesses an anonymous rmap may map anonymous
+ * folios.
+ *
+ * This function will not result in a false positive.
+ *
+ * However, if only a read lock is held, it may give a false negative, in which
+ * case it should be re-checked with mm->page_table_lock held.
+ *
+ * Returns: true if @vma has an anonymous reverse mapping, otherwise false.
+ */
+static inline bool vma_has_anon_rmap(const struct vm_area_struct *vma)
+{
+	if (vma_is_attached(vma))
+		vma_assert_stabilised(vma);
+	/* KCSAN gets confused about the optimistic check. Silence it. */
+	return data_race(vma->anon_vma);
+}
+
 static inline void assert_sane_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
 {
 	/* nommu doesn't set a virtual pgoff for anon VMAs. */
@@ -268,7 +295,7 @@ static inline void assert_sane_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
 	if (!vma_is_anonymous(vma))
 		return;
 	/* If faulted in, could have been remapped. */
-	if (vma->anon_vma)
+	if (vma_has_anon_rmap(vma))
 		return;
 	/* OK this is really an anon VMA - expect virtual page offset. */
 	VM_WARN_ON_ONCE(pgoff != vma->vm_start >> PAGE_SHIFT);
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index d6136e19a8af..e3bb52bc2d92 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -302,6 +302,10 @@ static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 {
 }
 
+static inline void vma_assert_stabilised(const struct vm_area_struct *vma)
+{
+}
+
 static inline void ksm_add_vma(struct vm_area_struct *vma)
 {
 }

-- 
2.55.0


