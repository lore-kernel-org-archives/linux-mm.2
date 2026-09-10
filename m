Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D3C9C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 13:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 648186B0098; Thu, 10 Sep 2026 09:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D11B6B0099; Thu, 10 Sep 2026 09:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 472A26B009B; Thu, 10 Sep 2026 09:18:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E57C6B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:18:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B44721604EB
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:18:50 +0000 (UTC)
X-FDA: 85197907620.17.6FB808C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C3978C0002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:18:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JNXK6iFC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789046328;
	b=EttwsPMdjp6dH/VJl5INl/UkyNd5WqED68UTTwzRDcUAlSMcR8fBgCkC9VxYvXOq6KsTNo
	SJU9gt3lBNz3DBvf49/yAgA0yqIOoRxi/X2I04hTwCWOPQciQeUx42NBxPK+Dw6gJYtHgj
	jBJ4+kHRl11E/MD7qfV4dLcvoCuJuwU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JNXK6iFC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789046328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=C9rP7mS0UPpIVYqx1mAxdixbwYJbxZl9KU4w1KgTEZs=;
	b=vi6XCCazP/Cszu/jxMwhOIBONdQrgv7v9nMARGSMXPDoF72o9b+o2IDxu8gsmIpbpu8XaE
	1+8fOhDwsMttKxVViFZiJmMWwMepayosjgIVY1y8qwAGZvJbBQG2eLufV4nkYRAHmyxUEK
	zv1mSJEjk6tn3eTODLF4AFEFmkFZR3o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E7E9441E75;
	Thu, 10 Sep 2026 13:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECED1F000FF;
	Thu, 10 Sep 2026 13:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789046327;
	bh=C9rP7mS0UPpIVYqx1mAxdixbwYJbxZl9KU4w1KgTEZs=;
	h=From:Date:Subject:To:Cc;
	b=JNXK6iFCfpZLYbOmRPyUsXWxvEAKwfpY0UHKxue0dBbfLO0rxicGBkFxoLqSh9kk0
	 GrvOarl/yI/mfJcBygELb3pAXCTPbVrwVnDy+pjEha1IG5od92V2wURVicDgGms5YE
	 r2pEbRiwmCwdVotoVdAgza+er+XEDNAgYxbSf1k9VJjFl3gPkFE8ir/QmjoIFgm8y3
	 H8vZ9KjTL6m1YqCxrKg2dqfMJFyuw/YAGaMxkainHVMlWBfwJBhyjnKYurd5nCOzKe
	 qpRKDkKiuc427wmywUCAJ/LsgELYoE+CbUYNwF4NkVqelkGis0JP9KYYSDQ6kgbBH9
	 DAsvPHN4SggLg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 10 Sep 2026 14:18:35 +0100
Subject: [PATCH v2] mm: implement and use vma_anon_tracked(), silence KCSAN
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-vma-is-faulted-v2-1-e81ebc7d146b@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3XMQQ6CMBCF4auQWTtmCkWoK+9hWDR2gIkIpsVGQ
 3p3K3uX/0vet0FgLxzgXGzgOUqQZc5RHgq4jXYeGMXlhpLKExkyGB8WJWBvX9PKDit2RLquatM
 Q5NPTcy/vHbx2uUcJ6+I/ux/Vb/1LRYUKK9uQ6nVrWm0vd/YzT8fFD9CllL7vYt77rQAAAA==
X-Change-ID: 20260909-vma-is-faulted-3ed004535970
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
 Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=23126; i=ljs@kernel.org;
 h=from:subject:message-id; bh=u7ZjGzir/t+vIgIcKcr0sXDNqCJ/rbJPwxS1LxIHOLk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWrdP/Ynxr9ZX9QTkezfbiJj8zSpLne2ctvHbBcl3Gi
 g+MS/cs7yhlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEtr1l+KdyP8LjTsdstxz/
 qtcHi1cLav+Y2vblTrLhxeusbz9d+7yIkWF2TEpOwz3eX42BHtuXd7vVXkk/sNcnkk3jtPQONeH
 G42wA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C3978C0002
