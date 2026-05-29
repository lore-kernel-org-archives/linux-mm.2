Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E0E2CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81A846B00B1; Fri, 29 May 2026 10:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F2326B00B3; Fri, 29 May 2026 10:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72EB46B00B4; Fri, 29 May 2026 10:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64F146B00B1
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:57:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3C4F51A01A7
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:57:07 +0000 (UTC)
X-FDA: 84820760094.29.72A0CE9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 51B1040008
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:57:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bcg7lQ2W;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5KDFdW78oQLvi9zdqYiJHkVU0nXz4LsNL4gO36IoLHA=;
	b=Ps4dqYw0tIeSZrwPYyiNjcr/yhjq+ktjk4bXmab1C8TeL45OJXgliKc12eZiatIOZEq2zt
	RRV78EXVUVr3zQ7TYv8f4FlY2Al08ZLAZECmb0PJuWSGKJ7Rs5nGCjOw2DZ3TKbMbDjGV8
	OBdrh9sS2vhOQ96G5w+xXrh/hBbNZ+s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066625; a=rsa-sha256;
	cv=none;
	b=JNT88shdwSRWOENg6Fa+31v0B2pH00gdx099qJZ/2xd5YQHHx9eZ1Oow8YRgFsD48gqf0n
	tmjcU3OYnsXboAbqXTQ0pltKD+mbAF9f5sEsJdFTNqYiQPjbHD4432yFg8T1WFQU4xfFFv
	QAhZ1nYn5Wx8BUMTcX582ctTsSO3UWo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bcg7lQ2W;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780066624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5KDFdW78oQLvi9zdqYiJHkVU0nXz4LsNL4gO36IoLHA=;
	b=bcg7lQ2WDK9wjgmfoOkMVBOkqbCFaugpmy/RdzkTUmoXeh3SWJIGq6ioyJMAA62PQjNa1D
	ph8/XjuUEP5kaXRniZE6vlPm+bMVMbQPbogib5aaWZLa8nrMb+JG7wHv/n7ZL/zagcLcmW
	0JG9S5i/eULNxWJ728V7Qyijv82MsEY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-84-ftSHDmiTNxCkJXpVX8nWFA-1; Fri,
 29 May 2026 10:56:58 -0400
