Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BFE9C88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 08:25:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3F086B0092; Sat, 12 Sep 2026 04:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B152E6B0093; Sat, 12 Sep 2026 04:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52E56B0095; Sat, 12 Sep 2026 04:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 892946B0092
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 04:25:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F38A740418
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 08:25:50 +0000 (UTC)
X-FDA: 85204426860.19.56B2BCB
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5677120003
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 08:25:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=p+QhlJEF;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf31.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789201549;
	b=0pBZq3tdsNlQVh4jDAaEr7+wz2NyiF6ytaFT+3yUoyg6bP1TvNg4RXBbgSGQr0ELzKzwuP
	a3vYckzxdjKy+XDk5BKbdJRjhn8WJYKr4B5gjFOpkb4noMVVi6c1L0YLyFPjRetn0n//6p
	MVC4wsf5W2Gk/rhK59RM4vLXO7aVDxs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=p+QhlJEF;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf31.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789201549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zBogXOhOlG1kMkxMqII2ZbwGmlciHENob2EpVE6bVCc=;
	b=yBTOMTQznbI6nlw2TzQmmy90O9kRM2tNxkQEAvj2gRoQDWrHtnIgEQ38lICSwggvYSm/q0
	mbnqvmhp7gj62Dcn4qAGAcSwD/uq3Iopf0CqmYO1TDRx9cvPLHWrfdmU5xF6wnFFUffJP2
	NyFUISg193KBiRX481WB4FW0z2XAFKU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=zB
	ogXOhOlG1kMkxMqII2ZbwGmlciHENob2EpVE6bVCc=; b=p+QhlJEFq21IlZxo+c
	NxJyxgDg8fE6y/NEaX/XoL6bTwDF+tDVS++xpBFt/OaZSZY0SSExhsUc+C5k1hHI
	kNDk49X/U5ZtJRXr/AwtjCu6H1R1oPNh8g201lbpGjrw3gnoG6yLSG0avCaek5yv
	QKgmBzdwo8jjm+x6m996fAOI4=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDnr7FODKVqmfMoSQ--.44660S3;
	Sat, 12 Sep 2026 16:24:48 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	borntraeger@linux.ibm.com,
	chengming.zhou@linux.dev,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	harry@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nico.pache@linux.dev,
	peterz@infradead.org,
	rppt@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH RFC 1/3] mm/pagewalk: allow folio_walk_start() under a vma read lock