X-Stat-Signature: gseaxgra8skyswgcwwgmzabuoc7qso73
X-HE-Tag: 1789046328-348706
X-HE-Meta: U2FsdGVkX19r3lMgm46SrYluFc0NkiDUFcreEpeIn0/KZ4yX8eGQqz38LOhYwqpVT0oRoVH5gs9F3DcQkptx+QxJ2IRbhsvTXGcK7G/25u1IStefUmIZAPQsnZcLk6sEq6LXZHH+9QAXB/tCvQ+5AV+PYyz51VDAQVJs1EjjAoHtcsMFzp3YBtEV4ftFS5nvMzE4faCK2LPOIWGJJp/vqEgQmwC2hILmJfYR/iaPT7VbGvNb8PT2Ijz8cWD7ajk+Pta2w2qqgjjhR1+4/VcTS8lTHkWC+V5FXFGjBJXE68D+GrV+hi/mmxisaN+zCuAv/F4Em5crHTVfe1O3cCuZpN/xbk9MI6DFOBTEuAQ4DEQM30Lq9ACYKe9vrQQgrL9wpUaRRKyZ3HT0CHQYLfMxq1PEJim2gL2ySeltnQAFeQzRCrUbUtfxgHxzvxUT7JKDrIVA9UW7igcggVEOmS4WGyUtp6JKELD2WicoPn1Hvc8DiJztq5lprh+h/Bl5OhAAmFapNI/bIHMj83JVWVhRhNfWqvz/tMdSkrMJOvhYzwA4mTbpYSduKLwwge3IkGSa5UNBiQ4J1lD7Ii2u3Ua5dTbhpTTXTi303Vu0eoHFYqI8BnzW6rUIaXO4feMw/jJaRVYRuAG8b2T9+GmD5G5gyhiLnFaceQ46rlmouQvAfDg4cvLsMT5+khO96m9M8bZzK6IuHJNA6enx2JOWCI8xCUf2ZDTK0y4Xp+t9qfBFYdOa2VaE9Hbppu7mNCx0Z0O/aUwsNv4ZlLsS3cIXqYawL6sUj5Vb7bLxqPTlyHrUCM1JDUn5Rajd9ZgN+B+L/GipM8El2IZd1OOjHPdjKlN6wteYniL3Z/NPYub4LEjQy07Wtc8v/Ufnrb9oDbINXyou5kQoiPABowsajPtEZImpYK/TZu8uUOjyv6RfTQgJXgTG/oBJ1xqDq4cgPrsOEc2snJL3142A4Y73Bdhz1Z7
 nXK77Tfu
 CQEKfmxD1jsOd47I9umcsGKprc75QReZvUhSXZCI7iJ9V+zmVSZWkQIldBP1QPWjdda0WV9U24ja4FfSiNzoD8EFn0WQV4rJA6TOWXi1v0mCT0ul99UEx7LbOaZcuf4co1IE3/jbMbK8EpA/6T92pNrjafpXOdFyv+5EqZykuCQlKK5vd6AQbEyoyQ7KhPuNOT2FohY0jV9PeDWbmKeUPerXw6H9AXJbZNfVl7n+bpbeT7Wn5nPVxuufRsfse84NwlhR3U8DFEF+44g7wz7G7euTeGDCP7P/relpPcHBo8UaO/DJN0mdV4oY3X+r0mrdW/M2z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide a function to abstract the common task of checking whether
a VMA is faulted in or not.

A VMA or mmap lock must be held when calling this function. For an attached
VMA the transitions between unfaulted/faulted state are:

       Transition        |              VMA/mmap Lock state
 ------------------------|-----------------------------------------------
   unfaulted to faulted  | write lock OR read lock + mm->page_table_lock
   faulted to unfaulted  | write lock

So vma_anon_tracked() never provides a false positive (the lock precludes
it), but if only a read lock is held, a negative result must be re-checked
with mm->page_table_lock held.

