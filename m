Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79835CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 21:29:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDF0F8E000E; Thu,  6 Nov 2025 16:29:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D688C8E0002; Thu,  6 Nov 2025 16:29:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C571A8E000E; Thu,  6 Nov 2025 16:29:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B36858E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:29:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85229B7125
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:34 +0000 (UTC)
X-FDA: 84081473868.21.A951E20
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id C3B3B140005
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qo4CuCBu;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762464572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShSdFYzhV0Y6APXZPKs3ZiZ210ybMNWShqtHNQeC/jQ=;
	b=w7XciMJp0LTRyUcP5SS/DT0DCsLohdBbvnaNGhcua/eoXvyW+zq8RuLrCBIZmFfnII+jmh
	ozWjPHrtfkA3ZC2e2pKVjEeIZe+kMMwh1bzogJxw/9sKVKWyFh+8YOFOP4Ap1rHRjpQMwY
	KXQxH0L4qhakZItmPBumG1zN/OdPFfM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qo4CuCBu;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762464572; a=rsa-sha256;
	cv=none;
	b=s3rtNAMwbA2ObitH9MxNZPRNykeq116wV3BRMT33g3i0YwOM6i+gLE3ntSXLGhlsfvaOtQ
	H+WWVVkVRVv3YTsUTZA+MRwbSgTiNV46mhQb7JomIEZgaWRUbRzjVH+7ykFGvuqZKBNoO1
	GKZlMHhGkggHqUGJ1W4i1l3V6Bs/tTI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762464572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ShSdFYzhV0Y6APXZPKs3ZiZ210ybMNWShqtHNQeC/jQ=;
	b=Qo4CuCBuV2KjEpxYB7SKVwH31f4KaOcF/vVSncbnNluQIvwTp6/wgNgVz/DIuC594XIaTA
	HrjyTVxWpZ+yU8usBOf5NQ9e+cX5jZTuvvHyJ8fsNnYvYjOL9IakgB3PYxUCYb702hlrMV
	0elxKjVfyZSvWZ5G9zfBkPUUwgRhv1M=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-312-iG6epfEWMK268t0-mdSp6A-1; Thu,
 06 Nov 2025 16:29:27 -0500
X-MC-Unique: iG6epfEWMK268t0-mdSp6A-1
X-Mimecast-MFC-AGG-ID: iG6epfEWMK268t0-mdSp6A_1762464565
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB79B1800473;
	Thu,  6 Nov 2025 21:29:25 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.101])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D47B419560A7;
	Thu,  6 Nov 2025 21:29:24 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [RFC 08/10] mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
Date: Thu,  6 Nov 2025 16:28:55 -0500
Message-ID: <83ee5e3b09ae9c0496790d70c5e47f71fd03e868.1762464515.git.luizcap@redhat.com>
In-Reply-To: <cover.1762464515.git.luizcap@redhat.com>
References: <cover.1762464515.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: C3B3B140005
X-Stat-Signature: f8hjmrjnqtgh1p3ser7o931yei56ikhg
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762464572-958089
X-HE-Meta: U2FsdGVkX1/ohpBtvZK0leF9CHqWXNU1yJZI1AA/zb7hInrlgVLw+pseoJcngYYFm9qTjimcP2SvJJxs/WZIw86Vaj0yh8eSaNJdEAAtYoNW2pZ0R+DIvVB+kwLModXc9Ptv0Du3znfYUy/WwaK0cV9IVp5ngbjmu+3p2/AJLkyKWl+zb7Oe6i2NKh1b4lkdg3pzT0HkGzYAGP40btM8JONk8wLuy+ejMzWVAPCYdKtHfFSzey8NJ6KcvYjSXL9JsUjC+Q/xJhbzBI9pcrN/FIl4k4szNdqIesi+Rh5u2/XHI2k7ydSZkSFU4hko4Yo9hi8pbUsZ3kTlrKnB/LWvSEhmXU0Zr1npa1Bl9I7dSyFQPV/J5m8TaSN/57ou8Mw82F+/pKetVNcpPM+iRIOZESWKpTkIlr8GFiQBOUSv41moh3r1GiQ4f/af9+MWVx/2gqmUlTLs7cj1plZ7dXb520Pi9faVkyIId7uitBrxP/P4+PKe6gTZluOHcDbLUMqKw8ZQDnjQ38pLosMJChW/bJYXVlowU6vMmg48IpuIY3qo+ekfKxdQXCNKxN5d71tZhKXhEjIbOY3Ty1uwa3GH/QKP2KKpBK50gk6Aqmg2dB1knzMkftGx9sEA7WUSxMCV9h6Vr2acwIHCXIh3FF0//zSlAaBqOp5hbEr0e/ptXaprf7r2eO/uD0qpFQ3pWq4tg1OGdnnYKnAYcHFuczPS5bbvcz+PkEryFW5YV9heR1lVBGDTHfM/Cf2rwCUeq3pbLcEV0E1WpxCe1JZK/OPZ55r1eBkyjJlh1C/1x72Ssud4kVdtPu/VO2xRzuxCXlU7SQX/ui6ZzRV7soi0Zyu9VWTLy9u79YngcbKasv9yOFhsCbsEvjctj0OfVL4vByUu86Gi6QLuK5tXfMvaCdC8jDP9nGCa40s0Q2xdqk6WaUFuts723urUhByZrdCHUptbpyeeQK77FLdOT3SMFDP
 gV9C52n2
 Hc5uBJ4qYmBvInpXRXoZU03tvhDPQ3CRukyhal9RYybfcRbgQOa9zhNYvFWAYgqWsJLRA4JA8rq6i5aAiESaP1HCejBlegHc3IaKB83LM2YGVzJl5An/Y722A1Q6pwqj14bLVFnQqNQVqxwmOukbShYCWz4PAnKR22/Sk5s4liNs5ewsGQap5Dvo7xsGoZWRr6GW9wD88HG7SKWCpoXv5yKDvdc6VRknNykKmCWx3FLLLTf7SWL84xSpKSFUT9MGy3TxcCgUrUIXxZFeErQQvdHeLVzjfMdefsw22yTFY4tmRxzZ6erMQtJjjsDYQZTwhNBYOVW6eROdQM97KZ0fnqDRw1cQwT5u4paUC/jh8KQddj0U+bLlN0lAISA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Despite its name, thp_disabled_by_hw() only checks whether the
architecture supports PMD-sized pages. It returns true when
TRANSPARENT_HUGEPAGE_UNSUPPORTED is set, which occurs if the
architecture implements arch_has_pmd_leaves() and that function
returns false.

Since pgtable_has_pmd_leaves() provide the same semantics, use it
instead.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 include/linux/huge_mm.h | 7 -------
 mm/huge_memory.c        | 6 ++----
 mm/memory.c             | 2 +-
 mm/shmem.c              | 2 +-
 4 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index f327d62fc985..63d75a2897dd 100644
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
index 9bfa11aa2cbc..0f016ea7082d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -122,7 +122,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -904,10 +904,8 @@ static int __init hugepage_init(void)
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
index 6702c9187114..68d10a63276d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5345,7 +5345,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	 * PMD mappings if THPs are disabled. As we already have a THP,
 	 * behave as if we are forcing a collapse.
 	 */
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags,
+	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vma->vm_flags,
 						     /* forced_collapse=*/ true))
 		return ret;
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 48312b7727a7..406617a1fab8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1780,7 +1780,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
 	unsigned int global_orders;
 
-	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
+	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
 		return 0;
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
-- 
2.51.1


