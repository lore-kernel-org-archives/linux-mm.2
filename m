Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9A4BEB5968
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 02:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 011686B0093; Wed, 11 Feb 2026 21:25:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1DE26B0095; Wed, 11 Feb 2026 21:25:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16AD6B0096; Wed, 11 Feb 2026 21:25:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D228D6B0093
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:25:34 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8448A5A468
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:25:34 +0000 (UTC)
X-FDA: 84434213388.27.AAD7427
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id A1F05A0009
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:25:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V39KcKJR;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770863132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4xykWdQM5vJ3oEKsCmEuM4BEcEsG5qojr85PS8jMpA0=;
	b=48xAK8jJnAQBe99JaeAU3GGnBcKJsVVxoK1EdN9FHhoBaU6Jw19VWumqZyHvm6TUm5Tmlh
	Uqf0T03CEZXSkM3KgCzHjAwMrYnANSJAm93A2QN4KFW0wqTpYn2TuStuzWdk2FNr6ZyC0r
	4DRC/oSbwzeYF50qE0XnZEzH9sSXi8U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V39KcKJR;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770863132; a=rsa-sha256;
	cv=none;
	b=olcbflPePhohgcE8tTMzevR+3JUfHAuSbbYIDutM+QDjJaZgZGuxIrDtEc1h7h4wqH0TAn
	LHrDU/b/PBCBOYIARQoc9/h8LHSIuVD5Qgu9JQxqgIE9ONAfTPH0aUqrLxNam2R8OlfLMU
	XXtJRKExCvljHmy+M3/yTRHNWxYT2KA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770863132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4xykWdQM5vJ3oEKsCmEuM4BEcEsG5qojr85PS8jMpA0=;
	b=V39KcKJRO/HgNvFAHq3W3QYsGZVVBo7f9zrFYZGdao2g23efRWSFd+XV36EhwTsEksSE/z
	OdvKF28Lw1Z8AjcjCfx8muut6nplPEpDftY/w5MXnVbSHqMEIdlLPvVmVr+dFo5AEcN3rw
	pqw+JR1JZUOFDt2WVZx0+LubruqdpiQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-572-R5CLi0HGNwecZPB7zKpSKA-1; Wed,
 11 Feb 2026 21:25:30 -0500
