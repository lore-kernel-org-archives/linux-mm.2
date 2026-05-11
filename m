Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBFFACD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 13:26:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5CF6B00BC; Mon, 11 May 2026 09:26:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 276F46B00BD; Mon, 11 May 2026 09:26:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B30F6B00BF; Mon, 11 May 2026 09:26:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CA096B00BC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:26:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CBE7986E0C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:26:00 +0000 (UTC)
X-FDA: 84755212080.28.B5BE192
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf04.hostedemail.com (Postfix) with ESMTP id B84E44000D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:25:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ZGnz7jRA;
	spf=pass (imf04.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778505959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QCqNSdBVodDtZaVxA5hMlC2tXqXUhPFm0dsq5zYMjWc=;
	b=R5uZ0l/f36dBPFwyV4Vf0bc0TNweUDbjYq8cFzkRLR1alaXvK9uUt20UkEBSdRTaI9k+1L
	kZQA5/BDPDKy+vg2XB3+tVPIeduDeVRIeU1IdY8a9a2be6/9IJdQj3F8dadr9sagecAx7A
	jIRBVoyK1vaXI1FSxucKdcy14RNMzto=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ZGnz7jRA;
	spf=pass (imf04.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778505959; a=rsa-sha256;
	cv=none;
	b=j3cCw5JNzdg8HUZJBHej8hc7lSm0gtXyatV0kvTg48KWnxbaIkva9UpeAhNt3oKHO5SdHl
	m7tw6aUlohVvOca52NSJz9H0buw2Rjlwg403G16pOegTqJyN+zIcCK8UySziVaWlHVnwOr
	3zN5lFZpSDcSZ+pZi74YXcEonRY1i7s=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QCqNSdBVodDtZaVxA5hMlC2tXqXUhPFm0dsq5zYMjWc=;
	b=ZGnz7jRAAPTlzzb9fRVcj7ipY9Wg8r5E6Ik/bn6mk4XiHWwIBtmCj92D1b9p7wxEhbmaBA2HU
	094ZWjG7qyhduk0e5KvNJTTBtxF3Ccw9G6J7W2Jz5bTvt3rzzFfp9UtC03CpGSk+EgkiEHJ2G+Y
	sGJ2lDK71bZKV/Mb2d63Wik=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gDgJm2Lfkz1K96p;
	Mon, 11 May 2026 21:18:16 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id E857A40572;
	Mon, 11 May 2026 21:25:50 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 11 May 2026 21:25:50 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: <damon@lists.linux.dev>, <linux-mm@kvack.org>, <sunnanyong@huawei.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH] mm/damon/vaddr: attempt per-vma lock during page table walk
Date: Mon, 11 May 2026 21:25:46 +0800
Message-ID: <20260511132546.1973270-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: B84E44000D
X-Rspamd-Server: rspam06
X-Stat-Signature: xzya39857ueuuti4dr1gegpjrxwedter
X-HE-Tag: 1778505957-18536
X-HE-Meta: U2FsdGVkX194vdeskVOxvqtX15z5Z40h3bMP1dSPbm0xGzTql8CrI6/v5t4b2TO3VOb5znYbzkAbJFhI8/feuHs167brkCcmk55MTYL6icXBh5dzGBH6uMbMpFC0E9k91dSk8HssT+zv7r1X7EYt7BuvXKbGNav3NP6pMcpTplAvyzfYEwVXRu4ZTz5rzqJtEhF4VOywT5yDTh/ivLiBvXc+PqbNVe0J8bJufsJr1zUIoPwWRN9xEJQhFe4+sP2XRXUUHZHd5ZH8H8s6LXZksbFI2L53xaww6yoAFxx8CvZKpaSbpsdIqipbVucqW5rUakf52g7z4F/d/9o5VM3+oaOUjgiy8lg+Xh/2bmax9sCULB7ga70LXcVDLAQ0YhwnnZPXa3niWoX14lcnEqSlc6gYjeGUElxui+8CBaeXdMlo1m+QHYFr2LXN1QqAto9Y6uauekT6j4+uIP9tiSxAG+farGRl3zbDRbUD0qb4HXIQ6Bt4V/TKxoB9NpbTbBAQuMIlDWv13Be5gVOgEuvRFMhQ8nrNOXSvGlh/DCfyICb5kZKAhirZLrAVb7tlvJQvtPjylPB+5eCIT8qMfBLhigu6AlELk21eupD11Pv/IxeVWPrWl4iEe+Pf+Tb8I7VM+7J/pMAXJwb2QGQGhjndA5d4ftUgWmw6wJhozE56tr70UvvUpZiK9p2ukuaWkIvcMBFOxx7A5GUXrhAWjmIo46/bPYGMP5IiHl83hj8RPWSjgXa5FY/ZCYeWnqvUOTGiQcD4Mw0S62RKwIPdMK1f62YcX7hHv0eEgZ1Nk0FlxSibEJwofirID0+d1YNG7fT+uFALl12DdZm91LpajgKcVHXVWbfO8VWgvXyILkFYyJtDL7+LISgu0ShZZypeG8nccysKjE7YBz0KXqSgwI+dIOJQG7ZaeuOvTdbUAQmSGqMhwbl1mpDm1qsPiIlZYI871XKEAhtANDhbiNr104H
 wrPhafz9
 tXq7OvcGXiC+nyiX+c7r0tuC0meY6RSTxwv0EdGzjPhP1tM+D4JgibnqVr8hJDgR0pXbFE7G2PuyGYuV/x9fKVm6L17ML3En0P2tnS+TJ/kgXj0qdQofEzYdpEU1enTa8FpdJBTR+VYFB0O+w53YpbnDDAfLYXEJDSd0YdnSBxcx8uMMtTa0KZMC/YfEvQJKyndYQfCMugnAsVJbZAJNrAYj08SQ0OdajqCQMKnQWx2dPcC+NbvxLqmBPx0L3ZePWHvSTdDkSKSKrOaaLaFsLsb7qVg/JUiCRYvKkcWqohNeJJA3drNDV7K3N5fUyQbKXQu3r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, DAMON virtual address operations use mmap_read_lock
during page table walks, which can cause unnecessary contention
under high concurrency.

Introduce damon_va_walk_page_range() to first attempt acquiring a
per-vma lock. If the VMA is found and the range is fully contained
within it, the page table walk proceeds with the per-vma lock
instead of mmap_read_lock.

This optimization is particularly effective for damon_va_young()
and damon_va_mkold(), which are frequently called and typically
operate within a single VMA.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/damon/vaddr.c | 66 +++++++++++++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 26 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index dd5f2d7027ac..cd6c0c5f3655 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -237,6 +237,32 @@ static void damon_va_update(struct damon_ctx *ctx)
 	}
 }
 
