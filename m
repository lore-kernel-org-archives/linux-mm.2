Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79FE2C531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 01:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E39CC6B00AE; Thu, 23 Jul 2026 21:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9B796B00B0; Thu, 23 Jul 2026 21:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC77B6B00B1; Thu, 23 Jul 2026 21:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3906B00AE
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:35:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 065601A026F
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:44 +0000 (UTC)
X-FDA: 85021953408.15.7CF0848
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 16D22A0011
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HZNXt+r4;
	spf=pass (imf25.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784856942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8NGeKqua+tRU3jPUjhDe7h+RXR8SmOKilK5RCupyqUY=;
	b=B/cir057LZJiGd+/cIOp0NHaeF0tmGqY/wbd3JJ5Xsirs9XgSuZrHov+ZwLiX/x5kdpzCo
	bveGGw2TWjsuzFOH5bKGES2aBh2ut7zqPAsTYzaRjPVHWPE9kkJ9R1io3BmCxWhS70PBOR
	a8/BY1GnEH/sybuF/weflyEXRnTYBQE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HZNXt+r4;
	spf=pass (imf25.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784856942;
	b=tBf1HMiEpf6vbVFOzyHO4PLTcSYSkV7J2J1X519j90YFBV/VFT+5rNpQercqBAGNHw6XOW
	i6zCtNqbvJUSdFgNevrMz3FCBLrXg94DWqoH2XqMm+YI952D9GpMRQ+8SOc65ht3tfX2II
	Z32oZOHp8htY4jx2PCTAnfB/nDQxrfc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784856941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8NGeKqua+tRU3jPUjhDe7h+RXR8SmOKilK5RCupyqUY=;
	b=HZNXt+r4IuoeqhQd98YUe7OliU1YFcKys7R5mfnlW6DywZLjA9BOJm+5Lsd3S0bPBu2ICO
	Hd2NSKSfTdii9mpwRl6oK3nJzrt3O1i67facOmEaoiC0tnhcpwO6HtkjdUPX1TtQ5UjONo
	LAk1cenPRoO9xLyeVAB/V2L4/zxhQwA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-317-1-f-MQAMNVqJKz5xu6vCGw-1; Thu,
 23 Jul 2026 21:35:37 -0400
X-MC-Unique: 1-f-MQAMNVqJKz5xu6vCGw-1
X-Mimecast-MFC-AGG-ID: 1-f-MQAMNVqJKz5xu6vCGw_1784856934
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E1B051944EB2;
	Fri, 24 Jul 2026 01:35:33 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.238])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 672B6180059A;
	Fri, 24 Jul 2026 01:35:30 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	ira.weiny@intel.com,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	ljs@kernel.org,
	dev.jain@arm.com
Subject: [PATCH v6 14/14] mm: thp: always enable mTHP support
Date: Thu, 23 Jul 2026 21:34:18 -0400
Message-ID: <1a11c6075971d7321bb115ea16a2ec2e0cdfadc0.1784856856.git.luizcap@redhat.com>
In-Reply-To: <cover.1784856856.git.luizcap@redhat.com>
References: <cover.1784856856.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: rx0N7sn7OyXSqu35rfIWdcOGwwXidiVCYx6Bx_N9Z6I_1784856934
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 16D22A0011
X-Stat-Signature: wwbjgkxnsjbd7eu6zyyyt9fk6y5ttcde
X-HE-Tag: 1784856941-496304
X-HE-Meta: U2FsdGVkX192E4qfd+xHClXejQCv9oF8O1uHHIOdpG5nq2xvX4llhi/LenHhwVImGJSE8mgGvQzlfdFfY36lukqslk76KTNad8wAhBJtlvybzHfjhqXYqYf/dh40AN2peMi5iZe7g+bNzHboltEX4Pj2kyWk3m71nYzPMvkJc/0w+q3kTsYlZjC5+vCWNF+hl0SpIBDB/hvRYoYINWrJlaG+Z5G9YHr3nngTL9vw22gwgvt4iEFTnRnzJUZgKcCpxhNaPzS7Bdk5zjg9ZFdUR5soiSscpoYrAPIsXaIXbHU0Z+eJGMbSFRAX8W5dIdDk9Sczx468S+eqh8pZUtHLr08oRnoa9gqhYCsxhelnAunhkvY9NQz6C9lIMJ+kdhFJsn8Z6upjy61JnbuyJZK7p+i7VhYfF8N5UhXe0TSasSHk689nkhO2aVaRM6eT+mbx3dmrD/WPdNK+8MnNkOtT91xkvhFMBFyOAOzdYNjzpZYhDAxM+X8ISkK6exEV6YBgLH/0QRLU8Mb4ekevwI9Zxgy8XGeYzXUsnYRLPAh8kWcSfsD5vZ900ruesDZuBxr437OuzFiky+Ur59lvZm8B6g4+ow2jSl8ObipQFohyTZChmnzPeFONwS+LCex4WnaU9ckTy2p6MDrHTLzMsYyURDlBf8oQIEA8EhfA5xNifxoJSoPJiqNn29NlhY9RrnGq5H/oI+5FOEZxQRKubf8+CLxglPNvIVuEaxet6or4zo5xDX5CMnQExiHui+Ar5j3K0md4LSZQvzytf0+ruaNEjzgjlfSTUEq7FKtLl3HHBgOwgem/HvM2xrfSZrGhHH+RpaR5I1hdOcHQQWfR3h2s81gm2zLRTyZbAxSKfN9hGHAzV4BhTHQJRK6N8O5+xknfh9/XYndKyameOnDhJF6SzjG8fIZAse7RftPKFvkBdUn1yAf3n5Lae1U0noK6NzAPmhtvHBPFpFWxP5BQID+
 NjcCT8UA
 syI8NO/yp0BjHQ/DdciFz5ayzQcZ6mZPFKQGVELv8eOhJUdY0dh5/sJLWFbpBGaZcrZtH9hquFm/uiGUITt46ATwldihssxvM7A98U0VKqL/Ou1Rhubk/O7Wcv97w75aPFLcBWGOUOPKwh7QZejTVeKLLmGaPSwuPORoXcn/HrXgy6f7ZprE/jS2NIs66KmACUh2tVJjItv+b27shdl+AeqU6wWj9uVqA1Q2wKrLBQPOtJKxYm15Xn6PHV/gpUGXA9nGa9ajx0/1qWEZkWA+LzZs26gmXxr4ycORc9Leso3Ph5Yj7jWyy05xpjLvRIizxiaIOdPVDvAdgCKMvw6QVqcO22CNB4lslhe+YimGVb8c2klk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If PMD-sized pages are not supported on an architecture (ie. the
arch implements arch_has_pmd_leaves() and it returns false) then the
current code disables all THP, including mTHP.

