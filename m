Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCF02FD45FE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 01:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3619A6B0093; Wed, 25 Feb 2026 20:31:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 314F06B0095; Wed, 25 Feb 2026 20:31:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2009C6B0096; Wed, 25 Feb 2026 20:31:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D1E56B0093
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:31:44 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C05BA1A046F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:31:43 +0000 (UTC)
X-FDA: 84484880886.08.D7BDDA6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 95059120007
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:31:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S1oAayho;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772069501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QWbQCLxFNetZtUZHWAH4m1E3X7v7coqtVj+kPPc/xwk=;
	b=Q55WOsC+vbcdkzDihuKooss1v7xMfNxC8pfXB3pglC/weH0Z0ot28oDe/NwkyzpHKiGEpf
	wS9iOdsEK1JZ8yEpqzFCPu7uywDcOvaCRqhvW2d4EpePfaCkJLBj/dpo2siYKKE0Ef5tp/
	VPUyQ/CtrmQoQ7ORRDzm+h9I1C8An08=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S1oAayho;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772069501; a=rsa-sha256;
	cv=none;
	b=4sEACV3mAc+RRNM4DVJy/St0QW5AGGftHZ5uUwx90N2Je1TRSj/qPhnu1XNwPKKpT7TmgX
	Mw0U5Yfh+KYjEcSIP2xI2H0Kzfw2HCN6lT26wy44MC1wZWhaNCOHbvJ2uYtvvgP4g7vMCU
	kwfuH5yq1gZQwFMQOniuKr7dmbtAHAU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772069501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QWbQCLxFNetZtUZHWAH4m1E3X7v7coqtVj+kPPc/xwk=;
	b=S1oAayhoi9fAVmkjdMOUb14g4ek2HzBxsPL7d6GDFGHXf/z3aXY9T+fREvcYspqVe2iEqO
	LBmZpHxDLfHcH+90JCSoDj1Ll6k7tQgtjBIVSWi+8sa+OWqkzO1hdo9m3LICNldON/FS39
	4wNUs4e7Tl9leO1uTTKj+cmHrwV3igk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-570-XD8WHFoGPOux5x1ljMxdrQ-1; Wed,
 25 Feb 2026 20:31:38 -0500
X-MC-Unique: XD8WHFoGPOux5x1ljMxdrQ-1
X-Mimecast-MFC-AGG-ID: XD8WHFoGPOux5x1ljMxdrQ_1772069493
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B60661956094;
	Thu, 26 Feb 2026 01:31:32 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.173])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1CB903003D91;
	Thu, 26 Feb 2026 01:31:21 +0000 (UTC)
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
	zokeefe@google.com