Date: Sat, 12 Sep 2026 16:24:05 +0800
Message-ID: <20260912082407.75875-2-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260912082407.75875-1-xialonglong2025@163.com>
References: <20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn>
 <20260912082407.75875-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgDnr7FODKVqmfMoSQ--.44660S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7ur15Xr1rZr4xGr18GF1UAwb_yoW8Kw45pF
	Z2ka4FqFWvkr1I9w18Aa12yr45u34kKFWUC3ZFgry7ZrnIya1fKF1kt3Wjqa45Gr4xAFZ5
	XrWDKrWkuF18Jr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jSv38UUUUU=
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+BAbFGqlDFCUsQAA3R
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5677120003
X-Stat-Signature: fu4gt86w9aa3xnzx61nhr37k9g5f516z
X-HE-Tag: 1789201547-234432
X-HE-Meta: U2FsdGVkX1+XC98n90HIRiiNuxaKrxx6O1A/p4cKZCfl+j1RO3g4HTysGJs5afQG/m7/Uo7gHOWRNVPEK4h6+FH4vhfqj16cM95idztFnrgsGb8GWbpALpqSKVXbVup9BcOfNgkcNVt5ywP4n3qY4FK4PcJtj9uttBzRyw3t3upZbdadnU/PCU08FpRj2UGgtDgnuiuhmvVtvMdSRGFHLrzEudTP1VI3kfIj0/wNvdzJeS2cS49Fs3bialqOIOcqfQPayu0fcfoYuhzPnTfOGSxiMjQctA+rA4VDM2O8vfnaFSLyd+isNe9PEwQj6FkfhUrYcH7p9jXA+pShnSCXrDvhb0bjf3Zj9PQK+w3biQVPIyS+m6HwFhWpv9jfYbqO6P1P8Uq+hGflW9jxy70Bf1a6RcJWQ7KUo5rPR9OgeADROPJX8ddo8bSibkA2GPtgZwl+YZjq2D43GKOC2myoiXWtouTpySHzDf8aGzvpjjuDL57PbDaZhWYDgVp7x6GTPKJKOEtW/6XctqfH3gCCr2VxEvwPFDhxcp7JdqZ0KiIOUz5fIK46edmdHA/CQPM+M/tqZOFOalADEXd4os4frQJGmv0H9LltTgMxsssKRlBK9tKmMv1I6Nar7QXODI2ReuNLLNFkmvJPDvRecndE27H51nq6Ob+RytOTuVFMmxELLA4VeMQNNYL83wM6HuHcLmPXuoHMWeE0TZiBMtIwkZh2BjkNoMheoyZ68Mw9c6DDp2e/tEzf0P3dhprLmGlZ7L43iRBkxLMfTehlA7iqx7fILR2TUiyIx40NS1/wYUIvE4+fRnfwKzaDLcj7J42s8dxeuNZ9U+teEXqMe6fQWjuPTHPaNaYOlmNwVsHWre5R5i/eyiyftdggRWfGq/i8+yUrnpCr+3QO88C+lyadmdI5CZCnstQFX5HOadL/DONWOP9tSjsZ2FA7NweCdzlyjjguaOK0zVCFvZ4HGnI
 nszGpPDY
 wgEWTO1LkaFCaWfzoZMnB7BMEiXBCDH9RCY3j+oqMRj86LbHkTMWzsUAtlPASQ8RFr9ghkMJuObAxg3D91/YmNXGlXY+T71Z+v7g/1p2EHigtO0TPJ/I3Ea6/DctTaO9U4pM9QdfUaicDsX/cC2R9d+WFJolr9fxtRjC20qRMxmzQWm7fMqRDmcliZ0CDyyGzy/8aQW1yKWSq//jlObd5a5O9jeZGp5oU5eJklFt6e5x4iqLBJlDhSx+zBzr5TqVYVDL8eXRmYfiiJZ/7t6OdWt8ScqZCjKEA4nA8hhZnPi0dwZWSylYgfo+E5Rsjj4eqDiJIaR7fZXbf/9DZuoj0o8A8UeAZyuHhQQZOVMehVCc/LjaTwspP/FvfBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

Allow folio_walk_start() to use a vma read lock by replacing
mmap_assert_locked() with vma_assert_locked().  This lets KSM look
up pages without taking the mmap read lock.

The vma lock stabilizes the mapping, while page table locks serialize
entry updates.  Callers walking another mm under the vma lock must
also hold an mm_users reference to prevent exit_mmap() from freeing
the page tables.

Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 include/linux/pagewalk.h |  3 +++
 mm/pagewalk.c            | 11 +++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
index b41d7265c01b..cafd7b15f480 100644
--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -151,6 +151,9 @@ typedef int __bitwise folio_walk_flags_t;
 /* Walk shared zeropages (small + huge) as well. */
 #define FW_ZEROPAGE			((__force folio_walk_flags_t)BIT(0))
 
+/* The caller holds the VMA read lock instead of the mmap lock. */
+#define FW_VMA_LOCKED			((__force folio_walk_flags_t)BIT(1))
+
 enum folio_walk_level {
 	FW_LEVEL_PTE,
 	FW_LEVEL_PMD,
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index cc07fcf50e87..57ffaf2a85b8 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -894,7 +894,11 @@ int walk_page_mapping(struct address_space *mapping, pgoff_t first_index,
  * huge_ptep_set_*, ...). Note that the page table entry stored in @fw might
  * not correspond to the first physical entry of a logical hugetlb entry.
  *
- * The mmap lock must be held in read mode.
+ * The mmap lock must be held in read mode.  Alternatively, with
+ * CONFIG_PER_VMA_LOCK and @FW_VMA_LOCKED, the vma lock may be held in read mode: the
+ * page tables of a read-locked vma cannot be torn down while the mm has
+ * users, so a caller that walks an mm other than its own must also hold a
+ * mm_users reference for the duration of the walk.
  *
  * Return: folio pointer on success, otherwise NULL.
  */
@@ -912,7 +916,10 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 	pgd_t *pgdp;
 	p4d_t *p4dp;
 
-	mmap_assert_locked(vma->vm_mm);
+	if (flags & FW_VMA_LOCKED)
+		vma_assert_locked(vma);
+	else
+		mmap_assert_locked(vma->vm_mm);
 	vma_pgtable_walk_begin(vma);
 
 	if (WARN_ON_ONCE(addr < vma->vm_start || addr >= vma->vm_end))
-- 
2.43.0


