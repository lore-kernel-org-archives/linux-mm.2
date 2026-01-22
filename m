Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C66EED6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34CAC6B0321; Thu, 22 Jan 2026 14:30:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313F56B0324; Thu, 22 Jan 2026 14:30:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22A166B0325; Thu, 22 Jan 2026 14:30:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0FB946B0321
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:30:51 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2176140AC0
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:30:50 +0000 (UTC)
X-FDA: 84360592260.28.51BE06A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id A49A3180008
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:30:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FLdQkP7R;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+GEyTsIIxthANaYp7hDwgGrjrQoxw+PtebqYK78QEc=;
	b=z/tCanaSdTATk+DiQv4hq21oTgIUkveFYXFPnolZRvX1YPKMm7i+IKYTi0/f+xaQU0Blov
	P+4TOSHlVP46UyERlHWEK4i5m/JCMV2k36QD9uNdN68Nny/wAAz0Ld9fyrZPMcKilJfWc4
	mEN/nCQHQWoSfk/7DGi4Zq8PG9nzd4A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FLdQkP7R;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769110248; a=rsa-sha256;
	cv=none;
	b=IDlEDS4F7OZhQOE8YAMmo7NjuuOlxLkuMYXXsDwZkIOwXb4UtOe4YU0RSrHmW3u5Gzd60U
	+Hj57Es7uF5FhIBS3l0LwSIAzGpMW7T0X2jn96Uh9Ed3njFRjlxH0X4+3h+patajCyErQM
	t3AX/O/Ge621Ux7HFh2X64e9Oovr4Ys=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769110247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A+GEyTsIIxthANaYp7hDwgGrjrQoxw+PtebqYK78QEc=;
	b=FLdQkP7RGCbU//ciLa5aKVxIfG5bUJS+Vu17TUzSDgS3dAdUGWrDYkukD6l17kql/i+SOq
	oxwbBdVuzVESstiwFoCd3eQ3gbI3CLhIpng7CZWXNVHQc1f0xrlJavJiV8+LPA+HiPDruF
	YrsX7mq+p1o1sft1JDT/w9KHC7R1Rck=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-119-P5xDX0XjNU-YASV0eC0ILQ-1; Thu,
 22 Jan 2026 14:30:40 -0500
X-MC-Unique: P5xDX0XjNU-YASV0eC0ILQ-1
X-Mimecast-MFC-AGG-ID: P5xDX0XjNU-YASV0eC0ILQ_1769110234
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7280619775AE;
	Thu, 22 Jan 2026 19:30:33 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.88.59])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D87431958DC3;
	Thu, 22 Jan 2026 19:30:23 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: npache@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	willy@infradead.org,
	peterx@redhat.com,
	wangkefeng.wang@huawei.com,
	usamaarif642@gmail.com,
	sunnanyong@huawei.com,
	vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com,
	yang@os.amperecomputing.com,
	kas@kernel.org,
	aarcange@redhat.com,
	raquini@redhat.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com,
	tiwai@suse.de,
	will@kernel.org,
	dave.hansen@linux.intel.com,
	jack@suse.cz,
	cl@gentwo.org,
	jglisse@google.com,
	zokeefe@google.com,
	rientjes@google.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH mm-unstable v14 03/16] introduce collapse_single_pmd to unify khugepaged and madvise_collapse
