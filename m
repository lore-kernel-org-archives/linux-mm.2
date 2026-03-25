Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD75C103A9AD
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 11:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 256946B00A1; Wed, 25 Mar 2026 07:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22DAE6B00A2; Wed, 25 Mar 2026 07:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143416B00A3; Wed, 25 Mar 2026 07:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 045A16B00A1
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:42:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8920A1608A9
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:42:37 +0000 (UTC)
X-FDA: 84584397954.22.74606DD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9AD6018000C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:42:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VUKDUwMM;
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VUKDUwMM;
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774438955; a=rsa-sha256;
	cv=none;
	b=ax74qRNdHwo3YRdc3OkKeRtZMtqsH/ChWgfW0XlPCjdtD90OOJZ7pmFrSH7rsK2K5Vkiby
	AFXjktDmGaE17fxJNfafBcnySvszvBgF8UntqZHpT9G/4ucGn4beUXtaAaJpAkJSZUJbfz
	zQDEDzjPz5rsj9uC107a2gjbD8Xz2WI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774438955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qkmjhafQ5ISCRajjpMDTMb7eH4ctQIZNWYKiDpq7pM4=;
	b=YkoWBrrPZxLSLIU4WR4h5p7+CKWm41suzSn8P6BJ5IpO0R3fUXLemvj0T5MOC2FYIZShbc
	5VjDC4XMVSnn6MtU/T4omu9CQ8Tn1wX0zW+Su0B4CTi8dQO8uSGLnTFYv/JnGEimYg9hYo
	Cl6hn1b4brz2CFEuXkceMotY+HO0Tfw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774438955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qkmjhafQ5ISCRajjpMDTMb7eH4ctQIZNWYKiDpq7pM4=;
	b=VUKDUwMMnnAPeM++u96Tyk0b9DWhNVw2Doq3IgDW5sYhfgC5n8PAkNHp3C9R8GRCQSxOLn
	0R6HzptQYTT4hw4POcXEXAnFpaGb/ipF8WpDAVetRISDCsQbgftlq0z1HW9GSpb5E1UIDc
	0V5lb2Z7MKVv435BAwNZE7yBjonaWw0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-500-H365NjHQMzutCak1FobmAA-1; Wed,
 25 Mar 2026 07:42:30 -0400
X-MC-Unique: H365NjHQMzutCak1FobmAA-1
X-Mimecast-MFC-AGG-ID: H365NjHQMzutCak1FobmAA_1774438945
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C34E819560B5;
	Wed, 25 Mar 2026 11:42:24 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.2.14.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7EABF18002A6;
	Wed, 25 Mar 2026 11:42:08 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jackmanb@google.com,
	jack@suse.cz,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: [PATCH mm-unstable v4 5/5] mm/khugepaged: unify khugepaged and madv_collapse with collapse_single_pmd()
Date: Wed, 25 Mar 2026 05:40:22 -0600
Message-ID: <20260325114022.444081-6-npache@redhat.com>
In-Reply-To: <20260325114022.444081-1-npache@redhat.com>
References: <20260325114022.444081-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SPUO0jfBWkLim0Ep6Iojz1_3Tlu7rv2frbjEdXLndA4_1774438945
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9AD6018000C
X-Stat-Signature: 4r8ijduhti7ockzx68mmeymkiziwme65
X-Rspam-User: 
X-HE-Tag: 1774438955-820169
X-HE-Meta: U2FsdGVkX1/cabO79fpc9WW4NogTvayHmhov4AobEpmfwU4nJiJ9x7y0vXe4DIn5XAQmPh/KOtSEbaMZ8MaI+8I1FC1bfwYRzCm4Eeq9T2+mHJpKHD+E0z+9L41SXaZBq6oLkweuzVAPwDgwo59xT+MFnyTm5bu2gNjhGnldZMuEZDs2e9q+wfKsEdlpAdDwtdqB5g6n1r9n9LUdjDXBhp+O57AA8uhGY8Tz7nwXjNdcRYzbclZQ8kcU/xjZkKjerqc/X4u8dX97KTelNDhB9AWYSjgO5VZuYtBNFUo27/Z7Trb2AxEqBJWb+FCmXEN3BNX6xmzOtzcRrKf49OQ9a1sMLlKyzh5Z6s/W+WC7ZvWdLYwJJEUN5XkrYfNjSBterbGjYLJcbZHjCu0Rw1DESubNp3fQ/FmcrJcSrqPGigY86VQmHlXM0caihpraA111MxKaU59hfkPe3/jEoMG9/WgruDKGfEvhcAB47wLXik1m/p+5WNH+vOS05k2KdOE9TW8LZWCS6EWdj4N+2/xom8CyIVdBblcTYCwAiPx2yI2/MjOE/joaEabGv86EFMhpYNBbUUKJF3KnwN+4EKdavMJIfaS08mnT+XXHXE+pQmM48S/aIUHNSC4alib15tNE79Acz3SXuBe05IK+xj7OLrK//guODQynfJbpOHWnH+tVjTpn4dzVY1rZU9Y8p0chdKwS7fZ5aE+WeAhbRFNM2QyPpP+F0JOw1JWnwZkNuLaGhDzXVk1aSBLZVIrlOj71NaOAAAuN9MKUVqH6H9t2TicG8zulrJo9pAEHUEi7FEDj8QB5mPEfa3xRhRskV/9LO5Nrbr1TyABkOetrdNOb1tL/iZEC5LWut11WY7+9wJ5dYiMj0K5zfF43sgD4FviBhypBP2WDqEJBsp1E2U9p5HLUnOl4EUrU7nVuElA3ZHWl0C+EjdN1iRw7RPWxKqfNIvezhYiOnzst+dJ5/EG
 w1XGC76r
 VL7rT+jKnyPWS9g9Grj5ZY4MuifnweedXUBCuGKDwNIawy0AUoP7VwIqUpzORaQQ54v44KV+2+iJmszCqTY2NRrLQqkN9S+1LWIJ5SvWzK1vmzawb7E1uRR0YF0CJob2HVknTv9DwGpaz8ytkXogvTK3OwAAsy/pxK34nJ4nimCijnrO+ogtMOwtnAl0bQ2lypB1uGTOPNodJcopqMDvTO622NQ6Ja7x725oSRYCcEZAwnfs4eGoXhp4J65tXPGW4Wmk1Alwx8lfK30cpoz/qgeh6jyaUPLBMCETytcUxysXcZlYRrEfVc5KIrOxiehf1pfZnjzBH2QJAq/kIoq9HgF/UPMCwfAwXs3yYxEfEzEQQHnT5BqAZplwr4GraUgU25hf6SDC1vhvNdAFySvzTBndi2OMWHCKpnDqNPXUnqDSP3tm/d/IYlSOTcY5rOJCn2W1ZVnuypCvX8wLRDaY18rqE9w3q+L5beizx5vlNmOalfaqpZksUDt0DrcS1h5pB/ZRN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The khugepaged daemon and madvise_collapse have two different