Detached VMAs cannot be concurrently manipulated as they are removed from
the maple tree so require no guarantees.

Use data_race() to silence KCSAN about non-existent data races between
concurrent vma->anon_vma read/write on optimistic fault tests.

Also while here, const-ify vma_is_attached(), vma_assert_stabilised() and
dependants.

Finally, update the core VMA merge/split, rmap, mremap, KSM and fault
preparation callers which test vma->anon_vma directly to use
vma_anon_tracked() instead.

Note that the lockless read in reusable_anon_vma() is doing more than
checking whether the VMA is faulted - it is returning the anon_vma to be
used on fault, so this check is not altered.

There is one odd one out - file_backed_vma_is_retractable() - which holds
neither a VMA nor mmap lock and is stabilised by the file rmap lock only.

Therefore just add a comment to explain why the direct vma->anon_vma check
is required.

Reported-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Closes: https://lore.kernel.org/all/20260829100034.423064-1-trintaeoitogc@gmail.com/
Closes: https://lore.kernel.org/all/20260909115723.528501-1-trintaeoitogc@gmail.com/
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v2:
- Renamed vma_is_faulted() to vma_anon_tracked() as per David.

v1:
https://lore.kernel.org/r/20260909-vma-is-faulted-v1-1-3a701f48984a@kernel.org
---
 include/linux/mmap_lock.h         | 12 ++++++------
 mm/huge_memory.c                  |  4 ++--
 mm/internal.h                     |  2 +-
 mm/khugepaged.c                   |  3 +++
 mm/ksm.c                          | 10 +++++-----
 mm/madvise.c                      |  4 ++--
 mm/memory.c                       |  2 +-
 mm/mprotect.c                     |  2 +-
 mm/mremap.c                       |  4 ++--
 mm/rmap.c                         | 22 +++++++++++-----------
 mm/swapfile.c                     |  2 +-
 mm/userfaultfd.c                  |  2 +-
 mm/vma.c                          | 29 +++++++++++++++--------------
 mm/vma.h                          | 22 +++++++++++++++++++++-
 tools/testing/vma/include/dup.h   |  2 +-
 tools/testing/vma/include/stubs.h |  4 ++++
 16 files changed, 77 insertions(+), 49 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 00eae65b74bd..03e1eb136111 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -273,7 +273,7 @@ static inline void vma_end_read(struct vm_area_struct *vma)
 	vma_refcount_put(vma);
 }
 
