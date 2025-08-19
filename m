Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 820DCCA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 019658E001E; Tue, 19 Aug 2025 09:43:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F043F8E0007; Tue, 19 Aug 2025 09:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3C88E001E; Tue, 19 Aug 2025 09:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C9EAF8E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:43:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A3F1183D4B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:43:44 +0000 (UTC)
X-FDA: 83793624768.04.C2FC8B8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id C9F4740007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:43:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MnIV7RWG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755611022; a=rsa-sha256;
	cv=none;
	b=UxLryByfDhZfVk79cFulb1/7C8uVOTrymFQrLBESfx6aYUM6vfd3R80dZzos8IPkBao630
	t2cuGsv+9j6UQse9Ll5vdoUc4wJB1PRYF3L1Jt3L9yxlddXGiFHEgm80lkG6mWDjU+NNvM
	FqAX9qvZVUwrpAE+PPTi5y5WFcK4/OY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MnIV7RWG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755611022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kTFsuAmlEgxzFtD1O/P7BIlE/vfV96f3aKi9QfqF2QQ=;
	b=ihhNvc4GMuQPmA1wdQgTktGgw4V8D0ekiSykp6etIPsoi+Ta8CelIMylJFInuIFWd5UuH2
	mzUvkpf0L7gklEQypO/S8dUdmHomSgInqBHVbmWd0g67w+qyBWpsewxvi3btDZdZJMriUf
	dsaBRwI0rrZLcOVcbtWuaWyNcqnriwg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755611022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kTFsuAmlEgxzFtD1O/P7BIlE/vfV96f3aKi9QfqF2QQ=;
	b=MnIV7RWGYZZPrq0wP7hblKHkR5OnqBMoSQMh6IFCO8T4O+nLlH2qIjzgn1FnLff186vc7h
	eMrgHiVLzDhido6/XtXBHwmG/FJZga1wxSNdr6xM5thNJ7sU78hN2jheWc9Tv6pDhcqOHF
	LT1Noc5VZYfdV3/eEudRclf1WlFEWLQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-255-7FDqgCWGPy-XDcg9xC29_g-1; Tue,
 19 Aug 2025 09:43:37 -0400
X-MC-Unique: 7FDqgCWGPy-XDcg9xC29_g-1
X-Mimecast-MFC-AGG-ID: 7FDqgCWGPy-XDcg9xC29_g_1755611013
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5306C1800289;
	Tue, 19 Aug 2025 13:43:32 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.137])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F56319560AB;
	Tue, 19 Aug 2025 13:43:12 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	willy@infradead.org,
	peterx@redhat.com,
	wangkefeng.wang@huawei.com,
	usamaarif642@gmail.com,
	sunnanyong@huawei.com,
	vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com,
	yang@os.amperecomputing.com,
	kirill.shutemov@linux.intel.com,
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
	surenb@google.com,
	zokeefe@google.com,
	hannes@cmpxchg.org,
	rientjes@google.com,
	mhocko@suse.com,
	rdunlap@infradead.org,
	hughd@google.com
