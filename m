Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92673C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 19:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D3606B0096; Thu, 17 Sep 2026 15:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ABB76B0098; Thu, 17 Sep 2026 15:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79B4D6B0099; Thu, 17 Sep 2026 15:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F25A6B0096
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:48:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB210A04CD
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:48:40 +0000 (UTC)
X-FDA: 85224291600.12.6BAE747
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2DF4C100009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:48:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OYc4wkDf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789674519;
	b=sylknFDIGR1hEr04fSpsrscfJRDjs09VQPf/fIdsYq3KWKzvSp3RSGwpWjvq45EzVms79I
	lkZykLU1m9EOHJLlSUuq5hZhHKLl4+lHqlZeoIq7oVSfzrnQHMwBTxuQ433Ujimrx66Ott
	qehQw6iJdSecwj+wvGdOS/B0Bk7i3mQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OYc4wkDf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789674519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vQcOs8Hdw4qG+J710lveSZHuidky9NwDCke7uYl/Jhc=;
	b=U+557pibkpSPiphv7w0tRtcL5/tjSO9DzXYLFWdPMYf6ar40ttFs1+iCch95s0GgE+r3Kh
	9u5wMEzAT9+0gSmafapNBPjvJi2VTBbAvF247N6v7hql1jmX+ci8IJjZC/0OL7wHA//S6r
	nyhfXWc5qbv/Qt8SdmrK7NBn4GxMAJY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C76CD4177E;
	Thu, 17 Sep 2026 19:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F37D1F00893;
	Thu, 17 Sep 2026 19:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789674516;
	bh=vQcOs8Hdw4qG+J710lveSZHuidky9NwDCke7uYl/Jhc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OYc4wkDf5rs5k8VD5t6ioZZAINDm83e9oXTthEFWhoQwfh/iAS3TkcQV5yvnZKMKf
	 e506nFNFal7iZk38O0QifcW9KbvkvxYiMQBxLR2jQjQlxzi0EFK1r+Cq/cF+5+j4mQ
	 Pmy16tDrVIJ45gA0iBtanXAaKcLfG7X5Y8lJqpuajNvbXsgo5U/Xut7OJzHCgCYLlT
	 JKuf75g8YGuLJ8BYCnKD8spcrTBee7lE4zULbU8Qm41YafNwftSGpxSB6TlLQd9aAq
	 +zZoUviMaoDGp2MsxEEY7/ZoFw0DCrcfpnAcyzJl3WX9lbpJhE558bZGIC0nkkXTnt
	 rXx3ZomgxPnPQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 20:47:43 +0100
Subject: [PATCH v3 3/3] mm: update comments to refer to anon rmap rather
 than anon_vma
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-vma-is-faulted-v3-3-5c22314a72e7@kernel.org>
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
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=31891; i=ljs@kernel.org;
 h=from:subject:message-id; bh=u2GQNxd3QzKGYKoxK6lKCYrziDV/yFFSdu7xCLfHsBA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWOL/qmKeWGlgdlHLm5BsX7rpnW6cUTF1gZXl7j8KG8
 5vnWFRHdJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAit04x/I9+H3Iy6u99hcOm
 wm9YNaKbMvTuH2Yy1ff469B39dmlhFOMDFfmbffPKJgjd8Q3OcOQU1Ne5JuWyKtCm+5XvxPS3F4
 oMQIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2DF4C100009
