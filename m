Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 765F6CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D71C46B00B3; Fri, 29 May 2026 10:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CACCD6B00B5; Fri, 29 May 2026 10:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9BCA6B00B6; Fri, 29 May 2026 10:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AAB696B00B3
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:57:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 71B651A017A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:57:11 +0000 (UTC)
X-FDA: 84820760262.21.200E5E9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 78B0916000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:57:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jHqixT3Q;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZ/3SDoifl8f0cLPCsdOx/VHK2TElW/aB5rioFk5LQw=;
	b=M+FgemOiQA/BNzr9Z2CabL2iWWCrRf0Umsgw+xUOZ6Wp6L5yu6FrLkUezK0dBoSsNtGfiq
	gHgDnbrxEYInsYE55nuIZf1xp2PJJY0+n03goE7SbeSGwvr2KOhnO7OjaSY0Nc8Lt8AEso
	Dpn80pmh78k8VtDYGXywIe9cgxrEOYk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jHqixT3Q;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066629; a=rsa-sha256;
	cv=none;
	b=m0jrlz57v2GLR6G8jYplqLyXhxrL/II2pmtSj7KVsRc/nvCL0zkVzSod47QmbRn90G7ydx
	3JKB1POQnHzDk6jE2viQf3PUwUEqKZt6S/7u7XjD4S4XtlYoh3x+Me5f7m6rOOFB68PHby
	qyR1r1h2K2xT2zRYm3txfzMRKRzIF9Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780066628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vZ/3SDoifl8f0cLPCsdOx/VHK2TElW/aB5rioFk5LQw=;
	b=jHqixT3QLxCw5bgkUFvRBA9f1Jnf7dp+sX/O1F+IFJxzNwhGyyO/H57zsJwgQADFGX+lNZ
	TXnXnW66YirO/RRSS78wJwqW9gy4zHA3ZAwKvXO0vBwl2uiUXL5wmXL6m22xbErklWgdj3
	kj2iAB2hHUqcin5lu5wybBCJ8dGloYg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-116-wsw1JObFNN6taHimYi1MlA-1; Fri,
 29 May 2026 10:57:01 -0400
X-MC-Unique: wsw1JObFNN6taHimYi1MlA-1
X-Mimecast-MFC-AGG-ID: wsw1JObFNN6taHimYi1MlA_1780066618
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F7A719560B3;
	Fri, 29 May 2026 14:56:58 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2CAB130001BB;
	Fri, 29 May 2026 14:56:55 +0000 (UTC)
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
	ljs@kernel.org