Subject: [PATCH v10 02/13] introduce collapse_single_pmd to unify khugepaged and madvise_collapse
Date: Tue, 19 Aug 2025 07:41:54 -0600
Message-ID: <20250819134205.622806-3-npache@redhat.com>
In-Reply-To: <20250819134205.622806-1-npache@redhat.com>
References: <20250819134205.622806-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: C9F4740007
X-Stat-Signature: 6z9dj6thge94oxoz86tjyro5beh9w5ex
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755611022-861895
X-HE-Meta: U2FsdGVkX1/SR4bFBr+UM//lEOJAK19kDmNtNUDBGxGyOSgjnbOkE+9PZx9XAK9AXQg4uYmcDqHdg6OiJcMVAKyW81TqSAfKDerlC5IvEVCVYozekbere5IbQrM8XO+5tJV9O6GfZjbvne18onJfWJlQtHHB7xBVpXl2kR5R3RvlcWPjOrWQgXM+bi9J0/v8NXXHx7RxFrxhXI/x6FxV7vAmqBSGEiOQBF2CRyIisNTlJ+3/CcLNVghq8nQAoQKxCAaAFszHvoW45bNizJQdP959llpw6NNlONAZ+AtuT2HsjRkRzRRMmJZenvefati0S/bg+j0UFX9OSMsjiTwrxNv3Bl+0RX/gAv4zZNIOPzpfgDJ53XWv9Eg4BC3DdOYfyWQT1AcAahNN9pDeoSFC1dL87L0CdXbXiDXElsu/IiYTsQ4U/m0V7u8y34RPvcVk+BFqrA++5jF/ALCr81k3GAk3dsptkgaY/o/tM0YegMBUkck8Kh9JfrRjHUJa3oEBQvOHt6rWX0rHN0ZV9Fq5Iql3c0W6rFhgYEsWVHmtLTnMa/EDV8O64c4G9EkueEyGqcmkpACzdNcsYnJVayhVnEwfT3RRNnxKrzq2gFfBF33QH3Z/wn+Gq20mvBzEWahkG1FT0o4Q1ycZepdbAGPEHjtPT2QqqyZaQIgCT8Y4x3qsg88FbaZPC1VyXqPzHNnJQ2shT3zzRMY1P7c2AHhj3Z89uQMIU3xJoTJLoVDE1fQignflF65FwsAvyAHIJYwTjtBt1bdB1fTEl7/kGf8+suIIIK6tnhTOpiKopb/7IKg58fCZ6y8mnfeDYegP2usUwWmhHF6byGOd4ONsMZ7J5Ra76xVEFHA9SgLEZmKyzWEKqCPXaRdpa1WREydwNy7CoWUnH9M8CFSxGe6wnn8BNV54md5flP835IoA00Y/W3+xWjuNb+DM0OOvyJmCpl2XdTYTgz1Qi7H3WrJ07mr
 DzzdtUpZ
 62hud+gNpi5kCqY6HadZn5omXHaiauMWvSfVligAqe+31HP/ozDjeiG01NOL21iaJCYpgRHeXr9Wl0e68kxl6LAptrWOAodmuYBwitlc5jEFpmC657faK0Wob4X36767JCc0N61FBP5TWN0LI7htsNEyeeHFTyHIyW+Jcuey/K1uSPHeHgrxlK2ducQ==
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
this check.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 94 ++++++++++++++++++++++++++-----------------------
 1 file changed, 49 insertions(+), 45 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0e7bbadf03ee..b7b98aebb670 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2382,6 +2382,50 @@ static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
+/*
+ * Try to collapse a single PMD starting at a PMD aligned addr, and return
+ * the results.
+ */
+static int collapse_single_pmd(unsigned long addr,
+				struct vm_area_struct *vma, bool *mmap_locked,
+				struct collapse_control *cc)
+{
+	int result = SCAN_FAIL;
+	struct mm_struct *mm = vma->vm_mm;
+
+	if (!vma_is_anonymous(vma)) {
+		struct file *file = get_file(vma->vm_file);
+		pgoff_t pgoff = linear_page_index(vma, addr);
+
+		mmap_read_unlock(mm);
+		*mmap_locked = false;
+		result = collapse_scan_file(mm, addr, file, pgoff, cc);
+		fput(file);
+		if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
+			mmap_read_lock(mm);
+			*mmap_locked = true;
+			if (collapse_test_exit_or_disable(mm)) {
+				mmap_read_unlock(mm);
+				*mmap_locked = false;
+				result = SCAN_ANY_PROCESS;
+				goto end;
+			}
+			result = collapse_pte_mapped_thp(mm, addr,
+							 !cc->is_khugepaged);
+			if (result == SCAN_PMD_MAPPED)
+				result = SCAN_SUCCEED;
+			mmap_read_unlock(mm);
+			*mmap_locked = false;
+		}
+	} else {
+		result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cc);
+	}
+	if (cc->is_khugepaged && result == SCAN_SUCCEED)
+		++khugepaged_pages_collapsed;
+end:
+	return result;
+}
+
 static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
 					    struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
@@ -2455,34 +2499,9 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
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
-					*result = collapse_pte_mapped_thp(mm,
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
+							vma, &mmap_locked, cc);
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 			progress += HPAGE_PMD_NR;
@@ -2799,34 +2818,19 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		mmap_assert_locked(mm);
 		memset(cc->node_load, 0, sizeof(cc->node_load));
 		nodes_clear(cc->alloc_nmask);
-		if (!vma_is_anonymous(vma)) {
-			struct file *file = get_file(vma->vm_file);
-			pgoff_t pgoff = linear_page_index(vma, addr);
 
-			mmap_read_unlock(mm);
-			mmap_locked = false;
-			result = collapse_scan_file(mm, addr, file, pgoff, cc);
-			fput(file);
-		} else {
-			result = collapse_scan_pmd(mm, vma, addr,
-						   &mmap_locked, cc);
-		}
+		result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
+
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
-			result = collapse_pte_mapped_thp(mm, addr, true);
-			mmap_read_unlock(mm);
-			goto handle_result;
 		/* Whitelisted set of results where continuing OK */
+		case SCAN_PTE_MAPPED_HUGEPAGE:
 		case SCAN_PMD_NULL:
 		case SCAN_PTE_NON_PRESENT:
 		case SCAN_PTE_UFFD_WP:
-- 
2.50.1