X-Stat-Signature: k7k4by1p3q39h17arqnzbzcn6b7rbjan
X-HE-Tag: 1789674518-781355
X-HE-Meta: U2FsdGVkX1+lJ1r8NEKtLe2JhzmGCXf0sV1rdEfCCqH81fJHS8uecXucyLoKleHobgMeKM3KX1iut5qpMuf/thRpbvJFmm9IgcWCmbNULFiBEh8qiL9LLIKfwpnHAXt2uMJR+hBJp63kKC09P6lJos0grQzbbzuDnpXgqRFOhiNOsQCzEP3NtIaMHxR7Jdma72I3+doMz+7oKOfpt9X62fQ/IUuhwps3bQS3wk+W/Al/fadotsu8s8PMKnjxq+CP7ESfj4850Wi9jXuAQqz7J6w9LNItvpmSOmKrNXPIIbZMHYrpe6BPliihekEQGFZrhfLoxYUaFVwDmXTTUuz0L2EQQAefn8pm72RQYdKakvWehGrFEo9tiTGTxzPqXo1kqMODOANoMFZhECMgDETdX9oVjZDBB+Qq0hOD7qDXFLR9jAnPsas2qa5BSiOp6J27eoTITnHGXlgOD2xRENl299FGnsSsrVzqKzU6pHIHo9LKYDCLEDvwANxhaMnYjXZRbKbQgPW0FsS1FLO9GA9w/q4J2msfGRv1fVdSaQMixlP3zs8PfYdBozmfk7SKZQ5vTco/fZcZ5no3/rpg+rLjNAL3ZtxtAfF+XwdduUsuUPQA9sTA/oLxsiwlsr5JlCjJSGJVhA7LLQ8hQYbKIFuuZzIL08BwYfglw6aHsHYwjVLBEozsedsUPoDKDQzGku9kRHfMTNDle8mAdkMD+69MzUFTsTAzlYEf7JRIp7gOUzp6PsXGrGqzyeHJ97sPhkIcwLVQA8AcoDixNfCsZX4HV3URGkwicR6P/MGl8iD+uuEBEv1v14rCsCeoIqMxgv95N/UycicNtWAkjYzb0B690ZVuIyBvHQJJf6U5m3kDBV4LUd0AAu/TRMvaebG5tf89j+9X7TI3ZTc0tvXq9J8aYikJuO8eoGngQsGqKJ9vu/bpL2MOAEapn8c5zQrHf8fcCGtIbaES7Tgb3qJDt+3
 lVNAK1iQ
 KRos56RqSdjmzIJnCrU9X2MZ+KBfb0xwdhu4ZaxyyMeWLwuZZCiH31KrBzVIDs9mA2l/7FwvK2zhbCSkWxV1Ju9YJJk9BEFt9wHxsg60YCJps7I68HRKpYrlG9l4apS7+VhjlHoxWTWM1hfFc+IGrJv8f6oP0O3u88cZcrIW7OEUO3gJD7T5ew6/Mr3XmdKUhrJeD+ZUeX+7d7GepUPkATYsysWTnGYU+ePy2F5offUBBXdI0GHQk2Oku1CI9xocS1ooiNczEfw2jLi7VCCWwiBc8rqRkhZrS9cnPodMI7Tg3wISLSobpfVhMZXrENCPI2bOnrvzhuQkrH89DAeNpUi8TqObiPi+PacTFWfCYvIRgtSg7L9TsHROcHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that vma_has_anon_rmap() abstracts whether a VMA has an anonymous
reverse mapping, remove references to anon_vma and instead reference the
anon rmap.

The anon_vma is an implementation detail and should be treated as such.

Do not update mm/rmap.c which implements the anon_vma mechanism as it is
reasonable to directly reference it there.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c     | 17 +++++----
 mm/hugetlb.c         |  2 +-
 mm/khugepaged.c      | 12 +++----
 mm/ksm.c             |  6 ++--
 mm/madvise.c         |  6 ++--
 mm/memory.c          | 12 +++----
 mm/migrate.c         | 12 +++----
 mm/mmap.c            |  6 ++--
 mm/mprotect.c        |  4 +--
 mm/mremap.c          |  6 ++--
 mm/pgtable-generic.c |  2 +-
 mm/userfaultfd.c     | 10 +++---
 mm/vma.c             | 98 ++++++++++++++++++++++++++--------------------------
 13 files changed, 96 insertions(+), 97 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8974aaa17f22..bd7678b6d0e3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -259,10 +259,10 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 
 	/*
 	 * THPeligible bit of smaps should show 1 for proper VMAs even
-	 * though anon_vma is not initialized yet.
+	 * though they don't have an anon rmap yet.
 	 *
-	 * Allow page fault since anon_vma may be not initialized until
-	 * the first page fault.
+	 * Allow page fault since the VMA may not have an anon rmap until the
+	 * first page fault.
 	 */
 	if (!vma_has_anon_rmap(vma))
 		return (smaps || in_pf) ? orders : 0;