X-MC-Unique: ftSHDmiTNxCkJXpVX8nWFA-1
X-Mimecast-MFC-AGG-ID: ftSHDmiTNxCkJXpVX8nWFA_1780066615
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFE2F19560A2;
	Fri, 29 May 2026 14:56:54 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9ADD23002D2D;
	Fri, 29 May 2026 14:56:51 +0000 (UTC)
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
Subject: [PATCH v5 13/14] mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
Date: Fri, 29 May 2026 10:55:31 -0400
Message-ID: <9185274a22d31eaf6aca0c8aa5ebaf8b68805055.1780066530.git.luizcap@redhat.com>
In-Reply-To: <cover.1780066530.git.luizcap@redhat.com>
References: <cover.1780066530.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: HT8f_GqD-Maq26aF3zW_5pkms0przB70Cb07dO8_F2k_1780066615
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam11
X-Stat-Signature: q56paw8md15s1u3fy5d16n6qbo6g1ros
X-Rspamd-Queue-Id: 51B1040008
X-Rspam-User: 
X-HE-Tag: 1780066625-564822
X-HE-Meta: U2FsdGVkX197HtkC7Q+G/bE3e6Icod6iWRLvYHO6jqab1xXOHhCWWV2WocS4OYlO/+JePPSwKK1tNaS5NUhHNd6yqo8xUnydv3WBoKl2PBYYOn7ehembv4OXrrRino5X7guwyjWV4T7jxrio/yi4gdozMOyYQ24BCgchHZQ0B57pRE3IVHZYX46KnaptQsdp4w5tvL4zM96cSkzXD+ZZ2CX4fprPFRbupUqhgmZ/RZpGsvPs0IvWI213QTYa4yOk5wZwwI3jJNebCFKuIBJpj2PTB46Ewdc3vKZQ/YLRyXz9yj9509chFM/x8ttUnNg5FAAFhCRUme9HogI+3bJo241rWm/i75Gba/jgmBMGtQy2kQChs27s3QfyX3QH08KWXa9dcKa/Nzldm5/dzfdfklTkowWHMikxTepPJP1Xlz095aWQia+LQSkUvqBx7t9GS6tZTDH9P38FXM3WBHTDQ/UZ8Jcm/GgEfpsweEyMP9g2nDR/0derrwbd1nAhHK2W26Ey6xkTJZjo4YGBWF9jMH0Dre4YFWiymlXfLfB5itfyNI0TBjQN+u8bMLpyNROIRch/umPOrnaJZpgJBuWGnkk4cxEAkMkDcxOVL9caV7BcYQKR9MyEPEq85703ymXjo1tpOxlirDim7A+GL38PWR1AS1snU0CCxKkl2JTzWvPosiFdHIpxx4k8az37HeiWcQQuKlOYhMbyMoARomWYhmkRGZ0dOud/cRZC6yUYKJVJscdUjuvVGKvMt8rNmiS3YU6BulSGI2IxeHNM6WWln19uuM+cLd/3lEr/RgPjCBT3eZVOgypgUTI+OKC6UmXpPntcFfq0Fsf+E4u8PwAxwCZ9Gnt7/qP3g6PsbewAf4s3IB3yMUPThcSBx2pP9oppMRMDiL10LVG89YN3ULCKA0OF2F46YLJohCG8idX0As6jhHn/vZUHmsYigFrW/l6fDckVss10jeoWwFT6xIn
 lR/e3btk
 m5vABXRUjAJogf2wo5AP0u3ouFjXb9Ic4YmohGcDndQKsW82ky46oHDiySR6YnbO7/xU+VOA2sWdXrTtRz5y09ZLa/8Ctf5EQusY94poquURr1m5sRzFOJCzDideOMs6ncNaxXWvhxv/ZQqJ0lBnJLO0O09aNYulqGwK0rsi6uVkOjjK7urzcrqeR7sqDIkfMAK0kB6t8cE+AjCmbsyKiavMwZ2qAJFq/JEoKi9N41iHRMV5PefJgZaoh4c/PKjnEgHNYd38MeKSUsZKZJHTdIiRHjycKZQY3MxZ0WTCUpozRPWnnMFSRxx9u4raopHO/DclHtotMqQHpcK3kkB0yMhhXXn4P5ai/dusX0Y/lT3mEu07fY5DNYY4H0ROxib47h4LlvxAFWp3Y9W3xRScOBMt/TEbFURKhXFxCyCnSrSbYJQJ3yN58KMpTfV8PsxKDPkXia01uH+PJa5M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Despite its name, thp_disabled_by_hw() just checks whether the
architecture supports PMD-sized pages. It returns true when
TRANSPARENT_HUGEPAGE_UNSUPPORTED is set in transparent_hugepage_flags,
this only occurs if the architecture implements arch_has_pmd_leaves()
and that function returns false.

Since pgtable_has_pmd_leaves() provides the same semantics, use it
instead.

Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 include/linux/huge_mm.h | 7 -------
 mm/huge_memory.c        | 6 ++----
 mm/memory.c             | 2 +-
 mm/shmem.c              | 2 +-
 4 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 2949e5acff35..da048aa06761 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -47,7 +47,6 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 				bool write);
 
 enum transparent_hugepage_flag {
-	TRANSPARENT_HUGEPAGE_UNSUPPORTED,
 	TRANSPARENT_HUGEPAGE_FLAG,
 	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
@@ -352,12 +351,6 @@ static inline bool vma_thp_disabled(struct vm_area_struct *vma,
 	return mm_flags_test(MMF_DISABLE_THP_EXCEPT_ADVISED, vma->vm_mm);
 }
 
-static inline bool thp_disabled_by_hw(void)
-{
-	/* If the hardware/firmware marked hugepage support disabled. */
-	return transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED);
-}
-
 unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4da10e94bbb6..32254febe097 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -133,7 +133,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -969,10 +969,8 @@ static int __init hugepage_init(void)
 	int err;
 	struct kobject *hugepage_kobj;
 
-	if (!arch_has_pmd_leaves()) {
-		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED;
+	if (!pgtable_has_pmd_leaves())
 		return -EINVAL;
-	}
 
 	/*
 	 * hugepages can't be allocated by the buddy allocator
diff --git a/mm/memory.c b/mm/memory.c
index 953d8d1ea268..707a9867c034 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5538,7 +5538,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	 * PMD mappings if THPs are disabled. As we already have a THP,
 	 * behave as if we are forcing a collapse.
 	 */
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags,
+	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vma->vm_flags,
 						     /* forced_collapse=*/ true))
 		return ret;
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 108dc969b92a..079e299ea789 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1846,7 +1846,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
 	unsigned int global_orders;
 
-	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
+	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
 		return 0;
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
-- 
2.54.0