Subject: [PATCH mm-unstable v2 5/5] mm/khugepaged: unify khugepaged and madv_collapse with collapse_single_pmd()
Date: Wed, 25 Feb 2026 18:29:29 -0700
Message-ID: <20260226012929.169479-6-npache@redhat.com>
In-Reply-To: <20260226012929.169479-1-npache@redhat.com>
References: <20260226012929.169479-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Hc91JIuEyH-rSpn-eclnbcjDOy3E8qgLemprGzRcCec_1772069493
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 95059120007
X-Stat-Signature: m55wjzdw59isqkzed5aqh5yepkg5xizi
X-HE-Tag: 1772069501-391888
X-HE-Meta: U2FsdGVkX1/sYoz84CvQUbnUrupZIdvYpy0NzULxFCShb0NrY5G6DOvSQjkuGbsi+RxxQtq3ceWtlOROsStuMcflPDv4EK4smE4Abs0BNclhBR6spf4ZGE7CdxF8NxQMLJ6k4EpMP1P4e6+D842vxgex0WMDPBQOc5S3+5wgM2uieKadMhwr5PLyuSRT/ef4Q9pPuaewvrgksKvcBrTLyGPqDYUMr9Kc29DoHe5agcr6SejqP8FrZ0sjXoMhaTXwk4igmmgOU4aFRyxGWbWvQmvllejUxyFxcLyNXGKtn5LkCEodcxkCg95SXEHCTK9tC8QztOVYt+GbrhO8ONrqnIrCbkLMewZbuJCvSahQ0ynRhnSPp/RTwJ4gfvvtGRyjSBTT+qvFewvZcMiWVUgHdKvxulhRMCSqt8uyqDh2wpoH5yXAG9q7z++aQ1dgj9iRI5oMtywV1lfPP5K5hLWUstqLZ9CWbk/lIpPtsjNZAieb1A0mtoOSU9d2l3YoUs1EdiBGilO0olGAlM4rq4v9NFD/P68UyhFPnTI6kxuTeMYozrRM4h5k6dmrsXKPOdoOX4iNdZngoLD0gFAqLOPs0+81CddqFJeaRmfFufzZrob38BnI+M7CJEmoinh0hixTmlQUIcxuI3AAV8ASqRtc0PokQvfmBAMHo36aLtHvznpV8WfOghpbbF5XgBcga3vpfwIgH5ZcOReTfgZl3kxln2N4a3X3SPP7rTZ18WWS4wW9y9iSdir+otAaeq17jIYXJi4zbj2lSDbKLFZgHoVqHspOKr/INlUeKq3WbS9LjidwDSiQhK1BYhb8vjnC4WZixZ4Njeo7k/lnzaGSoCjUuRjX6L7w651t+KB1dHeZRBXjsn+yAGNnJ1ENG9tYlGYXn1WEniL/lkgSybIQbF44MWkCXsBffZMOuGlHcNS9mZZfucfr8EvZm1MHr2ec+JC648U1VyWbSkKpnAEew6Y
 DlqdTWjK
 PmOnrKz454DiVIwe0S4uFOxIQtBVgebqVmcONLGzYgdxkyTlyXzmaHkeBJovX++q/MiEGVNcM4sZTbCJ+bSrHZ3a/SJ4RQx/caxE6iCBCKIXXdm1E9XN1pP4/4bzEDikp72gI5HOZ33yXR63QB3IUlYq3Joz7++My+zECXF8L2JNnEXdlMqvn3L1qBMeFkS422G6EFiK7VX8w2/16RcMG1rqs4vcUaFn0w8H8t9NAZYjRQmPQZgah/PijIPfD1re3hL0ZyDO7zJoUvZoAhN6fY5aaa0/w6/KoEnFMNiv0tJPECyuI0L9TjF7GqBQFzo/LhAdE7cx/WnUvB6e0GXEnZKzXzLqh6U2GZz57x87K2tq98Ya88mfn8FB+rdBPbQvafsJxaGHojMf7w3wAxnLBC+r+neZo8JmdGhz8Hp0YKwayXH/rOCvzm+OtF+/uwXR5tHMI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The khugepaged daemon and madvise_collapse have two different
implementations that do almost the same thing.

Create collapse_single_pmd to increase code reuse and create an entry
point to these two users.

Refactor madvise_collapse and collapse_scan_mm_slot to use the new
collapse_single_pmd function. This introduces a minor behavioral change
that is most likely an undiscovered bug. The current implementation of
khugepaged tests collapse_test_exit_or_disable before calling
collapse_pte_mapped_thp, but we weren't doing it in the madvise_collapse
case. By unifying these two callers madvise_collapse now also performs
this check. We also modify the return value to be SCAN_ANY_PROCESS which
properly indicates that this process is no longer valid to operate on.

We also guard the khugepaged_pages_collapsed variable to ensure its only
incremented for khugepaged.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 128 ++++++++++++++++++++++++++----------------------
 1 file changed, 69 insertions(+), 59 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 64086488ca01..0058970d4579 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2417,6 +2417,70 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm, unsigned long a
 	return result;
 }
 
