Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2419103E2E6
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 21:16:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 135DE6B0095; Wed, 11 Mar 2026 17:16:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F6566B0096; Wed, 11 Mar 2026 17:16:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1DCE6B0098; Wed, 11 Mar 2026 17:16:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E375E6B0095
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:16:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B84D51C2F0
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:16:38 +0000 (UTC)
X-FDA: 84535041276.15.8B8AB34
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id E36C51C000C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:16:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MRgaJEtY;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773263796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nNKo9FHKBZTc5Vq10luN5wK1dtYIxXPk4TtKv9aQv2c=;
	b=u/lV445yUuSvNVftvL7A9bi7c1H+liMwfO71YctraBUXDkaKDb1vxtq4iwcU0Fl1BgQti3
	xI1I8DjP82cJyPvQ4/Ru+hlkKgMnQ7HR33MpuTHMRpE+ckCeu0dNvh1tpjTS6D/wWO75z1
	j6eb5JwxMLSIZbOkT0hQRo51htFj+ls=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MRgaJEtY;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773263797; a=rsa-sha256;
	cv=none;
	b=4cdjZoKKVropMoQxohmQt8NnzSv+3SwyCPx3JFDa98K+kY/Ui9g+1TY0lr8md+e2GueHGI
	BJv34Uz060bISJ4gg7yIGS7XW/UnDq/Ifr6EnhaBAuczONIUXlnWdjtj8WuqpK3KOVttKo
	8EIWnuqqNa+ICNE0bV4qN6A1VlX7D2o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773263796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nNKo9FHKBZTc5Vq10luN5wK1dtYIxXPk4TtKv9aQv2c=;
	b=MRgaJEtYJ0sBTI3BjDPJy9Qa5Wlp6LJLtDMXS9SRc5sXV3HmBmlmY/PQjf+WPiX8oknK+U
	9PtDDFmm2lfxcJ4l1/1yZbimzOrQbHHmJQZM8foGX79PJNXjOLThxtHI21TS6+fWfLijOn
	gGr/vneZzUeOVXOhfCjKhlFXq/3cre8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-325-pW1R4KbIMYCFdN7yLDqZGg-1; Wed,
 11 Mar 2026 17:16:33 -0400
X-MC-Unique: pW1R4KbIMYCFdN7yLDqZGg-1
X-Mimecast-MFC-AGG-ID: pW1R4KbIMYCFdN7yLDqZGg_1773263783
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C997119560A2;
	Wed, 11 Mar 2026 21:16:22 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.89.69])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 42E523002D0E;
	Wed, 11 Mar 2026 21:16:12 +0000 (UTC)
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
Subject: [PATCH mm-unstable v3 5/5] mm/khugepaged: unify khugepaged and madv_collapse with collapse_single_pmd()
Date: Wed, 11 Mar 2026 15:13:15 -0600
Message-ID: <20260311211315.450947-6-npache@redhat.com>
In-Reply-To: <20260311211315.450947-1-npache@redhat.com>
References: <20260311211315.450947-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7Lw7PGo1nIgfcWdYluEkWwo54xW2X2rxZy2UNrPEMes_1773263783
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: E36C51C000C
X-Stat-Signature: 4p14jiqk6x9kcf6caygp45eazqt5xgjo
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773263796-358658
X-HE-Meta: U2FsdGVkX19FXJea/g1kmXuFd4HzHWjRQVjZXb3VGbMyIatR+59rRCdsP3PRSyqpOQjZqGPM5tnA803YaPeegsn3KxT8VwrD0/OPD6nL0QJHs48EeYEItFltUMKE/cIVS3FBaFKNxjavs2ZVoW/E9/YFd0AWJP8uBesjTK2KdnnV0Pt3tkGAw/H25tzf1vPiZdbZH9Y1mZg03631ICOHsW45OiIAqBKQ2dbEBn9yAft8xKFlUsA9OqrFznjI4dIk2WadgaPpbfmNqlsfsHeya4WaFNMpT0J5OiJ87kedw/6RZ7kx0uMPvQUW8qvF5g6IvLNeh5twgTmlQ/SJJNYRpLXDNgoZVg02is1GOIB8YYQfo4m9YHE7Gbo28kAX3YT/dhM8lpWF6pKDwDVuJpy4XVYLdu/Ku2fDz8ds9JxGwh1NcWaPoDD8Gt5GxwE/HAFXaQTVx9WYkhU21JRKOlPChCe9LYjnzgDpcPfl+N8dM8kH2SrhI31vgWaeRsNYK1T+/vWljqgEXbtwG7IKAUxJpa4cflV9yzM9wYE0uoLDmgUHecxCJc3dDXH+6wwHh7qUu/FFxkcerBDKVMO4AOX8HzrNWqJuX9VU4zIINXHO/k1eMaXr1uxvReW6UxJEMfu6ktGmUvNs94P+/AutRH3xCd/mPw9BQMBxRXB7A8dUyQ2gmKts9ctDJugu1EycSPNbbpbj2fRohBrP0Sp+BWgFs7yFAoyrqypX6ZR4MD1Va/GqtCSa2GjJnhONO4Rg+E3dSrYUpA5coZxq2Agw7yiwoAgKQEpVe8i7EdZUIlzalo3LOMQaLSi+mpyFWmdiAMoZ8AvUFCM3QYvsQF+zcqm/MUISSlvzAqbPuzoWXLmmPF5s7xtYYk6DcOiRhDgnXwLcMfAP3Xwspew8f6h5NOLCv9WkhbZH2pLTJuGIM+B0bMhVgtOR2EqC2ecWXkt8w4fybaJBUo14i4yDbu+K8j4
 F0+TUKDj
 lgO+/rTZyK5kySoqtV5ga7JXfhMNJRSC6vkkevG6lQwmwZ9oHC6FzXIfZv/r8RhFN6ZOL9T6GG9BTRV7fZcB5UekOXiSqcmxNAPXS8oxzbpJwhPdBURTYreiEy/cVEDVd/oxIiBLQ4Eklb/I=
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
collapse_single_pmd function. This introduces a minor behavioral change
that is most likely an undiscovered bug. The current implementation of
khugepaged tests collapse_test_exit_or_disable before calling
collapse_pte_mapped_thp, but we weren't doing it in the madvise_collapse
case. By unifying these two callers madvise_collapse now also performs
this check. We also modify the return value to be SCAN_ANY_PROCESS which
properly indicates that this process is no longer valid to operate on.

By moving the madvise_collapse writeback-retry logic into the helper
function we can also avoid having to revalidate the VMA.

We also guard the khugepaged_pages_collapsed variable to ensure its only
incremented for khugepaged.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 120 +++++++++++++++++++++++++-----------------------
 1 file changed, 63 insertions(+), 57 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 33ae56e313ed..733c4a42c2ce 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2409,6 +2409,65 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
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
+	bool triggered_wb = false;
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
@@ -2479,34 +2538,9 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
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
 			if (!mmap_locked)
@@ -2806,9 +2840,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;
-		bool triggered_wb = false;
 
-retry:
 		if (!mmap_locked) {
 			cond_resched();
 			mmap_read_lock(mm);
@@ -2823,46 +2855,20 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
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


