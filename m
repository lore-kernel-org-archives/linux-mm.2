Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86C9EE9E31B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 02:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8F926B008A; Wed, 11 Feb 2026 21:24:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E366B0092; Wed, 11 Feb 2026 21:24:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D73586B0093; Wed, 11 Feb 2026 21:24:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C86386B008A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:24:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 91002160740
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:24:08 +0000 (UTC)
X-FDA: 84434209776.25.5B3D708
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id A00CB140002
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:24:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JSmlL7Re;
	spf=pass (imf26.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770863046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4xykWdQM5vJ3oEKsCmEuM4BEcEsG5qojr85PS8jMpA0=;
	b=s9heG7uEAw3BoT3OBMok+YKhNtAOtTj0sIfN9Sh+tvp34KkIJqKA9wivix1Bvf4nM2xZRp
	U7w6354Tum63ZK9LuYg6qWnR7+CWlOaKrMpQRioi0UUfLl6GMjYzqIn9a3sgIanS+wxyP6
	ujgJiNBPoQrAsQGAhv0Y5V0jROr2L9A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JSmlL7Re;
	spf=pass (imf26.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770863046; a=rsa-sha256;
	cv=none;
	b=6OZibsi8xAm7V3Bs3ehv2VcCDSK3uV7DnXqEFTbXP4MMvn5nzYu8iBhJD8t0XQqz64cqxR
	rVUxyXqTsCI8bhRVcouBW9g8ADuFEL/4RpZs5QTATTLfDmaBuJJQtDadGqyoUNFI/r9BDn
	I52vvEq4jAUqdSRH85F0XYDhRLYKthg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770863046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4xykWdQM5vJ3oEKsCmEuM4BEcEsG5qojr85PS8jMpA0=;
	b=JSmlL7RetDnydsx3k3XjEHx8JIU/f4g8p57eAYV5HMIMayLec0Y/Z/AQsrdRE7nDvvGwnD
	5Q11yDhpeJF/ndSCy1om5XoK8m3dLUFY93+LRa1BDc3hn/W9TF4yKT1ykMItHSLyfP4WJu
	Q8yja5dPsTxgRQ0KAVsxoKNQJRkkQIQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-2-E2-xYiB-MhKXMnGm3SvTFQ-1; Wed,
 11 Feb 2026 21:24:04 -0500
X-MC-Unique: E2-xYiB-MhKXMnGm3SvTFQ-1
X-Mimecast-MFC-AGG-ID: E2-xYiB-MhKXMnGm3SvTFQ_1770863038
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0EA7118003FC;
	Thu, 12 Feb 2026 02:23:58 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.91])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 07CC3180035A;
	Thu, 12 Feb 2026 02:23:47 +0000 (UTC)
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
Date: Wed, 11 Feb 2026 19:23:29 -0700
Message-ID: <20260212022329.18892-2-npache@redhat.com>
In-Reply-To: <20260212022329.18892-1-npache@redhat.com>
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212022329.18892-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0U48OSrxBiaE9M9RvQDWNAjb945emNa9txFuXaTNX1I_1770863038
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: p4o3bdbb8y9g86gyutrtgjum5qfwniyn
X-Rspamd-Queue-Id: A00CB140002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770863046-961157
X-HE-Meta: U2FsdGVkX1+SKfvQYfGAoR7Sn56ErPV/iXwG59GTqEWzEzqwY21t4MO2Jpn2TGEQxKJ0ytwZ51mypzQusEVyza6TiWwkDfalejN9rdMNrs0b7fAFBzakFUOl9Mr7+8Bh0znf3032VbgzdDAz7sJJHS5lCXwvWM1ME+Wafd0YEoNFwBZJq9ynZ7rf3LM1YRj7wRUfwQFKDWJ4UDqJ3veqAEkV8w/NA8EyqmZ+OIAeEdZt12ZJgl60d4mwuiVWMCe9RgZXH3O0y51ARNFu4CdlL7GC1RdpPXJxuZfGIwrg8jCENQjZLN8hQ14OH92i2dwtLEiAZ1Vzn1D6+aN8MmjnOHDJFZdk/xN97uYTn0Dzqazb/NDmCYoUoC+GrGCXaBvrxfq7/PC8PBBm2uVSNhdS1PjG5nzuc4ReYL2aFsVqCvDhFkqBthj4H6VOGuK2IIlqfSSZaARpPg5sNd1KXL7rnLKGCii8r+weVsb1aiF/iizLDsKB0dx9IcUAabuPvE1jFZ+wlY+sJgNQd6MN/CSsOL1bgqCATUt0aDoDVyA6bhTc8BRjfFMdGAVfsT9+1pLQbqT0Y6XMZj2e006R/F51I1WTVC2GX6if6tGn4OywXA9uOoPTUy9RBetcavujqdc0LmApkTLp0peJjtvLXCi0oq8raNTek76mWse3iBOY4HaOAUIJYiRLyGonwW9n561hqPZYPFxoCjaXSvViB6wNvlsIgObZ0kKu3LNPpWCGTW2Y5tDaKOREKqULd5+ozCSLIGWdnP67wPJhqJcUaEGxjVrPMK9h9a4UkRdC4sOqd6WyMRjZFNAjej7Vjag/UJgKoD6xJj/XtopI8AQ3OudZL9qtHhAl4Y7TAOlcH/Sq3+cSMo3n+SDU5JR1Cqz3ZxJhBQLD+LDn5ZzdFDtqeN49n03dY6JAPXDn4QQjVWY98RJ3Qvyu3bzZwzogv+y2Q9XTH7d7NSSSoVLuZ6UAo1I
 y9WFs4f0
 Dry/TR+dH4/pOo3y7g74tRIiiehNsbZXd8velXBZa65RA8h57/LRrgIgrpckd5ElEveWrcHIICpQsngdkHW2DWxJ//1n/Ps1NGAKsPL3v/FPXnbFdKggP6hwxV2vwNVET0p+8jPa4u4Dm+HiQ9QNTIsU4HEK20MTLZ43/iv1VgcKZXsSPfXufFSZgJWn4qH8qOkP+4poHrWiPpa4kWhAc3FF1mJAcUlpqcaV/tRLX9voNTMhrjQNUCpIR93MjZVwFjOGL96y4Dy8PoLjA9jAtXZ6eQbOTOhvmXWkq0oaB3RPBlJnazR+URshjYnsmgioQXlJylrIUpdwBzorOjadzKGFH/aORdNFXqGY7yBd45DshKWXNzKCLA/XrISESRJUSKJQkOOFMNUtKDCxe7hHgNqSWrkOMsXA/8Tz6Qz9HrHEQMVwf0YmEIIwLAJvjn2+sFcbUCqtoUUqz1/2wM3R/3HarwBnOrR8bHaBV
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