+/*
+ * Try to collapse a single PMD starting at a PMD aligned addr, and return
+ * the results.
+ */
+static enum scan_result collapse_single_pmd(unsigned long addr,
+		struct vm_area_struct *vma, bool *mmap_locked,
+		unsigned int *cur_progress, struct collapse_control *cc)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	bool triggered_wb = false;
+	enum scan_result result;
+	struct file *file;
+	pgoff_t pgoff;
+
+	if (vma_is_anonymous(vma)) {
+		result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cur_progress, cc);
+		goto end;
+	}
+
+	file = get_file(vma->vm_file);
+	pgoff = linear_page_index(vma, addr);
+
+	mmap_read_unlock(mm);
+	*mmap_locked = false;
+retry:
+	result = collapse_scan_file(mm, addr, file, pgoff, cur_progress, cc);
+
+	/*
+	 * For MADV_COLLAPSE, when encountering dirty pages, try to writeback,
+	 * then retry the collapse one time.
+	 */
+	if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
+	    triggered_wb && mapping_can_writeback(file->f_mapping)) {
+		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
+		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
+
+		filemap_write_and_wait_range(file->f_mapping, lstart, lend);
+		triggered_wb = true;
+		goto retry;
+	}
+	fput(file);
+
+	if (result != SCAN_PTE_MAPPED_HUGEPAGE)
+		goto end;
+
+	mmap_read_lock(mm);
+	*mmap_locked = true;
+	if (collapse_test_exit_or_disable(mm)) {
+		mmap_read_unlock(mm);
+		*mmap_locked = false;
+		return SCAN_ANY_PROCESS;
+	}
+	result = try_collapse_pte_mapped_thp(mm, addr, !cc->is_khugepaged);
+	if (result == SCAN_PMD_MAPPED)
+		result = SCAN_SUCCEED;
+	mmap_read_unlock(mm);
+	*mmap_locked = false;
+
+end:
+	if (cc->is_khugepaged && result == SCAN_SUCCEED)
+		++khugepaged_pages_collapsed;
+	return result;
+}
+
 static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *result,
 					    struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
@@ -2489,36 +2553,9 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
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
-					khugepaged_scan.address, file, pgoff,
-					&cur_progress, cc);
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
-					khugepaged_scan.address, &mmap_locked,
-					&cur_progress, cc);
-			}
-
-			if (*result == SCAN_SUCCEED)
-				++khugepaged_pages_collapsed;
 
+			*result = collapse_single_pmd(khugepaged_scan.address,
+						      vma, &mmap_locked, &cur_progress, cc);
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 			progress += cur_progress;
@@ -2819,13 +2856,12 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;
-		bool triggered_wb = false;
 
-retry:
 		if (!mmap_locked) {
 			cond_resched();
 			mmap_read_lock(mm);
 			mmap_locked = true;
+			*lock_dropped = true;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
 							 cc);
 			if (result  != SCAN_SUCCEED) {
@@ -2836,46 +2872,20 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}
 		mmap_assert_locked(mm);
-		if (!vma_is_anonymous(vma)) {
-			struct file *file = get_file(vma->vm_file);
-			pgoff_t pgoff = linear_page_index(vma, addr);
-
-			mmap_read_unlock(mm);
-			mmap_locked = false;
-			*lock_dropped = true;
-			result = collapse_scan_file(mm, addr, file, pgoff, NULL, cc);
 
-			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
-			    mapping_can_writeback(file->f_mapping)) {
-				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
-				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
+		result = collapse_single_pmd(addr, vma, &mmap_locked, NULL, cc);
 
-				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
-				triggered_wb = true;
-				fput(file);
-				goto retry;
-			}
-			fput(file);
-		} else {
-			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, NULL, cc);
-		}
 		if (!mmap_locked)
 			*lock_dropped = true;
 
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
+		case SCAN_PTE_MAPPED_HUGEPAGE:
 		case SCAN_PTE_NON_PRESENT:
 		case SCAN_PTE_UFFD_WP:
 		case SCAN_LACK_REFERENCED_PAGE:
-- 
2.53.0


