Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80D78C5CFC1
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 07:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A17EF6B0925; Mon, 17 Aug 2026 03:17:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0236B0927; Mon, 17 Aug 2026 03:17:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92CA16B0928; Mon, 17 Aug 2026 03:17:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F4076B0925
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:17:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 09E37A3187
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:17:00 +0000 (UTC)
X-FDA: 85109904600.05.63F470D
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf01.hostedemail.com (Postfix) with ESMTP id D258740003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:16:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DsyUV6KN;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786951017;
	b=0EeSQRwU6crh2Eabao47QyOOInsnmnZzA7MZjwpLStAoXjEn0uRQ4AVWjjttaNEawtmiOK
	3jypl1u+Gcr1PGJ1qX7N36qeQx2aTSfCsm4UCe7ruqOROqpcRYFT3npJM0ezBb7+hCobU1
	gjVGHsWgVtFw9neShCqxp9/gCeHJijk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DsyUV6KN;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786951017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NoWPmd2X0OYLbm11P9Q08lQNXkCRPjJwt7qQhihJ0Ks=;
	b=f/OD86t1R84nKaK4T85vqEpO1LfqtAiElbbnhseKhcjpVPnCeMpPz6a5GGPUaA2+uFuF3W
	mb9RqX12BGIC2+WBFkqoS4rpnz1aTM4+Ve0s7kok3udPhbmFRwLGZvPun3PEV6ClVeEacs
	j48kH+91LmW0gsg9a6bPKia3jQDiLr4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786951012; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=NoWPmd2X0OYLbm11P9Q08lQNXkCRPjJwt7qQhihJ0Ks=;
	b=DsyUV6KNV/5Rf2cm58+BTuMm+mosnzmzDVVSj7aCMm4wZtNhSfIgdUhiumj//WzPRNUTrfMUUOT+WK2211UecjYU+CTPNiWjHx9jxaTZmsySzlNmn+9s2VIac0aEqtOpRzAZpHpXjEizvQuknRTeH0wjVipot9RrU6vt4qyWcN0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X93Z8A3_1786951010;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X93Z8A3_1786951010 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 17 Aug 2026 15:16:50 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: shmem: fix incorrect vm_flags usage when checking allowable orders
Date: Mon, 17 Aug 2026 15:16:43 +0800
Message-ID: <ed34ca03ae7d65e89467fb87bc961f5497049c00.1786948410.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D258740003
X-Rspam-User: 
X-Stat-Signature: 3nu4xu85rtmpbebo8o84nhpr1kcm5835
X-Rspamd-Server: rspam06
X-HE-Tag: 1786951014-713791
X-HE-Meta: U2FsdGVkX1/0SGd5jLE/X9k0Q3iDcz05YcU1Dg78ceiA/OitgCSemeJRlXrzQ2o5oOHgL6nspvJ95oKKJrLFghGf/oB+YtRhu/1SMNdUhCLIdEzrGP6Zk6xbZE60d8j9ck4ntdzXCmpLzk1pu8R6eoOyn5KxTEG3eAzCX3+itkPkqOqyTQbaRy/izs4UIiRLZCwCq7KMhosqElk/pHpbMFt6Fe64e7o4dMZmOqk31nk/1ILaCnXYrpZRwAArIwNLq50x9jkXxlymwxPkxx4fuH2Kl+6yfcCSYDd+yEfHn6cpBr03zW3unKMgKVNc43PNOybyGXwrClwpXYMB5GvUtVnY33xmNuBkq3ZcQOFnW5WJOQxoBGxbJ9LXnsi9NH9Hu2A7yPAVjriKlxLk9Ata1aJtQ/NLGjQNi9faMzrrgtYZvJn9QE2a7+kQRFN6wccllA+k2tt4pY9mDFVFYnjuhFsOlKer/RIHiNHtPWd8/6ijB7LxB+QiEzb2nGUAv2VKDiLqZWRFewmh45nYvEf4IS49RDXdh8horuxeGv1jVIUnF0mxcj8xv/4z5xpoV4crjOGtG5t+iskEolaxtmD7mi5PZyEznC8Xh20dCobBnEKG4H3SO6TH1gG6+Tl0ESPczDwqfsV/Amtz9z4xImDYfXC1ZGpQr6P7s1cPavw3xWvYtBuxPKqKwan5h3QZIpi9zCxG08ijbXKUlBGlHIIZBg4S85x7E7Z+agMApB4WAEV6UIZNiXtZsrR6GNOYkNak6ON5q1PBg+5D5xjgrd1jKh/BhJ37sWLRikmgIgKBboremEg3cUIblFZqarlSOKfE1WHpGuE7dF52TMhq4RAzDtaMY/4qmIrIdDoxRjvKw6/QkqGUgxeZda/R5NjOZfySfNJF2FHI5efBWiKC6zXZTITyC3XrYFBex8/ftiRL2LJ5yvr28viOStyw5sdpqGEP6zHn225Tn7+kOuN+rHE
 OHy95plR
 CaPKR88rl3FRkwuONawj9bruhvYjmo4l8AMAe4qm1qEI0gvR+chRH9yUKisq6lsfFQLrnXFKyTShEoC2/8GopuFciBQO3ROVSnaEl5F4Jp2bAF+i7pWfZ7a1shMe1NEK+qxlYSjJLzQS1K6npukT3IJ1UUWIt/zRQwCT8do/RZCIm+r67q+eaRr/Bg8waYEpl7ptsrtIUHnj89i3bUUVilKYypsWIozNbS8FoIIu/NugvJebslnAAlGHY2a4t2FaPUCNgCFSZ19r8UciVbgYMDy/Rc/PrDJt5wlNOYzQ2RiXc7j6kIQ7jnZyK60I4MVyvyYq1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lance reported that when MADV_HUGEPAGE is set on a tmpfs file mounted with
