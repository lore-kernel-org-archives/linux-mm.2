Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4885C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1C376B0092; Fri, 11 Sep 2026 04:13:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF62B6B0093; Fri, 11 Sep 2026 04:13:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFD026B0095; Fri, 11 Sep 2026 04:13:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99C466B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:13:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 274A212013B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:13:49 +0000 (UTC)
X-FDA: 85200767778.14.194F46C
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf19.hostedemail.com (Postfix) with ESMTP id 838B51A0009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:13:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789114427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g50zuchxdpLwbPYEbpbH83k1JLgGWshnQRGeL6Ro/FA=;
	b=diEARnIXpn7/5ZfY25VHdujfAzWJDQ/tdpQ0X4+uC5Euons74wMWjg4KHWzBsM/p/xTgpG
	zfhotgmtjLGID3yd3yB9Kd09Y6U+8dmOt9ICHYxyCftkAywOAGmzDUhYTF+oVvtyJkvPgl
	IApCqpqkjm583nUtNW0JFK0Qy+RrkXM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789114427;
	b=hX9Ma2ydn11Ivqv8+3OyTHk6oSvRkfN4at3fc37wNlw0CTn90NFT+qHomKSlqyh9xSNQv3
	q+SH1wFZxX92jGRJXlz0qP86kuSHBPMFEgy89Wwv5+yv4VpTeqQxHDyGqLERVIUkDfqPEc
	iPAxSZ/7WUBAuhZvx8lUtzVy62ajjlg=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4hh6kZ2hg5z8Xrrb;
	Fri, 11 Sep 2026 16:13:42 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 68B8DVsW037964;
	Fri, 11 Sep 2026 16:13:31 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 11 Sep 2026 16:13:33 +0800 (CST)
X-Zmail-TransId: 2afa6aa3b82db48-b5b38
X-Mailer: Zmail v1.0
Message-ID: <20260911161333316ISAQaj9yJhmglKT5A9OnK@zte.com.cn>
In-Reply-To: <20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn>
References: 20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn
Date: Fri, 11 Sep 2026 16:13:33 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <liam@infradead.org>,
        <surenb@google.com>, <rppt@kernel.org>, <ziy@nvidia.com>,
        <baolin.wang@linux.alibaba.com>, <nico.pache@linux.dev>,
        <dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
        <chengming.zhou@linux.dev>, <usama.arif@linux.dev>,
        <gourry@gourry.net>, <harry@kernel.org>, <vbabka@kernel.org>,
        <peterz@infradead.org>, <borntraeger@linux.ibm.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: =?UTF-8?B?W1BBVENIIDQvNF0gbW0va3NtOiBhZGQgZmluZF9tZXJnZWFibGVfdm1hX2xvY2tlZCgpIHRvIHVzZSBwZXItVk1BIGxvY2tpbmc=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 68B8DVsW037964
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Fri, 11 Sep 2026 16:13:42 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AA3B836.000/4hh6kZ2hg5z8Xrrb
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 838B51A0009
X-Stat-Signature: ctxk7xtnn84x9in8171bfx9xjh7fr7cz
X-Rspam-User: 
X-HE-Tag: 1789114424-287116
X-HE-Meta: U2FsdGVkX18drTKdmrs6+TJt/FAbD/7pT7zUUjihIdsSE8Zg9AGB7G/5sMoqw7lYln1zUcd0bLY66eRQn1DobTi5HId/r3YbmVFBAKLjGwEZ1FE+FJ0WhMLBDJ1Acv3BMN/4MB39aUVLTW0HNjuBCfHo/WEwFeTqmyveTcAGp0P9wtqWy+ORF/BxAO6QP9TUHjL0wVbF5acf2R5EdfGD4C+Mn+pS8Ydjyfh49XzoM5v4bnaNyaUEHJ/C4uS9Cee+TXOqOZch5rT3Lhm8jqsgLSG2Fo5i9ZTyLrvEUMILhJikqQE9xhOZQyIMG6TYr256QckPUVpGx02nBJ0JEJZQuGzg2tRzMOaovcK+aRkbquRzs4rCBcBaxSCKj91mau+MuP9FOtCvj999pZffM8NoyclJ+IVwx7H07nIGbrqnDCJdl1BiGwSf2gRYLnBAk2SlPk359RK4ML4Jbi3P+8hRV528JLIGvlLtb56rADVvIaSx3bKBHOQTQwQMVx5XhkVS8LtUOCD7l86nJpdjo0NwnutLyANlj8zQj+wiC/YCWhc9on2o08G3Ge3kaYrl2bNJeMtZ8fLY4MvovBVQWCDBk9e+H/bE6Vmoyrgcir4BEPs/bIFTJkBMESMtggauPBBNGbZgx70o0C2qb5nshMW4DOREablgiriLSSL1ut9lR+CzS69x7WuCQX38FqZVO1jBg25dt6tK6uqa5t1wshxSici/qfYtQdAo6RdepaP36N80YtqFTE+8xBR4OybEC4O6llAnMmtlAuCTcrvkHiIBhqwQlGUEHjFtIGMQUJlzGeLoDFo4tiNLCxxNhWeHrXQXAgB0Vw32wl6TN9KVVA85xwqkfouNni8Li1fJn0s6h1hoqghTRyqX8s5DNTj2iX+wN+my+wubi9sHa07yEi1iUFsg3JDGfgPbjqipwVKskotccIyb9qRS8AcUagvmcGE5D99279YD3btHBT2wCLR
 EDnkELqq
 Y9NZ4BZ20i35gcjR1K79Nf9OZ6eNdOtCsToa+gbcZgmEu+h4vjAbTLfZuxZZ6g6noTwwaq8AqBRQRIgbbYSeLy/+QxYD0E2HFPPj6+bUEYeK/P8Ev13CCGNgbEducFzJujFegf/198DXKypD2JlqWo0/Cb6Bj853WoVF3gb68ae1H4fsj/hsE6Qd+aPpLOdPh1TH7V8kok1ICkU4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xu Xin (ZTE) <xu.xin@linux.dev>

