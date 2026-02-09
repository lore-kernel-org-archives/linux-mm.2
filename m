Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71C40E94615
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 22:15:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5CAF6B0095; Mon,  9 Feb 2026 17:15:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE73D6B00A0; Mon,  9 Feb 2026 17:15:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFBD56B00A2; Mon,  9 Feb 2026 17:15:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9C8A36B0095
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:15:15 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3C4DC1A0312
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:15:15 +0000 (UTC)
X-FDA: 84426324990.15.CC24DC1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7BAAF40010
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:15:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d37FRF9G;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770675313; a=rsa-sha256;
	cv=none;
	b=pwgxAg5kWJaWXSQDrySvtnWZsxWfGVxjRUPEl802uVr6eiODvcZVLE4k5OeEH1dzW2ic9E
	gRKtUgsc1JYp2pc/yc2FCBvFVHJuV3jWiRZlY3yYcq7+E4knF/vAXtfFp8bMq0hyNdxT/s
	FWkmSsNWn+9jytQxEn+R7vyM2DEwtII=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d37FRF9G;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770675313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+HpD3amJN83e1nK4/UYx8PNBs97+doRf6FtLNeMX5c0=;
	b=agWqqVo1miYUQ3EM0CqmEC3q8N20YytbO50rodjsxryepZDPhHi0ys4TBcnSCmUxWbnlPN
	54aX9RYT6Z8Lg4A+DfrtlQAByyqA4U7a4YhDhMF+8szLoYLe8GPWw/fsmB16LPpqpXjhyE
	QdJHP8NorbTrNUp+oPGiA49VXvCiGa8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770675312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+HpD3amJN83e1nK4/UYx8PNBs97+doRf6FtLNeMX5c0=;
	b=d37FRF9GcECnTk+9C6rc+URbutXcomtNXKla10FG/8cwKYbn++DGPyE/0WopKNsNAfooID
	BQS9PFXmrgAbbLdiEFQYC5l2LS3dSYRExeV+UTX/2WQPzX2EuSdMMkq3nmjHOpeG5dan7w
	3+5Nnx+8REGGTvsUJf6XN7KO6/NNvck=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-446-_cUmsVACN5G5gKmJRBu_YA-1; Mon,
 09 Feb 2026 17:15:02 -0500
X-MC-Unique: _cUmsVACN5G5gKmJRBu_YA-1
X-Mimecast-MFC-AGG-ID: _cUmsVACN5G5gKmJRBu_YA_1770675301
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4D961955F12;
	Mon,  9 Feb 2026 22:15:00 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.66])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 47B0818003F6;
	Mon,  9 Feb 2026 22:14:59 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v2 10/11] mm: thp: always enable mTHP support
Date: Mon,  9 Feb 2026 17:14:32 -0500
Message-ID: <29e8dfc2772af4b6e0db24134ca3563ec422b91a.1770675272.git.luizcap@redhat.com>
In-Reply-To: <cover.1770675272.git.luizcap@redhat.com>
References: <cover.1770675272.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: qFq6FwIpehykfrWikrdCLrMTlZlR-9AOp--MRCDNbVI_1770675301
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7BAAF40010
X-Stat-Signature: xtxkw7amqdgb57a6wwxiy1zpybo4zhfh
X-HE-Tag: 1770675313-505806
X-HE-Meta: U2FsdGVkX1++ljiLeBkyeJflwPfYbVOYGl0t8MxHzvfN4YAb57jQt24GVbSDB6cFy0ZlB5sKW/CvtkxFK4uktw/L4QGzEDdH1tL7yaSWvfehDawQahsf61xtVCxZMWhf4cS34nB+IGJZpB7CmpxpenkGXvd9YB/Lz+q+Yd8XF/p38vyx22ZHfdVwxAy9hr2sPy6Lk9cXVl8G1Ly4yjWeDhMfzBsJHOSAgqcQTTr6Jx3EerlQbfvLRwBRSscBfz/awX8ukNmNc1tkKHxyxSx5U7/nb2rX1ny5FDB6iyo12ukZcZK2wjDh/U9e+v7NHVUjrjtQjGrFycS2Xx9uFiMsvkBCbKSHyXyaLdG/Qr4BrYndVmW6pM0hORTcOIPIRYXOFQsTPPB8s0VCREZWhSMeaH1G6fG8pTo0DXA9OfMd/TB6S3gz57oOj5ITMqdld/zk7j1vg9xMCJKV3W3i5JyNSOfZft2e+79t3mUUU9VtdLremV1DF9EY3uX1g31mlRHZZ0FrkH8wsYRpKki991r4oxGOSE556r6XskJuJ8TaNLUYQJ3G98hbBNEkTCoPjX9MycDOJgApHu9fCTjlLAO4+8p+nhPgpak0EyEuGQXFHkSInF4tdznpwOxnSDHVibeDCIpTAaX4vOZG3887SJV/GtTb3OmpWknLT6GaYfiFulJA4OwISLLMmsVQxwv2Wk3cTXrrfMLluJ2sjYM6Eu1bd09FZLRykwc/rnutXXfuO1sBCst26AAV/NgBR/CDJWzxR0f6kgvOPns/9cVFOj8DK+YzkTSlpqR6kLGreDToX5hV3rcodnS97ReT9dVeM4Sxm2WNPiDZA6jVUS4/yV3jnQx7gkEGOMOZi2Rh0/Jmj7X9rS6yVFbkU+h545OzewCyM+l3qR8x7KOvYtZTWkwQjWxs4G7wVodRWQQYPhm0E67sCzhOWxtcquM4F39IAsJUzIb7vHmNVItVMd/ufL5
 NOSAoBN/
 cOwfB8YGXoiSqrh4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Similarly, this commit implements the following changes for shmem:

 - In shmem_allowable_huge_orders(): drop the pgtable_has_pmd_leaves()
   check so that mTHP sizes are considered
 - In shmem_alloc_and_add_folio(): don't consider PMD and PUD orders
   when PMD-sized pages are not supported by the CPU

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/huge_memory.c | 11 +++++++----
 mm/shmem.c       |  4 +++-
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1e5ea2e47f79..882331592928 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -115,6 +115,9 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
 
+	if (!pgtable_has_pmd_leaves())
+		supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
+
 	orders &= supported_orders;
 	if (!orders)
 		return 0;
@@ -122,7 +125,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -806,6 +809,9 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
 	}
 
 	orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
+	if (!pgtable_has_pmd_leaves())
+		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
+
 	order = highest_order(orders);
 	while (orders) {
 		thpsize = thpsize_create(order, *hugepage_kobj);
@@ -905,9 +911,6 @@ static int __init hugepage_init(void)
 	int err;
 	struct kobject *hugepage_kobj;
 
-	if (!pgtable_has_pmd_leaves())
-		return -EINVAL;
-
 	/*
 	 * hugepages can't be allocated by the buddy allocator
 	 */
diff --git a/mm/shmem.c b/mm/shmem.c
index 1c98e84667a4..cb325d1e2d1e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1827,7 +1827,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
 	unsigned int global_orders;
 
-	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
+	if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
 		return 0;
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
@@ -1935,6 +1935,8 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
 
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		orders = 0;
+	else if (!pgtable_has_pmd_leaves())
+		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
 
 	if (orders > 0) {
 		suitable_orders = shmem_suitable_orders(inode, vmf,
-- 
2.53.0