implementations that do almost the same thing. Create collapse_single_pmd
to increase code reuse and create an entry point to these two users.

Refactor madvise_collapse and collapse_scan_mm_slot to use the new
collapse_single_pmd function. To help reduce confusion around the
mmap_locked variable, we rename mmap_locked to lock_dropped in the
collapse_scan_mm_slot() function, and remove the redundant mmap_locked
in madvise_collapse(); this further unifies the code readiblity. the
SCAN_PTE_MAPPED_HUGEPAGE enum is no longer reachable in the
madvise_collapse() function, so we drop it from the list of "continuing"
enums.

This introduces a minor behavioral change that is most likely an
undiscovered bug. The current implementation of khugepaged tests
collapse_test_exit_or_disable() before calling collapse_pte_mapped_thp,
but we weren't doing it in the madvise_collapse case. By unifying these
two callers madvise_collapse now also performs this check. We also modify
the return value to be SCAN_ANY_PROCESS which properly indicates that this
process is no longer valid to operate on.

By moving the madvise_collapse writeback-retry logic into the helper
function we can also avoid having to revalidate the VMA.

We guard the khugepaged_pages_collapsed variable to ensure its only
incremented for khugepaged.

As requested we also convert a VM_BUG_ON to a VM_WARN_ON.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 142 ++++++++++++++++++++++++------------------------
 1 file changed, 72 insertions(+), 70 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 3728a2cf133c..d06d84219e1b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1257,7 +1257,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 
 static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long start_addr,
-		bool *mmap_locked, struct collapse_control *cc)
+		bool *lock_dropped, struct collapse_control *cc)
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
@@ -1432,7 +1432,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		result = collapse_huge_page(mm, start_addr, referenced,
 					    unmapped, cc);
 		/* collapse_huge_page will return with the mmap_lock released */
-		*mmap_locked = false;
+		*lock_dropped = true;
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
@@ -2424,6 +2424,67 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	return result;
 }
 
