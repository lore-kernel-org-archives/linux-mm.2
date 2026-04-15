Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A81E1F41994
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 11:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C773B6B0089; Wed, 15 Apr 2026 07:47:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4EEA6B0092; Wed, 15 Apr 2026 07:47:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC7306B008C; Wed, 15 Apr 2026 07:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 977E26B0089
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:47:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4BDEBC1AEE
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:47:02 +0000 (UTC)
X-FDA: 84660613884.30.5498F1D
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id 10D59100006
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:46:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of stepanov.anatoly@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=stepanov.anatoly@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776253620; a=rsa-sha256;
	cv=none;
	b=Pf2lyMm7QlV+/cFUs5t+w1lyZVCFJTjrCeVOCGp0lZppe43wGfd9bzFcZFt4ToBPGwXx3n
	GnCOC5+tec3rzvajjPrOZPItxd5wFwWXHVKaDevSRb2HG+i5dzidz4lFy5NF3LI3enA/LJ
	NWtpQJkvYch/sCjRH580mW9zEPEiMSE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776253620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gpZy9eLLRuhpFgutTrS08ZpD1ZHIttBRuOzFngVw22M=;
	b=3zTO8AznqYiSVReYgDTlLh09FpouyHV41gWHoNtT9df54POqwEKyAghE4LDk4xdXt3F5rr
	P6ynPsAjghsg/PVBVdH6DbBz7ukIyR9zwm6wqdnrwcDAi22c7Mq5w1N2X7jRQaXmD3uJM0
	6jXDkegysHHZezZ5s3IZQNxSiwN3oQM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of stepanov.anatoly@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=stepanov.anatoly@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fwfW56W0TzHnH57;
	Wed, 15 Apr 2026 19:46:41 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id DC6FB4056B;
	Wed, 15 Apr 2026 19:46:57 +0800 (CST)
Received: from localhost.localdomain (10.123.70.40) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Apr 2026 14:46:57 +0300
From: Anatoly Stepanov <stepanov.anatoly@huawei.com>
To: <willy@infradead.org>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<ljs@kernel.org>, <Liam.Howlett@oracle.com>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<artem.kuzin@huawei.com>, <gutierrez.asier@huawei-partners.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Anatoly Stepanov
	<stepanov.anatoly@huawei.com>
Subject: [RFC PATCH 1/2] procfs: add contpte info into smaps
Date: Thu, 16 Apr 2026 03:28:52 +0800
Message-ID: <20260415192853.3470423-2-stepanov.anatoly@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260415192853.3470423-1-stepanov.anatoly@huawei.com>
References: <20260415192853.3470423-1-stepanov.anatoly@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.70.40]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 10D59100006
X-Stat-Signature: xtz6r131ecxnicpp7c8mq66e65mesmcx
X-HE-Tag: 1776253619-694462
X-HE-Meta: U2FsdGVkX1/wqN3kB8o/o+K6cN/L/1nJOpLMLwHZnYvXE8FQFTJVNQwbeympqYIQepsqev7d/uILmXU8tANKHBGB7n05xQfLadiAc/hBICRavxoNGdWcd1bos99kCcXqrpiv0Trz5xWhFTHHambhhRbkfK2UiHmjMbPlyB/Tj2yCLue0j0x2SsWVowM0pC6MN2cj8tRGt5RAw3X422Iv9P5kPMyRxH3+5PiyBT2TM4cdIVFRE78SNvLM2D6HJR4yd7fkxsbi/W3X+XBfA6RlWgA1Vg5dCuNp2aBKyWYUNzf1vkaiJ6WMq2rEUQ5dyvkZ9QIOdTMKIr3jLyy3dCbE5VlxmKv/t3MdV7FdMC/NsrjlVpIO2OPtSwTia0LhUsvSz2lW8bdzX6Yaa5p6tSuEfQarlzpmp5PWWHAfr0e3T0hSFS1XWi5r45FLMSvGPIFsXFjUeWvk4OYm7MNbwiCwLn+XjXm+eQz0z/OIrGK9GMa7/u4kDMViyagdFfqjQEjlZ2dq62OHbfHTZ85IunFI2iGw21h5HDo2kGLKqnMKkXjMatNLmGAgf40T3Akz4Ok2KKDqNp1r0o+S1PY80lHH9gyWZwGcBVD2fkAlFrsjnuv73XhM1XoTgLEcoEpdBi0fwgrHR06/B+HEfYtoLMqZ8qE1mvi0uzEcyesYi+japMv4q57q8c4KcYyJ4S+yawoIXKO1YARar5uQIMZsRZlndCDUGKu6bd1303Hw7QK2JUVQ3OQzNYzX2osLrq6uABb1NmpSXMR8bhM25Thj7/F6WnW4uk6Ltjs+bSbJ2Dq3tBmfAxv8c3zRIExpsTs/wGsTa9jcWJobQoPYTIn4tzkwjaq60YXXAceUE27d4bj5P1LSclMsqhPZQ1iz9s8eLPa98VhNk1F78J+q+F9/czbxXDII4hlqLlSavvlHHY8EBH/3OlZn0vXQ/YW093fTurzgP6QutSIoK0pKZq7yA3s
 QHhgzOyD
 K2pMtvPbc4OoBqoBScKhhZksTh3fRyXiNW/2YdjYZrYcx6l3YadxdulQQyIsGXZHczm3+puM2q+/5LxXU7DW4BVmiLyHdoUv1AXufko1j0tuzxLEoPKSKhygRGWIP6IEluW7t0lNJDT3VIG7Vxbu2NJ+uSkejJFHvNKcVLYMqWGHGLeNwbU5+PQIBD68ZnmhQ/4ZpyQKEdShbYUOsHZb/1iow4Ks6x/3oj5tM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