X-MC-Unique: R5CLi0HGNwecZPB7zKpSKA-1
X-Mimecast-MFC-AGG-ID: R5CLi0HGNwecZPB7zKpSKA_1770863125
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65F15195608F;
	Thu, 12 Feb 2026 02:25:24 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.91])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 68BE9300DDA4;
	Thu, 12 Feb 2026 02:25:14 +0000 (UTC)
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
Subject: [PATCH mm-unstable v1 5/5] mm/khugepaged: unify khugepaged and madv_collapse with collapse_single_pmd()
Date: Wed, 11 Feb 2026 19:25:12 -0700
Message-ID: <20260212022512.19076-1-npache@redhat.com>
In-Reply-To: <20260212021835.17755-1-npache@redhat.com>
References: <20260212021835.17755-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Rlz6nOtZvXohHC6cbGw2ZqARHlmoAvCk7tkaZcypL98_1770863125
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A1F05A0009
X-Stat-Signature: p4o3bdbb8y9g86gyutrtgjum5qfwniyn
X-Rspam-User: 
X-HE-Tag: 1770863132-391307
X-HE-Meta: U2FsdGVkX183XkISVdS/QK8KJwkfXTfUDgWJIgRW7tfIuqGfXqwYj2C9hBp6+vSy9k+1jRb80PmouZOBfMV4VkDWVVI9XS29qHlIv1kCKgAaPxTJjfPqsPocUnciPXalTSLFL17lYPlPszZNeI7vQJNGI7MKIBJZ2bAMb2F1fBxRZhgv75smRLLwVEjlymnzdN1lOLuIJT8+rIZMH74GeZLXmFlw0MQ0QpdreMEEGwL2V5hY7WM0YffYycUW5i/0KeTJ1LYwGOslX+Vr38wIvwr+7gyULMiYrYxBmgHCm8rVl/cPf9sQfpi6z9i+7uFPb08soICEqnVBhezkp0f0LtZngKcuT63bosaSxT+/kHbZFN24Yg1R93RLSBSvHVHAXwFB+N+QpfhzuiwWX28vzPH926bDHfndfZVavqjxAmh8+scAAwAYgVWU5U7ZRvi6GaV3k48NPmj7Qos5di9oi73bSrhUq5XVs2e5Ky8xTb8e0UMH9rXhx3TPVXvILfI1x0g178TZmA7gqgv+7f1cpkfr5YBuxcjzP20jnVyNyLR1fhfbccZN8FDW9TwlDUk0o+xSRRwKs8gsPgs6wRI+E5N2mFhKOrRAbnHwuNGM6OTOExwcbajBGmafZN4oQ0v6lkgijPMXIa3JJRPaDLY5LHg16StpX85O5EFygKTaDi4ukFNW4Sjh4EGE93SwpzQthAxmKtDeYnMMsP/aGp9CnIqimge3eCKTo+gKAjPXfSB59WYFk/0BygmEPvZUKvC9SRmAFeH4IsMq1/3tK9Ibb34YiyQSRO9EdzfzwodWVvyoPJsnz3lrJeuUCyOJNrhKaREgMal8XhyJjXmkRSWuN3OfyLsCsEOM9KlqnshVpXzP8rh/XYnNI8bNSZtC/7qg9RUkUM7wDcsMRhQnI63ys2aU3Gau6YgVAIv8i8Hhojah7WKlyn2IQndnKr38u9fgns2GaPfke9Wbh67OTmU
 5S76eNzT
 csLBHM3l47P75Iob72p9zp7Ga7hOmtTBWZU6CHvERsKRyJQ7q2cVFOkzgKpTe99P1Q96ygeT+yu5CL63ZjCPF4ueYtzWLMm5I5101S0S5WQZxwbEQjmVsXjbTBwAK5onfUdLn8YVZwDswYtw8L7Jx6BaqEPbT5EVzLkVntxYee4zhZOiDkPP7ER/cfVJFdtr/1Ih8U/E5ohf5CX8WheTXY6MpLBq1innM2pz3ZgvyMkOG3aalrn2Fk5Qsn5CPOWXAxcvP7a9WNaU1nviL+Fkf/JpjTgcuHfNKDC+97NQN+4gRwaU6EpAxuQmbaQOSzgvUnZ0w5VRvQj7GsrcjepR6ZMuzPxfx4vpAZIfon4LcY53JPsAjVKSGslM0u1hIrJQPHgcIt5SXaW3MXlEu17un8qHb7TluOpANy+vgjQ8Hkf6H3+eUwF/eimR2PWjVXIK6Z9l6hGVonPXeF1NPvC+LnbBb6rRyWmhE9XEy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 mm/khugepaged.c | 121 ++++++++++++++++++++++++++----------------------
 1 file changed, 66 insertions(+), 55 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fa41480f6948..0839a781bedd 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2395,6 +2395,62 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm, unsigned long a
 	return result;
 }
 
+/*
+ * Try to collapse a single PMD starting at a PMD aligned addr, and return
+ * the results.
+ */
+static enum scan_result collapse_single_pmd(unsigned long addr,
+		struct vm_area_struct *vma, bool *mmap_locked,
+		struct collapse_control *cc)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	enum scan_result result;
+	struct file *file;
+	pgoff_t pgoff;
+
+	if (vma_is_anonymous(vma)) {
+		result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cc);
+		goto end;
+	}
+
+	file = get_file(vma->vm_file);
+	pgoff = linear_page_index(vma, addr);
+
+	mmap_read_unlock(mm);
+	*mmap_locked = false;
+	result = collapse_scan_file(mm, addr, file, pgoff, cc);
+
+	if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
+	    mapping_can_writeback(file->f_mapping)) {
+		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
+		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
+
+		filemap_write_and_wait_range(file->f_mapping, lstart, lend);
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
@@ -2466,34 +2522,9 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *
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
+						      vma, &mmap_locked, cc);
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 			progress += HPAGE_PMD_NR;
@@ -2799,6 +2830,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			cond_resched();
 			mmap_read_lock(mm);
 			mmap_locked = true;
+			*lock_dropped = true;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
 							 cc);
 			if (result  != SCAN_SUCCEED) {
@@ -2809,46 +2841,25 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}
 		mmap_assert_locked(mm);
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
+		result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
 
-				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
-				triggered_wb = true;
-				fput(file);
-				goto retry;
-			}
-			fput(file);
-		} else {
-			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, cc);
-		}
 		if (!mmap_locked)
 			*lock_dropped = true;
 
-handle_result:
+		if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb) {
+			triggered_wb = true;
+			goto retry;
+		}
+
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