+/*
+ * Try to collapse a single PMD starting at a PMD aligned addr, and return
+ * the results.
+ */
+static enum scan_result collapse_single_pmd(unsigned long addr,
+		struct vm_area_struct *vma, bool *lock_dropped,
+		struct collapse_control *cc)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	bool triggered_wb = false;
+	enum scan_result result;
+	struct file *file;
+	pgoff_t pgoff;
+
+	mmap_assert_locked(mm);
+
+	if (vma_is_anonymous(vma)) {
+		result = collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
+		goto end;
+	}
+
+	file = get_file(vma->vm_file);
+	pgoff = linear_page_index(vma, addr);
+
+	mmap_read_unlock(mm);
+	*lock_dropped = true;
+retry:
+	result = collapse_scan_file(mm, addr, file, pgoff, cc);
+
+	/*
+	 * For MADV_COLLAPSE, when encountering dirty pages, try to writeback,
+	 * then retry the collapse one time.
+	 */
+	if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
+	    !triggered_wb && mapping_can_writeback(file->f_mapping)) {
+		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
+		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
+
+		filemap_write_and_wait_range(file->f_mapping, lstart, lend);
+		triggered_wb = true;
+		goto retry;
+	}
+	fput(file);
+
+	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
+		mmap_read_lock(mm);
+		if (collapse_test_exit_or_disable(mm))
+			result = SCAN_ANY_PROCESS;
+		else
+			result = try_collapse_pte_mapped_thp(mm, addr,
+							     !cc->is_khugepaged);
+		if (result == SCAN_PMD_MAPPED)
+			result = SCAN_SUCCEED;
+		mmap_read_unlock(mm);
+	}
+end:
+	if (cc->is_khugepaged && result == SCAN_SUCCEED)
+		++khugepaged_pages_collapsed;
+	return result;
+}
+
 static void collapse_scan_mm_slot(unsigned int progress_max,
 		enum scan_result *result, struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
@@ -2485,46 +2546,21 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
 
 		while (khugepaged_scan.address < hend) {
-			bool mmap_locked = true;
+			bool lock_dropped = false;
 
 			cond_resched();
 			if (unlikely(collapse_test_exit_or_disable(mm)))
 				goto breakouterloop;
 
-			VM_BUG_ON(khugepaged_scan.address < hstart ||
+			VM_WARN_ON_ONCE(khugepaged_scan.address < hstart ||
 				  khugepaged_scan.address + HPAGE_PMD_SIZE >
 				  hend);
-			if (!vma_is_anonymous(vma)) {
-				struct file *file = get_file(vma->vm_file);
-				pgoff_t pgoff = linear_page_index(vma,
-						khugepaged_scan.address);
-
-				mmap_read_unlock(mm);
-				mmap_locked = false;
-				*result = collapse_scan_file(mm,
-					khugepaged_scan.address, file, pgoff, cc);
-				fput(file);
-				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
-					mmap_read_lock(mm);
-					if (collapse_test_exit_or_disable(mm))
-						goto breakouterloop;
-					*result = try_collapse_pte_mapped_thp(mm,
-						khugepaged_scan.address, false);
-					if (*result == SCAN_PMD_MAPPED)
-						*result = SCAN_SUCCEED;
-					mmap_read_unlock(mm);
-				}
-			} else {
-				*result = collapse_scan_pmd(mm, vma,
-					khugepaged_scan.address, &mmap_locked, cc);
-			}
-
-			if (*result == SCAN_SUCCEED)
-				++khugepaged_pages_collapsed;
 
+			*result = collapse_single_pmd(khugepaged_scan.address,
+						      vma, &lock_dropped, cc);
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			if (!mmap_locked)
+			if (lock_dropped)
 				/*
 				 * We released mmap_lock so break loop.  Note
 				 * that we drop mmap_lock before all hugepage
@@ -2799,7 +2835,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	unsigned long hstart, hend, addr;
 	enum scan_result last_fail = SCAN_FAIL;
 	int thps = 0;
-	bool mmap_locked = true;
 
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
@@ -2821,13 +2856,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;
-		bool triggered_wb = false;
 
-retry:
-		if (!mmap_locked) {
+		if (*lock_dropped) {
 			cond_resched();
 			mmap_read_lock(mm);
-			mmap_locked = true;
+			*lock_dropped = false;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
 							 cc);
 			if (result  != SCAN_SUCCEED) {
@@ -2837,45 +2870,14 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}
-		mmap_assert_locked(mm);
-		if (!vma_is_anonymous(vma)) {
-			struct file *file = get_file(vma->vm_file);
-			pgoff_t pgoff = linear_page_index(vma, addr);
 
-			mmap_read_unlock(mm);
-			mmap_locked = false;
-			*lock_dropped = true;
-			result = collapse_scan_file(mm, addr, file, pgoff, cc);
-
-			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
-			    mapping_can_writeback(file->f_mapping)) {
-				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
-				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
-
-				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
-				triggered_wb = true;
-				fput(file);
-				goto retry;
-			}
-			fput(file);
-		} else {
-			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, cc);
-		}
-		if (!mmap_locked)
-			*lock_dropped = true;
+		result = collapse_single_pmd(addr, vma, lock_dropped, cc);
 
-handle_result:
 		switch (result) {
 		case SCAN_SUCCEED:
 		case SCAN_PMD_MAPPED:
 			++thps;
 			break;
-		case SCAN_PTE_MAPPED_HUGEPAGE:
-			BUG_ON(mmap_locked);
-			mmap_read_lock(mm);
-			result = try_collapse_pte_mapped_thp(mm, addr, true);
-			mmap_read_unlock(mm);
-			goto handle_result;
 		/* Whitelisted set of results where continuing OK */
 		case SCAN_NO_PTE_TABLE:
 		case SCAN_PTE_NON_PRESENT:
@@ -2898,7 +2900,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 
 out_maybelock:
 	/* Caller expects us to hold mmap_lock on return */
-	if (!mmap_locked)
+	if (*lock_dropped)
 		mmap_read_lock(mm);
 out_nolock:
 	mmap_assert_locked(mm);
-- 
2.53.0