This commit fixes this by allowing mTHP to be always enabled for all
archs. When PMD-sized pages are not supported, its sysfs entry won't be
created and their mapping will be disallowed at page-fault time.

Similarly, this commit implements the following changes for shmem in
shmem_allowable_huge_orders():

 - Drop the pgtable_has_pmd_leaves() check so that mTHP sizes are
   considered
 - Filter out PMD and PUD orders from allowable orders when
   PMD-sized pages are not supported by the CPU

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/huge_memory.c | 25 ++++++++++++++++++++-----
 mm/shmem.c       | 14 +++++++++-----
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 78dd16513a11..385a305e7af6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -129,6 +129,15 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
 
+	if (!pgtable_has_pmd_leaves()) {
+		/*
+		 * If the CPU does not support PMD leaves, assume for
+		 * now that it does not support PUD leaves and disable
+		 * both folio orders.
+		 */
+		supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
+	}
+
 	orders &= supported_orders;
 	if (!orders)
 		return 0;
@@ -136,7 +145,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -874,7 +883,7 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
 	 * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
 	 * constant so we have to do this here.
 	 */
-	if (!anon_orders_configured)
+	if (!anon_orders_configured && pgtable_has_pmd_leaves())
 		huge_anon_orders_inherit = BIT(PMD_ORDER);
 
 	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
@@ -896,6 +905,15 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
 	}
 
 	orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
+	if (!pgtable_has_pmd_leaves()) {
+		/*
+		 * If the CPU does not support PMD leaves, assume for
+		 * now that it does not support PUD leaves and disable
+		 * both folio orders.
+		 */
+		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
+	}
+
 	order = highest_order(orders);
 	while (orders) {
 		thpsize = thpsize_create(order, *hugepage_kobj);
@@ -1010,9 +1028,6 @@ static int __init hugepage_init(void)
 	int err;
 	struct kobject *hugepage_kobj;
 
-	if (!pgtable_has_pmd_leaves())
-		return -EINVAL;
-
 	/*
 	 * hugepages can't be allocated by the buddy allocator
 	 */
diff --git a/mm/shmem.c b/mm/shmem.c
index 4d2e1b91ec26..008df558af23 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1830,16 +1830,19 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
-	unsigned int global_orders;
+	unsigned int global_orders, disabled_orders = 0;
 
-	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
+	if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
 		return 0;
 
+	if (!pgtable_has_pmd_leaves())
+		disabled_orders = BIT(PMD_ORDER);
+
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
 						  shmem_huge_force, vma, vm_flags);
 	/* Tmpfs huge pages allocation */
 	if (!vma || !vma_is_anon_shmem(vma))
-		return global_orders;
+		return global_orders & ~disabled_orders;
 
 	/*
 	 * Following the 'deny' semantics of the top level, force the huge
@@ -1853,7 +1856,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	 * means non-PMD sized THP can not override 'huge' mount option now.
 	 */
 	if (shmem_huge == SHMEM_HUGE_FORCE)
-		return READ_ONCE(huge_shmem_orders_inherit);
+		return READ_ONCE(huge_shmem_orders_inherit) & ~disabled_orders;
 
 	/* Allow mTHP that will be fully within i_size. */
 	mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);
@@ -1864,6 +1867,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	if (global_orders > 0)
 		mask |= READ_ONCE(huge_shmem_orders_inherit);
 
+	mask &= ~disabled_orders;
 	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
 }
 
@@ -5395,7 +5399,7 @@ void __init shmem_init(void)
 	 * Default to setting PMD-sized THP to inherit the global setting and
 	 * disable all other multi-size THPs.
 	 */
-	if (!shmem_orders_configured)
+	if (!shmem_orders_configured && pgtable_has_pmd_leaves())
 		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
 #endif
 	return;
-- 
2.55.0