@@ -4176,11 +4176,10 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (is_anon) {
 		/*
 		 * The caller does not necessarily hold an mmap_lock that would
-		 * prevent the anon_vma disappearing so we first we take a
-		 * reference to it and then lock the anon_vma for write. This
-		 * is similar to folio_lock_anon_vma_read except the write lock
-		 * is taken to serialise against parallel split or collapse
-		 * operations.
+		 * prevent the anon rmap disappearing so we first we take a
+		 * reference to it and then lock it for write. This is similar
+		 * to folio_lock_anon_vma_read except the write lock is taken to
+		 * serialise against parallel split or collapse operations.
 		 */
 		anon_vma = folio_get_anon_vma(folio);
 		if (!anon_vma) {
@@ -4336,7 +4335,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  * THP pages in the middle of migration, due to allocation issues on either
  * side.
  *
- * anon_vma_lock is not required to be held, mmap_read_lock() or
+ * The anon rmap lock is not required to be held, mmap_read_lock() or
  * mmap_write_lock() should be held. @folio is expected to be locked by the
  * caller. device-private and non device-private folios are supported along
  * with folios that are in the swapcache. @folio should also be unmapped and
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a69bd463b1ae..8ceacae13e33 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5670,7 +5670,7 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 
 	/*
 	 * When the original hugepage is shared one, it does not have
-	 * anon_vma prepared.
+	 * an anon rmap prepared.
 	 */
 	ret = __vmf_anon_prepare(vmf);
 	if (unlikely(ret))
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6aaa66cea518..fd376118f452 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1340,7 +1340,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	/*
 	 * Prevent all access to pagetables with the exception of
 	 * gup_fast later handled by the pmdp_collapse_flush() and the VM
-	 * handled by the anon_vma lock + folio lock.
+	 * handled by the anon rmap lock + folio lock.
 	 *
 	 * UFFDIO_MOVE is prevented to race as well thanks to the
 	 * mmap_lock.
@@ -1407,8 +1407,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	}
 
 	/*
-	 * For PMD collapse all pages are isolated and locked so anon_vma
-	 * rmap can't run anymore. For mTHP collapse the PMD entry has been
+	 * For PMD collapse all pages are isolated and locked so the anon
+	 * rmap walk can't run anymore. For mTHP collapse the PMD entry has been
 	 * removed and not all pages are isolated and locked, so we must hold
 	 * the lock to prevent neighboring folios from attempting to access
 	 * this PMD until its reinstalled.
@@ -2206,9 +2206,9 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 
 		/*
 		 * Huge page lock is still held, so normally the page table must
-		 * remain empty; and we have already skipped anon_vma and
-		 * userfaultfd_wp() vmas.  But since the mmap_lock is not held,
-		 * it is still possible for a racing userfaultfd_ioctl() or
+		 * remain empty; and we have already skipped vmas with an anon
+		 * rmap and userfaultfd_wp() vmas.  But since the mmap_lock is not
+		 * held, it is still possible for a racing userfaultfd_ioctl() or
 		 * madvise() to have inserted ptes or markers.  Now that we hold
 		 * ptlock, repeating the retractable checks protects us from
 		 * races against the prior checks.
diff --git a/mm/ksm.c b/mm/ksm.c
index 338cd95cd2e5..2f49acaf4880 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -795,7 +795,7 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
 
 	/*
 	 * It is not an accident that whenever we want to break COW
-	 * to undo, we also need to drop a reference to the anon_vma.
+	 * to undo, we also need to drop a reference to the anon rmap.
 	 */
 	put_anon_vma(rmap_item->anon_vma);
 	/*
@@ -1415,7 +1415,7 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 		goto out;
 	/*
 	 * Some THP functions use the sequence pmdp_huge_clear_flush(), set_pmd_at()
-	 * without holding anon_vma lock for write.  So when looking for a
+	 * without holding the anon rmap lock for write.  So when looking for a
 	 * genuine pmde (in which to find pte), test present and !THP together.
 	 */
 	pmde = pmdp_get_lockless(pmd);
@@ -1619,7 +1619,7 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
 
 	/*
 	 * We can consider the VMA only while still holding the mmap lock,
-	 * so lock, so reference the anon_vma and calculate the linear
+	 * so lock, so reference the anon rmap and calculate the linear
 	 * page index early, before stable_tree_append(). If anything goes
 	 * wrong that prevents the rmap_item from being added to the
 	 * stable_tree, break_cow() will clean it up.
diff --git a/mm/madvise.c b/mm/madvise.c
index f335a47e6e02..7fce2bb2694c 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1150,7 +1150,7 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 
 	/*
 	 * If anonymous and we are establishing page tables the VMA ought to
-	 * have an anon_vma associated with it.
+	 * have an anon rmap associated with it.
 	 *
 	 * We will hold an mmap read lock if this is necessary, this is checked
 	 * as part of the VMA lock logic.
@@ -1615,8 +1615,8 @@ static bool is_vma_lock_sufficient(struct vm_area_struct *vma,
 	 * anon_vma_prepare() explicitly requires an mmap lock for
 	 * serialisation, so we cannot use a VMA lock in this case.
 	 *
-	 * Note we might race with anon_vma being set, however this makes this
-	 * check overly paranoid which is safe.
+	 * Note we might race with the anon rmap being assigned, however this
+	 * makes this check overly paranoid which is safe.
 	 */
 	if (vma_is_anonymous(vma) &&
 	    prepares_anon_vma(madv_behavior->behavior) && !vma_has_anon_rmap(vma))
diff --git a/mm/memory.c b/mm/memory.c
index 84182971f242..15be749cbbe3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1291,8 +1291,8 @@ copy_pte_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 	 * copy_pmd_range()'s prior pmd_none_or_clear_bad(src_pmd), and the
 	 * error handling here, assume that exclusive mmap_lock on dst and src
 	 * protects anon from unexpected THP transitions; with shmem and file
-	 * protected by mmap_lock-less collapse skipping areas with anon_vma
-	 * (whereas vma_needs_copy() skips areas without anon_vma).  A rework
+	 * protected by mmap_lock-less collapse skipping areas with an anon rmap
+	 * (whereas vma_needs_copy() skips areas without one).  A rework
 	 * can remove such assumptions later, but this is good enough for now.
 	 */
 	dst_pte = pte_alloc_map_lock(dst_mm, dst_pmd, addr, &dst_ptl);
@@ -1533,8 +1533,8 @@ vma_needs_copy(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 	if (dst_vma->vm_flags & VM_COPY_ON_FORK)
 		return true;
 	/*
-	 * The presence of an anon_vma indicates an anonymous VMA has page
-	 * tables which naturally cannot be reconstituted on page fault.
+	 * The presence of an anon rmap indicates the VMA may map anonymous
+	 * folios which naturally cannot be reconstituted on page fault.
 	 */
 	if (vma_has_anon_rmap(src_vma))
 		return true;
@@ -3901,10 +3901,10 @@ static inline vm_fault_t vmf_can_call_fault(const struct vm_fault *vmf)
  *
  * When preparing to insert an anonymous page into a VMA from a
  * fault handler, call this function rather than anon_vma_prepare().
- * If this vma does not already have an associated anon_vma and we are
+ * If this vma does not already have an anon rmap and we are
  * only protected by the per-VMA lock, the caller must retry with the
  * mmap_lock held.  __anon_vma_prepare() will look at adjacent VMAs to
- * determine if this VMA can share its anon_vma, and that's not safe to
+ * determine if this VMA can share its anon rmap, and that's not safe to
  * do with only the per-VMA lock held for this VMA.
  *
  * Return: 0 if fault handling can proceed.  Any other value should be
diff --git a/mm/migrate.c b/mm/migrate.c
index a369d0c95c38..2437ccdf6a14 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1175,7 +1175,7 @@ static void migrate_folio_undo_src(struct folio *src, int was_mapped,
 {
 	if (was_mapped)
 		remove_migration_ptes(src, src, 0);
-	/* Drop an anon_vma reference if we took one */
+	/* Drop an anon rmap reference if we took one */
 	if (anon_vma)
 		put_anon_vma(anon_vma);
 	if (locked)
@@ -1282,15 +1282,15 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 
 	/*
 	 * By try_to_migrate(), src->mapcount goes down to 0 here. In this case,
-	 * we cannot notice that anon_vma is freed while we migrate a page.
-	 * This get_anon_vma() delays freeing anon_vma pointer until the end
+	 * we cannot notice that the anon rmap is freed while we migrate a page.
+	 * This get_anon_vma() delays freeing the anon rmap until the end
 	 * of migration. File cache pages are no problem because of page_lock()
 	 * File Caches may use write_page() or lock_page() in migration, then,
 	 * just care Anon page here.
 	 *
 	 * Only folio_get_anon_vma() understands the subtleties of
-	 * getting a hold on an anon_vma from outside one of its mms.
-	 * But if we cannot get anon_vma, then we won't need it anyway,
+	 * getting a hold on an anon rmap from outside one of its mms.
+	 * But if we cannot get the anon rmap, then we won't need it anyway,
 	 * because that implies that the anon page is no longer mapped
 	 * (and cannot be remapped so long as we hold the page lock).
 	 */
@@ -1433,7 +1433,7 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	 * and will be freed.
 	 */
 	list_del(&src->lru);
-	/* Drop an anon_vma reference if we took one */
+	/* Drop an anon rmap reference if we took one */
 	if (anon_vma)
 		put_anon_vma(anon_vma);
 	folio_unlock(src);
diff --git a/mm/mmap.c b/mm/mmap.c
index 4bf26b0f1e6e..4b2780eaf3d0 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -547,7 +547,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 		}
 		case MAP_PRIVATE:
 			/*
-			 * Set pgoff according to addr for anon_vma.
+			 * Set pgoff according to addr for the anon rmap.
 			 */
 			pgoff = addr >> PAGE_SHIFT;
 			break;
@@ -1774,8 +1774,8 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		if (vma_test(tmp, VMA_WIPEONFORK_BIT)) {
 			/*
 			 * VMA_WIPEONFORK_BIT gets a clean slate in the child.
-			 * Don't prepare anon_vma until fault since we don't
-			 * copy page for current vma.
+			 * Don't prepare the anon rmap until fault since we
+			 * don't copy pages for the current vma.
 			 */
 			tmp->anon_vma = NULL;
 		} else if (anon_vma_fork(tmp, mpnt))
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 94a1830738de..52f2f0c1fbd3 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -797,8 +797,8 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	/*
 	 * If we make a private mapping writable we increase our commit;
 	 * but (without finer accounting) cannot reduce our commit if we
-	 * make it unwritable again except in the anonymous case where no
-	 * anon_vma has yet to be assigned.
+	 * make it unwritable again except in the anonymous case where the
+	 * VMA's anon rmap has yet to be assigned.
 	 *
 	 * hugetlb mapping were accounted for even if read-only so there is
 	 * no need to account for them here.
diff --git a/mm/mremap.c b/mm/mremap.c
index 5afc3968d22b..b1e01938b103 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -214,7 +214,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
 	int err = 0;
 
 	/*
-	 * When need_rmap_locks is true, we take the i_mmap_rwsem and anon_vma
+	 * When need_rmap_locks is true, we take the i_mmap_rwsem and anon rmap
 	 * locks to ensure that rmap will always observe either the old or the
 	 * new ptes. This is the easiest way to avoid races with
 	 * truncate_pagecache(), page migration, etc...
@@ -1339,8 +1339,8 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
 	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
 
 	/*
-	 * anon_vma links of the old vma is no longer needed after its page
-	 * table has been moved.
+	 * The anon rmap links of the old vma are no longer needed after its
+	 * page table has been moved.
 	 */
 	if (new_vma != vma && start == old_start && end == old_end) {
 		const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 224c444cf45d..b2c2583a44b7 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -349,7 +349,7 @@ pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
  * pte_offset_map_lock(mm, pmd, addr, ptlp) is usually called with the pmd
  * pointer for addr, reached by walking down the mm's pgd, p4d, pud for addr:
  * either while holding mmap_lock or vma lock for read or for write; or in
- * truncate or rmap context, while holding file's i_mmap_lock or anon_vma lock
+ * truncate or rmap context, while holding file's i_mmap_lock or anon rmap lock
  * for read (or for write). In a few cases, it may be used with pmd pointing to
  * a pmd_t already copied to or constructed on the stack.
  *
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index b5698cce5314..617247771d6b 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -130,7 +130,7 @@ struct vm_area_struct *find_vma_and_prepare_anon(struct mm_struct *mm,
  * Should be called without holding mmap_lock.
  *
  * Return: A locked vma containing @address, -ENOENT if no vma is found,
- * -ENOMEM if anon_vma couldn't be allocated, or -EAGAIN if vma refcount
+ * -ENOMEM if the anon rmap couldn't be allocated, or -EAGAIN if vma refcount
  * overflow happened due to high number of readers and the caller should
  * retry later.
  */
@@ -142,8 +142,8 @@ static struct vm_area_struct *uffd_lock_vma(struct mm_struct *mm,
 	vma = lock_vma_under_rcu(mm, address);
 	if (vma) {
 		/*
-		 * We know we're going to need to use anon_vma, so check
-		 * that early.
+		 * We know we're going to need an anon rmap, so check that
+		 * early.
 		 */
 		if (!(vma->vm_flags & VM_SHARED) && unlikely(!vma_has_anon_rmap(vma)))
 			vma_end_read(vma);
@@ -1680,7 +1680,7 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 		/*
 		 * Verify the existence of the swapcache. If present, the folio's
 		 * index and mapping must be updated even when the PTE is a swap
-		 * entry. The anon_vma lock is not taken during this process since
+		 * entry. The anon rmap lock is not taken during this process since
 		 * the folio has already been unmapped, and the swap entry is
 		 * exclusive, preventing rmap walks.
 		 *
@@ -1909,7 +1909,7 @@ static void uffd_move_unlock(struct vm_area_struct *dst_vma,
  *
  * move_pages() remaps arbitrary anonymous pages atomically in zero
  * copy. It only works on non shared anonymous pages because those can
- * be relocated without generating non linear anon_vmas in the rmap
+ * be relocated without generating non linear anon rmaps in the rmap
  * code.
  *
  * It provides a zero copy mechanism to handle userspace page faults.
diff --git a/mm/vma.c b/mm/vma.c
index f9386f9f2353..9036ba7be199 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -97,7 +97,7 @@ static bool vma_is_fork_child(struct vm_area_struct *vma)
 {
 	/*
 	 * The list_is_singular() test is to avoid merging VMA cloned from
-	 * parents. This can improve scalability caused by the anon_vma root
+	 * parents. This can improve scalability caused by the anon rmap root
 	 * lock.
 	 */
 	return vma && vma_has_anon_rmap(vma) &&
@@ -135,7 +135,7 @@ static bool is_mergeable_anon_vma(struct vma_merge_struct *vmg, bool merge_next)
 
 	/*
 	 * We _can_ have !src, vmg->anon_vma via copy_vma(). In this instance we
-	 * will remove the existing VMA's anon_vma's so there's no scalability
+	 * will remove the existing VMA's anon rmap so there's no scalability
 	 * concerns.
 	 */
 	VM_WARN_ON(src && src_anon != src->anon_vma);
@@ -151,10 +151,10 @@ static bool is_mergeable_anon_vma(struct vma_merge_struct *vmg, bool merge_next)
 
 		return true;
 	}
-	/* Case 2 - we will simply use tgt's anon_vma. */
+	/* Case 2 - we will simply use tgt's anon rmap. */
 	if (vma_has_anon_rmap(tgt) && !src_anon)
 		return !vma_is_fork_child(tgt);
-	/* Case 3 - the anon_vma's are already shared. */
+	/* Case 3 - src and tgt already share an anon rmap. */
 	return src_anon == tgt_anon;
 }
 
@@ -228,8 +228,8 @@ static bool needs_adjacent_anon_pgoff(const struct vma_merge_struct *vmg)
  * Return true if we can merge this (vma_flags,anon_vma,file,vm_pgoff)
  * in front of (at a lower virtual address and file offset than) the vma.
  *
- * We cannot merge two vmas if they have differently assigned (non-NULL)
- * anon_vmas, nor if same anon_vma is assigned but offsets incompatible.
+ * We cannot merge two vmas if they have differently assigned anon rmaps,
+ * nor if the same anon rmap is assigned but offsets incompatible.
  *
  * We don't check here for the merged mmap wrapping around the end of pagecache
  * indices (16TB on ia32) because do_mmap() does not permit mmap's which
@@ -255,8 +255,8 @@ static bool can_vma_merge_before(struct vma_merge_struct *vmg)
  * Return true if we can merge this (vma_flags,anon_vma,file,vm_pgoff)
  * beyond (at a higher virtual address and file offset than) the vma.
  *
- * We cannot merge two vmas if they have differently assigned (non-NULL)
- * anon_vmas, nor if same anon_vma is assigned but offsets incompatible.
+ * We cannot merge two vmas if they have differently assigned anon rmaps,
+ * nor if the same anon rmap is assigned but offsets incompatible.
  *
  * We assume that vma is not removed as part of the merge.
  */
@@ -300,18 +300,18 @@ static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 }
 
 /*
- * vma has some anon_vma assigned, and is already inserted on that
- * anon_vma's interval trees.
+ * vma has an anon rmap assigned, and is already inserted on its interval
+ * trees.
  *
  * Before updating the vma's vm_start / vm_end / vm_pgoff fields, the
- * vma must be removed from the anon_vma's interval trees using
+ * vma must be removed from the anon rmap's interval trees using
  * anon_rmap_tree_pre_update_vma().
  *
  * After the update, the vma will be reinserted using
  * anon_rmap_tree_post_update_vma().
  *
  * The entire update must be protected by exclusive mmap_lock and by
- * the root anon_vma's mutex.
+ * the anon rmap root lock.
  */
 static void
 anon_rmap_tree_pre_update_vma(struct vm_area_struct *vma)
@@ -479,7 +479,7 @@ static bool can_vma_merge_left(struct vma_merge_struct *vmg)
  * account the end position of the proposed range.
  *
  * In addition, if we can merge with the left VMA, ensure that left and right
- * anon_vma's are also compatible.
+ * anon rmaps are also compatible.
  */
 static bool can_vma_merge_right(struct vma_merge_struct *vmg,
 				bool can_merge_left)
@@ -495,7 +495,7 @@ static bool can_vma_merge_right(struct vma_merge_struct *vmg,
 
 	/*
 	 * If we can merge with prev (left) and next (right), indicating that
-	 * each VMA's anon_vma is compatible with the proposed anon_vma, this
+	 * each VMA's anon rmap is compatible with the proposed anon rmap, this
 	 * does not mean prev and next are compatible with EACH OTHER.
 	 *
 	 * We therefore check this in addition to mergeability to either side.
@@ -645,8 +645,8 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 }
 
 /*
- * dup_anon_vma() - Helper function to duplicate anon_vma on VMA merge in the
- * instance that the destination VMA has no anon_vma but the source does.
+ * dup_anon_vma() - Helper function to duplicate the anon rmap on VMA merge in
+ * the instance that the destination VMA has no anon rmap but the source does.
  *
  * @dst: The destination VMA
  * @src: The source VMA
@@ -659,17 +659,17 @@ static int dup_anon_vma(struct vm_area_struct *dst,
 {
 	/*
 	 * There are three cases to consider for correctly propagating
-	 * anon_vma's on merge.
+	 * anon rmaps on merge.
 	 *
-	 * The first is trivial - neither VMA has anon_vma, we need not do
+	 * The first is trivial - neither VMA has an anon rmap, we need not do
 	 * anything.
 	 *
-	 * The second where both have anon_vma is also a no-op, as they must
+	 * The second where both have an anon rmap is also a no-op, as they must
 	 * then be the same, so there is simply nothing to copy.
 	 *
-	 * Here we cover the third - if the destination VMA has no anon_vma,
+	 * Here we cover the third - if the destination VMA has no anon rmap,
 	 * that is it is unfaulted, we need to ensure that the newly merged
-	 * range is referenced by the anon_vma's of the source.
+	 * range is referenced by the anon rmap of the source.
 	 */
 	if (vma_has_anon_rmap(src) && !vma_has_anon_rmap(dst)) {
 		int ret;
@@ -1016,9 +1016,9 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 		vmg->anon_pgoff = vma_start_anon_pgoff(prev);
 
 		/*
-		 * We already ensured anon_vma compatibility above, so now it's
-		 * simply a case of, if prev has no anon_vma object, which of
-		 * next or middle contains the anon_vma we must duplicate.
+		 * We already ensured anon rmap compatibility above, so now it's
+		 * simply a case of, if prev has no anon rmap, which of next or
+		 * middle contains the anon rmap we must duplicate.
 		 */
 		err = dup_anon_vma(prev, vma_has_anon_rmap(next) ? next : middle,
 				   &anon_dup);
@@ -1084,7 +1084,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 		unlink_anon_vmas(anon_dup);
 
 	/*
-	 * This means we have failed to clone anon_vma's correctly, but no
+	 * This means we have failed to clone the anon rmap correctly, but no
 	 * actual changes to VMAs have occurred, so no harm no foul - if the
 	 * user doesn't want this reported and instead just wants to give up on
 	 * the merge, allow it.
@@ -1279,7 +1279,7 @@ int vma_expand(struct vma_merge_struct *vmg)
 
 	/*
 	 * If we are removing the next VMA or copying from a VMA
-	 * (e.g. mremap()'ing), we must propagate anon_vma state.
+	 * (e.g. mremap()'ing), we must propagate anon rmap state.
 	 *
 	 * Note that, by convention, callers ignore OOM for this case, so
 	 * we don't need to account for vmg->give_up_on_mm here.
@@ -2041,16 +2041,16 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 
 /*
  * Rough compatibility check to quickly see if it's even worth looking
- * at sharing an anon_vma.
+ * at sharing an anon rmap.
  *
  * They need to have the same vm_file, and the flags can only differ
  * in things that mprotect may change.
  *
- * NOTE! The fact that we share an anon_vma doesn't _have_ to mean that
+ * NOTE! The fact that we share an anon rmap doesn't _have_ to mean that
  * we can merge the two vma's. For example, we refuse to merge a vma if
  * there is a vm_ops->close() function, because that indicates that the
  * driver is doing some kind of reference counting. But that doesn't
- * really matter for the anon_vma sharing case.
+ * really matter for the anon rmap sharing case.
  */
 static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *b)
 {
@@ -2083,13 +2083,13 @@ static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *
 }
 
 /*
- * Do some basic sanity checking to see if we can re-use the anon_vma
+ * Do some basic sanity checking to see if we can re-use the anon rmap
  * from 'old'. The 'a'/'b' vma's are in VM order - one of them will be
  * the same as 'old', the other will be the new one that is trying
- * to share the anon_vma.
+ * to share the anon rmap.
  *
  * NOTE! This runs with mmap_lock held for reading, so it is possible that
- * the anon_vma of 'old' is concurrently in the process of being set up
+ * the anon rmap of 'old' is concurrently in the process of being set up
  * by another page fault trying to merge _that_. But that's ok: if it
  * is being set up, that automatically means that it will be a singleton
  * acceptable for merging, so we can do all of this optimistically. But
@@ -2103,8 +2103,8 @@ static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *
  * accessing an uninitialised anon_vma's fields may result in a UAF.
  *
  * IOW: that the "list_is_singular()" test on the anon_vma_chain only
- * matters for the 'stable anon_vma' case (ie the thing we want to avoid
- * is to return an anon_vma that is "complex" due to having gone through
+ * matters for the 'stable anon rmap' case (ie the thing we want to avoid
+ * is to return an anon rmap that is "complex" due to having gone through
  * a fork).
  *
  * We also make sure that the two vma's are compatible (adjacent,
@@ -2127,10 +2127,10 @@ static struct anon_vma *reusable_anon_vma(struct vm_area_struct *old,
 
 /*
  * find_mergeable_anon_vma is used by anon_vma_prepare, to check
- * neighbouring vmas for a suitable anon_vma, before it goes off
- * to allocate a new anon_vma.  It checks because a repetitive
+ * neighbouring vmas for a suitable anon rmap, before it goes off
+ * to allocate a new anon rmap.  It checks because a repetitive
  * sequence of mprotects and faults may otherwise lead to distinct
- * anon_vmas being allocated, preventing vma merge in subsequent
+ * anon rmaps being allocated, preventing vma merge in subsequent
  * mprotect.
  */
 struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *vma)
@@ -2156,13 +2156,13 @@ struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *vma)
 
 	/*
 	 * We might reach here with anon_vma == NULL if we can't find
-	 * any reusable anon_vma.
+	 * any reusable anon rmap.
 	 * There's no absolute need to look only at touching neighbours:
-	 * we could search further afield for "compatible" anon_vmas.
+	 * we could search further afield for "compatible" anon rmaps.
 	 * But it would probably just be a waste of time searching,
-	 * or lead to too many vmas hanging off the same anon_vma.
+	 * or lead to too many vmas hanging off the same anon rmap.
 	 * We're trying to allow mprotect remerging later on,
-	 * not trying to minimize memory used for anon_vmas.
+	 * not trying to minimize memory used for anon rmaps.
 	 */
 	return anon_vma;
 }
@@ -2258,7 +2258,7 @@ static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
 		/*
 		 * We can safely modify head.next after taking the
 		 * anon_vma->root->rwsem. If some other vma in this mm shares
-		 * the same anon_vma we won't take it again.
+		 * the same anon rmap we won't take it again.
 		 *
 		 * No need of atomic instructions here, head.next
 		 * can't change from under us thanks to the
@@ -2300,14 +2300,14 @@ static void vm_lock_mapping(struct mm_struct *mm, struct address_space *mapping)
  * mmap_lock in write mode is required in order to block all operations
  * that could modify pagetables and free pages without need of
  * altering the vma layout. It's also needed in write mode to avoid new
- * anon_vmas to be associated with existing vmas.
+ * anon rmaps being associated with existing vmas.
  *
  * A single task can't take more than one mm_take_all_locks() in a row
  * or it would deadlock.
  *
  * The LSB in anon_vma->rb_root.rb_node and the AS_MM_ALL_LOCKS bitflag in
  * mapping->flags avoid to take the same lock twice, if more than one
- * vma in this mm is backed by the same anon_vma or address_space.
+ * vma in this mm is backed by the same anon rmap or address_space.
  *
  * We take locks in following order, accordingly to comment at beginning
  * of mm/rmap.c:
@@ -3285,7 +3285,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 	if (next && vma_is_accessible(next)) {
 		if (!vma_test(next, VMA_GROWSUP_BIT))
 			return -ENOMEM;
-		/* Check that both stack segments have the same anon_vma? */
+		/* Check that both stack segments have the same anon rmap? */
 	}
 
 	if (next)
@@ -3295,7 +3295,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 	if (vma_iter_prealloc(&vmi, vma))
 		return -ENOMEM;
 
-	/* We must make sure the anon_vma is allocated. */
+	/* We must make sure the anon rmap is allocated. */
 	if (unlikely(anon_vma_prepare(vma))) {
 		vma_iter_free(&vmi);
 		return -ENOMEM;
@@ -3358,7 +3358,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 
 	/* Enforce stack_guard_gap */
 	prev = vma_prev(&vmi);
-	/* Check that both stack segments have the same anon_vma? */
+	/* Check that both stack segments have the same anon rmap? */
 	if (prev) {
 		if (!vma_test(prev, VMA_GROWSDOWN_BIT) &&
 		    vma_is_accessible(prev) &&
@@ -3373,7 +3373,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 	if (vma_iter_prealloc(&vmi, vma))
 		return -ENOMEM;
 
-	/* We must make sure the anon_vma is allocated. */
+	/* We must make sure the anon rmap is allocated. */
 	if (unlikely(anon_vma_prepare(vma))) {
 		vma_iter_free(&vmi);
 		return -ENOMEM;
@@ -3448,7 +3448,7 @@ int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 
 	/*
 	 * The vm_pgoff of a purely anonymous vma should be irrelevant
-	 * until its first write fault, when page's anon_vma and index
+	 * until its first write fault, when page's anon rmap and index
 	 * are set.  But now set the vm_pgoff it will almost certainly
 	 * end up with (unless mremap moves it elsewhere before that
 	 * first wfault), so /proc/pid/maps tells a consistent story.

-- 
2.55.0


