Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 854DBC982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61E7C6B00AB; Thu, 17 Sep 2026 21:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D0296B00AC; Thu, 17 Sep 2026 21:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498126B00AE; Thu, 17 Sep 2026 21:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BD6F6B00AB
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:47:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E680A5DC6
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:47:08 +0000 (UTC)
X-FDA: 85225194936.08.A2FA16A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id AA20AC0007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:47:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ibXFjyjN;
	spf=pass (imf28.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789696026;
	b=zTyECT/pMgkgzMo1GkF4HrinCQei80nJ1peO5jGNUlZdINF44akpgEOFQR1GfULeCsRes5
	l/G6DGIXLXaruPhFYeQ08fi5OJG7u1J34KaOfAz7/a1MkEPN0jVXluVwqSviViljPUz58j
	eZUJxCSc4tOXm00m82ydhuptGcUOans=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ibXFjyjN;
	spf=pass (imf28.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789696026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ovPTbvLEJJOqEFcDDpslczGlymPsHZBK7w/POdlYcQ=;
	b=SYd5HUbgfQ4371HxJm/+UDc05F8BtX7BGFTnOQQ08MnRnUe7bAGG+hZsd1mWob8Q8aBDS8
	/m10TAKdheow+VxwWhP3siUpcb7t9wY88gUpJVfu2dpbrLyTxD/F73j9gfxpW8LJt4FvMs
	LN0eTBI6VM08daYxRT3ciXvTGoRoLZc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789696026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ovPTbvLEJJOqEFcDDpslczGlymPsHZBK7w/POdlYcQ=;
	b=ibXFjyjNgtWv0kwdvsgP79U7DydokHYWa7/Xwo1DMJgQByrS5wsBiQP5Ne/XHN/RdE1feR
	+zmBD6ychadqG/75r4uoPZ+rVkaeSEuymK2tGMQaGs5TJnWXT7XG8tcn/pRbDZqe5dnocH
	Nsn9NQyFa/9WF/kPsdrCbWFPtDGo+H0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-458-ngUFKrJONAmcmwzqvcMYeA-1; Thu,
 17 Sep 2026 21:47:04 -0400
X-MC-Unique: ngUFKrJONAmcmwzqvcMYeA-1
X-Mimecast-MFC-AGG-ID: ngUFKrJONAmcmwzqvcMYeA_1789696021
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A7F61954229;
	Fri, 18 Sep 2026 01:47:01 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E4B9718002A6;
	Fri, 18 Sep 2026 01:46:57 +0000 (UTC)
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
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	dev.jain@arm.com,
	usama.arif@linux.dev
Subject: [PATCH v8 14/14] mm: thp: always enable mTHP support
Date: Thu, 17 Sep 2026 21:45:35 -0400
Message-ID: <752f528f0fed5cdc9de12b54260b0495d4e5a6cb.1789695931.git.luizcap@redhat.com>
In-Reply-To: <cover.1789695931.git.luizcap@redhat.com>
References: <cover.1789695931.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: Zqyy31tKMj6H1sGjKlfmMnJUb3ZFv_LQxgpl9wx3HpA_1789696021
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AA20AC0007
X-Stat-Signature: 6665pw93mdxppns3tm5ceduzom1ig9ku
X-Rspam-User: 
X-HE-Tag: 1789696026-805892
X-HE-Meta: U2FsdGVkX1/v+ZCFwJlOkzIA+e/1xRkWz9r8k0UE6/oHDalWUVTVmv6YYiZlltu8MxZuGepkneitYahZTb5lJRubBAZURjNf9Dso+TQigcA/g5dp3yYFVbuaDR/T5zSJcMl0UnG9VYSjhc0+CihW7x7yAruAH/SdRUAyv+2DsxzmAElaihnatZYcdx+LzSAIS3HefQYB/wjG8kTi56AbzDoeG0pROsvKGpi15Xp7L1OhP6fnLogAHKnT9W/enAF5CuzuL0gxGPwyHt2DLxwA2TuWs29fxGpmsY1FC76F2aY0n/DfHSjmDW3DHxOOhxtadrlO4XfCyiKvxHU2cquDaKwi1FxN/wllxXaxMp/wQ80GBvbFzGhfyrasSOGWdxgjin6LFbuyMU9jflJIhJQuhsHEtVTa7BPfTcdy2jRs6kwl28RiNJIwXtAUOZPjrnDD/upG8T5IXFNu8kfr6v1jGhrQlLWaO00pKGWmuiD07354wgYfsIW7HRs/L9iAgyB3Eb3jMhODt1Nc2WP0ojK3GD4uQ9wzj4/NM38OJZN+nKoalOHQCn76Kit8gh5jR8bYELkvISy7h3SPc7xjdwL1Rk7jNEZRH+kwF4iyLGVaDwGXndPKeLPCW/SpNHOEWbJDAtTug7CTFKmDyx5WD1fIIFsKYIMIbrmZ93kacuwGm3nGuncyo3B5Xg+x1q/3+Uh7owC5oEgeUvdl6cCvCWIOTsB3T2OPKxBPtg/A0bU6CB65PQczgq1GeWRh/5o/rPA9TJumYhcLMGHX5sLda9bWBXIiziUL+FYsyuZx3YxA6DuKXk/uFIKzGtMy/pyixnn1ibDQPT4ZXy7ozSfRiINGfeJfywsEzLAl0TiEv5hSVs49FmsFBEv1UVZQKVtU1zy+m+kKGOc5kA7/iO5EgySNArlOzbgVVkrD9ui1Dbaz0kMjNqC/UlL9TkgomR1JLpsqX5RGvYiaG8rOmWedXr7
 JEbIfsIM
 pwM4jgYoTHE7RgTmOzc9zmda27Uc8M075yXubUHZOLxSWaAsI+ZZRA6xdQkX8UrnEq5sUVJHv4FcUPS2kzu7ws6uDREG7uUt3YRGx2YThgSTe0uAa6qAMvSDH+6XZBEKwKNrU11Q7RQUnNW+YnTHDqQhW43apFQtEZMb+KstY5C0wYTeLmv7J0ZAT998/9XYdah9Vl3IOLybRoehnGFnzu3FdGJjDty+h4I58KPvg2fv5qNxnMoy7ZqNRKTJUBOzO3T2rSoTiZclSTfV8gxZeZS6j5DpebtHcnQVo08+2LFk1GyOnLYC5dxcoYDlvtmQ7eq6HIPJFEcSRovCayGYF4D83ig==
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
index a06025b87e7c..a2d6de3ea988 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -189,6 +189,15 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
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
@@ -196,7 +205,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -979,7 +988,7 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
 	 * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
 	 * constant so we have to do this here.
 	 */
-	if (!anon_orders_configured)
+	if (!anon_orders_configured && pgtable_has_pmd_leaves())
 		huge_anon_orders_inherit = BIT(PMD_ORDER);
 
 	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
@@ -1001,6 +1010,15 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
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
@@ -1091,9 +1109,6 @@ static int __init hugepage_init(void)
 	int err;
 	struct kobject *hugepage_kobj;
 
-	if (!pgtable_has_pmd_leaves())
-		return -EINVAL;
-
 	/*
 	 * hugepages can't be allocated by the buddy allocator
 	 */
diff --git a/mm/shmem.c b/mm/shmem.c
index bc2de3a7c1ea..8c0f7e3efeeb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2046,11 +2046,14 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
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
 	/*
@@ -2058,7 +2061,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	 * sysfs configs.
 	 */
 	if (!vma || !vma_is_anon_shmem(vma) || shmem_huge_force)
-		return global_orders;
+		return global_orders & ~disabled_orders;
 
 	/*
 	 * Following the 'deny' semantics of the top level, force the huge
@@ -2072,7 +2075,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	 * means non-PMD sized THP can not override 'huge' mount option now.
 	 */
 	if (shmem_huge == SHMEM_HUGE_FORCE)
-		return READ_ONCE(huge_shmem_orders_inherit);
+		return READ_ONCE(huge_shmem_orders_inherit) & ~disabled_orders;
 
 	/* Allow mTHP that will be fully within i_size. */
 	mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);
@@ -2083,6 +2086,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	if (global_orders > 0)
 		mask |= READ_ONCE(huge_shmem_orders_inherit);
 
+	mask &= ~disabled_orders;
 	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
 }
 
@@ -5630,7 +5634,7 @@ void __init shmem_init(void)
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


