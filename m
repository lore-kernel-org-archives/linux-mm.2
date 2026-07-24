Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD368C531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 01:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BA8E6B00AC; Thu, 23 Jul 2026 21:35:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86B0E6B00AE; Thu, 23 Jul 2026 21:35:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70C5D6B00AF; Thu, 23 Jul 2026 21:35:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 322486B00AC
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:35:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2ED6A0254
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:41 +0000 (UTC)
X-FDA: 85021953282.24.D2471B3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id C902D20005
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g9Hog1K4;
	spf=pass (imf13.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784856939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sgmo3dkmrTaTr7yC380bEBxgt/VymQg2/lczzNEznUk=;
	b=fcNM1IS9U2pcSYpxCpaXPrvvk/E2WEmTufPn08gw9woTT3bn769jRCm5KWzAAlmQP5pz0E
	cp/ZbVxuKrEkIQaUclf4buRbdBl1EbvYjGM9qDqkYE5ooeTRAhQMvyvZOJ3KyCu5/o+kV9
	sQ0M0MM7juWBRTwK+NhoHNRjM5N6Eso=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784856939;
	b=lSp83iH0YEmIigA62A7rz0Yf153RC5f/Z3+cFaCyjshP43BGoevPvg20xScsgPTh2a/nVa
	uiWuvC9FBiozeDSz7akRkf3oWbiFEZ8rkLyAGPIcUSqaAuYvMjQjjEZrX+uB9WV79u4T5V
	cMnEC6uhcpEAl4kofEtLG4tzGTBUzHw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g9Hog1K4;
	spf=pass (imf13.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784856939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sgmo3dkmrTaTr7yC380bEBxgt/VymQg2/lczzNEznUk=;
	b=g9Hog1K4vuSYkdInpz9JTlDxQU4QOAwRYiWbL8WFSxOZnMfLWD6AvPFkceuUP1VYHbj6O6
	3be/b/Aj8OMkfsHi6ckCJCpkWHpcmBRj6PcEBnaVWlurm3FFy/l71tOclbpG+0F9YvwZ7A
	InYEPQQ31f0XTv/+TGIt9ZHtBR4ZynA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-67-FbnTqJmhPTm4qCYxQYmUMA-1; Thu,
 23 Jul 2026 21:35:33 -0400
X-MC-Unique: FbnTqJmhPTm4qCYxQYmUMA-1
X-Mimecast-MFC-AGG-ID: FbnTqJmhPTm4qCYxQYmUMA_1784856930
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 33C89183031E;
	Fri, 24 Jul 2026 01:35:30 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.238])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AF4BB180059A;
	Fri, 24 Jul 2026 01:35:26 +0000 (UTC)
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
Subject: [PATCH v6 13/14] mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
Date: Thu, 23 Jul 2026 21:34:17 -0400
Message-ID: <45fa16fa399243b20c90196a7d9ba217cc29d399.1784856856.git.luizcap@redhat.com>
In-Reply-To: <cover.1784856856.git.luizcap@redhat.com>
References: <cover.1784856856.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: jxf8jvmhB4Ea9bugoFNK6V4ums-rOYDFBOgmI9HCGpU_1784856930
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: sahyqugq4kwdpzyr1dn4ichrqsgobpzc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C902D20005
X-HE-Tag: 1784856939-345932
X-HE-Meta: U2FsdGVkX1+X1SpKh3Nz+OC0okehLQ7X1KUXyDawTl+k31S+1rcKevJChxqwOFPpXMVTmzdCtf6Mhnm3ds5T80RimCPuU7683xvllRwpLSFIBXdxnayuzaR2fCto3RjJyHZocINeNMDwRuMToNWp3a2RSeBvk0iHN91pVxfhShQD0yhlkFqGVonWD3RN5MlGVtxl2hj8l1a7melHxffVJzYMewNLxkraa0s0z7ScyflCIhF5MIFCpcnew4PP+jOEGSeeQNPSpuLRwIktE7gFl6UfcNHsz9nn9OIReqne4j2TK7eeOOdvjOwZX9pGkSC1uUf1fGH1Q1zh11+F92FY76JkzIB3rc2FI8i6y9HQMccTYBwt9ci7AqeJ/FhBj+z7dIcyImV4q7+sutQzQVBJv8LOcNuhUZ7f8KCUr/dRORDGXgNduWofwQTXxf1cgVRbk+vWAYb1WQREaQTLtqwm3okrv8yAud7rQJA7n/NkQFuy4UBi2Wi/RZssEREZt6RnchtbF0muy2EN5eFSs/c+LG/1yMQGAmw9s6Kh+uEhvaW2YgAk84D9fodiLYLRUpjgjl14ylaxZ5aPTkg15qVxkuLmkY8uUCn4QmE2sdbGvOS6DQatTd/9ui/I7JSbdpV9Eeb6eK/TR56TEUNIvMzbPngbsLeGsNtHirrCgTT42EqMDZkdo1YhqLqJfK+PxEhRtPTSiRv5xH1vBhLH4MvzypIk8LuJ/obCn8PKOyULYzHb/uJ4zZ1wcx9niUqFQaqXm13mwc2oEk34pcNmNvkqIAgL9Kqnft4yFWyaOHrCq6WXfys49qsSU3R7J+//nFFn/o0ngJ7cxYhUXoNcIdYTkoUZm2Bmds+eU10qpRtlDflhrj6Q1DDC3UeZF5DUfBveeB4/R+mhAvx6GVuJGcd5jgrd1GEnj0bsV/VicB4Md8GpZ/nBF7WYJQnXYmF5fm0LHjTe8Hvs2Qgt0RKVVhE
 E93WkDlV
 AGiy3LyZ1i8Hz4jG3Zz2MkOHArd/YeelLKZobywyUF+tXMqxX3Wxmr+3JE0XHBzdFgkOFaYFwU7jWz0/5O+Zbkd8aDWmbelCLuHo22sZI2VrITd6/DmmcacuQImYlBTSAqTWCwghZo4zksh7X61B0M1UPkGdf8DRMIrGdDmm47LF07hFdD72Z11EIlgI5/tlmyzf87laFMYP0ULtp65I76EImQsyWOUv56HNfnUyJqS9Sn9I9DSYOB0Xd3VFXXREfkUm+gLOHiTndBLLT/JspIPDALRafbtlMHoAMsA2igmb+1b10wPkcbcI33sxOXXeADewgF6Fq+8OM2DvM7Sv1vL+DP2DWKBJJjU2V1a8vp9zZenrjlxa4xFMvc6BNRRd4mF+ZbBtlxvCL2JYTlCiLvsXaV5B3DpAghtF2+AiB0FSxSMieiMZWny9b0eYTddZmA3oi1RWU8JskXdbErp0NBP0Dug==
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
index c745f7ad2298..525acea2eb59 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -47,7 +47,6 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 				bool write);
 
 enum transparent_hugepage_flag {
-	TRANSPARENT_HUGEPAGE_UNSUPPORTED,
 	TRANSPARENT_HUGEPAGE_FLAG,
 	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
@@ -383,12 +382,6 @@ static inline bool vma_thp_disabled(struct vm_area_struct *vma,
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
 unsigned long thp_get_unmapped_area_vmaflags(struct file *filp, unsigned long addr,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3f3a929e3069..78dd16513a11 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -136,7 +136,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -1010,10 +1010,8 @@ static int __init hugepage_init(void)
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
index b0d3a8a8a25d..f39d9383494e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5576,7 +5576,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	 * PMD mappings if THPs are disabled. As we already have a THP,
 	 * behave as if we are forcing a collapse.
 	 */
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags,
+	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vma->vm_flags,
 						     /* forced_collapse=*/ true))
 		return ret;
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 68ae606b5c4c..4d2e1b91ec26 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1832,7 +1832,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
 	unsigned int global_orders;
 
-	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
+	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
 		return 0;
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
-- 
2.55.0