Purpose
=======
Let's add find_mergeable_vma_locked(), which is similar to find_tcp_vma(),
using the universal per-VMA locking helper, so that we can avoid
mmap_read_lock() to reduce contention.

To be used in KSM code to replace find_mergeable_vma() with
mmap_read_lock(), the helper find_mergeable_vma_locked() uses the
universal per-VMA locking allowing us to lock a struct vm_area_struct
without taking the process-wide mmap lock in read mode.

Performance
===========
As a test, I construct a testcase which follows the approach: Create
one victim and several churner threads sharing one mm_struct; The
victim registers a 32 MiB anonymous VM_MERGEABLE region containing
8192 pages totally:churners hammer mmap_lock via mmap/munmap
repeatedly; ksmd merges the victim's pages; Compare latency baseline
VS this per-VMA patch.

               Before patched         After Patched
0 churner:     1.627 seconds          1.426 seconds
4 churners:    72.45 seconds          36.61 seconds

In conclusion, when no mmap_lock contention (0 churner), there is little
difference between the baseline kernel and the per-VMA optimized kernel;
But under interference from 4 churner threads, the merge time of the
per-VMA KSM-optimized kernel is significantly reduced by 50%.

Signed-off-by: Xu Xin (ZTE) <xu.xin@linux.dev>
---
 mm/ksm.c | 64 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 22 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index dda105681d7f..1d85769ec7db 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -765,15 +765,36 @@ static bool vma_ksm_compatible(struct vm_area_struct *vma)
 	return ksm_compatible(vma->vm_file, vma->flags);
 }