+static void damon_va_walk_page_range(struct mm_struct *mm, unsigned long start,
+		unsigned long end, struct mm_walk_ops *ops, void *private)
+{
+	struct vm_area_struct *vma;
+
+	vma = lock_vma_under_rcu(mm, start);
+	if (!vma)
+		goto lock_mmap;
+
+	if (end > vma->vm_end) {
+		vma_end_read(vma);
+		goto lock_mmap;
+	}
+
+	ops->walk_lock = PGWALK_VMA_RDLOCK_VERIFY;
+	walk_page_range_vma(vma, start, end, ops, private);
+	vma_end_read(vma);
+	return;
+
+lock_mmap:
+	mmap_read_lock(mm);
+	ops->walk_lock = PGWALK_RDLOCK;
+	walk_page_range(mm, start, end, ops, private);
+	mmap_read_unlock(mm);
+}
+
 static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long next, struct mm_walk *walk)
 {
@@ -315,17 +341,14 @@ static int damon_mkold_hugetlb_entry(pte_t *pte, unsigned long hmask,
 #define damon_mkold_hugetlb_entry NULL
 #endif /* CONFIG_HUGETLB_PAGE */
 
-static const struct mm_walk_ops damon_mkold_ops = {
-	.pmd_entry = damon_mkold_pmd_entry,
-	.hugetlb_entry = damon_mkold_hugetlb_entry,
-	.walk_lock = PGWALK_RDLOCK,
-};
-
 static void damon_va_mkold(struct mm_struct *mm, unsigned long addr)
 {
-	mmap_read_lock(mm);
-	walk_page_range(mm, addr, addr + 1, &damon_mkold_ops, NULL);
-	mmap_read_unlock(mm);
+	struct mm_walk_ops damon_mkold_ops = {
+		.pmd_entry = damon_mkold_pmd_entry,
+		.hugetlb_entry = damon_mkold_hugetlb_entry,
+	};
+
+	damon_va_walk_page_range(mm, addr, addr + 1, &damon_mkold_ops, NULL);
 }
 
 /*
@@ -444,12 +467,6 @@ static int damon_young_hugetlb_entry(pte_t *pte, unsigned long hmask,
 #define damon_young_hugetlb_entry NULL
 #endif /* CONFIG_HUGETLB_PAGE */
 
-static const struct mm_walk_ops damon_young_ops = {
-	.pmd_entry = damon_young_pmd_entry,
-	.hugetlb_entry = damon_young_hugetlb_entry,
-	.walk_lock = PGWALK_RDLOCK,
-};
-
 static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
 		unsigned long *folio_sz)
 {
@@ -458,9 +475,12 @@ static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
 		.young = false,
 	};
 
-	mmap_read_lock(mm);
-	walk_page_range(mm, addr, addr + 1, &damon_young_ops, &arg);
-	mmap_read_unlock(mm);
+	struct mm_walk_ops damon_young_ops = {
+		.pmd_entry = damon_young_pmd_entry,
+		.hugetlb_entry = damon_young_hugetlb_entry,
+	};
+
+	damon_va_walk_page_range(mm, addr, addr + 1, &damon_young_ops, &arg);
 	return arg.young;
 }
 
@@ -749,7 +769,6 @@ static unsigned long damos_va_migrate(struct damon_target *target,
 	struct mm_walk_ops walk_ops = {
 		.pmd_entry = damos_va_migrate_pmd_entry,
 		.pte_entry = NULL,
-		.walk_lock = PGWALK_RDLOCK,
 	};
 
 	use_target_nid = dests->nr_dests == 0;
@@ -767,9 +786,7 @@ static unsigned long damos_va_migrate(struct damon_target *target,
 	if (!mm)
 		goto free_lists;
 
-	mmap_read_lock(mm);
-	walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
-	mmap_read_unlock(mm);
+	damon_va_walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
 	mmput(mm);
 
 	for (int i = 0; i < nr_dests; i++) {
@@ -861,7 +878,6 @@ static unsigned long damos_va_stat(struct damon_target *target,
 	struct mm_struct *mm;
 	struct mm_walk_ops walk_ops = {
 		.pmd_entry = damos_va_stat_pmd_entry,
-		.walk_lock = PGWALK_RDLOCK,
 	};
 
 	priv.scheme = s;
@@ -874,9 +890,7 @@ static unsigned long damos_va_stat(struct damon_target *target,
 	if (!mm)
 		return 0;
 
-	mmap_read_lock(mm);
-	walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
-	mmap_read_unlock(mm);
+	damon_va_walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
 	mmput(mm);
 	return 0;
 }
-- 
2.27.0


