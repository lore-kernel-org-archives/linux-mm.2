Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27EBF10F9972
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 20:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C1006B008A; Wed,  8 Apr 2026 16:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898CD6B008C; Wed,  8 Apr 2026 16:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D61F6B0092; Wed,  8 Apr 2026 16:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E1D86B008A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:26:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3CE0AB7460
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:26:16 +0000 (UTC)
X-FDA: 84636520752.23.01E2F40
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2720A1C0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:26:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="V/UlaWmB";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775679974; a=rsa-sha256;
	cv=none;
	b=WJ3yTXqULHFbfVmX2C+4fO8FOXGajKwxLIZAeW89bWH0g2XzsFomV/irgaALOcCb6sLjqd
	Upv6INqxTwxdwT2mc8LEFzAB3d8kC0gV141hjFOsKVfgSGtDCH496IS5YiBpb7+AcsRi5u
	71cir19r973Pq0XeC/UMbEq6iWgLSoI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="V/UlaWmB";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775679974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5DLMjRaVolqsbGTCRhcQShr1myO/MYUO5PjIwdLZWU=;
	b=UgFJpi0MDQJlue/sPJeYNj/nW9E+NwO0H16/wjOY73G+MP5nixSSYgb54sjd1N1JTdl6Dg
	VCVV+3ZVAyv1luP0udC1pfYYeWWREQ2KbPav6nAAOacIZ1neiwJcb6IPMWup5tBMG+Lm9l
	QwZObcYf8wM99MjBqxJQb0V4igHIDHs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775679973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q5DLMjRaVolqsbGTCRhcQShr1myO/MYUO5PjIwdLZWU=;
	b=V/UlaWmB9V6PDAigqkMmblX6FCpHZMpqQ8bBvR2KhBJT8F6ZQJ3NS5AaV9D5Z2I02Y1GN6
	O2zUINg6abInloD4uvd3t81TaIyxhOVS6bxGZg95mi/hND9lLF1FqmRkCV1OR58n2Jme12
	GfiC7HvJYcswZPdEajFg5srPhYzPQG8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-393-9S6wRMOHNjqFBwrQOGi0LQ-1; Wed,
 08 Apr 2026 16:23:28 -0400
X-MC-Unique: 9S6wRMOHNjqFBwrQOGi0LQ-1
X-Mimecast-MFC-AGG-ID: 9S6wRMOHNjqFBwrQOGi0LQ_1775679807
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 17F7F18005B6;
	Wed,  8 Apr 2026 20:23:27 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.88.140])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EE09C180075B;
	Wed,  8 Apr 2026 20:23:25 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v3 08/10] mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
Date: Wed,  8 Apr 2026 16:23:03 -0400
Message-ID: <9432a2398caef7261ca44355fb7b786bb20bc15e.1775679721.git.luizcap@redhat.com>
In-Reply-To: <cover.1775679721.git.luizcap@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 65TzKn_ZTKe14BPO1RIkXYqpIR1LJiW0qHC9kTxYgPw_1775679807
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: suansuaihj3y59uucjqdo4cpayt9qp97
X-Rspamd-Queue-Id: 2720A1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775679973-863887
X-HE-Meta: U2FsdGVkX1+9SyVqv+nrUTebqmkrQmEOmLLO84QQko9+yzwSK6hvelD4CGbBB+bzwkjLLfjM7qNn/BJxwZL56San2v0hvevMlRnjXTy6qHHfi1vNqYshlk/2Lgr/9svTk03yWL/+uq8bRbjN0xmTmgkrY5FRB9epmXnDu3NlnaprbdL0CUQEbluNqzg8eh4PLBmV0Pj2lOtnyuLP20iDjoISV9x1WfT4iPEFyfmxmWJJmP/B/wrScjk2nuij3n1FjKbbJg07qCITqAlTxuURToX5ifFUXY97qyLBRJZ08HMjaNusUoyidOI/Ug5V3wA/U2PwXEwC19I53mRIwyrdhDWVDIx0tuBXs2kMNfCdLcU8/a249rEbA0+z7Z361Wrrt4XWAbKSdd/8HnR2RhM25zZFDPst7NVNH1h4b7lU7cL16pwZUXRpH82HVP1XoSWhooBVPVlOZfYH/OZAXHKnuyTapelHmhxx3pUcWoJ/Mb3z0DkD3QJyer6R/ce9W+L7UwtSjJ0jO8IYDcINFWOX/XzQsAqoA3YWjAxSEhE7fixe06Sqp/8lPi+Ibm6zla40QfCpTPiCvDoGQjt3E7lBQqW2uL8G59Dv4GJCEwRIgen4j06S4cCMqfmO/BVPJr9NVcE3B79GffN9/UK+Ct1ll1TszGti3z1UGYFtWdU3hN4VNXfiWwBMdVAUL6WG7S9R9afdZmePI8lTGTMqTqxayJE0YCMZY/gPHGo0lPsuBalSvkqXFYOLnVcZQskIQzeTDkN6sYiYH6ymIc8tykFpROqXAvu9zSpEhe0/pvsJzYB5DO7iwY5s5Zzt2QKPnQhtWQTw1LlZ7kNkNGzarhQtF7fUMq/tFcT2CqzpIdaoKXumAO/x5odxCSm83CGJqAm9LEXka1q5zB8kiblIQvZN2S17mFc2aTuGoQhTFZYCtj9mrtcZ+d/VTWorC4mGftRLpuLUnEtn9i2ZyyMwg8z
 Z2pi7GV+
 uhVxkWa0e+w4HXBs9P+kFhOv8VuQUUuOsbKJ4HQSN6FLS4hj5B/BFpJWZN9j5buJwKHIz+U9/Pc3CZIl9ZxWIZo90xs3RDKzTtTkYMcaR7g5wDmpwZPP9vHtgqqqjwcqWTwq9FFCMhKecjc/F8hBcve9dXQJ6MMBFrK8QW7qAFZxv2Mw9sutlYjAAfJYNACOJU2iO8m2TiAB28lPtEHDG7o8LRbfXAF9vT6rAYxhnZo7rGGrSUScErTfsRrW+CEPaQYKwhUSH36TooLTBRpJpVA+OTvhmj1sMhYHg0OstOg2vhYI5vgCFE5KZ6UwiYH9E5VjvXAt8LAHa6HaK0LAO3MXI60E3spW7vY+R4m91q6hztU0kEH8VMIGSr733N2t3EIjk
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

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 include/linux/huge_mm.h | 7 -------
 mm/huge_memory.c        | 6 ++----
 mm/memory.c             | 2 +-
 mm/shmem.c              | 2 +-
 4 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a4d9f964dfde..e291a650b10f 100644
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
index 9e4889d1673f..86e489c0a150 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -125,7 +125,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -908,10 +908,8 @@ static int __init hugepage_init(void)
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
index 87a65f6eabfb..29cb4ea33ba0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5427,7 +5427,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	 * PMD mappings if THPs are disabled. As we already have a THP,
 	 * behave as if we are forcing a collapse.
 	 */
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags,
+	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vma->vm_flags,
 						     /* forced_collapse=*/ true))
 		return ret;
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 6f8b20d77e07..613393eae5a9 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1839,7 +1839,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
 	unsigned int global_orders;
 
-	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
+	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
 		return 0;
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
-- 
2.53.0