Date: Thu, 22 Jan 2026 12:28:28 -0700
Message-ID: <20260122192841.128719-4-npache@redhat.com>
In-Reply-To: <20260122192841.128719-1-npache@redhat.com>
References: <20260122192841.128719-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: O6FKmldCQnV6go4ycXZltaz2ab6M3yYV5r1Am9NmSyU_1769110234
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 9yoqxf79m6zqgosz57az3r98s4paob1o
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A49A3180008
X-HE-Tag: 1769110248-277500
X-HE-Meta: U2FsdGVkX19ZFtj5p8WXih02RyrYT3vbetkn5sf5nt/vCSFc5rM1ZwREI7yK+2KrZ6FGRp3FflovSQYl/qudnl6b6lAkCh1jspdQWnN97N2Hix7zS5YiTulTcKU6BaaFVXwravo32UwkR67NMO0KKortgsRjup0d0L2w7PrQsZudcrSf5YrmdgIa+nLIHAi63lBIWjoIwFqvM3zTOEQOEJedYIu0LdlH+rJ70G+IImEOjfullQC98Ka+7CGG5fbl9Qtfmi9k4IZIZqljp0C96lIYT4hszvTrfagFE19NkECxtXVRuxR+95IhFQ3PW25kaL9ojVH+zrIZUN9IwiR8GAXl3m4xTURuasr0OWxikQG1rWYiIoTUd9B5LcU965qsxnqadi8miyeRzr9DEow5YaePP+fff4AWfvbHVTlEjKeUfNqQlni2ldd5og4Z6borqhTYOQ1S58GxuWKCrsvT2LN566axIMSlEt8hCX3+YHgaSC1M4qWcSZzn2ZoFQK0LyJuUqYw2+XilWq1T0p9Du9qFMoXkUt97mckJDdcXn70gYnm0mB7yqSHI7ukT8xAe0XmwfwHeexk3clwHEEkh4iaoeTm+H2OmSSQuDYiJKVJS4MQzntwNo4sgOY1bcD0CoCfqOUKMaZTlWqMz2LwFuRMDpIruETu9RSm+F2CV1X4w8YsFmD1V0lr1iKYvLIPn/O22lUY6a1tAcgbqvNythgnIAMULz3+IYc1iuScVrDKG3V+oi0Xf5UK+7+oljrSTsoqqK2RnzfZp62FryPSK0cx+S+tsHI4mHHiDh8l6lYNPBzQoEZIHJPoqq09k6Vm557l8R4d+4PFNqf7XdRiEyZH7EuQSyCbpp+8B7L93ZrcMSsVR4hqNqP3VPsr9Bn415GitFNkLaFrFPE5s0T975DeSKwx0Af75OhkKl6b1OfL9eJGNBB48/8SxKW4eG8lJWQQgKeodZJUJNFb9rRT
 PQNe88v8
 YaxsJVE62msySoOly3Ba6GY+7y2fqmDa8S4WKMznj6s7uFWQ8YL/IC6++DI8jYOLPbmklgZI4huHUZfIzNqcUUPgWC+hJhX/VOYainVgzMy6AlNJb/xIVJtOHVYYJbsOqnWSvOOUwkQ9gj4nY/nxbaiGYEdOacN4m59iiIOaXMUZVCBdJzkWJmE6d3nw7MhHuDBRHYj/Nto0ZfZ918tLxh6gxujsXC07y7bRBjIa5ndoCZxQEgytfeAdQgNvhbZ1QxP2yCBr9/dhTSBmrW9e37MUYROYJUAnIpG/y9q0KFhTIVDT60TExBun/Q/vmfXMa/kMpLbDmYoCRA/8ak2HMqgPdqCeOtRRo2XfrNp9IwgJZGHKdu4apzK+RX6qnTfSyNSreDnO7VTY39wCe3TcVRksW7ndunKrZPAHr+ZOMp6x/ZyMhjrBph8wxeiYo70Amfvf76K7iTO5Rtm/u2hcSNcBIrD/2w/vTvLBpN7D+NltDX6iIk5ke0q8ib3I06iAOnQSn
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

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 106 +++++++++++++++++++++++++++---------------------
 1 file changed, 60 insertions(+), 46 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fefcbdca4510..59e5a5588d85 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2394,6 +2394,54 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm, unsigned long a
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
@@ -2466,34 +2514,9 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *
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
@@ -2799,6 +2822,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			cond_resched();
 			mmap_read_lock(mm);
 			mmap_locked = true;
+			*lock_dropped = true;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
 							 cc);
 			if (result  != SCAN_SUCCEED) {
@@ -2809,17 +2833,17 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}
 		mmap_assert_locked(mm);
-		if (!vma_is_anonymous(vma)) {
-			struct file *file = get_file(vma->vm_file);
-			pgoff_t pgoff = linear_page_index(vma, addr);
 
-			mmap_read_unlock(mm);
-			mmap_locked = false;
+		result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
+
+		if (!mmap_locked)
 			*lock_dropped = true;
-			result = collapse_scan_file(mm, addr, file, pgoff, cc);
 
-			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
-			    mapping_can_writeback(file->f_mapping)) {
+		if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb) {
+			struct file *file = get_file(vma->vm_file);
+			pgoff_t pgoff = linear_page_index(vma, addr);
+
+			if (mapping_can_writeback(file->f_mapping)) {
 				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
 				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
 
@@ -2829,26 +2853,16 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 				goto retry;
 			}
 			fput(file);
-		} else {
-			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, cc);
 		}
-		if (!mmap_locked)
-			*lock_dropped = true;
 
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
2.52.0