-static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
-		unsigned long addr)
+/**
+ * find_mergeable_vma_locked() - Find the VMA covering 'address' which is
+ * VM_MERGEABLE and read-lock it by per-VMA locks. Please use vma_end_read()
+ * to unlock vma after finishing reading the VMA (non-NULL).
+ *
+ * Return: If a VMA exists which spans @address, return that VMA, read-locked.
+ * If no VMA is mapped there or, very unlikely, a reference count overflow
+ * occurred, return NULL, and no read-locked.
+ *
+ * IMPORTANT: If a VMA exists but is not VM_MERGEABLE or has no anon_vma,
+ * this function releases the per-VMA read lock before returning NULL.
+ * Callers must NOT call vma_end_read() on a NULL return value.
+ */
+static struct vm_area_struct *find_mergeable_vma_locked(struct mm_struct *mm,
+		unsigned long address)
 {
 	struct vm_area_struct *vma;
+
 	if (ksm_test_exit(mm))
 		return NULL;
-	vma = vma_lookup(mm, addr);
-	if (!vma || !(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
+
+	vma = vma_start_read_unlocked(mm, address);
+	if (!vma)
+		return NULL;
+
+	if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma) {
+		vma_end_read(vma);
 		return NULL;
+	}
+
 	return vma;
 }

@@ -799,11 +820,12 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
 	 */
 	rmap_item->linear_page_index = 0;

-	mmap_read_lock(mm);
-	vma = find_mergeable_vma(mm, addr);
-	if (vma)
-		break_ksm(vma, addr, addr + PAGE_SIZE, PGWALK_RDLOCK);
-	mmap_read_unlock(mm);
+	vma = find_mergeable_vma_locked(mm, addr);
+	if (!vma)
+		return;
+
+	break_ksm(vma, addr, addr + PAGE_SIZE, PGWALK_VMA_RDLOCK_VERIFY);
+	vma_end_read(vma);
 }

 static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
@@ -814,13 +836,12 @@ static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
 	struct page *page = NULL;
 	struct folio *folio;
 	struct folio_walk fw = {
-		.walk_lock  = PGWALK_RDLOCK,
+		.walk_lock  = PGWALK_VMA_RDLOCK_VERIFY,
 	};

-	mmap_read_lock(mm);
-	vma = find_mergeable_vma(mm, addr);
+	vma = find_mergeable_vma_locked(mm, addr);
 	if (!vma)
-		goto out;
+		return NULL;

 	folio = folio_walk_start(&fw, vma, addr, 0);
 	if (folio) {
@@ -831,12 +852,12 @@ static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
 		}
 		folio_walk_end(&fw, vma);
 	}
-out:
+
 	if (page) {
 		flush_anon_page(vma, page, addr);
 		flush_dcache_page(page);
 	}
-	mmap_read_unlock(mm);
+	vma_end_read(vma);
 	return page;
 }

@@ -1568,14 +1589,14 @@ static int try_to_merge_with_zero_page(struct ksm_rmap_item *rmap_item,
 	if (ksm_use_zero_pages && (rmap_item->oldchecksum == zero_checksum)) {
 		struct vm_area_struct *vma;

-		mmap_read_lock(mm);
-		vma = find_mergeable_vma(mm, rmap_item->address);
+		vma = find_mergeable_vma_locked(mm, rmap_item->address);
 		if (vma) {
 			err = try_to_merge_one_page(vma, page,
 					ZERO_PAGE(rmap_item->address));
 			trace_ksm_merge_one_page(
 				page_to_pfn(ZERO_PAGE(rmap_item->address)),
 				rmap_item, mm, err);
+			vma_end_read(vma);
 		} else {
 			/*
 			 * If the vma is out of date, we do not need to
@@ -1583,7 +1604,6 @@ static int try_to_merge_with_zero_page(struct ksm_rmap_item *rmap_item,
 			 */
 			err = 0;
 		}
-		mmap_read_unlock(mm);
 	}

 	return err;
@@ -1602,10 +1622,9 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
 	struct vm_area_struct *vma;
 	int err = -EFAULT;

-	mmap_read_lock(mm);
-	vma = find_mergeable_vma(mm, rmap_item->address);
+	vma = find_mergeable_vma_locked(mm, rmap_item->address);
 	if (!vma)
-		goto out;
+		goto out_trace;

 	err = try_to_merge_one_page(vma, page, kpage);
 	if (err)
@@ -1625,7 +1644,8 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
 	rmap_item->linear_page_index = linear_anon_page_index(vma, rmap_item->address);
 	get_anon_vma(vma->anon_vma);
 out:
-	mmap_read_unlock(mm);
+	vma_end_read(vma);
+out_trace:
 	trace_ksm_merge_with_ksm_page(kpage, page_to_pfn(kpage ? kpage : page),
 				rmap_item, mm, err);
 	return err;
-- 
2.25.1