---
 fs/proc/task_mmu.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e091931d7..22bcd36b9 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -874,6 +874,7 @@ struct mem_size_stats {
 	unsigned long shared_hugetlb;
 	unsigned long private_hugetlb;
 	unsigned long ksm;
+	unsigned long cont_pte;
 	u64 pss;
 	u64 pss_anon;
 	u64 pss_file;
@@ -915,7 +916,7 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
 
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
 		bool compound, bool young, bool dirty, bool locked,
-		bool present)
+		bool present, bool cont)
 {
 	struct folio *folio = page_folio(page);
 	int i, nr = compound ? compound_nr(page) : 1;
@@ -938,6 +939,8 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 		mss->ksm += size;
 
 	mss->resident += size;
+	if (cont)
+		mss->cont_pte += PAGE_SIZE;
 	/* Accumulate the size in pages that have been accessed. */
 	if (young || folio_test_young(folio) || folio_test_referenced(folio))
 		mss->referenced += size;
@@ -1015,6 +1018,10 @@ static void smaps_pte_hole_lookup(unsigned long addr, struct mm_walk *walk)
 #endif
 }
 
+#ifndef pte_cont
+#define pte_cont(pte) (false)
+#endif
+
 static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 		struct mm_walk *walk)
 {
@@ -1023,12 +1030,14 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
 	bool present = false, young = false, dirty = false;
+	bool cont = false;
 	pte_t ptent = ptep_get(pte);
 
 	if (pte_present(ptent)) {
 		page = vm_normal_page(vma, addr, ptent);
 		young = pte_young(ptent);
 		dirty = pte_dirty(ptent);
+		cont = pte_cont(ptent);
 		present = true;
 	} else if (pte_none(ptent)) {
 		smaps_pte_hole_lookup(addr, walk);
@@ -1058,7 +1067,7 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 	if (!page)
 		return;
 
-	smaps_account(mss, page, false, young, dirty, locked, present);
+	smaps_account(mss, page, false, young, dirty, locked, present, cont);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -1096,7 +1105,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 		mss->file_thp += HPAGE_PMD_SIZE;
 
 	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd),
-		      locked, present);
+		      locked, present, false);
 }
 #else
 static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
@@ -1356,6 +1365,11 @@ static void __show_smap(struct seq_file *m, const struct mem_size_stats *mss,
 	SEQ_PUT_DEC(" kB\nAnonHugePages:  ", mss->anonymous_thp);
 	SEQ_PUT_DEC(" kB\nShmemPmdMapped: ", mss->shmem_thp);
 	SEQ_PUT_DEC(" kB\nFilePmdMapped:  ", mss->file_thp);
+	if (mss->cont_pte) {
+		SEQ_PUT_DEC(" kB\nContPTE(Rss):        ", mss->cont_pte);
+		SEQ_PUT_DEC(" ", mss->resident);
+	}
+
 	SEQ_PUT_DEC(" kB\nShared_Hugetlb: ", mss->shared_hugetlb);
 	seq_put_decimal_ull_width(m, " kB\nPrivate_Hugetlb: ",
 				  mss->private_hugetlb >> 10, 7);
-- 
2.34.1