Subject: [PATCH v5 14/14] mm: thp: always enable mTHP support
Date: Fri, 29 May 2026 10:55:32 -0400
Message-ID: <8781a9a0f115705ee11884ed3184b65a1ce39923.1780066530.git.luizcap@redhat.com>
In-Reply-To: <cover.1780066530.git.luizcap@redhat.com>
References: <cover.1780066530.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: V9bjnyUtqJDmN3GDMLqWQ6wolqgMiXYs6l-EC9_MqTY_1780066618
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 78B0916000A
X-Stat-Signature: jhunyk1cgibjymqhu7f9k5ncsqdm1k5d
X-HE-Tag: 1780066629-471358
X-HE-Meta: U2FsdGVkX1+B3DJKe80B5/OM2XHpK3GhqWmG0QEuTLUw12NkuOt5dp71Py3o9OVG1TS+XC4D/0KzSaTcoADAOkp+yZOitxf5gQEeFN+hjFoi0mN+h+HiY3cpkBeaJ/X+dxcByiokrMAMe9a5FBqBqCWdq63VJGXwhHCpfmxxZfv018SdXHZp0zL7FCcCSwqPVA7fXtsDUOrBP83gtiUQeyuS2TiSJdtblyPOlIpPwCjC8txccJ5zDMRwUrhNrPk0leo9p6SjNOUnuIoFcuF5DDScgoiKcDO/vHDU+7a3xDPFc7kOYzzrToq3908oQNGhC6j9F3YFmncix+58FTtLVHUhtkV4PThXJhsipK+15IkWfEbXIiynF1d9v7bG9u03PdhuCoWLQiEm6AxM/YnhWG0B+x0an70OYvPRsRd0AF44m/xAaXJmyI1BMa/q46xjtwNOj8JSJICrV8JdpMPeG1TlJJOU4lOO3tZ3zYzfRs8aZvTOdtktf/zAKBxMR/raSjEZeLVFrJ58GM7wEWCXjFIwfWhQ0qJqJtin0RpWHeuria2QU+lXL34abYsC2rAgkD13OZnIqV2qmilpdbG5Ze+6++9vLCIVd2nhvVXc+4a1z60PFk30yq0eGPeeoD+fw4/C7ingiu3SrS8deNGD1DXDtyEXqOFfYkZCmQ1EQ99Hf4VKYiYMgVw6ORyFzVuO3g78Vt4Et0wHl14nWOWrrJ8jyI3mlWnGanPe8OqMHnKMuI4CsyRUvsyYPXGJ62pgcMdO+Cw93j3GjXm03AwUf0icpIV1eLOeywWgukAKMMqiyWD9embk3+2zZo8lukL3RF/xjTOiNIB7tpp5w7BjVUq73WhBrRBV46p0HUJxXC9DppBklUB6k9cn/Cle5tA2j+RfhG1QoMwfBWE4+7CvkJN+zfMBNL+inZcNwSbJEtpWje3qSKSFnvfgyzwnLTuT9yfRx3YGjdJfk4CEcni
 vZ8wpUoN
 UPZO+iUIRIVmAaT0tcHcjFnKI4Ia4S9i8jeUFg/0cZ7rcbegQpYT2sB/hJNLHbY2xre9Z6u3EiD8s3nXibCNcITdiYJbIJPlf6K0Nk69t7IJK/cabbH9JNNOkxVz3S7jkjnRn44rZXJp+x3bT8/lzvYXvOWtNjx5Y9Yy69O6rWhKHXnX94RP2A/fsrX04gdakGx0Keky9/vyzRp9WESphulr6nxJ/b6hzZe0tggsc/aQwtMxrxOhBpu8AYBMatJ2PVfGfok1qc42yC6iygOC5FJ/czGbvliDhl9UFzAU/F14nddvo5SmixWk9gqOG0kfZpeABSXs/R/r/qclZlAHCPSdQtg==
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

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/huge_memory.c | 25 ++++++++++++++++++++-----
 mm/shmem.c       | 14 +++++++++-----
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 32254febe097..059901a8c6cb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -126,6 +126,15 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
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
@@ -133,7 +142,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -848,7 +857,7 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
 	 * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
 	 * constant so we have to do this here.
 	 */
-	if (!anon_orders_configured)
+	if (!anon_orders_configured && pgtable_has_pmd_leaves())
 		huge_anon_orders_inherit = BIT(PMD_ORDER);
 
 	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
@@ -870,6 +879,15 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
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
@@ -969,9 +987,6 @@ static int __init hugepage_init(void)
 	int err;
 	struct kobject *hugepage_kobj;
 
-	if (!pgtable_has_pmd_leaves())
-		return -EINVAL;
-
 	/*
 	 * hugepages can't be allocated by the buddy allocator
 	 */
diff --git a/mm/shmem.c b/mm/shmem.c
index 079e299ea789..c15dffd0eb41 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1844,16 +1844,19 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
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
@@ -1867,7 +1870,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	 * means non-PMD sized THP can not override 'huge' mount option now.
 	 */
 	if (shmem_huge == SHMEM_HUGE_FORCE)
-		return READ_ONCE(huge_shmem_orders_inherit);
+		return READ_ONCE(huge_shmem_orders_inherit) & ~disabled_orders;
 
 	/* Allow mTHP that will be fully within i_size. */
 	mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);
@@ -1878,6 +1881,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	if (global_orders > 0)
 		mask |= READ_ONCE(huge_shmem_orders_inherit);
 
+	mask &= ~disabled_orders;
 	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
 }
 
@@ -5461,7 +5465,7 @@ void __init shmem_init(void)
 	 * Default to setting PMD-sized THP to inherit the global setting and
 	 * disable all other multi-size THPs.
 	 */
-	if (!shmem_orders_configured)
+	if (!shmem_orders_configured && pgtable_has_pmd_leaves())
 		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
 #endif
 	return;
-- 
2.54.0


