Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C546FC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:11:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A6206B010E; Thu, 24 Jul 2025 05:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40DB96B0113; Thu, 24 Jul 2025 05:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 121016B0110; Thu, 24 Jul 2025 05:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E8D436B010E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:11:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 895C01602C8
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:11:00 +0000 (UTC)
X-FDA: 83698588680.15.F6F5AE6
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7D709C0002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:10:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753348258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FphBrdgefnTg6ImAfSYb5vwwRUqmc8UvRTbsqAcPhO0=;
	b=OyICJXZCuyoajBAHXkYzRALInCG9JZgeGo/50qOuIX5TweBvAQhOa+Sl8slSL6uXTu7uq3
	wxSQL8tsyl2ytOsZnRxx8tr52w8pcc8KIZZK6g9t3Oox1fVADYfGQKloqN95Bk0XT9ZJFR
	F5YsKyon5RCsHv9x83L04qjPLF5fszI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753348259; a=rsa-sha256;
	cv=none;
	b=ImFAL6utNfKBcdBW4w5+Q0I2fMFoBEcqRGnZyRvLyNvS7ihfeUtfOsyG1bUvlXFb/e4Buy
	mlTUjCUwgJlXjYLGFW1NvqQ+ndrFvbNVffVa15xKoyTfF04Zt0wDnjdH9jDL6nd89E4hld
	RwR7RQmShN7T4LLaEeLJ32NPoV7/OJY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4bnlY50bnhz2FbNZ;
	Thu, 24 Jul 2025 17:08:41 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id 3371C140295;
	Thu, 24 Jul 2025 17:10:55 +0800 (CST)
Received: from huawei.com (10.175.124.71) by kwepemo200002.china.huawei.com
 (7.202.195.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 24 Jul
 2025 17:10:54 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@redhat.com>, <dev.jain@arm.com>,
	<catalin.marinas@arm.com>, <lorenzo.stoakes@oracle.com>,
	<thiago.bauermann@linaro.org>, <superman.xpt@gmail.com>,
	<christophe.leroy@csgroup.eu>, <brahmajit.xyz@gmail.com>,
	<andrii@kernel.org>, <avagin@gmail.com>, <baolin.wang@linux.alibaba.com>,
	<ryan.roberts@arm.com>, <hughd@google.com>, <rientjes@google.com>,
	<mhocko@suse.com>, <joern@logfs.org>
CC: <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v2 2/3] fs/proc/task_mmu: hold PTL in pagemap_hugetlb_range and gather_hugetlb_stats
Date: Thu, 24 Jul 2025 17:09:57 +0800
Message-ID: <20250724090958.455887-3-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724090958.455887-1-tujinjiang@huawei.com>
References: <20250724090958.455887-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.124.71]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Rspamd-Queue-Id: 7D709C0002
X-Stat-Signature: zdi8ixcqodrcpncym737u3b7jtnoaxh5
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753348258-714154
X-HE-Meta: U2FsdGVkX1/h/cO+lu3RaACdVhtk+Dq9bSVsIj4Y+2UTuyyuA2TsM7u99alheHBgI2qrpSnPilugm9X2BbPw5ncRu3VsV06D+q4QnE9h9BuGO5QuGRJtSpbwpUeP+hBK0RKeWxiwrphngysoEzpBtBZZLAwRbUf4NODRy6v2vBdtrpVrwfLtSO2suzsv2LDZSXw3wtd+kfddu9uV1ZV9psLmAACAvanSVycV4tM2LhvO7Nr3ufAo+e8bzXrN9vgRZuPEiG7uwBCYq4SGUOYoK8MohMVB3/SBy1S50nxDm44CQewe5if6V8yPdgIqnVrKXWKfUIKX119noZVYAGPx+AmBXzwm2YArGHYLbxTUnMo+0fVYmw3JMzkRstaQRxyDVa5J6yJUl+C3NqI5hT/IE9jExuOsnF0Nn4hhiymWfThwSUHaJvLboevt9a48sYpFdUkKHONCvQFF9UyCt8tGBHAKDFjvv0J2nkLyH66u30wzFMXx5BpRk/zB1p5I2t3f2vF/vh0GCqp8YAvDoU0k+H5dqfBuUExgw8mOTDDA8GMB06U/z+N5+08KYmE7tiqR82sDqrMSIAGj0AEGEb8RhSrdaEfUAt1wUWmDpqmGxQtt/kIZVx171jswtoE+rEVtxKqrYKFKrn0/wDTUlHxFoCJ0VDksC+cQgDKUiHQSxY5HNqFzonfGdR2SQW4mCG5WhMslMG+krveWqu6TdsyExHe23jMJlftQbtOulVAhs5T8tdXpmKbWxLHRBiB9In7EGJ7PmHeaO+1pCcHJ9M8981Og9D6YgNWtUvTGhp1DFRrOiPC8sh4zw3irzpx1wJGqltq7oerE42Nu5SY65TxheOzmwRler4rwuXS9qrx4Ur3gzQ0ghZt+ziZGCa5Dxyhv5AxBJT8i1G+rky/zrMtoVEkRcorelXLAikxLtT3TKLdFCRBRTB683lhSkboBVVSF4fXv8uJ0i13FSANDkFf
 M4dlQlSp
 rTrUVaMA2fbIqo17dIav6x9iU+O+YZFTnyCTs2BNt+W00mOQzrlD34z3PWAnvBfpkwrZkQL97GplB5Bw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hold PTL in pagemap_hugetlb_range() and gather_hugetlb_stats() to avoid
operating on stale page, as pagemap_pmd_range() and gather_pte_stats() have
done.

Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 fs/proc/task_mmu.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 0102ab3aaec1..68077aef6c5b 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1893,12 +1893,14 @@ static int pagemap_hugetlb_range(pte_t *ptep, unsigned long hmask,
 	struct pagemapread *pm = walk->private;
 	struct vm_area_struct *vma = walk->vma;
 	u64 flags = 0, frame = 0;
+	spinlock_t *ptl;
 	int err = 0;
 	pte_t pte;
 
 	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags |= PM_SOFT_DIRTY;
 
+	ptl = huge_pte_lock(hstate_vma(vma), walk->mm, ptep);
 	pte = huge_ptep_get(walk->mm, addr, ptep);
 	if (pte_present(pte)) {
 		struct folio *folio = page_folio(pte_page(pte));
@@ -1926,11 +1928,12 @@ static int pagemap_hugetlb_range(pte_t *ptep, unsigned long hmask,
 
 		err = add_to_pagemap(&pme, pm);
 		if (err)
-			return err;
+			break;
 		if (pm->show_pfn && (flags & PM_PRESENT))
 			frame++;
 	}
 
+	spin_unlock(ptl);
 	cond_resched();
 
 	return err;
@@ -3004,17 +3007,22 @@ static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
 static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
 		unsigned long addr, unsigned long end, struct mm_walk *walk)
 {
-	pte_t huge_pte = huge_ptep_get(walk->mm, addr, pte);
+	pte_t huge_pte;
 	struct numa_maps *md;
 	struct page *page;
+	spinlock_t *ptl;
 
+	ptl = huge_pte_lock(hstate_vma(walk->vma), walk->mm, pte);
+	huge_pte = huge_ptep_get(walk->mm, addr, pte);
 	if (!pte_present(huge_pte))
-		return 0;
+		goto out;
 
 	page = pte_page(huge_pte);
 
 	md = walk->private;
 	gather_stats(page, md, pte_dirty(huge_pte), 1);
+out:
+	spin_unlock(ptl);
 	return 0;
 }
 
-- 
2.43.0