-static inline unsigned int __vma_raw_mm_seqnum(struct vm_area_struct *vma)
+static inline unsigned int __vma_raw_mm_seqnum(const struct vm_area_struct *vma)
 {
 	const struct mm_struct *mm = vma->vm_mm;
 
@@ -288,7 +288,7 @@ static inline unsigned int __vma_raw_mm_seqnum(struct vm_area_struct *vma)
  *
  * Returns true if write-locked, otherwise false.
  */
-static inline bool __is_vma_write_locked(struct vm_area_struct *vma)
+static inline bool __is_vma_write_locked(const struct vm_area_struct *vma)
 {
 	/*
 	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
@@ -344,7 +344,7 @@ int vma_start_write_killable(struct vm_area_struct *vma)
  * vma_assert_write_locked() - assert that @vma holds a VMA write lock.
  * @vma: The VMA to assert.
  */
-static inline void vma_assert_write_locked(struct vm_area_struct *vma)
+static inline void vma_assert_write_locked(const struct vm_area_struct *vma)
 {
 	if (!IS_ENABLED(CONFIG_MMU)) {
 		mmap_assert_write_locked(vma->vm_mm);
@@ -359,7 +359,7 @@ static inline void vma_assert_write_locked(struct vm_area_struct *vma)
  * lock and is not detached.
  * @vma: The VMA to assert.
  */
-static inline void vma_assert_locked(struct vm_area_struct *vma)
+static inline void vma_assert_locked(const struct vm_area_struct *vma)
 {
 	unsigned int refcnt;
 
@@ -410,7 +410,7 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
  * With lockdep disabled we may sometimes race with other threads acquiring the
  * mmap read lock simultaneous with our VMA read lock.
  */
-static inline void vma_assert_stabilised(struct vm_area_struct *vma)
+static inline void vma_assert_stabilised(const struct vm_area_struct *vma)
 {
 	/*
 	 * If another thread owns an mmap lock, it may go away at any time, and
@@ -445,7 +445,7 @@ static inline void vma_assert_stabilised(struct vm_area_struct *vma)
 	vma_assert_locked(vma);
 }
 
-static inline bool vma_is_attached(struct vm_area_struct *vma)
+static inline bool vma_is_attached(const struct vm_area_struct *vma)
 {
 	return refcount_read(&vma->vm_refcnt);
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index dd66c6ad5af1..40669bec953c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -264,7 +264,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	 * Allow page fault since anon_vma may be not initialized until
 	 * the first page fault.
 	 */
-	if (!vma->anon_vma)
+	if (!vma_anon_tracked(vma))
 		return (smaps || in_pf) ? orders : 0;
 
 	return orders;
@@ -2176,7 +2176,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf)
 	pmd_t orig_pmd = vmf->orig_pmd;
 
 	vmf->ptl = pmd_lockptr(vma->vm_mm, vmf->pmd);
-	VM_BUG_ON_VMA(!vma->anon_vma, vma);
+	VM_BUG_ON_VMA(!vma_anon_tracked(vma), vma);
 
 	if (is_huge_zero_pmd(orig_pmd)) {
 		vm_fault_t ret = do_huge_zero_wp_pmd(vmf);
diff --git a/mm/internal.h b/mm/internal.h
index da14c56fb24e..ec1ab4105a6a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -325,7 +325,7 @@ void unlink_anon_vmas(struct vm_area_struct *vma);
 
 static inline int anon_vma_prepare(struct vm_area_struct *vma)
 {
-	if (likely(vma->anon_vma))
+	if (likely(vma_anon_tracked(vma)))
 		return 0;
 
 	return __anon_vma_prepare(vma);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f49a6710933b..0295afcb3687 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2117,6 +2117,9 @@ static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
 	 * Check vma->anon_vma to exclude MAP_PRIVATE mappings that
 	 * got written to. These VMAs are likely not worth removing
 	 * page tables from, as PMD-mapping is likely to be split later.
+	 *
+	 * Can't use vma_anon_tracked() here as the VMA may be stabilised
+	 * by the file rmap lock.
 	 */
 	if (READ_ONCE(vma->anon_vma))
 		return false;
diff --git a/mm/ksm.c b/mm/ksm.c
index 624f37975e12..71e7c0212b3c 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -777,7 +777,7 @@ static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
 	if (ksm_test_exit(mm))
 		return NULL;
 	vma = vma_lookup(mm, addr);
-	if (!vma || !(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
+	if (!vma || !(vma->vm_flags & VM_MERGEABLE) || !vma_anon_tracked(vma))
 		return NULL;
 	return vma;
 }
@@ -1241,7 +1241,7 @@ static int unmerge_and_remove_all_rmap_items(void)
 			goto mm_exiting;
 
 		for_each_vma(vmi, vma) {
-			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
+			if (!(vma->vm_flags & VM_MERGEABLE) || !vma_anon_tracked(vma))
 				continue;
 			err = break_ksm(vma, vma->vm_start, vma->vm_end, false);
 			if (err)
@@ -2691,7 +2691,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 			continue;
 		if (ksm_scan.address < vma->vm_start)
 			ksm_scan.address = vma->vm_start;
-		if (!vma->anon_vma)
+		if (!vma_anon_tracked(vma))
 			ksm_scan.address = vma->vm_end;
 
 		while (ksm_scan.address < vma->vm_end) {
@@ -2882,7 +2882,7 @@ static int __ksm_del_vma(struct vm_area_struct *vma)
 	if (!(vma->vm_flags & VM_MERGEABLE))
 		return 0;
 
-	if (vma->anon_vma) {
+	if (vma_anon_tracked(vma)) {
 		err = break_ksm(vma, vma->vm_start, vma->vm_end, true);
 		if (err)
 			return err;
@@ -3034,7 +3034,7 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		if (!(*vm_flags & VM_MERGEABLE))
 			return 0;		/* just ignore the advice */
 
-		if (vma->anon_vma) {
+		if (vma_anon_tracked(vma)) {
 			err = break_ksm(vma, start, end, true);
 			if (err)
 				return err;
diff --git a/mm/madvise.c b/mm/madvise.c
index 73c2901b9adb..5a9632d39f30 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1156,7 +1156,7 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 	 * as part of the VMA lock logic.
 	 */
 	if (vma_is_anonymous(vma)) {
-		VM_WARN_ON_ONCE(!vma->anon_vma &&
+		VM_WARN_ON_ONCE(!vma_anon_tracked(vma) &&
 				madv_behavior->lock_mode != MADVISE_MMAP_READ_LOCK);
 
 		err = anon_vma_prepare(vma);
@@ -1619,7 +1619,7 @@ static bool is_vma_lock_sufficient(struct vm_area_struct *vma,
 	 * check overly paranoid which is safe.
 	 */
 	if (vma_is_anonymous(vma) &&
-	    prepares_anon_vma(madv_behavior->behavior) && !vma->anon_vma)
+	    prepares_anon_vma(madv_behavior->behavior) && !vma_anon_tracked(vma))
 		return false;
 
 	return true;
diff --git a/mm/memory.c b/mm/memory.c
index a2a63ae0967c..ce24a1189814 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3915,7 +3915,7 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
 	struct vm_area_struct *vma = vmf->vma;
 	vm_fault_t ret = 0;
 
-	if (likely(vma->anon_vma))
+	if (likely(vma_anon_tracked(vma)))
 		return 0;
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
 		if (!mmap_read_trylock(vma->vm_mm))
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2888ee638d87..73e68f02ca91 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -817,7 +817,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 			vma_flags_set(&new_vma_flags, VMA_ACCOUNT_BIT);
 		}
 	} else if (vma_flags_test(&old_vma_flags, VMA_ACCOUNT_BIT) &&
-		   vma_is_anonymous(vma) && !vma->anon_vma) {
+		   vma_is_anonymous(vma) && !vma_anon_tracked(vma)) {
 		vma_flags_clear(&new_vma_flags, VMA_ACCOUNT_BIT);
 	}
 
diff --git a/mm/mremap.c b/mm/mremap.c
index 7c368440fafe..06da9d0a9c5b 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -144,13 +144,13 @@ static void take_rmap_locks(struct vm_area_struct *vma)
 {
 	if (vma->vm_file)
 		i_mmap_lock_write(vma->vm_file->f_mapping);
-	if (vma->anon_vma)
+	if (vma_anon_tracked(vma))
 		anon_vma_lock_write(vma->anon_vma);
 }
 
 static void drop_rmap_locks(struct vm_area_struct *vma)
 {
-	if (vma->anon_vma)
+	if (vma_anon_tracked(vma))
 		anon_vma_unlock_write(vma->anon_vma);
 	if (vma->vm_file)
 		i_mmap_unlock_write(vma->vm_file->f_mapping);
diff --git a/mm/rmap.c b/mm/rmap.c
index 0a3952706faf..27d713a5cd43 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -208,7 +208,7 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	anon_vma_lock_write(anon_vma);
 	/* page_table_lock to protect against threads */
 	spin_lock(&mm->page_table_lock);
-	if (likely(!vma->anon_vma)) {
+	if (likely(!vma_anon_tracked(vma))) {
 		/*
 		 * Make anon_vma fields visible before anon_vma is published.
 		 * Paired with an address dependency in reusable_anon_vma().
@@ -246,21 +246,21 @@ static void check_anon_vma_clone(struct vm_area_struct *dst,
 	VM_WARN_ON_ONCE(operation != VMA_OP_FORK && dst->vm_mm != src->vm_mm);
 
 	/* If we have anything to do src->anon_vma must be provided. */
-	VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_chain));
-	VM_WARN_ON_ONCE(!src->anon_vma && dst->anon_vma);
+	VM_WARN_ON_ONCE(!vma_anon_tracked(src) && !list_empty(&src->anon_vma_chain));
+	VM_WARN_ON_ONCE(!vma_anon_tracked(src) && vma_anon_tracked(dst));
 	/* We are establishing a new anon_vma_chain. */
 	VM_WARN_ON_ONCE(!list_empty(&dst->anon_vma_chain));
 	/*
 	 * On fork, dst->anon_vma is set NULL (temporarily). Otherwise, anon_vma
 	 * must be the same across dst and src.
 	 */
-	VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma != src->anon_vma);
+	VM_WARN_ON_ONCE(vma_anon_tracked(dst) && dst->anon_vma != src->anon_vma);
 	/*
 	 * Essentially equivalent to above - if not a no-op, we should expect
 	 * dst->anon_vma to be set for everything except a fork.
 	 */
-	VM_WARN_ON_ONCE(operation != VMA_OP_FORK && src->anon_vma &&
-			!dst->anon_vma);
+	VM_WARN_ON_ONCE(operation != VMA_OP_FORK && vma_anon_tracked(src) &&
+			!vma_anon_tracked(dst));
 	/* For the anon_vma to be compatible, it can only be singular. */
 	VM_WARN_ON_ONCE(operation == VMA_OP_MERGE_UNFAULTED &&
 			!list_is_singular(&src->anon_vma_chain));
@@ -273,7 +273,7 @@ static void maybe_reuse_anon_vma(struct vm_area_struct *dst,
 		struct anon_vma *anon_vma)
 {
 	/* If already populated, nothing to do.*/
-	if (dst->anon_vma)
+	if (vma_anon_tracked(dst))
 		return;
 
 	/*
@@ -327,7 +327,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
 
 	check_anon_vma_clone(dst, src, operation);
 
-	if (!active_anon_vma)
+	if (!vma_anon_tracked(src))
 		return 0;
 
 	/*
@@ -384,7 +384,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	int rc;
 
 	/* Don't bother if the parent process has no anon_vma here. */
-	if (!pvma->anon_vma)
+	if (!vma_anon_tracked(pvma))
 		return 0;
 
 	/* Drop inherited anon_vma, we'll reuse existing or allocate new. */
@@ -405,7 +405,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	 */
 	rc = anon_vma_clone(vma, pvma, VMA_OP_FORK);
 	/* An error arose or an existing anon_vma was reused, all done then. */
-	if (rc || vma->anon_vma) {
+	if (rc || vma_anon_tracked(vma)) {
 		put_anon_vma(anon_vma);
 		anon_vma_chain_free(avc);
 		return rc;
@@ -864,7 +864,7 @@ unsigned long page_address_in_vma(const struct folio *folio,
 		 * Note: swapoff's unuse_vma() is more efficient with this
 		 * check, and needs it to match anon_vma when KSM is active.
 		 */
-		if (!vma->anon_vma || !anon_vma ||
+		if (!vma_anon_tracked(vma) || !anon_vma ||
 		    vma->anon_vma->root != anon_vma->root)
 			return -EFAULT;
 		/* KSM folios don't reach here because of the !anon_vma check */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 01e7b6b046b6..9f9cd6657360 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2705,7 +2705,7 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
 	if (check_stable_address_space(mm))
 		goto unlock;
 	for_each_vma(vmi, vma) {
-		if (vma->anon_vma && !is_vm_hugetlb_page(vma)) {
+		if (vma_anon_tracked(vma) && !is_vm_hugetlb_page(vma)) {
 			ret = unuse_vma(vma, type);
 			if (ret)
 				break;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 79cc7b546f13..e83f4c784a57 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -145,7 +145,7 @@ static struct vm_area_struct *uffd_lock_vma(struct mm_struct *mm,
 		 * We know we're going to need to use anon_vma, so check
 		 * that early.
 		 */
-		if (!(vma->vm_flags & VM_SHARED) && unlikely(!vma->anon_vma))
+		if (!(vma->vm_flags & VM_SHARED) && unlikely(!vma_anon_tracked(vma)))
 			vma_end_read(vma);
 		else
 			return vma;
diff --git a/mm/vma.c b/mm/vma.c
index 55917d097933..9753fdad9f9c 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -100,7 +100,8 @@ static bool vma_is_fork_child(struct vm_area_struct *vma)
 	 * parents. This can improve scalability caused by the anon_vma root
 	 * lock.
 	 */
-	return vma && vma->anon_vma && !list_is_singular(&vma->anon_vma_chain);
+	return vma && vma_anon_tracked(vma) &&
+		!list_is_singular(&vma->anon_vma_chain);
 }
 
 static inline bool is_mergeable_vma(struct vma_merge_struct *vmg, bool merge_next)
@@ -140,7 +141,7 @@ static bool is_mergeable_anon_vma(struct vma_merge_struct *vmg, bool merge_next)
 	VM_WARN_ON(src && src_anon != src->anon_vma);
 
 	/* Case 1 - we will dup_anon_vma() from src into tgt. */
-	if (!tgt_anon && src_anon) {
+	if (!vma_anon_tracked(tgt) && src_anon) {
 		struct vm_area_struct *copied_from = vmg->copied_from;
 
 		if (vma_is_fork_child(src))
@@ -151,7 +152,7 @@ static bool is_mergeable_anon_vma(struct vma_merge_struct *vmg, bool merge_next)
 		return true;
 	}
 	/* Case 2 - we will simply use tgt's anon_vma. */
-	if (tgt_anon && !src_anon)
+	if (vma_anon_tracked(tgt) && !src_anon)
 		return !vma_is_fork_child(tgt);
 	/* Case 3 - the anon_vma's are already shared. */
 	return src_anon == tgt_anon;
@@ -190,10 +191,10 @@ static void init_multi_vma_prep(struct vma_prepare *vp,
 		adjust = NULL;
 
 	vp->adj_next = adjust;
-	if (!vp->anon_vma && adjust)
+	if (!vma_anon_tracked(vma) && adjust)
 		vp->anon_vma = adjust->anon_vma;
 
-	VM_WARN_ON(vp->anon_vma && adjust && adjust->anon_vma &&
+	VM_WARN_ON(vma_anon_tracked(vma) && adjust && vma_anon_tracked(adjust) &&
 		   vp->anon_vma != adjust->anon_vma);
 
 	vp->file = vma->vm_file;
@@ -430,7 +431,7 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 				      vp->remove->vm_end);
 			fput(vp->file);
 		}
-		if (vp->remove->anon_vma)
+		if (vma_anon_tracked(vp->remove))
 			unlink_anon_vmas(vp->remove);
 		mm->map_count--;
 		mpol_put(vma_policy(vp->remove));
@@ -500,7 +501,7 @@ static bool can_vma_merge_right(struct vma_merge_struct *vmg,
 	 * We therefore check this in addition to mergeability to either side.
 	 */
 	prev = vmg->prev;
-	return !prev->anon_vma || !next->anon_vma ||
+	return !vma_anon_tracked(prev) || !vma_anon_tracked(next) ||
 		prev->anon_vma == next->anon_vma;
 }
 
@@ -670,7 +671,7 @@ static int dup_anon_vma(struct vm_area_struct *dst,
 	 * that is it is unfaulted, we need to ensure that the newly merged
 	 * range is referenced by the anon_vma's of the source.
 	 */
-	if (src->anon_vma && !dst->anon_vma) {
+	if (vma_anon_tracked(src) && !vma_anon_tracked(dst)) {
 		int ret;
 
 		vma_assert_write_locked(dst);
@@ -720,7 +721,7 @@ void validate_mm(struct mm_struct *mm)
 		}
 
 #ifdef CONFIG_DEBUG_VM_RB
-		if (anon_vma) {
+		if (vma_anon_tracked(vma)) {
 			anon_vma_lock_read(anon_vma);
 			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 				anon_rmap_tree_verify(avc);
@@ -1019,7 +1020,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 		 * simply a case of, if prev has no anon_vma object, which of
 		 * next or middle contains the anon_vma we must duplicate.
 		 */
-		err = dup_anon_vma(prev, next->anon_vma ? next : middle,
+		err = dup_anon_vma(prev, vma_anon_tracked(next) ? next : middle,
 				   &anon_dup);
 	} else if (merge_left) {
 		/*
@@ -1957,7 +1958,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	 * If a vma has not yet been faulted, update its anonymous pgoff to
 	 * match the new location to increase its chance of merging.
 	 */
-	if (!vma->anon_vma) {
+	if (!vma_anon_tracked(vma)) {
 		anon_pgoff = addr >> PAGE_SHIFT;
 
 		if (vma_is_anonymous(vma)) {
@@ -2369,7 +2370,7 @@ int mm_take_all_locks(struct mm_struct *mm)
 	for_each_vma(vmi, vma) {
 		if (signal_pending(current))
 			goto out_unlock;
-		if (vma->anon_vma)
+		if (vma_anon_tracked(vma))
 			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 				vm_lock_anon_vma(mm, avc->anon_vma);
 	}
@@ -2431,7 +2432,7 @@ void mm_drop_all_locks(struct mm_struct *mm)
 	BUG_ON(!mutex_is_locked(&mm_all_locks_mutex));
 
 	for_each_vma(vmi, vma) {
-		if (vma->anon_vma)
+		if (vma_anon_tracked(vma))
 			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 				vm_unlock_anon_vma(avc->anon_vma);
 		if (vma->vm_file && vma->vm_file->f_mapping)
@@ -3458,7 +3459,7 @@ int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 	 * Similarly in do_mmap and in do_brk_flags.
 	 */
 	if (vma_is_anonymous(vma)) {
-		WARN_ON_ONCE(vma->anon_vma);
+		WARN_ON_ONCE(vma_anon_tracked(vma));
 		vma_set_pgoff(vma, vma->vm_start >> PAGE_SHIFT);
 	}
 	vma_set_anon_pgoff(vma, vma->vm_start >> PAGE_SHIFT);
diff --git a/mm/vma.h b/mm/vma.h
index e97bd2dfa786..6e1c0aa71af0 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -255,6 +255,26 @@ static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
 	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
 }
 
+/**
+ * vma_anon_tracked() - is @vma tracked by an anon_vma?
+ * @vma: The VMA to be checked.
+ *
+ * A VMA or mmap lock must be held.
+ *
+ * It will not give a false positive. However, if only a read lock is held, it
+ * may give a false negative, in which case it should be re-checked with
+ * mm->page_table_lock held.
+ *
+ * Returns true if @vma is tracked by an anon_vma, otherwise false.
+ */
+static inline bool vma_anon_tracked(const struct vm_area_struct *vma)
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
@@ -268,7 +288,7 @@ static inline void assert_sane_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
 	if (!vma_is_anonymous(vma))
 		return;
 	/* If faulted in, could have been remapped. */
-	if (vma->anon_vma)
+	if (vma_anon_tracked(vma))
 		return;
 	/* OK this is really an anon VMA - expect virtual page offset. */
 	VM_WARN_ON_ONCE(pgoff != vma->vm_start >> PAGE_SHIFT);
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 16c09dac59d9..17505bcf9cf6 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1179,7 +1179,7 @@ static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
 	return mas_find(&vmi->mas, ULONG_MAX);
 }
 
-static inline bool vma_is_attached(struct vm_area_struct *vma)
+static inline bool vma_is_attached(const struct vm_area_struct *vma)
 {
 	return refcount_read(&vma->vm_refcnt);
 }
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

---
base-commit: b02c77c78ff74d3d88ea614335ae833e01ed5d30
change-id: 20260909-vma-is-faulted-3ed004535970

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