huge=advise option, khugepaged fails the allowable order check and does not
scan the tmpfs file for collapse.

After commit 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into
shmem_allowable_huge_orders()"), the shmem/tmpfs allowable order check reads
vma->vm_flags directly.  However, when MADV_HUGEPAGE is handled,
khugepaged_enter_vma() is called before the VMA's vm_flags have been updated,
so the check uses stale flags and incorrectly rejects the VMA for collapse.
As a result, khugepaged does not collapse the tmpfs file into PMD order in time.

Fix this by passing vm_flags as a parameter to shmem_allowable_huge_orders()
instead of reading it from the vm_area_struct.

Reported-by: Lance Yang <lance.yang@linux.dev>
Closes: https://lore.kernel.org/all/20260815181632.21453-1-lance.yang@linux.dev/
Fixes: 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into shmem_allowable_huge_orders()")
Cc: stable@vger.kernel.org
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/shmem_fs.h | 8 ++++----
 mm/huge_memory.c         | 2 +-
 mm/shmem.c               | 9 +++++----
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 5663dff53186..321017e0fd63 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -127,13 +127,13 @@ int shmem_unuse(unsigned int type);
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
-				struct vm_area_struct *vma, pgoff_t index,
-				loff_t write_end, bool shmem_huge_force);
+		struct vm_area_struct *vma, vm_flags_t vm_flags,
+		pgoff_t index, loff_t write_end, bool shmem_huge_force);
 bool shmem_hpage_pmd_enabled(void);
 #else
 static inline unsigned long shmem_allowable_huge_orders(struct inode *inode,
-				struct vm_area_struct *vma, pgoff_t index,
-				loff_t write_end, bool shmem_huge_force)
+		struct vm_area_struct *vma, vm_flags_t vm_flags, pgoff_t index,
+		loff_t write_end, bool shmem_huge_force)
 {
 	return 0;
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ced400f72d43..70f57d700739 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -187,7 +187,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	 */
 	if (!in_pf && shmem_file(vma->vm_file))
 		return orders & shmem_allowable_huge_orders(file_inode(vma->vm_file),
-						   vma, vma_start_pgoff(vma), 0,
+						   vma, vm_flags, vma_start_pgoff(vma), 0,
 						   forced_collapse);
 
 	if (!vma_is_anonymous(vma)) {
diff --git a/mm/shmem.c b/mm/shmem.c
index 599665a3d6e7..6f1ad5456aca 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1834,12 +1834,11 @@ bool shmem_hpage_pmd_enabled(void)
 }
 
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
-				struct vm_area_struct *vma, pgoff_t index,
-				loff_t write_end, bool shmem_huge_force)
+		struct vm_area_struct *vma, vm_flags_t vm_flags,
+		pgoff_t index, loff_t write_end, bool shmem_huge_force)
 {
 	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
-	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
 	unsigned int global_orders;
 
 	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
@@ -2430,6 +2429,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 		gfp_t gfp, struct vm_fault *vmf, vm_fault_t *fault_type)
 {
 	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
+	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
 	struct mm_struct *fault_mm;
 	struct folio *folio;
 	int error;
@@ -2507,7 +2507,8 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	}
 
 	/* Find hugepage orders that are allowed for anonymous shmem and tmpfs. */
-	orders = shmem_allowable_huge_orders(inode, vma, index, write_end, false);
+	orders = shmem_allowable_huge_orders(inode, vma, vm_flags, index,
+					     write_end, false);
 	if (orders > 0) {
 		gfp_t huge_gfp;
 
-- 
2.47.3


