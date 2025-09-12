Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6366ACA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD80D8E0008; Thu, 11 Sep 2025 23:29:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B89C28E0001; Thu, 11 Sep 2025 23:29:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A29D18E0008; Thu, 11 Sep 2025 23:29:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB558E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:29:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A75DC068D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:29:50 +0000 (UTC)
X-FDA: 83879168940.04.4F9D005
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 90CAB1C0012
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:29:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KCw5+Vr0;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757647788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FgAeDXTdH58+NNzWxsAhtBgj8QkDsiIiiAbzGEuCw8U=;
	b=zfptTqDeBvLunn/O/dWYIr1nBG9T2pjtDhMQpOTiWvE8eyGHQT8/Jz/zMceP744UN9bPcF
	dejZaD75BdcMjUo6qkhYYDvnefT5V5vk+kGflwAaAq9bvglotvjZeS5/6RW9NxA/NMuTPa
	Kvq6QRLLEy3Gls8i5ZHIhButaRuQtAw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KCw5+Vr0;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757647788; a=rsa-sha256;
	cv=none;
	b=ghM6W3GVQQSrGPUo3T4QGKD0x+dcgoy6KQwp/IqnoPDmWaKitRHIOpedjypLjotSJWea1d
	q03MZhak9kZy0onWVbns2Sqs6QdNiFmfspL7cdAJ95r6krxGYFgbs6cchTKG00HswQX6R/
	wI8R/W2oofuU/xO7m46M1mGhDcr4VVo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757647788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FgAeDXTdH58+NNzWxsAhtBgj8QkDsiIiiAbzGEuCw8U=;
	b=KCw5+Vr0ZIHPR9hY0poaMo4C4AVjUx8CiMgnS3be88XxQhTmVgI0quB0u8sD7GDQd3Sqvr
	uzKHFb6bRqxTS/CumQSTvEkUll2736qPecsDtq8Ox74ObNn2/hcCHx14VAZpgPeBQaiaxB
	/pnflN9evJtpa6a5Je+IjMqfptNiWm0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-653-DbG21aV7NumJcjM1VAnbGg-1; Thu,
 11 Sep 2025 23:29:44 -0400
X-MC-Unique: DbG21aV7NumJcjM1VAnbGg-1
X-Mimecast-MFC-AGG-ID: DbG21aV7NumJcjM1VAnbGg_1757647780
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D4F81955E9A;
	Fri, 12 Sep 2025 03:29:39 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 29C631800576;
	Fri, 12 Sep 2025 03:29:28 +0000 (UTC)
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
	surenb@google.com,
	zokeefe@google.com,
	hannes@cmpxchg.org,
	rientjes@google.com,
	mhocko@suse.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	jannh@google.com,
	pfalcato@suse.de
Subject: [PATCH v11 02/15] introduce collapse_single_pmd to unify khugepaged and madvise_collapse
Date: Thu, 11 Sep 2025 21:27:57 -0600
Message-ID: <20250912032810.197475-3-npache@redhat.com>
In-Reply-To: <20250912032810.197475-1-npache@redhat.com>
References: <20250912032810.197475-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 90CAB1C0012
X-Stat-Signature: safu793iq8ep13dw6echpskxddc1jp7e
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757647788-756946
X-HE-Meta: U2FsdGVkX1/N7YpUqN+l3ElgTBkYYaqMrNGHJw4AKKu7XG5jPKzDEV2KwIHh9SC+0SAw3okTU1HtIYulNFB4UbY3sFuoGGXQbH7W/pczr2nz2viXlV5G/6YA8ecN+4XU2iRVqTpO9LeEIjTD9ScKsJyMYuFeBEZRi17oVOZiGUmKXTSAQWdJzLQjPv2v4BlSxrs6JopYIx0JWfyA2M7p+oNzxGN+EoyZmZRE8ALas9EHEbcdJf2+W51ICHJuKfFkH5De+lHTjj8kEhQI/XW3QZwVjtz9F7gnR3tkItogv6nivG5F6mfic/KinsHQIhtDdk+vMtFVDLdknyTCtOXMk1EUd6RsQrD5zCa1zMdniW80mCdUtx6TTSBMWmq1T8foE21W/jbW7GsUh9g8HmZ17ElAMd6LXv3yueKHuUL6y9sfYrIZYaROtSh5JiVsK+56e3jFSFOp9fAq3wqxD7nqkufZtWgQWetvDIrC0vUHxhNMPQKTaFJxB78vRAUGwN8nYDi1/7r71Uchi5ujrpXQaBtLpb9g3uQwOGknAbv3+6GrQxCfrX3QAP371cK0WWzk09TNWecunBGSulFa5XmCTmVASfFAno1s5kz9FGjMyatcPZVPZvJ8jPIL0hQImxI3NQwlPDet5I8Z2n+fcMSHLsudK6TM6ecTZTMogm0WOYSe33DTbkuLWqmqGZHsOhs+zZ6oEkXJgoD71YYOc1m0EriR0sHtFGoMKTiiLP5GRB4V+1yOnO2/0phhrdjBgdTMVdjCDKPCBWH9TwSAGMgLmHaz9nXHvX3w0gg2aS72xF97iLxF4vWhn2ny8AlX8QBhwLxz+MzA/e1DXym109qaASTNM5Cuh0eE2smu4nI00YCJIHYWR7EdT6kn+3IyyOcOoeyuWOz1u0PUbWeAoRh5cJ9VzkRvPCIzX4eYXVeQeSPYcOHtO/whsiDWPuJL7SQEKuw6571QHBHySOK7HCb
 QlPyeKXe
 nJqKDklYzZtOU/6pccu6Ltn9VIGzieGrbRvvqTPwp+Imw091wcvzs2N61OT7rYu2IuPqADeeXZKNRtx0Jt98xHU/hbzNOAKwbu9DTFs9jmEbiXXdDbchZ+FfuCYTwibz6OOPa1UTPC5vEDmg7OUzZtOxBpzlkYEJip4fxgbvJGEGLVpKGORvmr4yv8Yhk3dzryjHJTyLMcigFirH6XllPd2o/4q3+0XPWjrgrmdyx/c6VaeWD1fbrRY72nQLcQaDlZVHFiukO5OV0Od75jSAiC9HQnsSN4fa5FpFwRzGgXL0HwQPa1OpQMBWS8YSa5s1fu6jV6gzRCF7PjDyFVxGEdVOmKWfLc4Le7NMahmZfEw3lGYiOwIAXEdAnAQNfv6NEVc5CeHeaPUcEZw2uKWRNOCOF6Ef2kOJ9wNp7RM7TRnbodLa5t5MXVRb7soMCvTEq/G0RZTTRMJxLsCYCnhaufc8FFgWFC8rOn7Te
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

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 97 ++++++++++++++++++++++++++-----------------------
 1 file changed, 52 insertions(+), 45 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 40fa6e0a6b2d..63d2ba4b2b6d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2370,6 +2370,53 @@ static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
+/*
+ * Try to collapse a single PMD starting at a PMD aligned addr, and return
+ * the results.
+ */
+static int collapse_single_pmd(unsigned long addr,
+		struct vm_area_struct *vma, bool *mmap_locked,
+		struct collapse_control *cc)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	int result;
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
+	result = collapse_pte_mapped_thp(mm, addr, !cc->is_khugepaged);
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
 static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
 					    struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
@@ -2443,34 +2490,9 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
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
+						      vma, &mmap_locked, cc);
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 			progress += HPAGE_PMD_NR;
@@ -2786,34 +2808,19 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
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
2.51.0


